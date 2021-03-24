Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6861C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 04:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B1D619BB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 04:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbhCXD7w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 23:59:52 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:14349 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbhCXD71 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 23:59:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616558367; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=BsmeMdezVqvMu28lTn6tiXj/adA2HRB7cfqcT1XrXJ8=;
 b=IPJRxal2QRzMpFsGD0uagHjalXfpXYzD4uf2Kw966XwJ4bvy6s2r299rvoKpX3jVgIdhVGx1
 hWyubTEAUd9f1Kp0scK1TdlYy2pEie/o87M6nk6qnE0w9W1jKIMsE8DXIvwr1OvgeB25W0Ra
 3nR9YB1ShRHFTWnlqZOObzHjpPU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 605ab9092b0e10a0badfa994 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 24 Mar 2021 03:59:05
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 14AECC43468; Wed, 24 Mar 2021 03:59:05 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C225FC433C6;
        Wed, 24 Mar 2021 03:59:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 24 Mar 2021 11:59:03 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Zang Leigang <zangleigang@hisilicon.com>
Cc:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, stanley.chu@mediatek.com
Subject: Re: [PATCH v6 02/10] scsi: ufshpb: Add host control mode support to
 rsp_upiu
In-Reply-To: <20210324033104.5kms7pez6arnkaoz@shaphisprc48410>
References: <20210322081044.62003-1-avri.altman@wdc.com>
 <20210322081044.62003-3-avri.altman@wdc.com>
 <20210324033104.5kms7pez6arnkaoz@shaphisprc48410>
Message-ID: <e3bfb8c4fcadc8e1b7f9fec0ee4d57f5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-24 11:31, Zang Leigang wrote:
> On Mon, Mar 22, 2021 at 10:10:36AM +0200, Avri Altman wrote:
>> In device control mode, the device may recommend the host to either
>> activate or inactivate a region, and the host should follow. Meaning
>> those are not actually recommendations, but more of instructions.
>> 
>> On the contrary, in host control mode, the recommendation protocol is
>> slightly changed:
>> a) The device may only recommend the host to update a subregion of an
>>    already-active region. And,
>> b) The device may *not* recommend to inactivate a region.
>> 
>> Furthermore, in host control mode, the host may choose not to follow 
>> any
>> of the device's recommendations. However, in case of a recommendation 
>> to
>> update an active and clean subregion, it is better to follow those
>> recommendation because otherwise the host has no other way to know 
>> that
>> some internal relocation took place.
>> 
>> Signed-off-by: Avri Altman <avri.altman@wdc.com>
>> ---
>>  drivers/scsi/ufs/ufshpb.c | 34 +++++++++++++++++++++++++++++++++-
>>  drivers/scsi/ufs/ufshpb.h |  2 ++
>>  2 files changed, 35 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>> index fb10afcbb49f..d4f0bb6d8fa1 100644
>> --- a/drivers/scsi/ufs/ufshpb.c
>> +++ b/drivers/scsi/ufs/ufshpb.c
>> @@ -166,6 +166,8 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu 
>> *hpb, int rgn_idx,
>>  	else
>>  		set_bit_len = cnt;
>> 
>> +	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
>> +
>>  	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
>>  	    srgn->srgn_state == HPB_SRGN_VALID)
>>  		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
>> @@ -235,6 +237,11 @@ static bool ufshpb_test_ppn_dirty(struct 
>> ufshpb_lu *hpb, int rgn_idx,
>>  	return false;
>>  }
>> 
>> +static inline bool is_rgn_dirty(struct ufshpb_region *rgn)
>> +{
>> +	return test_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
>> +}
>> +
>>  static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
>>  				     struct ufshpb_map_ctx *mctx, int pos,
>>  				     int len, u64 *ppn_buf)
>> @@ -713,6 +720,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu 
>> *hpb,
>>  static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
>>  				     struct ufshpb_subregion *srgn)
>>  {
>> +	struct ufshpb_region *rgn;
>>  	u32 num_entries = hpb->entries_per_srgn;
>> 
>>  	if (!srgn->mctx) {
>> @@ -726,6 +734,10 @@ static int ufshpb_clear_dirty_bitmap(struct 
>> ufshpb_lu *hpb,
>>  		num_entries = hpb->last_srgn_entries;
>> 
>>  	bitmap_zero(srgn->mctx->ppn_dirty, num_entries);
>> +
>> +	rgn = hpb->rgn_tbl + srgn->rgn_idx;
>> +	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
>> +
>>  	return 0;
>>  }
>> 
>> @@ -1245,6 +1257,18 @@ static void ufshpb_rsp_req_region_update(struct 
>> ufshpb_lu *hpb,
>>  		srgn_i =
>>  			be16_to_cpu(rsp_field->hpb_active_field[i].active_srgn);
>> 
>> +		rgn = hpb->rgn_tbl + rgn_i;
>> +		if (hpb->is_hcm &&
>> +		    (rgn->rgn_state != HPB_RGN_ACTIVE || is_rgn_dirty(rgn))) {
>> +			/*
>> +			 * in host control mode, subregion activation
>> +			 * recommendations are only allowed to active regions.
>> +			 * Also, ignore recommendations for dirty regions - the
>> +			 * host will make decisions concerning those by himself
>> +			 */
>> +			continue;
>> +		}
>> +
> 
> Hi Avri, host control mode also need the recommendations from device,
> because the bkops would make the ppn invalid, is that right?

Right, but ONLY recommandations to ACTIVE regions are of host's interest
in host control mode. For those inactive regions, host makes its own 
decisions.

Can Guo.

> 
>>  		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
>>  			"activate(%d) region %d - %d\n", i, rgn_i, srgn_i);
>> 
>> @@ -1252,7 +1276,6 @@ static void ufshpb_rsp_req_region_update(struct 
>> ufshpb_lu *hpb,
>>  		ufshpb_update_active_info(hpb, rgn_i, srgn_i);
>>  		spin_unlock(&hpb->rsp_list_lock);
>> 
>> -		rgn = hpb->rgn_tbl + rgn_i;
>>  		srgn = rgn->srgn_tbl + srgn_i;
>> 
>>  		/* blocking HPB_READ */
>> @@ -1263,6 +1286,14 @@ static void ufshpb_rsp_req_region_update(struct 
>> ufshpb_lu *hpb,
>>  		hpb->stats.rb_active_cnt++;
>>  	}
>> 
>> +	if (hpb->is_hcm) {
>> +		/*
>> +		 * in host control mode the device is not allowed to inactivate
>> +		 * regions
>> +		 */
>> +		goto out;
>> +	}
>> +
>>  	for (i = 0; i < rsp_field->inactive_rgn_cnt; i++) {
>>  		rgn_i = be16_to_cpu(rsp_field->hpb_inactive_field[i]);
>>  		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
>> @@ -1287,6 +1318,7 @@ static void ufshpb_rsp_req_region_update(struct 
>> ufshpb_lu *hpb,
>>  		hpb->stats.rb_inactive_cnt++;
>>  	}
>> 
>> +out:
>>  	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
>>  		rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
>> 
>> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
>> index 7df30340386a..032672114881 100644
>> --- a/drivers/scsi/ufs/ufshpb.h
>> +++ b/drivers/scsi/ufs/ufshpb.h
>> @@ -121,6 +121,8 @@ struct ufshpb_region {
>> 
>>  	/* below information is used by lru */
>>  	struct list_head list_lru_rgn;
>> +	unsigned long rgn_flags;
>> +#define RGN_FLAG_DIRTY 0
>>  };
>> 
>>  #define for_each_sub_region(rgn, i, srgn)				\
>> --
>> 2.25.1
>> 
