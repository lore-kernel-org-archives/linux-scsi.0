Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B57FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09E2F2053B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rrcWDFPO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgFCJUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgFCJUP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 05:20:15 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF5FC05BD43;
        Wed,  3 Jun 2020 02:20:15 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id x1so1377794ejd.8;
        Wed, 03 Jun 2020 02:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3DI0t3OHBLadpo7QorIFcufLBAcgTKa7K38eRTU2zac=;
        b=rrcWDFPOBajLO3DBatyL3qv6TP2l1qbGg53b4iPYWVbAUXDyOAt05D+PU1XoSK+NZT
         O0wZB/qgo+ig/Y7wYxOqFMe6eIzNN+6wY0NwZL9PSBPtNliQThtRV7/uOPmqhyHZHFmg
         JS/eGy8OVDzU0whCYe977jIIS2z96Fyr+1gHPYtPnNSbqdGsdpXl0RwIurkLWpHR2RGg
         AbSJ1NdQOWgC8tOvMGtonn1+6/4cFXM9s1lPO5iTA8r3xWf5aWXHUPHBEWDHeIj874y4
         342uTHhjKIFP7fmnPHhUml7WOP9JL1icZeN56mqCloxkRbrYaDn6wZ7/LNTXowh3o5BZ
         07GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3DI0t3OHBLadpo7QorIFcufLBAcgTKa7K38eRTU2zac=;
        b=XDHIYugpXCkvtWCHwnXJhnyDmdBIrxW7CGeuKxfmUULhXzea2Zcyv2sUnCHyl5fyIr
         bYynWVLVgAvB+Hvql12Z5XbfJfx3Sk5AOmolaJQQQP3U4+XjH7FPAkuZfvC43HsGl8ul
         cjbfsDDuUffvv3WHwsrwRuyuyijVV60ZquwYvmP0+BLQ0cZJSZU2EPjswOaPa7LFuIK3
         KX8rvhtP4Gdj57LZLTAg0Zz9S1rQZmYLXvSeZqn9D8SbeuhNIGv/fpLcZr75kQwBJYO6
         TQdRp/vKUhrsp1Lgn+hP+Oi2GqygfRXWqhh1L41JpKathL3Dzf/M+hG3lGjihFDj69e7
         EvXg==
X-Gm-Message-State: AOAM530wyF5iTCNoov62CB6zQF1tx0nPtbe/jOzv1t/YsMnXNgsPpcrb
        WmqfZ2k7bgRk/2+SOoeNlL8=
X-Google-Smtp-Source: ABdhPJwlttuTqCVLTqVHp3w14w1u2iU3UwK9d2/tPK3GNbRUkWH2ImiK2QVPrMrDNAQZjpMetldFIw==
X-Received: by 2002:a17:906:a458:: with SMTP id cb24mr12743050ejb.5.1591176014067;
        Wed, 03 Jun 2020 02:20:14 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:d00c:464c:92b:aecc:3637:dc7c])
        by smtp.gmail.com with ESMTPSA id 64sm865636eda.85.2020.06.03.02.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 02:20:13 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        beanhuo@outlook.com
Subject: [RESENT PATCH v5 0/5] scsi: ufs: cleanup ufs initialization
Date:   Wed,  3 Jun 2020 11:19:54 +0200
Message-Id: <20200603091959.27618-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Resent this patchset since linux-scsi@vger.kernel.org and
linux-kernel@vger.kernel.org rejected my email


Cleanup UFS descriptor length initialization, and delete some unnecessary code.

Changelog:
v4 - v5:
    1. Rebased patch
    2. In the patch 3/5, change "param_size > buff_len" to
       "(param_offset + param_size) > buff_len"

v3 - v4:
    1. add desc_id >= QUERY_DESC_IDN_MAX check in patch 4/5 (Avri Altman)
    2. update buff_len to hold the true descriptor size in 4/5 (Avri Altman)
    3. add new patch 3/5

v2 - v3:
    1. Fix typo in the commit message (Avri Altman & Bart van Assche)
    2. Delete ufshcd_init_desc_sizes() in patch 3/4 (Stanley Chu)
    3. Remove max_t() and buff_len in patch 1/4 (Bart van Assche)
    4. Add patch 4/4 to compatable with 3.1 UFS unit descriptor length

v1 - v2:
    1. split patch
    2. fix one compiling WARNING (Reported-by: kbuild test robot <lkp@intel.com>)

Bart van Assche (1):
  scsi: ufs: remove max_t in ufs_get_device_desc

Bean Huo (4):
  scsi: ufs: delete ufshcd_read_desc()
  scsi: ufs: fix potential access NULL pointer while memcpy
  scsi: ufs: cleanup ufs initialization path
  scsi: ufs: add compatibility with 3.1 UFS unit descriptor length

 drivers/scsi/ufs/ufs.h     |  11 +-
 drivers/scsi/ufs/ufs_bsg.c |   5 +-
 drivers/scsi/ufs/ufshcd.c  | 207 +++++++++----------------------------
 drivers/scsi/ufs/ufshcd.h  |  16 +--
 4 files changed, 54 insertions(+), 185 deletions(-)

-- 
2.17.1

