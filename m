From: David Brownell <david-b@pacbell.net>
Subject: Re: Usb storage mounting was broken
Date: Wed, 22 Oct 2003 15:53:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F970A51.3060907@pacbell.net>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>	 <20031021175556.A8670@beaverton.ibm.com>	 <1066808944.3699.9.camel@ulysse.olympe.o2t> <3F969E04.6060801@pacbell.net>	 <1066837537.6960.3.camel@ulysse.olympe.o2t> <3F96AE64.5020305@pacbell.net>	 <1066845819.2806.11.camel@m70.net81-64-235.noos.fr>	 <3F96D00E.1080500@pacbell.net> <1066854786.3848.8.camel@m70.net81-64-235.noos.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010209040206090705040201"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtaw4.prodigy.net ([64.164.98.52]:1964 "EHLO mtaw4.prodigy.net")
	by vger.kernel.org with ESMTP id S261298AbTJVWuh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 18:50:37 -0400
In-Reply-To: <1066854786.3848.8.camel@m70.net81-64-235.noos.fr>
List-Id: linux-scsi@vger.kernel.org
To: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010209040206090705040201
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


>>And since this resembles an enumeration failure, it'd be good
>>to have the Alt-Sysrq-t output for "khubd".
> 
> In the report too (took me some time to remember it ended up in
> /var/log/messages, not only the current console)

That says to me "self-deadlock"; crept in recently.  It turns
out that routine already has all the locks it needs.  Try the
attached patch.

This is pretty far from being a mount problem ... no wonder I
kept expecting more info from you!

- Dave

--------------010209040206090705040201
Content-Type: text/plain;
 name="Diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Diff"

--- 1.37/drivers/usb/core/message.c	Tue Sep 23 11:18:09 2003
+++ edited/drivers/usb/core/message.c	Wed Oct 22 15:49:15 2003
@@ -1001,8 +1001,10 @@
 	int			i, retval;
 	struct usb_host_config	*config;
 
-	/* dev->serialize guards all config changes */
-	down(&dev->serialize);
+	/* caller must own dev->serialize (config won't change)
+	 * and the usb bus readlock (so driver bindings are stable);
+	 * so calls during probe() are fine
+	 */
 
 	for (i = 1; i < 16; ++i) {
 		usb_disable_endpoint(dev, i);
@@ -1016,7 +1018,7 @@
 			NULL, 0, HZ * USB_CTRL_SET_TIMEOUT);
 	if (retval < 0) {
 		dev->state = USB_STATE_ADDRESS;
-		goto done;
+		return retval;
 	}
 
 	dev->toggle[0] = dev->toggle[1] = 0;
@@ -1029,9 +1031,7 @@
 		intf->act_altsetting = 0;
 		usb_enable_interface(dev, intf);
 	}
-done:
-	up(&dev->serialize);
-	return (retval < 0) ? retval : 0;
+	return 0;
 }
 
 /**

--------------010209040206090705040201--


