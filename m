Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62120C2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2B46208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f7HlqwdQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgI1VC7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:02:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbgI1VC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 17:02:59 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601326977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J4rhUFdthU9hZhTyEjv0f5vJaWoBGGUSOt4mTK9HkN8=;
        b=f7HlqwdQk1ClhK5lDhQ13qd0ZYO/WlpIH2KKZ05nwEPT19asIsF2J0ws6M8jsiljstDi7c
        SkALCjnhd6rhwEC85VoD4JlifdibDqsMjoeVn1w2FTIDnSLcdhMD0GGjQACBVMWR7PDkDS
        2czmAuckxtBhvBR1jagCOxTbB4GC0z0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-rm5NjD66Npm8re8Ob_H0DA-1; Mon, 28 Sep 2020 17:02:53 -0400
X-MC-Unique: rm5NjD66Npm8re8Ob_H0DA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBD551DDFF;
        Mon, 28 Sep 2020 21:02:51 +0000 (UTC)
Received: from ovpn-112-154.phx2.redhat.com (ovpn-112-154.phx2.redhat.com [10.3.112.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BE365D9CD;
        Mon, 28 Sep 2020 21:02:51 +0000 (UTC)
Message-ID: <e7be51d47022cab2f1630879f0902ccc0c968d61.camel@redhat.com>
Subject: Re: [PATCH] scsi_dh_alua: avoid crash during alua_bus_detach()
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>
Date:   Mon, 28 Sep 2020 17:02:50 -0400
In-Reply-To: <2175d8e0-88fa-a9eb-5d50-46f0eed402cf@acm.org>
References: <20200924104559.26753-1-hare@suse.de>
         <2175d8e0-88fa-a9eb-5d50-46f0eed402cf@acm.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-09-26 at 15:01 -0700, Bart Van Assche wrote:
> On 2020-09-24 03:45, Hannes Reinecke wrote:
> > alua_bus_detach() might be running concurrently with
> > alua_rtpg_work(),
> > so we might trip over h->sdev == NULL and call BUG_ON().
> > The correct way of handling it would be to not set h->sdev to NULL
> > in alua_bus_detach(), and call rcu_synchronize() before the final
> > delete to ensure that all concurrent threads have left the critical
> > section.
> > Then we can get rid of the BUG_ON(), and replace it with a simple
> > if condition.
> > 
> > Cc: Brian Bunker <brian@purestorage.com>
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/scsi/device_handler/scsi_dh_alua.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> > b/drivers/scsi/device_handler/scsi_dh_alua.c
> > index f32da0ca529e..308bda2e9c00 100644
> > --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> > +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> > @@ -658,8 +658,8 @@ static int alua_rtpg(struct scsi_device *sdev,
> > struct alua_port_group *pg)
> >  					rcu_read_lock();
> >  					list_for_each_entry_rcu(h,
> >  						&tmp_pg->dh_list, node)
> > {
> > -						/* h->sdev should
> > always be valid */
> > -						BUG_ON(!h->sdev);
> > +						if (!h->sdev)
> > +							continue;
> >  						h->sdev->access_state =
> > desc[0];
> >  					}
> >  					rcu_read_unlock();
> > @@ -705,7 +705,8 @@ static int alua_rtpg(struct scsi_device *sdev,
> > struct alua_port_group *pg)
> >  			pg->expiry = 0;
> >  			rcu_read_lock();
> >  			list_for_each_entry_rcu(h, &pg->dh_list, node)
> > {
> > -				BUG_ON(!h->sdev);
> > +				if (!h->sdev)
> > +					continue;
> >  				h->sdev->access_state =
> >  					(pg->state &
> > SCSI_ACCESS_STATE_MASK);
> >  				if (pg->pref)
> > @@ -1147,7 +1148,6 @@ static void alua_bus_detach(struct
> > scsi_device *sdev)
> >  	spin_lock(&h->pg_lock);
> >  	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h-
> > >pg_lock));
> >  	rcu_assign_pointer(h->pg, NULL);
> > -	h->sdev = NULL;
> >  	spin_unlock(&h->pg_lock);
> >  	if (pg) {
> >  		spin_lock_irq(&pg->lock);
> > @@ -1156,6 +1156,7 @@ static void alua_bus_detach(struct
> > scsi_device *sdev)
> >  		kref_put(&pg->kref, release_port_group);
> >  	}
> >  	sdev->handler_data = NULL;
> > +	synchronize_rcu();
> >  	kfree(h);
> >  }
> 
> Hi Hannes,
> 
> Do you agree that the changes in alua_bus_detach() make the changes
> in
> alua_rtpg() superfluous?

I agree that the "if (!h->sdev)   continue;" should not be needed in
alua_rtpg() if the h->sdev remains valid while in the list.

I'm a little concerned about adding the synchronize_rcu() as this is
called in the scsi_device_dev_release_usercontext() path, with a lot
of LUNs it could take a while to remove all the devices, see e.g.:

f983622ae605 scsi: core: Avoid calling synchronize_rcu() for each
               device in scsi_host_block()

It doesn't look like we ever NULL sdev->handler on detach even though
we do a module_put() on the DH.  But we have already called the
release() function so perhaps this doesn't cause a problem in
practice.

-Ewan

> 
> How about freezing command processing for 'sdev' while detaching a
> device handler instead of inserting a synchronize_rcu() call in
> alua_bus_detach()? I'm concerned that the alua_bus_detach() changes
> are
> not sufficient to fix all possible races between detaching a device
> handler and the following code from the SCSI error handler:
> 
> 	if (sdev->handler && sdev->handler->check_sense) {
> 		int rc;
> 
> 		rc = sdev->handler->check_sense(sdev, &sshdr);
> 		if (rc != SCSI_RETURN_NOT_HANDLED)
> 			return rc;
> 		/* handler does not care. Drop down to default handling
> */
> 	}
> 
> Thanks,
> 
> Bart.
> 

