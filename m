From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] SCSI: fix racing operations in fc_remote_port_add()
Date: Sat, 25 Sep 2010 22:20:42 +0800
Message-ID: <AANLkTi=ecOXEcQgq=OD4x9Rr+QWMmhpPLXMBsNZdiFCa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42887 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0IYOUu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Sep 2010 10:20:50 -0400
Received: by wwj40 with SMTP id 40so14587wwj.1
        for <linux-scsi@vger.kernel.org>; Sat, 25 Sep 2010 07:20:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.>

After its state is changed from FC_PORTSTATE_BLOCKED to FC_PORTSTATE_ONLINE,
operations on rport that was scsi target_id but is not shown by new
role seem racing with
the operations in the dev_loss_work of rport.
And new rport should be created for the sake of adding rport.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- o/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-25
22:25:12.000000000 +0800
@@ -2672,7 +2672,17 @@ fc_remote_port_add(struct Scsi_Host *sho
 			}

 			if (match) {
-
+				if (rport->scsi_target_id != -1 &&
+				    !(ids->roles & FC_PORT_ROLE_FCP_TARGET)) {
+					/*
+					 * rport will be torn down by timer,
+					 * and we have to create it.
+					 */
+					spin_unlock_irqrestore(
+						shost->host_lock, flags);
+					return fc_rport_create(shost,
+								channel, ids);
+				}
 				memcpy(&rport->node_name, &ids->node_name,
 					sizeof(rport->node_name));
 				memcpy(&rport->port_name, &ids->port_name,
@@ -2781,6 +2791,11 @@ fc_remote_port_add(struct Scsi_Host *sho
 		}

 		if (match) {
+			if (!(ids->roles & FC_PORT_ROLE_FCP_TARGET)) {
+				spin_unlock_irqrestore(shost->host_lock,
+							flags);
+				return fc_rport_create(shost, channel, ids);
+			}
 			memcpy(&rport->node_name, &ids->node_name,
 				sizeof(rport->node_name));
 			memcpy(&rport->port_name, &ids->port_name,
