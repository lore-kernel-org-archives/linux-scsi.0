From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Thu, 28 Mar 2019 16:15:39 +0100
Message-ID: <1553786139.14990.6.camel@suse.com>
References: <AE5419EAB4965843B3C0C1FE29F1FFE5872241@JPYOKXMS103.jp.sony.com>
         <1552063928.29776.2.camel@suse.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE587268B@JPYOKXMS103.jp.sony.com>
         <1552405047.21557.7.camel@suse.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE5873FFB@JPYOKXMS103.jp.sony.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE588EA40@JPYOKXMS103.jp.sony.com>
         <1553510086.2668.2.camel@suse.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE588FCC9@JPYOKXMS103.jp.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AE5419EAB4965843B3C0C1FE29F1FFE588FCC9@JPYOKXMS103.jp.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kento.A.Kobayashi@sony.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu
Cc: usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Do, 2019-03-28 at 07:53 +0000, Kento.A.Kobayashi@sony.com wrote:
> Hi,
> 
> > Sorry,
> > 
> > I thought this was clear. Your patch is making the assumption that the reset is triggered by the SCSI layer. You cannot make that assumption, as there is an ioctl for resetting a USB device.
> > In case we are getting an error during the reset (our endpoints vanish), the device driver must report that to the USB layer, so the driver will always be disconnected.
> > We cannot drop errors.
> > 
> > 	Regards
> > 		Oliver
> 
> This patch modified uas_post_reset to skip rebind operation to avoid exception while -ENODEV happens not drop error.
> If uas_post_reset happens -ENODEV, usb_reset_and_verify_device must happen error.
> So,when we use ioctl(USBDEVFS_RESET) to reset device, if usb_reset_and_verify_device happens error, the error will be reported through ioctl return value. 

OK, It is possible that I am stupid. We must rebind if uas_post_reset()
fails. The driver will crash without the endpoints. Can you please
explain again in greater detail, what you are trying to achieve?

	Regards
		Oliver
