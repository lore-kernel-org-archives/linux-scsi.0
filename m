Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C10BC33CB3
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 09:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4352224684
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 09:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="vmTS8rm0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgA1Jny (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jan 2020 04:43:54 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:51873 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgA1Jny (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jan 2020 04:43:54 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Deepak.Ukey@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="Deepak.Ukey@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Deepak.Ukey@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: wgyWR0v57Bc87USgk+ljhy4E5wGLXZ4k/ZYi15AhoexjUGXfZalSveqsKR0908Bde6jgTxc9yp
 mes01DalIBjsNHYRuvxMdThaA03RD2dMNfu3PRhAHsE9f4s+Fj5jG4SoV/qK6kr/UcJ4RRKRxf
 lPPGcZyyMYIS/uYHj+s20wAKcfgg4/9IucZtshsVuXvbS/oFCzyPNj3DVpopUb1wCKanZZtllc
 rQKmYFHi884IYUPEMDjIffI8/zIZqF2dW2DTD09t70iMtc+ppkb0HAZNT4PcGB7tyl18mK4bzA
 GFc=
X-IronPort-AV: E=Sophos;i="5.70,373,1574146800"; 
   d="scan'208";a="64717916"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jan 2020 02:43:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 Jan 2020 02:43:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 28 Jan 2020 02:43:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnSWrKFIOWQXeqjD7a04g+s4QqI6xNmebjGEmEk43Khn+CyLtq5Qa3lpXd9lwTzkzCpEtBGVSjZVQCLOndaQ+8u4QorjcyQijggJaQRMWKyy7rPifTFXxvJYrNiEcmEcXUyTytRYvxizbDm/bh0DFY2SBoLyjYlymLWbVF5h8HvdT20QMyEHxbaqApq0vISc+Xq6VPd5lV3eV82eQUEz9LlFWrEySGFxkG4QXvaCfnFu1+sIcKZlBD1Gmt0jFjXgzvqyjwq8fTORX5zxZ7Tdievu42uDlj3z/YGiUw6vkGEnILpvn3rG0z3al1vEG+jr7GHfoATS3C8/rkdZPR5tXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBwFk2PYLOHR8ph5vgdEmsgLNQJ9wTKdABxmV3U7Y6Y=;
 b=ekCyTenZtO7hkLOPZNjUyGZslKCdU+Ugr8JcQp43imrVyRjaFTYdzkH0GsFraQl3eEKAiC255x0uLPm21s1xK5E+dpuBi/IAht6NDkIDssBuqYme0YKZ36LYL4ZTv4bNXnCoN78iZOuwxHVBMtjaYE1yuLW/AW1Q5T64DbbYRVGb3PaTjMQSUbmEHfeU+aXVCPiO1tnArEvEOJBjs0/a2kJTxRUh7XMakAZtFe12awO/L0XBgsyBJUHF0QP8wgoOXUEefTgayReBQzg+GGKGAHjPoKxrazJPTlmiptu9rJXt5D6hQcQjiubZL+Pgh7/hQwVze761TKNY9q5ohzAjUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBwFk2PYLOHR8ph5vgdEmsgLNQJ9wTKdABxmV3U7Y6Y=;
 b=vmTS8rm0R7f7sfGkc9Zmu3BPwyi6yL9Lz1Faq2SDFdXeUcsHAIgtbTQOvlXEb3f5eLHmg5YnCRnFa2py7XmGcsXUUWosxDypm3iPEtHv1nrqj9ktRcZSht5HEF2+u65ltWuYAKD0oW/lE8eRW1LHN/5VTKBxGBkEjR/dduOhHBg=
Received: from MN2PR11MB3550.namprd11.prod.outlook.com (20.178.251.149) by
 MN2PR11MB3678.namprd11.prod.outlook.com (20.178.254.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.23; Tue, 28 Jan 2020 09:43:49 +0000
Received: from MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961]) by MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961%5]) with mapi id 15.20.2665.026; Tue, 28 Jan 2020
 09:43:49 +0000
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
Thread-Index: AQHVzQVM9vnazpqT4UOKc1DpjMmY0Kfu5wUAgAVhaJaAAExHYIAAgPEAgAFQuBCAAEFtAIAJPCNw
Date:   Tue, 28 Jan 2020 09:43:49 +0000
Message-ID: <MN2PR11MB35505927EB38FFD749E535CBEF0A0@MN2PR11MB3550.namprd11.prod.outlook.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-6-deepak.ukey@microchip.com>
 <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
 <yq17e1lk666.fsf@oracle.com>
 <MN2PR11MB3550E72F0521F873F52AF671EF0D0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <68e52d06-1fd2-770d-627a-7e8c79067282@huawei.com>
 <MN2PR11MB35509B0042BEE7BFBB707CA8EF0C0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <3e76b6e1-9c3d-2e5c-896e-f1af9a785fe5@huawei.com>
In-Reply-To: <3e76b6e1-9c3d-2e5c-896e-f1af9a785fe5@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6a53771-263c-492d-e7d3-08d7a3d693c5
x-ms-traffictypediagnostic: MN2PR11MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3678AEA794497291AD022966EF0A0@MN2PR11MB3678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(376002)(136003)(346002)(189003)(199004)(2906002)(71200400001)(19627235002)(26005)(5660300002)(8676002)(7416002)(186003)(53546011)(316002)(9686003)(6506007)(66476007)(110136005)(81166006)(66556008)(66446008)(81156014)(8936002)(55016002)(54906003)(7696005)(478600001)(66946007)(64756008)(76116006)(86362001)(52536014)(33656002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3678;H:MN2PR11MB3550.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IX+KQ0HkOXxYipxluy37Jl8iqzvUzFfpFt3IfTRM1etmBRfMn3gUBm6Fzo2kDdU1ombs1FdoFu51VXHMC/1b2ojaqmfRI5o+iGsns0FkV40ls50bwly47kFcQ+og4KDkLA4Cqpp+7FJ7rxmshPFUo6F9uLe3GGWqZf+bEyaqEz6Ax+a0OpbUe9f740KXi7d6w08iMrQ24V2qlhHLGLQ1cGpZCKamIm6GF5NFWJQzqkjJmstJp1tUVCepO4HyoSrsG/8zz/wJfh0GuV5uZTuZNFj2gXJsONbTXeDkg9tJh3a2qkw0qyB7ljm3j0rRnaw6uTN3NF67wNCt1DtDcJEp++CU4dTjoo3++djIeYHuY1P7u9tFeo5fJNK85X9Rm69T0SJEN8zuWUT55yzwS6M9Xjqivyrsriny7vGhTm3sNIQcpvbGRibH+YHLlQDz/MBf
x-ms-exchange-antispam-messagedata: USJxXRdD/sqLyndAAmNbau9qn2ai7mgQUVAXJ8GaIlY3qmco89jkNA96nOwRghJdwMZ4MypwJPYEov+r6PglSBDcSSd4Ipg72qTFZiDwsPfYtKhrKOaAM6KnnXivXQBKsaNzYqiNrxbHdmHjNpj2bg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c6a53771-263c-492d-e7d3-08d7a3d693c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2020 09:43:49.2005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XmPxEHt3DPfmOk9ebBhyPhvjSV+ifoXtSFICHL/Vt0CXOaD+gtMTRILdiqnte7dYqObf+ahNaISjlSupBLr+d0ufQDDDKOFp2cAoP/DmFwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3678
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMg
dW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCg0KT24gMjIvMDEvMjAyMCAwODo1
MCwgRGVlcGFrLlVrZXlAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4gLXItLXItLXItLSAxIHJvb3Qg
cm9vdCA0MDk2IEphbiAyMSAxMjowNSBydW5uaW5nX2Rpc3Bhcml0eV9lcnJvcl9jb3VudCANCj4g
KioqDQo+IC1yLS1yLS1yLS0gMSByb290IHJvb3QgNDA5NiBKYW4gMjEgMTI6MDUgc2FzX2FkZHJl
c3MNCj4gbHJ3eHJ3eHJ3eCAxIHJvb3Qgcm9vdCAgICAwIEphbiAyMSAxMTo0NSBzdWJzeXN0ZW0g
LT4NCj4gLi4vLi4vLi4vLi4vLi4vLi4vLi4vY2xhc3Mvc2FzX3BoeQ0KPiAtci0tci0tci0tIDEg
cm9vdCByb290IDQwOTYgSmFuIDIxIDEyOjA1IHRhcmdldF9wb3J0X3Byb3RvY29scw0KPiAtcnct
ci0tci0tIDEgcm9vdCByb290IDQwOTYgSmFuIDIxIDExOjQ1IHVldmVudA0KPg0KPiBNYXliZSB0
aGUgb3RoZXIgc3R1ZmYgcHJvdmlkZWQgaW4gdGhlIHBhdGNoZXMgYXJlIHVzZWZ1bCwgSSBkb24n
dCBrbm93Lg0KPiBCdXQgZGVidWdmcyBzZWVtcyBiZXR0ZXIgZm9yIHRoYXQuDQo+DQo+ICAgICAg
IC0gMDAwNi1wbTgweHgtc3lzZnMtYXR0cmlidXRlLWZvci1udW1iZXItb2YtcGh5cw0KPiAgICAg
ICAtIDAwMDctcG04MHh4LUlPQ1RMLWZ1bmN0aW9uYWxpdHktdG8tZ2V0LXBoeS1zdGF0dXMgZ2V0
cyB0aGluZ3MgbGlrZSBQcm9ncmFtbWVkIExpbmsgUmF0ZSwgTmVnb3RpYXRlZCBMaW5rIFJhdGUs
IFBIWSBJZGVudGlmaWVyDQo+ICAgICAgIC0gMDAwOC1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0
eS10by1nZXQtcGh5LWVycm9yIHByb3ZpZGVzIG90aGVyIHRoaW5ncyBsaWtlIEludmFsaWQgRHdv
cmQgRXJyb3IgQ291bnQsIERpc3Bhcml0eSBFcnJvciBDb3VudA0KPiAgICAgICAtIFRoYW5rcyBm
b3IgYWRkcmVzc2luZyBpdC4gV2UgY2FuIGdldCB0aGlzIGluZm8gZnJvbSAvc3lzL2NsYXNzL3Nh
c19waHkgYW5kIC9zeXMvY2xhc3Mvc2FzX3BvcnQgc28gd2Ugd2lsbCBkcm9wIHRoZXNlIGFib3Zl
IG1lbnRpb25lZCB0aHJlZSBwYXRjaGVzIGZyb20gdGhlIG5leHQgICAgICAgICAgICAgIC0gcGF0
Y2ggc2VyaWVzLg0KPg0KPiAgID4gMDAwOS1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0eS1mb3It
R1BJTw0KPiAgID4gMDAxMC1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0eS1mb3ItU0dQSU8NCj4N
Cj4gSSBkb24ndCBrbm93IHdoeSBhbiBpb2N0bCBpcyByZXF1aXJlZCBoZXJlLg0KPg0KPiAgID4g
MDAxMy1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0eS1mb3ItVFdJLWRldmljZQ0KPg0KPiAgICAg
ICAtIDAwMDktcG04MHh4LUlPQ1RMLWZ1bmN0aW9uYWxpdHktZm9yLUdQSU8NCj4gICAgICAgLSAw
MDEwLXBtODB4eC1JT0NUTC1mdW5jdGlvbmFsaXR5LWZvci1TR1BJTw0KPiAgICAgICAtIDAwMTMt
cG04MHh4LUlPQ1RMLWZ1bmN0aW9uYWxpdHktZm9yLVRXSS1kZXZpY2UNCj4gICAgICAgLSBGb3Ig
dGhlIGFib3ZlIHBhdGNoZXMgbWFuYWdlbWVudCB1dGlsaXR5IHBhc3NlcyBjb21tYW5kIHNwZWNp
ZmljIGluZm9ybWF0aW9uIHRvIGRyaXZlciB0aHJvdWdoIElPQ1RMIHN0cnVjdHVyZSwgd2hpY2gg
dXNlZCBieSBkcml2ZXIgdG8gZnJhbWUgdGhlIGNvbW1hbmQgYW5kICAgICAgICAgLSBzZW5kIHRv
IEZXLiAgV2UgYXJlIHVzaW5nIHRoZSBJT0NUTCBpbnRlcmZhY2UgZm9yIHRoZSBzYW1lLiBQbGVh
c2UgbGV0IHVzIGtub3cgeW91ciB0aG91Z2h0Lg0KDQpTbyBJIHNwZWNpZmljYWxseSBxdWVzdGlv
bmVkIHRoZSBTR1BJTyBwYXRjaCBhbmQgd2h5IGl0IHdvdWxkIGhhdmUgYW4gSU9DVEwsIGFzIHRo
aXMgZnVuY3Rpb24gaXMgc3VwcG9ydGVkIGluIGtlcm5lbCBsaWJzYXMvU0FTIHRyYW5zcG9ydCBj
b2RlIGFzIGFuIFNNUCBmdW5jdGlvbi4NCj4gIFRoYW5rIHlvdSBmb3IgeW91ciBzdWdnZXN0aW9u
cy4gV2Ugd2lsbCBtYWtlIHVzZSBvZiBmdW5jdGlvbiBzdXBwb3J0ZWQgaW4gbGlic2FzLg0KDQpG
b3IgdGhlIEdQSU8gSU9DVEwsIGNvdWxkIHlvdSB1c2UgcmVnaXN0ZXIgYSBncGlvIGRyaXZlciB0
byBwcm92aWRlIGEgZ3Bpb2xpYiBzeXNmcz8NCj4gV2UgY2Fubm90IHVzZSBHUElPIGRyaXZlciB0
byBwcm92aWRlIGdwaW9saWIgc3lzZnMuIFRoZXJlIGFyZSAyNCBHUElPIHNpZ25hbHMgcGluIHBy
b3ZpZGVkIGJ5IHRoZSBTUENWIGNvbnRyb2xsZXIgb3V0IG9mIHdoaWNoIDE2IHNpZ25hbHMgcGlu
IGFyZSB1c2VkIGJ5IGN1c3RvbWVyLiAgVGhlIGhvc3QgYXBwbGljYXRpb24gcGVyZm9ybSBkaWZm
ZXJlbnQgb3BlcmF0aW9ucyBvbiB0aGF0IHBpbnMgZm9yIGV4YW1wbGUgcGluIHNldHVwLCBldmVu
dCBzZXR1cCBhbmQgcmVhZC93cml0ZSBHUElPIHBpbnMuDQo+IEZvciB0aGlzLCBhcHBsaWNhdGlv
bnMgcGFzc2VzIGRpZmZlcmVudCBjb21iaW5hdGlvbiBvZiB2YWx1ZXMgdG8gZXhlY3V0ZSB0aGUg
c3BlY2lmaWMgb3BlcmF0aW9uIHdpdGggaGVscCBvZiBhIHBheWxvYWQgc3RydWN0dXJlIGFuZCBh
cHBsaWNhdGlvbiBwYXNzZXMgdGhhdCBzdHJ1Y3R1cmUgdG8gZHJpdmVyIHVzaW5nIElPQ1RMLg0K
PiBEcml2ZXIgZmV0Y2ggdGhlIGluZm9ybWF0aW9uIGxpa2UgaW5wdXQgZW5hYmxlIHBpbiBzZXR1
cCwgdHlwZXBhcnQxL3R5cGVwYXJ0MiBwaW4gc2V0dXAsIGdwaW8gZXZlbnQgbGV2ZWwgc2V0dXAs
IGdwaW8gcmlzaW5nIC8gZmFsbGluZyBlZGdlIHNldHVwLCBncGlvIHBpbiBtYXNrIHNldHVwICBw
YXNzZWQgYnkgYXBwbGljYXRpb24gYW5kIHRoZW4gc2VuZCB3aXRoIHNwZWNpZmljIGNvbW1hbmQg
Zm9ybWF0IHRvIGV4ZWN1dGUgdGhlIGdwaW8gb3BlcmF0aW9uLg0KDQpBcyBmb3IgVFdJLCBpdCBz
ZWVtcyB0byBiZSBmb3Igc2VyaWFsIEVFUFJPTSwgc28geW91IGNvdWxkIGFzayB0aGVzZSBleHBl
cnRzIGFib3V0IGhvdyB0byBoYW5kbGUgaXQgcHJvcGVybHkgaW4gdGhlIGtlcm5lbCBmb3Igc3Rh
bmRhcmQgc3lzZnMNCmludGVyZmFjZXM6DQo+IERyaXZlciBzdXBwb3J0cyBkaWZmZXJlbnQgVFdJ
IGRldmljZXMgbm90IGxpbWl0ZWQgdG8gdGhlIFNlcmlhbCBFRVBST00uIEFwcGxpY2F0aW9uIHBh
c3NlcyB0aGUgYWRkcmVzcyBvZiB0aGUgYXR0YWNoZWQgVFdJIGRldmljZSB0byByZWFkIGFuZCB3
cml0ZSB0aGUgVFdJIGJpbmFyeSBhbG9uZyB3aXRoIHRoZSBwYXlsb2FkIHN0cnVjdHVyZSB3aGlj
aCBjb250YWlucyBpbmZvcm1hdGlvbiBsaWtlIG9mZnNldCwgYWRkcmVzcyBtb2RlLCByZWFkL3dy
aXRlIHNpemUuDQo+IERyaXZlcnMgZmV0Y2ggdGhlIGluZm9ybWF0aW9uIHBhc3NlZCBieSBhcHBs
aWNhdGlvbiBhbmQgdGhlbiBzZW5kIHdpdGggc3BlY2lmaWMgY29tbWFuZCBmb3JtYXQgdG8gZXhl
Y3V0ZSBvcGVyYXRpb24uDQoNCjp+L2xpbnV4JCAuL3NjcmlwdHMvZ2V0X21haW50YWluZXIucGwg
LWYgZHJpdmVycy9taXNjL2VlcHJvbS9lZXByb20uYyBKZWFuIERlbHZhcmUgPGpkZWx2YXJlQHN1
c2UuY29tPiAobWFpbnRhaW5lcjpMRUdBQ1kgRUVQUk9NIERSSVZFUikgQXJuZCBCZXJnbWFubiA8
YXJuZEBhcm5kYi5kZT4gKHN1cHBvcnRlcjpDSEFSIGFuZCBNSVNDIERSSVZFUlMpIEdyZWcgS3Jv
YWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IChzdXBwb3J0ZXI6Q0hBUiBh
bmQgTUlTQw0KRFJJVkVSUykNCg0KVGhhbmtzLA0KRGVlcGFrDQo=
