Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3762FC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 06:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE29321941
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 06:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="ytCcT4wJ";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="KBOldyq/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgI1GiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 02:38:16 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:54127 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgI1GiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 02:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601275093; x=1632811093;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vnfud01dkwQj1HlPTyEq3hpM6gUGZap7CXKsEeMI2Mc=;
  b=ytCcT4wJCOEZjpG4KYJyyyOP5rcva6qbyx74cuVbAiGyWeGChaq0/zH2
   gKxO1RR5htMgdmcnv2TKBP7qEWxjvLBw3YrMH1dMKglmMMVRJyMnB114D
   YGej8s5c0f5oSZ2bf4KApJ2t3WsW/4tfupXVsOdnzYOdzGBkXpXOuSOST
   zymFASn/+qFAgniiv/wUb2gX67jUOD5GSNE/Qee4zWDYY7sJhGUndX1Di
   uPrWb0wOKr5mYlziQgRUlGB5tyoHM2dtoDynZfpxxMQAtlZdyrp4tLUhu
   0uMMJH6DaP22h62urabc3xbCzmOzq9wgzWl7VLzKl7J8noxj0mc1u/DcN
   A==;
IronPort-SDR: 7eWsv4qgG25IVXPCcKfo1DsxhjN4tC+i3qyiqv0wacp7t2Wo8n3PLxPGSLsrmAKORyUDnTigCW
 QSo/u8hnvauKBSEwcGQs+oGEnJNZJvD0O4HM+N8eDJGFr6u5vN/m3m3bkcDOhKhLzePv1/AOlG
 mNq7BaiIPY0r79XSY1UOQU7SXELsKS07aTxuM9R842pLn+1p/f0jH9s8MkV0jIO4ZrDyzE7IF+
 kRrEGnKdLM8Sr1H4RyZxjJ6eZRCyr1AvIKAp/hOomi5YOAQkicdE+UzHnQmCaApS3NdKhiqu/W
 H3Y=
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="92588841"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Sep 2020 23:38:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 27 Sep 2020 23:38:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Sun, 27 Sep 2020 23:38:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzSaWNMjxf9/VaMe+8HR++L/7zf64UBxbVcEvhqFUcOgZdUMansNIfKKGwpKpro4W2bTT+e7Bs5R2p1JoMOuzifH7OnsY9w9ggcj6vNgBZy6Q3Kz0h0H13ZGpMwTrHcwaOmrySfwGtmZ52Zyv0DQOTDsNddiAjBterxSk7DrUthYPyVa3tLzqEI1blbQ7zyMrj5I1N+TDAF5vtmviegIgbAfDbC+Wc/Y2SIZmG/FP65y0P5QhRfB9F51kE5ik6oFnXagTxTmwTNFotLv/k6164KEbHBZEq7HHuX3HC1NXfP7IPATMHkd7RTRVEf0RsQiepISd3jhUidYSux3E0zAhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnfud01dkwQj1HlPTyEq3hpM6gUGZap7CXKsEeMI2Mc=;
 b=aKeU4IKFjqkmR+iSq6RVWtv4XHo3OXD9B3PMa6Hqu+nIxYw1Y7ViBKqXoGgWvNPNllpdZ2yAigzdarip9BSf33Dbn8Y80RXE1OLC2tRTrVhyvtWxnDWv12/ECD8NkWnBIYi4vrgfi6sG4WSnOAANphlmshaTEFXszb4CF9ARkdkDuftCTwMNV9gRkZTk7vHI8LrWlyW4D2mXJFCRZgA1+LC6iCy85ikTf2m8CHB6wtr53zZgPR7bXO+tmFUl0EIMZrIxy7Of9S/CUku9HiUdZzemSYEXF50CGItyS8iHBFphjtksAmumIuufZM2iYpl51ZQE45dum0d5Jx9BDxJsIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnfud01dkwQj1HlPTyEq3hpM6gUGZap7CXKsEeMI2Mc=;
 b=KBOldyq/wNl1J3Mz6dPZVmfhuym0erf9zlEqqPCLQQVLK0bcPA3v0RUuxVRl2MXAA1WpqkiAiXWIOj70NRDMhZcWKV01iynbDk2ngioMx19IZe3zmKdpfc/krKAiPQ24rxD/DiLctoqrapr8BycYEdBoJT0SaoUCa/5iUXimKsw=
Received: from SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27)
 by SN6PR11MB3102.namprd11.prod.outlook.com (2603:10b6:805:d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Mon, 28 Sep
 2020 06:38:09 +0000
Received: from SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::ecf3:84c8:5f1e:c734]) by SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::ecf3:84c8:5f1e:c734%7]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 06:38:09 +0000
From:   <Viswas.G@microchip.com>
To:     <jinpu.wang@cloud.ionos.com>, <john.garry@huawei.com>
CC:     <Viswas.G@microchip.com.com>, <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Ruksar.devadi@microchip.com>
Subject: RE: [PATCH 3/4] pm80xx : Increase the number of outstanding IO
 supported
Thread-Topic: [PATCH 3/4] pm80xx : Increase the number of outstanding IO
 supported
Thread-Index: AQHWkwIEKsxLVwrs+E+okaZB9ru9/al5Hk0AgAAESoCABHKY4A==
Date:   Mon, 28 Sep 2020 06:38:09 +0000
Message-ID: <SN6PR11MB34887FAC24FAB243D13F7BE29D350@SN6PR11MB3488.namprd11.prod.outlook.com>
References: <20200925061605.31628-1-Viswas.G@microchip.com.com>
 <20200925061605.31628-4-Viswas.G@microchip.com.com>
 <c0603b76-28a6-4fe7-89c5-129ea0d6b344@huawei.com>
 <CAMGffEk-2XYp=o1fDHV7sP3rhsfc_1URzULp24JfXhcX5KfEgQ@mail.gmail.com>
In-Reply-To: <CAMGffEk-2XYp=o1fDHV7sP3rhsfc_1URzULp24JfXhcX5KfEgQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: cloud.ionos.com; dkim=none (message not signed)
 header.d=none;cloud.ionos.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [43.229.88.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 786e688a-2db3-4e50-47f9-08d8637910da
x-ms-traffictypediagnostic: SN6PR11MB3102:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB310240DBD645C84FE6CA9FF79D350@SN6PR11MB3102.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W+UOwEPFzGOI3HKt+XAcT7xR1dgnQH5KS+CS/+xxVHulxXNz7bRXEJDjrwCZRcTBqMhhqGdaRaUvwdqfI6W6gWhpnOHOk/ulej1g9hV+bjmBPotsSeu6plKMJc+LzM6GjPIk6Gaq9NRdlXADw+hs4gUVWClO061rtbpgyT6DeLMVnUwcJwClXB2ruqpWYPVi3vA7v1Lmr/Jx0C29fd3iDaJmOvOyUO2zDPS13WwqEc+QAuyawSDeGP2Jg2gIab7VYet/JPlwyZREWvyIkD5CJOY+xLX2ijkEODXF+VyohQu+0ci+Q95jZqPUuH6GxIkvWKl9YWsUYSMO28UIzNbpK75f2juVCkMtkI5VfsF79zq7BFGoYin8/YOeIo6wMPdP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(39860400002)(376002)(55016002)(33656002)(83380400001)(9686003)(8676002)(8936002)(2906002)(5660300002)(52536014)(7696005)(6506007)(64756008)(66446008)(66556008)(66476007)(53546011)(66946007)(71200400001)(478600001)(55236004)(76116006)(316002)(110136005)(54906003)(86362001)(26005)(186003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SyFXLcNOWb1O+qaQAM5BvPblWhKLrRQhmnYEwWwzKdD9qWDVM8YXYXcvT5b8YjSudoqsXs2IF1m3yve72U/aAnA4K069Yc7N7y7dE4mzc8GbgbPgFgdsqgEklS/1TPvTkxIytO/RpnokxgX28CWqujikVNIeLytot+8E5qWYsmp5nJ8INc+z/ksDpjGYFMDNLnspV/bpUyIYnE3ZtLh1oY6Da0Z5eRBWIbIyki+GBYeEZQL26/P9LIyArjgR0hm3B/VBL+59oMmYrornw7zb666xG+lKgHN07vleU40EWB8/gvcRDs4U5wVZEjKlE7bD5pAQZl3zLDRa6q6CDLp67q3VPZbohYtbp28wakqAgBoTj0Fd9XV0XkgBtTHeXBm1/BPWcxxB95TwOcWFJ6d7We3TYLu3ElbPB8aTipcHV6AYm8zmpuCI77u9+/8KV90s7JAAl4Fb2Gw5V/Ead3HOzsEoW7xOjxCVTk5Qv7u5ZrjZjHk2ekGGDks6xsNHsVTIUMInawfXkimu5rjZzYY+HvPp+qWDCvM6z7+Lc1eLazHQoU+JzxIDVoo/GjG5Jxs5gC3onePgIoBYObgnkn/lXFv9UmeR7c5cDZ9urmuAR1iHr9CiaB97mt6yh9KSUuJhS+zmiyGX0pbCco3rW8t6bA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 786e688a-2db3-4e50-47f9-08d8637910da
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 06:38:09.5729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w3jk53nmZkVdDvLfeZ3Prqzj8QMryYJTKgY4ZFBUZkF8qjGGQtYvLdtI1ucyO2YQpLKt4g1Ck4xXVEMQ1PxhCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3102
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmsgeW91IEppbnB1IGFuZCBKb2huIGZvciB0aGUgcmV2aWV3Lg0KDQpXZSBhcmUgeWV0IHRv
IGFkZCB0aGlzIHN1cHBvcnQgaW4gdGhlIGRyaXZlciB0byBtYWtlIHVzZSBvZiB0aGUgYmxvY2sg
bGF5ZXIgcmVxdWVzdCB0YWcuIFdlIGFyZSBwbGFubmluZyB0byBhZGQgdGhhdCBmZWF0dXJlIGlu
IG91ciBhc3luYyBkcml2ZXIgZmlyc3QgYW5kIHNlZSB0aGUgcGVyZm9ybWFuY2UgaW1wcm92ZW1l
bnRzIGFuZCBkbyBhIGZ1bGwgUUEgdGVhbSB2YWxpZGF0aW9uIGJlZm9yZSBzdWJtaXR0aW5nIHRv
IG9wZW4gc291cmNlLiBUaGUgY3VycmVudCBwYXRjaCBzZXQgd2FzIGNyZWF0ZWQgYmFzZWQgb24g
b3VyIGFzeW5jIGRyaXZlciB3aGljaCBoYXMgYmVlbiB0ZXN0ZWQgYnkgb3VyIFFBIHRlYW0uIFdl
IGNvdWxkIHNlZSBzb21lIHBlcmZvcm1hbmNlIGJvb3N0IHdpdGggdGhlc2UgY2hhbmdlcyBhcyB3
ZWxsLiANCg0KUmVnYXJkcywNClZpc3dhcyBHDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gRnJvbTogSmlucHUgV2FuZyA8amlucHUud2FuZ0BjbG91ZC5pb25vcy5jb20+DQo+IFNl
bnQ6IEZyaWRheSwgU2VwdGVtYmVyIDI1LCAyMDIwIDM6NDIgUE0NCj4gVG86IEpvaG4gR2Fycnkg
PGpvaG4uZ2FycnlAaHVhd2VpLmNvbT4NCj4gQ2M6IFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNyb2No
aXAuY29tLmNvbT47IExpbnV4IFNDU0kgTWFpbGluZ2xpc3QgPGxpbnV4LQ0KPiBzY3NpQHZnZXIu
a2VybmVsLm9yZz47IFZhc2FudGhhbGFrc2htaSBUaGFybWFyYWphbiAtIEkzMDY2NA0KPiA8VmFz
YW50aGFsYWtzaG1pLlRoYXJtYXJhamFuQG1pY3JvY2hpcC5jb20+OyBWaXN3YXMgRyAtIEkzMDY2
Nw0KPiA8Vmlzd2FzLkdAbWljcm9jaGlwLmNvbT47IFJ1a3NhciBEZXZhZGkgLSBJNTIzMjcNCj4g
PFJ1a3Nhci5kZXZhZGlAbWljcm9jaGlwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAzLzRd
IHBtODB4eCA6IEluY3JlYXNlIHRoZSBudW1iZXIgb2Ygb3V0c3RhbmRpbmcgSU8NCj4gc3VwcG9y
dGVkDQo+IA0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0
YWNobWVudHMgdW5sZXNzIHlvdSBrbm93DQo+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9u
IEZyaSwgU2VwIDI1LCAyMDIwIGF0IDExOjU5IEFNIEpvaG4gR2FycnkgPGpvaG4uZ2FycnlAaHVh
d2VpLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBPbiAyNS8wOS8yMDIwIDA3OjE2LCBWaXN3YXMg
RyB3cm90ZToNCj4gPiA+IEZyb206IFZpc3dhcyBHPFZpc3dhcy5HQG1pY3JvY2hpcC5jb20+DQo+
ID4gPg0KPiA+ID4gSW5jcmVhc2luZyB0aGUgbnVtYmVyIG9mIE91dHN0YW5kaW5nIElPcyBmcm9t
IDI1NiB0byAxMDI0Lg0KPiA+ID4gQ0NCIGFuZCB0YWcgYXJlIGFsbG9jYXRlZCBhY2NvcmRpbmcg
dG8gb3V0c3RhbmRpbmcgSU9zLg0KPiA+ID4gQWxzbyB1cGRhdGluZyB0aGUgY2FuX3F1ZXVlIHZh
bHVlIChtYXhfb3V0X2lvIC0NCj4gUE04MDAxX1JFU0VSVkVfU0xPVCkNCj4gPiA+IHRvIHNjc2kg
bWlkbGF5ZXIuDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogVmlzd2FzIEc8Vmlzd2FzLkdA
bWljcm9jaGlwLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFJ1a3NhciBEZXZhZGk8UnVrc2Fy
LmRldmFkaUBtaWNyb2NoaXAuY29tPg0KPiA+DQo+ID4gQW55IHJlYXNvbiB5b3UgY2FuJ3QgYWxz
byB1c2UgdGhlIHJlcXVlc3QtPnRhZyAoaW5zdGVhZCBvZiBnZW5lcmF0aW5nDQo+ID4gdGFncyBp
bnRlcm5hbGx5KSBmb3IgYWRkZWQgcGVyZm9ybWFuY2UgYm9vc3Q/IE1hbnkgb3RoZXIgTExERHMg
ZG8NCj4gPiB0aGlzLCBhcyBtYW5hZ2luZyB0YWdzIGhhcyBhIHBlcmZvcm1hbmNlIG92ZXJoZWFk
Lg0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IEpvaG4NCj4gDQo+ICsxLCBJIHRoaW5rIHRoZSByZWFz
b24gcHJvYmFibHkgaXMgZWFzaWx5IGNvbXBhdGlibGUgd2l0aCB0aGUgb2xkZXIga2VybmVsLg0K
PiBGb3IgdXBzdHJlYW0gb25lLCBpdCBtYWtlcyBzZW5zZSB0byBzd2l0Y2ggdG8gcmVxdWVzdC0+
dGFnLg0KPiANCj4gVGhhbmtzIQ0K
