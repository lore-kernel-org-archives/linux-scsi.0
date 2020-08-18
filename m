Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB32C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99B9B2076D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gGtI0ekF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgHRDLa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:11:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgHRDLZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:11:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I36u8S113699;
        Tue, 18 Aug 2020 03:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=koOeD6UZysXMCr07CSiEZl9Zbiz8qg++oVLz6RmXqaU=;
 b=gGtI0ekFUJKOxblzlyr+4fd/JQzbkKocN6l6mT7hEIx7OsTOrGvt3tyra7gLUpzb5Z1c
 Xj3jX7p6ihdGv2fUVEt+ycZlKBCzz7aYy8B9bHFqpWARnbiR5IPlxEyYn+c5U1561qeP
 vn924n6zRjKC99RljoCZsNU8YSW1SyPDSZMw8c+QmTVwdMjboY6lZvbl9oX+tVE8SyGs
 C9U42dUAEfyClsUBvBnZANxMO3GOwnz5DWXnnmOp6l5OP8Mjs8s6XgpIr8l/xZvL20bb
 tO3QXfWHiH9AGnf7KfG3LmySJSu3eAyGahNj0zsF7jmQHItCcL8LEMk78F7mByEbUwoH iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32x8bn22kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:11:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38711131287;
        Tue, 18 Aug 2020 03:11:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32xs9mf38r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:11:22 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07I3BMe3019891;
        Tue, 18 Aug 2020 03:11:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:11:21 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/7] mpt3sas: Enhancements and bug fixes
Date:   Mon, 17 Aug 2020 23:11:15 -0400
Message-Id: <159772022967.19349.10811255364155630321.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Jul 2020 13:33:42 +0530, Suganath Prabu S wrote:

> This patch set has below bug fixes and enhancements.
> 
> Dump IOC system interface register set when IOC fails to
> transit to READY state during initialization.
> 
> During controller reset, cancel the running work along
> with the queued works. This avoids processing the expired event after
> the controller reset.
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/7] scsi: mpt3sas: Memset config_cmds.reply buffer with zeros
      https://git.kernel.org/mkp/scsi/c/01348b76fa82
[2/7] scsi: mpt3sas: Dump system registers for debugging
      https://git.kernel.org/mkp/scsi/c/7f3cca0f1f54
[3/7] scsi: mpt3sas: Cancel the running work during host reset
      https://git.kernel.org/mkp/scsi/c/b5f025c3f702
[4/7] scsi: mpt3sas: Rename and export interrupt mask/unmask functions
      https://git.kernel.org/mkp/scsi/c/87a1cbcfe55b
[5/7] scsi: mpt3sas: Add functions to check if any cmd is outstanding on Target and LUN
      https://git.kernel.org/mkp/scsi/c/844b4f05661e
[6/7] scsi: mpt3sas: Postprocessing of target and LUN reset
      https://git.kernel.org/mkp/scsi/c/caa596babea7
[7/7] scsi: mpt3sas: Update driver version to 35.100.00.00
      https://git.kernel.org/mkp/scsi/c/d2101b4ee8f8

-- 
Martin K. Petersen	Oracle Linux Engineering
