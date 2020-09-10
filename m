Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D64C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 17:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9CF321D40
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 17:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgIJRvM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 13:51:12 -0400
Received: from smtp.infotech.no ([82.134.31.41]:44808 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgIJRoq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 13:44:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id BAF8520418E;
        Thu, 10 Sep 2020 19:43:55 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zy8WN2ZTR6yN; Thu, 10 Sep 2020 19:43:53 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 1D47A204153;
        Thu, 10 Sep 2020 19:43:51 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: clear UAC before sending SG_IO
To:     Randall Huang <huangrandall@google.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200910101513.2900079-1-huangrandall@google.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <6baf4adf-e97b-9584-1aae-d12235c362fe@interlog.com>
Date:   Thu, 10 Sep 2020 13:43:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200910101513.2900079-1-huangrandall@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-10 6:15 a.m., Randall Huang wrote:
> Make sure UAC is clear before sending SG_IO.
> 
> Signed-off-by: Randall Huang <huangrandall@google.com>

This patch just looks wrong. Imagine if every LLD front loaded some LLD
specific code before each invocation of ioctl(SG_IO). Is UAC Unit Attention
Condition? If so the mid-level notes them as they fly past.

Haven't looked at the rest of the patchset but I suspect the "wlun_clr_uac"
work needs a rethink. If that is the REPORT LUNS Well known LUN then perhaps
it could be handled in the mid-level scanning code. Otherwise it should
be handled in the LLD/UFS.

Also users of ioctl(SG_IO) should be capable of handling UAs, even if they
are irrelevant, and repeat the invocation. Finally ioctl(sg_dev, SG_IO) is
not the only way to send a pass-through command, there are also
   - write(sg_dev, ...)
   - ioctl(bsg_dev, SG_IO, ...)
   - ioctl(most_blk_devs, SG_IO, ...)
   - ioctl(st_dev, SG_IO, ...)

Hopefully I have convinced you by now not to take this route.

Doug Gilbert

> ---
>   drivers/scsi/sg.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 20472aaaf630..ad11bca47ae8 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -922,6 +922,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>   	int result, val, read_only;
>   	Sg_request *srp;
>   	unsigned long iflags;
> +	int _cmd;
>   
>   	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
>   				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
> @@ -933,6 +934,13 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>   			return -ENODEV;
>   		if (!scsi_block_when_processing_errors(sdp->device))
>   			return -ENXIO;
> +
> +		_cmd = SCSI_UFS_REQUEST_SENSE;
> +		if (sdp->device->host->wlun_clr_uac) {
> +			sdp->device->host->hostt->ioctl(sdp->device, _cmd, NULL);
> +			sdp->device->host->wlun_clr_uac = false;
> +		}
> +
>   		result = sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
>   				 1, read_only, 1, &srp);
>   		if (result < 0)
> 

