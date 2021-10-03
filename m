Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653B3C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 07:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D9FF611C1
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 07:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhJCH12 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 03:27:28 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:51796 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhJCH11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2021 03:27:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633245940; x=1664781940;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bq9npCDxul4vtznMwfYD6cLYKGjidlX8bP4t/If4XDs=;
  b=CA6oTcbo8Bxmg8CQFm/ruCJT2lNyQMqx2s/8BtM84hdYUtFDRlKDm3bZ
   wqtOk7p8ABEHab7pVrQaC/u5c+dEirh5wnaDVUZG1bpkZ3zlJETg25J3R
   XSty8O5iDmIJZh9of7EzIe+klInwDZsSTlhyhl5T76Ru7zm6muDrhF4bL
   +lv5pguU62pG0Vo5hJdatI0A7wEJziraDjz62BdNc1S3tgr8uBx9O2pvd
   Vqd6JUJOYap2vMcGzVYqwRMhHUSMolxXUQRnyhROEzjYsASAvQVECnMjr
   eeUN2Jhj2F0yjmBJq+Ih2s864A+zEa7sr82zOs3FR18NVr9hyaqX0Xc4l
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,343,1624291200"; 
   d="scan'208";a="180743370"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2021 15:25:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMcKbnGq2qJXQHo1l4BmpDUbrH7QMUOPkMEh3KH0ihaXMRXxt6vzokr0jc6EfKE/pdzd2CBXhfCakGcgFvh2xBnNmVqH4Z6feFLaLjMlytMDY5JoyWkoLgP6PdBwE5H8HGdZiTW8wzfWy2NiHyhUQTt8hj7L+8qlS4XFKi2JaokrQupkwsS6XTR0jUANcV/6HOIJD/9OyyV6z+8O4DrJW0l3xWJctBfoBaWoYC8yM+UzsbdlRuJXkpOfwDD4mQWwTEiqtME9qatnko4jsR2DgtIICDTRunSUpBf/UFlSTzQDxblYaE2hysC7K1YLWiw5nLgo6uFFhhoStN02kTwstA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bq9npCDxul4vtznMwfYD6cLYKGjidlX8bP4t/If4XDs=;
 b=lcnQLzRQ95AgK8+sO4caXzjoKqp1pwCwT5NbJwx/TTb2tTxCCqr6FhPzk1RfLjcuHBiKGNonhygqG21gJHjVwUucyPLwQXPZ/djAUUPi5Q6y+3ff3mNdaK7qo9VqbnsPJA5KDxaVK10w//UREfQQgTCbUdWxuBv5QA64RCtxyGObWmWIoFrNir8ZCie1oVT8pRh1AXXMLJKFCLCmazHInT16Wrpgn31Amlg43JlQK7aFhz2h1tzTyc/+Zx7ZYhDLYKqdghFrMuyEf/YxY79rHve8a5PiHdX9KM7t64nkdpysYdhdDL6TR4+2npmoqvf0VaEPGWyWzaTYiR5SK27MGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq9npCDxul4vtznMwfYD6cLYKGjidlX8bP4t/If4XDs=;
 b=MKipcZdWy2bgr/1Zs9Uij1cT84oUBd60hdithd1LpKf+KjeJjZOh/XOis7uUEdd47qNi//4QTQfJlynhOPOQ1pkQYhR/DUK50/RSQy7rXV78ZdhkE8vYNlLtcVeRP0kd8YDRe6BSK+n+ICOcuD01HKVF53c9sLypyiiJPId0Uj0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1130.namprd04.prod.outlook.com (2603:10b6:3:a5::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.17; Sun, 3 Oct 2021 07:25:35 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 07:25:35 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: ufs: Do not exit ufshcd_err_handler() unless
 operational or dead
Thread-Topic: [PATCH 2/2] scsi: ufs: Do not exit ufshcd_err_handler() unless
 operational or dead
Thread-Index: AQHXt6SizcPX5XU+gUCAYqEZHVd+nKvA1OIAgAAHXQCAAAPpcA==
Date:   Sun, 3 Oct 2021 07:25:35 +0000
Message-ID: <DM6PR04MB6575E83A6E8E7BAF4B2971AAFCAD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211002154550.128511-1-adrian.hunter@intel.com>
 <20211002154550.128511-3-adrian.hunter@intel.com>
 <DM6PR04MB6575003C0D1D2A31878B952CFCAD9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <4be2d6be-fffb-a2e0-aa40-c1bf5fa0fc0e@intel.com>
In-Reply-To: <4be2d6be-fffb-a2e0-aa40-c1bf5fa0fc0e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2995779a-6ffc-455a-7a53-08d9863efe07
x-ms-traffictypediagnostic: DM5PR04MB1130:
x-microsoft-antispam-prvs: <DM5PR04MB1130600EEC4E21C4BC9AC2C8FCAD9@DM5PR04MB1130.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sex08ghKr395Kf12k2C49pIxnJviYggsW9DxuRnmpgA4E/mdeF8BJrEEALNdXL2Xx6ljgcGELleN9o7h4/xLTrPqWKd3S4z9TBqv5j+Aq3TNIMN9At4TojAYx3SMZ6tyXDyk3oPZKVUWTCKu/pHEMqy5cDbwtbCBj4EH9uPEttz389/rQR5AFYyWPQJENFM8s6UusTYuRP+5h/RHXyz+vWdJZ6r+TNmPfIrs7HH8VXe5keSdcwbt43PMZ9QmauaIRQ8jTQBGOMW/WL+fU8SeqiGJopIVNOgQmSnWTztjSoG1Vv21na/hKLHyzoWsx7szigm0XO1Lug0h5wY2qiNE4gczn1ZWKEighKszLN6bKUeiOyoBcqUf5F3PItzgqkiFsb6vT36SLizB/T6Tb2gqvBL30YMH9FAuuL1gD8yka2ZyiiBwlBiN/ogpmOdCjHXbpAmqDzZ7kuasc+gdfnbj5JdS4MyWWdrpz57E6tQdRqgKicTXhcfsyq2kA8l1/yZNNyHKKDi678NKbPALj7LtriKy8K0hbGVhxz/ce3AX0Lpx4EVX61vIL83RnvjUr1RneoTol4WCaJFvvKzT7ts+OCblW3rcB1AOHTJ55tm4RTogKHicS/bRUzmVBYYFfj/8/QfogbYVhKxYrdyhBVMhjcObUjLYlLOhyP+RfTcd4iV07hdtPAdK+RxrnAkvXntWlMmaEfkMWhA0zF6/GsCA6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(38100700002)(6506007)(66476007)(66556008)(66446008)(83380400001)(5660300002)(33656002)(26005)(122000001)(508600001)(66946007)(2906002)(9686003)(64756008)(76116006)(316002)(4326008)(54906003)(86362001)(110136005)(52536014)(7696005)(38070700005)(55016002)(8676002)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFNmNVloNkh0ZUxEem9GemR3VEtnZVRhTHpIdFVDR2tQQmdSdEtaN0hLcC8v?=
 =?utf-8?B?M0h1K3FaUFU0d0xZNEFDTWN3SjFhZ3lxMEh1dkNXSVhVY29teFQ2Vy9xR0VE?=
 =?utf-8?B?UDdORzZTL3dybUZ1dEFqT1RGbkNzQjhoQkVuUGR3MXdyYTAxVlpzTk1WTkNl?=
 =?utf-8?B?cmJ6UXJFUncyOFp0WGduVllJaVlBaW1rUnZPb0JaL29HVFV2VERTV001YS9n?=
 =?utf-8?B?dFpSL2JmSkY1bkt6YkFXTXVsaXEyZ1FjKzBmbGY0S2lkakp3Z2hpajBFMDEz?=
 =?utf-8?B?b0xMbUpBU0tGNml4ZlNZNmluMktWSmY2UHlVak5WNmhhUktaNHB3L0RsVHpV?=
 =?utf-8?B?K2gyQ3ZOL3pGM1hzUndDTEdwRGVBUDFFZm1MQ3lTY29wbFlIZldod0UvTVhp?=
 =?utf-8?B?ekVVVDNxbDhxbDZXa3VNaDU5bUFHZ0ZyM1RPYlhNUFpDTnp1NWx3THU2SmNI?=
 =?utf-8?B?NnVFSTlQOEZWVXdOVjlOdFlsREZBZzZXWVY2VkVYQUNJMEdpdURINTJTY2tB?=
 =?utf-8?B?MnVOdGgzOWFNZng3TEhKSEwxQXNUVTdERzZVZnQ1VTJVenJnY25FS1VIYThs?=
 =?utf-8?B?OHhwbXVQYVNFdmRtUWRQMHZBME1SRk96WVRCa0U5VWJaOHl0R3hjaW1vYnZC?=
 =?utf-8?B?Rk83Y2NjellBTWFlYUpxODl5NVBkbGVET3J3YlBjS3pXeHdqV3MzMlIwNkJU?=
 =?utf-8?B?YmV5V2p3VDVPUnI2T3RBdklDR0FjZzBTeTZDNFRoWVV4UkhUeWo0cVJLV1dl?=
 =?utf-8?B?Wkl1ZVJtV3F6WXVyQ0IwazViS3g5dFVPRWNCWC80Mmh2UmdUUFpiRmp3em9G?=
 =?utf-8?B?WFgwWVJ1V3A0NFlybGRwUVBlb1BROWpJQmhRK0JZMVRkRWxidDVQaC8yQmFq?=
 =?utf-8?B?dUMydGRBMzdQend6S2krTUNYbTlIR3kvekVqaUhIUjFYckswTU1TcDZrUm5F?=
 =?utf-8?B?QVFPYzBBNzlSd3V1M1FnN2VueGYrZjBnZXV6QW05UVNJK01oUnFhYm83S0No?=
 =?utf-8?B?KytLY1hQTksvQ2J5L0tublVtMFhHdHRnYlMrVmxobCtQdGZVMjlmWnFvWWdE?=
 =?utf-8?B?enk5eFFzYTNzMGZkYVpXWmdaNGNFS0hJV3V2T2NOL3c3RmFnOWdubkRFcUZn?=
 =?utf-8?B?TThLM0JQdjJpUXprTlRyS0FtTjJpMnBxRktYaU9rRGJjQ1Z4aUd0bDJ5dUpV?=
 =?utf-8?B?S2JBR25CRmdjeENkL0QzbzJNUlpaNGZyVFB5cy9MejdOMXFLZmpiNWgvTlJC?=
 =?utf-8?B?aWtTQmtsdU5WUHBTcnFhNzlSell2YnpCN25XRHBqMXNSQUFxSjZvcHIvdVlG?=
 =?utf-8?B?VGhrd2U2NEFVS2paOWNsMWpkeURrS2o1V0dlME0xNU5TaEloVzgyVnQzNFdB?=
 =?utf-8?B?aXhGRTF0Q042RWx1bU9pVGdwRStPTkNPMEJEZ0RWeDBIQUF1TFVYdEM5Z2sw?=
 =?utf-8?B?a3lheUo4a1VJUVB2N2JhV2tuczJKSWlaUnNNWlJEdVk4RDZIZEJ4N01FMHhQ?=
 =?utf-8?B?aVhZMm1FMys5aEM5bXRwdTRWbWxnUDBuclYzR0JqZmNBeUk1aGdJWkdUbmN4?=
 =?utf-8?B?TDRQZVBQSXhmQ3hDa0daMU9iYnVRN0I4emEreTNwTWJrMXZ6clJFdXJlSFFB?=
 =?utf-8?B?T2dYVTV6OVFra0Z6ZFpMaU1OYmU0cTFlU1VONS84SEZlakVNKzE5WmNZZENQ?=
 =?utf-8?B?TS9SY1BnTXJlMWhnZ0R6SkdyQ3FsQ1pXOU90OVQwcHQrdUdWNlYvRTZ3am1z?=
 =?utf-8?Q?cJWvJx30UtOBmfHaudxJBM1W47L8ZmY4bWgKaCj?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2995779a-6ffc-455a-7a53-08d9863efe07
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 07:25:35.6000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IH2eW1DWDIs5zoAwvYm0jatsN9SFybTb3c++SHKXAOTzRia+O73h1iAuvHFYqLJxT2HWW3vxo2Rjf7OKGdMs6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+PiAgICAgICAgICAgICAgICAgaGJhLT5mb3JjZV9yZXNldCA9IGZhbHNlOw0KPiA+PiAgICAg
ICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywg
ZmxhZ3MpOw0KPiA+PiAgICAgICAgICAgICAgICAgZXJyID0gdWZzaGNkX3Jlc2V0X2FuZF9yZXN0
b3JlKGhiYSk7IEBAIC02MjMyLDYNCj4gPj4gKzYyNDUsMTMgQEAgc3RhdGljIHZvaWQgdWZzaGNk
X2Vycl9oYW5kbGVyKHN0cnVjdCBTY3NpX0hvc3QNCj4gPj4gKmhvc3QpDQo+ID4+ICAgICAgICAg
ICAgICAgICAgICAgICAgIGRldl9lcnJfcmF0ZWxpbWl0ZWQoaGJhLT5kZXYsICIlczogZXhpdDoN
Cj4gPj4gc2F2ZWRfZXJyIDB4JXggc2F2ZWRfdWljX2VyciAweCV4IiwNCj4gPj4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIF9fZnVuY19fLCBoYmEtPnNhdmVkX2VyciwgaGJhLT5zYXZlZF91
aWNfZXJyKTsNCj4gPj4gICAgICAgICB9DQo+ID4+ICsgICAgICAgLyogRXhpdCBpbiBhbiBvcGVy
YXRpb25hbCBzdGF0ZSBvciBkZWFkICovDQo+ID4+ICsgICAgICAgaWYgKGhiYS0+dWZzaGNkX3N0
YXRlICE9IFVGU0hDRF9TVEFURV9PUEVSQVRJT05BTCAmJg0KPiA+PiArICAgICAgICAgICBoYmEt
PnVmc2hjZF9zdGF0ZSAhPSBVRlNIQ0RfU1RBVEVfRVJST1IpIHsNCj4gPj4gKyAgICAgICAgICAg
ICAgIGlmICgtLXJldHJpZXMpDQo+ID4+ICsgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gYWdh
aW47DQo+ID4gV2h5IGRvIHlvdSBuZWVkIHRvIHJldHJ5IGhlcmUgYXMgd2VsbD8NCj4gDQo+IFRo
YW5rcyBmb3IgbG9va2luZyBhdCB0aGlzLg0KPiANCj4gSXQgc2hvdWxkbid0IGh1cnQgdG8gcmV0
cnkgYnJpbmdpbmcgdGhlIGRldmljZSBiYWNrIHRvIGxpZmUuICBUaGUgYWx0ZXJuYXRpdmUgaXMN
Cj4gVUZTSENEX1NUQVRFX0VSUk9SIHdoaWNoIG1lYW5zIGRlYWQuDQo+IA0KPiA+IHVmc2hjZF9y
ZXNldF9hbmRfcmVzdG9yZSgpIGFscmVhZHkgZXhpc3RzIG9ubHkgaWYgb3BlcmF0aW9uYWwgb3Ig
ZGVhZD8NCj4gDQo+IHVmc2hjZF9yZXNldF9hbmRfcmVzdG9yZSgpIGlzbid0IHRoZSBvbmx5IHBh
dGguICBUaGVyZSBhcmUgYWxzbw0KPiB1ZnNoY2RfcXVpcmtfZGxfbmFjX2Vycm9ycygpIGFuZCB1
ZnNoY2RfY29uZmlnX3B3cl9tb2RlKCkgYW5kIGluIHRoZQ0KPiBmdXR1cmUgcGVyaGFwcyBvdGhl
cnMuDQo+IA0KPiBUaGlzIHNlZW1zIHRoZSByaWdodCBwbGFjZSB0byBlbnN1cmUgdGhhdCB0aGUg
ZXJyb3IgaGFuZGxlciBndWFyYW50ZWVzDQo+IG9wZXJhdGlvbmFsIChvciBkZWFkKSBzdGF0dXMu
DQpPSy4gIFRoYW5rcy4NCkF2cmkNCg==
