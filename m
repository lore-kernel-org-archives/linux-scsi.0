Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9577C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA5E76135F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242960AbhI1Vj1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhI1Vj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 17:39:27 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E91AC06161C;
        Tue, 28 Sep 2021 14:37:47 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id q127-20020a1ca785000000b0030cb71ea4d1so168970wme.1;
        Tue, 28 Sep 2021 14:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mtlIZSIok7x/x2QvivMiVvgsTprWU6lwDKDsHsHJyXI=;
        b=AVSWeZVHr3YFaX8Xi/GEt1Fswd4LwTe9OKTr6qUa0us0HboIcXX4r4uplSL+Y3NHMS
         eoBmJXY+/9vvJfi9nD7F62sn8TxsxyKtz3r3vPTfGyUjnG+jhHKB5S9oiuvWKdTr+BMc
         YNpxnUiGYusXqaPMRqZBJOJMsVkwdA3jApUu0f8rZD9SpvwX3I4V9qTXlU7QRxEQgj5J
         +yQfabLzrsFoG0N6x4czkTHjMfuHa5G8fV2RfpoxA1v/b0xstp5PcvI8Q4vcMPaqYrAX
         FD9NFaHk5mnxA/esdy3XYL5rodkDeJXWl6/XodpPH6tUf/gE4sDsLgZH7+MZ6o/g205+
         h9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mtlIZSIok7x/x2QvivMiVvgsTprWU6lwDKDsHsHJyXI=;
        b=ErwwTsMMeNwYI+9GRXTpBg7KSgdxSv3K3VqeptABw8RQlFcS+W5KVYEWGAJZldHy5L
         gokhi9+MXJchHMl4pumgOfoDcHfw+uHWDoBDVh9Dyb77ioW2E61rtTTSy5F5zqL3GG9q
         sKpNnm8LBM6XjbS+dN2fn/9hGmXX3MQOSbk6tY7y5sxtToi0fyKzfXGNO0AIVfAyC7t2
         BqmYEf2uARs7/aIrgHXFmlKL1GG4qNNUZB3U/5JUOEZHpPLzCCI5bUlxdyU59IFYm8XA
         4peJumpK38b7KO9LUqZZNjyStLwTYXb963FjvgNnLrYgU0Wii/8BpX1elnygqhL/rcvL
         Blcg==
X-Gm-Message-State: AOAM530nhM4F2TdssgASXA+CMJc+GdiVtXiHKb3FGY1EHBlgUOsN2rh2
        +zAZp7WhUdWWQ5dbunXazpDC1MyxCyFRzg==
X-Google-Smtp-Source: ABdhPJwfneo/e3jymw/UQnwfo0tdvCA6G8ksjDVABBJGZThVDmzXUh/O/R9K9XLhuY8CSYwRJs+S+g==
X-Received: by 2002:a05:600c:4f8e:: with SMTP id n14mr6920291wmq.63.1632865065935;
        Tue, 28 Sep 2021 14:37:45 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cfe07139628ae9da1147.dip0.t-ipconnect.de. [2003:e9:4717:cfe0:7139:628a:e9da:1147])
        by smtp.gmail.com with ESMTPSA id l18sm270461wrp.56.2021.09.28.14.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 14:37:45 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] Two fixes for UFS
Date:   Tue, 28 Sep 2021 23:37:32 +0200
Message-Id: <20210928213734.778908-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>



Bean Huo (2):
  scsi: ufs: ufshpb: Fix NULL pointer dereference
  scsi: ufs: core: Fix a non-constant function argument name

 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshpb.c | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

-- 
2.25.1

