Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AEFC6FA99
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjCGC5s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCGC5q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:57:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3938F65057
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:57:46 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NwksI021394;
        Tue, 7 Mar 2023 02:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=c2T3JZTAhU/MPxakeKFyS/8LiNvS7HkER3FiHYBJYoM=;
 b=SGdOdMZbm2RxOetNutvMTn1QULAGxblcwGyMZfDrGA1Y+ncU2UxqUhLnglAOwG4nHNaK
 wSPhZFTCPSBS+2Scjwi6FLK6kQgnHSJqRD8QJcjiqHh1tG+i3T0cjUvHmKaN0uXw279x
 xxHPX/z2Uw891bEnT3x4FTt7Qskhcy5Afq1kBSZVr8OCY3qT9sfh4VVFiEo+ZoJ01wpR
 97UhVlZcAokQXJLI7q+ji1DL6+OChHx1Jp3UXfytOrXbXWwgmA2v0KAz5+xhO2gCztQX
 1mxxidrrUvsDOkRQfnLOLjTuCtAEhnmZCnMc3A7n3iZRY5HM4Etf90ig1+hHl9KeauF0 5A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415hvhfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3271Sx3E037521;
        Tue, 7 Mar 2023 02:57:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txdvjm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:43 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3272vY2S009567;
        Tue, 7 Mar 2023 02:57:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p4txdvjhj-10;
        Tue, 07 Mar 2023 02:57:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH REPOST] scsi: sd: Fix wrong zone_write_granularity value at revalidate
Date:   Mon,  6 Mar 2023 21:57:27 -0500
Message-Id: <167815780211.2075334.4842291986023970461.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230306063024.3376959-1-shinichiro.kawasaki@wdc.com>
References: <20230306063024.3376959-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=546 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070025
X-Proofpoint-GUID: nETbdHxkvBqHKMoDrWfHKGrCkdOHxZ49
X-Proofpoint-ORIG-GUID: nETbdHxkvBqHKMoDrWfHKGrCkdOHxZ49
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 06 Mar 2023 15:30:24 +0900, Shin'ichiro Kawasaki wrote:

> When sd driver revalidates host-managed SMR disks, it calls
> disk_set_zoned() which changes the zone_write_granularity attribute
> value to the logical block size regardless of the device type. After
> that, the sd driver overwrites the value in sd_zbc_read_zone() with
> the physical block size, since ZBC/ZAC requires it for the host-managed
> disks. Between the calls to disk_set_zoned() and sd_zbc_read_zone(),
> there exists a window that the attribute shows the logical block size as
> the zone_write_granularity value, which is wrong for the host-managed
> disks. The duration of the window is from 20ms to 200ms, depending on
> report zone command execution time.
> 
> [...]

Applied to 6.3/scsi-fixes, thanks!

[1/1] scsi: sd: Fix wrong zone_write_granularity value at revalidate
      https://git.kernel.org/mkp/scsi/c/288b3271d920

-- 
Martin K. Petersen	Oracle Linux Engineering
