From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/7] block: Clean up merge logic
Date: Tue, 06 Mar 2012 12:42:46 -0500
Message-ID: <yq1ty21lj6x.fsf@sermon.lab.mkp.net>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
	<1330658571-12958-2-git-send-email-martin.petersen@oracle.com>
	<20120302202139.GG26315@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:23805 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2CFRnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 12:43:04 -0500
In-Reply-To: <20120302202139.GG26315@redhat.com> (Vivek Goyal's message of
	"Fri, 2 Mar 2012 15:21:39 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> So in this patch bio_is_rw() == bio_is_data(). Do they diverge in
Vivek> later patches?

Yep.


Vivek> Some of the flags in REQ_NOMERGE_FLAGS are rq only and should not
Vivek> be used on bio. For example REQ_NOMERGE and REQ_STARTED.

Right, but even if the caller passed down invalid flags they'd be masked
off when we create the request.


Vivek> Will it be better to define BIO_NOMERGE_FLAGS separately?

I'd rather not have things defined two places. That leads us down the
path to the mess we have now.

However, I don't have a problem with doing:

#define BIO_NOMERGE_FLAGS (REQ_NOMERGE_FLAGS & REQ_COMMON_MASK)

-- 
Martin K. Petersen	Oracle Linux Engineering
