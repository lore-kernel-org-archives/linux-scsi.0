From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH, 2.6] tmscsim - prevent Oops
Date: Thu, 29 Jan 2004 21:52:00 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401292147001.5173-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:43690 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S266365AbUA2Uwn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 15:52:43 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kurt Garloff <kurt@garloff.de>

Hi

Not sure, if correct semantically, but without this one gets a guaranteed
Oops in dc390_BuildSRB. Yes, it shouldn't happen. No, it never happened to
me:-)

Guennadi
---
Guennadi Liakhovetski

--- linux-2.6.2-rc1/drivers/scsi/tmscsim.c~	Sat Nov 29 22:28:04 2003
+++ linux-2.6.2-rc1/drivers/scsi/tmscsim.c	Thu Jan 29 21:45:15 2004
@@ -1099,6 +1099,7 @@
 		DC390_UNLOCK_ACB_NI;
 		pcmd->done (pcmd);
 		DC390_LOCK_ACB_NI;
+		return;
 	}
 	dc390_BuildSRB (pcmd, pDCB, pSRB);
 	dc390_Waiting_append ( pDCB, pSRB );


