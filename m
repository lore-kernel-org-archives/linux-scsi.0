Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9377C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiKPBKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiKPBKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:10:49 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2596330F4A
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:10:47 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id v8so10728335qkg.12
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qu5SqtL3Y8BzDJuMq8QjtvQOYcJx059WPdla2esMmj8=;
        b=Q80LVHyJQwr/ZFbQ5ZX5KJO6VpBITWSx4tX5tAj+tsQ+R16O7jCLsLHIjrGeWjMeVd
         TU7lWKVRm2eXMtg8SXIKbToh7EcVIjMWTYIBnYCShqQQLnM83+fo8CptzUidjFilLf0n
         NsYEaFEw3GiBZw2iJ7oZ6t+WV/xKBfIXbS3hPngz631EoyP0f+/xtkpKexdTFnlnZNzp
         Oy3P4jcqArhM4RU5Z1Ca8Wck7yu+kqOyzF0q7VKikeya0I7Zq8A49edBLxSI1sE5axj+
         QipO+18MXU3A5MObLx6A8E0UMGLkRCODR2k3wotS3lhg6Lzl0zVVaPCxLYhbKCOT7c5w
         pY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qu5SqtL3Y8BzDJuMq8QjtvQOYcJx059WPdla2esMmj8=;
        b=ritJ+5Ia6NxdmJEaHwIz5NUDiABh2HPgywM7wisgrFWjWYy6wIystoqy0XrwYjCJ9s
         7Mb7Eh7xfYoflKGHnbxXpEZR0gWZP4dgQ70QtPaNvfXEshC54khsmlcIbSL/l5WTTk0J
         gtXLmfPnJus5WO3CJiK9Jv02IHBlXprroi90v4PmUOCT6mH5LT6ik94n2I6D5+BkRtYj
         HG7zLWcYaTA37pYkbuky06eVmz305Xnsk7XBmxffIuNt99Jx4m4xqkZ42rJ7Yd+t6Moo
         b75JadXifu+HAPNkZO3dxQ9ufjA1xDnpDe8s0VMrmydIjGlFOErZgxt5PP5VMK33Ccnm
         bJMg==
X-Gm-Message-State: ANoB5pmHaXL8GOR+S68yvZriQKPmfIEw5Hl9595XOrFT0oj5MXb5GlAq
        Rd3N1evbJuZnkzvClvLtMUFC2dXuQJs=
X-Google-Smtp-Source: AA0mqf4r2odXOzypVfydmGvjs7DZBP2wlYuxbfiNFTDjPHttaeCEhDLpwGUACJ7ZUpnaketwurbKNQ==
X-Received: by 2002:a05:620a:319d:b0:6fa:91f9:e54e with SMTP id bi29-20020a05620a319d00b006fa91f9e54emr17591130qkb.53.1668561046208;
        Tue, 15 Nov 2022 17:10:46 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8128c000000b00399b73d06f0sm7901966qti.38.2022.11.15.17.10.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 17:10:45 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/6] lpfc: Update lpfc to revision 14.2.0.9
Date:   Tue, 15 Nov 2022 17:19:15 -0800
Message-Id: <20221116011921.105995-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.9

This patch set contains bug fixes and a change to a default setting.

The patches were cut against Martin's 6.2/scsi-queue tree.

Justin Tee (6):
  lpfc: Fix WQ|CQ|EQ resource check
  lpfc: Correct bandwidth logging during receipt of congestion sync WCQE
  lpfc: Fix MI capability display in cmf_info sysfs attribute
  lpfc: Fix crash involving race between FLOGI timeout and devloss
    handler
  lpfc: Change default lpfc_suppress_rsp mode to off
  lpfc: Update lpfc version to 14.2.0.9

 drivers/scsi/lpfc/lpfc_attr.c    | 12 +++++------
 drivers/scsi/lpfc/lpfc_els.c     | 36 +++++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_hbadisc.c | 36 +++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_init.c    | 15 ++++++-------
 drivers/scsi/lpfc/lpfc_sli.c     |  6 ++++++
 drivers/scsi/lpfc/lpfc_sli4.h    |  1 +
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 7 files changed, 79 insertions(+), 29 deletions(-)

-- 
2.38.0

