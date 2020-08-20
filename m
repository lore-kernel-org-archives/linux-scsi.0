Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA795C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79932207DE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L9rMDH8o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHTS40 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 14:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgHTS4Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 14:56:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF83EC061385;
        Thu, 20 Aug 2020 11:56:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l2so3147269wrc.7;
        Thu, 20 Aug 2020 11:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D2knyK2NI/0zEQhqBEmeYzCiqIf2nh2bPQqBRntv250=;
        b=L9rMDH8oLiXXtnMRb71uBQEgwEYdT4SmnwHQx7cYgBlDWxuaTcQCVtpMEnl9uJS5qs
         LPkgzZ64LGJEEBiyQC5xuTQMTYWYfB3fKvXUM7QH5u5tvcs8r00h8W5HeZ20lkB2+Dyp
         7PMtAj0ISWB8MSK9nrP2uGnmEebAf2wND8O9yOPRFxHbxGmqRNDjK0gJSkRtgQ+5OYXG
         xVAetHKQCXde5uZOlIhcl1ZGv4Xv+kQtX7yOtsbmSmiaiDHcILNlXvD1We2HVxQdgaof
         XUhactJxk2tEbs2EUqnGjg3SiSYb4v00kfkEDR9uCDRLKGB+iVR7v6A9cfcG39NyFsH+
         LWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D2knyK2NI/0zEQhqBEmeYzCiqIf2nh2bPQqBRntv250=;
        b=pZ8tuHeWYBQAER+1YGt5VMoPikvVTjbF1eKaopUD6zUZldEGKHny30DicNorhQcXZz
         1sNwnZ4GVgwXsUzJSiO6RO3k7tzGvA8p+47enfwrd2zWUzZ3qmuqqp0QjfJ80K26PeWZ
         a5Z0+EN9mUTQWaS/XDMwQFCB9vHAeGWSMY9gPSQabr860QZlMDqTTv61RKOBdXJoSVZR
         zRRmR5VzpZNjJBmz+lFnoe7gmroaZf4t0nEczEaZIF9qZmDG0TN66HieesdhrVDVejas
         tQAtJ5+eFHHlqTESHR6zDHiFmzWKQs62ZngHyqKd+X9iVU7s1KYXedQBwVCteYKBTG/c
         QJCQ==
X-Gm-Message-State: AOAM530YW/i0bTEc/wgEXtaWZ8eQg8GWFWOPQZt7hP82+tZW7Y7Wsf5x
        8G6uB/1fsSjqeCsCEhtvifxT1r4qYWMtPfT6
X-Google-Smtp-Source: ABdhPJwffCaCdS+J4D1IlMtWs13gBhzP2wByzriIfwKQ4zXneAL7WWyECZkTmYUryu821q1xxKLb6A==
X-Received: by 2002:adf:fb87:: with SMTP id a7mr117350wrr.390.1597949783580;
        Thu, 20 Aug 2020 11:56:23 -0700 (PDT)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id 124sm5800326wmd.31.2020.08.20.11.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 11:56:23 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Thu, 20 Aug 2020 19:56:20 +0100
To:     Joe Perches <joe@perches.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mptfusion: Remove unnecessarily casts
Message-ID: <20200820185620.ysfdpzjj4qrquqbz@medion>
References: <20200820180552.853289-1-alex.dewar90@gmail.com>
 <a99fde707b367b0cee126b596b2dc7a74dbb84e7.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a99fde707b367b0cee126b596b2dc7a74dbb84e7.camel@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 20, 2020 at 11:53:58AM -0700, Joe Perches wrote:
> On Thu, 2020-08-20 at 19:05 +0100, Alex Dewar wrote:
> > In a number of places, the value returned from pci_alloc_consistent() is
> > unnecessarily cast from void*. Remove these casts.
> []
> > diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> []
> > @@ -4975,7 +4975,7 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
> >  
> >  	if (hdr.PageLength > 0) {
> >  		data_sz = hdr.PageLength * 4;
> > -		ppage0_alloc = (LANPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
> > +		ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
> >  		rc = -ENOMEM;
> >  		if (ppage0_alloc) {
> >  			memset((u8 *)ppage0_alloc, 0, data_sz);
> 
> If you are removing unnecessary casts, it'd be better to remove
> all of them in the same file or subsystem at once.
> 
> Also this memset and cast isn't actually necessary any more
> as pci_alloc_consistent already zeros memory.
> 
> etc...
> 

Good suggestion. Thanks for the feedback :-)
