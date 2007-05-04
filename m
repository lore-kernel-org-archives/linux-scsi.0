From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Fix ipr ata_do_eh API compile warning
Date: Fri, 04 May 2007 17:11:52 -0500
Message-ID: <37199.8143535622$1178316755@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:47424 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031510AbXEDWL4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2007 18:11:56 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l44MBuBi013121
	for <linux-scsi@vger.kernel.org>; Fri, 4 May 2007 18:11:56 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l44MBt1h185474
	for <linux-scsi@vger.kernel.org>; Fri, 4 May 2007 16:11:55 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l44MBsR3019705
	for <linux-scsi@vger.kernel.org>; Fri, 4 May 2007 16:11:55 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, akpm@linux-foundation.org, htejun@gmail.com, jgarzik@pobox.com, brking@linux.vnet.ibm.com


This patch fixes the following compile warning:

drivers/scsi/ipr.c: In function '__ipr_eh_dev_reset':
drivers/scsi/ipr.c:3955: warning: passing argument 4 of 'ata_do_eh' from incompatible pointer type

This patch reverts the following commit, which looks to have been pushed
before the ata_do_eh API change got pushed.

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=120bda35ff8514c937dac6d4e5c7dc6c01c699ac;hp=771b8dad9653d2659e0ffcc237184cb16c317788

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_ata_do_eh_fix drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_ata_do_eh_fix	2007-05-04 15:13:08.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-05-04 17:07:34.000000000 -0500
@@ -3857,8 +3857,7 @@ static int ipr_device_reset(struct ipr_i
  * Return value:
  *	0 on success / non-zero on failure
  **/
-static int ipr_sata_reset(struct ata_port *ap, unsigned int *classes,
-				unsigned long deadline)
+static int ipr_sata_reset(struct ata_port *ap, unsigned int *classes)
 {
 	struct ipr_sata_port *sata_port = ap->private_data;
 	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
_
