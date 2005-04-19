From: Matthew Wilcox <matthew@wil.cx>
Subject: streamlining the sym2 io submission path
Date: Wed, 20 Apr 2005 00:43:23 +0100
Message-ID: <20050419234323.GA31352@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10125 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261254AbVDSXnS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 19:43:18 -0400
Received: from willy by parcelfarce.linux.theplanet.co.uk with local (Exim 4.43)
	id 1DO2NH-0000vj-V4
	for linux-scsi@vger.kernel.org; Wed, 20 Apr 2005 00:43:23 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I've been looking at speeding up sym2's queuecommand method.  In my
current development tree, I've removed most of sym_queue_command()
and inlined the remains into sym53c8xx_queuecommand().  There's some
funny stuff I wouldn't mind some advice with:

We fail the first command to the device if the device is marked as
NOSCAN or the lun is non-0 and the device isn't marked as SCAN LUNS.
I think the first part should be moved to slave_alloc(); it's a little
weird, but supportable.  The second part troubles me a little -- is the
blacklist in the midlayer good enough to handle this, or should I leave
this mechanism in?

The driver currently fails commands sent to the lun of the host adapter.
Is this the correct behaviour?  What should the driver do?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
