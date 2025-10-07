Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17072AE68;
	Tue,  7 Oct 2025 02:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759804726; cv=none; b=Jkf3Ap4PXv/aKAIjsEmibd1inAG4EARVuNZGqiMIVlvnyYyFkyh0fO3SVhGLdRGCOg2drbP5dPgMZzPNxMtBzAULngCkFET4biWJZ8cOlMVboEDKpobvF0IRBI76gWfhYSONuDSpE/DhO3HAj8WdGHs5Li3cMo6rbhDLHkV75AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759804726; c=relaxed/simple;
	bh=Ey9wuJ4oAYHzAzd2eMXB9cB7CZvPwacBF3tRTa5dtS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mm8YxcoF2fR6BTND9q6CIsQbxazUd4Fys6YlLqGjFc2E66P8jmEyONua+gJODEVfbVmZMumdHY27502TSc9DO0Xy9DL2jZQnLXKrV4NlUEr22KSwOq/nR286zr60Bk4L68jvxbKUQHnYt0UZ8/RGd8grOnUG34moAxfEw0MI05A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ITMLjA/p; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ITMLjA/p"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5971HWof008652;
	Tue, 7 Oct 2025 02:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bP70ohDJzn8116dAWtFsp+n2iuOR/zuZrYUt3tvXqHA=; b=
	ITMLjA/p8xl8RJOinVibjH659EY6dmQfoGO8Vk1AeMVbEetk8pLjDc7PT5drJ4NX
	Xhc0bvjXVhSaeLRzCy9brTHHjAbY6ofeMF32wGDrkt+S94nXnRE4GYaRaiDb4qlR
	UFBo1F6OtM5aF7S4a0jotEWpLrYavDpNuC4fFfjJEAh38+cqaJM55uHG3q7ipF1+
	SeNCpbcexUAG7+IlMhbmRXQr5cuGuo26nn8/eymKdCSLrH9QYxr4pQzQqtz5MKq6
	gPKDh8JIMuljF+UwmYPkaVt8nASmgvgpLOMmO1SoA3iuzLYBIJzxCqvnWIcJLYgk
	U9iK6FYHCJ1UjHY2sZvrVQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mr9sg3wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:38:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5971JWIK028599;
	Tue, 7 Oct 2025 02:38:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17ktv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:38:34 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5972cYWD013646;
	Tue, 7 Oct 2025 02:38:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 49jt17ktuv-1;
	Tue, 07 Oct 2025 02:38:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Daniel Lee <chullee@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        tanghuan@vivo.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: sysfs: Make HID attributes visible
Date: Mon,  6 Oct 2025 22:38:28 -0400
Message-ID: <175980238052.149901.4706267062715899884.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930010939.3520325-1-chullee@google.com>
References: <20250930010939.3520325-1-chullee@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=489 spamscore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070020
X-Authority-Analysis: v=2.4 cv=PqKergM3 c=1 sm=1 tr=0 ts=68e47d2b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=vtQSeeifSsz6rET5qL4A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13625
X-Proofpoint-GUID: 0x0XbyyY93bbwjNgvedZxvcIhmltniUv
X-Proofpoint-ORIG-GUID: 0x0XbyyY93bbwjNgvedZxvcIhmltniUv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDAwMiBTYWx0ZWRfX3LjtTOQFWMcd
 kFSrYRkyStCkBBjOp1bL5PNdLCgVOF09lHGpu5p2WsCybBPVOEluT94NGtXN8VemEXo/52PoVZd
 gYFeL0bNw0KDIUT137zNz5nlAHxAnkmnlbvu9Ry5l6gzw8AnfQR3UorPfazb2Bd6Iuu3GMH2AvG
 6JMIhUWsnndg77/AZmUFIAaL0Aoeg2MiV5FlYf1173y97XIRdQcFt9IPMqve7YyC/+TyPV2HWoh
 xJ7IYFaJ/STckOsXkn6gn88yI7kE86CVUyPHIgb+OAToK7jVmCikHBZPwVadNryedlN4lE+XeiJ
 JxtQNCrOepVmKOddSvwGBycRTx1iqCaLoh50dihDMbc5I4aU6yh5p6cOJlQ5e20reokcdtPpS8U
 8I6jjsKzu59v+LgbHE6c21f8aENpd+fkjUYUOr+zVskChL7Eqec=

On Mon, 29 Sep 2025 18:09:39 -0700, Daniel Lee wrote:

> Call sysfs_update_group() after reading the device descriptor
> to ensure the HID sysfs attributes are visible when the feature
> is supported.
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: ufs: sysfs: Make HID attributes visible
      https://git.kernel.org/mkp/scsi/c/bb7663dec67b

-- 
Martin K. Petersen
