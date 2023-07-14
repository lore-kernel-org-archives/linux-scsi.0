Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC77EB64DA
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 08:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbjGNIOD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbjGNINq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 04:13:46 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5016C4689
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 01:11:41 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R2PLD26CRzBR9sg
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 16:10:44 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689322244; x=1691914245; bh=hi2JCXpuWCGnO3LedqdVgh9QV7J
        Qv/56InerFXZUi1A=; b=ke5oI5HFDNgABUfbDVVgWGOlDL0tSk2hQxlS+KgL1ex
        vjiJVU3ZmQUgFRCmTgsC7tdzEo5DlXUW4Ynl4aQiKT0Yfyf40SnXtuRotp9UdDEK
        ub2G7TOWWAJjbe94lZfNOF9Gc2vOiEnZaMoUhxj6M8wIjIbOmKNpwUnXUspK8jNN
        23v1bbgafhHnkXI85gvPNyE9izI9GFhB9HvAq60OXgZA5uvO94zdvI0P/ijTcNYa
        xSj91mMgWXrHYWOJ6ljqCBZ9VUxJmlxasWjWWwZlrP3x0g3qAjgZJi8SUSXaTrpo
        H6MT9uLpG7pdGKq3evCqCtomDwoLOI0M8mZc/VxVRfg==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pqaLmlHBjdog for <linux-scsi@vger.kernel.org>;
        Fri, 14 Jul 2023 16:10:44 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R2PLD0RjgzBR9sc;
        Fri, 14 Jul 2023 16:10:44 +0800 (CST)
MIME-Version: 1.0
Date:   Fri, 14 Jul 2023 16:10:43 +0800
From:   hanyu001@208suo.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Fwd: [PATCH] scsi: be2iscsi: wacom: convert sysfs sprintf/snprintf
 family to sysfs_emit
In-Reply-To: <tencent_A27502E2D5B495E4E319441AB4B3B5F7E708@qq.com>
References: <tencent_A27502E2D5B495E4E319441AB4B3B5F7E708@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <a70b030b0e0bdf224d35dec9aecc7371@208suo.com>
X-Sender: hanyu001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/hid/wacom_sys.c:1828:8-16: WARNING: use scnprintf or sprintf.

./drivers/scsi/be2iscsi/be_mgmt.c:1251:9-17: WARNING: use scnprintf or 
sprintf
./drivers/scsi/be2iscsi/be_mgmt.c:1145:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/be2iscsi/be_mgmt.c:1164:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/be2iscsi/be_mgmt.c:1280:8-16: WARNING: use scnprintf or 
sprintf

Signed-off-by: ztt <1549089851@qq.com>
---
  drivers/scsi/be2iscsi/be_mgmt.c | 8 ++++----
  1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c 
b/drivers/scsi/be2iscsi/be_mgmt.c
index 4e899ec1477d..4916ce9c36a6 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1142,7 +1142,7 @@ ssize_t
  beiscsi_drvr_ver_disp(struct device *dev, struct device_attribute 
*attr,
                 char *buf)
  {
-    return snprintf(buf, PAGE_SIZE, BE_NAME "\n");
+    return scnprintf(buf, PAGE_SIZE, BE_NAME "\n");
  }

  /**
@@ -1161,7 +1161,7 @@ beiscsi_fw_ver_disp(struct device *dev, struct 
device_attribute *attr,
      struct Scsi_Host *shost = class_to_shost(dev);
      struct beiscsi_hba *phba = iscsi_host_priv(shost);

-    return snprintf(buf, PAGE_SIZE, "%s\n", phba->fw_ver_str);
+    return scnprintf(buf, PAGE_SIZE, "%s\n", phba->fw_ver_str);
  }

  /**
@@ -1248,7 +1248,7 @@ beiscsi_adap_family_disp(struct device *dev, 
struct device_attribute *attr,
      case BE_DEVICE_ID1:
      case OC_DEVICE_ID1:
      case OC_DEVICE_ID2:
-        return snprintf(buf, PAGE_SIZE,
+        return scnprintf(buf, PAGE_SIZE,
                  "Obsolete/Unsupported BE2 Adapter Family\n");
      case BE_DEVICE_ID2:
      case OC_DEVICE_ID3:
@@ -1277,7 +1277,7 @@ beiscsi_phys_port_disp(struct device *dev, struct 
device_attribute *attr,
      struct Scsi_Host *shost = class_to_shost(dev);
      struct beiscsi_hba *phba = iscsi_host_priv(shost);

-    return snprintf(buf, PAGE_SIZE, "Port Identifier : %u\n",
+    return scnprintf(buf, PAGE_SIZE, "Port Identifier : %u\n",
              phba->fw_config.phys_port);
  }
