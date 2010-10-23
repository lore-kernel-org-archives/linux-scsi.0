From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] libfc: fix mem leak in fc_seq_assign()
Date: Sat, 23 Oct 2010 14:58:31 +0800
Message-ID: <AANLkTim7DsdaeXA=OUkDHiXZLJyBsNaAr9Jo_ixNtOYM@mail.gmail.com>
References: <AANLkTimLBm2z=nWb_Q3MsyzFo_r6omMMQKnZ9FD2rtwW@mail.gmail.com>
	<4CBDD579.2010101@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55071 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JWG6d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Oct 2010 02:58:33 -0400
Received: by wyf28 with SMTP id 28so1644563wyf.19
        for <linux-scsi@vger.kernel.org>; Fri, 22 Oct 2010 23:58:31 -0700 (PDT)
In-Reply-To: <4CBDD579.2010101@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

There is a typo cleaned, which triggers memory leakage.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_exch.c	2010-10-23 15:00:08.000000000 +0800
@@ -3,6 +3,9 @@
  * Copyright(c) 2008 Red Hat, Inc.  All rights reserved.
  * Copyright(c) 2008 Mike Christie
  *
+ * Oct 23 2010		Hillf Danton
+ *			minor fix of memory leakage
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
  * version 2, as published by the Free Software Foundation.
@@ -1247,7 +1250,7 @@ static struct fc_seq *fc_seq_assign(stru

 	list_for_each_entry(ema, &lport->ema_list, ema_list)
 		if ((!ema->match || ema->match(fp)) &&
-		    fc_seq_lookup_recip(lport, ema->mp, fp) != FC_RJT_NONE)
+		    fc_seq_lookup_recip(lport, ema->mp, fp) == FC_RJT_NONE)
 			break;
 	return fr_seq(fp);
 }
