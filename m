Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73ED2C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 18:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F5A6207D3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 18:59:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmLGCDhx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgETS7p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 14:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETS7o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 14:59:44 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4DEC061A0E;
        Wed, 20 May 2020 11:59:44 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f134so3505888wmf.1;
        Wed, 20 May 2020 11:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QVRzIw5gK9X80Q4zCQi5+LrdGRNRTwpX/elN2U6ejEI=;
        b=FmLGCDhxguF6bNHD6SODLgUzmLA/p4Gxc1NL+iWJo1UYZ6AWYmzdLLGP6mxTMna3LY
         idHhxxQkZjdN/MoP8g18PATW8T8l+LGxGlvLCT4jSus2ggAn13syBKK5DfKyJhXrxmEY
         Nk7J7n2FDUtS5qpP7S4BF9Pas9PuxfT2IXKSqgmzoKDXtmk/yjxpC/t9YMeDdLGQFfj2
         38v/8KJQ1V9OrMa3BxYZ3KuzI0d9rUIV/P2U5Nw4XEe2tQZDVFKjC16x0U+63b5AR664
         wAVbo6z4OnTj8KqyIVef3iarDmEXOddSRe/pzSoohG3B4jewVwyB2b7l5Oh4RKjsvUsz
         Pmpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QVRzIw5gK9X80Q4zCQi5+LrdGRNRTwpX/elN2U6ejEI=;
        b=UqIuY3Pdu+LsyUDY8JKN8evOxhHWapFhCZHq1xB+9j9MbIlNQX4++5VpikxVREfCTB
         1MCMDKVik0k5ij5pzKFleDe3soO9P18bDNZTgVAKfK10bzBefa8zXLlQgEPQjsUyA04+
         vTji/WeWklUoin7k+jbC8O7qEthjPoHZ/8Y46NyXfUDFnBnDP3z21vuHVVHiYSFnEbZb
         EBTIkN+YutmLhk+F2WmFkZCVnj7EEM3qkCnWK6ivrnS2YtXPY/catpurbvhhjRbnByMF
         s2lFvGvZyl5AImf5bXjWdrI6KkhcVM3X/bxaW/OLOmkC0Q+509pwAWYPg482GYMSodH4
         NaRQ==
X-Gm-Message-State: AOAM531El0X6h+x3E4ymiJ2UwTU6RXKon4ZeNpiGSNRl8v1fJmCqAW+J
        uqf+4Id3yHu8IvgNOgFybqU=
X-Google-Smtp-Source: ABdhPJydDZKgzAApy4kKFZ4WgRq2UFly1Ga7Z2UBJ/ii8/6KCYt0/YlY+CKGy/e2lXYNKaAnq9OkoA==
X-Received: by 2002:a7b:c8d4:: with SMTP id f20mr6008280wml.72.1590001182803;
        Wed, 20 May 2020 11:59:42 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id c19sm3896483wrb.89.2020.05.20.11.59.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 May 2020 11:59:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        paul.ely@broadcom.com, hare@suse.de, jejb@linux.ibm.com,
        axboe@kernel.dk, martin.petersen@oracle.com, hch@infradead.org,
        dan.carpenter@oracle.com, James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/3] lpfc: Fix errors in LS receive refactoring
Date:   Wed, 20 May 2020 11:59:26 -0700
Message-Id: <20200520185929.48779-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A prior patch set refactored lpfc to create common routines for NVME LS
handling for use by both the initiator and target paths.  The refactoring
introduced several errors spotted by additional testing and static checker
reporting.

This patch set corrects those errors.

The patches should enter via the nvme tree, as the lpfc modifications were
in support of nvme-fc transport api deltas merged via the nvme tree.

-- james


James Smart (3):
  lpfc: Fix pointer checks and comments in LS receive refactoring
  lpfc: fix axchg pointer reference after free and double frees
  lpfc: Fix return value in __lpfc_nvme_ls_abort

 drivers/scsi/lpfc/lpfc_nvme.c  |  2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c | 29 ++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli.c   | 10 ++++++----
 3 files changed, 25 insertions(+), 16 deletions(-)

-- 
2.26.1

