Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314C2C18E5B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05C3E20658
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 03:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgCPDwd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 23:52:33 -0400
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:59509 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgCPDwd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2020 23:52:33 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Mar 2020 23:52:33 EDT
Received: from localhost.localdomain (unknown [58.251.74.226])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id E3695663D0F;
        Mon, 16 Mar 2020 11:46:37 +0800 (CST)
From:   Zheng Wei <wei.zheng@vivo.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hanjun Guo <guohanjun@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yunfeng Ye <yeyunfeng@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     kernel@vivo.com, wenhu.wang@vivo.com,
        Zheng Wei <wei.zheng@vivo.com>
Subject: [PATCH v2,RESEND] scsi/ipr: fix wrong __VA_ARGS__ usage
Date:   Mon, 16 Mar 2020 11:46:29 +0800
Message-Id: <20200316034631.126018-1-wei.zheng@vivo.com>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZTlVLSE9CQkJDT0xPSklKSllXWShZQU
        hPN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nio6Pzo6Kjg4GjcrQwkVKBoS
        OToaC0hVSlVKTkNPSEhLSEJDTUNCVTMWGhIXVQweElUBEx4VHDsNEg0UVRgUFkVZV1kSC1lBWU5D
        VUlOSlVMT1VJSU1ZV1kIAVlBSU1NSDcG
X-HM-Tid: 0a70e1735b759373kuwse3695663d0f
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ipr_hcam_err uses __VA_ARGS__ without "##" prefix, 
it causes a build error when there is no variable arguments.

Signed-off-by: Zheng Wei <wei.zheng@vivo.com>
---

changelog
v1 -> v2
 - resend for the failure of delivery to some recipients.

 drivers/scsi/ipr.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index b97aa9ac2ffe..de3401972354 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1813,14 +1813,14 @@ struct ipr_ucode_image_header {
 					hostrcb->hcam.u.error64.fd_res_path, \
 					hostrcb->rp_buffer,		\
 					sizeof(hostrcb->rp_buffer)),	\
-				__VA_ARGS__);				\
+				##__VA_ARGS__);				\
 		} else {						\
 			ipr_ra_err((hostrcb)->ioa_cfg,			\
 				(hostrcb)->hcam.u.error.fd_res_addr,	\
-				fmt, __VA_ARGS__);			\
+				fmt, ##__VA_ARGS__);			\
 		}							\
 	} else {							\
-		dev_err(&(hostrcb)->ioa_cfg->pdev->dev, fmt, __VA_ARGS__); \
+		dev_err(&(hostrcb)->ioa_cfg->pdev->dev, fmt, ##__VA_ARGS__); \
 	}								\
 }
 
-- 
2.17.1

