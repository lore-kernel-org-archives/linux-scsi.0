Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD90184E;
	Wed,  5 Jun 2024 02:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554806; cv=none; b=s62Hex+ihXd6uxSfxFav7gCweA0U7zI9M/n+ImMxnQ/12i38p+/iTW21otETAMjDhcE9R8yObWu4MeQwZskJZYOWFrKyo3jbLP8HmHzcTA2SMavo69yfMaoQo4yxwH5lj+wlKMVdPDko3aRFlIRml4eO4DF8XPLJr09yxaK0Or0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554806; c=relaxed/simple;
	bh=dxJjjcht5HLUS6ZRJqfRkpTQibrrKD4SwhpETJ6qPKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U3KKqA6YKXeEniDkrsCpkb2soFbwGvFG34Q0JvCApI4KLxCDQ97ExurWcZztdN2kH02DAUYXDoZQBu5ifXFwldxrwNm4o4VC3Hd5X3csY+xTW14OB1gog/kJeSDbJbMrK0L2VYHA40Abp+M0S8R0dv6/X1Tsze1MUsG71roEMig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Iots8wdS; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Iots8wdS"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551DvBU005217;
	Wed, 5 Jun 2024 02:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=corp-2023-11-20;
 bh=YF1pZmbtrrh0JQYfM/Nk+W3XPvlIGS4AclEO2b/dAQE=;
 b=Iots8wdSWoiz57TB2gtpxKdUv3BBFUKX2egezCAlB/zCanJJ7akQitZRbvXE5WfKHuHw
 EIiwCmJDsYovbdP9qkBYXobskN4g7FsIw0E3ZPQHpQpVodEl2OhGuFytvGxzX/5MoHw1
 badrYRstaQ2AUKqaYnPKlx2S0d1SjyMbzeUpS38GDcDQDZA5ff9BqezEhkFsNIxGM30C
 CKwvcaCXI+iXZnRJbWJg/JNT2Xb38BRnIV22+ZIYtfOkJ9tRAjkqtPWGr8//qlL0gqrK
 M/MDGHkKyeu1SJPyOxMf5EeINWoTEY4Uxnq7/VklsBgeBI8gDW180B3nLkZFB4Ig3uGG tQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbrs865f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:33:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4550ZM70015573;
	Wed, 5 Jun 2024 02:33:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrjd4bm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:33:16 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4552XFLs011499;
	Wed, 5 Jun 2024 02:33:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ygrjd4bky-1;
	Wed, 05 Jun 2024 02:33:15 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] scsi: ufs: Allow RTT negotiation
Date: Tue,  4 Jun 2024 22:32:37 -0400
Message-ID: <171755313984.3904072.6642162030397966521.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240530142510.734-1-avri.altman@wdc.com>
References: <20240530142510.734-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=722 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050018
X-Proofpoint-ORIG-GUID: EV8AbOhiJ7-fEUVMSSzMlYuC0efHq3bp
X-Proofpoint-GUID: EV8AbOhiJ7-fEUVMSSzMlYuC0efHq3bp

On Thu, 30 May 2024 17:25:06 +0300, Avri Altman wrote:

> The rtt-upiu packets precede any data-out upiu packets, thus
> synchronizing the data input to the device: this mostly applies to write
> operations, but there are other operations that requires rtt as well.
> 
> There are several rules binding this rtt - data-out dialog, specifically
> There can be at most outstanding bMaxNumOfRTT such packets.  This might
> have an effect on write performance (sequential write in particular), as
> each data-out upiu must wait for its rtt sibling.
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/3] scsi: ufs: Allow RTT negotiation
      https://git.kernel.org/mkp/scsi/c/9ec54934ce85
[2/3] scsi: ufs: Maximum RTT supported by the host driver
      https://git.kernel.org/mkp/scsi/c/e75ff63300c5
[3/3] scsi: ufs: sysfs: Make max_number_of_rtt read-write
      https://git.kernel.org/mkp/scsi/c/600edc6620a4

-- 
Martin K. Petersen	Oracle Linux Engineering
