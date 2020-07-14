Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95DBC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 10:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C781F21897
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 10:14:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KykNrRHP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgGNKO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:14:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48918 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgGNKO4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 06:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594721695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eK+gRiV5wR55qDimLkvlx5oZ6+faA3C9UnHWXxdJQp4=;
        b=KykNrRHPbx+J9m4nlUYNWbcxxT+QedUMx+v5kJ59dhFKjRplfnx52MzcxH6KpxB1gEvsdg
        hxGDejfoTFECQpW5qFxUA2KdO+z17MbotnCI1daO53biSp8fLMh8xVD3xndwgD/UXuCj5S
        8CihzaSZvJlWIa130WwYznhj33s2pr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-2qr_FMNFPAC0ct7ewZ-Adw-1; Tue, 14 Jul 2020 06:14:50 -0400
X-MC-Unique: 2qr_FMNFPAC0ct7ewZ-Adw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 272E08014D4;
        Tue, 14 Jul 2020 10:14:48 +0000 (UTC)
Received: from T590 (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFFEB60BEC;
        Tue, 14 Jul 2020 10:14:37 +0000 (UTC)
Date:   Tue, 14 Jul 2020 18:14:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>, don.brace@microsemi.com,
        axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        shivasharan.srikanteshwara@broadcom.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Message-ID: <20200714101432.GA602708@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
 <20200714080631.GA600766@T590>
 <3584bcc3-830a-d50d-bb55-8ac0b686cdc0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3584bcc3-830a-d50d-bb55-8ac0b686cdc0@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2020 at 10:53:32AM +0100, John Garry wrote:
> On 14/07/2020 09:06, Ming Lei wrote:
> > > v7 is here:
> > > 
> > > https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-shared-tags-rfc-v7
> > > 
> > > So that should be good to test with for now.
> > > 
> > > And I was going to ask this same question about smartpqi, so can you please
> > > let me know about this one?
> 
> Hi Ming,
> 
> > smartpqi is real MQ HBA, do you need any change wrt. shared tags?
> 
> Is it really?

Yes, it is.

pqi_register_scsi():
        shost->nr_hw_queues = ctrl_info->num_queue_groups;

pqi_enable_msix_interrupts():
        num_vectors_enabled = pci_alloc_irq_vectors(ctrl_info->pci_dev,
                        PQI_MIN_MSIX_VECTORS, ctrl_info->num_queue_groups,
                        PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);

> 
> As I see, today it maintains a single tagset per HBA. So Hannes' change in

No, each hw queue has one independent tagset for smartpqi.

> this series seems ok. However, I do worry that mainline code may be wrong,
> as block layer may send can_queue * nr_hw_queues requests, when it seems the
> HBA can only handle can_queue requests.

I have one machine in which all system are installed on smartpqi disks,
and I almost work on the system everyday, so far so good with this real
MQ style.

Can you explain a bit why you worry the mainline code may be wrong?


Thanks,
Ming

