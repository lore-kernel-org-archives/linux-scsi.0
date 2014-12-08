From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] libata: Whitelist SSDs that are known to properly
 return zeroes after TRIM
Date: Mon, 8 Dec 2014 10:15:59 -0500
Message-ID: <20141208151559.GB7001@thunk.org>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
 <1415336894-15327-2-git-send-email-martin.petersen@oracle.com>
 <94D0CD8314A33A4D9D801C0FE68B4029593FA1F3@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593FA1F3@G4W3202.americas.hpqcorp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 05, 2014 at 10:58:09PM +0000, Elliott, Robert (Server Storage) wrote:
> > I have a Crucial_CT256MX1 (i.e. MX100) and it does reliably zero.
> 
> make me concerned about this whitelist approach.
> 
> I think you need a manufacturer assertion that this is indeed
> the design intent; you cannot be certain based on observation
> from outside.

How is this different from a manufacturer assertion that they follow a
SCSI or ATA standard?  There have been cases in the distant past
(fortunately) of disk manufacturers that ignored a CACHE FLUSH command
just to get higher Winbench scores.  Does that mean we can't trust
them to do anything right?

What I'd suggest instead is that if a vendor states this on a spec
sheet --- more than just an e-mail assertion --- so they can be sued
if they knowingly misrepresent their product, that we take their word
at it.  Of course, there will be bugs, which is why we have
blacklists, or why we can remove them from the list if it turns out
there are edge conditions where it appears the disk doesn't quite do
the right thing.

After all, we generally take the manufacturer's word that air bags
will work as claimed, even if potentially 11 million of them are
currently subject to recall.  And do we think that "the community"
would necessarily be more suited than the vendors and the manufacturer
to figure out whether or not air bags or drives are working as
desired?

That being said, if someone wants to create a open source program
which stress tests SSD's to look for cases where it is dropping a
requested discard, that would certainly be a good thing to do...

Cheers,

						 - Ted
						 
