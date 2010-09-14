From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Blank DVD is not detected / cannot burn
Date: Tue, 14 Sep 2010 07:40:19 -0500
Message-ID: <1284468019.20409.14.camel@mulgrave.site>
References: <4C8F5C3E.80909@canonical.com>
	 <1284466724.20409.8.camel@mulgrave.site>  <4C8F6C2D.4070200@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab0INMkX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2010 08:40:23 -0400
In-Reply-To: <4C8F6C2D.4070200@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Jones <lee.jones@canonical.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

linux-scsi cc re-added, please don't drop ... others may know more than
me.

On Tue, 2010-09-14 at 13:35 +0100, Lee Jones wrote:
> On 14/09/10 13:18, James Bottomley wrote:
> > On Tue, 2010-09-14 at 12:27 +0100, Lee Jones wrote:
> >> A bug as been reported me to where some DVD-RW drives are unable to
> >> detect blank DVDs. Apparently this is a regression issue, as the
> >> reporting user is insisting that they used to be able to burn DVDs
> >> using the same hardware.
> >>
> >> The reporting user provided this dmesg output. I believe they tried a
> >> few different disks to gain this response.
> > 
> > You neglected to say what kernel?  I assume 2.6.35
> 
> The same results have been seen in 2.6.32 and 2.6.35.

OK, I'd still lay better odds on a burner program problem ... but since
it's so old, a bisection is likely needed.  Which kernel actually
worked?

James


> >> I am pasting dmesg output from these attempts:
> >> [ 3563.989601] sr 5:0:1:0: [sr0] Unhandled sense code
> >> [ 3563.989606] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> >> [ 3563.989609] sr 5:0:1:0: [sr0] Sense Key : Medium Error [current]
> >> [ 3563.989614] sr 5:0:1:0: [sr0] ASC=0x10 <<vendor>> ASCQ=0x90
> >> [ 3563.989621] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 05 6f 60 00 00 02 00
> >> [ 3563.989629] end_request: I/O error, dev sr0, sector 1424768
> >> [ 3563.989633] quiet_error: 3 callbacks suppressed
> >> [ 3563.989636] Buffer I/O error on device sr0, logical block 178096
> >> [ 3607.084661] sr 5:0:1:0: [sr0] Device not ready
> >> [ 3607.084665] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> >> [ 3607.084669] sr 5:0:1:0: [sr0] Sense Key : Not Ready [current]
> >> [ 3607.084673] sr 5:0:1:0: [sr0] Add. Sense: Medium not present
> >> [ 3607.084677] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 1e 00 00 02 00
> >> [ 3607.084685] end_request: I/O error, dev sr0, sector 120
> >> [ 3607.084690] Buffer I/O error on device sr0, logical block 15
> >> [ 3607.090021] sr 5:0:1:0: [sr0] Device not ready
> >> [ 3607.090023] sr 5:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> >> [ 3607.090026] sr 5:0:1:0: [sr0] Sense Key : Not Ready [current]
> >> [ 3607.090029] sr 5:0:1:0: [sr0] Add. Sense: Medium not present
> >> [ 3607.090032] sr 5:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 1e 00 00 02 00
> >> [ 3607.090039] end_request: I/O error, dev sr0, sector 120
> > 
> > So these are all direct pass throughs.  That likely means the problem is
> > in the setup on the burner.  If there's some filesystem above this,
> > there was a Read/Write flag error in blk_rq_map_kern ... but that was
> > introduced in 2.6.36-rc1.
> > 
> > The only recent changes to sr were the BLK pushdown and they were post
> > 2.6.35.
> > 
> > James
> > 
> > 
> 


