Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4A9C41513
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 10:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjG0K5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 06:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbjG0K5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 06:57:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1FB1FEC
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 03:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690455406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mz3kdTZiV4Fh8BC16ASC64XxRXM+HggzPF30N2v+2/w=;
        b=SK1Ut7G7dhSULs91vMX5rfEY2+S1OeSpd/8X4REbSzTSOnOLK1UXluXGnYIl4/9D3b28lS
        jxP0JEtylHVq8m44z9lysfzq5v+jXnD/281zyF/yPrjAJH8mwkKfKNi1IX2iVz3Nrup4C9
        8sSFjVUK+f7BKH+QE2LmHjC1F1isUhk=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-T0DDSoeuP_ms-_Xasvy4eA-1; Thu, 27 Jul 2023 06:56:42 -0400
X-MC-Unique: T0DDSoeuP_ms-_Xasvy4eA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CF163803511;
        Thu, 27 Jul 2023 10:56:41 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37E22F641C;
        Thu, 27 Jul 2023 10:56:34 +0000 (UTC)
Date:   Thu, 27 Jul 2023 18:56:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.g.garry@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>, ming.lei@redhat.com
Subject: Re: [PATCH V2 5/9] scsi: hisi: take blk_mq_max_nr_hw_queues() into
 account for calculating io vectors
Message-ID: <ZMJNXk5MiViklCBX@ovpn-8-16.pek2.redhat.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-6-ming.lei@redhat.com>
 <07f84570-5307-df3c-99ab-a996bfcbf83a@oracle.com>
 <ZMHFQm2BpuGjjlTm@ovpn-8-16.pek2.redhat.com>
 <44b1bd30-426d-db85-4b52-4f079948e52a@oracle.com>
 <ZMI78klyiVUPFRZA@ovpn-8-16.pek2.redhat.com>
 <123dc4ca-88da-b2b1-44b2-791ea841572f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <123dc4ca-88da-b2b1-44b2-791ea841572f@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 27, 2023 at 11:28:31AM +0100, John Garry wrote:
> On 27/07/2023 10:42, Ming Lei wrote:
> > > > > > hisi_sas_v3_hw.c
> > > > > > +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> > > > > > @@ -2550,6 +2550,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
> > > > > >     	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
> > > > > > +	if (hisi_hba->cq_nvecs > scsi_max_nr_hw_queues())
> > > > > > +		hisi_hba->cq_nvecs = scsi_max_nr_hw_queues();
> > > > > > +
> > > > > >     	shost->nr_hw_queues = hisi_hba->cq_nvecs + hisi_hba->iopoll_q_cnt;
> > > > > For other drivers you limit the max MSI vectors which we try to allocate
> > > > > according to scsi_max_nr_hw_queues(), but here you continue to alloc the
> > > > > same max vectors but then limit the driver's completion queue count. Why not
> > > > > limit the max MSI vectors also here?
> > > Ah, checking again, I think that this driver always allocates maximum
> > > possible MSI due to arm interrupt controller driver bug - see comment at top
> > > of function interrupt_preinit_v3_hw(). IIRC, there was a problem if we
> > > remove and re-insert the device driver that the GIC ITS fails to allocate
> > > MSI unless all MSI were previously allocated.
> > My question is actually why hisi_hba->iopoll_q_cnt is subtracted from
> > allocated vectors since io poll queues does_not_  use msi vector.
> > 
> 
> It is subtracted as superfluous vectors were allocated.
> 
> As I mentioned, I think that the driver is forced to allocate all 32 MSI
> vectors, even though it really needs max of 32 - iopoll_q_cnt, i.e. we don't
> need an MSI vector for a HW queue assigned to polling. Then, since it gets
> 16x MSI for cq vectors, it subtracts iopoll_q_cnt to give the desired count
> in cq_nvecs.

Looks the current driver wires nr_irq_queues with nr_poll_queues, which is
wrong logically.

Here:

1) hisi_hba->queue_count means the max supported queue count(irq queues
+ poll queues)

2) max vectors(32) means the max supported irq queues, but actual
nr_irq_queues can be less than allocated vectors because of the irq
allocation bug

3) so the max supported poll queues should be (hisi_hba->queue_count -
nr_irq_queues).

What I meant is that nr_poll_queues shouldn't be related with allocated
msi vectors.


> > So it isn't related with driver's msi vector allocation bug, is it?
> 
> My deduction is this is how this currently "works" for non-zero iopoll
> queues:
> - allocate max MSI of 32, which gives 32 vectors including 16 cq vectors.
> That then gives:
>    - cq_nvecs = 16 - iopoll_q_cnt
>    - shost->nr_hw_queues = 16
>    - 16x MSI cq vectors were spread over all CPUs

It should be that cq_nvecs vectors spread over all CPUs, and
iopoll_q_cnt are spread over all CPUs too.

For each queue type, nr_queues of this type are spread over all
CPUs.

> 
> - in hisi_sas_map_queues()
>    - HCTX_TYPE_DEFAULT qmap->nr_queues = 16 - iopoll_q_cnt, and for
> blk_mq_pci_map_queues() we setup affinity for 16 - iopoll_q_cnt hw queues.
> This looks broken, as we originally spread 16x vectors over all CPUs, but
> now only setup mappings for (16 - iopoll_q_cnt) vectors, whose affinity
> would spread a subset of CPUs. And then qmap->mq_map[] for other CPUs is not
> set at all.

That isn't true, please see my above comment.


Thanks,
Ming

