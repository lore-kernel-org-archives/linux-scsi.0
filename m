Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6D2C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9064208CA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NiXQ5nGL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgEHIjD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHIjD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:39:03 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27B9C05BD43
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 01:39:02 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i15so859087wrx.10
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 01:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Sa7keAbjonPPlNedeu/K6UjwhQkst6LKZUXA12ievDU=;
        b=NiXQ5nGLQFFSWY2ITwDBenwO3djNQclqbiXiie8Rgv4fZJ1PpmYrVtsxj6ZlO8PGL9
         clxhjXXiBK/2Bpp/CYaPOwCrmD3TW/6ZpzQjSaPBL6cUiCAI/FjskrSFtSrwvknEoSY3
         fwTnua8bjwEGeoaKmhSQ07Kwheuj4kJzbYtYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Sa7keAbjonPPlNedeu/K6UjwhQkst6LKZUXA12ievDU=;
        b=UGUK99d+HXoVa/NIayqbo7TcIskSY9IfPzmmmwMjZqKcXDCQ08612JXE8B/HRdKz52
         yOLKvf++bRTXyH+7VTP+1abHsfhi5f/205wZxVGqGYLiKmDx9WS88n+2oEMqHyoeJWBi
         DXyzcULzV/BKuEId4NGESL+RVZnCGm7WcjC3MlXlHqTqVl/7FCLGJJColXRhA7wmynWX
         pYIU7zfHyxQSoDLi/0pTf7/U/e+oSR/LEdGdhVf98jo5u28K4Hmq5QecTZ9R4As5AMLI
         QM3QEEsyIhy6kZSLKNjkSsUiX9B6yApy48f2xERFU8nvP2mBoz5JwawVQqkPdVEyq5nh
         V14A==
X-Gm-Message-State: AGi0PuZ5JNJ7qHDMvvBh70YgV0ktah9cucbMAI1R8pf9LZgOVj1XjH5i
        3Pt/5bMH8Gk2zNN4H08Zm1t8u0rgI1MN1rtgFv63XJ3aaxkw6VoFHFTEYyeBJ0C/QGNId6dBwOT
        z0BIhy2RD36X21+DibnwCa6FbFbIrxRZiK1PhpRVJOwnCMPlngdZ7vnCI4/Kso51EkHY28D5Eqg
        gC0J7La77HOOkq
X-Google-Smtp-Source: APiQypJuJvdH9r6cR59+A1X1ibLfMDHFYpYiR7vnVajC/dmfue/WLiWvR4gAEaTKAr0CvPcJixhuxg==
X-Received: by 2002:adf:cc81:: with SMTP id p1mr1583471wrj.192.1588927141369;
        Fri, 08 May 2020 01:39:01 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a8sm1810240wrg.85.2020.05.08.01.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:39:00 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 0/5] megaraid_sas: driver updates for 07.714.04.00-rc1
Date:   Fri,  8 May 2020 14:08:33 +0530
Message-Id: <20200508083838.22778-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset contains few critical driver fixes.

Chandrakanth Patil (5):
  megaraid_sas: Limit device qd to controller qd when device qd is
    greater than controller qd
  megaraid_sas: Remove IO buffer hole detection logic
  megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro with
    __BIG_ENDIAN_BITFIELD macro
  megaraid_sas: TM command refire leads to controller firmware crash
  megaraid_sas: Update driver version to 07.714.04.00-rc1

 drivers/scsi/megaraid/megaraid_sas.h        |  8 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c   |  5 +--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 65 +++--------------------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  6 +--
 4 files changed, 15 insertions(+), 69 deletions(-)

-- 
2.9.5

