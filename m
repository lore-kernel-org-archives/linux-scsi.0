From: Matthew Wilcox <willy@debian.org>
Subject: Some constants I don't understand in sym2
Date: Mon, 20 Sep 2004 21:25:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040920202535.GS642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:8173 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266837AbUITUZm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 16:25:42 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1C9UjA-0004dV-P4
	for linux-scsi@vger.kernel.org; Mon, 20 Sep 2004 21:25:36 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I'd like to convert sym2 over to using the same constants as the
rest of Linux SCSI.  I think this process has uncovered a bug, but
it may simply be history that I'm missing.  Here's one bit:

-#define        S_GOOD          (0x00)
-#define        S_CHECK_COND    (0x02)
[...]
+#define        S_GOOD          SAM_STAT_GOOD
+#define        S_CHECK_COND    SAM_STAT_CHECK_CONDITION
[...]
 #define        S_TERMINATED    (0x20)
-#define        S_QUEUE_FULL    (0x28)
+#define        S_QUEUE_FULL    SAM_STAT_TASK_SET_FULL
 #define        S_ILLEGAL       (0xff)

I don't know what S_TERMINATED should be.  There's
SAM_STAT_COMMAND_TERMINATED 0x22, marked as obsolete in SAM-3.  Was there
ever a TERMINATED that was 0x20, or is this simply a mistake?  This same
definition can also be found in drivers/scsi/sym53c8xx_defs.h (from
the same author).  aiclib.h thinks SCSI_STATUS_CMD_TERMINATED (0x22)
is obsolete in SAM-2 instead of SAM-3.

Other symbolic tags I haven't found Linux names for yet include:

 #define        M_ABORT_TAG     (0x0d)
 #define        M_CLEAR_QUEUE   (0x0e)
-#define        M_INIT_REC      (0x0f)
-#define        M_REL_REC       (0x10)
+#define        M_INIT_REC      INITIATE_RECOVERY
+#define        M_REL_REC       RELEASE_RECOVERY
 #define        M_TERMINATE     (0x11)
 #define        M_IGN_RESIDUE   (0x23)
 #define        M_IDENTIFY      (0x80)

Again, history lesson / pointers to specs appreciated (I have sam3r09,
spc3r15 and spi5r06 handy).

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
