Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403B2C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 17:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 139BD20826
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 17:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FKjA0GEr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgEURoI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 13:44:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728542AbgEURoI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 13:44:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LHhKDe026948;
        Thu, 21 May 2020 17:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=rXuu1XX2MEdFBZfGOAQZalRM3Pz3ov5tuSWeDa/8opg=;
 b=FKjA0GErHFaM57nw6b4AVeDB1C2HJZL0arvPdqJyj8qJkyDslgxPuESCD16vFVCPWc3X
 jnP+uT81Z0vW6p7tWsV6/46eeBpVZ8nhE182tLroNZ/GmLUNh2Bw93T1Sjo6G+8WeAjO
 FWv4Oe401I4x+/nQTJeLutYAHjzi7srCaj5fu8bGLKDRRytqqR9D8HVqQiYcNpg9dLKU
 Z8A1c3JtrvuzjpTLmosm33NmapRDo1ZBEYtujl1eYQCMhOo/q9GJ2gFqONn7g/wP/Ky2
 +0pVZkaaI8ZThbU7r4KQtV2gtWjbaW7bpEal3va3Yh8okXGhD83PtLoUzIKXfvD2y0Mr Yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krhw2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 17:44:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LHdE9n191950;
        Thu, 21 May 2020 17:42:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t3bvkj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 17:42:05 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04LHg3FX024793;
        Thu, 21 May 2020 17:42:04 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 10:42:03 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com, ssudhakarp@gmail.com
Subject: [PATCH 0/3] target: fix NULL pointer dereference
Date:   Thu, 21 May 2020 17:41:48 +0000
Message-Id: <1590082908-884-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005210128
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following set of commits address a NULL pointer dereference and some
refactoring around this issue.

Sudhakar Panneerselvam (3):
  target: factor out a new helper, target_init_cmd_from_cdb()
  target: fix NULL pointer dereference
  target: rename target_setup_cmd_from_cdb() to target_parse_cdb()

 drivers/target/iscsi/iscsi_target.c    | 21 +++++++++++++--------
 drivers/target/target_core_transport.c | 27 +++++++++++++++++++++------
 drivers/target/target_core_xcopy.c     |  5 ++++-
 include/target/target_core_fabric.h    |  3 ++-
 4 files changed, 40 insertions(+), 16 deletions(-)

-- 
1.8.3.1

