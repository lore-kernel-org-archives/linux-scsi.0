From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 3/7]  mptfusion - cleaning up xxx_probe error handling
Date: Wed, 16 Nov 2005 18:54:17 -0700
Message-ID: <200511161854.17435.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JL+eDysP0AuiWmQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4738 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161091AbVKQB7s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 20:59:48 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id jAH1t7SW011541
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:55:07 -0800 (PST)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id jAH1xmFP001934
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:59:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_JL+eDysP0AuiWmQ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This cleans the returning failure conditions of the mptsas/mptfc/mptspi probe routines.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

--Boundary-00=_JL+eDysP0AuiWmQ
Content-Type: text/x-diff;
  charset="us-ascii";
  name="3-probe-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="3-probe-fix.patch"

diff -uarN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2005-11-16 17:22:38.000000000 -0700
+++ a/drivers/message/fusion/mptfc.c	2005-11-16 17:29:13.000000000 -0700
@@ -168,13 +168,15 @@
 		printk(MYIOC_s_WARN_FMT
 		  "Skipping because it's not operational!\n",
 		  ioc->name);
-		return -ENODEV;
+		error = -ENODEV;
+		goto out_mptfc_probe;
 	}
 
 	if (!ioc->active) {
 		printk(MYIOC_s_WARN_FMT "Skipping because it's disabled!\n",
 		  ioc->name);
-		return -ENODEV;
+		error = -ENODEV;
+		goto out_mptfc_probe;
 	}
 
 	/*  Sanity check - ensure at least 1 port is INITIATOR capable
@@ -199,7 +201,8 @@
 		printk(MYIOC_s_WARN_FMT
 			"Unable to register controller with SCSI subsystem\n",
 			ioc->name);
-                return -1;
+		error = -1;
+		goto out_mptfc_probe;
         }
 
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
@@ -267,7 +270,7 @@
 	mem = kmalloc(sz, GFP_ATOMIC);
 	if (mem == NULL) {
 		error = -ENOMEM;
-		goto mptfc_probe_failed;
+		goto out_mptfc_probe;
 	}
 
 	memset(mem, 0, sz);
@@ -285,7 +288,7 @@
 	mem = kmalloc(sz, GFP_ATOMIC);
 	if (mem == NULL) {
 		error = -ENOMEM;
-		goto mptfc_probe_failed;
+		goto out_mptfc_probe;
 	}
 
 	memset(mem, 0, sz);
@@ -331,13 +334,13 @@
 	if(error) {
 		dprintk((KERN_ERR MYNAM
 		  "scsi_add_host failed\n"));
-		goto mptfc_probe_failed;
+		goto out_mptfc_probe;
 	}
 
 	scsi_scan_host(sh);
 	return 0;
 
-mptfc_probe_failed:
+out_mptfc_probe:
 
 	mptscsih_remove(pdev);
 	return error;
diff -uarN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2005-11-16 17:23:02.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2005-11-16 17:27:57.000000000 -0700
@@ -1134,13 +1134,15 @@
 		printk(MYIOC_s_WARN_FMT
 		  "Skipping because it's not operational!\n",
 		  ioc->name);
-		return -ENODEV;
+		error = -ENODEV;
+		goto out_mptsas_probe;
 	}
 
 	if (!ioc->active) {
 		printk(MYIOC_s_WARN_FMT "Skipping because it's disabled!\n",
 		  ioc->name);
-		return -ENODEV;
+		error = -ENODEV;
+		goto out_mptsas_probe;
 	}
 
 	/*  Sanity check - ensure at least 1 port is INITIATOR capable
@@ -1164,7 +1166,8 @@
 		printk(MYIOC_s_WARN_FMT
 			"Unable to register controller with SCSI subsystem\n",
 			ioc->name);
-                return -1;
+		error = -1;
+		goto out_mptsas_probe;
         }
 
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
@@ -1238,7 +1241,7 @@
 	mem = kmalloc(sz, GFP_ATOMIC);
 	if (mem == NULL) {
 		error = -ENOMEM;
-		goto mptsas_probe_failed;
+		goto out_mptsas_probe;
 	}
 
 	memset(mem, 0, sz);
@@ -1256,7 +1259,7 @@
 	mem = kmalloc(sz, GFP_ATOMIC);
 	if (mem == NULL) {
 		error = -ENOMEM;
-		goto mptsas_probe_failed;
+		goto out_mptsas_probe;
 	}
 
 	memset(mem, 0, sz);
@@ -1309,14 +1312,14 @@
 	if (error) {
 		dprintk((KERN_ERR MYNAM
 		  "scsi_add_host failed\n"));
-		goto mptsas_probe_failed;
+		goto out_mptsas_probe;
 	}
 
 	mptsas_scan_sas_topology(ioc);
 
 	return 0;
 
-mptsas_probe_failed:
+out_mptsas_probe:
 
 	mptscsih_remove(pdev);
 	return error;
diff -uarN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2005-11-16 17:22:29.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2005-11-16 17:26:47.000000000 -0700
@@ -178,13 +178,15 @@
 		printk(MYIOC_s_WARN_FMT
 		  "Skipping because it's not operational!\n",
 		  ioc->name);
-		return -ENODEV;
+		error = -ENODEV;
+		goto out_mptspi_probe;
 	}
 
 	if (!ioc->active) {
 		printk(MYIOC_s_WARN_FMT "Skipping because it's disabled!\n",
 		  ioc->name);
-		return -ENODEV;
+		error = -ENODEV;
+		goto out_mptspi_probe;
 	}
 
 	/*  Sanity check - ensure at least 1 port is INITIATOR capable
@@ -209,7 +211,8 @@
 		printk(MYIOC_s_WARN_FMT
 			"Unable to register controller with SCSI subsystem\n",
 			ioc->name);
-                return -1;
+		error = -1;
+		goto out_mptspi_probe;
         }
 
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
@@ -287,7 +290,7 @@
 	mem = kmalloc(sz, GFP_ATOMIC);
 	if (mem == NULL) {
 		error = -ENOMEM;
-		goto mptspi_probe_failed;
+		goto out_mptspi_probe;
 	}
 
 	memset(mem, 0, sz);
@@ -305,7 +308,7 @@
 	mem = kmalloc(sz, GFP_ATOMIC);
 	if (mem == NULL) {
 		error = -ENOMEM;
-		goto mptspi_probe_failed;
+		goto out_mptspi_probe;
 	}
 
 	memset(mem, 0, sz);
@@ -386,13 +389,13 @@
 	if(error) {
 		dprintk((KERN_ERR MYNAM
 		  "scsi_add_host failed\n"));
-		goto mptspi_probe_failed;
+		goto out_mptspi_probe;
 	}
 
 	scsi_scan_host(sh);
 	return 0;
 
-mptspi_probe_failed:
+out_mptspi_probe:
 
 	mptscsih_remove(pdev);
 	return error;

--Boundary-00=_JL+eDysP0AuiWmQ--
