Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E48430B50F;
	Mon, 15 Jun 2026 20:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781554564; cv=none; b=B6Vq2UFUhQFGeILEmlPmcSqA675jmp//iz8EpEfa95R5dVyefDCaQBrv8M6R4jks3KoAOF1lXg08ZRhiOcfGzV0s9neER0rJpge1gducdi43ZMR5+YypllVyEQKgcz7Spg1AK7JCZixP4/fKE1qdL6nXRT41zlE3qvRIz8DjAMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781554564; c=relaxed/simple;
	bh=wsSSYFD75I6Il27m5JPWNfZ/SLvy3oNrij6hkmBr+G8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rDdSsm6k6eupxAda9d1B+Fg+emyZCUNi/1MQ5zDRKYwOV1B3ZtVN5Fdo8qzsKK6vfFCX9ayLZ5VfT8Oikrkon9GTN6OPo5CCQx+VQgHNAGIjse+aiYLHe5ndyaFvocnHtlmnlGYZ/gIakuLsRfwjxf+JCNGprjzLgdx+N/9FgO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B4vavR3a; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B4vavR3a"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FJIc373334969;
	Mon, 15 Jun 2026 20:15:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7P7va7+meqsTAlaUbyol4cF226BVTG
	W/q7MbSdKdAgY=; b=B4vavR3aglW4JcMCblM3EGpyTII1n8qpy+OnrT814/y+ck
	5Tv1+QpzXukhSyc03LV/23aADvo41pcE3lyLL09tkMxQZh/pCcTfOEh5paRqAW2B
	EKCifyvkwF6Hy6bTEXtkKEnrzrxl7E+cbNzxFq649qNn9L+dzjLYpMoDyqVyme8Z
	m7TVQAv4adhcwASGmEmdBTY5DNOIO3YNCpyqeF3gUoHX091cWS94wTsYy2STSwdX
	7xSvJDTnik9IGA6Pgsls1zrwqGT3asz5xucKYo+SeG2rZFyk6LWG7rLcTA8baqtc
	tqh4Q9CIhRWUbNEJ2SH84sXVLMcAGhtdygiSjWKg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4es1u0j08y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 20:15:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65FK4a5k025420;
	Mon, 15 Jun 2026 20:15:40 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4esjhk06qv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 20:15:40 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65FKFclU7078406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jun 2026 20:15:39 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC31958045;
	Mon, 15 Jun 2026 20:15:38 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3046858052;
	Mon, 15 Jun 2026 20:15:38 +0000 (GMT)
Received: from d (unknown [9.61.47.236])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 15 Jun 2026 20:15:38 +0000 (GMT)
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
Subject: Re: [PATCH v2 4/7] ibmvfc: define asynchronous sub-queue
In-Reply-To: <55fd8413-34d6-4dda-8a65-1aefaa8585e6@linux.ibm.com> (Tyrel
	Datwyler's message of "Mon, 15 Jun 2026 12:27:03 -0700")
References: <20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com>
	<20260608-ibmvfc-fpin-support-v2-4-d41f540fba5c@linux.ibm.com>
	<55fd8413-34d6-4dda-8a65-1aefaa8585e6@linux.ibm.com>
Date: Mon, 15 Jun 2026 15:15:37 -0500
Message-ID: <87se6no906.fsf@linux.ibm.com>
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
X-Proofpoint-GUID: wczoI-7ioeSKo1vSn1I7NWqWeujZNvok
X-Authority-Analysis: v=2.4 cv=XdK5Co55 c=1 sm=1 tr=0 ts=6a305d6d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=w5PW5THavAhz0YZFxZUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDIwOSBTYWx0ZWRfXw8tSEqfnKAZN
 MpmDvrvGL7hfULuDmhLzhAlcVc29gj7hWQFlW/pU10mChvGVjCt/IGoqAVTpTh6BahM1CG9xLby
 KFXv7dHLFAHzNwz0nqzoCAR2SRBOjyfsXvcQ1aUk3V/MgUF7lqvC1ZNK7He8ZtIC23ea/CQkK+i
 6upe/lLm7ElQuNbJERbx2txY+Da063bAftJkefhUkmp+vx3nfQdfkW5/xzPzs3nddi8DllB2f8z
 kvLaudbZXhS71yAXyGPioCoksaN9VpcrfE3kf58z74h/jJ3fV6lISgV+IfQqvM85FUfrBFSa98k
 jXu4vruTjSiTSjkviOIVXMS8Khs0xXOmE9x5ms1ibPhAjuI1tNEpheKame/U5+ngk2QKmkab2Li
 rwoFEfEEjGPq9W0gwwBIkR5e4grJzuu7Jo4s0Q53Bh0+7/u+hQHBNRvyooty3SWCnjSVqaUEs5S
 PWIa6AGmYmxNdHwlygg==
X-Proofpoint-ORIG-GUID: zbcaP4yBrTPJoL76FWoBlJmT-Rko4kgz
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDIwOSBTYWx0ZWRfX5lm14A1MALsA
 XuMR016jw0uva/Xn7QGGmGMgKyjnlGsQtYgg11ZdntCbFjT/7lZ4OIX6mg6lSK303QSanDP2oDj
 G4F3J9A3OYFQnhB8SCxpF+yNiUNE0nM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_05,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150209

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> On 6/8/26 11:30 AM, Dave Marquardt via B4 Relay wrote:
>> From: Dave Marquardt <davemarq@linux.ibm.com>
>> 
>> Adds the asynchronous sub-queue structure, modifies the existing
>> channel setup structure, adds the asynchronous sub-queue to the
>> channels structure, and adds flags needed to tell VIOS to use the
>> sub-queue.
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.h | 26 +++++++++++++++++++++++++-
>>  1 file changed, 25 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
>> index c996b36d335d..f026f30f98d3 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
>> @@ -181,6 +181,8 @@ struct ibmvfc_npiv_login {
>>  #define IBMVFC_CAN_HANDLE_FPIN		0x04
>>  #define IBMVFC_CAN_USE_MAD_VERSION	0x08
>>  #define IBMVFC_CAN_SEND_VF_WWPN		0x10
>> +#define IBMVFC_YES_SCSI			0x40
>> +#define IBMVFC_USE_ASYNC_SUBQ		0x100
>>  #define IBMVFC_CAN_USE_NOOP_CMD		0x200
>>  	__be64 node_name;
>>  	struct srp_direct_buf async;
>> @@ -229,6 +231,7 @@ struct ibmvfc_npiv_login_resp {
>>  #define IBMVFC_HANDLE_VF_WWPN		0x40
>>  #define IBMVFC_CAN_SUPPORT_CHANNELS	0x80
>>  #define IBMVFC_SUPPORT_SCSI		0x200
>> +#define IBMVFC_SUPPORT_ASYNC_SUBQ	0x800
>>  #define IBMVFC_SUPPORT_NOOP_CMD		0x1000
>>  	__be32 max_cmds;
>>  	__be32 scsi_id_sz;
>> @@ -563,7 +566,7 @@ struct ibmvfc_channel_setup_mad {
>>  	struct srp_direct_buf buffer;
>>  } __packed __aligned(8);
>>  
>> -#define IBMVFC_MAX_CHANNELS	502
>> +#define IBMVFC_MAX_CHANNELS	501
>>  
>>  struct ibmvfc_channel_setup {
>>  	__be32 flags;
>> @@ -578,6 +581,7 @@ struct ibmvfc_channel_setup {
>>  	struct srp_direct_buf buffer;
>>  	__be64 reserved2[5];
>>  	__be64 channel_handles[IBMVFC_MAX_CHANNELS];
>> +	__be64 asyncSubqHandle;
>
> No camelCase please. Kernel style prefers snake_case. Something like
> async_sub_crq_handle for consistency.

Got it. Thanks.

-Dave
