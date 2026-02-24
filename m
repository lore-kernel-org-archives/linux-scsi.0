Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260783A9603
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 16:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951716; cv=none; b=ZPGVaqD/JMXKdF5Vi/c9YvROIBBnrjOyIEidGHzzOTFt+dozBM3saWSVHlPGAhTsXgP67TxTleuYOtdyekoxBmTCxtgVOWbpljaHl5nuLud7nqPjWnIQc3FRmnk/zgZW9RoyZixCNR0nsHTQtQTW2v4oFw8KHSy1Ct4uWifrhxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951716; c=relaxed/simple;
	bh=yPx4QTowzbIXTjxX18DFy4HW7+5u4cJ2NP2Gq/is/qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GhlhycOIFDu3GSeTCXBq819+SVB/Re/69EEaOZDauB6Uu4EWlwK3o/axDrBmL6zh0Uzi5WRFr1Uz5DOh/XwebiRZRlWiVoiDIhhcDEhllR6oh74KlMVnvcY/1CjHsD37iGAmfYlrCZLczJ+AitMk1610uAryFN1EKujsyk1J4cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jmquSe3A; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jmquSe3A"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMooD255191;
	Tue, 24 Feb 2026 16:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FUpLX3qWgzvuEoqbp0QBQX246qCBfLx1xBoVWKXY5ME=; b=
	jmquSe3Ad88Nt9ZvtoAZVYBO7bKJoNNb7gk4qpP0VBjaZ9fkHdjmLxTlpJFFdkQX
	lU5pUZ3lEOtY9MSYY6QRjlIjJy3bPYHiXkUBzDKsk7fYREtMfwP3kJJovkMufGca
	Af9izRSc4XT8S/bxv1ZAYvSQa/WeUJMsOdgdyWqoD7ouR8FMNf1jboQNE3AcLsG1
	nWGtU+J4t1y5xnVBEOAVB3CtBHCrBe04uo2y5k/0gxuUGTmiPz6h/CT56QjY7PGQ
	RxzyiOiAQcKwnsdbH5OaF1NE8Sh9eQbRM7CuJJvymkEG5Iu+J2ulHjTL9MnlbQgu
	lcB9gR08/HssgHNLVCFU7A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b4kye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OFUo1E015693;
	Tue, 24 Feb 2026 16:48:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a6m5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:31 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61OGlt4r012936;
	Tue, 24 Feb 2026 16:48:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35a6kjb-8;
	Tue, 24 Feb 2026 16:48:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, djeffery@redhat.com
Subject: Re: [PATCH] scsi: ses: fix devices attaching to different hosts
Date: Tue, 24 Feb 2026 11:47:47 -0500
Message-ID: <177195161181.1154639.11320674499548449858.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210191850.36784-1-thenzl@redhat.com>
References: <20260210191850.36784-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=874 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240140
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699dd660 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=xfLj1nrCPGUbdxv_uVUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: F5DJQC2PbQnc6yukVHqhdj3-h7c5xIxZ
X-Proofpoint-GUID: F5DJQC2PbQnc6yukVHqhdj3-h7c5xIxZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE0MCBTYWx0ZWRfXy5VF7ZVpqnFR
 Bfb/8y78fMz56CYH9TynLBGlPbF0Z737/xtRPCJwH7KXDRzqItHaZnj9MsV9rCz7KcE9eVK4wAS
 uWaGS+YrVOj9J1lEfx3z/ET+G2Ie4tczl/XCms+0trQ7x3DIcUzx3JIvOiMIBse6hLORwf8mgzY
 B4mm+3L/JFJgV4Tt1vU8boGqilNO5OPAaB1ru30DpS4pYRXjSSpkyHJXWW8uYXR7zYFjnrwzXfK
 M90G6bH88bxMbhq0rd5dC2ByCnNjIyJ/xHiSW/JEqfFK0syDDMGiA3kKesgiIqEH8reL48EIghQ
 4LzeQ6lvwinRb2fvw6dA88+54Ue0ux2JW+i8w8gZqmcZPQR7DPqa0wxBpL6IjESNzbyiweOYmBP
 5uZQdbVHzT5+Xz99jpv2XL94HXeOkrtQv9SBVev1NvRQIFMfaa4l5EN0Ka5yhjPIJDnn4A0affW
 qMMjZfcWig8ax1r2rlQ==

On Tue, 10 Feb 2026 20:18:50 +0100, Tomas Henzl wrote:

> On a multipath SAS scsi system some devices don't end up with enclosure
> symlinks from a scsi device to its enclosure. Scsi devices which have
> enclosures linked to them are linked to enclosures on different
> scsi hosts.
> In ses_match_to_enclosure is being called enclosure_for_each_device which
> iterates over all enclosures not just enclosures on the current host.
> Fix this by replacing this call with ses_enclosure_find_by_addr.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: ses: fix devices attaching to different hosts
      https://git.kernel.org/mkp/scsi/c/70ca8caa96ce

-- 
Martin K. Petersen
