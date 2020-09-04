Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F881C43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 11:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28B34208C7
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 11:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a2qeYtvZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbgIDLhf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730116AbgIDLhS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 07:37:18 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8567C061244
        for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2020 04:37:17 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id b17so6048663ilh.4
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2020 04:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=P+hlH44g5Jz7kmbirrQDDmLsUNWWo2HktCmUdcwrxJ8=;
        b=a2qeYtvZ7U9L1lS5oVRpCRMdT7vjoohQNoBW6gJETRpCLHvGMF6L/tQb8fBF9Mkhz7
         cx1OK8lHZaKmbc6KwynggbRT4o+LHmZ/OO9A6vE5sV48Ke8u6AAgXSDHZqRTrS36X2MQ
         YsCDYDf3fpfjGiFd0ZG5bBqDeL7yTGp3eGk1uWUPb8wAou7mWKOwV87gatE/Pfyn48Ej
         740QmexKMKHT6VNut9jicnwtVM1fheL/I1P/uFW2G6WgJbN3bRslOTFZjhvdfWdICMUC
         pmujpSwq8O5fPJunCN/lgxVkIaQDtyG02/Qwhdk34zABErEaKRxu8esjNpBY66ZnAR+R
         8e+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=P+hlH44g5Jz7kmbirrQDDmLsUNWWo2HktCmUdcwrxJ8=;
        b=S8DjGsLx28kUA8j2uH1Ymhqm/vWHb2T8a9WN08MbnYVULhGN7DUdz7xgdbv+mG6rBg
         GWoLvSwjKK6gXXRPM8YlgLiYNzhRSqTQNC4ejN7vo/HDZq7nqielShvk58EQo+b9RzMc
         niDBpb+pyBHIPtLImAnK3UI/kGwNlnjkBiBuxrJuFxurxrRmxGM/D2i8hEUHWKP+kGB1
         kkUjwh5QdLHQWCpTe6rKUq4n4PXklVxRXN+Cdg6n0QxdJ9MnqE2miy4PbmadqyOb5ZkI
         VElqHV9UzXPYt5TM5r12e3/ZjZYuYgVrsLI4DNvAN3GKA31bfsHOvrIKcrx+hWLqeEJY
         bwkQ==
X-Gm-Message-State: AOAM530loewEPj92eGcmM1JtrSx4rBKw0MnZulGSmDrNl5oXdPUx5rpM
        l4ik/qs87CTZVKsBzl4ZwcU0InR9DY+FXoZzo6dKBwbSmyDi+A==
X-Google-Smtp-Source: ABdhPJxapWbzyJ2fZ5uMOkrL63bbwiu8S+PqYsaF8aF9JvZzH/1w05Hk874MzpEFYlE2C/Kr1KvxlOaR57kvPzV9D28=
X-Received: by 2002:a05:6e02:d4f:: with SMTP id h15mr7101761ilj.307.1599219436881;
 Fri, 04 Sep 2020 04:37:16 -0700 (PDT)
MIME-Version: 1.0
From:   sgmihai <sgmihai@gmail.com>
Date:   Fri, 4 Sep 2020 14:37:05 +0300
Message-ID: <CALP1Rr7iwsnJ0VcOmNx0z5841zw-=YLy-fjOZnjcs1eQ9ExUzQ@mail.gmail.com>
Subject: LSI 9201-16e regression ?
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi. Somebody on irc gave me this e-mail for reporting a potential bug.
I have a LSI 9201-16e controller and no hard drives connected to it
are detected if using kernel 5.8.5 or 5.9 current
(5.9rc3.d0830.gf75aef3-1, packaged by manjaro).
Relevant dmesg message:
mpt2sas_cm0: failure at
drivers/scsi/mpt3sas/mpt3sas_scsih.c:10790/_scsih_probe()!

I tested with 4.19, 5.4.6, and 5.7.19 and it works fine with all of
those. My motherboard is B450 Aorus Elite. Not sure if the regression
is related to the driver handling that card, or something else.
Let me know if you can help me track this down and what further info
to provide if needed.
