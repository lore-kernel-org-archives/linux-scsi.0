Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E8DC00528
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjGaOfa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbjGaOf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:35:29 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC5C186;
        Mon, 31 Jul 2023 07:35:26 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b9bf52cd08so69166451fa.2;
        Mon, 31 Jul 2023 07:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814124; x=1691418924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:dkim-signature:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8OVn8+FHJGJqVncFTAuXJotMlgzD7kqP1U5E88OZLZs=;
        b=he9hILsSVjrd6WIkQMqbB6jgD1Lw8RiJt3RvBXtBb8t48ECkH1w7wXoOnOYFSeSF5q
         ov58rWqCShAozsmj1I+4D74Img65O94n1hOapaFWwSJsO1Pc1EenIyMET64unctRrJIU
         +HNYM93Oktlm0qMogT/zAYpxk5ncwwOOrzEO8wTQJVvGTTi1aE07rmiN/F0n6hbM9KuO
         I/GjsXhllizg69t6/EMv+DDdMTdK1pOjyMgkgeO9DYvrfCsV5LDoeZt7yhfVhl3JP6O3
         eXDgEH5ClZ4KFC9KF1Ja4NdXKv9DhpRPSi5nW9A+P27BLAMOj3BUTRgJvC0sSB9GFQf7
         E4/w==
X-Gm-Message-State: ABy/qLYCeNV98TAFCrPS235kAyGz1s5UENaTIeb8ts/5uotTH2qW+wF8
        eb0lyfB3SJgIL1GOS6HXDmvP0Tiw41LXnQ==
X-Google-Smtp-Source: APBJJlF0XzC8HKZFNm6zVA/HN9hOJ6+yc4rnnHyk8WUA7Kdcg1NJj+5ktukuWzcqrOU9ou2LkUlGUw==
X-Received: by 2002:a05:651c:14b:b0:2b6:cf6f:159e with SMTP id c11-20020a05651c014b00b002b6cf6f159emr85972ljd.44.1690814124412;
        Mon, 31 Jul 2023 07:35:24 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id y16-20020a2e7d10000000b002b9899d0f0bsm2110782ljc.83.2023.07.31.07.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:35:24 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 17AAD828A; Mon, 31 Jul 2023 16:35:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814123; bh=My65lAvbOOstq/34fWpOt5ymBYHHu9SQH88HxqSfLCQ=;
        h=From:To:Cc:Subject:Date:From;
        b=KRlxs1bbQIF/kdrbCFa4W8j7gFR0oaOkx5c+iFxvrD4xOhVfQbJPWsuDn/UsK4N12
         0X+fmtu3+w27E1g2LfJPa0YjtZdRcGhSJUIahb4t1YJx0eyS5T45fyPwPpT7UORYdP
         8yQfk02ARZTSqnwyt9Q9yMvzj55Z8AExYdJHRGIQ=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id E34E63F6D;
        Mon, 31 Jul 2023 16:34:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814085; bh=My65lAvbOOstq/34fWpOt5ymBYHHu9SQH88HxqSfLCQ=;
        h=From:To:Cc:Subject:Date:From;
        b=jRP5Hky6pV0JJpVTXXWyjrHXVIzJzLEbJfmwMuvo4vF5xO/58QDqabkaPGvBz+Qic
         GnY6mo+SRa0SWhLRvespnOAk2vBSLMXXcUT+E02NrKZpyVO9tCo/mg617Zim9uYjjP
         DgWypKGZiZyJzCAPuJIguDYGBZKnh2QkUPIY3amY=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH v4 00/10] libata: remove references to 'old' error handler
Date:   Mon, 31 Jul 2023 16:34:11 +0200
Message-ID: <20230731143432.58886-1-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Hi all,

now that the ipr driver has been modified to not hook into libata
all drivers now use the 'new' error handler, so we can remove any
references to it. And do a general cleanup to remove callbacks
which are no longer needed.

Damien:
This patch series is based on v6.5-rc4, however it also applies to your
libata/for-next branch, if you cherry-pick commit 3ac873c76d79 ("ata:
libata-core: fix when to fetch sense data for successful commands"),
before applying the series (this patch is already in Torvald's tree).



Changes since v3:
-Rebased patch series so that it applies without conflicts.
-Picked up tags (John, Jason, Sergey, thank you!).
-Updated comment referring to a renamed function in hisi_sas_main.c.
-Added new patch 7/10 which removes ata_sas_port_init() (thanks John!).


Hannes Reinecke (6):
  ata: remove reference to non-existing error_handler()
  ata,scsi: remove ata_sas_port_{start,stop} callbacks
  ata,scsi: remove ata_sas_port_destroy()
  ata: remove ata_sas_sync_probe()
  ata: inline ata_port_probe()
  ata,scsi: cleanup __ata_port_probe()

Niklas Cassel (4):
  ata,scsi: remove ata_sas_port_init()
  ata: sata_sx4: drop already completed TODO
  ata: remove ata_bus_probe()
  ata: remove deprecated EH callbacks

 Documentation/driver-api/libata.rst   |  38 +--
 drivers/ata/libata-core.c             | 355 ++++++--------------------
 drivers/ata/libata-eh.c               | 152 +++++------
 drivers/ata/libata-sata.c             |  96 +------
 drivers/ata/libata-scsi.c             | 161 +-----------
 drivers/ata/libata-sff.c              |  30 +--
 drivers/ata/libata.h                  |   3 -
 drivers/ata/pata_sl82c105.c           |   3 +-
 drivers/ata/sata_sx4.c                |   1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c |   2 +-
 drivers/scsi/libsas/sas_ata.c         |   9 +-
 drivers/scsi/libsas/sas_discover.c    |   2 +-
 include/linux/libata.h                |  16 +-
 13 files changed, 183 insertions(+), 685 deletions(-)

-- 
2.41.0

