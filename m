Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72845C43142
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 01:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48DB12343F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 01:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbhANBaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:30:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727535AbhANB3u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Jan 2021 20:29:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610587677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HUOvlaCkrm/U0Zg0GZ+mc9xEDctf6SlBoM2x9QYlFlc=;
        b=fE6A3bEPXy4D/zTCikiD+6fcDwc/A6YAoqs/lShi82lLpf5xmePre3z8UwiA/SwVCEE/ih
        gHMvXuc4E5+8+8wV9c5ql2R9oM6lqq0a/t73JzhCtsXjMNtj/Z/PdgvcGGtYO8BrQqMqX7
        9tleYlkwETaOLHIV0Ln4fH1oEp6t2vU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-QnMTOfp_N76wQ8VrFfkD4w-1; Wed, 13 Jan 2021 20:27:53 -0500
X-MC-Unique: QnMTOfp_N76wQ8VrFfkD4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CDE8C28A;
        Thu, 14 Jan 2021 01:27:51 +0000 (UTC)
Received: from T590 (ovpn-13-18.pek2.redhat.com [10.72.13.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3134100AE3B;
        Thu, 14 Jan 2021 01:27:42 +0000 (UTC)
Date:   Thu, 14 Jan 2021 09:27:38 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Brian King <brking@linux.vnet.ibm.com>
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        james.smart@broadcom.com
Subject: Re: [PATCH v4 01/21] ibmvfc: add vhost fields and defaults for MQ
 enablement
Message-ID: <20210114012738.GA237540@T590>
References: <20210111231225.105347-1-tyreld@linux.ibm.com>
 <20210111231225.105347-2-tyreld@linux.ibm.com>
 <0525bee7-433f-dcc7-9e35-e8706d6edee5@linux.vnet.ibm.com>
 <a8623705-6d49-2056-09bb-80190e0b6f52@linux.ibm.com>
 <51bfc34b-c2c4-bf14-c903-d37015f65361@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51bfc34b-c2c4-bf14-c903-d37015f65361@linux.vnet.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 13, 2021 at 11:13:07AM -0600, Brian King wrote:
> On 1/12/21 6:33 PM, Tyrel Datwyler wrote:
> > On 1/12/21 2:54 PM, Brian King wrote:
> >> On 1/11/21 5:12 PM, Tyrel Datwyler wrote:
> >>> Introduce several new vhost fields for managing MQ state of the adapter
> >>> as well as initial defaults for MQ enablement.
> >>>
> >>> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> >>> ---
> >>>  drivers/scsi/ibmvscsi/ibmvfc.c | 8 ++++++++
> >>>  drivers/scsi/ibmvscsi/ibmvfc.h | 9 +++++++++
> >>>  2 files changed, 17 insertions(+)
> >>>
> >>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> >>> index ba95438a8912..9200fe49c57e 100644
> >>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> >>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> >>> @@ -3302,6 +3302,7 @@ static struct scsi_host_template driver_template = {
> >>>  	.max_sectors = IBMVFC_MAX_SECTORS,
> >>>  	.shost_attrs = ibmvfc_attrs,
> >>>  	.track_queue_depth = 1,
> >>> +	.host_tagset = 1,
> >>
> >> This doesn't seem right. You are setting host_tagset, which means you want a
> >> shared, host wide, tag set for commands. It also means that the total
> >> queue depth for the host is can_queue. However, it looks like you are allocating
> >> max_requests events for each sub crq, which means you are over allocating memory.
> > 
> > With the shared tagset yes the queue depth for the host is can_queue, but this
> > also implies that the max queue depth for each hw queue is also can_queue. So,
> > in the worst case that all commands are queued down the same hw queue we need an
> > event pool with can_queue commands.
> > 
> >>
> >> Looking at this closer, we might have bigger problems. There is a host wide
> >> max number of commands that the VFC host supports, which gets returned on
> >> NPIV Login. This value can change across a live migration event.
> > 
> > From what I understand the max commands can only become less.
> > 
> >>
> >> The ibmvfc driver, which does the same thing the lpfc driver does, modifies
> >> can_queue on the scsi_host *after* the tag set has been allocated. This looks
> >> to be a concern with ibmvfc, not sure about lpfc, as it doesn't look like
> >> we look at can_queue once the tag set is setup, and I'm not seeing a good way
> >> to dynamically change the host queue depth once the tag set is setup. 
> >>
> >> Unless I'm missing something, our best options appear to either be to implement
> >> our own host wide busy reference counting, which doesn't sound very good, or
> >> we need to add some API to block / scsi that allows us to dynamically change
> >> can_queue.
> > 
> > Changing can_queue won't do use any good with the shared tagset becasue each
> > queue still needs to be able to queue can_queue number of commands in the worst
> > case.
> 
> The issue I'm trying to highlight here is the following scenario:
> 
> 1. We set shost->can_queue, then call scsi_add_host, which allocates the tag set.
> 
> 2. On our NPIV login response from the VIOS, we might get a lower value than we
> initially set in shost->can_queue, so we update it, but nobody ever looks at it
> again, and we don't have any protection against sending too many commands to the host.
> 
> 
> Basically, we no longer have any code that ensures we don't send more
> commands to the VIOS than we are told it supports. According to the architecture,
> if we actually do this, the VIOS will do an h_free_crq, which would be a bit
> of a bug on our part.
> 
> I don't think it was ever clearly defined in the API that a driver can
> change shost->can_queue after calling scsi_add_host, but up until
> commit 6eb045e092efefafc6687409a6fa6d1dabf0fb69, this worked and now
> it doesn't. 

Actually it isn't related with commit 6eb045e092ef, because blk_mq_alloc_tag_set()
uses .can_queue to create driver tag sbitmap and request pool.

So even thought without 6eb045e092ef, the updated .can_queue can't work
as expected because the max driver tag depth has been fixed by blk-mq already.

What 6eb045e092ef does is just to remove the double check on max
host-wide allowed commands because that has been respected by blk-mq
driver tag allocation already.

> 
> I started looking through drivers that do this, and so far, it looks like the
> following drivers do: ibmvfc, lpfc, aix94xx, libfc, BusLogic, and likely others...
> 
> We probably need an API that lets us change shost->can_queue dynamically.

I'd suggest to confirm changing .can_queue is one real usecase.


Thanks,
Ming

