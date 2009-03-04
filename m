From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Getting TRIM working
Date: Wed, 04 Mar 2009 11:20:27 +0200
Message-ID: <49AE47DB.4030200@panasas.com>
References: <20090303190700.GD20511@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:32181
	"EHLO natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753691AbZCDJVF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 04:21:05 -0500
In-Reply-To: <20090303190700.GD20511@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> I'm having trouble getting Linux to spit out an appropriate TRIM
> command, and I've hit a bit of a wall, so I thought I'd appeal for help.
> 
> The symptom is that we send out only 24 bytes and then stop rather than
> sending out a full 512 byte "sector".
> 
> Here's what goes on, as far as I understand it.
> 
> We call 'blkdiscard /dev/sda 0 1' which is supposed to TRIM just LBA 0.
> 
> We create a bio in blk_ioctl_discard() which sets bi_size to 512 (1 << 9).
> This is necessary to let the elevators know how many bytes we're going
> to discard, so it can do merging correctly.
> 
> Then, in sd_discard_fn(), we do this:
> 
>         bio->bi_size = 0;
>         if (bio_add_pc_page(q, bio, page, 24, 0) < 24) {
>                 __free_page(page);
>                 return -ENOMEM;
>         }
> 
> This is where the 24 comes from -- it's the length of the data transmitted
> to the drive for an unmap of a single range.
> 
> Now in ata_scsi_unmap_xlat() we need to turn this SCSI UNMAP command
> into an ATA TRIM command.  So I do this:
> 
>         size = ALIGN(i * 8, 512);
>         memset(buffer + i * 8, 0, size - i * 8);
>         old_size = bio_iovec(bio)->bv_len;
> printk("before: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
>                 req->data_len, old_size);
>         if (size > old_size) {
>                 bio_add_pc_page(req->q, bio, bio_page(bio),
>                                         size - old_size, old_size);
>                 req->data_len = size;
>         }
> printk("after: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
>                 req->data_len, bio_iovec(bio)->bv_len);
> 
> Now req->data_len, bio->bi_size and bio_iovec(bio)->bv_len are all 512.
> Yet the AHCI driver still spits out 24 bytes and then stops (which hangs
> the drive).  What am I missing?
> 
> The current git tree can be found at
> http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20090212
> 
> I tried a few things yesterday with access to the ATA bus analyser,
> and the results of that are not found in the git tree.  This patch on
> top of that git tree makes things better (before yesterday, I didn't
> know about bv_len, for example):
> 

I have not inspected the code so please forgive me if I'm talking none-sense.

What about the length embedded in the CDB, which is usually derived from
scsi_bufflen(), or other places that look at scsi_bufflen() and not at
request && it's bios. The later might be bigger then scsi's in split commands
but the drivers should only consume scsi_bufflen() bytes.

Just a shot in the dark
Boaz
 

