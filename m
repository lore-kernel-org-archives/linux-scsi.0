Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8797CCD4F2B
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 08:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjIVIKR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 04:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjIVIJV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 04:09:21 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F27810E5
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 01:09:11 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-69101022969so1720139b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 01:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20230601.gappssmtp.com; s=20230601; t=1695370150; x=1695974950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2R1uFPZQh5rHaFChaIdksfqptVdy9O1APe6DAZC5D0I=;
        b=FMIJaogkkZtO2QxFoznDTYrHqdpcF/zgrndaId/L96DRM7Z79v+iQBbXbCw0NVoEyr
         IWpij/rBZqhImADfeQdS7YX9n1TlHo72R7fn4IdgHoUz5uKkiJGrqvDG2d2glpZLf65w
         +eR9NgKhM82VaAmx8s1KOB1PdAM+0V8tqghKsgKqL+K60ODb2txOwWobfznyQTkeipLw
         gKKr4ns39v55htCgtEUPP5JL0QyvOuwmxsuJw2PdcXEJN+bCkpQTtaGseLIwL2c7hUwo
         k+WPGO0XMGV2ADDLL49FU9xw3TbKrc3r4GviZwlZIjJXOTMo+TlRvanlebyF1vrSmJm6
         vIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695370150; x=1695974950;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2R1uFPZQh5rHaFChaIdksfqptVdy9O1APe6DAZC5D0I=;
        b=B/EimJtj5wQCH9viX6U9vBB2WtQK4Z3ZD3scu3pXUqajbRubnETZBSUTzL86A6zrWI
         d1o8Ea561yS/TmBWmr2C4jfCQcQ8VBshURQUHM+ZBzfV8sjJQmpJCpLYKdp7H5WWZ8pk
         JTiRojTrZc8rAb1vq+6A/RWT9AQkWi+mOQjp3cdvzHkLr8fkRL6NSdAlbeQjHUVlwYbH
         YZNl2s7a7SuTVNZCN/UWAJchevvbaxon73AYDx4rXDBXp7dm9wIAqd6D9E2jY4c3tfAm
         1tomF65ixMnBUWOPtUcidTyE1GTkfyiakdIKNJfGPWtna5ygbGhKQGET0EMS3ftVWp2A
         G5IA==
X-Gm-Message-State: AOJu0Yzz7xnJDiOZeTiyaA/4tJ1aPc4ugVc13pd+LW1KAtlnBo18pWSh
        gQsbvq/+hTQ+GbuTin1qxPkWTA==
X-Google-Smtp-Source: AGHT+IGog4fauLibzha4KpXKqEK5AYSa6a1Ny+SSsUJzl0+tJeVaaAPf3XdtD7Qo1Ghy/9d6mvjLDA==
X-Received: by 2002:a05:6a20:8410:b0:12e:5f07:7ede with SMTP id c16-20020a056a20841000b0012e5f077edemr10419235pzd.41.1695370150487;
        Fri, 22 Sep 2023 01:09:10 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id c24-20020a170902d91800b001bf846dd2d0sm2852442plz.13.2023.09.22.01.09.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Sep 2023 01:09:09 -0700 (PDT)
Message-ID: <5445094045757819ea650b138a8e03d833e2cbfc.camel@areca.com.tw>
Subject: [PATCH V2 0/3] scsi: arcmsr: support Areca ARC-1688 Raid controller
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 22 Sep 2023 16:09:09 +0800
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

