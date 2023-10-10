Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C065CD68E3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 02:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441800AbjJJCJp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 22:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379354AbjJJCJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 22:09:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE50DA7
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 19:09:43 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 399Nwq0a004665;
        Tue, 10 Oct 2023 02:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=RWlh4g+lfyRzcmMVDBfXBjYgKACljzz4N40er8FiAHs=;
 b=ikXGDdVPIdNKTb5R+LxvnH+ZaN5/KiXzTPNnI0PwsmOX3yIlDF+LydhO2E4qu2GFnQj/
 xkLyYl64McrnOOIGyrVKDcYbZbfcY1RF4uWdeBilpo50y50VQ02NnTa4Q0vNRaMJgDVe
 6d9y+hCRFSOJ6Z5KbnZPy+WF1zAOoeyKBORr6gubt7Dk0c1zgZefp1qQ5Dw6ULG8o9XK
 lEAxrwk/mEFUPYyWZhCFKCXNTQb9KF4IHG0tEbokFDeNU8trrn7wbMdE88dJq/8xfeqX
 K/iNu31m+A4gINZ4pWvhJantR9fKhChgwVY2DkrOCz9xxjhf02BdUUfvK8UOHh95cdAc Mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjx43m152-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 02:09:41 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39A1BKms015185;
        Tue, 10 Oct 2023 02:09:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tjws63mae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 02:09:40 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A29dUI036611;
        Tue, 10 Oct 2023 02:09:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tjws63m9y-1;
        Tue, 10 Oct 2023 02:09:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/4] UFS core patches
Date:   Mon,  9 Oct 2023 22:09:32 -0400
Message-Id: <169690017521.1410956.2552630185220721051.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921192335.676924-1-bvanassche@acm.org>
References: <20230921192335.676924-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_01,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310100013
X-Proofpoint-ORIG-GUID: QHGJBfu1ccAZhFIKVUUlEYZVo8dWTQjm
X-Proofpoint-GUID: QHGJBfu1ccAZhFIKVUUlEYZVo8dWTQjm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 Sep 2023 12:22:45 -0700, Bart Van Assche wrote:

> Please consider these UFS core patches for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> Changes compared to v1:
> - In patch 1/4, instead of preserving the WARN_ONCE() statements, remove these.
> - Added a reference to CDL in the description of patch 4/4.
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/4] scsi: ufs: Remove request tag range checks
      https://git.kernel.org/mkp/scsi/c/cdaaff61d3bf
[2/4] scsi: ufs: Move the 4K alignment code into the Exynos driver
      https://git.kernel.org/mkp/scsi/c/858231bdb223
[3/4] scsi: ufs: Simplify ufshcd_comp_scsi_upiu()
      https://git.kernel.org/mkp/scsi/c/c788cf8a21cd
[4/4] scsi: ufs: Set the Command Priority (CP) flag for RT requests
      https://git.kernel.org/mkp/scsi/c/00d2fa28da0a

-- 
Martin K. Petersen	Oracle Linux Engineering
