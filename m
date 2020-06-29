Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6478C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD9F2072D
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgF2VjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:39:13 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2413 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727023AbgF2VjK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 17:39:10 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 2162EE3E60B9BA6859F6;
        Mon, 29 Jun 2020 14:53:33 +0100 (IST)
Received: from [127.0.0.1] (10.210.170.8) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 29 Jun
 2020 14:53:32 +0100
Subject: Re: [PATCH 07/22] csiostor: use internal command for LUN reset
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>
References: <20200629072021.9864-1-hare@suse.de>
 <20200629072021.9864-8-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4567ba10-c024-8e37-7aef-7ea13025952e@huawei.com>
Date:   Mon, 29 Jun 2020 14:51:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200629072021.9864-8-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.170.8]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/06/2020 08:20, Hannes Reinecke wrote:
> When issuing a LUN reset we should be allocating an
> internal command to avoid overwriting the original command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/csiostor/csio_scsi.c | 48 +++++++++++++++++++++++----------------
>   1 file changed, 29 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> index 00cf33573136..27001fdcdcac 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -2057,10 +2057,12 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
>   static int
>   csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
>   {
> -	struct csio_lnode *ln = shost_priv(cmnd->device->host);
> +	struct scsi_cmnd *reset_cmnd;
> +	struct scsi_device *sdev = cmnd->device;
> +	struct csio_lnode *ln = shost_priv(sdev->host);
>   	struct csio_hw *hw = csio_lnode_to_hw(ln);
>   	struct csio_scsim *scsim = csio_hw_to_scsim(hw);
> -	struct csio_rnode *rn = (struct csio_rnode *)(cmnd->device->hostdata);
> +	struct csio_rnode *rn = (struct csio_rnode *)(sdev->hostdata);
>   	struct csio_ioreq *ioreq = NULL;
>   	struct csio_scsi_qset *sqset;
>   	unsigned long flags;
> @@ -2073,13 +2075,13 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
>   		goto fail;
>   
>   	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
> -		      cmnd->device->lun, rn->flowid, rn->scsi_id);
> +		      sdev->lun, rn->flowid, rn->scsi_id);
>   
>   	if (!csio_is_lnode_ready(ln)) {
>   		csio_err(hw,
>   			 "LUN reset cannot be issued on non-ready"
>   			 " local node vnpi:0x%x (LUN:%llu)\n",
> -			 ln->vnp_flowid, cmnd->device->lun);
> +			 ln->vnp_flowid, sdev->lun);
>   		goto fail;
>   	}
>   
> @@ -2099,17 +2101,22 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
>   		csio_err(hw,
>   			 "LUN reset cannot be issued on non-ready"
>   			 " remote node ssni:0x%x (LUN:%llu)\n",
> -			 rn->flowid, cmnd->device->lun);
> +			 rn->flowid, sdev->lun);
>   		goto fail;
>   	}
>   
> +	reset_cmnd = scsi_get_internal_cmd(sdev, DMA_NONE, REQ_NOWAIT);

out of curiosity, do we use the tag at all or need to allocate a request 
here?

it seems that the current code just scribbles on the scmd host scribble 
parts, and now we use the internal scmd host scribble parts instead - so 
I'm not sure what we're really improving here.

Thanks
