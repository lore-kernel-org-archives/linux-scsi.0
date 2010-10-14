From: Dan Carpenter <error27@gmail.com>
Subject: [patch -next] scsi_transport_fc: remove unneeded check
Date: Thu, 14 Oct 2010 20:23:30 +0200
Message-ID: <20101014182330.GD6614@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52615 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab0JNSXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2010 14:23:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: James Smart <james.smart@emulex.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

"val" can never be less than zero here.  It's unsigned and
simple_strtoul() always returns positive values.

I also cleaned up the check.  "*cp != '\0'" is more explicit than "*cp"
and I removed some parenthesis that weren't needed.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I sent this patch some months back but didn't recieve any feedback.

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0681378..b108a9b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -844,7 +844,7 @@ store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
 	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
 		return -EBUSY;
 	val = simple_strtoul(buf, &cp, 0);
-	if ((*cp && (*cp != '\n')) || (val < 0))
+	if (*cp != '\0' && *cp != '\n')
 		return -EINVAL;
 
 	/*

