Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BB7C432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 03:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0924206D7
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 03:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EDk9NKBM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKVDYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 22:24:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48572 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726620AbfKVDYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 22:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574393093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nLFgxXDR8yiLK/d72yVk39IgQ6YE+2TqmiR+EF+7jfg=;
        b=EDk9NKBM8OvPr+DnTqB7VEVmEmQFewotanNqVjmjhmoQJKTcOSLuCHnYedZ14IIzn0smLc
        Ch3BQzcKbxaxA1v9S4rcztuTw3d6XPdzZK8ZLytTgafKpWLsNJVHFRLSSRpFDG5jN/QYKs
        rZCIyyiIuv95D1wyp1hLvjjHEDT9wuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-9MOjzsJsN4avVKE-xUo_9w-1; Thu, 21 Nov 2019 22:24:50 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36C46107ACCC;
        Fri, 22 Nov 2019 03:24:47 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5571F600CC;
        Fri, 22 Nov 2019 03:24:36 +0000 (UTC)
Date:   Fri, 22 Nov 2019 11:24:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
Message-ID: <20191122032432.GB903@ming.t460p>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
 <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
 <44644664-f7b6-facd-d1bb-f7cfc9524379@acm.org>
 <20191121010730.GD24548@ming.t460p>
 <yq1pnhkbopi.fsf@oracle.com>
MIME-Version: 1.0
In-Reply-To: <yq1pnhkbopi.fsf@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 9MOjzsJsN4avVKE-xUo_9w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Thu, Nov 21, 2019 at 09:59:53PM -0500, Martin K. Petersen wrote:
>=20
> Ming,
>=20
> > I don't understand the motivation of ramp-up/ramp-down, maybe it is jus=
t
> > for fairness among LUNs.
>=20
> Congestion control. Devices have actual, physical limitations that are
> different from the tag context limitations on the HBA. You don't have
> that problem on NVMe because (at least for PCIe) the storage device and
> the controller are one and the same.
>=20
> If you submit 100000 concurrent requests to a SCSI drive that does 100
> IOPS, some requests will time out before they get serviced.
> Consequently we have the ability to raise and lower the queue depth to
> constrain the amount of requests in flight to a given device at any
> point in time.

blk-mq has already puts a limit on each LUN, the number is
host_queue_depth / nr_active_LUNs, see hctx_may_queue().

Looks this way works for NVMe, that is why I try to bypass
.device_busy for SSD which is too expensive on fast storage. Even
Hannes wants to kill it completely.

>=20
> Also, devices use BUSY/QUEUE_FULL/TASK_SET_FULL to cause the OS to back
> off. We frequently see issues where the host can submit burst I/O much
> faster than the device can de-stage from cache. In that scenario the
> device reports BUSY/QF/TSF and we will back off so the device gets a
> chance to recover. If we just let the application submit new I/O without
> bounds, the system would never actually recover.
>=20
> Note that the actual, physical limitations for how many commands a
> target can handle are typically much, much lower than the number of tags
> the HBA can manage. SATA devices can only express 32 concurrent
> commands. SAS devices typically 128 concurrent commands per
> port. Arrays differ.

I understand SATA's host queue depth is set as 32.

But SAS HBA's queue depth is often big, so do we reply on .device_busy for
throttling requests to SAS?

>=20
> If we ignore the RAID controller use case where the controller
> internally queues and arbitrates commands between many devices, how is
> submitting 1000 concurrent requests to a device which only has 128
> command slots going to work?

For SSD, I guess it might be fine, given NVMe sets per-hw-queue depth
as 1023 usually. That means the concurrent requests can be as many as=20
1023 * nr_hw_queues in case of single namespace.

>=20
> Some HBAs have special sauce to manage BUSY/QF/TSF, some don't. If we
> blindly stop restricting the number of I/Os in flight in the ML, we may
> exceed either the capabilities of what the transport protocol can
> express or internal device resources.

OK, one conservative approach may be just to just bypass .device_busy=20
in case of SSD only for some high end HBA.

Or maybe we can wire up sdev->queue_depth with block layer's scheduler
queue depth? One issue is that sdev->queue_depth may be updated some
times.

Thanks,
Ming

