From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH 2/3] scsi_dh_alua: Store the PREF bit from RTPG
Date: Tue, 27 Mar 2012 20:56:08 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B02C3EE@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:13240 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab2C0U4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2012 16:56:15 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "Qi, Yanling" <Yanling.Qi@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>

This patch stores the pref bit from rptg command. PREF bit indicates
preferred target port group for accessing a logical unit. This bit is used 
to optimize the STPG command handling. 

Signed-off-by: Babu Moger <babu.moger@netapp.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
--- linux-3.3-rc6/drivers/scsi/device_handler/scsi_dh_alua.c.orig	2012-03-27 14:19:33.000000000 -0500
+++ linux-3.3-rc6/drivers/scsi/device_handler/scsi_dh_alua.c	2012-03-27 14:28:04.000000000 -0500
@@ -63,6 +63,7 @@ struct alua_dh_data {
 	int			rel_port;
 	int			tpgs;
 	int			state;
+	int			pref;
 	unsigned		flags; /* used for optimizing STPG */
 	unsigned char		inq[ALUA_INQUIRY_SIZE];
 	unsigned char		*buff;
@@ -558,14 +559,16 @@ static int alua_rtpg(struct scsi_device
 	for (k = 4, ucp = h->buff + 4; k < len; k += off, ucp += off) {
 		if (h->group_id == (ucp[2] << 8) + ucp[3]) {
 			h->state = ucp[0] & 0x0f;
+			h->pref = ucp[0] >> 7;
 			valid_states = ucp[1];
 		}
 		off = 8 + (ucp[7] * 4);
 	}
 
 	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x state %c supports %c%c%c%c%c%c%c\n",
+		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
 		    ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
+		    h->pref ? "preferred" : "non-preferred",
 		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
 		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
 		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',


