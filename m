From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 7/8] zfcp: remove access control tables interface (port leftovers)
Date: Wed, 21 Aug 2013 17:05:30 +0200
Message-ID: <1377097531-4942-8-git-send-email-maier@linux.vnet.ibm.com>
References: <1377097531-4942-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:42018 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3HUPHP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2013 11:07:15 -0400
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Wed, 21 Aug 2013 16:00:24 +0100
In-Reply-To: <1377097531-4942-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

This patch removes some leftovers for commit
663e0890e31cb85f0cca5ac1faaee0d2d52880b5
"[SCSI] zfcp: remove access control tables interface".

The "access denied" case for ports is gone, as well.
The corresponding flag was cleared, but never set.
So clean it up.

Sysfs flag is kept, though, for backward-compatibility.
Now it returns always 0.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c   |    7 -------
 drivers/s390/scsi/zfcp_fsf.c   |    3 +--
 drivers/s390/scsi/zfcp_sysfs.c |    4 +---
 3 files changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -821,11 +821,6 @@ static int zfcp_erp_port_forced_strategy
 	return ZFCP_ERP_CONTINUES;
 }
 
-static void zfcp_erp_port_strategy_clearstati(struct zfcp_port *port)
-{
-	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED, &port->status);
-}
-
 static int zfcp_erp_port_forced_strategy(struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_port *port = erp_action->port;
@@ -833,7 +828,6 @@ static int zfcp_erp_port_forced_strategy
 
 	switch (erp_action->step) {
 	case ZFCP_ERP_STEP_UNINITIALIZED:
-		zfcp_erp_port_strategy_clearstati(port);
 		if ((status & ZFCP_STATUS_PORT_PHYS_OPEN) &&
 		    (status & ZFCP_STATUS_COMMON_OPEN))
 			return zfcp_erp_port_forced_strategy_close(erp_action);
@@ -933,7 +927,6 @@ static int zfcp_erp_port_strategy(struct
 
 	switch (erp_action->step) {
 	case ZFCP_ERP_STEP_UNINITIALIZED:
-		zfcp_erp_port_strategy_clearstati(port);
 		if (p_status & ZFCP_STATUS_COMMON_OPEN)
 			return zfcp_erp_port_strategy_close(erp_action);
 		break;
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1396,8 +1396,7 @@ static void zfcp_fsf_open_port_handler(s
 		port->handle = header->port_handle;
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN |
 				ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
-		atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
-		                  ZFCP_STATUS_COMMON_ACCESS_BOXED,
+		atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_BOXED,
 		                  &port->status);
 		/* check whether D_ID has changed during open */
 		/*
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -73,9 +73,7 @@ ZFCP_DEFINE_ATTR(zfcp_port, port, status
 ZFCP_DEFINE_ATTR(zfcp_port, port, in_recovery, "%d\n",
 		 (atomic_read(&port->status) &
 		  ZFCP_STATUS_COMMON_ERP_INUSE) != 0);
-ZFCP_DEFINE_ATTR(zfcp_port, port, access_denied, "%d\n",
-		 (atomic_read(&port->status) &
-		  ZFCP_STATUS_COMMON_ACCESS_DENIED) != 0);
+ZFCP_DEFINE_ATTR_CONST(port, access_denied, "%d\n", 0);
 
 ZFCP_DEFINE_ATTR(zfcp_unit, unit, status, "0x%08x\n",
 		 zfcp_unit_sdev_status(unit));

