From: Matthew Wilcox <matthew@wil.cx>
Subject: The future of host_scribble
Date: Thu, 21 Apr 2005 01:23:33 +0100
Message-ID: <20050421002333.GA8556@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:44503 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261860AbVDUAX1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 20:23:27 -0400
Received: from willy by parcelfarce.linux.theplanet.co.uk with local (Exim 4.43)
	id 1DOPTh-0006Xi-HD
	for linux-scsi@vger.kernel.org; Thu, 21 Apr 2005 01:23:33 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


In scsi_cmnd there's an element called host_scribble.  The name and the
comment by it were sufficiently confusing that I didn't realise that this
field is basically for the host's private data.  Any objections to something
like this, assuming I also submit a patch that converts all the drivers?

+++ include/scsi/scsi_cmnd.h    2005-04-20 20:16:41.562034944 -0400
@@ -129,13 +129,8 @@
         */
        struct scsi_pointer SCp;        /* Scratchpad used by some host adapters */
 
-       unsigned char *host_scribble;   /* The host adapter is allowed to
-                                          * call scsi_malloc and get some memory
-                                          * and hang it here.     The host adapter
-                                          * is also expected to call scsi_free
-                                          * to release this memory.  (The memory
-                                          * obtained by scsi_malloc is guaranteed
-                                          * to be at an address < 16Mb). */
+       void *host_data;        /* Pointer to the host's data structure
+                                * associated with this command. */
 
        int result;             /* Status code from lower level driver */
 
(the only remaining references to scsi_malloc are in comments ... I'll
submit a different patch to remove those too)

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
