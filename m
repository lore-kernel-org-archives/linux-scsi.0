From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC] use struct scsi_lun in generic code
Date: Sun, 23 Oct 2005 00:33:01 -0400
Message-ID: <20051023043301.GA22615@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:18144 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751367AbVJWEdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 00:33:04 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 76E3B1C011C6
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 00:33:01 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N4X1qH022800
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 00:33:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A further experiment:  once dev_printk() has been used to eliminate
direct references to HCIL address (see previous patch), we can see what
happens when we update the core to use struct scsi_lun.

DO NOT APPLY.

Depends on previous "kill scsi_device::{channel,id} in generic code"
patch.

Changes:

* replace 'unsigned int lun' with 'struct scsi_lun lun' in struct scsi_device

* change various function args to receive 'const struct scsi_lun *'
  rather than unsigned int.

* export scsilun_to_int()

* create scsilun_to_str() helper

* create scsilun_eq() helper

* update all references to scsi_device::lun, as caught by the compiler.

  Again, generic code was 100% converted, driver code 0% converted.

* int_to_scsilun() is used to convert SCSI-2 luns, and luns passed
  from userspace as integers, to struct scsi_lun.

* shost->max_lun check moved into scsi_scan_host_selected() callers


 drivers/scsi/scsi.c               |   16 ++++++-----
 drivers/scsi/scsi_error.c         |    6 ++--
 drivers/scsi/scsi_ioctl.c         |    4 ++
 drivers/scsi/scsi_priv.h          |    5 ++-
 drivers/scsi/scsi_proc.c          |   23 +++++++++++-----
 drivers/scsi/scsi_scan.c          |   54 ++++++++++++++++++++++----------------
 drivers/scsi/scsi_sysfs.c         |   18 +++++++++---
 drivers/scsi/scsi_transport_fc.c  |    2 -
 drivers/scsi/scsi_transport_sas.c |    3 +-
 drivers/scsi/sg.c                 |   19 +++++++++----
 include/scsi/scsi_device.h        |   29 ++++++++++++++------
 11 files changed, 118 insertions(+), 61 deletions(-)


diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 0cb69a5..e6269f0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -570,8 +570,10 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
 	if (cmd->device->scsi_level <= SCSI_2) {
+		unsigned int tmp_lun =
+			(unsigned int) scsilun_to_int(&cmd->device->lun);
 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
-			       (cmd->device->lun << 5 & 0xe0);
+			       (tmp_lun << 5 & 0xe0);
 	}
 
 	/*
@@ -1132,12 +1134,12 @@ EXPORT_SYMBOL(starget_for_each_device);
  * really want to use scsi_device_lookup_by_target instead.
  **/
 struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
-						   uint lun)
+						   const struct scsi_lun *lun)
 {
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
-		if (sdev->lun ==lun)
+		if (scsilun_eq(&sdev->lun, lun))
 			return sdev;
 	}
 
@@ -1155,7 +1157,7 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_ta
  * needs to be release with scsi_host_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
-						 uint lun)
+						 const struct scsi_lun *lun)
 {
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -1188,14 +1190,14 @@ EXPORT_SYMBOL(scsi_device_lookup_by_targ
  * really want to use scsi_device_lookup instead.
  **/
 struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, uint lun)
+		uint channel, uint id, const struct scsi_lun *lun)
 {
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev_channel(sdev) == channel &&
 		    sdev_id(sdev) == id &&
-		    sdev->lun ==lun)
+		    scsilun_eq(&sdev->lun, lun))
 			return sdev;
 	}
 
@@ -1215,7 +1217,7 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  * needs to be release with scsi_host_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, uint lun)
+		uint channel, uint id, const struct scsi_lun *lun)
 {
 	struct scsi_device *sdev;
 	unsigned long flags;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index fe5b9b9..29b0e2b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -480,9 +480,11 @@ static int scsi_send_eh_cmnd(struct scsi
 	 * we will use a queued command if possible, otherwise we will
 	 * emulate the queuing and calling of completion function ourselves.
 	 */
-	if (sdev->scsi_level <= SCSI_2)
+	if (sdev->scsi_level <= SCSI_2) {
+		unsigned int tmp_lun = scsilun_to_int(&sdev->lun);
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
-			(sdev->lun << 5 & 0xe0);
+			(tmp_lun << 5 & 0xe0);
+	}
 
 	scsi_add_timer(scmd, timeout, scsi_eh_times_out);
 
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 43cb1f1..884cb06 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -359,6 +359,7 @@ static int scsi_ioctl_get_pci(struct scs
 int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
+	int tmp_lun;
 
 	/* No idea how this happens.... */
 	if (!sdev)
@@ -394,8 +395,9 @@ int scsi_ioctl(struct scsi_device *sdev,
 		if (!access_ok(VERIFY_WRITE, arg, sizeof(struct scsi_idlun)))
 			return -EFAULT;
 
+		tmp_lun = scsilun_to_int(&sdev->lun);
 		__put_user((sdev_id(sdev) & 0xff)
-			 + ((sdev->lun & 0xff) << 8)
+			 + ((tmp_lun & 0xff) << 8)
 			 + ((sdev_channel(sdev) & 0xff) << 16)
 			 + ((sdev->host->host_no & 0xff) << 24),
 			 &((struct scsi_idlun __user *)arg)->dev_id);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d05f778..afb0f86 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -31,7 +31,8 @@ struct Scsi_Host;
  * Special value for scanning to specify scanning or rescanning of all
  * possible channels, (target) ids, or luns on a given shost.
  */
-#define SCAN_WILD_CARD	~0
+#define SCAN_WILD_CARD		~0
+#define SCAN_LUN_WILD_CARD	NULL
 
 /* hosts.c */
 extern int scsi_init_hosts(void);
@@ -103,7 +104,7 @@ extern void scsi_exit_procfs(void);
 
 /* scsi_scan.c */
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
-				   unsigned int, unsigned int, int);
+				   unsigned int, const struct scsi_lun *, int);
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 43a9ec2..d0c2160 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -147,11 +147,12 @@ static int proc_print_scsidevice(struct 
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct seq_file *s = data;
 	int i;
+	char lunstr[33];
 
 	seq_printf(s,
-		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
+		"Host: scsi%d Channel: %02d Id: %02d Lun: %s\n  Vendor: ",
 		sdev->host->host_no, sdev_channel(sdev), sdev_id(sdev),
-		sdev->lun);
+		scsilun_to_str(sdev, lunstr));
 
 	for (i = 0; i < 8; i++) {
 		if (sdev->vendor[i] >= 0x20)
@@ -192,21 +193,28 @@ static int proc_print_scsidevice(struct 
 	return 0;
 }
 
-static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
+static int scsi_add_single_device(uint host, uint channel, uint id,
+				  uint lun)
 {
 	struct Scsi_Host *shost;
+	struct scsi_lun __lun;
 	int error = -ENXIO;
 
 	shost = scsi_host_lookup(host);
 	if (IS_ERR(shost))
 		return PTR_ERR(shost);
 
-	error = scsi_scan_host_selected(shost, channel, id, lun, 1);
+	if (lun > shost->max_lun)
+		return -EINVAL;
+
+	int_to_scsilun(lun, &__lun);
+	error = scsi_scan_host_selected(shost, channel, id, &__lun, 1);
 	scsi_host_put(shost);
 	return error;
 }
 
-static int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
+static int scsi_remove_single_device(uint host, uint channel, uint id,
+				     const struct scsi_lun *lun)
 {
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost;
@@ -271,14 +279,17 @@ static ssize_t proc_scsi_write(struct fi
 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
 	 */
 	} else if (!strncmp("scsi remove-single-device", buffer, 25)) {
+		struct scsi_lun __lun;
+
 		p = buffer + 26;
 
 		host = simple_strtoul(p, &p, 0);
 		channel = simple_strtoul(p + 1, &p, 0);
 		id = simple_strtoul(p + 1, &p, 0);
 		lun = simple_strtoul(p + 1, &p, 0);
+		int_to_scsilun(lun, &__lun);
 
-		err = scsi_remove_single_device(host, channel, id, lun);
+		err = scsi_remove_single_device(host, channel, id, &__lun);
 	}
 
  out:
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index cf6f8bc..5315beb 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -199,7 +199,7 @@ static void print_inquiry(unsigned char 
  *     scsi_Device pointer, or NULL on failure.
  **/
 static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
-					   unsigned int lun, void *hostdata)
+					   const struct scsi_lun *lun, void *hostdata)
 {
 	struct scsi_device *sdev;
 	int display_failure_msg = 1, ret;
@@ -215,7 +215,7 @@ static struct scsi_device *scsi_alloc_sd
 	sdev->model = scsi_null_device_strs;
 	sdev->rev = scsi_null_device_strs;
 	sdev->host = shost;
-	sdev->lun = lun;
+	memcpy(&sdev->lun, lun, sizeof(*lun));
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
@@ -608,6 +608,8 @@ static int scsi_probe_lun(struct scsi_de
  **/
 static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
 {
+	char lunstr[33];
+
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
 	 * save just vendor/model/rev.
@@ -692,9 +694,10 @@ static int scsi_add_lun(struct scsi_devi
 	if (inq_result[7] & 0x10)
 		sdev->sdtr = 1;
 
-	sprintf(sdev->devfs_name, "scsi/host%d/bus%d/target%d/lun%d",
+	sprintf(sdev->devfs_name, "scsi/host%d/bus%d/target%d/lun%s",
 				sdev->host->host_no, sdev_channel(sdev),
-				sdev_id(sdev), sdev->lun);
+				sdev_id(sdev),
+				scsilun_to_str(sdev, lunstr));
 
 	/*
 	 * End driverfs/devfs code.
@@ -797,7 +800,7 @@ static inline void scsi_destroy_sdev(str
  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct scsi_target *starget,
-				  uint lun, int *bflagsp,
+				  const struct scsi_lun *lun, int *bflagsp,
 				  struct scsi_device **sdevp, int rescan,
 				  void *hostdata)
 {
@@ -972,11 +975,14 @@ static void scsi_sequential_lun_scan(str
 	 * until we reach the max, or no LUN is found and we are not
 	 * sparse_lun.
 	 */
-	for (lun = 1; lun < max_dev_lun; ++lun)
-		if ((scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan,
+	for (lun = 1; lun < max_dev_lun; ++lun) {
+		struct scsi_lun __lun;
+		int_to_scsilun(lun, &__lun);
+		if ((scsi_probe_and_add_lun(starget, &__lun, NULL, NULL, rescan,
 					    NULL) != SCSI_SCAN_LUN_PRESENT) &&
 		    !sparse_lun)
 			return;
+	}
 }
 
 /**
@@ -998,7 +1004,7 @@ static void scsi_sequential_lun_scan(str
  *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function returns
  *     the integer: 0x0b030a04
  **/
-static int scsilun_to_int(struct scsi_lun *scsilun)
+int scsilun_to_int(const struct scsi_lun *scsilun)
 {
 	int i;
 	unsigned int lun;
@@ -1009,6 +1015,7 @@ static int scsilun_to_int(struct scsi_lu
 			      scsilun->scsi_lun[i + 1]) << (i * 8));
 	return lun;
 }
+EXPORT_SYMBOL(scsilun_to_int);
 
 /**
  * int_to_scsilun: reverts an int into a scsi_lun
@@ -1222,7 +1229,7 @@ static int scsi_report_lun_scan(struct s
 			int res;
 
 			res = scsi_probe_and_add_lun(starget,
-				lun, NULL, NULL, rescan, NULL);
+				lunp, NULL, NULL, rescan, NULL);
 			if (res == SCSI_SCAN_NO_RESPONSE) {
 				/*
 				 * Got some results, but now none, abort.
@@ -1247,7 +1254,7 @@ static int scsi_report_lun_scan(struct s
 }
 
 struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
-				      uint id, uint lun, void *hostdata)
+				      uint id, const struct scsi_lun *lun, void *hostdata)
 {
 	struct scsi_device *sdev;
 	struct device *parent = &shost->shost_gendev;
@@ -1274,7 +1281,7 @@ struct scsi_device *__scsi_add_device(st
 EXPORT_SYMBOL(__scsi_add_device);
 
 int scsi_add_device(struct Scsi_Host *host, uint channel,
-		    uint target, uint lun)
+		    uint target, const struct scsi_lun *lun)
 {
 	struct scsi_device *sdev = 
 		__scsi_add_device(host, channel, target, lun, NULL);
@@ -1303,7 +1310,7 @@ void scsi_rescan_device(struct device *d
 EXPORT_SYMBOL(scsi_rescan_device);
 
 static void __scsi_scan_target(struct device *parent, unsigned int channel,
-		unsigned int id, unsigned int lun, int rescan)
+		unsigned int id, const struct scsi_lun *lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
@@ -1321,7 +1328,7 @@ static void __scsi_scan_target(struct de
 		return;
 
 	get_device(&starget->dev);
-	if (lun != SCAN_WILD_CARD) {
+	if (lun != SCAN_LUN_WILD_CARD) {
 		/*
 		 * Scan for a specific host/chan/id/lun.
 		 */
@@ -1369,7 +1376,7 @@ static void __scsi_scan_target(struct de
  *     sequential scan of LUNs on the target id.
  **/
 void scsi_scan_target(struct device *parent, unsigned int channel,
-		      unsigned int id, unsigned int lun, int rescan)
+		      unsigned int id, const struct scsi_lun *lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
@@ -1381,7 +1388,7 @@ void scsi_scan_target(struct device *par
 EXPORT_SYMBOL(scsi_scan_target);
 
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun, int rescan)
+			      unsigned int id, const struct scsi_lun *lun, int rescan)
 {
 	uint order_id;
 
@@ -1412,14 +1419,17 @@ static void scsi_scan_channel(struct Scs
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
-			    unsigned int id, unsigned int lun, int rescan)
+			    unsigned int id, const struct scsi_lun *lun, int rescan)
 {
-	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "%s: <%u:%u:%u:%u>\n",
-		__FUNCTION__, shost->host_no, channel, id, lun));
+	char lunstr[33];
+
+	sprintf(lunstr, "%d", scsilun_to_int(lun));
+
+	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "%s: <%u:%u:%u:%s>\n",
+		__FUNCTION__, shost->host_no, channel, id, lunstr));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
-	    ((id != SCAN_WILD_CARD) && (id > shost->max_id)) ||
-	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
+	    ((id != SCAN_WILD_CARD) && (id > shost->max_id)))
 		return -EINVAL;
 
 	down(&shost->scan_mutex);
@@ -1444,7 +1454,7 @@ int scsi_scan_host_selected(struct Scsi_
 void scsi_scan_host(struct Scsi_Host *shost)
 {
 	scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
-				SCAN_WILD_CARD, 0);
+				SCAN_LUN_WILD_CARD, 0);
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
@@ -1457,7 +1467,7 @@ EXPORT_SYMBOL(scsi_scan_host);
 void scsi_scan_single_target(struct Scsi_Host *shost, 
 	unsigned int chan, unsigned int id)
 {
-	scsi_scan_host_selected(shost, chan, id, SCAN_WILD_CARD, 1);
+	scsi_scan_host_selected(shost, chan, id, SCAN_LUN_WILD_CARD, 1);
 }
 EXPORT_SYMBOL(scsi_scan_single_target);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 3a914cf..a52e963 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -96,6 +96,7 @@ static int scsi_scan(struct Scsi_Host *s
 	char s1[15], s2[15], s3[15], junk;
 	unsigned int channel, id, lun;
 	int res;
+	struct scsi_lun __lun;
 
 	res = sscanf(str, "%10s %10s %10s %c", s1, s2, s3, &junk);
 	if (res != 3)
@@ -106,7 +107,12 @@ static int scsi_scan(struct Scsi_Host *s
 		return -EINVAL;
 	if (check_set(&lun, s3))
 		return -EINVAL;
-	res = scsi_scan_host_selected(shost, channel, id, lun, 1);
+
+	if (lun > shost->max_lun)
+		return -EINVAL;
+	int_to_scsilun(lun, &__lun);
+
+	res = scsi_scan_host_selected(shost, channel, id, &__lun, 1);
 	return res;
 }
 
@@ -859,20 +865,22 @@ void scsi_sysfs_device_initialize(struct
 	unsigned long flags;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_target  *starget = sdev->sdev_target;
+	char lunstr[33];
 
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.release = scsi_device_dev_release;
-	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
+	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%s",
 		sdev->host->host_no, sdev_channel(sdev), sdev_id(sdev),
-		sdev->lun);
+		scsilun_to_str(sdev, lunstr));
 	
 	class_device_initialize(&sdev->sdev_classdev);
 	sdev->sdev_classdev.dev = &sdev->sdev_gendev;
 	sdev->sdev_classdev.class = &sdev_class;
 	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
-		 "%d:%d:%d:%d", sdev->host->host_no,
-		 sdev_channel(sdev), sdev_id(sdev), sdev->lun);
+		 "%d:%d:%d:%s", sdev->host->host_no,
+		 sdev_channel(sdev), sdev_id(sdev),
+		scsilun_to_str(sdev, lunstr));
 	sdev->scsi_level = SCSI_2;
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2cab556..9f1d15e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1674,7 +1674,7 @@ fc_scsi_scan_rport(void *data)
 	struct fc_rport *rport = (struct fc_rport *)data;
 
 	scsi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
-			SCAN_WILD_CARD, 1);
+			SCAN_LUN_WILD_CARD, 1);
 }
 
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1d145d2..50f50d7 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -31,6 +31,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
+#include "scsi_priv.h"		/* for SCAN_LUN_WILD_CARD */
 
 
 #define SAS_HOST_ATTRS		0
@@ -579,7 +580,7 @@ int sas_rphy_add(struct sas_rphy *rphy)
 
 	if (rphy->scsi_target_id != -1) {
 		scsi_scan_target(&rphy->dev, parent->number,
-				rphy->scsi_target_id, ~0, 0);
+				rphy->scsi_target_id, SCAN_LUN_WILD_CARD, 0);
 	}
 
 	return 0;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b03e2fd..3ab60e5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -879,6 +879,8 @@ sg_ioctl(struct inode *inode, struct fil
 		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
 			return -EFAULT;
 		else {
+			unsigned int tmp_lun =
+				scsilun_to_int(&sdp->device->lun);
 			sg_scsi_id_t __user *sg_idp = p;
 
 			if (sdp->detached)
@@ -888,7 +890,7 @@ sg_ioctl(struct inode *inode, struct fil
 			__put_user((int) sdev_channel(sdp->device),
 				   &sg_idp->channel);
 			__put_user((int) sdev_id(sdp->device), &sg_idp->scsi_id);
-			__put_user((int) sdp->device->lun, &sg_idp->lun);
+			__put_user((int) tmp_lun, &sg_idp->lun);
 			__put_user((int) sdp->device->type, &sg_idp->scsi_type);
 			__put_user((short) sdp->device->host->cmd_per_lun,
 				   &sg_idp->h_cmd_per_lun);
@@ -3001,12 +3003,15 @@ static int sg_proc_seq_show_dev(struct s
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
 	Sg_device *sdp;
 	struct scsi_device *scsidp;
+	char lunstr[33];
 
 	sdp = it ? sg_get_dev(it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
-		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
+		seq_printf(s, "%d\t%d\t%d\t%s\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, sdev_channel(scsidp),
-			      sdev_id(scsidp), scsidp->lun, (int) scsidp->type,
+			      sdev_id(scsidp),
+			      scsilun_to_str(scsidp, lunstr),
+			      (int) scsidp->type,
 			      1,
 			      (int) scsidp->queue_depth,
 			      (int) scsidp->device_busy,
@@ -3127,13 +3132,15 @@ static int sg_proc_seq_show_debug(struct
 				sdp->disk->disk_name);
 			if (sdp->detached)
 				seq_printf(s, "detached pending close ");
-			else
+			else {
+				char lunstr[33];
 				seq_printf
-				    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
+				    (s, "scsi%d chan=%d id=%d lun=%s   em=%d",
 				     scsidp->host->host_no,
 				     sdev_channel(scsidp), sdev_id(scsidp),
-				     scsidp->lun,
+				     scsilun_to_str(scsidp, lunstr),
 				     scsidp->host->hostt->emulated);
+			}
 			seq_printf(s, " sg_tablesize=%d excl=%d\n",
 				   sdp->sg_tablesize, sdp->exclude);
 		}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8fdd70b..03b381e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <scsi/scsi.h>		/* for struct scsi_lun */
 #include <asm/atomic.h>
 
 struct request_queue;
@@ -66,7 +67,7 @@ struct scsi_device {
 					   jiffie count on our counter, they
 					   could all be from the same event. */
 
-	unsigned int lun;
+	struct scsi_lun lun;
 
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
@@ -178,22 +179,22 @@ static inline struct scsi_target *scsi_t
 	to_scsi_target(class_dev->dev)
 
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
-		uint, uint, uint, void *hostdata);
+		uint, uint, const struct scsi_lun *, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
-			   uint target, uint lun);
+			   uint target, const struct scsi_lun *lun);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_device_cancel(struct scsi_device *, int);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
-					      uint, uint, uint);
+					      uint, uint, const struct scsi_lun *);
 extern struct scsi_device *__scsi_device_lookup(struct Scsi_Host *,
-						uint, uint, uint);
+						uint, uint, const struct scsi_lun *);
 extern struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *,
-							uint);
+							const struct scsi_lun *);
 extern struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *,
-							  uint);
+							  const struct scsi_lun *);
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));
 
@@ -249,12 +250,13 @@ extern void scsi_device_resume(struct sc
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
 extern void scsi_scan_target(struct device *parent, unsigned int channel,
-			     unsigned int id, unsigned int lun, int rescan);
+			     unsigned int id, const struct scsi_lun *lun, int rescan);
 extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *);
 extern void scsi_remove_target(struct device *);
 extern void int_to_scsilun(unsigned int, struct scsi_lun *);
+extern int scsilun_to_int(const struct scsi_lun *scsilun);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
@@ -276,6 +278,17 @@ static inline unsigned int sdev_id(struc
 	return sdev->sdev_target->id;
 }
 
+static inline char *scsilun_to_str(struct scsi_device *sdev, char *s)
+{
+	sprintf(s, "%d", scsilun_to_int(&sdev->lun));
+	return s;
+}
+
+static inline int scsilun_eq(const struct scsi_lun *a, const struct scsi_lun *b)
+{
+	return (memcmp(a, b, sizeof(struct scsi_lun)) == 0);
+}
+
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
