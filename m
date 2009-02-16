From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: pNFS rant (was Re: [PATCH 1/8] exofs: Kbuild, Headers and osd
	utils)
Date: Mon, 16 Feb 2009 09:50:01 -0600
Message-ID: <1234799401.3237.16.camel@localhost.localdomain>
References: <1234185129-31858-1-git-send-email-bharrosh@panasas.com>
	 <20090216131806X.fujita.tomonori@lab.ntt.co.jp>
	 <499928A3.60507@panasas.com>
	 <20090216180028C.fujita.tomonori@lab.ntt.co.jp>
	 <49992F99.1060404@panasas.com> <49993182.3010707@garzik.org>
	 <49993DAD.40407@panasas.com>  <49994860.9060109@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51358 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbZBPPuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2009 10:50:08 -0500
In-Reply-To: <49994860.9060109@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, avishay@gmail.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Mon, 2009-02-16 at 06:05 -0500, Jeff Garzik wrote:
> Boaz Harrosh wrote:
> > No can do. exofs is meant to be a reference implementation of a pNFS-objects
> > file serving system. Have you read the spec of pNFS-objects layout? they define
> > RAID 0, 1, 5, and 6. In pNFS the MDS is suppose to be able to write the data
> > for its clients as NFS, so it needs to have all the infra structure and knowledge
> > of an Client pNFS-object layout drive.
> 
> Yes, I have studied pNFS!  I plan to add v4.1 and pNFS support to my NFS 
> server, once v4.0 support is working well.
> 
> 
> pNFS The Theory:   is wise and necessary:  permit clients to directly 
> connect to data storage, rather than copying through the metadata 
> server(s).  This is what every distributed filesystem is doing these 
> days -- direct to data server for bulk data read/write.
> 
> pNFS The Specification:   is an utter piece of shit.  I can only presume 
> some shady backroom deal in a smoke-filled room was the reason this saw 
> the light of day.
> 
> 
> In a sane world, NFS clients would speak... NFS.
> 
> In the crazy world of pNFS, NFS clients are now forced to speak NFS, 
> SCSI, RAID, and any number of proprietary layout types.  When will HTTP 
> be added to the list?  :)

Heh, it's one of the endearing faults of the storage industry that we
never learn from our mistakes ... particularly in storage protocols.

Actually, perhaps that's a mischaracterised: we never actually learn
from our successes.  For example, most popular storage protocols solve
about 80% of the problem (NFSv2) get something bolted on to take that to
95% (locking) and rule for decades.  We end up obsessing about the 5%
and produce something that's like 10x the overhead to solve it.
Customers, for some unfathomable reason, hate complexity  (I suspect
principally because it in some measure equals expense) so the 100%
solution (which actually turns out to be a 95% one because the over
engineered complexity adds another 5% of different problems that take
years to find) tends to work its way into a niche and stay there ...
eventually fading.

If you're really lucky, the niche evolves into something sustainable.
For example iSCSI: blew its early promise, pulled a bunch of unnecessary
networking into the protocol and ended up too big to fit in disk
firmware (thus destroying the ability to have a simple network tap to
replace storage fabric).  It's been slowly fading until Virtualisation
came along.  Now all the other solutions to getting storage into virtual
machines are so horrible and arcane that iSCSI looks like a winner (if
the alternative is Frankenstein's monster, Grendel's mother suddenly
looks more attractive as a partner).

So, trust the customer ... if it's so horrible it shouldn't have seen
the light of day, the chances are that no-one will buy it anyway.

James


