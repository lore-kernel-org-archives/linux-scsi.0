Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12BE1C698;
	Sat, 11 May 2024 18:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715453673; cv=none; b=J22G6MtLCHuIiL+NE8y3Kv3TJjvOJoFda/si4823WeOf2Jdwn/nmx55kdobLTG1U5hd7HMCNMlNRW1JKewMDcQuUosRy02+r7G4n3AfvJo5YMa86nUbqrUOZgLmsUczziBs3wgdB5IQF6HXI+dJ3tsu/VFC7uYcgPaEhaZrXFWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715453673; c=relaxed/simple;
	bh=zsV9PavFJcTnNWI/Th6BtzFhoDWcMrSZoE/bqvNAUb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IKn6EyLylU2zDD92PgVZVb7DuRLomCicVmS0GF/4mZJUSfge98ekgHxRNfzltyM6LwGv0VPezJ9kOcYIpWyWOYDOZ33boC2Vmso/CQC24z3w52S3Fc9iVOVRYXUPbg9RTYk8N4JGmTm8rE8BE1s8fxIOn5Yv4JQuTYLf21F8peQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lrz64as7; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lrz64as7"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44BHw2s1024717;
	Sat, 11 May 2024 18:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=8w/6C+HdpkK6kFdInaalIfrEqZhi68Ze6hefgz5Sk/U=;
 b=lrz64as7e/YGk8I57jY/dV7HacWL4o9ZE3faF8f8F0ULPyeUDIROy1InorcdG77hCwDw
 rAaxiqnANL2/ySDI2qtPMkHX3Ae+6P3SK3uYt+8xOGpj85QDjTFUtmCIC3VCkH8wYfE1
 VXEq7pa7CJ4HC8cYLqxua6qKCb53Q0Rv6WckGl5Cc7fFbsR144ApVZUM9t6BLeaeYevQ
 VZd6Nx2yeFJ5hyTwYXGKOou+Wl7cSeRFp1sPbYfpzsT1mxWp8wQ3QoSZ3FoSCjaNFLsZ
 PwIEZhfGeVISOiMPQP1cYkW/0AUzhZ4iQD9brfI6wxF+Yy2M9Hoq4RYYiVb+xfpexctT 0A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y28ub864c-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:54:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44BGJkGR022397;
	Sat, 11 May 2024 18:40:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y44fn7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:40:00 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44BIZYPW028255;
	Sat, 11 May 2024 18:39:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y1y44fn5r-5;
	Sat, 11 May 2024 18:39:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        James.Bottomley@HansenPartnership.com,
        Peter Griffin <peter.griffin@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        tudor.ambarus@linaro.org, andre.draszik@linaro.org,
        saravanak@google.com, willmcvicker@google.com, kernel-team@android.com
Subject: Re: [PATCH v3 0/6] ufs-exynos support for Tensor GS101
Date: Sat, 11 May 2024 14:39:11 -0400
Message-ID: <171545260083.2119337.10146864051829985278.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240426122004.2249178-1-peter.griffin@linaro.org>
References: <20240426122004.2249178-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-11_06,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405110139
X-Proofpoint-ORIG-GUID: 2qdil7Pa5aFUKQqVJo-LXRoqqyQtZf98
X-Proofpoint-GUID: 2qdil7Pa5aFUKQqVJo-LXRoqqyQtZf98

On Fri, 26 Apr 2024 13:19:58 +0100, Peter Griffin wrote:

> This series adds support to the ufs-exynos driver for Tensor gs101 found
> in Pixel 6. It was send previously in [1] and [2] but included the other
> clock, phy and DTS parts. This series has been split into just the
> ufs-exynos part to hopefully make things easier.
> 
> With this series, plus the phy, clock and dts changes UFS is functional
> upstream for Pixel 6. The SKhynix HN8T05BZGKX015 can be enumerated,
> partitions mounted etc.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/6] dt-bindings: ufs: exynos-ufs: Add gs101 compatible
      https://git.kernel.org/mkp/scsi/c/438e23b61cd4
[2/6] scsi: ufs: host: ufs-exynos: Add EXYNOS_UFS_OPT_UFSPR_SECURE option
      https://git.kernel.org/mkp/scsi/c/449adb00d4f7
[3/6] scsi: ufs: host: ufs-exynos: add EXYNOS_UFS_OPT_TIMER_TICK_SELECT option
      https://git.kernel.org/mkp/scsi/c/9238cad67969
[4/6] scsi: ufs: host: ufs-exynos: allow max frequencies up to 267Mhz
      https://git.kernel.org/mkp/scsi/c/c9deb9a4f574
[5/6] scsi: ufs: host: ufs-exynos: add some pa_dbg_ register offsets into drvdata
      https://git.kernel.org/mkp/scsi/c/6f9f0d564b04
[6/6] scsi: ufs: host: ufs-exynos: Add support for Tensor gs101 SoC
      https://git.kernel.org/mkp/scsi/c/d11e0a318df8

-- 
Martin K. Petersen	Oracle Linux Engineering
