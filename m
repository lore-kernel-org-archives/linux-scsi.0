From: Jeff Garzik <jgarzik@pobox.com>
Subject: [scsi hcil 6/9] introduce sfoo_printk, sfoo_id, sfoo_channel helpers
Date: Mon, 24 Oct 2005 18:03:34 -0400
Message-ID: <20051024220334.GF10567@havoc.gtf.org>
References: <20051024220013.GA10070@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:50575 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751310AbVJXWDf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:03:35 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 166511C0A7BA
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:03:35 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OM3YY7010755
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:03:34 -0400
Content-Disposition: inline
In-Reply-To: <20051024220013.GA10070@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


commit 30d604030b5c7add791746119c72cab358eb75c3
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Mon Oct 24 15:59:30 2005 -0400

    [SCSI] introduce sfoo_printk, sfoo_id, sfoo_channel helpers
    
    New dev_printk wrappers, which allow us to shrink code, and
    eliminate direct references to host/channel/id/lun members:
    	{scmd,sdev,starget,shost}_printk()
    
    Introduce wrappers for highly common idioms, which may also help us
    eliminate some ->{channel,id} references in the future:
    	{scmd,sdev}_id()
    	{scmd,sdev}_channel()
    
    The scmd_* wrappers are present in scsi/scsi_device.h because they all
    employ the dereference chain cmd->device->$member.  We would prefer to
    use static inline functions rather than macros, but that would have a

 include/scsi/scsi_device.h |   22 ++++++++++++++++++++++
 include/scsi/scsi_host.h   |    4 ++++
 2 files changed, 26 insertions(+)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 14d89eb..39b4aad 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -148,6 +148,12 @@ struct scsi_device {
 #define transport_class_to_sdev(class_dev) \
 	to_scsi_device(class_dev->dev)
 
+#define sdev_printk(prefix, sdev, fmt, a...)	\
+	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
+
+#define scmd_printk(prefix, scmd, fmt, a...)	\
+	dev_printk(prefix, &(scmd)->device->sdev_gendev, fmt, ##a)
+
 /*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
@@ -177,6 +183,9 @@ static inline struct scsi_target *scsi_t
 #define transport_class_to_starget(class_dev) \
 	to_scsi_target(class_dev->dev)
 
+#define starget_printk(prefix, starget, fmt, a...)	\
+	dev_printk(prefix, &(starget)->dev, fmt, ##a)
+
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
@@ -264,6 +273,19 @@ extern int scsi_execute_req(struct scsi_
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries);
 
+static inline unsigned int sdev_channel(struct scsi_device *sdev)
+{
+	return sdev->channel;
+}
+
+static inline unsigned int sdev_id(struct scsi_device *sdev)
+{
+	return sdev->id;
+}
+
+#define scmd_id(scmd) sdev_id((scmd)->device)
+#define scmd_channel(scmd) sdev_channel((scmd)->device)
+
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 26b3f70..ecd53d7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -609,6 +609,10 @@ struct Scsi_Host {
 #define		class_to_shost(d)	\
 	container_of(d, struct Scsi_Host, shost_classdev)
 
+#define shost_printk(prefix, shost, fmt, a...)	\
+	dev_printk(prefix, &(shost)->shost_gendev, fmt, ##a)
+
+
 int scsi_is_host_device(const struct device *);
 
 static inline struct Scsi_Host *dev_to_shost(struct device *dev)
