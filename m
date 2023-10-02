Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B18E784AF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 09:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbjJBJyT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 05:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbjJBJyQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 05:54:16 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33707DA
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 02:54:13 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-690bfd4f3ebso12720813b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2023 02:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20230601.gappssmtp.com; s=20230601; t=1696240453; x=1696845253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:cc:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/WeJY/PqNDvxvNMtQMBDU2MORKpRU53y8JzmRVuDi1g=;
        b=QdTjfUB2rxhds4Ts1F8vJCXMBV5o51XpRNOJU/Y+MVuDQZSX+6l06gmhfuexlmUDw2
         8MsGOKd7h7BxjwQ0fcDDXR2Z1a1sukvWdRocb1eYFVistdcYlAzOMNCoJdaqizCxOKNN
         6GG5Catn3GyG0M+16UKxOkwWuBzhovwWZ3Ck2BJEgR7+4ySTKegfJc86wThu7R3NJ9Nd
         Qe437rJFWAL9sX19D0ZkyevB84DRU0e02ydBiYv8q1Prg1OvctqZbuN5GEedbIQC1b35
         sN0/Nb5v/ACg1nxa6lOpe6L7/EUWlRFZEuhcs9AF2WoBAg5qZ4zVhxaoeVJMAgf4NW0J
         8g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696240453; x=1696845253;
        h=content-transfer-encoding:mime-version:date:cc:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/WeJY/PqNDvxvNMtQMBDU2MORKpRU53y8JzmRVuDi1g=;
        b=h25Wz0weaf+DOy3N95pcYYXWZU4IpyAxtRkdt8uoByZOPZQxXRL1GUVa/qc+4mJMt0
         2W4KHVn55jX2zB5UZpYgaJN0FS4/tIySD/TiRnG2wBAZmjWT7eJJs2RyH0/u5ERL/TVN
         /JrahikRD6iBf719UOn/IXTmxGJUdAhGZGLJpN0slFmHxCP7kjQma766rQYtH7miX9ci
         56fb8+qfH6Z3h3FbFLXx8vM1T3lBjaxnD5oeEgf7CpYJJ5pz53ydjsoVmO9eo279/xTg
         BmjvxFqcdIIJhI6GbdqIE0ooKtSGxZR8xhSE95UZHq1/oFAbxX//Wwnxztzrys2RW66H
         u2YQ==
X-Gm-Message-State: AOJu0YyrZ7vTnDT/ryiiTDYa34p9+sUK9B0ARQma/xEA3kJR1xk067r2
        3hGE+JwJyZBHzNOzym4xsRIkog==
X-Google-Smtp-Source: AGHT+IEviW7j5XCFdfsYtjJIdmNTgL39+izAKE+TL+5UUgJ/nGOyRtatzU29215y+O7nGR+sclWD+A==
X-Received: by 2002:a05:6a00:24c5:b0:690:ca4e:662f with SMTP id d5-20020a056a0024c500b00690ca4e662fmr11052853pfv.5.1696240453410;
        Mon, 02 Oct 2023 02:54:13 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id r25-20020aa78459000000b006933f657db3sm8186374pfn.21.2023.10.02.02.54.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Oct 2023 02:54:12 -0700 (PDT)
Message-ID: <514898a472dfdf0502afe27d127ed5145a1fb915.camel@areca.com.tw>
Subject: [PATCH v3 3/3] scsi: arcmsr: update driver's version to
 v1.51.00.14-20230915
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     bvanassche@acm.org, kbuild test robot <lkp@intel.com>
Date:   Mon, 02 Oct 2023 17:54:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

his patch updates driver's version to v1.51.00.14-20230915

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---
 drivers/scsi/arcmsr/arcmsr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 2f80a6acb..12c4148fe 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -50,7 +50,7 @@ struct device_attribute;
 #define ARCMSR_MAX_OUTSTANDING_CMD	1024
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
 #define ARCMSR_MIN_OUTSTANDING_CMD	32
-#define ARCMSR_DRIVER_VERSION		"v1.50.00.13-20230206"
+#define ARCMSR_DRIVER_VERSION		"v1.51.00.14-20230915"
 #define ARCMSR_SCSI_INITIATOR_ID	255
 #define ARCMSR_MAX_XFER_SECTORS		512
 #define ARCMSR_MAX_XFER_SECTORS_B	4096
-- 
2.39.3


