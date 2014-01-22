From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Date: Wed, 22 Jan 2014 09:21:40 -0800
Message-ID: <1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>
	 <20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com>
	 <20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com>
	 <20140122151913.GY4963@suse.de>
	 <1390410233.1198.7.camel@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1390410233.1198.7.camel@ret.masoncoding.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chris Mason <clm@fb.com>
Cc: "mgorman@suse.de" <mgorman@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-01-22 at 17:02 +0000, Chris Mason wrote:
> On Wed, 2014-01-22 at 15:19 +0000, Mel Gorman wrote:
> > On Wed, Jan 22, 2014 at 09:58:46AM -0500, Ric Wheeler wrote:
> > > On 01/22/2014 09:34 AM, Mel Gorman wrote:
> > > >On Wed, Jan 22, 2014 at 09:10:48AM -0500, Ric Wheeler wrote:
> > > >>On 01/22/2014 04:34 AM, Mel Gorman wrote:
> > > >>>On Tue, Jan 21, 2014 at 10:04:29PM -0500, Ric Wheeler wrote:
> > > >>>>One topic that has been lurking forever at the edges is the current
> > > >>>>4k limitation for file system block sizes. Some devices in
> > > >>>>production today and others coming soon have larger sectors and it
> > > >>>>would be interesting to see if it is time to poke at this topic
> > > >>>>again.
> > > >>>>
> > > >>>Large block support was proposed years ago by Christoph Lameter
> > > >>>(http://lwn.net/Articles/232757/). I think I was just getting started
> > > >>>in the community at the time so I do not recall any of the details. I do
> > > >>>believe it motivated an alternative by Nick Piggin called fsblock though
> > > >>>(http://lwn.net/Articles/321390/). At the very least it would be nice to
> > > >>>know why neither were never merged for those of us that were not around
> > > >>>at the time and who may not have the chance to dive through mailing list
> > > >>>archives between now and March.
> > > >>>
> > > >>>FWIW, I would expect that a show-stopper for any proposal is requiring
> > > >>>high-order allocations to succeed for the system to behave correctly.
> > > >>>
> > > >>I have a somewhat hazy memory of Andrew warning us that touching
> > > >>this code takes us into dark and scary places.
> > > >>
> > > >That is a light summary. As Andrew tends to reject patches with poor
> > > >documentation in case we forget the details in 6 months, I'm going to guess
> > > >that he does not remember the details of a discussion from 7ish years ago.
> > > >This is where Andrew swoops in with a dazzling display of his eidetic
> > > >memory just to prove me wrong.
> > > >
> > > >Ric, are there any storage vendor that is pushing for this right now?
> > > >Is someone working on this right now or planning to? If they are, have they
> > > >looked into the history of fsblock (Nick) and large block support (Christoph)
> > > >to see if they are candidates for forward porting or reimplementation?
> > > >I ask because without that person there is a risk that the discussion
> > > >will go as follows
> > > >
> > > >Topic leader: Does anyone have an objection to supporting larger block
> > > >	sizes than the page size?
> > > >Room: Send patches and we'll talk.
> > > >
> > > 
> > > I will have to see if I can get a storage vendor to make a public
> > > statement, but there are vendors hoping to see this land in Linux in
> > > the next few years.
> > 
> > What about the second and third questions -- is someone working on this
> > right now or planning to? Have they looked into the history of fsblock
> > (Nick) and large block support (Christoph) to see if they are candidates
> > for forward porting or reimplementation?
> 
> I really think that if we want to make progress on this one, we need
> code and someone that owns it.  Nick's work was impressive, but it was
> mostly there for getting rid of buffer heads.  If we have a device that
> needs it and someone working to enable that device, we'll go forward
> much faster.

Do we even need to do that (eliminate buffer heads)?  We cope with 4k
sector only devices just fine today because the bh mechanisms now
operate on top of the page cache and can do the RMW necessary to update
a bh in the page cache itself which allows us to do only 4k chunked
writes, so we could keep the bh system and just alter the granularity of
the page cache.

The other question is if the drive does RMW between 4k and whatever its
physical sector size, do we need to do anything to take advantage of
it ... as in what would altering the granularity of the page cache buy
us?

James


