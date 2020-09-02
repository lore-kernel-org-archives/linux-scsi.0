Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25D2C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7DCB207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QSJwp82j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgIBPvT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgIBPvS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:51:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B48C061244;
        Wed,  2 Sep 2020 08:51:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e11so3442831wme.0;
        Wed, 02 Sep 2020 08:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dzKY3NK+bPcp95h+ajPimug08LR9zIvaotW8xkZTp8Y=;
        b=QSJwp82jwQlpRQ173CqB+2lwvREIreH2XPy6w+aYPSRH5xOZQeqXclQ8lxnrbJboSD
         nZUz0qQG15+qEpJPEsTfg2qfHBKDyo+3yDry9sSGH2xl/OdChZk97wS+0PwExJ3sP14R
         6yp9NJoomQCmAIUscEYEiPR7DU6llo1AXTS1/6PdCPnPAf8DMVG1tfR+SIcGEW/eBBaM
         cpIm8Kb6sFHYrRyhTYnOo9GBXeF0AclXFLMGDvyXJTj3tE+bTQ+vM7Lb/cDiWMDH+9iD
         UptJbo2qR1jNKHICbjMiOses8rmzJlcVLA0VtIAKObiiWHJgLstRKrxgU/oANJ6pnYoH
         GX0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dzKY3NK+bPcp95h+ajPimug08LR9zIvaotW8xkZTp8Y=;
        b=Oky5S7YLhNvyUP0yGf2I2KQN85Y+Ppu38K+RHAtx8Ec3lYwlE731R7UvFs2YiWgPgo
         6Kyv2XH6r+p9qobHEKQ9kkFQeQCcZF25+G8xon5p+9Y6XirjhXtKMpCWnrbh8tqx8++4
         CCAnvnkAlTgKnCg857I3pILHHZPeWfdJsYQE7HNnFncKPbO+uJov5jSmeZNJpErFAZH3
         Bf6EWFP8Mogu4BHcCsh/Kfn1nOukbjHhLaVtMlA7Z1BUIBIIzlIHHCaGVsdL5XULV2Hw
         Qn8Ebk7WT2jkMHtkREgqf9nbR6C/3yh27XyTPKCaZigkBLKTVWaUfuKAyOh1caj+Dwg6
         V8WQ==
X-Gm-Message-State: AOAM5335kZ+N4DpmVvy6+9G0PIpaR8KQOJS1ni2Qnnyc36YSf05LfWN3
        n01vSnvD0g3JHmjP1pygCPU=
X-Google-Smtp-Source: ABdhPJwAFrZJGRFUqoWN0L52cBSPeBinyeOxBCh5wyL5+14HTA0oQoA6n7B39XUVnqvUbla+quem7g==
X-Received: by 2002:a1c:bbd7:: with SMTP id l206mr1350845wmf.185.1599061876398;
        Wed, 02 Sep 2020 08:51:16 -0700 (PDT)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id n11sm67365wrx.91.2020.09.02.08.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 08:51:15 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Wed, 2 Sep 2020 16:51:14 +0100
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        njavali@marvell.com
Subject: Re: [PATCH v2] scsi: Don't call memset after dma_alloc_coherent()
Message-ID: <20200902155114.bscqz3a5mdp27toj@medion>
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

There's a single patch for QLA2XXX already submitted: https://lore.kernel.org/lkml/20200820185149.932178-1-alex.dewar90@gmail.com/

I'll send separate patches for the other cases.

> 
> Thanks!
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
