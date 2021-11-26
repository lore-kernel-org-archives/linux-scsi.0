Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3BBC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 17:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355792AbhK0Rn5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 12:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbhK0Rl5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 12:41:57 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90520C061746;
        Sat, 27 Nov 2021 09:38:42 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so10334385pjb.1;
        Sat, 27 Nov 2021 09:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=muEV41oGv4dCXu6T0pBAwtMsCi0zA6yAWl0ncN03ssw=;
        b=ELNJTmDbhtdH+T48RrB+KCCm2X/Ky075szsYsS+ZAZv8JCLapZFv9iCiqsNRy/sQFZ
         ghW1tvD9A4x50zkAPuWYfdJGsVnkz/CU6S8/IDpSYtYfIqWiUkHw5yS+aFdckm843CnV
         Kstt4wXRdvvhR8Q9iaF9rsR3xKBY2viNw2QU/UPVHrE175KgEZ+MzK424N3Br+mMVx91
         VpgWTn968HG35ery5EGB+JFYCd6EyHUtuzJz4pLH4Hlp43ZV5U1eWNtCsv3ZOhVS1wBT
         fW4PrVijiUFiSc8m8RVm8lLre4g7m+MgfTuRb0b0gn6wmSEW6a9j10w50Eec30PZKjKg
         zH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=muEV41oGv4dCXu6T0pBAwtMsCi0zA6yAWl0ncN03ssw=;
        b=kmi6Hzvr1qTh+ags570tjbVu8M73iIBuiaFSNyl5OnphtSGFTbAV8YxVHIF8lrOO4j
         1IhAtwEwPIlTK+0oPbj8fLjkYZGFw/tVXBJIEMx5Uhpjfjs86lZF0Xvp2Ix1rm2jR/Ng
         1HnVq0d7iuXkPnJ9hfK2NVqKg+Nm88ifnUJAu2xCMhE6/juYLYlsbiI/svtCEXZxzczx
         R0EGi43Zt84Ahg5G96BRU91URIq07BUpYF+wAYUsvx7sU1YmCTsz3wt98YHxdN449c5Q
         wCJT16BA14y8DDffTTFlKZzXuDElSe9OxKAuAGAz7XoEJtk2kDc9h/j/3kwwrBtlkSET
         yWIQ==
X-Gm-Message-State: AOAM531tss9DX1VGWQ6a09bAZmNJBy4akmZgW1CoYh23srMo5YNOK+sc
        oJEQu/0zvpEc3QAnZKX0ndf9D+OctTTGJA==
X-Google-Smtp-Source: ABdhPJzTLlK8vbWzwyWP4NjwL6Fds42LHIYpXygP2nvsOPHZkzR79c0EvoWrDhBvYexSBb8bkqdPOw==
X-Received: by 2002:a17:90b:1bcb:: with SMTP id oa11mr24815160pjb.140.1638034721764;
        Sat, 27 Nov 2021 09:38:41 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (70-36-60-214.dyn.novuscom.net. [70.36.60.214])
        by smtp.gmail.com with ESMTPSA id t19sm8051776pgn.7.2021.11.27.09.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 09:38:41 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com (supporter:QLOGIC QL41xxx ISCSI
        DRIVER), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:QLOGIC QL41xxx ISCSI DRIVER)
Subject: [PATCH v2 2/2] scsi: qedi: Fix SYSFS_FLAG_FW_SEL_BOOT formatting
Date:   Fri, 26 Nov 2021 12:17:08 -0800
Message-Id: <20211126201708.27140-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126201708.27140-1-f.fainelli@gmail.com>
References: <20211126201708.27140-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The format used for formatting SYSFS_FLAG_FW_SEL_BOOT creates the
following warning:

drivers/scsi/qedi/qedi_main.c:2259:35: warning: format specifies type
'char' but the argument has type 'int' [-Wformat]
                   rc = snprintf(buf, 3, "%hhd\n",
SYSFS_FLAG_FW_SEL_BOOT);

Fix this to cast the constant as an u8 since the intention is to print
it via sysfs as a byte.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/scsi/qedi/qedi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index ce199a7a16b8..421b3a69fd37 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -358,7 +358,7 @@ struct qedi_ctx {
 	bool use_fast_sge;
 
 	atomic_t num_offloads;
-#define SYSFS_FLAG_FW_SEL_BOOT 2
+#define SYSFS_FLAG_FW_SEL_BOOT (u8)2
 #define IPV6_LEN	41
 #define IPV4_LEN	17
 	struct iscsi_boot_kset *boot_kset;
-- 
2.25.1

