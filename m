Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CCDC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 11:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF57020706
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 11:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m6ft64qd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgHYLU0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 07:20:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41584 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbgHYLU0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2020 07:20:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PBFIW4163978;
        Tue, 25 Aug 2020 11:20:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=f/ZPCxc9vZ8nAlaGk1YqszjChxqmeTSTY+ksjeTGrSk=;
 b=m6ft64qdZ8B6jazxp7+AzB7DpnpkrmpC/8QhWMU7SIBeqmu/vULeR7nPUL26RPC5O9he
 qyJC7wUz5VSZKlez4ZcypIFa1sKuL/Bve82nMkpb9K6vY3qKhwIi8ghiHi45U64mwUJZ
 nBt6iRf2NBbX51PKuU8xI2qa8ad73Xr4rf2trkT5A/bKB1BcSZtMqkFZHleAEmWbTZy9
 sUSwpiFYnATkTMTnZxqvdn0TWDK5El9wOw1kC9+9gMOMj/EqMHnmlqAk6hdkq5lo8Lsv
 6o7WeIdldf7j4V1owQtYfT383MTLWIibQikc6+XnKfk5QLYVj6JGLOTiGj5fXZ0oRQYY WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 333csj1wn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 11:20:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PBFIce160579;
        Tue, 25 Aug 2020 11:20:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 333r9je5vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 11:20:14 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07PBKBPY029763;
        Tue, 25 Aug 2020 11:20:12 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Aug 2020 04:20:11 -0700
Date:   Tue, 25 Aug 2020 14:20:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Raghava Aditya Renukunta 
        <RaghavaAditya.Renukunta@microsemi.com>,
        Dave Carroll <David.Carroll@microsemi.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: aacraid: remove erroneous fallthrough annotation
Message-ID: <20200825112003.GD285523@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 clxscore=1011
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250085
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fallthrough annotation is unreachable so we can delete it.

Fixes: c4e2fbca374b ("scsi: aacraid: Reworked scsi command submission path")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/aacraid/aachba.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index fd6ae5c38086..2fb1881954c7 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3253,7 +3253,6 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	case START_STOP:
 		return aac_start_stop(scsicmd);
 
-		fallthrough;
 	default:
 	/*
 	 *	Unhandled commands
-- 
2.28.0

