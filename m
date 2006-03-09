From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] scsi_transport_fc: fix FC_HOST_NUM_ATTRS
Date: Thu, 9 Mar 2006 16:37:49 +0100
Message-ID: <20060309153749.GA10170@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:51637 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750762AbWCIPjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 10:39:02 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id k29Fd17i124826
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 15:39:01 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k29FdNxe219610
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 16:39:23 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k29Fd0Lo020232
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 16:39:00 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

In the past I added an host attribute but unfortunately
I forgot to increase FC_HOST_NUM_ATTRS.
This is fixed with the patch. Otherwise an fibre channel
lld might run into
      BUG_ON(count > FC_HOST_NUM_ATTRS);
in fc_attach_transport().

Sorry about that.


Regards,

Andreas


scsi_transport_fc: fix FC_HOST_NUM_ATTRS

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/scsi/scsi_transport_fc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

a9b1dbac2ffd19d1360a96809d8fc6f5bc4ab738
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 929032e..13ea641 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -223,7 +223,7 @@ static void fc_rport_terminate(struct fc
  */
 #define FC_STARGET_NUM_ATTRS 	3
 #define FC_RPORT_NUM_ATTRS	9
-#define FC_HOST_NUM_ATTRS	16
+#define FC_HOST_NUM_ATTRS	17
 
 struct fc_internal {
 	struct scsi_transport_template t;
-- 
0.99.9n-g5a22
