Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F35C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 15:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504092072C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 15:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgABPBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 10:01:00 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:37957 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgABPBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 10:01:00 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MrhDg-1jYVqE2Tga-00ndiR; Thu, 02 Jan 2020 16:00:06 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/22] compat_ioctl: add scsi_compat_ioctl
Date:   Thu,  2 Jan 2020 15:55:28 +0100
Message-Id: <20200102145552.1853992-11-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20200102145552.1853992-1-arnd@arndb.de>
References: <20200102145552.1853992-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:wWyOxkPxks6ZLGDfVWfB8jnnZ3eQfd6m6seDw5PYn1G0Q10JVRK
 4AMdasffkBmhIydWEoH7T9ScuaYHbmIYzx+4jUOHHbNvU0cNDRrnxCczvfO3dh3CYAaFlpf
 jwSe4DfQdi8xyS9uL6lg+3WOkvoA5jYpK0um+F5NMWagaJ2WEXZCg6VHdqepgTb/JwoNpVz
 uoLzfpEW7Jnc5jcgB+T9g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JasbQQ2pZHY=:C73jn5i5YVNLi2pVZJvlfn
 mJ55iUBUXDj6d45Xdi7PSUMvxbjyfoK2fjonVZ8uguYHWiZ8mDeKTOCtzQb+HQ4QMNjMFXKJE
 ziQHt3euqxU29a/3q0LitLy9Xw+yXySToZ/07WYR+jEC2teqYlc4SC7Wz0/jBfZCltDUAWAxO
 HG7OA1tvZDRXPaLNoiMLneiPOsGpJl9kSQIe4F4ww57owUJdVBoWJVDvAg74nPwF6WBL1RhoL
 BLAUPZ5v9yxADTkniNf9oL3NcPEqopVYLvV1gAd9PUEE/WXhPGPDClLJ/ISeNxc5UFyxwLlE4
 jJBq/Wz6Sk0OjairsgMwVGkePt3HuaPO+QXbtkTAzYTfWvg8oZck7j1FyHq2rp2qqVxKepeGK
 16R550NWjA5MsW8kNregylyT5OhymP2aMJHiIlH87SXkRVmB1rmSHD0AcdPCZiCLL7DvxnVQz
 sj3UIP1976nDtaq4EsYIy8o7zN3oKyB2/SUMSRRLw0RuYZeBxWkdVW1CpvniLybGmvpKYbO7T
 O1OKsCIxrAg1/LXl8HFTTII4dBKJUyA6VLJsa/pF79eQm88PfIzUfPoSXTsO8UTgl4JdLZir2
 N88EjMm/iuHcjAIs9Sdo+wJW8lXwcGsjz9umB8dW4ZB+dXPUCULt7X9ecnCXIxM9QijyFsklx
 VzzAYDV1e449PTQFTWVxWZOBHvtpiO1keC47HZJucn+Ec3vzLPLgMMS3N99NmKsNeV2iKQ6w7
 EacpwBCCiboM8Sy7b0IVCW3gLrr1lv12xD0zkUxfE27z4luCSOJqN0lN12X6iabUGs6jTD/2R
 w18vc/UUpTfk3AES8Lf1FJzzbPkkxqpNPvZM8pN8cYWryKi4+jbEdamlKtwsmggOZHKiWdRWW
 YkGNaEthjv6Z041GvVRQ==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order to move the compat handling for SCSI ioctl commands out of
fs/compat_ioctl.c into the individual drivers, we need a helper function
first to match the native ioctl handler called by sd, sr, st, etc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/scsi_ioctl.c | 54 +++++++++++++++++++++++++++++----------
 include/scsi/scsi_ioctl.h |  1 +
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 57bcd05605bf..8f3af87b6bb0 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -189,17 +189,7 @@ static int scsi_ioctl_get_pci(struct scsi_device *sdev, void __user *arg)
 }
 
 
-/**
- * scsi_ioctl - Dispatch ioctl to scsi device
- * @sdev: scsi device receiving ioctl
- * @cmd: which ioctl is it
- * @arg: data associated with ioctl
- *
- * Description: The scsi_ioctl() function differs from most ioctls in that it
- * does not take a major/minor number as the dev field.  Rather, it takes
- * a pointer to a &struct scsi_device.
- */
-int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+static int scsi_ioctl_common(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
 	struct scsi_sense_hdr sense_hdr;
@@ -266,14 +256,50 @@ int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
                 return scsi_ioctl_get_pci(sdev, arg);
 	case SG_SCSI_RESET:
 		return scsi_ioctl_reset(sdev, arg);
-	default:
-		if (sdev->host->hostt->ioctl)
-			return sdev->host->hostt->ioctl(sdev, cmd, arg);
 	}
+	return -ENOIOCTLCMD;
+}
+
+/**
+ * scsi_ioctl - Dispatch ioctl to scsi device
+ * @sdev: scsi device receiving ioctl
+ * @cmd: which ioctl is it
+ * @arg: data associated with ioctl
+ *
+ * Description: The scsi_ioctl() function differs from most ioctls in that it
+ * does not take a major/minor number as the dev field.  Rather, it takes
+ * a pointer to a &struct scsi_device.
+ */
+int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+{
+	int ret = scsi_ioctl_common(sdev, cmd, arg);
+
+	if (ret != -ENOIOCTLCMD)
+		return ret;
+
+	if (sdev->host->hostt->ioctl)
+		return sdev->host->hostt->ioctl(sdev, cmd, arg);
+
 	return -EINVAL;
 }
 EXPORT_SYMBOL(scsi_ioctl);
 
+#ifdef CONFIG_COMPAT
+int scsi_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+{
+	int ret = scsi_ioctl_common(sdev, cmd, arg);
+
+	if (ret != -ENOIOCTLCMD)
+		return ret;
+
+	if (sdev->host->hostt->compat_ioctl)
+		return sdev->host->hostt->compat_ioctl(sdev, cmd, arg);
+
+	return ret;
+}
+EXPORT_SYMBOL(scsi_compat_ioctl);
+#endif
+
 /*
  * We can process a reset even when a device isn't fully operable.
  */
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index 5101e987c0ef..4fe69d863b5d 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -44,6 +44,7 @@ typedef struct scsi_fctargaddress {
 int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
 		int cmd, bool ndelay);
 extern int scsi_ioctl(struct scsi_device *, int, void __user *);
+extern int scsi_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg);
 
 #endif /* __KERNEL__ */
 #endif /* _SCSI_IOCTL_H */
-- 
2.20.0

