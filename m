Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796B939524D;
	Thu,  7 May 2026 22:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778192739; cv=none; b=XFDy3aYq1pr5bHeSfgY+r/DmcLulmjSetfyd23lkd1AYCoX12t+nEzm2LGBetPzHCwj8O5t5hWvTrAzMdUpF4VUi6OFK5pVWXSzp38HWhdae2bcBWhbqkAaijMDpUPGy17e7xF0BVfKPc82/r7jjINI/E/DjJvlVfm9IVvn6iyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778192739; c=relaxed/simple;
	bh=ws75NAAgJZrBwdojyh1zjC4ELfTisTwCB/u+8w7QAJY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OYzj6TvMTwZRF1tntqPV1jPDy7iJRbJ5CL6ZTrNJoGqSDhbXut7c82KVcQkPnxLHh5o6KgrhNkgnD+wQo3t16Uk+T5j+NUNw95kHibMaDoNmU0zUWE+TXalV9GsKMgOmG8MJnCIqCLFWUy/0zscZrpp83Uxa12W7yxIfM9DEN8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QKjZLqjI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QKjZLqjI"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 647EHtIn1063728;
	Thu, 7 May 2026 22:25:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=81Jh3LK+0vUs1pnvEUughFFm1dUuq8
	wUB8fdLhXQnyw=; b=QKjZLqjI6mR1uVnAfcpF28/mJaIdRvnxQvQOGZG0GQIIOM
	A8Jhca1qEq5vIFZabfMcLviACotWVuQvLd26wHY4SdcfJQ5BTdPABDaYRFesoFOT
	CwmwgpG9Rw0/JdQJR9MQ8qlP+Av3l8sUDxArtH3eQOjg5zgsXjaSDmv5qHpz+4fZ
	5GFqkn8i9XeM+rajrUOxLGFDAnmya9nynAa3MRXLvJv+QH+i7f3vg3aLBJgFzDaj
	rVraAbDCtwwWYNj+m7B33A7pwi2+CvYYEOnY0vfwScYujT1nvsBIVvAxnUgOssFl
	JYP38sNZxcK3p9kXdrHjYVSYh4R6Gg1V0pXD+JVA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9x5118w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 22:25:26 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 647MOa7I021399;
	Thu, 7 May 2026 22:25:25 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9ynhcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 22:25:25 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 647MPNBi27394654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 22:25:23 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 876A158056;
	Thu,  7 May 2026 22:25:23 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44DAB58052;
	Thu,  7 May 2026 22:25:23 +0000 (GMT)
Received: from d (unknown [9.61.133.117])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  7 May 2026 22:25:23 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King
 <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch
 <kmahlkuc@linux.ibm.com>
Subject: Re: [PATCH 2/5] ibmvfc: Add NOOP command support
In-Reply-To: <7da072cf-8774-4144-8888-b3d41af470f8@linux.ibm.com> (Tyrel
	Datwyler's message of "Wed, 6 May 2026 21:17:55 -0700")
References: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
	<20260408-ibmvfc-fpin-support-v1-2-52b06c464e03@linux.ibm.com>
	<7da072cf-8774-4144-8888-b3d41af470f8@linux.ibm.com>
Date: Thu, 07 May 2026 17:25:22 -0500
Message-ID: <87mryaeu25.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDIyNCBTYWx0ZWRfX1baZNpuC9Gnv
 mzv1A0+BLzkjuKzb8iwt7xfmI6rIo2oyKZwkNhCVbPnVN4XGs4PkR24pmoBDByCktuDcxzGhrjQ
 mmEnYP4AM7F8LuSKe2iKprDAbddgsxv9E1Vtf5uaSdjJu+GlNzQRAvi3XCXaVZJAB3azB4wUFQp
 8pwN91p2ymy6lsBOCFoIhoI7aCMwsXhL7Ynu92Ia+e8ESnFm/+sT+1FMLoY8fKhNPWss+ix1uG2
 Uv57jFpvzr7C02biEBhi54BhXigXMKxGbB1pmKmsHvobKUWVjrKXvLyFhBOgA9h9goDDgLY2jOU
 TxrcfqD6fRi5KDszVFPnPMoSzFS/xSqoakYwgbQJSOv3YiXlqV2xAVJ6r+n27+jco+Orh5EA86m
 k9q/JkovKox+pI7HnXItA7KsInxK+eWkPTOSI8L3a4cMfayNlHvGKemkZ8pjZqkZe6hiPL9bqpv
 3JLwg49Yi9X9OfxlfZg==
X-Proofpoint-ORIG-GUID: pKVQwESEzxR8i_uN_p95xAEMkqMPZSpX
X-Proofpoint-GUID: zhsIKTCjxrjzRJAEf3b04GBtRfj4Ym1B
X-Authority-Analysis: v=2.4 cv=W7UIkxWk c=1 sm=1 tr=0 ts=69fd1156 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=T0R0goG4r3LzasRk0F4A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605070224

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> On 4/8/26 10:07 AM, Dave Marquardt via B4 Relay wrote:
>> From: Dave Marquardt <davemarq@linux.ibm.com>
>
>> - Add VFC_NOOP command support
>> - Add KUnit tests for VFC_NOOP command
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c       | 23 +++++++++++++----------
>>  drivers/scsi/ibmvscsi/ibmvfc.h       | 13 +++++++++++++
>>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 27 +++++++++++++++++++++++++++
>>  3 files changed, 53 insertions(+), 10 deletions(-)
>> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index 3ac376ba2c62..808301fa452d 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -189,13 +189,6 @@ static long h_reg_sub_crq(unsigned long unit_address, unsigned long ioba,
>>  	return rc;
>>  }
>>  
>> -static int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap_flags)
>> -{
>> -	u64 host_caps = be64_to_cpu(vhost->login_buf->resp.capabilities);
>> -
>> -	return (host_caps & cap_flags) ? 1 : 0;
>> -}
>> -
>
> It appears you are moving this to ibmvfc.h? Is there reasoning outside making it
> visible to kunit?

That's exactly why I'm moving this to ibmvfc.h. Alternatively I could
export this routine. I'm okay doing that if you prefer it.

>>  static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *vhost,
>>  						   struct ibmvfc_cmd *vfc_cmd)
>>  {
>> @@ -1512,7 +1505,9 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>>  		login_info->flags |= cpu_to_be16(IBMVFC_CLIENT_MIGRATED);
>>  
>>  	login_info->max_cmds = cpu_to_be32(max_cmds);
>> -	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
>> +	login_info->capabilities =
>> +		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
>> +			    IBMVFC_CAN_USE_NOOP_CMD);
>>  
>>  	if (vhost->mq_enabled || vhost->using_channels)
>>  		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
>> @@ -3461,8 +3456,8 @@ EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_async);
>>   * @evt_doneq:	Event done queue
>>   *
>>  **/
>> -static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
>> -			      struct list_head *evt_doneq)
>> +VISIBLE_IF_KUNIT void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
>> +					struct list_head *evt_doneq)
>>  {
>>  	long rc;
>>  	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
>> @@ -3520,6 +3515,13 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
>>  	if (crq->format == IBMVFC_ASYNC_EVENT)
>>  		return;
>>  
>> +	if (crq->format == IBMVFC_VFC_NOOP) {
>> +		if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
>> +			dev_err(vhost->dev,
>> +				"Received unexpected NOOP command from partner\n");
>
> If we have a misbahaved VIOS partner we may want to ratelimit this dev_err so
> that we don't flood the log. Probably a corner case, but I don't think it hurts.

Okay, I'll add rate limiting in v2.

-Dave
