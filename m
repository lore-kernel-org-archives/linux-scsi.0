Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DCCC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 04:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AAC264E06
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 04:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhBAE0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 23:26:02 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38369 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbhBAEZv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 23:25:51 -0500
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210201042502epoutp024cce63e5fbadbf7c4c226960970f29a0~fhRGhyWZg1296912969epoutp02X
        for <linux-scsi@vger.kernel.org>; Mon,  1 Feb 2021 04:25:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210201042502epoutp024cce63e5fbadbf7c4c226960970f29a0~fhRGhyWZg1296912969epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612153502;
        bh=4CaMWmOxTRQ4Yvh5Egmq/VowEgz2jyK7bRflwWVi//g=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=VP7cOWaOIgG3nQaGUVL5/gtwTr3yEG2NfDy2tspxFvR66j6p3owX6kBzYDmOz9i6x
         GGUNTEAVX7wmDlH5XwBgB7vs98xv7BsgJ6bH4E37+q4ZkpSNRLvMrrMDHXnhzJAuDM
         DJmCcmqCz/o7G5XRSUKtu7/sL2PUGlHeFg3b1JYA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210201042501epcas3p324f93d079b2b4cbe46209d413bc811f7~fhRGC5IB91510715107epcas3p3d;
        Mon,  1 Feb 2021 04:25:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4DTZbx5xfjz4x9Q0; Mon,  1 Feb 2021 04:25:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210127151217.24760-4-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01612153501819.JavaMail.epsvc@epcpadp3>
Date:   Mon, 01 Feb 2021 12:51:36 +0900
X-CMS-MailID: 20210201035136epcms2p2c245b5fc97d5ecdf0c1ca96496d6e0c6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210127151311epcas2p1696c2b73f3b4777ac0e7f603790b552f
References: <20210127151217.24760-4-avri.altman@wdc.com>
        <20210127151217.24760-1-avri.altman@wdc.com>
        <CGME20210127151311epcas2p1696c2b73f3b4777ac0e7f603790b552f@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

Thanks for adding HCM support on HPB.
I have some opinion for this patch.

> +#define WORK_PENDING 0
> +#define ACTIVATION_THRSHLD 4 /* 4 IOs */
Rather than fixing it with macro, how about using sysfs and make it
configurable?

> @@ -306,12 +325,39 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
>  				 transfer_len);
>  		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +
> +		if (ufshpb_mode == HPB_HOST_CONTROL)
> +			atomic64_set(&rgn->reads, 0);
> +
>  		return;
>  	}
>  
> +	if (ufshpb_mode == HPB_HOST_CONTROL)
> +		reads = atomic64_inc_return(&rgn->reads);
> +
>  	if (!ufshpb_is_support_chunk(transfer_len))
>  		return; <- *this*
>  
> +	if (ufshpb_mode == HPB_HOST_CONTROL) {
> +		/*
> +		 * in host control mode, reads are the main source for
> +		 * activation trials.
> +		 */
> +		if (reads == ACTIVATION_THRSHLD) {
If the chunk size is not supported, we can not active this region
permanently. It may be returned before get this statement.

> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index 8a34b0f42754..b0e78728af38 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -115,6 +115,9 @@ struct ufshpb_region {
>  	/* below information is used by lru */
>  	struct list_head list_lru_rgn;
>  	unsigned long rgn_flags;
> +
> +	/* region reads - for host mode */
> +	atomic64_t reads;
I think 32 bits are suitable, because it is normalized by worker on every
specific time.

Thanks,
Daejun
