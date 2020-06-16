Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68217C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E2AD20B1F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VwytIP2N";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KuTgu9Us"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgFPMip (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 08:38:45 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:33098 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgFPMip (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 08:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592311124; x=1623847124;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U+9VhUwFy/5HR4hwxG4PNOQPyJwk2BxA+0mQ8zMjLr8=;
  b=VwytIP2NufZtmmkqGXF8kMVTR2yVcEdGT/fK0CRP4c0NEHD0Av9RT8Bk
   biL/VA/u8VJ/HpSgAN2rxXfm+LME6EoDWDUBY3K2U9qonpKW+9Z9IsBL7
   ZzHahmUFgBbx8CD6UqMHFnQQnq/yJ/7PMOBisGZ397P1PDpYvJapDTQTf
   Tp5K/kYldSwUAx4gMONU4Q4KQNYU13rXYiyumyyLkIB2yo96s4qF8IIfo
   GtOAffCqOXJeFGayvWI0uC/YJCmuJ73q867VFrnRDSg6Os90IVcOULhVM
   phGTUxtx5ihoTIoYJblvhbbjLh9Fj67hz+W7pOF00kVWqRkvzGqbTFxY3
   g==;
IronPort-SDR: dpYdwH23FtvuA6F7Gc0eS41l3Qx+00t19uvwDiz7M04Js67HOCNvMUy7hrRSrGqSyII1netvKL
 CGe7VtC2c9bXkNr3UX8bTINncn4AOynREMlYYg9LC/ueMxphqbw6Pw+DkFY/YPQq+XeeBwpaAL
 +CvlIEFqVJ2WwGdakHZjy1TLeTNmh4oUuCmb3fZqH/vnjbL2tDT+B+ScCZwvS/VFvCMKrsl4LP
 jvDojXLmQrG1tQ9WQKLeXC7ZYBEwfkSZ1B+Yb26UHm/jsBo3DqIAPqn3BFrpqlK9NXJtvu/QfN
 IIw=
X-IronPort-AV: E=Sophos;i="5.73,518,1583164800"; 
   d="scan'208";a="140390456"
Received: from mail-co1nam04lp2052.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.52])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2020 20:38:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2CawvVh8V/0zCIkLHsO9mN49p3LyPr/f+SKzHMXABaxgcnEg7sn7/972gaE53JtS29sfSArGrBi0OB8oN2iRtDJwUMXafqlSN7Up2Hu//YDF+mFtEg046Vll5WR0PFUfFCRiALOeboL3+AMeEmAc+vQdjzFfXp7iW+7wWU+KAjNp27gZ12IzXwQTIrAp80eF6M5Nxv5cNNZHoigqYDp6Cgy9uS4AXK/0N3KdfgdmNb3E+brWMzUemXPbNDqEcz8CnDkjrhnMwUzNoNDneYF5JmYDnFw8FGW91oZKDLjtY9N1gUMBCAXsdsTDS6PbCXhfpUxvISS1odYOduJEmoJKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+9VhUwFy/5HR4hwxG4PNOQPyJwk2BxA+0mQ8zMjLr8=;
 b=T7T6cwVr2hq9/J5KH3eruqacFSIdhVvhXRubRwEYGWF+28TxZeyPab2WWdsDv+OhqQ+rWAzSqP6Y9ccMjHb5BTETx196cYDPjQAPqYGqkli428DI5s2izuKqAZvV+VvxY2v2vyDMjEHfYShThZNEVdgIOppjgvMDbVIH+d9n6q1KqlsaQDKX5+AlqzBHZPBIfVs0RxaV6Nn5yOGD6+gLxh7odSSoJb2ZIEPouJCszSk2X0wgSS0iAh4KsFqrKnOXE0/4Hl2ivWBIK2EVkCsDwlGiZVl7d2s7N9Wjj9ixpk4rW1DTpGeqpAPgYAFCh+4WeZ/q5LyM/nYpSk0sqqPyww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+9VhUwFy/5HR4hwxG4PNOQPyJwk2BxA+0mQ8zMjLr8=;
 b=KuTgu9UsI8g97ejmqtJYpbCZwC7yGhJ63QI+ntHQMBiJx/o9kgBXaiWEr3vmugNGn69ixCX/qama3KI6b/gZaZbzD5Imosjcgw1gtq+5CEFGdiCIYTjL4odiFx0ddQ50H2SmpG+VV7jS1riKjm9InUEjpbuC90rBgbiJb8SDlZI=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN2PR04MB2174.namprd04.prod.outlook.com (2603:10b6:804:10::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Tue, 16 Jun
 2020 12:38:41 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.021; Tue, 16 Jun 2020
 12:38:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>
Subject: RE: [PATCH] scsi: ufs-mediatek: Make ufs_mtk_wait_link_state as
 static function
Thread-Topic: [PATCH] scsi: ufs-mediatek: Make ufs_mtk_wait_link_state as
 static function
Thread-Index: AQHWQ8O5SdGwpLWeBk+lZ+eDkpyrJKjbLmyA
Date:   Tue, 16 Jun 2020 12:38:41 +0000
Message-ID: <SN6PR04MB4640FC505DFE6CB567A488ABFC9D0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200616095120.14570-1-stanley.chu@mediatek.com>
In-Reply-To: <20200616095120.14570-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 94a0dc61-0c75-4b29-af7a-08d811f23394
x-ms-traffictypediagnostic: SN2PR04MB2174:
x-microsoft-antispam-prvs: <SN2PR04MB2174A89167296B2C60DEC817FC9D0@SN2PR04MB2174.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dwc07w1enTjrX3Gkwd81rBW7krBtdCw6CHbCx+n49WFZUQLCskSWLdcFfpDploxrkKFmo2GuvKpkbxGEsUrDnioXKD6B1MNqwzhHhBRAekGLYlXFtog6l1iFSvLquQuoTFG8HXRA0bSFVsvP2XhmoyFj8mBg9hjKzWJqYwRsEZtRXcZicJpaTfRWhE5+LQM65bBBRk6KDTLEi2PrhFVEf47E+0SS8rD6uAjtUXJc/r8+eBe4nw381ZptFeKaYxoJeAwvxFxxb2SyAVo9T0Uk6x4x9vvMLwEliTk++03QrwxNB0PosWnBThP5xTPcjo9v5AunZz5m7z0mpjL0TMNkjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(66946007)(7416002)(66476007)(33656002)(4326008)(8676002)(66446008)(64756008)(66556008)(86362001)(76116006)(4744005)(71200400001)(83380400001)(186003)(55016002)(2906002)(6506007)(8936002)(26005)(110136005)(54906003)(9686003)(52536014)(7696005)(498600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cUCuCw0b/wlMaozCcl1oMW0oRT7qMj1sAsbQFB5djgwuDSEkCLczTzsUitRjWlWXdYObkvzhc1IiP4hwwE+rH1avR0THnar/6A+fmifuUnh+MCz7GSqQU/AIIftlFe/4bqH4w5A+eQ1PuML47kXnMrXXdjfbJ88xymdchfToKXQMA4R33DSHWXNtBx7GKArYBYFOOv4UybaTna8bZH9a1XAA4JamplQONr/Btp08VTpPetyTVAO7zqgpVvLG1fNE+cVfbEs+6kQwKFjh/mLNZD05b1MppyYTzUXICSj+B8YbjlHLh09h1Xc6tqPvbhh/0Gobgi22pQIrYe3Ydo/Ykn4UWmRNeXwoVSFakzMs8H6Xy9xq6eXA/n9neJilu4dMJaEU6rY3smKRO8mm+DBEMuXgnvixul66R54ZuNDFp8xiCPgxknywIuaFBKOIGOHQybsTHp7CSmBDhNahDfuxgd6k3jOuHNLfDzE+LHKG1Zc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a0dc61-0c75-4b29-af7a-08d811f23394
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 12:38:41.6865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HA4xaXES7BzCDfJNkeZ7UBJFopIFBj7rsk8j05D6nvuC9ORLbYWxAbekRdt8JsCgbK9wHJaGRsxUWdkmoDftQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2174
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



=20
>=20
> Fix build warning reported by kernel test robot:
> Make ufs_mtk_wait_link_state() as static functon.
>=20
> Warning:
> >> drivers/scsi/ufs/ufs-mediatek.c:181:5: warning: no previous prototype
> >> for 'ufs_mtk_wait_link_state' [-Wmissing-prototypes]
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
