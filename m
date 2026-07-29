Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7818438E121
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 02:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293730; cv=none; b=MsE5nlY/kOY6ecGUEG+5j/NCiyABUtUw/na4HGoLDFW5t5kYxZWT7AcskmVQZFAIMktpUKuPrAq+1DEo9sIOfDRMKwKX08AdfV6lIpxAUzoSx93X7BzQimQ4Uaf+gK7wSsslj36gqx4CkswlfE1ExaI1GqGMnlqyBwI04y+R8RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293730; c=relaxed/simple;
	bh=dmyuDkt5aq4mMLl0+NjRpRO+OrAiCgfc1UVj2Atxeh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QtPW5GeLDpc9ODlW9m8DA+XC13ukpMzF9/hwLrpgOKtylRMPariadeb0KNfP0ypBlBosb2ZI2dfdK/NuUiUjZl2KGwIvUT0aX+0q3QY9BX7Q4oZ5L0oYO8xiSF/a8pQzeVw54UT66m4ItOQjxw0uPHIZ+oHgpent48S6iZNNA7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=na+6rNhM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="na+6rNhM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItXOJ1074589;
	Wed, 29 Jul 2026 02:55:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1UxItTTDxFS8tRoozyGu2xKEaCyde5oKPuNrb9HIRGU=; b=
	na+6rNhMjE263YVrfieXNh8q9yR9HieeWLss6EAWQfnxWFU2OLdJP8/54w62NK2y
	qGZCRsBMstF2soWzKgb/6mrcoAeYZmk2j8ckYRhfMDr7tpohLwo74CpnqqyU6d8K
	7UeoLIj/RWxX+IT4yReKXs0j5QYyKsrjeKKH3TBNA1G7xtLJy/L5Oe9+EF9PIzmO
	VMlXmQdpL25Pq0fKkOeOI5QBJ5R/lThvXZ1JOQHTXkwW97QtAjnBDepNqQip7ICi
	EUKqJImmAk/QHkzpInp3vjSJxlDX/WnvT+8DGrbmKLluTbX3noVMc4YLQSLzWTul
	+VGAgrbUFiV1seqnd5fSRw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq5476-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2o5lW001409;
	Wed, 29 Jul 2026 02:55:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87p0kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:10 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2t8jP012133;
	Wed, 29 Jul 2026 02:55:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fnh87p0jb-3;
	Wed, 29 Jul 2026 02:55:10 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        mani@kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] scsi: ufs: Harden TX EQTR error handling paths
Date: Tue, 28 Jul 2026 22:54:57 -0400
Message-ID: <178508193499.4027291.3840194105123563793.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
References: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX4QtoQFzvKVxx
 oRXSdOKStMROW9M1WuifQ/vm2iLApL0FLAvZOfSC1sf0ViGhTCYm5GRB7nzrX4A9YN3vdR5LuEG
 v5d8/9+1snCzJ+hMWk7Se0yYFqaiixcVEsRoMGDftQ0kPkmvZr4BrwBIVenamZFO5ATQ05fgDUo
 Dn3hgp1pnwgkhxtttVA/SiSx0r7Tu45thq+eJcgS4faVaZdGsP2Dug2q8sl7B+5690YzmHcvodH
 oDDZF9Gt1M0QPPypPtddWSdZ0cXjfKutQJmEuGqCwMNN6dq0p2WY8IdjMgTdnrfjUw/lR7Jukco
 Xdr+5bmSXpaSnp+uexfyHutTPeTu8z5ki5nEjUT9aituuv5b8QGT/BQsDWvCwpac6s93YuA7rgn
 KyOKMwMdMkFCNUpAX1RjcHvDcBXB5wQqK2FCH39uqDF3eRKxcxvP7q8QWiL8iKyZhLEUvDvgd11
 3gMEc/j+yyibR7vM2Dg==
X-Proofpoint-GUID: MlKpxkC3fyPM9R1RreZ2XJioDF3Zw6Z2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX5+hbvicaOPFl
 jdRrymmLnME17JJaT5iTFbPHGHC97rdZYL18adrwCzi3dB0s/ghp/Kh5qI7a1rkbI3JuKqB75fR
 sE4la3bMrB5fV40UzQGGGlEOK2eZyJkDqeeiRzGaAxyAtKyRiQz+
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a696b90 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=OZ7cIDxDWjs4DeRuK_wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: MlKpxkC3fyPM9R1RreZ2XJioDF3Zw6Z2

On Thu, 25 Jun 2026 05:13:02 -0700, Can Guo wrote:

> TX Equalization training currently has a few error-path gaps that can
> make the flow brittle and can leave variant/device cleanup incomplete.
> 
> This series hardens TX EQTR in three places:
> 
> 1. ufs-qcom: route SW FOM setup failures through the shared cleanup path
>    so temporary device TX EQ settings are restored and link recovery is
>    always attempted before exit.
> 2. core: treat RX_FOM DME read failures as best effort so TX EQTR can
>    continue, and force failed lanes to deterministic 0 FOM.
> 3. core: always run tx_eqtr POST_CHANGE notify once PRE_CHANGE succeeds,
>    even when TX EQTR fails, so variant cleanup is not skipped.
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/3] scsi: ufs: ufs-qcom: Restore TX Equalization settings on FOM failure
      https://git.kernel.org/mkp/scsi/c/890b10e76e6c
[2/3] scsi: ufs: core: Tolerate RX_FOM read failures in TX EQTR
      https://git.kernel.org/mkp/scsi/c/4bd0875b7e57
[3/3] scsi: ufs: core: Always run tx_eqtr POST_CHANGE notify
      https://git.kernel.org/mkp/scsi/c/f13faec1d4c1

-- 
Martin K. Petersen
