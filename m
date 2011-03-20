From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] firmware/efi: export a routine to retrieve
 efi-variables by GUID
Date: Sat, 19 Mar 2011 20:13:27 -0500
Message-ID: <1300583607.12679.29.camel@mulgrave.site>
References: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
	 <20110318225016.GB15921@suse.de>
	 <AANLkTim+HB0GWzGiif=MvYHaiXMSLuVB6R0=UK3906xU@mail.gmail.com>
	 <20110319002246.GB14249@suse.de> <4D8403C3.6020300@intel.com>
	 <20110320001459.GA9237@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab1CTBNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2011 21:13:44 -0400
In-Reply-To: <20110320001459.GA9237@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <gregkh@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>

On Sat, 2011-03-19 at 17:14 -0700, Greg KH wrote:
> On Fri, Mar 18, 2011 at 06:15:47PM -0700, Dan Williams wrote:
> > On 3/18/2011 5:22 PM, Greg KH wrote:
> > >On Fri, Mar 18, 2011 at 04:10:10PM -0700, Dan Williams wrote:
> > >>>I needed all patches in linux-next _before_ the merge window opened to
> > >>>be able to accept it.
> > >>
> > >>Yes, I know, and as dmaengine maintainer I also hate being ambushed by
> > >>last minute patches, but now I am unfortunately one of those annoying
> > >>people on the other side of the coin.
> > >
> > >Then you should know better than to try to go around the well-known
> > >rules :)
> > 
> > Yes...
> > 
> > /me about to push his luck
> 
> <snip>
> 
> > As Jeff pointed out:
> > "It seemed like this was turning into another driver that would get
> > held outside the kernel until it's "perfect."  If that is the case,
> > Linus has also made it clear we should get drivers for high volume,
> > shipping hardware into the kernel, even if its staging, if the
> > alternative is to deny users the driver."
> 
> That's fine, _BUT_ you are trying to go around the rules for the merge
> window, which isn't acceptable.  Also note that your driver isn't
> self-contained, it needs this change at the least, right?  Any others?
> 
> > So yes, we are targeting that exception.  I'm up for taking the heat
> > directly if you want...  because the pull request will need to
> > backed up with justification.
> 
> No, sorry, I'll not take this for .40, all of my trees are merged with
> Linus now for .40 and I'll only be sending him bugfixes until the .41
> merge window opens up.
> 
> Remember, it's only a 3 month wait, you knew about this _WAY_ in
> advance, so it's not like this is something new, or out of the ordinary
> at all.  Because of that, I fail to see why this is somehow not
> expected.
> 
> On a personal note, I'm going to be very scarse for the next 3 weeks due
> to conferences and travel for spring break, so I physically don't have
> the time to do any more merges like this with Linus.

So, here's the deal:  You get this driver to a mergeable state, which
means all of the problems Christoph, others and I have outlined
completely fixed or well on the way to being in two months and I will
take it under the merge window exception for new drivers.  However, I
mean seriously cleaned up and shiny (and dumping tens of thousands of
lines of flue code and other oddities), not cleaned up for staging.
Further you're going to have to use standard methods to store and
retrieve data, not esoteric efi ones that rely on changes outside SCSI
(you aren't the first people to need to set a SAS address and other
things, so we have a request firmware like method for it).

If you can't make it in two months .. can you do it? I'll extend the
offer to the .40 which makes the cutoff around 5 months, if you need
extra time.

What I suggest is that you take about a month and a half to make all the
changes and then do a patch code drop on linux-scsi.  If you're less
sure about what you need to do, do one after three weeks and we'll redo
the assessment.

James


