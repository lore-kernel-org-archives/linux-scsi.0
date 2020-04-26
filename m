Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B282C55199
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C1420A8B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 17:42:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gDD9DuF3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDZRmM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 13:42:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33746 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgDZRmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 13:42:11 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200426174207epoutp039c107b694468d060f355ea5a95e5802b~Jb31Q1Ww10343203432epoutp03c
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:42:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200426174207epoutp039c107b694468d060f355ea5a95e5802b~Jb31Q1Ww10343203432epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587922927;
        bh=HK/1/VP5ov7EOoNpQ0X08DtlhI52O+2EyAZ3cTvlQkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDD9DuF3h5DKjYXD9Fv7hDpFLAkplAHCIIuqPic0lDC8ppoEZdKT0qBgGr4hu+SuD
         8Qxo13CjMIbwyQyIXI0gUMeuXNq8ayQO5L/pRQ4cAub6uqJe7ADjEF97QEdtyJth1c
         2yl/814ECQOSqOf9USWGOfMOX5cEp40wvpiTNRXU=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200426174206epcas5p45d98aa69c0a3ec15204b0bb33ece54e6~Jb3z8cphO2672326723epcas5p4U;
        Sun, 26 Apr 2020 17:42:06 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0F.13.10083.EE7C5AE5; Mon, 27 Apr 2020 02:42:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200426174204epcas5p24796abe49298815cff344fba2e067169~Jb3yukotj0053600536epcas5p2c;
        Sun, 26 Apr 2020 17:42:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200426174204epsmtrp10e5c790ec6d05b3b23c26adff7a88c98~Jb3yqSRah0798907989epsmtrp1Q;
        Sun, 26 Apr 2020 17:42:04 +0000 (GMT)
X-AuditID: b6c32a4a-875ff70000002763-76-5ea5c7ee3eba
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.FF.18461.CE7C5AE5; Mon, 27 Apr 2020 02:42:04 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200426174202epsmtip1ea4f6fe09ac532bc666ce69b98cdbc0b~Jb3wxjaqe2817828178epsmtip1I;
        Sun, 26 Apr 2020 17:42:02 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v7 01/10] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Date:   Sun, 26 Apr 2020 23:00:15 +0530
Message-Id: <20200426173024.63069-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426173024.63069-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSbUhTYRTHe+7brtatyzR6UsxY+MGFWlZwCU0/WNwisKig0rSRNyc6Hbu6
        1IKWylKXpkFqNadkm6mhNqeuLVN0OnpBrTnTIDAqSA3fAkmiF+ed9O13zvn/z/nz8JCouBIP
        INMyszlVpixDQvhiXQOh0rA5pzFpT1/7RmbK0EUw0ytugllqM+FMnWMYZ0ZG2kXMpGUQY8yf
        x3HGZdMTTM3IC4TRvbcSTKPzD8L8fW4VMcbOSRBLsa7yMoQ1N5cQbMej62zRy16MXfz6AWPL
        Lc2A/WHewd7s0yEnyPO+USlcRpqaU0Ucuugr/zb4BFPa6dzeBSeqAbNUKfAhIb0ftrQWikqB
        Lymm7QDOzLcCoVgC0Fow6C2WAWyeqBOtW35Wur2WHgCn9XZUKIoQWDXfSHhUBL0bfqy2IB72
        p/2gY1kLPIzSEwicaorzsB99GvYU165txegQqK02rDFFR0HH2BtcuBYMW9r7UA/70NHwVY0N
        8RyDdAkJx0c/eSPFwaF3c4TAfnDGafH2A+D0be0qk6ucDm/Z9gnta9BoGMIEjoF9Y3rMI0Hp
        UNhmixBiboZlv74ggpOCxVqxoA6BhXNurzMQVup03pQsbNJNed+kAsDi6kZQAYLu/99aD0Az
        2M4peUUqxx9QRmZyV8J5mYLPyUwNv5SlMIO1jyI9ZgWm4eP9gCaBZBNFdhuTxLhMzecp+gEk
        UYk/lZj9MElMpcjy8jlVVrIqJ4Pj+0EgiUm2UXdwd6KYTpVlc+kcp+RU61OE9AnQgIENm0U2
        d0Kiy1xvLLvajQf9BnEGTfLjqty7YQm7CDJ9fierD3cptiiTG9Rq7fd8LMax9WnB5ZWTGvsD
        c+TryaMHG0Smc9mj/A3lQk68Tl5jkUblvp2Nz+8eUD27sBjc2x9QG33EVJuX5SYwedfZzokz
        99DYSnrZ0nKYP9UhwXi5bK8UVfGyf2J1nAMkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSnO6b40vjDP7t0LN4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGS+OrmEp2C1Qsf/DceYGxte8XYycHBICJhI/Jl5l72Lk4hAS2M0ocf3LSyaI
        hLTE9Y0T2CFsYYmV/55DFTUxSbyZsRIswSagLXF3+hawBhGgoiPf2hhBbGaBZ0wSpx6WgtjC
        AkESZz9tZgOxWQRUJdqmzwPr5RWwkThy5QwrxAJ5idUbDjCD2JwCthKnZuwCmskBtMxGYvp6
        /wmMfAsYGVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgQHs5bmDsbtqz7oHWJk4mA8
        xCjBwawkwhtTsihOiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+NwoVxQgLpiSWp2ampBalFMFkm
        Dk6pBqbJX2O42f7dUTvLrRYanOBdxNCewXV5+gfe5anS6pOm2hpyH1XTT041e8jHs6lCVeXZ
        xI9TD+bu4DTPWPfml8lU/6PV9eu3GldpqgTFr5h29Z7K7q6dgSfeHzzx50rP3px3zBt1n35y
        Zr3cltW+I9jmWKXB0U92d5tWH43bu6l22m5/Aw79rdMqHWdO/+Jw7pfJ/I279Da5+O/h4Lt+
        gF19m51uxIWKPAX5Nb/T3X/oTWBmYlC6/G7/6rgTRov3Bm4Vi31q1SU4YXV6/TeblwYvrO/x
        tjYmxBuEi+xfy3jm5vktj98t4z80J+zpy528gToyB9fcl5nH5f315pLb7H42XmsVjy2o1b9Z
        fcEtewOPEktxRqKhFnNRcSIAt0D+aNUCAAA=
X-CMS-MailID: 20200426174204epcas5p24796abe49298815cff344fba2e067169
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174204epcas5p24796abe49298815cff344fba2e067169
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174204epcas5p24796abe49298815cff344fba2e067169@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the right behavior, setting the bit to '0' indicates clear and '1'
indicates no change. If host controller handles this the other way,
UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR can be used.

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++--
 drivers/scsi/ufs/ufshcd.h |  5 +++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 698e8d20b4ba..3655b88fc862 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -645,7 +645,11 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
  */
 static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos),
+				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -655,7 +659,10 @@ static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
  */
 static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6ffc08ad85f6..071f0edf3f64 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -518,6 +518,11 @@ enum ufshcd_quirks {
 	 * ops (get_ufs_hci_version) to get the correct version.
 	 */
 	UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		= 1 << 5,
+
+	/*
+	 * Clear handling for transfer/task request list is just opposite.
+	 */
+	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

