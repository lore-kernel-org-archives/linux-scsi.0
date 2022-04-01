Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC5BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 00:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243456AbiDAAXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 20:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbiDAAXR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 20:23:17 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBEC12E15A
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 17:21:26 -0700 (PDT)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220401002122epoutp014f18664ed3ace073c4a16407f26c5d65~hndZtUUhH1185311853epoutp01d
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 00:21:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220401002122epoutp014f18664ed3ace073c4a16407f26c5d65~hndZtUUhH1185311853epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648772482;
        bh=cfFIVNxmEKALcuLvPyk5jUSJiYHP+Y+x674JNlkkV+4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ca30j45u2W6L3AqudV1NVCTsARuOpix68eU9K06IXR6GosmrvrbNMshsTJeVzOnq3
         2ZTpQv56CF6y/0VwCDfCv1HlQVnR86eWuFx3hZvzOUBH7x84k1zknzdKbGUGLJNVUP
         IM5oUYhMMdastvIzYS3Yd2Zp/m/1Kgmt0ns9EGEI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20220401002122epcas2p364e0fb7306290eb325f39dc436288fec~hndZCx4qn1936319363epcas2p3F;
        Fri,  1 Apr 2022 00:21:22 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.70]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KV1723frtz4x9Q3; Fri,  1 Apr
        2022 00:21:18 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.EF.16040.E7546426; Fri,  1 Apr 2022 09:21:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20220401002117epcas2p3c513e897d9d19ac57d75cf63d664235a~hndVAzkwV2823528235epcas2p3q;
        Fri,  1 Apr 2022 00:21:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220401002117epsmtrp29d50acd8e74a4ce54d7276bc7019a8b4~hndU-mw9q1315913159epsmtrp2d;
        Fri,  1 Apr 2022 00:21:17 +0000 (GMT)
X-AuditID: b6c32a46-be9ff70000023ea8-59-6246457e217d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.1E.03370.D7546426; Fri,  1 Apr 2022 09:21:17 +0900 (KST)
Received: from KORCO082417 (unknown [10.229.8.121]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220401002117epsmtip2d44e27028907aab27ca4f1a20604bc4f~hndUx3nOQ2701827018epsmtip2E;
        Fri,  1 Apr 2022 00:21:17 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Asutosh Das'" <asutoshd@codeaurora.org>,
        "'Daejun Park'" <daejun7.park@samsung.com>,
        "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Keoseong Park'" <keosung.park@samsung.com>,
        "'Mike Snitzer'" <snitzer@redhat.com>,
        "'Eric Biggers'" <ebiggers@google.com>,
        "'Jens Axboe'" <axboe@kernel.dk>,
        "'Ulf Hansson'" <ulf.hansson@linaro.org>
In-Reply-To: <20220331223424.1054715-27-bvanassche@acm.org>
Subject: RE: [PATCH 26/29] scsi: ufs: Split the ufshcd.h header file
Date:   Fri, 1 Apr 2022 09:21:17 +0900
Message-ID: <002201d8455e$67b46e70$371d4b50$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEkvIO8WDCMeleYLL46gzQacByZhQJUTo2RAiEKkqOuHZaZwA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJsWRmVeSWpSXmKPExsWy7bCmqW6dq1uSwYa13BYnn6xhs9jbdoLd
        4uXPq2wWq+/2s1kcfNjJYjHtw09mi0/rl7FarHoQbnFxdQurxZP1s5gtFt3YxmRx/OQ7Rovu
        6zvYLJ4sPMNksfz4PyaLto1fGS2Orw13EPS4fMXb43JfL5PHgk2lHov3vGTyuHy21GPTqk42
        jzvX9rB5TFh0gNHj+/oONo+PT2+xeLzfd5XNY+f3BnaPvi2rGD0+b5LzaD/QzRTAH5Vtk5Ga
        mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0pZJCWWJOKVAo
        ILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwLxArzgxt7g0L10vL7XEytDAwMgUqDAhO6P/8gr2
        gpUrGStm3rrB1sC4rJexi5GTQ0LARGLBu0NsXYxcHEICOxglpnccZoZwPjFKnPj5ggnC+cwo
        MfXyISaYltXtx1ghErsYJY4u+QzlvGCUeLlxNjtIFZuAvsTLjm1ACQ4OEYEUif0PJEFqmAWe
        s0jMbj8KVsMpYC3R0XeMCaRGWMBF4vTTCpAwi4CKxPw/68BKeAUsJb5M+AdlC0qcnPmEBcRm
        FpCX2P52DjPEQQoSP58uYwWxRQScJE6/PMUKUSMiMbuzDewdCYHFnBKt/T+gGlwkFjy8ww5h
        C0u8Or4FypaS+PxuLxuEXSyxdNYnJojmBkaJy9t+QSWMJWY9a2cEOZpZQFNi/S59EFNCQFni
        yC2o2/gkOg7/ZYcI80p0tAlBNKpLHNg+nQXClpXonvOZdQKj0iwkn81C8tksJB/MQti1gJFl
        FaNYakFxbnpqsVGBETy6k/NzNzGCs4CW2w7GKW8/6B1iZOJgPMQowcGsJMJ7NdY1SYg3JbGy
        KrUoP76oNCe1+BCjKTCsJzJLiSbnA/NQXkm8oYmlgYmZmaG5kamBuZI4r1fKhkQhgfTEktTs
        1NSC1CKYPiYOTqkGJt4j37qUKz/vXXTNMmL79aSjoddvnzW7W5F7RtQ1tLvN7OO82jlqb1bn
        CTVdjr1zVebz2m0pFpxS/oKbnnE7f2FRuiTA9P5+zJWc9e+f2uVbNcq7ydWILZIyOP741v3W
        dX3Fwn1bVZ8r+0z5v+aZ1VIpicofkufi3kwQcm0OMPn3y+HMm9hTuw5dkYy4xKO98tL+lJK5
        LlPDNqpxm59d7+64+HWYR/PzI/619UmC2/c1PVvBo7NiCbvpQ+HFnxXnp/RznvkieePilFzJ
        /UVbJ2/ZtTYx2Fd6ddrNw5yKiVPuPamUXmoS/qCcbVvtTvsG5VitcPZop7du16u3ec4sv2I6
        7cv3N95TOF2zX/L6lSixFGckGmoxFxUnAgC+pl26iwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsWy7bCSvG6tq1uSwbUlOhYnn6xhs9jbdoLd
        4uXPq2wWq+/2s1kcfNjJYjHtw09mi0/rl7FarHoQbnFxdQurxZP1s5gtFt3YxmRx/OQ7Rovu
        6zvYLJ4sPMNksfz4PyaLto1fGS2Orw13EPS4fMXb43JfL5PHgk2lHov3vGTyuHy21GPTqk42
        jzvX9rB5TFh0gNHj+/oONo+PT2+xeLzfd5XNY+f3BnaPvi2rGD0+b5LzaD/QzRTAH8Vlk5Ka
        k1mWWqRvl8CV0X95BXvBypWMFTNv3WBrYFzWy9jFyMkhIWAisbr9GGsXIxeHkMAORonvf6ey
        QyRkJZ692wFlC0vcbzkCVfSMUWLdz/UsIAk2AX2Jlx3bWEFsEYEUiRkLPrKDFDELfGaR2Nn6
        lR2iYxejxPIz35hAqjgFrCU6+o4B2RwcwgIuEqefVoCEWQRUJOb/WQe2jVfAUuLLhH9QtqDE
        yZlPWEDKmQX0JNo2gl3NLCAvsf3tHGaI4xQkfj5dBnWDk8Tpl6dYIWpEJGZ3tjFPYBSehWTS
        LIRJs5BMmoWkYwEjyypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOB0oKW1g3HPqg96
        hxiZOBgPMUpwMCuJ8F6NdU0S4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6Yklqdmpq
        QWoRTJaJg1OqgYk/T3id0IOtgRNti2XX50575Z21nm/ah1fphwtSp5/8YpbP8zlTU0VDt8ZA
        ofhK30olo7hOY/VPlWuDnX/rz/z9st9cVutc7BGdX95shyIMwrZWir3my1mo6nPhYrP/nM1L
        9P/3x/ZYLslcs//fNr29JXFJF7doNP3Wjg3bfMxgzl2PyP7js8Pm2Meu3PXFUeDrt7C8Kxq5
        m/Yu+p5UuVyLparjqWdW7hmlY5wXW1svRi/+Y1WxSeuyiEpVWbv5wZ96HxbrSpcwWgq7Pav8
        bV9b/qUm+fb/06l1VetmR18/cblqU//P9R/SlzI6SUd9sPNbxlDF9qgwci3LgjbjmAPVX0OX
        3mJ39DI6Y8SQqsRSnJFoqMVcVJwIALH2pK52AwAA
X-CMS-MailID: 20220401002117epcas2p3c513e897d9d19ac57d75cf63d664235a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220331224010epcas2p33104ab9dbf6df0d885f1cc2b31d07d12
References: <20220331223424.1054715-1-bvanassche@acm.org>
        <CGME20220331224010epcas2p33104ab9dbf6df0d885f1cc2b31d07d12@epcas2p3.samsung.com>
        <20220331223424.1054715-27-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I'm seeing below build error when I applied this patch. Any baseline do I
need?

In file included from drivers/scsi/ufs/ufs-sysfs.c:9:
drivers/scsi/ufs/ufshcd-priv.h:32:20: error: redefinition of
'ufs_hwmon_probe'
   32 | static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
      |                    ^~~~~~~~~~~~~~~
In file included from drivers/scsi/ufs/ufshcd-priv.h:5,
                 from drivers/scsi/ufs/ufs-sysfs.c:9:
drivers/scsi/ufs/ufshcd.h:1079:20: note: previous definition of
'ufs_hwmon_probe' with type 'void(struct ufs_hba *, u8)' {aka 'void(struct
ufs_hba *, unsigned char)'}
 1079 | static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
      |                    ^~~~~~~~~~~~~~~
In file included from drivers/scsi/ufs/ufs-sysfs.c:9:
drivers/scsi/ufs/ufshcd-priv.h:33:20: error: redefinition of
'ufs_hwmon_remove'
   33 | static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
      |                    ^~~~~~~~~~~~~~~~
In file included from drivers/scsi/ufs/ufshcd-priv.h:5,
                 from drivers/scsi/ufs/ufs-sysfs.c:9:
drivers/scsi/ufs/ufshcd.h:1080:20: note: previous definition of
'ufs_hwmon_remove' with type 'void(struct ufs_hba *)'
 1080 | static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
      |                    ^~~~~~~~~~~~~~~~

Best Regards,
Chanho Park

-----Original Message-----
From: Bart Van Assche <bvanassche@acm.org> 
Sent: Friday, April 1, 2022 7:34 AM
To: Martin K . Petersen <martin.petersen@oracle.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>; Adrian Hunter
<adrian.hunter@intel.com>; linux-scsi@vger.kernel.org; Bart Van Assche
<bvanassche@acm.org>; James E.J. Bottomley <jejb@linux.ibm.com>; Avri Altman
<Avri.Altman@wdc.com>; Can Guo <cang@codeaurora.org>; Asutosh Das
<asutoshd@codeaurora.org>; Daejun Park <daejun7.park@samsung.com>; Guenter
Roeck <linux@roeck-us.net>; Bean Huo <beanhuo@micron.com>; Keoseong Park
<keosung.park@samsung.com>; Mike Snitzer <snitzer@redhat.com>; Eric Biggers
<ebiggers@google.com>; Jens Axboe <axboe@kernel.dk>; Ulf Hansson
<ulf.hansson@linaro.org>
Subject: [PATCH 26/29] scsi: ufs: Split the ufshcd.h header file

Split the ufshcd.h header file into a header file that defines the interface
used by UFS drivers and another header file with declarations and data
structures only used by the UFS core.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-debugfs.c   |   1 +
 drivers/scsi/ufs/ufs-hwmon.c     |   1 +
 drivers/scsi/ufs/ufs-sysfs.c     |   3 +-
 drivers/scsi/ufs/ufs_bsg.c       |   1 +
 drivers/scsi/ufs/ufshcd-crypto.h |   2 +
 drivers/scsi/ufs/ufshcd-priv.h   | 277 +++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        |   1 +
 drivers/scsi/ufs/ufshcd.h        | 212 -----------------------
 drivers/scsi/ufs/ufshpb.c        |   1 +
 9 files changed, 285 insertions(+), 214 deletions(-)  create mode 100644
drivers/scsi/ufs/ufshcd-priv.h

diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
index 4a0bbcf1757a..c10a8f09682b 100644
--- a/drivers/scsi/ufs/ufs-debugfs.c
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -5,6 +5,7 @@
 
 #include "ufs-debugfs.h"
 #include "ufshcd.h"
+#include "ufshcd-priv.h"
 
 static struct dentry *ufs_debugfs_root;
 
diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs/ufs-hwmon.c
index 74855491dc8f..c38d9d98a86d 100644
--- a/drivers/scsi/ufs/ufs-hwmon.c
+++ b/drivers/scsi/ufs/ufs-hwmon.c
@@ -8,6 +8,7 @@
 #include <linux/units.h>
 
 #include "ufshcd.h"
+#include "ufshcd-priv.h"
 
 struct ufs_hwmon_data {
 	struct ufs_hba *hba;
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 2bf128e4b613..97ab1a75e3b8 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -6,8 +6,7 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include "ufs-sysfs.h"
-#include "ufs.h"
-#include "ufshcd.h"
+#include "ufshcd-priv.h"
 
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c index
fbcdfb713542..9e9b93867cab 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -10,6 +10,7 @@
 #include <scsi/scsi_host.h>
 #include "ufs_bsg.h"
 #include "ufshcd.h"
+#include "ufshcd-priv.h"
 
 static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
 				       struct utp_upiu_query *qr)
diff --git a/drivers/scsi/ufs/ufshcd-crypto.h
b/drivers/scsi/ufs/ufshcd-crypto.h
index 57dd51256b57..9f98f18f9646 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.h
+++ b/drivers/scsi/ufs/ufshcd-crypto.h
@@ -8,6 +8,8 @@
 
 #include <scsi/scsi_cmnd.h>
 #include "ufshcd.h"
+#include "ufshcd-priv.h"
+#include "ufshci.h"
 
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 
diff --git a/drivers/scsi/ufs/ufshcd-priv.h b/drivers/scsi/ufs/ufshcd-priv.h
new file mode 100644 index 000000000000..4ceb0c63aa15
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-priv.h
@@ -0,0 +1,277 @@
+#ifndef _UFSHCD_PRIV_H_
+#define _UFSHCD_PRIV_H_
+
+#include <linux/pm_runtime.h>
+#include "ufshcd.h"
+
+static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba) {
+	return !hba->shutting_down;
+}
+
+void ufshcd_schedule_eh_work(struct ufs_hba *hba);
+
+static inline bool ufshcd_keep_autobkops_enabled_except_suspend(
+							struct ufs_hba *hba)
+{
+	return hba->caps &
UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND;
+}
+
+static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba) {
+	if (hba->dev_info.wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
+		return hba->dev_info.wb_dedicated_lu;
+	return 0;
+}
+
+#ifdef CONFIG_SCSI_UFS_HWMON
+void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask); void 
+ufs_hwmon_remove(struct ufs_hba *hba); void 
+ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask); #else static 
+inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {} static 
+inline void ufs_hwmon_remove(struct ufs_hba *hba) {} static inline void 
+ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask) {} #endif
+
+int ufshcd_read_desc_param(struct ufs_hba *hba,
+			   enum desc_idn desc_id,
+			   int desc_index,
+			   u8 param_offset,
+			   u8 *param_read_buf,
+			   u8 param_size);
+int ufshcd_query_attr_retry(struct ufs_hba *hba, enum query_opcode opcode,
+			    enum attr_idn idn, u8 index, u8 selector,
+			    u32 *attr_val);
+int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+		      enum attr_idn idn, u8 index, u8 selector, u32
*attr_val); int 
+ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
+	enum flag_idn idn, u8 index, bool *flag_res); void 
+ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
+
+#define SD_ASCII_STD true
+#define SD_RAW false
+int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
+			    u8 **buf, bool ascii);
+
+int ufshcd_hold(struct ufs_hba *hba, bool async); void 
+ufshcd_release(struct ufs_hba *hba);
+
+void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn
desc_id,
+				  int *desc_length);
+
+int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command 
+*uic_cmd);
+
+int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
+			     struct utp_upiu_req *req_upiu,
+			     struct utp_upiu_req *rsp_upiu,
+			     int msgcode,
+			     u8 *desc_buff, int *buff_len,
+			     enum query_opcode desc_op);
+
+int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
+
+/* Wrapper functions for safely calling variant operations */ static 
+inline const char *ufshcd_get_var_name(struct ufs_hba *hba) {
+	if (hba->vops)
+		return hba->vops->name;
+	return "";
+}
+
+static inline void ufshcd_vops_exit(struct ufs_hba *hba) {
+	if (hba->vops && hba->vops->exit)
+		return hba->vops->exit(hba);
+}
+
+static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba) 
+{
+	if (hba->vops && hba->vops->get_ufs_hci_version)
+		return hba->vops->get_ufs_hci_version(hba);
+
+	return ufshcd_readl(hba, REG_UFS_VERSION); }
+
+static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
+			bool up, enum ufs_notify_change_status status) {
+	if (hba->vops && hba->vops->clk_scale_notify)
+		return hba->vops->clk_scale_notify(hba, up, status);
+	return 0;
+}
+
+static inline void ufshcd_vops_event_notify(struct ufs_hba *hba,
+					    enum ufs_event_type evt,
+					    void *data)
+{
+	if (hba->vops && hba->vops->event_notify)
+		hba->vops->event_notify(hba, evt, data); }
+
+static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on,
+					enum ufs_notify_change_status
status) {
+	if (hba->vops && hba->vops->setup_clocks)
+		return hba->vops->setup_clocks(hba, on, status);
+	return 0;
+}
+
+static inline int ufshcd_vops_hce_enable_notify(struct ufs_hba *hba,
+						bool status)
+{
+	if (hba->vops && hba->vops->hce_enable_notify)
+		return hba->vops->hce_enable_notify(hba, status);
+
+	return 0;
+}
+static inline int ufshcd_vops_link_startup_notify(struct ufs_hba *hba,
+						bool status)
+{
+	if (hba->vops && hba->vops->link_startup_notify)
+		return hba->vops->link_startup_notify(hba, status);
+
+	return 0;
+}
+
+static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
+				  enum ufs_notify_change_status status,
+				  struct ufs_pa_layer_attr *dev_max_params,
+				  struct ufs_pa_layer_attr *dev_req_params)
{
+	if (hba->vops && hba->vops->pwr_change_notify)
+		return hba->vops->pwr_change_notify(hba, status,
+					dev_max_params, dev_req_params);
+
+	return -ENOTSUPP;
+}
+
+static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
+					int tag, u8 tm_function)
+{
+	if (hba->vops && hba->vops->setup_task_mgmt)
+		return hba->vops->setup_task_mgmt(hba, tag, tm_function); }
+
+static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
+					enum uic_cmd_dme cmd,
+					enum ufs_notify_change_status
status) {
+	if (hba->vops && hba->vops->hibern8_notify)
+		return hba->vops->hibern8_notify(hba, cmd, status); }
+
+static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba) {
+	if (hba->vops && hba->vops->apply_dev_quirks)
+		return hba->vops->apply_dev_quirks(hba);
+	return 0;
+}
+
+static inline void ufshcd_vops_fixup_dev_quirks(struct ufs_hba *hba) {
+	if (hba->vops && hba->vops->fixup_dev_quirks)
+		hba->vops->fixup_dev_quirks(hba);
+}
+
+static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op
op,
+				enum ufs_notify_change_status status) {
+	if (hba->vops && hba->vops->suspend)
+		return hba->vops->suspend(hba, op, status);
+
+	return 0;
+}
+
+static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum 
+ufs_pm_op op) {
+	if (hba->vops && hba->vops->resume)
+		return hba->vops->resume(hba, op);
+
+	return 0;
+}
+
+static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba) {
+	if (hba->vops && hba->vops->dbg_register_dump)
+		hba->vops->dbg_register_dump(hba);
+}
+
+static inline int ufshcd_vops_device_reset(struct ufs_hba *hba) {
+	if (hba->vops && hba->vops->device_reset)
+		return hba->vops->device_reset(hba);
+
+	return -EOPNOTSUPP;
+}
+
+static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
+		struct devfreq_dev_profile *p,
+		struct devfreq_simple_ondemand_data *data) {
+	if (hba->vops && hba->vops->config_scaling_param)
+		hba->vops->config_scaling_param(hba, p, data); }
+
+extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
+
+/**
+ * ufshcd_scsi_to_upiu_lun - maps scsi LUN to UPIU LUN
+ * @scsi_lun: scsi LUN id
+ *
+ * Returns UPIU LUN id
+ */
+static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun) {
+	if (scsi_is_wlun(scsi_lun))
+		return (scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID)
+			| UFS_UPIU_WLUN_ID;
+	else
+		return scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID; }
+
+int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask); 
+int ufshcd_write_ee_control(struct ufs_hba *hba); int 
+ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
+			     u16 set, u16 clr);
+
+static inline int ufshcd_update_ee_drv_mask(struct ufs_hba *hba,
+					    u16 set, u16 clr)
+{
+	return ufshcd_update_ee_control(hba, &hba->ee_drv_mask,
+					&hba->ee_usr_mask, set, clr);
+}
+
+static inline int ufshcd_update_ee_usr_mask(struct ufs_hba *hba,
+					    u16 set, u16 clr)
+{
+	return ufshcd_update_ee_control(hba, &hba->ee_usr_mask,
+					&hba->ee_drv_mask, set, clr);
+}
+
+static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba) {
+	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba) {
+	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+static inline void ufshcd_rpm_get_noresume(struct ufs_hba *hba) {
+	pm_runtime_get_noresume(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+static inline int ufshcd_rpm_resume(struct ufs_hba *hba) {
+	return pm_runtime_resume(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+static inline int ufshcd_rpm_put(struct ufs_hba *hba) {
+	return pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
+}
+
+#endif /* _UFSHCD_PRIV_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
de366247628b..bab0f1ee41e6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -32,6 +32,7 @@
 #include "ufs_bsg.h"
 #include "ufs_quirks.h"
 #include "ufshcd-crypto.h"
+#include "ufshcd-priv.h"
 #include "ufshcd.h"
 #include "ufshpb.h"
 #include "unipro.h"
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
ab0c643296c0..b13469fb1e15 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1007,11 +1007,6 @@ static inline bool ufshcd_is_wb_allowed(struct
ufs_hba *hba)
 	return hba->caps & UFSHCD_CAP_WB_EN;
 }
 
-static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba) -{
-	return !hba->shutting_down;
-}
-
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
@@ -1075,18 +1070,6 @@ static inline void *ufshcd_get_variant(struct ufs_hba
*hba)
 	BUG_ON(!hba);
 	return hba->priv;
 }
-static inline bool ufshcd_keep_autobkops_enabled_except_suspend(
-							struct ufs_hba *hba)
-{
-	return hba->caps &
UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND;
-}
-
-static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba) -{
-	if (hba->dev_info.wb_buffer_type == WB_BUF_MODE_LU_DEDICATED)
-		return hba->dev_info.wb_dedicated_lu;
-	return 0;
-}
 
 #ifdef CONFIG_SCSI_UFS_HWMON
 void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask); @@ -1230,13 +1213,6 @@
int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);  void
ufshcd_resume_complete(struct device *dev);
 
 /* Wrapper functions for safely calling variant operations */ -static
inline const char *ufshcd_get_var_name(struct ufs_hba *hba) -{
-	if (hba->vops)
-		return hba->vops->name;
-	return "";
-}
-
 static inline int ufshcd_vops_init(struct ufs_hba *hba)  {
 	if (hba->vops && hba->vops->init)
@@ -1245,61 +1221,6 @@ static inline int ufshcd_vops_init(struct ufs_hba
*hba)
 	return 0;
 }
 
-static inline void ufshcd_vops_exit(struct ufs_hba *hba) -{
-	if (hba->vops && hba->vops->exit)
-		return hba->vops->exit(hba);
-}
-
-static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba) -{
-	if (hba->vops && hba->vops->get_ufs_hci_version)
-		return hba->vops->get_ufs_hci_version(hba);
-
-	return ufshcd_readl(hba, REG_UFS_VERSION);
-}
-
-static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
-			bool up, enum ufs_notify_change_status status)
-{
-	if (hba->vops && hba->vops->clk_scale_notify)
-		return hba->vops->clk_scale_notify(hba, up, status);
-	return 0;
-}
-
-static inline void ufshcd_vops_event_notify(struct ufs_hba *hba,
-					    enum ufs_event_type evt,
-					    void *data)
-{
-	if (hba->vops && hba->vops->event_notify)
-		hba->vops->event_notify(hba, evt, data);
-}
-
-static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on,
-					enum ufs_notify_change_status
status)
-{
-	if (hba->vops && hba->vops->setup_clocks)
-		return hba->vops->setup_clocks(hba, on, status);
-	return 0;
-}
-
-static inline int ufshcd_vops_hce_enable_notify(struct ufs_hba *hba,
-						bool status)
-{
-	if (hba->vops && hba->vops->hce_enable_notify)
-		return hba->vops->hce_enable_notify(hba, status);
-
-	return 0;
-}
-static inline int ufshcd_vops_link_startup_notify(struct ufs_hba *hba,
-						bool status)
-{
-	if (hba->vops && hba->vops->link_startup_notify)
-		return hba->vops->link_startup_notify(hba, status);
-
-	return 0;
-}
-
 static inline int ufshcd_vops_phy_initialization(struct ufs_hba *hba)  {
 	if (hba->vops && hba->vops->phy_initialization) @@ -1308,102 +1229,8
@@ static inline int ufshcd_vops_phy_initialization(struct ufs_hba *hba)
 	return 0;
 }
 
-static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
-				  enum ufs_notify_change_status status,
-				  struct ufs_pa_layer_attr *dev_max_params,
-				  struct ufs_pa_layer_attr *dev_req_params)
-{
-	if (hba->vops && hba->vops->pwr_change_notify)
-		return hba->vops->pwr_change_notify(hba, status,
-					dev_max_params, dev_req_params);
-
-	return -ENOTSUPP;
-}
-
-static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
-					int tag, u8 tm_function)
-{
-	if (hba->vops && hba->vops->setup_task_mgmt)
-		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
-}
-
-static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
-					enum uic_cmd_dme cmd,
-					enum ufs_notify_change_status
status)
-{
-	if (hba->vops && hba->vops->hibern8_notify)
-		return hba->vops->hibern8_notify(hba, cmd, status);
-}
-
-static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba) -{
-	if (hba->vops && hba->vops->apply_dev_quirks)
-		return hba->vops->apply_dev_quirks(hba);
-	return 0;
-}
-
-static inline void ufshcd_vops_fixup_dev_quirks(struct ufs_hba *hba) -{
-	if (hba->vops && hba->vops->fixup_dev_quirks)
-		hba->vops->fixup_dev_quirks(hba);
-}
-
-static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op
op,
-				enum ufs_notify_change_status status)
-{
-	if (hba->vops && hba->vops->suspend)
-		return hba->vops->suspend(hba, op, status);
-
-	return 0;
-}
-
-static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum ufs_pm_op
op) -{
-	if (hba->vops && hba->vops->resume)
-		return hba->vops->resume(hba, op);
-
-	return 0;
-}
-
-static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba) -{
-	if (hba->vops && hba->vops->dbg_register_dump)
-		hba->vops->dbg_register_dump(hba);
-}
-
-static inline int ufshcd_vops_device_reset(struct ufs_hba *hba) -{
-	if (hba->vops && hba->vops->device_reset)
-		return hba->vops->device_reset(hba);
-
-	return -EOPNOTSUPP;
-}
-
-static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
-		struct devfreq_dev_profile *p,
-		struct devfreq_simple_ondemand_data *data)
-{
-	if (hba->vops && hba->vops->config_scaling_param)
-		hba->vops->config_scaling_param(hba, p, data);
-}
-
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
-/**
- * ufshcd_scsi_to_upiu_lun - maps scsi LUN to UPIU LUN
- * @scsi_lun: scsi LUN id
- *
- * Returns UPIU LUN id
- */
-static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun) -{
-	if (scsi_is_wlun(scsi_lun))
-		return (scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID)
-			| UFS_UPIU_WLUN_ID;
-	else
-		return scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID;
-}
-
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix);
 
@@ -1412,43 +1239,4 @@ int ufshcd_write_ee_control(struct ufs_hba *hba);
int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16
*other_mask,
 			     u16 set, u16 clr);
 
-static inline int ufshcd_update_ee_drv_mask(struct ufs_hba *hba,
-					    u16 set, u16 clr)
-{
-	return ufshcd_update_ee_control(hba, &hba->ee_drv_mask,
-					&hba->ee_usr_mask, set, clr);
-}
-
-static inline int ufshcd_update_ee_usr_mask(struct ufs_hba *hba,
-					    u16 set, u16 clr)
-{
-	return ufshcd_update_ee_control(hba, &hba->ee_usr_mask,
-					&hba->ee_drv_mask, set, clr);
-}
-
-static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba) -{
-	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
-}
-
-static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba) -{
-	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
-}
-
-static inline void ufshcd_rpm_get_noresume(struct ufs_hba *hba) -{
-	pm_runtime_get_noresume(&hba->ufs_device_wlun->sdev_gendev);
-}
-
-static inline int ufshcd_rpm_resume(struct ufs_hba *hba) -{
-	return pm_runtime_resume(&hba->ufs_device_wlun->sdev_gendev);
-}
-
-static inline int ufshcd_rpm_put(struct ufs_hba *hba) -{
-	return pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
-}
-
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c index
d456404e5c49..daac81290f50 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 #include "ufshcd.h"
 #include "ufshpb.h"
+#include "ufshcd-priv.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */  #define READ_TO_MS 1000

