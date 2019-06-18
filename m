From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] usb: storage: scsiglue: Do not skip VPD if
 try_vpd_pages is set
Date: Tue, 18 Jun 2019 18:07:24 +0200
Message-ID: <20190618160724.GB27611@kroah.com>
References: <20190618013146.21961-3-marcos.souza.org@gmail.com>
 <Pine.LNX.4.44L0.1906180946160.1659-100000@iolanthe.rowland.org>
 <20190618151737.GA16959@geeko>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190618151737.GA16959@geeko>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, "open list:USB MASS STORAGE DRIVER" <linux-usb@vger.kernel.org>, "open list:USB MASS STORAGE DRIVER" <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 18, 2019 at 12:17:39PM -0300, Marcos Paulo de Souza wrote:
> On Tue, Jun 18, 2019 at 09:48:01AM -0400, Alan Stern wrote:
> > On Mon, 17 Jun 2019, Marcos Paulo de Souza wrote:
> > 
> > > If BLIST_TRY_VPD_PAGES is set for a device, even for an USB, it should
> > > be honored, so only set skip_vpd_pages is try_vpd_pages is not set.
> > > 
> > > Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> > > ---
> > >  drivers/usb/storage/scsiglue.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> > > index 59190d88fa9f..0a9520780771 100644
> > > --- a/drivers/usb/storage/scsiglue.c
> > > +++ b/drivers/usb/storage/scsiglue.c
> > > @@ -195,8 +195,11 @@ static int slave_configure(struct scsi_device *sdev)
> > >  		 */
> > >  		sdev->skip_ms_page_8 = 1;
> > >  
> > > -		/* Some devices don't handle VPD pages correctly */
> > > -		sdev->skip_vpd_pages = 1;
> > > +		/*
> > > +		 * Some devices don't handle VPD pages correctly, so skip vpd
> > > +		 * pages if not forced by SCSI layer.
> > > +		 */
> > > +		sdev->skip_vpd_pages = sdev->try_vpd_pages == 0;
> > >  
> > >  		/* Do not attempt to use REPORT SUPPORTED OPERATION CODES */
> > >  		sdev->no_report_opcodes = 1;
> > 
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Although I think it would be clearer to write:
> > 
> > 		sdev->skip_vpd_pages = !sdev->try_vpd_pages;
> 
> I agree. Greg, would you like me to send a v2 of this patch with this change, or
> can you apply the change suggested by Alan?

I do not hand-edit patches, sorry.  It does not scale, please resend.

greg k-h
