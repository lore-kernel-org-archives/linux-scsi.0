Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529C53CEB83;
	Fri, 11 Sep 2026 02:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092740; cv=none; b=FmOzCq2p4ppskSyuGRYmIQzeKpQukuhNlCVLiJ5qFOqnGizSsIbG+/xGlksgjbQJuT8fzpZWotsszH2PPNIJm+I+D7mhmg2tn3LzvUm+MakhJaT03mG726CSfEzSoKNa6xA/EQJYlHYrj5s+YSMqayw7+PFX0sRN1FbjTFbLfUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092740; c=relaxed/simple;
	bh=a9J8w1ss2DWnyZMyGB6sfwkB1LCT2bkd5AOe5g+qt2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t9xZpkrrzgOCyt8AGHMqa2J2kCdS2iIisBk3Xi9zyRQ3GOzJFwQiYKdQ25a4J9EHxguLlLsnEtSmRjslUonXAvNM/TWQTqsDUp30ljYIRd4WwZTr5/SwDeBMutA6qTw2sc3OLPFFDUOBw7V1BWYwV6n7usCef+sWD2i3HaymqRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RbMKbEiA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RbMKbEiA"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B136Ds333689;
	Fri, 11 Sep 2026 02:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0FLI34
	LvU43N2dRSEVxg6o6eyrPlInwZ3BpNrXQyhbA=; b=RbMKbEiAuXzUusKgGXVEiH
	agNPdHkmUL6VyTE25XFTwqRqtJoeseVz9mm39jVQ/FYxA+o58TOyid89aX6gy1qF
	/EHQ7CnhxLJKGe5Z4u8bbIudEHX5dqaRooZSZgtCfzaIdAy+6iZOHa4E4RF05kLG
	1BPxBwFNbENTecvOASbne6bo2ztTxflYLVxoJe3ujleZz0c11fWpYgini6hytuvj
	W6AGKYSt84AN7sgvDXVdWznGYs5AvlTckrbIc22O8OJRBn7XaR+K99/5MyDyxNaI
	7ruHynfBH5Dvhh1DHnl6iBBk3mShUHaK94u62IzqgMKlyWvrWdXsil/8Kf7XgGJQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8qrrm8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:12:12 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B152Od892168;
	Fri, 11 Sep 2026 02:12:11 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvtfbund-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:12:11 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B2C9FV1835962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:12:10 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6AD65805A;
	Fri, 11 Sep 2026 02:12:09 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D0665803F;
	Fri, 11 Sep 2026 02:12:09 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:12:08 +0000 (GMT)
Message-ID: <ffe1a7fa-a182-4971-b000-4e5799be7d84@linux.ibm.com>
Date: Thu, 10 Sep 2026 19:12:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/9] scsi: ibmvfc: make ibmvfc support FPIN messages
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=SpUFe/O0 c=1 sm=1 tr=0 ts=6aa3637c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=fT4Tv0FmYl8aopXRZhsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: cuHROuYj0CYtdKccNUi4tGUzsAM_WD9M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX3q0XKphhTqh8
 XMx4Kwxp43+OARQ2T8LBEPiR3vKWOSW4zn8WFwhfSbmuuYiW2S11n1RUyCaxMqhoPUM4g8G+j3X
 S9B2Pbb/xr/oxLzNaiYw7ze9QUwZ66cCupAX9mf+CoB8ID7GVy9QaLWYkq7QJr990xP6K9qlOa/
 jAmy2pRxkBYXHFWjvNK3ULD7emGqi18jQo2Ygo8r1AjlaaFej0RefDmcXdxMWxqpRob0doMzX3w
 nHL3ohDEQZCQ84fGtG5sY2fJ3FeBLdgesA8wMUgPQoYa9mQrInvxs9KfIXAM7F2h+alAKdtnQ0g
 OqsJFIoykEnzX/Ml0K9Yob7ZKjLeeOjTiACnk8CBE1qORHD6XtcFYfakG2XQ7ReUjP3GwQBIoSq
 dbMSwvcj204Ue1nxbIvadYTe2jFByTPA51n1hnZTrzl/DPNa4AKQvbDJGIT6EpzgBmNRJ1VB98+
 qx6lkw3jFA7Cv9/Tfrw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfXzO4FHaDdA79Z
 lKBFOeXTQIRcGNjfrof2k+1jazcBrvOO3tjqO4ssHPbaSjZrstfmP4yIFoT4D4FHW7DjvhNmuUH
 FyD6QM1X1YWpeA5AZPv0Dyd+xpQKWMI=
X-Proofpoint-GUID: cuHROuYj0CYtdKccNUi4tGUzsAM_WD9M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024

On 9/10/26 7:08 PM, Tyrel Datwyler wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> This patch series adds FPIN (fabric performance impact notification)
> support to the ibmvfc (IBM Virtual Fibre Channel) driver. This comes
> in three flavors:
> 
> - basic, to recognize existing FPIN messages from the virtual I/O
>   server (VIOS) (patch 1)
> - full, supporting additional FPIN information and using its own
>   asynchronous sub-queue and interrupt (patches 3-8)
> - extended, supporting FC-LS-5 (patch 9)
> 
> Full and extended FPIN support requires a new asynchronous sub-queue
> with its own interrupt. The asynchronous sub-queue support requires
> ibmvfc to also support a new IBMVFC_NOOP command, which the driver
> recognizes and ignores (patch 2).
> 
> The asynchronous sub-queue work is split across four patches: patch 3
> defines the necessary data structures, patch 5 adds the interrupt and
> drain routines for the queue, patch 6 extends channel registration and
> deregistration to accommodate the new queue, and patch 7 fixes IRQ
> cleanup on registration failure. Patch 8 wires everything together,
> registering the async sub-queue during channel initialization and
> advertising support to VIOS during NPIV login.
> 
> All three modes convert an incoming FPIN message from VIOS to an FC
> extended link service message, in some cases using default values for
> information not provided by the VIOS FPIN message but expected in the
> FC ELS message. This FC ELS message is passed to fc_host_rcv_fpin for
> updating statistics and sending the information upstream by netlink
> multicast, where it may be read by listeners including the DM
> multipath daemon "multipathd."
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
Well it looks like I botched the cover letter and message-id here on the v9
respin. Doh!

I'll resend.

-Tyrel
