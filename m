From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Problem with an USB Stick and kernel 2.6.1
Date: Fri, 16 Jan 2004 13:27:30 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20040116212730.GA1183@beaverton.ibm.com>
References: <20040116165559.GB2686@beaverton.ibm.com> <Pine.LNX.4.44L0.0401161551300.843-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0401161551300.843-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Florian Lohoff <flo@rfc822.org>, Alexander Motzkau <a.motzkau@web.de>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org


This matches what I thought should be added to sd, but I did not hear an
answer from James / others if this is the way we should handle it.

Alan Stern [stern@rowland.harvard.edu] wrote:
> On Fri, 16 Jan 2004, Mike Anderson wrote:
> 
> > Alan Stern [stern@rowland.harvard.edu] wrote:
> > > 
> > > Seeing no sense key, usb-storage returns 0 indicating the command
> > > succeeded.  But scsi_finish_command() sees that valid sense data is
> > > present and sets the driver_byte to DRIVER_SENSE.
> > > 
> > > > SCSI error : <1 0 0 0> return code = 0x8000000
> > > > Current sda: sense key No Sense
> > > 
> > > This causes scsi_io_completion() to call scsi_end_request() with uptodate 
> > > = 0 and results in this error:
> > > 
> > > > end_request: I/O error, dev sda, sector 32
> > > > FAT: unable to read boot sector
> > > 
> > > How should we handle this?  Should we zero out sense_buffer[0] when 
> > > auto-sense shows sense key = NO_SENSE?
> > > 
> > 
> > I would think the upper level driver should handle this. We decode
> > RECOVERED_ERROR in sd. sd could just handle NO_SENSE the same with /
> > without the print_sense. I noticed that st and osst under some
> > circumstances look at the NO_SENSE case (the tape people will need to
> > comment as this looks like a EOM workaround) so it would seem incorrect
> > for the LLDD as a general policy to say it received no sense when it
> > did.
> 
> Florian and Alexander, does this patch fix your problem?  Mike, how does 
> it look to you?
> 
> Alan Stern
> 
> 
> ===== sd.c 1.59 vs edited =====
> --- 1.59/drivers/scsi/sd.c	Fri Oct 24 14:53:37 2003
> +++ edited/drivers/scsi/sd.c	Fri Jan 16 15:49:48 2004
> @@ -730,6 +730,14 @@
>  			 * hard error.
>  			 */
>  			print_sense("sd", SCpnt);
> +			/* FALLS THROUGH */
> +
> +		case NO_SENSE:
> +			/*
> +			 * The low-level driver got the sense data but
> +			 * everything was all right.  Don't treat this
> +			 * an an error.
> +			 */
>  			SCpnt->result = 0;
>  			SCpnt->sense_buffer[0] = 0x0;
>  			good_sectors = this_count;
> 
-andmike
--
Michael Anderson
andmike@us.ibm.com



-------------------------------------------------------
The SF.Net email is sponsored by EclipseCon 2004
Premiere Conference on Open Tools Development and Integration
See the breadth of Eclipse activity. February 3-5 in Anaheim, CA.
http://www.eclipsecon.org/osdn
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
