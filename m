From: Jens Axboe <axboe@suse.de>
Subject: Re: Re: Unaligned scatter-gather buffers and usb-storage
Date: Thu, 20 Nov 2003 17:24:58 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20031120162457.GC1106@suse.de>
References: <20031120153026.GB1106@suse.de> <Pine.LNX.4.44L0.0311201059130.878-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311201059130.878-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 20 2003, Alan Stern wrote:
> On Thu, 20 Nov 2003, Jens Axboe wrote:
> 
> > Well yes, that's what my objection is against - adding that member. Did
> > you not read any of my mails? And it's quite simple why - basically
> > noone will add it, so it'll end up being 512 anyways.
> 
> All right, fine.  Host adapter drivers have the option of setting the 
> dma_alignment mask in their slave_configure() routines.  Doing it there 
> won't add anything to the host template, will leave the value at its 
> default 512 for host drivers that don't care, and will let drivers that do 
> care set it to the optimal value.
> 
> The important thing is that sg and st should check the alignment of the 
> actual buffer against the dma_alignment mask, which they currently don't 
> do.

Sure fine. I still don't think it's worth anybodies time messing with.

> > I just don't see the point. It's a miniscule optimization. If you need
> > that last bit of performance, then align your buffers and noone loses.
> > See?
> 
> I'm not sure -- was that "you" directed at me personally or at userspace 
> program writers in general?  Telling me to align the user buffers won't 
> help anything; it's the program writers who need to be informed of the 
> restrictions.  And it's the host-driver writers who need to loosen those 
> restrictions where applicable.

You as in program writers, clearly you cannot do anything about it. Of
course sg/st/whatever cannot pass down badly aligned sg addresses,
that's a given. And I think they are currently broken that they don't
attempt to align to 512 bytes. I just think we've waisted way more time
discussion the issue than what will ever be saved in cpu time.

-- 
Jens Axboe



-------------------------------------------------------
This SF.net email is sponsored by: SF.net Giveback Program.
Does SourceForge.net help you be more productive?  Does it
help you create better code?  SHARE THE LOVE, and help us help
YOU!  Click Here: http://sourceforge.net/donate/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
