Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DB813AD1C
	for <linux-scsi@vger.kernel.org>; Sun,  1 Mar 2026 02:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772331401; cv=none; b=kB4xr5j3zhOw001KSRsf1SSQDDhVUNLzr7FNraqRogMA/Tr/vBck9PCWJUn8/fsLUWNIkLgjBAmoUSn4N5Q2oxFEdE0jYAwXkJ7E0TDfTPizB3n2ZVXYBl1PNUHvfIsarvRaGHfddddsJ47XBneTLAal8Mx4r0vERw8kgjZ0jic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772331401; c=relaxed/simple;
	bh=oCsaYnTTUzxdHud5LggUSGydBv4/zQIDrCchkmlHZW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOQbn/dFrfDi6ZrSa0bWFtnzE3BTZMdiu2i49UTOohNlWTlqzIFBdQFLczEGMYS9W80oF4hAn2isI9OMsTRgQUv7cVVxH8X2q99cfWmdqrd4Q2P1BQIgRBvCHyiuAKMR5IhYVWe1dw5sZoxT5N3KP8ZK9IWbBr19bRjZx65xX8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SJXnpfTI; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SJXnpfTI"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6211vFbc2001883;
	Sun, 1 Mar 2026 02:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E5Z40bfTa0h/OqvIAWFFcrfk1aYZASiSQ+vUL+AZ35I=; b=
	SJXnpfTI9M9b57VfQc1GKQHxDO9d3QZWCORHt0nRF5GZPOSfT/P+xMVraPJlclbO
	fEgTGEqq+gZ451TtH63GcbyLjy9tNFi3J8SbczE8MEL+DiwymWChrQ6Cq/tm6SCH
	AqGU1RoryjRRGEmHtiTZtNVoHp9T4Ezk2R7x+9HWU/UEKmvmxeLbU6tQRD70psvS
	nPiAlTz49Z24bCSeNiA0slHjbYN1B5HejjryXx847BinKWkz/ms6Q7fB7r+cmuGX
	LxctgRZ+fhfpihk6eg/OaXDpPZmeFXjuKK7iDcHY/xn8OieyFsdXGsj+RNT+G8Br
	cha0EAk3QTbQqVwP99UxeA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksp18qgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:16:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SL0h6q037067;
	Sun, 1 Mar 2026 02:16:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7ehfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:16:35 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6212GXsw019643;
	Sun, 1 Mar 2026 02:16:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4ckpt7ehdg-2;
	Sun, 01 Mar 2026 02:16:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart833426@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/13] Update lpfc to revision 14.4.0.14
Date: Sat, 28 Feb 2026 21:16:15 -0500
Message-ID: <177231727955.1778274.3490259535072252193.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
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
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603010017
X-Authority-Analysis: v=2.4 cv=KcbfcAYD c=1 sm=1 tr=0 ts=69a3a184 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=eRhhiKW_uzDJ5QdGn9YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: L7DwinpMuzH52btVa8ZAtIpXAEoXwX3y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAxOCBTYWx0ZWRfX+DZkQwLIYwF1
 04lLsuLrnFtfnpYw2usDY9s3/8RG0QNlSlyoj8+lcoL4jGt7Zs6u3kdMOnXIwy1QTXx3zQQFLtZ
 ZceFcKo6vFnyWFYLw4kMFfUFQmsyVFQMTQwzvY5HB5FZvQKxy3+W4AjP9baOzxpbu6gVnxzsM/U
 x/1MLnlCqdjuPX4D9ZuV6MR0dqvxfRlaA5y59KGS5MD3seqyEy92A5LiEhMFT3ZQt0OVR2CBkUO
 bNdvbvt3mKcq13BKQmmfHxXui0trIP0eq0neII1cCrrOzOc7eotYGSv5cyXz2vVd8Iv1/iF8psW
 zfJTQSFk+mrD/flw8Ej2KS08bcL4h5290JEZbBA1JxXOKT/P+Y1vkCvN0SKiACVcOCYbk5VSRzL
 AHxzPhSJiVkz3k3pS+YGrIzuxzKqh0z1rWZn942rCgxQKM18ibTWXxkIDFMLeBeOn1hYazsMjq+
 tGWwsw2ZCGIA5JenNkQ==
X-Proofpoint-GUID: L7DwinpMuzH52btVa8ZAtIpXAEoXwX3y

On Thu, 12 Feb 2026 13:29:55 -0800, Justin Tee wrote:

> Update lpfc to revision 14.4.0.14
> 
> This patch set contains updates to log messaging, trivial typecast and
> pointer changes, bug fixes related to kref accounting and cleanup handling,
> an update to a WQE submission bitfield, and restriction of first burst to
> specific HBAs only.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[01/13] lpfc: Update log message when ndlp kref get is unsuccessful
        https://git.kernel.org/mkp/scsi/c/8ecb3ec244ac
[02/13] lpfc: Log discarded and insufficient RQE buffer events
        https://git.kernel.org/mkp/scsi/c/b4082ac8e62c
[03/13] lpfc: Add log messages to fabric login error labels
        https://git.kernel.org/mkp/scsi/c/5f442e54e9ef
[04/13] lpfc: Use min_t() instead of min() in lpfc_sli4_driver_resource_setup
        https://git.kernel.org/mkp/scsi/c/f8c599ad90f5
[05/13] lpfc: Reduce pointer chasing when accessing vmid_flag
        https://git.kernel.org/mkp/scsi/c/70b468d41b82
[06/13] lpfc: Remove unnecessary ndlp kref get in lpfc_check_nlp_post_devloss
        https://git.kernel.org/mkp/scsi/c/f6bfb8d14933
[07/13] lpfc: Cleanup error exit paths in lpfc_fdmi_cmd and associated messages
        https://git.kernel.org/mkp/scsi/c/6b0bcf4b6430
[08/13] lpfc: Fix incorrect txcmplq_cnt during cleanup in lpfc_sli_abort_ring
        https://git.kernel.org/mkp/scsi/c/2da10bcaa58a
[09/13] lpfc: Add clean up of aborted NVMe commands during PCI fcn reset
        https://git.kernel.org/mkp/scsi/c/559a6c2ab097
[10/13] lpfc: Update class of service bit field to 3 bits for WQE submissions
        https://git.kernel.org/mkp/scsi/c/9714c5463fd1
[11/13] lpfc: Restrict first burst to non-FCoE and SLI4 adapters only
        https://git.kernel.org/mkp/scsi/c/5807d96c46d5
[12/13] lpfc: Update copyright year string for 2026
        https://git.kernel.org/mkp/scsi/c/107cb8ed4f44
[13/13] lpfc: Update lpfc version to 14.4.0.14
        https://git.kernel.org/mkp/scsi/c/6446e8c2b6c7

-- 
Martin K. Petersen
