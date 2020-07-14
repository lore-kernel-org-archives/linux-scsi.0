Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0039BC433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 09:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B87062075F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 09:29:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SgiN2JBE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qhHic998"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgGNJ3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 05:29:54 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45585 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgGNJ3x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 05:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594718993; x=1626254993;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pJBrDXbSNcUoC7nE72rkJlHXG9zg9/kmKAwRfv61Mmo=;
  b=SgiN2JBEj2DkFfCSYyhH2Ozp3S743dLkLlINuMQvhXAdO12JxSthAIKi
   2l2e6AkzlpcTEDvuEx0iwk8ALlQkyfSjn7dGY1wU5gXUb2ljTFj/sjZAN
   Z7xyQmLSIOJYUh+aCr8WTGG8kD0g/+o2hv5O3329HWuMOeEag6NaX6beQ
   Axu3PTBcmYi9Dx9/aVnLlMa3/OYpFAexO+tC10/11UrXUj5ifBT8sIKkz
   dcXINOxkxT3SqFfHpX8QUvwlX4QFkgPFq0u867WQwG2xKpeRYsrWsrKBX
   zPvHo4i0HtMbTaVPtwWJAo/Iv1g1DHI2Q6LXICtVnIg9p4dkSyBXbjD4Y
   A==;
IronPort-SDR: gSf1UdmNubb5ev4k3kdSEd2A/bzX8f2NwBvoB+1vRDtr4u1iIQLGQbJtPps5mAk5Y8ZIoEOqs8
 ynEZOLSF8E9XBUGoi6odvZ4G0rgoDQuMlFlb6vDg/SFQts+ujn6NcRWOe3H34q7Vjte6MYTuH4
 vwN9j8b79fR1bppC+SD4f4ofrwbGP+XJ5CmPiliTw3TEbHE+Q6ZI2Q/pJZPXjbl3TjrMHuSDD5
 f26Ud7vt1mFGAcJkjL/K8CiqfZEBwCwpnZwleWZ0AKM8bPcVzNr/Sw1aw9tD2KUSpEnJHwA4wS
 zJk=
X-IronPort-AV: E=Sophos;i="5.75,350,1589212800"; 
   d="scan'208";a="251666408"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jul 2020 17:29:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfPoUAbE9IFZANttFHYotJU2KbZVJuxZOealk2yhBq6OXVkyakx/l/WGlBWz8WUyJtEEpSOQRDIviX6zyO5vC0uBhJQg1G/b4jwGTv4FR3ItwFyJUm7I9l7vWz7TzFNNFTeyqztPgYeE5awHdtZrIlYBzsiYgiW35F0a4LQga+kr0j1/cvJd4NV+vfvc0Eu/mZJE08sQpU9oHaDVVQn3tg2i2WDNaZRtZvhnRYO+S5Y6mZoPo06jQcPV/CyutZ7GRevH5/D4B8ySIpvY+R4HTqWyrLUFtr/V0CbKsidCb3y/Qfq5FT33bOi5NuRPPdHv1EK1Ctn59TzKZi/dZl6bSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJBrDXbSNcUoC7nE72rkJlHXG9zg9/kmKAwRfv61Mmo=;
 b=ihe/uvGBLrPA2hBGXGlL4XQ36gZbAS0gTH0AMqBkM6CVxoqkPkEeQD2jdDC30E2fIeSOxVwgbxe+2nEckJMobFk3XgWSAGbssv+iLphaT2z/eNTmZ8lzO5RsMxhcl6OwnOO7DYjcdEmrnLhkuMFxSdRdurwMWrYpzi1DFAxtESnDTetSqNHBAjham6AkrJ1zu/P7V7rtKyABnt5qsaEu6bO9PIXpkvvMyHbIaDLPD7mCdkShB92G36AEi7ox9xYXYW0k/d2uDJ2r9+Do4cc3leBwWEv2sWfm+3YWUMxXHzBuO0GYqhYvZmYWRjh8ojqoJ76FMVQM+GtJrA1wl2vs+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJBrDXbSNcUoC7nE72rkJlHXG9zg9/kmKAwRfv61Mmo=;
 b=qhHic9989jVtEW1EkK/QzimGX0UQpfJJrcSfXU605GkQUfopksUUnBC0ESBe7yRIEKhYnJ8Gty+y8Q+pUbjIkANieRGI5RWAcCuXw3me3d751woNHMDXU9q6nkEcYDTXVSSO7QzupKwwWiKYI1vfaoZIx7sAokcRqdNTTStS0zU=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4190.namprd04.prod.outlook.com (2603:10b6:805:32::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Tue, 14 Jul
 2020 09:29:50 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 09:29:49 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
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
Subject: RE: [PATCH v3] scsi: ufs: Cleanup completed request without interrupt
 notification
Thread-Topic: [PATCH v3] scsi: ufs: Cleanup completed request without
 interrupt notification
Thread-Index: AQHWU5heDqJFApuOo0yQOIjuO+/O36j+4j7ggARNXQCAAJBVkIADEAuAgAAKm5A=
Date:   Tue, 14 Jul 2020 09:29:49 +0000
Message-ID: <SN6PR04MB46404C9EC8C29F75E5D1E45BFC610@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
         <SN6PR04MB4640BEAFE18BDC933FC7EC95FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
         <1594517160.10600.33.camel@mtkswgap22>
         <SN6PR04MB4640F34CAA25B3CB58F94CABFC630@SN6PR04MB4640.namprd04.prod.outlook.com>
 <1594716527.22878.28.camel@mtkswgap22>
In-Reply-To: <1594716527.22878.28.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5d5a98e-0f83-486f-491e-08d827d874cb
x-ms-traffictypediagnostic: SN6PR04MB4190:
x-microsoft-antispam-prvs: <SN6PR04MB419094342B3F06678E7E360BFC610@SN6PR04MB4190.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8hU+qnBVhVf+Fu5r6ODjZkmvn8R0/0VOXGT17R9e68ObhhzHRZ/7bUAEVxIyqlkda3ejXBPNKd76SYGB6a1Ka5JwvTja4r2kWK92lAJwpItqpsn5xSNxvKxf9GYkeMPM+r9/pNE9aazhgh5auwC09uzSgmCxkau8ivVwQq/v6SSBuv1XxtgllMGAyEkTfZKWXE2DLp2jp85frbc1dVCtQ8e1t1+nIXSc6iwudubEeg7nod7RJgf9Ul5lF/9td0ohExhMPorkm7SZR6WgobNV/sgZGBtEODp4oxsI/4IeUpxOUfoLWmX17aoJ8oqeRyCNl101MtTIVxy6eVXh4Xv/5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(4744005)(9686003)(55016002)(2906002)(6916009)(8936002)(6506007)(86362001)(8676002)(33656002)(83380400001)(5660300002)(186003)(54906003)(66946007)(316002)(52536014)(7416002)(4326008)(66446008)(478600001)(66476007)(64756008)(76116006)(26005)(71200400001)(7696005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EPHmS5BIBL3kXrB0ecbmy4Bv10AyAnA+rFcx5jtW0taWga3SqqatqPvsat3x/+vESifq4kI9W7DNpDR1qvFmoyO+7CEAjiL8ZKxN6VabSYuk+PSJljEDEHDd3NNAL/3PAjb4WZEbeH4AZtvHlOOw/nTg1z4YvhjTkrXJuUKKnE1SoixYLzsnye5w5HYe9Sl4IClfRPj7dxVWipPYCRkRtnUW7aOxAxuEtvdWBV1LvqpOqrlWtA7fz9CqmgxpXNJDc3hZ766D8NtxPlFHAWgSuca2ZwoAWIsIVIX8CA/wzQKTVZD+2+gNuAL3ZXeICFDlOzBTOzILB92FemKDL4cXJKMcL8n/dlGO3JLBFWr/MbKTLj0gS7PT5wURToGYFP02auRcOhbvJ8PzTHfF9bihLEVlgsL5anI3AKanUPgiMQX2IHe5h4cuWhFQY3JXMyJTk6gX6+MBpAQ+ewacUSzL+Atbw/irqokNExP7nBUmHUk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d5a98e-0f83-486f-491e-08d827d874cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 09:29:49.7924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e9eQGoIJvfGjUNKHniROFEkgANFj6ULcfgeGjfB+aP1+Yo6WS5Aa5/Pa6BkdMWm8HpDHgLR9IUKOHjqVkMbRPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4190
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gPiA+ICtjbGVhbnVwOg0KPiA+ID4gPiA+ICsgICAgICAgc3Bpbl9sb2NrX2lycXNhdmUo
aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ID4gPiA+ID4gKyAgICAgICBpZiAoIXRlc3RfYml0
KHRhZywgJmhiYS0+b3V0c3RhbmRpbmdfcmVxcykpIHsNCj4gPiBJcyB0aGlzIG5lZWRlZD8gIGl0
IHdhcyBhbHJlYWR5IGNoZWNrZWQgaW4gbGluZSA2NDM5Lg0KPiA+DQo+IA0KPiBJIGFtIHdvcnJp
ZWQgYWJvdXQgdGhlIGNhc2UgdGhhdCBpbnRlcnJ1cHQgY29tZXMgdmVyeSBsYXRlbHkuIA0Kc2Nz
aSB0aW1lb3V0IGlzIDMwc2VjIC0gZG8geW91IGV4cGVjdCBhbiBpbnRlcnJ1cHQgdG8gYXJyaXZl
IGFmdGVyIHRoYXQ/DQoNClRoYW5rcywNCkF2cmkNCg0KPkZvcg0KPiBleGFtcGxlLCBpZiBpbnRl
cnJ1cHQgZmluYWxseSBjb21lcyB3aGlsZSB1ZnNoY2RfYWJvcnQoKSBpcyBoYW5kbGluZw0KPiB0
aGlzIGNvbW1hbmQsIHRoZW4gcHJvYmFibHkgdGhpcyBjb21tYW5kIG1heSBiZSBjb21wbGV0ZWQg
Zmlyc3QgYnkNCj4gaW50ZXJydXB0IGhhbmRsZXIuIEluIHRoaXMgY2FzZSwgdWZzaGNkX2Fib3J0
KCkgc2hhbGwgbm90IGNsZWFyIHRoaXMNCj4gY29tbWFuZCBhZ2Fpbi4gSW4gY29udHJhc3QsIGlm
IHVmc2hjZF9hYm9ydCgpIGNsZWFycyB0aGlzIGNvbW1hbmQgZmlyc3QsDQo+IHRoZW4gaW50ZXJy
dXB0IHNoYWxsIG5vdCBjb21wbGV0ZSBpdC4gVGh1cyBoZXJlIGNoZWNraW5nDQo+IGhiYS0+b3V0
c3RhbmRpbmdfcmVxIHdpdGggaG9zdCBsb2NrIGhlbGQgaXMgcmVxdWlyZWQgdG8gcHJldmVudCBh
Ym92ZQ0KPiByYWNpbmcuDQo+IA0KPiBUaGFua3MsDQo+IFN0YW5sZXkgQ2h1DQo+IA0KDQo=
