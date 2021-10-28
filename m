Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D6CC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995EA61108
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhJ1UYM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:24:12 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:46985 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhJ1UYM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 16:24:12 -0400
Received: by mail-pj1-f52.google.com with SMTP id lx5-20020a17090b4b0500b001a262880e99so5682488pjb.5;
        Thu, 28 Oct 2021 13:21:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bdl1W785S9//M7tjvJhEvajwnPMEKADExtalMMLObjs=;
        b=XQaqg3P6W0k6tgFJT7X2s2BNa9ZVNWLgjp/I3GUj5v/NKApFVUFu3Q8SWRdlmeKtSg
         GB9wpvVz7BDBB6AxDg+nR2aONOYZ72Xxw1tPzCmvUr/PVWzNHlhC+7x2WYT5a3gB4WeP
         LcNh3e3YYprja2Q8+raBgjvOB1wf1UiZEBEojBnDGx7D6XE555djQfIiS6Bgp7fQHECz
         LO8dd1k/3C1aZdVV07XEYqQluL4q8Jz7msdFL+q7vUHb6+eij+wjTKD/QhDwJnWxu3qO
         seeHfQAA+7xu7+8smBmezrQcVSK/aaacz6Gd17SV49c1sE1Crmal69J++O752ppR+PIS
         UHLw==
X-Gm-Message-State: AOAM533f63BlnXFr1FBgynqngRDXHbwera/ProTSpdhGdN+q7K1/e6zn
        HA/4OIx9NG3fhKDajsjO+gs8Bp+wnn/FZg==
X-Google-Smtp-Source: ABdhPJygXqDG1hJ9iFkSg0gb9TDzNfdXIqEkauwy1B1jAMT7eFLLW4CKsZ775Br8IHPaOoU7Vnxsyw==
X-Received: by 2002:a17:90a:7e13:: with SMTP id i19mr6748966pjl.120.1635452504555;
        Thu, 28 Oct 2021 13:21:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:e816:bd0d:426c:f959])
        by smtp.gmail.com with ESMTPSA id u10sm4230288pfk.211.2021.10.28.13.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 13:21:43 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk@kernel.org>,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Daejun Park <daejun7.park@samsung.com>
References: <20211026071204.1709318-1-hch@lst.de>
 <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
 <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org> <20211027052724.GA8946@lst.de>
 <b2bcc13ccdc584962128a69fa5992936068e1a9b.camel@HansenPartnership.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a6af2ce7-4a03-ab0c-67cd-c58022e5ded1@acm.org>
Date:   Thu, 28 Oct 2021 13:21:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <b2bcc13ccdc584962128a69fa5992936068e1a9b.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/21 5:20 AM, James Bottomley wrote:
> We don't have to revert it entirely, we can just remove the API since
> it's in an optimization path.  The below patch does exactly that.  It's
> compile tested but I don't have hardware so I've no idea if it works;
> Daejun can you please test it as a matter of urgency since we have to
> get this in before the end of the week.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 66b19500844e..1c89eafe0c1d 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -365,148 +365,6 @@ static inline void ufshpb_set_write_buf_cmd(unsigned char *cdb,
>   	cdb[9] = 0x00;	/* Control = 0x00 */
>   }
>   
> -static struct ufshpb_req *ufshpb_get_pre_req(struct ufshpb_lu *hpb)
> -{
> -	struct ufshpb_req *pre_req;
> -
> -	if (hpb->num_inflight_pre_req >= hpb->throttle_pre_req) {
> -		dev_info(&hpb->sdev_ufs_lu->sdev_dev,
> -			 "pre_req throttle. inflight %d throttle %d",
> -			 hpb->num_inflight_pre_req, hpb->throttle_pre_req);
> -		return NULL;
> -	}
> -
> -	pre_req = list_first_entry_or_null(&hpb->lh_pre_req_free,
> -					   struct ufshpb_req, list_req);
> -	if (!pre_req) {
> -		dev_info(&hpb->sdev_ufs_lu->sdev_dev, "There is no pre_req");
> -		return NULL;
> -	}
> -
> -	list_del_init(&pre_req->list_req);
> -	hpb->num_inflight_pre_req++;
> -
> -	return pre_req;
> -}
> -
> -static inline void ufshpb_put_pre_req(struct ufshpb_lu *hpb,
> -				      struct ufshpb_req *pre_req)
> -{
> -	pre_req->req = NULL;
> -	bio_reset(pre_req->bio);
> -	list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
> -	hpb->num_inflight_pre_req--;
> -}
> -
> -static void ufshpb_pre_req_compl_fn(struct request *req, blk_status_t error)
> -{
> -	struct ufshpb_req *pre_req = (struct ufshpb_req *)req->end_io_data;
> -	struct ufshpb_lu *hpb = pre_req->hpb;
> -	unsigned long flags;
> -
> -	if (error) {
> -		struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> -		struct scsi_sense_hdr sshdr;
> -
> -		dev_err(&hpb->sdev_ufs_lu->sdev_dev, "block status %d", error);
> -		scsi_command_normalize_sense(cmd, &sshdr);
> -		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> -			"code %x sense_key %x asc %x ascq %x",
> -			sshdr.response_code,
> -			sshdr.sense_key, sshdr.asc, sshdr.ascq);
> -		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> -			"byte4 %x byte5 %x byte6 %x additional_len %x",
> -			sshdr.byte4, sshdr.byte5,
> -			sshdr.byte6, sshdr.additional_length);
> -	}
> -
> -	blk_mq_free_request(req);
> -	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> -	ufshpb_put_pre_req(pre_req->hpb, pre_req);
> -	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> -}
> -
> -static int ufshpb_prep_entry(struct ufshpb_req *pre_req, struct page *page)
> -{
> -	struct ufshpb_lu *hpb = pre_req->hpb;
> -	struct ufshpb_region *rgn;
> -	struct ufshpb_subregion *srgn;
> -	__be64 *addr;
> -	int offset = 0;
> -	int copied;
> -	unsigned long lpn = pre_req->wb.lpn;
> -	int rgn_idx, srgn_idx, srgn_offset;
> -	unsigned long flags;
> -
> -	addr = page_address(page);
> -	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
> -
> -	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> -
> -next_offset:
> -	rgn = hpb->rgn_tbl + rgn_idx;
> -	srgn = rgn->srgn_tbl + srgn_idx;
> -
> -	if (!ufshpb_is_valid_srgn(rgn, srgn))
> -		goto mctx_error;
> -
> -	if (!srgn->mctx)
> -		goto mctx_error;
> -
> -	copied = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset,
> -					   pre_req->wb.len - offset,
> -					   &addr[offset]);
> -
> -	if (copied < 0)
> -		goto mctx_error;
> -
> -	offset += copied;
> -	srgn_offset += copied;
> -
> -	if (srgn_offset == hpb->entries_per_srgn) {
> -		srgn_offset = 0;
> -
> -		if (++srgn_idx == hpb->srgns_per_rgn) {
> -			srgn_idx = 0;
> -			rgn_idx++;
> -		}
> -	}
> -
> -	if (offset < pre_req->wb.len)
> -		goto next_offset;
> -
> -	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> -	return 0;
> -mctx_error:
> -	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> -	return -ENOMEM;
> -}
> -
> -static int ufshpb_pre_req_add_bio_page(struct ufshpb_lu *hpb,
> -				       struct request_queue *q,
> -				       struct ufshpb_req *pre_req)
> -{
> -	struct page *page = pre_req->wb.m_page;
> -	struct bio *bio = pre_req->bio;
> -	int entries_bytes, ret;
> -
> -	if (!page)
> -		return -ENOMEM;
> -
> -	if (ufshpb_prep_entry(pre_req, page))
> -		return -ENOMEM;
> -
> -	entries_bytes = pre_req->wb.len * sizeof(__be64);
> -
> -	ret = bio_add_pc_page(q, bio, page, entries_bytes, 0);
> -	if (ret != entries_bytes) {
> -		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> -			"bio_add_pc_page fail: %d", ret);
> -		return -ENOMEM;
> -	}
> -	return 0;
> -}
> -
>   static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
>   {
>   	if (++hpb->cur_read_id >= MAX_HPB_READ_ID)
> @@ -514,88 +372,6 @@ static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
>   	return hpb->cur_read_id;
>   }
>   
> -static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
> -				  struct ufshpb_req *pre_req, int read_id)
> -{
> -	struct scsi_device *sdev = cmd->device;
> -	struct request_queue *q = sdev->request_queue;
> -	struct request *req;
> -	struct scsi_request *rq;
> -	struct bio *bio = pre_req->bio;
> -
> -	pre_req->hpb = hpb;
> -	pre_req->wb.lpn = sectors_to_logical(cmd->device,
> -					     blk_rq_pos(scsi_cmd_to_rq(cmd)));
> -	pre_req->wb.len = sectors_to_logical(cmd->device,
> -					     blk_rq_sectors(scsi_cmd_to_rq(cmd)));
> -	if (ufshpb_pre_req_add_bio_page(hpb, q, pre_req))
> -		return -ENOMEM;
> -
> -	req = pre_req->req;
> -
> -	/* 1. request setup */
> -	blk_rq_append_bio(req, bio);
> -	req->rq_disk = NULL;
> -	req->end_io_data = (void *)pre_req;
> -	req->end_io = ufshpb_pre_req_compl_fn;
> -
> -	/* 2. scsi_request setup */
> -	rq = scsi_req(req);
> -	rq->retries = 1;
> -
> -	ufshpb_set_write_buf_cmd(rq->cmd, pre_req->wb.lpn, pre_req->wb.len,
> -				 read_id);
> -	rq->cmd_len = scsi_command_size(rq->cmd);
> -
> -	if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> -		return -EAGAIN;
> -
> -	hpb->stats.pre_req_cnt++;
> -
> -	return 0;
> -}
> -
> -static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
> -				int *read_id)
> -{
> -	struct ufshpb_req *pre_req;
> -	struct request *req = NULL;
> -	unsigned long flags;
> -	int _read_id;
> -	int ret = 0;
> -
> -	req = blk_get_request(cmd->device->request_queue,
> -			      REQ_OP_DRV_OUT | REQ_SYNC, BLK_MQ_REQ_NOWAIT);
> -	if (IS_ERR(req))
> -		return -EAGAIN;
> -
> -	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> -	pre_req = ufshpb_get_pre_req(hpb);
> -	if (!pre_req) {
> -		ret = -EAGAIN;
> -		goto unlock_out;
> -	}
> -	_read_id = ufshpb_get_read_id(hpb);
> -	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> -
> -	pre_req->req = req;
> -
> -	ret = ufshpb_execute_pre_req(hpb, cmd, pre_req, _read_id);
> -	if (ret)
> -		goto free_pre_req;
> -
> -	*read_id = _read_id;
> -
> -	return ret;
> -free_pre_req:
> -	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> -	ufshpb_put_pre_req(hpb, pre_req);
> -unlock_out:
> -	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> -	blk_put_request(req);
> -	return ret;
> -}
> -
>   /*
>    * This function will set up HPB read command using host-side L2P map data.
>    */
> @@ -685,23 +461,6 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>   		dev_err(hba->dev, "get ppn failed. err %d\n", err);
>   		return err;
>   	}
> -	if (!ufshpb_is_legacy(hba) &&
> -	    ufshpb_is_required_wb(hpb, transfer_len)) {
> -		err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> -		if (err) {
> -			unsigned long timeout;
> -
> -			timeout = cmd->jiffies_at_alloc + msecs_to_jiffies(
> -				  hpb->params.requeue_timeout_ms);
> -
> -			if (time_before(jiffies, timeout))
> -				return -EAGAIN;
> -
> -			hpb->stats.miss_cnt++;
> -			return 0;
> -		}
> -	}
> -
>   	ufshpb_set_hpb_read_to_upiu(hba, lrbp, ppn, transfer_len, read_id);
>   
>   	hpb->stats.hit_cnt++;

Hi James,

The help with trying to find a solution is appreciated.

One of the software developers who is familiar with HPB explained to me that
READ BUFFER and WRITE BUFFER commands may be received in an arbitrary order
by UFS devices. The UFS HPB spec requires UFS devices to be able to stash up
to 128 such pairs. I'm concerned that leaving out WRITE BUFFER commands only
will break the HPB protocol in a subtle way.

Thanks,

Bart.
