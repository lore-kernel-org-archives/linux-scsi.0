Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51E414B06A
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 02:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156362; cv=none; b=Rjs4NZpUMR++YWq0u/YzJNDQ7FHKlRF1j17WPeW2ZfWGO+TJrDviR5VyClivIUb0YHlqBJsFGnqL8aKLgBPvEqVaM+w4Mjc/dBrVCQ/is6gMmCW1A3n7DJRk7RuprIKrFFAHFTmNl7Tb8P1qvspqFYBUcCaE/YMr/+lXqElJz90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156362; c=relaxed/simple;
	bh=p8ZztsDTQCpeHCeVlpd/KDOkE7i1LY+ilORnB20aLvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m0Ah9v7bonyLllCnDKJ0YCYoYMPWqCZXqE2FFAI6Y6j+n3n603GUS0gTgMjluU/lVr07McJEI6InomNVgqpCwao4FEVaeNbg61rs/0n1BH1PGqh5j9hTY3qJam0u1mXKeRyLZe5wSIQndj4KxEvnNeSuI3UceO26zl4ceR72xPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fUa7cexn; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fUa7cexn"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 519MHLuX019113;
	Mon, 10 Feb 2025 02:59:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=viUEa2CE8g0mHnd3kYFYLm2BYkkshpPoxm5tGq7iRXs=; b=
	fUa7cexniPSHFU4p2wWQsS68XlwMAoIT4cV3JpaPCxutAAjpbrwcsCIz9oHL54hF
	U6NZfMwZeZwYGFzJt5gT1h/2DiESJjpRJDuXspYigKQMwS8ZSLyDX8YGe42tPqev
	CS2ML6ZQcvT6Ddpa0+dx5dWV6q6nSadsRMpqOzzefBys17DTeOQbiutI6Q+cetzv
	S1oUvjzK1CY62TBR/vy4TCFH1s3THz+J8g0vrFlaXanc/Nkgoeuz5/jng+CpfVRn
	6NXMcd2fLEF73a+9FXLt2uLdjwlkhGYS0WYh3AWLi4lH+KsxDqTCyyd5bCl3Tgvg
	Mk0S3YmdSMHgGl441tJSHg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sq24wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51A2XqSR012644;
	Mon, 10 Feb 2025 02:59:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq6uaed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:07 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51A2vwAd033952;
	Mon, 10 Feb 2025 02:59:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44nwq6uacs-4;
	Mon, 10 Feb 2025 02:59:06 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, jmeneghi@redhat.com,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, loberman@redhat.com
Subject: Re: [PATCH v3 0/4] scsi: st: scsi_error: More reset patches
Date: Sun,  9 Feb 2025 21:58:26 -0500
Message-ID: <173915612134.10716.14576699038325783753.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-10_02,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100023
X-Proofpoint-ORIG-GUID: GpUP2GIhnATGMjUNroT59WmQ_XrEWNC1
X-Proofpoint-GUID: GpUP2GIhnATGMjUNroT59WmQ_XrEWNC1

On Mon, 20 Jan 2025 21:49:21 +0200, Kai Mäkisara wrote:

> The first patch re-applies after device reset some settings changed
> by the user (partition, density, block size).
> 
> The second and third patch address the case where more than one ULD
> access the same device. The Unit Attention (UA) sense data is sent only
> to one ULD and the others miss it. The st driver needs to find out
> if device reset or media change has happened.
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/4] scsi: st: Restore some drive settings after reset
      https://git.kernel.org/mkp/scsi/c/7081dc75df79
[2/4] scsi: scsi_error: Add counters for New Media and Power On/Reset UNIT ATTENTIONs
      https://git.kernel.org/mkp/scsi/c/a5d518cd4e3e
[3/4] scsi: st: scsi_device: Modify st.c to use the new scsi_error counters
      https://git.kernel.org/mkp/scsi/c/341128dfe10a
[4/4] scsi: st: Add sysfs file position_lost_in_reset
      https://git.kernel.org/mkp/scsi/c/2c445d5f832a

-- 
Martin K. Petersen	Oracle Linux Engineering
