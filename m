From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST
 sense to be retryable
Date: Tue, 6 Dec 2011 17:42:19 -0500
Message-ID: <20111206224218.GA31543@redhat.com>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
 <yq1zkf5pfx1.fsf@sermon.lab.mkp.net>
 <20111206212704.GB30719@redhat.com>
 <yq1vcptpdch.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab1LFWm1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Dec 2011 17:42:27 -0500
Content-Disposition: inline
In-Reply-To: <yq1vcptpdch.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

On Tue, Dec 06 2011 at  5:03pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Regardless, shouldn't the SCSI midlayer classify such
> Mike> ILLEGAL_REQUEST sense, with an add. sense I listed in the patch,
> Mike> as a target error?
> 
> Well, even SUCCESS should cause the I/O to be aborted.

As I replied to James, yes SUCCESS does cause the IO to fail, but the
discard gets retried by multipath.

Returning TARGET_ERROR enables the block layer to return -EREMOTEIO
which multipath will immediately pass up (rather than the normal fail
path and retry).
 
> I assume this is the RHEL6 kernel? Did you backport my provisioning
> updates that brings the heuristics in sync with SBC-3 (#c98a0e)?

Yes, that update was pulled in to RHEL6.2 (released today).  But this
issue is a concern for both upstream and RHEL6 (and any other distro
with a recent kernel).
