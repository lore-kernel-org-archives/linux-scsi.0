Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA32AC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 07:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADEDB2073A
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 07:09:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U7HO8+yM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfKRHJL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 02:09:11 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56661 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726536AbfKRHJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 02:09:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574060950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+0/ryLhoyTlc8fNpJVFlmLm/sHXzaSnDJOloPJnrzH0=;
        b=U7HO8+yMDv76d9MaAy4UPLH635yK2A1fhdBt3B4qbAT1A2xbQ8yDKzM/TLldAw+yn0Fv6+
        F23+bvUmKbRvaLEQzYXrPG5YcvfZ2XtWIR+PLrzrCD/lq5GWFCmJJozHP7JffjuAlfx8mw
        jMx0pEmRpPEOgNYsQ8IhDBOZeOqX4yg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-hpV8uoGZNnydjUOeEQPhbg-1; Mon, 18 Nov 2019 02:09:06 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 586F6107ACC4;
        Mon, 18 Nov 2019 07:09:04 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AC479F79;
        Mon, 18 Nov 2019 07:08:55 +0000 (UTC)
Date:   Mon, 18 Nov 2019 15:08:51 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Long Li <longli@microsoft.com>, linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
Message-ID: <20191118070851.GA16717@ming.t460p>
References: <20191117080818.2664-1-ming.lei@redhat.com>
 <465632fa-2519-6e44-3a3c-0f81a8e6689e@acm.org>
MIME-Version: 1.0
In-Reply-To: <465632fa-2519-6e44-3a3c-0f81a8e6689e@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: hpV8uoGZNnydjUOeEQPhbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Nov 17, 2019 at 09:30:39PM -0800, Bart Van Assche wrote:
> On 2019-11-17 00:08, Ming Lei wrote:
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 379533ce8661..212903d5f43c 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -612,7 +612,7 @@ static bool scsi_end_request(struct request *req, b=
lk_status_t error,
> >  =09if (scsi_target(sdev)->single_lun ||
> >  =09    !list_empty(&sdev->host->starved_list))
> >  =09=09kblockd_schedule_work(&sdev->requeue_work);
> > -=09else
> > +=09else if (READ_ONCE(sdev->restart))
> >  =09=09blk_mq_run_hw_queues(q, true);
> > =20
>=20
> Rerunning the hardware queues is not only necessary after
> scsi_dev_queue_ready() returns false but also after .queuecommand()
> returns SCSI_MLQUEUE_*_BUSY. Can this patch cause queue stalls if
> .queuecommand() returns SCSI_MLQUEUE_*_BUSY?

No, that isn't why blk_mq_run_hw_queues is called in scsi_end_request(),
and you should see that it is just this LUN to be re-run.

Also if .queuecommand() returns any non-zero value, BLK_STS_RESOURCE
will be returned to blk-mq, then blk-mq will cover the re-run.

thanks,
Ming

