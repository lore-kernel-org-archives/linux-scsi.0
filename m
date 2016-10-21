From: Chris Leech <cleech@redhat.com>
Subject: [PATCH 1/1] libfc: don't have fc_exch_find log errors on a new exchange
Date: Fri, 21 Oct 2016 14:10:53 -0700
Message-ID: <1477084253-1742-1-git-send-email-cleech@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932989AbcJUVLC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Oct 2016 17:11:02 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 577E36330D
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2016 21:11:02 +0000 (UTC)
Received: from straylight.hirudinean.org.com (ovpn-116-10.phx2.redhat.com [10.3.116.10])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9LLB1Sk018579
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2016 17:11:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

With the error message I added in "libfc: sanity check cpu number
extracted from xid" I didn't account for the fact that fc_exch_find is
called with FC_XID_UNKNOWN at the start of a new exchange if we are the
responder.

It doesn't come up with the initiator much, but that's basically every
exchange for a target.  By checking the xid for FC_XID_UNKNOWN first, we
not only prevent the erroneous error message, but skip the unnecessary
lookup attempt as well.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/libfc/fc_exch.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 16ca31a..42cc403 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -910,6 +910,9 @@ static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
 	struct fc_exch *ep = NULL;
 	u16 cpu = xid & fc_cpu_mask;
 
+	if (xid == FC_XID_UNKNOWN)
+		return NULL;
+
 	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
 		printk_ratelimited(KERN_ERR
 			"libfc: lookup request for XID = %d, "
-- 
2.7.4

