From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH 1/3] scsi_dh_alua: Inroduce the set_params interface
 scsi_dh_alua handler
Date: Tue, 27 Mar 2012 20:55:49 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B02C3E4@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:17440 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab2C0Uz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2012 16:55:56 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "Qi, Yanling" <Yanling.Qi@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>

This patch provides set_params interface for scsi_dh_alua handler.

Handler expects only one parameter to set the flag ALUA_OPTIMIZE_STPG.
This flag is used to optimize the STPG behaviour. There is no change in
behaviour by default.

For example, to set the flag pass the following parameters from multipath.conf
hardware_handler        "2 alua 1"

Signed-off-by: Babu Moger <babu.moger@netapp.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
--- linux-3.3-rc6/drivers/scsi/device_handler/scsi_dh_alua.c.orig	2012-03-12 13:22:16.000000000 -0500
+++ linux-3.3-rc6/drivers/scsi/device_handler/scsi_dh_alua.c	2012-03-12 13:22:49.000000000 -0500
@@ -55,11 +55,15 @@
 #define ALUA_FAILOVER_TIMEOUT		(60 * HZ)
 #define ALUA_FAILOVER_RETRIES		5
 
+/* flags passed from user level */
+#define ALUA_OPTIMIZE_STPG		1
+
 struct alua_dh_data {
 	int			group_id;
 	int			rel_port;
 	int			tpgs;
 	int			state;
+	unsigned		flags; /* used for optimizing STPG */
 	unsigned char		inq[ALUA_INQUIRY_SIZE];
 	unsigned char		*buff;
 	int			bufflen;
@@ -621,6 +625,37 @@ static int alua_initialize(struct scsi_d
 out:
 	return err;
 }
+/*
+ * alua_set_params - set/unset the optimize flag
+ * @sdev: device on the path to be activated
+ * params - parameters in the following format
+ *      "no_of_params\0param1\0param2\0param3\0...\0"
+ * For example, to set the flag pass the following parameters
+ * from multipath.conf
+ *     hardware_handler        "2 alua 1"
+ */
+static int alua_set_params(struct scsi_device *sdev, const char *params)
+{
+	struct alua_dh_data *h = get_alua_data(sdev);
+	unsigned int optimize = 0, argc;
+	const char *p = params;
+	int result = SCSI_DH_OK;
+
+	if ((sscanf(params, "%u", &argc) != 1) || (argc != 1))
+		return -EINVAL;
+
+	while (*p++)
+		;
+	if ((sscanf(p, "%u", &optimize) != 1) || (optimize > 1))
+		return -EINVAL;
+
+	if (optimize)
+		h->flags |= ALUA_OPTIMIZE_STPG;
+	else
+		h->flags &= ~ALUA_OPTIMIZE_STPG;
+
+	return result;
+}
 
 /*
  * alua_activate - activate a path
@@ -698,6 +733,7 @@ static struct scsi_device_handler alua_d
 	.prep_fn = alua_prep_fn,
 	.check_sense = alua_check_sense,
 	.activate = alua_activate,
+	.set_params = alua_set_params,
 	.match = alua_match,
 };
 


