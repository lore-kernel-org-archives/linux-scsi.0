Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76412C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 09:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EFEC206C3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 09:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgETJLl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 05:11:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34804 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbgETJLk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 May 2020 05:11:40 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6BCF348DF83988F62CA4;
        Wed, 20 May 2020 17:11:38 +0800 (CST)
Received: from huawei.com (10.67.174.156) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 20 May 2020
 17:11:28 +0800
From:   Chen Tao <chentao107@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <tyreld@linux.ibm.com>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>, <paulus@samba.org>,
        <linux-scsi@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <chentao107@huawei.com>
Subject: [PATCH -next] scsi: ibmvscsi: Make some functions static
Date:   Wed, 20 May 2020 17:10:36 +0800
Message-ID: <20200520091036.247286-1-chentao107@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.156]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following warning:

drivers/scsi/ibmvscsi/ibmvscsi.c:2387:12: warning: symbol
'ibmvscsi_module_init' was not declared. Should it be static?
drivers/scsi/ibmvscsi/ibmvscsi.c:2409:13: warning: symbol
'ibmvscsi_module_exit' was not declared. Should it be static?

Signed-off-by: Chen Tao <chentao107@huawei.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 59f0f1030c54..44e64aa21194 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2384,7 +2384,7 @@ static struct vio_driver ibmvscsi_driver = {
 static struct srp_function_template ibmvscsi_transport_functions = {
 };
 
-int __init ibmvscsi_module_init(void)
+static int __init ibmvscsi_module_init(void)
 {
 	int ret;
 
@@ -2406,7 +2406,7 @@ int __init ibmvscsi_module_init(void)
 	return ret;
 }
 
-void __exit ibmvscsi_module_exit(void)
+static void __exit ibmvscsi_module_exit(void)
 {
 	vio_unregister_driver(&ibmvscsi_driver);
 	srp_release_transport(ibmvscsi_transport_template);
-- 
2.22.0

