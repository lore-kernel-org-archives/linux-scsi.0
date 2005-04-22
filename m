From: Matthew Wilcox <matthew@wil.cx>
Subject: Unused error handling code in sym2
Date: Fri, 22 Apr 2005 07:33:55 +0100
Message-ID: <20050422063355.GB31511@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63970 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261983AbVDVGdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 02:33:46 -0400
Received: from willy by parcelfarce.linux.theplanet.co.uk with local (Exim 4.43)
	id 1DOrjf-0003W7-Gx
	for linux-scsi@vger.kernel.org; Fri, 22 Apr 2005 07:33:55 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


No variable is ever set to SYM_EH_DO_COMPLETE:

$ grep SYM_EH_DO_COMPLETE drivers/scsi/sym53c8xx_2/*
drivers/scsi/sym53c8xx_2/sym_glue.c:#define SYM_EH_DO_COMPLETE  1
drivers/scsi/sym53c8xx_2/sym_glue.c:    case SYM_EH_DO_COMPLETE:
drivers/scsi/sym53c8xx_2/sym_glue.c:    if (to_do == SYM_EH_DO_COMPLETE)

Taking this out gets rid of a lot of then-unused code:

-#define SYM_EH_DO_COMPLETE     1
...
-
-/*
- *  scsi_done() alias when error recovery is in progress. 
- */
-static void sym_eh_done(struct scsi_cmnd *cmd) { __sym_eh_done(cmd, 0); }
...
-       case SYM_EH_DO_COMPLETE:
-               ep->old_done = cmd->scsi_done;
-               cmd->scsi_done = sym_eh_done;
-               SYM_UCMD_PTR(cmd)->eh_wait = ep;
...
-       /* Complete the command with locks held as required by the driver */
-       if (to_do == SYM_EH_DO_COMPLETE)
-               sym_xpt_done2(np, cmd, CAM_REQ_ABORTED);
-

I'm wondering if this is too lucky -- should SYM_EH_DO_COMPLETE be set at
some point?  I'm pretty unfamiliar with the error handling areas of scsi.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
