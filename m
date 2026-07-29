Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A1545628A;
	Wed, 29 Jul 2026 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785350903; cv=none; b=YyMtsUBH6+tPB//SayWB+BBc5aipDcBiQmDfYsNAuYW3HyX2ra288QWP/mH5layH2ISN1gGZZ05kpq1imYuqhPTW30F4ho8YHoo1n2mkcb6UNgy6Pr4e+PDzexJCdOxtRz5KQV6eLXzDqoQMIJXtLPVnv80YTV3zET4R7a4Jlt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785350903; c=relaxed/simple;
	bh=OeYMPvndSWdwWL7Dm/fPIM8Z89rTyPnkX14PIN4wntE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=sLLgYC8Rm16Wjhb8N5Pakc5k9IotP6b28Eu2G1vG07OG1ZTB5Z3rwfsLu4w3F+JEqraPYuQ8Oq3VyyQVBlzgT3YIu11YiS66BO7KfNdNtWIA8FWd7T/T6MJlpYmMq+Sc4Yi8hk5EjN8dGwXXFFtl/Kjp50soB7wO4hIw3QmNrZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dXQDoyWr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dXQDoyWr"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TIlia4732663;
	Wed, 29 Jul 2026 18:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=cx5VdKtVAyKFl73vD1Z51vWNfi2Lt7
	3eQCUYiqvdrOs=; b=dXQDoyWrKi6fudCWXLmqwHpY5Hx+HEnednurVMKF6nyGrS
	BmZOjwAHyB6J2OwW9LQJc3z3k2qCXqKT8I0zmo8GDsxlab25Qwn+M9s/GbdfUxdZ
	/6TwvteUy3hya6hahLDl/PPlNeg4FbiWm9qDv30RjoBF5+TkHGxaUebcurY/kizj
	bPea8i4eeKBkGqBOVtQI6jegHt4kp3IsGzTBo2bLUM57dX2pTiwRYzA7XxX3O2W5
	z/aQreHJfjbPKx3gQYlCBJlx1jLG4lY9mH1jbHSmCvy/ip048sYIvpN0jqLKjb0A
	OgV1KxRZYC0/J4b60xLOd/Mu769dre53u2sdyBbA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0nud65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 18:48:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66TIfUT6006377;
	Wed, 29 Jul 2026 18:48:12 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5y7qp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 18:48:12 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66TImB7730212658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 18:48:11 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E48658053;
	Wed, 29 Jul 2026 18:48:11 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA63458043;
	Wed, 29 Jul 2026 18:48:10 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Jul 2026 18:48:10 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
Subject: Re: [PATCH v2 30/33] ibmvfc: implement nvme-fc IO command
 submission callback
In-Reply-To: <20260723000149.969416-31-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
	<20260723000149.969416-31-tyreld@linux.ibm.com>
Date: Wed, 29 Jul 2026 13:48:10 -0500
Message-ID: <878q6tzl79.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDE0NCBTYWx0ZWRfX/EN+nfO5ODT2
 tidL+oQdoI0M2NSo7pQKP8F2jtXDLyf8yh+oKNbMYvuNAYB8M2vkKNBCCHlaEDphqAi52Ps5XT/
 FtiqIthvhEzn36XeY9Ksltbc5Y3kYt0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDE0NCBTYWx0ZWRfX6q1Sqt7DhQ4P
 zMqGfP0PBIKZNXwEHLxNRPYOAUbGZGl+UWykCUNtHGN6vRbS6HnelRIOsabQnCLZEE6HI60hklT
 bFzRAQ1HB8HVH0Es01SDd7PUYdLyzWZ3kkTxwRvVm56NhmExkjjqb8I6NnNH9moCbH5qrf6Ewfl
 gfuK3dUkMm6ZZ3vxI5JeBvKNJ8HG6mCfSydv0N3AEcvuy08JA1wq/kw9HNjIev5qzjZVBp1FUrx
 +M7z7aqtzvnA8n4mKYa29OcxOq9T5/UP5SPHUeja7uE3dAkOLMhiAPLxpJ8Icy0KnCgAFoP/QVq
 vP0BKF+Xnj8XFdlb3oWQDPnLdjHWgSntaELbtxyNOphlIumEHtfMSLYV8LQLkkU0CEcI2JznTnQ
 VbSVffQUh4vGmO+fszzB5CaLMm46pJnSbZQMkNr5s8SOHE540Wi5+jAojuBW+AQ0iHbv4HdPUtg
 9XZhhYTpxLO+ZiJDOjg==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6a4aed cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=mLul2hC0Gid57qSl7OMA:9
X-Proofpoint-GUID: DOa0ISyLvq6hd9O_Nr1IVg5EZhj5WPAE
X-Proofpoint-ORIG-GUID: DOa0ISyLvq6hd9O_Nr1IVg5EZhj5WPAE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_07,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290144

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> index 45c7bcf69201..bc975f632da2 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -1539,7 +1539,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>  
>  	login_info->ostype = cpu_to_be32(IBMVFC_OS_LINUX);
>  	login_info->max_dma_len = cpu_to_be64(max_sectors << 9);
> -	login_info->max_payload = cpu_to_be32(sizeof(struct ibmvfc_fcp_cmd_iu));
> +	login_info->max_payload = cpu_to_be32(sizeof(struct nvme_fc_cmd_iu));

Do you know that sizeof(struct nvme_fc_cmd_iu) >= sizeof(struct
ibmvfc_fcp_cmd_iu) just by examination? I was wondering if using MAX()
here might be less prone to future breakage if the structures change.

-Dave
