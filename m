Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA414C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 18:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E2EB20772
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 18:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390612AbgF3SC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 14:02:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42293 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S2390605AbgF3SC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 14:02:56 -0400
Received: (qmail 460459 invoked by uid 1000); 30 Jun 2020 14:02:55 -0400
Date:   Tue, 30 Jun 2020 14:02:55 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200630180255.GA459638@rowland.harvard.edu>
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <c19f1938-ae47-2357-669d-5b4021aec154@puri.sm>
 <20200629161536.GA405175@rowland.harvard.edu>
 <5231c57d-3f4e-1853-d4d5-cf7f04a32246@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5231c57d-3f4e-1853-d4d5-cf7f04a32246@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 30, 2020 at 08:59:00AM -0700, Bart Van Assche wrote:
> On 2020-06-29 09:15, Alan Stern wrote:
> > Aha.  Looking at this more closely, it's apparent that the code in 
> > blk-core.c contains a logic bug: It assumes that if the BLK_MQ_REQ_PREEMPT 
> > flag is set then the request can be issued regardless of the queue's 
> > runtime status.  That is not correct when the queue is suspended.
> 
> Are you sure of this? In the past (legacy block layer) no requests were
> processed for queues in state RPM_SUSPENDED. However, that function and
> its successor blk_pm_allow_request() are gone. The following code was
> removed by commit 7cedffec8e75 ("block: Make blk_get_request() block for
> non-PM requests while suspended").
> 
> static struct request *blk_pm_peek_request(struct request_queue *q,
>                                            struct request *rq)
> {
>         if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
>             (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM))))
>                 return NULL;
>         else
>                 return rq;
> }

No, it wasn't.  Another routine, blk_pm_allow_request(), was removed by 
that commit, but almost no other code was deleted.  Maybe you're thinking 
of a different commit?

In any case, I don't understand the point you're trying to make.

Here's what I _do_ understand: While the queue is in the RPM_SUSPENDED 
state, it can't carry out any requests at all.  If a request is added to 
the queue, the queue must be resumed before the request can be issued to 
the lower-layer drivers -- no matter what flags are set in the request.

Right now there doesn't seem to be any mechanism for resuming the queue 
if an REQ_PREEMPT request is added while the queue is suspended.

Alan Stern
