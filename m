Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22159394EB7;
	Thu,  6 Aug 2026 19:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043190; cv=none; b=Bx6LaF6yvlNd5blXWKYr14pYxKnuLMKqbayqr63IKI4Z98IbrN9d50nQGRURd6A9Zcu8Vyjg80vyt7ZQHqgDOrE+l+Zrd/OcNOhSZSiBZQr9i035Ahl456MVkXNnnqc+gHVBZPXiJor6mwFbXcV1gmnKskN7I+QXjWVMFMrmjbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043190; c=relaxed/simple;
	bh=i9vB7+PU5qWXtiKpKKsFrL3CR23QB4n8vZ52NC0yfvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PdSpW28NGw63YAMnU3Q0ZE3lGwy5eaMlqmJGEEQtoljFIL61vT8HDhtuEsO4XifbOaqFtjK9QRfQnTNywLwHHSmIo9Nd2eDAqruH5jkspgSnC8/U+JPiyPMjp9DLJkM/ufpBRSGqVknSq2G8ftJyrFVz49SqQl6K0by/PnVA/uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X3oZZRrD; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X3oZZRrD"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676FtuH43037797;
	Thu, 6 Aug 2026 19:06:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qQxxFlruU1KrRs84DlezECcMSmpXzEKTE/AOOTmPYXs=; b=
	X3oZZRrDS5ZEF1u7ma82RpahdRXbfv6b3XU4ZxqyETBUE1y1qq+ndxMhEGMN+3Xl
	g6JyqTgWmcbKVJH2ToQ7XQ6P+OZ/wkd6RHzKbSSf4vdBgEl6jwUTab4/j8EEvjRO
	lULUIUMgE5iMO7dBLD7pyDuyLgMzjkOLN38rnjpZfK3dzXlciiUv1M7wVHGO+Jnm
	okZdjEI0R4RlBgVnAqZib76mPTz+167chEZzsLNXXnnn0KxsaofBxexf9V1xnTay
	yzxF6LOfRKf1A8Oniul2QwEK3dipcVi9w4dvWEpox2RI2NXAlnSNINM0a7EJnM+h
	q6CWd4JcIad3+uVNGXM/VA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs77exn2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676J0WxE024602;
	Thu, 6 Aug 2026 19:06:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w56fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:26 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 676J6Lgf011247;
	Thu, 6 Aug 2026 19:06:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fs78w56b9-6;
	Thu, 06 Aug 2026 19:06:25 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nihar Panda <niharp@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] Request to queue zfcp enhancements for upstream merge window.
Date: Thu,  6 Aug 2026 15:06:11 -0400
Message-ID: <178589207064.336697.14444308400423001582.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728044857.2532646-1-niharp@linux.ibm.com>
References: <20260728044857.2532646-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX7YN/nbUtBFww
 SCqqHsODC8bDsiO84l2arUYXXQK0GWE6byGS5cdTyBh6Q7guIU6VZcBAz9dBMP57+LVFQLYBuVo
 TDuHzbai88sckFMmSkwIEqMzYbNAZl8I1RAtgL7bcsGnbBdeuRwmGvZv6nwRjNtvT5MSqGAcGDG
 qzRxERzwigLlQxTKyFd5jTi4/JVx4QO8z330UVAXeAuRf0fL1LeWEJDW3dECK9s4aKOOdB7PLN3
 h8Y3xDuRCLMNl51nU0H0JH1omwFeAJ20FZVHB+ykMITD+URC+SUnIe3eZr3zV1ZtYa6bYNsSFKI
 TBMn6SVmYhj1J1E/ULGG+kW4rvdaVYPK4ds1WYmUdRJ3A3IPZ6hS6ZfFSlzYnBQuutA39W2N7oG
 IfQLkKLm9gBIM7jOwRYEGojlNACouexYGO+l8hD7U9k8QkySOMc3NEJ/0Osb/9XxQY1If37Wzob
 7s/fYFesReQtqj7eFPRcOsoLU6glCqqW2BoKpmw8=
X-Proofpoint-GUID: 2OoPWSrU0Pf8e30lIeB50ggFc3M6KMyK
X-Authority-Analysis: v=2.4 cv=OqZ/DS/t c=1 sm=1 tr=0 ts=6a74db32 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=gqx0BmyeMWZalLoaKdEA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510
X-Proofpoint-ORIG-GUID: 2OoPWSrU0Pf8e30lIeB50ggFc3M6KMyK
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX9jE4YpsQWtWI
 dwpO+H19ApX26RaB3H+flsftPKKgbTVeYPDCpBSghGPMOYzba1xbZdrxql9Q6uz9nIe/Gnzzm4I
 0MtnYtlsDr4mabPaVqW1CK0fTax0yxfymAocTLdX0UI6CnmXBEUg

On Tue, 28 Jul 2026 06:48:54 +0200, Nihar Panda wrote:

> We are submitting zfcp enhancement designed to improve trace logging for
> the upcoming v7.3 release.
> 
> Regarding the sashiko bot feedback: the majority of the reported findings are legacy issues
> rather than regressions caused by this series. We plan to resolve those separately.
> 
> This v2 submission corrects the single issue introduced by our previous patch set.
> Revision History (v2):
> Updated patch v2-0003 to initialize fcp_lun to 0 as per the sashiko review requirements.
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/3] zfcp: Enhance fsf status read buffer tracing
      https://git.kernel.org/mkp/scsi/c/5994844195e9
[2/3] zfcp: Trace plogi and prli within open port response as payload
      https://git.kernel.org/mkp/scsi/c/3efec904df6f
[3/3] zfcp: trace return values of sysfs unit add store
      https://git.kernel.org/mkp/scsi/c/dff03860a722

-- 
Martin K. Petersen
