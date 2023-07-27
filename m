Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3771EC0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 12:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbjG0MCr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 08:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbjG0MCq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 08:02:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC93272A
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 05:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690459320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g4D058gjwKkdyS8i0jUPhq1NNuEifJC27HMn+Dz4hxg=;
        b=QcKA/a9QD5v07u1v7OJ18YV35a0FcSNAdMQDnopLpFrohC7cqxRFjD6A1qAECt/gmc9o9+
        V34b+iLMPeguhsj+VyQdcqarxnPifa6E/J0rtJ9gZVWyxaW2jMWBhsopNomPbGcL+zx6kh
        hg+vVnNmTWzYzsWhoqHPypc5Sus446c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-s0RQ-y9hNaSWBl2Y43axZQ-1; Thu, 27 Jul 2023 08:01:59 -0400
X-MC-Unique: s0RQ-y9hNaSWBl2Y43axZQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 860718028B2;
        Thu, 27 Jul 2023 12:01:58 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9045492C13;
        Thu, 27 Jul 2023 12:01:52 +0000 (UTC)
Date:   Thu, 27 Jul 2023 20:01:47 +0800
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
Message-ID: <ZMJcqzeaE5e0BdmK@ovpn-8-16.pek2.redhat.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-6-ming.lei@redhat.com>
 <07f84570-5307-df3c-99ab-a996bfcbf83a@oracle.com>
 <ZMHFQm2BpuGjjlTm@ovpn-8-16.pek2.redhat.com>
 <44b1bd30-426d-db85-4b52-4f079948e52a@oracle.com>
 <ZMI78klyiVUPFRZA@ovpn-8-16.pek2.redhat.com>
 <123dc4ca-88da-b2b1-44b2-791ea841572f@oracle.com>
 <ZMJNXk5MiViklCBX@ovpn-8-16.pek2.redhat.com>
 <cc41d37e-5dce-9381-8b47-f8c690388a88@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc41d37e-5dce-9381-8b47-f8c690388a88@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 27, 2023 at 12:30:34PM +0100, John Garry wrote:
> On 27/07/2023 11:56, Ming Lei wrote:
> > > As I mentioned, I think that the driver is forced to allocate all 32 MSI
> > > vectors, even though it really needs max of 32 - iopoll_q_cnt, i.e. we don't
> > > need an MSI vector for a HW queue assigned to polling. Then, since it gets
> > > 16x MSI for cq vectors, it subtracts iopoll_q_cnt to give the desired count
> > > in cq_nvecs.
> > Looks the current driver wires nr_irq_queues with nr_poll_queues, which is
> > wrong logically.
> > 
> > Here:
> > 
> > 1) hisi_hba->queue_count means the max supported queue count(irq queues
> > + poll queues)
> > 
> 
> JFYI, from https://github.com/tianocore/edk2-platforms/blob/master/Silicon/Hisilicon/Hi1620/Hi1620AcpiTables/Dsdt/Hi1620Pci.asl#L587C25-L587C41,
> hisi_hba->queue_count is fixed at 16.
> 
> > 2) max vectors(32) means the max supported irq queues,
> I'll just mention some details of this HW, in case missed.
> 
> For this HW, max vectors is 32, but not all are for completion queue
> interrupts.
> 
> interrupts 0-15 are for housekeeping, like phy up notification
> interrupts 16-31 are for completion queue interrupts
> 
> That is a fixed assignment. irq #16 is for HW queue #0 interrupt, irq #17 is
> for HW queue #1 interrupt, and so on.
> 
> > but actual
> > nr_irq_queues can be less than allocated vectors because of the irq
> > allocation bug
> > 
> > 3) so the max supported poll queues should be (hisi_hba->queue_count -
> > nr_irq_queues).
> > 
> > What I meant is that nr_poll_queues shouldn't be related with allocated
> > msi vectors.
> 
> Sure, I agree with that. nr_poll_queues is set in that driver as a module
> param.
> 
> I am just saying that we have a fixed number of HW queues (16), each of
> which may be used for interrupt or polling mode. And since we always
> allocate max number of MSI, then number of interrupt queues available will
> be 16 - nr_poll_queues.

No.

queue_count is fixed at 16, but pci_alloc_irq_vectors_affinity() still
may return less vectors, which is one system-wide resource, and queue
count is device resource.

So when less vectors are allocated, you should have been capable of using
more poll queues, unfortunately the current code can't support that.

Even worse, hisi_hba->cq_nvecs can become negative if less vectors are returned.

> 
> > 
> > 
> > > > So it isn't related with driver's msi vector allocation bug, is it?
> > > My deduction is this is how this currently "works" for non-zero iopoll
> > > queues:
> > > - allocate max MSI of 32, which gives 32 vectors including 16 cq vectors.
> > > That then gives:
> > >     - cq_nvecs = 16 - iopoll_q_cnt
> > >     - shost->nr_hw_queues = 16
> > >     - 16x MSI cq vectors were spread over all CPUs
> > It should be that cq_nvecs vectors spread over all CPUs, and
> > iopoll_q_cnt are spread over all CPUs too.
> 
> I agree, it should be, but I don't think that it is for HCTX_TYPE_DEFAULT,
> as below.
> 
> > 
> > For each queue type, nr_queues of this type are spread over all
> > CPUs. >> - in hisi_sas_map_queues()
> > >     - HCTX_TYPE_DEFAULT qmap->nr_queues = 16 - iopoll_q_cnt, and for
> > > blk_mq_pci_map_queues() we setup affinity for 16 - iopoll_q_cnt hw queues.
> > > This looks broken, as we originally spread 16x vectors over all CPUs, but
> > > now only setup mappings for (16 - iopoll_q_cnt) vectors, whose affinity
> > > would spread a subset of CPUs. And then qmap->mq_map[] for other CPUs is not
> > > set at all.
> > That isn't true, please see my above comment.
> 
> I am just basing that on what I mention above, so please let me know my
> inaccuracy there.

You said queue mapping for HCTX_TYPE_DEFAULT is broken, but it isn't.

You said 'we originally spread 16x vectors over all CPUs', which isn't
true. Again, '16 - iopoll_q_cnt' vectors are spread on all CPUs, and
same with iopoll_q_cnt vectors.

Since both blk_mq_map_queues() and blk_mq_pci_map_queues() does spread
map->nr_queues over all CPUs, so there isn't spread a subset of CPUs.

Thanks, 
Ming

