Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16747C6FD1F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 14:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbjCIOZh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 09:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjCIOZN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 09:25:13 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC4A637F9
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 06:25:09 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h14so2054310wru.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 06:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678371908;
        h=content-transfer-encoding:subject:to:mime-version:from:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Yf2ahHvlY2IXDyPqkpKQ3Qkug7WIJL4NOmqcaxPWKDU=;
        b=KnLQaxigg3QmZcdRfnig2QiZe2vyVeXFkjESXW2yYxaXCjkuSeKHbP1BZTLADNuUV4
         koDJ9sAXezRXrkUzH8mnyyM9gMxZGrkItzIPdxi+Nf2IdrfUvJti+n6P2F+WEGOMkXGo
         6KUsVa7wSIm5h34TfShF0UUnl6F3JdQdtMe0wDV/W/WczUJTQ7eHMdmrXEOlsGRJeElR
         2uUzr06MOFgLe1QcZPGuqIjp/UfMs57sww2+70ArQyEsx2/JzDCN18qDgnTmEFk/ARS4
         ngyoujXAaQkBoXK1tVSSEH/BJ6nVlBkniRWW/KzIiFHzoUwngxmB0reS2tN/tgKhdVIU
         DGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678371908;
        h=content-transfer-encoding:subject:to:mime-version:from:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yf2ahHvlY2IXDyPqkpKQ3Qkug7WIJL4NOmqcaxPWKDU=;
        b=5EDZuSsWLNcz7p4Tg0UvXylCHZXNmc/6N0EM4dRmUxyRLaaWmGloVwSql80ZrDvLm4
         gkk79csPrP8+0xbE1/ghsR3VimfA5KwDl9vs61hHsEd98PF+TNOE3r84jvsplQRy9qs5
         5Thqeqm/7a2tpoSNPSPP9nIhWCthKfyPml43f7FEKYUtULN74s3ox/Gm7C1bvNEUFnMp
         OWmKHITMBIaHwVWCRwsOgsJDUXPQy6xFyYB/yHGAOh/6er5XzHzSHwGmBPm5F8kJFJlK
         C6ZMGNOtlHW7/r6OI7TMW03RGko31HU8B71CBt/46xDYkVn0My8HYOQQIwz1E2DMyODs
         Y8PA==
X-Gm-Message-State: AO0yUKU8t/0RvS1piaqSVevRGN9CKfy9GWfRCHn7blqC5zlegHWf6Qlu
        fgKtQXXiKRXjb5PyNU//7BzbW2YmlBo=
X-Google-Smtp-Source: AK7set9MwEAAXKQ8dkwFMimsHLNrHQaMU+wc9JFbM3paqdmwIaFlXc0N1XXXVSk92cqNksS7fShA9g==
X-Received: by 2002:a5d:4585:0:b0:2ca:ab68:eff9 with SMTP id p5-20020a5d4585000000b002caab68eff9mr2064552wrq.7.1678371908164;
        Thu, 09 Mar 2023 06:25:08 -0800 (PST)
Received: from DESKTOP-8VK398V ([125.62.90.127])
        by smtp.gmail.com with ESMTPSA id w2-20020a5d6802000000b002c7163660a9sm17905138wru.105.2023.03.09.06.25.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 09 Mar 2023 06:25:07 -0800 (PST)
Message-ID: <6409ec43.5d0a0220.dc775.cc0f@mx.google.com>
Date:   Thu, 09 Mar 2023 06:25:07 -0800 (PST)
X-Google-Original-Date: 9 Mar 2023 19:25:07 +0500
From:   krewkaydenr843@gmail.com
X-Google-Original-From: KrewKaydenr843@gmail.com
MIME-Version: 1.0
To:     linux-scsi@vger.kernel.org
Subject: Estimate To Bid
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,=0D=0A=0D=0ACrown Estimation, LLC is experts in providing cost=
ing and takeoff solutions to GC's and Sub's. We are based in NJ. =
We do estimate all types of construction projects including resid=
ential, commercial, new build and federal government projects.=0D=0A=
=0D=0Aplease send me the plans if you have any job for a quote on=
 our service charges before getting started.=0D=0A=0D=0AYou may a=
sk for any type of samples.Thanks.=0D=0A=0D=0ABest Regards,=0D=0A=
Krew Kaydenr=0D=0AMarketing Manager=0D=0ACrown Estimation, LLC=0D=0A

