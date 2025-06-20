Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F68801;
	Fri, 20 Jun 2025 03:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389620; cv=none; b=GRjoFTmqjx4yWB+eIg3OZ/RtSQjf1kfdaf4vsXwq5toijFgmEQsuEYC69MyFqHjaa6p6fXPNau1v1tjD9ogQyNDnvbRcYEpYsuIXKWi040qhZrozQWv805uph32o0nEIhtYMCghZOLBFJAfgGt+AeQDF1RlzoXBdguqEEPaVNow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389620; c=relaxed/simple;
	bh=FGLegPBeZc51NG7tc5zTXJlDczf81jielwYkLOFDaZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4D0vvU7di1MFw29JPjUozb5oXX8+ryWh5EVHs8piTJxs6Pz3lPDiBA2FBU04dvptn1x90xl029ej3+OOobnKIlt/vVlvPHAdF3+/E6O/l1wekUVWba5/62Q4e/SfG1megnYAknZLbX7jXigH7cwOIoYwOBS35vnqqLDAK6Qg6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c2x8uxnK; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c2x8uxnK"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K2u584018391;
	Fri, 20 Jun 2025 03:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=R9ljl7iX0riG6nr1xVc4bm09V/rwVMsqYs7/6lM/aH4=; b=
	c2x8uxnKoY6LJU4G8XqwXrnJ7U8fGQq5JjwZlzZDnMdKitxXWNEXCeViPZyOF7bh
	OctarDnjz8TVfr8AeGERQTwFSD3lcoAgFsdiVeGrFLuuFwb2b2lWb0CBV148Kr0L
	P7LKTB0h/vikLw0S4xKDnoFpjty08SiNY6Y/10LXXa1dvzwbtV4/MxY/3bNobyXz
	kkAX+R8sNhDJXwRddFy2yE2tADqJxsDYH+j/Wy4puBzOj0cb2AMEzC+0lrWbNAdh
	XnDUmY9Xycs7+9iEA9DKZnHLN8NDtOmFAdBZ7LFy/Y8Oy+OnzyGfq4lkzwRfz4Nr
	OIQOwNTcNkFbGJk8EJCwEw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 479hvna91d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K1Cctx009647;
	Fri, 20 Jun 2025 03:19:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhjydhb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:08 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55K3J7oP002814;
	Fri, 20 Jun 2025 03:19:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 478yhjydgj-3;
	Fri, 20 Jun 2025 03:19:08 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Yihang Li <liyihang9@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Don't use %pK through printk
Date: Thu, 19 Jun 2025 23:18:38 -0400
Message-ID: <175038845869.1665414.6330710566460469653.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250611-restricted-pointers-scsi-v1-1-fe31bfbc4910@linutronix.de>
References: <20250611-restricted-pointers-scsi-v1-1-fe31bfbc4910@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_01,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=800 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506200024
X-Authority-Analysis: v=2.4 cv=XeSJzJ55 c=1 sm=1 tr=0 ts=6854d32d b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=_ym-YgABFaPYJePyZlUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=ZXulRonScM0A:10 a=zZCYzV9kfG8A:10 cc=ntf awl=host:14714
X-Proofpoint-ORIG-GUID: XDiBK_qPFwaLTQhnJyzOXpKPLERsEOi2
X-Proofpoint-GUID: XDiBK_qPFwaLTQhnJyzOXpKPLERsEOi2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDAyNCBTYWx0ZWRfX+scp1wmi7JWq fSVlyXeAODTh3PYvTpoN0c5NaFhek2NLe/RfVBMXTRm8v04h4Q/urBCsPJbVWrmtxOB2ItJy7ml EPm5J1K7dghur7szToPE3gGC76b1FnbbsR9WLIlZUPnSzetPKCCpp3xRvRdofjcDVwm/Cerdymu
 vgZNCqoBzWo+Ar4R73FUkolFmJclQLQ9G4tMfadSwqlWaM6cO80dfELOH6Cy1u0qLd7simWjVkW jSUKLKZ9+8plRICD6vNAkgVGiY5DVfRnAHtvjeqsIg+Lw7d5vtagEC2E1qyTzVzhImFgF7e84Z2 ymLjyAVR1Hwngz73OGEMJY1NNS6a9tArz3clxwo9Pp6mkskOEZdppQBF2T8sqqHaiqxjUXiwpbj
 rZ1VVH1q758nRhdqYOYleyMpYqynJSfbK2erQqmP36pqYRBWoIek1fpbSVaw3ogc6geNl40D

On Wed, 11 Jun 2025 11:58:06 +0200, Thomas Weißschuh wrote:

> In the past %pK was preferable to %p as it would not leak raw pointer
> values into the kernel log.
> Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
> the regular %p has been improved to avoid this issue.
> Furthermore, restricted pointers ("%pK") were never meant to be used
> through printk(). They can still unintentionally leak raw pointers or
> acquire sleeping locks in atomic contexts.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: Don't use %pK through printk
      https://git.kernel.org/mkp/scsi/c/76549adb4260

-- 
Martin K. Petersen	Oracle Linux Engineering
