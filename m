Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A14AC4708D
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 07:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D7A5611CD
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 07:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbhE1HcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 03:32:11 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:30286 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbhE1HcK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2021 03:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622187035; x=1653723035;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XC4OCbdPT/OgR8xq5cUX1oiAdTgZflA/RbTm6sJCNOM=;
  b=cTDn97zb3DXjL8fbvofn02/Sibx3PNWblZETAodDADipVaWpaoDP4MoY
   1AztQXHJ4k5WSAsIfIqXl89XvqFESCNoCANFdGXp29Rjy4T++pfznrOam
   bZyzPkd44nQYJeQeIXKwRI3S+pZ6z51wXMV4ufxduM5XUyM/lbYyO206z
   d5gMurNO7IhXKCdXh7spk4P54elE0ShZ6uotnFMH7mwjM5G6mrgddfcJS
   0JsscchY0lywqjbGmPPFuJ99Txv/bl77EOA6oDYQuNeKCA0x+YfEZxWTk
   8jK3GW4mW0QY998d0vIeKymASDL/QUoE0ahH/SSR6phI8yGU8ayzOrWVF
   A==;
IronPort-SDR: 5+QNhbE5zmXP//EUXrEjci0AJ57OgxNoafyZWB1OD3HncNeRZAXt9r0IqUzf2Zz0LZr9rZLnUN
 YR4MhkDNxjPL5Cl7rgdDMtL+bTfA1YuGEQU7pl+us6pRgIRgAB5oF+iln/hElO0BXQncWeTsa7
 m17Be0mH3SPuymU95twrBBRHz6oJesd7yruRyiL+izmLLhlxiASO+y2qM3cuBlHDFj9iZzM4I2
 2oAnfO/JtWCOjftadqvXQnYIxP8I6dpAk0lK9y+whvGlMjntAA0S18hPX4Nt0nMvjpZtJJT6gB
 2So=
X-IronPort-AV: E=Sophos;i="5.83,229,1616428800"; 
   d="scan'208";a="281126130"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 28 May 2021 15:30:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afe0oCL0eEGJbs5sQEFIa98/4rcjRMVjLr6/3LN4YJtjQmj21IhFIVKOV30d3X3dAfvfwIHouYMfDftq4NaxGG/4ryagBsZ8XF5aL7ryGyNB+zJqpgNBH3/0Q+m4bXV1lPix4hqhmtrWVhzCLuKnf+wIYEncfiBFv0NKD9+zuNt2HpyCmMDBFUiue9B5amD+/RQA2649DPqIDRwd9RgwOMiEA0RLJ9+EPBKvmoMkV1IQTEAo4WulU1XQJ7FQXxm7WgCg/zo/SHsr7HWXUgZtsr84fld4K26eZYkOQobTaTpd496g/VxmxyBKb+ab3QUg0gpofrc5T3/zq3E27/F6tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XC4OCbdPT/OgR8xq5cUX1oiAdTgZflA/RbTm6sJCNOM=;
 b=LIt+rS1TTwvSPJjgwNAz9l9VMrOFeUGsP4cmev4Cw6q/qrRm0bdd8jsdLSWynfrq7AMuCBtdh0fFdY6wGwAL3jLEiTm+UAXL4EEXmROcE//hS9jguZ0JTVxnNpKeRb6F4luhI11PtXyIybu4NcbHmXz6jX4W3gt1D33lQ6ulGRHRlPeu1zxCTQTXmx2wyw/3bZiez6EPMcAtXk7jUt2Bi9fNKkbq/vlLrtZ7afgsaDdlM2VOU0qKzK6SjZvXNk6wa9roY0tg+lh98Z8c2tESDhaF3uh9NmgGX6YtZlX85lJ94PB7SgreSNSz1vhPuT7OJE1mifY+Tv1D7OMmmLuMXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XC4OCbdPT/OgR8xq5cUX1oiAdTgZflA/RbTm6sJCNOM=;
 b=RxWW0XypVXmFoSWyQ+8NZDw2VLOTn2NQgGE/dmNoyyXGYrWQvjTfRAtUqQE8h68mMY9freg5HCUfnLcZppJFWTsJG5R9kFBcyC04UMZXjqeUYLbLkgsCDSU0ZXrzworlSqqWc/l9kCV/q7iyDKangTQ0RX8UcH5ub/oeHzlBBmc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3654.namprd04.prod.outlook.com (2603:10b6:4:79::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.24; Fri, 28 May 2021 07:30:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%6]) with mapi id 15.20.4173.022; Fri, 28 May 2021
 07:30:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
CC:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
Thread-Topic: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer
 requests send/compl paths
Thread-Index: AQHXUHgHUX4+5y22lkmg8exJdO90rKrzENmAgABaTgCAAHAxUIAEqb/w
Date:   Fri, 28 May 2021 07:30:32 +0000
Message-ID: <DM6PR04MB657525D67B70FF3418511694FC229@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
 <41a08b3e-122d-4f1a-abbd-4b5730f880b2@acm.org>
 <d4ff8e1a-f368-6720-798a-a2a31a4d41fb@codeaurora.org>
 <DM6PR04MB65752DD2F442C178B2D0233AFC259@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB65752DD2F442C178B2D0233AFC259@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aade9801-e71c-4c21-3c3e-08d921aa7a0f
x-ms-traffictypediagnostic: DM5PR0401MB3654:
x-microsoft-antispam-prvs: <DM5PR0401MB3654CA2BCD99998F24F70841FC229@DM5PR0401MB3654.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fXHFAEjhMPTaFbNoJ2uVKeDRzePC97T7wRVzpmx6m3QW19lk7BK8W+GsySuMcCQivPk8QTeA4GyC6IRDQfIaT9LnrvlLOrGjgrAYNNFpx2q6O1QUlwPWb87rtl1/ntRTyKAMQUJRzkPWWxm5LSGeFM0q5/LTrHuPf5OkYLlIxf1EMbngz4Wc0Wg/fIhSrbbdz3dUlTL0U/GywEktrX8kz2U5JClYF9CGcT8WM2vAMaX6Qug9ewiEm71bd5YcQrFqN5Us029T+z9IVRRQ1uyWdZRno4LVpwtAv/0q8hG4A/BDNWIcwVFnqKBDgBnlM1Ezt3n9lMJ18WjOPio5gUj/odIOKKW48GEy6LZjvY+ClO3hq8HcyNQ3AHXH77tYegKXHXpoJuTD+oZ+HxJnzVXB5Tu0dnckSAAeJSdiwmD0ADF9R6mYt+t/1cyEX7ZGHlN6D4dllhjLyeL6r3QIrregRp8RN99bOWlskHoOSdAJtNuNBZW0VKE2L2Wk0pHojHSJoI8wNa9f6o/KbEee0x7HDCCMbQfVujrT+AUvYzAepq2OGKdlTjtWjhSvi58mIvdzA8ZFEW/rs80CGRODUiooKWTXpdIVyExM83ZXT3MeBTQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(7416002)(53546011)(7696005)(26005)(6506007)(54906003)(110136005)(478600001)(83380400001)(316002)(55016002)(71200400001)(66946007)(76116006)(8676002)(64756008)(66556008)(66476007)(4326008)(5660300002)(8936002)(52536014)(122000001)(2906002)(86362001)(66446008)(38100700002)(9686003)(186003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TFJZcnhHRXo5VTg2c29nanNnQXdDQi80bjRyVkQ1Z2kyVU50RE5IWEd3S09O?=
 =?utf-8?B?N0wxVm5ZOE9NbHBab2Q1VFZ1cDc5d0FhVGFQdE9oek5KcE9YeW04b0ZOOWl2?=
 =?utf-8?B?eFF4WXlZZ0dlTit0NExmOGR1cmFFVXMwSTE2MDJEWVFzaUw1d3k2U3dlS0Nr?=
 =?utf-8?B?ZkV5OWlIWkNFS1FzUUZkQS9USzJBNldxOStJeU1jRURyOWR2aWk4VGNHNW9S?=
 =?utf-8?B?dEtYRmpPRStlK0VKbnN6bmZYRENvOFJtRys4eFprVzJyQUgwa2d0bnJ6YW9u?=
 =?utf-8?B?d2FMS1YvM1FsWWVIVS9YRE51L0dVUnJFRGxsMFk1MENkTVoxa3EyUlFQNUlB?=
 =?utf-8?B?ZlRtM1RCa21vd3phUTZ4T1pBaVBIWktjeDkwa25CMFMwUCtiZ1dYSi9va2dD?=
 =?utf-8?B?SE5EMzlUNUpubjNZUXd4SXdyR1VqUWVSVjg4NlFkdUl4Sk0xaUNicHl3bzdw?=
 =?utf-8?B?amZSeDl6N3pWNjJtMmlGc2Fma3NueWUwSjNMeG14UEZWajd2R2ZURmp1ZmY0?=
 =?utf-8?B?cEp4MzlHUUo3bTlKS0xnaksrek1oZTdJMWZDK3RRbDNlUGZKMGdGeE4xb204?=
 =?utf-8?B?UFEyOVEvdFFaRHhHcU1rWmxyd2tqMFJ0LzVlb3ZKd2tuZEpmN05La1paUGEz?=
 =?utf-8?B?QXo5OHN3Zlh4bHFGR05HdlA0Vkx2ZVVkTk5qU1BWbW1Lb0FiYW1NVnpqUmJG?=
 =?utf-8?B?VjNXazkvTDBRUmc5QlZmemhZcjVuaU1EMmJOVHJTU2lrSEx3OXV2YnRPdHNq?=
 =?utf-8?B?ZUZMTkIvZnB6cS9sbUVJM282bHRYL2NvK2wyMEhJdGtZODdzNE9SbFdYYTdp?=
 =?utf-8?B?OXdoL1JOcnlHL1NPR0ZEYjEwOTREaTRJMWgwUDlPQUp1V1hncGVsMWhqeU1D?=
 =?utf-8?B?VGNqUjdOM212YkRNTUgvanJlcG05cXk0eFBKc0p6U2I4Nit1M2NNZ3pucytJ?=
 =?utf-8?B?ZmZlakIzMGJYdm45cllycXJOYUNOdTliQXBoa3Mxc0g0VXM4bytaTTNicENY?=
 =?utf-8?B?L0NwT3J2bTNYY3BWamVOUjdRL3JHRVZ5Sk1lbzVPQ0k1ZDRSOUFhcU0zRFBk?=
 =?utf-8?B?bUZybExJWkVZRFZGalVENS9QL3VGNGtyeU1TbVhVbVNEci9XTTNPcVhxZDVC?=
 =?utf-8?B?MitPT3BTMXJEZkNTWXZoOWFLYnM2anhyZkNhY2QraFdvaFZkNm9KTk1YeGlN?=
 =?utf-8?B?RXFKZjdINnRZQUxRMEpHRjNKMFNlR01BVnR5QURzRVlZNG1XTmlQNEs2blRv?=
 =?utf-8?B?Ri9aWFdJZURKMXAzYzZsWldiVmlPMFIxOTlBS3hQclJsVFZ6RmtPczFnRFls?=
 =?utf-8?B?N0xxTUZ6c3VYOUVQV2lOYnJsNXFpRy9HR2MyZXM0TGNlVkVTRExtSk16OWtQ?=
 =?utf-8?B?VEh6dkhBbXRYdWdkcTIwNkg1emowMzJwQUpQTFdhM243WXhkZnhERzNPem1U?=
 =?utf-8?B?bzA4bzMyNW13by9hdmlYdWlsWTFkY2Mzb2lvcGJNRGd4eVBxaThTOTd0blZZ?=
 =?utf-8?B?anlHM1hKVFJra3NuU2llcVRHWW54QzNaRGdsdlA4ek9LMVgrUzZwVzYzalNW?=
 =?utf-8?B?K2kyditCbkQ1VHEwREVJL3J5ZXVDR1hFZ3c0OGRiMXduYzUyK0xCMk5xSElB?=
 =?utf-8?B?RUZwYk9NQWV2cXhHVjdldTRLU01nOWY1c0ZzU0V4SXQ5Tnl3cDhpTndEejMz?=
 =?utf-8?B?Y1MxRmcwTXV0WGt5Z0E4T1dRMWJzQzh4UllPZmx0VlQ5TEZKMFQ2N3dBOUlH?=
 =?utf-8?Q?NlZJwSYsVKqJX1+52M=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aade9801-e71c-4c21-3c3e-08d921aa7a0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 07:30:32.4705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z3lTjVv5IXDpvbInHVBiCPLiMwcbBBQbM7QXHOZIPXkSKVlEs7atBrBf+PnGTGU7kNlz5hjMv6F7aTRMbYFXew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3654
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+IE9uIDUvMjQvMjAyMSAxOjEwIFBNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gPiBP
biA1LzI0LzIxIDE6MzYgQU0sIENhbiBHdW8gd3JvdGU6DQo+ID4gPj4gQ3VycmVudCBVRlMgSVJR
IGhhbmRsZXIgaXMgY29tcGxldGVseSB3cmFwcGVkIGJ5IGhvc3QgbG9jaywgYW5kDQo+IGJlY2F1
c2UNCj4gPiA+PiB1ZnNoY2Rfc2VuZF9jb21tYW5kKCkgaXMgYWxzbyBwcm90ZWN0ZWQgYnkgaG9z
dCBsb2NrLCB3aGVuIElSUQ0KPiBoYW5kbGVyDQo+ID4gPj4gZmlyZXMsIG5vdCBvbmx5IHRoZSBD
UFUgcnVubmluZyB0aGUgSVJRIGhhbmRsZXIgY2Fubm90IHNlbmQgbmV3DQo+ID4gcmVxdWVzdHMs
DQo+ID4gPj4gdGhlIHJlc3QgQ1BVcyBjYW4gbmVpdGhlci4gTW92ZSB0aGUgaG9zdCBsb2NrIHdy
YXBwaW5nIHRoZSBJUlEgaGFuZGxlcg0KPiA+IGludG8NCj4gPiA+PiBzcGVjaWZpYyBicmFuY2hl
cywgaS5lLiwgdWZzaGNkX3VpY19jbWRfY29tcGwoKSwgdWZzaGNkX2NoZWNrX2Vycm9ycygpLA0K
PiA+ID4+IHVmc2hjZF90bWNfaGFuZGxlcigpIGFuZCB1ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBs
KCkuIE1lYW53aGlsZSwgdG8NCj4gPiBmdXJ0aGVyDQo+ID4gPj4gcmVkdWNlIG9jY3B1YXRpb24g
b2YgaG9zdCBsb2NrIGluIHVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKSwgaG9zdA0KPiBsb2Nr
DQo+ID4gaXMNCj4gPiA+PiBubyBsb25nZXIgcmVxdWlyZWQgdG8gY2FsbCBfX3Vmc2hjZF90cmFu
c2Zlcl9yZXFfY29tcGwoKS4gQXMgcGVyIHRlc3QsDQo+IHRoZQ0KPiA+ID4+IG9wdGltaXphdGlv
biBjYW4gYnJpbmcgY29uc2lkZXJhYmxlIGdhaW4gdG8gcmFuZG9tIHJlYWQvd3JpdGUNCj4gPiBw
ZXJmb3JtYW5jZS4NCj4gPiA+DQo+ID4NCj4gPiA+IEFuIGFkZGl0aW9uYWwgcXVlc3Rpb24gaXMg
d2hldGhlciBpdCBpcyBuZWNlc3NhcnkgZm9yIHYzLjAgVUZTIGRldmljZXMNCj4gPiA+IHRvIHNl
cmlhbGl6ZSB0aGUgc3VibWlzc2lvbiBwYXRoIGFnYWluc3QgdGhlIGNvbXBsZXRpb24gcGF0aD8g
TXVsdGlwbGUNCj4gPiA+IGhpZ2gtcGVyZm9ybWFuY2UgU0NTSSBMTERzIHN1cHBvcnQgaGFyZHdh
cmUgd2l0aCBzZXBhcmF0ZSBzdWJtaXNzaW9uDQo+ID4gYW5kDQo+ID4gPiBjb21wbGV0aW9uIHF1
ZXVlcyBhbmQgaGVuY2UgZG8gbm90IG5lZWQgYW55IHNlcmlhbGl6YXRpb24gYmV0d2VlbiB0aGUN
Cj4gPiA+IHN1Ym1pc3Npb24gYW5kIHRoZSBjb21wbGV0aW9uIHBhdGguIEknbSBhc2tpbmcgdGhp
cyBiZWNhdXNlIGl0IGlzIGxpa2VseQ0KPiA+ID4gdGhhdCBzb29uZXIgb3IgbGF0ZXIgbXVsdGlx
dWV1ZSBzdXBwb3J0IHdpbGwgYmUgYWRkZWQgaW4gdGhlIFVGUw0KPiA+ID4gc3BlY2lmaWNhdGlv
bi4gQmVuZWZpdGluZyBmcm9tIG11bHRpcXVldWUgc3VwcG9ydCB3aWxsIHJlcXVpcmUgdG8gcmV3
b3JrDQo+ID4gPiBsb2NraW5nIGluIHRoZSBVRlMgZHJpdmVyIGFueXdheS4NCj4gPiA+DQo+ID4g
SGkgQmFydCwNCj4gPiBObyBpdCdzIG5vdCBuZWNlc3NhcnkgdG8gc2VyaWFsaXplIGJvdGggdGhl
IHBhdGhzLiBJIHRoaW5rIHRoaXMgc2VyaWVzDQo+ID4gYXR0ZW1wdHMgdG8gcmVtb3ZlIHRoaXMg
c2VyaWFsaXphdGlvbiB0byBhIGNlcnRhaW4gZGVncmVlLCB3aGljaCBpcw0KPiA+IHdoYXQncyBn
aXZpbmcgdGhlIHBlcmZvcm1hbmNlIGltcHJvdmVtZW50Lg0KQnR3LCBJcyB0aGlzIHBlcmZvcm1h
bmNlIGltcHJvdmVtZW50IGlzIG9uIHRvcCBvZiBycV9hZmZpbml0eSAyIG9yIDE/DQoNClRoYW5r
cywNCkF2cmkNCg0KPiA+DQo+ID4gRXZlbiBpZiBtdWx0aXF1ZXVlIHN1cHBvcnQgd291bGQgYmUg
YXZhaWxhYmxlIGluIHRoZSBmdXR1cmUsIEkgdGhpbmsNCj4gPiB0aGlzIGNoYW5nZSBpcyBhcHQg
bm93IGZvciB0aGUgY3VycmVudCBhdmFpbGFibGUgc3BlY2lmaWNhdGlvbi4NCj4gSSBhZ3JlZSAt
IHRoaXMgbG9va3MgbGlrZSB0aGUgaGFyYmluZ2VyIG9mIGEgbWFqb3IgY2hhbmdlLA0KPiBBbmQg
Z29pbmcgZnVydGhlciB3aXRoIHJlc3BlY3Qgb2YgaHcgcXVldWVzLA0KPiB3aWxsIG5lZWQgdGhl
IHNwZWMgc3VwcG9ydCAtIGUuZy4gZG9vcmJlbGwgcGVyIGxhbmUsIGV0Yy4NCj4gDQo+IFRoYW5r
cywNCj4gQXZyaQ0KPiANCj4gPiA+IFRoYW5rcywNCj4gPiA+DQo+ID4gPiBCYXJ0Lg0KPiA+ID4N
Cj4gPg0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IC1hc2QNCj4gPg0KPiA+IC0tDQo+ID4gVGhlIFF1
YWxjb21tIElubm92YXRpb24gQ2VudGVyLCBJbmMuIGlzIGEgbWVtYmVyIG9mIHRoZSBDb2RlIEF1
cm9yYQ0KPiA+IEZvcnVtLA0KPiA+IExpbnV4IEZvdW5kYXRpb24gQ29sbGFib3JhdGl2ZSBQcm9q
ZWN0DQo=
