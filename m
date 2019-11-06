Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E57C5DF60
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 01:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6EC12087E
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 01:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbfKFBGg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 20:06:36 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33880 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729614AbfKFBGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 20:06:36 -0500
Received: by mail-pl1-f193.google.com with SMTP id k7so10610446pll.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 17:06:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LrLGgN6mrXo4zPq5LZD9HETnY7vYdUS0EAeEridoHrA=;
        b=OUy+lhToUuTQaD03WFPVAy47eVmUjk3T5ymyTbELQg8ZVFEnJxG1RaM1Xup3nE+gRv
         Zj9LtXjvYT7j7kV0mRnIGdRsZQxwsWLBaelAM6/fr+sLTNPXYn2XpouhuKlR4J6aKPEu
         3dX4eKI9hH5Ec908goSTSK4Gsqv9nBHA5zKwF+u2HUpFrrqJZL3Lgg3lZ3vLxAP9Ypkt
         C9NAUvC6z2LmFt3ozazY/QQzjcZVyg7k0yuxcXReU0sevX/dFMw3PcPQDbfNnvzO8Qv2
         p3wlQ9Fua5PqWolgPuE2uEgCNxGqxSK2ILkAqnx7m5GYox25cqNfapyQBtez9XdR/xcd
         Cvkw==
X-Gm-Message-State: APjAAAUDGVfsakZp7oI6dYkZ6pcj0sDAw26cEEBuu1pAspeQuB5R8/v/
        /jdzVa/NUXg+IsqJMzfU60Oc3Rj0
X-Google-Smtp-Source: APXvYqxrFtXgFQ+52ZZq5n0RvFW3Yyu4MMDgrOQydOGOddhkCswHPcJiU9D+vlQxgVnJ7cruJQP4wA==
X-Received: by 2002:a17:902:6b4b:: with SMTP id g11mr12081169plt.196.1573002395251;
        Tue, 05 Nov 2019 17:06:35 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id j22sm18711443pff.42.2019.11.05.17.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 17:06:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC v3 0/3] Simplify and optimize the UFS driver
Date:   Tue,  5 Nov 2019 17:06:25 -0800
Message-Id: <20191106010628.98180-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello everyone,

This is version three of the patch series that simplifies and optimizes the
UFS driver. These patches are entirely untested. Any feedback is welcome.

Thanks,

Bart.

Changes compared to v2:
- Use a separate tag set for TMF tags.

Changes compared to v1:
- Use the block layer tag infrastructure for managing TMF tags.

Bart Van Assche (3):
  ufs: Avoid busy-waiting by eliminating tag conflicts
  ufs: Use blk_{get,put}_request() to allocate and free TMFs
  ufs: Simplify the clock scaling mechanism implementation

 drivers/scsi/ufs/ufshcd.c | 375 +++++++++++++++++---------------------
 drivers/scsi/ufs/ufshcd.h |  21 +--
 2 files changed, 169 insertions(+), 227 deletions(-)
