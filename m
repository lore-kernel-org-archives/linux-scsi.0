Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39337C352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB3A520842
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KDYTznqY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgBKKSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 05:18:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36440 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgBKKSg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 05:18:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so11573220wru.3
        for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2020 02:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=obzJ6U/NuyMHmBAx2PzD7kviiylkm8kDpSK0BE0zA/A=;
        b=KDYTznqYS0cdbJQs/X832+RZtkjRyq1Bl6DJHk5cjAAmvmbW9M1yRpEBWXXmDK7cVH
         U5C8OF7B/JFZKSK+g0ddtF+PXj+jqZ81Rj0gGGpo1+e12kDSpYPDGnfGa2n/65zfaHK5
         SSs5OF4R673wALaqr7iqnclu58p+tSUSAdYOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=obzJ6U/NuyMHmBAx2PzD7kviiylkm8kDpSK0BE0zA/A=;
        b=qCNvbMG6d5n0DZmETnKN/PHBRkyorm9JRwO9pU1RRGvABVdJwTLyCoSkl+Tx/MLw7v
         0Jguv9o/vJcZieLDl/G6h9XzqpsKNvYRQk1hIA9pnUje1BqKYkLDabl9MVMs1gCLY0G5
         fuDxvsI2IO50nhMqigc8cdl20VvryQcScqhBhHDsoINk/O1EPUHbMHV4u6XcL1ovCa2h
         DqSQwYlkh9JDyQ6dargBfNNC1iSUpCjRMPS/zY1BTk74joLmAqsYbNQBZjaW2XTnRpH+
         yrq4pQtG3FW6L4WAwOEwpEEl44JILysjgqR6jWtm04nw4YCF6IqOoxd61fMjmD5nXWDM
         UA3w==
X-Gm-Message-State: APjAAAVU3eVg7nE5gvJEJx/5Eu9cmeW9bE8MwqY8CidZ8cgisGrssLP6
        /s89RfadYQazHHZ0BKOE1JXTF0ub4iWTo2wspsI0RRyBor5k8eiIXA6GQJiOBbmrh4Weq+Pp7eu
        7v/dp+nEfXVGr7NZsYG106DC/PQ8Yftinen8VV8sfBFpgJH4Q2K2s0P+ui9+PxgGhnZmxWyANW3
        GyVPh0gWOsHkkL6QPBu83hCWI=
X-Google-Smtp-Source: APXvYqwbYD9FJ9aOaH1ccqfTTkKyqhkuh2QDihvFBulqz0sJjkGN2taly/p+5oXPjqI2QdvETrVPcA==
X-Received: by 2002:adf:a746:: with SMTP id e6mr7710233wrd.329.1581416314315;
        Tue, 11 Feb 2020 02:18:34 -0800 (PST)
Received: from dhcp-10-123-20-55.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f65sm3058895wmf.29.2020.02.11.02.18.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 02:18:33 -0800 (PST)
From:   suganath-prabu.subramani@broadcom.com
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, kashyap.desai@broadcom.com,
        sathya.prakash@broadcom.com, martin.petersen@oracle.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 0/5] mpt3sas: Fix changing coherent mask after allocation.
Date:   Tue, 11 Feb 2020 05:18:08 -0500
Message-Id: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

* Enables 64-bit dma for RDPQ and memory allocation 
within same 4gb region.
* With this there is no need to change DMA coherent
mask when there are outstanding allocations in mpt3sas.
* Code-Refactoring

Suganath Prabu S (5):
  mpt3sas: Don't change the dma coherent mask after      allocations
  mpt3sas: Rename function name is_MSB_are_same
  mpt3sas: Code Refactoring.
  mpt3sas: Handle RDPQ DMA allocation in same 4g region
  mpt3sas: Update version to 33.101.00.00

 drivers/scsi/mpt3sas/mpt3sas_base.c | 287 ++++++++++++++++++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |   9 +-
 2 files changed, 181 insertions(+), 115 deletions(-)

-- 
1.8.3.1

