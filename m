From: jim owens <jowens@hp.com>
Subject: Re: Aggregating discard requests in the filesystem
Date: Tue, 11 Nov 2008 10:25:03 -0500
Message-ID: <4919A3CF.1050305@hp.com>
References: <4913028B.6010405@redhat.com> <20081110203915.GP15439@parisc-linux.org> <20081111001236.GA14000@cynthia.pants.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081111001236.GA14000@cynthia.pants.nu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Brad Boyer <flar@allandria.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>
List-Id: linux-scsi@vger.kernel.org

Brad Boyer wrote:
> On Mon, Nov 10, 2008 at 01:39:15PM -0700, Matthew Wilcox wrote:
>> One of the proposals in this thread (that has got buried somewhere) was
>> to expand any discard request sent down from the filesystem to encompass
>> all the adjacent free space.  I've checked with our SSD people and
>> they're fine with this idea.
>>
>> dwmw2 says "it isn't actually that hard in FAT" and then interjects some
>> personal opinion about this solution ;-)
>>
>> Is it hard in XFS?  btrfs?  ext2?  Does anyone have a problem with this
>> as a solution?
> 
> I suspect how hard it is depends somewhat on exactly what you mean by
> "all the adjacent free space" and what is expected of the file system.

My take on this is that an "expanded discard" is just saying that
any UNMAP that is sent to the device can contain blocks which were
already UNMAPed.  In fact, all blocks in the command may already
be unmapped.

The filesystem can send individual block discards down to the block
layer or/and send a range of free blocks that surround the just-freed
block(s).  It is easy as long as the trim/unmap is permitted on
an already unmapped block.  Then repeating is not an issue.

If devices do not allow unmapping an already unmapped block then
nothing works without massive filesystem changes such as Dave C
said were needed for "reliable exact tracking".

All devices must allow unmapping an already unmapped block for
the "defrag tool as unmapper" idea to work reliably too.

jim
