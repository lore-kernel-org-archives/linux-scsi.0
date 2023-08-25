Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E89EE49B0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbjHYBOA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbjHYBNn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:13:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153A01BFE;
        Thu, 24 Aug 2023 18:13:42 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEUSZ007510;
        Fri, 25 Aug 2023 01:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=rjsC85RENWknezGj7Kf3T7z4R6Yd3yLs1XWNWLKCQas=;
 b=TVSX/wzd3/3MUDy7p5R4O9BqDLCVs8trNJx4ja2bDQO1BGPOXFn603vemlg5yQKgSICZ
 9TS5U+dfbN3h7QqgT8qmu6w4ecUj/V6CLwIdhOfbo62wgmTPusRwBoH5keZz2LYdMyfo
 Rxx3A8mn7K/fns9CFil2tvVvxev+guXbfqAk9Jo63WuQ2+UySHWcfe4QXttJR99puuGE
 IyLQaeNzDYlO0hcB8bkR/dJ0/U0plt02QniEDVBnTa3QcrA+FAe1K1CNIjgkubVQx22C
 rfQ+rK+w+Yje50fBo5z+JpRvSqHa4CeTcko1aJGZpU8/6Hka4FQJlk4hHFc8a/MafXpo aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yvwcp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P0FWG9036019;
        Fri, 25 Aug 2023 01:13:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywqfm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:40 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37P1DVEE019787;
        Fri, 25 Aug 2023 01:13:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3sn1ywqf8n-11;
        Fri, 25 Aug 2023 01:13:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: target: Fix write perf due to unneeded throttling
Date:   Thu, 24 Aug 2023 21:12:57 -0400
Message-Id: <169292577178.789945.10446294207547632721.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817192902.346791-1-michael.christie@oracle.com>
References: <20230817192902.346791-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=800 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250009
X-Proofpoint-ORIG-GUID: f9ubiCuTutcZ0SG6rZgkNUq1al92ziWu
X-Proofpoint-GUID: f9ubiCuTutcZ0SG6rZgkNUq1al92ziWu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Aug 2023 14:29:02 -0500, Mike Christie wrote:

> The write back throttling (WBT) code checks if REQ_SYNC | REQ_IDLE is set
> to determine if a write is O_DIRECT vs buffered. If the bits are not set
> then it assumes it's a buffered write and will throttle LIO if we hit
> certain metrics. LIO itself is not using the buffer cache and is doing
> direct IO, so this has us set the direct bits so we are not throttled.
> 
> When the initiator application is doing direct IO this can greatly
> improve performance. It depends on the backend device but we have seen
> where the WBT code is throttling writes to only 20K IOPs with 4K IOs when
> the device can support 100K+.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: target: Fix write perf due to unneeded throttling
      https://git.kernel.org/mkp/scsi/c/84c073fd89de

-- 
Martin K. Petersen	Oracle Linux Engineering
