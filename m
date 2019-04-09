From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Tue, 9 Apr 2019 12:45:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1904091232370.1599-100000@iolanthe.rowland.org>
References: <1554823007.161891.6.camel@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554823007.161891.6.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Kento.A.Kobayashi@sony.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, Oliver Neukum <oneukum@suse.com>, gregkh@linuxfoundation.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Jacky.Cao@sony.com, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 9 Apr 2019, Bart Van Assche wrote:

> On Tue, 2019-04-09 at 10:44 -0400, Alan Stern wrote:
> +AD4 On Mon, 8 Apr 2019, Martin K. Petersen wrote:
> +AD4 
> +AD4 +AD4 
> +AD4 +AD4 Alan,
> +AD4 +AD4 
> +AD4 +AD4 +AD4 So it looks as though the SCSI subsystem doesn't like to have a reset 
> +AD4 +AD4 +AD4 handler call scsi+AF8-remove+AF8-host.
> +AD4 +AD4 
> +AD4 +AD4 Are you talking about a PCI device removal handler or a SCSI error
> +AD4 +AD4 handler?
> +AD4 
> +AD4 The context of this discussion is a USB mass-storage device where the
> +AD4 device's port on its upstream hub has been powered off.  The
> +AD4 powered-off port causes an executing command to time out.  As a result
> +AD4 the SCSI error handler runs and calls the USB reset routine, but the
> +AD4 reset fails because the kernel is unable to communicate with the device
> +AD4 through the powered-off port.  This causes the USB reset routine to
> +AD4 unbind the device from its USB driver, which in turn calls
> +AD4 scsi+AF8-remove+AF8-host -- while the error handler is still running.
> 
> From which context does that unbind happen? From inside a SCSI EH callback
> or from the context of a workqueue? I think the former is not allowed but
> that the latter is allowed. The SRP initiator driver (ib+AF8-srp.c) follows the
> latter approach. See also srp+AF8-queue+AF8-remove+AF8-work().

The unbind happens from inside the SCSI EH callback.  If that really is
not allowed, we'll need to change it.  Or we can just change it
regardless, since the effort required is pretty small.

Kento, please try the patch below.  Does it help with your problem?

Alan Stern



Index: usb-4.x/drivers/usb/core/hub.c
===================================================================
--- usb-4.x.orig/drivers/usb/core/hub.c
+++ usb-4.x/drivers/usb/core/hub.c
@@ -5902,7 +5902,9 @@ int usb_reset_device(struct usb_device *
 					cintf->needs_binding = 1;
 			}
 		}
-		usb_unbind_and_rebind_marked_interfaces(udev);
+		/* If the reset failed, hub_wq will unbind drivers later */
+		if (ret == 0)
+			usb_unbind_and_rebind_marked_interfaces(udev);
 	}
 
 	usb_autosuspend_device(udev);
