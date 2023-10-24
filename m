Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFEDC25B67
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 02:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjJXC3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 22:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJXC3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 22:29:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61728CC
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 19:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698114544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ljunzYankt+Y8DsOwYK9IuDt9vyB/XfCBQ409TGpc7Q=;
        b=KY6yY2whRReXF71zLI60SnkMIFl0xIAR/OakfQpd9sjiYvaie0hQ2bcsU7nRSgNq6bu2/8
        v50ArGozyM7aIcANl8caNZqasj7nuoiMgGfv91oh4BEvUoM+0jmg+sHTWsjoaNNrdIbMup
        q7JSmZmhtzH949CuyXMV96nqELlsHoI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-nOcrXpvNNY2jYihqGF8djg-1; Mon, 23 Oct 2023 22:28:54 -0400
X-MC-Unique: nOcrXpvNNY2jYihqGF8djg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53E5E101A52D;
        Tue, 24 Oct 2023 02:28:53 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 446F6492BD9;
        Tue, 24 Oct 2023 02:28:48 +0000 (UTC)
Date:   Tue, 24 Oct 2023 10:28:44 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, ming.lei@redhat.com
Subject: Re: [PATCH v4 0/3] Support disabling fair tag sharing
Message-ID: <ZTcr3AHr9l4sHRO2@fedora>
References: <20231023203643.3209592-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023203643.3209592-1-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Mon, Oct 23, 2023 at 01:36:32PM -0700, Bart Van Assche wrote:
> Hi Jens,
> 
> Performance of UFS devices is reduced significantly by the fair tag sharing
> algorithm. This is because UFS devices have multiple logical units and a
> limited queue depth (32 for UFS 3.1 devices) and also because it takes time to
> give tags back after activity on a request queue has stopped. This patch series
> addresses this issue by introducing a flag that allows block drivers to
> disable fair sharing.
> 
> Please consider this patch series for the next merge window.

In previous post[1], you mentioned that the issue is caused by non-IO
queue of WLUN, but in this version, looks there isn't such story any more.

IMO, it isn't reasonable to account non-IO LUN for tag fairness, so
solution could be to not take non-IO queue into account for fair tag
sharing. But disabling fair tag sharing for this whole tagset could be
too over-kill.

And if you mean normal IO LUNs, can you share more details about the
performance drop? such as the test case, how many IO LUNs, and how to
observe performance drop, cause it isn't simple any more since multiple
LUN's perf has to be considered.


[1] https://lore.kernel.org/linux-block/20231018180056.2151711-1-bvanassche@acm.org/

Thanks,
Ming

