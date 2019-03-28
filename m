From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Thu, 28 Mar 2019 11:57:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1903281157070.1291-100000@iolanthe.rowland.org>
References: <1553786139.14990.6.camel@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553786139.14990.6.camel@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: Kento.A.Kobayashi@sony.com, gregkh@linuxfoundation.org, usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 28 Mar 2019, Oliver Neukum wrote:

> On Do, 2019-03-28 at 07:53 +0000, Kento.A.Kobayashi@sony.com wrote:
> > Hi,
> > 
> > > Sorry,
> > > 
> > > I thought this was clear. Your patch is making the assumption that the reset is triggered by the SCSI layer. You cannot make that assumption, as there is an ioctl for resetting a USB device.
> > > In case we are getting an error during the reset (our endpoints vanish), the device driver must report that to the USB layer, so the driver will always be disconnected.
> > > We cannot drop errors.
> > > 
> > > 	Regards
> > > 		Oliver
> > 
> > This patch modified uas_post_reset to skip rebind operation to avoid exception while -ENODEV happens not drop error.
> > If uas_post_reset happens -ENODEV, usb_reset_and_verify_device must happen error.
> > So,when we use ioctl(USBDEVFS_RESET) to reset device, if usb_reset_and_verify_device happens error, the error will be reported through ioctl return value. 
> 
> OK, It is possible that I am stupid. We must rebind if uas_post_reset()
> fails. The driver will crash without the endpoints. Can you please
> explain again in greater detail, what you are trying to achieve?

Actually no, the driver doesn't have to do anything if the post-reset 
method fails.  usbcore will take care of rebinding automatically.

Alan Stern
