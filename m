From: Jes Sorensen <jes@sgi.com>
Subject: [patch] qla1280 bus reset typo
Date: 17 Oct 2006 09:32:06 -0400
Message-ID: <yq0odsb9ig9.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:3222 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S1750929AbWJQNcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 09:32:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>, Jeremy Higdon <jeremy@sgi.com>

Hi,

This one falls in the 'must wear a brown paper bag when going out in
public' deparment. Please apply as soon as possible. The actual fix is
obfuscated inbetween the cleanup of the printk message to hide the
embarrassment.

Thanks,
Jes

Fix typo in check of return value of qla1280_bus_reset() which would
result in an adapter reset in addition to the bus reset.

Signed-off-by: Jes Sorensen <jes@sgi.com>

---
 drivers/scsi/qla1280.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c
+++ linux-2.6/drivers/scsi/qla1280.c
@@ -931,11 +931,10 @@ qla1280_error_action(struct scsi_cmnd *c
 
 	case BUS_RESET:
 		if (qla1280_verbose)
-			printk(KERN_INFO "qla1280(%ld:%d): Issuing BUS "
-			       "DEVICE RESET\n", ha->host_no, bus);
-		if (qla1280_bus_reset(ha, bus == 0))
+			printk(KERN_INFO "qla1280(%ld:%d): Issued bus "
+			       "reset.\n", ha->host_no, bus);
+		if (qla1280_bus_reset(ha, bus) == 0)
 			result = SUCCESS;
-
 		break;
 
 	case ADAPTER_RESET:
