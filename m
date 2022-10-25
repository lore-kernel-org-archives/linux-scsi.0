Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43939C38A2D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 12:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiJYMTT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 08:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiJYMTS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 08:19:18 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2203181D9A
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 05:19:17 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id g16so7341895qtu.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 05:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KGIEmyBbcrFhYCeupjDEHPoFpQFVvDingmDc937Z/U4=;
        b=ZaSJ0qLzqLrztrR6stMTBOI96WL5BMwVYmFHc3p5UiTXTrEMZpRhufrv1+eEjcsyjq
         +Fxws2uKxUPU8HCdyh47STp+o6f1gGsanbnHWRYZKRJig9Y8YiINQKyigfpEX45r9dTA
         UDsoShVDlIWHV6S1DR37+gF0vz2hLgJLSE4+cndAslG64tW3EADbHyWP9BgVnv81DJQM
         8bf9UtgMCtaoNwXkuSrFme6TEVmbQRtE09hP7Y4BXvS2HFnSC845PP8tWztzBzxbrxqd
         MN1uW1bC9M67MCV0IGl9Bhr5jtvpjtSieAdwpV4ih/tE33TGHbWnjE+gcBYKXvfeMSWI
         0h0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGIEmyBbcrFhYCeupjDEHPoFpQFVvDingmDc937Z/U4=;
        b=DNO/lCmU7LnokNlhA4wXweErKtOZqsaRlLdiWlnHAzSDAZSexxnR3psI2mulv9sqaw
         17ElPlxdfsOgPf8ia+O2yDDkhq0KjBKKu/TndcMtHDWk9IatZVNSWInjyxcDPK6aHDD7
         TGftKSivY7H7d1bHVL5ZddT1qP1cldrxq0a9Vb4HQqkr7eRLLpvGt8S2sakDkrUVJGKp
         rzufD00zRrB5Qf79VYQpg01Y3FUxw/0dNUbx/LNbmg8Cfx6y3Q+8rrYrzySuS8I1rPNW
         qO2dlKek+Rr9qIOa6UyeYO2zNhBKcp3adQaof/L5Z/a2u/nKc6X3WgfEVr4XdmJ1xNoG
         XFSg==
X-Gm-Message-State: ACrzQf1oLhXmoFBz3zAQJvFYFZD0QBqmDbKjwdCvCtvZJVsa55sxfKS4
        40N8rMve85saBjQ+Gs6Kx0RwgeGY6Nulrw==
X-Google-Smtp-Source: AMsMyM4j8TkbeYL0ULIom1BNqzJMgVwezdkLiGMLJt6A7My42zqLjZ0PwqYLWbWOkRsHwHB0z3sxjA==
X-Received: by 2002:a05:622a:43:b0:39c:eb15:c2ee with SMTP id y3-20020a05622a004300b0039ceb15c2eemr31910141qtw.331.1666700356812;
        Tue, 25 Oct 2022 05:19:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id m24-20020ac86898000000b003999d25e772sm1492197qtq.71.2022.10.25.05.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 05:19:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1onItl-00EMDr-JR;
        Tue, 25 Oct 2022 09:19:13 -0300
Date:   Tue, 25 Oct 2022 09:19:13 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: Re: [PATCH 1/5] sgl_alloc_order: remove 4 GiB limit
Message-ID: <Y1fUQZdpXUTPUovP@ziepe.ca>
References: <20221024010244.9522-1-dgilbert@interlog.com>
 <20221024010244.9522-2-dgilbert@interlog.com>
 <Y1aDQznakNaWD8kd@ziepe.ca>
 <665f8dee-6688-60d1-5097-49f9726c38ec@gmail.com>
 <Y1bMKU5nq5DXYdbw@ziepe.ca>
 <9b5f5e2b-bf37-f986-469f-107eb463924b@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b5f5e2b-bf37-f986-469f-107eb463924b@interlog.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 24, 2022 at 03:58:22PM -0400, Douglas Gilbert wrote:

> Changing the interface of sgl_alloc_order() will break these callers:
>    drivers/scsi/ipr.c
>    drivers/target/target_core_transport.c
> 
> due to change the type (and size on 64 bit machines) of the fifth argument
> (i.e. 'size_t *nent_p').

Yes, you'd fold those small fixes into this patch.

Jason
