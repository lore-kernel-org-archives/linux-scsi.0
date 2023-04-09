Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA5BC7619A
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Apr 2023 00:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjDIATP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Apr 2023 20:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIATO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Apr 2023 20:19:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8526188
        for <linux-scsi@vger.kernel.org>; Sat,  8 Apr 2023 17:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680999506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fthLfgsrmO+VQ/3mqtYaCeVMpX4ccu17z3fIGbvqXQw=;
        b=OdReJVnaXDnCoeHXQEqPWvvC7HnizjeDlZfd/gH6u0LTxLrY6VOshkIaUJx24u5g/JATEr
        dhCXTXBgwkF32iHPGvPX+YYjQprPNILuVm8ZPILru4W9wXy0y8bmdHvVydMPlQ7+psjgGL
        8eh4o2rNRyypi6fk9BP1pee3IGK5JfI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-vZ2ml9xTNDmwEkmcZsyNLA-1; Sat, 08 Apr 2023 20:18:24 -0400
X-MC-Unique: vZ2ml9xTNDmwEkmcZsyNLA-1
Received: by mail-qk1-f199.google.com with SMTP id s2-20020a37a902000000b0074a28a891baso10285831qke.18
        for <linux-scsi@vger.kernel.org>; Sat, 08 Apr 2023 17:18:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680999504; x=1683591504;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fthLfgsrmO+VQ/3mqtYaCeVMpX4ccu17z3fIGbvqXQw=;
        b=5W61Y+K3jv2gUClW9+DFQXy3BldrV8I9o9GzI2IrNQ24MZ+UBl2AQVC2FyQanqVzRC
         3/8Vyc9VyqiSym7I0+Rq6TsIzjinE8BJOVUtUwRdNL14sMy4Ak4mzgeNr86p8dkC2kld
         2280JdP+3g0V/IjlFeqyWvSmWiyjtqQEOh/K3o2ysjiqFZzMjtZbTFIGSUPSTRnEmakT
         Vsh9v9uRuzfaynyPXL95Wrqd/KAkB9b+u13HfuvUr0YvKM5Lb8XIk3YGuxT7Li3mUH8X
         FwzX+gw4uzLU6Ij1Rry+DL6bDV7KQg+vWfNupPXGGKj1HUG2pT5nSXafBpHLFRnM5P67
         c5Xw==
X-Gm-Message-State: AAQBX9d3nAlnu+Xc7kS3Ptv29XrdTNNh4KVhxtELE5xGWG57olTZLs33
        /YFQ3T5FVEQF2tBvy7Zx3YzUwTkRswykedrce6pZMylGiJHt1VNUm0rHGj8qxjLmNPaT/Ay5jt5
        DCSaI5oZDnn5PAoewFABMEA==
X-Received: by 2002:ad4:5bc8:0:b0:5e6:1bf5:1ae0 with SMTP id t8-20020ad45bc8000000b005e61bf51ae0mr4505493qvt.18.1680999504443;
        Sat, 08 Apr 2023 17:18:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zub/i0ia+kTS4JpAt+IWiBML6QH+0qoSGLmZ78BUF4djOvneBTcjWxstnv9N/gsCm3i5OGsw==
X-Received: by 2002:ad4:5bc8:0:b0:5e6:1bf5:1ae0 with SMTP id t8-20020ad45bc8000000b005e61bf51ae0mr4505482qvt.18.1680999504197;
        Sat, 08 Apr 2023 17:18:24 -0700 (PDT)
Received: from localhost (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id m16-20020ad44a10000000b005dd8b9345a5sm2366787qvz.61.2023.04.08.17.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 17:18:23 -0700 (PDT)
Date:   Sat, 8 Apr 2023 17:18:22 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: question about mpt3sas commit fae21608c31c
Message-ID: <mn22fe7cs744nbtl55kjgtz23udaw2qk3ye4bafvnsczowaiit@c3xrd3pw22jp>
References: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
 <hwlhzyqc42lnkifu6izsrx4lpqgjltjnrrcyzxhxmawgx3emeg@qxadku6yknpa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hwlhzyqc42lnkifu6izsrx4lpqgjltjnrrcyzxhxmawgx3emeg@qxadku6yknpa>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 08, 2023 at 01:59:21PM -0700, Jerry Snitselaar wrote:
> On Sat, Apr 08, 2023 at 12:18:29PM -0700, Jerry Snitselaar wrote:
> > We've had some people trying to track a problem for months revolving
> > around a system hanging at shutdown, and last thing they see being a
> > message from mpt3sas about a reset. They quickly bisected down to the
> > commit below, and reverted it made the problem go away for the
> > customer.
> > 
> > b424eaa1b51c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")
> > 
> 
> That should be (grabbed the wrong commit id):
> 
> fae21608c31c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")
> 
> > I got asked to look at something since I recently at another issue
> > that involved mpt3sas at shutdown, so I was looking through the
> > history, saw this commit being mentined. Looking at it, I'm not sure
> > why it is doing what is doing.
> > 
> > It says it is to perform a soft reset, but that was already happening before this commit via:
> > 
> > scsih_shutdown -> mpt3sas_base_detach -> mpt3sas_base_free_resources -> _base_make_ioc_ready(ioc, SOFT_RESET);
> > 
> > The original submission [1] had the following commit message:
> > 
> > "During shutdown just move the IOC state to Ready state
> > by issuing MUR. No need to free any IOC memory pools."
> > 
> > But is now skipping more than not freeing the memory pools. It no
> > longer frees memory that was kalloc'd, it doesn't unmap something that
> > was iomapped, it no longer cleans up the fault reset workqueue, and no
> > longer calls the pci cleanup code. It also no longer does the things
> > it moved to scsih_shutdown under the pci access mutex, nor uses the if
> > condition that was in mpt3sas_base_free_resources.
> > 
> > [1] https://lore.kernel.org/r/20210705145951.32258-1-sreekanth.reddy@broadcom.com
> > 
> > 
> > Am I missing something, and what the commit does here is really okay?
> > 
> > 
> > Regards,
> > Jerry
> > 
> 

One last thing. The issue I was looking at a few weeks ago turned out
to be that mpt3sas frees and unmaps the trace buffer in
mpt3sas_ctl_exit(), but doesn't appear to tell the fw about it so it
keeps trying to write to the trace buffer while the soft reset
happens. I don't know if should be doing something like
ctl_diag_unregister(), or something else? I thought I saw an email
from Tomas, but couldn't find it so I thought I'd bring that to your
attention.

Regards,
Jerry

