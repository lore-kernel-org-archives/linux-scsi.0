From: Matthew Wilcox <matthew@wil.cx>
Subject: request sense
Date: Thu, 24 Feb 2005 23:19:01 +0000
Message-ID: <20050224231901.GT28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2250 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262552AbVBXXTG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 18:19:06 -0500
Received: from willy by parcelfarce.linux.theplanet.co.uk with local (Exim 4.33)
	id 1D4SG5-00086M-IU
	for linux-scsi@vger.kernel.org; Thu, 24 Feb 2005 23:19:01 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Found a funny in the sym2 driver I'm not sure how to resolve:

                cp->sensecmd[0]         = REQUEST_SENSE;
                cp->sensecmd[1]         = 0;
                if (tp->tinfo.curr.scsi_version <= 2 && cp->lun <= 7)
                        cp->sensecmd[1] = cp->lun << 5;

Thing is, we don't set scsi_version anywhere, so I'm sure sym2 currently
does The Wrong Thing for SCSI-2 drives.  Pulling up the (draft) specs,
this does seem to be something that changed between SCSI-2 and SPC3r15.
Polling some of the other scsi drivers for a solution:

3w-9xxx		Never fills in LUN
53c700		Always fills in LUN
BusLogic	Doesn't send REQUEST_SENSE
aic7xxx		Same as sym2 (except it sets its equivalent of scsi_version)
dc395x		Always fills in LUN
gdth		Doesn't send REQUEST_SENSE
ipr		Never fills in LUN
ips		Doesn't send REQUEST_SENSE
ncr53c8xx	Doesn't send REQUEST_SENSE
qla1280		Doesn't send REQUEST_SENSE
sym53c416	Doesn't send REQUEST_SENSE
tmscsim		Always fills in LUN

In other words, the only driver I've found that gets this *right* is
aic7xxx (and 79xx).  Even scsi_error.c doesn't fill in the LUN.  What's
going on here?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
