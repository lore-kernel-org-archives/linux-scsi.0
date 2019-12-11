Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC92BC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 20:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F7E2054F
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 20:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfLKUrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 15:47:16 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:53299 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfLKUrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 15:47:16 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N7Qt9-1heGB12Xy1-017l1U; Wed, 11 Dec 2019 21:47:02 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 12/24] compat_ioctl: add scsi_compat_ioctl
Date:   Wed, 11 Dec 2019 21:42:46 +0100
Message-Id: <20191211204306.1207817-13-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191211204306.1207817-1-arnd@arndb.de>
References: <20191211204306.1207817-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:K9j2t2hRIDN1s24Qc+2ApYId+NR70I0ahQXZVZus7eh7p5W3KwC
 BexL4HNQXEGo1mU+/z+mF+nWOdFPvBBNu+B3O+hhRy6chSEBu6VtLmq6zXb4gdu/3JIZkWp
 fxlku3lFgKF/LiyPgpzzL8FHeSh1jnUjSLS5XVoRw4PLA0ipNO8wXuf5fhuEbAVIaJ5e9cD
 Xp7cjFIB9kwrj12+7CkmA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:iCPMOUwnMGU=:56ma4IjE+C5v8tJDupanbg
 ffaWXakkoowFJced4omf+RzDDMZK7NMo9/Q1isuFrGMdxbOrbBfPNB4zVP292J9Lbze6z2vby
 06MP9oMvdo6eX2EQ+g6AyzUwrOXltJyuT/hOYV6Su2QTSINt/C4WWoqEXtdSge4uz7tfCyCfM
 NAUvMG9TLvoWOo7S8XMZgeW9VdarpO8Z6RaMpJWsAqIEFK7gKubRgL8PBHYuUNrnT6DkeHy6Y
 D2RgrNSWuI3nI0AUGGni+g0HZzWgwLC5QtKsxsQj9gSQytfqAuiY5q/RIT/0Jd5MHcv6ouf+x
 EEB3nJoKwgCYlh8Lx79x5uuRLFOQpSySmOqaD7P17FrJWT2sby0FrSqCrNx82EaFhOFk0y8B1
 eVwHci2CU8wKbf3Tt2N3rLVN+DK/ozFKAXNYPJbwcpoQRIHtcXAuCVgELFDqYsGkUa+ql2gvC
 I32A8I4uzEqukJM7Z9b+D9DNGfOl2HZvnkR/ZhmtObpEo5/pUFMfj11wTiSsTYebpdrhG8+HY
 8c/NxNufKbs+tpi1t5B/poXDjXurDqYNvg+E5zjGn8xLXJivGVlsSEEEwwvZU94xH2RO97qTk
 sd9kyb/N8K8jMfqZqEz8RnBPgNlLtXMRO04cU0ns0ZvRQbc6aumAItMheTcPj+ZUIQPfCTPWK
 oAVIFgY8NprWEIdqZfjvA01MQ2v5Zo3hXfyOGYaXQlRWV74VXSf4th8Xzis0k/650QKI8mrDK
 cQqX4kJHyT/K3IX6moEX6stv8hy4WfiXEZf8ZfqNZXgEK9idm51FpDCc6gyFKsAtIGdDb4bZ5
 uVs5sguZu62Bjex2nnONT0YwfyPyRwY1tNjMH6PcTOBj5p2/ohWqRAkR/T3GTfRVOUcCbpZ1w
 vdIHEV5oDXVh+MX6OPeA==
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

