Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75F8C7619A
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Apr 2023 19:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjDHTTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Apr 2023 15:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDHTTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Apr 2023 15:19:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AE359F8
        for <linux-scsi@vger.kernel.org>; Sat,  8 Apr 2023 12:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680981513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=yoNoObGAEZS+HGzL4vRcHUd467hL63i+/F3KEiO6o+U=;
        b=YiqWB0Oy3c/o0vixDLWxLCtt3x6lZIwttGnWXHMjrFJFkoXWSB69/60Q2tg88pa0K4GXSc
        GXLxDpcSy1CDFB3aGWRXbD71TEmLev8U7J4+i9MXabppQQNH2oPB62ROQ0WXA6aagTOBp9
        VuoG1I2neUbuMCwMGvkb4ldSRO6DMfI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-Deq0RNC1PX6_r89OBa7ofg-1; Sat, 08 Apr 2023 15:18:32 -0400
X-MC-Unique: Deq0RNC1PX6_r89OBa7ofg-1
Received: by mail-qt1-f198.google.com with SMTP id s23-20020a05622a1a9700b003e6578904c3so12502408qtc.17
        for <linux-scsi@vger.kernel.org>; Sat, 08 Apr 2023 12:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680981512; x=1683573512;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yoNoObGAEZS+HGzL4vRcHUd467hL63i+/F3KEiO6o+U=;
        b=b6fTx7oHvClcWvagt6/1JKsot3RZuMsjirMG5x7BYrJ7LjEPMWa3/iAhknpEcoZfWH
         My7gRM0yfRtjfTVp3VYfTUh7CTY1s2r8N60bNOfGNOZ+ouxuu0HVyi2ZTFxMZclr2WJ8
         TzEtpysURW8XrtjgglkECyusm4/3McJFftrzsjE8qtLjn2dDZFQ0iLpVJka9FXtQgOBt
         b/kEoP8nxIbmLN84MOkPj+d9eeVWHptk/sMNfWZIG5ZW+GLTiKIsh6MGhXkLNq40wsQq
         r3sv7gFPe7meuB7Vt4vaIjVzPCJAmBPrj0B866KXhM8ng5TUaOlUzTV9ngm2NQQRuPTP
         upMg==
X-Gm-Message-State: AAQBX9cLB68r0pqRP3ldFumJzNmc8BZ1ojN1vHbeERWgxa9bS3idm82u
        M00dR26d0PTpPXGdIuJtLOAv+dW79J+NM5woPu3BfgQjHv/L4hneG2kzZOD3TtEAMTPiM0qCUuw
        S+2zFc23e06XTKu3kic+6NA==
X-Received: by 2002:a05:6214:29cd:b0:5b3:4b99:7af8 with SMTP id gh13-20020a05621429cd00b005b34b997af8mr11092643qvb.21.1680981511973;
        Sat, 08 Apr 2023 12:18:31 -0700 (PDT)
X-Google-Smtp-Source: AKy350a/bMzDn/+u2WaJlNwwTgIDWH1zOyQNHn9NiTFUazhfDHMt/L9EK3JeLxWeHbB4/XltAoMWKQ==
X-Received: by 2002:a05:6214:29cd:b0:5b3:4b99:7af8 with SMTP id gh13-20020a05621429cd00b005b34b997af8mr11092629qvb.21.1680981511721;
        Sat, 08 Apr 2023 12:18:31 -0700 (PDT)
Received: from localhost (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id pv5-20020ad45485000000b005e84bbc3306sm1301397qvb.55.2023.04.08.12.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 12:18:31 -0700 (PDT)
Date:   Sat, 8 Apr 2023 12:18:29 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: question about mpt3sas commit b424eaa1b51c
Message-ID: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We've had some people trying to track a problem for months revolving
around a system hanging at shutdown, and last thing they see being a
message from mpt3sas about a reset. They quickly bisected down to the
commit below, and reverted it made the problem go away for the
customer.

b424eaa1b51c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")

I got asked to look at something since I recently at another issue
that involved mpt3sas at shutdown, so I was looking through the
history, saw this commit being mentined. Looking at it, I'm not sure
why it is doing what is doing.

It says it is to perform a soft reset, but that was already happening before this commit via:

scsih_shutdown -> mpt3sas_base_detach -> mpt3sas_base_free_resources -> _base_make_ioc_ready(ioc, SOFT_RESET);

The original submission [1] had the following commit message:

"During shutdown just move the IOC state to Ready state
by issuing MUR. No need to free any IOC memory pools."

But is now skipping more than not freeing the memory pools. It no
longer frees memory that was kalloc'd, it doesn't unmap something that
was iomapped, it no longer cleans up the fault reset workqueue, and no
longer calls the pci cleanup code. It also no longer does the things
it moved to scsih_shutdown under the pci access mutex, nor uses the if
condition that was in mpt3sas_base_free_resources.

[1] https://lore.kernel.org/r/20210705145951.32258-1-sreekanth.reddy@broadcom.com


Am I missing something, and what the commit does here is really okay?


Regards,
Jerry

