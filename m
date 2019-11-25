Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796ADC432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 18:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56F952084D
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 18:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TnslP4sS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfKYS3G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 13:29:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39874 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727893AbfKYS3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 13:29:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574706544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9XkBoWLj/Xn7XxBPjtDBghFZzpuVWU0MkgEhLaJjFNU=;
        b=TnslP4sSHm0TlS7HG+DfjKodAC61JAeLNF++r6s2++YR/gDXYDqvj7wn08I/GCxtpBm7DS
        VSgN8cqRvt8hISb/dGRhMQQpdVS9PFIKi43Nhm8gK3MKstkrGm6Ebnt71wGajTE4wjuI9o
        FRLg5MAFkldv3cR0bnIL7BMcROM6Th0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-58X1kjCtNY2yWuX8ZEttSQ-1; Mon, 25 Nov 2019 13:29:01 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E35498E9360;
        Mon, 25 Nov 2019 18:28:56 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BF935C1D8;
        Mon, 25 Nov 2019 18:28:50 +0000 (UTC)
Message-ID: <e9cb5e75681537443b393ed1631857df81b8894d.camel@redhat.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
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
Date:   Mon, 25 Nov 2019 13:28:49 -0500
In-Reply-To: <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
References: <20191118103117.978-1-ming.lei@redhat.com>
         <20191118103117.978-5-ming.lei@redhat.com>
         <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
         <20191121005323.GB24548@ming.t460p>
         <336f35fc-2e22-c615-9405-50297b9737ea@suse.de>
         <20191122080959.GC903@ming.t460p>
         <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 58X1kjCtNY2yWuX8ZEttSQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-11-22 at 10:14 -0800, Bart Van Assche wrote:
> 
> Hi Ming,
> 
> Thanks for having shared these numbers. I think this is very useful 
> information. Do these results show the performance drop that happens if 
> /sys/block/.../device/queue_depth exceeds .can_queue? What I am 
> wondering about is how important these results are in the context of 
> this discussion. Are there any modern SCSI devices for which a SCSI LLD 
> sets scsi_host->can_queue and scsi_host->cmd_per_lun such that the 
> device responds with BUSY? What surprised me is that only three SCSI 
> LLDs call scsi_track_queue_full() (mptsas, bfa, esp_scsi). Does that 
> mean that BUSY responses from a SCSI device or HBA are rare?
> 

Some FC HBAs end up returning busy from ->queuecommand() but I think
this is more commonly due to there being and issue with the rport rather
than the device.

-Ewan

