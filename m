Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF0AC5DF61
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 06:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0229B21D79
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 06:20:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="oHHFXQ3F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfKGGUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 01:20:43 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:30658 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfKGGUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 01:20:43 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Deepak.Ukey@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="Deepak.Ukey@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  a:mx1.microchip.iphmx.com a:mx2.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Deepak.Ukey@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: oBDffT+zNbU5k+EP5z4eyHh9oydbrqclqSzpMMxzH8S5p+9AKI4AjNC7sQA5SqnhWYSJyl749/
 XsgL+4wKZIm2d/NEPcBI14bpkhNBTHnZCQTHREGCumhlIGIjxyXO6itBUFCg7AkCYztzC5QZpu
 /qL6FGGwF/4wwxZ998LlWuI0eNmLJ07fpJTHL25F7aUHynpU3oUJ8Amfzbkdk2/jQt1qr/OARH
 AoT6aJ0VA8O+JBVZe8hrhPWhK7+YN9v88eF5NU2/xNu+qy16DB7ShqWHOew4sOvET3N2K2TxDf
 wSc=
X-IronPort-AV: E=Sophos;i="5.68,277,1569308400"; 
   d="scan'208";a="54510218"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2019 23:20:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 23:20:20 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 6 Nov 2019 23:20:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHF3EVEjdgkuFdYusZjytVX5v162po2RLGV7t9f+HEGhsp752EVQfFUntWx40+dLxyfQUeubMGXTurzuMN7/W7kN7jI9/i0ExJ2Gnc8x/xm5q3kQxcK/PwUTN9KTEA7EzTiWe1LpejLGX28psw9ZevCsAKAztgiaWr9tdaV8H8Nhe1kakpbTfYLc08bOjv4VtSoJltNaTnkDt0/A5hD3kzKNDR60q2wlbKud0hx/H0hQWeYnhaed5l85PATb9r0XkFu1d8x8FSz6lSU0Adarq376RYUTsDMP9jiyJPifVKfi52bQ9W2a7BwoKk67qrcUQNaaMUBJkyVHQDXy/wF+eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rybXoRYkWxIgNHh4VrhWGVi8DifzFS/+ZD/IKJQTvuU=;
 b=JYfAW4uI5Y6Ya3GMtzGgGaEO6iahaEMSxQxBzrlHO63Nwlj3KcUtqSi1FgHtDnwNuiO8g92c1YkFO/yhBRtTQaTQImlR2PIrOM7YAnTs7PicYSZj4PkBDPe0D8h7nfTInQVN6VmEFxJppzd1ABeEIdUUbj7Ga7wRGkyBSi/INPVsifPnjcm/qFO6gvEE+XGwXaZ6kYczFSoqfK23LRiAKvqKOYMgqvKXdqHyqdPnN7YJsooU+KnOjH/yX+3W129kpn1rKkcxjAHzYaScbujIO9NfLAJX10xEipsk5wrJykP9cIzeJiCBLN4GO6ok1bqw7LQ7Nsb5iTT+t6EQidzanQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rybXoRYkWxIgNHh4VrhWGVi8DifzFS/+ZD/IKJQTvuU=;
 b=oHHFXQ3Fwn2iC5yk7/aWiYuRatBbwptV0B1qlRAGJ/j43elFNmWtgzYH3PK8xDo6pnLIGtvF9MtXepd+bXwb4hFewKp6IFIVZLB+CuTOUuWzlvsc5bTMztcPNawg6bUYD0yd/45SGUknc9iNtQibkm+Yy1QDmb2I6eDBzWBEO9I=
Received: from MN2PR11MB3550.namprd11.prod.outlook.com (20.178.251.149) by
 MN2PR11MB4015.namprd11.prod.outlook.com (10.255.181.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 06:20:19 +0000
Received: from MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::702a:927f:baaa:dd59]) by MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::702a:927f:baaa:dd59%5]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 06:20:19 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <dpf@google.com>,
        <jsperbeck@google.com>, <auradkar@google.com>, <ianyar@google.com>
Subject: RE: [PATCH 10/12] pm80xx : Controller fatal error through sysfs.
Thread-Topic: [PATCH 10/12] pm80xx : Controller fatal error through sysfs.
Thread-Index: AQHVj6nr5fYP0UqPqk21/OdTzuAemad+AHCAgAEsTLA=
Date:   Thu, 7 Nov 2019 06:20:18 +0000
Message-ID: <MN2PR11MB3550193FA72FEF6C5E862E6DEF780@MN2PR11MB3550.namprd11.prod.outlook.com>
References: <20191031051241.6762-1-deepak.ukey@microchip.com>
 <20191031051241.6762-11-deepak.ukey@microchip.com>
 <CAMGffE=qMtx7m_9up1N9j0bGT+cjb0VOUwB2LD5z8=BMU_3MRA@mail.gmail.com>
In-Reply-To: <CAMGffE=qMtx7m_9up1N9j0bGT+cjb0VOUwB2LD5z8=BMU_3MRA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55025f2c-6c6f-4805-dff4-08d7634a8ff5
x-ms-traffictypediagnostic: MN2PR11MB4015:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4015E61D094A9145CFE402A1EF780@MN2PR11MB4015.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(346002)(376002)(39860400002)(189003)(199004)(4326008)(54906003)(6436002)(8676002)(66476007)(76116006)(66946007)(6916009)(66556008)(64756008)(478600001)(25786009)(305945005)(229853002)(6116002)(6246003)(3846002)(256004)(7736002)(14444005)(102836004)(81166006)(11346002)(81156014)(66446008)(26005)(446003)(14454004)(99286004)(5660300002)(476003)(9686003)(486006)(316002)(33656002)(86362001)(66066001)(8936002)(53546011)(74316002)(2906002)(55016002)(7696005)(6506007)(186003)(76176011)(71200400001)(71190400001)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4015;H:MN2PR11MB3550.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PMnOGvyLXNZnJb3qv4Kr0eFytq0cZq6b3Sb1mXDGn7jPRH4U5x9hmVPn7dM66pffQ5QUn8PYVG7EXXpekMd70AuK9CL9P0WEgHMxZJLVWk67pU9eyJKKsHm/s0Ak6ufXIKTmR+s5PAvMIwa6VdwpvaOrFchKpDfQ9MxlJzv8/kDQ8u1GiON8kxF3VwTT2++opGlA3RKFU5D8XJZoy72b7S3LUREIgswvr2fXo8qhQZQsJksJAr+C+nOclV4Vjjw9uJ3TPYMAWNIXlfh5YvicqthGCXit3m7eYQc25JadZjMcBVFdbZEYKIXvmGgMVUGFNsRGJmVjtEcXCeRYfeaQdapF9wDX0GBcWZImd5bU+aQuTc1nb30wO4JKOu/oXMdaMMAfWS+n/rIuJFXAjdP/DZAqufa3x0WDRcHF60JMoA3QxP/XNE18KtF6xRr5BYeF
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 55025f2c-6c6f-4805-dff4-08d7634a8ff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 06:20:18.8740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JGDHJvRH6nN2Nemb92M5LIBFj8UG0i6c8MGefDcLNZROWMk4MYOXA7YcZ7t7+ayngTriuFLFu9P0barJp/G44eupgxNAcUH3KLWesOD10Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4015
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCBPY3QgMzEsIDIwMTkgYXQgNjoxMiBBTSBEZWVwYWsgVWtleSA8ZGVlcGFrLnVrZXlA
bWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+DQo+IEZyb206IERlZXBhayBVa2V5IDxEZWVwYWsuVWtl
eUBtaWNyb2NoaXAuY29tPg0KPg0KPiBBZGRlZCBzdXBwb3J0IHRvIGNoZWNrIGNvbnRyb2xsZXIg
ZmF0YWwgZXJyb3IgdGhyb3VnaCBzeXNmcy4NCj4NCj4gU2lnbmVkLW9mZi1ieTogRGVlcGFrIFVr
ZXkgPGRlZXBhay51a2V5QG1pY3JvY2hpcC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFZpc3dhcyBH
IDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS9wbTgwMDEv
cG04MDAxX2N0bC5jIHwgMjAgKysrKysrKysrKysrKysrKysrKysNCj4gIDEgZmlsZSBjaGFuZ2Vk
LCAyMCBpbnNlcnRpb25zKCspDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcG04MDAx
L3BtODAwMV9jdGwuYyANCj4gYi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9jdGwuYw0KPiBp
bmRleCA2Yjg1MDE2YjRkYjMuLmZiZGQwYmYwZTFhYiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9z
Y3NpL3BtODAwMS9wbTgwMDFfY3RsLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgw
MDFfY3RsLmMNCj4gQEAgLTY5LDYgKzY5LDI1IEBAIHN0YXRpYyBzc2l6ZV90IA0KPiBwbTgwMDFf
Y3RsX21waV9pbnRlcmZhY2VfcmV2X3Nob3coc3RydWN0IGRldmljZSAqY2RldiwgIHN0YXRpYyAg
DQo+IERFVklDRV9BVFRSKGludGVyZmFjZV9yZXYsIFNfSVJVR08sIHBtODAwMV9jdGxfbXBpX2lu
dGVyZmFjZV9yZXZfc2hvdywgDQo+IE5VTEwpOw0KPg0KPiArLyoqDQo+ICsgKiBwbTgwMDFfY3Rs
X2NvbnRyb2xsZXJfZmF0YWxfZXJyIC0gY2hlY2sgY29udHJvbGxlciBpcyB1bmRlciBmYXRhbCAN
Cj4gK2Vycg0KPiArICogQGNkZXY6IHBvaW50ZXIgdG8gZW1iZWRkZWQgY2xhc3MgZGV2aWNlDQo+
ICsgKiBAYnVmOiB0aGUgYnVmZmVyIHJldHVybmVkDQo+ICsgKg0KPiArICogQSBzeXNmcyAncmVh
ZCBvbmx5JyBzaG9zdCBhdHRyaWJ1dGUuDQo+ICsgKi8NCj4gK3N0YXRpYyBzc2l6ZV90IGNvbnRy
b2xsZXJfZmF0YWxfZXJyb3Jfc2hvdyhzdHJ1Y3QgZGV2aWNlICpjZGV2LA0KPiArICAgICAgICAg
ICAgICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1ZikNClRoZSBrZXJu
ZWwtZG9jIGRvZXNuJ3QgbWF0Y2ggdGhlIGZ1bmN0aW9uIG5hbWUsIHBsZWFzZSBmaXggaXQuDQot
LUNhbiB5b3UgcGxlYXNlIHRlbGwgbWUgd2hpY2ggZnVuY3Rpb24gbmFtZSB5b3UgYXJlIHBvaW50
aW5nIG91dC4gSXMgaXQgYWJvdXQgdGhlIGRpZmZlcmVuY2UgaW4gZnVuY3Rpb24gZGVzY3JpcHRp
b24gaW4gdGhlICANCmNvbW1lbnQgKHBtODAwMV9jdGxfY29udHJvbGxlcl9mYXRhbF9lcnIpICBh
bmQgYWN0dWFsIGZ1bmN0aW9uIG5hbWUgKGNvbnRyb2xsZXJfZmF0YWxfZXJyb3Jfc2hvdykgPw0K
PiArew0KPiArICAgICAgIHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gY2xhc3NfdG9fc2hvc3Qo
Y2Rldik7DQo+ICsgICAgICAgc3RydWN0IHNhc19oYV9zdHJ1Y3QgKnNoYSA9IFNIT1NUX1RPX1NB
U19IQShzaG9zdCk7DQo+ICsgICAgICAgc3RydWN0IHBtODAwMV9oYmFfaW5mbyAqcG04MDAxX2hh
ID0gc2hhLT5sbGRkX2hhOw0KPiArDQo+ICsgICAgICAgcmV0dXJuIHNucHJpbnRmKGJ1ZiwgUEFH
RV9TSVpFLCAiJWRcbiIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHBtODAwMV9oYS0+Y29u
dHJvbGxlcl9mYXRhbF9lcnJvcik7DQo+ICt9DQo+ICtzdGF0aWMgREVWSUNFX0FUVFJfUk8oY29u
dHJvbGxlcl9mYXRhbF9lcnJvcik7DQo+ICsNCj4gIC8qKg0KPiAgICogcG04MDAxX2N0bF9md192
ZXJzaW9uX3Nob3cgLSBmaXJtd2FyZSB2ZXJzaW9uDQo+ICAgKiBAY2RldjogcG9pbnRlciB0byBl
bWJlZGRlZCBjbGFzcyBkZXZpY2UgQEAgLTgwNCw2ICs4MjMsNyBAQCBzdGF0aWMgDQo+IERFVklD
RV9BVFRSKHVwZGF0ZV9mdywgU19JUlVHT3xTX0lXVVNSfFNfSVdHUlAsDQo+ICAgICAgICAgcG04
MDAxX3Nob3dfdXBkYXRlX2Z3LCBwbTgwMDFfc3RvcmVfdXBkYXRlX2Z3KTsgIHN0cnVjdCANCj4g
ZGV2aWNlX2F0dHJpYnV0ZSAqcG04MDAxX2hvc3RfYXR0cnNbXSA9IHsNCj4gICAgICAgICAmZGV2
X2F0dHJfaW50ZXJmYWNlX3JldiwNCj4gKyAgICAgICAmZGV2X2F0dHJfY29udHJvbGxlcl9mYXRh
bF9lcnJvciwNCj4gICAgICAgICAmZGV2X2F0dHJfZndfdmVyc2lvbiwNCj4gICAgICAgICAmZGV2
X2F0dHJfdXBkYXRlX2Z3LA0KPiAgICAgICAgICZkZXZfYXR0cl9hYXBfbG9nLA0KPiAtLQ0KPiAy
LjE2LjMNCj4NCldpdGggdGhlIHVwZGF0ZWQga2VybmVsLWRvYy4NCkFja2VkLWJ5OiBKYWNrIFdh
bmcgPGppbnB1LndhbmdAY2xvdWQuaW9ub3MuY29tPg0K
