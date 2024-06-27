Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDE617BD3
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 03:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719459502; cv=none; b=j16k6nnd+o29E9Sg0T5LSDeiln7YTS2GnN2q/aH1CVSLc6vfZBe9wYGutvLkhYFBIT3lZiJ0WNFQGAolMwN0+gPvpUrMrAUDtv1jzKFD48/jSarLnJNz+nw46TzhJqpFNKJGCvcIMnXrYQ3vhWMloyHwCGp6wQ7iy4AaRiuUmCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719459502; c=relaxed/simple;
	bh=Yo3F1+BMrf7JbisEmbPZl2EspeieY9oQkmud2DrE444=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LodMU+4r/m84GZe+35gt11hSQ6C6K3aK4YA5Z21yWo+vtrI40RnGOVCxArpS5ueWKzBnn18yLEoetibLh/5sDJk2jYtDVu5lc85di/fgQbDJ1i++DYdSM1NHvH8fciiQ4iGpRlbj6k5xYhZVBClMX336h/GDbiHw8B0p+8Qc9sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YdN7sf+C; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YdN7sf+C"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QLMTYo007258;
	Thu, 27 Jun 2024 03:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=dzbRSfVVQrj0TtMGplgrx3waFWwvOQemtYJBHai7FxA=; b=
	YdN7sf+CQLNTTVYG8plrgvMscFsmJC9CeUET6JZWZ521l4dVuj1V7Tasu6dmoB+h
	ew9He4VmPPnzGrBOGzSU/BHFwAnnctIf9qUbP8Br6ewUPwXT+PI81Mk6uuaedxlY
	9OIVrB2MDTyzh1JcZiognBTQpmO5erZJ2jeogC8hiXU7Tmpo9IOk0JR8YG4TctuA
	RfAIm8b2iaorGIihEOutwBgjo+3W15Abf5jU4uxg3KsnyqvJZBNEl2/Vkrku16nR
	XfLs/k+WOl1Epx/a/9Q2dtCXUW71KVxSy42KHwwUvIdD/iTyfjHAk52maHjJOmHX
	UChWbAZemyxvqCWpD8mopA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywp7smt99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:38:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45R0x26d010738;
	Thu, 27 Jun 2024 03:38:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2gb25d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:38:13 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45R3cD1k000929;
	Thu, 27 Jun 2024 03:38:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ywn2gb24v-1;
	Thu, 27 Jun 2024 03:38:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: core: Fix an incorrect comment
Date: Wed, 26 Jun 2024 23:37:38 -0400
Message-ID: <171945945209.1436848.8851365553502536554.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240612171522.2677600-1-bvanassche@acm.org>
References: <20240612171522.2677600-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_17,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=879 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406270026
X-Proofpoint-GUID: ifUBYhZ9oVBqXMpK-DK9XhREKqA7K5i5
X-Proofpoint-ORIG-GUID: ifUBYhZ9oVBqXMpK-DK9XhREKqA7K5i5

On Wed, 12 Jun 2024 10:15:21 -0700, Bart Van Assche wrote:

> The comment that scsi_static_device_list would go away was added more
> than 18 years ago. Today, that list is still there and a large number
> of additional entries have been added. This shows that this comment is
> incorrect. Hence fix that comment.
> 
> 

Applied to 6.11/scsi-queue, thanks!

[1/1] scsi: core: Fix an incorrect comment
      https://git.kernel.org/mkp/scsi/c/14d38356ec33

-- 
Martin K. Petersen	Oracle Linux Engineering
