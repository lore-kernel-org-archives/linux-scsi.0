Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43E1229B2A
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 03:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764387040; cv=none; b=Tv3hjsuckkJFja0Hyc7MW5PILsbwBmidj8sSSHTppRV4XTcJYjuxCH7RMCYR5P2cju4MCspV/CWtFEipmdud1xNDQk2ifqiRz6F4YPHKHmPWHJm5GGY3CyvtQA/2If/vePUKFjiQ3SHaGzLBUT6JNGAjX0sHJGLVfl9kuLC/dc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764387040; c=relaxed/simple;
	bh=MfdgEp6sXUwSpj6k6fAurMS5osMrjwaGwkemgpQZMSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qoyk/Mve2D76ghZ/NCqVl4/KaUJl+MleM3iWGy2FFbYHd5b1t13DAKwDL0vvSC+AIlBoh1TUCzbuUkiJCXCsyK7PYTdKlhXiTsx6ecCHLnlOdsKNSuIcpFTmUpDfObJ5hq4m51PDkKmsIrfNwqlt9NE3DqFnzl4GtxWUXnClhxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YBz2/iU9; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YBz2/iU9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AT1VopS469005;
	Sat, 29 Nov 2025 03:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=78uInKZrWpjpWwFowD1O535t2yNRuSJ4fcHCzDtpQPY=; b=
	YBz2/iU9AHQ1N3vaH5PmatmVshd0oZ2XKkFOIGCDArX9bV5dDeA5J2X15USPddWv
	QmlobTh7ntflHp8ZpPN7+GV5rV4R/fs1IgQUg5r/hZYt8t/yj1FqWfyehxZxBx4r
	+q/Et77AqQYzbw7kpm7xD3xt/838VueMwgitUIPwc5esGiFFSkX02E5VQwZZSQZJ
	03dvnr++PzFOfrt5zO0GM5+jA3a9eVaf9Ff5JP/W+GwNak5hz3GsMMk2kyd8h8pX
	J7vk63IwEEav25bNmOW+LuK7RTINl/zacCPDVQ63poh+Ia9Tvc9XBrQTT5g4+NWd
	dYPPy/BAUSKTHDWzWfQQAQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqq8c01uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AT1XgY4032028;
	Sat, 29 Nov 2025 03:30:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq961n9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 03:30:17 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AT3UEpH015090;
	Sat, 29 Nov 2025 03:30:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aqq961n85-3;
	Sat, 29 Nov 2025 03:30:16 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>, Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] ufs: core: Fix single doorbell mode support
Date: Fri, 28 Nov 2025 22:30:02 -0500
Message-ID: <176438479580.3682470.12222771050885604804.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114193406.3097237-1-bvanassche@acm.org>
References: <20251114193406.3097237-1-bvanassche@acm.org>
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
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=907
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyNCBTYWx0ZWRfXzm5YMbmFExsx
 YSyuZrlITeDEGSG+aNlT1319/1scm2I1I//L0qG4WxOwpPvrCUzvaZiw2+acCBVM8JkRYJwh4va
 MPj6ODk1BiFAn7SHpIi43m/4c1v1a/lrTiPpxvdd4BgDutxxaGubFaWct8Sq71vJ0kWDz8RGE2V
 k8c4Oh150JFQN7UNVVD4qZRwmzLFHZzuwuRMfYsF9Ek3oXkJp1fp8S1ZgmfkluAjclL19xZrcXe
 XYgYMsjtfaa2EmS9yqfiJtjOnOQTFNuSs0s2RVBWiIshim4yfb1ZuuMNCwGTZKZKzfiW370q+nJ
 eTVa6v//M+PcY+Fmd5aK+CJUmh9DYlgHQRw2ABdCRnyKTNk+Y7eD2AAwHo35bTfZIzBDD9uNfDH
 x/AjXXK0QaY1/nRw3Zt1VocqjRxR0A==
X-Proofpoint-GUID: R_4Eywf1nyRFNyi1WeFBWGwCTu7UhcDz
X-Proofpoint-ORIG-GUID: R_4Eywf1nyRFNyi1WeFBWGwCTu7UhcDz
X-Authority-Analysis: v=2.4 cv=EpHfbCcA c=1 sm=1 tr=0 ts=692a68ca cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=rmvIFdxgP89PMopFlyEA:9 a=QEXdDO2ut3YA:10 a=UzISIztuOb4A:10

On Fri, 14 Nov 2025 11:34:03 -0800, Bart Van Assche wrote:

> Commit 22089c218037 ("scsi: ufs: core: Optimize the hot path")
> accidentally broke support for the legacy single doorbell mode.
> The tag_set.shared_tags pointer is only != NULL if shared tag support is
> enabled. The UFS driver only enables shared tag support in MCQ mode.
> 
> Fix this by handling legacy and MCQ modes differently in
> ufshcd_tag_to_cmd().
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] ufs: core: Fix single doorbell mode support
      https://git.kernel.org/mkp/scsi/c/02b5822d2fea

-- 
Martin K. Petersen
