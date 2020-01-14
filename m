Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115F0C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6A1D2467A
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:21:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="T5m4bG3T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgANLVv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:21:51 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:54849 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANLVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:21:51 -0500
Received: by mail-wm1-f45.google.com with SMTP id b19so13282947wmj.4
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zlyx5dbRhXJzxKr5Jgln+DlSgmGkzibsMSLWOj4eBbM=;
        b=T5m4bG3T8kQN+cIK+wKJiFCJOmjSz7eMf0fl+Vaxi3p/85oPVBuCQwWc/bxI3mT0zv
         fehOc2kv+eDiz30Ohepy9Kmqv6nsgnaRgjWYNfcBE6uLytdVIcSjlAIURfPKvV2InNK2
         wSkVExA1EL5IXfsECPC34TRFc53qn5E7eIoOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zlyx5dbRhXJzxKr5Jgln+DlSgmGkzibsMSLWOj4eBbM=;
        b=guyhVSYj4KQqPpHt4HAkS5ND8/h+MWkMGYd5IH8JiKUdbJ34wDZZvwLNle7yj3HPKA
         0sIpNnkFBFLdtbUnTsdIqbj+b5JMAWxJHmAowbaNWilE02a2hryICLnA9kNfC/O6COw7
         yIHsj4aZC7bhqOYqjPX9fUocXyUflKf2KUCYynFnt5RTRwAGsbH3DJS9sSiMG5XW38BA
         TVf1raLSROHj5FdwTlY1f2U1O1JZAja9ubfDnAfR3wqTkaEUcMVw4fDl5FgTzjie4I2t
         lMVjS3LjpCtsKdtcR76s+TXfQtL+6Pf3YBNj9Gy7V+X/Q3jxNUACZNcjS3CkcU6HhT5r
         FH6w==
X-Gm-Message-State: APjAAAWrwxPhcncM+F8rLWOebFXQ6Imzoaofb7q64wYdJKitkt0qo5Ih
        eiH5XiKz9kRixQNejsjl0TKJs7XgQiG5Eg30Sxf8N+cjbmcoVtrIkOrXKGwJ4/JuMFkobKqWVyk
        hQ8T9YRkfRW4Y49I1qmYSWLnwO1yHTuhvoJQb9lWpIToCtfxd6XIFCeZEHaELKRZw1FZ6qCo/G0
        RNDpSsbpI7
X-Google-Smtp-Source: APXvYqwgUupqNFhFmXv0bqEVrR7wmDCNVGipC9sncZegRIX17RSdyoD7vbJanEK7eF2UWLClCk5A+Q==
X-Received: by 2002:a05:600c:220e:: with SMTP id z14mr26406419wml.114.1579000908965;
        Tue, 14 Jan 2020 03:21:48 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.21.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:21:48 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 00/11] megaraid_sas: driver updates to 07.713.01.00-rc1
Date:   Tue, 14 Jan 2020 16:51:11 +0530
Message-Id: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset contains few enhancements and fixes in megaraid_sas driver.

v2:
    - Fixed couple of typos and indentation issues as pointed out by Martin K.
    - Added proper commit descriptions where ever necessary.

Anand Lodnoor (11):
  megaraid_sas: Reset adapter if FW is not in READY state after device
    resume
  megaraid_sas: Set no_write_same only for Virtual Disk
  megaraid_sas: Update optimal queue depth for SAS and NVMe devices
  megaraid_sas: Do not kill host bus adapter, if adapter is already dead
  megaraid_sas: Do not kill HBA if JBOD Seqence map or RAID map is
    disabled
  megaraid_sas: Do not set HBA Operational if FW is not in operational
    state
  megaraid_sas: Re-Define enum DCMD_RETURN_STATUS
  megaraid_sas: Do not initiate OCR if controller is not in ready state
  megaraid_sas: Limit the number of retries for the IOCTLs causing
    firmware fault
  megaraid_sas: Use Block layer API to check SCSI device in-flight IO
    requests
  megaraid_sas: Update driver version to 07.713.01.00-rc1

 drivers/scsi/megaraid/megaraid_sas.h        |  17 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c   |  95 ++++++++++++++------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 134 +++++++++++++++++++++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  18 +++-
 4 files changed, 197 insertions(+), 67 deletions(-)

-- 
1.8.3.1

