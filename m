Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28262C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 07:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4E7A64ED6
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 07:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhBVH1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 02:27:34 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:33831 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229886AbhBVH1d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 02:27:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UPCfPyz_1613978806;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UPCfPyz_1613978806)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Feb 2021 15:26:46 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, lduncan@suse.com, cleech@redhat.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] scsi: iscsi: Switch to using the new API kobj_to_dev()
Date:   Mon, 22 Feb 2021 15:26:44 +0800
Message-Id: <1613978804-4846-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

fixed the following coccicheck:
./drivers/scsi/scsi_transport_iscsi.c:436:60-61: WARNING opportunity for
kobj_to_dev()
./drivers/scsi/scsi_transport_iscsi.c:1128:60-61: WARNING opportunity
for kobj_to_dev()
./drivers/scsi/scsi_transport_iscsi.c:4043:61-62: WARNING opportunity
for kobj_to_dev()
./drivers/scsi/scsi_transport_iscsi.c:4312:61-62: WARNING opportunity
for kobj_to_dev()
./drivers/scsi/scsi_transport_iscsi.c:4456:61-62: WARNING opportunity
for kobj_to_dev()

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2e68c0a..467ed95 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -433,7 +433,7 @@ struct device_attribute dev_attr_##_prefix##_##_name =		\
 static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 					  struct attribute *attr, int i)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
 	struct iscsi_transport *t = iface->transport;
 	int param;
@@ -1125,7 +1125,7 @@ static umode_t iscsi_flashnode_conn_attr_is_visible(struct kobject *kobj,
 						    struct attribute *attr,
 						    int i)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct iscsi_bus_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
 	struct iscsi_transport *t = fnode_conn->transport;
 	int param;
@@ -4040,7 +4040,7 @@ static ISCSI_CLASS_ATTR(conn, field, S_IRUGO,				\
 static umode_t iscsi_conn_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
-	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct device *cdev = kobj_to_dev(kobj);
 	struct iscsi_cls_conn *conn = transport_class_to_conn(cdev);
 	struct iscsi_transport *t = conn->transport;
 	int param;
@@ -4309,7 +4309,7 @@ static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUSR,		\
 static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 					    struct attribute *attr, int i)
 {
-	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct device *cdev = kobj_to_dev(kobj);
 	struct iscsi_cls_session *session = transport_class_to_session(cdev);
 	struct iscsi_transport *t = session->transport;
 	int param;
@@ -4453,7 +4453,7 @@ static ISCSI_CLASS_ATTR(host, field, S_IRUGO, show_host_param_##param,	\
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

