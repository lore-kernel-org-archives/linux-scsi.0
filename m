From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/18] [PATCH] zfcp: Simplify latency lock handling
Date: Mon, 02 Mar 2009 13:08:57 +0100
Message-ID: <20090302121002.549246000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:63513 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZCBMKt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:49 -0500
Content-Disposition: inline; filename=703-zfcp-lat-lock.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The lock only needs to protect the softirq context called from qdio
against the userspace context called from sysfs. spin_lock and
spin_lock_bh is enough.

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c   |    5 ++---
 drivers/s390/scsi/zfcp_sysfs.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:30.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:30.000000000 +0100
@@ -2069,7 +2069,6 @@ static void zfcp_fsf_req_latency(struct 
 	struct fsf_qual_latency_info *lat_inf;
 	struct latency_cont *lat;
 	struct zfcp_unit *unit = req->unit;
-	unsigned long flags;
 
 	lat_inf = &req->qtcb->prefix.prot_status_qual.latency_info;
 
@@ -2087,11 +2086,11 @@ static void zfcp_fsf_req_latency(struct 
 		return;
 	}
 
-	spin_lock_irqsave(&unit->latencies.lock, flags);
+	spin_lock(&unit->latencies.lock);
 	zfcp_fsf_update_lat(&lat->channel, lat_inf->channel_lat);
 	zfcp_fsf_update_lat(&lat->fabric, lat_inf->fabric_lat);
 	lat->counter++;
-	spin_unlock_irqrestore(&unit->latencies.lock, flags);
+	spin_unlock(&unit->latencies.lock);
 }
 
 #ifdef CONFIG_BLK_DEV_IO_TRACE
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2009-03-01 16:41:30.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2009-03-01 16:41:30.000000000 +0100
@@ -318,10 +318,9 @@ zfcp_sysfs_unit_##_name##_latency_show(s
 	struct zfcp_unit *unit = sdev->hostdata;			\
 	struct zfcp_latencies *lat = &unit->latencies;			\
 	struct zfcp_adapter *adapter = unit->port->adapter;		\
-	unsigned long flags;						\
 	unsigned long long fsum, fmin, fmax, csum, cmin, cmax, cc;	\
 									\
-	spin_lock_irqsave(&lat->lock, flags);				\
+	spin_lock_bh(&lat->lock);					\
 	fsum = lat->_name.fabric.sum * adapter->timer_ticks;		\
 	fmin = lat->_name.fabric.min * adapter->timer_ticks;		\
 	fmax = lat->_name.fabric.max * adapter->timer_ticks;		\
@@ -329,7 +328,7 @@ zfcp_sysfs_unit_##_name##_latency_show(s
 	cmin = lat->_name.channel.min * adapter->timer_ticks;		\
 	cmax = lat->_name.channel.max * adapter->timer_ticks;		\
 	cc  = lat->_name.counter;					\
-	spin_unlock_irqrestore(&lat->lock, flags);			\
+	spin_unlock_bh(&lat->lock);					\
 									\
 	do_div(fsum, 1000);						\
 	do_div(fmin, 1000);						\

