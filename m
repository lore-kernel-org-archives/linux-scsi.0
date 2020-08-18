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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C61C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD79206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wcX8irhS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgHRDL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:11:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56774 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgHRDLY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:11:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38BPt134801;
        Tue, 18 Aug 2020 03:11:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=NJGb42kxruDBKZkQiR9AvBZ8NfWLrCnFLNTcQTTcufI=;
 b=wcX8irhSaGVj6CEsRINYFiJUXssYEnVzx4GszSAY8vouBomYTBopqAM3AjeC1olC7ZUc
 itADdXlIHnqGcRlQcfC0CadyTFEovhmCct1lR8DifiQiWR6FfbwuVgkUbGEtXVfXv5c1
 2ifcjLpYU6dwN9/8invyFkOpLBNVQXFGGsck4ijwu9yj1mC3uWN5C73zT4M4G/27cFPt
 pmn8ik54SqGNW4h3Hi9GPbLNG46nPS9PPsio3ta/kvqgY/9IcHbyBMM2wAA8zprKPBkl
 JkdJw10zqB6GsXuEtpFvHd8xt1FykZE23BvjC3Cqa9FdZ6LDxho5pvJjFNmHqRMlZcYk Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74r2798-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:11:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I37jNi111691;
        Tue, 18 Aug 2020 03:11:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32xsm1q1tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:11:21 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07I3BKk1020113;
        Tue, 18 Aug 2020 03:11:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:11:19 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/7] qedf: Misc fixes for the driver.
Date:   Mon, 17 Aug 2020 23:11:13 -0400
Message-Id: <159772022968.19349.5116654525336166344.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200807110656.19965-1-jhasan@marvell.com>
References: <20200807110656.19965-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 7 Aug 2020 04:06:49 -0700, Javed Hasan wrote:

> This series has misc bug fixes and code enhancements.
> 
> Kindly apply this series to scsi-queue at your earliest convenience.
> 
> Thanks,
> ~Javed
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/7] scsi: qedf: Check for port type and role before processing an event
      https://git.kernel.org/mkp/scsi/c/04fedba774e8
[2/7] scsi: qedf: Check the validity of rjt frame before processing
      https://git.kernel.org/mkp/scsi/c/df89b0e5bfad
[3/7] scsi: qedf: Do not kill timeout work for original I/O on RRQ completion
      https://git.kernel.org/mkp/scsi/c/76693f4f1e2d
[4/7] scsi: qedf: Send cleanup even for RRQ on timeout
      https://git.kernel.org/mkp/scsi/c/8ea8f3eae8e5
[5/7] scsi: qedf: Initiate cleanup for ELS commands as well
      https://git.kernel.org/mkp/scsi/c/170ce800ed5c
[6/7] scsi: qedf: Don't process ELS completion if event is flushed or cleaned up
      https://git.kernel.org/mkp/scsi/c/49cf23e02935
[7/7] scsi: qedf: Fix race between ELS completion and flushing ELS request
      https://git.kernel.org/mkp/scsi/c/9acf1f771914

-- 
Martin K. Petersen	Oracle Linux Engineering
