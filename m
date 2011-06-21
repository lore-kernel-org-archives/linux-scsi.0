From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix NCR_Q720 section mismatch warning
Date: Tue, 21 Jun 2011 13:14:27 -0700
Message-ID: <20110621131427.a76d21a6.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:61601 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1FUUPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2011 16:15:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <jbottomley@parallels.com>, samr <sam@ravnborg.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: drivers/scsi/NCR_Q720_mod.o(.data+0x24): Section mismatch in reference from the variable NCR_Q720_driver to the function .init.text:NCR_Q720_probe()
The variable NCR_Q720_driver references
the function __init NCR_Q720_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

although it now generates this warning:
drivers/scsi/NCR_Q720.c:348: warning: 'noinline' attribute ignored

Am I using the wrong marker here?

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/NCR_Q720.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-30-rc4.orig/drivers/scsi/NCR_Q720.c
+++ lnx-30-rc4/drivers/scsi/NCR_Q720.c
@@ -345,7 +345,7 @@ NCR_Q720_remove(struct device *dev)
 
 static short NCR_Q720_id_table[] = { NCR_Q720_MCA_ID, 0 };
 
-static struct mca_driver NCR_Q720_driver = {
+static struct mca_driver NCR_Q720_driver __init_refok = {
 	.id_table = NCR_Q720_id_table,
 	.driver = {
 		.name		= "NCR_Q720",
