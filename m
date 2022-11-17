Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2288C43219
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240516AbiKQS3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240524AbiKQS3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:29:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE8F7D51C
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:29:41 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHHhqa6028297;
        Thu, 17 Nov 2022 18:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=epy++eZYuEUWoDQyv5+LjDGB/5IvkisxjciH1HmMKfo=;
 b=OqcJk54csQEXd6k7JlIeoZsoFko2+4cFP6zt3gzEcDx2F10odTEoSqz0hL46kb3TPmJi
 6HzTE6FutXddl0UWHP+zMLf+rKXLgtGAPxyWFOb1Xa5UrC6zqiCkqKC+0fE0Rx6WHrDc
 cp28DYdAEk/0Y0GBKjkb8cSjAvcnCpVgF68clf/Pycrfy3Ebz07Yf9k6Gu2FSFoDvKMa
 dQ2lDYc67CKzvIc+YizXt3jKZRCdt/N/qKHK0h7ekxiyvJZcUS8+hZlTHF8PfXq+tei9
 pzFQA9gpjTaF5F/RHyTPfuKCc68/wJcOzQnC6RpPCCzO9cA3u1MnkjMxQkoJoxhYlZ0M TA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv8ykt0us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:29:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHHHmUq010917;
        Thu, 17 Nov 2022 18:29:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ku3kab0gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:29:36 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHITap1022894;
        Thu, 17 Nov 2022 18:29:36 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ku3kab0gb-1;
        Thu, 17 Nov 2022 18:29:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] Call scsi_device_put() from non-atomic context
Date:   Thu, 17 Nov 2022 13:29:23 -0500
Message-Id: <166870943119.1584889.5824077853820808172.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221031224728.2607760-1-bvanassche@acm.org>
References: <20221031224728.2607760-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170133
X-Proofpoint-GUID: ohCUdbZimFfQIBx_mQ2E5ENWghXjQlAH
X-Proofpoint-ORIG-GUID: ohCUdbZimFfQIBx_mQ2E5ENWghXjQlAH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 Oct 2022 15:47:24 -0700, Bart Van Assche wrote:

> As reported by Dan Carpenter, a recent change may cause scsi_device_put() to
> sleep while a few callers remain that call scsi_device_put() from atomic
> context. This patch series converts those callers. Please consider this patch
> series for the 6.0 kernel.
> 
> Thanks,
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/4] scsi: alua: Move a scsi_device_put() call out of alua_check_vpd()
      https://git.kernel.org/mkp/scsi/c/0b25e17e9018
[2/4] scsi: alua: Move a scsi_device_put() call out of alua_rtpg_select_sdev()
      https://git.kernel.org/mkp/scsi/c/379e2554e3d1
[3/4] scsi: bfa: Convert bfad_reset_sdev_bflags() from a macro into a function
      https://git.kernel.org/mkp/scsi/c/2e5a6c3baccd
[4/4] scsi: bfa: Rework bfad_reset_sdev_bflags()
      https://git.kernel.org/mkp/scsi/c/2e79cf37b15b

-- 
Martin K. Petersen	Oracle Linux Engineering
