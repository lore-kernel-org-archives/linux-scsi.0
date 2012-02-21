From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re: Write same support]
Date: Mon, 20 Feb 2012 22:57:26 -0500
Message-ID: <yq1pqd825zt.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<20120216200202.GA27311@redhat.com>
	<20120216210301.GA27404@redhat.com>
	<yq139a55rhr.fsf@sermon.lab.mkp.net>
	<20120220184623.GA29931@redhat.com>
	<20120220234410.GC31853@redhat.com>
	<yq1k43h2gm9.fsf@sermon.lab.mkp.net> <20120221031854.GA468@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20677 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2BUD5r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 22:57:47 -0500
In-Reply-To: <20120221031854.GA468@redhat.com> (Mike Snitzer's message of
	"Mon, 20 Feb 2012 22:18:55 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

Mike> One, thing I noticed: bio_has_data returns false for
Mike> REQ_WRITE_SAME.  But REQ_WRITE_SAME does have data, and it really
Mike> should be accounted no?:

I decided against it. We don't count discards either and write sames are
not really page-out types of activity. Happy to change it if people
think this is something we should handle. But what do we actually count?
A single logical block or the number of sectors written by the target
device?


Mike> That aside, I tried your updated code and hit this BUG when I use
Mike> the patch that has always worked (my dm-thin patch that uses the
Mike> blkdev_issue_write_same() interface):

Mike> ------------[ cut here ]------------ kernel BUG at
Mike> drivers/scsi/scsi_lib.c:1116!

That's the

                BUG_ON(!req->nr_phys_segments);

in scsi_setup_blk_pc_cmnd(). We set nr_phys_segments to bi_phys_segments
just before calling that function. So how did you end up with a
zero-segment bio?

PS. I was unsuccessful in getting the thinp test suite working. If you
can come up with a simpler way for me to get DM to issue a write same
then please share...

-- 
Martin K. Petersen	Oracle Linux Engineering
