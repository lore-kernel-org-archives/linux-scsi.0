Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE5BC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 089E620776
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:47:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E0TzlHVO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387931AbgFRCrp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733105AbgFRCrl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 22:47:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDCBC06174E
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 19:47:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a188so4908788ybg.20
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 19:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Lz9OqytQOx62YvB3/35dUDFEfoZf6bezxgXAiKQpDjE=;
        b=E0TzlHVOJfeEyCi4ZEM1EjuuNWtv8se7A/RToTfeTHit4MHRImn0+1VoUYb4XO7yf6
         1t7eaZB+q+vpIQrRJXrHWzPSKDEUSMOB1VFIzOKoRvqeu9vklD8e0TaDJs3+05jlgzep
         hta5/EiuiFd9jf8uO7WQIqqHpD5Y3Iw929rk+c7kku77PINJnRjbpASjiUJsTNtE2qm3
         vNsv10RgYwbpGiH09o4LbpsauOXv+rNGqkVYSf9popC2XBsEpg1C8GwNCF427LYkuU5z
         p8XrBaqbxAI8kawPX4I9HbL63OLe5l5g7S3FgHlt1vEBhyAMFR5QYfAASu7Lp3w8YvDe
         fneQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Lz9OqytQOx62YvB3/35dUDFEfoZf6bezxgXAiKQpDjE=;
        b=USK17EJPHkJrTS3x/+4C3OXLUpZyR45NGhgPcFNc8aUQzbNdbeU11W3FKiG2Ezh0EV
         juqZBZoB0LXscx06Fa71iynYsxiODudhjbYpphmvEeLawa0GGCPeKkUcGAx4l78pYr56
         MCNSU/Tc+C9b/duG3ftmoOyXiYzlNRZj4i7spPYCPqPHYUxgp6hDB1GyhlkIqFjbQbbq
         aMWSSSBAzPAU0Gbo7MXa89gijMeodN3lTaoRU+Wh7xoMuWTdVLl6cLEVHDITe9m/iRKY
         i8989uz4Booe44F/wMM+uX0CJiuGON1tRmGqzgpMWybaKX51wbmKOoiIxqfeQKIIKJvo
         XsfQ==
X-Gm-Message-State: AOAM531jQLAmbyjOqhC9PoKpOTfYVeBSF0PU/YNmMZ8D1YrOTyXYKiIv
        GVwl705BFy8J6Sr+lWDzpPdGWzG1oUWdk5hf2xDe6+Ys9ajchIrcdUnziWMXRJb9KDuyrYEidXK
        fWlvuTRNGSEeVjJPp3GuW7pjhBaZMV05fgwUp8DL2rup+32cl6+cJgaIPqDoz+wxjpxY=
X-Google-Smtp-Source: ABdhPJwUaM/Eg2UXQN52yXfqp10Qg46MXbbQTNcwIPf65PoXcchFjt4/EvQZoAY1aOkvg5r+ROnZ4d5BvOo=
X-Received: by 2002:a25:ac1b:: with SMTP id w27mr3295676ybi.378.1592448458905;
 Wed, 17 Jun 2020 19:47:38 -0700 (PDT)
Date:   Thu, 18 Jun 2020 02:47:33 +0000
Message-Id: <20200618024736.97207-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH v2 0/3] Inline Encryption support for UFS
From:   Satya Tangirala <satyat@google.com>
To:     linux-scsi@vger.kernel.org
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series adds support for inline encryption to UFS using
the inline encryption support in the block layer. It follows the JEDEC
UFSHCI v2.1 specification, which defines inline encryption for UFS.

This patch series previously went through a number of iterations as
part of the "Inline Encryption Support" patchset (last version was v13:
https://lkml.kernel.org/r/20200514003727.69001-1-satyat@google.com).
There aren't any significant changes here from that version.
This patch series is based on v5.8-rc1.

Patch 1 introduces the crypto registers and struct definitions defined
in the UFSHCI v2.1 spec.

Patch 2 introduces functions to manipulate the UFS inline encryption
hardware (again in line with the UFSHCI v2.1 spec) via the block
layer keyslot manager. Device specific drivers must set the
UFSHCD_CAP_CRYPTO in hba->caps before ufshcd_hba_init_crypto is called
to opt-in to inline encryption support.

Patch 3 wires up ufshcd.c with the UFS crypto API introduced in Patch 2.

This patch series has been tested on some Qualcomm chipsets (on the
db845c, sm8150-mtp and sm8250-mtp) using some additional patches at
https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-ebiggers@kernel.org/
and on some Mediatek chipsets using the additional patch in
https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/.
These additional patches are required because these chipsets need certain
additional behaviour not specified within the UFSHCI v2.1 spec.

Thanks a lot to all the folks who tested this out!

Changes v1 => v2
 - handle OCS_DEVICE_FATAL_ERROR explicitly in ufshcd_transfer_rsp_status

Satya Tangirala (3):
  scsi: ufs: UFS driver v2.1 spec crypto additions
  scsi: ufs: UFS crypto API
  scsi: ufs: Add inline encryption support to UFS

 drivers/scsi/ufs/Kconfig         |   9 ++
 drivers/scsi/ufs/Makefile        |   1 +
 drivers/scsi/ufs/ufshcd-crypto.c | 226 +++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-crypto.h |  60 ++++++++
 drivers/scsi/ufs/ufshcd.c        |  47 ++++++-
 drivers/scsi/ufs/ufshcd.h        |  24 ++++
 drivers/scsi/ufs/ufshci.h        |  67 ++++++++-
 7 files changed, 427 insertions(+), 7 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h

-- 
2.27.0.290.gba653c62da-goog

