From: Bruce Robson <bns_robson@hotmail.com>
Subject: PNP AHA-1542CP not working after upgrading kernel from 2.2.25 to
 2.4.20
Date: Sun, 29 Feb 2004 12:00:06 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4041D446.4060300@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080704010008020200070205"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail18.svr.pol.co.uk ([195.92.67.23]:23308 "EHLO
	mail18.svr.pol.co.uk") by vger.kernel.org with ESMTP
	id S262035AbUB2MBQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 07:01:16 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080704010008020200070205
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I've recently upgraded my kernel from 2.2.25 to 2.4.20.
After the upgrade, I was unable to use my ZIP 100 PLUS drive that
is attached to an Adaptec AHA-1542CP SCSI card.

The card is set to use PNP, the BIOS is set for non-PNP operating
systems and allocates resources to the card.

I did not have any PNP features in the old 2.2.25 kernel but built
the new 2.4.20 with the isapnp driver. In the new kernel
a)  the isapnp driver found the card
b)  the aha1542 driver logged the message
      "ISAPnP found an AHA1535 at I/O 0x330"
c)  the aha1542 driver did not log a message to say that it was
      "Configuring Adaptec".

I added printk statements to the aha1542 driver to find out why it
was not configuring the card and this made it do so. I did a few
experiments was different printk statements and concluded that the
AHA-1542CP needs a delay between when it is "PNP activated" and
when it is next accessed. I've now added a mdelay(100) statement
after activating the card and am able to use my ZIP drive.

I attach a diff -u of the changes I've made. As well as adding
the mdelay, I have left in one printk statement that I think
is useful.

After making my fix, I looked at the aha1542 driver for 2.6.1.
This has a number of changes to the PNP part of the driver. These
mainly appear to be due to changes to the interface to PNP in 2.6.1.
However it has a call to pnp_port_valid after doing the activation.
I presume this causes the driver to wait after activating the card.
i.e. It is a better way of achieving what I've achieved with the
mdelay statement.

Is it possible to either add my fix to 2.4 or for someone competent
in kernel hacking to implement a fix similar to that done in the
2.6 driver?


Bruce


--------------080704010008020200070205
Content-Type: text/plain;
 name="diff-u.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-u.txt"

--- aha1542.c.orig	Fri Oct 12 23:35:53 2001
+++ aha1542.c	Sat Feb 28 21:30:27 2004
@@ -23,6 +23,9 @@
  *        19-Jul-99
  *  Modified by Adam Fritzler <mid@auk.cx>
  *        Added proper detection of the AHA-1640 (MCA version of AHA-1540)
+ *  Modified by Bruce Robson <bns_robson@hotmail.com>
+ *        Added a delay after activating a PNP card (needed by AHA-1542CP)
+ *        28-Feb-04
  */
 
 #include <linux/config.h>
@@ -1174,6 +1177,10 @@
 			   the DMA set up that is enough */
 			   
 			printk(KERN_INFO "ISAPnP found an AHA1535 at I/O 0x%03X\n", bases[indx]);
+
+			/* aha1542_test_port fails for AHA-1542CP if we don't wait for the card */
+			/* n.b. In 2.6.1 the driver calls pnp_port_valid */
+			mdelay(100);	/* I've made no attempt to minimise this */
 		}
 	}
 	for (indx = 0; indx < sizeof(bases) / sizeof(bases[0]); indx++)
@@ -1189,8 +1196,10 @@
 				printk(KERN_ERR "Invalid address for shpnt with 1542.\n");
 				goto unregister;
 			}
-			if (!aha1542_test_port(bases[indx], shpnt))
+			if (!aha1542_test_port(bases[indx], shpnt)) {
+				printk(KERN_INFO "aha1542 probed 0x%03X, card not at this address\n", bases[indx]);
 				goto unregister;
+			}
 
 
 			base_io = bases[indx];


--------------080704010008020200070205--
