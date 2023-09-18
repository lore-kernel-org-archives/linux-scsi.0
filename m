Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA03FC46CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 10:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbjIRKZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240873AbjIRKZc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 06:25:32 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F30AD
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 03:25:21 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1c328b53aeaso38414545ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 03:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20230601.gappssmtp.com; s=20230601; t=1695032721; x=1695637521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2R1uFPZQh5rHaFChaIdksfqptVdy9O1APe6DAZC5D0I=;
        b=gHnyFUgGgcQkE5CuJjm5EQ4vN6BEuMahmI64hqssUMHjMJb34/uTV8TxWtmUKDxTzI
         cYrnatzJ36aG4YF7WkN0/nsFYeuCCFtJK5//kQM7yduJsiNi4Bk+aCHT0yQEfJ/g8qM7
         K/YadinEiuJHfpNxVsiqHM5WISGlUbvO4yUeAYjIwLQjExLkzgIcfteXz4vRuZzw/iU4
         mWeqA0yjqa9YBlMRxJBXqlpNPPDXmDQZGpicad6BMPCJ/NwxeRTKwhdpGKXuecbuBWB4
         V6aGP+p3YyfteW9QmJPT1FzG7oNshx2MnggA5+jWqgkffL37u2hGCGokKp+h70tPzUOO
         foMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695032721; x=1695637521;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2R1uFPZQh5rHaFChaIdksfqptVdy9O1APe6DAZC5D0I=;
        b=ID/yjXMStF7Mp0C4AlNU5/4tEewRwygXWIdzxdDPk4Udnp1QFBQYGA2vkBMyVMFD3x
         L9dDGKkoDL8LXEHokhBqAxlEhQHxrzxzM4eotEdnB7wjVulMLVNVxAX2eZku21eBHRf8
         GDx15UBfH+YASjtzJ/UNDHhfSH6qDbRyuiTIKRD2kj4cKvEYGRPZjO6c2dI6JSeDEvar
         tJxzHRt6dFh8+wb5uK5340WOAdQDvlU8vU4/o03atRJG9Ku1u4D7Rr3Go/K0pk1jWOyk
         lNwqigY4mfok7vX+Kyt1M1x1zsMWu6WKci5jTmwrYG5CZh0L9fTxpKGwO0+/UN4X3B6o
         0Hdw==
X-Gm-Message-State: AOJu0YzbhzB26CURQt/m81q8hLhawUYcEON7Om09l+mJjwyZtkvmGAK7
        Dlj+dEz5mRpTXNaKZ4D/EPN62w==
X-Google-Smtp-Source: AGHT+IF+u2kWo8jwH97CBxsh0Pl65Wiztx0Y7Z+VM2CcJTy3FdfSVviraEX4BckReV+C05bmFGJa4Q==
X-Received: by 2002:a17:902:efc6:b0:1bb:7b6c:983a with SMTP id ja6-20020a170902efc600b001bb7b6c983amr7623614plb.59.1695032721344;
        Mon, 18 Sep 2023 03:25:21 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id j17-20020a170902da9100b001bf095dfb79sm7953757plx.235.2023.09.18.03.25.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Sep 2023 03:25:20 -0700 (PDT)
Message-ID: <0608654a043206078d3a27d23cd5e3c2851ee415.camel@areca.com.tw>
Subject: [PATCH 0/3] scsi: arcmsr: support Areca ARC-1688 Raid controller
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Mon, 18 Sep 2023 18:25:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches are made over mkp's 6.7/scsi-staging

This series add supporting new Raid and new PCI device ID controllers
- support new Raid controller ARC-1688
- support new PCI device ID 1883 and 1886
- updated driver's version to v1.51.00.14-20230915
---


