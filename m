Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F98C00528
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 02:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjHHCoL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjHHCoA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 22:44:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6C61BEA
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 19:43:55 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781i3dt006678;
        Tue, 8 Aug 2023 02:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=tn8T/lbutOnKfq75YZp2hFoIrmaetdJUInAAzfPAzE8=;
 b=gSU98fJSfarQGJX8K2OOGO6ja75A9ar8pbwtJpfsoXE5xdw4Izz4vABN/J4sSjQxt0pF
 5DBU56/MekAcu3Tl7Lk2JIz1CmysP0y5LHLsaLF3+dOUT0Th4Fle/302VasMSPbEbkDN
 jUrUC1LUoiJn4BVa8J1OMjr7x+aS40nbEPp9eMqBZTCp0hzr4Fq9kAlOrXT2VGtY9nzw
 p1GTikc958d9K5s0odrgCZnAUMMCUKKRTFhBobWpLqiPdR9hFFDrDnfGfLxB3NCXZOho
 oZpCtpMVbv+nE0DWlir9PAN7N0J5RqMTRk/FETm8LIx0jq8+DfNkRqL5r+sugpkuhEJ1 Yg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9dbc45qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 377NW0bd027353;
        Tue, 8 Aug 2023 02:43:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv55wgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:37 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3782hYGt038171;
        Tue, 8 Aug 2023 02:43:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3s9cv55wfu-6;
        Tue, 08 Aug 2023 02:43:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, kay.sievers@vrfy.org, tonyj@suse.de,
        gregkh@suse.de, linux-scsi@vger.kernel.org, bvanassche@acm.org,
        Zhu Wang <wangzhu9@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next v3] SCSI: fix possible memory leak while device_add() fails
Date:   Mon,  7 Aug 2023 22:43:27 -0400
Message-Id: <169146257046.4040705.7546274600881851767.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230803020230.226903-1-wangzhu9@huawei.com>
References: <20230803020230.226903-1-wangzhu9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=982 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308080022
X-Proofpoint-ORIG-GUID: 7iMPSumExMaTRVl8zhKghuJtroFdjQPR
X-Proofpoint-GUID: 7iMPSumExMaTRVl8zhKghuJtroFdjQPR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 03 Aug 2023 10:02:30 +0800, Zhu Wang wrote:

> If device_add() returns error, the name allocated by dev_set_name() need
> be freed. As comment of device_add() says, it should use put_device() to
> decrease the reference count in the error path. So fix this by calling
> put_device, then the name can be freed in kobject_cleanp().
> 
> 

Applied to 6.5/scsi-fixes, thanks!

[1/1] SCSI: fix possible memory leak while device_add() fails
      https://git.kernel.org/mkp/scsi/c/04b5b5cb0136

-- 
Martin K. Petersen	Oracle Linux Engineering
