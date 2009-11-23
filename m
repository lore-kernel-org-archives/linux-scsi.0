From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/4] block: Allow devices to indicate whether discarded
 blocks are zeroed
Date: Mon, 23 Nov 2009 11:50:05 -0600
Message-ID: <4B0ACB4D.1030403@redhat.com>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-2-git-send-email-martin.petersen@oracle.com> <20091121101356.GA21716@infradead.org> <20091121195802.GC8502@parisc-linux.org> <4B08A543.909@rtr.ca> <4B0ABA2F.2090407@redhat.com> <87f94c370911230854v46c1dc35g417a54b8a415ba16@mail.gmail.com> <4B0AC038.6050606@redhat.com> <20091123170325.GA23217@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20091123170325.GA23217@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Greg Freemyer <greg.freemyer@gmail.com>, Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Nov 23, 2009 at 12:02:48PM -0500, Ric Wheeler wrote:
>> I agree - the discard of the whole device is a good idea.
>>
>> I just want to make clear that "discard block X; write block X with 
>> zeroed data" undoes the discard in general :-)
> 
> We can skip the writing of zeroes if we know the device returns zeroed
> blocks after a trim.  Martin's patch exports that information to
> userspace, and once we have a nice enough interface (e.g. blkid or an
> ioctl) we can actually use it in mkfs to optimize the writing of zeroes
> away.  Raw growling in sysfs is a bit too nasty to add it to mkfs for
> those few blocks IMHO.
> 

well, in testing, I've found that not all devices which claim to return
0s post-trim, do.

For example one ssd I have, if I pattern 1M of 0xaf, then trim from
512k to 1M, and read it back (all IO done direct) I get:

00000000  af af af af af af af af  af af af af af af af af
*
00080000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
*
000a9000  af af af af af af af af  af af af af af af af af
*
00100000

with scraps of data left over at 0xA9000.

So for the very few blocks that we zero at mkfs (thinking xfs here,
anyway) I'd really rather just zero them post-trim to be safe, at least
for now.

-Eric

