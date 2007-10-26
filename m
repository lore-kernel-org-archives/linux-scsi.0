From: Rob Landley <rob@landley.net>
Subject: Questions about proc_scsi_write() in scsi_proc.c
Date: Fri, 26 Oct 2007 15:07:49 -0500
Message-ID: <200710261507.49284.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33658
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750924AbXJZTIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 15:08:34 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 60C9D7392C
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 15:11:17 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I don't understanding this code:

1) for echo "scsi add-single-device 0 1 2 3" > /proc/scsi/scsi, is this only 
for parallel scsi?  I thought most modern busses (usb, sata, FC, firewire, 
etc) dynamically assign these numbers and just use them as a unique 
identifier ala kdev_t.  How would this work on one of the other devices?

2) How do you trigger this?  /proc/scsi/scsi is read only even for root.

3) This bit is repeated in both the add and remove logic:
                p = buffer + 23;

                host = simple_strtoul(p, &p, 0);
                channel = simple_strtoul(p + 1, &p, 0);
                id = simple_strtoul(p + 1, &p, 0);
                lun = simple_strtoul(p + 1, &p, 0);

So what happens if you echo "scsi add-single-device 0" > /proc/scsi/scsi (or 
wherever file would trigger this function) so the read for channel skips over 
the null terminator (I'm assuming there is one) and reads who knows what?  Or 
what if instead of ending that with one 0, you end it with enough zeroes to 
pad right up to PAGE_SIZE, so it reads the next page?  (I don't even know 
what the page protections are on that, depends how 
__get_free_page(GFP_KERNEL) works...)

Confused,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
