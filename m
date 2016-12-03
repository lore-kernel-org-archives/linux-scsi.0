From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: scsi: use-after-free in bio_copy_from_iter
Date: Sat, 3 Dec 2016 19:19:50 +0100
Message-ID: <20161203181948.GA3322@linux-x5ow.site>
References: <CACT4Y+aBd+1pssnsVx2x145n7Q1nDMU=xc7NAiOCtpy-MA-EDg@mail.gmail.com>
 <CACT4Y+auCpJbXhmxbr4OmSHbiVkatyWmDxGGShs=WvO=HCXRKA@mail.gmail.com>
 <20161203103802.dmvqzzquthwa7kd7@linux-x5ow.site>
 <CACT4Y+bB+oxjPoC0WVCUV_Bq9ePqdV3m_V4snsfUrZ2BSWub2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+bB+oxjPoC0WVCUV_Bq9ePqdV3m_V4snsfUrZ2BSWub2Q@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk, linux-block@vger.kernel.org, David Rientjes <rientjes@google.com>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 03, 2016 at 04:22:39PM +0100, Dmitry Vyukov wrote:
> On Sat, Dec 3, 2016 at 11:38 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> > On Fri, Dec 02, 2016 at 05:50:39PM +0100, Dmitry Vyukov wrote:
> >> On Fri, Nov 25, 2016 at 8:08 PM, Dmitry Vyukov <dvyukov@google.com> wrote:

[...]

Hi Dmitry,

> 
> Thanks for looking into this!
> 
> As I noted I don't think this is use-after-free, more likely it is an
> out-of-bounds access against non-slab range.
> 
> Report says that we are copying 0x1000 bytes starting at 0xffff880062c6e02a.
> The first bad address is 0xffff880062c6f000, this address was freed
> previously and that's why KASAN reports UAF.

We're copying 65499 bytes (65535 - sizeof(sg_header)) and we've got 2 order 3
page allocations to do this. It fails somewhere in there. I have seen fails at
0x2000, 0xe000 and all (0x1000 aligned) offsets inbetween.

> But this is already next page, and KASAN does not insert redzones
> around pages (only around slab allocations).
> So most likely the code should have not touch 0xffff880062c6f000 as it
> is not his memory.
> Also I noticed that the report happens after few minutes of repeatedly
> running this program, so I would expect that this is some kind of race
> -- either between kernel threads, or maybe between user space threads
> and kernel.

I somehow think it's a race as well, especially as I have to run the
reproducer in an endless loop and break out of it once I have the 1st
stacktrace in dmesg. This takes between some minutes up to one hour on my
setup.

But the race against a userspace thread... Could it be that the reproducer has
already exited it's threads while the copy_from_iter() is still running?
Normally I'd say no, as user-space shouldn't run while the kernel is doing
things in it's address space, but this is highly suspicious.

> Or maybe it's just that the next page is not always marked
> as free, so we just don't detect the bad access.

Could be, but I lack the memory management knowledge to say more than a 'could
be'.

> 
> Does it all make any sense to you?
> Can you think of any additional sanity checks that will ensure that
> this code copies only memory it owns?

Given that we pass the 0xffff as dxfer_len it thinks it owns all memory, so
this is OK, kinda. All that could be would be that user-space has already
exited and thus it's memory is already freed.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
