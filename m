From: Matthew Wilcox <willy@debian.org>
Subject: Re: sym53c8xx_2 version 2.1.18j domain validation failures (was Re: Sym53c8xx_2)
Date: Sun, 22 Aug 2004 02:01:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040822010123.GF9660@parcelfarce.linux.theplanet.co.uk>
References: <1092366037.28144.202254467@webmail.messagingengine.com> <Pine.LNX.4.60.0408132049060.4069@poirot.grange> <1092432298.18813.202307545@webmail.messagingengine.com> <Pine.LNX.4.60.0408150005570.5333@poirot.grange> <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local> <1092624889.15338.202386294@webmail.messagingengine.com> <41209D02.6010202@jound.net> <1092738272.28646.202482540@webmail.messagingengine.com> <4127D208.6010600@jound.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2989 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264954AbUHVBB2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 21:01:28 -0400
Content-Disposition: inline
In-Reply-To: <4127D208.6010600@jound.net>
List-Id: linux-scsi@vger.kernel.org
To: Lance Dryden <lance@jound.net>
Cc: Kai OM <epimetreus@fastmail.fm>, linux-scsi@vger.kernel.org

On Sat, Aug 21, 2004 at 06:51:52PM -0400, Lance Dryden wrote:
> What I have found is that only my Quantum Atlas disks seem to have the 
> problem with domain validation at boot-up.

Correct.  James managed to isolate the problem to the Atlas drives too.
Basically, the sym2 driver was trying to negotiate an invalid state.
Most drives recognised it was invalid and rejected it, but the Atlas drives
tried to obey it.  Here's the patch to fix the problem:

http://marc.theaimsgroup.com/?l=linux-scsi&m=109311381603239&w=2

The patch James mentions that it depends on is:

http://marc.theaimsgroup.com/?l=linux-scsi&m=109305341428550&w=2
(and maybe the followup supplemental patch)
http://marc.theaimsgroup.com/?l=linux-scsi&m=109306123627231&w=2

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
