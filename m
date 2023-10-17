Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201E3CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 18:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbjJQS7x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 14:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344007AbjJQR62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 13:58:28 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1AA98
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 10:58:26 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-577e62e2adfso3813333a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 10:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1697565506; x=1698170306; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ERqNElzqK3ivGhZFkbR1xLkOQfN9J+nTp0C/iYJJ+VA=;
        b=XqcCAps+8YsariOAHQzEiFfjcJBTYAoekfrhKC19iXGjyXJ6ENGSqdRI+YvGocZW2d
         q1LRd80AQG7O3RKmKgHzU9Xpy9mokg3jHhKV1RC7Mbp2e6qXwArBlpkPRkHXueb0gVfQ
         wdk/HSdQ+uDKBn37ULmBA3kQ4xo3xAsWfz4IOKc+bFf3R8zittfSmgAVURIQ1B5OGIVM
         2ZK69269YHVQBzEjM7N5/EDNeuFxcij9iLOBpg7jz9qTz1NGXAbA9LX4OHq1ZQlVBE4J
         cdotPEOGW/87TAVDf4ZnvnaPvlPJ4z5cOZOstKm1NTOYLkkfk0t9vIIebniHDyc+2dx8
         25sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697565506; x=1698170306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERqNElzqK3ivGhZFkbR1xLkOQfN9J+nTp0C/iYJJ+VA=;
        b=DUjlHlwOKhE0jGw0manqZgFqRdlE9oFfCVG7a819N92YOtFRErrE+nJIS21MalInDk
         dX6aCxAIeBfROmkgt5UAKF91sGGRcSlPrh+7W/bLZIU7M2FO/tB57xCZ1w1lmdQ9puoc
         KOT2XNqpkZnRrTPaxd2N/mgy0XtwxTzlYpMvSmZp3NDG00OEpAMVAmpkDv+KlnWKGzkn
         rN+CvD/1eQJ30wBxyMYs+XXydnLajplFixkie8tBlYL9Ma23gyu7FY1DjY74iChsQxV7
         jpHYLvVekmif/thoFB2o2R2tTLx37gbOO1cUIJk3h0kBMWuOty2DPjd9lGJJHbPcm+cQ
         lvJA==
X-Gm-Message-State: AOJu0YwQOweWAhvH2EgJl0odI0zqRAb8eKuL8ewLlaR/pcEgWV/9aZqM
        KzqdsAyBmZxnRuQLW7dHghr5+A==
X-Google-Smtp-Source: AGHT+IHlUf16ZVZJPS3ADV9Yv03x8UI3R6UaRGantthvSPP+pLWQgx7zQmsS3AaqPA44Ed7qPZeJRg==
X-Received: by 2002:a17:90a:f410:b0:27d:4f1f:47f5 with SMTP id ch16-20020a17090af41000b0027d4f1f47f5mr2958963pjb.23.1697565505762;
        Tue, 17 Oct 2023 10:58:25 -0700 (PDT)
Received: from ziepe.ca ([12.22.141.131])
        by smtp.gmail.com with ESMTPSA id gz24-20020a17090b0ed800b0027d0af2e9c3sm6671197pjb.40.2023.10.17.10.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 10:58:23 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qsoKj-002t1w-CQ;
        Tue, 17 Oct 2023 14:58:21 -0300
Date:   Tue, 17 Oct 2023 14:58:21 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bob Pearson <rpearsonhpe@gmail.com>
Cc:     "Daisuke Matsuda (Fujitsu)" <matsuda-daisuke@fujitsu.com>,
        'Bart Van Assche' <bvanassche@acm.org>,
        'Rain River' <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <yanjun.zhu@linux.dev>,
        "leon@kernel.org" <leon@kernel.org>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] blktests srp/002 hang
Message-ID: <20231017175821.GG282036@ziepe.ca>
References: <b80dae29-3a7c-f039-bc35-08c6e9f91197@gmail.com>
 <CAJr_XRAy4EHueAP-10=WSEa46j2aQBArdzYsq7OqSqR93Ue+ug@mail.gmail.com>
 <8aff9124-85c0-8e3b-dc35-1017b1540037@gmail.com>
 <3c84da83-cdbb-3326-b3f0-b2dee5f014e0@linux.dev>
 <4e7aac82-f006-aaa7-6769-d1c9691a0cec@gmail.com>
 <CAJr_XRCFuv_XO3Zk+pfq6C73CgDsnaJT4-G-jq1ds3bdg76iEA@mail.gmail.com>
 <OS7PR01MB1180450455E624D5CD977C461E5FCA@OS7PR01MB11804.jpnprd01.prod.outlook.com>
 <29c5de53-cc61-4efc-8e8d-690e27756a16@acm.org>
 <OS7PR01MB118045AD711E93D223DCD6F17E5C3A@OS7PR01MB11804.jpnprd01.prod.outlook.com>
 <a3be5e98-e783-4108-a690-acc8a5cc5981@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3be5e98-e783-4108-a690-acc8a5cc5981@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2023 at 12:09:31PM -0500, Bob Pearson wrote:

 
> For qp#167 the call to srp_post_send() is followed by the rxe driver
> processing the send operation and generating a work completion which
> is posted to the send cq but there is never a following call to
> __srp_get_rx_iu() so the cqe is not received by srp and failure.

? I don't see this funcion in the kernel?  __srp_get_tx_iu ?
 
> I don't yet understand the logic of the srp driver to fix this but
> the problem is not in the rxe driver as far as I can tell.

It looks to me like __srp_get_tx_iu() is following the design pattern
where the send queue is only polled when it needs to allocate a new
send buffer - ie the send buffers are pre-allocated and cycle through
the queue.

So, it is not surprising this isn't being called if it is hung - the
hang is probably something that is preventing it from even wanting to
send, which is probably a receive side issue.

Followup back up from that point to isolate what is the missing
resouce to trigger send may bring some more clarity.

Alternatively if __srp_get_tx_iu() is failing then perhaps you've run
into an issue where it hit something rare and recovery does not work.

eg this kind of design pattern carries a subtle assumption that the rx
and send CQ are ordered together. Getting a rx CQ before a matching tx
CQ can trigger the unusual scenario where the send side runs out of
resources.

Jason
