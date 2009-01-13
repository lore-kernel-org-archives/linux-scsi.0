From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Tue, 13 Jan 2009 08:44:30 -0500
Message-ID: <496C9ABE.8060300@garzik.org>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	 <20081229121423.efde9d06.akpm@linux-foundation.org>	 <495B8D90.1090004@panasas.com>	 <1230739053.3408.74.camel@localhost.localdomain>	 <4960D3CA.2000202@panasas.com>	 <1231783926.3256.29.camel@localhost.localdomain>	 <496B989F.7050907@garzik.org>	 <1231790190.15161.29.camel@localhost.localdomain>	 <496BA671.3070900@garzik.org> <1231802758.27151.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231802758.27151.18.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2009-01-12 at 15:22 -0500, Jeff Garzik wrote: 
>> If Seagate were to release a production OSD device, do you really think 
>> they would prefer a block-based filesystem hacked to work with OSDs?  I 
>> don't think so.
> 
> Um, speaking with my business hat on, I'd really beg to differ ... you
> don't release a product into an empty market.  you pick an existing one,
> or fill a fundamental need that a market nucleates around.  If that
> means block based filesystems hacked to work with OSDs, I think they'd
> take it, yes.

It seems unlikely drive manufacturers would get excited about a 
sub-optimal solution that does not even approach using the full 
potential of the product.

Plus, given the existence of an OSD-specific filesystem (exofs, at the 
very least), it seems unlikely that end users who own OSDs would choose 
the sub-optimal solution when an OSD-specific filesystem exists.


>>> Note that "providing benefit to" does not equate to "rewriting the
>>> filesystem for" ... and it shouldn't; the benefit really should be
>>> incremental.  And that's the crux of my criticism.  While OSD are
>>> separate things that we have to rewrite whole filesystems for, they're
>>> never going to set the world on fire.  If they could be used with only
>>> incremental effort, they might.  The bridge for the incremental effort
>>> will come from a properly designed kernel API.
>> Well, hey, if you wanna expend energy creating a kernel API that 
>> presents a complex OSD as simple block-based storage, go for it.  AFAICS 
>> it's just extra overhead and complexity when a new filesystem could do 
>> the job much better.
> 
> Because writing a new filesystem is so much easier?

Yes, easier -- both technically and politically -- than hacking XFS or 
ext4 to support two vastly different storage APIs (linear sector or 
object-based).

It might be a tad easier to hack btrfs to do objects.


>>>> * an in-kernel OSD-based filesystem needs some sort of generic in-kernel 
>>>> libosd API, so that multiple OSD filesystems do not reinvent the wheel 
>>>> each time.
>>>>
>>>> * OSD was bound to be annoying, because it forces the kernel filesystem 
>>>> to either (a) talk SCSI or (b) use messages that can be converted to 
>>>> SCSI OSD commands, like existing drivers convert the block layer's READ 
>>>> and WRITE to device-specific commands.
>>> OK, so what you're arguing is that unlike block devices where we can
>>> produce a useful generic abstraction that is protocol agnostic, for OSD
>>> we can't?  As I've said before, I think this might be true, but fear it
>>> dooms OSD to being too difficult to use.
>> No, a generic abstraction is "(b)" in my quoted paragraph.
>>
>> But it's certainly easy to create an OSD block device client, that 
>> simulates sector-based storage, if you are motivated in that direction.
>>
>> But that only makes sense if you want the extra overhead (square peg, 
>> round hole), which no sane person will want.  Face it, only screwballs 
>> want to mount ext4 on an OSD.
> 
> So what's your proposal for lowering the barrier to adoption then?

Once exofs is in upstream, installers can easily choose that when an OSD 
device is detected.


> Filesystems are complex and difficult beasts to get right.  Btrfs took a
> year to get to the point of kernel inclusion and will take some little
> time longer to get enterprises to the point of trusting data to it.  So
> if we say a two year lead time, that would mean that even if someone
> started a general purpose OSD based filesystem today, it wouldn't be
> ready for the consumer market until 2011.  That's not really going to
> convince the disk vendors that OSD based devices should be marketed
> today.

And you have a similar sales job and lag time, when hacking -- read 
destabilizing -- a filesystem to work with OSDs as well as sector-based 
devices.

	Jeff



