From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi-debug regression with 4.5-rc?
Date: Fri, 4 Mar 2016 10:24:09 -0500
Message-ID: <20160304152409.GA31358@redhat.com>
References: <1453303051.22112.110.camel@localhost.localdomain>
 <yq1powwp7l4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020AbcCDPYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2016 10:24:10 -0500
Content-Disposition: inline
In-Reply-To: <yq1powwp7l4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com

On Wed, Jan 20 2016 at 10:57am -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Ewan" == Ewan Milne <emilne@redhat.com> writes:
> 
> Ewan> So I have a report from our test people that the optimal_io_size
> Ewan> sysfs value is now different by a factor of 512 from what it used
> Ewan> to be...
> 
> Yes, just prepared a patch this morning. I messed up sectors vs. bytes.

Would your fix (commit d0eb20a863ba7dc) address this BZ too?
https://bugzilla.redhat.com/show_bug.cgi?id=1314687

Seems not, I think that BZ may be due to the LBPRZ clause in commit
397737223 ("sd: Make discard granularity match logical block size when LBPRZ=1") ?

should be: q->limits.discard_granularity = 1 * logical_block_size;

Mike
