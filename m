Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB52C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51495216C4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbhAKIYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 03:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbhAKIYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 03:24:18 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D72C061786;
        Mon, 11 Jan 2021 00:23:38 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id q22so23521273eja.2;
        Mon, 11 Jan 2021 00:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bVN0e+guDBLEpu6mTxspL6cIVlkhLwLLZ+onFEWXX6A=;
        b=tJkpcXk8vFzGwDuQsBli+0A51PRMs8y/ZaSc1V518emxHlfPUgO6R9ghca15yuq0k+
         GI3K6iFlQs7ArQLFItoxdmNstsSMWVzh7CgAGhRMtmXCFExZ/tuCGYWBse0+1IfJ7gRu
         Z4BPBgD5Xv76hvYMSBC3cGAvCdK0okaHfkzlO35wKXI65tX2RI/MfaMwXVJ09ykrCp9a
         RHZMLSdWnkDo04n/58icl8uawRzHj1k4m8bSB3H/ELxMd4PQrIIYNVxTisrHzm6/CDIk
         eOmF586XoHaBOval+esEDYIa57YCu/ALhiXlwqG7olISb0+kab/KyS1Heza2BnvZqzKw
         Inaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVN0e+guDBLEpu6mTxspL6cIVlkhLwLLZ+onFEWXX6A=;
        b=VnDhKmkbHDYEIHx0uFwJWhE8V14KFqQQCZRWCMAZnkY8cx8txYWNdO9O8VGjT8n4+N
         w5+uOAxNyqjpkoCQ9dNCNAlctGjpGeIyj+3rWk9DJlEuU9pidMlMrHlYnBFUCIyRQV4h
         +WCWf9kxAeXOWPjlinL9o39GRQt33TEW5HzOm15LFWiwNPO+j0XmeIQWIrp/FwnZ/ndV
         xn3cX8dWLUwfv9s65F7T2l6YwIaJAJlhdDO3i1EvxPnv3Zu5RYzsdtjFKsLOqdIlOtrO
         PDL5Mt9hSmy761O7phkwv9yJARo3XJpc5TcYvqQT+DPFPrpcpby6GNUsTqbWnzdtHrEu
         7fpw==
X-Gm-Message-State: AOAM531BUNM3d2CXyCgeN7p4k6FQsZnyliRyZXZZr8h2LkzzPMPVVBJu
        PUkxJfbIU8EmQuKQp+XhETk=
X-Google-Smtp-Source: ABdhPJxLp00VJeDO4ym1wWtt5UUQ7OHMb2Ke85WdRScCsecilBrIfomuAnuHUxc3OKiZoE4mP61kpQ==
X-Received: by 2002:a17:906:8151:: with SMTP id z17mr10197276ejw.48.1610353417073;
        Mon, 11 Jan 2021 00:23:37 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id t15sm6740531ejx.88.2021.01.11.00.23.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 00:23:36 -0800 (PST)
Message-ID: <976641f42211af23d90464d0c4841cc40740b0d7.camel@gmail.com>
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
Date:   Mon, 11 Jan 2021 09:23:35 +0100
In-Reply-To: <fa0e976387070c64752c972d32ce15df@codeaurora.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-01-11 at 09:27 +0800, Can Guo wrote:
> > 
> > If accessing sysfs nodes, which triggers a UFS UPIU request to
> > read/write UFS device descriptors during shutdown flow, there is
> > only
> > one issue that sysfs node access failure since UFS device and LINK
> > has
> > been shutdown. Strictly speaking, the failure comes after
> > ufshcd_set_dev_pwr_mode().
> > 
> >     __ufshcd_query_descriptor: opcode 0x01 for idn 0 failed, index
> > 0,
> > err = -11
> 
> You misunderstood it again. You are expecting a simple query cmd
> error.
> But what really matters are NoC issues[1] and OCP[2]. And
> while/after 
> UFS
> shutting down, either of them may happen.
> 
> [1] When a un-clocked register access issue happens, we call it a
> NoC 
> issue,
> meaning you are tring to access a register when clocks are disabled. 
> This
> leads to system CRASH.
> 

OK, let it simple, share this kind of crash log becuase of access sysfs
node in the shutdown flow.


> [2] OCP is over current protection. While UFS shutting down, you may
> have put UFS regulators to LPM. After that, if you are still trying
> to
> talk to UFS, OCP can happen on VCCQ/VCCQ2. This leads to system
> CRASH 
> too.

the same as above, share the crash log.

> 
> > 
> > Since the shutdown is oneway process, this failure is not big
> > issue. If
> > you meant to avoid this failure for unsafe shutdown, I agree with
> > you,
> > But for the race issue, I don't know.
> > 
> 
> Easy for you to say. System crash is a big issue to any SoC vendors
> I 
> belive.
> 

indeed, crash is serious issue, share the log.


Thanks,
Bean


> Can Guo.

