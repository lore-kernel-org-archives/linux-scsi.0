Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FBEC43464
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 07:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8F921D43
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 07:53:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jvW1Pw53";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pNQejk2w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgISHx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Sep 2020 03:53:27 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:29413 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgISHx0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Sep 2020 03:53:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600502006; x=1632038006;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sKY26FFKn37wPjaDWqNKQ5SHM6CJVPkpEe0cAAE2jSw=;
  b=jvW1Pw53+7W+1m9H8FHfTyaZz2lvP2iO2O8UCZbvZOhERq+sR4e1GSon
   QnGoVciTpyZtEOAoyOdTe9l//DQUmYJiWErd/pEowlUTR6ua+8iVBmtQV
   E8jkwIU+8I2QG/B7PSvq9u5EadUW0g2ph82IYT4QXjtPxTDRAYTvKxVEZ
   NDt5YxG7gVhflaPUWKEOhBfmmMelzLqvSPjbsVCXvuR8XP/Q32ujnHbMo
   lykKER1aQtclNrg5wAp54tchz6yzeYfpcfaZXm547qnMDe4r8hfOTNjDa
   Q3nQdFPJllikBCAJLHHecTELXSXur0sC1DJbnxKAO5xl9xCCoJcCA5fqR
   g==;
IronPort-SDR: e9MN5DBdYUHb29Qqi3Pzssg6Y4mp1HmpzG8EQZSX/SrJFzTGo6ZQZ05ViPK2HEBdPYfwc6QOlP
 85plXsCdjR+B29+esosaGjoODsj2/RTCfrZXOOf67Oa+lxjPjKByolMVIg9IPTEhdHQdNQMVtn
 Agg4OVMYnsBBIb4Dkt1RSU7mi4m6XDfMfwwCZqjBJixE0uM77AbDxHEKfwWVBzk4czgCNgMayJ
 on36hllsyt7lPlzZi3LKMXdC0VUf77NYa6Gw6Gz4LYHTiUd6JH6ItplLCKvxWmKo/m/1ypMNoP
 r7w=
X-IronPort-AV: E=Sophos;i="5.77,278,1596470400"; 
   d="scan'208";a="149017257"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2020 15:53:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wh/X4kbHnVk3TL7RLZc6ZwVI+HAYJPf7ogrO7cBCi4w0kDpQge7ke3d0JEQ7OsZZV2DHc5f2TDY8auY3a2ALROKb75xcJSDhXiyZVNB2cY/kDWLQ8OG5CFpYIoksHLPtHdiY6bf5Z85v7RkGt1zW2mOmVsZqyhKwUbfqlyUTyrVzIDrVln+YZXGkObpjynO1cgBOerc3d4WrZHbX/KVA6+Bo5UH7FIG6yuJWvMDf+D6Z0/k9LOHzr/AJARr4EqqKCvAhRpQskWulU4XgdZa8Tqorj4h2NYyTct/4ScjDtuGpRw0BDUFKdheSdlJwDlXtAzfRbXyF/VgF4wb88yH2Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKY26FFKn37wPjaDWqNKQ5SHM6CJVPkpEe0cAAE2jSw=;
 b=EeNrQzTvOa83LFWTvFBRYpnj8Y2TB9ow2Z0hJoGY2IsJr/RQQeJeR9QB2eBrZ+hcuxUm08fM7aBgVvIvbx3iYGaNYFAa6EEo1wnIRm6BkCGyRQrfh6eTZYQ8q45BfhgB74zIuF++dLOkcTfbCkXdU0idy0M5AfPnDVUqIt+ThI16kjERH44aCgWaw1mrsHv0NEgXoEBABnQSvTsIKQfO4EEw5fwRGKr+XI0VDyUNrD6XuFARLy5lb+/dZirh2T5rmYG6oPE9XEM5AHtRUurH4M2r3PvLYAmXkA9tOlO/vreqWGpvoU+oT4MWOLjvuT68ftUPaCIB7RRfBEcYsaHGyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKY26FFKn37wPjaDWqNKQ5SHM6CJVPkpEe0cAAE2jSw=;
 b=pNQejk2wVMfGfAMlHj+m9ei7e+kiTw+EFge4EFFHCxneFevbHKMqRKcTPYFC1dYdF6usg/OI05ZqXRUeNY7zoHOr5h4rhBtQCuyRFFM07zwrg/wv5vlOka0lNxpyM2vTnq/aOUjIIczMdsL+Kotvlna52F9/u9zLluVycr9Xo84=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BYAPR04MB5238.namprd04.prod.outlook.com (2603:10b6:a03:c6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Sat, 19 Sep
 2020 07:53:19 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0%9]) with mapi id 15.20.3391.011; Sat, 19 Sep 2020
 07:53:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
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
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH 2/4] scsi: ufs-mediatek: Fix HOST_PA_TACTIVATE quirk
Thread-Topic: [PATCH 2/4] scsi: ufs-mediatek: Fix HOST_PA_TACTIVATE quirk
Thread-Index: AQHWhaugPlH83fCRGE6LVX+FKPQRNqlvqEbQ
Date:   Sat, 19 Sep 2020 07:53:19 +0000
Message-ID: <BY5PR04MB6705B15F1B7373FF6FFBCAF3FC3C0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20200908064507.30774-1-stanley.chu@mediatek.com>
 <20200908064507.30774-3-stanley.chu@mediatek.com>
In-Reply-To: <20200908064507.30774-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 77ede0ba-a9a0-44a9-8003-08d85c71130a
x-ms-traffictypediagnostic: BYAPR04MB5238:
x-microsoft-antispam-prvs: <BYAPR04MB5238AC58F9A36CEF139D249CFC3C0@BYAPR04MB5238.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m9zXO/2WGL2tb/K641OXJ49KLWYAsUiO3qX6uDHzzgwZnLt48LwH75K3w2Qf9yMY+tIqZfjctB1FL53YycRhjpppBfDSD6U0r4WblwFqVy7z80ZXRableqeGUUImEj3dN+fEyZKJ8ZAheLcCw5rPdr7r1+0Mfi7dif3U6cpDyNZVnQPtZkhLelhHJB0vPaaZfXONp3QySWlXivo5AzUAHlibqC0pMXjxho8lY0aVQNgwvifdpYXORHNMbyc3TOeLedciKXnu7jqNQXxjvR//B7Ueyyz6sD0CIM6wZNKUnnJajIqucyDdi5WV+APrM0CiHp59HW0DrwQCMnUJecj7uQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(55016002)(8936002)(7416002)(110136005)(8676002)(7696005)(316002)(54906003)(186003)(83380400001)(6506007)(26005)(478600001)(71200400001)(66446008)(86362001)(4326008)(33656002)(66476007)(52536014)(558084003)(66556008)(9686003)(2906002)(76116006)(64756008)(5660300002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aGUFUyJWQce10loiAMDlhMJMYTaOnMZHXLnnDB3bYG++fbbjYntknzetpDSQBYwT8LWA4I6Ag1UyoGdAtGB/gjs+/7gb8vJZhmluijrHr9AncumW2mbGbnPibaydMRzRDgrVmSteZDgOreDDJdw+c/oRhEzLKfEIX+nl3dNdDxrU+9nZkydzQzoR0KML5Ud9EE1cRoxWLjNT0fEfCyyfb2SwkqrKVSU/TZzmkj82vmtLbRoL1CqkPtb/sOjlNw/aSUvYU9kwOuKWvAHuVlQm9gJoJVSzHMA4mJUn2A7bHo56ftqlIwEWj4a8XHMKSh6UxobCrD6EMD8Dh8QUvb8SMjhr11PGB+xqrTSUQ4+CYg4eSAjiy7y+13jMt0mXZ458MEZF2Yfqsow/y1ZYbyCmyNBja9IzdxphKRkl+g1VgrCcBaO2h3j+x3S8kQf1rJ1aUsiKrtvSAA/eagCq+RE+XizSpKnybVPxVICKFhvIH++T9t4w6y4cR3RBy7b+9BmNOVOfXTW/qyMIYmJ1PO1LjSL6/ZmDDZo3bT8TX9daCKjzDBOPUN1LSBymYVfZjNiLtVkG00JyukZO9zVr6+2r7Fyr2tzaGp7QLGYRG/5cX2K9KiQpx21k3vrPEJFNXU00EDYBjAxkYkJ+tPzeMzZ+7Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ede0ba-a9a0-44a9-8003-08d85c71130a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2020 07:53:19.2175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1biusgXjg69yUj4lh8uLF5wSSZ500lWECUbqdBWx7LCD3q+mxbfLbnMUhx/ajtmCJbgUyMKMuKHpAVQqCIer4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5238
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Simply add HOST_PA_TACTIVATE quirk back since it was incorrectly
> removed before.
>=20
> Fixes: 47d054580a75 ("scsi: ufs-mediatek: fix HOST_PA_TACTIVATE quirk for
> Samsung UFS Devices")
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
