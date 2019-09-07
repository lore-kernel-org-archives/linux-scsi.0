Return-Path: <SRS0=mW7r=XC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACECC43140
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 12:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4F54218AC
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 12:37:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="RnUi+SKW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392081AbfIGMh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Sep 2019 08:37:28 -0400
Received: from mout.web.de ([212.227.17.11]:33143 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731870AbfIGMh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 7 Sep 2019 08:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1567859793;
        bh=PSaXtgJwZd1CREWlBeOAL7J9z8nB0xiLbtFGD4xfehg=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=RnUi+SKWOZtSlr0mk9oIdV6GDmV2xrIKq7vIdyW0CX2LMWYKpCwIbucjuwpt4hpCJ
         YN/SJh6p454BNwbAG20ttRaBcN20ZBqx2gpFNigZp2TI8+WK1C17Ksirouv+JYGTWm
         jqHzkYbjdHga/kxEywPwXzGe1FXeyTRX3hX5llZA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.16.142]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MK24P-1i7Otx3PmP-001SEO; Sat, 07
 Sep 2019 14:36:32 +0200
To:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Allison Randal <allison@lohutok.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Avri Altman <avri.altman@wdc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Kangjie Lu <kjlu@umn.edu>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Li <liwei213@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] scsi: ufs-hisi: Use PTR_ERR_OR_ZERO() in
 ufs_hisi_get_resource()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <9e667f19-434e-ed30-78cb-9ddc6323c51e@web.de>
Date:   Sat, 7 Sep 2019 14:36:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cNHpQ+jeTfGeWICOYA7wmoDby9yvgIX7UhM/m3fSlfN7oMw/2ym
 ilwADzk5hP655UAnuaAmIrKzAEh2HBl+GrPSYAjucFFtWt2aDAbXkNtnX+VhtoXbSwQls8o
 uEnrVc0p+jCAaITPlmhPCYBYZKaXH9vanin3blftx93cOqNpCh1dlEimmG8Y97e7K07Zhtj
 9ZqNT0He5LjDkd+NW5e6g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jAwdniN09rM=:0lOI9WIzG8hBLi9MmX3NSa
 xbps9oevGfM1rgQXm+xJYs3zEXrjXqa7Ru7/aM8oZbVH6I8sCgXO1EHe8CCHbFg+HXapuhKid
 RhZ94fyNCkaHlazVq3rYLyO8pcSUsrdxq/4vvTOZwoaBHIvP+wkB5tgf9Wa4tronZtX0n471Z
 +gQ7PmZIZBtrZ4RbtZal+tx38W61gw9CVppchmouFVxJFjtsOQI3GLIgO8I8vcBBgMOCWDxRK
 fAG4PXOfRG23ILLcT2JKRCXWYqlY7llxVb9sMTHB5Vdt6ZXUHW2R/bGbxeYC4mX1GRq0PQEfY
 +JOZx4CjKiyxXYL0hO+OGeNWtLUKu3zOSyq1iYEQfNRoFqtZ+ck1zQNdnrj66d46FPE/xYuST
 cbd2z7wEoj+b0QQz4hc+bIRy7xEOYPk1amfRg58muKNIMx3LEeCAXnnKbBKODdCqC8E6I+MbE
 KsdU+QVtn/W3P8HK+5CPbQOuI5qvshZ+/OIrnxkhy2JAEwyuuMlEjMxtwj1VCX9NJLIvfXy9U
 PKCa+fCCHAo7W143I1SwdXJuEn29XJ57T8X6Jx5EYwmTFWwOJvSylu2Mz6TMmbWXa3uBFOzgF
 1Jgts0C2ntx9pN541r3DJvHinpeH4yWrBw97NOvfV/5XNQ2FA5HJVxJbzmxhEzvhOwmUaOCpT
 8A2dcbpq9JLrSg+IoV0UQ2x4fAdH783PTCqrwyBBqbY1gmmR6n266sXrbGPpyzrl9J16oMmDu
 vkTYD36RWZTgiw0/tvH6IbPbPPBGn6evG37l37uYXz8+Nrim/0psKHu+Nez02gY5IvAHAGfDr
 vfRlpXci73AfhdrNG8fKfihHth3vLDdSEcRIVYAjFvDpb/vUOsgk4LczOtXp6sQnZ5ucXGejt
 g+0ORVJ4G6bYqCrJMqP1BQKilB9T85N3bTkGKPT2uedFy0CfPeI+lnx/mZ5xIX7z6eZGd/k0b
 UjXDcR/rITzSLf8c2fErsmBYs40zjF5SxeNYGQGO1T6Nc3wBSvKHNI29T7Choi37CtP+R2ZCm
 +s3y2KToIRJa4foNAgcg7Ur8Kdjmq2SQcUE+3lKQSUXyKW/E7SdO99F6SsimhU6/Ts6SqbT8o
 xG411pYVzOiZ+p5jbxAMRPkP/bVK44/tX3RY6sLNZJVe3lfBDzI3iAFhBKf+P6f5mIcIumGH2
 6wqKHg2ZmZD1NwA5GQwmowZKJcNvFc+4+WjPlUI6v4Dft+nTVJ3095NqDgFgGVJsRAJQWb/lH
 JYjNJ+9LOa3z0RWhN
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 7 Sep 2019 14:25:31 +0200

Simplify this function implementation by using a known function.

Generated by: scripts/coccinelle/api/ptr_ret.cocci

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/scsi/ufs/ufs-hisi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index f4d1dca962c4..a0ea57c19dbc 100644
=2D-- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -454,10 +454,7 @@ static int ufs_hisi_get_resource(struct ufs_hisi_host=
 *host)
 	/* get resource of ufs sys ctrl */
 	mem_res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	host->ufs_sys_ctrl =3D devm_ioremap_resource(dev, mem_res);
-	if (IS_ERR(host->ufs_sys_ctrl))
-		return PTR_ERR(host->ufs_sys_ctrl);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(host->ufs_sys_ctrl);
 }

 static void ufs_hisi_set_pm_lvl(struct ufs_hba *hba)
=2D-
2.23.0

