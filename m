Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C27C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D0364F1D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581413AbhCBSvQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:51:16 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:58265 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382684AbhCBJlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 04:41:36 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UQ4Q0Ci_1614678045;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UQ4Q0Ci_1614678045)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Mar 2021 17:40:52 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     lduncan@suse.com
Cc:     cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: iscsi: Switch to using the new API kobj_to_dev()
Date:   Tue,  2 Mar 2021 17:40:44 +0800
Message-Id: <1614678044-5635-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/scsi/scsi_transport_iscsi.c:4453:61-62: WARNING opportunity
for kobj_to_dev().

./drivers/scsi/scsi_transport_iscsi.c:4309:61-62: WARNING opportunity
for kobj_to_dev().

./drivers/scsi/scsi_transport_iscsi.c:4040:61-62: WARNING opportunity
for kobj_to_dev().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 969d24d..debedcd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4037,7 +4037,7 @@ static ISCSI_CLASS_ATTR(conn, field, S_IRUGO,				\
 static umode_t iscsi_conn_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
-	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct device *cdev = kobj_to_dev(kobj);
 	struct iscsi_cls_conn *conn = transport_class_to_conn(cdev);
 	struct iscsi_transport *t = conn->transport;
 	int param;
@@ -4306,7 +4306,7 @@ static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUSR,		\
 static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 					    struct attribute *attr, int i)
 {
-	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct device *cdev = kobj_to_dev(kobj);
 	struct iscsi_cls_session *session = transport_class_to_session(cdev);
 	struct iscsi_transport *t = session->transport;
 	int param;
@@ -4450,7 +4450,7 @@ static ISCSI_CLASS_ATTR(host, field, S_IRUGO, show_host_param_##param,	\
 static umode_t iscsi_host_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
-	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct device *cdev = kobj_to_dev(kobj);
 	struct Scsi_Host *shost = transport_class_to_shost(cdev);
 	struct iscsi_internal *priv = to_iscsi_internal(shost->transportt);
 	int param;
-- 
1.8.3.1

