Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0170177982
	for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713463846; cv=none; b=ATgxYZx9BrSzJJP/ThsTwWmwnM1NE9Epvxx+a1F0K+nd6h73JR0Tz8mqECp7Bu7qVDAgZsiFdNHE6KYBjAJtVGFF3A3UxlngVh1yIdJ4g6TnGfkDGnbACkXWyJl1sxvMDWDOpHrmpVHoYG6Jxb12vgTJdoEmBcioMaoEcCzAaws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713463846; c=relaxed/simple;
	bh=SvoGsPPNmzsdDfyPcYy6K4+g8/SbnhTFMlZmlFMxM50=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=NdTfnqyJ5dhaOOmtyk4ob8pWIDrFOdQ9hd0MokUmbkSmIVuv0EUB5eXusG710Tnx509f9Q1+u/zGeHGXdFKqmPEBbOmCaBf9hfZHX0VvKw/P3clAUB8x4edJLLa3hTaBuVARLSPGy+CRbolvczpKzXEDPw8vnDIepGr4AbHsi2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cSx4NBIT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cSx4NBIT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713463843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JMnsBskA5ZoVHlFpWWGZTlvVAgvUGvu6xG38H7y9v3c=;
	b=cSx4NBIT1SdOdzgi3PwFS2MSLTGxo1kt9oirDEFhluw8XUg8HAeJW2q8ySnlQX87h0Qdp7
	+8N9MvCzwEjCmxKkAKV/Tlw6r9n54T0yQDlc806f73xB9GgApSPmrOxKHv/5TqAc+ig972
	LBgEdmWwCWX/2CTn/R3Scle9EfVEo8c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-UFqs0D42NX6cUA0gBQxgtQ-1; Thu, 18 Apr 2024 14:10:42 -0400
X-MC-Unique: UFqs0D42NX6cUA0gBQxgtQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE0B418065AE;
	Thu, 18 Apr 2024 18:10:41 +0000 (UTC)
Received: from lobefedora.redhat.com (unknown [10.22.16.199])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 78FDB20296D2;
	Thu, 18 Apr 2024 18:10:41 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: loberman@redhat.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	emilne@redhat.com,
	jpittman@redhat.com,
	jmeneghi@redhat.com,
	Bart.VanAssche@wdc.com
Subject: [PATCH] V2 scsi_mod: Add a new parameter to scsi_mod to control
Date: Thu, 18 Apr 2024 14:10:38 -0400
Message-ID: <20240418181038.198242-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Resend of this patch as V2 against Martin's tree.
Changes: Removed initialization of global variable storage_quiet_discovery

This new parameter storage_quiet_discovery defaults to 0 and behavior is
unchanged. If its set to 1 on the kernel line then sd_printk and
sdev_printk are disabled for printing. The default logging can be
re-enabled any time after boot using /etc/sysctl.conf by setting
dev.scsi.storage_quiet_discovery = 0.
systctl -w dev.scsi.storage_quiet_discovery=0 will also change it
immediately back to logging. i
Users can leave it set to 1 on the kernel line and 0 in the conf file
so it changes back to default after rc.sysinit.
This solves the tough problem of systems with 1000's of
storage LUNS consuming a system and preventing it from booting due to
NMI's and timeouts due to udev triggers.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 Documentation/scsi/scsi-parameters.rst | 16 ++++++++++++++++
 Makefile                               |  2 +-
 drivers/scsi/scsi.c                    |  6 ++++++
 drivers/scsi/scsi_sysctl.c             |  5 +++++
 drivers/scsi/sd.h                      | 11 ++++++++---
 include/scsi/scsi_device.h             |  8 ++++++--
 6 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/Documentation/scsi/scsi-parameters.rst b/Documentation/scsi/scsi-parameters.rst
index c42c55e1e25e..ec2372db82bd 100644
--- a/Documentation/scsi/scsi-parameters.rst
+++ b/Documentation/scsi/scsi-parameters.rst
@@ -93,6 +93,22 @@ parameters may be changed at runtime by the command
 			S390-tools package, available for download at
 			https://github.com/ibm-s390-linux/s390-tools/blob/master/scripts/scsi_logging_level
 
+	scsi_mod.storage_quiet_discovery=
+                       [SCSI] a parameter to control the printing from
+                        sdev_printk and sd_printk for systems with large
+                        amounts of LUNS.
+                        Defaults to 0 so unchanged behavior.
+                        If scsi_mod.storage_quiet_discovery=1 is added boot line
+                        then the messages are not printed and can be enabled
+                        after boot via
+                        echo 0 >
+                        /sys/module/scsi_mod/parameters/storage_quiet_discovery
+                        Another option is using
+                        sysctl -w dev.scsi.storage_quiet_discovery=0.
+                        Leaving this set to 0 in /etc/sysctl.conf and setting
+                        it to 1 on the kernel line will help for these large
+                        LUN count configurations and ensure its back on after boot.
+
 	scsi_mod.scan=	[SCSI] sync (default) scans SCSI busses as they are
 			discovered.  async scans them in kernel threads,
 			allowing boot to proceed.  none ignores them, expecting
diff --git a/Makefile b/Makefile
index 763b6792d3d5..5effa83a32ab 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@
 VERSION = 6
 PATCHLEVEL = 9
 SUBLEVEL = 0
-EXTRAVERSION = -rc1
+EXTRAVERSION = -rc1.lobe
 NAME = Hurr durr I'ma ninja sloth
 
 # *DOCUMENTATION*
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3e0c0381277a..38db68861bbe 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -76,6 +76,9 @@
  * Definitions and constants.
  */
 
+int storage_quiet_discovery;
+EXPORT_SYMBOL(storage_quiet_discovery);
+
 /*
  * Note - the initial logging level can be set here to log events at boot time.
  * After the system is up, you may enable logging via the /proc interface.
@@ -979,6 +982,9 @@ MODULE_LICENSE("GPL");
 
 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
+module_param(storage_quiet_discovery, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(storage_quiet_discovery, "If set to 1 will silence SCSI and \
+		ALUA discovery logging on boot");
 
 static int __init init_scsi(void)
 {
diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 093774d77534..13c7ee4a6212 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -18,6 +18,11 @@ static struct ctl_table scsi_table[] = {
 	  .maxlen	= sizeof(scsi_logging_level),
 	  .mode		= 0644,
 	  .proc_handler	= proc_dointvec },
+	{ .procname	= "storage_quiet_discovery",
+	  .data		= &storage_quiet_discovery,
+	  .maxlen	= sizeof(storage_quiet_discovery),
+	  .mode		= 0644,
+	  .proc_handler	= proc_dointvec },
 };
 
 static struct ctl_table_header *scsi_table_header;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5c4285a582b2..e1cff37ca69e 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -162,11 +162,16 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 	return disk->private_data;
 }
 
+extern int storage_quiet_discovery;
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
-        (sdsk)->disk ?							\
-	      sdev_prefix_printk(prefix, (sdsk)->device,		\
+	do {								\
+		if (!storage_quiet_discovery)				\
+		 (sdsk)->disk ?						\
+			sdev_prefix_printk(prefix, (sdsk)->device,	\
 				 (sdsk)->disk->disk_name, fmt, ##a) :	\
-	      sdev_printk(prefix, (sdsk)->device, fmt, ##a)
+			sdev_printk(prefix, (sdsk)->device, fmt, ##a);	\
+	} while (0)
 
 #define sd_first_printk(prefix, sdsk, fmt, a...)			\
 	do {								\
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c540f5468eb..0ad0c387883e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -302,8 +302,12 @@ __printf(4, 5) void
 sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
 		const char *, ...);
 
-#define sdev_printk(l, sdev, fmt, a...)				\
-	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
+extern int storage_quiet_discovery;
+
+#define sdev_printk(l, sdev, fmt, a...) ({			\
+	if (!storage_quiet_discovery)				\
+		sdev_prefix_printk(l, sdev, NULL, fmt, ##a);	\
+	})
 
 __printf(3, 4) void
 scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
-- 
2.42.0

