Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4D6EB64DA
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 08:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbjGNIWs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbjGNIWr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 04:22:47 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5494B9B
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 01:22:46 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R2Pbz4cYRzBR9sk
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 16:22:39 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689322959; x=1691914960; bh=PT7uYoLjvXsxxh5IkZDmSyFixPx
        JBwpKA1PQo08X5yA=; b=rhN0sPClmlONnMfkjRUl7p7JvZM71R20fWVmZsnrLbY
        D623AKORKuXRzDi91Qx/Lf2WyG1AsSLatPzRxMAeWObSbmFL42M7XrO+qidY03HF
        Zxeg1QIKwb94cSwybITkn2qs/ZES5XS0A3aC4JyVxjh6EFk3lOZUKZHifwCq16bn
        gQ3w6R/gPAfFCoxxjC3atldbIVlreZgwpSsDU/mF1jq8JKm18YZbgBmoJqqO8jOv
        i75PJ2YWGT1JXQjduR252F/IZBNBk6yO0B3CP4c5v0DDpS8kjQi3GzsYbLKehr7R
        0ZR4fzYdlXdcEmP+1t0x7wFWLg4ydyKTrUrOTgxJTrw==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4aA5YaeQAjdg for <linux-scsi@vger.kernel.org>;
        Fri, 14 Jul 2023 16:22:39 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R2Pbz2NsSzBR9sc;
        Fri, 14 Jul 2023 16:22:39 +0800 (CST)
MIME-Version: 1.0
Date:   Fri, 14 Jul 2023 16:22:39 +0800
From:   hanyu001@208suo.com
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Fwd: [PATCH] scsi: arcmsr: (ina2xx) Convert sysfs sprintf/snprintf
 family to sysfs_emit
In-Reply-To: <tencent_3FF1E7BD0216D5C39552E3E9442AB41FB508@qq.com>
References: <tencent_3FF1E7BD0216D5C39552E3E9442AB41FB508@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <feb3f5bb92896daf589f7d3a4c839dec@208suo.com>
X-Sender: hanyu001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

drivers/hwmon/ina2xx.c:313:8-16: WARNING: use scnprintf or sprintf
drivers/hwmon/ina2xx.c:453:8-16: WARNING: use scnprintf or sprintf
drivers/hwmon/ina2xx.c:484:8-16: WARNING: use scnprintf or sprintf
drivers/hwmon/ina2xx.c:540:8-16: WARNING: use scnprintf or sprintf

./drivers/scsi/arcmsr/arcmsr_attr.c:297:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/arcmsr/arcmsr_attr.c:273:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/arcmsr/arcmsr_attr.c:285:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/arcmsr/arcmsr_attr.c:261:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/arcmsr/arcmsr_attr.c:374:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/arcmsr/arcmsr_attr.c:309:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/arcmsr/arcmsr_attr.c:348:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/arcmsr/arcmsr_attr.c:335:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/arcmsr/arcmsr_attr.c:361:8-16: WARNING: use scnprintf or 
sprintf
./drivers/scsi/arcmsr/arcmsr_attr.c:322:8-16: WARNING: use scnprintf or 
sprintf

Signed-off-by: ztt <1549089851@qq.com>
---
  drivers/scsi/arcmsr/arcmsr_attr.c | 20 ++++++++++----------
  1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c 
b/drivers/scsi/arcmsr/arcmsr_attr.c
index baeb5e795690..94bc7c783024 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -258,7 +258,7 @@ static ssize_t
  arcmsr_attr_host_driver_version(struct device *dev,
                  struct device_attribute *attr, char *buf)
  {
-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%s\n",
              ARCMSR_DRIVER_VERSION);
  }
@@ -270,7 +270,7 @@ arcmsr_attr_host_driver_posted_cmd(struct device 
*dev,
      struct Scsi_Host *host = class_to_shost(dev);
      struct AdapterControlBlock *acb =
          (struct AdapterControlBlock *) host->hostdata;
-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%4d\n",
              atomic_read(&acb->ccboutstandingcount));
  }
@@ -282,7 +282,7 @@ arcmsr_attr_host_driver_reset(struct device *dev,
      struct Scsi_Host *host = class_to_shost(dev);
      struct AdapterControlBlock *acb =
          (struct AdapterControlBlock *) host->hostdata;
-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%4d\n",
              acb->num_resets);
  }
@@ -294,7 +294,7 @@ arcmsr_attr_host_driver_abort(struct device *dev,
      struct Scsi_Host *host = class_to_shost(dev);
      struct AdapterControlBlock *acb =
          (struct AdapterControlBlock *) host->hostdata;
-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%4d\n",
              acb->num_aborts);
  }
@@ -306,7 +306,7 @@ arcmsr_attr_host_fw_model(struct device *dev, struct 
device_attribute *attr,
      struct Scsi_Host *host = class_to_shost(dev);
      struct AdapterControlBlock *acb =
          (struct AdapterControlBlock *) host->hostdata;
-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%s\n",
              acb->firm_model);
  }
@@ -319,7 +319,7 @@ arcmsr_attr_host_fw_version(struct device *dev,
      struct AdapterControlBlock *acb =
              (struct AdapterControlBlock *) host->hostdata;

-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%s\n",
              acb->firm_version);
  }
@@ -332,7 +332,7 @@ arcmsr_attr_host_fw_request_len(struct device *dev,
      struct AdapterControlBlock *acb =
          (struct AdapterControlBlock *) host->hostdata;

-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%4d\n",
              acb->firm_request_len);
  }
@@ -345,7 +345,7 @@ arcmsr_attr_host_fw_numbers_queue(struct device 
*dev,
      struct AdapterControlBlock *acb =
          (struct AdapterControlBlock *) host->hostdata;

-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%4d\n",
              acb->firm_numbers_queue);
  }
@@ -358,7 +358,7 @@ arcmsr_attr_host_fw_sdram_size(struct device *dev,
      struct AdapterControlBlock *acb =
          (struct AdapterControlBlock *) host->hostdata;

-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%4d\n",
              acb->firm_sdram_size);
  }
@@ -371,7 +371,7 @@ arcmsr_attr_host_fw_hd_channels(struct device *dev,
      struct AdapterControlBlock *acb =
          (struct AdapterControlBlock *) host->hostdata;

-    return snprintf(buf, PAGE_SIZE,
+    return scnprintf(buf, PAGE_SIZE,
              "%4d\n",
              acb->firm_hd_channels);
  }
