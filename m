From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3rom: sector size should be 512 bytes
Date: Thu, 31 Jan 2008 08:10:55 -0800
Message-ID: <1201795855.11265.67.camel@haakon2.linux-iscsi.org>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
	 <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
	 <1201788625.11265.23.camel@haakon2.linux-iscsi.org>
	 <1201793647.3131.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:25485 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756357AbYAaQLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 11:11:23 -0500
In-Reply-To: <1201793647.3131.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Aegis Lin <aegislin@gmail.com>, Masakazu Mokuno <Masakazu_Mokuno@hq.scei.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

On Thu, 2008-01-31 at 09:34 -0600, James Bottomley wrote:
> On Thu, 2008-01-31 at 06:10 -0800, Nicholas A. Bellinger wrote:
> > Greetings Geert and Co,
> > 
> > I have a related patch that I have been using with ps3rom.c for some
> > time that fixes a bug in fs/bio.c that assumes 512 byte sectors for
> > ATAPI operations.  This bug actually exists for all non 512 byte sector
> > devices go through this code path (I found it with
> > scsi_execute_async()), but I first ran into this issue with ps3rom.c
> > because max_sectors (32) is small enough to trigger the bug assuming 512
> > byte sectors during typical ATAPI READ_10 ops with iSCSI/HD.  Because
> > typical max_sector settings for libata and USB are much higher, I have
> > never ran into this issue outside of ps3rom.c, but the bug exists
> > nevertheless..
> > 
> > The current patch assumes 512 byte sectors, and adds a sector_size
> > parameter to drivers/scsi/scsi_lib.c:scsi_req_map_sg() to change it for
> > passed struct request.  I know that some folks talked about killing
> > scsi_execute_async() and fixing this problem elsewhere, but until then
> > please consider this patch.  Any input is also appreciated.
> 
> My first reaction is really, no; there's no way we should be doing such
> a nasty layering violation.
> 

I don't care for it either, but without this patch (or something
similar) all SCSI targets that use scsi_execute_async(), for non 512
byte requests are broken.  This causes a problem when a small max_sector
is correctly used by the LLD, and trips the check in
fs/bio.c:__bio_add_page()

	if (((bio->bi_size + len) >> 9) > max_sectors)

> The block code is set up to work with 512 byte sectors for its internal
> counts.  Something like this will damage all non-512 byte sector devices
> (and we do have several of those).

The purpose of the patch was to make none 512 byte sector struct
scsi_device (2048 byte sector size ATAPI packets received over IP
storage fabric, and queued into ps3rom.c in this particular case) work
with scsi_execute_async().  If there is another target mode SCSI
interface that does not have this problem existing or planned, I have no
problem moving to that one instead.

> 
> There are three quantities you need to understand when trying to do
> something like this
> 
>      1. The actual internal block sector size for sector counts.  This
>         is hard coded to 512
>      2. The medium sector size.  This is stored in hardsect_size in the
>         queue.  Block ensures that it always sends down enough 512 byte
>         sectors to be a multiple of this
>      3. The block size.  This represents the unit the user of the device
>         wants to think in terms of (most often for filesystems, the fs
>         block size). It's stored in various places including the
>         block_device bd_block_size.

Yes, the assumption of the two hardcoded locations of 512 byte sectors
in __bio_add_page() and bio_endio() is where I was orginally running
into problems. I know you have mentioned that no in-tree drivers
currently send non 512 byte sector requests into scsi_execute_async(),
but the issue exists for all current target mode code when going through
said SCSI target interface.

So what I am hearing is that the conditionals in __bio_add_page() and
bio_endio() that assume 512 byte sector size should be checking when the
medium sector size does not match the hardcoded block sector size,  byte
and use the non 512 sector value for the incoming and completion
paths..?

> It really sounds like the problem with ps3rom is that hardsect_size
> isn't being set correctly.  As I understand the problem, from the
> incredibly cursory insight the emails give, so please correct if wrong,
> you want the hard sector size to be the CD_FRAMESIZE?

Sorry, to confuse this.  These are two seperate issues.

--nab
  
> 
> James
> 
> 
> 



