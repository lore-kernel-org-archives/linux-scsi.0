From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 2/3] scsi_dh: Provide set_params interface in emc device handler
Date: Wed, 01 Jul 2009 20:13:20 -0700
Message-ID: <20090702031320.28354.96958.sendpatchset@chandra-ubuntu>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52353 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZGBDKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2009 23:10:46 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n6236AW3018120
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jul 2009 21:06:10 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n623AoL2197314
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jul 2009 21:10:50 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n623AnQl028316
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jul 2009 21:10:50 -0600
In-Reply-To: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com, Eddie.Williams@steeleye.com, Chandra Seetharaman <sekharan@us.ibm.com>

Handle the parameters provided by user thru multipath.

This handler expects only 2 parameters and their value can either be 0 or 1.

This code originates from the old dm-emc.c file. Appropriate changes have
been made to make it work in the new design.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |   56 ++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c
===================================================================
--- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh_emc.c
+++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -561,6 +561,61 @@ done:
 
 	return result;
 }
+/*
+ * params - parameters in the following format
+ *      "no_of_params\0param1\0param2\0param3\0...\0"
+ *      for example, string for 2 parameters with value 10 and 21
+ *      is specified as "2\010\021\0".
+ */
+static int clariion_set_params(struct scsi_device *sdev, const char *params)
+{
+	struct clariion_dh_data *csdev = get_clariion_data(sdev);
+	unsigned int hr = 0, st = 0, argc;
+	char *p = params;
+	int result = SCSI_DH_OK;
+
+	if ((sscanf(params, "%u", &argc) != 1) || (argc != 2))
+		return -EINVAL;
+
+	while (*p++)
+		;
+	if ((sscanf(p, "%u", &st) != 1) || (st > 1))
+		return -EINVAL;
+
+	while (*p++)
+		;
+	if ((sscanf(p, "%u", &hr) != 1) || (hr > 1))
+		return -EINVAL;
+
+	if (st)
+		csdev->flags |= CLARIION_SHORT_TRESPASS;
+	else
+		csdev->flags &= ~CLARIION_SHORT_TRESPASS;
+
+	if (hr)
+		csdev->flags |= CLARIION_HONOR_RESERVATIONS;
+	else
+		csdev->flags &= ~CLARIION_HONOR_RESERVATIONS;
+
+	/*
+	 * If this path is owned, we have to send a trespass command
+	 * with the new parameters. If not, simply return. Next trespass
+	 * command would use the parameters.
+	 */
+	if (csdev->lun_state != CLARIION_LUN_OWNED)
+		goto done;
+
+	csdev->lun_state = CLARIION_LUN_UNINITIALIZED;
+	result = send_trespass_cmd(sdev, csdev);
+	if (result != SCSI_DH_OK)
+		goto done;
+
+	/* Update status */
+	result = clariion_send_inquiry(sdev, csdev);
+
+done:
+	return result;
+}
 
 static const struct scsi_dh_devlist clariion_dev_list[] = {
 	{"DGC", "RAID"},
@@ -581,6 +636,7 @@ static struct scsi_device_handler clarii
 	.check_sense	= clariion_check_sense,
 	.activate	= clariion_activate,
 	.prep_fn	= clariion_prep_fn,
+	.set_params	= clariion_set_params,
 };
 
 /*
