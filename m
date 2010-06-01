From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 1 Jun 2010 15:50:59 +0200
Message-ID: <20100601135059.GA21008__26930.0524415032$1275400346$gmane$org@schmichrtp.mainz.de.ibm.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <1275318102.2823.47.camel@mulgrave.site>
 <4C03D5FD.3000202@panasas.com>
 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
 <20100601130325.GG8980@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:58385 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab0FANvB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 09:51:01 -0400
Content-Disposition: inline
In-Reply-To: <20100601130325.GG8980@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vg

On Tue, Jun 01, 2010 at 09:03:25AM -0400, Chris Mason wrote:
> On Tue, Jun 01, 2010 at 12:30:42PM +0200, Christof Schmitt wrote:
> > On Mon, May 31, 2010 at 06:30:05PM +0300, Boaz Harrosh wrote:
> > > On 05/31/2010 06:01 PM, James Bottomley wrote:
> > > > On Mon, 2010-05-31 at 10:20 -0400, Martin K. Petersen wrote:
> > > >>>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> > > >>
> > > >> Christof> Since the guard tags are created in Linux, it seems that the
> > > >> Christof> data attached to the write request changes between the
> > > >> Christof> generation in bio_integrity_generate and the call to
> > > >> Christof> sd_prep_fn.
> > > >>
> > > >> Yep, known bug.  Page writeback locking is messed up for buffer_head
> > > >> users.  The extNfs folks volunteered to look into this a while back but
> > > >> I don't think they have found the time yet.
> > > >>
> > > >>
> > > >> Christof> Using ext3 or ext4 instead of ext2 does not show the problem.
> > > >>
> > > >> Last I looked there were still code paths in ext3 and ext4 that
> > > >> permitted pages to be changed during flight.  I guess you've just been
> > > >> lucky.
> > > > 
> > > > Pages have always been modifiable in flight.  The OS guarantees they'll
> > > > be rewritten, so the drivers can drop them if it detects the problem.
> > > > This is identical to the iscsi checksum issue (iscsi adds a checksum
> > > > because it doesn't trust TCP/IP and if the checksum is generated in
> > > > software, there's time between generation and page transmission for the
> > > > alteration to occur).  The solution in the iscsi case was not to
> > > > complain if the page is still marked dirty.
> > > > 
> > > 
> > > And also why RAID1 and RAID4/5/6 need the data bounced. I wish VFS
> > > would prevent data writing given a device queue flag that requests
> > > it. So all these devices and modes could just flag the VFS/filesystems
> > > that: "please don't allow concurrent writes, otherwise I need to copy data"
> > > 
> > > From what Chris Mason has said before, all the mechanics are there, and it's
> > > what btrfs is doing. Though I don't know how myself?
> > 
> > I also tested with btrfs and invalid guard tags in writes have been
> > encountered as well (again in 2.6.34). The only difference is that no
> > error was reported to userspace, although this might be a
> > configuration issue.
> 
> This would be a btrfs bug.  We have strict checks in place that are
> supposed to prevent buffers changing while in flight.  What was the
> workload that triggered this problem?

I am running an internal test tool that creates files with a known
pattern until the disk is full, reads the data to verify if the
pattern is still intact, removes the files and starts over.

# uname -r
2.6.34

# mkfs.btrfs /dev/sda

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sda
        nodesize 4096 leafsize 4096 sectorsize 4096 size 8.00GB
Btrfs Btrfs v0.19
    
# mount /dev/sda /mnt/esslv0/

The kernel log shows:

Jun  1 11:11:53 R78_4E19_ESAME26_40_1 kernel: device fsid d260dc729d784bf0-9d097091e01ec932 devid 1 transid 7 /dev/sda
Jun  1 11:23:26 R78_4E19_ESAME26_40_1 kernel: no space left, need 4096, 0 delalloc bytes, 7701659648 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 7701659648 total 

I guess this is to be expected, since the test tool keeps writing
until there is no space left.

Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd tag mismatch, lba 0x12480, dif tag c8c0, computed tag dbe0
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd tag mismatch, lba 0x12480, dif tag 51d, computed tag 5861
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd tag mismatch, lba 0x12480, dif tag 3693, computed tag c52e
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd tag mismatch, lba 0x12480, dif tag ff8a, computed tag 4ac3
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd tag mismatch, lba 0x12480, dif tag b337, computed tag 3840
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd tag mismatch, lba 0x12480, dif tag fbed, computed tag 746a
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd tag mismatch, lba 0x12480, dif tag 2bfc, computed tag 263e
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd tag mismatch, lba 0x12480, dif tag c0a4, computed tag 3942

This is the output from my debug patch where i see the mismatch
between the data and the provided guard tags in the block integrity
data.

Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd 0:0:13:1077952528: [sda] Host Data Integrity Failure
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd 0:0:13:1077952528: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd 0:0:13:1077952528: [sda] Sense Key : Illegal Request [current] [descriptor]
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd 0:0:13:1077952528: [sda] Add. Sense: Logical block guard check failed
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: sd 0:0:13:1077952528: [sda] CDB: Write(10): 2a 20 00 01 24 80 00 00 08 00
Jun  1 11:25:10 R78_4E19_ESAME26_40_1 kernel: end_request: I/O error, dev sda, sector 74880

As expected, the controller detects the checksum mismatch in the same
request and this is reported as an error for the request. But the
running application is not affected.

I can start this again to get more data, but for now, this is what i
see.

--
Christof Schmitt
