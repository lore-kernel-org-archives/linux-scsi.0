Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C77C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 13:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A21261058
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 13:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241885AbhHJNs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 09:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbhHJNs3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 09:48:29 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333BEC0613D3;
        Tue, 10 Aug 2021 06:48:07 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d1so21071872pll.1;
        Tue, 10 Aug 2021 06:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=CNbvPsnGAfa3fu8fS5mw3q/ySea1UUbi6hadd0bmWeo=;
        b=hoINABunSBYQ2JkYYVpHWvnqfcKfMeuLsEs5RBPS9/roCQMZMiD8Wxk9YzMTPbAdEd
         YzUET3flnDrEnas2moHTKPj3eqswt2kl5ojHJntcAq8jcq2IuxIMYACvccw+Lm85ZX7M
         aTNYTHMibdUa38vFxAe5MBByd9PxmMuhpsXSTHF0c8hmGdN2V/LQfCSpHOUcMdE2n7MT
         jtyOHqPjjBavBY4g4/yMQVtRbmLKampGH4MPxTklXrluLEYLLNczihZlhKO8zIvnnvZ9
         iz+y5QDYlyCqWxuviWQBmvC1EeSkgtS6YU61oTcz6Rxw4sxi0GTJYiBp2PZZj+q1mwqw
         fBNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=CNbvPsnGAfa3fu8fS5mw3q/ySea1UUbi6hadd0bmWeo=;
        b=N3+0KnM+5IZ4US73trrCGcKJutOc9pjhRFK8mV46n+9gBCxlTzLg/y3VMTA94OqpU2
         tYJZmWkIv/v1HUmPrjHgcQ6WKPX9b0li+9BwN5vjZBn2gsG95lmRJGunc96Gi2RNxHHu
         sTdUzvOg5WDKoeduk6+yrskxNvFjxL/y0Tb9GzDPjmnr4iNjmQdBtW5QmmvhUM8f8PwP
         NuTb1Za89AWjSmPqi8zmXLDYi7k0e3CGMx9C3Qi5ScxSlr0hWW2scn3qzJkZxkWiEwjR
         DGf3hhdDxi1sMl9vP1jOawtHczFu/bKB0nSQj5TOqGkAUEC3wGuSb8I+WC63QXidTssK
         XaZg==
X-Gm-Message-State: AOAM5311Z8iG3aSKOMGDCSYMp1Er7bX38o4ih4+lnpie/E4T7YMsh6G7
        TxFMyF6mnhV6A+eCVKFKf164oR5K0SB46FZG
X-Google-Smtp-Source: ABdhPJxDb2+ly1WlR776U/zcEbiEs6orYG1yRVBz/Bbo75OnSuxjbvfHOT0X/0rejyW2zB2iDRDzYQ==
X-Received: by 2002:a17:902:d890:b029:12d:f2:e8d6 with SMTP id b16-20020a170902d890b029012d00f2e8d6mr7240709plz.42.1628603286547;
        Tue, 10 Aug 2021 06:48:06 -0700 (PDT)
Received: from [10.178.0.62] ([85.203.23.37])
        by smtp.gmail.com with ESMTPSA id x13sm22637326pjh.30.2021.08.10.06.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:48:06 -0700 (PDT)
To:     martin.petersen@oracle.com
Cc:     baijiaju1990@gmail.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
From:   Tuo Li <islituo@gmail.com>
Subject: [BUG] scsi: iscsi: possible null-pointer dereference in
 iscsit_tpg_add_network_portal()
Message-ID: <89aaa039-2f03-f657-a555-a6a99f38db6d@gmail.com>
Date:   Tue, 10 Aug 2021 21:48:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Our static analysis tool finds a possible null-pointer dereference in 
the iscsi driver in Linux 5.14.0-rc3:

The variable tpg->tpg_tiqn is checked in:
496:    if (tpg->tpg_tiqn)

This indicates that it can be NULL. If so, a null-pointer dereference 
will occur:
508:    pr_debug("CORE[%s] - Added Network Portal: %pISpc,%hu on %s\n", 
tpg->tpg_tiqn->tiqn, ...)

I am not quite sure whether this possible null-pointer dereference is 
real and how to fix it if it is real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
