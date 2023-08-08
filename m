Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06F5C00528
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 02:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjHHCul (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjHHCuj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 22:50:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1F619F;
        Mon,  7 Aug 2023 19:50:39 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781iQsx030975;
        Tue, 8 Aug 2023 02:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=WVgIlNqXBWHsezbX4KfLFGIvBpSxXRn+qWiS+I1CSeo=;
 b=hpJMmbp6I7Nsy+kCGC3cAt7NAoxShtAniXm71vSIUhvuHF6z0GEoB9koXlybRJGAwwnF
 7L/I3zTdUdTy354FzbUyF+y7fQyIiqcK3QvXW7DuyhjPx7ZvryvwsFWRgwsjYvaMlg1K
 wUAn89eGqS1P1zHPGLz2+yG5KPTEzxDywHHUdcfOeI2N19/BsMkNzVQSdlAH0nzwQ+sj
 snY7q/DQ9iRzsGgQzTjSxA/B71X6N/9tTuzvPpOOQtiMdxsFsbVBnubvtBxpblQKclnO
 u8oOp97Z58BBLmIJulut1jrj586H8Vyl+xIs/XVDSiLxX7DUCb6vkfV3s95H0N0nRxaV 8w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9d12c5wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:50:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3782dITX027678;
        Tue, 8 Aug 2023 02:50:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv561n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:50:36 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3782oadc010815;
        Tue, 8 Aug 2023 02:50:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3s9cv561mp-2;
        Tue, 08 Aug 2023 02:50:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com
Subject: Re: [PATCH 0/2] scsi: target: iscsi: Get rid of sprintf in iscsi_target_configfs.c
Date:   Mon,  7 Aug 2023 22:50:27 -0400
Message-Id: <169146270849.4040832.10944640625308030970.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230722152657.168859-1-k.shelekhin@yadro.com>
References: <20230722152657.168859-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=336 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308080023
X-Proofpoint-GUID: Oj2feA8MACF-3Iml3joqVcP7Z8_GVNtb
X-Proofpoint-ORIG-GUID: Oj2feA8MACF-3Iml3joqVcP7Z8_GVNtb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 22 Jul 2023 18:26:36 +0300, Konstantin Shelekhin wrote:

> This patch series cleanses iscsi_target_configfs.c of sprintf usage. The
> first patch fixes the real problem, the second just makes sure we are on
> the safe side from now on.
> 
> I've reproduced the issue fixed in the first patch by utilizing this
> cool thing:
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/2] scsi: target: iscsi: Fix buffer overflow in lio_target_nacl_info_show
      https://git.kernel.org/mkp/scsi/c/801f287c93ff
[2/2] scsi: target: iscsi: Stop using sprintf in iscsi_target_configfs.c
      https://git.kernel.org/mkp/scsi/c/c0431feb0a75

-- 
Martin K. Petersen	Oracle Linux Engineering
