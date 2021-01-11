Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF86C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40B102220F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbhAKKFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbhAKKFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 05:05:16 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40AFC061786;
        Mon, 11 Jan 2021 02:04:35 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id h16so18138922edt.7;
        Mon, 11 Jan 2021 02:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YOzaCXEr/kpfYx4XNxIfJ2wmIFUIzb+KQl5qAT3V4vg=;
        b=inC2mB8BG86FhisiYKWxfnrs2hC5mpc4KyEy1kdQaPEHzCE0j8clGN3LnG1hAU5vYn
         fH4mIN5Q23lzKwoab14+TcI/CDcOLcVmRjANBfmN+laQBAR7oecs9LXsXvWaP8udEdLD
         wORuwEbgsUG0r6YjypoMiLW25ylyzBxT8JbwjFNkgH8MWTy59sXU/Oktrcpa+7TaYFEv
         IZL15lQabuYcRum5hy6ZDo1kDPBAlLugrhJUAl3/q6LIRETEsXiqW8CxxrRDwmnS9XkF
         4E9qsARvS+Cr5l1/wJf1VHJSc4aqtVEZ+/ERCGiGS/mhz3wBZM9n/UOLkNLQmZfN7CLq
         6hSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YOzaCXEr/kpfYx4XNxIfJ2wmIFUIzb+KQl5qAT3V4vg=;
        b=ZvWiwsgbILGEBql9TQwZAWNi69pdPaHP2L/uy/2Hv+pWlAfcqmtu8RVJCG8tagWprE
         8t8XkUjnrz4/NLqg14f8okCPIWn1+i6y2PeTNPKaDq61+83/TYOs1XI8yyQvy61Hn5Gc
         VNsO36heid6oXdo/Zo1AqnidHkBoGt/lCdlwIi8pyjzn5btwn+p/jeDOZOjgLmHnXUZF
         0QqFXZROvhKdfl5+eRS7HJSuhx0A0uz/AQ9OdyKQj+w8yAUOFooRIr+jl7RyMfyx+f8a
         KWffPIoz1rs+BLxfXNCTyVRc22xOOV01NOehXkm5hi4zhNfWS156vF9jBH7jbCgPigm0
         QwKQ==
X-Gm-Message-State: AOAM532mAeCrbgkC8ABIHMTxCPdePbEPj9ogR73FxPTwdYmxq4JR0R8I
        0zp5O0ICNUftnxqui3C4BBI=
X-Google-Smtp-Source: ABdhPJy9rOzRaHHsqhgViDX/kv2CPjZnb5DTmUtM6p8LgX52UEdnLLpsOtJNM4nL/J1SrIAViJbNBA==
X-Received: by 2002:a05:6402:746:: with SMTP id p6mr13672420edy.313.1610359474332;
        Mon, 11 Jan 2021 02:04:34 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id v18sm6781220ejw.18.2021.01.11.02.04.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 02:04:33 -0800 (PST)
Message-ID: <6eaa5c51c0b17968e0169b8a16bdbfa4934af5d8.camel@gmail.com>
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
Date:   Mon, 11 Jan 2021 11:04:31 +0100
In-Reply-To: <7f193fe5abfb41aa72d17f7884cbd113@codeaurora.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-01-11 at 17:22 +0800, Can Guo wrote:
> > > meaning you are tring to access a register when clocks are
> > > disabled.
> > > This
> > > leads to system CRASH.
> > > 
> > 
> > OK, let it simple, share this kind of crash log becuase of access
> > sysfs
> > node in the shutdown flow.
> > 
> > 
> > > [2] OCP is over current protection. While UFS shutting down, you
> > > may
> > > have put UFS regulators to LPM. After that, if you are still
> > > trying
> > > to
> > > talk to UFS, OCP can happen on VCCQ/VCCQ2. This leads to system
> > > CRASH
> > > too.
> > 
> > the same as above, share the crash log.
> > 
> 
> If you have hand-on experiences on NoC and/or OCP issues, you won't
> ask
> for the crash log. The tricky parts about critial NoC and OCP issues
> is

OK, interesting. would you tell me which register access node in ufs-
sysfs.c can trigger this crash? let me verify your statement.


Bean

> 

