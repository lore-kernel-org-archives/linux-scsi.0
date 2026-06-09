Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025FC3451B0;
	Tue,  9 Jun 2026 01:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969159; cv=none; b=qiHz5U7iCJGVFbLvRQnx7j+Nj1bn17lxBpeBdZI6gPa8ZXAQpFDTC5xKWFQm58bCZAweHryIm1lL8Xf2D7F425eOUSNSgJ1OOP6F2OB5VUBWjSBou5OfUeo8hlMIFHGnVXNS2+8MswG44sXv7JQdGHSHFiFKjAeTvNvIBFLo81w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969159; c=relaxed/simple;
	bh=1kdh05oUZnrMYesFpmPaqAMUdoaK9F+GU3VXJmbVt4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TWPWJb1XxtI0HPnjUSf4ursTr1gCS32+rk+CljWREdRZGIWARXc4qqFoj8l19j+5+uj852/M+xlbhTiH+7PMpBltC821Yr0OxvBPcsLXrgRADXerkcznzjcrEy7xhBYDP/6fKFNE7WiRrngZdhpYt7xjKdU7S+lZZk7AcM0BWcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pwTWV70F; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pwTWV70F"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSdNW3977595;
	Tue, 9 Jun 2026 01:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ls7T/VGiRIObURzyCMRzp52ZS0QqSn8Qkzqtt+6kfKo=; b=
	pwTWV70FKJvokxccZvqmsUEclxkntnQaH7PbtCC2kEQVfOg61TcKcnJO+yNOhRmj
	rBfbGLzb9yWIi3dkJ3b1XdUirZxAWTpAVp6XyqgOCQWk1C7cQ49EQDdq8jrnhXho
	BkvvW+C8yHxH5MvbbtlrGYG6KBHNeq8/bsS5x91YV+XIbKoTzofWvkgmPwAd3H8E
	eUyRGUrLrsitIJE19+LHqKzanjHz9RffI37bfZDedvVA2dmKGkrP39biVHQgHSeP
	6AJaGqxkXoBBc2IxY8dEJ44VvuplEma4b4x4IKRYhwpyrzTN17C2Yxnth5w7Z7Dn
	GivUp/mSPExAqQt8jI4KoA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embkjbg67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591caxZ028075;
	Tue, 9 Jun 2026 01:39:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pgesh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:11 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6Av030153;
	Tue, 9 Jun 2026 01:39:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-10;
	Tue, 09 Jun 2026 01:39:10 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: turn lpfc_queue q_pgs into a flexible array
Date: Mon,  8 Jun 2026 21:39:03 -0400
Message-ID: <178094912080.1810714.11290926888041989689.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260523050241.190239-1-rosenp@gmail.com>
References: <20260523050241.190239-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_06,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=613
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX747Pmg0claBL
 rnVitDsZcKAfmb/Xj87ACdNULkwmBeo+CW9j0eW2M/Dzqz0A7UuNjhu+R6OaZZO26FQlftJeqjD
 5Cp8/niLk8P6r9Uw+k42aeA3t6YRIgsycZO5PTikG4SFNR1VKsleOZTwcVIULE9afiKxXMCmnLm
 8h/T/T1w9HVixEwskUQ2NdmcG8RtVbQlWYNV7We9ycQB+r3/xda+rQnBv085M5ny+tKLZKCAmWg
 JSsMbApRiOSj160BPlkWLysDjX15hQm2WXlkt0a1qyCkk8ufQdgaihoT7rGThvHX2mZPSx8xVTu
 23yGd79M/tQXrdVvPvGIMbe2DNfxmAhbtLcF29+y+2yaZ1PmG5TY7SZX1JyBm7OPept0K2wrEzj
 11q3mzeuJW8/4R2Gjrhq9gqXlCmPOA0OaQPcfyUm2R7FfD9WPxXNd4nSoCukCeI7u6jOo67wdGG
 OfBVxGDTRTcvou7IiFDP5zmnSFmO0p2PyMu4eBU0=
X-Authority-Analysis: v=2.4 cv=ROSD2Yi+ c=1 sm=1 tr=0 ts=6a276ebf b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=2RsxlQ-sr0inMoi1Lx4A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: rECqdL3WdwyfQYY5IKJoFN6pxKpQFofR
X-Proofpoint-ORIG-GUID: rECqdL3WdwyfQYY5IKJoFN6pxKpQFofR

On Fri, 22 May 2026 22:02:41 -0700, Rosen Penev wrote:

> The q_pgs pointer was assigned to point at the trailing memory
> allocated past the struct. Convert it to a proper C99 flexible
> array member and use struct_size() for the allocation.
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: lpfc: turn lpfc_queue q_pgs into a flexible array
      https://git.kernel.org/mkp/scsi/c/056fca1f276f

-- 
Martin K. Petersen
