Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB40AC4332B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 15:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7760822AAD
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 15:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbhAKPb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 10:31:57 -0500
Received: from comms.puri.sm ([159.203.221.185]:57582 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbhAKPb5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 10:31:57 -0500
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id D21F4DFC6D;
        Mon, 11 Jan 2021 07:31:16 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XSc4KUmciF7T; Mon, 11 Jan 2021 07:31:15 -0800 (PST)
Subject: Re: [PATCH 3/3] scsi: sd: add support for expect_media_change_suspend
 flag
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        stern@rowland.harvard.edu, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210111152029.28426-1-martin.kepplinger@puri.sm>
 <20210111152029.28426-4-martin.kepplinger@puri.sm>
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
Message-ID: <b6bdd914-7c6d-032f-6412-9bd097f7c059@puri.sm>
Date:   Mon, 11 Jan 2021 16:31:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210111152029.28426-4-martin.kepplinger@puri.sm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11.01.21 16:20, Martin Kepplinger wrote:
> Make the sd driver act appropriately when the user has set
> expect_media_change_suspend for a device.
> 
> Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> ---
>   drivers/scsi/sd.c | 21 ++++++++++++++++++++-
>   1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a3d2d4bc4a3d..ad89f8c76a27 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -608,7 +608,7 @@ static const struct dev_pm_ops sd_pm_ops = {
>   	.poweroff		= sd_suspend_system,
>   	.restore		= sd_resume,
>   	.runtime_suspend	= sd_suspend_runtime,
> -	.runtime_resume		= sd_resume,
> +	.runtime_resume		= sd_resume_runtime,
>   };
>   
>   static struct scsi_driver sd_template = {
> @@ -3699,6 +3699,25 @@ static int sd_resume(struct device *dev)
>   	return ret;
>   }
>   
> +static int sd_resume_runtime(struct device *dev)
> +{
> +	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	int ret;
> +
> +	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
> +		return 0;
> +
> +	/*
> +	 * expect_media_change_suspend is the userspace setting and
> +	 * expecting_media_change is what is checked and cleared in the
> +	 * error path if we set it here.
> +	 */
> +	if (sdkp->device->expect_media_change_suspend)
> +		sdkp->device->expecting_media_change = 1;
> +
> +	return sd_resume(dev);
> +}
> +
>   /**
>    *	init_sd - entry point for this driver (both when built in or when
>    *	a module).
> 

oops, I'm very sorry, but the following is missing in order for this to 
build:

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -114,6 +114,7 @@ static void sd_shutdown(struct device *);
  static int sd_suspend_system(struct device *);
  static int sd_suspend_runtime(struct device *);
  static int sd_resume(struct device *);
+static int sd_resume_runtime(struct device *);
  static void sd_rescan(struct device *);
  static blk_status_t sd_init_command(struct scsi_cmnd *SCpnt);
  static void sd_uninit_command(struct scsi_cmnd *SCpnt);
