Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DD6C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9098F207AA
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgLHVKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgLHVKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:10:32 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07757C0613D6;
        Tue,  8 Dec 2020 13:09:52 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id x16so26643901ejj.7;
        Tue, 08 Dec 2020 13:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wNs/3miZJZMRVGd+tONPw5tRmrGF0sc2ymKJoQXU/q8=;
        b=NtwAvitu0Dgz05kasu9RPNf/EgA1QoLlWEzF65LW6NMQGstFb1Ho4Ix3Y7zaXwtAy3
         9zkPGbuDEXl3kOvqpACvCCPpVVaku1DpBwRKvSSPfjbrqe6TmukWn/ec95WLQcgdNqTC
         qIy1eugiLQU6LJ5BW6qiEPsOACSrIUIb2Po0ZtQo4XBNABypvgL5nUWjARUUzKqca57K
         iOjRzwXSrSEvB/+l3xiyJwHm/rdwqFuV0YTHMTk6Z33QSXGnJRwIBQllQxXfw68AEfwr
         fTilrDKF9bmaVauS/1UffKj+cy2Xk9q16OizX5xj+28Ad68ljoV0NEA6skRH8SxXrMoZ
         T2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wNs/3miZJZMRVGd+tONPw5tRmrGF0sc2ymKJoQXU/q8=;
        b=OlbG0WjUHa1vqdgcsfLqZ2VTppdn2eYjeiC+oUmcPviLotJbilgqepCAOTEGCL+s37
         RODDFQNYoEOrmgQ9zSIfGcf+s/O57IKuWdsDdl0WJ/iw+ti5saLSrCbip/rg9uJw+aeu
         x4FXHieRGwDIgVYNfS4NjdVYCbjw3RB6Cmu9zMk41TosBBv2MpA0lfEXM5/0Yf3V6a7q
         nfmHbc/AMBeJcqPH3U2e0Wd/Vfp4GZf13bAShy2hzeWSMcBChCPpWBdbeFqenbOU2UDh
         SAthnVlgLJ9JbrJ6vEsvfMSUJei53DkkOWt4Yts2IQ8G4Y/NqnSyF/cJyLTnH+4RQpfa
         zRBw==
X-Gm-Message-State: AOAM531T/Z4yA38yx1eUUad8m6nXx6fVCv6xnFfhSyXjFXKFDiuomhvQ
        zyFL5y6QQMaEvrlaXo1HpY8=
X-Google-Smtp-Source: ABdhPJz246F7teP6RzCfKElrHJAlYH7IEETY5MjpJ+xEOtfKHwtDj99KXOS9nDGpl+pqFU9r4XDB+Q==
X-Received: by 2002:a17:906:3081:: with SMTP id 1mr25895007ejv.162.1607461790800;
        Tue, 08 Dec 2020 13:09:50 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id n22sm17908edr.11.2020.12.08.13.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 13:09:50 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] Three changes for UFS WriteBooster
Date:   Tue,  8 Dec 2020 22:09:38 +0100
Message-Id: <20201208210941.2177-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:
v2--v3:
  1. Change multi-line comments style in patch 1/3 (Can Guo)

v1--v2:
  1. Take is_hibern8_wb_flush checkup out from function
     ufshcd_wb_need_flush() in patch 2/3
  2. Add UFSHCD_CAP_CLK_SCALING checkup in patch 1/3. that means
     only for the platform, which doesn't support UFSHCD_CAP_CLK_SCALING,
     can control WB through "wb_on".

Bean Huo (3):
  scsi: ufs: Add "wb_on" sysfs node to control WB on/off
  scsi: ufs: Keep device active mode only
    fWriteBoosterBufferFlushDuringHibernate == 1
  scsi: ufs: Changes comment in the function ufshcd_wb_probe()

 drivers/scsi/ufs/ufs-sysfs.c | 41 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       |  2 ++
 drivers/scsi/ufs/ufshcd.c    | 30 ++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 4 files changed, 64 insertions(+), 11 deletions(-)

-- 
2.17.1

