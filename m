From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Sun, 18 May 2003 16:46:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC81B67.2040807@pacbell.net>
References: <Pine.LNX.4.44L0.0305181429170.29233-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_OT3xKQucxusPsb6Lf/n6Mg)"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta6.snfc21.pbi.net ([206.13.28.240]:64456 "EHLO
	mta6.snfc21.pbi.net") by vger.kernel.org with ESMTP id S262270AbTERXgD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 May 2003 19:36:03 -0400
Received: from pacbell.net ([67.118.247.99])
 by mta6.snfc21.pbi.net (iPlanet Messaging Server 5.1 HotFix 1.6 (built Oct 18
 2002)) with ESMTP id <0HF3007JFWTKZW@mta6.snfc21.pbi.net> for
 linux-scsi@vger.kernel.org; Sun, 18 May 2003 16:48:59 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Florin Iucha <florin@iucha.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_OT3xKQucxusPsb6Lf/n6Mg)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Alan Stern wrote:
> On Sat, 17 May 2003, David Brownell wrote:
> 
> 
>>That reset couldn't re-assign the address, so of course it failed.
>>
>>In hub.c, usb_physical_reset_device() is leaving dev->state as
>>USB_STATE_CONFIGURED after resetting the port, and of course it's
>>not legal to set the address of a device in that state.
> 
> 
> Do you mean to say that this is a bug in usb_reset_device()?  Isn't it 
> always going to be true that after a port reset a device will need to be 
> assigned an address?

No; yes.  What I mean is that something like this patch
would seem to be needed, so USB_STATE_DEFAULT ("needs an
address") is set when the reset completes.  Untested, but
it compiles.

The enumeration logic still relies on hidden side effects.

- Dave



--Boundary_(ID_OT3xKQucxusPsb6Lf/n6Mg)
Content-type: text/plain; name=Diff
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=Diff

--- 1.99/drivers/usb/core/hub.c	Mon Apr 21 10:47:47 2003
+++ edited/drivers/usb/core/hub.c	Sun May 18 16:31:02 2003
@@ -737,6 +737,9 @@
 		if (status != -1) {
 			usb_clear_port_feature(hub,
 				port + 1, USB_PORT_FEAT_C_RESET);
+			dev->state = status
+					? USB_STATE_NOTATTACHED
+					: USB_STATE_DEFAULT;
 			return status;
 		}
 
--- 1.204/drivers/usb/core/usb.c	Sun May  4 23:49:53 2003
+++ edited/drivers/usb/core/usb.c	Sun May 18 16:32:19 2003
@@ -1018,7 +1018,6 @@
 	dev->dev.dma_mask = parent->dma_mask;
 
 	/* it's not usable yet */
-	dev->state = USB_STATE_DEFAULT;
 
 	/* USB 2.0 section 5.5.3 talks about ep0 maxpacket ...
 	 * it's fixed size except for full speed devices.

--Boundary_(ID_OT3xKQucxusPsb6Lf/n6Mg)--
