Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9024C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 11:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B3EA2077B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 11:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ZTZpTGOR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLYLCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 06:02:55 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:33159 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726025AbfLYLCy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Dec 2019 06:02:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577271774; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=62N7OXbGdkC8Rt0zho7z2/Df6d5Pscfs0lxlWoLWn7A=;
 b=ZTZpTGORhF1nEKbEYs1XfIdFdDxP/yZN5GHp/XAxO3G7aPoaijZ6oCkSdImwyBXoFtu48ItL
 NjFQr4MD2tz8jLjwB1UbAIw/yI/DQs8CIkeR7riaxbzQo0SLyUyg1VB/lLGWWLVpaXB+/IzH
 dqt7d7rvHXfyvwe1D36ABLNbk9g=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e0341db.7f4940b88fb8-smtp-out-n02;
 Wed, 25 Dec 2019 11:02:51 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1F89CC433CB; Wed, 25 Dec 2019 11:02:51 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB287C43383;
        Wed, 25 Dec 2019 11:02:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Dec 2019 19:02:49 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 6/6] ufs: Remove the SCSI timeout handler
In-Reply-To: <20191224220248.30138-7-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-7-bvanassche@acm.org>
Message-ID: <6d0c26d0e83c0372973889314eca004d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-25 06:02, Bart Van Assche wrote:
> The UFS SCSI timeout handler was needed to compensate that
> ufshcd_queuecommand() could return SCSI_MLQUEUE_HOST_BUSY for a long
> time. Commit a276c19e3e98 ("scsi: ufs: Avoid busy-waiting by 
> eliminating
> tag conflicts") fixed this so the timeout handler is no longer 
> necessary.
> 
> See also commit f550c65b543b ("scsi: ufs: implement scsi host timeout 
> handler").
> 
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 36 ------------------------------------
>  1 file changed, 36 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index edcc137c436b..763e41286a4b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7092,41 +7092,6 @@ static void ufshcd_async_scan(void *data,
> async_cookie_t cookie)
>  	ufshcd_probe_hba(hba);
>  }
> 
> -static enum blk_eh_timer_return ufshcd_eh_timed_out(struct scsi_cmnd 
> *scmd)
> -{
> -	unsigned long flags;
> -	struct Scsi_Host *host;
> -	struct ufs_hba *hba;
> -	int index;
> -	bool found = false;
> -
> -	if (!scmd || !scmd->device || !scmd->device->host)
> -		return BLK_EH_DONE;
> -
> -	host = scmd->device->host;
> -	hba = shost_priv(host);
> -	if (!hba)
> -		return BLK_EH_DONE;
> -
> -	spin_lock_irqsave(host->host_lock, flags);
> -
> -	for_each_set_bit(index, &hba->outstanding_reqs, hba->nutrs) {
> -		if (hba->lrb[index].cmd == scmd) {
> -			found = true;
> -			break;
> -		}
> -	}
> -
> -	spin_unlock_irqrestore(host->host_lock, flags);
> -
> -	/*
> -	 * Bypass SCSI error handling and reset the block layer timer if this
> -	 * SCSI command was not actually dispatched to UFS driver, otherwise
> -	 * let SCSI layer handle the error as usual.
> -	 */
> -	return found ? BLK_EH_DONE : BLK_EH_RESET_TIMER;
> -}
> -
>  static const struct attribute_group *ufshcd_driver_groups[] = {
>  	&ufs_sysfs_unit_descriptor_group,
>  	&ufs_sysfs_lun_attributes_group,
> @@ -7145,7 +7110,6 @@ static struct scsi_host_template
> ufshcd_driver_template = {
>  	.eh_abort_handler	= ufshcd_abort,
>  	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>  	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
> -	.eh_timed_out		= ufshcd_eh_timed_out,
>  	.this_id		= -1,
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,

Reviewed-by: Can Guo <cang@codeaurora.org>
