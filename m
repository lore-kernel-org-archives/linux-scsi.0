Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0F62D441D
	for <linux-scsi@vger.kernel.org>; Tue,  6 May 2025 04:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505560; cv=none; b=KkSWymPo3sgg8Skx0OyX43N3AABqumexH78dDByXPBSnlMMgjhtyMqqExr8fbe/1F86oxE0QJyLp1U14U62kTwlAmCRv0RreXv52kXb4g3xlef5LOq62Mu5GaZKdDpFUpUPSkEjA2g+EKEOhxnbo59AFuqnZYSjjUbr9U+l2PUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505560; c=relaxed/simple;
	bh=gYJBB6sl1hL6TUQQyyE6ckMCpXQhSSmNwyOOajPtj2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XPq7Xt7adjRSko0z7jlIOnSayjaclwn9Ned7XoYZd5M2k0KzUfyyUUE+bm/aZalul/eBNgno8gncZmAvRK0pE2JgIrxMN6iqNuh9zqfcBoW7hWpw3+GB94gdbqLo+9rSfzxyLMU0vqCKaODOVAmArMPEtcNoLRz7VQDfvOMN0L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eK5jeUHr; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eK5jeUHr"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5463HPQm000532;
	Tue, 6 May 2025 04:25:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7y96xeNcFbPyKQrKGuDoiMgtBvvWFgSOYRZGeDTa0+I=; b=
	eK5jeUHrvL0M/4MdmLGjYZFZbRIkUYsvQo6mHVLtUHsCJiVVM0XnD+YAYgpDtKk2
	zG4AsCMuIEYbOI98CX7gSbBAEUdS9pccsaiai1SZRivwQTHHJodfCd12Zv7H/Utr
	MRu5EDlc4Yzj/x7RWJPSIexO3NTZT1UEPRkvwAx1YhfzziJDn8f1J2XNK1V+Feud
	rWum2DCvBYxkKxvuaSiI7/uWBbYsiojAmKHvOroebvqF/L95IYlJikviq+Jo/nBd
	bvnQugaRpEvidwJ26zQf4EzRxWQc0FBMmCeZKD674Xw06cp/OLuDy3pS9bwoldSQ
	toYM1oIrFdtM7dk7ccNLBg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46facp01v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5462whXW036125;
	Tue, 6 May 2025 04:25:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8gpnd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:54 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5464Pr48012838;
	Tue, 6 May 2025 04:25:54 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46d9k8gpmt-2;
	Tue, 06 May 2025 04:25:54 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.9
Date: Tue,  6 May 2025 00:25:20 -0400
Message-ID: <174649624842.3806817.13493907898604040117.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
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
 definitions=2025-05-06_02,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060039
X-Proofpoint-GUID: FBGcc-sHjuB6pcu60niglKF7PiLTGhh5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAzOSBTYWx0ZWRfX/Qe464/H5HzJ WStrxPDr/evCVqpSHljQAEKqkErvpPwPsi3ypneOpbrCmCCnBW5PifXV4RHKhm+Kn8hNjGoh+gD nAyL7rQkmF1tdjrxPX5tv2JrWl1kiYSbA2lL/tlb55dZVN5VoaxBkZ3OuaYj5wpjNDFsRyhSjcl
 Q2aIBrlmRbXF4Gd6Rmfv4J/ZlEjDyaxPo3ykQ4NwWzly34ObNWEmHoTVTDyMuoEawNFgulOGBzP Kt1CGZkY8y0MP/b6rWGqmMBoUNMmU15KoewMdQzPipPfEdK5oCx+ZIqHoABQqeSkh1TX0wyfPgH jZbJtnuI1XkumX/lPh94QtgJN34RL3cssnPkWJqk7YSEQgAxBHWMQrfnSKABKaUqvLyTuBQuQCW
 6DGxEfwLhd/t0/k2YP2Sbu4qbtAAsXkt8LjQkXiMVXpiu2rZW9KbWRRPxQ1umuHzGsCnblQB
X-Authority-Analysis: v=2.4 cv=VMbdn8PX c=1 sm=1 tr=0 ts=68198f53 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=xY7ZwogtYb6j_2XKhjIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: FBGcc-sHjuB6pcu60niglKF7PiLTGhh5

On Fri, 25 Apr 2025 12:47:58 -0700, Justin Tee wrote:

> Update lpfc to revision 14.4.0.9
> 
> This patch set contains fixes related to handling of WQE commands, PCI
> function resets, firmware eratta events, ELS retries, a smatch
> use-after-free warning, and the creation of a new VMID information entry.
> 
> The patches were cut against Martin's 6.16/scsi-queue tree.
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/8] lpfc: Fix lpfc_check_sli_ndlp handling for GEN_REQUEST64 commands
      https://git.kernel.org/mkp/scsi/c/05ae6c9c7315
[2/8] lpfc: Notify fc transport of rport disappearance during PCI fcn reset
      https://git.kernel.org/mkp/scsi/c/8808c36b48a6
[3/8] lpfc: Restart eratt_poll timer if HBA_SETUP flag still unset
      https://git.kernel.org/mkp/scsi/c/19d768dca549
[4/8] lpfc: Prevent failure to reregister with NVME transport after PRLI retry
      https://git.kernel.org/mkp/scsi/c/df117c93f58a
[5/8] lpfc: Avoid potential ndlp use-after-free in dev_loss_tmo_callbk
      https://git.kernel.org/mkp/scsi/c/b5162bb6aa1e
[6/8] lpfc: Create lpfc_vmid_info sysfs entry
      https://git.kernel.org/mkp/scsi/c/327b110fdea1
[7/8] lpfc: Update lpfc version to 14.4.0.9
      https://git.kernel.org/mkp/scsi/c/773a136fc828
[8/8] lpfc: Copyright updates for 14.4.0.9 patches
      https://git.kernel.org/mkp/scsi/c/f65c7b81796e

-- 
Martin K. Petersen	Oracle Linux Engineering
