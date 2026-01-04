Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8DE315D2E
	for <linux-scsi@vger.kernel.org>; Sun,  4 Jan 2026 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563015; cv=none; b=qnLelCNLtDiT1MCEqP81/w1BP1+M8SZDBSsiG8UBiMHfkHoKT70InALgAtkB/S6DYKkTGRhTg4DkI7My0qFeCyKUYweBVyN3Q8cIfNDf0oKBxLbBUCnrFo7xQhfRxcUtprtvi7n6qG8N/2YqahXFtQXRPfLuvXaFaxhbA/MtvW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563015; c=relaxed/simple;
	bh=pBAenyUl3U2NYRcbDIuD1TRbYu4ypf1CozxPywywEqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUHehf1o4H4e94yPRnFThj5LqJfvs3DfHBxJnQUHcA0+wq2wSJZgjNiVXAkAwEFvQ74b77+veaYDtcXZ5xFw562Fwrhk4IwLXrS4yHV+Xr8Wgcz+EnsBwNPMLV18rS3BnJbX6TtJhfWuH4EBLGRGOxL6svndHHsDqdQjVZdAW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CvkcLNbz; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CvkcLNbz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LhSHn488499;
	Sun, 4 Jan 2026 21:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JKoJrrcEvKmSNjA/ekGKoi0UcoOi1rZYl3ewN7YrNV0=; b=
	CvkcLNbzBAfJ3a0V2xk3pRwyVud0AQun7Nox2Bl/ZhUBdKeAAK9/1nuVtQfbzg34
	FLm2jGN31S1wba0YSgfLHFZJwnWRGhh+udSYieeN1sX7Qo1kFkYWmT2WUWLw4mv0
	pmt3IR2fIDMXTUsvMrVhxx8e8kqLhnzOyFgBmMuX3iUE+TE0mqIr0IEELfnncSRN
	LHMuwKvHh9sRaCWRvxHMyJw0GSObSlCyBnhDpz41Kxr+QPmmj2Vspn0+Ydhvrc1n
	gbZUjszYSRNZAO+X1ZKTSiNP7UY2EyXORmo11PC8DJrkenNM8TZN1BXReAYt96TV
	E1NNXIDi3fhbzEelcSGJsg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev2jgyp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604HCn5o026776;
	Sun, 4 Jan 2026 21:43:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6gbh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:29 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LhPoV007658;
	Sun, 4 Jan 2026 21:43:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4besj6gbf9-5;
	Sun, 04 Jan 2026 21:43:28 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
Subject: Re: [PATCH v3 00/12] qla2xxx: Misc feature and bug fixes
Date: Sun,  4 Jan 2026 16:43:11 -0500
Message-ID: <176755562254.1327406.286512489078885188.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com>
References: <20251210101604.431868-1-njavali@marvell.com>
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
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=844 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040200
X-Proofpoint-ORIG-GUID: tkwe21Mya5Ouyauo83KdHo5FAF6KtaDk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX0hiJ7Iijt0nL
 neTsKhAAsvVWarw0H82zwwqHCMMUduI52mKUxpGdh9HtJriRm4DSz4ie7pNiVViYkSPYWfxcuDP
 nU7uQd0tvtEfrf2KHRdolaBIvTsACYiJ/aqN6+yhAyT0LFHAd1B6RCHmduZSuJ9S18vWSxNCgya
 LA8lxRn59QaWo5pJ5FJPInGWLo6pFMBAMmrUZrl0Cx0oAX8DOawSFImg75mER/ps7IWKKErhIWX
 LQs29xKlPzNE3nUpSuqBgjpk63CXIOW6KjOtsmxbkOv6HRFfo0TiIPeXpTpmO/vFdYclIPvknMM
 KBQHW/JQwCZGHmyBKsaPl82s0p4eE0GXu3/aBwvInLMtspO21eWo9X9f8zL6OvV1JBeqvMwhrPZ
 baociuPFl+1w/boUJw+wSemlujul+lOzW0WrxANYDudS1bz7HjK330BTEmxsnFghRoMFtvdMAuY
 Isvx4Z8OJtq8C3SK8OQ==
X-Authority-Analysis: v=2.4 cv=A9hh/qWG c=1 sm=1 tr=0 ts=695adf02 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=IC-FnDaXC95Psb3S0A0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: tkwe21Mya5Ouyauo83KdHo5FAF6KtaDk

On Wed, 10 Dec 2025 15:45:52 +0530, Nilesh Javali wrote:

> Please apply the qla2xxx driver load flash FW mailbox support
> along with miscellaneous bug fixes to the scsi tree at your
> earliest convenience.
> 
> v3:
> fix warning reported by kernel robot and Dan Carpenter
> v2:
> fix warning reported by kernel robot
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[01/12] qla2xxx: Add Speed in SFP print information
        https://git.kernel.org/mkp/scsi/c/7411f1875a60
[02/12] qla2xxx: Add support for 64G SFP speed
        https://git.kernel.org/mkp/scsi/c/21ab087cae50
[03/12] qla2xxx: Add load flash firmware mailbox support for 28xxx
        https://git.kernel.org/mkp/scsi/c/b99b04b12214
[04/12] qla2xxx: Validate MCU signature before executing MBC 03h
        https://git.kernel.org/mkp/scsi/c/478b152ab309
[05/12] qla2xxx: Add bsg interface to support firmware img validation
        https://git.kernel.org/mkp/scsi/c/d74181ca110e
[06/12] qla2xxx: Allow recovery for tape devices
        https://git.kernel.org/mkp/scsi/c/b0335ee4fb94
[07/12] qla2xxx: Delay module unload while fabric scan in progress
        https://git.kernel.org/mkp/scsi/c/8890bf450e0b
[08/12] qla2xxx: free sp in error path to fix system crash
        https://git.kernel.org/mkp/scsi/c/7adbd2b78090
[09/12] qla2xxx: validate sp before freeing associated memory
        https://git.kernel.org/mkp/scsi/c/b6df15aec8c3
[10/12] qla2xxx: Query FW again before proceeding with login
        https://git.kernel.org/mkp/scsi/c/42b2dab4340d
[11/12] qla2xxx: fix bsg_done causing double free
        https://git.kernel.org/mkp/scsi/c/c2c68225b145
[12/12] qla2xxx: Update version to 10.02.10.100-k
        https://git.kernel.org/mkp/scsi/c/1732d10fa7ed

-- 
Martin K. Petersen
