From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re: Write same support]
Date: Tue, 21 Feb 2012 14:56:34 -0500
Message-ID: <yq18vjw0xl9.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<20120216200202.GA27311@redhat.com>
	<20120216210301.GA27404@redhat.com>
	<yq139a55rhr.fsf@sermon.lab.mkp.net>
	<20120220184623.GA29931@redhat.com>
	<20120220234410.GC31853@redhat.com>
	<yq1k43h2gm9.fsf@sermon.lab.mkp.net> <20120221031854.GA468@redhat.com>
	<yq1pqd825zt.fsf@sermon.lab.mkp.net> <20120221065504.GB468@redhat.com>
	<20120221194717.GF21618@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:42821 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab2BUT4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2012 14:56:49 -0500
In-Reply-To: <20120221194717.GF21618@redhat.com> (Vivek Goyal's message of
	"Tue, 21 Feb 2012 14:47:17 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> First we returned "false" from bio_has_data() and skipped above
Vivek> assignment, in blk_rq_bio_prep() and now we are trying to make up
Vivek> for it.

Vivek> Maybe returning false from bio_has_data() for WRITE_SAME is not
Vivek> such a good idea because this bio has one logical block of data.

bio_has_data() is used for two different things. In my current tree I
split it up into bio_has_data() and bio_is_rw().

But given Mike's merge observation I think I'll take a step back and see
if I can come up with a better way to handle these
REQ_I_CANT_BELIEVE_ITS_NOT_FS requests in general. I really don't want
to have all the special cases scattered all over the place.

-- 
Martin K. Petersen	Oracle Linux Engineering
