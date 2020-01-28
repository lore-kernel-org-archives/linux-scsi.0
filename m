Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E79C32771
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD2D322527
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjnlZ9Ow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgA1AXY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:24 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:35078 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1AXY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:24 -0500
Received: by mail-wm1-f50.google.com with SMTP id b2so639234wma.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2y50HIom+3DX9zQHP3CeMW5fajFxBsDno3GGcOMEtE=;
        b=SjnlZ9OwIpBfz2GYOTClhah9YBfE+Q3rbHrEybjVUCJ1MjvAKJa04bJhqexil4TI4G
         OwZ2SyMqzJ6c7l9SSyLmwjxAKeW8phLrk/ttXlGC1GppOURaMST0iWWR9nsCIHJsKJbu
         K+cL8ekZM37MRJVTlUNh5omxPxqmY0w1uUSZ5qOP4uepT2N0Kc5BPOWj+JWn5L5+gpA6
         sMjE5lj8KwI3U4ut2bjl4EEDlpBsJcF/OPzJVbOdYUz6yLUGm2XFiKI9bJEIP2QT7eaT
         nbJGyGshOAuuLTrqE/LvZaKIrD8DutACeSPjfNH//F/5pgMsof+hvARgr68Z4N8oKNwj
         qIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2y50HIom+3DX9zQHP3CeMW5fajFxBsDno3GGcOMEtE=;
        b=HVndFUzmYlQVUrnzsZygH+EluqNOr3Ehb7mCzmRt0DGHRiW4A+bF7wUPMku9FptqJZ
         FkPWLbaiDYAfps7xwji950F7YVQzLAZ4/EkhukaglgVABVZ8QN94YTj4A1De8lYg5BhK
         iCviW4LWxl3XK0UkFVCf2xaYVcvoKxkr3HqwvROYQgZeOXs1LRuXUJD2v5b6KOcIEiVo
         KYKTsidr5DFXVoUo9vhkHIGu90LMaEjUYBW9t3JHOxhd0i8/SR66a44lYHp5EiEiWfBv
         BviFEbO+tH3ccXloOCSRCqTmE+P26aE+5CTvdY8eElbLuGaal/8Ij1OQxov8cSx2pfOA
         CdRA==
X-Gm-Message-State: APjAAAV/v9TQonN8GuPFewmBwXQatxbdpPE5/qkPK4fMguuFVAkJBICd
        +OfUuBVZkuNpeo1bG57/GkHhWsH3
X-Google-Smtp-Source: APXvYqzz4Qi1wQiaLLOjKFl9qVFGkrePBeP3Jg8J23V+TTG1DYkGc4PAXjpb55mrkhumQIYHcSepWQ==
X-Received: by 2002:a05:600c:2488:: with SMTP id 8mr1233321wms.152.1580171001785;
        Mon, 27 Jan 2020 16:23:21 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:21 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/12] lpfc: Update lpfc to revision 12.6.0.4
Date:   Mon, 27 Jan 2020 16:23:00 -0800
Message-Id: <20200128002312.16346-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.6.0.4

Patch set contains mainly fixes and a few cleanups.

The patch "lpfc: Change lpfc_lun_queue_depth attribute to writable" is
dependent upon the following patch series, which adds the new
scsi service routine shost_change_max_queue_depths():
https://www.spinics.net/lists/linux-scsi/msg137981.html

The patches were cut against Martin's 5.6/scsi-queue tree

-- james


James Smart (12):
  lpfc: Fix RQ buffer leakage when no IOCBs available
  lpfc: Fix lpfc_io_buf resource leak in lpfc_get_scsi_buf_s4 error path
  lpfc: Fix broken Credit Recovery after driver load
  lpfc: Fix registration of ELS type support in fdmi
  lpfc: Fix release of hwq to clear the eq relationship
  lpfc: Fix compiler warning on frame size
  lpfc: Fix coverity errors in fmdi attribute handling
  lpfc: Remove handler for obsolete ELS - Read Port Status (RPS)
  lpfc: Clean up hba max_lun_queue_depth checks
  lpfc: Change lpfc_lun_queue_depth attribute to writable
  lpfc: Update lpfc version to 12.6.0.4
  lpfc: Copyright updates for 12.6.0.4 patches

 drivers/scsi/lpfc/lpfc.h         |   7 +-
 drivers/scsi/lpfc/lpfc_attr.c    |  64 +++++++++++--
 drivers/scsi/lpfc/lpfc_ct.c      | 141 ++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_els.c     | 195 ++-------------------------------------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  61 +++++++-----
 drivers/scsi/lpfc/lpfc_hw.h      |  58 ++++--------
 drivers/scsi/lpfc/lpfc_init.c    |  40 ++++----
 drivers/scsi/lpfc/lpfc_scsi.c    |   6 +-
 drivers/scsi/lpfc/lpfc_sli.c     |  15 +--
 drivers/scsi/lpfc/lpfc_version.h |   4 +-
 10 files changed, 227 insertions(+), 364 deletions(-)

-- 
2.13.7

