Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B45C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E25DD2173E
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DU/DTsT6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgHEJph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 05:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHEJpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 05:45:15 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B68C061756
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 02:45:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id c6so4205470pje.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2020 02:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=enPHZhAIgacaYoG0g5PLcN0YKtmwYnsc9zZw8BJ2Xe0=;
        b=DU/DTsT6BdDk0osMVnG8sdFmb+J+Ij/eOOTvRW3/ACsSc3rW75Rbtx+6x/4fZHb56x
         zVxSjfeGEFcjExPyzOWCdUO4n85suO6oSyxolFBBnyWNIJLYwSH7QZjJCswdPD5fKNEY
         r0bzDEihiWyfyueZZ1ADH09Yaj6aZHTbfWsTg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=enPHZhAIgacaYoG0g5PLcN0YKtmwYnsc9zZw8BJ2Xe0=;
        b=Wy4XW4H7e0jTt5s9zS/Xkl4l3s6y98hUVjlbvd3NCzqELe2L2YcOO51AGWvwQ8BraB
         c2jiYWd72IojGf2+RtFeArX46Z8JYobFp3+ahY5nBWFm9ycRRBT7z+JDRHFsFVT/LK6F
         HappvBUuz64zvE5pm9hS1yoHv51pxd0hzMDuoUGIKLaldALPzksH6O8ECr3QgWxmkgwd
         fixph+y51NInDJXvlZyAKfWXN6hPLKnZxlwPrEeWgAoz8kx+aoQL/GfBf/JzuXGO+Icu
         mJ1yino8JLkF+h+bVW2/TekRj6z2UQ4136yyl0Yk3/lsGEn1T398JRX535uYvFsDuGtV
         Wu+g==
X-Gm-Message-State: AOAM533DHsClYKNia85PoFSAltiD3fhyAsubFZqMXnFsLYdXQPlZLEbn
        E4FGQk9Jn49StWgxmB8uvfgbs1v7L9XFEZ6PDUvYr9w7BCE4IitpxYi251X0Gnab43kZbcVe+pk
        9Wm6CsGuPnlJsYHQXJCni18l2ANH7bLUEdipennaLLFvfIxRdDn9V0XFuuAiMYREikfrNC2Hjls
        eKTQX3yQ==
X-Google-Smtp-Source: ABdhPJw/LZa2oKvdi+LTY9KGOJ2p2XUtvnxdZUaArB2OGa3FJYxC4NTfhgRwSzUADe9ZBD0zsGju3Q==
X-Received: by 2002:a17:90a:fb50:: with SMTP id iq16mr2436266pjb.177.1596620712567;
        Wed, 05 Aug 2020 02:45:12 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id e9sm2632346pfh.151.2020.08.05.02.45.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 02:45:11 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hare@suse.de, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com, Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH 0/5] scsi: Support to handle Intermittent errors
Date:   Wed,  5 Aug 2020 08:20:57 +0530
Message-Id: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a support to prevent retries of all the pending/inflight
io's after an abort succeeds on a particular device when transport
connectivity to the device is encountering intermittent errors.

Intermittent connectivity is a condition that can be detected by transport
fabric notifications. A service can monitor the ELS notifications and
take action on all the outstanding io's of a scsi device at that instant.


This feature is intended to be used when the device is part of a multipath
environment. When the service detects the poor connectivity, the multipath
path can be placed in a marginal path group and ignored further io
operations.

After placing a path in the marginal path group,the daemon sets a bit in
scmd->state for all the outstanding io's on that particular device with
the new sysfs interface provided in this patch.This prevent retries of 
all the pending/inflight io's if an io hits a scsi timeout which inturn
issues an abort.On Abort succeeds on a marginal path the io will be
immediately retried on another active path.On abort fails then the things
escalates to existing target reset sg interface recovery process.

Below is the interface provided to abort the io
echo 1 >> /sys/class/fc_transport/targetX\:Y\:Z/noretries_abort

The patches were cut against  5.9/scsi-queue tree

Muneendra (5):
  scsi: Added a new macro in scsi_cmnd.h
  scsi: Clear state bit SCMD_NORETRIES_ABORT of scsi_cmd before start
    request
  scsi: No retries on abort success
  scsi: Added routine to set SCMD_NORETRIES_ABORT bit for outstanding io
    on scsi_dev
  scsi_transport_fc: Added a new sysfs attribute noretries_abort

 drivers/scsi/scsi_error.c        | 63 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c          |  8 +++--
 drivers/scsi/scsi_priv.h         |  1 +
 drivers/scsi/scsi_transport_fc.c | 49 +++++++++++++++++++++++++++++--
 include/scsi/scsi_cmnd.h         |  3 ++
 5 files changed, 120 insertions(+), 4 deletions(-)

-- 
1.8.3.1

