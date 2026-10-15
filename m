Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CBD1FE44A;
	Thu, 15 Oct 2026 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792080936; cv=none; b=pA4P/8rjMGqQ4ahPDW7R/Suow4qJz0EG/whLyigwfhNpoF4nxjs6v+6YUZFeJf3fGFPn1hMEmTf6HOS6J9GqxB2+9oQDC6q4V18wujAyrpAif9BMQ2I/wbWc043mWYTbYwnJIvDn/S4IisRwzMeUv3HTwcXTXxNuS3cedDuiBmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792080936; c=relaxed/simple;
	bh=BI8WLvTMpcMrMft2vSbwyPe6vcySciKQ5LOt63/Idi4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=d00j4oU/2YjEAAl2MC6jOj/4S38j7/8hwwen5HB00udCJTFvfPQp1d83SBrFFfEKgW2L7+DG0xpp5vLaCoaXCYPsovcnrG9Id/gLe8Mk/0+e1PF8qj5HkjpdcQm4iimPKOB5TnsYZPy4xB6264GUhS08LKN4jXFxA7ffvHmWyWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EKXJoMTF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EKXJoMTF"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F9kIX1575198;
	Thu, 15 Oct 2026 16:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=cdC+BBfjrm9MNCjkKpUMG1PpTzkJzg
	HWXxZw+TxFl70=; b=EKXJoMTFH/a5E3URvc1ditlzcl582YPkHyszb+k+iFwLtS
	RdJqnSEWRtCfjNCoBous6zQfa9g3cEcyso+zBRxo/6f74/jScAITwgtB+cKDKI44
	O7+dxDbqaTKmaIjADO8oCFVuiYz5Uo0ttT9qdq7MCEnBK64qv2FYJHLGKXpTp9av
	Z6UDTyGF+bILXRIMFEkq+nf3Kp6wVJbnXwnhksL2KS01mvmlr4yXG7YN+6lO8dr9
	SdZ+JWNkxHYwD1lSTdk3+JdcrR2jbG2th/ouAQZwz1oNqY335sH+XzujEw0NAjv6
	lkhRrVO1gILSk37emx2jUTJtH9DqYdVwfPaGfNkA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7e1wj93f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 16:15:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69FFB3TM2057772;
	Thu, 15 Oct 2026 16:15:19 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hawqws2ys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 16:15:19 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69FGFIeE23462578
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Oct 2026 16:15:19 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9106958063;
	Thu, 15 Oct 2026 16:15:18 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EA4B5804B;
	Thu, 15 Oct 2026 16:15:18 +0000 (GMT)
Received: from d (unknown [9.16.59.154])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 15 Oct 2026 16:15:18 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v14 03/11] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
In-Reply-To: <sashiko-outbox-173054@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 15 Oct 2026 15:20:49 +0000")
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
	<20261015-ibmvfc-fpin-support-v14-3-a0b063b8d825@linux.ibm.com>
	<sashiko-outbox-173054@kernel.org>
Date: Thu, 15 Oct 2026 11:15:17 -0500
Message-ID: <87cxtbc54a.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA2NCBTYWx0ZWRfX75Sbocr/Zxj6
 YfSiRlkA6uLHCcLkQEJ2AbAh+sclIfFoMymdN96jm/f0I8REZwR8J1UMkeL7tKAzV5e25dM7zd/
 lrfNTF0vtbOBy1pYoz937Qr1qciqmVs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA2NCBTYWx0ZWRfXyzQd8YHQILW+
 difT11viee2ZCZ/hdFEDU9oRIR61/tOjdsd/cbuuCCT7mcKuMKM+E0sQFrqFlmCPjOnuK1ro1qK
 11qgto02AO/9hMdZrNkG93mek+uxri+kNFwmF3R3Oiz8VwHG06P6HSK4DrSbq934rW75/sSs3r/
 efMDvLP2T+8y2OJTIYBWPR2qGLkhrcdLyl9xPU7Urp7N6w++h72D7l1tQ9/rdGvNW5jIrSam1vo
 z/TG7tefI9HYAeikEaPg49l7v17gB5Y2ViAzWXNDqE6rMhnbG28mUJwVA/5oqM46OByuJhbMRuW
 +4Zi2uzaACHsIRePdUp7MXDNmikuLIT/wkKfZQ8hL3lI1W7+sp3Qqx9jknuf7a1aI+ODRYcxOSG
 V2y0dRVeY/Oifj/GpYF/r10IxhXQPaIH/vw4Vj1y/ro9+ZmGcrGefAhdg2eFJzO+QZszmu0+Zao
 U7M1NCcOdiyf/rJiKMA==
X-Authority-Analysis: v=2.4 cv=E6pYNqdl c=1 sm=1 tr=0 ts=6ad0fc18 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=jjpvvTQg5jf5z_DcJG8A:9
X-Proofpoint-ORIG-GUID: rwnz6FzMhmsaB66WLna5j6sr7TsydIpq
X-Proofpoint-GUID: rwnz6FzMhmsaB66WLna5j6sr7TsydIpq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150064

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] scsi: ibmvfc: Build failure due to un-guarded KUnit visibility macros
> --
>
> commit 79ff3803bf62c41db84d726eab4c3cdbd582546c
> Author: Tyrel Datwyler <tyreld@linux.ibm.com>
>
> scsi: ibmvfc: fix potential NULL pointer dereference on failed queue allocation
>
> This commit guards ibmvfc_deregister_channel() against operating on unallocated
> queues and exposes it for KUnit testing. It also adds a new KUnit test module
> for the IBM POWER Virtual FC Client.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 145d559041f12..0fe6b6f4260ba 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> -static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>> +/**
>> + * ibmvfc_deregister_channel - Deregister a sub-CRQ channel with the hypervisor
>> + * @vhost:	ibmvfc host struct
>> + * @channels:	ibmvfc channels struct containing the sub-CRQ array
>> + * @index:	index into the sub-CRQ array
>> + *
>> + * Frees the IRQ, disposes of the IRQ mapping, and calls H_FREE_SUB_CRQ to
>> + * release the sub-CRQ with the hypervisor. On success the queue message
>> + * buffer is zeroed and the current index is reset. If H_FREE_SUB_CRQ fails,
>> + * an error is logged but the channel resources are cleaned up regardless.
>> + */
>> +VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>>  				      struct ibmvfc_channels *channels,
>>  				      int index)
>>  {
>
> [Severity: Low]
> Does this cause a build failure when CONFIG_KUNIT is disabled?
>
> Since <kunit/visibility.h> is only included conditionally in ibmvfc.h under
> #if IS_ENABLED(CONFIG_KUNIT), won't the unconditional use of VISIBLE_IF_KUNIT
> here (and EXPORT_SYMBOL_IF_KUNIT below) result in syntax errors during a
> standard build without KUnit?

No, this is not a problem. The only code that calls
ibmvfc_deregister_channel(), which is defined in ibmvfc-core.c, is also
in ibmvfc-core.c in the case where CONFIG_KUNIT is not defined. I've
cleared CONFIG_KUNIT in my config, run "make clean", and built the
kernel, and there were no errors.

> [ ... ]
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
>> index ca80ceffe53a5..421ce8bc3ea33 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
>
> [ ... ]
>
>> +#if IS_ENABLED(CONFIG_KUNIT)
>> +#include <kunit/visibility.h>
>> +VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>> +						struct ibmvfc_channels *channels,
>> +						int index);
>> +VISIBLE_IF_KUNIT struct ibmvfc_host *ibmvfc_get_first_vhost(void);
>> +#endif
