From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3rom: sector size should be 512 bytes
Date: Thu, 31 Jan 2008 18:41:57 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801311840230.15534@vixen.sonytel.be>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
 <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
 <1201788625.11265.23.camel@haakon2.linux-iscsi.org>
 <1201793647.3131.8.camel@localhost.localdomain> <1201795855.11265.67.camel@haakon2.linux-iscsi.org>
 <1201796764.3131.15.camel@localhost.localdomain>
 <1201800489.11265.134.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-454446690-1201801313=:15534"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:61792 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759690AbYAaRmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 12:42:01 -0500
In-Reply-To: <1201800489.11265.134.camel@haakon2.linux-iscsi.org>
Content-ID: <Pine.LNX.4.64.0801311841560.15534@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Aegis Lin <aegislin@gmail.com>, Masakazu Mokuno <Masakazu_Mokuno@hq.scei.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-454446690-1201801313=:15534
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0801311841561.15534@vixen.sonytel.be>

On Thu, 31 Jan 2008, Nicholas A. Bellinger wrote:
> On Thu, 2008-01-31 at 10:26 -0600, James Bottomley wrote:
> > On Thu, 2008-01-31 at 08:10 -0800, Nicholas A. Bellinger wrote:
> > > On Thu, 2008-01-31 at 09:34 -0600, James Bottomley wrote:
> > > > On Thu, 2008-01-31 at 06:10 -0800, Nicholas A. Bellinger wrote:
> > > > > Greetings Geert and Co,
> > > > > 
> > > > > I have a related patch that I have been using with ps3rom.c for some
> > > > > time that fixes a bug in fs/bio.c that assumes 512 byte sectors for
> > > > > ATAPI operations.  This bug actually exists for all non 512 byte sector
> > > > > devices go through this code path (I found it with
> > > > > scsi_execute_async()), but I first ran into this issue with ps3rom.c
> > > > > because max_sectors (32) is small enough to trigger the bug assuming 512
> > > > > byte sectors during typical ATAPI READ_10 ops with iSCSI/HD.  Because
> > > > > typical max_sector settings for libata and USB are much higher, I have
> > > > > never ran into this issue outside of ps3rom.c, but the bug exists
> > > > > nevertheless..
> > > > > 
> > > > > The current patch assumes 512 byte sectors, and adds a sector_size
> > > > > parameter to drivers/scsi/scsi_lib.c:scsi_req_map_sg() to change it for
> > > > > passed struct request.  I know that some folks talked about killing
> > > > > scsi_execute_async() and fixing this problem elsewhere, but until then
> > > > > please consider this patch.  Any input is also appreciated.
> > > > 
> > > > My first reaction is really, no; there's no way we should be doing such
> > > > a nasty layering violation.
> > > > 
> > > 
> > > I don't care for it either, but without this patch (or something
> > > similar) all SCSI targets that use scsi_execute_async(), for non 512
> > > byte requests are broken.  This causes a problem when a small max_sector
> > > is correctly used by the LLD, and trips the check in
> > > fs/bio.c:__bio_add_page()
> > > 
> > > 	if (((bio->bi_size + len) >> 9) > max_sectors)
> > > 
> > 
> > Could we rewind this discussion back to an actual problem description
> > then, please?  Nothing in the standard path for a CD/DVD should be using
> > scsi_execute_async(), what's the actual problem use case?
> > 
> 
> The problem case is a SCSI Target Mode engine that receives a 2048 Byte
> single sector ATAPI READ_10 request from the storage fabric, and uses
> scsi_execute_async() (the only option >= 2.6.18) to issue said request
> to the underlying struct scsi_device.  Because the underlying bio code
> assumes 512 byte only sectors, the check in __bio_add_page() incorrectly
> determines that max_sectors (max_sectors has to be low, as with 32 from
> ps3rom.c) has been exceeded, and fails the request back up the stack.

Thanks for unfocussing James ;-)

James, do you have any comment about the first email in this thread, increasing
scsi_host_template.max_sectors?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-454446690-1201801313=:15534--
