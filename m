From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Thu, 16 Feb 2012 16:35:02 -0500
Message-ID: <20120216213502.GB29691@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <20120216200202.GA27311@redhat.com>
 <20120216210301.GA27404@redhat.com>
 <4F3D7430.2080506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab2BPVfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2012 16:35:18 -0500
Content-Disposition: inline
In-Reply-To: <4F3D7430.2080506@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: jaxboe@fusionio.com, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, device-mapper development <dm-devel@redhat.com>

On Thu, Feb 16 2012 at  4:25pm -0500,
Mike Christie <michaelc@cs.wisc.edu> wrote:

> On 02/16/2012 03:03 PM, Mike Snitzer wrote:
> > On Thu, Feb 16 2012 at  3:02pm -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> >> FYI, I'll bounce a message detailing the iSCSI scatter-gather NULL
> >> pointer I _always_ hit with dm-io issuing async WRITE_SAME.
> > 
> > I developed a patch for dm-io so that the new dm-thinp target can
> > leverage your new WRITE SAME functionality for, hopefully, more
> > efficient zeroing of the disk (see: dm-io-WRITE_SAME.patch at the end of
> > the following patchset).
> > 
> > Here is the patchset I'm using ontop of Linux 3.2:
> > http://people.redhat.com/msnitzer/patches/upstream/dm-io-WRITE_SAME/series.html
> > 
> > All works great on FC (tested against NetApp 3040 LUN)... I'm using the
> > thinp-test-suite to test dm-thinp's use of dm_kcopyd_zero().
> > 
> > But testing with iSCSI, I get a NULL pointer _every_ time in the iSCSI
> > scatter-gather code, see:
> > http://people.redhat.com/msnitzer/patches/upstream/dm-io-WRITE_SAME/async-WRITE_SAME-makes-iscsi-sg-die.txt
> > -- in the middle of that file you'll see my 'crash' analysis of the
> > issue -- but that is just the NULL pointer.. no idea what the smoking
> > gun is that caused the iscsi_segment to become NULL.
> > 
> > Anyway, taking a step back... WRITE SAME is all about transfering a
> > single logical block, backed by a single empty_zero_page in this test
> > case, so I'm wondering if for some reason iSCSI's sg code is getting
> > confused and thinking that more pages need to be transferred than were
> > in the original bio's payload (but iSCSI is way beneath the bio -> SCSI
> > command translation... grr)
> 
> Yeah, probably a request/scsi_cmnd/sg sector/length/offset value is off
> or iscsi is making a bad assumption.
> 
> Do:
> 
> echo 1 > /sys/module/libiscsi/parameters/debug_libiscsi_session
> echo 1 > /sys/module/libiscsi/parameters/debug_libiscsi_session
> echo 1 > /sys/module/libiscsi_tcp/parameters/debug_libiscsi_tcp
> echo 1 > /sys/module/libiscsi_tcp/parameters/iscsi_tcp
> 
> then rerun your test.

OK, will retry with all 4.. but just this caused the system to crap
itself:

echo 1 > /sys/module/libiscsi_tcp/parameters/debug_libiscsi_tcp

(I did this to turn on the ISCSI_DBG_TCP messages I noticed while
reviewing the code).

I saw a bunch of opcode 0x25 (READ CAPACITY) but never did see 0x93
(WRITE_SAME_16) come through.
