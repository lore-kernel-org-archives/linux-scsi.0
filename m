From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2.6] aacraid driver patch
Date: Thu, 11 Mar 2004 11:16:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079032608.10128.48.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:13224 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261531AbUCKTQv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 14:16:51 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

I submitted a patch last month for the aacraid driver's reset handler. 
I left out setting function pointers in the adapter_ops structure for
the adapter_check_health element.


 ===== drivers/scsi/aacraid/rkt.c 1.2 vs edited =====
--- 1.2/drivers/scsi/aacraid/rkt.c	Fri Feb 13 06:06:03 2004
+++ edited/drivers/scsi/aacraid/rkt.c	Thu Mar 11 10:50:52 2004
@@ -427,6 +427,7 @@
 	dev->a_ops.adapter_disable_int = aac_rkt_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_rkt_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rkt_sync_cmd;
+	dev->a_ops.adapter_check_health = aac_rkt_check_health;
 
 	if (aac_init_adapter(dev) == NULL)
 		return -1;
===== drivers/scsi/aacraid/rx.c 1.7 vs edited =====
--- 1.7/drivers/scsi/aacraid/rx.c	Fri Feb 13 06:04:31 2004
+++ edited/drivers/scsi/aacraid/rx.c	Thu Mar 11 10:50:46 2004
@@ -427,6 +427,7 @@
 	dev->a_ops.adapter_disable_int = aac_rx_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_rx_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
+	dev->a_ops.adapter_check_health = aac_rx_check_health;
 
 	if (aac_init_adapter(dev) == NULL)
 		return -1;
===== drivers/scsi/aacraid/sa.c 1.7 vs edited =====
--- 1.7/drivers/scsi/aacraid/sa.c	Fri Feb 13 06:03:46 2004
+++ edited/drivers/scsi/aacraid/sa.c	Thu Mar 11 10:50:42 2004
@@ -407,6 +407,7 @@
 	dev->a_ops.adapter_disable_int = aac_sa_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
+	dev->a_ops.adapter_check_health = aac_sa_check_health;
 
 	dprintk(("FUNCDONE\n"));
 


-- 
Mark Haverkamp <markh@osdl.org>

