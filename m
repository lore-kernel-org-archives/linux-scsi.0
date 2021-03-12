Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189F1C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 01:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFA0664F6D
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 01:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhCLBYh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 20:24:37 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:34793 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhCLBYX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 20:24:23 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615512262; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=mPCFrFaraLF0BgsJD0nMZhdkLB2JwveNjJsCXBbTD2o=;
 b=YpeV8eTTbhWUkhYqxfhehC126kGLJvNIOwhFvaX4GHn+QHwDYiXuWhzBxZIiVqXqldkiW/M7
 OFstwDu+II660Y0hX2XpQNcQSJgTZLR0luqkYGgXfEAD1jU8VfRboMXTsTtfwyMNHQF12P6o
 CBakOl42d2fSXgbzD3rvdmFixSg=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 604ac2ad3f267701a46531d7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 12 Mar 2021 01:23:57
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5C225C43462; Fri, 12 Mar 2021 01:23:57 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7F035C433C6;
        Fri, 12 Mar 2021 01:23:55 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Mar 2021 09:23:55 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, huobean@gmail.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v26 3/4] scsi: ufs: Prepare HPB read for cached sub-region
In-Reply-To: <20210303062859epcms2p5aad4084d1a29bebdcb5979af099692bf@epcms2p5>
References: <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
 <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p5>
 <20210303062859epcms2p5aad4084d1a29bebdcb5979af099692bf@epcms2p5>
Message-ID: <25d5e6fc76bbfcfdd326540cbfc706e8@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-03 14:28, Daejun Park wrote:
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
>  drivers/scsi/ufs/ufshpb.c | 253 +++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ufs/ufshpb.h |   2 +
>  3 files changed, 254 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5852ff44c3cc..851c01a26207 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2656,6 +2656,8 @@ static int ufshcd_queuecommand(struct Scsi_Host
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
> index 8abadb0e010a..c75a6816a03f 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -46,6 +46,29 @@ static void ufshpb_set_state(struct ufshpb_lu *hpb,
> int state)
>  	atomic_set(&hpb->hpb_state, state);
>  }
> 
> +static int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
> +				struct ufshpb_subregion *srgn)
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
> @@ -80,8 +103,8 @@ static void ufshpb_kick_map_work(struct ufshpb_lu 
> *hpb)
>  }
> 
>  static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
> -					 struct ufshcd_lrb *lrbp,
> -					 struct utp_hpb_rsp *rsp_field)
> +				    struct ufshcd_lrb *lrbp,
> +				    struct utp_hpb_rsp *rsp_field)
>  {
>  	/* Check HPB_UPDATE_ALERT */
>  	if (!(lrbp->ucd_rsp_ptr->header.dword_2 &
> @@ -107,6 +130,230 @@ static bool ufshpb_is_hpb_rsp_valid(struct 
> ufs_hba *hba,
>  	return true;
>  }
> 
> +static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
> +				 int srgn_idx, int srgn_offset, int cnt)
> +{
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +	int set_bit_len;
> +	int bitmap_len;
> +
> +next_srgn:
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	if (likely(!srgn->is_last))
> +		bitmap_len = hpb->entries_per_srgn;
> +	else
> +		bitmap_len = hpb->last_srgn_entries;
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
> +}
> +
> +static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
> +				  int srgn_idx, int srgn_offset, int cnt)
> +{
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +	int bitmap_len;
> +	int bit_len;
> +
> +next_srgn:
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	if (likely(!srgn->is_last))
> +		bitmap_len = hpb->entries_per_srgn;
> +	else
> +		bitmap_len = hpb->last_srgn_entries;
> +
> +	if (!ufshpb_is_valid_srgn(rgn, srgn))
> +		return true;
> +
> +	/*
> +	 * If the region state is active, mctx must be allocated.
> +	 * In this case, check whether the region is evicted or
> +	 * mctx allcation fail.
> +	 */
> +	if (unlikely(!srgn->mctx)) {
> +		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +			"no mctx in region %d subregion %d.\n",
> +			srgn->rgn_idx, srgn->srgn_idx);
> +		return true;
> +	}
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
> +static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
> +				     struct ufshpb_map_ctx *mctx, int pos,
> +				     int len, u64 *ppn_buf)
> +{
> +	struct page *page;
> +	int index, offset;
> +	int copied;
> +
> +	index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
> +	offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
> +
> +	if ((offset + len) <= (PAGE_SIZE / HPB_ENTRY_SIZE))
> +		copied = len;
> +	else
> +		copied = (PAGE_SIZE / HPB_ENTRY_SIZE) - offset;
> +
> +	page = mctx->m_page[index];
> +	if (unlikely(!page)) {
> +		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +			"error. cannot find page in mctx\n");
> +		return -ENOMEM;
> +	}
> +
> +	memcpy(ppn_buf, page_address(page) + (offset * HPB_ENTRY_SIZE),
> +	       copied * HPB_ENTRY_SIZE);
> +
> +	return copied;
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
> +			    u32 lpn, u64 ppn, unsigned int transfer_len)
> +{
> +	unsigned char *cdb = lrbp->cmd->cmnd;
> +
> +	cdb[0] = UFSHPB_READ;
> +
> +	/* ppn value is stored as big-endian in the host memory */
> +	memcpy(&cdb[6], &ppn, sizeof(u64));
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

Same here, please mute these prints before hpb is fully initialized.

Thanks,
Can Guo.
