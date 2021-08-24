Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A0CC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 010EB6125F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhHXDre (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:47:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234015AbhHXDre (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629776810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8oKeFpafUKcEEbcaIrs+44Y9vp+vcP0pRkBwCZCrRh0=;
        b=gsgfAi2fCtGCoCLnaf7P2C+HLaeh+Cyb84cqXF7UrWZaq8ZMLJy6qqNQ+f185nEbjkbhp0
        aap2XSPHGv6fc6o55kxgLAbVPL8o4yMDr0IcopMxJIURlxgQoboqPcZJfK3Vulb1zgm5Pv
        yKrWwG/zHV87JT+RMJPxDO7fTYZ1VSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-tJua4coPMUymKgxvWCY8uA-1; Mon, 23 Aug 2021 23:46:46 -0400
X-MC-Unique: tJua4coPMUymKgxvWCY8uA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EC691F2DC;
        Tue, 24 Aug 2021 03:46:45 +0000 (UTC)
Received: from T590 (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87E685C232;
        Tue, 24 Aug 2021 03:46:37 +0000 (UTC)
Date:   Tue, 24 Aug 2021 11:46:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Message-ID: <YSRrmOmrwm5olk0D@T590>
References: <20210823125649.16061-1-njavali@marvell.com>
 <c72c7669-8818-77f1-2e5d-98bb24308f08@grimberg.me>
 <DM6PR18MB30340DC93DCC82CFFAAE3ACCD2C59@DM6PR18MB3034.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB30340DC93DCC82CFFAAE3ACCD2C59@DM6PR18MB3034.namprd18.prod.outlook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2021 at 03:38:24AM +0000, Saurav Kashyap wrote:
> Hi Sagi,
> Comments inline
> 
> > -----Original Message-----
> > From: Sagi Grimberg <sagi@grimberg.me>
> > Sent: Monday, August 23, 2021 10:51 PM
> > To: Nilesh Javali <njavali@marvell.com>; martin.petersen@oracle.com; linux-
> > nvme@lists.infradead.org; Ming Lei <ming.lei@redhat.com>
> > Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-
> > Storage-Upstream@marvell.com>
> > Subject: Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
> > 
> > 
> > On 8/23/21 5:56 AM, Nilesh Javali wrote:
> > > Currently nvme fc doesn't support map queue functionality. This patch
> > > set adds map_queue functionality to nvme_fc_mq_ops and
> > > nvme_fc_port_template, providing an option to LLDs to map queues
> > > similar to SCSI. For qla2xxx, minimum 10% improvement is noticed
> > > with this change as it helps in reducing cpu thrashing.
> > 
> > Does this make nvme-fc use managed irq?
> 
> qla2xxx driver uses pci_alloc_irq_vectors_affinity to have affinity with each MSI-X vector. Currently nvme queue are not mapped based on affinity and irq offset. The change is to use blk_mq_pci_map_queues for mapping, this function consider irq affinity as well as irq offset.
> 

OK, got it. Even though without this patchset, nvme-fc actually relies
on managed irq since qla2xxx driver uses pci_alloc_irq_vectors_affinity.

Now the patchset[1] isn't good for addressing the issue in
blk_mq_alloc_request_hctx().

[1] https://lore.kernel.org/linux-block/YR7demOSG6MKFVAF@T590/T/#t


Thanks,
Ming

