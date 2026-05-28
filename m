Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0568E3438BD
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 00:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779929038; cv=none; b=X01IA9lPw+eTCTIp+DLm22FI7YWHWt2Wl8rc7WJiF89oBrXOf8oH7knx2NbczImjg1W85qxD+9sLmKLPpNHc8fZRCB5iV7NxQXT01UF4R/BqeWOfuebJk7VFrUn0moDxB/oelT34E8RXCoQaUgGHllUQ3uSAtHzKfF3iYW6WcW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779929038; c=relaxed/simple;
	bh=I8fylyytm6SqyhS37HrsZvyOw6B02kBD7cHSF9ieQIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=WSWG8URiJ5bfRpUVU5a0UQaofka9ni+QMECtegm5N+l+B4QPQdkxL0J998g3CUbJLa5Dq4eFM74Qce6qyW6ueQEJWocLq0oXyW5FJrqeISHahB13UR11B3NbI0tmuTkcKduDGvse3LTCO+Xd8/oNEacJjio+A6b6YDCiYF3ozeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EqWEP0GK; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EqWEP0GK"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260528004353epoutp01aded875b85232b8fe7767b9eff6cb23c~zlAacGsHn1530615306epoutp01_
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 00:43:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260528004353epoutp01aded875b85232b8fe7767b9eff6cb23c~zlAacGsHn1530615306epoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1779929033;
	bh=qZnK9XNZnt5S75D0eJ2QB1UtmuCaHKxP5rlmMZeoiCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqWEP0GKldwHNBFfo+JcNRu7AbmM/xcIgspLUmQl6Yx7a1UM+FJDgmQXzeUS9ViI7
	 gksY40xHaZhhPtgXS94nOepRpV4HbObnsUp4Q2T3zxcsDhHZqxAKsAp1ngmo+5TSX3
	 1myfIRwU21NW1qIn8rR1l4vjeRn/w8kwFt7+ipCg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20260528004353epcas1p1a67c3f97fd1fde1d299f3f49c5840672~zlAZ6amc_2979629796epcas1p1b;
	Thu, 28 May 2026 00:43:53 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.38.119]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4gQnmT0KWGz6B9mD; Thu, 28 May
	2026 00:43:53 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20260528004352epcas1p4474702b6aae3232afefc3b7b528523ee~zlAZKEDW80380303803epcas1p4W;
	Thu, 28 May 2026 00:43:52 +0000 (GMT)
Received: from cw9316lee.. (unknown [10.253.101.98]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20260528004352epsmtip196271caae684f27ee41eeed971db167d~zlAZGRhCX0273302733epsmtip1Z;
	Thu, 28 May 2026 00:43:52 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: cw9316.lee@samsung.com
Cc: James.Bottomley@HansenPartnership.com, adrian.hunter@intel.com,
	alim.akhtar@samsung.com, alok.a.tiwari@oracle.comm, avri.altman@wdc.com,
	beanhuo@micron.com, bvanassche@acm.org, can.guo@oss.qualcomm.com,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, peter.wang@mediatek.com, ulf.hansson@linaro.org,
	vamshigajjela@google.com
Subject: Re: [PATCH] scsi: ufs: core: Fix NULL pointer dereference in
 scsi_cmd_priv() calls
Date: Thu, 28 May 2026 09:43:49 +0900
Message-ID: <20260528004349.281467-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527072228.271542-1-cw9316.lee@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260528004352epcas1p4474702b6aae3232afefc3b7b528523ee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260528004352epcas1p4474702b6aae3232afefc3b7b528523ee
References: <20260527072228.271542-1-cw9316.lee@samsung.com>
	<CGME20260528004352epcas1p4474702b6aae3232afefc3b7b528523ee@epcas1p4.samsung.com>

On 5/27/26 16:14, Bart Van Assche wrote:
>On 5/27/26 12:22 AM, Chanwoo Lee wrote:
>> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
>> index c1b1d67a1ddc..798b2a910128 100644
>> --- a/drivers/ufs/core/ufs-mcq.c
>> +++ b/drivers/ufs/core/ufs-mcq.c
>> @@ -555,8 +555,8 @@ static int ufshcd_mcq_sq_start(struct ufs_hba *hba, struct ufs_hw_queue *hwq)
>>   int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
>>   {
>>   	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
>> -	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
>> -	struct request *rq = scsi_cmd_to_rq(cmd);
>> +	struct ufshcd_lrb *lrbp;
>> +	struct request *rq;
>>   	struct ufs_hw_queue *hwq;
>>   	void __iomem *reg, *opr_sqd_base;
>>   	u32 nexus, id, val;
>> @@ -568,6 +568,9 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
>>   	if (!cmd)
>>   		return -EINVAL;
>>   
>> +	lrbp = scsi_cmd_priv(cmd);
>> +	rq = scsi_cmd_to_rq(cmd);
>> +
>
>These changes are not necessary. Although scsi_cmd_priv() and
>scsi_cmd_to_rq() both return an invalid pointer if their argument is
>NULL, these pointers are not dereferenced before the cmd != NULL check.
>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 9e0336098e26..0371dea44887 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -5833,13 +5833,15 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>>   			  struct cq_entry *cqe)
>>   {
>>   	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
>> -	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
>> +	struct ufshcd_lrb *lrbp;
>>   	enum utp_ocs ocs;
>>   
>>   	if (WARN_ONCE(!cmd, "cqe->command_desc_base_addr = %#llx\n",
>>   		      le64_to_cpu(cqe->command_desc_base_addr)))
>>   		return;
>>   
>> +	lrbp = scsi_cmd_priv(cmd);
>> +
>>   	if (hba->monitor.enabled) {
>>   		lrbp->compl_time_stamp = ktime_get();
>>   		lrbp->compl_time_stamp_local_clock = local_clock();
>
>These changes are not necessary either because lrbp is not dereferenced
>before the cmd != NULL check.
>
>Thanks,
>
>Bart.

Thank you for the review. You're right that there is no runtime
crash since scsi_cmd_priv() and scsi_cmd_to_rq() only perform
pointer arithmetic without dereferencing, and the derived pointers
are not used before the NULL check.

I made these changes because it felt logically awkward to derive
values from a potentially NULL pointer, even if they aren't
dereferenced before the check. But I understand your point and
will drop these two changes.

Could you let me know if you think the remaining changes are
acceptable, or if you consider the entire patch unnecessary?
I'd like to clarify this before sending v2.

Thanks,
Chanwoo Lee.
