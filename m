Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC38C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F3E61038
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbhHMCJQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbhHMCJO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 22:09:14 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F984C061756
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:48 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a5so9896213plh.5
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WGvGE1G3/hqHhbnbZMmFRObm/5J3xDxaGBPDLqiv6DY=;
        b=CxnC6qW+M6diZ/re6wli/3kMtoloPnJNSHsoD8SEscadOOYtHv58L+fbsU59Na8tuP
         oMmXlbzwkTkVzKlHe8gywr/4g+L7KFBhpvXJmEsusgnRhmTWxiLZvZrkbmswKZoawUQT
         YRf1py8HbFreEyfZQqV7lknjlW3Bfnn21mmX6DGc7JrMArEvpl0A4Fl2mdYUlxaT09KV
         N7mG3hKFLDmsCSdKporqm9neTHzr1oIFknCKOjaDWhBrhQJnpOgR18HiARywcFjZjwPe
         IL6BDT7uBKxpnY3gUhpYZJvZqzlyirxXVJmngG0PLljIIjpw6myPb0iRJn8/QosCQ7a0
         /WPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WGvGE1G3/hqHhbnbZMmFRObm/5J3xDxaGBPDLqiv6DY=;
        b=N7kTN54xfWUVTtLxEtWKv1EEu6uvUljl73LJ4RxrY/xDTbtkgYkAOEijF43STFo9SD
         FThCZDo6ZbbLG0/kwzeP9EoVupFQ9rPqne3S/lMjwuaxU2PqUwnymGycgcLb/V4XaSjD
         pYSuwqVE6QwHMPZoj7O+XTrBX0xAKANj2bDwgamDYNIoHgDmC1fSqLM1lO5OIfH5Wxsb
         g1yCniMmExQ5utNY0DnXKHwe4JYJuJ41ssjxO0dNk73WPRa8FsyXqWnwWhIOJbLCWlH+
         7r3OaLgVaCYaucQRxv22vncUg6FWG3lhlGD10y6AI/lh5fmwOk7qGtoHEOGT8LnHUSiz
         HFfA==
X-Gm-Message-State: AOAM532WE5Cd1Tq54uJUq5GwO6Bqb66SaIT0uTv8kVXvCMZOH0RlfB9O
        tDzFKaeBaGLHJwNzp0tfuFWn0F9TC0I=
X-Google-Smtp-Source: ABdhPJwJiRHXqDNsfmPngWppJEZQqYAgjnbZWmiqgB5Nux1ZYEYBKN36elSJwVr0OBdffDe65D/Qgw==
X-Received: by 2002:a17:90b:3903:: with SMTP id ob3mr110449pjb.44.1628820527600;
        Thu, 12 Aug 2021 19:08:47 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ca7sm102619pjb.11.2021.08.12.19.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 19:08:47 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/16] lpfc: Update lpfc to revision 14.0.0.1
Date:   Thu, 12 Aug 2021 19:07:56 -0700
Message-Id: <20210813020812.99014-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.0.0.1

This patch set adds support the Congestion Management Framework (CMF)
which a component of Emulex San Manager (ESM). ESM is an inband
monitoring and management solution.  CMF performs congestion monitoring
and adaptive managment with roles split between the adapter and the
driver.

The CMF framework consists of tables and buffers exchanged between
the adapter and the driver. The tables indicate whether congestion is
to be managed, values for management, and congestion statistics. When
fully managed, periodic synchronization occurs between the driver
and the adapter.

The patches were cut against Martin's 5.15/scsi-queue tree

James Smart (16):
  fc: Add EDC ELS definition
  lpfc: Add SET_HOST_DATA mbox cmd to pass date/time info to firmware
  lpfc: Add MIB feature enablement support
  lpfc: Expand FPIN and RDF receive logging
  lpfc: Add EDC ELS support
  lpfc: Add cm statistics buffer support
  lpfc: Add support for cm enablement buffer
  lpfc: add cmfsync WQE support
  lpfc: Add support for the CM framework
  lpfc: Add rx monitoring statistics
  lpfc: Add support for maintaining the cm statistics buffer
  lpfc: Add debugfs support for cm framework buffers
  lpfc: Add cmf_info sysfs entry
  lpfc: Add bsg support for retrieving adapter cmf data
  lpfc: Update lpfc version to 14.0.0.1
  lpfc: Copyright updates for 14.0.0.1 patches

 drivers/scsi/lpfc/lpfc.h         |  252 ++++++
 drivers/scsi/lpfc/lpfc_attr.c    |  226 ++++-
 drivers/scsi/lpfc/lpfc_bsg.c     |   89 ++
 drivers/scsi/lpfc/lpfc_bsg.h     |   10 +-
 drivers/scsi/lpfc/lpfc_crtn.h    |   28 +
 drivers/scsi/lpfc/lpfc_ct.c      |   17 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |  223 +++++
 drivers/scsi/lpfc/lpfc_debugfs.h |   11 +-
 drivers/scsi/lpfc/lpfc_els.c     | 1065 ++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c |   23 +-
 drivers/scsi/lpfc/lpfc_hw.h      |    2 +
 drivers/scsi/lpfc/lpfc_hw4.h     |  249 +++++-
 drivers/scsi/lpfc/lpfc_init.c    | 1402 +++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_logmsg.h  |    5 +-
 drivers/scsi/lpfc/lpfc_mem.c     |   15 +-
 drivers/scsi/lpfc/lpfc_nvme.c    |   44 +-
 drivers/scsi/lpfc/lpfc_nvme.h    |    3 -
 drivers/scsi/lpfc/lpfc_scsi.c    |  187 +++-
 drivers/scsi/lpfc/lpfc_sli.c     |  770 +++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.h     |    2 +
 drivers/scsi/lpfc/lpfc_sli4.h    |    1 +
 drivers/scsi/lpfc/lpfc_version.h |    2 +-
 include/uapi/scsi/fc/fc_els.h    |  106 +++
 23 files changed, 4618 insertions(+), 114 deletions(-)

-- 
2.26.2

