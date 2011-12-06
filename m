From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST
 sense to be retryable
Date: Tue, 6 Dec 2011 16:27:04 -0500
Message-ID: <20111206212704.GB30719@redhat.com>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
 <yq1zkf5pfx1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab1LFV1O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Dec 2011 16:27:14 -0500
Content-Disposition: inline
In-Reply-To: <yq1zkf5pfx1.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

On Tue, Dec 06 2011 at  4:07pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Thin provisioned LUNs from multiple array vendors have failed
> Mike> WRITE SAME(16) w/ UNMAP bit set with ILLEGAL_REQUEST sense.
> 
> Can you share what these arrays are returning in block limits and the
> logical block provisioning VPD? It sounds like they are returning
> inconsistent data causing us to issue the wrong command...

I don't have that info.  But I can ask for it.

In the first instance the array had discard alignment constraints
(needed to be a multiple of 4k, vendor has since relaxed that).  For the
second case, the reason for why the array failed the CDB hasn't been
shared yet (other than it was an "Invalid field in cdb").

Regardless, shouldn't the SCSI midlayer classify such ILLEGAL_REQUEST
sense, with an add. sense I listed in the patch, as a target error?
