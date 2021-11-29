Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD99BC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhK2Tvf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:35 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:38774 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354589AbhK2Tte (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:34 -0500
Received: by mail-pl1-f177.google.com with SMTP id o14so13043377plg.5
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z7WxOKL1bMxoms8HaKTwpQbnB9hQvZmFF2Y4uuVxJTY=;
        b=lSTsDYdRZxnt/qvX5ot7NfKoMjwtvDI0FYSKeI7l3cy9u/9bh/fMYMCA3fr5q5MC+r
         +HBDs2HHup0NhVleIJ3Gt7QZbNcCWMed+acIjNt7uh9WnQwtdHeTzeM1WKW2/BXTTofK
         tdxDeOf5Fpu0ObJ3D4JwinrrfFlBR7geZk9z8Fggr36fJ5u3N/4Jf6XPl4E+83paJknR
         RxsEF5QZY377P70z+qKRpTG+xP4r8hrWnUIx5dLeVkUEUfrjwXHj/Dw5ZlGEJQA754AJ
         xU57qRU7bsmHvvG1gX5h+kogF6Er7UK61Wfb+5LINDu2KUUR45M0hCRurzMVw2ONfENw
         deGg==
X-Gm-Message-State: AOAM532xFUx9r9dRoxeWBFDN7iFDc2wMKXVsHS9SRIrQENm1YwoHRHKN
        DgtxDc/7qgyj+HBxFZ3RTVs=
X-Google-Smtp-Source: ABdhPJzkf6vGzFJ1eccQ/jHlGQi6/SwXnaq+lw6OPlU+E518PtdygEcYQVJZwDgXinkFwpNrSlKD3g==
X-Received: by 2002:a17:903:2045:b0:142:3d07:2866 with SMTP id q5-20020a170903204500b001423d072866mr61300436pla.17.1638215176535;
        Mon, 29 Nov 2021 11:46:16 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/12] A series of small SCSI patches
Date:   Mon, 29 Nov 2021 11:45:57 -0800
Message-Id: <20211129194609.3466071-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes a number of static checker warnings. Most of these
patches fix warnings introduced during the merge window.

Please consider these patches for kernel v5.17.

Thanks,

Bart.

Changes compared to v1:
- Dropped one patch since it is already upstream.
- Updated Acked-by / Reviewed-by tags.

Bart Van Assche (12):
  scsi: core: Suppress a kernel-doc warning
  scsi: core: Declare 'scsi_scan_type' static
  scsi: core: Show SCMD_LAST in text form
  scsi: a100u2w: Fix a kernel-doc warning
  scsi: atp870u: Fix a kernel-doc warning
  scsi: bfa: Declare 'bfad_im_vport_attrs' static
  scsi: dc395x: Fix a kernel-doc warning
  scsi: initio: Fix a kernel-doc warning
  scsi: megaraid: Fix a kernel-doc warning
  scsi: pm8001: Fix kernel-doc warnings
  scsi: pmcraid: Fix a kernel-doc warning
  scsi: Remove superfluous #include <linux/async.h> directives

 drivers/scsi/a100u2w.c                |  2 --
 drivers/scsi/atp870u.c                |  1 -
 drivers/scsi/bfa/bfad_attr.c          |  2 +-
 drivers/scsi/dc395x.c                 |  3 +--
 drivers/scsi/hisi_sas/hisi_sas.h      |  1 -
 drivers/scsi/initio.c                 |  2 --
 drivers/scsi/libsas/sas_discover.c    |  1 -
 drivers/scsi/megaraid/megaraid_mbox.c |  1 -
 drivers/scsi/pm8001/pm8001_ctl.c      | 24 ++++++++++++------------
 drivers/scsi/pmcraid.c                |  1 -
 drivers/scsi/scsi.c                   |  1 -
 drivers/scsi/scsi_debugfs.c           |  1 +
 drivers/scsi/scsi_pm.c                |  1 -
 drivers/scsi/scsi_priv.h              |  1 -
 drivers/scsi/scsi_scan.c              |  4 ++--
 drivers/scsi/sd.c                     |  1 -
 drivers/scsi/ufs/ufshpb.c             |  1 -
 17 files changed, 17 insertions(+), 31 deletions(-)

