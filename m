Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B442DCF74;
	Thu, 10 Sep 2026 23:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082119; cv=none; b=HZ0KLI/qmSZyswB/OsATpg4NXraf1znIr5vqNVATCzt0pKikWnc6ssmdD+9DWLeC5OmThR1dXoctW48Viu1PwxmtSvD+juzTHoI7ESveXPeR97OmdtVrbmowTM7lOLLnjNxmM6MD5fMthbS/M1zwRYzGPOjfGPdygKikAGKmg2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082119; c=relaxed/simple;
	bh=ehTDoHPsJP8oX/UFKacq2Cu1ZA6KhzYNpqer0tmcJm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IncyDyo1OF5Q7hhuKQ9E9VLegRmebSbQJ1QuLSiF3JZeoxBZGCFXvDOp+6owKB+Ub2ENMvbbY9hrLPs273O5fcmT+iqrIUif6n6hIae0i0rvEoHV4ixwv58KuadKaioXuloDd1mWqGS/WIn/IWYL7q6n9mwOBY/qSFDFEu1rv5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hOlCr26r; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hOlCr26r"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALVbkK4091985;
	Thu, 10 Sep 2026 23:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=r3j3xe
	dzHQVA7rrsaFy0FEdi7de45zllsDG3cCCc7Rk=; b=hOlCr26rcNtgont0xb/Ip2
	KhIzOW2i4J9qvNxXccOoUHPXJwHQ5IVd0tQ/2ZKEBtYJtmiW5fj0Hn9jE8n0DfpG
	znPAMSbh5NEuXB2Vug73UyYV96wCQCJAiEZAJG8glACCDPITeVrstB2bgG44Cmz7
	SIZmt82Iv6Y6MIzorgb6Hv1d+YPL0vtIXwTnNHDU0wtBNiCNDTdEnFt8aqz/FjhA
	neXg3HN/ZMNUA8ULrdUSRMoFGrKb8X/J2nxGuUnZoDCaziZrm/xNpO6MOqxIfSCW
	rNBpKr8QEM3tlT1uVyDwnY5kC37yqMAt8SPa3iDAuhPTWS06twYa4p8ftZrtN2wQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8qr3dy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:14:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALZ2WX619451;
	Thu, 10 Sep 2026 23:14:56 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvvrb3h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:14:56 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ANEtjw3605478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 23:14:55 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A93858056;
	Thu, 10 Sep 2026 23:14:55 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64AE55803F;
	Thu, 10 Sep 2026 23:14:54 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Sep 2026 23:14:54 +0000 (GMT)
Message-ID: <d9521b14-c126-4c52-ae3d-96ee0e35fea2@linux.ibm.com>
Date: Thu, 10 Sep 2026 16:14:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/9] scsi: ibmvfc: add NOOP command support
To: davemarq@linux.ibm.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-2-b27183b055af@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-2-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SpUFe/O0 c=1 sm=1 tr=0 ts=6aa339f2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=JdnPdPiFg7rkUO83TIAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: CklMNVxuauknLggUjWdAYpqXqF5ySy2N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfX9CReIHCV+jMX
 0y4qdne3EKFA8M93WR0ircv37LofkyL0Uv1ayJhgmDaxHbPwSL9Ai2yMSVsY7/BBx9TMDOn/ZDt
 3k6bqyyYFc4/USR8O97ZdAImE1b6SgoISHd67CiYm+WwjVJsZ0Q4hHeha5fEDnoWSqbY3c5bUvZ
 vl3unn76FW5kDlhmZWUmQPaHiIppwODqbDrJXx9uCZXCLzPqHu5SFeJmcmIqyroYlqKwrZFIPl3
 dDtB/y+MjxVD3TPmr69QY9/u8oUmNPKvNE/UzXfEW4DR1AKWYsnfPiiqIkGUmhiqc//BOvnJO9R
 GzNhR5CjmffXovv7kSCCGUc6yICzbrBhKoW3hcKuxD8SNOpiiEMMSLgUK8YGBDZYESzYaqUTHef
 XB/6Kjpaf+3hIRgsEZE7zYTahl+nf7rPjeRZpqBuuMR8jbK7lMxI/mWq/WjFNKE+QX+dEXthV4r
 ddbU9vaRGa7n+CQJHUA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfX8nLKlamHg6mW
 LEduDsjoXX2AzAylT9k2fiu/GCBULhg2qn2RI/33E/3S3C2VJyEH1aoclKIgRIEnJ7gS9Yhs+n8
 BsfuZxQvcu0L1WOsAMvtrWbjjc1CMbc=
X-Proofpoint-GUID: Jrcyqk8ofyac8oGM_TIYoTrKFnSt4h6Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100290

On 9/9/26 12:07 PM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Add support for handling IBMVFC_NOOP format CRQ messages from the
> VIOS partner.
> 
> Advertise the client's ability to handle NOOP commands by setting the
> IBMVFC_CAN_USE_NOOP_CMD capability in ibmvfc_set_login_info().
> 
> Handle and ignore IBMVFC_NOOP format messages in both ibmvfc_handle_crq()
> and ibmvfc_handle_scrq(). In both handlers, log a rate-limited error if a
> NOOP is received while in the IBMVFC_ACTIVE state without the partner
> having advertised IBMVFC_SUPPORT_NOOP_CMD.
> 
> In ibmvfc_handle_scrq(), also fix a typo ("Got and invalid" -> "Got an
> invalid"), add a missing return on invalid message types, and guard
> against null event pointers before processing CRQ responses.
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
