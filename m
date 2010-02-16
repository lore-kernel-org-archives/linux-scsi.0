From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/9] libfcoe: Send port LKA every FIP_VN_KA_PERIOD secs.
Date: Tue, 16 Feb 2010 12:15:34 -0800
Message-ID: <20100216201534.26581.76389.stgit@localhost.localdomain>
References: <20100216201513.26581.83756.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53830 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0BPUPf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 15:15:35 -0500
In-Reply-To: <20100216201513.26581.83756.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Gollapudi <bprakash@broadcom.com>, Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

libfcoe module doesnt send port keep alive every
FIP_VN_KA_PERIOD due to improper assignment of timeout value.
Update the port_ka_time appropriately by incrementing it by
FIP_VN_KA_PERIOD in fcoe_ctlr_timeout(), so that the link_work
is scheduled to send the port LKA.

Signed-off-by: Bhanu Gollapudi <bprakash@broadcom.com>
Acked-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 9823291..511cb6b 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1187,7 +1187,7 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 			next_timer = fip->ctlr_ka_time;
 
 		if (time_after_eq(jiffies, fip->port_ka_time)) {
-			fip->port_ka_time += jiffies +
+			fip->port_ka_time = jiffies +
 				msecs_to_jiffies(FIP_VN_KA_PERIOD);
 			fip->send_port_ka = 1;
 		}

