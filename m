From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Re: Unaligned scatter-gather buffers and
 usb-storage
Date: Thu, 20 Nov 2003 19:18:01 +0200 (EET)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.58.0311201911070.2302@kai.makisara.local>
References: <Pine.LNX.4.44L0.0311201015030.878-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0311201015030.878-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, 20 Nov 2003, Alan Stern wrote:

> On Thu, 20 Nov 2003, Jens Axboe wrote:
>
> > Then you just cannot do zero-copy dma, if the buffer isn't aligned
> > properly. It's as simple as that. And surely that wont kill you
> > performance wise.
> >
> > Doing bounce buffering to just maintain the use of mapping user pages
> > into the kernel ls out right silly.
> >
> > So no, I still don't think we have to add anything. Just don't do_dio if
> > the alignment doesn't allow it. Ditto for sg.
>
> The answer seems very simple.  There should be a host template entry for
> dma buffer alignment (there's already a dma_boundary member).  It would be
> copied into the device's request queue stucture if it is nonzero,
> overriding the default value of 512.  sg and st should check the user
> buffer against the request queue's dma_alignment mask and avoid doing
> direct I/O if the alignment is wrong -- just fall back to normal I/O.
>
> Any objections to this scheme?
>
My only objection is the default. It should be zero. If I read the
usb-storage sources correctly, the scsi_host_template is defined in one
file (scsiglue.c). If the mask is there set to 511, all USB storage
devices get 512-byte alignment and other get no constraints. All get
optimal result with minimal work. (Adding the check to st and sg is
trivial.)

-- 
Kai


-------------------------------------------------------
This SF.net email is sponsored by: SF.net Giveback Program.
Does SourceForge.net help you be more productive?  Does it
help you create better code?  SHARE THE LOVE, and help us help
YOU!  Click Here: http://sourceforge.net/donate/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
