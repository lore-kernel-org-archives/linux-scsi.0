Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92369C6FA8F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 16:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbjH2QgD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 12:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbjH2Qfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 12:35:54 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6055A6
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 09:35:51 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1bf7423ef3eso28142105ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 09:35:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693326951; x=1693931751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AdZCzX4GSeKrdOBDRPBhJSPOeLfKgYD8GAm+VOIiJiM=;
        b=fV5Dz0zEw7K3kZxvmhGHmA4iovL+r72cQ159mZ9YEFUnuKh7iy0Ix1VHY7GYq8DpId
         9jRbT+RbWrydrJZ3ZxLi90IMy74QofdHxDo73JV3RaTWnWEZ2tMEctUSNcIq/Ss70Qkm
         qTj2zPEkmivu4PZ/z/BVlRf7QxefA+JSe4EBnEqVEOGmzFxBqtmvkrBfspttg9pMKHbx
         6MczVIN3/Nl629HYxZA974cyzmNFAUMm5rO8DR+6bgoP+eCtwakBhMT6s8Wc4BIhWKrW
         I41EPwsy/sho4JF7YCGlkPsOajTwO7qqo/yadBaa90rU/ID8b3OEI90dbUBXRQ5xcODX
         Q0Aw==
X-Gm-Message-State: AOJu0YxVtsh9XdBsy4zNzG+laoO4a8TClfibwL7YxvlSG3K5rbeiIplH
        h6yvuct+aWGl6CBtdw2+/EI=
X-Google-Smtp-Source: AGHT+IFl/viMhkOU3GDdhUIqvBT8pe5sP4nCp05q3UQrP6ScfQ4Cb1+zYgcTjVOO64nUVRpS6v1fdw==
X-Received: by 2002:a17:90b:396:b0:26b:49de:13bd with SMTP id ga22-20020a17090b039600b0026b49de13bdmr22320368pjb.36.1693326951180;
        Tue, 29 Aug 2023 09:35:51 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id 10-20020a17090a194a00b0026b4d215627sm9866751pjh.21.2023.08.29.09.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 09:35:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Fix the build for the old ARM OABI
Date:   Tue, 29 Aug 2023 09:35:42 -0700
Message-ID: <20230829163547.1200183-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All structs and unions are word aligned when using the OABI. Mark the union
in struct utp_upiu_header as packed to prevent that the compiler inserts
padding bytes.

Cc: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308251634.tuRn4OVv-lkp@intel.com/
Fixes: 617bfaa8dd50 ("scsi: ufs: Simplify response header parsing")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/uapi/scsi/scsi_bsg_ufs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index bf1832dc35db..b41b5ae1d515 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -83,7 +83,7 @@ struct utp_upiu_header {
 			union {
 				__u8 tm_function;
 				__u8 query_function;
-			};
+			} __attribute__((packed));
 			__u8 response;
 			__u8 status;
 			__u8 ehs_length;
