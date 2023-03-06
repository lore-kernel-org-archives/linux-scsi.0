Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D76C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 16:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjCFQzX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 11:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCFQzW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 11:55:22 -0500
Received: from amity.mint.lgbt (vmi888983.contaboserver.net [149.102.157.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15B5273E
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 08:54:49 -0800 (PST)
Received: from amity.mint.lgbt (mx.mint.lgbt [127.0.0.1])
        by amity.mint.lgbt (Postfix) with ESMTP id 4PVl5B3WDxz1S5Jl
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 11:53:18 -0500 (EST)
Authentication-Results: amity.mint.lgbt (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=mint.lgbt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mint.lgbt; h=
        content-transfer-encoding:mime-version:x-mailer:message-id:date
        :subject:to:from; s=dkim; t=1678121597; x=1678985598; bh=uK+glyg
        nD/QeqUlfo72/hfCeJTh8hcZKk6WDctNDr6Q=; b=b+J/bASLsMbh6bwPjrsJ3td
        I5rkUH3avv4orgcdkrQoc5o55AfTI4IiPNGBxeE57PeBwQ8zjQROhXIB/Ky+BLq9
        PT3+iGUheM2PldP/+TPyIF48pTCJKpB7eYMOuri5w0qu7bPOjHZqC+uCG1cfjk1t
        0uOyZzFrEv3SY9hhERB2RCuALzdzMofO/5RAJ3r/JoN/5/26zmZfoJS+oaJ8OXTH
        HVD7rJTV+Es7KPAq827GqZDu8xmm5IufdxoAa0mq5GE5HSP287gzxb4Pgh+ps35U
        D3iXmMWqQxH/56Fe9LFOajWkJeZdGjtHnBC3U7RWow36fCZ0FNfGOFhjeCnmXxw=
        =
X-Virus-Scanned: amavisd-new at amity.mint.lgbt
Received: from amity.mint.lgbt ([127.0.0.1])
        by amity.mint.lgbt (amity.mint.lgbt [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id U-CEcER3NOKx for <linux-scsi@vger.kernel.org>;
        Mon,  6 Mar 2023 11:53:17 -0500 (EST)
Received: from dorothy.. (unknown [186.105.8.42])
        by amity.mint.lgbt (Postfix) with ESMTPSA id 4PVl4p1NzFz1S4vb;
        Mon,  6 Mar 2023 11:52:57 -0500 (EST)
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
        marijn.suijten@somainline.org
Subject: 
Date:   Mon,  6 Mar 2023 13:52:39 -0300
Message-Id: <20230306165246.14782-1-they@mint.lgbt>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce Universal Flash Storage support on SM6125 and add support for t=
he Xiaomi Mi A3 based on the former platform.

Changes since v6:
- Add struct for v3-660 UFS PHY offsets and modify sm6115 UFS PHY to use =
it
- Set ufs_mem_phy reg size to 0xdb8 in sm6125.dtsi
- Drop "#address-cells" and "#size-cells" properties on reserved-memory n=
ode in xiaomi-laurel-sprout dts
- Move "status" last on &pon_resin node in xiaomi-laurel-sprout dts
- Modify "&pm6125_gpio" pointer to "&pm6125_gpios" in xiaomi-laurel-sprou=
t dts

v6: https://lore.kernel.org/linux-devicetree/20230108195336.388349-1-they=
@mint.lgbt/
v5: https://lore.kernel.org/linux-devicetree/20221231222420.75233-2-they@=
mint.lgbt/



