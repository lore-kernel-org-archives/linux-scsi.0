From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/3] scsi_dh: Use scsi_dh_set_params() in multipath.
Date: Wed, 01 Jul 2009 20:13:26 -0700
Message-ID: <20090702031326.28354.82033.sendpatchset@chandra-ubuntu>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:32917 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbZGBDKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2009 23:10:53 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n6237dis002492
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jul 2009 21:07:39 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n623AuWK210952
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jul 2009 21:10:56 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n623At0R028497
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jul 2009 21:10:55 -0600
In-Reply-To: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com, Eddie.Williams@steeleye.com, Chandra Seetharaman <sekharan@us.ibm.com>

Use scsi_dh_set_params() set parameters provided. Save the parameters in
parse_hw_handler() and use it in parse_path().

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/md/dm-mpath.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

Index: linux-2.6.31-rc1/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.31-rc1.orig/drivers/md/dm-mpath.c
+++ linux-2.6.31-rc1/drivers/md/dm-mpath.c
@@ -64,6 +64,7 @@ struct multipath {
 	spinlock_t lock;
 
 	const char *hw_handler_name;
+	char *hw_handler_params;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
@@ -219,6 +220,7 @@ static void free_multipath(struct multip
 	}
 
 	kfree(m->hw_handler_name);
+	kfree(m->hw_handler_params);
 	mempool_destroy(m->mpio_pool);
 	kfree(m);
 }
@@ -615,6 +617,17 @@ static struct pgpath *parse_path(struct
 			dm_put_device(ti, p->path.dev);
 			goto bad;
 		}
+
+		if (m->hw_handler_params) {
+			r = scsi_dh_set_params(q, m->hw_handler_params);
+			if (r < 0) {
+				ti->error = "unable to set hardware "
+							"handler parameters";
+				scsi_dh_detach(q);
+				dm_put_device(ti, p->path.dev);
+				goto bad;
+			}
+		}
 	}
 
 	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);
@@ -705,6 +718,7 @@ static struct priority_group *parse_prio
 static int parse_hw_handler(struct arg_set *as, struct multipath *m)
 {
 	unsigned hw_argc;
+	int ret;
 	struct dm_target *ti = m->ti;
 
 	static struct param _params[] = {
@@ -726,17 +740,33 @@ static int parse_hw_handler(struct arg_s
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
 		ti->error = "unknown hardware handler type";
-		kfree(m->hw_handler_name);
-		m->hw_handler_name = NULL;
-		return -EINVAL;
+		ret = -EINVAL;
+		goto fail;
 	}
 
-	if (hw_argc > 1)
-		DMWARN("Ignoring user-specified arguments for "
-		       "hardware handler \"%s\"", m->hw_handler_name);
+	if (hw_argc > 1) {
+		char *p;
+		int i, j, len = 4;
+
+		for (i = 0; i <= hw_argc - 2; i++)
+			len += strlen(as->argv[i]) + 1;
+		p = m->hw_handler_params = kzalloc(len, GFP_KERNEL);
+		if (!p) {
+			ti->error = "memory allocation failed";
+			ret = -ENOMEM;
+			goto fail;
+		}
+		j = sprintf(p, "%d", hw_argc - 1);
+		for (i = 0, p+=j+1; i <= hw_argc - 2; i++, p+=j+1)
+			j = sprintf(p, "%s", as->argv[i]);
+	}
 	consume(as, hw_argc - 1);
 
 	return 0;
+fail:
+	kfree(m->hw_handler_name);
+	m->hw_handler_name = NULL;
+	return ret;
 }
 
 static int parse_features(struct arg_set *as, struct multipath *m)
