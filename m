From: michaelc@cs.wisc.edu
Subject: [PATCH 3/7] iscsi class: fix endpoint id handling
Date: Wed, 24 Sep 2008 11:46:11 -0500
Message-ID: <1222274775-8834-4-git-send-email-michaelc@cs.wisc.edu>
References: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-2-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53701 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYIXQq2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 12:46:28 -0400
In-Reply-To: <1222274775-8834-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Some endpoint code was using unsigned int and some
was using uint64_t. This converts it all to uint64_t.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    9 +++++----
 include/scsi/scsi_transport_iscsi.h |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f9e45f8..4a803eb 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -138,7 +138,7 @@ static ssize_t
 show_ep_handle(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
-	return sprintf(buf, "%u\n", ep->id);
+	return sprintf(buf, "%llu\n", (unsigned long long) ep->id);
 }
 static ISCSI_ATTR(ep, handle, S_IRUGO, show_ep_handle, NULL);
 
@@ -156,7 +156,7 @@ static struct attribute_group iscsi_endpoint_group = {
 static int iscsi_match_epid(struct device *dev, void *data)
 {
 	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
-	unsigned int *epid = (unsigned int *) data;
+	uint64_t *epid = (uint64_t *) data;
 
 	return *epid == ep->id;
 }
@@ -166,7 +166,7 @@ iscsi_create_endpoint(int dd_size)
 {
 	struct device *dev;
 	struct iscsi_endpoint *ep;
-	unsigned int id;
+	uint64_t id;
 	int err;
 
 	for (id = 1; id < ISCSI_MAX_EPID; id++) {
@@ -187,7 +187,8 @@ iscsi_create_endpoint(int dd_size)
 
 	ep->id = id;
 	ep->dev.class = &iscsi_endpoint_class;
-	snprintf(ep->dev.bus_id, BUS_ID_SIZE, "ep-%u", id);
+	snprintf(ep->dev.bus_id, BUS_ID_SIZE, "ep-%llu",
+		 (unsigned long long) id);
 	err = device_register(&ep->dev);
         if (err)
                 goto free_ep;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8749d4d..c667cc3 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -208,7 +208,7 @@ extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
 struct iscsi_endpoint {
 	void *dd_data;			/* LLD private data */
 	struct device dev;
-	unsigned int id;
+	uint64_t id;
 };
 
 /*
-- 
1.5.4.1

