From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] scsi-dh-emc: fix activate vs set_params race
Date: Tue, 2 Apr 2013 20:09:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304021954420.27554@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493Ab3DCAKP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Apr 2013 20:10:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Chandra Seetharaman <sekharan@us.ibm.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

Hi

This fixes a possible race in scsi_dh_emc. It is untested because I don't 
have the hardware. It could happen when we reload a multipath device and 
path failure happens at the same time.

This is a theoretical race condition (there are no reports of it 
hapenning), but a different bug was already triggered under the same 
conditions in QA testing.

Mikulas

---

scsi-dh-emc: fix activate vs set_params race

The activate routine may be called concurrently with the set_params
routine. This can happen when dm-multipath device is reloaded. When we
reload a device mapper device, the new target instance is being created
(that could call the set_params method) while the old target instance is
still active (that could call the activate method).

The activate and set_params routine share the same data and sense buffer,
so it could result in incorrect behaviour if they are called concurrently.
This patch adds a mutex to fix the race.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/scsi/device_handler/scsi_dh_emc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-3.9-rc5-fast/drivers/scsi/device_handler/scsi_dh_emc.c
===================================================================
--- linux-3.9-rc5-fast.orig/drivers/scsi/device_handler/scsi_dh_emc.c	2013-04-03 01:32:16.000000000 +0200
+++ linux-3.9-rc5-fast/drivers/scsi/device_handler/scsi_dh_emc.c	2013-04-03 01:45:13.000000000 +0200
@@ -111,6 +111,8 @@ struct clariion_dh_data {
 	 * path's mapped LUN
 	 */
 	int current_sp;
+
+	struct mutex mtx;
 };
 
 static inline struct clariion_dh_data
@@ -536,6 +538,8 @@ static int clariion_activate(struct scsi
 	struct clariion_dh_data *csdev = get_clariion_data(sdev);
 	int result;
 
+	mutex_lock(&csdev->mtx);
+
 	result = clariion_send_inquiry(sdev, csdev);
 	if (result != SCSI_DH_OK)
 		goto done;
@@ -562,6 +566,8 @@ done:
 		    csdev->port, lun_state[csdev->lun_state],
 		    csdev->default_sp + 'A');
 
+	mutex_unlock(&csdev->mtx);
+
 	if (fn)
 		fn(data, result);
 	return 0;
@@ -602,6 +608,8 @@ static int clariion_set_params(struct sc
 	else
 		csdev->flags &= ~CLARIION_HONOR_RESERVATIONS;
 
+	mutex_lock(&csdev->mtx);
+
 	/*
 	 * If this path is owned, we have to send a trespass command
 	 * with the new parameters. If not, simply return. Next trespass
@@ -618,6 +626,8 @@ static int clariion_set_params(struct sc
 	/* Update status */
 	result = clariion_send_inquiry(sdev, csdev);
 
+	mutex_unlock(&csdev->mtx);
+
 done:
 	return result;
 }
@@ -683,6 +693,7 @@ static int clariion_bus_attach(struct sc
 	h->lun_state = CLARIION_LUN_UNINITIALIZED;
 	h->default_sp = CLARIION_UNBOUND_LU;
 	h->current_sp = CLARIION_UNBOUND_LU;
+	mutex_init(&h->mtx);
 
 	err = clariion_std_inquiry(sdev, h);
 	if (err != SCSI_DH_OK)
