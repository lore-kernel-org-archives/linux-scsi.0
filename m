Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1803E95A9E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 16:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbjJIQFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 12:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377086AbjJIQFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 12:05:21 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265BE9E
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 09:05:20 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c746bc3bceso10362835ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2023 09:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696867519; x=1697472319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Si8SZKkU4HgQdzyVVzy808PyIykML7OSQc30Nhf5sk=;
        b=kvpow71mSxpwx6vJCmNkVu9eZMANc1BLo14sklyXlbsFjEyG/cIu5Bh7/PmBPFBiC6
         urTgf66vVfje86NMetKnDzZXtWc6qwG81jJLdr2QrmjiYUtMo9gT+9JD4roKhdtK1C4f
         o6ocH6D2WZAlVEejr89Vhvxpnhfj3eBQK5kWKkXFJrbcPXSuhzgBUWZKCWqK3xh7jKlc
         ZE+NW8n61i4IxnzT/V0m14sCTQEolfzNzgzCrsXxCyfvD+8+FilggDoW1XsMwEMl6DQv
         xT7KCNGimB0SViC3qaWyGkWuhsuNkFbr5dKrn/mEcxOjrJLEt6utoR1tRiuHr5DOQyaM
         LWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696867519; x=1697472319;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Si8SZKkU4HgQdzyVVzy808PyIykML7OSQc30Nhf5sk=;
        b=C5+lofN3RaJEPFGqcquwWFtgwypJ4R+c466dl5RuFT3TdHJ1AIe/WBXt2ZhRSmQF0J
         CY3OvDLUG0t9DXq8U+KfSxBOC38YUO+fpBNjgxmgS34NtAGtkFn26RLNoP4wDl2qsiU8
         YFgfh2exKZiJCffLX5tZuo4dFkUl2+lxWPOD8zpt+nSsraXOHaueMEEuIJJ6hcbATNB2
         bD69Mj/RNzTJscqHJW+NUHxLanhhCI1g00QQrVo+Q1ZQW/WEtjvx1nhXuHXR9InZ5uwh
         PS1OCwoo1kvd+er31tR9zhFq9zfEYg1MhPBUTPFOg82EYttdXAAmoyyMRGk68akpWOCW
         rc3A==
X-Gm-Message-State: AOJu0YydCUD3roe3eGroh9/K9TPhUD7HSt9RZo6fDdUzZHVDUujS0/kO
        0f50YUJO/zOTYOWSQIL28dkY8kQljzE=
X-Google-Smtp-Source: AGHT+IHoePjp3SFbv+vqoIvmI7Ug8/juGE1s78kOD71z6a0A39tVVaQf0gdaAMRqV2z72JRcaIvLWg==
X-Received: by 2002:a17:902:ce84:b0:1c6:9312:187 with SMTP id f4-20020a170902ce8400b001c693120187mr17638031plg.3.1696867519209;
        Mon, 09 Oct 2023 09:05:19 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902d34d00b001bb9f104328sm9793418plk.146.2023.10.09.09.05.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Oct 2023 09:05:18 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: [PATCH 0/6] lpfc: Update lpfc to revision 14.2.0.15
Date:   Mon,  9 Oct 2023 09:18:06 -0700
Message-Id: <20231009161812.97232-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Justin Tee <justin.tee@broadcom.com>

Update lpfc to revision 14.2.0.15

This patch set contains error handling fixes, ELS bug fixes, and logging
improvements.

The patches were cut against Martin's 6.7/scsi-queue tree.

Justin Tee (6):
  lpfc: Remove unnecessary zero return code assignment in
    lpfc_sli4_hba_setup
  lpfc: Treat IOERR_SLI_DOWN I/O completion status the same as pci
    offline
  lpfc: Reject received PRLIs with only initiator fcn role for NPIV
    ports
  lpfc: Validate ELS LS_ACC completion payload
  lpfc: Introduce LOG_NODE_VERBOSE messaging flag
  lpfc: Update lpfc version to 14.2.0.15

 drivers/scsi/lpfc/lpfc_els.c       | 23 +++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  8 ++++----
 drivers/scsi/lpfc/lpfc_logmsg.h    |  2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 18 ++++++++++++++----
 drivers/scsi/lpfc/lpfc_nvme.c      |  6 ++++--
 drivers/scsi/lpfc/lpfc_sli.c       |  4 +---
 drivers/scsi/lpfc/lpfc_version.h   |  2 +-
 7 files changed, 48 insertions(+), 15 deletions(-)

-- 
2.38.0

