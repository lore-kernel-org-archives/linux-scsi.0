Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A91FC33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CB202467C
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:23:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="A1DnCkoP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgANLXS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:23:18 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:44616 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgANLXR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:23:17 -0500
Received: by mail-wr1-f42.google.com with SMTP id q10so11770254wrm.11
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DA8phdQw+aUTdgyo5OReorPC3i37Z5tgP6xQbQ3gT60=;
        b=A1DnCkoPcQ5cU+dlxvYxgrI/KzqzEprhBIt7JlSmJ3FA0zM4/9cT18mVRprsXg0laY
         AIwc+IP4AtJivTK8v6uztRSYq9PKaTGR4EnsXVkFw8Xqh2R5P2GAhQSBFLrvwsUFp0tf
         cWcP178VrYaMALEOEU3D1kdG9rOUhWj9PyKX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DA8phdQw+aUTdgyo5OReorPC3i37Z5tgP6xQbQ3gT60=;
        b=Kn5jtj7SHhYMIY9iqAtPNKR0Wsf9TwozYAVTd+iXsoj8q1Vjktrvltwv2KgtaGv7eu
         hIJ9plGb2vdqKZ2BVxym8p62XSmShYtVNYuiM3aPvUR601D5G4ftSz6lJWHKb6dmoJ6a
         dggoUAGtc064pjHD9Yp3pqJqz9T2SqzLlh57WvbT5iekPHxPTpouWMZRXNTUvD5DOEqB
         tPjgCcNVj7Bi2ZS6pt9tSJgAixcLExCw0v1TPq1eAhs0rWt1QoRZI0bdsJjlNfByuHcP
         7Krwl8R+9GFj0p+R5LxKlmmlJi+Z9SJ8sHyq/1ztEQvaXIorPujk5c21SIhhLT1+3C0Z
         yMrg==
X-Gm-Message-State: APjAAAUF1S0nhTrSW0T7Jydqm4uXxGVRPeXADbqcurhy1qtt0SK+J+OK
        3b8Fsl8l6bP0xjLg143p+DbvDivf8VgqPRvBaiETfmQUYXfqcgaOaDEOWGwsyXWGOxFJz19hk2s
        Nv3kF87qA2QJW2cmHf/IlZbqCnb+9E6eOAbXe5M1eo1wVOvX0LlcAF7wh2C3X40C8sZZDqhjR+f
        P7ySETYg==
X-Google-Smtp-Source: APXvYqwvHREiYW/Uw6S4s56A+DBRZepyG949I3w/bTSiPC35TTSMx3AFMXNKj2VddjK9rxelQHxOfA==
X-Received: by 2002:adf:f54d:: with SMTP id j13mr24852499wrp.19.1579000995189;
        Tue, 14 Jan 2020 03:23:15 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.23.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:23:14 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 11/11] megaraid_sas: Update driver version to 07.713.01.00-rc1
Date:   Tue, 14 Jan 2020 16:51:22 +0530
Message-Id: <1579000882-20246-12-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 25afa81..83d8c4c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -21,8 +21,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.710.50.00-rc1"
-#define MEGASAS_RELDATE				"June 28, 2019"
+#define MEGASAS_VERSION				"07.713.01.00-rc1"
+#define MEGASAS_RELDATE				"Dec 27, 2019"
 
 #define MEGASAS_MSIX_NAME_LEN			32
 
-- 
1.8.3.1

