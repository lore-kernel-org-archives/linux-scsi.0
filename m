From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Potential out-of-bounds access in drivers/scsi/sd.c
Date: Wed, 4 Sep 2013 10:32:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309041030420.1186-100000@iolanthe.rowland.org>
References: <CACT4Y+bt9weet_0DxfX3s=_xnxBGZjMG0gF7vea+8psov+ky8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51401 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762603Ab3IDOcQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2013 10:32:16 -0400
In-Reply-To: <CACT4Y+bt9weet_0DxfX3s=_xnxBGZjMG0gF7vea+8psov+ky8w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: linux-scsi@vger.kernel.org, richard@r-senior.demon.co.uk, ltuikov@yahoo.com, jbottomley@parallels.com, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>

On Wed, 4 Sep 2013, Dmitry Vyukov wrote:

> Hi,
> 
> We are working on a memory error detector AddressSanitizer for Linux
> kernel (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel),
> it can detect use-after-free and buffer-overflow errors.

...

> The code in sd_read_cache_type does the following:
> 
> while (offset < len) {
> ...
> }
> ...
> if ((buffer[offset] & 0x3f) != modepage) {
>     sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
>     goto defaults;
> }
> 
> When control leaves the while loop, offset >= len, so buffer[offset]
> reads random garbage out-of-bounds.
> It the worst case it can lead to crash, or if (buffer[offset] & 0x3f)
> happen to be == modepage, then it will read more garbage.
> 
> Please help validate and triage this.

The tool's output is correct.  The patch below should fix it.

Alan Stern



Index: usb-3.11/drivers/scsi/sd.c
===================================================================
--- usb-3.11.orig/drivers/scsi/sd.c
+++ usb-3.11/drivers/scsi/sd.c
@@ -2419,7 +2419,7 @@ sd_read_cache_type(struct scsi_disk *sdk
 			}
 		}
 
-		if (modepage == 0x3F) {
+		if (modepage == 0x3F || offset + 2 >= len) {
 			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
 				  "present\n");
 			goto defaults;

