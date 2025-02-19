Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D98146447
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 01:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927276; cv=none; b=thm1XfKlVw6osC5LMgWH7bepQL2hp1byyrETBgBIwpbFrOtojpT5XHuPPS86KxmWohw3gTZ2O948rWxFTPd23V9Xac1GzwTlj+y9i2IgaVz4AYDd3Be7JLlCGHjHCUw07PCmwCm+lhpzRFm5QsRSPQK/QVYlIifmOag/779ATtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927276; c=relaxed/simple;
	bh=mw8k4EXe+ZKfP+iRdpjQ6cCGZKH/4Y2/WlIp8CJTUQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hK0lw1eLlhW3FRWpKGqibCunzNlZnJBrFLzg+V8BWnkyNf+r1nzzmur5vzDxTZI44fjviIqrpw8IDyQsQUYXsjgye8m14VaMrr/OKsSsoHAVoOL4lz4TUyt7X85idWxx7nj5D6iMfJy+3caXdqiTO2ePpCjkjirCZmuOH0lwstw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ht3of4ri; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ht3of4ri"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IMfbxC018894;
	Wed, 19 Feb 2025 01:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=4k1tMzfxeDGe8pwxNrkIDso1W0m7dwJO+wgCZhDV3fE=; b=
	Ht3of4ricpwUr+2kwV0Nuh6bgFgeVWewrrTjo+FsX3CEyQq98ifYauD/1FKqVRSP
	z+he75niFwwfPa6K1V1i8u3/HxyEFjKzZVF8Hpcpk4z4KtTvxNHaya6gnwkEQ8Wf
	Kf6l1TEi5WJmoK4L22d2B22zUNQy5Vw7gnJ5e3f5wgn68PCoHGP83KI0/VgW3Oou
	Gk3f/DUdrWRKwPSzdYlg9jaLfCRAVM/Jz7X9ZAuI+V9h5e/4a973CPOrqDqcBcUs
	rS1C4zDwqHOVnc4yOMgxUUn4xkDkjWq1TDggDpu6gB48VRCo3bZxG5Hi/y/TqiC4
	9Z7itmR2PY7NIw3NemojVQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00kgk3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J09eV2002113;
	Wed, 19 Feb 2025 01:07:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0tk1rqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:22 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51J17KeN000669;
	Wed, 19 Feb 2025 01:07:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44w0tk1rq5-3;
	Wed, 19 Feb 2025 01:07:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Bean Huo <beanhuo@micron.com>, Ziqi Chen <quic_ziqichen@quicinc.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Philipp Stanner <pstanner@redhat.com>,
        Minwoo Im <minwoo.im@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] scsi: ufs: Constify the third pwr_change_notify() argument
Date: Tue, 18 Feb 2025 20:06:51 -0500
Message-ID: <173992713096.526057.17998109495795713228.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250212213838.1044917-1-bvanassche@acm.org>
References: <20250212213838.1044917-1-bvanassche@acm.org>
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
 definitions=2025-02-18_11,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190006
X-Proofpoint-ORIG-GUID: mI2vWQ-z-C0nrxPmOxdANiOzwaZOxHlN
X-Proofpoint-GUID: mI2vWQ-z-C0nrxPmOxdANiOzwaZOxHlN

On Wed, 12 Feb 2025 13:38:02 -0800, Bart Van Assche wrote:

> The third pwr_change_notify() argument is an input parameter. Make this
> explicit by declaring it 'const'.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: ufs: Constify the third pwr_change_notify() argument
      https://git.kernel.org/mkp/scsi/c/3bcd901e4257

-- 
Martin K. Petersen	Oracle Linux Engineering
