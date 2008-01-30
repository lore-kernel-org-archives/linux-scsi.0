From: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Wed, 30 Jan 2008 20:07:53 +0100
Message-ID: <20080130190752.GW15220@kernel.dk>
References: <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <1201635195.3069.36.camel@localhost.localdomain> <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk> <Pine.LNX.4.64.0801301125350.26562@vixen.sonytel.be> <20080130103803.GN15220@kernel.dk> <1201703915.3292.1.camel@localhost.localdomain> <20080130180613.GU15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080130180613.GU15220-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven-osDt5Q4Chk1BDgjK7y7TUQ@public.gmane.org>, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 30 2008, Jens Axboe wrote:
> On Wed, Jan 30 2008, James Bottomley wrote:
> > On Wed, 2008-01-30 at 11:38 +0100, Jens Axboe wrote:
> > > On Wed, Jan 30 2008, Geert Uytterhoeven wrote:
> > > > On Tue, 29 Jan 2008, Jens Axboe wrote:
> > > > > On Tue, Jan 29 2008, Jens Axboe wrote:
> > > > > > On Tue, Jan 29 2008, James Bottomley wrote:
> > > > > > > On Tue, 2008-01-29 at 11:10 -0800, Matthew Dharm wrote:
> > > > > > > > For some reason, usb_sg_init is boned during auto-sense.
> > > > > > > 
> > > > > > > OK, that's implicating the scsi_eh_prep_cmnd() in the auto sense
> > > > > > > code ... that was also an update in 2.6.24
> > > > > > 
> > > > > > yeah, already found the bug - it's assuming ->request_buffer holds the
> > > > > > sglist, oops. Preparing a fix.
> > > > > 
> > > > > ok here goes, this saves and restores the sg table correctly. it also
> > > > > fixes the usb bug for me.
> > > > 
> > > > I can confirm this patch fixes the errors I was seeing with current
> > > > linux-2.6.git for the USB memory card readers in a Dell TFT connected
> > > > to a PS3.
> > > 
> > > James, we need a fix for this pushed asap. So either we should merge the
> > > below now, or push the bidi patchset that also fixes this. It all
> > > depends on when you want to merge the bidi patches...
> > 
> > The SCSI patch set (including the bidirectional pieces) is waiting in
> > scsi-misc ... just for forms sake, could you confirm that it actually
> > fixes the problem and I'll push it.
> 
> Certainly, I'll give it a spin tonight.

Confirmed, pulling your scsi-misc branch into current -git makes the
problem go away as well.

-- 
Jens Axboe
