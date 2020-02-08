Return-Path: <SRS0=yjur=34=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3D0C2BA83
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 00:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2F2B2082E
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 00:13:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMaVvNqi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgBHANE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 19:13:04 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35980 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgBHANE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 19:13:04 -0500
Received: by mail-pg1-f193.google.com with SMTP id d9so604827pgu.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Feb 2020 16:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GHE9Zp8WC0asUoCQaq18Rxe/3ckNJpUCTqcDdiFI2Sc=;
        b=bMaVvNqiLQwABTb4+0jp0wZ5Nf+oQy2QAHyDB2uc/eBHdxsmQgE4FvTMyb/xri2GL1
         wOBlM9oE9iQC9AjLYeHkLSFCM6TraVQVZxkNfY2dXdJ0nUB5agFpRp7Ycnv+c25ARoeV
         U4+9DkdS3a27FOP1uV5AH12Jq0Z790D02Y8Imbc0N1JkcmYVEYdiCWOl/0JA7Cj4TbSb
         boRwikrcOKK6H2iuoyB6Z85+ysoZ/f7BQOE8gEWr2XqsX4g4jpajxFhgdG/ossifbgNp
         1bC21/sqG3canIFSS4Yq+u/KxVYEowOwyW9XUftSiBdqHppubPMbkLzcBj1LRRPGuUNt
         kTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GHE9Zp8WC0asUoCQaq18Rxe/3ckNJpUCTqcDdiFI2Sc=;
        b=Wey04xpzYnHBx64qYrqwiF2JqEbz13eyFuiqJrw1FzxeZP8ieLgsh981piyUwXMURa
         Sy1viThftBw5y1jJ3+a9nz7gUtc2oo+dCZc2/fpHtuEA0AHbBuswqLYLYHA5AFJcZwPe
         /vGlhIwqcNJW1sQzs5wtRm5JAmwbPTj7KmrvSNpLXo/xcVNKlqFHeQVpaLKX+z69cXRF
         x2Ygf8n0oyEqjleaLOTa5uY0edKshm0q5YHx4jQfuLIclSzEEQaRstFTNRP0KI3pueF3
         77pjujl/4OJEUNotkqwfxYq6NP0OaJO89Y/QllwsHegvrWB/m2ZgKi9QRKzRNwJvFIiP
         nczA==
X-Gm-Message-State: APjAAAUJJqaT89JjIW7MA7MGsHGv6DjvLOdf7aIcYWpL2VpYU8PNfx+i
        fBlXRKZKUCFQzNdgdqZIke0nM7OH
X-Google-Smtp-Source: APXvYqwwkjmLcnUxJtvXpiUhpcb6VbPfX3eN0r5E/0zjLBcapjsHz0Lbb17iyW/RwNVGwjUW/Mc6mw==
X-Received: by 2002:a63:7419:: with SMTP id p25mr1728123pgc.430.1581120781861;
        Fri, 07 Feb 2020 16:13:01 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y23sm4175827pfn.101.2020.02.07.16.13.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Feb 2020 16:13:01 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/2] lpfc: Add Link Integrity FPIN registration and logging
Date:   Fri,  7 Feb 2020 16:12:51 -0800
Message-Id: <20200208001253.30594-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds the RDF ELS to the driver to register to receive Link
Integrity FPINs from the fabric.  The driver also adds logging of the
elements contained in the FPIN before delivering it to the scsi fc
transport.

As part of the patch, the uapi/scsi/fc/fc_els.h header is updated with
the FC standards definitions for the RDF and FPIN ELS and their components.

This patch was cut against 5.7/scsi-queue

James Smart (2):
  fc: Update Descriptor definition and add RDF and Link Integrity FPINs
  lpfc: add RDF registration and Link Integrity FPIN logging

 drivers/scsi/lpfc/lpfc.h         |  29 ++++
 drivers/scsi/lpfc/lpfc_crtn.h    |   3 +-
 drivers/scsi/lpfc/lpfc_els.c     | 325 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c |   4 +-
 drivers/scsi/lpfc/lpfc_hw.h      |   4 +-
 drivers/scsi/lpfc/lpfc_hw4.h     |  19 +++
 drivers/scsi/lpfc/lpfc_sli.c     |   1 +
 include/uapi/scsi/fc/fc_els.h    | 211 +++++++++++++++++++++++--
 8 files changed, 558 insertions(+), 38 deletions(-)

-- 
2.13.7

