Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8324052BB;
	Wed, 29 Jul 2026 15:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339074; cv=none; b=ZWSLiiy3Z/yJLeAWKWC8wgEvZtaKDGKZhU2e0ONcDmepb6DKJsd9Twh2NrX9D0rynqKrHkeBPA2uXOXfW1GrDNhK9sqlLHfEO5Q0b26QB4wh9rLWIj1tRtWwbNORQkxHWpsMX0bPOtb1mPcshPNkfSfdDGx8w04D8AjAYDFQgt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339074; c=relaxed/simple;
	bh=SGV0nBH0ycA88DZJgYKqI1BIJPDoY8trkRsL3k4lhYo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=W3Qia3IeSnkzX+TezREH9HjX16h/iLmScoDVTVkHrQuim8ZTKiBjJaOehXYMu+tRRyEXykGjWHhVixOAPBLhD+0cwD16neX8Cv1R022ZK0lhtzF4ibXaM90b0O0vGHBrE/0mXHNfaMGKZNrIPy+zSj1AX192CPdgHC+H8NdGLoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kjR7awZL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kjR7awZL"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TFHiq1388692;
	Wed, 29 Jul 2026 15:31:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=TXNtouI2/kjXBOGr0rrJbukRlIxoFm
	SurD605eyLn1E=; b=kjR7awZLpJwAvIeSqu9+YEfUtfVqBdJ8fv7GdEyCCtjCyV
	VncR1Sios1t2htysmpbw7r9+ogDfihRoapjfoPDjhMjPk5LyChm5LhUS34halDPr
	Rd+UujCnUDteOjkZ/gYAjP0ForfMimIl/X8MxOkqIBkJeH71i/3c+85an/tcvCg/
	vfaU4gQDe8XOMj3OtQA6oCCI2U8J2fsqwThqb7m4RWrlXzxo+gROb/SnxTxRdDXB
	9TweqH3wT6O48SGTen3hRMk5nra6oua70hPg/GdKVzzXYU0We9iZSoPDx2POffwT
	5jhBTqqOUKR3eigsjvWDUVSVfb6/5AfZMPxMrLwg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0xuenf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 15:31:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66TFQPrU002264;
	Wed, 29 Jul 2026 15:31:05 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn7fqffan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 15:31:05 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66TFV4c950332156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 15:31:05 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A076D5805F;
	Wed, 29 Jul 2026 15:31:04 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D625D58062;
	Wed, 29 Jul 2026 15:31:01 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Jul 2026 15:31:01 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
Subject: Re: [PATCH v2 11/33] ibmvfc: add wrapper to get vhost associated
 with a channel struct
In-Reply-To: <20260723000149.969416-12-tyreld@linux.ibm.com> (Tyrel Datwyler's
	message of "Wed, 22 Jul 2026 17:01:27 -0700")
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
	<20260723000149.969416-12-tyreld@linux.ibm.com>
Date: Wed, 29 Jul 2026 10:31:01 -0500
Message-ID: <878q6tvmmi.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kpRXnzlSIhLNxpL90Gc7sP-0VGBbbBob
X-Proofpoint-ORIG-GUID: kpRXnzlSIhLNxpL90Gc7sP-0VGBbbBob
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyMyBTYWx0ZWRfX44gOuq1ekcdW
 OM3GQXqz4Rc+dIoJRgUDLDIF4aqhLC32HpIIOPrvqa0ZUoPi4iezEnpPl+L4Seu2YVrDM//e9/u
 Ynkb8dTjJyVojAkW6kmsStGOiX4kuoY=
X-Authority-Analysis: v=2.4 cv=dYuwG3Xe c=1 sm=1 tr=0 ts=6a6a1cba cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=oCRRynCBdLGUAu8-UfIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyMyBTYWx0ZWRfX8F0D/yNyKESy
 ca5SXopSlRVTGIxG61lfAAxLbl96UlqVDi9cBc1bkAR4BT1q2xW5Dw5ZeUyQfBo9LxGHyrnxuSH
 Ok6XYbyBgdnFmLHEj5UCGoAzpeLS/5qaTtyG7bLTnx4CtjbsrRzsDVbS3dWkmGzx0B+F8Dfnt2a
 s6PFtffuNQ4TIChec2sDpFVV/bxww/0odS0o9tTEEtf/8MG1psaxOCvnIO9CaDtj40l1WVYk6wN
 2jg4O56g9EDMwGw26VSI58qGbhEhq0ojnF4XzxqrD+SlIq2nr6DcSgQXOdeVdGdMDvWu95+nZiD
 9dgubolvWtvMos8pB3+lfRfyEP7KUv7UBpNImspl/VBt550HftaSnXN1IuyOwNIVwA917afJ4my
 E1Xgo3nyqacS351laZojw1f33V2cmz1Hkujp5i9+ZoNmDCE2eqdz6uTFqZaV5CMeihBZwmFVxI7
 K1ezAayKHgDccD1EMJQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290123

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> +static inline struct ibmvfc_host *ibmvfc_channels_to_vhost(struct ibmvfc_channels *channels)
> +{
> +	if (channels->protocol == IBMVFC_PROTO_SCSI)
> +		return container_of(channels, struct ibmvfc_host, scsi_scrqs);
> +	else if (channels->protocol == IBMVFC_PROTO_NVME)
> +		return container_of(channels, struct ibmvfc_host, nvme_scrqs);
> +
> +	return NULL;
> +}

Nothing wrong with this, but in looking at the definition of
container_of(), I see this:

 * WARNING: any const qualifier of @ptr is lost.
 * Do not use container_of() in new code.

And there's now container_of_const(), where I see this:

 * Always prefer container_of_const() instead of container_of() in new code.

-Dave
