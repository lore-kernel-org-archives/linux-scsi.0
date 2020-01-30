Return-Path: <SRS0=Owrj=3T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60DEC35240
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 17:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F07A2083E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 17:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="FqmeQ3V4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgA3Rqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jan 2020 12:46:40 -0500
Received: from mail-dm6nam10on2085.outbound.protection.outlook.com ([40.107.93.85]:27968
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727359AbgA3Rqk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jan 2020 12:46:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZv5nwNeWTahY2ScmWQVujeo52k+eOumX/uO+157SLI7a1eHVpuygad3EElTzcynbAj9L+BgNAtlBUMlUTa5N11/JQhmt7Vi7eAp1znZszsRK/h7slCau1FVnBMxhqqI/82H2qgzJLZAHk8aW7buuL1yY3oNR82Kn3mdKI9IEmyTo8z4bOEKiU4CCpB8fqS10Drdzx6HAAeaVflSELnD2dYa5UJ5Ni1UAFEzLeM/rFReljRWbekL/S/vRbJ4ZXYCQsYcy7sU1jQzdjt/niK9nNKAJnu46ZAXbSd5fWgp7Kl/LhWItycT/RQ5J13250i3UwgRrbzVnTFX4GFuAgIqGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Ebke6eveyxao7m6TM2J+k5u29xj8tTIql2r8ll4bY=;
 b=nmE2B6/iuTt9gxpjmZ/hC894lZoGUo+p46y/cU+RKvaeHnXdB+yG91Tivn382lvrmk5YA7GdDAano8vLh5oZihTxVBrHNKDMh5zPFxx4Y4dg6PcSRqyjJfYbx6OAcPPfK2RS0Eiso9J/EIhCo1ykCEbXXmqlxbQZ0wq8ZMWIotKdwJCPkx9y7P0A+DgAUWbh1EAMc7xMPZ3p5qalsSuuwK2bVAJGMy7kzgYUyPHGx3q7KZTrGwOWxFyoRTLDP8sWAzop/C/zFSsAQ4jf6F0fS+LvxDqoUN0MzCusqiPXLMZx0ObXaKwh09DsliSTBCcKm4ENQiI4Odqi0VJajO0pbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Ebke6eveyxao7m6TM2J+k5u29xj8tTIql2r8ll4bY=;
 b=FqmeQ3V4ICnLvFN7W/A3AMH02Kxz/FX7zGBCD/xK+jUHhy0UQo9oTJqDWFeiuSa12gsBawRNIrEJWPJJpn6M4xbRcWygCrASAKL/iDlUmdBZ4ioa12XLmOtVXnWp7CArufg7jcwBwf6C4Gh/ZP2ELR7QlA22dNOmi34P9PyceOs=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4468.namprd08.prod.outlook.com (52.133.222.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Thu, 30 Jan 2020 17:46:38 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.025; Thu, 30 Jan 2020
 17:46:38 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
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
Subject: RE: [EXT] [PATCH RESEND v3 4/4] scsi: ufs-mediatek: gate ref-clk
 during Auto-Hibern8
Thread-Topic: [EXT] [PATCH RESEND v3 4/4] scsi: ufs-mediatek: gate ref-clk
 during Auto-Hibern8
Thread-Index: AQHV1pJIc1dgl/ITFkycQvQR9IcT1KgDfTyA
Date:   Thu, 30 Jan 2020 17:46:37 +0000
Message-ID: <BN7PR08MB5684D2DEA29598A666214B3FDB040@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200129105251.12466-1-stanley.chu@mediatek.com>
 <20200129105251.12466-5-stanley.chu@mediatek.com>
In-Reply-To: <20200129105251.12466-5-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.80.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96e96dca-fe07-468b-f1a4-08d7a5ac5b40
x-ms-traffictypediagnostic: BN7PR08MB4468:|BN7PR08MB4468:|BN7PR08MB4468:
x-microsoft-antispam-prvs: <BN7PR08MB446839B2DDE3DCB9AAE55D77DB040@BN7PR08MB4468.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(189003)(199004)(55236004)(6506007)(8676002)(5660300002)(76116006)(26005)(9686003)(81156014)(81166006)(52536014)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(7416002)(8936002)(186003)(7696005)(55016002)(86362001)(316002)(2906002)(33656002)(558084003)(110136005)(4326008)(54906003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4468;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CtLo7dr4allvHi6BkNOySr1LnuGEpKrSCA0bxIMMMu15aQMRBm0hoN1u+vTnfVuMzC7Dg/E1j7P5ige+yquuOpadH04az5bEgZtBtv7C1w1IXOcD5MI7RnfKswEjlTQiYI3HoakvdQV38Q8NoMokwkTp/lhryJUJERE7AvobSDe9Q1UMDIUwbmOZz0vkUvn053eLOdtvQ4ObVh6syvM9uBDJT10S2rGLto7ty43j9cAWYv2jHgegyQlmjnFsfGGHk22RcS+U/9/k9HTFWP/O+dVNB4gMVmjDmh1UZhuA0V95PaW8EwHgEoLSbQgxffmDeLFXxlMgilP8Xb4WgL21BVgvpYnhguuLbMij0UbZ4N2jQSeGggWuUx5QNpP6lBzhSwq0y2E0orNDXiC9Nlo/QYjOP2psAUX/Fotn6ZCE/AcxkrG8lXegeTaVhMsd3VqI
x-ms-exchange-antispam-messagedata: E10j3/8Zsju/hjmfsjl0g6OfHUJxxhhNDsKENLALZ3U86Bslu5fg0v3XkH/kzRT/cPMXKOj9r7Dccywgt4PsmMNEjLEgDc2DQx6vZWX3vzVbsKx43yYRlDf6xSq3B+IeP2+0EFfi+ynBQS8+LzGcCg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e96dca-fe07-468b-f1a4-08d7a5ac5b40
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 17:46:37.8747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g1mf3pcQojX1rAh5fvi3ofr07UTfr5j4EuD+q0G4isk8lmXRdb1zeSNrUz7eVEA2Fl3C532tM5FXMVm50HNy5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4468
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
