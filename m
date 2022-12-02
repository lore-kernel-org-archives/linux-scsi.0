Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48462C4321E
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 16:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiLBQ0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 11:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiLBQ0k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 11:26:40 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C362CF
        for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2022 08:26:39 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id fy37so12685722ejc.11
        for <linux-scsi@vger.kernel.org>; Fri, 02 Dec 2022 08:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Yg+r8QLgatbF46MHNyqGZrqOQYwsy3SXZiToj8O4QKI=;
        b=HHp/EsC8+ss76qCLu8Pyzh3ly59BRjpOOf8xRIvW7KrKMRwnF8Of7vwzMPTOnsAPR6
         Mfqobt5v4gchZjZ4VOHIxYR6tFdH/M8aG7V46AtHrLNCJ1CXYILhXqU6HjmFHGdAiDpb
         W24hDhWc9ORu/ZjS1FEzh+IYoIDLBP59WTljiEUvDGP7Q19rZaYc9WI4v+jEtvSkuP7o
         Y3oxQBUvJ8jOvfesDjvzUvsa3iHcHMV40mzZB31TRh/oxmKOHbV4SrP8MBF3GQ6yECbq
         27un/4wQS0+lqZNWva8uCTUmPyBquYHZkhh1mzT8YYRlGd2kN5BYpvlTE0bo1+REhqo8
         cVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yg+r8QLgatbF46MHNyqGZrqOQYwsy3SXZiToj8O4QKI=;
        b=l0k3E6TSgKbKwMzQHonCoSvRN1EZYDfTJdnTrFENGlhlgZtn0jCX1i3gqpQCibaubY
         NZc0N0fRGCBSxypVM2fMm9FmJjCu4Rtubh9Lp9IF3xjHru8nnov/d/G+LlmjQ4l/ElqQ
         0aI89GkCzY3BApL1M/eyB99ZArp1WAuTZFVQe4t2lLED05+86t97Vt3pq9VKeMlRfrY5
         PZpZ8MGB3tHfG9960a2WHdYq79Ac8WismhTu9w+9simQKq67UNCjTz02HIKPeZ7iFlEP
         Cl1Y+vJ9PK9NITckFHzR+SwpHprvi4UOwyk2dFYtw3s6kCQI4UvA5nzc0t5H7eKBPxB6
         hPHQ==
X-Gm-Message-State: ANoB5pnZaRj7hsLIktsvCNyfvlrIILaFyP07jci3ay2hwibsoHE7CiHf
        8VzRAsy1dxRLgLfZz0wIPXYuuRoECNvuMN10X58=
X-Google-Smtp-Source: AA0mqf4oFR1pNr1J0ApmZolrUbq6+F38sdvCp0GsPLg61gfIJap0vKabgtbTKeGPypM2wtXDT3/iYSNUkQj+KdN5yME=
X-Received: by 2002:a17:907:2a82:b0:7ab:9952:9452 with SMTP id
 fl2-20020a1709072a8200b007ab99529452mr63568416ejc.142.1669998397622; Fri, 02
 Dec 2022 08:26:37 -0800 (PST)
MIME-Version: 1.0
References: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
 <ca7e2aba5db5bd6e15182070f26e0c2c77c70927.camel@linux.ibm.com>
 <ada12c1d-b732-59a9-8dba-1662673b6a5d@huawei.com> <70f4d744d64bc075138128a7a98b7186375170d8.camel@linux.ibm.com>
 <CAOptpSPfswNrmYe4rnKFM3zWXY7P0JuWY94p=mfp7tV9ghFQ2w@mail.gmail.com>
 <f2e3c4dc0bfad6b05f40d716738e56f2cbb80810.camel@linux.ibm.com>
 <7fb4c882-c332-551c-8980-9b07ae9519dd@huawei.com> <d9d1f5da091895e2cb3fd17e5c49f2c25687f72b.camel@linux.ibm.com>
In-Reply-To: <d9d1f5da091895e2cb3fd17e5c49f2c25687f72b.camel@linux.ibm.com>
From:   Wenchao Hao <haowenchao22@gmail.com>
Date:   Sat, 3 Dec 2022 00:26:25 +0800
Message-ID: <CAOptpSNyOBe2Nn0Gk69T7DZWyO4QXx73GOsPWjemPdhjXP2mBw@mail.gmail.com>
Subject: Re: [QUESTION]: Why did we clear the lowest bit of SCSI command's
 status in scsi_status_is_good
To:     jejb@linux.ibm.com
Cc:     Wenchao Hao <haowenchao@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linfeilong@huawei.com,
        yanaijie@huawei.com, xuhujie@huawei.com, lijinlin3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 2, 2022 at 10:17 PM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Fri, 2022-12-02 at 21:58 +0800, Wenchao Hao wrote:
> >
> > On 2022/11/29 2:12, James Bottomley wrote:
> > > On Tue, 2022-11-29 at 01:38 +0800, Wenchao Hao wrote:
> > > > On Mon, Nov 28, 2022 at 11:24 PM James Bottomley
> > > > <jejb@linux.ibm.com>
> > > > wrote:
> > > > >
> > > > > On Mon, 2022-11-28 at 22:41 +0800, Wenchao Hao wrote:
> > > > > > On 2022/11/28 20:52, James Bottomley wrote:
> > > > > > > On Mon, 2022-11-28 at 11:58 +0800, Wenchao Hao wrote:
> > > > > [...]
> > > > > > > > We found some firmware or drivers would return status
> > > > > > > > which
> > > > > > > > did not defined in SAM. Now SCSI middle level do not have
> > > > > > > > an
> > > > > > > > uniform behavior for these undefined status. I want to
> > > > > > > > change
> > > > > > > > the logic to return error for all status which did not
> > > > > > > > defined in SAM or define a method in host template to let
> > > > > > > > drivers to judge what to do in this condition.
> > > > > > >
> > > > > > > Why? The general rule of thumb is be strict in what you
> > > > > > > emit
> > > > > > > and generous in what you receive (which is why reserved
> > > > > > > bits
> > > > > > > are ignored). Is the drive you refer to above not working
> > > > > > > in
> > > > > > > some way, in which case detail it so people can understand
> > > > > > > the
> > > > > > > actual problem.
> > > > > > >
> > > > > > > James
> > > > > > >
> > > > > > > .
> > > > > >
> > > > > >
> > > > > > We come with an issue with megaraid_sas driver. Where
> > > > > > scsi_cmnd
> > > > > > is completed with result's status byte set to 1,
> > > > >
> > > > > Megaraid_sas is an emulation driver for the most part, so it
> > > > > sounds
> > > > > like this is in the RAID emulation firmware, correct?  The
> > > > > driver
> > > > > can correct for emulation failures, if you can figure out what
> > > > > it's
> > > > > trying to signal and convert it to the correct SAM error code.
> > > > > There's no need to change anything in the layers above.  If you
> > > > > can't figure out the translation and you want the transfer to
> > > > > error, then add DID_ERROR, which is a nice catch all.  If this
> > > > > is
> > > > > transient and could be fixed by a retry, then do DID_SOFT_ERROR
> > > > > instead.
> > > > >
> > > > > James
> > > > >
> > > >
> > > > Thanks for your answer, Of curse we can recognize these undefined
> > > > status and map to an error which can be handled by SCSI middle
> > > > level
> > > > now. But I still confused why shouldn't we change the
> > > > scsi_status_is_good() to respect to SAM?
> > >
> > > Because it wouldn't be backwards compatible and something might
> > > break.
> > > Under SCSI-1, devices were allowed to set this bit to signal vendor
> > > unique status and a lot of manufacturers continued doing this for
> > > SCSI-
> > > 2, even though it was flagged as reserved instead of vendor
> > > specific in
> > > that standard, hence the mask.  Since this was over 20 years ago,
> > > it is
> > > possible there is no remaining functional device that does this,
> > > but if
> > > it's not causing a problem, why take the risk?
> > >
> > > James
> > >
> > > .
> >
> > Hi James, thank you very much for your answer.
> >
> > I think we should think about the following functions of megaraid
> > driver:
> >
> > megasas_complete_cmd() defined in
> > drivers/scsi/megaraid/megaraid_sas_base.c,
> > megasas_complete_cmd
> >         ...
> >         switch (hdr->cmd) {
> >         ...
> >         case MFI_CMD_LD_READ:
> >         case MFI_CMD_LD_WRITE:
> >                 switch (hdr->cmd_status) {
> >                 case MFI_STAT_SCSI_DONE_WITH_ERROR:
> >                         cmd->scmd->result = (DID_OK << 16) | hdr-
> > >scsi_status;
> >                         break;
> >                 ...
> >                 }
> >         ...
> >         }
> >
> > map_cmd_status() defined in
> > drivers/scsi/megaraid/megaraid_sas_fusion.c
> > map_cmd_status
> >         ...
> >         switch (status) {
> >         ...
> >         case MFI_STAT_SCSI_DONE_WITH_ERROR:
> >                 scmd->result = (DID_OK << 16) | ext_status;
> >                 break;
> >         ...
> >         }
> >
> > Both of these functions did not check the status byte, which can not
> > make sure the status byte is defined in SAM.
>
> Right, but the first one should be returning actual status from the
> drive, so should be OK.  The second one looks to be returning
> manufactured raid status, which is likely the problem.
>
> in either case, just fix the code to return DID_ERROR<<16 if the status
> is non SAM conforming.
>
> > What we meet is the status byte set to 1, and the host_byte is set to
> > DID_OK.
> >
> > In this condition, the scsi_cmnd would be finished by scsi middle
> > layer with BLK_STS_OK if the kernel version is before 3d45cefc8edd7
> > (scsi: core: Drop obsolete Linux-specific SCSI status codes).
>
> I don't believe it does: that commit should produce identical code
> before and after; it merely replaced the shifted status conditions with
> the unshifted ones.
>
Here is how the commit affect the flow:

When the command finished with status set to 1, and the actual
finished byte is less than requested.

Before this commit, scsi_io_completion_nz_result would check
result like following:
if (status_byte(result) && scsi_status_is_good(result)) {
        result = 0;
        *blk_statp = BLK_STS_OK;
}
If the lowest byte of result is 1, the status_byte() returned false,
the result would not be updated. So scsi_io_completion_nz_result()
returned a non zero value. We would call scsi_io_completion_action()
to handle this command after scsi_end_request() failed.

In scsi_io_completion_action(), the command should be finished
with BLK_STS_IOERR, while it is finished with BLK_STS_OK.

After this commit, scsi_io_completion_nz_result would check
result like following:
if (result & 0xff && scsi_status_is_good(result)) {
        result = 0;
        *blk_statp = BLK_STS_OK;
}
Where result && 0xff is 1, the result would be 0, and
scsi_io_completion_nz_result() returned 0. We would call
scsi_mq_requeue_cmd() to requeue this command after
scsi_end_request() failed.
