From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm: Integrity errors should not cause failover
Date: Wed, 25 May 2011 11:04:58 -0400
Message-ID: <yq139k2akit.fsf@sermon.lab.mkp.net>
References: <yq18vu4fw9e.fsf@sermon.lab.mkp.net>
	<20110518121156.GB18433@redhat.com>
	<20110523181723.GA18971@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:62508 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1EYPFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2011 11:05:15 -0400
In-Reply-To: <20110523181723.GA18971@redhat.com> (Mike Snitzer's message of
	"Mon, 23 May 2011 14:17:24 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

Mike> Alasdair and I just chatted about this patch: it will always pass
Mike> the the -EILSEQ up _without_ performing any mpath path failure.

Correct.


Mike> The newfound concern is: is there ever a benefit to failing the
Mike> path before returning -EILSEQ?

No, never.


Mike> Or will -EILSEQ always imply there is nothing wrong with the path?
Mike> E.g. a transport error cannot cause a CRC error -- the transport
Mike> error is always trapped by SCSI and cannot result in continued
Mike> processing of an IO (that goes on to have CRC error)?

-EILSEQ is only returned if a discrepancy is detected between data and
protection information. In both cases the block in question was
successfully received by either initiator or target. I.e. the path is
working fine.

-- 
Martin K. Petersen	Oracle Linux Engineering
