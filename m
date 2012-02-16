From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Wed, 15 Feb 2012 22:29:17 -0500
Message-ID: <yq1fwebbgmq.fsf@sermon.lab.mkp.net>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
	<1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
	<20120207214005.GG6346@redhat.com>
	<yq1hayugyv4.fsf@sermon.lab.mkp.net>
	<20120215153319.GA27312@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:41319 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab2BPD32 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2012 22:29:28 -0500
In-Reply-To: <20120215153319.GA27312@redhat.com> (Vivek Goyal's message of
	"Wed, 15 Feb 2012 10:33:19 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek,

Vivek> Mike Snitzer mentioned that we do allow merging of one discard
Vivek> request with another except following two cases.

It's allowed by virtue of being marked mergeable. This goes back to the
very first attempt we had a discard support. But we don't actually
support merging of discard requests. The merge checks were just never
updated to reflect this.

I'm also trying to get rid of all the REQ_DISCARD special cases. Soon
we'll have REQ_WRITE_SAME and REQ_COPY to worry about as well and the
same rules apply to them. So I'm trying to leverage Tejun's recent
cleanup to consolidate the merge checks.


>> - if (rq->cmd_type == REQ_TYPE_FS ||
>> - (rq->cmd_flags & REQ_DISCARD)) {
>> + if (rq->cmd_type == REQ_TYPE_FS) {

Vivek> This is orthogonal to merging?

REQ_DISCARD is REQ_TYPE_FS so the check is redundant.


>> break; case ELEVATOR_INSERT_SORT:
>> - BUG_ON(rq->cmd_type != REQ_TYPE_FS &&
>> - !(rq->cmd_flags & REQ_DISCARD));
>> + BUG_ON(rq->cmd_type != REQ_TYPE_FS);

Vivek> This change also looks orthogonal to merging. Will it not trigger
Vivek> BUG_ON() when DISCARD request is being inserted into the
Vivek> elevator?

I thought the same thing. But I was unable to trigger it.

-- 
Martin K. Petersen	Oracle Linux Engineering
