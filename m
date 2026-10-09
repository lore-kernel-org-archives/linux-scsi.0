Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E95A502566;
	Fri,  9 Oct 2026 18:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570878; cv=none; b=U7RbpUIKsck62i7UYNO7t0Sy1T514Xb6qth4vE25JeUnatiDuZx87TjXKKN4pkl6YN+hBGQ+ERRH9YMNUsVtQ5Cgg3vGTdjtEXxjC22v4FQw512viP+2GMFvpX4VbE80HadcjGeEX5VszoMDZApmf7Ef8jdeAGuxv0BqecYojAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570878; c=relaxed/simple;
	bh=dFSsQS/OnQ+Ipn9WS84kWOyWVIZbLjGCISb+AIfKXx4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Vt8zshvJSbZaB1PtK+WWLsdXXmxrjhaksPwIjKj1wurK4bjMbYqIVFCV0fw51/JByHvwA9B5T4Dj/6H0TyjF3tEAC9xJWOC//hywtpwnzn8gDTOar5rh1T7BD/ebmftT5ai/rCCcHekx5sRBBiAb7tvpPzs8cMhvL4aOH5ZDwwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H/j0yQq4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H/j0yQq4"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699HZwas699031;
	Fri, 9 Oct 2026 18:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=fzhQGVurYEC30EOm3SygksIRKzVMnH
	m/ENouoV/nkd0=; b=H/j0yQq4EzUsMdLvquYvLeyNn9+pBR0rIDGsJfzoG3GstX
	emOYsaVxDqHxrOLzm6pO/6SVTdBulaNQULR/e+tCln+7/Il00gJG2uakxVxLG88l
	WqyoTue0LWA0S/9U+EDknmy6B0IjbmditbLzYz13h+AVh6LBhSBYK0ew942txrg+
	CVNXmbpvo4iFyuMedln9k3POvhJin/fnbMxI/3we9H7MUKi6rDxR4AJH/f77ynkd
	GqtR9NWhITk8ftbzjzNUwDjLsQOXe+FQ9lFRSitOGwsc22cU2XkyOG9U0dK6Yn/a
	/9wKX2cFMujHtXHXdZwGBcthXpbNeBuJhEMGGKHA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h74ter9m4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 09 Oct 2026 18:34:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 699H8Eq01142910;
	Fri, 9 Oct 2026 18:34:31 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h6udd2byc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Oct 2026 18:34:31 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 699IYVQa24904420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Oct 2026 18:34:31 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB95F58063;
	Fri,  9 Oct 2026 18:34:30 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADA6D5804B;
	Fri,  9 Oct 2026 18:34:30 +0000 (GMT)
Received: from d (unknown [9.61.186.115])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  9 Oct 2026 18:34:30 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v13 03/11] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
In-Reply-To: <sashiko-outbox-163321@kernel.org> (sashiko-bot@kernel.org's
	message of "Wed, 07 Oct 2026 19:44:41 +0000")
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
	<20261007-ibmvfc-fpin-support-v13-3-b816abfa4fcc@linux.ibm.com>
	<sashiko-outbox-163321@kernel.org>
Date: Fri, 09 Oct 2026 13:34:30 -0500
Message-ID: <871p9yn2o9.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA3MiBTYWx0ZWRfX2uQlBU4X9p8t
 fx0WUFHp4Xlg3vt/VLsygT5DuRls8fT9iCZxAOauSZ4sKTogRVXorD5o5VOZECYgNDjsumJmAjO
 n1PuUorQBwWZ3l+K3FaSD4jLnR2pwyM=
X-Proofpoint-GUID: P9Yw8I3lIqNDUAN_JJqXFFdctffG6ilN
X-Authority-Analysis: v=2.4 cv=P42vFSAu c=1 sm=1 tr=0 ts=6ac933b8 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=MPx-HvhaHCjr5pnxk8wA:9
X-Proofpoint-ORIG-GUID: P9Yw8I3lIqNDUAN_JJqXFFdctffG6ilN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA3MiBTYWx0ZWRfX+ABqe2SXNaPc
 K+ePce8/l5KuU80lxkoxjs5BPJhZKqqm/RddorPYzjm2W2BdY/igL3YeyKNtzEaZI+S52Iy3KgG
 oegO6m/QxOtDN6ZrH7HIhUERwLRRzL5vrmnoKnyg5lWBtCQa3K0Xx8yrulaHy6QhBWWoeQir/oI
 ZMCiWKZLUVdyumKQerT46odx9aXJjUdIK5VZJ+lb7keILasaqSXaU7skrs6q4N7AFI7VkP974Yb
 bTefW7ics9wrcRsvZ2mzUndSMr2YHcMTlo2rthAkEQUitVbfKhBJNUYZZb5BAEyYN7oGGxjfpoa
 VzovkTF+SpjbcrHWDFSHRZBS5rsSPBnO/l6Gl6jok173wFvsiqwOy6GpO4yT/c6p7gnWIlT17R9
 Wg+AYOCSViEi5TgeBk2K8Yg1CZx18KlyNZyccFuqx7PxcOwhy+MGx0ZkSS6L9NghZ6uQxrkmLuN
 0ncRcF/hNshDtX3XWWg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_05,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 suspectscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610090072

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] scsi: ibmvfc: double free of sub-CRQs on partial registration failure
> - [Low] scsi: ibmvfc: unprotected H_FREE_SUB_CRQ on uninitialized or double-freed queues
> --
>
> commit 0fde5959dd5d7f8887aa67ee2fa7032b0dd6353a
> Author: Tyrel Datwyler <tyreld@linux.ibm.com>
>
> scsi: ibmvfc: fix potential NULL pointer dereference on failed queue allocation
>
> Guard the memset() in ibmvfc_deregister_channel() behind a check of
> scrq->msgs.handle to prevent a NULL dereference when the function is
> called on a queue that was never allocated, such as async_sub_crq when
> multi-queue is disabled or initialization failed before
> ibmvfc_alloc_queue() was reached.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 145d559041f12..6a42d15db9ec5 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -6480,8 +6480,10 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>>  		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
>
> [Severity: High]
> Can a partial registration failure lead to a double-free of the sub-CRQ
> resource?
>
> In ibmvfc_reg_sub_crqs(), if registration fails midway, it deregisters the
> already registered queues by calling ibmvfc_deregister_channel():
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_reg_sub_crqs() {
>     ...
> 	for (i = 0; i < channels->max_queues; i++) {
> 		if (ibmvfc_register_channel(vhost, channels, i)) {
> 			for (j = i; j > 0; j--)
> 				ibmvfc_deregister_channel(vhost, channels, j - 1);
>     ...
> }
>
> However, ibmvfc_deregister_channel() doesn't zero scrq->cookie, and
> vhost->mq_enabled remains true. 
>
> When a subsequent adapter reset or teardown occurs, ibmvfc_dereg_sub_crqs()
> loops over all queues and calls ibmvfc_deregister_channel() again on the
> same queues, potentially causing a double-free at the hypervisor level.
>
> Could scrq->cookie be cleared after successfully freeing the sub-CRQ to
> prevent this?
>
>>  	/* Clean out the queue */
>> -	memset(scrq->msgs.crq, 0, PAGE_SIZE);
>> -	scrq->cur = 0;
>> +	if (scrq->msgs.handle) {
>
> [Severity: Low]
> Is the H_FREE_SUB_CRQ hypercall safe to execute on uninitialized queues?
>
> The memset() is now properly guarded by scrq->msgs.handle, but the
> H_FREE_SUB_CRQ hypercall just above this block continues to run
> unconditionally.
>
> If a queue was never registered or was already deregistered (such as during
> the ibmvfc_reg_sub_crqs() rollback), the unconditional hypercall will fail
> and generate a spurious "Failed to free sub-crq..." error message.
>
> Should the hypercall logic also be protected against uninitialized or already
> freed queues?

Both of these issues will be resolve by check scrq.cookie. In the "never
registered" case, cookie is still 0 from the initial allocation by
kzalloc_obj(). Clearing scrq.cookie on deregistration will be added in
ibmvfc_deregister_channel(), and calling the hypervisor will also be
conditional on scrq.cookie != 0.

-Dave
