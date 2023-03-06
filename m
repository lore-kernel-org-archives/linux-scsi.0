Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA12C678D4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 17:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCFRAZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 12:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjCFRAY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 12:00:24 -0500
Received: from amity.mint.lgbt (vmi888983.contaboserver.net [149.102.157.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7F1AD06
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 09:00:05 -0800 (PST)
Received: from amity.mint.lgbt (mx.mint.lgbt [127.0.0.1])
        by amity.mint.lgbt (Postfix) with ESMTP id 4PVl5h4gvQz1S5KG
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 11:53:44 -0500 (EST)
Authentication-Results: amity.mint.lgbt (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=mint.lgbt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mint.lgbt; h=
        content-transfer-encoding:mime-version:references:in-reply-to
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1678121623;
         x=1678985624; bh=XBMOf7rDZmk1/gq6Hnv29VSjIdHlkH5Ie/sn9RbtUDE=; b=
        BRVzbO6l6vt57Zy7gxI2a2W2Q01HjeY2T9jvQuvCr+ePNsDE6y1YlZxSL2i5UY4Q
        NUqQ6rpVzZbWAoO4OxtMzVHBnGAYFx6PwXRG6dT6xAf9BDOTkNlFrzKFp0d2RS+5
        I0+bFpClxhKAk6y65uuPC+qfARRexUAQIi8o8eTAlEL4ESl3ogBxXbvjaxQ2PdKI
        gOM2XJg8CDdudNhInf+gXKrIj5uEIfYSRgzmcLK6SKCOLWo7uSpy938HyE/B2Hzk
        TaV2j1dtVn7iC6q2GhnkrT0uOogKpM5VFePpUsjyTaBbeKp3ltfutbKHudysiGdK
        v6lhQnakrZAHB4q90d1gQw==
X-Virus-Scanned: amavisd-new at amity.mint.lgbt
Received: from amity.mint.lgbt ([127.0.0.1])
        by amity.mint.lgbt (amity.mint.lgbt [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id q31KMzMfr5Ze for <linux-scsi@vger.kernel.org>;
        Mon,  6 Mar 2023 11:53:43 -0500 (EST)
Received: from dorothy.. (unknown [186.105.8.42])
        by amity.mint.lgbt (Postfix) with ESMTPSA id 4PVl5R43X3z1S4vb;
        Mon,  6 Mar 2023 11:53:31 -0500 (EST)
From:   Lux Aliaga <they@mint.lgbt>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, kishon@kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, keescook@chromium.org,
        tony.luck@intel.com, gpiccoli@igalia.com
Cc:     ~postmarketos/upstreaming@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        phone-devel@vger.kernel.org, martin.botka@somainline.org,
        marijn.suijten@somainline.org, Lux Aliaga <they@mint.lgbt>
Subject: [PATCH v7 3/6] phy: qcom-qmp: Add SM6125 UFS PHY support
Date:   Mon,  6 Mar 2023 13:52:42 -0300
Message-Id: <20230306165246.14782-4-they@mint.lgbt>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306165246.14782-1-they@mint.lgbt>
References: <20230306165246.14782-1-they@mint.lgbt>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SM6125 UFS PHY is compatible with the one from SM6115. Add a
compatible for it and modify the config from SM6115 to make them
compatible with the SC8280XP binding

Signed-off-by: Lux Aliaga <they@mint.lgbt>
Reviewed-by: Martin Botka <martin.botka@somainline.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualco=
mm/phy-qcom-qmp-ufs.c
index 318eea35b972..44c29fdfc551 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -620,6 +620,13 @@ static const char * const qmp_phy_vreg_l[] =3D {
 	"vdda-phy", "vdda-pll",
 };
=20
+static const struct qmp_ufs_offsets qmp_ufs_offsets_v3_660 =3D {
+	.serdes		=3D 0,
+	.pcs		=3D 0xc00,
+	.tx		=3D 0x400,
+	.rx		=3D 0x600,
+};
+
 static const struct qmp_ufs_offsets qmp_ufs_offsets_v5 =3D {
 	.serdes		=3D 0,
 	.pcs		=3D 0xc00,
@@ -693,6 +700,8 @@ static const struct qmp_phy_cfg sdm845_ufsphy_cfg =3D=
 {
 static const struct qmp_phy_cfg sm6115_ufsphy_cfg =3D {
 	.lanes			=3D 1,
=20
+	.offsets		=3D &qmp_ufs_offsets_v3_660,
+
 	.serdes_tbl		=3D sm6115_ufsphy_serdes_tbl,
 	.serdes_tbl_num		=3D ARRAY_SIZE(sm6115_ufsphy_serdes_tbl),
 	.tx_tbl			=3D sm6115_ufsphy_tx_tbl,
@@ -1172,6 +1181,9 @@ static const struct of_device_id qmp_ufs_of_match_t=
able[] =3D {
 	}, {
 		.compatible =3D "qcom,sm6115-qmp-ufs-phy",
 		.data =3D &sm6115_ufsphy_cfg,
+	}, {
+		.compatible =3D "qcom,sm6125-qmp-ufs-phy",
+		.data =3D &sm6115_ufsphy_cfg,
 	}, {
 		.compatible =3D "qcom,sm6350-qmp-ufs-phy",
 		.data =3D &sdm845_ufsphy_cfg,
--=20
2.39.2

