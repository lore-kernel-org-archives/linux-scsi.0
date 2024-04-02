Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E0912E7F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Apr 2024 01:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022571; cv=none; b=hhx7nvKSCr1/3ZafrNQ9MYl4DXsuQNHuU3iMttnDmh52gDs26WHoqEDfvEmqWD1Qsw/uAyCpVHw7o2zL/hn7ocZZXlZ8MvF5zZNXUBlvmC0ETEkTgw+jRfdAaijIO+2YpDKwfpNDaPHNMUT9beKsd5cjU5tnw9Mp2qHIyC1BWhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022571; c=relaxed/simple;
	bh=cEZO2vzLbSF4BUUUAQUTsIXhOzUm4FAJN1weWBnll4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNkmBZNSrTslU5YQWTvWxOP1IL+ILV/g48ONf1OJ2NuBb40RIekn0TTEUnZF5i0lCsakRNwjo3JtzhRmyg28rYlXmw9MTPwr8I7HQ9Ew2RVihuIxwRe5x8qvlXuVNi/7jdrnClafAKjalEicVY7ULJ+NUfJPiZ3bo28OCONH0ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TS1/SGOa; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TS1/SGOa"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 431IKCQA009659;
	Tue, 2 Apr 2024 01:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=ZCbDPopcwvRQZMkSktlFhLLo3Nu0UpFGUCF9FeZ0mNY=;
 b=TS1/SGOa5In3K4lia4GpZP6pw5LvIzzAghuW0r1O/qrnSxNz4Yp86tk/X3Hy0dzipN3G
 srycrpFXDkCSs53hlqczNYwskkvZQzUKQbKkaTgIjqk/jOgsNVF82vTTRf4hz3Ti25+y
 hClYMCFwZ95t78oYrhmrhELpe2tn3luzPM2LVG/MPCa9OFy2XO5VnSM4CcvdlqPhOI9c
 1TF5fMtt9vdG26IJ9GSlBdiXl0NjuId2GZIpOX5fFAIuo/O2gAPVI4KRrpsKqbRTsvcn
 Wa+cTdeqUS5ilaCGbEtfo5w12GW9ljSnEcvxP9AtKzJ+1t3HQ1t+hSTyV4lN+TObDi2R tA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x7tb9sjpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Apr 2024 01:48:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 431NUTEj018607;
	Tue, 2 Apr 2024 01:48:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x696cd6cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Apr 2024 01:48:48 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4321mkNH030130;
	Tue, 2 Apr 2024 01:48:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3x696cd6bp-5;
	Tue, 02 Apr 2024 01:48:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
        eddie.huang@mediatek.com, naomi.chu@mediatek.com,
        chu.stanley@gmail.com
Subject: Re: [PATCH v2] ufs: core: wlun suspend dev/link state error recovery
Date: Mon,  1 Apr 2024 21:48:39 -0400
Message-ID: <171202249153.2135322.11918822860021186461.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240329015036.15707-1-peter.wang@mediatek.com>
References: <20240329015036.15707-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-01_18,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2404020012
X-Proofpoint-GUID: HmNuGV14Tod30m5MRiyUXr86DJKBqJsW
X-Proofpoint-ORIG-GUID: HmNuGV14Tod30m5MRiyUXr86DJKBqJsW

On Fri, 29 Mar 2024 09:50:36 +0800, peter.wang@mediatek.com wrote:

> When wl suspend error occurs, for example, BKOP or SSU timeout, the host
> triggers an error handler and returns -EBUSY to break the wl suspend process.
> However, it is possible for the runtime PM to enter wl suspend again before
> the error handler has finished, and return -EINVAL because the device is
> in an error state. To address this, ensure that the rumtime PM waits for the
> error handler to finish, or trigger the error handler in such cases,
> because returning -EINVAL can cause the I/O to hang.
> 
> [...]

Applied to 6.9/scsi-fixes, thanks!

[1/1] ufs: core: wlun suspend dev/link state error recovery
      https://git.kernel.org/mkp/scsi/c/6bc5e70b1c79

-- 
Martin K. Petersen	Oracle Linux Engineering
