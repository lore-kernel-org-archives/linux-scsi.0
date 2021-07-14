Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C2DC12002
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 21:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23DF3613DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 21:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhGNVNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbhGNVNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 17:13:02 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A0CC06175F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 14:10:10 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h8so5079123eds.4
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 14:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=9uzONcSIwSvl/pOxJOzDp3VJ9SlzLyneKW4SatXrve0=;
        b=pF78DQd3hRcf0zfw2/aK2cvyFbKaxhNFM84q+NyCz6khrdCWBL0RQfIIAQ18tWkjgk
         w0oCVNiG4KBuOcX8yJ05jW7+ULPIRsGE81/YxRRwTVuoTqIb4doWhthGyk+L0Ck2XSmw
         sfV5WhE7w+w0ml3kUmEgHq/drUYhfzv68v0M/74TT/uRLlDyvD7wIXbUQeEAMInvCTQ+
         aCXOnzPijORzbLuJltQrChrLuPjrEs58ztFRwc3p0ZhhEtPaPk7pHiFBSZfqltFXBuzd
         fo6W7juN70fUmtngdPyPmyelVV/iQFrhQjdR+EU5qISBZGJKGGsSpr9tgW6wgrKwJL9X
         J9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9uzONcSIwSvl/pOxJOzDp3VJ9SlzLyneKW4SatXrve0=;
        b=s6iNGmBSTHZ+kwiYjTbP6RlBt9RxGPGUuvm9eOS3+M139fMaDZsR5L99GVOTg3moFb
         UtGlVikLZWxzB30/L1DPo/5Ica+RX1AwAH7E9TWGszmQP0DWzTw3wdzSK7Zmh2EmK98b
         YCJE6zpJZ2uA8vCukoG8kJSz5KqlDbzVfKghT7CQ0biS44VbJAVuGShrEQnnQsQVhl6L
         uiu2Nx3t53JouZqQTJGBh3BvQs9H8TZHqJP6ThFknEC+RFbqP6CSBmVxIR1G4MUZUh1S
         ZyglfTBcE0RlawYmuAQzrGG6AGRgZfHRVetRLhkCJjrvizTS76uIsVW0GbvTPr8ihlx9
         0DTQ==
X-Gm-Message-State: AOAM5308RB84tbQqpfbx01SIZ7WxztnGn3Kgz7OvYIM6TBn3phhsOG+S
        zJappCP6UUyE9G4bjBpY6JM=
X-Google-Smtp-Source: ABdhPJzBoonaeFgvZVh++0NBlAbhFE7XtYJhbj1aiIVZwDCXznHtMxNNtlEI2LlwNgWKQv0FpycQKQ==
X-Received: by 2002:a05:6402:b4e:: with SMTP id bx14mr432262edb.158.1626297008773;
        Wed, 14 Jul 2021 14:10:08 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec65.dynamic.kabel-deutschland.de. [95.91.236.101])
        by smtp.googlemail.com with ESMTPSA id ce21sm1168195ejc.25.2021.07.14.14.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 14:10:08 -0700 (PDT)
Message-ID: <fa22a560c024cb62c397f2f07b7d6269c7ff1d0d.camel@gmail.com>
Subject: Re: [PATCH v2 06/19] scsi: ufs: Remove ufshcd_valid_tag()
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Wed, 14 Jul 2021 23:10:06 +0200
In-Reply-To: <20210709202638.9480-8-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
         <20210709202638.9480-8-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-07-09 at 13:26 -0700, Bart Van Assche wrote:
> scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
> 
> shost->can_queue to hba->nutrs. In other words, we know that tag
> values
> 
> will less than hba->nutrs. Hence remove the checks that verify that
> 
> blk_get_request() returns a tag less than hba->nutrs. This check
> 
> was introduced by commit 14497328b6a6 ("scsi: ufs: verify command tag
> 
> validity").
> 
> 
> 
> Keep the tag >= 0 check because it helps to detect use-after-free
> issues.
> 
> 
> 
> CC: Avri Altman <avri.altman@wdc.com>
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Bart,
you need to rebase this patch.

Reviewed-by: Bean Huo <beanhuo@micron.com>

