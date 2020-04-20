Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBC0C54FCC
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 07:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C452078E
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 07:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PuBYdETi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Emo7IH+n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgDTHFG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 03:05:06 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:21968 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgDTHFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 03:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587366306; x=1618902306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PdozEzjWpfuNB5nF6LcsNt6jxdbBBUR0Q5y4dibA62A=;
  b=PuBYdETiB7NVFowDSSltnM8QbQ8C61hfvaQ7CJSlxMOMveMmcvX7/StE
   DnmuaIhzggiHE9Ogz3kKS4KNQ/Bt5Ibt6JxcEAg6PbgWTCoPImUl52zg7
   GS+81u1WqZJEoKQBBv7HpN3oRzMmj98tpDMro4kJLXgVuyClIX6DycUwk
   amN3ht2SzjbdETXqAmkR02wGhcXV1TsEnesARW5QZ99noV4DU3TfKET9L
   bcdUe5kVFOH1rRBDTX47c3b2i4/82wc9jDWHKgc0UxIK5PksVo7pmWkkq
   GHa/91O2SDp6TitV+seLqWGuNWUiqSWd22QPLxjQIlGcSpO3s89+mQd/c
   Q==;
IronPort-SDR: s00gY0LB4BjGRdqARXFlhIDjo14bnCkU0nAFhVytjZe76HTt6rrFg8i8pPyP2DdGSevFgkV1DH
 IUVs4Z1bRxB9+e36iVcWC7YlY/2wqa3nD/lnRKlI3pnqVRS0uKxDeh0fYvQugqtf6e/mxH+pY1
 5nzaUraIX93tMRZER8xJ0S9R/IWURSwmn4mldZAB+XuPdw9D0QZMaa97AW8hzfKntxqHNBvgye
 i4ROpabGaFIdUoTwkjsGUsGYpwaui+ir3HUXf9C7xpfiVJTsdxO0uzxDB16uvu2G1yRdBkrtKn
 cUU=
X-IronPort-AV: E=Sophos;i="5.72,406,1580745600"; 
   d="scan'208";a="137118302"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 20 Apr 2020 15:05:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kY7uZrlZMmE8Vq9jUTlcuTdxV+X0GTzfTwl1nFsUeN5GXwO/B6XG4Iq0cNB26BQpawxs+8Yd2rPit1hYlrjY93hOR8q8ZHgrgly7mktaGIoRHn34QG8BSQ28ylgraO9ZDGToDZuPprdCBr4M7YeQLaiWo4ZgrR+MFY7BFfNQXqATVFIZBS+IGLFpICpDzlMQONzbHSWreK0Lhg0AVfCwDSk3bwhsqs7EzlXljsr8hktAX3j52VbTnN5DNwgwn+9dtYgyWgSpB2oJLk3FalIUJzvHuS8oyRC+Q0rlN2XGcpzHc2Xz/jYCaClfw8rkDH1zgRdfEYGO/RLRT5ti0e4HkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdozEzjWpfuNB5nF6LcsNt6jxdbBBUR0Q5y4dibA62A=;
 b=V8YQZrP0/d9lqXFr7VM6eYrtEVt60ptLyhhJ2l9hUkUnAhxxpYiTj3KhyJwbm9vYXd7idT/aQJuNrmrlzWXMEk6gpBRcXWiFnOuGyaDQBqw/99kDZ6iRPFTuaDIJOx5Dy6GQWsMT4W8/6skN7qMcKqCYhpQr0OvNYof2W+GVgZqrUx2wK7NjrRa62yEzmCZSrOBRVc68war2JqDQ7JOUBwnnqezsIXe32Vm6jy/GgRAXdscOv1u2NczNW38irarME4XoOVSkp0TWoFcXUvYS677lqoM6XIWaOGhXN4DrR9Z0TIfOALzkbCY08G4rKzmbnkWv/xdhrj4EbVO0/aPzzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdozEzjWpfuNB5nF6LcsNt6jxdbBBUR0Q5y4dibA62A=;
 b=Emo7IH+nanzSNWSq7qhDlzsDPcPorPTvje1uzADRhDt9I+YlwvrqzklDg+5UA0fQuyWOTwV4ZJOVUNXjt7hvehlFBBX6pfNILpQ8/+begpLZFMzRzxJ7RPc7aawLEcnaVXbDHYdcPz7HI9aIomgAtY3D0kikCaW1DLIjAJYRvUk=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4446.namprd04.prod.outlook.com (2603:10b6:805:3c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 07:05:02 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 07:05:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh@kernel.org" <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 02/10] scsi: ufs: add quirk to disallow reset of
 interrupt aggregation
Thread-Topic: [PATCH v6 02/10] scsi: ufs: add quirk to disallow reset of
 interrupt aggregation
Thread-Index: AQHWFONzXdOgIo5A50O86TEJk9mR2aiBmfhQ
Date:   Mon, 20 Apr 2020 07:05:02 +0000
Message-ID: <SN6PR04MB4640A97F3BF5F2073878312FFCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181010epcas5p23cb018eee5b7ae0eba87d81dbaaec3ce@epcas5p2.samsung.com>
 <20200417175944.47189-3-alim.akhtar@samsung.com>
In-Reply-To: <20200417175944.47189-3-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c7940835-31ba-4a31-5585-08d7e4f925b3
x-ms-traffictypediagnostic: SN6PR04MB4446:
x-microsoft-antispam-prvs: <SN6PR04MB4446F7F3750D2D48FEBD7DA6FCD40@SN6PR04MB4446.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(66946007)(76116006)(66476007)(66556008)(64756008)(66446008)(5660300002)(186003)(81156014)(8676002)(52536014)(33656002)(8936002)(478600001)(26005)(6506007)(86362001)(558084003)(7696005)(9686003)(54906003)(7416002)(316002)(55016002)(2906002)(71200400001)(110136005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v00E52I/NyrDU5RxMQqDSZjyoEYPyg9E8fWKXnkHfUFTpUFFRLW1CIyrU+aUZ1r6UAL+CT305GPdN07YvcZrnEJ7PWa8LZRSXYc/AyM7Y96y15CjJJ28W8WxiFo1w8ogy8+f02RWGO+IpYarY9xVMXqpix/KH7liy7RRcTQ/7Aac5RUho0Ir8lKlVhIP8Lq5sDy04+7QwpnRg+7a09bTniazR0+WwkiX6AyiI/mZ/AQdLTdT7aZQIaD44JUBd/j64GnKqBR2HeE9UBj6fkpOO8lpH6a7N4QP0++Bb+j/V65KQPH2N6kOgRAzT06306+AN9pf9fkhFta2Zsk1jN2NeeMODEDEDrrHs6l7noVAZTfR7ICL/APYRdDVyYecF++VRCZ7vfeo7qyrbEd55gpW7r1FLh9xkIT6OBKgd858G0cHpVdpJ+Rrr7ulHWgEdRdm
x-ms-exchange-antispam-messagedata: pYMiUMy5wKhkrFi8gPL0um1NWvQ0SwksVMjAFfE503EwPF3zE9gKLlip2IXtUbFSQMB9W1jZ+tGnYwKB3k9ynmdQKMMpUvN3iMy11YF64sedv+rABrRrvkHDTiUBWHL19DsQ+zI26Th3S/ja4avcfw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7940835-31ba-4a31-5585-08d7e4f925b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 07:05:02.5744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eidFk0tU/s77f1xNRl5QS/nRE0KXTbBJ3zfeZDa7PCbQYNbz9ecuMQi5k5YOov1ltAKY0wpdxhvNEfreyVZBzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4446
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gU29tZSBob3N0IGNvbnRyb2xsZXJzIHN1cHBvcnQgaW50ZXJydXB0IGFnZ3JlZ2F0aW9u
IGJ1dCBkb24ndCBhbGxvdw0KPiByZXNldHRpbmcgY291bnRlciBhbmQgdGltZXIgaW4gc29mdHdh
cmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZXVuZ3dvbiBKZW9uIDxlc3N1dWpAZ21haWwuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+
DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo=
