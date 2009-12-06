From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 3/4] scsi: megaraid_sas -  driver fixed the device update
 issue
Date: Sun, 6 Dec 2009 08:39:25 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C3B7EAC2CC@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3B7EAC2C7@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3B7EAC2C9@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:38741 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933831AbZLFPja convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Dec 2009 10:39:30 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3B7EAC2C9@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>

driver fixed the device update issue after get the AEN PD delete/ADD and LD add/delete from FW.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
megaraid_sas.c |  142 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2009-12-06 03:51:57.000000000 -0500
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2009-12-06 04:42:17.000000000 -0500
@@ -4068,6 +4068,7 @@ megasas_aen_polling(struct work_struct *
 	struct  Scsi_Host *host;
 	struct  scsi_device *sdev1;
 	u16     pd_index = 0;
+	u16	ld_index = 0;
 	int     i, j, doscan = 0;
 	u32 seq_num;
 	int error;
@@ -4083,8 +4084,124 @@ megasas_aen_polling(struct work_struct *
 
 		switch (instance->evt_detail->code) {
 		case MR_EVT_PD_INSERTED:
+			if (megasas_get_pd_list(instance) == 0) {
+			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
+				for (j = 0;
+				j < MEGASAS_MAX_DEV_PER_CHANNEL;
+				j++) {
+
+				pd_index =
+				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
+
+				sdev1 =
+				scsi_device_lookup(host, i, j, 0);
+
+				if (instance->pd_list[pd_index].driveState
+						== MR_PD_STATE_SYSTEM) {
+						if (!sdev1) {
+						scsi_add_device(host, i, j, 0);
+						}
+
+					if (sdev1)
+						scsi_device_put(sdev1);
+					}
+				}
+			}
+			}
+			doscan = 0;
+			break;
+
 		case MR_EVT_PD_REMOVED:
+			if (megasas_get_pd_list(instance) == 0) {
+			megasas_get_pd_list(instance);
+			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
+				for (j = 0;
+				j < MEGASAS_MAX_DEV_PER_CHANNEL;
+				j++) {
+
+				pd_index =
+				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
+
+				sdev1 =
+				scsi_device_lookup(host, i, j, 0);
+
+				if (instance->pd_list[pd_index].driveState
+					== MR_PD_STATE_SYSTEM) {
+					if (sdev1) {
+						scsi_device_put(sdev1);
+					}
+				} else {
+					if (sdev1) {
+						scsi_remove_device(sdev1);
+						scsi_device_put(sdev1);
+					}
+				}
+				}
+			}
+			}
+			doscan = 0;
+			break;
+
+		case MR_EVT_LD_OFFLINE:
+		case MR_EVT_LD_DELETED:
+			megasas_get_ld_list(instance);
+			for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
+				for (j = 0;
+				j < MEGASAS_MAX_DEV_PER_CHANNEL;
+				j++) {
+
+				ld_index =
+				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
+
+				sdev1 = scsi_device_lookup(host,
+					i + MEGASAS_MAX_LD_CHANNELS,
+					j,
+					0);
+
+				if (instance->ld_ids[ld_index] != 0xff) {
+					if (sdev1) {
+						scsi_device_put(sdev1);
+					}
+				} else {
+					if (sdev1) {
+						scsi_remove_device(sdev1);
+						scsi_device_put(sdev1);
+					}
+				}
+				}
+			}
+			doscan = 0;
+			break;
+		case MR_EVT_LD_CREATED:
+			megasas_get_ld_list(instance);
+			for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
+				for (j = 0;
+					j < MEGASAS_MAX_DEV_PER_CHANNEL;
+					j++) {
+					ld_index =
+					(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
+
+					sdev1 = scsi_device_lookup(host,
+						i+MEGASAS_MAX_LD_CHANNELS,
+						j, 0);
+
+					if (instance->ld_ids[ld_index] !=
+								0xff) {
+						if (!sdev1) {
+							scsi_add_device(host,
+								i + 2,
+								j, 0);
+						}
+					}
+					if (sdev1) {
+						scsi_device_put(sdev1);
+					}
+				}
+			}
+			doscan = 0;
+			break;
 		case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
+		case MR_EVT_FOREIGN_CFG_IMPORTED:
 			doscan = 1;
 			break;
 		default:
@@ -4119,6 +4236,31 @@ megasas_aen_polling(struct work_struct *
 				}
 			}
 		}
+
+		megasas_get_ld_list(instance);
+		for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
+			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
+				ld_index =
+				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
+
+				sdev1 = scsi_device_lookup(host,
+					i+MEGASAS_MAX_LD_CHANNELS, j, 0);
+				if (instance->ld_ids[ld_index] != 0xff) {
+					if (!sdev1) {
+						scsi_add_device(host,
+								i+2,
+								j, 0);
+					} else {
+						scsi_device_put(sdev1);
+					}
+				} else {
+					if (sdev1) {
+						scsi_remove_device(sdev1);
+						scsi_device_put(sdev1);
+					}
+				}
+			}
+		}
 	}
 
 	if ( instance->aen_cmd != NULL ) {
