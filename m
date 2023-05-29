Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76308C7EE2C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjE2UWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjE2UWJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:22:09 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4B9C9;
        Mon, 29 May 2023 13:22:08 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso2769480b3a.0;
        Mon, 29 May 2023 13:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685391728; x=1687983728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T/1p5SPPB7bjZzuyDBtEK1cugeOahZIuAhcqF3cMejo=;
        b=k/LIeNbF/GmxvMihBZozmXPpCTKG6wSbSNy7Eg7TS6DO/8vcp/S5N5KpLkSkEmwqRA
         slc585aR2KVU1hp0rfuFDVVY4I7COnzt0GyGbAYT9WJDvp12c5JEGyNvG1CM181KPizn
         X8AlTB1MZGPpmF/C7FpWetq3VGI+BHVFubrJZBScJykmci0ilIIO6VWbQHkN59x+3vDN
         rc9R+mkQU8TGAsSowUCGlDN9HlXfhrNM2mg9treztqzFYAbmlp1jlBYQZw61mldtrYKK
         MjJ71TdLMg/fjD327mgSTM08Mi4NuaMJsmtqs1krEzlN4JCtM5TvmPPHEB/VwSrMmTvk
         hY4g==
X-Gm-Message-State: AC+VfDw8b2esKRnug+J1q3iIHAHzl3dhZFlEkNC5rXzLPtWUyuJKSPHW
        WFUadj2gARXAQG4kJFjb6QQ=
X-Google-Smtp-Source: ACHHUZ4bW8Xk1H7EKas3ykVS00IzZVMy+iVtQ93TZj0y/HRRZ9ofRUPaAecUz2/Dz9fXFnLKIZrI0Q==
X-Received: by 2002:a05:6a20:3d26:b0:10a:cbe6:69f0 with SMTP id y38-20020a056a203d2600b0010acbe669f0mr139442pzi.10.1685391727523;
        Mon, 29 May 2023 13:22:07 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b19-20020a639313000000b0051b0e564963sm7439342pge.49.2023.05.29.13.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:22:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 0/5] ufs: Do not requeue while ungating the clock
Date:   Mon, 29 May 2023 13:21:52 -0700
Message-Id: <20230529202157.11361-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202157.11361-1-bvanassche@acm.org>
References: <20230529202157.11361-1-bvanassche@acm.org>
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

