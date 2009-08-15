From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
Date: Sat, 15 Aug 2009 08:55:17 -0500
Message-ID: <1250344518.4159.4.camel@mulgrave.site>
References: <200908122007.43522.ngupta@vflare.org>
	 <20090813151312.GA13559@linux.intel.com>
	 <20090813162621.GB1915@phenom2.trippelsdorf.de>
	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
	 <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>
	 <4A85E0DC.9040101@rtr.ca>
	 <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>
	 <20090814234539.GE27148@parisc-linux.org>
	 <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>
	 <1250341176.4159.2.camel@mulgrave.site>  <4A86B69C.7090001@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754551AbZHONza@vger.kernel.org>
In-Reply-To: <4A86B69C.7090001@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>, Bryan Donlan <bdonlan@gmail.com>, david@lang.hm, Greg Freemyer <greg.freemyer@gmail.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Matthew Wilcox <willy@linux.intel.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>, Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2009-08-15 at 09:22 -0400, Mark Lord wrote:
> James Bottomley wrote:
> >
> > This means you have to drain the outstanding NCQ commands (stalling the
> > device) before you can send a TRIM.   If we do this for every discard,
> > the performance impact will be pretty devastating, hence the need to
> > coalesce.  It's nothing really to do with device characteristics, it's
> > an ATA protocol problem.
> ..
> 
> I don't think that's really much of an issue -- we already have to do
> that for cache-flushes whenever barriers are enabled.  Yes it costs,
> but not too much.

That's not really what the enterprise is saying about flush barriers.
True, not all the performance problems are NCQ queue drain, but for a
steady workload they are significant.

James
