From: "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Mon, 19 Jan 2015 01:45:50 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1501190139360.4837@tosh-p75a>
References: <Pine.LNX.4.44L0.1501051452440.1101-100000@iolanthe.rowland.org>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailbackend.panix.com ([166.84.1.89]:42990 "EHLO
	mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbASJpx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2015 04:45:53 -0500
In-Reply-To: <Pine.LNX.4.44L0.1501051452440.1101-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net


Sorry for taking so long to get back to you guys about this (the 3.19-rc series has been
problematic for me in a couple of areas, so I'd let it go for a while):

On Mon, 5 Jan 2015, Alan Stern wrote:

> The patch I posted sets a general limit of 32 MB for USB drives that
> don't have a quirk flag for a smaller limit.
> Kenneth, have you tried that patch?  Does it fix your problem?

No, it fails in the same way (applied to 3.19-rc5):

----
Jan 19 01:38:16 tosh-p75a kernel: [  268.606258] sd 5:0:0:0: [sdc] FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
Jan 19 01:38:16 tosh-p75a kernel: [  268.606262] sd 5:0:0:0: [sdc] CDB:
Jan 19 01:38:16 tosh-p75a kernel: [  268.606263] Write(10): 2a 00 0f e8 e0 40 00 3c 00 00
Jan 19 01:38:16 tosh-p75a kernel: [  268.606268] blk_update_request: I/O error, dev sdc, sector 2135360000
Jan 19 01:38:16 tosh-p75a kernel: [  268.839597] sd 5:0:0:0: [sdc] FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
Jan 19 01:38:16 tosh-p75a kernel: [  268.839603] sd 5:0:0:0: [sdc] CDB:
Jan 19 01:38:16 tosh-p75a kernel: [  268.839605] Write(10): 2a 00 0f e9 68 40 00 3c 00 00
Jan 19 01:38:16 tosh-p75a kernel: [  268.839615] blk_update_request: I/O error, dev sdc, sector 2135638528
<snip>
Jan 19 01:38:47 tosh-p75a kernel: [  300.103494] usb 2-4.2: reset SuperSpeed USB device number 3 using xhci_hcd
Jan 19 01:38:47 tosh-p75a kernel: [  300.115145] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880448c9bf00
Jan 19 01:38:47 tosh-p75a kernel: [  300.115150] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880448c9bf48
Jan 19 01:38:48 tosh-p75a kernel: [  300.443729] INFO: task kworker/u16:6:197 blocked for more than 30 seconds.
----

FWIW, my quick fix gets me going again:

----
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 6ed2cbe..3a10bf6 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -257,7 +257,8 @@ void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_
                       __func__, max_hw_sectors);
        }

-       limits->max_sectors = limits->max_hw_sectors = max_hw_sectors;
+       limits->max_sectors = limits->max_hw_sectors =
+               min_t(unsigned int, max_hw_sectors, 65535);
 }
 EXPORT_SYMBOL(blk_limits_max_hw_sectors);
----

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Silicon Valley
