Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D877FC71155
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 07:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 443C921741
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 07:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388169AbgLCH32 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 02:29:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388140AbgLCH31 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 02:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606980480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r1k4wx0RVXIRwAtoYOZLIrYpm5gPE+9hi+XUm0sx93I=;
        b=G8GUc54ZxazTBdF5eVPLYVldtPpgoaWj2Nn6M/u2KtdguFCJEz62iaWm1q3ujLPW6YZ1vN
        PDrF174UtzLDsUkyxdRIQKyXabC9GY7YSHXndZvW7KnyyyIHp2cjF6jgfh2OrfSOGP1StO
        +ARTSIWQ5EMD3RSTZJ+8mpAAdxqzHjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-uHFmrJhsO8Oz1uKrVuIbbQ-1; Thu, 03 Dec 2020 02:27:56 -0500
X-MC-Unique: uHFmrJhsO8Oz1uKrVuIbbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B82B51009456;
        Thu,  3 Dec 2020 07:27:54 +0000 (UTC)
Received: from T590 (ovpn-13-173.pek2.redhat.com [10.72.13.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 60B0D60BF1;
        Thu,  3 Dec 2020 07:27:46 +0000 (UTC)
Date:   Thu, 3 Dec 2020 15:27:38 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v4 5/9] scsi: Do not wait for a request in
 scsi_eh_lock_door()
Message-ID: <20201203072738.GB633702@T590>
References: <20201130024615.29171-1-bvanassche@acm.org>
 <20201130024615.29171-6-bvanassche@acm.org>
 <bdadfbcd-76c4-4658-0b36-b7666fa1dc7b@suse.de>
 <6e5fbc73-881e-69c7-54ce-381b8b695b3c@acm.org>
 <b56cf3af-940f-62ed-2a79-eb80599e2f44@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b56cf3af-940f-62ed-2a79-eb80599e2f44@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 03, 2020 at 08:18:57AM +0100, Hannes Reinecke wrote:
> On 12/3/20 6:10 AM, Bart Van Assche wrote:
> > On 12/1/20 11:06 PM, Hannes Reinecke wrote:
> > > On 11/30/20 3:46 AM, Bart Van Assche wrote:
> > > > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > > > index d94449188270..6de6e1bf3dcb 100644
> > > > --- a/drivers/scsi/scsi_error.c
> > > > +++ b/drivers/scsi/scsi_error.c
> > > > @@ -1993,7 +1993,12 @@ static void scsi_eh_lock_door(struct
> > > > scsi_device *sdev)
> > > >        struct request *req;
> > > >        struct scsi_request *rq;
> > > >    -    req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN, 0);
> > > > +    /*
> > > > +     * It is not guaranteed that a request is available nor that
> > > > +     * sdev->request_queue is unfrozen. Hence the BLK_MQ_REQ_NOWAIT
> > > > below.
> > > > +     */
> > > > +    req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN,
> > > > +                  BLK_MQ_REQ_NOWAIT);
> > > >        if (IS_ERR(req))
> > > >            return;
> > > >        rq = scsi_req(req);
> > > > 
> > > 
> > > Well ... had been thinking about that one, too.
> > > The idea of this function is that prior to SCSI EH the device was locked
> > > via scsi_set_medium_removal(). And during SCSI EH the device might have
> > > become unlocked, so we need to lock it again.
> > > However, scsi_set_medium_removal() not only issues the
> > > PREVENT_ALLOW_MEDIUM_REMOVAL command, but also sets the 'locked' flag
> > > based on the result.
> > > So if we fail to get a request here, shouldn't we unset the 'locked'
> > > flag, too?
> > 
> > Probably not. My interpretation of the 'locked' flag is that it
> > represents the door state before error handling began. The following
> > code in the SCSI error handler restores the door state after a bus reset:
> > 
> > 	if (scsi_device_online(sdev) && sdev->was_reset && sdev->locked) {
> > 		scsi_eh_lock_door(sdev);
> > 		sdev->was_reset = 0;
> > 	}
> > 
> > > And what does happen if we fail here? There is no return value, hence
> > > SCSI EH might run to completion, and the system will continue
> > > with an unlocked door ...
> > > Not sure if that's a good idea.
> > 
> > How about applying the following patch on top of patch 5/9?
> > 
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 6de6e1bf3dcb..feac7262e40e 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -1988,7 +1988,7 @@ static void eh_lock_door_done(struct request *req, blk_status_t status)
> >    * 	We queue up an asynchronous "ALLOW MEDIUM REMOVAL" request on the
> >    * 	head of the devices request queue, and continue.
> >    */
> > -static void scsi_eh_lock_door(struct scsi_device *sdev)
> > +static int scsi_eh_lock_door(struct scsi_device *sdev)
> >   {
> >   	struct request *req;
> >   	struct scsi_request *rq;
> > @@ -2000,7 +2000,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
> >   	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN,
> >   			      BLK_MQ_REQ_NOWAIT);
> >   	if (IS_ERR(req))
> > -		return;
> > +		return PTR_ERR(req);
> >   	rq = scsi_req(req);
> > 
> >   	rq->cmd[0] = ALLOW_MEDIUM_REMOVAL;
> > @@ -2016,6 +2016,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
> >   	rq->retries = 5;
> > 
> >   	blk_execute_rq_nowait(req->q, NULL, req, 1, eh_lock_door_done);
> > +	return 0;
> >   }
> > 
> >   /**
> > @@ -2037,8 +2038,8 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
> >   	 * is no point trying to lock the door of an off-line device.
> >   	 */
> >   	shost_for_each_device(sdev, shost) {
> > -		if (scsi_device_online(sdev) && sdev->was_reset && sdev->locked) {
> > -			scsi_eh_lock_door(sdev);
> > +		if (scsi_device_online(sdev) && sdev->was_reset &&
> > +		    sdev->locked && scsi_eh_lock_door(sdev) == 0) {
> >   			sdev->was_reset = 0;
> >   		}
> >   	}
> > 
> I probably didn't make myself clear.
> As per SBC (in this case, sbc3r36) the effects of
> PREVENT_ALLOW_MEDIUM_REMOVAL are being reset by a successfull LUN Reset,
> Hard Reset, Power/On Reset, or an I_T Nexus loss. Which incidentally maps
> nicely onto SCSI EH, so after a successful SCSI EH the door will be unlocked
> (which is why we need to call scsi_eh_lock_door()).
> In the SCSI midlayer this state is being reflected by the 'locked' flag.
> Now, if scsi_eh_lock_door() is _not_ being executed due to a
> blk_get_request() failure, the device remains unlocked, and as such the
> 'locked' flag would need to be _unset_.
> 
> So I was thinking more along these lines:
> 
> @@ -2030,7 +2037,8 @@ static void scsi_restart_operations(struct Scsi_Host
> *shost)
>          */
>         shost_for_each_device(sdev, shost) {
>                 if (scsi_device_online(sdev) && sdev->was_reset &&
> sdev->locked) {
> -                       scsi_eh_lock_door(sdev);
> +                       if (scsi_eh_lock_door(sdev) < 0)
> +                               sdev->locked = 0;

BTW, scsi_eh_lock_door() returns void, and it can't be sync because
there may not be any driver tag available. Even though it is available,
the host state isn't running yet, so the command can't be queued to LLD
yet.

Maybe the above lines should be put after host state is updated to
RUNNING.

Also changing to NOWAIT can't avoid the issue completely, what if 'none'
is used?


Thanks,
Ming

