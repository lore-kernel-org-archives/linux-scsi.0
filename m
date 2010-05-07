From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: relax PAGE LENGTH check for thin provisioning UNMAP support
Date: Fri, 07 May 2010 00:52:50 -0400
Message-ID: <yq1r5lo71p9.fsf@sermon.lab.mkp.net>
References: <1273096203-3164-1-git-send-email-snitzer@redhat.com>
	<yq1sk65ejs5.fsf@sermon.lab.mkp.net>
	<w2o170fa0d21005060424j912e21bev8dba13536d49ba41@mail.gmail.com>
	<AC32D7C72530234288643DD5F1435D5309994F2A@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:62125 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0EGEzp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 May 2010 00:55:45 -0400
In-Reply-To: <AC32D7C72530234288643DD5F1435D5309994F2A@RTPMVEXC1-PRD.hq.netapp.com>
	(Frederick Knight's message of "Thu, 6 May 2010 10:27:43 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Knight, Frederick" <Frederick.Knight@netapp.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

>>>>> "Fred" == Knight, Frederick <Frederick.Knight@netapp.com> writes:

Fred,

Fred> There are no guarantees about what the T10 committee will do to
Fred> that page in the draft, or in any future versions of SBC.

Obviously.  However, we're usually pretty good at tracking the drafts
and have a pretty quick turnaround for changes.


Fred> In reality, any value > 32 (20h) will mean that you probably have
Fred> all the data you want to look at today.  YES, any device that puts
Fred> such a small value into the page length field is non-compliant
Fred> (and therefore, the contents of those fields may be non-compliant
Fred> as well).  So, allowing a value less than 3Ch would be risky.

Our main concern is that we're dealing with a ton of low-end devices
that violate the SCSI protocols in the weirdest ways.  Some return the
same blob of data regardless of which VPD page you ask for.  So when we
have a mandated value we can key off of as an extra safeguard we tend to
use it.

In this particular case it might not be such a big deal since we're
already gated by TPE being enabled in READ CAPACITY(16).  The latter is
currently restricted by the device server claiming compliance with SPC3
or better.  However, we may have to relax that criteria soon since we'll
have USB drives coming out where READ CAPACITY(10) won't cut it.  And
that opens the flood gates for random debris lingering at byte 12 and
beyond in READ CAPACITY(16).

My main concern with Mike's patch is that I think it's a bit premature
given that there's already room to grow in the current block limits VPD
and that relaxing the page length test could cause us to accept random
garbage as valid thin provisioning information.

-- 
Martin K. Petersen	Oracle Linux Engineering
