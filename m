From: Rask Ingemann Lambertsen <rask@sygehus.dk>
Subject: Using ncr53c8xx.c for a 53c770 chip (Was: State of NCR53c7xx based drivers)
Date: Tue, 13 Jan 2004 14:55:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040113145553.A1738@sygehus.dk>
References: <20031122113834.GA8098@lst.de> <20031123175041.A1461@sygehus.dk> <1069606797.2066.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0x50a17253.albnxx15.adsl-dhcp.tele.dk ([80.161.114.83]:38148
	"EHLO 0x50a17253.albnxx15.adsl-dhcp.tele.dk") by vger.kernel.org
	with ESMTP id S264300AbUAMN4D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2004 08:56:03 -0500
Content-Disposition: inline
In-Reply-To: <1069606797.2066.2.camel@mulgrave>; from James.Bottomley@steeleye.com on Sun, Nov 23, 2003 at 10:59:55AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, Nov 23, 2003 at 10:59:55AM -0600, James Bottomley wrote:

> The driver for the 53c720 and 53c770 is the ncr53c8xx---I know, wrong
> name, but it's had all the 8xx PCI guts removed.  It now handles the
> 53c720 chips in both the zalon (parisc based) and NCRQ720 (MCA based)
> boards.  It should be fairly easy to use this for amiga stuff.

That's only for the 2.6.x kernels, isn't it?

I need some help filling in the ncr_chip structure. Where do I find the
device_id, revision_id, burst_max, nr_divisor and features settings? I can
figure some of it out:
.offset_max = 15 (the maximum allowed by the AmigaOS driver).
.features = FE_ULTRA | FE_WIDE | FE_RAM (but maybe more flags are needed?)

I also need some help filling in the ncr_slot structure. The registers are
memory mapped at bus address 0xf40000 and the script RAM is memory mapped at
bus address 0xf41000. So I guess base is for the registers, base2 is for
the script RAM and that *_v is for the virtual memory addresses of the above.
That still leaves me with io_port, base_c, base2_c and base_io.

Where do I tell the driver about the SCSI clock (50 MHz)?

-- 
Regards,
Rask Ingemann Lambertsen
