From: Mike Snitzer <snitzer@redhat.com>
Subject: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re: Write
 same support]
Date: Thu, 16 Feb 2012 16:03:01 -0500
Message-ID: <20120216210301.GA27404@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <20120216200202.GA27311@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab2BPVDO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2012 16:03:14 -0500
Content-Disposition: inline
In-Reply-To: <20120216200202.GA27311@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu

On Thu, Feb 16 2012 at  3:02pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> FYI, I'll bounce a message detailing the iSCSI scatter-gather NULL
> pointer I _always_ hit with dm-io issuing async WRITE_SAME.

I developed a patch for dm-io so that the new dm-thinp target can
leverage your new WRITE SAME functionality for, hopefully, more
efficient zeroing of the disk (see: dm-io-WRITE_SAME.patch at the end of
the following patchset).

Here is the patchset I'm using ontop of Linux 3.2:
http://people.redhat.com/msnitzer/patches/upstream/dm-io-WRITE_SAME/series.html

All works great on FC (tested against NetApp 3040 LUN)... I'm using the
thinp-test-suite to test dm-thinp's use of dm_kcopyd_zero().

But testing with iSCSI, I get a NULL pointer _every_ time in the iSCSI
scatter-gather code, see:
http://people.redhat.com/msnitzer/patches/upstream/dm-io-WRITE_SAME/async-WRITE_SAME-makes-iscsi-sg-die.txt
-- in the middle of that file you'll see my 'crash' analysis of the
issue -- but that is just the NULL pointer.. no idea what the smoking
gun is that caused the iscsi_segment to become NULL.

Anyway, taking a step back... WRITE SAME is all about transfering a
single logical block, backed by a single empty_zero_page in this test
case, so I'm wondering if for some reason iSCSI's sg code is getting
confused and thinking that more pages need to be transferred than were
in the original bio's payload (but iSCSI is way beneath the bio -> SCSI
command translation... grr)

It should be noted that using your synchronous blkdev_issue_write_same()
interface works fine on the same iSCSI LUN (again NetApp 3040 LUN):
http://people.redhat.com/msnitzer/patches/upstream/dm-io-WRITE_SAME/dm-thin-use-WRITE_SAME-for-zeroing.patch
(but an dm-thinp really wants an async interface for zeroing).

Mike

p.s.
dm-io-WRITE_SAME.patch's use of dp->get_page()+bio_add_page()
accomplishes the same bio init as you do in blkdev_issue_write_same():

      bio->bi_vcnt = 1;
      bio->bi_phys_segments = 1;
      bio->bi_io_vec->bv_page = virt_to_page(empty_zero_page);
      bio->bi_io_vec->bv_offset = offset_in_page(empty_zero_page);
      bio->bi_io_vec->bv_len = logical_block_size;
