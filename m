Return-Path: <SRS0=ECI8=3U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBC0C2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jan 2020 18:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D07A214D8
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jan 2020 18:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="euI4HSlg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IV4LZK7L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgAaSsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jan 2020 13:48:23 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:11653 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgAaSsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jan 2020 13:48:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580496504; x=1612032504;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fN1CVSHRDKEA6r0Dxq2ZalnLQH9fwSR+D/wSfwSoaU4=;
  b=euI4HSlgU6jFxk0gngkC54kuScwFhDxmiJEmUBTAow5EruEP3qRbFJa1
   ljwesZtiurpnz91xlpp9zJEgGg04IbaRy9eX/ojnzonmPL+yDsSs7OTuW
   b+W4UvkqpqM9V+j7rHubSUTfNL6phvMzz0IMLDz73cW9/4JZRZpuI/si1
   UtGCCrg4WUEy2BmrYUhnrOsFI8sjM82+mOOZGKZ4qfMxoTdQHEa8NKvPN
   jcaMJMImNMXL+Bmhl7MWCHOLLj9Kgrqj9D8VQThC+ygbzqYeH6f2q0Zxy
   jyueqoWmmXN75QoJvIrTpQUpsx2dedArEWzMLZD40sTz8TqCWKJtD4XR8
   w==;
IronPort-SDR: 9hhgxNXtVeAssR5GVS/XjFuQ+CqBGPUwwYliebSdEsson58KB0H0wDrlSErI5GlWSy5I15tGJI
 7iOvp5j0BjFBu751fJwgJgtTaWB47iQw4/Dg0MOcPVvTvRgkGMFpj8jY2tgRjdjXcAkGPxrOEQ
 f5SPVX9RWYOoJl0BBsOky7fwz6LdSVgsuXvoE/YQJSISSzrWivwTKLCqW91Fz6MxKkeoXpFE/T
 vRtY71JhJ6ouHNk43anY15HTB4h0zMoIxJK+YBxxsr1BiCpHTcb+OlD6lfHUKagtwxWOSKIk6P
 w/0=
X-IronPort-AV: E=Sophos;i="5.70,386,1574092800"; 
   d="scan'208";a="129407717"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2020 02:48:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DL6ic5zMjv+GqJeKogidT7HzRIpfTrKHo6iCQyCliXz2JoYnz4t8jsvYSoPbaQ0c+vkNLFwUVBTBcsLs6TCyGQayh2sDeP6qRiDI5/HBX1RTayV0LSY2Rk4Dydik3GrRKQzvIMgPELAk9FZ/+gueHG31KR9Q30epmx5FDwuwMtm5JOCgyY6U/qWh+Rz8JHRE8vW+Fnzr1ZKtiL+F5nwV8m15b1Um2litQEYw572nB7Fvh4Qk/K2V3Y9n15jodKXVLpxuh1OqKHi3BrjnhXU3arewI3+9SVJfEWep9cBkp9eFPwm28m2Za563EgrODyJWjZiCzP18qi0Ppzt5+wRZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xve3KMGkoYdCIcomZmbm60dhhHtqw19sglWiDXtc2go=;
 b=RGNOEwx/oPPAUgdnITbZZmuvPZBk+b6oPsDarLMdD0MEF/+LKpcftcxJIZt6DmvTrqcXoBawOfmvOTSSt8do9AuS+H01flNCMiv3A2p5+5MqSWwf4k1endCFDtqA1EX+vqcZ28ETPi7iaRsCP5UxCxqhcJ46C6DKbCcvme3MSb6O2+L/iQdk4wT8a4Im2Fpm+FZqlPr+vPgjvUOsc8HCjT7so2CfhrKGOyOjlePAIYYRIXawyrrs5DVvyDR1MNlHAvlNNWEASTXt6TMOcHWmxntsJBr/fHPKdPvegGq1EaaeoaQ1JjRZaMAqz3EWtYmUGi608KHVkDrAFbzcakPFhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xve3KMGkoYdCIcomZmbm60dhhHtqw19sglWiDXtc2go=;
 b=IV4LZK7LrYB/duVLcjF2DDaFWbsb/vHcPABaLpH4dhZ7FJFKN9iCG8BER1WQziYE8gyszS1kJEwHpIaqnUYzXOYoSmq0qyHGkd7xUXHhT+QVd6KdHemLgtXypeuCJgvYdn6S1WOEtjyi2503zgJhwd9Af+p9mqPRNHLRJeg+3ws=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5758.namprd04.prod.outlook.com (20.179.22.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.26; Fri, 31 Jan 2020 18:48:20 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::b870:3f25:f3be:535d]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::b870:3f25:f3be:535d%2]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 18:48:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH RESEND v3 4/4] scsi: ufs-mediatek: gate ref-clk during
 Auto-Hibern8
Thread-Topic: [PATCH RESEND v3 4/4] scsi: ufs-mediatek: gate ref-clk during
 Auto-Hibern8
Thread-Index: AQHV1pJJyxVd7c6bwEGDInsgF/50kKgFH/iA
Date:   Fri, 31 Jan 2020 18:48:19 +0000
Message-ID: <MN2PR04MB699108FC14777CC364522069FC070@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200129105251.12466-1-stanley.chu@mediatek.com>
 <20200129105251.12466-5-stanley.chu@mediatek.com>
In-Reply-To: <20200129105251.12466-5-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [2a00:a040:19b:4327:5d1a:58d1:eef2:f80e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a72847a0-8af7-432c-bcac-08d7a67e2438
x-ms-traffictypediagnostic: MN2PR04MB5758:
x-microsoft-antispam-prvs: <MN2PR04MB5758ACEC6457F6D1FB7AAE30FC070@MN2PR04MB5758.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:404;
x-forefront-prvs: 029976C540
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(189003)(81166006)(54906003)(316002)(71200400001)(8936002)(66476007)(8676002)(76116006)(66446008)(4326008)(66946007)(110136005)(64756008)(66556008)(81156014)(6506007)(33656002)(86362001)(52536014)(478600001)(7416002)(55016002)(4744005)(7696005)(186003)(2906002)(5660300002)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5758;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J0XgOHJGaO2zfIwGZuR+FrSpVZHNzqfL+5oJ2VBpGf95qYVvdaiiitm1ge+9o6YufzwM5BvOQhM0tm/Zqnl81HkWEIV6hk+2N9HCiQl+YQBn200BSzqW74QsR1bW+4e9kLA8Pfab8DeDbAwNFrAWkEpl0vLMumFhHnUPs920FadZYGlXUxCPsLzcNrnOZp5Bq2sgfG6FCl394wGtU/OsRe0WcQbvJlrrnNiSp4o/GGhZl+zaXT8pugbJzl6NGnkyPObFuWF9OpwGMmK6qXmca6WmZkaGf92MUlVbmXfvzkcP+cmrGvj7BtyN8gVgfSN6OB1nIpK52sgL0sH24N5dM744NeSBoT/Mmc5zH8y81wyLpG7CmlumijTKibcv2fVn7Ppm/fr7WfQ1SR7IjbEc7tEATYB2j8kKwBstrpV2FswuM64nMZIT80Ardi8yLVc8
x-ms-exchange-antispam-messagedata: 4atOS7QE1zXjzOxa9C1MUCdKUZQ05zKLV9Td55PfqKTVcJndgwQrKPXJGqlwMxf1qFxC5S8h8lNT+H9iS8zUlZFjJK9hq0/lKe99IQ8uagK5Txagj1nugaMMbnzJMngbMa3bW/Cty/eRWtCOREivm7IjRiaK42/xb6XpXt/eseUSiVuA4dxYk9vnFER3sdnJvLtp+qeoZIq9zd3S+vG3DA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a72847a0-8af7-432c-bcac-08d7a67e2438
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2020 18:48:19.8230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7TkZFSNb21E1KN30wKRYfzmzjSBK41QRzFCyz7Clax2fWZavE/9i/0MXWDfM88DOGRyDBiW7dpFlNfiv7Ic7FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5758
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> +static u32 ufs_mtk_link_get_state(struct ufs_hba *hba)
> +{
> +       u32 val;
> +
> +       ufshcd_writel(hba, 0x20, REG_UFS_DEBUG_SEL);
> +       val =3D ufshcd_readl(hba, REG_UFS_PROBE);
> +       val =3D val >> 28;
> +
> +       return val;
> +}
A little bit strange that you are relying on debug registers to setup your =
ref-clock.
Is this this debug info is always available?

Thanks,
Avri
