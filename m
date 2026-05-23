Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB39344044;
	Sat, 23 May 2026 03:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506173; cv=none; b=oHlLXxq7DRXkWkamc9dO6pgkznTNmU5v0euk/PytWWX89j8cOeOCAwCv2iiPgn7LqOp1Q1sSXS+Yrix6JZMgko11Fx3HJnXYquMqsoLLyy4Lo5uhob/e/S77Pa3ujQY8S1UnGmrYUZ9bMRI7jQ4hQY/Cc0qT2XGE6c24oY6LaYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506173; c=relaxed/simple;
	bh=n/P2KtIhvZSgF2wvCC5uHHqBtJaiVxdB+b0+6gXcKOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UFZYQoTATQFy4iAHXp+RHB01BY97wSr7hR979MOasQ8cB/ngL2CPo9W819ZHaA7hDeIm1IwL0Lqxw3JSNuWNO8oNIuDL0IIZBZEEbjMh4S8of5HiqkDAq2qiWEH7lWOO4HZmWOJOEU5JTtVfHeK4kxYXHrrL5QLq09keeV+nTBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TQ7rfQFZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TQ7rfQFZ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N3FUNS2612422;
	Sat, 23 May 2026 03:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rk41fKHf63GwM7RguDJxDuqi0OLXK71iG9vjpqd3F3E=; b=
	TQ7rfQFZEdbZVUxgAkFx80l1Rdziny1iz6L3Mg+sVeF9OnDjDHGJkADuxD1KvemY
	08VohGuHLQyYFi/lH8JiEbDBhCBMUfEOg3ztvfRqufe5jshzTTwKxicXePHOIYEk
	81dH0nvJrH8v2Wrt/mIg3doFDwQhE0uvd/apgZ6meGXu0y23gULQUh3i54lwvC5r
	4UJnuSuNHoRK72hW7U8N7g/8BLcNFwQnpSxiW2qRPf0LeBgAwUbx0Iq0UA9Cli2e
	zs/j3lIVHtUznx29lya1Pfv48xKoRq/lZNMlt3U1SPsQ/z0sSeT1swI3soPYXV0Y
	yQTKVhP+isdNbYB7o90LLA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb2nb88kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:16:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6Ow032343;
	Sat, 23 May 2026 03:16:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:16:02 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3FvRQ035132;
	Sat, 23 May 2026 03:16:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hstd-6;
	Sat, 23 May 2026 03:16:02 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Hannes Reinecke <hare@suse.de>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Michael Bommarito <michael.bommarito@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Robert Love <robert.w.love@intel.com>, Vasu Dev <vasu.dev@intel.com>,
        Joe Eykholt <jeykholt@cisco.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>, Arun Easi <aeasi@cisco.com>,
        Kees Cook <kees@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: fcoe: reject FIP descriptors with zero fip_dlen in CVL walker
Date: Fri, 22 May 2026 23:15:52 -0400
Message-ID: <177950426866.1557613.15249006407801695142.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518144307.2820961-1-michael.bommarito@gmail.com>
References: <20260518141150.2755252-1-michael.bommarito@gmail.com> <20260518144307.2820961-1-michael.bommarito@gmail.com>
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
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=bPcm5v+Z c=1 sm=1 tr=0 ts=6a111bf4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=3X0X3Jg-_aBW3QstAPsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: TBoD4zc5Bp47Eim-5kc3QwMr_WReTB78
X-Proofpoint-ORIG-GUID: TBoD4zc5Bp47Eim-5kc3QwMr_WReTB78
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX5bhhayBgPDVK
 bG/5B87HEiB20ex5EEr7EHMLYMiqCYBqSF2YCnn1BHiVug6D22ROFDph9VOweh+2jsL6TmMCj1E
 jms3WGZmoaGesT0E/cGi1m+nousGO5k05Hosk968Ps0t87bafSH5KKcc8/3/WzaYf7eC701FiJO
 ITPdCYjhNN5hzCceQQttrkUs4G7+tJGxQ0iXk2gMOVKwUxpEXip1SaULzJg1dzVdkMCq/Vgi0uD
 Fvbc3mEM0udCakZbeAx8MO21czrzW8buK3mAJ9TJ5s6XH5/KfveI4ZmxBj0Yw3ggxf6YzjP+I0u
 VEmqFB2Ufuvaz+shGPgiDMxTasGe7mr7k1mDd/voDVN4FwfEy4yBVk4so/CBMmG5g4jQw4Fe+b4
 dES+jr737dkT+FH2tNyRZWW+7XsJLh80283XhmsN3VBoUxAUDC1tAD+1v8tRwMiFfemzOyE+mgJ
 0JXboEScsONKAGNU8TA==

On Mon, 18 May 2026 10:43:07 -0400, Michael Bommarito wrote:

> drivers/scsi/fcoe/fcoe_ctlr.c::fcoe_ctlr_recv_clr_vlink() advanced
> the descriptor cursor by an attacker-supplied fip_dlen without
> ever requiring dlen >= sizeof(struct fip_desc) in the default
> branch.  The named descriptor cases (FIP_DT_MAC, FIP_DT_NAME,
> FIP_DT_VN_ID) checked their per-type minimum lengths, but a
> FIP_DT_NON_CRITICAL descriptor (fip_dtype >= 128, which the
> standard requires receivers to silently ignore) skipped that
> check entirely.
> 
> [...]

Applied to 7.1/scsi-fixes, thanks!

[1/1] scsi: fcoe: reject FIP descriptors with zero fip_dlen in CVL walker
      https://git.kernel.org/mkp/scsi/c/9eed1bd59937

-- 
Martin K. Petersen
