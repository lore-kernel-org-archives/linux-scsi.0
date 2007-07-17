From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libsas: fix lockdep issue with ATA
Date: Tue, 17 Jul 2007 11:35:26 -0500
Message-ID: <1184690126.3378.8.camel@localhost.localdomain>
References: <1184609751.3447.22.camel@localhost.localdomain>
	 <20070717112955.GR5195@kernel.dk>
	 <1184681570.3378.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55049 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752494AbXGQQfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 12:35:31 -0400
In-Reply-To: <1184681570.3378.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2007-07-17 at 09:12 -0500, James Bottomley wrote:
> > process context, no need to save flags here either.
> 
> OK, you caught me ... I was just doing the fastest thing I could to get
> lockdep to shut up.  By the way, it dumps about 120KB of logs so it's
> fun to get an actual trace of this...
> 
> I'll make the fixes and resubmit

Here's the update.

James

---

>From 0852ea7aafd0368026e8dacd7810c2444adb8d19 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@steeleye.com>
Date: Mon, 16 Jul 2007 13:15:51 -0500
Subject: [SCSI] libsas: fix lockdep issue with ATA

lockdep noticed that with ATA support the port->dev_list_lock was
entangled at irq context, so it now needs to become IRQ safe

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/libsas/sas_discover.c |   10 ++++++----
 drivers/scsi/libsas/sas_expander.c |   14 ++++++++------
 2 files changed, 14 insertions(+), 10 deletions(-)

Index: BUILD-2.6/drivers/scsi/libsas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_discover.c	2007-07-17 11:15:48.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_discover.c	2007-07-17 11:26:47.000000000 -0500
@@ -304,9 +304,9 @@ static int sas_get_port_device(struct as
 	port->disc.max_level = 0;
 
 	dev->rphy = rphy;
-	spin_lock(&port->dev_list_lock);
+	spin_lock_irq(&port->dev_list_lock);
 	list_add_tail(&dev->dev_list_node, &port->dev_list);
-	spin_unlock(&port->dev_list_lock);
+	spin_unlock_irq(&port->dev_list_lock);
 
 	return 0;
 }
@@ -703,9 +703,9 @@ static void sas_discover_domain(struct w
 		sas_rphy_free(dev->rphy);
 		dev->rphy = NULL;
 
-		spin_lock(&port->dev_list_lock);
+		spin_lock_irq(&port->dev_list_lock);
 		list_del_init(&dev->dev_list_node);
-		spin_unlock(&port->dev_list_lock);
+		spin_unlock_irq(&port->dev_list_lock);
 
 		kfree(dev); /* not kobject_register-ed yet */
 		port->port_dev = NULL;
Index: BUILD-2.6/drivers/scsi/libsas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_expander.c	2007-07-17 11:15:48.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_expander.c	2007-07-17 11:28:33.000000000 -0500
@@ -677,9 +677,9 @@ static struct domain_device *sas_ex_disc
 
 		child->rphy = rphy;
 
-		spin_lock(&parent->port->dev_list_lock);
+		spin_lock_irq(&parent->port->dev_list_lock);
 		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
-		spin_unlock(&parent->port->dev_list_lock);
+		spin_unlock_irq(&parent->port->dev_list_lock);
 
 		res = sas_discover_sata(child);
 		if (res) {
@@ -701,9 +701,9 @@ static struct domain_device *sas_ex_disc
 		child->rphy = rphy;
 		sas_fill_in_rphy(child, rphy);
 
-		spin_lock(&parent->port->dev_list_lock);
+		spin_lock_irq(&parent->port->dev_list_lock);
 		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
-		spin_unlock(&parent->port->dev_list_lock);
+		spin_unlock_irq(&parent->port->dev_list_lock);
 
 		res = sas_discover_end_dev(child);
 		if (res) {
@@ -816,9 +816,9 @@ static struct domain_device *sas_ex_disc
 	sas_fill_in_rphy(child, rphy);
 	sas_rphy_add(rphy);
 
-	spin_lock(&parent->port->dev_list_lock);
+	spin_lock_irq(&parent->port->dev_list_lock);
 	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
-	spin_unlock(&parent->port->dev_list_lock);
+	spin_unlock_irq(&parent->port->dev_list_lock);
 
 	res = sas_discover_expander(child);
 	if (res) {


