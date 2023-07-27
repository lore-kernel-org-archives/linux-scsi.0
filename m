Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7454CC001DE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 01:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjG0BUu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 21:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjG0BUs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 21:20:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64178188
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 18:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690420801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y8X6PgTR+pLYqKne9/e14XqsgiEG/L8rI/Zh18GGpEw=;
        b=XnDB5i49kZ5YW2Of5NXX3NgehZ0bAjQa69u0sgWNhDUhxirsB0h3GV585TEe6iZ3y3DVyf
        VMgh3SIyyKMJeRRP5Xw1SNpYQo2SL/TBk+vNrZQitWxUrDn28sUvcgHSYqtI44mp7GrwIv
        9MrPBNax8nDsDeuX5I4bQF09ZCVobQo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-BRU-t8dMNBqbQkWMIXLk4w-1; Wed, 26 Jul 2023 21:19:55 -0400
X-MC-Unique: BRU-t8dMNBqbQkWMIXLk4w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11396104458E;
        Thu, 27 Jul 2023 01:19:55 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27A2C40C206F;
        Thu, 27 Jul 2023 01:19:48 +0000 (UTC)
Date:   Thu, 27 Jul 2023 09:19:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Justin Tee <justintee8345@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH V2 4/9] scsi: lpfc: use blk_mq_max_nr_hw_queues() to
 calculate io vectors
Message-ID: <ZMHGLyg2bRY6S35i@ovpn-8-16.pek2.redhat.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-5-ming.lei@redhat.com>
 <CABPRKS-0GQqMRiGh6akOgk3BKpx5kqTd0QVhH4nPe=fUdi7DbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPRKS-0GQqMRiGh6akOgk3BKpx5kqTd0QVhH4nPe=fUdi7DbQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 26, 2023 at 03:12:16PM -0700, Justin Tee wrote:
> Hi Ming,
> 
> From version 1 of the patchset, I thought we had planned to put the
> min comparison right above pci_alloc_irq_vectors instead?
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 3221a934066b..20410789e8b8 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -13025,6 +13025,8 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
>                 flags |= PCI_IRQ_AFFINITY;
>         }
> 
> +       vectors = min_t(unsigned int, vectors, scsi_max_nr_hw_queues());

Strictly speaking, the above change is better, but non-managed irq
doesn't have such issue, that is why I just apply the change on managed
irq branch.


Thanks, 
Ming

