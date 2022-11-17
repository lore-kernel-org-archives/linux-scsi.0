Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6E0C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiKQSge (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiKQSgd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:36:33 -0500
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2F7F53
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:36:32 -0800 (PST)
Received: by mail-pf1-f177.google.com with SMTP id 140so2605093pfz.6
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mBeulsmFbF30F3//qWITucHyPK9On12IH79zifNr63k=;
        b=L6f6xIr+FgnLZzXWL7t2GfA+NLryF9TLruikKU3L9HGOra65Ycb+gFZ/AQ5iJiYyuh
         zfZXnCA5hpi8Y3xfSyDvr1VSNcz/ZFJPGzSUia3ljPFpLQfDVXHH2tniMUEH+nsfaLNW
         bc/X11BFFlUm2RazwbZZ/yxqJMt7KRYfDefzHMt6ZbzNacMdA1GO1uAD/CHjtbIIDBz8
         x+wWT4ZmqVPymaBO9b3TlugB7bexieepK9t1DJwc9AWoSlrdHryMlLE7oF3aq5lXkMpg
         LQvsJ61DwzclU6dZu4Ty0THn0DFv12JQMObDhxL/+YWWbdVYrUwcRXdI43PkFwUZabuh
         Auuw==
X-Gm-Message-State: ANoB5pnXGx5jyxPb396rjKDXW9FOYy3Bo1k5V14KYebUeZmxRtexuyHQ
        SJ/8F8FaXhBtQOJMhf/MaPc=
X-Google-Smtp-Source: AA0mqf5IC0d5drpIVQ6sQVGIpo7ms1WfAZKOFui3gO3JKayffUBM26urfRSNrX9hEXE8GywoSGqQiw==
X-Received: by 2002:a63:210d:0:b0:43c:1cb8:73ba with SMTP id h13-20020a63210d000000b0043c1cb873bamr3198743pgh.11.1668710192416;
        Thu, 17 Nov 2022 10:36:32 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7b21:f8f0:283b:9d21])
        by smtp.gmail.com with ESMTPSA id z11-20020aa79e4b000000b0056c0d129edfsm1479073pfq.121.2022.11.17.10.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:36:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Rework how the ALUA driver calls scsi_device_put()
Date:   Thu, 17 Nov 2022 10:36:24 -0800
Message-Id: <20221117183626.2656196-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series reworks how the SCSI ALUA device handler calls
scsi_device_put(). Please consider this patch series for the next merge
window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: alua: Revert "Move a scsi_device_put() call out of
    alua_check_vpd()"
  scsi: alua: Call scsi_device_put() from non-atomic context

 drivers/scsi/device_handler/scsi_dh_alua.c | 46 ++++++++++++----------
 1 file changed, 25 insertions(+), 21 deletions(-)

