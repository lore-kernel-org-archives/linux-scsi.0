From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] add scsi_level and revision support to lsscsci 0.03
Date: Tue, 7 Jan 2003 17:00:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030107170044.A17770@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

Doug -

This patch adds support for use of scsi_level and the output of revision
to lsscsi 0.03. It should work even without scsi_level in the scsi sysfs
attributes.

lsscsi -c now gives the exact same output as catting /proc/scsi/scsi.

--- lsscsi.c-orig	Tue Jan  7 15:55:25 2003
+++ lsscsi.c	Tue Jan  7 15:56:25 2003
@@ -221,7 +221,7 @@
 	int hcil_arr[4];
 	char buff[NAME_LEN_MAX];
 	char value[NAME_LEN_MAX];
-	int type, k;
+	int type, scsi_level, k;
 
 	strcpy(buff, dir_name);
 	strcat(buff, "/");
@@ -254,7 +254,13 @@
 		printf("  Type:   %-33s", "???");
 	} else
 		printf("  Type:   %-33s", scsi_device_types[type]);
-	printf("ANSI SCSI revision: ??\n");
+	if (! get_value(buff, "scsi_level", value, NAME_LEN_MAX)) {
+		printf("ANSI SCSI revision: ?\n");
+	} else if (1 != sscanf(value, "%d", &scsi_level)) {
+		printf("ANSI SCSI revision: ??\n");
+	} else
+		printf("ANSI SCSI revision: %02x\n", (scsi_level - 1) ?
+		                            scsi_level - 1 : 1);
 	if (out_mask & MASK_NAME) {
 		if (get_value(buff, "name", value, NAME_LEN_MAX))
 			printf("  name: %s\n", value);

-- Patrick Mansfield
