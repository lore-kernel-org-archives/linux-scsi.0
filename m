Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE542C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 12:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C255C2077D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 12:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Hgy0YnKU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="R1jIihBU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgGIMaQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 08:30:16 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5948 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgGIMaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 08:30:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594297816; x=1625833816;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ChmsUZ1b7TqCLG4rI/Q05YCjCvoNwuCz/2Cbnoou+pA=;
  b=Hgy0YnKUqpOcuvz6MHVp0UXm1kltQ3h9rOWT+7sXf3kzcdxTvrC39KgW
   k+hkNAxY74wJGac8B1OxPbqtv6thTZ1woH22P9VzImUfjR9v+96KZCClf
   sVvTm7CMrjvNjvRDkgjvChEB0H5bl7kzR77ISlDVZuzzgWacdW0xtnoep
   eAXXekePdqXdeg+V/M6GJTIvdgA7xPvwZW7pH/CNTgK2r1Khn0X5ZZQ/2
   yl54qvJ1AsjCg4scq7KH/1+Yv2IRyOriZ393KhEliF3tallunVHI4o4yz
   8cupUYzcZYEsSDO4whbHoD3BavZya4a1nm6fJxac8kn68yg2bCNhnTyJo
   Q==;
IronPort-SDR: PWpgbwsZYO0+rC+qHETNoij7HfZwpjquNH4cloblUETKuxnF3GsUU/6JgsHJZ9RSDlnZH/uJiL
 MC329EVgW19xnkehHUz+1/ZIFM23wI8vKqBHlNRR5KjFTtckBIC0tB9A3y4JtPYAipKc2OwagY
 WZ5AE0do3EL/aaLCTzO/vVoQVL7WMEns0ZVwFqM3uV7OwaZJrAbC54oLZxpf5jYiiQzdK+rUPe
 SP2dJ6QhJYE87ZwqE/E/8oyAk0wAYi8yt21pMMrI9Kzy+zFHKYqEOpgwSuV4JobJTPMge2xfBz
 JhQ=
X-IronPort-AV: E=Sophos;i="5.75,331,1589212800"; 
   d="scan'208";a="142186655"
Received: from mail-sn1nam02lp2053.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.53])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2020 20:30:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uz8U79fIJNuGnmnHfbeOyPIzFtxKZeuu/h0ej/aK8OUSO52YHRDItem6aiDcRZcbdAxU2WSmTkkY3yQe8trdj6v2f7KVS4OtCeY3ak4p63djkE/h62LKvA5ZRK/RTEqUt4G94BD9xaDjjyRMJ1msj1911PDFKZbExG2RFWu8bnuYs4WvIxfLurK6CMgwjFhIWAD+jjkWJrQAFVP5P+9o9QCT/rT/w08R5JwSDiC2SvJJmiLA9MSdR6cy9XQnqyLoh3E33/wxqbEZBegsm4c/BomSzeE2jd6D5ocOXuwwRhLQN2DVlyGvQDgbRS+1JqOStCXqLbdk2NovKi4I7whK0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChmsUZ1b7TqCLG4rI/Q05YCjCvoNwuCz/2Cbnoou+pA=;
 b=CEcpHTtW47Rx4zlDJXpRQpM4sTlNy5qinbl1GbTMCCiuiT+f59jRMPIIMAdtAophKWMceCH8s8fBzkc1tPjgDGPJm+aG63Z/Ksn42iR1EodMBS8sdFn7Yx+s1DJXY8xiOVN8H1HzP5yOxhuTFErOMAZCMuXTn3T/Q15ZyINVyqAbx8hFrPqGCJRCSnPgjAWjmQ1koBwJRVCtv92arEBqzmuXzY2jSJ7T+7yuwaKZLD6CxUXerfF9t47S2vwun5ap9+Rp55dRpVZNfAVZBccaeuND7++Vx5DIjQ76PABgoLhKxLmABSaAsw9nprw8dYjqIrSUmiBT30fpwafYQwUS4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChmsUZ1b7TqCLG4rI/Q05YCjCvoNwuCz/2Cbnoou+pA=;
 b=R1jIihBU/xtVSDCm9xoPWe4sdHC1L2JF1oRfD5qZwLzzHs9E2j1+4zKgtgmQWzqkxs8on1+depOuIgWForHhpTCe60J8xFaTMhotPR0B0PhK1G7lysX6TbTRcrvtvVZ+YoJlWxsK7/VyeNR0m7ALuAdxP49XCKJINSUBDkZGjus=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BY5PR04MB6819.namprd04.prod.outlook.com (2603:10b6:a03:22d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 9 Jul
 2020 12:30:12 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386%7]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 12:30:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [RESEND RFC PATCH v4 3/3] ufs: exynos: implement
 dbg_register_dump
Thread-Topic: [RESEND RFC PATCH v4 3/3] ufs: exynos: implement
 dbg_register_dump
Thread-Index: AQHWVM/45fDFLrLRh0yn+WB9DCTa0aj/LcMA
Date:   Thu, 9 Jul 2020 12:30:12 +0000
Message-ID: <BYAPR04MB46294F9AA905B811900BB48AFC640@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <cover.1594174981.git.kwmad.kim@samsung.com>
        <CGME20200708023156epcas2p188781afcff94b548918326986d58a2d7@epcas2p1.samsung.com>
 <ace3fe9ebea3b82e23c6c6ebc5bd92fbdde23b51.1594174981.git.kwmad.kim@samsung.com>
In-Reply-To: <ace3fe9ebea3b82e23c6c6ebc5bd92fbdde23b51.1594174981.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15fc0379-77b8-4e03-36e1-08d82403d37f
x-ms-traffictypediagnostic: BY5PR04MB6819:
x-microsoft-antispam-prvs: <BY5PR04MB68190D616A8CBE201851F848FC640@BY5PR04MB6819.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:407;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d9BaHqSy1J7NkUTCTCy4mqAOtI7sZdq/nVYVoAC5rF2d9qKsvFUFzD6mnONkl4qWY8RtNQbNw5xS4KcvsZLSr5XIs6aC/2gls8GSPRZT+89b4hqWE4itkr51Uu9ii3GSF/pqmEvXhO4TKqHfxGCWYRT04f8nksx3xNvP/lH9/kJMWESjJeSSnGDyqw0gY65qmk+Pio4A7fHKfXZQJ+DvEOf3t9kHhCDmvWQVlrtOqCGnacY+h2ttOhMRuFLTzkIWxZBpnAdxsj9Rs4qUEFlIbR6rye5siTsS5kKnhhyM69djo9RG/d/HIVjcyPbFiAnnA+7gDRSG0g0VE6mJJdisgHh/GAQ1yfT0QGp0aYlP+2S7Nc6qIzIxMbS8MP6T08FU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(55016002)(186003)(66476007)(478600001)(9686003)(66446008)(64756008)(26005)(66556008)(83380400001)(8936002)(71200400001)(33656002)(8676002)(2906002)(7416002)(7696005)(86362001)(110136005)(52536014)(5660300002)(76116006)(66946007)(6506007)(316002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +jfNF+PTQBMSIHCTrNUah9UepJ4QbWLJkspyLDY4slRbp5+JMfUBbyOhbnXyGuTG772zAYIjL5MZmFdblh7iRwGFm0Jzhjn5JE1r9am+nRW1EmsZnvqigoyGkXwsacxLRuEPKwx08tFTVq0Oigp5c8R66+5e2IibwqSFE6BdcLMuMWVbIwQkdZSkV+9EVMg/KPwUH4jYqdYr1iFGjxSYdkOsUDWZd20kRI0N6KuKOSUdB62j37n/XvhpLK2fTrIGec8OFW7t2WLGX2ywyYiledeWZtQatrZxiJD2Rlr704zWSturXl3abhGs7I7y25Zv0DyXCwz9v4SOX+MYX7hH6oFdZ7mheQ/V3g++kpoUnbBxkLKzT3Wq7hr9PCiLEgNEy91bOMUbT5T0YUETp9lMyTHCf6q1vLBn2THmIagCc0SAJ3VtfAl5FXw7P/oavn8lYzAUGT7IAb1ofA8+kdyzDjGoLKU0Vx8uDCexNWz5tQZxklOSjjzwxMhkgpzXr7K9
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4629.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fc0379-77b8-4e03-36e1-08d82403d37f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 12:30:12.3227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CoZNhIVrIk4Vks0vuHVDQknPQ297ggGmyiZltKwarK3UE1FeGKOfG0AqOt9LGH6yAi44k0UnWuzxiL+SIDSDXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6819
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gQXQgcHJlc2VudCwgSSBqdXN0IGFkZCBjb21tYW5kIGhpc3RvcnkgcHJpbnQgYW5k
DQo+IHlvdSBjYW4gYWRkIHZhcmlvdXMgdmVuZG9yIHJlZ2lvbnMuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNhbXN1bmcuY29tPg0KPiAtLS0NCj4gIGRyaXZl
cnMvc2NzaS91ZnMvdWZzLWV4eW5vcy5jIHwgMjQgKysrKysrKysrKysrKysrKysrKysrKysrDQo+
ICAxIGZpbGUgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzLWV4eW5vcy5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtZXh5bm9z
LmMNCj4gaW5kZXggOGM2MGY3ZC4uODE1YzM2MSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnMtZXh5bm9zLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtZXh5bm9zLmMN
Cj4gQEAgLTEyNDYsNiArMTI0NiwyOSBAQCBzdGF0aWMgaW50IGV4eW5vc191ZnNfcmVzdW1lKHN0
cnVjdCB1ZnNfaGJhICpoYmEsDQo+IGVudW0gdWZzX3BtX29wIHBtX29wKQ0KPiAgICAgICAgIHJl
dHVybiAwOw0KPiAgfQ0KPiANCj4gK3N0YXRpYyB2b2lkIGV4eW5vc191ZnNfZGJnX3JlZ2lzdGVy
X2R1bXAoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3QgZXh5bm9z
X3VmcyAqdWZzID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQo+ICsgICAgICAgdW5zaWduZWQg
bG9uZyBmbGFnczsNCj4gKw0KPiArICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZ1ZnMtPmRiZ19s
b2NrLCBmbGFncyk7DQo+ICsgICAgICAgaWYgKHVmcy0+dW5kZXJfZHVtcCA9PSAwKQ0KSWYgeW91
IHdvdWxkIHVzZSB0ZXN0X2FuZF9zZXRfYml0IGl0IHdvdWxkIHNhdmUgeW91IGJvdGggdW5kZXJf
ZHVtcCBhbmQgZGJnX2xvY2sgPw0KDQo+ICsgICAgICAgICAgICAgICB1ZnMtPnVuZGVyX2R1bXAg
PSAxOw0KPiArICAgICAgIGVsc2Ugew0KPiArICAgICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJx
cmVzdG9yZSgmdWZzLT5kYmdfbG9jaywgZmxhZ3MpOw0KPiArICAgICAgICAgICAgICAgZ290byBv
dXQ7DQo+ICsgICAgICAgfQ0KPiArICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnVmcy0+
ZGJnX2xvY2ssIGZsYWdzKTsNCj4gKw0KPiArICAgICAgIGV4eW5vc191ZnNfZHVtcF9pbmZvKCZ1
ZnMtPmhhbmRsZSwgaGJhLT5kZXYpOw0KPiArDQo+ICsgICAgICAgc3Bpbl9sb2NrX2lycXNhdmUo
JnVmcy0+ZGJnX2xvY2ssIGZsYWdzKTsNCj4gKyAgICAgICB1ZnMtPnVuZGVyX2R1bXAgPSAwOw0K
PiArICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnVmcy0+ZGJnX2xvY2ssIGZsYWdzKTsN
Cj4gK291dDoNCj4gKyAgICAgICByZXR1cm47DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBzdHJ1Y3Qg
dWZzX2hiYV92YXJpYW50X29wcyB1ZnNfaGJhX2V4eW5vc19vcHMgPSB7DQo+ICAgICAgICAgLm5h
bWUgICAgICAgICAgICAgICAgICAgICAgICAgICA9ICJleHlub3NfdWZzIiwNCj4gICAgICAgICAu
aW5pdCAgICAgICAgICAgICAgICAgICAgICAgICAgID0gZXh5bm9zX3Vmc19pbml0LA0KPiBAQCAt
MTI1OCw2ICsxMjgxLDcgQEAgc3RhdGljIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzDQo+IHVm
c19oYmFfZXh5bm9zX29wcyA9IHsNCj4gICAgICAgICAuaGliZXJuOF9ub3RpZnkgICAgICAgICAg
ICAgICAgID0gZXh5bm9zX3Vmc19oaWJlcm44X25vdGlmeSwNCj4gICAgICAgICAuc3VzcGVuZCAg
ICAgICAgICAgICAgICAgICAgICAgID0gZXh5bm9zX3Vmc19zdXNwZW5kLA0KPiAgICAgICAgIC5y
ZXN1bWUgICAgICAgICAgICAgICAgICAgICAgICAgPSBleHlub3NfdWZzX3Jlc3VtZSwNCj4gKyAg
ICAgICAuZGJnX3JlZ2lzdGVyX2R1bXAgICAgICAgICAgICAgID0gZXh5bm9zX3Vmc19kYmdfcmVn
aXN0ZXJfZHVtcCwNCj4gIH07DQo+IA0KPiAgc3RhdGljIGludCBleHlub3NfdWZzX3Byb2JlKHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+IC0tDQo+IDIuNy40DQoNCg==
