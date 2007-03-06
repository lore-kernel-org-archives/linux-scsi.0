From: akpm@linux-foundation.org
Subject: [patch 29/29] bug in gdth.c crashing machine
Date: Tue, 06 Mar 2007 02:46:54 -0800
Message-ID: <200703061046.l26AksTi020093@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35061 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964831AbXCFKsc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2007 05:48:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, joerg@dorchain.net, Achim_Leubner@adaptec.com, stable@kernel.org

From: Joerg Dorchain <joerg@dorchain.net>

Undocumented...

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>
Acked-by: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: <stable@kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/gdth.c~bug-in-gdthc-crashing-machine drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~bug-in-gdthc-crashing-machine
+++ a/drivers/scsi/gdth.c
@@ -3091,6 +3091,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw64.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw64.cmd,scp->cmnd,16);
+            cmdp->u.raw64.sg_ranz    = 0;
         } else {
             cmdp->u.raw.reserved   = 0;
             cmdp->u.raw.mdisc_time = 0;
@@ -3107,6 +3108,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw.cmd,scp->cmnd,12);
+            cmdp->u.raw.sg_ranz    = 0;
         }
 
         if (scp->use_sg) {
_
