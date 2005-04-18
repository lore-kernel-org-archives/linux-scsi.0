From: Tejun Heo <htejun@gmail.com>
Subject: Re: Regarding posted scsi midlyaer patchsets
Date: Mon, 18 Apr 2005 23:58:46 +0900
Message-ID: <4263CB26.2070609@gmail.com>
References: <20050417224101.GA2344@htj.dyndns.org> <1113833744.4998.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.199]:47364 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262090AbVDRO66 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 10:58:58 -0400
Received: by rproxy.gmail.com with SMTP id j1so1006718rnf
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2005 07:58:55 -0700 (PDT)
In-Reply-To: <1113833744.4998.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>

 Hello, James.
 Hello, Jens.

James Bottomley wrote:
> On Mon, 2005-04-18 at 07:41 +0900, Tejun Heo wrote:
> 
>> As it's been almost a week since I posted scsi midlayer patchsets and
>>haven't heard anything yet, I've been wondering what's going on.  Are
>>they under review or all dropped?  If they are dropped, can you please
>>tell me why they are dropped?
> 
> 
> I have about four of them in the scsi-misc-2.6 tree, if you look.
> 
> Your request path rewrite I already gave you feedback that I didn't want
> REQ_SOFTBARRIER in scsi ... it needs to be in the block submit API for
> special requests.  Also, you have a patch for block in this code so I
> can't apply it without an ack from Jens.  And all the rest of your
> patches depend on this one.

 This thread started as an private inquiry to James regarding the status
of four patchsets I posted about a week ago.  I'm replying publicly as I
think we can use some discussion.  The four patchsets are... (in the
following order)

 * timer updates
 * REQ_SPECIAL/REQ_SOFTBARRIER usage change
 * scsi_request_fn reimpl
 * requeue path consolidation.

 Accepted patches are

 * scsi_cmnd->internal_timeout kill
 * scsi_cmnd->serial_number_at_timeout
 * remove volatile
 * scsi_send_eh_cmnd() clean up

 All four accepted patches are not included in any of above patchsets
and the timer update patchset doesn't depend on
REQ_SPECIAL/REQ_SOFTBARRIER usage change patchset, so please review the
timer update patchset.

 And, James, regarding REQ_SOFTBARRIER, if the REQ_SOFTBARRIER thing can
be removed from SCSI midlayer, do you agree to change REQ_SPECIAL to
mean special requests?  If so, I have three proposals.

 * move REQ_SOFTBARRIER setting to right after the allocation of
scsi_cmnd in scsi_prep_fn().  This will be the only place where
REQ_SOFTBARRIER is used in SCSI midlayer, making it less pervasive.
 * Or, make another API which sets REQ_SOFTBARRIER on requeue.  maybe
blk_requeue_ordered_request()?
 * Or, make blk_insert_request() not set REQ_SPECIAL on requeue.  IMHO,
this is a bit too subtle.

 I like #1 or #2.  Jens, what do you think?  Do you agree to remove
requeue feature from blk_insert_request()?

 Thanks a lot. :-)

-- 
tejun

