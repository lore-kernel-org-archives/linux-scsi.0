Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A76C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 19:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073AB2074B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 19:58:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zhgXWCVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgFGT6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 15:58:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgFGT6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 15:58:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057JqJVB081030;
        Sun, 7 Jun 2020 19:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=dMp7o5Ck1CvXRSlE+ap4JT1ziPeIzGDf/JaWyBhbkMM=;
 b=zhgXWCVMNW4ZUbR9ihEC+AiDi0Eu7+yaw7dYLnfKoBX1CLGQm2WOtuoNNdDe05typWB5
 zEfnaouxOsvGhbbQC/s3t5O0cBEJcjXFNG5mNuW0XgUO1DY3kolDaPaJarszJ+ASRqjb
 CDw0lygYf6r1P9liSGwLSN6ivvlSXXpm3GJe8dxiU7f8EX8TzhK4nUgAecGJSuLHg8IS
 7WHMOERjIIK2UTV1bAal1pntjZouiZP9+FF06sOuoupsnpFWF4Iq6neT3yDIXP2NnSd5
 rsMWfRaQq59vuK95MGVyrke7R4SMMroqEkKhqwlmSRQj5UVE+WCMDfi78XPXWUL5VYiq Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31g3smkw0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 19:58:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057JwX8N132811;
        Sun, 7 Jun 2020 19:58:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31gmwnxraf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 19:58:41 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057JwemW008213;
        Sun, 7 Jun 2020 19:58:40 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 12:58:40 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
Subject: [PATCH v4 0/4] target: fix NULL pointer dereference
Date:   Sun,  7 Jun 2020 19:58:29 +0000
Message-Id: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006070155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following set of commits address a NULL pointer dereference and some
refactoring around this issue.

v4:
 - initialize the LUN in transport_init_se_cmd()

v3:
 - fix NULL pointer dereference when cdb initialization fails

v2:
 - new helper is named as target_cmd_init_cdb()
 - existing function, target_setup_cmd_from_cdb is renamed as
   target_cmd_parse_cdb()

Sudhakar Panneerselvam (4):
  target: factor out a new helper, target_cmd_init_cdb()
  target: initialize LUN in transport_init_se_cmd().
  target: fix NULL pointer dereference
  target: rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()

 drivers/target/iscsi/iscsi_target.c    | 29 ++++++++++--------
 drivers/target/target_core_device.c    | 19 +++++-------
 drivers/target/target_core_tmr.c       |  4 +--
 drivers/target/target_core_transport.c | 55 ++++++++++++++++++++++++++--------
 drivers/target/target_core_xcopy.c     |  9 ++++--
 drivers/usb/gadget/function/f_tcm.c    |  6 ++--
 include/target/target_core_fabric.h    |  9 +++---
 7 files changed, 83 insertions(+), 48 deletions(-)

-- 
1.8.3.1

