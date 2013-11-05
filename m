From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Disk wakeup on resume
Date: Tue, 05 Nov 2013 10:56:08 -0500
Message-ID: <52791518.5070705@interlog.com>
References: <527859D9.3030607@ubuntu.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49759 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab3KEP4T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Nov 2013 10:56:19 -0500
In-Reply-To: <527859D9.3030607@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, linux-scsi@vger.kernel.org

On 13-11-04 09:37 PM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> I can not figure out what is waking up disks on resume from suspend.
> I thought it was sd.c, and setting manage_start_stop = 0 should stop
> that.  It does stop the message printed saying it is being started,
> yet the disk is still started, and this makes the resume take nearly
> 10 seconds.  So it seems sd_resume()'s attempt to start the disk is
> pointless and redundant, and something else is starting up the disk.
> Oddly, if I unbind the sd driver ( echo 1 >
> /sys/block/sdx/device/delete ), then after a resume the disk remains
> off ( and spins up again on rescan ).

I think that you might find that almost any SCSI
command (translated to its ATA equivalent command)
will wake up a SATA disk. Perhaps just this sequence:
   fd = open(<ata_bloc_device>) ; close(fd) ;
is sufficient.


Strange things do go on with SATA disks and the block
layer. smartmontools has problems spinning them down,
given:

# lsscsi -g
[6:0:1:0]  disk ATA ST3500418AS CC34  /dev/sdc /dev/sg2

Then:

# sg_start --stop /dev/sdc
# sg_turs /dev/sdc
# # No answer means ready, but I asked it to stop??

# sg_start --stop /dev/bsg/6:0:1:0
# sg_turs /dev/bsg/6:0:1:0
device not ready
# # Yes, that is what I expect from a TEST UNIT READY

So the above is accessing the same SATA disk via the block
layer then via the bsg pass-through. In both cases the disk
is asked to stop (spinning). The SCSI TEST UNIT READY command
is used to check the state of the disk. The request works
when sent via the pass-through (i.e. the bsg driver as shown
above or the sg driver (e.g. /dev/sg2)).

When sent via the block layer initially it works, until
you do a close() on the file handle that was used to
send the SCSI command (translated to the ATA equivalent
command). However when you do that close() the block layer
decides to access the disk and that access spins it up :-)
And there is a click sound from my SATA disk and I think:
that must be good for it.


BTW There were no mounts active on /dev/sdc . The above was
tested on lk 3.12.0 . Only SATA/ATA disks have this feature,
SCSI disks work as expected via the block layer or a
pass-through.

Also this test was with a decent SATL (mpt2sas) not with this
howler from drivers/ata/libata-scsi.c

         /* no-op's, complete with success */
         case REZERO_UNIT:
         case SEEK_6:
         case SEEK_10:
         case TEST_UNIT_READY:
                 ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
                 break;

Doug Gilbert

