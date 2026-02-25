Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B76626CE39
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 02:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771985333; cv=none; b=p97m9VJOsSfE0TtvNyEKR/F1yOffv0tM9Emy1tqLZMJWGfKXcdV0kQyHVCaO0GmoFbaIboAL+1xvKnk+CbwUsZ4cVZnS08xoBZCrq13gcLbxfdCJValNR8LG4BWysnP6EZywXPNJgDH+AryEU13qFm0m9OY31bwMtbiUQnIpb/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771985333; c=relaxed/simple;
	bh=Pi2C1AVL82a2TMZOLelxS5UUS1jL2fkXXfxWFMrErl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lSwtGFPbcmNExRqv363yCbrSjXHucPY3/Jglq+OtLLUBOJFlyVBcp+bnpYcCyiRy2QTgPDtv0qqnH4fFPAQAOvdHOy54jnvC9H01q10MNicgJ0o+nx24vQUymrw8O0AolG1Sft8mq1Xo+KK4pa9jCUGNlKoxYCe4kSjnmthipIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ShVtZ8JM; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ShVtZ8JM"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OIvVwv3930646;
	Wed, 25 Feb 2026 02:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oiBICH0QgqmMAV9uuMkMi3BhSmbfCc+hSodQOal5Ujk=; b=
	ShVtZ8JM7+9jH3s7wWEOdznGhS0JLzCMh/n0IHTFe4SoDWmaMVJ4ZrP3JWjAy2HU
	ZWh7eNkHzhRd1YDcL/qM1hG1xwQvtc0Gve06znl8DkCckF1+50Kkc6jzRhIoSxxE
	PEwWSNaW/QBmx7qpVMEDY5bINOYluO7QQ2k1EHNms1/JxcnWPuPuAuDThzPH9psU
	jf1zrDr8h84VLg1mYvMnYdSJf/2qKRBkjLT5F7PH2sGeDSJ6MsUlyHZDEettAE3+
	5Rj2vpd/22KxGTZ+WDHRMgeYW3HkEBWrPzDpqEeprOJUpJ7GnPgDVU9wyK5Hpuh5
	u0w2dWb5iZBpBMQW/6Ftlg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qdb6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 02:08:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61P127Q8015739;
	Wed, 25 Feb 2026 02:08:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35ar24j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 02:08:36 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61P28YNR029537;
	Wed, 25 Feb 2026 02:08:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35ar1yt-2;
	Wed, 25 Feb 2026 02:08:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@sandisk.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, ed.tsai@mediatek.com, bvanassche@acm.org,
        sh043.lee@samsung.com
Subject: Re: [PATCH v1] ufs: core: Move link recovery for hibern8 exit failure to wl_resume
Date: Tue, 24 Feb 2026 21:08:04 -0500
Message-ID: <177198526953.1649777.13224863174266234470.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223103906.2533654-1-peter.wang@mediatek.com>
References: <20260223103906.2533654-1-peter.wang@mediatek.com>
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
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDAxOCBTYWx0ZWRfX3I5CDdYxB05F
 nWZnCd/Z6wWID/uIpnfk5LDl2+AaFdYZlZrHtIxrn8nZ3Nx85IcNvS0GvNXSTxWb5TiJ9W5cctl
 aJAIm1sRw9Fc2o4dg6XU9FdkOj58Nz8cLnYw8ZBVvXYudxX6HPbUTDCnbXshJzJfUlT0joelHAm
 2kp7Dhiv2Wc/mo29LMzZT/xt/ag8idOzepgxrpPlHIpTQBGLCwT2RZBVi40ckUpoRHsuVuTsR7O
 o9qkSA2SQdU6F6RsDA/fT5Hxzm9IS4Fm1lQb+alVxIausfhY6ecHxdBE1PQhdmSxvX+kzDsB7Wz
 1lngCe8ZUQXrxsobrDe7Kep3yPuuTw1YOoTjmmsfMhcPC27tw2YtlUr/nakslrUargcFncuOQXS
 G1DLt1M25+yucTclzodI3tf5J/u7i2pGaOuDhKVk4L3bUw85T1oS9CJYaIRl8KjLpxhX1rzuoPi
 lA1/qTa4NL9HtNzy1VQ==
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699e59a5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=mpaa-ttXAAAA:8 a=Xy4G9aJaCs3E2Fc1aycA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0-o0X9ZKoPq7o0RZcYi8XtYgRu5TDthy
X-Proofpoint-GUID: 0-o0X9ZKoPq7o0RZcYi8XtYgRu5TDthy

On Mon, 23 Feb 2026 18:37:57 +0800, peter.wang@mediatek.com wrote:

> Move the link recovery trigger from ufshcd_uic_pwr_ctrl() to
> __ufshcd_wl_resume(). Ensure link recovery is only attempted
> when hibern8 exit fails during resume, not during hibern8 enter
> in suspend. Improve error handling and prevent unnecessary link
> recovery attempts.
> 
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] ufs: core: Move link recovery for hibern8 exit failure to wl_resume
      https://git.kernel.org/mkp/scsi/c/62c015373e1c

-- 
Martin K. Petersen
