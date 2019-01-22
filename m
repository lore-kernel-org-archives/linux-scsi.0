From: "Satish Kharat (satishkh)" <satishkh@cisco.com>
Subject: RE: [PATCH 3/7] scsi: fnic: no need to check return value of
 debugfs_create functions
Date: Tue, 22 Jan 2019 18:05:30 +0000
Message-ID: <a001f340b2f94667bcc2870244cfccd7@XCH-RCD-012.cisco.com>
References: <20190122150906.12470-1-gregkh@linuxfoundation.org>
 <20190122150906.12470-4-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122150906.12470-4-gregkh@linuxfoundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
List-Id: linux-scsi@vger.kernel.org

Looks good to me.
Acked-by: Satish Kharat <satishkh@cisco.com>


Satish Kharat
TECHNICAL LEADER.ENGINEERING
satishkh@cisco.com

-----Original Message-----
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=20
Sent: Tuesday, January 22, 2019 7:09 AM
To: James Bottomley <jejb@linux.ibm.com>; Martin Petersen <martin.petersen@=
oracle.com>
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Greg Kroah-Ha=
rtman <gregkh@linuxfoundation.org>; Satish Kharat (satishkh) <satishkh@cisc=
o.com>; Sesidhar Baddela (sebaddel) <sebaddel@cisco.com>; Karan Tilak Kumar=
 (kartilak) <kartilak@cisco.com>
Subject: [PATCH 3/7] scsi: fnic: no need to check return value of debugfs_c=
reate functions

When calling debugfs functions, there is no need to ever check the return v=
alue.  The function can work or not, but the code logic should never do som=
ething different based on this.

Cc: Satish Kharat <satishkh@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fnic_debugfs.c | 88 ++------------------------------
 drivers/scsi/fnic/fnic_main.c    |  7 +--
 drivers/scsi/fnic/fnic_stats.h   |  2 +-
 drivers/scsi/fnic/fnic_trace.c   | 17 ++----
 drivers/scsi/fnic/fnic_trace.h   |  4 +-
 5 files changed, 10 insertions(+), 108 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debu=
gfs.c
index 139fffa3658a..21991c99db7c 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -54,23 +54,9 @@ int fnic_debugfs_init(void)  {
 	int rc =3D -1;
 	fnic_trace_debugfs_root =3D debugfs_create_dir("fnic", NULL);
-	if (!fnic_trace_debugfs_root) {
-		printk(KERN_DEBUG "Cannot create debugfs root\n");
-		return rc;
-	}
-
-	if (!fnic_trace_debugfs_root) {
-		printk(KERN_DEBUG
-			"fnic root directory doesn't exist in debugfs\n");
-		return rc;
-	}
=20
 	fnic_stats_debugfs_root =3D debugfs_create_dir("statistics",
 						fnic_trace_debugfs_root);
-	if (!fnic_stats_debugfs_root) {
-		printk(KERN_DEBUG "Cannot create Statistics directory\n");
-		return rc;
-	}
=20
 	/* Allocate memory to structure */
 	fc_trc_flag =3D (struct fc_trace_flag_type *) @@ -356,39 +342,19 @@ stati=
c const struct file_operations fnic_trace_debugfs_fops =3D {
  * it will also create file trace_enable to control enable/disable of
  * trace logging into trace buffer.
  */
-int fnic_trace_debugfs_init(void)
+void fnic_trace_debugfs_init(void)
 {
-	int rc =3D -1;
-	if (!fnic_trace_debugfs_root) {
-		printk(KERN_DEBUG
-			"FNIC Debugfs root directory doesn't exist\n");
-		return rc;
-	}
 	fnic_trace_enable =3D debugfs_create_file("tracing_enable",
 					S_IFREG|S_IRUGO|S_IWUSR,
 					fnic_trace_debugfs_root,
 					&(fc_trc_flag->fnic_trace),
 					&fnic_trace_ctrl_fops);
=20
-	if (!fnic_trace_enable) {
-		printk(KERN_DEBUG
-			"Cannot create trace_enable file under debugfs\n");
-		return rc;
-	}
-
 	fnic_trace_debugfs_file =3D debugfs_create_file("trace",
 					S_IFREG|S_IRUGO|S_IWUSR,
 					fnic_trace_debugfs_root,
 					&(fc_trc_flag->fnic_trace),
 					&fnic_trace_debugfs_fops);
-
-	if (!fnic_trace_debugfs_file) {
-		printk(KERN_DEBUG
-			"Cannot create trace file under debugfs\n");
-		return rc;
-	}
-	rc =3D 0;
-	return rc;
 }
=20
 /*
@@ -419,37 +385,20 @@ void fnic_trace_debugfs_terminate(void)
  * trace logging into trace buffer.
  */
=20
-int fnic_fc_trace_debugfs_init(void)
+void fnic_fc_trace_debugfs_init(void)
 {
-	int rc =3D -1;
-
-	if (!fnic_trace_debugfs_root) {
-		pr_err("fnic:Debugfs root directory doesn't exist\n");
-		return rc;
-	}
-
 	fnic_fc_trace_enable =3D debugfs_create_file("fc_trace_enable",
 					S_IFREG|S_IRUGO|S_IWUSR,
 					fnic_trace_debugfs_root,
 					&(fc_trc_flag->fc_trace),
 					&fnic_trace_ctrl_fops);
=20
-	if (!fnic_fc_trace_enable) {
-		pr_err("fnic: Failed create fc_trace_enable file\n");
-		return rc;
-	}
-
 	fnic_fc_trace_clear =3D debugfs_create_file("fc_trace_clear",
 					S_IFREG|S_IRUGO|S_IWUSR,
 					fnic_trace_debugfs_root,
 					&(fc_trc_flag->fc_clear),
 					&fnic_trace_ctrl_fops);
=20
-	if (!fnic_fc_trace_clear) {
-		pr_err("fnic: Failed to create fc_trace_enable file\n");
-		return rc;
-	}
-
 	fnic_fc_rdata_trace_debugfs_file =3D
 		debugfs_create_file("fc_trace_rdata",
 				    S_IFREG|S_IRUGO|S_IWUSR,
@@ -457,24 +406,12 @@ int fnic_fc_trace_debugfs_init(void)
 				    &(fc_trc_flag->fc_normal_file),
 				    &fnic_trace_debugfs_fops);
=20
-	if (!fnic_fc_rdata_trace_debugfs_file) {
-		pr_err("fnic: Failed create fc_rdata_trace file\n");
-		return rc;
-	}
-
 	fnic_fc_trace_debugfs_file =3D
 		debugfs_create_file("fc_trace",
 				    S_IFREG|S_IRUGO|S_IWUSR,
 				    fnic_trace_debugfs_root,
 				    &(fc_trc_flag->fc_row_file),
 				    &fnic_trace_debugfs_fops);
-
-	if (!fnic_fc_trace_debugfs_file) {
-		pr_err("fnic: Failed to create fc_trace file\n");
-		return rc;
-	}
-	rc =3D 0;
-	return rc;
 }
=20
 /*
@@ -757,45 +694,26 @@ static const struct file_operations fnic_reset_debugf=
s_fops =3D {
  * It will create file stats and reset_stats under statistics/host# direct=
ory
  * to log per fnic stats.
  */
-int fnic_stats_debugfs_init(struct fnic *fnic)
+void fnic_stats_debugfs_init(struct fnic *fnic)
 {
-	int rc =3D -1;
 	char name[16];
=20
 	snprintf(name, sizeof(name), "host%d", fnic->lport->host->host_no);
=20
-	if (!fnic_stats_debugfs_root) {
-		printk(KERN_DEBUG "fnic_stats root doesn't exist\n");
-		return rc;
-	}
 	fnic->fnic_stats_debugfs_host =3D debugfs_create_dir(name,
 						fnic_stats_debugfs_root);
-	if (!fnic->fnic_stats_debugfs_host) {
-		printk(KERN_DEBUG "Cannot create host directory\n");
-		return rc;
-	}
=20
 	fnic->fnic_stats_debugfs_file =3D debugfs_create_file("stats",
 						S_IFREG|S_IRUGO|S_IWUSR,
 						fnic->fnic_stats_debugfs_host,
 						fnic,
 						&fnic_stats_debugfs_fops);
-	if (!fnic->fnic_stats_debugfs_file) {
-		printk(KERN_DEBUG "Cannot create host stats file\n");
-		return rc;
-	}
=20
 	fnic->fnic_reset_debugfs_file =3D debugfs_create_file("reset_stats",
 						S_IFREG|S_IRUGO|S_IWUSR,
 						fnic->fnic_stats_debugfs_host,
 						fnic,
 						&fnic_reset_debugfs_fops);
-	if (!fnic->fnic_reset_debugfs_file) {
-		printk(KERN_DEBUG "Cannot create host stats file\n");
-		return rc;
-	}
-	rc =3D 0;
-	return rc;
 }
=20
 /*
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c =
index 5b3534b0deda..cc8f7c82e2ba 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -578,12 +578,7 @@ static int fnic_probe(struct pci_dev *pdev, const stru=
ct pci_device_id *ent)
=20
 	host->transportt =3D fnic_fc_transport;
=20
-	err =3D fnic_stats_debugfs_init(fnic);
-	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-				"Failed to initialize debugfs for stats\n");
-		fnic_stats_debugfs_remove(fnic);
-	}
+	fnic_stats_debugfs_init(fnic);
=20
 	/* Setup PCI resources */
 	pci_set_drvdata(pdev, fnic);
diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.=
h index 9daa6ada6fa0..09c3f864c1cf 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -134,6 +134,6 @@ struct stats_debug_info {  };
=20
 int fnic_get_stats_data(struct stats_debug_info *, struct fnic_stats *); -=
int fnic_stats_debugfs_init(struct fnic *);
+void fnic_stats_debugfs_init(struct fnic *);
 void fnic_stats_debugfs_remove(struct fnic *);  #endif /* _FNIC_STATS_H_ *=
/ diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trac=
e.c index bf0fd2aeb92e..c08eda9ef086 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -503,15 +503,10 @@ int fnic_trace_buf_init(void)
 		fnic_trace_entries.page_offset[i] =3D fnic_buf_head;
 		fnic_buf_head +=3D FNIC_ENTRY_SIZE_BYTES;
 	}
-	err =3D fnic_trace_debugfs_init();
-	if (err < 0) {
-		pr_err("fnic: Failed to initialize debugfs for tracing\n");
-		goto err_fnic_trace_debugfs_init;
-	}
+	fnic_trace_debugfs_init();
 	pr_info("fnic: Successfully Initialized Trace Buffer\n");
 	return err;
-err_fnic_trace_debugfs_init:
-	fnic_trace_free();
+
 err_fnic_trace_buf_init:
 	return err;
 }
@@ -596,16 +591,10 @@ int fnic_fc_trace_init(void)
 		fc_trace_entries.page_offset[i] =3D fc_trace_buf_head;
 		fc_trace_buf_head +=3D FC_TRC_SIZE_BYTES;
 	}
-	err =3D fnic_fc_trace_debugfs_init();
-	if (err < 0) {
-		pr_err("fnic: Failed to initialize FC_CTLR tracing.\n");
-		goto err_fnic_fc_ctlr_trace_debugfs_init;
-	}
+	fnic_fc_trace_debugfs_init();
 	pr_info("fnic: Successfully Initialized FC_CTLR Trace Buffer\n");
 	return err;
=20
-err_fnic_fc_ctlr_trace_debugfs_init:
-	fnic_fc_trace_free();
 err_fnic_fc_ctlr_trace_buf_init:
 	return err;
 }
diff --git a/drivers/scsi/fnic/fnic_trace.h b/drivers/scsi/fnic/fnic_trace.=
h index e375d0c2eaaf..8aa55c1e2025 100644
--- a/drivers/scsi/fnic/fnic_trace.h
+++ b/drivers/scsi/fnic/fnic_trace.h
@@ -111,7 +111,7 @@ int fnic_trace_buf_init(void);  void fnic_trace_free(vo=
id);  int fnic_debugfs_init(void);  void fnic_debugfs_terminate(void); -int=
 fnic_trace_debugfs_init(void);
+void fnic_trace_debugfs_init(void);
 void fnic_trace_debugfs_terminate(void);
=20
 /* Fnic FC CTLR Trace releated function */ @@ -123,7 +123,7 @@ int fnic_fc=
_trace_get_data(fnic_dbgfs_t *fnic_dbgfs_prt, u8 rdata_flag);  void copy_an=
d_format_trace_data(struct fc_trace_hdr *tdata,
 				fnic_dbgfs_t *fnic_dbgfs_prt,
 				int *len, u8 rdata_flag);
-int fnic_fc_trace_debugfs_init(void);
+void fnic_fc_trace_debugfs_init(void);
 void fnic_fc_trace_debugfs_terminate(void);
=20
 #endif
--
2.20.1
