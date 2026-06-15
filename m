Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3439A3382F9;
	Mon, 15 Jun 2026 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530964; cv=none; b=QZ+8rIB22vLrKC6A3j1/n3YF5q8k1cB63MY5kJbq/I/Qt9Dyybd+/8DSnMj/FIZSe4g3kO/yd7UNgce04vPicc5mCmc33teR9hFKHnpwZmxt6zG+Dosld1vuDHNovAqbyxJho0YU4GYpwgM7G4rOy5dw59gwptU6TkDFHZfVWRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530964; c=relaxed/simple;
	bh=/F8fogloGvQh4ay9+1WalY/kSS2ocsurO69oSr0JBWY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FIGlRRuCdG7vQQP3REGzYSUCK4Zp5lKQFNAeQ+z3u/dVGGh6cKBnxLPsZtZVVi8hNPduxo8AANj7a2b+ODYdR9XFv+3NTwtRo/knndCSIY6ThvPXV3jC7qKWSvC8ot1Ah73nhcECJF9xOjS5KxAqX8oTR6W17jemUwBTmlChZoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y+6iTTVH; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y+6iTTVH"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FCmI972492985;
	Mon, 15 Jun 2026 13:42:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=/AUs2IpHamyo41vAyD7BiKW2lU4vDv
	YAUoToDIb93Mo=; b=Y+6iTTVHuidrVhR6sd0Q6mUiaWTd5rmT29K0h7e7rMz7uM
	xRwbUMLU3U5rLwN32FINpxrs5ToE39p6HpH7QhxUA7DeVFniFJQtihlFhBBk1g52
	5bHfJLB7Jtm7ZqgJNtFgo/xTCaKhJtPYSwr0LHHw2HAP+eobqOOZNwmGB6LkUSHf
	mVKN4CuNN7aZVVJmDQ99sPdO7UUrmm1m+zvAsT1uIUjK3RHlCfHCxHfP7viPbJ70
	1ZZsxL8mJ81xPC4EKRzbDMJdmRpj19E0mH1vm40vehbb2UMuRWeaQgXCOWO+F3tF
	CWDeiAEJy70SZPAG5BdZU08he8U5Uc+4s5W59Vrw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4es1u0gb2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 13:42:22 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65FDYskr005326;
	Mon, 15 Jun 2026 13:42:21 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4esm7xxj46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 13:42:21 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65FDgKFq61800938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jun 2026 13:42:21 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2D165805E;
	Mon, 15 Jun 2026 13:42:20 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D05D58043;
	Mon, 15 Jun 2026 13:42:20 +0000 (GMT)
Received: from d (unknown [9.61.47.236])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 15 Jun 2026 13:42:20 +0000 (GMT)
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
Subject: Re: [PATCH v2 3/7] ibmvfc: make ibmvfc login to fabric
In-Reply-To: <bfb7ff08-e4ec-46a2-b368-12d5c77f0ee4@linux.ibm.com> (Tyrel
	Datwyler's message of "Fri, 12 Jun 2026 16:11:50 -0700")
References: <20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com>
	<20260608-ibmvfc-fpin-support-v2-3-d41f540fba5c@linux.ibm.com>
	<bfb7ff08-e4ec-46a2-b368-12d5c77f0ee4@linux.ibm.com>
Date: Mon, 15 Jun 2026 08:42:20 -0500
Message-ID: <87fr2ngbsz.fsf@linux.ibm.com>
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
X-Proofpoint-GUID: 8u22F-5ZuVfIGMU1LG1gjHNN8Q2486UM
X-Authority-Analysis: v=2.4 cv=XdK5Co55 c=1 sm=1 tr=0 ts=6a30013e cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=XpNYvxSjXNYYdcPCh5QA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE0MCBTYWx0ZWRfXyww3q4H4sX7z
 GEBlp/6aVGTE/1F8LTaGr5Bt/Nzk/wF4Zw6NkUJ1cVRSuqnK5Fnz70O2JYj76ILvdvKv2I3HHQ1
 CvWqP8gwiilp9baN+smOcXycHncoj1DR83F2zfXfTSqtQubPHxZsEUTXEHCzPylZOuvv5g9+iCM
 C43DmrqP4CxIkLN/rgbi0MMzHfLoRnTXP5ZdnXCbrEV2MMdeEuYTrJPhhoTcuVF8N28qaUeLzBb
 8EbVcuY4jMk/bAKWAOxOdJN9HD5l0J6lDDNfbxxCE6P3Nl0skSvPTGGfvFR1zzbYtsOocCJn+3G
 CfVV9Hvplk2qqyARSRzEkdpCg4FHf1z8404WwEYrUMI704F7HlPraJgpFcZ+QeHxeUQYG+5Sj9E
 Q8P3ZXBLpnMsXM+MFZ1nm9hHE91DWnJ831SV3tbIORwnA+hDDIyeBRXE81KJ7Z1Dpe8ZWFJ/zTc
 Gc7cIlql4qn/fJydaug==
X-Proofpoint-ORIG-GUID: o_eAyPbjzhEC7E28p1u7-6JtD0ON0pqo
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE0MCBTYWx0ZWRfX8rk26948JXO3
 eBMop23yX6JIdm+z0iGbBu4OqEC3/9oPhP18vM5yBuUT+VbDPSjYxJQu7gAkyXS/OsWxKAIREFZ
 56LbjGxp3NeXToiScy5wSwCr6MKQNoE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_03,2026-06-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150140

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> On 6/8/26 11:30 AM, Dave Marquardt via B4 Relay wrote:
>> From: Dave Marquardt <davemarq@linux.ibm.com>
>> 
>> Add support for fabric login in order to support the asynchronous
>> event queue with its own interrupt as required by NPIV specification
>> to support the asynchronous sub-queue and interrupt in order to
>> support full and extended FPIN messages.
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c | 94 ++++++++++++++++++++++++++++++++++++++++--
>>  drivers/scsi/ibmvscsi/ibmvfc.h | 16 +++++++
>>  2 files changed, 106 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index 88386d7c9106..a18861808325 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -5244,6 +5244,86 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
>>  		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
>>  }
>>  
>> +static void ibmvfc_fabric_login_done(struct ibmvfc_event *evt)
>> +{
>> +	struct ibmvfc_fabric_login *rsp = &evt->xfer_iu->fabric_login;
>> +	u32 mad_status = be16_to_cpu(rsp->common.status);
>> +	struct ibmvfc_host *vhost = evt->vhost;
>> +	int level = IBMVFC_DEFAULT_LOG_LEVEL;
>> +
>> +	ENTER;
>> +
>> +	switch (mad_status) {
>> +	case IBMVFC_MAD_SUCCESS:
>> +		fc_host_port_id(vhost->host) = be64_to_cpu(rsp->nport_id);
>> +		ibmvfc_free_event(evt);
>> +		break;
>> +
>> +	case IBMVFC_MAD_FAILED:
>> +		if (ibmvfc_retry_cmd(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)))
>> +			level += ibmvfc_retry_host_init(vhost);
>> +		else
>> +			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
>> +		ibmvfc_log(vhost, level, "Fabric Login failed: %s (%x:%x)\n",
>> +			   ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
>> +						be16_to_cpu(rsp->status), be16_to_cpu(rsp->error));
>> +		ibmvfc_free_event(evt);
>> +		LEAVE;
>> +		return;
>> +
>> +	case IBMVFC_MAD_CRQ_ERROR:
>> +		ibmvfc_retry_host_init(vhost);
>> +		fallthrough;
>> +
>> +	case IBMVFC_MAD_DRIVER_FAILED:
>> +		ibmvfc_free_event(evt);
>> +		LEAVE;
>> +		return;
>> +
>> +	default:
>> +		dev_err(vhost->dev, "Invalid fabric Login response: 0x%x\n", mad_status);
>> +		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
>> +		ibmvfc_free_event(evt);
>> +		LEAVE;
>> +		return;
>> +	}
>> +
>> +	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
>> +	wake_up(&vhost->work_wait_q);
>> +
>> +	LEAVE;
>> +}
>> +
>> +static void ibmvfc_fabric_login(struct ibmvfc_host *vhost)
>> +{
>> +	struct ibmvfc_fabric_login *mad;
>> +	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
>> +	int level = IBMVFC_DEFAULT_LOG_LEVEL;
>> +
>> +	if (!evt) {
>> +		ibmvfc_log(vhost, level, "Fabric Login failed: no available events\n");
>> +		ibmvfc_hard_reset_host(vhost);
>> +		return;
>> +	}
>> +
>> +	ibmvfc_init_event(evt, ibmvfc_fabric_login_done, IBMVFC_MAD_FORMAT);
>> +	mad = &evt->iu.fabric_login;
>> +	memset(mad, 0, sizeof(*mad));
>> +	if (vhost->scsi_scrqs.protocol == IBMVFC_PROTO_SCSI)
>> +		mad->common.opcode = cpu_to_be32(IBMVFC_FABRIC_LOGIN);
>> +	else {
>> +		ibmvfc_log(vhost, level, "Fabric Login failed: unknown protocol\n");
>> +		return;
>> +	}
>
> This check is pretty pedantic. Seeing as you are directly referencing the scsi
> sub-crqs. The protocol field exists so we can pass the sub-crqs blindly and the
> code once NVMf comes along can determine the protocol.
>
> Also, if somehow this was ever possibly the case you would leak the event
> structure. I think we can drop the check all together.

Okay, I'll drop this.

-Dave
