Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85986C07E95
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 02:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5217E613D2
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 02:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhGECvx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jul 2021 22:51:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhGECvx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jul 2021 22:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625453356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BLeXj+8XKMxLFChu+De6U7Z5h/Ve0EnpqGdSTfh+Oog=;
        b=NHJZgpONmyuxBVJzep3ZjC0iordRam/hK+we7ygjzSmoPLKDWlIogOjILg3OX4gkbdUo6D
        Pyhxg2/44gTwtRCHjEMHFxqCiKwEb8lC1ASrVhYbjUyIwWReyjtXbymjPtbxfdE39wwh9R
        dGN83Q6j+CwTZ5RdVCm0/sJPYAQEFmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-xXC6zSW9MTmViJGyU_E-qA-1; Sun, 04 Jul 2021 22:49:15 -0400
X-MC-Unique: xXC6zSW9MTmViJGyU_E-qA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD287100B3AC;
        Mon,  5 Jul 2021 02:49:12 +0000 (UTC)
Received: from T590 (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 759025C1A1;
        Mon,  5 Jul 2021 02:48:57 +0000 (UTC)
Date:   Mon, 5 Jul 2021 10:48:53 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 5/6] virtio: add one field into virtio_device for
 recording if device uses managed irq
Message-ID: <YOJzFe3xcLK279Wv@T590>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-6-ming.lei@redhat.com>
 <20210702115430-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702115430-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 02, 2021 at 11:55:40AM -0400, Michael S. Tsirkin wrote:
> On Fri, Jul 02, 2021 at 11:05:54PM +0800, Ming Lei wrote:
> > blk-mq needs to know if the device uses managed irq, so add one field
> > to virtio_device for recording if device uses managed irq.
> > 
> > If the driver use managed irq, this flag has to be set so it can be
> > passed to blk-mq.
> > 
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: virtualization@lists.linux-foundation.org
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> 
> The API seems somewhat confusing. virtio does not request
> a managed irq as such, does it? I think it's a decision taken
> by the irq core.

vp_request_msix_vectors():

        if (desc) {
                flags |= PCI_IRQ_AFFINITY;
                desc->pre_vectors++; /* virtio config vector */
                vdev->use_managed_irq = true;
        }

        err = pci_alloc_irq_vectors_affinity(vp_dev->pci_dev, nvectors,
                                             nvectors, flags, desc);

Managed irq is used once PCI_IRQ_AFFINITY is passed to
pci_alloc_irq_vectors_affinity().

> 
> Any way to query the irq to find out if it's managed?

So far the managed info isn't exported via /proc/irq, but if one irq is
managed, its smp_affinity & smp_affinity_list attributes can't be
changed successfully.

If irq's debugfs is enabled, this info can be retrieved.


Thanks,
Ming

