From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re: Write same support]
Date: Tue, 21 Feb 2012 07:31:53 -0500
Message-ID: <yq1linw1i6e.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<20120216200202.GA27311@redhat.com>
	<20120216210301.GA27404@redhat.com>
	<yq139a55rhr.fsf@sermon.lab.mkp.net>
	<20120220184623.GA29931@redhat.com>
	<20120220234410.GC31853@redhat.com>
	<yq1k43h2gm9.fsf@sermon.lab.mkp.net> <20120221031854.GA468@redhat.com>
	<yq1pqd825zt.fsf@sermon.lab.mkp.net> <20120221065504.GB468@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49620 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2BUMcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2012 07:32:10 -0500
In-Reply-To: <20120221065504.GB468@redhat.com> (Mike Snitzer's message of
	"Tue, 21 Feb 2012 01:55:04 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> This patch fixed the issue for me (though I'm still missing why
Mike> bio->bi_phys_segments was 0 given blkdev_issue_write_same() sets
Mike> it):

Ok, I see what's going on. You have your own dm-specific make request
function. When cloning the original bio phys_segments isn't carried
over. And that's why we see 0 in sd.

For discard this is not a problem because we hardwire things in sd.c
regardless of what was passed down. And besides you have special
handling for mapping discards in DM.

I was trying to avoid perpetuating Christoph's horrible hack (his words,
not mine). But maybe it's better to do it the same way as for discard so
we only have to have to deal with pure evil in one place.

I'll contemplate a bit...


PS. The good news is that your async stuff works when I set phys_segs to
1 in sd.

-- 
Martin K. Petersen	Oracle Linux Engineering
