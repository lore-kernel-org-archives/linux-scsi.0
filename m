From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block devices: validate block device capacity
Date: Thu, 30 Jan 2014 15:37:07 -0800
Message-ID: <1391125027.2181.114.camel@dabdike.int.hansenpartnership.com>
References: <alpine.LRH.2.02.1401301531040.29912@file01.intranet.prod.int.rdu2.redhat.com>
	 <1391122163.2181.103.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LRH.2.02.1401301805590.19506@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1401301805590.19506@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Nick Piggin <npiggin@kernel.dk>, "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-01-30 at 18:10 -0500, Mikulas Patocka wrote:
> 
> On Thu, 30 Jan 2014, James Bottomley wrote:
> 
> > Why is this?  the whole reason for CONFIG_LBDAF is supposed to be to
> > allow 64 bit offsets for block devices on 32 bit.  It sounds like
> > there's somewhere not using sector_t ... or using it wrongly which needs
> > fixing.
> 
> The page cache uses unsigned long as a page index. Therefore, if unsigned 
> long is 32-bit, the block device may have at most 2^32-1 pages.

Um, that's the index into the mapping, not the device; a device can have
multiple mappings and each mapping has a radix tree of pages.  For most
filesystems a mapping is equivalent to a file, so we can have large
filesystems, but they can't have files over actually 4GB on 32 bits
otherwise mmap fails.

Are we running into a problems with struct address_space where we've
assumed the inode belongs to the file and lvm is doing something where
it's the whole device?

> > > On 32-bit architectures, we must limit block device size to
> > > PAGE_SIZE*(2^32-1).
> > 
> > So you're saying CONFIG_LBDAF can never work, why?
> > 
> > James
> 
> CONFIG_LBDAF works, but it doesn't allow unlimited capacity: on x86, 
> without CONFIG_LBDAF, the limit is 2TiB. With CONFIG_LBDAF, the limit is 
> 16TiB (4096*2^32).

I don't think the people who did the large block device work expected to
gain only 3 bits for all their pain.

James
