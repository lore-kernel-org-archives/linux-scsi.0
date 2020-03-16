Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6409C0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 06:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A49820679
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 06:22:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="UvR3mNh3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgCPGWs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 02:22:48 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:24586 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729435AbgCPGWr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 02:22:47 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Deepak.Ukey@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="Deepak.Ukey@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Deepak.Ukey@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: bEj8BCA2NYvM0/3NpU9NLGxZ4eBVc1+XMrtAuiLWaBbLF1c97DlwmmvUa7xb8Og/2eejbgIhlk
 hq0ZNbuAN103IdszHR3h3wT1LxVzpFwdiI+jVh4miK2wSvU9Cv2rddX4AKcwPanWda2375YxNK
 F4qFF+0YdAefy2M2pQj/y6QOv23/Rh51IK7Dl6kVSx6JaK/lxoyO0CIYvva4ByJDPcpLwEe1aA
 IjWCoZQ2Macyz+QAkB+TctE1kIui33+57mGNhCUixu70YpjnUqhYUNleQqpv18u9JXDSTwN0wo
 XZg=
X-IronPort-AV: E=Sophos;i="5.70,559,1574146800"; 
   d="scan'208";a="72167196"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Mar 2020 23:22:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 15 Mar 2020 23:22:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 15 Mar 2020 23:22:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZI81KxE007YbbmV/eZ0TL4ON5h8aKzxG/SFYVBHUCAmb8H92s7XprzbwAXqRP5kAID11MhzJQ86IqC4jpS/6hHsOmCNg33bM4zlQF6BgMkrkyeZwgf1FQ2/PQPSFo2CJlXpO5cgbvJZXTGUhduv05CQaVjuIosKDzggbWei5pxRy4ST3Uuvite/5d7pUYiIT9GX/ERgEkOXwC9d5vgRs9nTYpA+5C3dMCy5RlVmqv79DBnssKGiTZla8a4b6uk0USUlEGm4++L8fT1wDvwuBmXtvR3IMP3hu+wjeOvV+2UH6lWzFGnyWQwhzG/00UB+E1uR1EPE+jaXN7PB2noCfjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNMTae09DigCRUxhoMtJVszI5IlQXnWG9gvkSaRodXQ=;
 b=OSxLGoSXVh+L+KnNu1y9yRHg99YNpSwvzw3TCC46K75e1dcGoK2hCHYqBCumIDoyusoQp/ouA0a+bS5fzX5wzr4Y0M6tsebzZ428G897A0WhLoJhCx8C19wIxueuVjmlQM8JMfN+VHCpGQImbTVCPU1xuMgKWxfiIwAjGpUJYyGmZwuY+gV51sEYV5TebeUX5SiSu9o9CV82oAIz3byDzsAFZt/ZSMmS9Mm29Cq17ESK0AZbP6yfh3qh64zOaNZDQN64sL+D9KeuM2F8UZU5EDzLs+68IP+v6asak7BI7Sfn5flf00TmIKoE+YwdF4rx5mYSnZUKtbtVZewa1LD83g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNMTae09DigCRUxhoMtJVszI5IlQXnWG9gvkSaRodXQ=;
 b=UvR3mNh3MKne7RxPBLeshLYFMhXFWv5YE23rPxbDrioXFiPFqwb3Bx252AjDBmVZdO/vyVu49XpUJ5Fg34rmyyyObuZrFV48puNoKSo9hMvr4ajQupXUe9L6Tu1XzTFQEhJQNjH+sTXxOAzFmO1FfkJYMcqWyf7LQ0sJHpFv414=
Received: from BYAPR11MB3543.namprd11.prod.outlook.com (2603:10b6:a03:b1::28)
 by BYAPR11MB3269.namprd11.prod.outlook.com (2603:10b6:a03:75::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19; Mon, 16 Mar
 2020 06:22:43 +0000
Received: from BYAPR11MB3543.namprd11.prod.outlook.com
 ([fe80::3d0e:3123:4225:9562]) by BYAPR11MB3543.namprd11.prod.outlook.com
 ([fe80::3d0e:3123:4225:9562%7]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 06:22:43 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <john.garry@huawei.com>, <jinpu.wang@cloud.ionos.com>,
        <dgilbert@interlog.com>
CC:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH V2 05/13] pm80xx : Support for char device.
Thread-Topic: [PATCH V2 05/13] pm80xx : Support for char device.
Thread-Index: AQHVzQVM9vnazpqT4UOKc1DpjMmY0Kfu5wUAgAVhaJaAAExHYIAAgPEAgAFQuBCAAEFtAIAJPCNwgEQRUYCAAFUqAIAAsekAgAAkBYCABfsoMA==
Date:   Mon, 16 Mar 2020 06:22:42 +0000
Message-ID: <BYAPR11MB354387FF15CDA47CB6C4B808EFF90@BYAPR11MB3543.namprd11.prod.outlook.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-6-deepak.ukey@microchip.com>
 <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
 <yq17e1lk666.fsf@oracle.com>
 <MN2PR11MB3550E72F0521F873F52AF671EF0D0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <68e52d06-1fd2-770d-627a-7e8c79067282@huawei.com>
 <MN2PR11MB35509B0042BEE7BFBB707CA8EF0C0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <3e76b6e1-9c3d-2e5c-896e-f1af9a785fe5@huawei.com>
 <MN2PR11MB35505927EB38FFD749E535CBEF0A0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <CAMGffEnHim9GD2F+7ueyoMWuYpdqghGGYqfLrWcAcN3WfXm_Ng@mail.gmail.com>
 <92a5ed32-eecb-dc1b-c485-1b691573f5de@interlog.com>
 <CAMGffEnxq9HTFZ3htbXMQoO4DQr5L+rOS5_KYUh2-edqFNWO1w@mail.gmail.com>
 <647fdd73-d4f5-efc3-a496-e161aa48f70a@huawei.com>
In-Reply-To: <647fdd73-d4f5-efc3-a496-e161aa48f70a@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d08784ca-bed2-4a2b-c357-08d7c9726f98
x-ms-traffictypediagnostic: BYAPR11MB3269:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3269DF3AA26E82EF4AD7EF73EFF90@BYAPR11MB3269.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(396003)(136003)(346002)(199004)(110136005)(54906003)(5660300002)(19627235002)(316002)(26005)(186003)(53546011)(6506007)(71200400001)(8676002)(55016002)(9686003)(8936002)(52536014)(81156014)(7696005)(81166006)(966005)(66946007)(478600001)(7416002)(33656002)(2906002)(4326008)(66476007)(64756008)(86362001)(66556008)(76116006)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3269;H:BYAPR11MB3543.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8unaflCoCfysNXo/IO4IEjwhkWroPTiunM7WLD90wvGUU/NJ7yWts9A/JJzSfLJjEZh/d+pssUwXjA1Vg4pnFajf55XMnJvTM4eiwzeL9X2LX9o2WMk2kADQekBpigTyqUsC2DvQTFsoflgG1PqDlvaMXv+44mEYbLwiDrS18BXedyhr+cUppvQbnPoK+026mMn5DIi9KEV7U/NzxxMi6w9ZTOux45uQUERknL4vowOAcYhcc/otG2RfGmWrvB/JZECl+C6feRm++FzCuI18XHFVv2U6loJ8Oldt74T0ugVNz8CjXdcJn3r1AhGU8uuw3o2SLnraDSwpq09m94kswtkwOIHgvmAKdKzvnu1AiM9TgMUPwU0d2+LOHc1GGksTZZZRUaYt3u98Hpec53oBQnHXY6XK1ZUsTmgJA26Ys5b64bTLMCo4z1kKqp6mJe37znoLEItY7m4fbDfhgG3AbdgadU7g5/+7jeEyKEWem5VceqZ67iA6F3ABn8Hk+Sdjs5T/tw+8t/KhJ26DguygnA==
x-ms-exchange-antispam-messagedata: KA24PeZA8YxWPYVwddT34T6NxqVw+zNiD6rv/H4YbMWU0beVnU21b4vjtZX8fpVqGaY780mFuDU0tA6Lvf4G6eKoH9odLDzwQ4u6SI8QpDuImwyWmR0gXNx3sTb7eV6+V/PX+f7yaAVYNo1IRlhLeQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d08784ca-bed2-4a2b-c357-08d7c9726f98
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 06:22:43.0222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JY5E0/zKBxu0HsYv/PZjkxIIcTFON+u5gV984aynR/6+JYnrP/n/OmT/nzWOvhqSSQO7Bmpr+kA0Dr/DNVKEZ4KG3juLV2tuYRyjRCYsHMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3269
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQoNCk9uIDEyLzAzLzIwMjAgMDg6NDks
IEppbnB1IFdhbmcgd3JvdGU6DQo+IE9uIFdlZCwgTWFyIDExLCAyMDIwIGF0IDExOjEzIFBNIERv
dWdsYXMgR2lsYmVydCA8ZGdpbGJlcnRAaW50ZXJsb2cuY29tPiB3cm90ZToNCj4+DQo+PiBPbiAy
MDIwLTAzLTExIDE6MDggcC5tLiwgSmlucHUgV2FuZyB3cm90ZToNCj4+PiBPbiBUdWUsIEphbiAy
OCwgMjAyMCBhdCAxMDo0MyBBTSA8RGVlcGFrLlVrZXlAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+
Pj4+DQo+Pj4+DQo+Pj4+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91IA0KPj4+PiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUN
Cj4+Pj4NCj4+Pj4gT24gMjIvMDEvMjAyMCAwODo1MCwgRGVlcGFrLlVrZXlAbWljcm9jaGlwLmNv
bSB3cm90ZToNCj4+Pj4+IC1yLS1yLS1yLS0gMSByb290IHJvb3QgNDA5NiBKYW4gMjEgMTI6MDUg
DQo+Pj4+PiBydW5uaW5nX2Rpc3Bhcml0eV9lcnJvcl9jb3VudA0KPj4+Pj4gKioqDQo+Pj4+PiAt
ci0tci0tci0tIDEgcm9vdCByb290IDQwOTYgSmFuIDIxIDEyOjA1IHNhc19hZGRyZXNzDQo+Pj4+
PiBscnd4cnd4cnd4IDEgcm9vdCByb290ICAgIDAgSmFuIDIxIDExOjQ1IHN1YnN5c3RlbSAtPg0K
Pj4+Pj4gLi4vLi4vLi4vLi4vLi4vLi4vLi4vY2xhc3Mvc2FzX3BoeQ0KPj4+Pj4gLXItLXItLXIt
LSAxIHJvb3Qgcm9vdCA0MDk2IEphbiAyMSAxMjowNSB0YXJnZXRfcG9ydF9wcm90b2NvbHMNCj4+
Pj4+IC1ydy1yLS1yLS0gMSByb290IHJvb3QgNDA5NiBKYW4gMjEgMTE6NDUgdWV2ZW50DQo+Pj4+
Pg0KPj4+Pj4gTWF5YmUgdGhlIG90aGVyIHN0dWZmIHByb3ZpZGVkIGluIHRoZSBwYXRjaGVzIGFy
ZSB1c2VmdWwsIEkgZG9uJ3Qga25vdy4NCj4+Pj4+IEJ1dCBkZWJ1Z2ZzIHNlZW1zIGJldHRlciBm
b3IgdGhhdC4NCj4+Pj4+DQo+Pj4+PiAgICAgICAgIC0gMDAwNi1wbTgweHgtc3lzZnMtYXR0cmli
dXRlLWZvci1udW1iZXItb2YtcGh5cw0KPj4+Pj4gICAgICAgICAtIDAwMDctcG04MHh4LUlPQ1RM
LWZ1bmN0aW9uYWxpdHktdG8tZ2V0LXBoeS1zdGF0dXMgZ2V0cyB0aGluZ3MgbGlrZSBQcm9ncmFt
bWVkIExpbmsgUmF0ZSwgTmVnb3RpYXRlZCBMaW5rIFJhdGUsIFBIWSBJZGVudGlmaWVyDQo+Pj4+
PiAgICAgICAgIC0gMDAwOC1wbTgweHgtSU9DVEwtZnVuY3Rpb25hbGl0eS10by1nZXQtcGh5LWVy
cm9yIHByb3ZpZGVzIG90aGVyIHRoaW5ncyBsaWtlIEludmFsaWQgRHdvcmQgRXJyb3IgQ291bnQs
IERpc3Bhcml0eSBFcnJvciBDb3VudA0KPj4+Pj4gICAgICAgICAtIFRoYW5rcyBmb3IgYWRkcmVz
c2luZyBpdC4gV2UgY2FuIGdldCB0aGlzIGluZm8gZnJvbSAvc3lzL2NsYXNzL3Nhc19waHkgYW5k
IC9zeXMvY2xhc3Mvc2FzX3BvcnQgc28gd2Ugd2lsbCBkcm9wIHRoZXNlIGFib3ZlIG1lbnRpb25l
ZCB0aHJlZSBwYXRjaGVzIGZyb20gdGhlIG5leHQgICAgICAgICAgICAgIC0gcGF0Y2ggc2VyaWVz
Lg0KPj4+Pj4NCj4+Pg0KPj4+Pj4NCj4+Pj4+ICAgICAgICAgLSAwMDA5LXBtODB4eC1JT0NUTC1m
dW5jdGlvbmFsaXR5LWZvci1HUElPDQo+Pj4+PiAgICAgICAgIC0gMDAxMy1wbTgweHgtSU9DVEwt
ZnVuY3Rpb25hbGl0eS1mb3ItVFdJLWRldmljZQ0KPj4+Pj4gICAgICAgICAtIEZvciB0aGUgYWJv
dmUgcGF0Y2hlcyBtYW5hZ2VtZW50IHV0aWxpdHkgcGFzc2VzIGNvbW1hbmQgc3BlY2lmaWMgaW5m
b3JtYXRpb24gdG8gZHJpdmVyIHRocm91Z2ggSU9DVEwgc3RydWN0dXJlLCB3aGljaCB1c2VkIGJ5
IGRyaXZlciB0byBmcmFtZSB0aGUgY29tbWFuZCBhbmQgICAgICAgICAtIHNlbmQgdG8gRlcuICBX
ZSBhcmUgdXNpbmcgdGhlIElPQ1RMIGludGVyZmFjZSBmb3IgdGhlIHNhbWUuIFBsZWFzZSBsZXQg
dXMga25vdyB5b3VyIHRob3VnaHQuDQo+Pj4+DQo+Pj4+IFNvIEkgc3BlY2lmaWNhbGx5IHF1ZXN0
aW9uZWQgdGhlIFNHUElPIHBhdGNoIGFuZCB3aHkgaXQgd291bGQgaGF2ZSBhbiBJT0NUTCwgYXMg
dGhpcyBmdW5jdGlvbiBpcyBzdXBwb3J0ZWQgaW4ga2VybmVsIGxpYnNhcy9TQVMgdHJhbnNwb3J0
IGNvZGUgYXMgYW4gU01QIGZ1bmN0aW9uLg0KPj4+Pj4gICAgVGhhbmsgeW91IGZvciB5b3VyIHN1
Z2dlc3Rpb25zLiBXZSB3aWxsIG1ha2UgdXNlIG9mIGZ1bmN0aW9uIHN1cHBvcnRlZCBpbiBsaWJz
YXMuDQo+Pj4NCj4+PiBTbyBiYXNpY2FsbHkgeW91IG9ubHkgbmVlZCBJT0NUTCBmb3IgR1BJTyBh
bmQgVFdJIGRldmljZXMsIG90aGVycyANCj4+PiBjYW4gaW1wbGVtZW50IHZpYSBsaWJzYXMgaW50
ZXJmYWNlIG9yIGZyb20gc3lzZnMgZGlyZWN0bHkuDQo+Pj4NCj4+PiBJIHdvdWxkIGxpa2UgdG8g
c3VnZ2VzdCB5b3UgZG8gc2VuZCBvdXQgb3RoZXIgY2hhbmdlcyB3aXRob3V0IHRoZSANCj4+PiBJ
T0NUTCBwYXJ0cyBmaXJzdCwgYW5kIGNvbnNpZGVyIGFnYWluIElzIGl0IHJlYWxseSBuZWVkZWQg
YnkgdGhlIA0KPj4+IHVzZXIgdG8gY29udHJvbCBHUElPIGFuZCBUV0ksIGFuZCBpZiB0aGVyZSBp
cyBvdGhlciB3YXkgdG8gZG8gaXQ/DQo+Pj4NCj4+PiBTb3JyeSwgSSBkb24ndCBoYXZlIGEgYmV0
dGVyIHN1Z2dlc3Rpb24hDQo+Pg0KPj4gTFNJIFNBUyBIQkFzIChMU0kgbm93IG93bmVkIGJ5IEJy
b2FkY29tKSBpbXBsZW1lbnQgYW4gaW50ZXJuYWwgKiogU01QIA0KPj4gdGFyZ2V0LiBJdCBjYW4g
YmUgc2VlbiBoZXJlOg0KPj4NCj4+ICMgbHMgL2Rldi9ic2cNCj4+IDM6MDowOjAgIDM6MDozOjAg
IDg6MDowOjAgIDg6MDowOjMgICAgICAgICAgIGVuZF9kZXZpY2UtMzoxICAgIGV4cGFuZGVyLTM6
MA0KPj4gMzowOjE6MCAgNDowOjA6MCAgODowOjA6MSAgODowOjA6NCAgICAgICAgICAgZW5kX2Rl
dmljZS0zOjE6MCAgZXhwYW5kZXItMzoxDQo+PiAzOjA6MjowICA3OjA6MDowICA4OjA6MDoyICBl
bmRfZGV2aWNlLTM6MDoxICBlbmRfZGV2aWNlLTM6MiAgICBzYXNfaG9zdDMNCj4+DQo+PiBJdCBp
cyB0aGUgbGFzdCBkZXZpY2Ugbm9kZTogInNhc19ob3N0MyIuIEhvdyBkbyBJIGtub3cgaXQgaXMg
YSBTTVAgdGFyZ2V0Pw0KPj4gQmVjYXVzZSB0aGlzIHdvcmtzOg0KPj4NCj4+ICMgc21wX3JlYWRf
Z3BpbyAvZGV2L2JzZy9zYXNfaG9zdDMNCj4+IFJlYWQgR1BJTyByZWdpc3RlciByZXNwb25zZToN
Cj4+ICAgICBHUElPX0NGR1swXToNCj4+ICAgICAgIHZlcnNpb246IDANCj4+ICAgICAgIEdQSU8g
ZW5hYmxlOiAxDQo+PiAgICAgICBjZmcgcmVnaXN0ZXIgY291bnQ6IDINCj4+ICAgICAgIGdwIHJl
Z2lzdGVyIGNvdW50OiAxDQo+PiAgICAgICBzdXBwb3J0ZWQgZHJpdmUgY291bnQ6IDE2DQo+Pg0K
DQpKRllJLCB0aGF0IHNwZWNpZmljIGNvbW1hbmQgaXMgbm90IGltcGxlbWVudGVkIGZvciBsaWJz
YXMgU01QIGhvc3QgaGFuZGxlciAoc2VlIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL2RyaXZlcnMvc2NzaS9saWJz
YXMvc2FzX2hvc3Rfc21wLmM/aD12NS42LXJjNSNuMjc4KSwNCmJ1dCB0aGUgd3JpdGUgY29tbWFu
ZCBzaG91bGQgYmUgb2sNCg0KPj4gV2hlbiB5b3Ugd29yayBvdXQgd2hhdCBMU0kgYXJlIGRvaW5n
IHdpdGggdGhpcywgcGVyaGFwcyB5b3UgY291bGQgDQo+PiB3cml0ZSBhbiBhcnRpY2xlIGFib3V0
IGl0IGFuZCBtYWtlIGl0IHB1YmxpY2x5IGF2YWlsYWJsZS4NCg0KRmlybXdhcmUgbWFnaWMuLi4N
Cg0KPj4gSXQgaXMgYWx3YXlzIGEgZ29vZCBpZGVhIHRvIHNlZSBob3cgeW91ciBjb21wZXRpdG9y
cyBzb2x2ZSBwcm9ibGVtcyANCj4+IDotKQ0KPiBUaGlzIHNvdW5kcyBpbmRlZWQgYSBiZXR0ZXIg
c29sdXRpb24sIHRoYW5rcyBmb3IgdGhlIGluZm8sIERvdWcNCj4NCj4gQERlZXBhayBVa2V5IGNh
biB5b3UgY2hlY2sgaWYgeW91IGd1eXMgY2FuIGFsc28gZG8gaXQgdGhpcyB3YXk/DQpXZSBhcmUg
Z29pbmcgdG8gc3VibWl0IHRoZSB2ZXJzaW9uIDMgb2YgdGhlIHBhdGNoc2V0IHdpdGhvdXQgSU9D
VEwgcGF0Y2hlcyBhbmQgaW4gZnV0dXJlIHdlIHdpbGwgY29tZSB1cCB3aXRoIHRoZSBkaWZmZXJl
bnQgc29sdXRpb24gZm9yIElPQ1RMIHBhdGNoZXMuIEFsc28gd2Ugd2lsbCBnbyB0aHJvdWdoIHRo
ZSBzb2x1dGlvbiBzdWdnZXN0ZWQgYnkgRG91Zy4NCj4NCj4gUmVnYXJkcywNCj4gRGVlcGFrDQo+
IC4NCj4NCg0K
