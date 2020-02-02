Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B4FC35240
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53020206D3
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rX5MtnkR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgBBHmE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 02:42:04 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6569 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgBBHmE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 02:42:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580629323; x=1612165323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=tS/zpN89ukOZa4e+YcelECEdpkMXtQtYyDQ8RTM+CYs=;
  b=rX5MtnkRMHRXIwEn5xHjZ1S4qC3fxevtSOYlC6KO0M/W5Qx6vIBdtVJ6
   5MdDv3ajSEi5E/3O+CAwOW+6CaNeKZYGWraq/mvIAcBjc7u6gav/ABbvd
   zmEUADR+rGm6z88TXQepUyNTXV7ZhCJ5HONdLzMSaV1fzQXMAA2Nu8XHp
   jMYq2Fv0RvBXZnpa8fAmb6mnqFMyQlBzbOn9WQVy+5N9HjYyg49s8yWVW
   LdoXv3yZjjYJZuOZc5Rlg0MTsGu8ImY3BxmnxDBPw96zaMdP6jrNkNtrQ
   YMLAQtoYvi0jDpRaN383FO7LN0726zKbtC8KOVigcXUC3mgi/MxX75p0M
   A==;
IronPort-SDR: Gjc9tCTlNudzYc9hOnzbTqAjeDzs7IiUwGs0Wrz+9O9m4Uf6+9MsMYqQxlZMN/wRmbc38Dquh6
 9pEcr+AxNAqF9ggX2H87+AKGGHOavaCElt+8aC8vuoPKhczqx7HvpMX7M9JyItmI6ggbWDfGxH
 6hlcM89UKcxZi4A76kwhBKDYzvq3brI56WxtafjDQOpa5s+5SJGcuGYZYb6b/223hfH+CXvSIH
 pIwIh3Wf4IknfT3+11Fbo/tO18jWERXuitGfX8OAvnfR0IyMu8hM69L7swxCk1XP6ETzv1N7H2
 R3A=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="130383378"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 15:42:03 +0800
IronPort-SDR: bxmnbggNot3gHffxN3HR0fChifAST/0gakBuznbzSGA88fyBHr9RvhMxWZtJb0mdnYdA5hJITM
 WdCJyrtef8q3+zsZu47hxlNu411ZlPoe7M0QZgzjadp177zUavO1aSkXlfW/GoYeXyiFz9vU9x
 l1EeTzzlaZmw76YuXV9/Z5u6I1OkbMKJTL/zjLfx+Z66MfWsljzAjDvrCaHgHr3sb2oQJB89IM
 n2Sx3MuzUyeW26DAUOFztQ4zJLl3QXiaxsY3tlDLv+VKtAdfY8FMvboF1QH2alYlYNyT3s0xa/
 mCqnYpdYMDMiF1qvAEGsXJA0
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 23:35:10 -0800
IronPort-SDR: Ty/bDUXdKqVqms2jNwOyl5ZdRjKsJjPyR2HoRdTIXp4YL5qFQcDablti20COwmhDSeHT+YZetl
 ipjBmE+hOFpSMMxBdZLXIpMsYze/2FcCqB/Z/+CpdZdTiqM2ap1AYKvYqUDAOOKx8cK5hwBFSt
 2CDAWKb6a+0QCIhr0O0jyB8lTRWmmZeVR0MM03S7igloGp4RH+naykWUHCnpYdikOjug/605tO
 xaMUKKoqGHBlhT4YFQUyxNVRGxJ0246h5vLju5IUdc0WPbxoyBXtQqJ4o5OObQkhkoikuysDIi
 AtQ=
WDCIronportException: Internal
Received: from kfae419068.sdcorp.global.sandisk.com ([10.0.231.195])
  by uls-op-cesaip02.wdc.com with ESMTP; 01 Feb 2020 23:42:01 -0800
From:   Avi Shchislowski <avi.shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Avi Shchislowski <avi.shchislowski@sandisk.com>,
        Uri Yanai <uri.yanai@wdc.com>
Subject: [PATCH 2/5] scsi: ufs: export ufshcd_enable_ee
Date:   Sun,  2 Feb 2020 09:41:50 +0200
Message-Id: <1580629313-20078-3-git-send-email-avi.shchislowski@wdc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1580629313-20078-1-git-send-email-avi.shchislowski@wdc.com>
References: <1580629313-20078-1-git-send-email-avi.shchislowski@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Avi Shchislowski <avi.shchislowski@sandisk.com>

export ufshcd_enable_ee so that other modules can use it. this will
come handy in the next patch where we will need it to enable thermal
support

Signed-off-by: Uri Yanai <uri.yanai@wdc.com>
Signed-off-by: Avi Shchislowski <avi.shchislowski@sandisk.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshcd.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 099d2de..f25b93c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4923,7 +4923,7 @@ static int ufshcd_disable_ee(struct ufs_hba *hba, u16 mask)
  *
  * Returns zero on success, non-zero error value on failure.
  */
-static int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
+int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
 {
 	int err = 0;
 	u32 val;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 28c0063..6d2a5fd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -960,6 +960,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
+int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
1.9.1

