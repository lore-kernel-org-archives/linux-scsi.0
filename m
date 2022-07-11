Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE54FC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 02:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiGKC3Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jul 2022 22:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGKC3W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jul 2022 22:29:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FD3B6363
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2022 19:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657506560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vz1GK9BX/gFWrmQP642bPgzY3Nvglr3NVgRq93Im89w=;
        b=Ly6i2ZKQgdlUpO9WpL2mCw1DSGVCfVTcPScHkP3tgK8rRHmQNIELWZoj93xSlEpZ0wJevO
        23CXXJE6q+UwIRwcWLbnJByodO2YwiYj/okJvPKE84EbCL32cdwaOTvxdFAj045y/+fdTi
        I6hJj4cUjHlFzU5aGNwrSwJ6A28jOgE=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-5FZP67t2OraJnO6vSGQJRw-1; Sun, 10 Jul 2022 22:29:19 -0400
X-MC-Unique: 5FZP67t2OraJnO6vSGQJRw-1
Received: by mail-yb1-f198.google.com with SMTP id j11-20020a05690212cb00b006454988d225so2873938ybu.10
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2022 19:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vz1GK9BX/gFWrmQP642bPgzY3Nvglr3NVgRq93Im89w=;
        b=u1MLbgfQ1Ojn+FrOUWy8AwtLyuRg6ChuN1P1MFWNkWu4/7Vr+6UkHF+KVzmR0AfnA9
         vkYPMn3kKAgwvfiJjvrXnjQlunOC/p2FopN9EBwl0gRAb0+XuSc38haoghcI19gDzCtU
         x/NxTetfVFZQRbV3fN7SzOutT8XJmfFpizclX3k40BbywoW9NmG4rhByzF/v9rMajIYC
         wwfDQmKwvZaLYMQIjpUMEjhrX4X4tTi81u6SOAvamTgPKQ/EPnPw999t+Ky07IAekZ5r
         NiCoqPdB/Ud0ck5NBMdL1BqRiHfD3KOcSBgAD4OOipE8j0Sd3B5ZaBpPMKWl8in6TUVL
         ij9w==
X-Gm-Message-State: AJIora/7MgK336KbKnSnQONQ5qW5OkT9+o43ubXLIF9HdTzBjDi0zPrw
        KwfEIOLyuDrZ28TLh51sV94Pi7fai+/aMbRmnibPY5q8PDesXp9TdvjkNs6GJlaOjK2J81wykHa
        cRI1z+e06C38/ife70dgzycF2xd7QrHJmi1ek+A==
X-Received: by 2002:a25:3a81:0:b0:66a:645f:fe99 with SMTP id h123-20020a253a81000000b0066a645ffe99mr14836582yba.489.1657506558827;
        Sun, 10 Jul 2022 19:29:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vqb00OL/S1ZQjGqe7y+O8w1oRX078Ot3LxIDI/LAz0Qo3pnFgAsc+9LkWNbW0R7S/zmsYzgDDbhqhxqw1uYNM=
X-Received: by 2002:a25:3a81:0:b0:66a:645f:fe99 with SMTP id
 h123-20020a253a81000000b0066a645ffe99mr14836571yba.489.1657506558645; Sun, 10
 Jul 2022 19:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220706125942.528533-1-ming.lei@redhat.com>
In-Reply-To: <20220706125942.528533-1-ming.lei@redhat.com>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Mon, 11 Jul 2022 10:29:07 +0800
Message-ID: <CAFj5m9JEtVY4WBwYPPmaJHXamozUXLZ2Pzk_2+ZNN7o6x7CYFQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: megaraid: clear READ queue map's nr_queues
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        linux-block <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Guangwu Zhang <guazhang@redhat.com>,
        Ming Lei <minlei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Guys,

On Wed, Jul 6, 2022 at 8:59 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> megaraid scsi driver sets set->nr_maps as 3 if poll_queues is > 0, and
> blk-mq actually initializes each map's nr_queues as nr_hw_queues, so
> megaraid driver has to clear READ queue map's nr_queues, otherwise queue
> map becomes broken if poll_queues is set as non-zero.
>
> Fixes: 9e4bec5b2a23 ("scsi: megaraid_sas: mq_poll support")

Ping...

Without this fix, it is easy to observe fio hang when running cpu hotplug
test in case of 'poll_queues > 0'.

Thanks,
Ming

