From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3rom: sector size should be 512 bytes
Date: Thu, 31 Jan 2008 21:01:21 -0800
Message-ID: <1201842081.11265.217.camel@haakon2.linux-iscsi.org>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
	 <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
	 <1201788625.11265.23.camel@haakon2.linux-iscsi.org>
	 <1201793647.3131.8.camel@localhost.localdomain>
	 <1201795855.11265.67.camel@haakon2.linux-iscsi.org>
	 <1201796764.3131.15.camel@localhost.localdomain>
	 <1201800489.11265.134.camel@haakon2.linux-iscsi.org>
	 <1201802031.3131.29.camel@localhost.localdomain>
	 <1201805075.11265.178.camel@haakon2.linux-iscsi.org>
	 <Pine.LNX.4.64.0801312013460.957@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:45325 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935327AbYBAFBv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 00:01:51 -0500
In-Reply-To: <Pine.LNX.4.64.0801312013460.957@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Aegis Lin <aegislin@gmail.com>, Masakazu Mokuno <Masakazu_Mokuno@hq.scei.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

On Thu, 2008-01-31 at 20:14 +0100, Geert Uytterhoeven wrote:
> On Thu, 31 Jan 2008, Nicholas A. Bellinger wrote:
> > On Thu, 2008-01-31 at 11:53 -0600, James Bottomley wrote:
> > > On Thu, 2008-01-31 at 09:28 -0800, Nicholas A. Bellinger wrote:
> > > > The problem case is a SCSI Target Mode engine that receives a 2048 Byte
> > > > single sector ATAPI READ_10 request from the storage fabric, and uses
> > > > scsi_execute_async() (the only option >= 2.6.18) to issue said request
> > > > to the underlying struct scsi_device.  Because the underlying bio code
> > > > assumes 512 byte only sectors, the check in __bio_add_page() incorrectly
> > > > determines that max_sectors (max_sectors has to be low, as with 32 from
> > > > ps3rom.c) has been exceeded, and fails the request back up the stack.
> > > 
> > > OK, so this is a totally separate issue from the one you actually posted
> > > it as a patch to fix?
> > > 
> > > the queue max_sectors parameter is also counted in the block internal of
> > > 512 byte sectors.  If you set it to 32 that means you were only
> > > expecting 16k of transfers per command maximum.  If that's not right,
> > > then set the limit correctly.
> > > 
> > > In short, and to repeat: almost every internal size counter to block is
> > > in units of 512 byte sectors ... that includes capacity, maximum etc ...
> > > 
> > 
> > Ok, after reading your followup with Geert I see that this looks like a
> > bug in ps3rom.c assuming 2048 byte sectors to calculate .max_sectors
> > (which was originally set to 32 as I mentioned).  Using the setting
> > BOUNCE_SIZE << 9 where BOUNCE_SIZE is the request size in bytes looks
> > like this will solve the issue.  My misunderstanding was
> > that .max_sectors was allowed to be calcuated in non 512 byte sectors,
> > so please disregard my patch.
> > 
> > Geert, .max_sectors for ps3rom.c using 512 byte sectors ends up being
> > 128, yes.?
> 
> Yes.
> 
> With kind regards,
> 
> Geert Uytterhoeven
> Software Architect
> 

Great!  I will update my ps3 to the latest 2.6.24 from ps3-linux.git and
get some new Linux/iSCSI.org Target builds made this weekend once
ps3rom-use-128-max-sector.patch is committed.

Also, I will be updating my userspace to FC8 PPC, and would like to get
a target build for the current stable 2.6.23 PPC64 from the addon CDs.
I also would not mind providing a ps3rom.ko with said patch for
interested parties using the default FC-8 Ps3-Linux kernel who are not
adventurous enough to build their own kernel until the Addon CDs are
reved again.

--nab


