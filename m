Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DECC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 09:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15D12206DB
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 09:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AoErrPD+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgIKJJj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 05:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgIKJJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2020 05:09:36 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2C0C061573;
        Fri, 11 Sep 2020 02:09:35 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id i26so12776418ejb.12;
        Fri, 11 Sep 2020 02:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Bp1bOXWpBW7xzPXZ3ZxvYtrmFHDxcf8OQZ+i0KC0UU=;
        b=AoErrPD+qrhwGcDvfNqT6OUGIyZYBl1CdW3NeuiUtAUwJ81YiW7prlQgPZiUhRt3DG
         Al3JCs1h2azPGHtzzd4u5MDTiPAg45Oy9b53hMVMMt06uflXgrNx1G6Fd4Ynk+s3abgP
         rh6JOuRCfYY3lPxlnFh8KOsBAXXzWoGURBEFL1U7PDCSM2SCvh/J8FlhqEqnhWVgDFsN
         JWCb8BRT4LIn/5MKmYAcThCLEeOqK1RB2cXjxMioWUWuLfMhs1/QxmPLl4xAQ77vj7Oc
         1s+gKjiObs/kxkN9xK4rN2bvdlK9jyTG81x26JzzxHlTSgvvoOUCFKRVRA9oyabwsMdg
         P62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Bp1bOXWpBW7xzPXZ3ZxvYtrmFHDxcf8OQZ+i0KC0UU=;
        b=eNsWu7HNK6MNAKs7YM04KfGstTsRMm4uYWZn1tTNlXQvVYY1iEfs2gM/z8LBsvLlk1
         N7KcE7+SYDcMmAu8Bc46e2dAtQBgl8mCkyiRrpGJqesWtevcFj/ITLB1pzaw9imqpJnm
         Uf21iHH9QaTHb1F+ZTmKZtu6YefNTBXHDMorR1LD7IWFEUlE0rXTT+cqli5eczLVlo13
         wbN+JUCKHywLdl5eqXfF0JExRXuj5Y81+orQwUtKmB8W2Wu745PXhOBoYtxtDjMlwhSD
         IvSkTFwQGARavSoP/YgR/DWda5j7tdpRHD/b1yioUYiw7LSi/rRdVjzJ3tGgWQW21H+m
         o4qA==
X-Gm-Message-State: AOAM532xlZnRYRR18cHrpXEor3HNkvSgFEjSrtrkNSEEqwEiDIEP+PgB
        VK4ds9f3fUHjAO1VpLxtL9I=
X-Google-Smtp-Source: ABdhPJwnPRlkAmFeY8wHJyQPHx85HxdD5H38Ly9l7RTwHl9JaRd86G75DM7dJ4DdksRfA/Wzh9U9DA==
X-Received: by 2002:a17:906:9a1:: with SMTP id q1mr1065673eje.30.1599815374057;
        Fri, 11 Sep 2020 02:09:34 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.googlemail.com with ESMTPSA id y25sm1156217edv.15.2020.09.11.02.09.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Sep 2020 02:09:33 -0700 (PDT)
Message-ID: <d151d6a2b53cfbd7bf3f9c9313b49c4c404c4c5a.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Fri, 11 Sep 2020 11:09:26 +0200
In-Reply-To: <010101747af387e9-f68ac6fa-1bc6-461d-92ec-dc0ee4486728-000000@us-west-2.amazonses.com>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
         <1599099873-32579-2-git-send-email-cang@codeaurora.org>
         <1599627906.10803.65.camel@linux.ibm.com>
         <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
         <1599706080.10649.30.camel@mtkswgap22>
         <1599718697.3851.3.camel@HansenPartnership.com>
         <1599725880.10649.35.camel@mtkswgap22>
         <1599754148.3575.4.camel@HansenPartnership.com>
         <010101747af387e9-f68ac6fa-1bc6-461d-92ec-dc0ee4486728-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-09-11 at 02:16 +0000, Can Guo wrote:
> > > 
> > > So your resolution looks good to me.
> > > 
> > > Thanks so much : )
> > 
> > You're welcome ... but just remember I have to explain this to
> > Linus
> > when the merge window opens.  It would be a lot easier if this
> > hadn't
> > happened so please don't make it any worse ...
> > 
> > James
> 
> Sorry that my changes got you confused and thank you for help
> resolve 
> the
> conflicts. My change ("scsi: ufs: Abort tasks before clearing them
> from
> doorbell") is to serve my fixes to ufs error recovery which only got 
> picked
> up on scsi-queue-5.10. So I checked out to scsi-queue-5.10 and made
> my
> changes on the tip of scsi-queue-5.10, below 2 changes were not even
> present in scsi-queue-5.10 back that time.

I mentioned here https://patchwork.kernel.org/patch/11734713/

this change (scsi: ufs: Abort tasks before clearing them from doorbell)
has conflicts with the scsi-fixes branch. I don't know which branch is
the main branch we should focus on.


Bean 

