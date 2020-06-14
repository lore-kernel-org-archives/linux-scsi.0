Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0FBC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 09:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F73220747
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 09:28:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lDrdbwn0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kwEywh7w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgFNJ2D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 05:28:03 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4937 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbgFNJ2B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 05:28:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592126881; x=1623662881;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R7F3+MRenkRoRSgH5UZ+VI9Ec5NSXcKN4+S/nRJG+fw=;
  b=lDrdbwn0TidfPbRTtzBtv9U1I3ofe+SOTsE4rdX8vW9yGLrAyCNScTF+
   NnQ41vSpL0HcHKwcQ0MQiMt5Lq+dnXjYHzckoylyFcZrQbdBKZPnJFgAc
   2ubD6D1tqYmMOs949M8AIyRIX4tNG9njUUdfJ8AI+fx0W9DPZuH1P0YmY
   rWMudnUwbQM4hpHdDO/uY3Scw0E5qx1m70Tsya2xdI9XEdL8rHgNlBpeD
   LBVhQR4xIowiu6dxbEMGXN5AwUm0rxM1U8W4qNhvqy40UX3MRQxVdR0LP
   W7M0fHpcyhdh1igNm0U5EoZFcn2u/A0LcLNX3r9JVlCyVqeXGxo8z9pmz
   Q==;
IronPort-SDR: pD2W7HXR04kSB4hI4O+JtkQoriWPUTm8WiCK6YnE4ADDWpfj/ilZEclk4Nnd7QtvAwcylLGawv
 abEicRnEjGCjXt6MAbEnr70OeCtcdl97DDZvozl2xmN1JI9xf0m57b8hQR/vYRjzvXVbmHHhkF
 fphcscOJkQj8TJmE65g6HNJ5K80IlgdXel5dcEwvm1DqKktynJMz1xQRT8CIBosWmvfTmq9nlc
 A7UuCj+X+ffjAHU3SOpuUhP9YKlf/tT4HsKjL9wdL0XWJeArDMT/gbRFdJiyDyHTQonlnGKUHl
 eRY=
X-IronPort-AV: E=Sophos;i="5.73,510,1583164800"; 
   d="scan'208";a="144270625"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jun 2020 17:27:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/eMOr3aLv7HvtXHaFiQd50m0O1FngJgZ2kMlIFe5s4keq6f9/ccJPBXW9H9CaTm1AcQq+XLODqiL69nNMeU/n4qeZOw1nMqFSVdz6P6DSZipn/FaPuNq3QTzLUYJLFSU+Hr+FsLuMO3rTtSBnaEaBHSlvVZaMW8GaEd4C0N7M4g5wSKlRJ/miHYqEugT9n0mIO7RROQF3y7QDensQ1ruvIMyEXOcmZrmGjrtCVU4BxtW7Sdc5K0H8+cuLmW5ZnAkSIq3UnrqwyAxkb2jAKf2jRZ4dk2gBDyRFPaWtU1BwEL2ijIb+XYE4pA67obhglQZdMMr15EyNPH12qrlZjfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7F3+MRenkRoRSgH5UZ+VI9Ec5NSXcKN4+S/nRJG+fw=;
 b=GBBYalNzc7xrU8tMX+8/Z67fhvHVBpkx9CChQtIJmg0c7phTjmaF4bgGRjJpXYuMuF3eUT5OgO5tT1+6MJj66lC0LsEaDmAqumcVBZxcRsteuUg31TQoiF30GytucMrBl33KZpDnm8DGJhfhM9q6ISaSrECQ1485jbIM5hxQ2BGjxU7h86ceXwuEclIAA3EQZtjmGEjBT5cI3ZmZEKJLFKzuyGMErNHRJ27Br3RLnW7BRsiXDclUX+mMTBdipPyIud4FvvBr/D+AqhKLZyLDyapICaUhpUma++Fn/iXPQ/UZepCg/rDkuaUet5rLEoCtDgsoHyHP1JmS+5ey8MFgtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7F3+MRenkRoRSgH5UZ+VI9Ec5NSXcKN4+S/nRJG+fw=;
 b=kwEywh7wGBQrMIdCMndIshrYZVuibUxAWyEFnX4o7eLDCGVkdfW4Yl1ki9LUJRgJzx4nKUoAC7ANqEY19ZfTb3UXAohyvVrKYqQWcVQ9X6ei4I8e2Az5TmybpPtdgTGUTjYgKXadrQjzaaRY9cAyiT30VCJd2A2JKUhrQyDS50I=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN2PR04MB2174.namprd04.prod.outlook.com (2603:10b6:804:10::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Sun, 14 Jun
 2020 09:27:54 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3088.028; Sun, 14 Jun 2020
 09:27:54 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
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
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH v1 2/2] scsi: ufs: Add trace event for UIC commands
Thread-Topic: [PATCH v1 2/2] scsi: ufs: Add trace event for UIC commands
Thread-Index: AQHWQMuVYKwzY3Iyf0mpsLlh28O4SKjWW/nQgAA9dgCAAUDwkA==
Date:   Sun, 14 Jun 2020 09:27:54 +0000
Message-ID: <SN6PR04MB46403686B1E4AD37B8E9C178FC9F0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200612151000.27639-1-stanley.chu@mediatek.com>
         <20200612151000.27639-3-stanley.chu@mediatek.com>
         <SN6PR04MB4640968DCD865651AFA8925DFC9E0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <1592057910.25636.81.camel@mtkswgap22>
In-Reply-To: <1592057910.25636.81.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb02fcb1-d733-412f-b1ef-08d810453796
x-ms-traffictypediagnostic: SN2PR04MB2174:
x-microsoft-antispam-prvs: <SN2PR04MB217493B045F892F4F189D6E2FC9F0@SN2PR04MB2174.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04347F8039
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V45XYchI3GVVZW1zMftveKYgYsUbXKmWf6bvj8XFOIoPSVrAYpU3xYaTW06wCqq/14bIhcPztFFkQW6uBEBzSNO6zJ5pswLZzgXMxqaxIc1y6/1TeKWZItcdzHECorp4Lxs2sR+/4K8MlJAzGenO7fIOlsvPBxnaIlwuYIm1Qp2fpfvWGO6Pbh5dNjOMBvor+dPxf7iUmUvRwmOPZDXcwpxatgV8myeYrLp3Z+ytikcc+l30RzTx07+ZTKuiqYSzmVwkdXk2d/vhWj0iFJBfXdGtxWvvv8df7827avnrTur4YuUO2UKngPTto9VI1ZMTO9eNM4mw6L2B22EQmYVe1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(26005)(54906003)(316002)(186003)(2906002)(8936002)(52536014)(7696005)(5660300002)(6506007)(478600001)(9686003)(55016002)(33656002)(86362001)(66556008)(64756008)(66446008)(66946007)(7416002)(66476007)(83380400001)(71200400001)(6916009)(8676002)(4326008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8M94q/XdN5lKbRhrssP94m1p+ODWMH2QqyLi7v5F8UpTE+hwHeygEgiFepaYzuQPsd142pIzz8isLO5BCGx+l33n3OYgjU5S/DMu/r1RWOwSED/7hq09RoVGkByAJQIS2Jo7COTf0BhnZFkvyNaAT9UdHHDPKSkbARytFVY+5NNFAq3zpOHUP6peczjDinIugQK5c/WDAYhc+57lMVPAmftRK4mqr2aucncEH/OhsnaiebtQFJw11Ezrm+JL+OPs9DywCNB7pIaB5oY72aC/reMuk++BHQyM+QMEpzJq/uWgeIPUpW7z7m0GXFod9OW4tNROIBoYa/p68Ntf6xAFtJMAbmHFc1faY0O3twJTw8wcIQU/fe1AbKKgg5cxrC9k3jmkjDa5kNfD2cGbLTCt/9p/zbpaMWIZOYXkYyME4/H3FdIIUwwzGnPlkblY0vLFKAwAVG1q9JgIhhI2DRQmrzd5xX9nZIUWm66KwNeD+io=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb02fcb1-d733-412f-b1ef-08d810453796
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2020 09:27:54.2956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ikbCQm3osS2SSNYGGamYfSgTX2mstnmVesHgqfhNJk5tZGMbq8PVGwiglyhp8j9qk+PPESMq5Mq3XBQjg8FojA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2174
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpBY2tlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQoNCj4gDQo+IA0K
PiBIaSBBdnJpLA0KPiANCj4gT24gU2F0LCAyMDIwLTA2LTEzIGF0IDEwOjQ4ICswMDAwLCBBdnJp
IEFsdG1hbiB3cm90ZToNCj4gPiA+ICtzdGF0aWMgdm9pZCB1ZnNoY2RfYWRkX3VpY19jb21tYW5k
X3RyYWNlKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHN0cnVjdCB1aWNfY29tbWFuZCAqdWNtZCwNCj4gPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqc3RyKQ0KPiA+
ID4gK3sNCj4gPiA+ICsgICAgICAgdTMyIGNtZDsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgaWYg
KCF0cmFjZV91ZnNoY2RfdWljX2NvbW1hbmRfZW5hYmxlZCgpKQ0KPiA+ID4gKyAgICAgICAgICAg
ICAgIHJldHVybjsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgaWYgKCFzdHJjbXAoc3RyLCAidWlj
X3NlbmQiKSkNCj4gPiA+ICsgICAgICAgICAgICAgICBjbWQgPSB1Y21kLT5jb21tYW5kOw0KPiA+
ID4gKyAgICAgICBlbHNlDQo+ID4gPiArICAgICAgICAgICAgICAgY21kID0gdWZzaGNkX3JlYWRs
KGhiYSwgUkVHX1VJQ19DT01NQU5EKTsNCj4gPiBXaHkgb24gY29tcGxldGUgeW91IGNhbid0IGp1
c3QgdXNlIHVjbWQtPmNvbW1hbmQgYXMgd2VsbD8NCj4gDQo+IFJlYWRpbmcgcmVnaXN0ZXJzIGlz
IHJlYWxseSBoZWxwZnVsIGZvciBkZWJ1Z2dpbmcgdG8gY2hlY2sgaWYgaG9zdCBVSUMNCj4gY29t
bWFuZCByZWdpc3RlciByZWFsbHkgcmVjZWl2ZWQgdGhlIGNvbW1hbmQgYmVmb3JlLg0KPiANCj4g
QnV0IHRoZSBvcmlnaW5hbCByZXF1ZXN0aW5nIFVJQyBjb21tYW5kIHNoYWxsIGJlIGxvZ2dlZCBp
biB0cmFjZSBzbw0KPiB1Y21kLT5jb21tYW5kIGlzIGxvZ2dlZCBkdXJpbmcgInNlbmQiLCBhbmQg
dGhlIGNvbW1hbmQgaW4gcmVnaXN0ZXIgaXMNCj4gcmVhZCBhbmQgbG9nZ2VkIGR1cmluZyAiY29t
cGxldGVkIi4gVGhlbiB3ZSBjb3VsZCBzaW1wbHkgY2hlY2sgdGhlbSB0bw0KPiBrbm93IGlmIHNv
bWV0aGluZyB3cm9uZyB3aGlsZSBzZW5kaW5nIHRoZSBjb21tYW5kLg0KPiANCj4gVGhpcyBjb25j
ZXB0IGlzIHNpbWlsYXIgYXMgY3VycmVudCBVVFAgY29tbWFuZCB0cmFjZSBldmVudHMgdGhhdA0K
PiBkb29yYmVsbCByZWdpc3RlciBpcyByZWFkIGFuZCBkdW1wZWQgaW4gdGhlIHRyYWNlLg0KPiAN
Cj4gPg0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICB0cmFjZV91ZnNoY2RfdWljX2NvbW1hbmQoZGV2
X25hbWUoaGJhLT5kZXYpLCBzdHIsIGNtZCwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHVjbWQtPnJlc3VsdCwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHVmc2hjZF9yZWFkbChoYmEsIFJFR19VSUNfQ09NTUFORF9BUkdfMSksDQo+ID4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdfVUlD
X0NPTU1BTkRfQVJHXzIpLA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
dWZzaGNkX3JlYWRsKGhiYSwgUkVHX1VJQ19DT01NQU5EX0FSR18zKSk7DQo+ID4gV2h5IGNhbid0
IHlvdSBqdXN0IHVzZSB0aGUgdWNtZCBtZW1iZXJzPw0KPiA+IFdoeSBuZWVkIHRvIHJlYWQgdGhv
c2U/DQo+IA0KPiBBcyBhYm92ZSBzYW1lIHJlYXNvbiwgcmVhZGluZyByZWdpc3RlcnMgY2FuIGtu
b3cgd2hpY2ggYXJndW1lbnRzIGFyZQ0KPiBleGFjdGx5IHNlbnQgdG8gdGhlIGRldmljZS4NCj4g
DQo+IFRoaXMgaXMgdmVyeSBoZWxwZnVsIGZvciBmYXN0IGlzc3VlIGJyZWFrZG93biBpZiBVSUMg
Y29tbWFuZCBpcyBub3QNCj4gcmVzcG9uZGVkIHVuZGVyIGV4cGVjdGF0aW9uLg0KPiANCj4gSGVy
ZSwgd2UgYWxzbyByZWFsbHkgd2FudCB0byBrZWVwIHRoZSBvcmlnaW5hbCByZXF1ZXN0aW5nIGFy
Z3VtZW50cyBmcm9tDQo+ICJ1Y21kIiwganVzdCBsaWtlIFVJQyBjb21tYW5kLiBIb3dldmVyLCBh
cmd1bWVudHMgaW4gcmVnaXN0ZXIgd2lsbCBiZQ0KPiBjaGFuZ2VkIGFmdGVyIFVJQyBjb21tYW5k
IGlzIGRvbmUgc28gd2UgY2FuIG5vdCBkbyB0aGUgc2FtZSB3YXkgYXMgVUlDDQo+IGNvbW1hbmQu
IFNvIGEgY29tcHJvbWlzZSBpcyBoZXJlIHRoYXQgd2UgbG9nZ2VkIHRoZSBhcmd1bWVudHMgd2hp
Y2ggaG9zdA0KPiByZWdpc3RlciBleGFjdGx5IHJlY2VpdmVkIGluIHRyYWNlLg0KPiANCj4gPg0K
PiA+ID4gK30NCj4gPg0KPiA+DQo+ID4gPiArDQo+ID4gPiAgc3RhdGljIHZvaWQgdWZzaGNkX2Fk
ZF9jb21tYW5kX3RyYWNlKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+ID4gPiAgICAgICAgICAgICAg
ICAgdW5zaWduZWQgaW50IHRhZywgY29uc3QgY2hhciAqc3RyKQ0KPiA+ID4gIHsNCj4gPiA+IEBA
IC0yMDU0LDYgKzIwNzUsOCBAQCB1ZnNoY2RfZGlzcGF0Y2hfdWljX2NtZChzdHJ1Y3QgdWZzX2hi
YSAqaGJhLA0KPiA+ID4gc3RydWN0IHVpY19jb21tYW5kICp1aWNfY21kKQ0KPiA+ID4gICAgICAg
ICAvKiBXcml0ZSBVSUMgQ21kICovDQo+ID4gPiAgICAgICAgIHVmc2hjZF93cml0ZWwoaGJhLCB1
aWNfY21kLT5jb21tYW5kICYNCj4gQ09NTUFORF9PUENPREVfTUFTSywNCj4gPiA+ICAgICAgICAg
ICAgICAgICAgICAgICBSRUdfVUlDX0NPTU1BTkQpOw0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICB1
ZnNoY2RfYWRkX3VpY19jb21tYW5kX3RyYWNlKGhiYSwgdWljX2NtZCwgInVpY19zZW5kIik7DQo+
ID4gPiAgfQ0KPiA+ID4NCj4gPiA+ICAvKioNCj4gPiA+IEBAIC0yMDgwLDYgKzIxMDMsOSBAQCB1
ZnNoY2Rfd2FpdF9mb3JfdWljX2NtZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiA+ID4gc3RydWN0
IHVpY19jb21tYW5kICp1aWNfY21kKQ0KPiA+ID4gICAgICAgICBoYmEtPmFjdGl2ZV91aWNfY21k
ID0gTlVMTDsNCj4gPiA+ICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3Qt
Pmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+ID4NCj4gPiA+ICsgICAgICAgdWljX2NtZC0+cmVzdWx0
ID0gcmV0Ow0KPiA+ID4gKyAgICAgICB1ZnNoY2RfYWRkX3VpY19jb21tYW5kX3RyYWNlKGhiYSwg
dWljX2NtZCwgInVpY19jb21wbGV0ZSIpOw0KPiA+ID4gKw0KPiA+ID4gICAgICAgICByZXR1cm4g
cmV0Ow0KPiA+ID4gIH0NCj4gPiBDYW4ndCB5b3UganVzdCBjYWxsIHRoZSAic2VuZCIgYW5kICJj
b21wbGV0ZSIgZnJvbSB1ZnNoY2Rfc2VuZF91aWNfY21kPw0KPiANCj4gRm9yICJzZW5kIiwgd2Ug
d291bGQgbGlrZSB0byBsb2cgdGhlIHRpbWUgYXMgcHJlY2lzZSBhcyBwb3NzaWJsZSBzbw0KPiAi
c2VuZCIgZXZlbnQgaXMgbG9nZ2VkIHdoaWxlIFVJQyBjb21tYW5kIGlzIHNlbnQuDQo+IA0KPiBU
aGFua3Mgc28gbXVjaCEgWW91ciBxdWVzdGlvbiByZW1pbmRzIG1lIHRoYXQgInNlbmQiIHRyYWNl
IHNoYWxsIGJlDQo+IG1vdmVkIGJlZm9yZSBVSUMgY29tbWFuZCBpcyBzZW50IG90aGVyd2lzZSBy
ZWdpc3RlciB2YWx1ZSBtYXkgYmUgY2hhbmdlZA0KPiBiZWZvcmUgbG9nZ2luZyAic2VuZCIgdHJh
Y2UuIEkgd2lsbCBmaXggdGhpcyBpbiBuZXh0IHZlcnNpb24uDQo+IA0KPiBGb3IgImNvbXBsZXRl
ZCIsIHRvIG1ha2UgbG9nZ2luZyB0aW1lIGFzIGNsb3NlZCB0byBVSUMgY29tbWFuZA0KPiBjb21w
bGV0aW9uIGFzIHBvc3NpYmxlLCBtYXliZSBJIG5lZWQgdG8gY2hhbmdlIHRoZSBsb2dnaW5nIHRp
bWluZyB0bw0KPiB1ZnNoY2RfdWljX2NtZF9jb21wbCgpLCBqdXN0IGxpa2UgVVRQIGNvbW1hbmQg
Y29tcGxldGlvbiB0cmFjZSB3aGljaCBpcw0KPiBsb2dnZWQgaW4gX191ZnNoY2RfdHJhbnNmZXJf
cmVnX2NvbXBsKCkuDQo+IA0KPiBJZiB5b3UgaGF2ZSBubyBvYmplY3Rpb24sIEkgd2lsbCB0cnkg
dG8gZml4IHRoaXMgaW4gbmV4dCB2ZXJzaW9uLg0KPiANCj4gPg0KPiA+DQo+ID4gPg0KPiA+ID4g
QEAgLTM3NjAsNiArMzc4Niw5IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3VpY19wd3JfY3RybChzdHJ1
Y3QgdWZzX2hiYQ0KPiAqaGJhLA0KPiA+ID4gc3RydWN0IHVpY19jb21tYW5kICpjbWQpDQo+ID4g
PiAgICAgICAgICAgICAgICAgcmV0ID0gKHN0YXR1cyAhPSBQV1JfT0spID8gc3RhdHVzIDogLTE7
DQo+ID4gPiAgICAgICAgIH0NCj4gPiA+ICBvdXQ6DQo+ID4gPiArICAgICAgIGNtZC0+cmVzdWx0
ID0gcmV0Ow0KPiA+ID4gKyAgICAgICB1ZnNoY2RfYWRkX3VpY19jb21tYW5kX3RyYWNlKGhiYSwg
Y21kLCAidWljX2NvbXBsZXRlIik7DQo+ID4gPiArDQo+ID4gPiAgICAgICAgIGlmIChyZXQpIHsN
Cj4gPiA+ICAgICAgICAgICAgICAgICB1ZnNoY2RfcHJpbnRfaG9zdF9zdGF0ZShoYmEpOw0KPiA+
ID4gICAgICAgICAgICAgICAgIHVmc2hjZF9wcmludF9wd3JfaW5mbyhoYmEpOw0KPiA+ID4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2UvZXZlbnRzL3Vmcy5oIGIvaW5jbHVkZS90cmFjZS9ldmVu
dHMvdWZzLmgNCj4gPiA+IGluZGV4IDVmMzAwNzM5MjQwZC4uY2Y4ZDU2OGQ1YTEzIDEwMDY0NA0K
PiA+ID4gLS0tIGEvaW5jbHVkZS90cmFjZS9ldmVudHMvdWZzLmgNCj4gPiA+ICsrKyBiL2luY2x1
ZGUvdHJhY2UvZXZlbnRzL3Vmcy5oDQo+ID4gPiBAQCAtMjQ5LDYgKzI0OSwzOSBAQCBUUkFDRV9F
VkVOVCh1ZnNoY2RfY29tbWFuZCwNCj4gPiA+ICAgICAgICAgKQ0KPiA+ID4gICk7DQo+ID4gPg0K
PiA+ID4gK1RSQUNFX0VWRU5UKHVmc2hjZF91aWNfY29tbWFuZCwNCj4gPiA+ICsgICAgICAgVFBf
UFJPVE8oY29uc3QgY2hhciAqZGV2X25hbWUsIGNvbnN0IGNoYXIgKnN0ciwgdTMyIGNtZCwgaW50
DQo+IHJlc3VsdCwNCj4gPiA+ICsgICAgICAgICAgICAgICAgdTMyIGFyZzEsIHUzMiBhcmcyLCB1
MzIgYXJnMyksDQo+ID4gPiArDQo+ID4gPiArICAgICAgIFRQX0FSR1MoZGV2X25hbWUsIHN0ciwg
Y21kLCByZXN1bHQsIGFyZzEsIGFyZzIsIGFyZzMpLA0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICBU
UF9TVFJVQ1RfX2VudHJ5KA0KPiA+ID4gKyAgICAgICAgICAgICAgIF9fc3RyaW5nKGRldl9uYW1l
LCBkZXZfbmFtZSkNCj4gPiA+ICsgICAgICAgICAgICAgICBfX3N0cmluZyhzdHIsIHN0cikNCj4g
PiA+ICsgICAgICAgICAgICAgICBfX2ZpZWxkKHUzMiwgY21kKQ0KPiA+ID4gKyAgICAgICAgICAg
ICAgIF9fZmllbGQoaW50LCByZXN1bHQpDQo+ID4gPiArICAgICAgICAgICAgICAgX19maWVsZCh1
MzIsIGFyZzEpDQo+ID4gPiArICAgICAgICAgICAgICAgX19maWVsZCh1MzIsIGFyZzIpDQo+ID4g
PiArICAgICAgICAgICAgICAgX19maWVsZCh1MzIsIGFyZzMpDQo+ID4gPiArICAgICAgICksDQo+
ID4gPiArDQo+ID4gPiArICAgICAgIFRQX2Zhc3RfYXNzaWduKA0KPiA+ID4gKyAgICAgICAgICAg
ICAgIF9fYXNzaWduX3N0cihkZXZfbmFtZSwgZGV2X25hbWUpOw0KPiA+ID4gKyAgICAgICAgICAg
ICAgIF9fYXNzaWduX3N0cihzdHIsIHN0cik7DQo+ID4gPiArICAgICAgICAgICAgICAgX19lbnRy
eS0+Y21kID0gY21kOw0KPiA+ID4gKyAgICAgICAgICAgICAgIF9fZW50cnktPnJlc3VsdCA9IHJl
c3VsdDsNCj4gPiA+ICsgICAgICAgICAgICAgICBfX2VudHJ5LT5hcmcxID0gYXJnMTsNCj4gPiA+
ICsgICAgICAgICAgICAgICBfX2VudHJ5LT5hcmcyID0gYXJnMjsNCj4gPiA+ICsgICAgICAgICAg
ICAgICBfX2VudHJ5LT5hcmczID0gYXJnMzsNCj4gPiA+ICsgICAgICAgKSwNCj4gPiA+ICsNCj4g
PiA+ICsgICAgICAgVFBfcHJpbnRrKA0KPiA+ID4gKyAgICAgICAgICAgICAgICIlczogJXM6IGNt
ZDogMHgleCwgYXJnMTogMHgleCwgYXJnMjogMHgleCwgYXJnMzogMHgleCwgcmVzdWx0Og0KPiAl
ZCIsDQo+ID4gPiArICAgICAgICAgICAgICAgX19nZXRfc3RyKHN0ciksIF9fZ2V0X3N0cihkZXZf
bmFtZSksIF9fZW50cnktPmNtZCwNCj4gPiA+ICsgICAgICAgICAgICAgICBfX2VudHJ5LT5hcmcx
LCBfX2VudHJ5LT5hcmcyLCBfX2VudHJ5LT5hcmczLCBfX2VudHJ5LT5yZXN1bHQNCj4gPiA+ICsg
ICAgICAgKQ0KPiA+IFBlcnNvbmFsbHksIGFzIHRob3NlIHRyYWNlIGV2ZW50cyBhcmVuJ3QgdmVy
eSBodW1hbiByZWFkYWJsZSBhbnl3YXksIEkNCj4gd291bGQganVzdCBkdW1wIHRoZSB1aWMgY29t
bWFuZCwNCj4gPiBBbmQgbGV0IHRoZSBwYXJzZXJzIGRvIHRoZWlyIGpvYi4NCj4gPiBBbmQgaWYg
dGhpcyBpcyB0aGUgY2FzZSwgcmVzdWx0IGlzIHJlZHVuZGFudCBhcyBpdCBpcyBwYXJ0IG9mIGFy
ZzINCj4gDQo+IE15IG9yaWdpbmFsIHRob3VnaHQgaXMgdG8gbG9nIHNvbWUgZXhjZXB0aW9ucywg
bGlrZSAiLUVUSU1FRE9VVCIgaW4NCj4gInJlc3VsdCIuIEJ1dCBpZiBJIGNoYW5nZWQgImNvbXBs
ZXRpb24iIHRyYWNlIGhhbmRsaW5nIHRvIGludGVycnVwdA0KPiBoYW5kbGVyLCB0aGVyZSB3aWxs
IGJlIG5vIGNoYW5jZSB0byBsb2cgdGhvc2UgZXhjZXB0aW9ucy4gVGhpcyBpcyBPSw0KPiBiZWNh
dXNlIFVUUCB0cmFjZSBpcyBleGFjdGx5IGJlaGF2ZSB0aGlzIHdheTogTm8gY29tcGxldGlvbiBl
dmVudCBpbg0KPiB0cmFjZSBpZiByZXF1ZXN0IGlzIG5vdCBiYWNrLiBBbmQgaWYgdGhpcyB3YXkg
aXMgaW1wbGVtZW50ZWQsICJyZXN1bHQiDQo+IGlzIGRlZmluaXRlbHkgcmVkdW5kYW50IGFuZCBz
aGFsbCBiZSByZW1vdmVkLg0KPiANCj4gVGhhbmtzLA0KPiBTdGFubGV5IENodQ0KDQo=
