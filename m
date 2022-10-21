Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FFDC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Oct 2022 18:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJUSdp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiJUSdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 14:33:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3E7286CBA
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 11:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666377215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dLmiSkOFaJ+6V3LqgPTa0cZ4h6uaklJ08nilTBsNxQM=;
        b=am6105K3H5yMse58mv6dGupvO98e+490dPT8TwomlL+iEx6QCy7MZSEbnJx3p0kaZni+74
        Vz7b9BYRY3LhE8PaF3W+2JYLMnuUcmIDoHksfhofCRy++LTkthfIzCHYqkJSZlU65GpbQW
        UqRaHwcmWRdfhaWEX4+poeG6sKqh5xc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-570-anX6R0-bMA6fTFNn4aCL1g-1; Fri, 21 Oct 2022 14:33:34 -0400
X-MC-Unique: anX6R0-bMA6fTFNn4aCL1g-1
Received: by mail-ed1-f72.google.com with SMTP id s8-20020a056402520800b0045cab560d5eso3454833edd.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 11:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dLmiSkOFaJ+6V3LqgPTa0cZ4h6uaklJ08nilTBsNxQM=;
        b=QdlGvICPleOajljwZNkWZBulDi/zMlY2biY+G9qWZAs6c2nasdtlSP2qjOb+iLueyu
         cDowsJ+ozlLErDQD0xE0rSm00FD09D9t1kDiyvDyf0EwXExdWu1hvo2H3ACX9uA0fmiK
         JOlJHUTOOIsyTrkBdswm8L95gwttOtF0jP5tugrjJIW3GpiHR3ib7ZR6NPFa5Z3lKqL+
         CAMaqDnuu1eU7K2beK6xa0CeMgfJYRL/lF+4OGjIniI2PeWLMkKl0G+1UdTkEnM8a6aG
         PAAFMRfnd3pomkOGZKMv9ePzumYM0KGAoYsgyWRjtobO0fJk+Pc/npFYa4DXCandGyd6
         QX0A==
X-Gm-Message-State: ACrzQf15l4x6GG1wz3sEMV3UnA4OgS5jXNoM4SaxPVsfcCDnPJbHfcxn
        cvzyIcACUtGiAM2etcR3EoL2wW9+BM05dMFEDgqbw9XsMjJZtliVEosbbUdLaxhZVmzKdenpIle
        aSukOADQaTPfEeeZLm9k2ZpwW/ZIdxNSdVnxEAg==
X-Received: by 2002:a17:907:6e09:b0:78d:a326:49c6 with SMTP id sd9-20020a1709076e0900b0078da32649c6mr16637988ejc.507.1666377213473;
        Fri, 21 Oct 2022 11:33:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7NZHJKc03YC7LnDuTW7o+luE+PAom09rHSVMHty9srBMk8ve+2AMEfrLe7S9AFxjPyeW5ZCPc2NuaXhM2MKJo=
X-Received: by 2002:a17:907:6e09:b0:78d:a326:49c6 with SMTP id
 sd9-20020a1709076e0900b0078da32649c6mr16637970ejc.507.1666377213305; Fri, 21
 Oct 2022 11:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <Y1EQdafQlKNAsutk@T590> <Y1Ktf2jRTlPMQwJR@kbusch-mbp.dhcp.thefacebook.com>
 <Y1K5Oo7bIRlVTDnb@T590>
In-Reply-To: <Y1K5Oo7bIRlVTDnb@T590>
From:   David Jeffery <djeffery@redhat.com>
Date:   Fri, 21 Oct 2022 14:33:21 -0400
Message-ID: <CA+-xHTFp+gFVy6aKW2nj47+WY2+1vOLAE-X067C-hm4_8ngA6g@mail.gmail.com>
Subject: Re: [Bug] double ->queue_rq() because of timeout in ->queue_rq()
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>, stefanha@redhat.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 21, 2022 at 11:22 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Fri, Oct 21, 2022 at 08:32:31AM -0600, Keith Busch wrote:
> >
> > I agree with your idea that this is a lower level driver responsibility:
> > it should reclaim all started requests before allowing new queuing.
> > Perhaps the block layer should also raise a clear warning if it's
> > queueing a request that's already started.
>
> The thing is that it is one generic issue, lots of VM drivers could be
> affected, and it may not be easy for drivers to handle the race too.
>

While virtual systems are a common source of the problem, fully
preempt kernels (with or without real-time patches) can also trigger
this condition rather simply with a poorly behaved real-time task. The
involuntary preemption means the queue_rq call can be stopped to let
another task run. Poorly behaving tasks claiming the CPU for longer
than the request timeout when preempting a task in a queue_rq function
could cause the condition on real or virtual hardware. So it's not
just VM related drivers that are affected by the race.

David Jeffery

