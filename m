From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6.9-bk aacraid: Detect non-committed array
Date: Mon, 13 Sep 2004 13:23:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095106999.10291.30.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:56767 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S267659AbUIMUXY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 16:23:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Haverkamp <markh@osdl.org>

James, Sorry for the resend, I accidentally had some sort of html in the
cut and paste text.  Hopefully this one is OK.
------------------------------------------------------

>From Mark Salyzyn at Adaptec:
"In the case of this driver patch, we will report to the user via a
syslogd kernel message that a foreign array has been ignored in
non-intel environments; or intel environments where the BIOS fails to
load to perform this set of housekeeping functions. There is a
provision, via the commit variable, to change this behavior to accept
the configuration instead."

Patch applies to the latest 2.6 BK tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/aachba.c 1.26 vs edited =====
--- 1.26/drivers/scsi/aacraid/aachba.c	2004-08-10 09:26:16 -07:00
+++ edited/drivers/scsi/aacraid/aachba.c	2004-08-16 10:55:47 -07:00
@@ -193,6 +193,80 @@
 static int nondasd = -1;
 static int dacmode = -1;
 
+static int commit = -1;
+
+/**
+ *	aac_get_config_status	-	check the adapter configuration
+ *	@common: adapter to query
+ *
+ *	Query config status, and commit the configuration if needed.
+ */
+int aac_get_config_status(struct aac_dev *dev)
+{
+	int status = 0;
+	struct fib * fibptr;
+
+	if (!(fibptr = fib_alloc(dev)))
+		return -ENOMEM;
+
+	fib_init(fibptr);
+	{
+		struct aac_get_config_status *dinfo;
+		dinfo = (struct aac_get_config_status *) fib_data(fibptr);
+
+		dinfo->command = cpu_to_le32(VM_ContainerConfig);
+		dinfo->type = cpu_to_le32(CT_GET_CONFIG_STATUS);
+		dinfo->count = cpu_to_le32(sizeof(((struct aac_get_config_status_resp *)NULL)->data));
+	}
+
+	status = fib_send(ContainerCommand,
+			    fibptr,
+			    sizeof (struct aac_get_config_status),
+			    FsaNormal,
+			    1, 1,
+			    NULL, NULL);
+	if (status < 0 ) {
+		printk(KERN_WARNING "aac_get_config_status: SendFIB failed.\n");
+	} else {
+		struct aac_get_config_status_resp *reply
+		  = (struct aac_get_config_status_resp *) fib_data(fibptr);
+		dprintk((KERN_WARNING
+		  "aac_get_config_status: response=%d status=%d action=%d\n",
+		  reply->response, reply->status, reply->data.action));
+		if ((reply->response != ST_OK)
+		 || (reply->status != CT_OK)
+		 || (reply->data.action > CFACT_PAUSE)) {
+			printk(KERN_WARNING "aac_get_config_status: Will not issue the Commit Configuration\n");
+			status = -EINVAL;
+		}
+	}
+	fib_complete(fibptr);
+	/* Send a CT_COMMIT_CONFIG to enable discovery of devices */
+	if (status >= 0) {
+		if (commit == 1) {
+			struct aac_commit_config * dinfo;
+			fib_init(fibptr);
+			dinfo = (struct aac_commit_config *) fib_data(fibptr);
+	
+			dinfo->command = cpu_to_le32(VM_ContainerConfig);
+			dinfo->type = cpu_to_le32(CT_COMMIT_CONFIG);
+	
+			status = fib_send(ContainerCommand,
+				    fibptr,
+				    sizeof (struct aac_commit_config),
+				    FsaNormal,
+				    1, 1,
+				    NULL, NULL);
+			fib_complete(fibptr);
+		} else if (commit == 0) {
+			printk(KERN_WARNING
+			  "aac_get_config_status: Foreign device configurations are being ignored\n");
+		}
+	}
+	fib_free(fibptr);
+	return status;
+}
+
 /**
  *	aac_get_containers	-	list containers
  *	@common: adapter to probe
===== drivers/scsi/aacraid/aacraid.h 1.19 vs edited =====
--- 1.19/drivers/scsi/aacraid/aacraid.h	2004-08-10 08:12:00 -07:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-08-16 11:28:35 -07:00
@@ -57,6 +57,7 @@
 #define		CT_VOLUME_OF_MIRRORS	12	/* volume of mirror */
 #define		CT_PSEUDO_RAID		13	/* really raid4 */
 #define		CT_LAST_VOLUME_TYPE	14
+#define 	CT_OK        		218
 
 /*
  *	Types of objects addressable in some fashion by the client.
@@ -1169,6 +1170,52 @@
 };
 
 /*
+ *	Query for Container Configuration Status
+ */
+
+#define CT_GET_CONFIG_STATUS 147
+struct aac_get_config_status {
+	u32		command;	/* VM_ContainerConfig */
+	u32		type;		/* CT_GET_CONFIG_STATUS */
+	u32		parm1;
+	u32		parm2;
+	u32		parm3;
+	u32		parm4;
+	u32		parm5;
+	u32		count;	/* sizeof(((struct aac_get_config_status_resp *)NULL)->data) */
+};
+
+#define CFACT_CONTINUE 0
+#define CFACT_PAUSE    1
+#define CFACT_ABORT    2
+struct aac_get_config_status_resp {
+	u32		response; /* ST_OK */
+	u32		dummy0;
+	u32		status;	/* CT_OK */
+	u32		parm1;
+	u32		parm2;
+	u32		parm3;
+	u32		parm4;
+	u32		parm5;
+	struct {
+		u32	action; /* CFACT_CONTINUE, CFACT_PAUSE or CFACT_ABORT */
+		u16	flags;
+		s16	count;
+	}		data;
+};
+
+/*
+ *	Accept the configuration as-is
+ */
+
+#define CT_COMMIT_CONFIG 152
+
+struct aac_commit_config {
+	u32		command;	/* VM_ContainerConfig */
+	u32		type;		/* CT_COMMIT_CONFIG */
+};
+
+/*
  *	Query for "mountable" objects, ie, objects that are typically
  *	associated with a drive letter on the client (host) side.
  */
@@ -1443,6 +1490,7 @@
 int fib_complete(struct fib * context);
 #define fib_data(fibctx) ((void *)(fibctx)->hw_fib->data)
 struct aac_dev *aac_init_adapter(struct aac_dev *dev);
+int aac_get_config_status(struct aac_dev *dev);
 int aac_get_containers(struct aac_dev *dev);
 int aac_scsi_cmd(struct scsi_cmnd *cmd);
 int aac_dev_ioctl(struct aac_dev *dev, int cmd, void __user *arg);
===== drivers/scsi/aacraid/linit.c 1.37 vs edited =====
--- 1.37/drivers/scsi/aacraid/linit.c	2004-08-18 20:54:47 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-08-24 08:49:49 -07:00
@@ -589,6 +589,7 @@
 	else
 		shost->max_channel = 1;
 
+	aac_get_config_status(aac);
 	aac_get_containers(aac);
 	aac_devices[aac_count-1] = aac;
 


-- 
Mark Haverkamp <markh@osdl.org>

