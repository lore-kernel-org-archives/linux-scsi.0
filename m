From: tmhikaru@gmail.com
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem readonly
Date: Mon, 23 Nov 2009 14:50:22 -0500
Message-ID: <20091123195022.GA18510@roll>
References: <20091123160914.GG15679@duck.suse.cz> <Pine.LNX.4.44L0.0911231319060.2958-100000@iolanthe.rowland.org> <20091123185449.GA11186@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756270AbZKWTub@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091123185449.GA11186@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2009 at 07:54:50PM +0100, Jan Kara wrote:
> On Mon 23-11-09 13:20:26, Alan Stern wrote:
> > On Mon, 23 Nov 2009, Jan Kara wrote:
> > 
> > > On Mon 23-11-09 10:06:03, Alan Stern wrote:
> > > > On Mon, 23 Nov 2009, Jan Kara wrote:
> > > > 
> > > > >   Yeah, from what you write, it looks like USB enclosure is at fault (or it
> > > > > could still be your USB controller but I doubt it).  It's still a bit
> > > > > bothering that the error reported by the drive was not properly propagated
> > > > > up to VFS. Either it's some block layer retry/ignore magic that I missed or
> > > > > we ignore errors from block layer in some place.
> > > > 
> > > > Is there any interest in tracking this down?  It's not hard to find out
> > > > what low-level errors are being reported and to generate them on demand
> > > > with an emulated USB disk drive.
> > >   Well, if you could provide me with the patch, I could try to track down
> > > why the errors aren't propagated... It would be interesting because if it's
> > > not some retry logic in block layer, it's a bug in VFS ;).
> > 
> > I can't provide a patch without first knowing what the errors are.  The 
> > way to find out is to use usbmon.  See Documentation/usb/usbmon.txt for 
> > instructions.
>   Ah, OK. The problem manifests itself as an error in SATA communication
> (which in fact somehow happens over USB, but I don't really know the
> details of mass storage over USB) so debugging USB would become actual only
> if we found out it's really some bug in an usb stack. But so far the most
> probable is just an error somewhere between the USB controller in the
> enclosure and the drive itself. BTW: Is the data transferred over USB
> checksummed?
> 
> 									Honza
	Mind that this is an ide hard drive in a usb enclosure, not sata.
The error reported is bizzare. I don't know if I'll be able to get the
enclosure to cause the error on demand, but before I try supergluing it,
I'll try to do whatever I need to do with usbmon so we can get the error
that's actually happening so you can do whatever you need to do to track it
down :)

Tim McGrath
