Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04DEC433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 03:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8943764F92
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 03:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhBEDar (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 22:30:47 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:62561 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230086AbhBEDaq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 22:30:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612495819; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7de4pU8VCrgKgb2uIrThFD75eGaIhnDm2vVGX2AEyBs=;
 b=DdCAeeXhZEylYPNgZd6BIfW1zYD+ZaIi2Lf0MulA/e7pYopI3N8OehrCOcicZLIp5U6k/ecx
 BdOXOa6LvAOVOxN4uA4Zu2rNptJbUG1ecTP7LjKvOoPzYYODvm5UHJNzflXdtlcoGBt0WLt9
 w+nPc6u9ndmuMpoDs0MAUEqqUNc=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 601cbbb081f6c45dcec6a17f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 05 Feb 2021 03:29:52
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D3E46C43469; Fri,  5 Feb 2021 03:29:50 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 92099C433CA;
        Fri,  5 Feb 2021 03:29:48 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 05 Feb 2021 11:29:48 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        huobean@gmail.com, bvanassche@acm.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached sub-region
In-Reply-To: <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
 <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
 <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
Message-ID: <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-29 13:30, Daejun Park wrote:
> This patch changes the read I/O to the HPB read I/O.
> 
> If the logical address of the read I/O belongs to active sub-region, 
> the
> HPB driver modifies the read I/O command to HPB read. It modifies the 
> UPIU
> command of UFS instead of modifying the existing SCSI command.
> 
> In the HPB version 1.0, the maximum read I/O size that can be converted 
> to
> HPB read is 4KB.
> 
> The dirty map of the active sub-region prevents an incorrect HPB read 
> that
> has stale physical page number which is updated by previous write I/O.
> 
> Reviewed-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Acked-by: Avri Altman <Avri.Altman@wdc.com>
> Tested-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |   2 +
>  drivers/scsi/ufs/ufshpb.c | 234 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h |   2 +
>  3 files changed, 238 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 52e48de8d27c..37cb343e9ec1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2653,6 +2653,8 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
> 
>  	lrbp->req_abort_skip = false;
> 
> +	ufshpb_prep(hba, lrbp);
> +
>  	ufshcd_comp_scsi_upiu(hba, lrbp);
> 
>  	err = ufshcd_map_sg(hba, lrbp);
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 48edfdd0f606..73e7b3ed04a4 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -31,6 +31,29 @@ bool ufshpb_is_allowed(struct ufs_hba *hba)
>  	return !(hba->ufshpb_dev.hpb_disabled);
>  }
> 
> +static int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
> +			     struct ufshpb_subregion *srgn)
> +{
> +	return rgn->rgn_state != HPB_RGN_INACTIVE &&
> +		srgn->srgn_state == HPB_SRGN_VALID;
> +}
> +
> +static bool ufshpb_is_read_cmd(struct scsi_cmnd *cmd)
> +{
> +	return req_op(cmd->request) == REQ_OP_READ;
> +}
> +
> +static bool ufshpb_is_write_or_discard_cmd(struct scsi_cmnd *cmd)
> +{
> +	return op_is_write(req_op(cmd->request)) ||
> +	       op_is_discard(req_op(cmd->request));
> +}
> +
> +static bool ufshpb_is_support_chunk(int transfer_len)
> +{
> +	return transfer_len <= HPB_MULTI_CHUNK_HIGH;
> +}
> +
>  static bool ufshpb_is_general_lun(int lun)
>  {
>  	return lun < UFS_UPIU_MAX_UNIT_NUM_ID;
> @@ -98,6 +121,217 @@ static void ufshpb_set_state(struct ufshpb_lu
> *hpb, int state)
>  	atomic_set(&hpb->hpb_state, state);
>  }
> 
> +static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
> +			     int srgn_idx, int srgn_offset, int cnt)
> +{
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +	int set_bit_len;
> +	int bitmap_len = hpb->entries_per_srgn;
> +
> +next_srgn:
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	if ((srgn_offset + cnt) > bitmap_len)
> +		set_bit_len = bitmap_len - srgn_offset;
> +	else
> +		set_bit_len = cnt;
> +
> +	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
> +	    srgn->srgn_state == HPB_SRGN_VALID)
> +		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
> +
> +	srgn_offset = 0;
> +	if (++srgn_idx == hpb->srgns_per_rgn) {
> +		srgn_idx = 0;
> +		rgn_idx++;
> +	}
> +
> +	cnt -= set_bit_len;
> +	if (cnt > 0)
> +		goto next_srgn;
> +
> +	WARN_ON(cnt < 0);
> +}
> +
> +static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
> +				   int srgn_idx, int srgn_offset, int cnt)
> +{
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +	int bitmap_len = hpb->entries_per_srgn;
> +	int bit_len;
> +
> +next_srgn:
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	if (!ufshpb_is_valid_srgn(rgn, srgn))
> +		return true;
> +
> +	/*
> +	 * If the region state is active, mctx must be allocated.
> +	 * In this case, check whether the region is evicted or
> +	 * mctx allcation fail.
> +	 */
> +	WARN_ON(!srgn->mctx);
> +
> +	if ((srgn_offset + cnt) > bitmap_len)
> +		bit_len = bitmap_len - srgn_offset;
> +	else
> +		bit_len = cnt;
> +
> +	if (find_next_bit(srgn->mctx->ppn_dirty,
> +			  bit_len, srgn_offset) >= srgn_offset)
> +		return true;
> +
> +	srgn_offset = 0;
> +	if (++srgn_idx == hpb->srgns_per_rgn) {
> +		srgn_idx = 0;
> +		rgn_idx++;
> +	}
> +
> +	cnt -= bit_len;
> +	if (cnt > 0)
> +		goto next_srgn;
> +
> +	return false;
> +}
> +
> +static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
> +			  struct ufshpb_map_ctx *mctx, int pos, int *error)
> +{
> +	u64 *ppn_table;
> +	struct page *page;
> +	int index, offset;
> +
> +	index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
> +	offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
> +
> +	page = mctx->m_page[index];
> +	if (unlikely(!page)) {
> +		*error = -ENOMEM;
> +		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +			"error. cannot find page in mctx\n");
> +		return 0;
> +	}
> +
> +	ppn_table = page_address(page);
> +	if (unlikely(!ppn_table)) {
> +		*error = -ENOMEM;
> +		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +			"error. cannot get ppn_table\n");
> +		return 0;
> +	}
> +
> +	return ppn_table[offset];
> +}
> +
> +static void
> +ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int 
> *rgn_idx,
> +			int *srgn_idx, int *offset)
> +{
> +	int rgn_offset;
> +
> +	*rgn_idx = lpn >> hpb->entries_per_rgn_shift;
> +	rgn_offset = lpn & hpb->entries_per_rgn_mask;
> +	*srgn_idx = rgn_offset >> hpb->entries_per_srgn_shift;
> +	*offset = rgn_offset & hpb->entries_per_srgn_mask;
> +}
> +
> +static void
> +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb 
> *lrbp,
> +				  u32 lpn, u64 ppn,  unsigned int transfer_len)
> +{
> +	unsigned char *cdb = lrbp->cmd->cmnd;
> +
> +	cdb[0] = UFSHPB_READ;
> +
> +	put_unaligned_be64(ppn, &cdb[6]);

You are assuming the HPB entries read out by "HPB Read Buffer" cmd are 
in Little
Endian, which is why you are using put_unaligned_be64 here. However, 
this assumption
is not right for all the other flash vendors - HPB entries read out by 
"HPB Read Buffer"
cmd may come in Big Endian, if so, their random read performance are 
screwed.

Actually, I have seen at least two flash vendors acting so. I had to 
modify this line
to get the code work properly on my setups.

Meanwhile, in your cover letter, you mentioned that the performance data 
is collected
on a UFS2.1 device. Please re-collect the data on a real UFS3.1 device 
and let me
know the part number. Otherwise, the data is not quite convincing to us.

Regards,
Can Guo.

> +	cdb[14] = transfer_len;
> +
> +	lrbp->cmd->cmd_len = UFS_CDB_SIZE;
> +}
> +
> +/*
> + * This function will set up HPB read command using host-side L2P map 
> data.
> + * In HPB v1.0, maximum size of HPB read command is 4KB.
> + */
> +void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +{
> +	struct ufshpb_lu *hpb;
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +	struct scsi_cmnd *cmd = lrbp->cmd;
> +	u32 lpn;
> +	u64 ppn;
> +	unsigned long flags;
> +	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
> +	int err = 0;
> +
> +	hpb = ufshpb_get_hpb_data(cmd->device);
> +	if (!hpb)
> +		return;
> +
> +	if (ufshpb_get_state(hpb) != HPB_PRESENT) {
> +		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> +			   "%s: ufshpb state is not PRESENT", __func__);
> +		return;
> +	}
> +
> +	if (!ufshpb_is_write_or_discard_cmd(cmd) &&
> +	    !ufshpb_is_read_cmd(cmd))
> +		return;
> +
> +	transfer_len = sectors_to_logical(cmd->device, 
> blk_rq_sectors(cmd->request));
> +	if (unlikely(!transfer_len))
> +		return;
> +
> +	lpn = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
> +	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	/* If command type is WRITE or DISCARD, set bitmap as drity */
> +	if (ufshpb_is_write_or_discard_cmd(cmd)) {
> +		spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
> +				 transfer_len);
> +		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +		return;
> +	}
> +
> +	if (!ufshpb_is_support_chunk(transfer_len))
> +		return;
> +
> +	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
> +				   transfer_len)) {
> +		hpb->stats.miss_cnt++;
> +		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +		return;
> +	}
> +
> +	ppn = ufshpb_get_ppn(hpb, srgn->mctx, srgn_offset, &err);
> +	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +	if (unlikely(err)) {
> +		/*
> +		 * In this case, the region state is active,
> +		 * but the ppn table is not allocated.
> +		 * Make sure that ppn table must be allocated on
> +		 * active state.
> +		 */
> +		WARN_ON(true);
> +		dev_err(hba->dev, "ufshpb_get_ppn failed. err %d\n", err);
> +		return;
> +	}
> +
> +	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
> +
> +	hpb->stats.hit_cnt++;
> +}
> +
>  static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
>  					     struct ufshpb_subregion *srgn)
>  {
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index e40b016971ac..2c43a03b66b6 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -198,6 +198,7 @@ struct ufs_hba;
>  struct ufshcd_lrb;
> 
>  #ifndef CONFIG_SCSI_UFS_HPB
> +static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) 
> {}
>  static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb 
> *lrbp) {}
>  static void ufshpb_resume(struct ufs_hba *hba) {}
>  static void ufshpb_suspend(struct ufs_hba *hba) {}
> @@ -211,6 +212,7 @@ static bool ufshpb_is_allowed(struct ufs_hba *hba)
> { return false; }
>  static void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf) {}
>  static void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf) {}
>  #else
> +void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
>  void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
>  void ufshpb_resume(struct ufs_hba *hba);
>  void ufshpb_suspend(struct ufs_hba *hba);
