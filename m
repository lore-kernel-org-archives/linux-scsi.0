From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and
 usb-storage
Date: Thu, 20 Nov 2003 21:23:10 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0311201959210.2302@kai.makisara.local>
References: <20031120065353.GW1106@suse.de> <Pine.LNX.4.44L0.0311201015030.878-100000@ida.rowland.org>
 <20031120153026.GB1106@suse.de> <200311201728.51200.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:41442 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262986AbTKTTXM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 14:23:12 -0500
In-Reply-To: <200311201728.51200.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Thu, 20 Nov 2003, Oliver Neukum wrote:

...
> But neither sg nor st currently honor the 512 byte alignment requirement.
> Whether this really hurts st in terms of performance is another question.
>
It depends on hardware :-)

Before implementing direct i/o, I made some measurements with the hardware
available. The tape drive was HP DDS-4 and computer dual PIII 700 MHz. The
results with a test program using well-compressible data (zeroes):

Buffer length 32768 bytes, 32768 buffers written (1024.000 MB, 1073741824 bytes)
Variable block mode (writing 32768 byte blocks).
dio:
write: wall  60.436 user   0.015 (  0.0 %) system   0.485 (  0.8 %) speed 16.944 MB/s
read:  wall  64.580 user   0.014 (  0.0 %) system   0.500 (  0.8 %) speed 15.856 MB/s
no dio:
write: wall  61.373 user   0.024 (  0.0 %) system   2.897 (  4.7 %) speed 16.685 MB/s
read:  wall  66.435 user   0.055 (  0.1 %) system   6.347 (  9.6 %) speed 15.413 MB/s

The common high-end drives at that time streamed at 30-40 MB/s assuming
2:1 compression. It meant that about 20 % of cpu was needed for extra
copies when reading. Other people reported even higher percentages with
other hardware.

I just repeated the tests using the same drive but a 2.6 GHz PIV on a
Intel D875 motherboard and dual channel memory. The results were:

dio:
write: wall  58.668 user   0.013 (  0.0 %) system   0.217 (  0.4 %) speed  17.045 MB/s
read:  wall  63.425 user   0.011 (  0.0 %) system   0.245 (  0.4 %) speed  15.767 MB/s
no dio:
write: wall  58.713 user   0.017 (  0.0 %) system   0.534 (  0.9 %) speed  17.032 MB/s
read:  wall  63.265 user   0.020 (  0.0 %) system   0.805 (  1.3 %) speed  15.807 MB/s

Current ordinary drives stream up to 70 MB/s (assuming 2:1 compression).
This would lead to over 5 % overhead per drive when not doing dio.

-- 
Kai
