Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3343DC48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 14:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ED7D611ED
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 14:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhFRO0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 10:26:20 -0400
Received: from mail-m121145.qiye.163.com ([115.236.121.145]:59038 "EHLO
        mail-m121145.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhFRO0U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 10:26:20 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jun 2021 10:26:19 EDT
DKIM-Signature: a=rsa-sha256;
        b=aqYYjiG7FJu1ehklzhPMJu21bcDU3i7mF3RFpaBA5cBPcfvq5OUhl5LV0JSWGRrWtzzAWuGP971UE/4IrBwBlOFDxFa62aa+c7GMLM8TMTMR4J2kWDXEfmt+WTksQajK1TGOTNZUhTip5GufgalULh8Whg2Wd5BywPfsWGQPmFE=;
        c=relaxed/relaxed; s=default; d=vivo.com; v=1;
        bh=UfHdKcHANJG54V5g7ZV3FWJBQ5I+E2Pa+DRQCviz84E=;
        h=date:mime-version:subject:message-id:from;
Received: from ubuntu.localdomain (unknown [36.152.145.182])
        by mail-m121145.qiye.163.com (Hmail) with ESMTPA id 81D2C80015A;
        Fri, 18 Jun 2021 22:16:18 +0800 (CST)
From:   zhouchuangao <zhouchuangao@vivo.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhouchuangao <zhouchuangao@vivo.com>
Subject: [PATCH] driver/scsi: Use kobj_to_dev() API
Date:   Fri, 18 Jun 2021 07:16:12 -0700
Message-Id: <1624025772-56692-1-git-send-email-zhouchuangao@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGkIYTlYdHxpMHRgeGktDQxpVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OT46GSo4Fj8JQkIwLS4TCw48
        EhQKCSlVSlVKTUlPS0lOTExCS01NVTMWGhIXVQETFA4YEw4aFRwaFDsNEg0UVRgUFkVZV1kSC1lB
        WUhNVUpOSVVKT05VSkNJWVdZCAFZQU9MSEo3Bg++
X-HM-Tid: 0a7a1f7aca05b03akuuu81d2c80015a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use kobj_to_dev() API instead of container_of().

Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 12 ++++++------
 drivers/scsi/scsi_transport_spi.c   |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b07105a..2f3b0135d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -436,7 +436,7 @@ iscsi_iface_attr(iface, initiator_name, ISCSI_IFACE_PARAM_INITIATOR_NAME);
 static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 					  struct attribute *attr, int i)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
 	struct iscsi_transport *t = iface->transport;
 	int param;
@@ -926,7 +926,7 @@ static umode_t iscsi_flashnode_sess_attr_is_visible(struct kobject *kobj,
 						    struct attribute *attr,
 						    int i)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct iscsi_bus_flash_session *fnode_sess =
 						iscsi_dev_to_flash_session(dev);
 	struct iscsi_transport *t = fnode_sess->transport;
@@ -1128,7 +1128,7 @@ static umode_t iscsi_flashnode_conn_attr_is_visible(struct kobject *kobj,
 						    struct attribute *attr,
 						    int i)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct iscsi_bus_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
 	struct iscsi_transport *t = fnode_conn->transport;
 	int param;
@@ -4179,7 +4179,7 @@ static struct attribute *iscsi_conn_attrs[] = {
 static umode_t iscsi_conn_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
-	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct device *cdev = kobj_to_dev(kobj);
 	struct iscsi_cls_conn *conn = transport_class_to_conn(cdev);
 	struct iscsi_transport *t = conn->transport;
 	int param;
@@ -4448,7 +4448,7 @@ static struct attribute *iscsi_session_attrs[] = {
 static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 					    struct attribute *attr, int i)
 {
-	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct device *cdev = kobj_to_dev(kobj);
 	struct iscsi_cls_session *session = transport_class_to_session(cdev);
 	struct iscsi_transport *t = session->transport;
 	int param;
@@ -4592,7 +4592,7 @@ static struct attribute *iscsi_host_attrs[] = {
 static umode_t iscsi_host_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
-	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct device *cdev = kobj_to_dev(kobj);
 	struct Scsi_Host *shost = transport_class_to_shost(cdev);
 	struct iscsi_internal *priv = to_iscsi_internal(shost->transportt);
 	int param;
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 5af7a10..594272ee 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1468,7 +1468,7 @@ static int spi_host_configure(struct transport_container *tc,
 static umode_t target_attribute_is_visible(struct kobject *kobj,
 					  struct attribute *attr, int i)
 {
-	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct device *cdev = kobj_to_dev(kobj);
 	struct scsi_target *starget = transport_class_to_starget(cdev);
 	struct Scsi_Host *shost = transport_class_to_shost(cdev);
 	struct spi_internal *si = to_spi_internal(shost->transportt);
-- 
2.7.4

