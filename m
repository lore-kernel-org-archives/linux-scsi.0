From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3rom: sector size should be 512 bytes
Date: Thu, 31 Jan 2008 20:14:30 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801312013460.957@vixen.sonytel.be>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
 <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
 <1201788625.11265.23.camel@haakon2.linux-iscsi.org>
 <1201793647.3131.8.camel@localhost.localdomain> <1201795855.11265.67.camel@haakon2.linux-iscsi.org>
 <1201796764.3131.15.camel@localhost.localdomain>
 <1201800489.11265.134.camel@haakon2.linux-iscsi.org>
 <1201802031.3131.29.camel@localhost.localdomain>
 <1201805075.11265.178.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-670278709-1201806870=:957"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62452 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759767AbYAaTOc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:14:32 -0500
In-Reply-To: <1201805075.11265.178.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Aegis Lin <aegislin@gmail.com>, Masakazu Mokuno <Masakazu_Mokuno@hq.scei.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-670278709-1201806870=:957
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 31 Jan 2008, Nicholas A. Bellinger wrote:
> On Thu, 2008-01-31 at 11:53 -0600, James Bottomley wrote:
> > On Thu, 2008-01-31 at 09:28 -0800, Nicholas A. Bellinger wrote:
> > > The problem case is a SCSI Target Mode engine that receives a 2048 Byte
> > > single sector ATAPI READ_10 request from the storage fabric, and uses
> > > scsi_execute_async() (the only option >= 2.6.18) to issue said request
> > > to the underlying struct scsi_device.  Because the underlying bio code
> > > assumes 512 byte only sectors, the check in __bio_add_page() incorrectly
> > > determines that max_sectors (max_sectors has to be low, as with 32 from
> > > ps3rom.c) has been exceeded, and fails the request back up the stack.
> > 
> > OK, so this is a totally separate issue from the one you actually posted
> > it as a patch to fix?
> > 
> > the queue max_sectors parameter is also counted in the block internal of
> > 512 byte sectors.  If you set it to 32 that means you were only
> > expecting 16k of transfers per command maximum.  If that's not right,
> > then set the limit correctly.
> > 
> > In short, and to repeat: almost every internal size counter to block is
> > in units of 512 byte sectors ... that includes capacity, maximum etc ...
> > 
> 
> Ok, after reading your followup with Geert I see that this looks like a
> bug in ps3rom.c assuming 2048 byte sectors to calculate .max_sectors
> (which was originally set to 32 as I mentioned).  Using the setting
> BOUNCE_SIZE << 9 where BOUNCE_SIZE is the request size in bytes looks
> like this will solve the issue.  My misunderstanding was
> that .max_sectors was allowed to be calcuated in non 512 byte sectors,
> so please disregard my patch.
> 
> Geert, .max_sectors for ps3rom.c using 512 byte sectors ends up being
> 128, yes.?

Yes.

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
---584349381-670278709-1201806870=:957--
