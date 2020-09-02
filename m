Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A15C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 16:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80CE7207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 16:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GuRjtYID"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgIBQDm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 12:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBQDl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 12:03:41 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13ADC061244;
        Wed,  2 Sep 2020 09:03:40 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z4so5821486wrr.4;
        Wed, 02 Sep 2020 09:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X0Rt7IIHXTzck/+bd2htT31QzTnaNifFk7gmI1vahEg=;
        b=GuRjtYIDNnozpuBXnQHDNYjl7QF+jagnYiGA54NPU5IH44jdy6VNhSXpzEEqYVRazk
         M2M7klztiK0Zw/CsHgGYs+HjAl+ptK/gcAMiPQcRlbZOUe/gd3Sskui/Vt88olTY08Hb
         cllZZs0IYSqpkCiEKezTXbpez4g0q2IB9PUYdIPIWZ2ZX5iz3SAA5ux5ShVtn1Rgkuf/
         82mDl8UxrmRYRiW7T1NcBJjQDqIgb3Y1tYCAZbGG+5r7NQQc6gC7EDMAK7hXp8P741CF
         nyT9CG9LMsBHBMOHG6WmGTOnA2cddZwKZV6Piu47gbM+rHbI27JZIkYy2HO5gST7GXIt
         cuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X0Rt7IIHXTzck/+bd2htT31QzTnaNifFk7gmI1vahEg=;
        b=oJlCKtIhd8TckHr6scFjVFWCEkcaqYpWekW0/GcwTGadnfwl1BEQ6d8CjnZANeAly/
         EjrqmlUHFZ874dRpQJP2S5Ubhl44/Kr3HK6FL/2v+tt2cKfRJcUOu6CeIiTVc71eOudX
         l1/nTUMdMalu7ovB6b8K+sk+8fZ/Yw8nu6rhzdZs+d7RWdq5F7Y01oYH4/4had1hfQqc
         2drL9mHpUK/AIUwJ/tR0jWQHyJVbgTAQXFUCDJik8s2jBvHTKsN6S/yHD470v8eYdhBu
         qPlmSOne0zr1g4XHjgYckxQ6HxhL2eSBc10m6Ho6B2ZU2qg7IYf8dA1OTaIx74gdiXIY
         jkWg==
X-Gm-Message-State: AOAM533IvGFvhqDzmxmSNcOv+Seb3N8nAe1UqvWjkSn5nbSskBz6XoTe
        rTLLdr1/L/fG1f3UZD7eroc=
X-Google-Smtp-Source: ABdhPJzlpCe7lWxaXiZONhYsMHB19rIJPbnbQbs8FtQSMeKK2Jkhei6HAF0HtcryDJ65bBa9O/kZkw==
X-Received: by 2002:adf:ef48:: with SMTP id c8mr7933606wrp.370.1599062619556;
        Wed, 02 Sep 2020 09:03:39 -0700 (PDT)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id m185sm217035wmf.5.2020.09.02.09.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 09:03:38 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Wed, 2 Sep 2020 17:03:37 +0100
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        njavali@marvell.com
Subject: Re: [PATCH v2] scsi: Don't call memset after dma_alloc_coherent()
Message-ID: <20200902160337.kvuujxodeokrbn4d@medion>
References: <20200820185149.932178-1-alex.dewar90@gmail.com>
 <20200820234952.317313-1-alex.dewar90@gmail.com>
 <yq1eenlezwf.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1eenlezwf.fsf@ca-mkp.ca.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 01, 2020 at 09:22:44PM -0400, Martin K. Petersen wrote:
> 
> Alex,
> 
> > dma_alloc_coherent() already zeroes memory, so the extra call to
> > memset() is unnecessary.
> 
> One patch per driver, please.

Nvm, someone's already beaten me to the punch!
> 
> Thanks!
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
