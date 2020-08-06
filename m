Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2CAC43459
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC7C20855
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="el0vbVwk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qkjFU5Ho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgHFKNf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 06:13:35 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:60061 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729292AbgHFKNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 06:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596708783; x=1628244783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7XyLmEYirqLmHQXYIBn2cYmB4vCouxQWNSgrZWJJxQ8=;
  b=el0vbVwk/ppGNx73RApZ6+QZiAhllJIKnpb+MRD9Ep3BuLR00OpXoiwV
   J8v9w2EDy3ZVOf7AXl4kaITSHJrXmzRu8n29nugOuSVhowl/iUQ3Chjha
   mJNiMX75ud/R6FV9FAf/nrJ6f7+oUVGriqqQRwIjd2idn/3z4KaUyGiKp
   GqFa2OtUk60Avye9qH/MtN+4GuOjhExPC56gQhg0DZiPeLxMbVyVT3K0S
   iX1VajkocLuqjfhkeVabICzoxiXhsiOJK680i3DH+EItkD/IX5ZmZfWsN
   Hrn3hoVBjfEa8eI2Fds1wuqMJ/4K8atqQDExlIx3smVVvx1iMkj45VN/d
   w==;
IronPort-SDR: eXnwdPsCG+G/lkqoI4UBIt5a39e08S+klmF3Y4zRA2JEZqq6TpDUsZhF/+Vcq9zulZgTI5z/iD
 H4txbZBMDtYF18+4s3O5/nSo4a+KNjqDYRawt3HAUr2tlv2jLoaK/PLoMFw+W6Ycs5Ti06tufa
 r3Or+Xz5ok/wZKQ5UYMwx9P4RNBPrayaOZXeAd7BAsTk8ZEODw5FuyGUGP5FKonrN99IEWJWpM
 F2ElOETYiBlmO78Qtkt70E7JgR3o0lx9NCsmk6XnPeXiYwx+NKabuUo5GSBkeIaOQtYy3aiUT6
 rSw=
X-IronPort-AV: E=Sophos;i="5.75,441,1589212800"; 
   d="scan'208";a="247392732"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2020 18:13:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZ9JZ380GDHyCqE02YHA39y81Uysf2Ja0ymQLxNtrySmNCtCCIS4KKBm0kpBBEe2yr5yTwEsdB8ziZwriXwvRhjnQIMTWBuXb2x29EGrlWd+vy/Fc9mJ0hFExM12Dkw9grg05JvQq5Zkr5QVl2z0pHfVppowFN7bolFg+zfC2dUz5Jc1EoD5ICyapHTufO8xrChMgUUDL/teexEBFf7KlHiuVUalq1cDt+mj8gv4NegsDihUEKGpIjsxregXuh4khckfnFm48Ab8ZyBUr3yo85sXJzr/U32rbOosYqWcCvv91IzmE2R1JKuonpc3hivLGiOSACaAzmFKW9KH07Z14g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XyLmEYirqLmHQXYIBn2cYmB4vCouxQWNSgrZWJJxQ8=;
 b=DGfMpq+tsuPS4bIAln811PbEmVyL+hr+Mzu9l0LWFdJsE5zXaRl5WRpKyALA6f4r5MwNKsYRrrSGD02zU00u/UgknUc7FnBCXSdzj4ZS264EeOeS9DLmsRrpiiLWrhNBgF1KQO/9JHFPaLkOV3yoBY7nprxLzR371WDAs5UrB9NaIEMcos4MhOeaXvWh53m7qYnf7n/rRb05BKL8CMcUVBidfnZSpsERZB9kHkaKromCYI43cX8JJc2+siyeVA9Yb3QmnWgqlMNgtSvG79luhunBPA2posPQ9tlTMpAXG5smR0DfnQNKY8jdy/XT4TVEb6NdVEfJXBEp57DKuwl03w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XyLmEYirqLmHQXYIBn2cYmB4vCouxQWNSgrZWJJxQ8=;
 b=qkjFU5HoQ/fFKO6Y301zwlad0e22dc7D5hFui4Psj/tMMpA3xvXjrZHXunk6owg059CAf59+bMIqt2GBEx5d633m7RM4qaz8a3EvZSMV2zCyeLgaWXcxgPcFFKb0+dc1aePBL+yWipYR9kzZhHO06oAyOAyYWEs8dj5n3iFUg+g=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4496.namprd04.prod.outlook.com (2603:10b6:805:a3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Thu, 6 Aug
 2020 10:12:47 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3239.022; Thu, 6 Aug 2020
 10:12:47 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWa8+0AqkNRErINUCUKezc5qYxwKkq1vwAgAAAvyCAAAH2AIAAATCQ
Date:   Thu, 6 Aug 2020 10:12:47 +0000
Message-ID: <SN6PR04MB4640210D586CBA053F56DCF0FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
         <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
         <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
         <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
 <39c546268abead68f4c00f17dc47c1597f3e0273.camel@gmail.com>
In-Reply-To: <39c546268abead68f4c00f17dc47c1597f3e0273.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b9ed8e21-6523-4b7d-6853-08d839f14483
x-ms-traffictypediagnostic: SN6PR04MB4496:
x-microsoft-antispam-prvs: <SN6PR04MB4496BEA57225E648B45AB3C6FC480@SN6PR04MB4496.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tkOsOUCq7wWYPz18343wYTauQFyZyY/5MCbz3TUqbDDcZAkBmVF49ms7VEZBk2POZvpASgHLXHjFdnhgCnb7MzoFr//2m+pxPYghJR3ZdGcMk6dAuBQjvEKoQxhwqrBzQflHIPRDNuoihnAkKD4L3Qg+qO+yuHENdBuNhVER6x/adlsnYPPUV1bGvfAP1V0S6DBGBcRDI7frRGin2Lqiec+tH71SlShRGI1HWiQsTHXWrbDG1RaRZy20u5we+RmoCX9l7BBO3p0Zj/FEfF7LKUKPG6fIhPoNXoMUYYLdPX6G7xF4gMVpHySlhy8zHmV46qXRGE3nDUDPg7H2qb8/GnXvIWf0bKtyltHyZR8h/izobxjx/faCP0vI8wxLoAhz8lX7rVCiK+B5x0Satv+i74D3CqwNX2gdWddO9S5yb3Q0GX+QTbLZ1ym6AlSbuWrB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(966005)(4744005)(478600001)(316002)(26005)(7696005)(86362001)(110136005)(54906003)(83380400001)(5660300002)(6506007)(186003)(66476007)(71200400001)(64756008)(55016002)(66556008)(33656002)(8676002)(4326008)(66446008)(52536014)(66946007)(8936002)(7416002)(76116006)(9686003)(2906002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: r2WjcEigcegYrK1/3WCEpTVUaEDCGkZ0EjZ15pez1M49IH7PW/xSyfa47bSf9Ay4Xx96RC3xnNZhezCvudJ3rzWuJErpn9GPUmAc6Crx2D2HAChPH0WIJbx9TiyETGyVp6gd4GNO2eEaSHMIIfGrbedSqmeCYtqWics51YfOO/bb+QVcqr9wLX+fHJZLa1MkXlXt6fpny1Q+Hh9Zswa9Y0jUCPJtrgdETk6SRjHDsfal6t+NVvqjK6vwYU2bd5vjhwccR9jN4NWlgU+ZFXYyha5q2SI3f8a1fpZEsSbUUrG5/88olq3xeSLVemuS9PNd+C0qEhmPwWBJRQ3dyjD780A21HXUzAWGMLEzaZRe+9wFUuoLMXG0SD1pePrczqaHbdBkJm4cz+/nwc6IINl2wKoQUs0XlvQvAvZ73aKwIM8LV6vdP4BusQH2yNPocAmtg2NxxHzNVdXTyovcS7BSY9v2zwk89kbDk/hUoufbvpzlf4itWPMQkTgfRIh3lODZfcjSE6YGBnQo78iZiQNKsay6eGMUmvFAiz1uXPxNdCd7Kblm57eG7giAbANLBwrrpQ6MP5TZFsFfqVB/z7/7a0Xh9Xs0mnbT13AwFAuWmlHyLiviRyNkSac3uwGL4QpEFTC1MDsGQYwKiZaOKCYW+g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ed8e21-6523-4b7d-6853-08d839f14483
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2020 10:12:47.0640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FYvcFNGyIVcmYdAnYCWtIfUcfH6e1/BSCyKs/ZMPQQWT5xZbf/3Dra0oXFNVjwakn0/l6BmEw3YlaO/JtcdWcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4496
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gT24gVGh1LCAyMDIwLTA4LTA2IGF0IDA5OjU2ICswMDAwLCBBdnJpIEFsdG1hbiB3
cm90ZToNCj4gPiA+DQo+ID4gPiBIaSBBdnJpDQo+ID4gPiB3aGF0IGlzIHlvdXIgcGxhbiBmb3Ig
dGhpcyBzZXJpZXMgcGF0Y2hzZXQ/DQo+ID4NCj4gPiBJIGFscmVhZHkgYWNrZWQgaXQuDQo+ID4g
V2FpdGluZyBmb3IgdGhlIHNlbmlvciBtZW1iZXJzIHRvIGRlY2lkZS4NCj4gPg0KPiA+IFRoYW5r
cywNCj4gPiBBdnJpDQo+ID4NCj4gPiA+DQo+ID4gPiBCZWFuDQo+ID4NCj4gPg0KPiB3ZSBkaWRu
J3Qgc2VlIHlvdSBBY2tlZC1ieSBpbiB0aGUgcGF0aHdvcmssIHdvdWxkIHlvdSBsaWtlIHRvIGFk
ZCB0aGVtPw0KPiBKdXN0IGZvciByZW1pbmRpbmcgdXMgdGhhdCB5b3UgaGF2ZSBhZ3JlZWQgdG8g
bWFpbmxpbmUgdGhpcyBzZXJpZXMNCj4gcGF0Y2hzZXQuDQpJIGFja2VkIGl0IC0gaHR0cHM6Ly93
d3cuc3Bpbmljcy5uZXQvbGlzdHMvbGludXgtc2NzaS9tc2cxNDQ2NjAuaHRtbA0KQW5kIGFza2Vk
IE1hcnRpbiB0byBtb3ZlIGZvcndhcmQgLSBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9s
aW51eC1zY3NpL21zZzE0NDczOC5odG1sDQpXaGljaCBoZSBkaWQsIGFuZCBnb3Qgc29tZSBzcGFy
c2UgZXJyb3JzOiBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC1zY3NpL21zZzE0
NDk3Ny5odG1sDQpXaGljaCBJIGFza2VkIERhZWp1biB0byBmaXggLSBodHRwczovL3d3dy5zcGlu
aWNzLm5ldC9saXN0cy9saW51eC1zY3NpL21zZzE0NDk4Ny5odG1sDQoNCkZvciB0aGUgbmV4dCBj
aGFpbiBvZiBldmVudHMgSSBndWVzcyB5b3UgY2FuIGZvbGxvdyBieSB5b3Vyc2VsZi4NCg0KVGhh
bmtzLA0KQXZyaQ0K
