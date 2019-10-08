Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136E0C4360C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 04:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4FC020867
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 04:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfJHEHY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:07:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfJHEHY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 00:07:24 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04E7A79704;
        Tue,  8 Oct 2019 04:07:24 +0000 (UTC)
Received: from ming.t460p (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD013600C6;
        Tue,  8 Oct 2019 04:07:13 +0000 (UTC)
Date:   Tue, 8 Oct 2019 12:07:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH V2] scsi: core: avoid host-wide host_busy counter for
 scsi_mq
Message-ID: <20191008040707.GD5556@ming.t460p>
References: <20191006074432.23993-1-ming.lei@redhat.com>
 <ae46a16c-3289-dc5c-9e7d-570d4b1de8e0@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae46a16c-3289-dc5c-9e7d-570d4b1de8e0@acm.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 08 Oct 2019 04:07:24 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 07, 2019 at 08:20:20PM -0700, Bart Van Assche wrote:
> On 2019-10-06 00:44, Ming Lei wrote:
> > +struct scsi_host_mq_in_flight {
> > +	int cnt;
> > +};
> 
> Is this structure useful? Have you considered to use the 'int' datatype
> directly and to leave out struct scsi_host_mq_in_flight?

OK, will switch to 'int' in V2.

> 
> >  /**
> >   * scsi_host_busy - Return the host busy counter
> >   * @shost:	Pointer to Scsi_Host to inc.
> >   **/
> >  int scsi_host_busy(struct Scsi_Host *shost)
> >  {
> > -	return atomic_read(&shost->host_busy);
> > +	struct scsi_host_mq_in_flight in_flight = {
> > +		.cnt = 0,
> > +	};
> 
> In case struct scsi_host_mq_in_flight would be retained, have you
> considered to use "{ }" to initialize "in_flight"?
> 
> > -static void scsi_dec_host_busy(struct Scsi_Host *shost)
> > +static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> >  {
> >  	unsigned long flags;
> >  
> >  	rcu_read_lock();
> > -	atomic_dec(&shost->host_busy);
> > +	clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> 
> If a new state variable would be introduced for SCSI commands, would it
> be possible to use non-atomic operations to set and clear
> SCMD_STATE_INFLIGHT? In other words, are any of the functions that
> modify this bit ever called concurrently?

scsi_host_queue_ready() is always called before calling
host->hostt->queuecommand(scmd), and scsi_dec_host_busy() is called
after calling into host->hostt->queuecommand(scmd) in non-failure path.

So the answer is no, they won't be called concurrently, even they won't
be called concurrently with test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)
in scsi_mq_done(), which can avoid to re-order between setting SCMD_STATE_INFLIGHT
and clearing SCMD_STATE_INFLIGHT.

The only exception is that clear_bit(SCMD_STATE_COMPLETE) may be run
concurrently with clear_bit(SCMD_STATE_INFLIGHT) because .complete() may
be called in another CPU remotely, but that only happens in case of
blk_should_fake_timeout().

So looks it is safe to change to non-atomic __set_bit() and
__clear__bit().

Thanks,
Ming
