Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB801C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240531AbiKQS3A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbiKQS2t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:28:49 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7AC7C033
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:28:48 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHGFMd9007332;
        Thu, 17 Nov 2022 18:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=fw3I2zsQGhZu6WFlYt7saWJeU4sm/tKx0h5IvcvogBA=;
 b=FVUMQj0NycNZnzkHURkjKGBqCJOqOs+r2ZBvT6MfOmU7eBWoDnf/VA/jOt39j2miq7uU
 gUzukm3YfTgqOBwN2Vm6q/VRhjJ5BSZLiPkw/GjhUcKFS8z6G9AprCqMpFJ84t8z4fJC
 H5t153SiAk6rQpZBBETW+HrCqh3S/V5og5DTXU5q4zXePvZfe5t88a9D3BrKymo6XYVK
 1cZySfUSG/lvmQxG5bORDBG6Bzfpq6XoYCVd19pS3cry9xahMYa5yhsCgz3VpbcVfFm3
 HB7fqeYEpgVfKCvyiY5nhiE9iPqZw/XPtL7sWLtzfNkmP/HG7/tHPyV2XClGYtHEdrBM rQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3nsa6f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHHN0BO008693;
        Thu, 17 Nov 2022 18:28:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xft5rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:39 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHISanu025586;
        Thu, 17 Nov 2022 18:28:38 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kt1xft5pj-4;
        Thu, 17 Nov 2022 18:28:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Yuan Can <yuancan@huawei.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()
Date:   Thu, 17 Nov 2022 13:28:34 -0500
Message-Id: <166870940538.1572108.12555117922187963833.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221117084421.58918-1-yuancan@huawei.com>
References: <20221117084421.58918-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170133
X-Proofpoint-GUID: gLCWAZc2ez8Ma87NPuh_hdy-A-HbtUbT
X-Proofpoint-ORIG-GUID: gLCWAZc2ez8Ma87NPuh_hdy-A-HbtUbT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Nov 2022 08:44:21 +0000, Yuan Can wrote:

> If device_register() fails in sdebug_add_host_helper(), it will goto clean
> and sdbg_host will be freed, but sdbg_host->host_list will not be removed
> from sdebug_host_list, then list traversal may cause UAF, fix it.
> 
> 

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()
      https://git.kernel.org/mkp/scsi/c/e208a1d795a0

-- 
Martin K. Petersen	Oracle Linux Engineering
