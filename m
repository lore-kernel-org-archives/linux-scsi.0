From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Thu, 16 Feb 2012 15:25:04 -0600
Message-ID: <4F3D7430.2080506@cs.wisc.edu>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com> <20120216200202.GA27311@redhat.com> <20120216210301.GA27404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59091 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab2BPVZS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2012 16:25:18 -0500
In-Reply-To: <20120216210301.GA27404@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com

On 02/16/2012 03:03 PM, Mike Snitzer wrote:
> On Thu, Feb 16 2012 at  3:02pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> FYI, I'll bounce a message detailing the iSCSI scatter-gather NULL
>> pointer I _always_ hit with dm-io issuing async WRITE_SAME.
> 
> I developed a patch for dm-io so that the new dm-thinp target can
> leverage your new WRITE SAME functionality for, hopefully, more
> efficient zeroing of the disk (see: dm-io-WRITE_SAME.patch at the end of
> the following patchset).
> 
> Here is the patchset I'm using ontop of Linux 3.2:
> http://people.redhat.com/msnitzer/patches/upstream/dm-io-WRITE_SAME/series.html
> 
> All works great on FC (tested against NetApp 3040 LUN)... I'm using the
> thinp-test-suite to test dm-thinp's use of dm_kcopyd_zero().
> 
> But testing with iSCSI, I get a NULL pointer _every_ time in the iSCSI
> scatter-gather code, see:
> http://people.redhat.com/msnitzer/patches/upstream/dm-io-WRITE_SAME/async-WRITE_SAME-makes-iscsi-sg-die.txt
> -- in the middle of that file you'll see my 'crash' analysis of the
> issue -- but that is just the NULL pointer.. no idea what the smoking
> gun is that caused the iscsi_segment to become NULL.
> 
> Anyway, taking a step back... WRITE SAME is all about transfering a
> single logical block, backed by a single empty_zero_page in this test
> case, so I'm wondering if for some reason iSCSI's sg code is getting
> confused and thinking that more pages need to be transferred than were
> in the original bio's payload (but iSCSI is way beneath the bio -> SCSI
> command translation... grr)

Yeah, probably a request/scsi_cmnd/sg sector/length/offset value is off
or iscsi is making a bad assumption.

Do:

echo 1 > /sys/module/libiscsi/parameters/debug_libiscsi_session
echo 1 > /sys/module/libiscsi/parameters/debug_libiscsi_session
echo 1 > /sys/module/libiscsi_tcp/parameters/debug_libiscsi_tcp
echo 1 > /sys/module/libiscsi_tcp/parameters/iscsi_tcp

then rerun your test.
