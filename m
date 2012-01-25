From: Josh Boyer <jwboyer@gmail.com>
Subject: Re: [v2] Re: [091/129] block: fail SCSI passthrough ioctls on
 partition devices
Date: Wed, 25 Jan 2012 18:10:47 -0500
Message-ID: <CA+5PVA601fTyuTc66nvY_9pZPE5i5DkBkKpyL3-i=q9OxkoT+g@mail.gmail.com>
References: <20120124023932.023409422@clark.kroah.org>
	<1327423431-13965-1-git-send-email-pbonzini@redhat.com>
	<20120125223937.GA12516@kroah.com>
	<alpine.DEB.2.02.1201252348520.22090@aurora.sdinet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1201252348520.22090@aurora.sdinet.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Greg KH <greg@kroah.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 25, 2012 at 5:51 PM, Sven-Haegar Koch <haegar@sdinet.de> wr=
ote:
> On Wed, 25 Jan 2012, Greg KH wrote:
>
>> On Tue, Jan 24, 2012 at 05:43:50PM +0100, Paolo Bonzini wrote:
>> > > You need to return -ENOTTY from scsi_verify_blk_ioctl and -ENOIO=
CTLCMD from
>> > > sd_compat_ioctl, because -ENOIOCTLCMD will not be handled correc=
tly by
>> > > block/ioctl.c. =A0This would break BLKROSET and BLKFLSBUF done b=
y non-root
>> > > but with the appropriate capabilities.
>> > >
>> > > Fixed patch follows. =A0If you prefer that I send an interdiff, =
let me know.
>>
>> Wait, why do you want the stable trees to diverge from what is in
>> Linus's tree with regards to the error codes being returned?
>>
>> That doesn't seem safe, or sane.
>>
>> So for now, I'm going to follow what is in Linus's tree. =A0If you
>> need/want the error codes to be different, then shouldn't it also be
>> done there as well?
>
> May be because the stable trees do not have
> 07d106d0a33d6063d2061305903deb02489eba20? "vfs: fix up ENOIOCTLCMD er=
ror
> handling"?

I believe that is the case, yes.  Linus was unhappy about ENOIOCTLCMD v=
s.
ENOTTY overall when the patch was first submitted, which lead to that c=
ommit.
The patches Paolo submitted for stable are the original versions that a=
pply
directly to 3.2 and older.

07d106d0a isn't really stable material as it was put into 3.3 to catch =
any odd
fallout from the change.

josh
