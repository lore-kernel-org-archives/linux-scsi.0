Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548A6C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 15:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 382E3207BB
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 15:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgHUPnQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 11:43:16 -0400
Received: from smtp.infotech.no ([82.134.31.41]:48357 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgHUPme (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 11:42:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 39525204155;
        Fri, 21 Aug 2020 17:42:21 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FnfxziSm+gjF; Fri, 21 Aug 2020 17:42:19 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 3D6DA204255;
        Fri, 21 Aug 2020 17:42:18 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        john.garry@huawei.com
Subject: [PATCH v6 10/10] scsi_transport_sas: avoid dev_to_shost() walks
Date:   Fri, 21 Aug 2020 11:42:04 -0400
Message-Id: <20200821154204.9298-11-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821154204.9298-1-dgilbert@interlog.com>
References: <20200821154204.9298-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While dev_to_shost() is a solid implementation of a runtime type
identification (RTTI) scheme, within the scope of a Scsi_Host
object (e.g. representing a HBA) the answer is always the same!
So cache the answer for the sas_phy and sas_rphy cases. This
should marginally improve the speed of about half the functions
defined in scsi_transport_sas.c .

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_transport_sas.c | 40 +++++++++++++++----------------
 include/scsi/scsi_transport_sas.h |  8 +++++--
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index c9abed8429c9..8d52de5d0957 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -171,7 +171,7 @@ static struct sas_end_device *sas_sdev_to_rdev(struct scsi_device *sdev)
 
 static int sas_smp_dispatch(struct bsg_job *job)
 {
-	struct Scsi_Host *shost = dev_to_shost(job->dev);
+	struct Scsi_Host *shost;
 	struct sas_rphy *rphy = NULL;
 
 	if (!scsi_is_host_device(job->dev))
@@ -183,6 +183,7 @@ static int sas_smp_dispatch(struct bsg_job *job)
 		return 0;
 	}
 
+	shost = rphy->shost;
 	to_sas_internal(shost->transportt)->f->smp_handler(job, shost, rphy);
 	return 0;
 }
@@ -462,7 +463,7 @@ store_sas_phy_##field(struct device *dev, 				\
 		      const char *buf,	size_t count)			\
 {									\
 	struct sas_phy *phy = transport_class_to_phy(dev);		\
-	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);	\
+	struct Scsi_Host *shost = phy->shost;				\
 	struct sas_internal *i = to_sas_internal(shost->transportt);	\
 	u32 value;							\
 	struct sas_phy_linkrates rates = {0};				\
@@ -494,7 +495,7 @@ show_sas_phy_##field(struct device *dev, 				\
 		     struct device_attribute *attr, char *buf)		\
 {									\
 	struct sas_phy *phy = transport_class_to_phy(dev);		\
-	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);	\
+	struct Scsi_Host *shost = phy->shost;				\
 	struct sas_internal *i = to_sas_internal(shost->transportt);	\
 	int error;							\
 									\
@@ -525,7 +526,7 @@ static ssize_t do_sas_phy_enable(struct device *dev,
 		size_t count, int enable)
 {
 	struct sas_phy *phy = transport_class_to_phy(dev);
-	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	struct Scsi_Host *shost = phy->shost;
 	struct sas_internal *i = to_sas_internal(shost->transportt);
 	int error;
 
@@ -573,8 +574,7 @@ static ssize_t
 do_sas_phy_reset(struct device *dev, size_t count, int hard_reset)
 {
 	struct sas_phy *phy = transport_class_to_phy(dev);
-	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
-	struct sas_internal *i = to_sas_internal(shost->transportt);
+	struct sas_internal *i = to_sas_internal(phy->shost->transportt);
 	int error;
 
 	error = i->f->phy_reset(phy, hard_reset);
@@ -621,8 +621,7 @@ static int sas_phy_setup(struct transport_container *tc, struct device *dev,
 			 struct device *cdev)
 {
 	struct sas_phy *phy = dev_to_phy(dev);
-	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
-	struct sas_internal *i = to_sas_internal(shost->transportt);
+	struct sas_internal *i = to_sas_internal(phy->shost->transportt);
 
 	if (i->f->phy_setup)
 		i->f->phy_setup(phy);
@@ -640,7 +639,7 @@ static int sas_phy_match(struct attribute_container *cont, struct device *dev)
 
 	if (!scsi_is_sas_phy(dev))
 		return 0;
-	shost = dev_to_shost(dev->parent);
+	shost = dev_to_phy(dev)->shost;
 
 	if (!shost->transportt)
 		return 0;
@@ -655,8 +654,7 @@ static int sas_phy_match(struct attribute_container *cont, struct device *dev)
 static void sas_phy_release(struct device *dev)
 {
 	struct sas_phy *phy = dev_to_phy(dev);
-	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
-	struct sas_internal *i = to_sas_internal(shost->transportt);
+	struct sas_internal *i = to_sas_internal(phy->shost->transportt);
 
 	if (i->f->phy_release)
 		i->f->phy_release(phy);
@@ -687,6 +685,7 @@ struct sas_phy *sas_phy_alloc(struct device *parent, int number)
 
 	phy->number = number;
 	phy->enabled = 1;
+	phy->shost = shost;
 
 	device_initialize(&phy->dev);
 	phy->dev.parent = get_device(parent);
@@ -806,6 +805,7 @@ static int sas_port_match(struct attribute_container *cont, struct device *dev)
 
 	if (!scsi_is_sas_port(dev))
 		return 0;
+	/* Could dev_to_sas_port(dev) and if port non-NULL use rphy->shost */
 	shost = dev_to_shost(dev->parent);
 
 	if (!shost->transportt)
@@ -1180,8 +1180,7 @@ show_sas_rphy_enclosure_identifier(struct device *dev,
 {
 	struct sas_rphy *rphy = transport_class_to_rphy(dev);
 	struct sas_phy *phy = dev_to_phy(rphy->dev.parent);
-	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
-	struct sas_internal *i = to_sas_internal(shost->transportt);
+	struct sas_internal *i = to_sas_internal(phy->shost->transportt);
 	u64 identifier;
 	int error;
 
@@ -1200,8 +1199,7 @@ show_sas_rphy_bay_identifier(struct device *dev,
 {
 	struct sas_rphy *rphy = transport_class_to_rphy(dev);
 	struct sas_phy *phy = dev_to_phy(rphy->dev.parent);
-	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
-	struct sas_internal *i = to_sas_internal(shost->transportt);
+	struct sas_internal *i = to_sas_internal(phy->shost->transportt);
 	int val;
 
 	val = i->f->get_bay_identifier(rphy);
@@ -1327,7 +1325,7 @@ static int sas_rphy_match(struct attribute_container *cont, struct device *dev)
 
 	if (!scsi_is_sas_rphy(dev))
 		return 0;
-	shost = dev_to_shost(dev->parent->parent);
+	shost = dev_to_rphy(dev)->shost;
 
 	if (!shost->transportt)
 		return 0;
@@ -1348,8 +1346,8 @@ static int sas_end_dev_match(struct attribute_container *cont,
 
 	if (!scsi_is_sas_rphy(dev))
 		return 0;
-	shost = dev_to_shost(dev->parent->parent);
 	rphy = dev_to_rphy(dev);
+	shost = rphy->shost;
 
 	if (!shost->transportt)
 		return 0;
@@ -1371,8 +1369,8 @@ static int sas_expander_match(struct attribute_container *cont,
 
 	if (!scsi_is_sas_rphy(dev))
 		return 0;
-	shost = dev_to_shost(dev->parent->parent);
 	rphy = dev_to_rphy(dev);
+	shost = rphy->shost;
 
 	if (!shost->transportt)
 		return 0;
@@ -1436,6 +1434,7 @@ struct sas_rphy *sas_end_device_alloc(struct sas_port *parent)
 	}
 
 	device_initialize(&rdev->rphy.dev);
+	rdev->rphy.shost = shost;
 	rdev->rphy.dev.parent = get_device(&parent->dev);
 	rdev->rphy.dev.release = sas_end_device_release;
 	if (scsi_is_sas_expander_device(parent->dev.parent)) {
@@ -1480,6 +1479,7 @@ struct sas_rphy *sas_expander_alloc(struct sas_port *parent,
 	}
 
 	device_initialize(&rdev->rphy.dev);
+	rdev->rphy.shost = shost;
 	rdev->rphy.dev.parent = get_device(&parent->dev);
 	rdev->rphy.dev.release = sas_expander_release;
 	mutex_lock(&sas_host->lock);
@@ -1504,7 +1504,7 @@ EXPORT_SYMBOL(sas_expander_alloc);
 int sas_rphy_add(struct sas_rphy *rphy)
 {
 	struct sas_port *parent = dev_to_sas_port(rphy->dev.parent);
-	struct Scsi_Host *shost = dev_to_shost(parent->dev.parent);
+	struct Scsi_Host *shost = rphy->shost;
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 	struct sas_identify *identify = &rphy->identify;
 	int error;
@@ -1563,7 +1563,7 @@ EXPORT_SYMBOL(sas_rphy_add);
 void sas_rphy_free(struct sas_rphy *rphy)
 {
 	struct device *dev = &rphy->dev;
-	struct Scsi_Host *shost = dev_to_shost(rphy->dev.parent->parent);
+	struct Scsi_Host *shost = rphy->shost;
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
 	mutex_lock(&sas_host->lock);
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 05ec927a3c72..9f4c50358f82 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -9,6 +9,7 @@
 #include <linux/bsg-lib.h>
 
 struct scsi_transport_template;
+struct Scsi_Host;
 struct sas_rphy;
 struct request;
 
@@ -80,6 +81,8 @@ struct sas_phy {
 	/* for the list of phys belonging to a port */
 	struct list_head	port_siblings;
 
+	struct Scsi_Host	*shost;		/* cache to avoid dev_to_shost() walks */
+
 	/* available to the lldd */
 	void			*hostdata;
 };
@@ -89,7 +92,7 @@ struct sas_phy {
 #define transport_class_to_phy(dev) \
 	dev_to_phy((dev)->parent)
 #define phy_to_shost(phy) \
-	dev_to_shost((phy)->dev.parent)
+	((phy)->shost)
 
 struct request_queue;
 struct sas_rphy {
@@ -97,6 +100,7 @@ struct sas_rphy {
 	struct sas_identify	identify;
 	struct list_head	list;
 	struct request_queue	*q;
+	struct Scsi_Host	*shost;		/* cache to avoid dev_to_shost() walks */
 	u32			scsi_target_id;
 };
 
@@ -105,7 +109,7 @@ struct sas_rphy {
 #define transport_class_to_rphy(dev) \
 	dev_to_rphy((dev)->parent)
 #define rphy_to_shost(rphy) \
-	dev_to_shost((rphy)->dev.parent)
+	((rphy)->shost)
 #define target_to_rphy(targ) \
 	dev_to_rphy((targ)->dev.parent)
 
-- 
2.25.1

