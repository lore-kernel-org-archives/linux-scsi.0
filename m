Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321D5C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 03:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BEF4206EB
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 03:23:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZjMmz7t4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgGADXt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 23:23:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGADXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 23:23:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0613IBvI151984;
        Wed, 1 Jul 2020 03:23:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=dg/1C3xLoyHGDDIp3rRy9JJ505zSZt2XCWqsk48jMQQ=;
 b=ZjMmz7t4mJzdvULtnsX4hM9fw4rBBGsDBw9oPsi1gh6aZRChVlE+I8C8aSYmtWuQQJYv
 TJneqVicGhTUvIkL/MF1s90Vej31ca4e0LaHywz1blOUwOHJ1q1EZPAXDtq+XoSOpkzI
 B/ryWIvjqtIjMIwXNDLOL7cIdRRIFcWilcNbHFpveIb8PlZ7//XwAFhdXXiEOywJSGw7
 xsNWazmNwLYyjDmbbvo9S4sOjkIgCLZwIlkyAe5cg4XSlCSbGV+feVZLm8nxqVIF2pco
 TlqXgcbjS6GxOktxy1u0gtXo9JjJqKSyGFT1Hllg/aiwbQj6r4bKiSWh2AzV8IYJPYJW 3A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrn7wxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 03:23:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0613IhWU056760;
        Wed, 1 Jul 2020 03:23:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31xg1544sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 03:23:44 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0613Nf9l026041;
        Wed, 1 Jul 2020 03:23:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 03:23:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/9] qla2xxx patches for kernel v5.9
Date:   Tue, 30 Jun 2020 23:23:40 -0400
Message-Id: <159357380640.11551.3183785758303195996.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=943 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=953
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1011
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010021
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 Jun 2020 15:54:45 -0700, Bart Van Assche wrote:

> This patch series includes cleanup patches and also patches that address
> complaints from several static source code analyzers. Please consider these
> patches for kernel v5.9.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/9] scsi: qla2xxx: Check the size of struct fcp_hdr at compile time
      https://git.kernel.org/mkp/scsi/c/a7f474542ea3
[2/9] scsi: qla2xxx: Remove the __packed annotation from struct fcp_hdr and fcp_hdr_le
      https://git.kernel.org/mkp/scsi/c/f1e12bee55e6
[3/9] scsi: qla2xxx: Make qla82xx_flash_wait_write_finish() easier to read
      https://git.kernel.org/mkp/scsi/c/2f91a0a03c2d
[4/9] scsi: qla2xxx: Initialize 'n' before using it
      https://git.kernel.org/mkp/scsi/c/67668b5b13c7
[5/9] scsi: qla2xxx: Remove a superfluous cast
      https://git.kernel.org/mkp/scsi/c/9bb013584a5e
[6/9] scsi: qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32 bits of request_t.handle
      https://git.kernel.org/mkp/scsi/c/f8f12bda53ea
[7/9] scsi: qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()
      https://git.kernel.org/mkp/scsi/c/57fec9f24e58
[8/9] scsi: qla2xxx: Make qla2x00_restart_isp() easier to read
      https://git.kernel.org/mkp/scsi/c/f85a299f5ec5
[9/9] scsi: qla2xxx: Introduce a function for computing the debug message prefix
      https://git.kernel.org/mkp/scsi/c/e7019c95c40d

-- 
Martin K. Petersen	Oracle Linux Engineering
