Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9E7C2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 08:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 092B324656
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 08:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="a8uoMYsc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgAVIuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 03:50:21 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:61971 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVIuV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 03:50:21 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Deepak.Ukey@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="Deepak.Ukey@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Deepak.Ukey@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: GpGT6CXvuxJBhiMikihe6sPjQ5pWG8Lvo7HIZSNDB+KB9CC0Ly9WyGzZz1Igu6gTuQFnEaSbHv
 DBjHLxf/gHmBVMJsC4TIgz0nIdocMKzlZ8FAWrSsr1jSGAS3aBj1KJT6nUf24k55mwd0yCHvBJ
 Mao40bpPOcpaFUYhF8kHmJvjtNxvHN8vkm0oWUaFXvmvbWrok3x2YnJsRWJx/hhNNv8mZKf2v/
 sEGaC2I/RYCkDWrCaQPSK8YEoSi6SR2YeLpTNFv3SndPkGHHw+B5PekcbLlOg3HagMQU0jw4/F
 Y1E=
X-IronPort-AV: E=Sophos;i="5.70,348,1574146800"; 
   d="scan'208";a="61640340"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jan 2020 01:50:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Jan 2020 01:50:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 Jan 2020 01:50:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3w4kPf8xufqsnUzpet6fwlFbDDN6Nk2Js79qwgRrttCtwnBJKqMwNYT469gyF7xrkCCGtCPj46D+Pm3fOpJc8FyMgT9OyPOfpL2Jril8ZSGtWbBuSIg4Gx3YdxwVJ0oI6c5YcGyhqcd4t3D0rqRJ6DUkvZpiEBgQyzdqPPNg2sU9QMiyD+rw7thkpeQGmzTlGisAh/Wm1D4WfF8ml1b9O9NAMwVsFhT3DT9XFikM3KGeLWQIbE89wxvL2h4VffuqJvm3j+eg+sK7Jhrszk/JGyogaOsS3F9yTdssKR8BaRbRtBgTrrP/FjVinmYlXjEyqpYyXefMd/Evfe1PXDv6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRQ55rktWjqDxhMLUMt+vsbIVcvEyodbwV0HMkjlZY4=;
 b=ShakBxmb2FRyIacmTO1amPf41UfWvq+/B5iPmVMsujKuGvo0KwyfQ2mvzarqnOJMDFeIIiI2X/hnBsAbi5OYdFrdY+FRV0vN7ggxXFvRUZNRlSBPTFL8uP0DGrEvQJTd19+JSYSJi0v1sdph4nBXL6PcavC8biRJQT+DuEuBemYkzrT46okc5XBsCKBQ1YqZH+e5YmA44rz76y/5DF7uxBoFvKVHp1rCanvXcW9yvhRBR1mRqq5F0sipcoaQcdJtfi8NeP0nlyuW/e0sPjwMXmBEzriRpi+upVyT9ZnQkNsnRgcRSGnMWRpjGTivkOxD3DTBHAoI+8T+/pWH1hkBRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRQ55rktWjqDxhMLUMt+vsbIVcvEyodbwV0HMkjlZY4=;
 b=a8uoMYscTL9paqPBOtyI0cT4vJZ3ktGI3llMvxbqDrvpT79JQQ0ku31P0pp6CxIXW+HtH0xJ/2+iqeO/BWeYxEUFEwZbQ/yO/+vSI0VsLO0xCsCm7HsAb6pureO641ClnkZYFnfRNNg6VsC1Ky9N/heAkHhjN5Fwq2NxBALNC0U=
Received: from MN2PR11MB3550.namprd11.prod.outlook.com (20.178.251.149) by
 MN2PR11MB3997.namprd11.prod.outlook.com (10.255.181.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 22 Jan 2020 08:50:15 +0000
Received: from MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961]) by MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961%5]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 08:50:15 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <john.garry@huawei.com>, <martin.petersen@oracle.com>,
        <jinpu.wang@cloud.ionos.com>
CC:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH V2 05/13] pm80xx : Support for char device.
Thread-Topic: [PATCH V2 05/13] pm80xx : Support for char device.
Thread-Index: AQHVzQVM9vnazpqT4UOKc1DpjMmY0Kfu5wUAgAVhaJaAAExHYIAAgPEAgAFQuBA=
Date:   Wed, 22 Jan 2020 08:50:14 +0000
Message-ID: <MN2PR11MB35509B0042BEE7BFBB707CA8EF0C0@MN2PR11MB3550.namprd11.prod.outlook.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-6-deepak.ukey@microchip.com>
 <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
 <yq17e1lk666.fsf@oracle.com>
 <MN2PR11MB3550E72F0521F873F52AF671EF0D0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <68e52d06-1fd2-770d-627a-7e8c79067282@huawei.com>
In-Reply-To: <68e52d06-1fd2-770d-627a-7e8c79067282@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9e3572d-ad66-4570-944a-08d79f181968
x-ms-traffictypediagnostic: MN2PR11MB3997:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3997BFFF450887620D326257EF0C0@MN2PR11MB3997.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(366004)(136003)(39860400002)(376002)(199004)(189003)(8676002)(2906002)(110136005)(71200400001)(76116006)(7416002)(5660300002)(52536014)(33656002)(316002)(55016002)(81156014)(478600001)(8936002)(7696005)(81166006)(6506007)(53546011)(26005)(9686003)(86362001)(66946007)(186003)(66556008)(66476007)(64756008)(4326008)(54906003)(19627235002)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3997;H:MN2PR11MB3550.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3AZD3+WYVrglxD1dJ8eeUECCVkHOOp8YbBjEN8NbiHukbMPP85nMYjKPkK+KwC1x+MNqYYjtFHKtWHY5/j1TT3QAeIRo8hYkUp5KeAUN3M1l5pVXAb+fbAKRFL3pKcY1ZqZbQz9FXupsaWUMOYHa9csclqn7Dsohppoiv7Iy/v/d1nnUVmYGLhrpzwir/UcwbvU+cu3Y1i4EELjTo4SWqBG2SnLvm9Rbzlqvo0cTlhyUo6Qfa1mo9rwjKrqBUakE1riPkBDB3adW+2/PEwQkO84iLWmFQp4kVZPmnaIogOqq1NZNTd5PdkBAYluf9hP/ErkSAfY4J1UI7DuQ6z5QQhHheVxDMA7ZqMjjbwcyIUVXMNimdfZQSeBtuzkVAph12cJZlUj34n13w9Io6dxMfPHVZNQ4iEP7lPWR9RnLeSlWTBoKzSsC+EinGnVWRe5U
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b9e3572d-ad66-4570-944a-08d79f181968
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 08:50:14.9730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: seqw67ALt/VnWCUqWW2qV+S8uLba8X6aBmMHo1HVFsriu5+t2nCJhrCucc5k7ez/kKk3bSx9rGBBMrR7RTVDaVqwbYHyFSIsuu405AKbFs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3997
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMg
dW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCg0KT24gMjEvMDEvMjAyMCAwNToz
MywgRGVlcGFrLlVrZXlAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4NCj4gRVhURVJOQUwgRU1BSUw6
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyAN
Cj4gdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPg0KPiBNYXJ0aW4sDQo+DQo+PiBUaGFua3MgZm9yIHRo
ZSBjb21taXQgbWVzc2FnZSwgbG9va3MgbXVjaCBiZXR0ZXIuIEluIHRoZSBwYXN0LCBwZW9wbGUg
DQo+PiBhcmUgYWdhaW5zdCBJT0NUTCwgc3VnZ2VzdGluZyBuZXRsaW5rLCBoYXZlIHlvdSBjb25z
aWRlcmVkIHRoYXQ/DQo+DQo+IE5vdCBzbyBrZWVuIG9uIGFkZGluZyBtb3JlIGlvY3Rscy4gSXQn
cyAyMDIwIGFuZCBhbGwuLi4NCj4NCj4gR2l2ZW4gdGhlIG5hdHVyZSBvZiB0aGUgZXhwb3J0ZWQg
aW5mb3JtYXRpb24sIHdoYXQncyB3cm9uZyB3aXRoIHB1dHRpbmcgaXQgaW4gc3lzZnM/DQo+IC0t
IFdlIGhhdmUgc29tZSB1cGNvbWluZyBwYXRjaGVzIHdoaWNoIHVzZXMgdGhpcyBJT0NUTCBpbnRl
cmZhY2UgYW5kIHRoYXQgY2Fubm90IGJlIHN1cHBvcnRlZCB0aHJvdWdoIHN5c2ZzLg0KPiBCZWxv
dyBhcmUgdGhlIHBhdGNoZXMgaW4gdGhpcyBwYXRjaHNldCB3aGljaCByZXF1aXJlcyBJT0NUTCBp
bnRlcmZhY2UuDQo+IDAwMDctcG04MHh4LUlPQ1RMLWZ1bmN0aW9uYWxpdHktdG8tZ2V0LXBoeS1z
dGF0dXMNCj4gMDAwOC1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0eS10by1nZXQtcGh5LWVycm9y
DQoNClBsZWFzZSBub3RlIHRoYXQgdGhlcmUgZGVmaW5pdGVseSBzZWVtcyB0byBiZSByZXBsaWNh
dGlvbiBvZiB3aGF0IHN5c2ZzIGFscmVhZHkgcHJvdmlkZXMgaW4gc29tZSBvZiB0aGVzZSBwYXRj
aGVzOg0KDQotIDAwMDctcG04MHh4LUlPQ1RMLWZ1bmN0aW9uYWxpdHktdG8tZ2V0LXBoeS1zdGF0
dXMgZ2V0cyB0aGluZ3MgbGlrZSBQcm9ncmFtbWVkIExpbmsgUmF0ZSwgTmVnb3RpYXRlZCBMaW5r
IFJhdGUsIFBIWSBJZGVudGlmaWVyDQoNCi0gMDAwOC1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0
eS10by1nZXQtcGh5LWVycm9yIHByb3ZpZGVzIG90aGVyIHRoaW5ncyBsaWtlIEludmFsaWQgRHdv
cmQgRXJyb3IgQ291bnQsIERpc3Bhcml0eSBFcnJvciBDb3VudA0KDQpTZWUgKioqOg0KDQpyb290
QHVidW50dTovc3lzL2NsYXNzL3Nhc19waHkvcGh5LTA6MCMgbHMgLWwgdG90YWwgMA0KbHJ3eHJ3
eHJ3eCAxIHJvb3Qgcm9vdCAgICAwIEphbiAyMSAxMjowNSBkZXZpY2UgLT4gLi4vLi4vLi4vcGh5
LTA6MA0KLXItLXItLXItLSAxIHJvb3Qgcm9vdCA0MDk2IEphbiAyMSAxMjowNSBkZXZpY2VfdHlw
ZQ0KLXJ3LXItLXItLSAxIHJvb3Qgcm9vdCA0MDk2IEphbiAyMSAxMjowNSBlbmFibGUgKioqDQot
LXctLS0tLS0tIDEgcm9vdCByb290IDQwOTYgSmFuIDIxIDEyOjA1IGhhcmRfcmVzZXQNCi1yLS1y
LS1yLS0gMSByb290IHJvb3QgNDA5NiBKYW4gMjEgMTI6MDUgaW5pdGlhdG9yX3BvcnRfcHJvdG9j
b2xzDQotci0tci0tci0tIDEgcm9vdCByb290IDQwOTYgSmFuIDIxIDEyOjA1IGludmFsaWRfZHdv
cmRfY291bnQgKioqDQotLXctLS0tLS0tIDEgcm9vdCByb290IDQwOTYgSmFuIDIxIDEyOjA1IGxp
bmtfcmVzZXQNCi1yLS1yLS1yLS0gMSByb290IHJvb3QgNDA5NiBKYW4gMjEgMTI6MDUgbG9zc19v
Zl9kd29yZF9zeW5jX2NvdW50ICoqKg0KLXJ3LXItLXItLSAxIHJvb3Qgcm9vdCA0MDk2IEphbiAy
MSAxMjowNSBtYXhpbXVtX2xpbmtyYXRlICoqKg0KLXItLXItLXItLSAxIHJvb3Qgcm9vdCA0MDk2
IEphbiAyMSAxMjowNSBtYXhpbXVtX2xpbmtyYXRlX2h3ICoqKg0KLXJ3LXItLXItLSAxIHJvb3Qg
cm9vdCA0MDk2IEphbiAyMSAxMjowNSBtaW5pbXVtX2xpbmtyYXRlICoqKg0KLXItLXItLXItLSAx
IHJvb3Qgcm9vdCA0MDk2IEphbiAyMSAxMjowNSBtaW5pbXVtX2xpbmtyYXRlX2h3ICoqKg0KLXIt
LXItLXItLSAxIHJvb3Qgcm9vdCA0MDk2IEphbiAyMSAxMjowNSBuZWdvdGlhdGVkX2xpbmtyYXRl
ICoqKg0KLXItLXItLXItLSAxIHJvb3Qgcm9vdCA0MDk2IEphbiAyMSAxMTo1OCBwaHlfaWRlbnRp
ZmllciAqKioNCi1yLS1yLS1yLS0gMSByb290IHJvb3QgNDA5NiBKYW4gMjEgMTI6MDUgcGh5X3Jl
c2V0X3Byb2JsZW1fY291bnQgKioqDQpkcnd4ci14ci14IDIgcm9vdCByb290ICAgIDAgSmFuIDIx
IDEyOjA1IHBvd2VyDQotci0tci0tci0tIDEgcm9vdCByb290IDQwOTYgSmFuIDIxIDEyOjA1IHJ1
bm5pbmdfZGlzcGFyaXR5X2Vycm9yX2NvdW50ICoqKg0KLXItLXItLXItLSAxIHJvb3Qgcm9vdCA0
MDk2IEphbiAyMSAxMjowNSBzYXNfYWRkcmVzcw0KbHJ3eHJ3eHJ3eCAxIHJvb3Qgcm9vdCAgICAw
IEphbiAyMSAxMTo0NSBzdWJzeXN0ZW0gLT4NCi4uLy4uLy4uLy4uLy4uLy4uLy4uL2NsYXNzL3Nh
c19waHkNCi1yLS1yLS1yLS0gMSByb290IHJvb3QgNDA5NiBKYW4gMjEgMTI6MDUgdGFyZ2V0X3Bv
cnRfcHJvdG9jb2xzDQotcnctci0tci0tIDEgcm9vdCByb290IDQwOTYgSmFuIDIxIDExOjQ1IHVl
dmVudA0KDQpNYXliZSB0aGUgb3RoZXIgc3R1ZmYgcHJvdmlkZWQgaW4gdGhlIHBhdGNoZXMgYXJl
IHVzZWZ1bCwgSSBkb24ndCBrbm93Lg0KQnV0IGRlYnVnZnMgc2VlbXMgYmV0dGVyIGZvciB0aGF0
Lg0KDQoJLSAwMDA2LXBtODB4eC1zeXNmcy1hdHRyaWJ1dGUtZm9yLW51bWJlci1vZi1waHlzDQoJ
LSAwMDA3LXBtODB4eC1JT0NUTC1mdW5jdGlvbmFsaXR5LXRvLWdldC1waHktc3RhdHVzIGdldHMg
dGhpbmdzIGxpa2UgUHJvZ3JhbW1lZCBMaW5rIFJhdGUsIE5lZ290aWF0ZWQgTGluayBSYXRlLCBQ
SFkgSWRlbnRpZmllcg0KCS0gMDAwOC1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0eS10by1nZXQt
cGh5LWVycm9yIHByb3ZpZGVzIG90aGVyIHRoaW5ncyBsaWtlIEludmFsaWQgRHdvcmQgRXJyb3Ig
Q291bnQsIERpc3Bhcml0eSBFcnJvciBDb3VudA0KCS0gVGhhbmtzIGZvciBhZGRyZXNzaW5nIGl0
LiBXZSBjYW4gZ2V0IHRoaXMgaW5mbyBmcm9tIC9zeXMvY2xhc3Mvc2FzX3BoeSBhbmQgL3N5cy9j
bGFzcy9zYXNfcG9ydCBzbyB3ZSB3aWxsIGRyb3AgdGhlc2UgYWJvdmUgbWVudGlvbmVkIHRocmVl
IHBhdGNoZXMgZnJvbSB0aGUgbmV4dCAJCS0gcGF0Y2ggc2VyaWVzLg0KDQogPiAwMDA5LXBtODB4
eC1JT0NUTC1mdW5jdGlvbmFsaXR5LWZvci1HUElPDQogPiAwMDEwLXBtODB4eC1JT0NUTC1mdW5j
dGlvbmFsaXR5LWZvci1TR1BJTw0KDQpJIGRvbid0IGtub3cgd2h5IGFuIGlvY3RsIGlzIHJlcXVp
cmVkIGhlcmUuDQoNCiA+IDAwMTMtcG04MHh4LUlPQ1RMLWZ1bmN0aW9uYWxpdHktZm9yLVRXSS1k
ZXZpY2UNCg0KCS0gMDAwOS1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0eS1mb3ItR1BJTw0KCS0g
MDAxMC1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0eS1mb3ItU0dQSU8NCgktIDAwMTMtcG04MHh4
LUlPQ1RMLWZ1bmN0aW9uYWxpdHktZm9yLVRXSS1kZXZpY2UNCgktIEZvciB0aGUgYWJvdmUgcGF0
Y2hlcyBtYW5hZ2VtZW50IHV0aWxpdHkgcGFzc2VzIGNvbW1hbmQgc3BlY2lmaWMgaW5mb3JtYXRp
b24gdG8gZHJpdmVyIHRocm91Z2ggSU9DVEwgc3RydWN0dXJlLCB3aGljaCB1c2VkIGJ5IGRyaXZl
ciB0byBmcmFtZSB0aGUgY29tbWFuZCBhbmQgCS0gc2VuZCB0byBGVy4gIFdlIGFyZSB1c2luZyB0
aGUgSU9DVEwgaW50ZXJmYWNlIGZvciB0aGUgc2FtZS4gUGxlYXNlIGxldCB1cyBrbm93IHlvdXIg
dGhvdWdodC4NCg0KUmVnYXJkcywNCkRlZXBhaw0K
