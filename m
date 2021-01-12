Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3CBC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85F5622B37
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbhALLdG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728144AbhALLdG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:33:06 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF97C061575;
        Tue, 12 Jan 2021 03:32:25 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id dk8so1934870edb.1;
        Tue, 12 Jan 2021 03:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Itw7Iqb4CKG85NKNT+SCan+dDCLWRY6hWBAQ4hMnJc=;
        b=J8hBndB4qSsaiPyCsjidck82eOuN3NM74IKPNWD56FfpcdDyZ2XtuAhv76YVDyUtVs
         IC00AtWsVcaIapNgdXQ53OvYa9gF1oSxm1TkbXfW6h7nbVz/xGeY6wPx4vgpEPGO8ZIP
         3AprwnZV88HJHZzci51G8FAg7pVmKc+VyZ8+kqGlfLwsL+9bkHVIL0IjIwCfsk/eiP6k
         XCO49B9OiFImC5es6A4ZMicySci7luFATQ/k/Z4rZtT1fV9/ZkbvFlY8/KzpYGpRc48o
         WEe2dd+0CAPNPADOaoOTyOTgZFUJz/jxXFeZNt721VfhDRhVy0JxoTRSgnFgpmn63Gko
         Qh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Itw7Iqb4CKG85NKNT+SCan+dDCLWRY6hWBAQ4hMnJc=;
        b=LTpNP/qPDl+cNAhytOr9LQ8NeDNmFdUJfFryCNEHBxtncprb+CHpTtoaGr7y1G090t
         QwvPtbyi8ni/VgsKS8rlaX7QQXxahn60mac2U0O9iAGsO1Mwrz03SIf89jrvGn+UQbJ8
         zt+lbFl92Lc3shNOFfT7Ooz1odrzui818ngQ2vUSKALZwHqh8x2ayapcE/TM6BoNyilu
         GPUIDswcslEDpFo3HGc0eYoIP1cBGKdlqls8b6CtEpzJnfLVF+D3/oDblwi9qwGQXpL1
         B+oVWcYvHpTNq8YWbI2A5OwImHV0C4czZJ32PdPRqCrd1zlpdrmykIJjIh7rurBl3k2H
         I6Hg==
X-Gm-Message-State: AOAM53009mF9TsEdMkgdpOdtiq9HpmsYx7bIINjMCn618Ae2Q9BJWVy9
        xATexlz9HmklTYP+jCdGOKc=
X-Google-Smtp-Source: ABdhPJwdXaX/tjzpovrurNwgVRIiQAkcPLLK76mgq5Cp2NajeS+zH4fPZH61v/8lZ6GDuTHCL8y4aw==
X-Received: by 2002:a50:fd10:: with SMTP id i16mr3052047eds.331.1610451144573;
        Tue, 12 Jan 2021 03:32:24 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id k23sm1064441ejs.100.2021.01.12.03.32.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Jan 2021 03:32:24 -0800 (PST)
Message-ID: <e5213ef0c3d0040903db92c84abd538ab860ed5b.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        rjw@rjwysocki.net, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 12 Jan 2021 12:32:22 +0100
In-Reply-To: <9d74b57f9a26878705b7162a36b2bceb@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
         <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
         <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
         <1514403adf486ac8069253c09f45b021bad32e00.camel@gmail.com>
         <f814b71d1d4ea87a72df4851a8190807@codeaurora.org>
         <cb388d8ea15b2c80a072dec74d9ededecb183a08.camel@gmail.com>
         <e69bd5a6b73d5c652130bf4fa077aac0@codeaurora.org>
         <606774efd4d89f0ea78cefeb428cc9e1@codeaurora.org>
         <146b46a5c38f4582a9a8e6df1d87cdfc0684f549.camel@gmail.com>
         <fa0e976387070c64752c972d32ce15df@codeaurora.org>
         <976641f42211af23d90464d0c4841cc40740b0d7.camel@gmail.com>
         <7f193fe5abfb41aa72d17f7884cbd113@codeaurora.org>
         <6eaa5c51c0b17968e0169b8a16bdbfa4934af5d8.camel@gmail.com>
         <9d74b57f9a26878705b7162a36b2bceb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-12 at 08:45 +0800, Can Guo wrote:
> > > > > to
> > > > > talk to UFS, OCP can happen on VCCQ/VCCQ2. This leads to
> > > > > system
> > > > > CRASH
> > > > > too.
> > > > 
> > > > the same as above, share the crash log.
> > > > 
> > > 
> > > If you have hand-on experiences on NoC and/or OCP issues, you
> > > won't
> > > ask
> > > for the crash log. The tricky parts about critial NoC and OCP
> > > issues
> > > is
> > 
> > OK, interesting. would you tell me which register access node in
> > ufs-
> > sysfs.c can trigger this crash? let me verify your statement.
> > 
> > 
> 
> I believe I have explained enough to prove we need this change.
> 
> If you are really interested in NoC and OCP, feel free to ping me
> on teams, I will show you how to trigger one and what is it like
> on my setup.
> 
> Can Guo.

Ok, I no meant to stop or slow down your patch merging,
meant to avoid redundant instruction cycles.

Avri and Stanley have been convinced. let it go at that and merge.

Thanks,
Bean

