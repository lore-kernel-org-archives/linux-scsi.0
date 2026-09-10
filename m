Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1539449E13E;
	Thu, 10 Sep 2026 23:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789083275; cv=none; b=auW0qV3L9xY2PcfPSSu+IPpidTQx9gTbAtetgzSWjt8g9RBuHWB8jo7hjWzcZGPANIcXibtqX06lkAf7rEN1FWA1FlIUVqyj3z2/ZPMGurGRWDh0Nrc5Wy5iQiurs/kMEZIJrNNlFXj2b+ZpAyLhw+sxpIPkPYj4OlUiWfYIFbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789083275; c=relaxed/simple;
	bh=701Dvi92DHKonZtbSA73/uU+8yMb4v2WR1pLRmacJcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mMWtWPJVU2buiLlwBuif+RRSASzoD/qOleUTG9LlFKjcO4aYtpCMg2JN+IabGrM7QjSB2Uk3aPvOD1RzzlLsD4Sl3kexwEOts+Sk+njrsJ7cKTu9FuxGYTEexYgiHrJ5DQnvXqaVCTxp2WjUkNpJfIkHBYqqCujTX7mr9NUV5BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oDnzlz/x; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oDnzlz/x"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALVWVn4091831;
	Thu, 10 Sep 2026 23:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1CK3Q0
	DLq1i/SuMADWu88bmFWHiJLO7oP2FWToAdHFE=; b=oDnzlz/xuDd9acANt/hOdl
	wXv7tmHELMWAhhN4DY1JblKqqJENRu9Grcqk0Ec7wH0Y+SCbEM5CCUw+gRKALmTE
	VrvxQrSG/ieOemrotsyncoWb3/5YNds2f9tooXi6uK8QOWJ9igzJEbPJc2ElFTDH
	J9ljWsWmdzx+BJxNRyr3lDd90gOkSoFMH4TY1d24jriYuPPB4n2ZiUOsSA9UD4ns
	OG1OhVkC98Wt0TpNSmS9z09QwH/K+ndeOWntDFApqYjv9QPT17TVA+rXfa6VylfK
	BjBosWWrQNuwRByjJUJUZriE2+wr5D3YSvPDCWxUnFnPnrTA3YXz6P0Rw66Bn1OA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8qr5es-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:34:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALZ170654191;
	Thu, 10 Sep 2026 23:34:21 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvtfb78g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:34:21 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ANYJfW66060680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 23:34:20 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D80D058060;
	Thu, 10 Sep 2026 23:34:19 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0670F58056;
	Thu, 10 Sep 2026 23:34:19 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Sep 2026 23:34:18 +0000 (GMT)
Message-ID: <4dda7fe6-cb27-4c52-8817-45df6640e857@linux.ibm.com>
Date: Thu, 10 Sep 2026 16:34:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 8/9] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
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
 <20260909-ibmvfc-fpin-support-v8-8-b27183b055af@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-8-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SpUFe/O0 c=1 sm=1 tr=0 ts=6aa33e7e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=-YAZYqJh-q85vGwOs2wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Y7DZCj-bdRalhUfmLQ43Cgm_RikJxP8X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI5NyBTYWx0ZWRfX4xWNyRzkONSe
 k4jLxJyH+FXrLQL429rKUKTaKOO13i0S8iZ3nZKXO5M7xcg8sR+BvoMbC0qe9rLjglCsH63YnKg
 N9YpNuPPVRGXBFv+kU33wA/L+G9+37kk9gqR9JzDSL4PPw2L55W3UGfEXBitGxoevIlEOHG+SMg
 cvOZtdKs7FzdD/92pVL0lkXojJuw29qazSkIdyxvZU7pkfiHfdWOJvWywdvAMjX9C3ijaoQ1zZ4
 cM8mBXJsOX7HVWoZQdqp6rkmmz7kOykR72DeKAuX4qEThJOJYkUIvgt8bvSxMWXkmiKajJ2Em2u
 4Nx3tIuwW0pkXT+87gXdXjWd0bIZoNw0ZOmTKO+q4mI2gemoHVevK9Y6QWt1RPAq1DZZVBYK3WO
 E7Y4rk2k9ALeeVM6EyVkW/KkcfP3Wtu0zxTlBLrteHre3r9VfLHYK2FEsXoEwUgOz2tUt9Cj3ov
 8b8J2xqTqhgGechRIrQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI5NyBTYWx0ZWRfX7mFKuqqYe1V+
 GAKBtMdbbaOivUJNBZNNO5RPMjEwZSs73lAXaO7z0B97Z2z4+qJISSI5aBIZ4Dy0fztMvGxIlZl
 +v2gr71SKbPe47KlUjSDQfJfdhQu8Do=
X-Proofpoint-GUID: cnkrV3L0eMKU8H2Jx19VLzmecBHdXq9h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100297

On 9/9/26 12:08 PM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
> registered, and freed alongside the SCSI channel queues.
> 
> In ibmvfc_init_sub_crqs(), allocate the async sub-CRQ queue buffer via
> ibmvfc_alloc_queue() before allocating the SCSI channels. Register it
> with the VIOS by calling ibmvfc_register_channel() with index -1 (the
> negative-index sentinel introduced in the previous commit). Either
> failure disables multi-queue and aborts init.
> 
> In ibmvfc_release_sub_crqs(), ibmvfc_reenable_crq_queue(), and
> ibmvfc_reset_crq(), deregister and re-register the async sub-CRQ
> alongside the SCSI channel queues.
> 
> In ibmvfc_channel_setup_done(), capture the async sub-CRQ handle
> returned by the VIOS in the channel setup response and store it in
> vhost->async_sub_crq.vios_cookie.
> 
> In ibmvfc_set_login_info(), advertise IBMVFC_USE_ASYNC_SUBQ,
> IBMVFC_CAN_HANDLE_FPIN, and IBMVFC_YES_SCSI capabilities whenever
> multi-queue channels are enabled. IBMVFC_YES_SCSI was previously only
> set for NVMe-enabled configurations; move it to the common multi-queue
> path so it is always advertised when channels are in use.
> 
> Fix a variable-shadowing bug in ibmvfc_register_channel() where the
> irq_failed cleanup loop reused rc for the H_FREE_SUB_CRQ hcall result,
> clobbering the error code returned to the caller. Introduce hcall_rc
> for the cleanup loop instead.
> 
> Guard the memset() in ibmvfc_deregister_channel() behind a check of
> scrq->msgs.handle to prevent a NULL dereference when the function is
> called on a queue that was never allocated, such as async_sub_crq when
> multi-queue is disabled or initialization failed before
> ibmvfc_alloc_queue() was reached.
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
