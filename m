Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602FCC61DA4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 23:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjCMXBb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 19:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCMXBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 19:01:23 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78621211DB;
        Mon, 13 Mar 2023 16:00:34 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i9so3745934wrp.3;
        Mon, 13 Mar 2023 16:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678748408;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lQ8HCvy+knNv4fgP277vjD/YWRmgOe4jFTBMj1XoMvQ=;
        b=NaFGprQgPLF5N3bvetu4WdLJuW1Pb02I28YZafmKEfgTsFlfNzBGm7iqsbBr7smFoE
         3xVbSltMaYkOl1ELg/3Q3lg8su8siBq+aun6McYn6tIw9o0oWUOxg8WO/N7tqNXIK3Vy
         WT1FkEgmQ2w1xPaHhpBStO8GOLBiMNyI11eHvnImXyvMqU3t8GIojA4BusoMzCS3/FDu
         fuIVGMvkzNmhYXFdvUxfPjdzCg7k3BEsuKDWQkue5D0uSCgvJcBG0PibP3hFhX7NgItf
         stMggtvA9OJz6nTqQDoHtS7HYU24fnSWN26zLzCYz9DdxdOiGPMZ9LQlfecWF+VzhSC8
         EuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678748408;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lQ8HCvy+knNv4fgP277vjD/YWRmgOe4jFTBMj1XoMvQ=;
        b=ZBsahoPwC2eP+v2xXL6pNLmGw3JquvukcYDsoL8T3pz4sRB6X9GBxVuLKuqVLtQUMq
         yUvdsk/vew0hO+5PILJc9Eh3+B9ish5CuCVgjzk4gKuLsRRlXV+M5zO+h70S+KQVmFdj
         F8wXUbn5K9nyn7Cez+caXQV2zRGzdWY6/IyI47LhpKI/zlSK0+yYGDchwk5k0pRjgLMB
         ne2LXEYhwUUUbk1a1OLxZIcDaIOCZIBG7WOiRyUrQX91nbXnsdPoBeTz/kfm7STANJzq
         kTfWb7v69cdF1k9JhkdKBkF/AEHw4htfKC6XeJzMGF69eEjoSbEZ7a2l1io9Tt1UAnRg
         FQwg==
X-Gm-Message-State: AO0yUKU58bkIzL24oWo3TdpoY7gzGvdEtDFn8jb6wuJHooqF6tJFXePl
        393RVOCIayW04NHARHvgzA==
X-Google-Smtp-Source: AK7set/uhvWPQ0Ie9gQ1N3wv4IkubfAyRs1bC9cnXC/JpgVKHE6EO6sgTZpjN7pB+iKjNG7hZbsabQ==
X-Received: by 2002:adf:e34c:0:b0:2c7:17a5:8687 with SMTP id n12-20020adfe34c000000b002c717a58687mr25075279wrj.0.1678748407393;
        Mon, 13 Mar 2023 16:00:07 -0700 (PDT)
Received: from playfield-dev-2 ([2a00:23c8:881a:8601:beed:984d:cecc:ef14])
        by smtp.gmail.com with ESMTPSA id t18-20020a1c7712000000b003ed2987690dsm961375wmi.26.2023.03.13.16.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 16:00:07 -0700 (PDT)
Date:   Mon, 13 Mar 2023 23:00:03 +0000
From:   Jules Irenge <jbi.octave@gmail.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux@highpoint-tech.com, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: hptiop:Convert snprintf() to sysfs_emit()
Message-ID: <ZA+q87K8vP72y69l@playfield-dev-2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Coccinnelle reports a warning
Warning: Use scnprintf or sprintf

Following the advice on kernel documentation
https://www.kernel.org/doc/html/latest/filesystems/sysfs.html

For show(device *...) functions we should only use sysfs_emit() or sysfs_emit_at()
especially when formatting the value to be returned to user space.

Convert snprintf() to sysfs_emit()

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/scsi/hptiop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 7e8903718245..3ae4a0a8be57 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1111,7 +1111,7 @@ static int hptiop_adjust_disk_queue_depth(struct scsi_device *sdev,
 static ssize_t hptiop_show_version(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", driver_ver);
+	return sysfs_emit(buf, "%s\n", driver_ver);
 }
 
 static ssize_t hptiop_show_fw_version(struct device *dev,
@@ -1120,7 +1120,7 @@ static ssize_t hptiop_show_fw_version(struct device *dev,
 	struct Scsi_Host *host = class_to_shost(dev);
 	struct hptiop_hba *hba = (struct hptiop_hba *)host->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "%d.%d.%d.%d\n",
+	return sysfs_emit(buf, "%d.%d.%d.%d\n",
 				hba->firmware_version >> 24,
 				(hba->firmware_version >> 16) & 0xff,
 				(hba->firmware_version >> 8) & 0xff,
-- 
2.39.2

