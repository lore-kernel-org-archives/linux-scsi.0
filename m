Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F64CA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98BC12089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfRtkO9c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440269AbfJRVSv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:18:51 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:43062 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390763AbfJRVSv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:18:51 -0400
Received: by mail-pg1-f182.google.com with SMTP id i32so4009021pgl.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JxH1HXqcadeC4Tc0Scs85to3iorK+sJnq1VcWHO+a1s=;
        b=OfRtkO9cA+P2/KY0/1ZeHvQl7Nu/K2rLu9aU668Jjs2d6B+BDlt096dBzIfqzexpx+
         esjnSmdr2G7+NPOzIZjQMYQqstwW+c2bSngWj3B/XekFGBU69YA8eIfKebliDjy5Uwhd
         kemchhrjighhznXHcDHDATkiVG+ZipIxZndyDWYEVrVSq6Jm9HryW4b1UBeuM6cYdqS8
         cez8Rr1tZBwRAWD/RZ7Bfo615F3QKobOrYF9zIqOOSW+ogTzLQJf+VXa5fZf4B+IZg82
         xs9l/8Uz+QIP4rkCdbRbtX2c0vU2pH6uuQbno38COK4nUTLlTjrmopBljf3sg0TGrzpp
         ry4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JxH1HXqcadeC4Tc0Scs85to3iorK+sJnq1VcWHO+a1s=;
        b=m8pMtKGD6bzuo3NRZ4iQBrjH1ZL/JKJlHFGd/otfsH0UcTiHGvIOhZmtyaYd842RdK
         I4amKpcODmlXK4x2WFZXm/fOQU3dnh4kmS/rBG0RLfIA3v+bmLBx9F7plCXzMZpSufXT
         2PXIAM7fMEQuVNfuxyaMuc3o9EYXNJTB5Ifn6fm8xAlhzhsM7/YrSX5uXfLuD6Hz/5Cr
         7PzdsT8vVPTiY605+bEDBhwLHRfrBrkTOVAlODQLPSf/faSKxYToKAEeKL8UogsIwsVe
         2/eONlH1WS+S8IfNFYnNGC+d7OjJ1keqVJA7e7PP3aS4E295W8eqmpcZ8YP44ezGlDuf
         f8GQ==
X-Gm-Message-State: APjAAAXHW/AkSl+uNnC6i4h5cS148TGgjI6qhQ/a6v0etTrIepzcAvN4
        LHxQaFvnvoZe4RxVmlyCBt6S5R7J
X-Google-Smtp-Source: APXvYqwMe3RrKdCOMK5cc8o73g9uFLD69aBwxejX5CjwjVrC0C/eYTp+FQ7b419OYadej3adOBtwbg==
X-Received: by 2002:a17:90a:d141:: with SMTP id t1mr13323283pjw.103.1571433528806;
        Fri, 18 Oct 2019 14:18:48 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.18.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:18:48 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/16] lpfc: Update lpfc to revision 12.6.0.0
Date:   Fri, 18 Oct 2019 14:18:16 -0700
Message-Id: <20191018211832.7917-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.6.0.0

This patch contains a set fixes, optimizations, and a handful of
new additions. 

The patches were cut against Martin's 5.5/scsi-queue tree

James Smart (16):
  lpfc: fix lpfc_nvmet_mrq to be bound by hdw queue count
  lpfc: Fix reporting of read-only fw error errors
  lpfc: Fix lockdep errors in sli_ringtx_put
  lpfc: Fix SLI3 hba in loop mode not discovering devices
  lpfc: Fix bad ndlp ptr in xri aborted handling
  lpfc: Fix hardlockup in lpfc_abort_handler
  lpfc: fix coverity error of dereference after null check
  lpfc: Slight fast-path Performance optimizations
  lpfc: Remove lock contention target write path
  lpfc: Revise interrupt coalescing for missing scenarios
  lpfc: Make FW logging dynamically configurable
  lpfc: Add log macros to allow print by serverity or verbocity setting
  lpfc: Add FA-WWN Async Event reporting
  lpfc: Add FC-AL support to lpe32000 models
  lpfc: Add additional discovery log messages
  lpfc: Update lpfc version to 12.6.0.0

 drivers/scsi/lpfc/lpfc.h           |  11 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  92 +++++++++++++-
 drivers/scsi/lpfc/lpfc_bsg.c       |  18 ++-
 drivers/scsi/lpfc/lpfc_ct.c        |  22 +++-
 drivers/scsi/lpfc/lpfc_debugfs.c   | 117 +++++++++++++++++-
 drivers/scsi/lpfc/lpfc_els.c       |  14 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  39 +++++-
 drivers/scsi/lpfc/lpfc_hw4.h       |  15 ++-
 drivers/scsi/lpfc/lpfc_init.c      | 242 +++++++++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_logmsg.h    |  17 +++
 drivers/scsi/lpfc/lpfc_mbox.c      |   1 +
 drivers/scsi/lpfc/lpfc_mem.c       |   3 -
 drivers/scsi/lpfc/lpfc_nportdisc.c |   4 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  46 ++-----
 drivers/scsi/lpfc/lpfc_nvmet.h     |   2 -
 drivers/scsi/lpfc/lpfc_scsi.c      |  33 ++---
 drivers/scsi/lpfc/lpfc_sli.c       |  40 ++++--
 drivers/scsi/lpfc/lpfc_sli.h       |   3 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |   2 +
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 21 files changed, 567 insertions(+), 158 deletions(-)

-- 
2.13.7

