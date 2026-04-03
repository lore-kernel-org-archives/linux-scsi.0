Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983AD26ACC;
	Fri,  3 Apr 2026 02:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775182000; cv=none; b=PNv1/KR3wQ1iJTifgCnPEqc+nOZWf4Vyo7r11AhrGB1ppZoR2tfN0HjvPX/sZyEOVLIrRWal4tfPOnEF2NIxgPPVdfwXrCjmz3SWR08HPdMMw3DgMUSJnsqHvC3Xz1+OLh3r8VzBQnul6tL42lSdcWmxHBLLse9GYFETkzqm6eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775182000; c=relaxed/simple;
	bh=i7V6VkLPQDqZm8NpuP1aa073qQ2nQvu0ms+PknJS9r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AtyAkZqPVl0V7FAEKJOXHzPp3BVXp3EJb+IDCDaYYNTcpWscx4WY/gVm0exMlKtNDIYm6+J6OWPWGdpw5ITkAQSeb8NvnBcL+JCMRW2PrNCfOXewRbkW2ciQLBHr8o1OPoFslMbvidso3Trm/udHUG27y+4ZtdDlweZl/ez2cOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qt+9uZ1u; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qt+9uZ1u"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6330GC2Z1380163;
	Fri, 3 Apr 2026 02:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JuU4KWiApf0ZUp6VJ9psnuq1pPNAcv7FH3S1uYvgc+M=; b=
	Qt+9uZ1u/LHo+bGtDpN2v9Zed05JNtsSBBB4ocolh0+Hcx/687h8RJkoVDR6XWwX
	7PxIeDQwZcCajaStb2ljMKnHhg2T2UZEHisLgsTB8kzx892bx2hjTBVbofEQt2Qh
	GHjPKwtJW12eCl5IeGwfr4vrGzUX2lMrTSJq6JQyfXs5IR+Z6RHl+/O8gSlfQKOU
	sk/KVypXcEKQOewPSELXyvRXdw1SozqpbtAwhE6mi+uesCIBoF19iZneL/UJpmC1
	q3f9mqKyJscv4fKScHnsKiXNxHYRAksDgxgI29yEO7OLaPbm6Xa4KXYBO/OZwv9A
	rIUmFix3T6ug3/SHFFoaaA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d671b1gvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6331Kig9028961;
	Fri, 3 Apr 2026 02:05:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddp4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:41 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 63325cqb017364;
	Fri, 3 Apr 2026 02:05:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65eddp33-3;
	Fri, 03 Apr 2026 02:05:41 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, mani@kernel.org,
        Can Guo <can.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v5 00/12] scsi: ufs: Add TX Equalization support for UFS 5.0
Date: Thu,  2 Apr 2026 22:05:26 -0400
Message-ID: <177517593459.3522679.17128283878850153356.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260325152154.1604082-1-can.guo@oss.qualcomm.com>
References: <20260325152154.1604082-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNyBTYWx0ZWRfX1LBiQhOsYASj
 d3H2snTfATbPOEWZg2HG1tt7/4T05EXo6LV9feS5OwUWTg9/TPUFuBZwMOd4Mo2K0RiRPDDxkqP
 8CVDlhXM4D4w+Cenl0eGd7Fly88H4BubUJyn/NL2+LCyPi9qgNO6Z5QylQcfp//xeCvqvmGTFuC
 4ed74nuW9ruFeUQoEZ1C696AmvDcf9Wcj7a2feizDRouxswMEU4mKU9MMqyhAAHcrZKsvd9d0zP
 zDOEC0kknYdUFcuxqVHXejyJ0FM7Blp79ONYlwPS33o/B/8yyC6Tym11GoS7uwXfBImVWwZiR3K
 eee13D0Ypm0e7zVrvudZuoOepSxSLGYcgJDwMwSa4FAmJLb3qumlAXYF/MiVQ4D1wuwEyvz2Uoa
 ozEiIqkLDlrmXKZ2FFo0FiULZWxafzSvHrWhrAWAJIHXoraP9TqfqkRU5hudSrcB83FYZepIWSw
 fQldEsdhH7i8u7HnPZw==
X-Authority-Analysis: v=2.4 cv=PJkCOPqC c=1 sm=1 tr=0 ts=69cf2076 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=EuvOurwuZNnj9x5cPKIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: J3hC8jPB2XAMZ05DyGFme7bAbVHCETjW
X-Proofpoint-ORIG-GUID: J3hC8jPB2XAMZ05DyGFme7bAbVHCETjW

On Wed, 25 Mar 2026 08:21:42 -0700, Can Guo wrote:

> The UFS v5.0 and UFSHCI v5.0 standards have published, introducing support
> for HS-G6 (46.6 Gbps per lane) through the new UniPro V3.0 interconnect
> layer and M-PHY V6.0 physical layer specifications. To achieve reliable
> operation at these higher speeds, UniPro V3.0 introduces TX Equalization
> and Pre-Coding mechanisms that are essential for signal integrity.
> 
> This patch series implements TX Equalization support in the UFS core
> driver as specified in UFSHCI v5.0, along with the necessary vendor
> operations and a reference implementation for Qualcomm UFS host
> controllers.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[01/12] scsi: ufs: core: Introduce a new ufshcd vops negotiate_pwr_mode()
        https://git.kernel.org/mkp/scsi/c/d3eba21c7170
[02/12] scsi: ufs: core: Pass force_pmc to ufshcd_config_pwr_mode() as a parameter
        https://git.kernel.org/mkp/scsi/c/c91c83671642
[03/12] scsi: ufs: core: Add UFS_HS_G6 and UFS_HS_GEAR_MAX to enum ufs_hs_gear_tag
        https://git.kernel.org/mkp/scsi/c/6669ab18c223
[04/12] scsi: ufs: core: Add support for TX Equalization
        https://git.kernel.org/mkp/scsi/c/03e5d38e2f98
[05/12] scsi: ufs: core: Add debugfs entries for TX Equalization params
        https://git.kernel.org/mkp/scsi/c/10c40143f369
[06/12] scsi: ufs: core: Add helpers to pause and resume command processing
        https://git.kernel.org/mkp/scsi/c/dc5dcac53278
[07/12] scsi: ufs: core: Add support to retrain TX Equalization via debugfs
        https://git.kernel.org/mkp/scsi/c/adbabdcf0db0
[08/12] scsi: ufs: ufs-qcom: Fixup PAM-4 TX L0_L1_L2_L3 adaptation pattern length
        https://git.kernel.org/mkp/scsi/c/53c94067efa2
[09/12] scsi: ufs: ufs-qcom: Implement vops tx_eqtr_notify()
        https://git.kernel.org/mkp/scsi/c/385b95893e79
[10/12] scsi: ufs: ufs-qcom: Implement vops get_rx_fom()
        https://git.kernel.org/mkp/scsi/c/26605db7604d
[11/12] scsi: ufs: ufs-qcom: Implement vops apply_tx_eqtr_settings()
        https://git.kernel.org/mkp/scsi/c/16cbdc830877
[12/12] scsi: ufs: ufs-qcom: Enable TX Equalization
        https://git.kernel.org/mkp/scsi/c/57b7943fd87f

-- 
Martin K. Petersen
