From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix sim710 section mismatch warnings
Date: Tue, 21 Jun 2011 13:14:32 -0700
Message-ID: <20110621131432.c1679799.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:63103 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1FUUQC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2011 16:16:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <jbottomley@parallels.com>, samr <sam@ravnborg.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warnings:

WARNING: drivers/scsi/sim710.o(.data+0x24): Section mismatch in reference from the variable sim710_mca_driver to the function .init.text:sim710_mca_probe()
WARNING: drivers/scsi/sim710.o(.data+0x60): Section mismatch in reference from the variable sim710_eisa_driver to the function .init.text:sim710_eisa_probe()

although it does now generate this unwanted warning:
drivers/scsi/sim710.c:268: warning: 'noinline' attribute ignored
drivers/scsi/sim710.c:328: warning: 'noinline' attribute ignored

Am I using the wrong marker here?

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/sim710.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-30-rc4.orig/drivers/scsi/sim710.c
+++ lnx-30-rc4/drivers/scsi/sim710.c
@@ -265,7 +265,7 @@ sim710_mca_probe(struct device *dev)
 				   0, id_array[slot]);
 }
 
-static struct mca_driver sim710_mca_driver = {
+static struct mca_driver sim710_mca_driver __init_refok = {
 	.id_table		= sim710_mca_id_table,
 	.driver = {
 		.name		= "sim710",
@@ -325,7 +325,7 @@ sim710_eisa_probe(struct device *dev)
 				   differential, scsi_id);
 }
 
-static struct eisa_driver sim710_eisa_driver = {
+static struct eisa_driver sim710_eisa_driver __init_refok = {
 	.id_table		= sim710_eisa_ids,
 	.driver = {
 		.name		= "sim710",
---
