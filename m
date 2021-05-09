Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E2CC433ED
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 351A7613C5
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhEIVoT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 17:44:19 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:33687 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhEIVoS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 17:44:18 -0400
Received: by mail-pf1-f181.google.com with SMTP id h11so12458913pfn.0
        for <linux-scsi@vger.kernel.org>; Sun, 09 May 2021 14:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n/YPnwUAP7d37x+nWEn86iL15TmUEyX9v1bK+ty/vsw=;
        b=MwOPKGp8EmTNai2zjjAOVpsi3mxePevVrYy/fGHBA8zizld2FOIy6KFY1lqEl/3cch
         fm+f+QfMz1PmaAPEgYhGUVkX8jFmpH7rg8maSfb6b/NzBwkvuGjwIa9vDgtTW3PvToUo
         W321iw3yuvlplKCT10fJUW9UCFtE04GxgXP+8itb9LL+AaDiPxX7uiqSpplq1ia3myCI
         1WxiA3kaawmNgTjJVU/HUJKnyEk7O0N7h5ZtOufBa2oEnA6wtDeYSJXE4DtWduGMuUx7
         8BTfQ6a7NBmwVvN+PCoHH50mTb5KoYfMoNUdIEQ9ext7FIBucfi7mUPM+zfeST0Tszx6
         hzlQ==
X-Gm-Message-State: AOAM5325MG6Pvy3wCmil8l8iBSRDbDJMta9V9IRMSb1Z7rn+R6bkjFCz
        yOcFH+w11eZS9h//DFtmWaYq69VsCNM=
X-Google-Smtp-Source: ABdhPJxG/D77gBVDGPSEfQs3ahQdkiy65NJsJ+JchDt/iTiQ1by1w35Uucfs78zpeWdI7dejwMbS0A==
X-Received: by 2002:a62:d108:0:b029:25d:497e:2dfd with SMTP id z8-20020a62d1080000b029025d497e2dfdmr22317108pfg.29.1620596594954;
        Sun, 09 May 2021 14:43:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1f3e:222f:39bb:cb2e])
        by smtp.gmail.com with ESMTPSA id t4sm9712567pfq.165.2021.05.09.14.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:43:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/7] Rename scsi_get_lba() into scsi_get_pos()
Date:   Sun,  9 May 2021 14:43:00 -0700
Message-Id: <20210509214307.4610-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series renames scsi_get_lba() into scsi_get_pos(). The name of
scsi_get_lba() is confusing since it does not return an LBA but instead the
start offset divided by 512.

Please consider this patch series for kernel v5.14.

Thanks,

Bart.

Bart Van Assche (7):
  Introduce scsi_get_pos()
  iser: Use scsi_get_pos() instead of scsi_get_lba()
  zfcp: Use scsi_get_pos() instead of scsi_get_lba()
  iscsi: Use scsi_get_pos() instead of scsi_get_lba()
  qla2xxx: Use scsi_get_pos() instead of scsi_get_lba()
  ufs: Fix the tracing code
  Remove scsi_get_lba()

 drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
 drivers/s390/scsi/zfcp_fsf.c             |  2 +-
 drivers/scsi/isci/request.c              |  4 ++--
 drivers/scsi/lpfc/lpfc_scsi.c            | 12 ++++++------
 drivers/scsi/qla2xxx/qla_iocb.c          |  9 +++------
 drivers/scsi/qla2xxx/qla_isr.c           |  8 ++++----
 drivers/scsi/ufs/ufshcd.c                | 20 +++++++-------------
 include/scsi/scsi_cmnd.h                 |  2 +-
 include/trace/events/ufs.h               | 10 +++++-----
 9 files changed, 30 insertions(+), 39 deletions(-)

