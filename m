From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] libfc: fix mem leak in fc_seq_assign()
Date: Tue, 19 Oct 2010 22:17:50 +0800
Message-ID: <AANLkTimLBm2z=nWb_Q3MsyzFo_r6omMMQKnZ9FD2rtwW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45705 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0JSORw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 10:17:52 -0400
Received: by wwe15 with SMTP id 15so41040wwe.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Oct 2010 07:17:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems exchs should get released in cases that FC_RJT_NONE is
returned, or they will no longer get freed.

It also looks a typo like the following,

-		    fc_seq_lookup_recip(lport, ema->mp, fp) != FC_RJT_NONE)
+		    fc_seq_lookup_recip(lport, ema->mp, fp) == FC_RJT_NONE)

but I am not sure.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_exch.c	2010-10-19 21:48:22.000000000 +0800
@@ -3,6 +3,9 @@
  * Copyright(c) 2008 Red Hat, Inc.  All rights reserved.
  * Copyright(c) 2008 Mike Christie
  *
+ * Copyright(c) Oct 19, 2010	Hillf Danton
+ *				minor fix of memory leakage
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
  * version 2, as published by the Free Software Foundation.
@@ -1246,9 +1249,16 @@ static struct fc_seq *fc_seq_assign(stru
 	fr_seq(fp) = NULL;

 	list_for_each_entry(ema, &lport->ema_list, ema_list)
-		if ((!ema->match || ema->match(fp)) &&
-		    fc_seq_lookup_recip(lport, ema->mp, fp) != FC_RJT_NONE)
-			break;
+		if (! ema->match || ema->match(fp))
+			if (fc_seq_lookup_recip(lport, ema->mp, fp) !=
+				FC_RJT_NONE)
+				break;
+			else {
+				struct fc_seq *seq = fr_seq(fp);
+				struct fc_exch *exch = fc_seq_exch(seq);
+				fc_exch_release(exch);
+			}
+
 	return fr_seq(fp);
 }
