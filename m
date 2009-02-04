From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod]: Make RELATIVE TARGET PORT IDENTIFER
	assignment always non zero
Date: Tue, 03 Feb 2009 19:05:26 -0800
Message-ID: <1233716726.12375.144.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:27553 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751880AbZBDDGd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2009 22:06:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Greetings all,

This patch makes RELATIVE TARGET PORT IDENTIFER assignment always a non zero value.
This SCSI device unique 16-bit counter is allocated each time a new port is created,
and is unique within a SCSI device.

Using a zero value is defined as Reserved in spc4r17 section 7.7.3.8.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc2 x86 32-bit HVM.  The lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary


Signed-off-by: Nicholas A. Bellinger
---
 drivers/lio-core/target_core_device.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index ced583a..9f1503c 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -508,7 +508,21 @@ extern se_port_t *core_alloc_port (se_device_t *dev)
 		return(NULL);
 	}
 again:
-	port->sep_rtpi = dev->dev_rpti_counter++;
+	/*
+	 * Allocate the next RELATIVE TARGET PORT IDENTIFER for this se_device_t.
+	 * Here is the table from spc4r17 section 7.7.3.8.
+	 * 
+	 *    Table 473 -- RELATIVE TARGET PORT IDENTIFIER field
+	 *
+	 * Code      Description
+	 * 0h        Reserved
+	 * 1h        Relative port 1, historically known as port A
+	 * 2h        Relative port 2, historically known as port B
+	 * 3h to FFFFh    Relative port 3 through 65 535
+	 */
+	if (!(port->sep_rtpi = dev->dev_rpti_counter++))
+		goto again;
+
 	list_for_each_entry(port_tmp, &dev->dev_sep_list, sep_list) {
 		/*
 		 * Make sure RELATIVE TARGET PORT IDENTIFER is unique
-- 
1.5.4.1



