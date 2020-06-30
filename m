Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B033BC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824AF2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXka4+Ow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgF3VuP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgF3VuM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:12 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169FCC061755
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:12 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j18so20212725wmi.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CGU10iYGdKNENwc3exBUybOmGkG1awYu0CtnuSSLH4U=;
        b=nXka4+OwaEZAV5aXzojEntA361MQ5g1GiTdkGvXDTG7R5j9ut5HcUCS51BZuAkxRV+
         YxfjSnnO1EQQ+3TG2YSvevtlF0dK3TDI8PAgbo6pYmDE2vLh3h0aSDRRU9Na4ZOVadbx
         6/5lfKL6gp9gff6cHJjEFfiSiA/mKNvKHBQ73G8EpGJDqrL6xHucpP7KSICOAgTfDVVo
         g8Q+y1hcI+RVcOca1YByb1fmKixoSuAs6DB7fJ1mzg7b+XRlf+VVZgol+cX80FL3IpBj
         ftfZa6nySUa0RbTgFmW/febcMA2QFZ1DB3myGyleWifSduRqytTFp3jIn3fT0csRcG2o
         IjgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CGU10iYGdKNENwc3exBUybOmGkG1awYu0CtnuSSLH4U=;
        b=D8GMyo5I6QfWTJgIUHmiI74LvuNJ8f6gKV+JYCKH6E3gpN2HB3oQ28vSzSC833LJm9
         HdbnLJ5BRsXcrsj6kmbnvU7zhsnLzr72pQjtVnCx72Vg0+JjBts5W5YpqBwB0tdaPZ1f
         Dg68hYkHGC09IWCsoaBeKSvj+7bqek1pK/UMXUGTGYtcpQvlKWRCLtpjTW5yIAuEuHQf
         8TYCAfLnWDP1qjQ3wm88TsxX4N3whj0d0EJ7GZidgSZMpLdIhdTmABKfLJs8Gbt/GKL0
         bcd7n5BueJkMNTKjpgx0ERb6M6ro6xg90fS+FPjSqqKrMJRFvgyjYYAF6cke19bpF2PO
         0KYg==
X-Gm-Message-State: AOAM532TLI+UylAPw8sIZq3tgZXjGLtV7rnlq4COiGYlvqVJ4q1DSh8p
        eksMjoH4Ji5b88lAWNShhti02hDf
X-Google-Smtp-Source: ABdhPJyVIvG1UOlybnpGYcKTaKsYEtdrHwoutjyitIur8et3V8IPrgii4rPPaFwcDZ5RtEh3MSINTw==
X-Received: by 2002:a1c:8192:: with SMTP id c140mr22399445wmd.108.1593553810546;
        Tue, 30 Jun 2020 14:50:10 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:09 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/14] lpfc: Update lpfc to revision 12.8.0.2
Date:   Tue, 30 Jun 2020 14:49:47 -0700
Message-Id: <20200630215001.70793-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.2

Patch set contains fixes as a couple of small additions, and two larger
additions - blk_io_poll support and a different log message facility.

The patches were cut against Martin's 5.9/scsi-queue tree

James Smart (14):
  lpfc: Fix unused assignment in lpfc_sli4_bsg_link_diag_test
  lpfc: Fix missing MDS functionality
  lpfc: Fix first-burst driver implementation.
  lpfc: Fix NVME rport deregister and registration during ADISC
  lpfc: Fix oops due to overrun when reading SLI3 data
  lpfc: Fix stack trace seen while setting rrq active
  lpfc: Fix shost refcount mismatch when deleting vport
  lpfc: Fix kdump hang on PPC
  lpfc: Fix language in 0373 message to reflect non-error message
  lpfc: Allow applications to issue Common Set Features mailbox command
  lpfc: Add support to display if adapter dumps are available
  lpfc: Add blk_io_poll support for latency improvment
  lpfc: Add an internal trace log buffer
  lpfc: Update lpfc version to 12.8.0.2

 drivers/scsi/lpfc/lpfc.h           |  15 +
 drivers/scsi/lpfc/lpfc_bsg.c       |  35 +-
 drivers/scsi/lpfc/lpfc_bsg.h       |  14 +
 drivers/scsi/lpfc/lpfc_crtn.h      |   6 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  16 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       | 135 +++---
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 220 +++++-----
 drivers/scsi/lpfc/lpfc_hw4.h       |   5 +-
 drivers/scsi/lpfc/lpfc_init.c      | 667 ++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_logmsg.h    |  24 +-
 drivers/scsi/lpfc/lpfc_mem.c       |   3 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  83 ++--
 drivers/scsi/lpfc/lpfc_nvme.c      |  67 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  96 ++---
 drivers/scsi/lpfc/lpfc_scsi.c      | 421 +++++++++++++++---
 drivers/scsi/lpfc/lpfc_scsi.h      |  24 ++
 drivers/scsi/lpfc/lpfc_sli.c       | 587 ++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_sli.h       |   1 +
 drivers/scsi/lpfc/lpfc_sli4.h      |  18 +
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |  86 ++--
 22 files changed, 1636 insertions(+), 890 deletions(-)

-- 
2.25.0

