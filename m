From: Jens Axboe <axboe@suse.de>
Subject: Re: IO buffer alignment for block devices
Date: Tue, 14 Sep 2004 09:44:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914074448.GK2336@suse.de>
References: <41459729.5060106@il.marvell.com> <1095084876.1762.8.camel@mulgrave> <4145B9DF.7020408@il.marvell.com> <1095089305.1762.73.camel@mulgrave> <Pine.LNX.4.58.0409131952170.4529@kai.makisara.local> <20040913190257.GD18883@suse.de> <Pine.LNX.4.58.0409132217370.1972@kai.makisara.local> <20040913202348.GH18883@suse.de> <Pine.LNX.4.58.0409132351210.1972@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:63184 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S269049AbUINHqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 03:46:22 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0409132351210.1972@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Saeed Bishara <Saeed.Bishara@il.marvell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 14 2004, Kai Makisara wrote:
> On Mon, 13 Sep 2004, Jens Axboe wrote:
> 
> > On Mon, Sep 13 2004, Kai Makisara wrote:
> > > On Mon, 13 Sep 2004, Jens Axboe wrote:
> > > 
> > > > On Mon, Sep 13 2004, Kai Makisara wrote:
> ...
> > > I agree. That is why I have not objected to the patch that changed the 
> > > default back to 512. That is why I reviewed sym53c8xx_2 and, to me, it 
> > > seemed safe to to try 8 byte alignment with this driver. The proper way is 
> > > to have safe default and let the LLDDs relax the alignment. The only 
> > > practical problem is how to get this done but we probably have to live 
> > > with this. Besides we were talking about SCSI.
> > 
> > This seemed to be a device problem, not an adapter problem.
> > 
> The tape drives at the other end of the SCSI cable don't have any 
> restrictions. The restrictions are at the computer end of the cable.

I'm talking about the specific ide-cd case.

> > I'm curious where the alignment is really documented, seems to be we are
> > stabbing in the dark.
> > 
> I have not seen any Linux documentation on the whole problem. The 
> requirements have to be determined case by case considering the whole data 
> path from the source to the target. The low-level driver (writer) should 
> know the requirements for the adapter but this should be combined with the 
> requirements coming from the i/o architecture of the computer. One might 
> design code where the low-level driver suggests an alignment that 
> architecture-dependent code then modifies if necessary.

I completely agree, and right now there are many bits and pieces missing
from that chain. Which is why we have to default to something a little
aggressive...

> > > > And finally (and most importantly), why do you care so much?
> > > 
> > > I do care because the non-bounced transfers give measurable decrease in 
> > > cpu time and bus use. And I don't like the situation where portable 
> > > software has to have special alignment code just for Linux when there is 
> > > no real technical reason for that. In practice, this code often does not 
> > > exist. Then the question is, why does writing to tape in Linux use, say, 
> > > 30 % CPU time when the same thing in xxx Unix uses 1 % CPU time.
> > 
> > Please share how you arrived at those numbers, if you get that bad
> > performance you are doing something horribly wrong elsewhere. Doing
> > 50MiB/sec single transfer from a hard drive with either bio_map_user()
> > or bio_copy_user() backing shows at most 1% sys time difference on a
> > dual P3-800MHz. How fast are these tape drives?
> > 
> On 20 Nov 2003 I posted to linux-scsi and linux-usb-development the 
> following results:
> -----------------------8<--------------------------------------------
> Before implementing direct i/o, I made some measurements with the hardware
> available. The tape drive was HP DDS-4 and computer dual PIII 700 MHz. The
> results with a test program using well-compressible data (zeroes):
> 
> Buffer length 32768 bytes, 32768 buffers written (1024.000 MB, 1073741824 
> bytes)
> Variable block mode (writing 32768 byte blocks).
> dio:
> write: wall  60.436 user   0.015 (  0.0 %) system   0.485 (  0.8 %) speed 
> 16.944 MB/s
> read:  wall  64.580 user   0.014 (  0.0 %) system   0.500 (  0.8 %) speed 
> 15.856 MB/s
> no dio:
> write: wall  61.373 user   0.024 (  0.0 %) system   2.897 (  4.7 %) speed 
> 16.685 MB/s
> read:  wall  66.435 user   0.055 (  0.1 %) system   6.347 (  9.6 %) speed 
> 15.413 MB/s
> 
> The common high-end drives at that time streamed at 30-40 MB/s assuming
> 2:1 compression. It meant that about 20 % of cpu was needed for extra
> copies when reading. Other people reported even higher percentages with
> other hardware.

Just tried 70MiB/sec on my test box, and it is going rather slowly with
non direct io. So your numbers don't look all that bad. Pretty strange,
I don't remember it being this bad. This is a profile from a forced
unaligned 128KiB contig transfer from two SCSI disks, doing 40 and
30MiB/sec at the same time:

 89887 default_idle                             1404.4844
 24357 __copy_to_user_ll                        217.4732
   512 __generic_unplug_device                    8.0000
   279 __free_pages                               3.4875
   291 sym53c8xx_intr                             1.8188
   137 blk_rq_unmap_user                          1.4271
   260 scsi_end_request                           1.2500
   210 blk_execute_rq                             1.0938
    17 free_hot_page                              1.0625

Compared to direct io:

118502 default_idle                             1851.5938
   138 __generic_unplug_device                    2.1562
    50 unlock_page                                1.5625
   117 sym53c8xx_intr                             0.7312
    37 set_page_dirty_lock                        0.3854
    30 set_page_dirty                             0.3750
    73 scsi_end_request                           0.3510
    49 __bio_unmap_user                           0.3403

For 512-byte reads, the results are comparable (aggregate bandwidth):

non-dio:

 91038 default_idle                             1422.4688
  2843 __generic_unplug_device                   44.4219
  3014 sym53c8xx_intr                            18.8375
  1694 __copy_to_user_ll                         15.1250
  1739 scsi_end_request                           8.3606
   779 blk_rq_unmap_user                          8.1146
   571 blk_run_queue                              7.1375

dio:

 92280 default_idle                             1441.8750
  2824 __generic_unplug_device                   44.1250
  2926 sym53c8xx_intr                            18.2875
  1608 scsi_end_request                           7.7308
   716 blk_rq_unmap_user                          7.4583
   566 blk_run_queue                              7.0750
  1284 blk_execute_rq                             6.6875


> I just repeated the tests using the same drive but a 2.6 GHz PIV on a
> Intel D875 motherboard and dual channel memory. The results were:
> 
> dio:
> write: wall  58.668 user   0.013 (  0.0 %) system   0.217 (  0.4 %) speed  
> 17.045 MB/s
> read:  wall  63.425 user   0.011 (  0.0 %) system   0.245 (  0.4 %) speed  
> 15.767 MB/s
> no dio:
> write: wall  58.713 user   0.017 (  0.0 %) system   0.534 (  0.9 %) speed  
> 17.032 MB/s
> read:  wall  63.265 user   0.020 (  0.0 %) system   0.805 (  1.3 %) speed  
> 15.807 MB/s

That looks a lot closer to what I would expect - non-dio using a little
more sys time at the same transfer rate, still a little high though. You
must be doing something else differently as well. Are you transfer sizes
as big for non-dio as with dio? Are you using sg for non-dio?

> > There's no questioning that bio_map_user() will be faster for larger
> > transfers (4kb and up, I'm guessing), but there's no way that you can
> > claim 30% sys time for a tape drive without backing that up. Where was
> > this time spent?
> > 
> I have not profiled the code. The st driver uses the same loop for direct 
> and buffered transfers. The only difference is that in the buffered case 
> the data is copied to/from the internal buffer before/after the SCSI 
> transactions.

That's truly the only difference?

> As you can see from the results and project from them, the system time 
> varies a lot depending on the hardware. The differences between the older 
> system and the newer system are surprisingly big but, if you look at 
> system architectures, the results are what you actually should expect.

Agree.

> I am not claiming that the cpu usage is in all cases significant with 
> buffered transfers. Just that there exist cases where it is significant 
> (big drive connected to a not very fast computer). This has motivated 
> doing the code. (And the fact that other Unices do this, too).

Sure.

> > You can't map 6MB into a single bio, but you can string them together if
> > you want such a big request.
> > 
> OK, I will look at that when I have time. The need for big requests comes 
> from reading existing tapes with multimegabyte blocks. A block has to be 
> read with a single SCSI read and this is why the request has to be so big 
> in these cases.

I understand.

-- 
Jens Axboe

