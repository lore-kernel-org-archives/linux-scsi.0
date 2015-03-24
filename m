From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] [RESEND] aic7xxx: replace kmalloc/memset by kzalloc
Date: Tue, 24 Mar 2015 23:16:09 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A8416C5@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B40295930E577@G4W3296.americas.hpqcorp.net>
	 <1427041891-2694-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <550FB9BE.5010801@suse.de> <5511CD10.6040709@free-electrons.com>
 <1427230622.12126.13.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427230622.12126.13.camel@perches.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Hannes Reinecke <hare@suse.de>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, March 24, 2015 3:57 PM
> To: Michael Opdenacker
> Cc: Hannes Reinecke; JBottomley@parallels.com; Elliott, Robert (Server
> Storage); linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] [RESEND] aic7xxx: replace kmalloc/memset by kzalloc
> 
> On Tue, 2015-03-24 at 13:46 -0700, Michael Opdenacker wrote:
...
> > On 03/22/2015 11:59 PM, Hannes Reinecke wrote:
> > > On 03/22/2015 05:31 PM, Michael Opdenacker wrote:
> > >> This replaces kmalloc + memset by a call to kzalloc
> > >> (or kcalloc when appropriate, which zeroes memory too)
> > >>
...
> > I'm sending a version that reverts the use of kcalloc() instead of
> > kzalloc(). For reasons I don't understand, I didn't see the end of
> > Robert Elliott's comment that the use of kcalloc() could prevent the
> > compiler from detecting an overflow.
> 
> I'm confused.  I don't see that comment either, but
> the entire point of kcalloc is to prevent overflows
> by returning NULL when an overflow might occur.

It was a reply to the original post on 2014-10-16, not the resend
this month. 

>From http://permalink.gmane.org/gmane.linux.kernel/1808168:

kcalloc is helpful when one of the values is a variable that 
might cause the multiply to overflow during runtime.  Here, 
two constants are being multiplied together, which can
be done and checked by the compiler at compile time.  

Since kcalloc and kmalloc_array are both static inline 
functions:
static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
{
        if (size != 0 && n > SIZE_MAX / size)
                return NULL;
        return __kmalloc(n * size, flags);
}
static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
{
        return kmalloc_array(n, size, flags | __GFP_ZERO);
}

a compiler that detects an overflow will probably just reduce
that to an inlined "return NULL."
	
BUILD_BUG_ON could be used to trigger a compile-time error,
instead of building a kernel that returns a run-time error.
