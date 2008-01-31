From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3rom: sector size should be 512 bytes
Date: Thu, 31 Jan 2008 09:28:09 -0800
Message-ID: <1201800489.11265.134.camel@haakon2.linux-iscsi.org>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
	 <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
	 <1201788625.11265.23.camel@haakon2.linux-iscsi.org>
	 <1201793647.3131.8.camel@localhost.localdomain>
	 <1201795855.11265.67.camel@haakon2.linux-iscsi.org>
	 <1201796764.3131.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:41367 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1765101AbYAaR2h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 12:28:37 -0500
In-Reply-To: <1201796764.3131.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Aegis Lin <aegislin@gmail.com>, Masakazu Mokuno <Masakazu_Mokuno@hq.scei.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

On Thu, 2008-01-31 at 10:26 -0600, James Bottomley wrote:
> On Thu, 2008-01-31 at 08:10 -0800, Nicholas A. Bellinger wrote:
> > On Thu, 2008-01-31 at 09:34 -0600, James Bottomley wrote:
> > > On Thu, 2008-01-31 at 06:10 -0800, Nicholas A. Bellinger wrote:
> > > > Greetings Geert and Co,
> > > > 
> > > > I have a related patch that I have been using with ps3rom.c for some
> > > > time that fixes a bug in fs/bio.c that assumes 512 byte sectors for
> > > > ATAPI operations.  This bug actually exists for all non 512 byte sector
> > > > devices go through this code path (I found it with
> > > > scsi_execute_async()), but I first ran into this issue with ps3rom.c
> > > > because max_sectors (32) is small enough to trigger the bug assuming 512
> > > > byte sectors during typical ATAPI READ_10 ops with iSCSI/HD.  Because
> > > > typical max_sector settings for libata and USB are much higher, I have
> > > > never ran into this issue outside of ps3rom.c, but the bug exists
> > > > nevertheless..
> > > > 
> > > > The current patch assumes 512 byte sectors, and adds a sector_size
> > > > parameter to drivers/scsi/scsi_lib.c:scsi_req_map_sg() to change it for
> > > > passed struct request.  I know that some folks talked about killing
> > > > scsi_execute_async() and fixing this problem elsewhere, but until then
> > > > please consider this patch.  Any input is also appreciated.
> > > 
> > > My first reaction is really, no; there's no way we should be doing such
> > > a nasty layering violation.
> > > 
> > 
> > I don't care for it either, but without this patch (or something
> > similar) all SCSI targets that use scsi_execute_async(), for non 512
> > byte requests are broken.  This causes a problem when a small max_sector
> > is correctly used by the LLD, and trips the check in
> > fs/bio.c:__bio_add_page()
> > 
> > 	if (((bio->bi_size + len) >> 9) > max_sectors)
> > 
> 
> Could we rewind this discussion back to an actual problem description
> then, please?  Nothing in the standard path for a CD/DVD should be using
> scsi_execute_async(), what's the actual problem use case?
> 

The problem case is a SCSI Target Mode engine that receives a 2048 Byte
single sector ATAPI READ_10 request from the storage fabric, and uses
scsi_execute_async() (the only option >= 2.6.18) to issue said request
to the underlying struct scsi_device.  Because the underlying bio code
assumes 512 byte only sectors, the check in __bio_add_page() incorrectly
determines that max_sectors (max_sectors has to be low, as with 32 from
ps3rom.c) has been exceeded, and fails the request back up the stack.

--nab

> James
> 
> 
> 

