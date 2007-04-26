From: akpm@linux-foundation.org
Subject: [patch 01/30] aacraid: 2.6.21-rc6-mm1 aacraid not finding device
Date: Thu, 26 Apr 2007 00:35:07 -0700
Message-ID: <200704260735.l3Q7Z7Ol024206@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933187AbXDZHfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 03:35:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, mark_salyzyn@adaptec.com, aacraid@adaptec.com

From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

Thanks for the help from Steve Fox and Duane Cox investigating this
issue, I'd like to report that we found the problem. The issue is with
the patch Steve Fox isolated below, by not accommodating older adapters
properly and issuing a command they do not support when retrieving
storage parameters about the arrays. This simple patch resolves the
problem (and more accurately mimics the logic of the original code
before the patch).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aachba.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/aachba.c~aacraid-2621-rc6-mm1-aacraid-not-finding-device drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~aacraid-2621-rc6-mm1-aacraid-not-finding-device
+++ a/drivers/scsi/aacraid/aachba.c
@@ -503,8 +503,7 @@ static int _aac_probe_container1(void * 
 	dresp = (struct aac_mount *) fib_data(fibptr);
 	dresp->mnt[0].capacityhigh = 0;
 	if ((le32_to_cpu(dresp->status) != ST_OK) ||
-	    ((le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
-	     (le32_to_cpu(dresp->mnt[0].state) == FSCS_HIDDEN)))
+	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE))
 		return _aac_probe_container2(context, fibptr);
 	scsicmd = (struct scsi_cmnd *) context;
 	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
_
