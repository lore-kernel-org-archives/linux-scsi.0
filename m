Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DF3C7619A
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Apr 2023 21:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDHVAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Apr 2023 17:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDHVAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Apr 2023 17:00:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C1A49C6
        for <linux-scsi@vger.kernel.org>; Sat,  8 Apr 2023 13:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680987568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JB083fTTSxcCs2UaKyWljOb6rAwe9wu+A7E1B77ylxo=;
        b=XoghHeQlKKXcfLnw60R9bVwO6GCbUKZx9M/njBXe0uVeUKI8iDB5nHkbcR/jUzuO1bmF3n
        UnGjlIOMkzJhSC50y2ZJxgaONopD2KAAdxoHNBr7RILeQhjAqLLwR+85gO+bBgpY2A17HA
        f57NSpM0muzBd785g2w+GxTG16dQb7k=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-O8DAQJdINgmmn0p8VIhx0g-1; Sat, 08 Apr 2023 16:59:24 -0400
X-MC-Unique: O8DAQJdINgmmn0p8VIhx0g-1
Received: by mail-qv1-f72.google.com with SMTP id l15-20020a0cd6cf000000b005df451a51ddso16689375qvi.9
        for <linux-scsi@vger.kernel.org>; Sat, 08 Apr 2023 13:59:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680987564; x=1683579564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JB083fTTSxcCs2UaKyWljOb6rAwe9wu+A7E1B77ylxo=;
        b=CGDPZQn5j19C9Kdaa3NeTf6adKoSoExhyNIfZLmpTI0Fb92tyBhD8PnMnSRovijy7w
         ePBD1nZg1h7mEgb+fU8lwSA8s8famFhW23wxqRiRWAN/0XwczIS9betSQrYMdsxWAuy6
         6Hp5xO88wwwW1g0oa3k3uP811ZKnCnvUDeya+mXnlz2f1Ipr24yXFaWRGBpMdWKmNcoQ
         ZfOw17IFGA0Aoe2FZmIQr+uLyAVIBe7s777Ka2YEPvoDAGknjijCXLwDDYF7WKRBhoNA
         L4uBGcRGzQe2VuSXaCQ49OZqRQV+0EEE5S1BmzxFuWL7g4ETSEMPjkjIXNgiXu0K9pD6
         zABA==
X-Gm-Message-State: AAQBX9cxsfdYCwIJsN/pvFGga8FEEkn+cKuJyjlKQ1zBsvHrP8bmHDYi
        qENpoXxXNi5aL+j7Q8BeDVY4o+EB7kelobZiRy4xokPtlgIrWdIbyrZ4RvkfzcgXcI1MZEBB5Lo
        EgnlydmoFY/TRnFZfWbf2cQ==
X-Received: by 2002:a05:622a:1c8:b0:3b6:323d:bcac with SMTP id t8-20020a05622a01c800b003b6323dbcacmr11453639qtw.32.1680987564322;
        Sat, 08 Apr 2023 13:59:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350aYUbzmXXNfn+2D5TYwhbESQknNyeaqwFmbX9EPTvGd9HoI3tRYmadT5MvPqFYYQ/X3JjklCA==
X-Received: by 2002:a05:622a:1c8:b0:3b6:323d:bcac with SMTP id t8-20020a05622a01c800b003b6323dbcacmr11453628qtw.32.1680987564102;
        Sat, 08 Apr 2023 13:59:24 -0700 (PDT)
Received: from localhost (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id q75-20020a37434e000000b007485a383921sm2205619qka.116.2023.04.08.13.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 13:59:23 -0700 (PDT)
Date:   Sat, 8 Apr 2023 13:59:21 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: question about mpt3sas commit fae21608c31c
Message-ID: <hwlhzyqc42lnkifu6izsrx4lpqgjltjnrrcyzxhxmawgx3emeg@qxadku6yknpa>
References: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 08, 2023 at 12:18:29PM -0700, Jerry Snitselaar wrote:
> We've had some people trying to track a problem for months revolving
> around a system hanging at shutdown, and last thing they see being a
> message from mpt3sas about a reset. They quickly bisected down to the
> commit below, and reverted it made the problem go away for the
> customer.
> 
> b424eaa1b51c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")
> 

That should be (grabbed the wrong commit id):

fae21608c31c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")

> I got asked to look at something since I recently at another issue
> that involved mpt3sas at shutdown, so I was looking through the
> history, saw this commit being mentined. Looking at it, I'm not sure
> why it is doing what is doing.
> 
> It says it is to perform a soft reset, but that was already happening before this commit via:
> 
> scsih_shutdown -> mpt3sas_base_detach -> mpt3sas_base_free_resources -> _base_make_ioc_ready(ioc, SOFT_RESET);
> 
> The original submission [1] had the following commit message:
> 
> "During shutdown just move the IOC state to Ready state
> by issuing MUR. No need to free any IOC memory pools."
> 
> But is now skipping more than not freeing the memory pools. It no
> longer frees memory that was kalloc'd, it doesn't unmap something that
> was iomapped, it no longer cleans up the fault reset workqueue, and no
> longer calls the pci cleanup code. It also no longer does the things
> it moved to scsih_shutdown under the pci access mutex, nor uses the if
> condition that was in mpt3sas_base_free_resources.
> 
> [1] https://lore.kernel.org/r/20210705145951.32258-1-sreekanth.reddy@broadcom.com
> 
> 
> Am I missing something, and what the commit does here is really okay?
> 
> 
> Regards,
> Jerry
> 

