Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B23C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B75366101B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240654AbhJGIOI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42975 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240655AbhJGIOC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:02 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211007081207epoutp012cdd2d24e46283652bc3b22e0fba52d0~rsWLN2J5L1750617506epoutp01Y
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211007081207epoutp012cdd2d24e46283652bc3b22e0fba52d0~rsWLN2J5L1750617506epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594327;
        bh=t/9mBeUsO1xUWp/zitagz5WuQKnzCN8nu+EQOn2Ef5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBZxUNsnp1njNlvDBKhrWLwdWRk99Mdetq8nGpkzT+7daCKQiU496HhJryMSzx21r
         miI12TrVtrYEz4jchEQkeU2xfmmNI75G3K/gRcI/O8UIpZ7djU+Q6jJY6SIdiQJCP8
         yGi9N0wu8eidNY+JF/RsBcHiv/PWqgOPziJLaM+I=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211007081151epcas2p1d89c0a07a20723e833837ad9d531921e~rsV8Y7Nvs1039810398epcas2p1j;
        Thu,  7 Oct 2021 08:11:51 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.91]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HQ3v92wW8z4x9Qp; Thu,  7 Oct
        2021 08:11:49 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.A8.09816.EBBAE516; Thu,  7 Oct 2021 17:11:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epcas2p46aebdd54f2e5263e0662a1adbd93613a~rsVsQ1Doj2630826308epcas2p4d;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211007081134epsmtrp18c307f91ede5690a42479021d164e438~rsVsPowq52192321923epsmtrp1p;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-19-615eabbea015
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.63.09091.6BBAE516; Thu,  7 Oct 2021 17:11:34 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epsmtip25550194b305a099ae822af4ad86216fd~rsVr-KwOD0435204352epsmtip2j;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 06/16] scsi: ufs: ufs-exynos: add setup_clocks callback
Date:   Thu,  7 Oct 2021 17:09:24 +0900
Message-Id: <20211007080934.108804-7-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzOuff2tjjBa8XtjMTZ1RACCLYNpRdCwQ1GboQ55px7heEN3FBS
        +rCPZbDF1JFWHoPhY6B1oIBDLBIcFgQmWAsG8RFhMCZky8QBG2RlQON4GMpaLtv87/t9v+87
        v/OdBw/lP8GDeDlqA6NT07lCfBPW1hMqi+hu/JgWFZlfIPsnruDk4+o2nJxe/hEnb40XYWTF
        3DJKLjTXc8ihm+Hklx2J5L3yWoScaLaiZO2jNoR8tGLhkN+5lhBy1H4bI8887EbIkp/acfJS
        nwchny07kb18amg4hbKaSnFqqKwUoa41hFF1N6YRqsVWhFPltQ5ALTYX4tT85BhGldltgHK3
        vEIdd5QgaZs/VMYpGDqL0QkYdaYmK0edLRemvJORmCGNFokjxDGkTChQ0ypGLkxKTYtIzsn1
        hhMKPqFzjV4qjdbrhXvi43Qao4ERKDR6g1zIaLNytTJtpJ5W6Y3q7Eg1Y4gVi0QSqVd4WKnw
        OBK1Y1s/XbM5OSawFlAM/HiQiII/Dz/FisEmHp9oB7BnoZrDFgsAnrFUImzxN4DOGTsoBrx1
        S8HKFpbvAnDYcWxDNA/g4tPLwLcuTkRA++8zwNcIJP4CcOK301xfgRKTKKxeKsV9qm3EPnh5
        3oz4MEYEQ0vzPdSH/YkEONA6xWV3uBP2rhSt837EXnijswlnNVth/9kJzIdRr6ag9RzqGwCJ
        P3iwauTWhjkJWkc7URZvgzN99g0+CE5/ZeGyhhIAzU/WNhqNABYdS2VxAlyptHN8oVEiFDZ3
        7mHz74K9YxtzA2BhzyqXpf1hoYXPGkOg43olxuIdsOQbN4eVUPCuO4Y9rFMAfnFpiFMOBNbn
        0lifS2P9f+4FgNrAi4xWr8pm9BKt5L8bztSoWsD6Yw9LbgenXXORToDwgBNAHioM9NckpNN8
        /yw6L5/RaTJ0xlxG7wRS71mfQIO2Z2q8v0VtyBBHxYiioqPFMolUJBO+5F/leZ3mE9m0gVEy
        jJbR/etDeH5BJqSr+7MFaW1Zb87VKrMiP4SeNd+Xm0f39w1/fTShwsB8a3ywXdqz+e771prr
        gWcfy1uKDyAN4VcyP8o8FM/VBTedCw2JHa+gTwryrHnxr3GVIRZ3nNL1qrZ49Y76pvXOs/rd
        I1JJIzj03v7UlA/6NZqO0JCaEcHFqVkSV+x+uXfu7bpp5RF5+g+fq7qC3pXelvWdcilORmKe
        1UVenMjqZzOONF0TB+yMdXVvmbXtMKhMU+Wqg738ul++j/gz29W+6/ibV02DnDrlUsF47P2U
        833hoEPlaR2UYkdDD9Y/DHAXJj+YPtIgDr44MHnYLy8pstMhzz9Q82u63CJ5a1/BGwODQkyv
        oMVhqE5P/wODVTJddQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSvO621XGJBv82sFmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsnqyfxWyx6MY2Josbv9pYLTa+
        /cFkcXPLURaLGef3MVl0X9/BZrH8+D8mi98/DzE5CHlcvuLtMauhl83jcl8vk8fmFVoei/e8
        ZPLYtKqTzWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRHHZpKTmZJalFunbJXBl
        /DvgXHBLsOL/qkOsDYz/+boYOTgkBEwkmn/xdzFycQgJ7GaUWHlyLlsXIydQXFbi2bsd7BC2
        sMT9liOsEEXvGSX+fJ/GCJJgE9CV2PL8FZgtIvCRUWLONy2QImaBj8wSd1YuYQFJCAt4Saz8
        2MoEYrMIqEq0rT/NDGLzCthLXNj6DGqDvMSRX51gcU4BB4k9u9aygVwnBFTT9TcSolxQ4uTM
        J2AjmYHKm7fOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjB
        8aeluYNx+6oPeocYmTgYDzFKcDArifDm28cmCvGmJFZWpRblxxeV5qQWH2KU5mBREue90HUy
        XkggPbEkNTs1tSC1CCbLxMEp1cA0lbvoUNo847vh8avLr0RvSb7xQkKZvfOpms7Fj80cEROq
        o1h7I+fM+Vjxb//pG6n2r49bul3eaWQvwcQ7/cChRV2xLsYlZ7Iiuq+pe89xbjVUshXYU1F6
        oWK65JKwSzZNP57em+Gn+n/rvhiJbKkD921rNWZv8XCKNbkXJKnPuKlLYPfhqfuelG6dVfnz
        Y/6C8urPy+7K9PpEmrtnT3B+Wvlu7oa6QyvzQ7jqIkWmB0vdzVrdsEBr9tWZEg90y8qYa18K
        ep16k3biUcgW8Zs6vz7dfX72uzDL/rIX0h+WCq66oFxhYi2jmz/nATvDpB83ZEUUefJEruhY
        vVjlMH03y/R8pW72oi/1z4oCpHyVWIozEg21mIuKEwEQa0DgLgMAAA==
X-CMS-MailID: 20211007081134epcas2p46aebdd54f2e5263e0662a1adbd93613a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p46aebdd54f2e5263e0662a1adbd93613a
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p46aebdd54f2e5263e0662a1adbd93613a@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds setup_clocks callback to control/gate clocks by ufshcd.
To avoid calling before initialization, it needs to check whether ufs is
null or not and call it initially from pre_link callback.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 37a4ab4cc662..e800fb9e1ce4 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -794,6 +794,27 @@ static void exynos_ufs_config_intr(struct exynos_ufs *ufs, u32 errs, u8 index)
 	}
 }
 
+static int exynos_ufs_setup_clocks(struct ufs_hba *hba, bool on,
+				   enum ufs_notify_change_status status)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	if (!ufs)
+		return 0;
+
+	if (on && status == PRE_CHANGE) {
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_disable_auto_ctrl_hcc(ufs);
+		exynos_ufs_ungate_clks(ufs);
+	} else if (!on && status == POST_CHANGE) {
+		exynos_ufs_gate_clks(ufs);
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+	}
+
+	return 0;
+}
+
 static int exynos_ufs_pre_link(struct ufs_hba *hba)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
@@ -812,6 +833,8 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 	exynos_ufs_config_phy_time_attr(ufs);
 	exynos_ufs_config_phy_cap_attr(ufs);
 
+	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
+
 	if (ufs->drv_data->pre_link)
 		ufs->drv_data->pre_link(ufs);
 
@@ -1198,6 +1221,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hce_enable_notify		= exynos_ufs_hce_enable_notify,
 	.link_startup_notify		= exynos_ufs_link_startup_notify,
 	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
+	.setup_clocks			= exynos_ufs_setup_clocks,
 	.setup_xfer_req			= exynos_ufs_specify_nexus_t_xfer_req,
 	.setup_task_mgmt		= exynos_ufs_specify_nexus_t_tm_req,
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
-- 
2.33.0

