From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: IO buffer alignment for block devices
Date: Tue, 14 Sep 2004 20:39:31 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409142016550.2490@kai.makisara.local>
References: <41459729.5060106@il.marvell.com> <1095084876.1762.8.camel@mulgrave>
 <4145B9DF.7020408@il.marvell.com> <1095089305.1762.73.camel@mulgrave>
 <Pine.LNX.4.58.0409131952170.4529@kai.makisara.local> <20040913190257.GD18883@suse.de>
 <Pine.LNX.4.58.0409132217370.1972@kai.makisara.local> <20040913202348.GH18883@suse.de>
 <Pine.LNX.4.58.0409132351210.1972@kai.makisara.local> <20040914074448.GK2336@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:20892 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S269461AbUINRjg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 13:39:36 -0400
In-Reply-To: <20040914074448.GK2336@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Saeed Bishara <Saeed.Bishara@il.marvell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 14 Sep 2004, Jens Axboe wrote:

> On Tue, Sep 14 2004, Kai Makisara wrote:
> > On Mon, 13 Sep 2004, Jens Axboe wrote:
> > 
...
> > On 20 Nov 2003 I posted to linux-scsi and linux-usb-development the 
> > following results:
> > -----------------------8<--------------------------------------------
> > Before implementing direct i/o, I made some measurements with the hardware
> > available. The tape drive was HP DDS-4 and computer dual PIII 700 MHz. The
> > results with a test program using well-compressible data (zeroes):
> > 
> > Buffer length 32768 bytes, 32768 buffers written (1024.000 MB, 1073741824 
> > bytes)
> > Variable block mode (writing 32768 byte blocks).
> > dio:
> > write: wall  60.436 user   0.015 (  0.0 %) system   0.485 (  0.8 %) speed 
> > 16.944 MB/s
> > read:  wall  64.580 user   0.014 (  0.0 %) system   0.500 (  0.8 %) speed 
> > 15.856 MB/s
> > no dio:
> > write: wall  61.373 user   0.024 (  0.0 %) system   2.897 (  4.7 %) speed 
> > 16.685 MB/s
> > read:  wall  66.435 user   0.055 (  0.1 %) system   6.347 (  9.6 %) speed 
> > 15.413 MB/s
> > 
> > The common high-end drives at that time streamed at 30-40 MB/s assuming
> > 2:1 compression. It meant that about 20 % of cpu was needed for extra
> > copies when reading. Other people reported even higher percentages with
> > other hardware.
> 
> Just tried 70MiB/sec on my test box, and it is going rather slowly with
> non direct io. So your numbers don't look all that bad. Pretty strange,
> I don't remember it being this bad. This is a profile from a forced
> unaligned 128KiB contig transfer from two SCSI disks, doing 40 and
> 30MiB/sec at the same time:
> 
>  89887 default_idle                             1404.4844
>  24357 __copy_to_user_ll                        217.4732
...
> For 512-byte reads, the results are comparable (aggregate bandwidth):
> 
> non-dio:
> 
>  91038 default_idle                             1422.4688
>   2843 __generic_unplug_device                   44.4219
>   3014 sym53c8xx_intr                            18.8375
>   1694 __copy_to_user_ll                         15.1250

Interesting results. I did tests also with other block sizes (8192 - 
131072 bytes) with that P3 system (VIA chipset). Looking at the notes now 
I can see the same trend: the system time percentage increases quite a lot 
when the block size gets larger!

I did similar tests with the P4 system. No trend was seen. The read/write 
system time balance changed a little but the averages were very close.

...
> > I just repeated the tests using the same drive but a 2.6 GHz PIV on a
> > Intel D875 motherboard and dual channel memory. The results were:
> > 
> > dio:
> > write: wall  58.668 user   0.013 (  0.0 %) system   0.217 (  0.4 %) speed  
> > 17.045 MB/s
> > read:  wall  63.425 user   0.011 (  0.0 %) system   0.245 (  0.4 %) speed  
> > 15.767 MB/s
> > no dio:
> > write: wall  58.713 user   0.017 (  0.0 %) system   0.534 (  0.9 %) speed  
> > 17.032 MB/s
> > read:  wall  63.265 user   0.020 (  0.0 %) system   0.805 (  1.3 %) speed  
> > 15.807 MB/s
> 
> That looks a lot closer to what I would expect - non-dio using a little
> more sys time at the same transfer rate, still a little high though. You
> must be doing something else differently as well. Are you transfer sizes
> as big for non-dio as with dio? Are you using sg for non-dio?
> 
The transfer sizes are the same. This is actually the only possibility 
with variable block mode. Sg is used for no-dio. However, the driver tries 
to allocate as large chunks of memory as it can get and the buffer 
probably consisted of only one sg segment with this block size.

...
> > I have not profiled the code. The st driver uses the same loop for direct 
> > and buffered transfers. The only difference is that in the buffered case 
> > the data is copied to/from the internal buffer before/after the SCSI 
> > transactions.
> 
> That's truly the only difference?
> 
Yes. Most of the code is checking results and updating status. This does 
not depend on how the data is transferred.

-- 
Kai
