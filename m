Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB5DC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 09:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0616C208DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 09:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="qxG5RLeA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgE1Jrz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 05:47:55 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:53640 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728300AbgE1Jrz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 05:47:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590659273; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=xYmozZb9WnxWip2hHrnXjv1hBkqRH9+nVZvZMrgJSVU=;
 b=qxG5RLeAFg4D/M0sx8zB6YiaRv58VIYwHbttWV1hYfcnt4pf4eu56WUvDyh/cDvlhjjiBYiO
 xAwxXLVvdI0mZOoOajcoyi2ZhypHn3WyUuMikHywwEtddIRzmbA1cp+yFB4tXMbVKVmq0tGB
 TgJn2UC0Gvnlk4UaiLMgO5F2P+M=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5ecf88c044a25e00525c8f09 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 May 2020 09:47:44
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CD29EC4339C; Thu, 28 May 2020 09:47:42 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6CF47C433C6;
        Thu, 28 May 2020 09:47:41 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 May 2020 17:47:41 +0800
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
Message-ID: <4fe9074323178a0b006f08402dd08b51@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

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

Sorry for bugging you on this old change. I am afraid we may need to add
this timeout handler back. Because there is till chances that a request
gets stuck somewhere in ufshcd_queuecommand() path before
ufshcd_send_command() gets called. e.g.

ufshcd_queuecommand()
->ufshcd_map_sg()
-->scsi_dma_map()
--->dma_map_sg()
---->dev->ops->map_sg()

map_sg() ops may get stuck. map_sg() method can vary on different 
platforms
based on actual IOMMU engines. We cannot gaurantee map_sg() ops must 
return
immediately as we don't know what is actually inside map_sg() ops.

And if it gets stuck there for a long time till the request times out, 
without
the UFS timeout handler, scsi layer will try to abort this request from 
UFS
driver by calling ufshcd_abort() eventually. ufshcd_abort() will think 
this
request has been completed due to its tag is not in 
hba->outstanding_reqs
or UFS host's door bell reg. However, actually, this request is still in
ufshcd_queuecommand() path. I don't need to continue on the subsequent 
impact
to UFS driver if ufshcd_abort() happens in this case. This is a corner 
case,
but it is still possible (I did see map_sg() ops hangs on real devices).

Having the UFS timeout handler back will prevent this situation as UFS 
timeout
handler checks if the tag is in hba->outstanding_reqs (for our case, it 
is not
in there), if no, it returns BLK_EH_RESET_TIMER so that scsi/block layer 
will
keep waiting.

What do you think? Please let me know your ideas on this, thanks!

<--code snippet-->
static int ufshcd_abort(struct scsi_cmnd *cmd)
{
...
         reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
         /* If command is already aborted/completed, return SUCCESS */
         if (!(test_bit(tag, &hba->outstanding_reqs))) {
                 dev_err(hba->dev,
                         "%s: cmd at tag %d already completed, 
outstanding=0x%lx, doorbell=0x%x\n",
                         __func__, tag, hba->outstanding_reqs, reg);
                 goto out;
         }
...
}
<--code snippet-->

Thanks,
Can Guo.

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
