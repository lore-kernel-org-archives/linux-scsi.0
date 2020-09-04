Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451AFC54F42
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDABC24894
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 18:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599242631;
	bh=L+IaHSGdBw9KUoLImRwoPA6TdKHrTD9HEZwevJ1mrhE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hvVCwqeqVk1A7p6DTY9qHoPiLqqWorzHrvMuQWzThdXovCeNOOB/pH2Ej0M9rZk3e
	 VJwXvecIyI7pR4X+T6Wn9+fEtxq0YyA3A9bVXF1oxlrqruWJKONcLnrhr6yw181KGx
	 6sj3u9Jgo4EWkO5XshDusPqSOb6zBrOZjGVWlBCI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgIDRIB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 13:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgIDRIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 13:08:00 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BCDC061244;
        Fri,  4 Sep 2020 10:08:00 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id j10so3330134qvk.11;
        Fri, 04 Sep 2020 10:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=918xF9/TxEdi5FKvlN1Hc01QrtvkdS/H0R8ZEDh1m/w=;
        b=Y+l+zXkj3iZuqa7nZb8fCT0usDu58TsmwrbKiLnARLXhpx48LTNUg1vzSWZYgs/13+
         c1SW4HWkRuzguFhcVaFubEzMo5JXetRpeb5IaKJOis3Lc5y9CwOET924hMWP2Vria8nd
         lvYqy0/NenC9vVpu/Yp1rWyHWoprju0xCwWUlf1mTx/o9Qlbcgxj1lElbOEp/dFdt8+Z
         BGaY4GUaBVJUZsazZYrwxDJExUCqoGF7BDCUdmm2aARQzGWk5MuT3kglx8jdUMvuyY7l
         WejixWyeWg1d4quZafz/tyWtoFfO7ikEoRS/oCUdYDVmPmpvif1r+0wTn3/t+wi9jFPm
         HbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=918xF9/TxEdi5FKvlN1Hc01QrtvkdS/H0R8ZEDh1m/w=;
        b=V7hafMwmvMIeYgH9CTFN841qa5j+f9rTlAlZj71oloSzqcZDhuFy7MPkQJLrGvHwEZ
         l6SmfKNfcWkykRDhfMUtNQxqwki7p+3ciiOhm1Znp7ODIfdpb5oAw6MzIyw/I2IhfjQv
         epDPLzm6o7j3c2j+k7mT41V0VcaxKJ/Mr4bIvKiQ6EXcl31B/MNNZIWuk780bKmIcwFQ
         cy1qH+zuSICgf1g56HuGxas+rcL+BTDMeHYqgoER8ImqAbRJyma7+KfUJoXNnCXgOEW6
         hIQ+YjRCgrNS3k5VllIGvNmdG1J0tiktFGa4byjfQe9Yd9iJjSBIb50d8JKM9cTZeB01
         SuMg==
X-Gm-Message-State: AOAM531Xcz2pfqh5KuD8mUxmUYL3AF8xngJAFo4K1IePYVp3dVTDn4c9
        iCkZLeMxh33azDjGPRJbVVRAFv4nO9cCzA==
X-Google-Smtp-Source: ABdhPJz64ED1455jnMV0eSDG6iae1M9P2FH5Z/qtI61QyZxv8e+JfUDQeaVwUy8YmSVR4hm6jbnxYw==
X-Received: by 2002:a0c:e981:: with SMTP id z1mr8597033qvn.15.1599239278260;
        Fri, 04 Sep 2020 10:07:58 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:f2f5])
        by smtp.gmail.com with ESMTPSA id c185sm4950309qkb.135.2020.09.04.10.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 10:07:57 -0700 (PDT)
Date:   Fri, 4 Sep 2020 13:07:56 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Akshat Jain <akshatzen@google.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        linux-ide@vger.kernel.org, John Grass <jgrass@google.com>,
        Thieu Le <thieule@google.com>, linux-scsi@vger.kernel.org
Subject: Re: Question on ata_gen_passthru_sense interpretation of fixed
 format sense buffer
Message-ID: <20200904170756.GC4295@mtj.thefacebook.com>
References: <CACqKpR-5=bDwODQFfMY+o8-XJMCQmtLVAOiCEY8ApFwQr04A8A@mail.gmail.com>
 <20200817174215.GB4230@mtj.thefacebook.com>
 <CACqKpR8i=9A6kb05yCyh39HMZ8aEhEGacXTCvQKyUS=nYkqRiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqKpR8i=9A6kb05yCyh39HMZ8aEhEGacXTCvQKyUS=nYkqRiQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

On Tue, Aug 18, 2020 at 09:12:13PM -0700, Akshat Jain wrote:
> To answer your question:
> 1. Yes we will start working on a patch and send it for review.
> 2. We found this issue during our code review.
> 
> Another information I need to bring to your attention is that many
> user libraries today decode the fixed format sense block based on the
> format today's kernel (ata_gen_passthru_sense) provides. Rather than
> the format specified in the SCSI Primary commands - 4 specification.
> If we were to correct the field offsets for the fixed format sense block.
> It may break such libraries. How do you assess the impact
> of such a change?

So, I don't know. Given that nobody tripped over it till now, I doubt fixing
it would cause a lot of trouble but at the same time it isn't a real
problem, again, given that nobody has tripped over it yet. Maybe just fix it
and see how it goes?

Thanks.

-- 
tejun
