Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64A5C43333
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A77782070A
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPPpAagJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgCUAmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:42:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38146 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgCUAmK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2020 20:42:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id s1so9583847wrv.5;
        Fri, 20 Mar 2020 17:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BYu1AxfdPUTqAQZFe1sqtfUo8jvdQdN79PgYT3yueg8=;
        b=CPPpAagJz4RFvFmupDJbXcBMhoaLg35p7vVB6OyOzCMZ4i+XHvObnMIkG1+GEaQtUs
         Qxhedai4lchDX7aHyVtmhrn2d5tnRMEaB/7GnqQe/2bX92EqkhjqraT8gKmdZrno+y+j
         ZdZf9y4HDDiwVfgdhDy1w81arm6RVeOjVXWZE5kJYkrEQDJ65//3pPNZ6QF2/w+fbeEa
         y1K3VcmIE4Hv7AMDRZLRbdAQm4Z89eCu4vLGnwzRHej+xj1inJtmZZX3npsI0V77Cn5d
         jSQ8Vt1FvRX//w20w07ehHtBduR+a8UxqvVc+mzWk6CxHavn4tu3Xqfx1cnf+mjxfeEc
         qndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BYu1AxfdPUTqAQZFe1sqtfUo8jvdQdN79PgYT3yueg8=;
        b=bTDloQf0uMEaRa4DO63bbRK39Y1tplzHKgkB6hRiN9WrBcsv6v29T5KD05YBd8o9le
         VC0UuN3jJPjRetfK8JXpoijgtvhSPB6Ztzad3V/nkGaZoshAeG+dANxzNC9SBicXGXWa
         Rp4lsSgG6qxYg4zu36vKVWI2D7qB/Qjtpht07hfRAFNySaGH/40UuX4xrva9frRt5k/v
         lE/d8zPpCWWad335AvVt6U+AN5pgyvOa8F7LEQ7cF7AQj10MDImflaLpPa9Qw1nbu8yC
         lnl/Xl91iuV35LCtkilTvKSuSbZET7eat/86WyBl2dPBzNHFCqlZxwbFDGoE8fJBxNM5
         6vZg==
X-Gm-Message-State: ANhLgQ2aIu2AmmIfOQE1AVGKyW6/w+JxzXBQQRTPblSMn+7apdeRQSwp
        TTu7o1U6s+STQrIoQ7OXoms=
X-Google-Smtp-Source: ADFU+vsa24cXkwKWAZlSST+P+ep6fZlFncbOF+1C0E8DWeyg0juZJ5j11JS2xZDlSLHjY15HvHROYQ==
X-Received: by 2002:adf:ce8e:: with SMTP id r14mr14441120wrn.415.1584751327365;
        Fri, 20 Mar 2020 17:42:07 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id j6sm8194982wrb.4.2020.03.20.17.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 17:42:06 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ymhungry.lee@samsung.com, j-young.choi@samsung.com
Subject: [PATCH v1 0/5] scsi: ufs: add UFS Host Performance Booster(HPB) driver
Date:   Sat, 21 Mar 2020 01:41:51 +0100
Message-Id: <20200321004156.23364-1-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

I disclose my development/changes on UFS HPB (UFS Host Performance Booster) to the
community, as this would enable more UFS developers to test and start an iterative
review and update process.                                                         
                                                                                   
The HPB is defined in Jedec Standard Universal Flash (UFS) Host Performance        
Booster(HPB) Extension Version 1.0, which is designed to improve a read performance
by utilizing the host side memory. Based on our testing, the HPB can increase the
random read performance by up to about 46% in random read.                         
                                                                                   
The original HPB driver is from [1]. Based on it, I did some                       
optimizations, simplications, fixed several reliability issues, implemented HPB 
host control mode and make it much more readable. There are still some FIXME need
to do, but this doesn't stop disclosure of patches to community to let you review.
                                                                                   
To avoid touching the traditional SCSI core, the HPB driver in this version series
HPB patch chooses to develop under SCSI, and sits the same layer with UFSHCD. At the
same time, in order to minimize changes on UFSHCD driver, the HPB driver inserts
HPB READ BUFFER and HPB WRITE BUFFER requests into the scsi_device->request_queueu
to execute, rather than that directly go through raw UPIU request path.            
                                                                                   
                                                                                   
[1] https://github.com/OpenMPDK/HPBDriver 

Bean Huo (5):
  scsi; ufs: add device descriptor for Host Performance Booster
  scsi: ufs: make ufshcd_read_unit_desc_param() non-static func
  scsi: ufs: add ufs_features parameter in structure ufs_dev_info
  scsi: ufs: add unit and geometry parameters for HPB
  scsi: ufs: UFS Host Performance Booster(HPB) driver

 drivers/scsi/ufs/Kconfig  |   34 +
 drivers/scsi/ufs/Makefile |    1 +
 drivers/scsi/ufs/ufs.h    |   19 +
 drivers/scsi/ufs/ufshcd.c |   66 +-
 drivers/scsi/ufs/ufshcd.h |   14 +-
 drivers/scsi/ufs/ufshpb.c | 3322 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  421 +++++
 7 files changed, 3870 insertions(+), 7 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.17.1

