From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 11:34:15 -0500
Message-ID: <1201624455.3069.10.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0801291032210.4229-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760633AbYA2Qeq@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0801291032210.4229-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-01-29 at 10:36 -0500, Alan Stern wrote:
> On Tue, 29 Jan 2008, Boaz Harrosh wrote:
> 
> > --- a/drivers/usb/storage/transport.c
> > +++ b/drivers/usb/storage/transport.c
> > @@ -462,18 +462,24 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
> >   * Common used function. Transfer a complete command
> >   * via usb_stor_bulk_transfer_sglist() above. Set cmnd resid
> >   */
> > -int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
> > -		      struct scsi_cmnd* srb)
> > +int usb_stor_bulk_srb_length(struct us_data* us, unsigned int pipe,
> > +		      struct scsi_cmnd* srb, unsigned length)
> >  {
> >  	unsigned int partial;
> >  	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
> > -				      scsi_sg_count(srb), scsi_bufflen(srb),
> > +				      scsi_sg_count(srb), length,
> >  				      &partial);
> >  
> >  	scsi_set_resid(srb, scsi_bufflen(srb) - partial);
> >  	return result;
> >  }
> >  
> > +int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
> > +		struct scsi_cmnd* srb)
> > +{
> > +	return usb_stor_bulk_srb_length(us, pipe, srb, scsi_bufflen(srb));
> > +}
> > +
> 
> I don't like this patch very much.  Why add another layer of 
> indirection when the two subroutines do hardly any work?  Leave 
> usb_stor_bulk_srb() the way it was, and add usb_stor_bulk_srb_length() 
> as a separate routine that simply calls usb_stor_bulk_transfer_sglist() 
> and scsi_set_resid().
> 
> BTW, the standard coding style calls for a blank line after the list of 
> local variables at the start of a function or block.

There's another bug in the transport.c conversion in that the residuals
are updated with bogus data in several error cases, since
usb_stor_bulk_transfer_sglist() only sets the actual length if the urb
is actually sent.

I'm not sure if this is is the solution to the problem at hand, but it
definitely fixes another bug in the code.

James

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index d9f4912..bab0858 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -465,7 +465,7 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
 		      struct scsi_cmnd* srb)
 {
-	unsigned int partial;
+	unsigned int partial = scsi_get_resid(srb);
 	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
 				      scsi_sg_count(srb), scsi_bufflen(srb),
 				      &partial);
