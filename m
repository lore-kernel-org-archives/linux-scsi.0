Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D10C2BB1D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 06:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B90B206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 06:14:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="wDmJnJuz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405831AbgDNGOm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 02:14:42 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:53304 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405818AbgDNGOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 02:14:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586844881; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=rzOJ+bED0a6EYmTfUhJM8iFUhrBMPXOs94qxa4YgxsM=;
 b=wDmJnJuzHiJ/dSYctKVqwMZ0tGnfDI06gU14t7M3kPwZU5HJ9EBo6KvjW+FPDfm1G55filEk
 /IGyakGLb3SaBEo1EszBrpAcd7Of+hKRYpKFlCcZeMfXPlmPBXXXHeFQncfYoDpmrF31qUZw
 +Eh726UMG0clMxX1rOksKMxjaNo=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e9554c3.7f51e41080a0-smtp-out-n02;
 Tue, 14 Apr 2020 06:14:27 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7D691C43636; Tue, 14 Apr 2020 06:14:26 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9BCA5C433CB;
        Tue, 14 Apr 2020 06:14:25 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 14 Apr 2020 14:14:25 +0800
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] scsi: pm: Balance pm_only counter of request queue
 during system resume
In-Reply-To: <1586841875-15667-1-git-send-email-cang@codeaurora.org>
References: <1586841875-15667-1-git-send-email-cang@codeaurora.org>
Message-ID: <9603edb9d1ae2c81dfd0a14bce4c6ce8@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Loop more...

On 2020-04-14 13:24, Can Guo wrote:
> During system resume, scsi_resume_device() decreases a request queue's
> pm_only counter if the scsi device was quiesced before. But after that,
> if the scsi device's RPM status is RPM_SUSPENDED, the pm_only counter 
> is
> still held (non-zero). Current scsi resume hook only sets the RPM 
> status
> of the scsi device and its request queue to RPM_ACTIVE, but leaves the
> pm_only counter unchanged. This may make the request queue's pm_only
> counter remain non-zero after resume hook returns, hence those who are
> waiting on the mq_freeze_wq would never be woken up. Fix this by 
> calling
> blk_post_runtime_resume() if pm_only is non-zero to balance the pm_only
> counter which is held by the scsi device's RPM ops.
> 
> (struct request_queue)0xFFFFFF815B69E938
> 	pm_only = (counter = 2),
> 	rpm_status = 0,
> 	dev = 0xFFFFFF815B0511A0,
> 
> ((struct device)0xFFFFFF815B0511A0)).power
> 	is_suspended = FALSE,
> 	runtime_status = RPM_ACTIVE,
> 
> (struct scsi_device)0xffffff815b051000
> 	request_queue = 0xFFFFFF815B69E938,
> 	sdev_state = SDEV_RUNNING,
> 	quiesced_by = 0x0,
> 
> B::v.f_/task_0xFFFFFF810C246940
> -000|__switch_to(prev = 0xFFFFFF810C246940, next = 0xFFFFFF80A49357C0)
> -001|context_switch(inline)
> -001|__schedule(?)
> -002|schedule()
> -003|blk_queue_enter(q = 0xFFFFFF815B69E938, flags = 0)
> -004|generic_make_request(?)
> -005|submit_bio(bio = 0xFFFFFF80A8195B80)
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> 
> Change since v1:
> - Added more debugging context info
> 
> ---
>  drivers/scsi/scsi_pm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index 3717eea..4804029 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -93,8 +93,10 @@ static int scsi_dev_type_resume(struct device *dev,
>  		 */
>  		if (!err && scsi_is_sdev_device(dev)) {
>  			struct scsi_device *sdev = to_scsi_device(dev);
> -
> -			blk_set_runtime_active(sdev->request_queue);
> +			if (blk_queue_pm_only(sdev->request_queue))
> +				blk_post_runtime_resume(sdev->request_queue, 0);
> +			else
> +				blk_set_runtime_active(sdev->request_queue);
>  		}
>  	}
