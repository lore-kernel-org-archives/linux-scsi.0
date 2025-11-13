Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D000224245;
	Thu, 13 Nov 2025 02:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002040; cv=none; b=WJr7kWlwMypUimVDBTyhCZJjvj2Qp6gYfxdGXO01ZRQk9f9RfGvwzSYOCvzn56JSy2LdElfXMk323VglxfzJVOkDT7j6F6FOHYR7XoWw4aTT/w/xWZBCrz6QHfxSX5/gNmygC+HBmGjjMJKDHvJWWOubSUeDM9QHIU9K125EsG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002040; c=relaxed/simple;
	bh=QJUJUhYsydM4+WvY46cXM56h2+QxTeXQUcK0oykjkvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fhxTVPdY/klQwYK9Cn1tb9kU6iTcQNKo5kPzelOaXUvtgCDBfyMsWMSvL+3D2HgzKXwXitson5PipF+qq9Pqhlwvqhpibp33KIjAMZSQgXM0ZNBiVGid6NHEfXSkFpC7bB4Hf3ukKpaDWHHL6StGHyZTmskh4LRqPvgYnGi6+0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JJhrlMFZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JJhrlMFZ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gR8H019397;
	Thu, 13 Nov 2025 02:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rBMramPaAnoeJ4wPSmO3IpWNBlWzKqg8QgHEVjYebfM=; b=
	JJhrlMFZcAQ/ZvDebHiuvNswdtDvAElhuMULEugKw1CA+0lK/pT+tPPMTQCtXvPM
	R9/zaH76QrNd6xhxUh0heG/VICgG9GYKrqPqwGLWwdJZYzzPrqE1h9h7Bf77/V5a
	mEDAX5U+Jn1Jp66pCwPGYTPL7ZB4v5HlhoCnkpMQFAHOuEMY9Q/ubf912JGcp/0g
	b6X2dcZM014DEfMxkfR0/NVyDSGOQmrEVMdboVMA40mIaqx6YmWgGgf0FSTrNMJL
	D830se44cJx/h6uyOvinZOG7J5Tj01TAvnjr4wb1O0pvn4hxsJWdNhwNhbRjRoqR
	MvJwM8XbqkblJji4QMQiFA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyjs8rww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0t8c5032426;
	Thu, 13 Nov 2025 02:47:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van9qd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:15 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AD2lB8R038323;
	Thu, 13 Nov 2025 02:47:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a9van9qab-8;
	Thu, 13 Nov 2025 02:47:14 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Haotian Zhang <vulab@iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: stex: fix reboot_notifier leak in probe error path
Date: Wed, 12 Nov 2025 21:46:57 -0500
Message-ID: <176298170700.2933492.1775430303064106936.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251104094847.270-1-vulab@iscas.ac.cn>
References: <20251104094847.270-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=880 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130017
X-Proofpoint-GUID: srz490qii5c8YqXSBGzYDO0xdr270Je_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0OSBTYWx0ZWRfX/fxeIEw1iHqg
 K9Yvw3ysaVEm/kOe0XAIzGfEX2cNnI+ot8rl0wrqBHQF34J0RCn6kFJ+Z3MEYIulJ2sPKA0DHcJ
 RO9zmKuv3jVeAedIUmWOh+U/miNUAQpJbDgnOjaQCbmHylgsTM40Zg8PJs4Pk4YVxcgV4NJuB7a
 5vO6Tl7+DLt168WArcgb1BWSFYmZM9N1T6ZZg0bykrKKS8fWo6gWo1qJmoQxmDHBA++HrFb/RZ0
 T3T1WQB3hYAvy+NQf2YWXb97PcJAqKUTZIFFEYvceLBT8la3at+nkDv3eWkFpMtfUZDFffl1evP
 1Lq0H/EzVoqOM1dAvopaDiCTyo62dg4vaPdW+wpqTC6iNygGVFlgEXvtYrCpdgahRDvb35efEQ2
 otGWjBe9BuVyN10ojAwvFisNmQjIYfzuMvb8drbm17X8TE24Roc=
X-Proofpoint-ORIG-GUID: srz490qii5c8YqXSBGzYDO0xdr270Je_
X-Authority-Analysis: v=2.4 cv=HLzO14tv c=1 sm=1 tr=0 ts=691546b3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=bTsIed3PDlPYtXLHKZUA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12100

On Tue, 04 Nov 2025 17:48:47 +0800, Haotian Zhang wrote:

> In stex_probe(), register_reboot_notifier() is called at the beginning,
> but if any subsequent initialization step fails, the function returns
> without unregistering the notifier, resulting in a resource leak.
> 
> Add unregister_reboot_notifier() in the out_disable error path to ensure
> proper cleanup on all failure paths.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: stex: fix reboot_notifier leak in probe error path
      https://git.kernel.org/mkp/scsi/c/20da637eb545

-- 
Martin K. Petersen
