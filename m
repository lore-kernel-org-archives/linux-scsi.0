Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907E8C3F68F
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 555A02467B
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgAWEXx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 23:23:53 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40379 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgAWEXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 23:23:53 -0500
Received: by mail-pg1-f195.google.com with SMTP id k25so693538pgt.7
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 20:23:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iX/4w6jV+/5WqGUUjlUJZJZuiMnrH8UNXYL0OQa2CRI=;
        b=DaNcYiJ8blIfSx+KmXJsY0tL3SrP4M1K/XY2JqbkIU26g2XFUmF6UIDknHfEm0Ujak
         g82S6JFMOmsFait0HQYkmQUKJZr1gPLMqSGdA/o0nI4zAyB7MC1YrqD5f2TP4VyyLUc+
         yeBHBi6faa9J73bUdKkIVsbGVdolbdrb8ZXoBbSDK3eGFdlPPRxKVyc3yj/fbPNohvzA
         jzF6lV3Vy0/ESG4MjCBhA87obOcejfxwVORCHcOxvzc5qYMeCcqKHq4CQhI/E+ep0V3v
         TuvSjdHlZGPh6BaOgPs7ZTi1Xy0w9JnUUl5daiiyLQEVleSzITp0HtLNUXbwYXgENjqP
         v4nQ==
X-Gm-Message-State: APjAAAVM27lYdS5of2Ps5tQ2yNTHdNQcNWrLy3fEA+qEjbYTHlwVxqVe
        IBb4k9QkPyTYEt6hbAhcKC4=
X-Google-Smtp-Source: APXvYqw+w/hjTIv0pNix/wMRllicBOqB2IbGw9z2ml+/dXqrY2IQJ+9xHNDVdufMSTdH5C2cLHoTcA==
X-Received: by 2002:a62:f94d:: with SMTP id g13mr5713528pfm.60.1579753432681;
        Wed, 22 Jan 2020 20:23:52 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id p16sm492879pfq.184.2020.01.22.20.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 20:23:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/6] qla2xxx patches for kernel v5.6
Date:   Wed, 22 Jan 2020 20:23:39 -0800
Message-Id: <20200123042345.23886-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these six small qla2xxx patches for kernel v5.6.

Thanks,

Bart.

Changes compared to v1:
- Dropped patch "Fix point-to-point mode for qla25xx and older"
- Added three new patches.

Bart Van Assche (6):
  qla2xxx: Check locking assumptions at runtime in qla2x00_abort_srb()
  qla2xxx: Simplify the code for aborting SCSI commands
  qla2xxx: Suppress endianness complaints in
    qla2x00_configure_local_loop()
  qla2xxx: Fix sparse warnings triggered by the PCI state checking code
  qla2xxx: Convert MAKE_HANDLE() from a define into an inline function
  qla2xxx: Fix the endianness annotations for the port attribute
    max_frame_size member

 drivers/scsi/qla2xxx/qla_def.h  | 14 +++++++-------
 drivers/scsi/qla2xxx/qla_gs.c   | 14 ++++++--------
 drivers/scsi/qla2xxx/qla_init.c | 11 +++++------
 drivers/scsi/qla2xxx/qla_isr.c  |  5 -----
 drivers/scsi/qla2xxx/qla_mbx.c  |  5 ++---
 drivers/scsi/qla2xxx/qla_mr.c   |  5 ++---
 drivers/scsi/qla2xxx/qla_os.c   | 29 ++++++++++++++++-------------
 7 files changed, 38 insertions(+), 45 deletions(-)

