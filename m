Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D68C2BB48
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E672223E8
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgLOJ25 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 04:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgLOJ2p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 04:28:45 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE54C06179C;
        Tue, 15 Dec 2020 01:28:05 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jx16so26625853ejb.10;
        Tue, 15 Dec 2020 01:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iYBE2cZXqVlKV0i+AsU6Eo5VZfZrVHQ68uczVmC/4KA=;
        b=BD3UYVIFn+8VSuYngyVAd9DP8rpa7tMaMWToHZ5GGYXEeNGTYs6/3YSOJ0/BUR9KFs
         OgjbtnfABGdR9TKMPEiKzDJrzMZi1hRV5a6rij83rAU50zU5HfhUyIpeTH1uRsL/xhjS
         j372eGkNkWH9Z3ynBdzV8+V/6XjMt/prUBn1VXFcLJ6tkfdQxTfXNu5dLDJ5+Tnumqqb
         mfAUJEG2aN6uBPjVWn/T2nUxq71A0lUnQLHgpKaPQW72uRj9uXHWi/EOvC03Gw0jDTPa
         SiHqs1QodTSpSFZ8TzHaALPEOjC1pjkxWUcyEFshlik0l9TMP6faGqrKV1RHvcsB+RmI
         9/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iYBE2cZXqVlKV0i+AsU6Eo5VZfZrVHQ68uczVmC/4KA=;
        b=Tsp1FIiEFApxc86oYAbCHkuSb33BoTo2jnyNgzWFbUmwqrzPsE6v7rhX51VtsytzV7
         h+4jWJQg2nLp6zNm4ntKSlbKeAhPQ2jdDy+Ap/nmdcpGiEcAOdSKbwyQzdGYw8J0TxPQ
         2OcS2c9S1XP+al45Oa6wGwMNRELWCHYpttdIXUqVVz54F1Itf80lR7thSqHs+G+NGAcR
         /COhki8tquehKXvsUknOkLa6iubXSHhn2/o/2fDgLB4ZX9A9d0Es9Fe/1zmcIu9/XKEx
         2Hsesg6iGIGQvSk4GGwry62GLLkZZECYiIcWQPfZrqYDSmbRq0hZf7NeDK1mbp8alvSw
         JlGw==
X-Gm-Message-State: AOAM530mO88n3KnLrW/PaOTyBLZrir14Em15T66tccfbGQH/USbLBQCi
        5v8DLxC/+HWbc5Zq67pLijs=
X-Google-Smtp-Source: ABdhPJzRShezHeWBdVSKEXASOHVJUSGh2GD3hSlsswKkuPss0Um9LKy3Fskmbzk1turFYU5FLGacfQ==
X-Received: by 2002:a17:907:2131:: with SMTP id qo17mr25708954ejb.546.1608024484248;
        Tue, 15 Dec 2020 01:28:04 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id f18sm17821450edt.60.2020.12.15.01.28.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Dec 2020 01:28:03 -0800 (PST)
Message-ID: <410bf2a27978abb74ba41bc9f9198dcf85636b3c.camel@gmail.com>
Subject: Re: [PATCH v4 5/6] scsi: ufs: Cleanup WB buffer flush toggle
 implementation
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 15 Dec 2020 10:28:02 +0100
In-Reply-To: <1608023234.10163.19.camel@mtkswgap22>
References: <20201211140035.20016-1-huobean@gmail.com>
         <20201211140035.20016-6-huobean@gmail.com>
         <1608023234.10163.19.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-15 at 17:07 +0800, Stanley Chu wrote:
> >        if (ret) {
> > -             dev_warn(hba->dev, "%s: WB - buf flush disable failed
> > %d\n",
> > -                      __func__, ret);
> > -     } else {
> > -             hba->dev_info.wb_buf_flush_enabled = false;
> > -             dev_dbg(hba->dev, "WB - Flush disabled: %d\n", ret);
> > +             dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n",
> > __func__,
> > +                     enable ? "enable" : "disable", ret);
> > +             goto out;
> >        }
> >   
> > +     if (enable)
> > +             hba->dev_info.wb_buf_flush_enabled = true;
> > +     else
> > +             hba->dev_info.wb_buf_flush_enabled = false;
> 
> Perhaps this could be simpler as below?
> 
> hba->dev_info.wb_buf_flush_enabled = enable;

Thanks, will be changed in next version.

Bean

