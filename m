Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BADDC54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59BDD20700
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="k0Ai8YSZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgDXMf6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgDXMf5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 08:35:57 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6B9C09B045
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 05:35:56 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z1so3049474pfn.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 05:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=zBWMTRVBR12LwdUWmT+crYPA7058E9M5+oph2NaiToo=;
        b=k0Ai8YSZGBT1Y36K2pzwlj2v+2zNsoH1EwNuURr+1uPAyFqraRB7pWOmOjwaQrHN1U
         JpI6WNzz6UYz+lVfE6LjX4RlIwquwfonjn9TJnevbKRvWXDPgs5btqYxmaq6ZXOvK1uu
         wkmvjxlhn9annh/2Pq6FE6rbMX6Y9Dx+dZDAgS1adRJ7KWCVmU89YefL017P2lfDahuL
         OcCUpCW5ZlHs7c3zIn9+DUbeErpflzFJI9hcwKtM2pKCAhagZXukhCRzisGkO4wDawuI
         HEgfmxcIcqJuzMkUK6pWKIOIEic5idA1LvtX/eiNDUqhjfzsA+SZAoZqU1JX9T5zx8V1
         fcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zBWMTRVBR12LwdUWmT+crYPA7058E9M5+oph2NaiToo=;
        b=YHzdiiiAGe9qDeAN28d4UoG79p6g8caMOZnTHwdKvREUzBE5CxgIGk/BaQDbq0V6mm
         QgIseUJgocl/qNelofqL8Q98HaCviqpyY8wl2e8DXlhZg+DJsGA2MZTJz+E8W8naf4lN
         sO+lh6kJL4Q9jp+fhttOF2BuEWzd7Qcx0b7zhDX7QTwAbRCBuGzOekOSgHUtIUxF7Fie
         fsIOc9OUlRfJFAePrsXYUbMw9yE8EPDCE3jlmXCLHWQI5KUbJy4z3StEpFPVbJ070f04
         4V2eks/g6cIzUMBMdwsOdw6UioE4Y1krl/V1u85HyrMkIpVAIil5G2nAPSPL1BP/pAP8
         Q7OA==
X-Gm-Message-State: AGi0PuZ0spBjD2cObj38aY5rNW23HsDuVrKB4J65vEJOKdcTUzRSWoc/
        AmWLpQ1SmS/TN54b0TCcuR5vwg==
X-Google-Smtp-Source: APiQypIvYlJkpUXOf3UjQIkO/0K9Vet1Cl7S/3lGW/Icb14R9NbeAWMqeHWnuof/BP/x6WmdtnHNpg==
X-Received: by 2002:a63:5a5f:: with SMTP id k31mr9188117pgm.109.1587731755534;
        Fri, 24 Apr 2020 05:35:55 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id 128sm5510851pfy.5.2020.04.24.05.35.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 05:35:54 -0700 (PDT)
From:   Hou Pu <houpu@bytedance.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, Hou Pu <houpu@bytedance.com>
Subject: [PATCH v3 0/2] iscsi-target: fix login error when receiving is too fast
Date:   Fri, 24 Apr 2020 08:35:26 -0400
Message-Id: <20200424123528.17627-1-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
We encountered "iSCSI Login negotiation failed" several times.
After enable debug log in iscsi_target_nego.c of iSCSI target.
Error shows:
  "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"

Patch 1 is trying to fix this problem. Please see comment in patch 1
for details.

Changes from v3:
* Fix style problem found by checkpatch.pl.

Changes from v2:
* Improve comments in patch #1.
* Change bit possition of login_flags in patch #1.

Hou Pu (2):
  iscsi-target: fix login error when receiving is too fast
  iscsi-target: Fix inconsistent debug message in
    __iscsi_target_sk_check_close

 drivers/target/iscsi/iscsi_target_nego.c | 31 ++++++++++++++++++++++++++-----
 include/target/iscsi/iscsi_target_core.h |  9 +++++----
 2 files changed, 31 insertions(+), 9 deletions(-)

-- 
2.11.0

