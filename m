From: brking@us.ibm.com
Subject: [PATCH 04/15] ipr: Device remove cleanup
Date: Mon, 21 Feb 2005 15:08:50 -0600
Message-ID: <200502212108.j1LL8p15000487@d01av02.pok.ibm.com>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:25987 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262108AbVBUVIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:08:52 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL8qQv004509
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:52 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL8p0H242494
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:51 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL8pIr000514
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


If a device disappears across an adapter reset, ipr schedules the device to be
removed from scsi core. Any ops sent to that device prior to its actual removal
end up getting sent to the adapter using a now invalid adapter resource handle.
Usually, the adapter will just fail the command and the failure will end up
looking like a selection timeout, but it is possible the resource handle
has been re-used by the adapter and we could be sending an op to a different
device than we think we are. This patch closes this window.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_remove_sdev_oops drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_remove_sdev_oops	2005-02-21 13:11:07.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:11:07.000000000 -0600
@@ -4501,6 +4501,7 @@ static int ipr_init_res_table(struct ipr
 	list_for_each_entry_safe(res, temp, &old_res, queue) {
 		if (res->sdev) {
 			res->del_from_ml = 1;
+			res->sdev->hostdata = NULL;
 			list_move_tail(&res->queue, &ioa_cfg->used_res_q);
 		} else {
 			list_move_tail(&res->queue, &ioa_cfg->free_res_q);
_
