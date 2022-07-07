Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D572C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbiGGVrj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbiGGVrh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:47:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097F132078
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 14:47:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCRGB003646;
        Thu, 7 Jul 2022 21:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=L60gjeWURG7QzjAe51F5k5CBVw2cEBVAPXznfK2iLpk=;
 b=DpRMalAkOO4Q87fBBUhdMLuLysW9NFCY4StLxq8LW6hIFEug/BSuz8CATFywtWl5zZsn
 YSoa83Rcx7W13j+IGpDX8zZpZQwd9gmTUK/dQmKYrmOQyy/grNzPwYMxAGFu301WP8fu
 0ayd2o5mbpdtriS+obUg0BmloyO8gEMgq2L7r9UU78UceN3mogjoweI+O1BXxUJuE7VV
 ihK6VRQsgSjt9B3g+ngYSlBh1OuMbzb2itB2J7pzSI48ra2U3x4Snsgl+Ggz6ufe7c1H
 M7WYlNYcfuI9HHqh9imylq+yQlhZTaj5k7eEvB4fEvAWZQyDP+cyuX3vVc5oLImcj74n WQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubye73v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:47:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LjMcd030293;
        Thu, 7 Jul 2022 21:47:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud7c5dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:47:30 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 267LlRsc033607;
        Thu, 7 Jul 2022 21:47:29 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud7c5ag-3;
        Thu, 07 Jul 2022 21:47:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Chanwoo Lee <cw9316.lee@samsung.com>, bjorn.andersson@linaro.org,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com, agross@kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sh043.lee@samsung.com, jt77.jang@samsung.com,
        dh0421.hwang@samsung.com, grant.jung@samsung.com
Subject: Re: [PATCH] scsi: ufs-qcom: Remove unneeded code
Date:   Thu,  7 Jul 2022 17:47:22 -0400
Message-Id: <165723020283.18731.16395025181277309277.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627235545.16943-1-cw9316.lee@samsung.com>
References: <CGME20220627235926epcas1p22a6327d6c47f48012e853aec3c8b2fe3@epcas1p2.samsung.com> <20220627235545.16943-1-cw9316.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: IoV-CFb1YfL0c9AMxhgqOv5A1_U9mdYR
X-Proofpoint-ORIG-GUID: IoV-CFb1YfL0c9AMxhgqOv5A1_U9mdYR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Jun 2022 08:55:45 +0900, Chanwoo Lee wrote:

> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> Checks information about tx_lanes, but is not used.
> 
> Since the commit below is applied, tx_lanes is deprecated.
>  'commit 1e1e465c6d23
>   ("scsi/ufs: qcom: Remove ufs_qcom_phy_*() calls from host")'
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi: ufs-qcom: Remove unneeded code
      https://git.kernel.org/mkp/scsi/c/bcec04b3cce4

-- 
Martin K. Petersen	Oracle Linux Engineering
