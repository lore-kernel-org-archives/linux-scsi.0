Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AABC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 15:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3130620838
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 15:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgG3PKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 11:10:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:60279 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727966AbgG3PKb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 11:10:31 -0400
Received: (qmail 6777 invoked by uid 1000); 30 Jul 2020 11:10:30 -0400
Date:   Thu, 30 Jul 2020 11:10:30 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200730151030.GB6332@rowland.harvard.edu>
References: <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
 <20200729143213.GC1530967@rowland.harvard.edu>
 <1596033995.4356.15.camel@linux.ibm.com>
 <1596034432.4356.19.camel@HansenPartnership.com>
 <d9bb92e9-23fa-306f-c7f2-71a81ab28811@puri.sm>
 <1596037482.4356.37.camel@HansenPartnership.com>
 <A1653792-B7E5-46A9-835B-7FA85FCD0378@puri.sm>
 <20200729182515.GB1580638@rowland.harvard.edu>
 <1596047349.4356.84.camel@HansenPartnership.com>
 <d3fe36a9-b785-a5c4-c90d-b8fa10f4272f@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3fe36a9-b785-a5c4-c90d-b8fa10f4272f@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 30, 2020 at 10:52:14AM +0200, Martin Kepplinger wrote:
> Maybe I should just start a new discussion with a patch, but the below
> is what makes sense to me (when I understand you correctly) and seems to
> work. I basically add a new flag, so that the old flags behave unchanged
> and only call it during *runtime* resume for SD cards:
> 
> 
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -553,15 +553,21 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>                  * information that we should pass up to the upper-level
> driver
>                  * so that we can deal with it there.
>                  */
> -               if (scmd->device->expecting_cc_ua) {
> +               if (scmd->device->expecting_cc_ua ||
> +                   scmd->device->expecting_media_change) {
>                         /*
>                          * Because some device does not queue unit
>                          * attentions correctly, we carefully check
>                          * additional sense code and qualifier so as
> -                        * not to squash media change unit attention.
> +                        * not to squash media change unit attention;
> +                        * unless expecting_media_change is set, indicating
> +                        * that the media (most likely) didn't change
> +                        * but a device only believes so (for example
> +                        * because of suspend/resume).
>                          */
> -                       if (sshdr.asc != 0x28 || sshdr.ascq != 0x00) {
> -                               scmd->device->expecting_cc_ua = 0;
> +                       if ((sshdr.asc != 0x28 || sshdr.ascq != 0x00) ||
> +                           scmd->device->expecting_media_change) {
> +                               scmd->device->expecting_media_change = 0;
>                                 return NEEDS_RETRY;
>                         }
>                 }
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d90fefffe31b..b647fab2b663 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -114,6 +114,7 @@ static void sd_shutdown(struct device *);
>  static int sd_suspend_system(struct device *);
>  static int sd_suspend_runtime(struct device *);
>  static int sd_resume(struct device *);
> +static int sd_resume_runtime(struct device *);
>  static void sd_rescan(struct device *);
>  static blk_status_t sd_init_command(struct scsi_cmnd *SCpnt);
>  static void sd_uninit_command(struct scsi_cmnd *SCpnt);
> @@ -574,7 +575,7 @@ static const struct dev_pm_ops sd_pm_ops = {
>         .poweroff               = sd_suspend_system,
>         .restore                = sd_resume,
>         .runtime_suspend        = sd_suspend_runtime,
> -       .runtime_resume         = sd_resume,
> +       .runtime_resume         = sd_resume_runtime,
>  };
> 
>  static struct scsi_driver sd_template = {
> @@ -3652,6 +3653,21 @@ static int sd_resume(struct device *dev)
>         return ret;
>  }
> 
> +static int sd_resume_runtime(struct device *dev)
> +{
> +       struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +
> +       /* Some SD cardreaders report media change when resuming from
> suspend
> +        * because they can't keep track during suspend. */
> +
> +       /* XXX This is not unproblematic though: We won't notice when a card
> +        * was really changed during runtime suspend! We basically rely
> on users
> +        * to unmount or suspend before doing so. */
> +       sdkp->device->expecting_media_change = 1;
> +
> +       return sd_resume(dev);
> +}
> +
>  /**
>   *     init_sd - entry point for this driver (both when built in or when
>   *     a module).
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index bc5909033d13..8c8f053f71c8 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -169,6 +169,8 @@ struct scsi_device {
>                                  * this device */
>         unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
>                                      * because we did a bus reset. */
> +       unsigned expecting_media_change:1; /* Expecting media change
> ASC/ASCQ
> +                                             when it actually doesn't
> change */
>         unsigned use_10_for_rw:1; /* first try 10-byte read / write */
>         unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
>         unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */

That's pretty much what James was suggesting, except for one thing: You 
must not set sdkp->device->expecting_media_change to 1 for all devices 
in sd_runtime_resume().  Only for devices which may generate a spurious 
Unit Attention following runtime resume -- and maybe not even for all of 
them, depending on what the user wants.

Alan Stern
