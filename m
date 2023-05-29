Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F8BC7EE23
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjE2U0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjE2U0t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:26:49 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0252C9
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:26:45 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5304d0d1eddso1777156a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:26:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685392005; x=1687984005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/1p5SPPB7bjZzuyDBtEK1cugeOahZIuAhcqF3cMejo=;
        b=kBYlGiXwyxx8ufcCq2hI6oSvCOV/Wj3tPVFc+8rzsvQ9temkdmPDNuPJ0hPcEYC4Ib
         j9vAcKXGTeh8s3djBF7Iv0PMHn+Y6L416yLXBgUGJDp7tXeVERZTc4B9365lLVFI9UX7
         KpFtS2jv5rK/DRRY2/59QXUTbafZJlrvd+1vB8LVjZ3mYOpUM+Qc2uY5JcRs+Y0kj3zj
         5d/OnjXobrQxh5t4ilYoE78q1D0HEenxrtwx42IKgHJYvohG+E05pbpSCLK0N1b3UVTF
         E901Z0qsh1JGvqOM4nqIcSuZa5YqHAOgn617uIri8xXV2ROWGCWTZmYLYvS688MDWTRa
         OyYw==
X-Gm-Message-State: AC+VfDwXE6WuP6iPUFNoyyyxi5vRUlUouRpo1nIQ5MhVcF22MMG257yG
        KlMFIM6/hNFpyCvc7MeoIPc=
X-Google-Smtp-Source: ACHHUZ4JNLgWlLUOBsXly1uST/Lz9tEdzfW3JgXM5Hw8lXmI6E5n2bj2fh9zXLf+3vxNfSieFq4M9A==
X-Received: by 2002:a17:903:2291:b0:1ac:a28e:4b1d with SMTP id b17-20020a170903229100b001aca28e4b1dmr294078plh.34.1685392005084;
        Mon, 29 May 2023 13:26:45 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id l18-20020a170903245200b001b027221393sm4957237pls.43.2023.05.29.13.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:26:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/5] ufs: Do not requeue while ungating the clock
Date:   Mon, 29 May 2023 13:26:35 -0700
Message-Id: <20230529202640.11883-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

In the traces we recorded while testing zoned storage we noticed that UFS
commands are requeued while the clock is being ungated. Command requeueing
makes it harder than necessary to preserve the command order. Hence this
patch series that modifies the SCSI core and also the UFS driver such that
clock ungating does not trigger command requeueing.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v3:
- Added a patch that removes two duplicate declarations.

Changes compared to v2:
- Only enable BLK_MQ_F_BLOCKING if clock gating is supported.
- Introduce flag queuecommand_may_block in both the SCSI host and SCSI host
  template data structures.

Changes compared to v1:
- Dropped patch "scsi: ufs: core: Unexport ufshcd_hold() and ufshcd_release()".
- Removed a ufshcd_scsi_block_requests() / ufshcd_scsi_unblock_requests() pair
  from patch "scsi: ufs: Ungate the clock synchronously".

Bart Van Assche (4):
  scsi: core: Rework scsi_host_block()
  scsi: core: Support setting BLK_MQ_F_BLOCKING
  scsi: ufs: Conditionally enable the BLK_MQ_F_BLOCKING flag
  scsi: ufs: Ungate the clock synchronously

Bart Van Assche (5):
  scsi: core: Rework scsi_host_block()
  scsi: core: Support setting BLK_MQ_F_BLOCKING
  scsi: ufs: Conditionally enable the BLK_MQ_F_BLOCKING flag
  scsi: ufs: Declare ufshcd_{hold,release}() once
  scsi: ufs: Ungate the clock synchronously

 drivers/scsi/hosts.c             |  1 +
 drivers/scsi/scsi_lib.c          | 27 ++++++----
 drivers/ufs/core/ufs-sysfs.c     |  2 +-
 drivers/ufs/core/ufshcd-crypto.c |  2 +-
 drivers/ufs/core/ufshcd-priv.h   |  3 --
 drivers/ufs/core/ufshcd.c        | 87 ++++++++++----------------------
 include/scsi/scsi_host.h         |  6 +++
 include/ufs/ufshcd.h             |  2 +-
 8 files changed, 54 insertions(+), 76 deletions(-)

