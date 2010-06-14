From: Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.34 PDC20268 PATA IO error loop makes system unusable
Date: Mon, 14 Jun 2010 13:29:52 +0200
Message-ID: <20100614112952.GF17092@basil.fritz.box>
References: <20100613154808.GA10408@basil.fritz.box> <4C15DDA0.3020409@kernel.org> <20100614121753.5723eaa2@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57252 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0FNL35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2010 07:29:57 -0400
Content-Disposition: inline
In-Reply-To: <20100614121753.5723eaa2@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jun 14, 2010 at 12:17:53PM +0100, Alan Cox wrote:
> > > sd 11:0:0:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > > sd 11:0:0:0: [sdd] Sense Key : Medium Error [current] [descriptor]
> 
> That is the drive complaining about a bad block.
> 
> > > Descriptor sense data with sense descriptors (in hex):
> > >        72 03 13 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
> > >        00 5b 23 bb 
> > > sd 11:0:0:0: [sdd] Add. Sense: Address mark not found for data field
> > > sd 11:0:0:0: [sdd] CDB: Read(10): 28 00 00 5b 23 4f 00 00 80 00
> 
> Which in my experience usually comes from
> 
> - The disc being unable to find the data block
> 
> - A corrupt indirect block in the file system leading to a requst for an
>   out of range data block
> 
> In theory it could be an on the wire bitflip but thats a bit too
> consistent to believe.

Thank, Alan. I really don't care about the drive (nothing valuable on it).
It was an old IDE disk and I am not surprised it has some bad sectors.
In fact I was clearing it for junking it (although I may keep it now
just in case I need to test IDE error handling again :)

But I cared about the system becoming unusable due to error handling running
amok.

That was the point of this bug report.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
