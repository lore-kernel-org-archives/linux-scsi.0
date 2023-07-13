Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4A3EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 07:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbjGMHEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 03:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjGMHEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 03:04:50 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E73E69
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 00:04:49 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R1lwb1stvzBKy8c
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 15:04:47 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689231887; x=1691823888; bh=hOv6olFChRQtE64fY6wHJgjor0+
        nEFlIexqOHv6IHq0=; b=POJi/Bs/j4j78irF1yptP0eaf3Yr1RmAcOnF9ZTcwr2
        CpD8QMugKELPSoaFAHYn7QtIjsBUq81+Uk6aEZojZ4f06VmUsIFXRYfr18EwZnIR
        ybhp5VxInvKqcIFu+ELpHJSPEWML71RqFpOTszqAlI0SJ26X/WIOyRd8m6XOXQtY
        YE+VryewE8zDCl56pO/D0KeyX9EjJKBK5HP9T7gfVdJW7lz2wF1faY1TfSEwRqLN
        HY0SiFA48iHofy5Cm2CXQaMhM/xNOOOaWMcuII1A3mefSliuFrJiWl2W4AatFBxg
        aVMrjoCHmkaoNjlVbnzDd1uPT4jPAAIBbKITUm60wpQ==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id eoTmmH7OH2pZ for <linux-scsi@vger.kernel.org>;
        Thu, 13 Jul 2023 15:04:47 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R1lwZ6zCvzBJDhy;
        Thu, 13 Jul 2023 15:04:46 +0800 (CST)
MIME-Version: 1.0
Date:   Thu, 13 Jul 2023 15:04:46 +0800
From:   hanyu001@208suo.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Fwd: [PATCH] scsi: ibmvscsi_tgt: Convert snprintf() to sysfs_emit()
In-Reply-To: <tencent_9B65D1CAD7CE9FE3086C542B55428F8B110A@qq.com>
References: <tencent_9B65D1CAD7CE9FE3086C542B55428F8B110A@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <0969a39dca88032a93ce9c619e707d7d@208suo.com>
X-Sender: hanyu001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Coccinnelle reports a warning
Warning: Use scnprintf or sprintf

WARNING: use scnprintf or sprintf
WARNING: use scnprintf or sprintf
WARNING: use scnprintf or sprintf
Signed-off-by: ztt <1549089851@qq.com>
---
  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c 
b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 385f812b8793..f9dad598380d 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3616,13 +3616,13 @@ static void ibmvscsis_remove(struct vio_dev 
*vdev)
  static ssize_t system_id_show(struct device *dev,
                    struct device_attribute *attr, char *buf)
  {
-    return snprintf(buf, PAGE_SIZE, "%s\n", system_id);
+    return scnprintf(buf, PAGE_SIZE, "%s\n", system_id);
  }

  static ssize_t partition_number_show(struct device *dev,
                       struct device_attribute *attr, char *buf)
  {
-    return snprintf(buf, PAGE_SIZE, "%x\n", partition_number);
+    return scnprintf(buf, PAGE_SIZE, "%x\n", partition_number);
  }

  static ssize_t unit_address_show(struct device *dev,
@@ -3630,7 +3630,7 @@ static ssize_t unit_address_show(struct device 
*dev,
  {
      struct scsi_info *vscsi = container_of(dev, struct scsi_info, dev);

-    return snprintf(buf, PAGE_SIZE, "%x\n", 
vscsi->dma_dev->unit_address);
+    return scnprintf(buf, PAGE_SIZE, "%x\n", 
vscsi->dma_dev->unit_address);
  }

  static int ibmvscsis_get_system_info(void)
