From: Jens Axboe <axboe@suse.de>
Subject: Re: Re: Unaligned scatter-gather buffers and usb-storage
Date: Wed, 19 Nov 2003 15:39:01 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20031119143901.GI1106@suse.de>
References: <20031110095914.B22518@beaverton.ibm.com> <20031118143720.A6411@beaverton.ibm.com> <20031119084729.GA1106@suse.de> <200311191401.34540.oliver@neukum.org> <20031119130400.GG1106@suse.de> <1069252642.10768.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1069252642.10768.7.camel@mulgrave>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 19 2003, James Bottomley wrote:
> On Wed, 2003-11-19 at 07:04, Jens Axboe wrote:
> > On Wed, Nov 19 2003, Oliver Neukum wrote:
> > > 
> > > > > You could add a scsi_host fields or bits specifying alignment
> > > > > restrictions, and enforce them as needed in upper level drivers.
> > > > 
> > > > The queue already has such a restriction embedded, see bio_map_user()
> > > > and queue_dma_alignment().
> > > 
> > > Very well, as far as sd and sr are concerned, but it doesn't help for
> > > sg and st, does it?
> > 
> > They both have a queue through the scsi device structure. But you could
> > put the value someplace else if you wanted.
> 
> Actually, the sg case should be fine, because it shares the queue with
> the other attachment (unless it's a processor or other unrecognised
> device).
> 
> but, regardless, the queue is already set up (for all devices, including
> st) in either slave_alloc, or slave_configure, so you could call the
> alignment setting routine there.

That was my point, yes.

> Alternatively, we could add this as yet another parameter to the host
> and template structures.  Any preferences?

I suppose you have to, if you want LLD to be able to pass it down.

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
