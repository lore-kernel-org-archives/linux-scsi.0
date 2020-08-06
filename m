Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACF9C43618
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5927221E2
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="nn+5gWd8";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="C8aXj5fU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgHFGf7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 02:35:59 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:61581 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgHFGf5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 02:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596695756; x=1628231756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tJG74rl1/gk29g14pxLoGaFrjJfaQU+sWK+ypMOtwCU=;
  b=nn+5gWd8Z7jVtDXRuPCcpNvReHWA1tNZ7vykvwdRmmZF5kerjkOOxS5x
   EnZZQoEgha39ZREDiXqSfCN3xP2wsqvJvM8iWFTufTgCpXzvj5hIJEzXs
   pfGmW3o//edd2gvnDkq+B5kOrVAYiBFbyOGB5chsFa8aE+9oWdFsRZSiv
   z9gMZdRGMf+zFwekKYxUdzF4W8cICC/5UhqIORK8eRcZ+R7Do2iHX+D0z
   kPTldx5LKQZ2AGDXuaWTV9i20hN47VYjN9HmSijijSVgxRUFE/7/4dP2k
   QWHrcuvlvQ/0WNbthuAWf6/TykSyJdDi9ZiyyDTZEb33/mYe4ZkDWYiQ8
   w==;
IronPort-SDR: dNGip56gCz3jAiVDJToQg6eNwX6owd2ek7RdwG/ZMREY9fLPRx1hrnqlsaKIXFTtnd0dU8tapv
 z1JeAhM4xuCi9bH2PkFp7KrJOBZB9c4KbOxiGAbHCfU10dV+IUXfhCGXt4fBapc7lnRJ8riaBE
 FMsQU2V7RdnLZB5Vq22m4STjfdJgWyD+nw3wnncyjvD+fZu/5ZC2/Q2JfjopB9+L+hxwndjYxp
 2h1dI3w86hSjFktJ9OBDO6Z4YVvbhUPXyzDGH9w3952TgHDWn50tDfSyH20e2w2C6IEih4N+sj
 nkk=
X-IronPort-AV: E=Sophos;i="5.75,440,1589266800"; 
   d="scan'208";a="21972352"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Aug 2020 23:35:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 5 Aug 2020 23:35:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 5 Aug 2020 23:35:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muWBloMx18vlMVITaLxI+9//hWLvegrwwOkDx0/iQyw/JkJqGVKBZrvd5RYWTk4S8sYx7GR+mzZfyTsNX1KOFKit07Z0wQkQqaQtixwUIf55MRyc4zOq+GPkQTnC6VA9eCyfQYuvDcawVSjm8pXz/FHG6NyjK4hwJY8t/bE1v+WipheHzo18ypztPDIPv4VdfuMtNS1pduysE0ZmfE80YQn0dKYOiUljCK6CIiyYxpziNdyGiRE2to9w+vEeOqNQ5RYFqLIPO+zC1BG9P55u3IMM4WUvacO0Fre0ov4ckb67hi3RT7iZAbg6VbQilX9i4B7gJ4ylWTk/c0D1MRgXwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJG74rl1/gk29g14pxLoGaFrjJfaQU+sWK+ypMOtwCU=;
 b=T+8WkueR20UtTse4X2CrDie3CMDt2tdE9fkdmqHNb0PR/brWmnyOUZ8KO5UCPFvou7tmLlehi9znIbTp0J5aUsnzffIFeWpdqPSkw9uLM5GGjIYsa1A+7l11IwGxWXOn+0NXm9enQiy2ShOPfJz1Fj7WL8B/86VdEbsq+DINm4cj1M9zQXWpTtdDYdtCI0JtN5f87/6LrZYStDuNjwcpIdjv9vW0BEEkc7w/cInsyz5wtLfhCxby5CeLWPav/ZtqvZSYlv0d+MOigYl2g5te3a0O8DLcJU+SCjk9wF/oXwCh4J9Jj2ROmr496f765LAOEt6ixruCM5jEf3sl5EC44g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJG74rl1/gk29g14pxLoGaFrjJfaQU+sWK+ypMOtwCU=;
 b=C8aXj5fUBeEQPt79IjS8vvTXKvTiuS9GLeoCK4hQYOhY1q/aKEBRDmUZxJllT3cyJt7r+CAF12WbO92WcZdPs0hUqo8KWhu8Cpwq6pCf7VTt9g6ObWqEIqAYZSZ540YVpETPq0fVnh06G3GTshclsLwPJxb9wOjheEJfEcKtd40=
Received: from MWHPR11MB1568.namprd11.prod.outlook.com (2603:10b6:301:f::20)
 by MWHPR1101MB2208.namprd11.prod.outlook.com (2603:10b6:301:4d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Thu, 6 Aug
 2020 06:35:47 +0000
Received: from MWHPR11MB1568.namprd11.prod.outlook.com
 ([fe80::c8ea:a04c:8daa:a503]) by MWHPR11MB1568.namprd11.prod.outlook.com
 ([fe80::c8ea:a04c:8daa:a503%12]) with mapi id 15.20.3261.015; Thu, 6 Aug 2020
 06:35:45 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <john.garry@huawei.com>, <hch@infradead.org>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>,
        <chenxiang66@hisilicon.com>, <yanaijie@huawei.com>,
        <luojiaxing@huawei.com>
Subject: RE: [PATCH V6 2/2] pm80xx : Staggered spin up support.
Thread-Topic: [PATCH V6 2/2] pm80xx : Staggered spin up support.
Thread-Index: AQHWahpYwcBHbbKDcU2nwyxmUYyn4KkndX2AgAAIPuCAAC0kgIAACimwgAIA1QCAAOxugA==
Date:   Thu, 6 Aug 2020 06:35:45 +0000
Message-ID: <MWHPR11MB1568D57D6C70598B50F70330EF480@MWHPR11MB1568.namprd11.prod.outlook.com>
References: <20200804045628.6590-1-deepak.ukey@microchip.com>
 <20200804045628.6590-3-deepak.ukey@microchip.com>
 <20200804060235.GA28428@infradead.org>
 <DM5PR11MB15637501DB12BE665E81C7FBEF4A0@DM5PR11MB1563.namprd11.prod.outlook.com>
 <1d09bf1a-f555-b5de-a369-9797f96b2e9d@huawei.com>
 <MWHPR11MB1568027073E64A535B278D32EF4A0@MWHPR11MB1568.namprd11.prod.outlook.com>
 <4a11caf7-933a-1079-526c-b5c97183ac04@huawei.com>
In-Reply-To: <4a11caf7-933a-1079-526c-b5c97183ac04@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [103.252.171.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac3a3b25-49dc-4fc8-f31c-08d839d2f312
x-ms-traffictypediagnostic: MWHPR1101MB2208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB22083C02E847B79DC33A4816EF480@MWHPR1101MB2208.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g9M+l7twCfJr/dh7BYNhB12DM2rcFxt2eylQGT3iX2rWhju75MbZOvB4bzwVnhcjzaFyiMjS2WoeUgG2WLr98pz71D3M2aoKzB7+0mXPm/rk4Oa9BomrbZX5JAfArdY/6xHrzQzb5ZTuny00tYP937MfLvSDpKxQDCGYsu7d4vFEVsiukvf2HBbzWuBusdWhBdA20uT95DWHxZBD6bXvi7viOVamCvrENXEa7BMGMUdCND1EqphrvWDTpGsMeyZpVI5hGZQXUFgNcDOZyG67mxKAJrO8f4VdUX9bLfwjWzCgnCSMac6BZqfaUbe55M0a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1568.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(346002)(366004)(136003)(396003)(53546011)(2906002)(71200400001)(76116006)(66946007)(66476007)(8676002)(9686003)(83380400001)(7696005)(66446008)(66556008)(478600001)(316002)(52536014)(5660300002)(86362001)(64756008)(7416002)(110136005)(54906003)(186003)(6506007)(55016002)(4326008)(26005)(8936002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0StVRJ5FaqiDS6Mc/SAjf+RfcWG93vxmGItJujNQLHdPQjIeDvOBONXjrKsNJ7Y4flc1iHBGFfuJigVBcbJNM0XtDkHJQR9Jx1CPHvaT4JigQN4PrC3u70NLluajeXU7rK4YCDlKwJ0mE0r5o/2UnaZE7vdwc3z4EGTXJ51bq4A8oyuz7HGMQGNn0D/lm8asZiaZlDxHOdglXNwRG+lFgqyDDijLTcMWmR3EXJpmVyALwZrm6nCRRaqabcDQOwrCSNOym9w//A4xkPfnRe3RLQcoUjmk4VvI0NI+YZk0ezxFBp0xye00EYoW9AXzhIlqW75IMrjDZX6SS1ZlHthbFpG9NEWZleryxahv3GZN6oen/aflRnRq8xfPv5Jh9hV7ym9rzfrZaV4NbE091wmXfzxIaybD7zhQTgpt3xaV1VdKKtWNBmxMsSbJDCCZjT+28KTLewKjIVw2V10vJVGEvVjmQzv9gryHTToosQUHI/2yagXYwAr/JTwy/FFWeuKsbkTNc5rkN9jDaX/4SAnbpt2TPsxCMPzAQCULPuAZYQ/DllAjcXcWABR2vrLr8zopNTwRio1+PNHmKe+TExDRoJzCjRtt+qfPB0uLrwmD38cRXGY//p+nfZ+0SmIg4pTmxjUSBE7DvadGudCifMUdiA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1568.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3a3b25-49dc-4fc8-f31c-08d839d2f312
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2020 06:35:45.5406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RGOdDh6wJHL3mud02wQS3JoJNl30s5WU7l7BavmldnKxz5ssS1/DIDrt8jFYyHOKpygvPjaDhCCywy3y0IUln6RjcPoox7y+G0hsFLS0hNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2208
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gIC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ICBGcm9tOiBKb2huIEdhcnJ5IFtt
YWlsdG86am9obi5nYXJyeUBodWF3ZWkuY29tXQ0KPiAgU2VudDogV2VkbmVzZGF5LCBBdWd1c3Qg
NSwgMjAyMCA5OjU2IFBNDQo+ICBUbzogRGVlcGFrIFVrZXkgLSBJMzExNzIgPERlZXBhay5Va2V5
QG1pY3JvY2hpcC5jb20+Ow0KPiAgaGNoQGluZnJhZGVhZC5vcmcNCj4gIENjOiBsaW51eC1zY3Np
QHZnZXIua2VybmVsLm9yZzsgVmFzYW50aGFsYWtzaG1pIFRoYXJtYXJhamFuIC0gSTMwNjY0DQo+
ICA8VmFzYW50aGFsYWtzaG1pLlRoYXJtYXJhamFuQG1pY3JvY2hpcC5jb20+OyBWaXN3YXMgRyAt
IEkzMDY2Nw0KPiAgPFZpc3dhcy5HQG1pY3JvY2hpcC5jb20+OyBqaW5wdS53YW5nQHByb2ZpdGJy
aWNrcy5jb207DQo+ICBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsgeXV1emhlbmdAZ29vZ2xl
LmNvbTsNCj4gIGF1cmFka2FyQGdvb2dsZS5jb207IHZpc2hha2hhdmNAZ29vZ2xlLmNvbTsgYmph
c2huYW5pQGdvb2dsZS5jb207DQo+ICByYWRoYUBnb29nbGUuY29tOyBha3NoYXR6ZW5AZ29vZ2xl
LmNvbTsgY2hlbnhpYW5nNjZAaGlzaWxpY29uLmNvbTsNCj4gIHlhbmFpamllQGh1YXdlaS5jb207
IGx1b2ppYXhpbmdAaHVhd2VpLmNvbQ0KPiAgU3ViamVjdDogUmU6IFtQQVRDSCBWNiAyLzJdIHBt
ODB4eCA6IFN0YWdnZXJlZCBzcGluIHVwIHN1cHBvcnQuDQo+ICANCj4gIEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlDQo+ICBjb250ZW50IGlzIHNhZmUNCj4gIA0KPiAgT24gMDQvMDgvMjAyMCAxMDo1MSwgRGVl
cGFrLlVrZXlAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4gID4gRVhURVJOQUwgRU1BSUw6IERvIG5v
dCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdw0KPiAgPiB0
aGUgY29udGVudCBpcyBzYWZlDQo+ICA+DQo+ICA+IE9uIDA0LzA4LzIwMjAgMDc6MzMsRGVlcGFr
LlVrZXlAbWljcm9jaGlwLmNvbSAgd3JvdGU6DQo+ICA+PiBIaSBDaHJpc3RvcGgsDQo+ICA+Pg0K
PiAgPj4gWWVzLCBJdCBpcyBiZXR0ZXIgdG8gYmUgaW1wbGVtZW50ZWQgaW4gbGlic2FzLiBTaW5j
ZSB0aGUgb3V0IG9mIGJveCBwbTgweHgNCj4gIGRyaXZlciBoYXMgdGhpcyBzdXBwb3J0LCB3ZSB3
b3VsZCBsaWtlIHRvIHB1c2ggdGhpcyBmb3IgdGhlIHRpbWUgYmVpbmcuIFdlIHdpbGwNCj4gIHNl
ZSBob3cgdGhpcyBjYW4gYmUgbW92ZWQgdG8gbGlic2FzLg0KPiAgPj4NCj4gID4gT3RoZXIgbGli
c2FzIHVzZXJzIG1heSBsaWtlIHRoaXMgZmVhdHVyZS4gQW5kIGxpYnNhcyBkb2VzIGFscmVhZHkg
c3VwcG9ydCBTQVRBDQo+ICBzcGluLXVwIGhvbGQgZXZlbnRzIC0gYXMgZG9lcyBwbTgwMDEgLSBi
dXQgdGhlcmUncyBub3QgcmVhbGx5IG11Y2ggdG8gdGhhdCBpbg0KPiAgbGlic2FzLg0KPiAgPg0K
PiAgPiBRdWVzdGlvbjogd2h5IGhhdmUgYSBtb2R1bGUgcGFyYW0gdG8gZW5hYmxlIHRoaXMgZmVh
dHVyZT8gV2h5IG5vdCBzb2xlbHkNCj4gIHJlbHkgb24gdGhlIHNlZXByb20gc3Bpbi11cCBpbnRl
cnZhbCwgd2hlcmVieSBhIHZhbHVlIG9mIDAgbWVhbnMgbm8gc3RhZ2dlcmVkDQo+ICBzcGluLXVw
Pw0KPiAgPiAtIFNldHRpbmcgc3Bpbi11cCBpbnRlcnZhbCBtYXkgaW5jcmVhc2UgdGhlIHRpbWUg
Zm9yIGRldmljZSBkaXNjb3ZlcnkuDQo+ICA+IEN1c3RvbWVyIHdobyBoYXMgYSB2YWxpZCBzcGlu
IHVwIGludGVydmFsDQo+ICANCj4gIFBsZWFzZSB1c2Ugc3RhbmRhcmQgbWFpbGluZyBsaXN0IHBy
YWN0aWNlcyBpbiByZXBseWluZy4NCj4gIA0KPiAgICAgICAgLSBjb25maWd1cmVkIGNhbiBzdGls
bCB0dXJuIG9mIHRoaXMgdXNpbmcgbW9kdWxlIHBhcmFtZXRlci4gT3IgZWxzZSwgdGhleSBoYXZl
DQo+ICB0byByZWZsYXNoIHRoZSBzZWVwcm9tLg0KPiAgDQo+ICBTbyBhbm90aGVyIGtub2IgdG8g
Y29udHJvbCB0aGUgZHJpdmVyLiBBbnl3YXkgSSB0aGluayB0aGF0IGl0IHdvdWxkIGJlIGdvb2Qg
Zm9yDQo+ICBsaWJzYXMgdG8gc3VwcG9ydCB0aGlzIGZlYXR1cmUgdG8gYmVuZWZpdCBhbGwgdXNl
cnMuDQo+ICANCj4gIEFsbCB0aGUgdHVuYWJsZXMgZnJvbSB0aGUgTExERCBjYW4gYmUgZmVkIHRv
IGxpYnNhcywgYW5kIGxpYnNhcyBqdXN0IG5lZWRzIHRvIGRvDQo+ICB3aGF0IHlvdSBkbyBpbiBw
bTgwMDFfc3BpbnVwX3RpbWVkb3V0KCkgdG8gY2FsbGJhY2sgdG8gdGhlIExMREQgdG8gZW5hYmxl
DQo+ICB0aGUgU1BJTlVQLg0KPiAgDQo+ICBCVFcsIG91dCBvZiBpbnRlcmVzdCwgd2hhdCBpcyB0
aGlzIGNoYW5nZSBmb3I6DQo+ICANCj4gICA+ICAgdm9pZCBwbTgwMDFfc2Nhbl9zdGFydChzdHJ1
Y3QgU2NzaV9Ib3N0ICpzaG9zdCkNCj4gICA+ICAgew0KPiAgID4gICAgICBpbnQgaTsNCj4gICA+
ICsgICAgdW5zaWduZWQgbG9uZyBsb2NrX2ZsYWdzOw0KPiAgID4gICAgICBzdHJ1Y3QgcG04MDAx
X2hiYV9pbmZvICpwbTgwMDFfaGE7DQo+ICAgPiAgICAgIHN0cnVjdCBzYXNfaGFfc3RydWN0ICpz
aGEgPSBTSE9TVF9UT19TQVNfSEEoc2hvc3QpOw0KPiAgID4gKyAgICBERUNMQVJFX0NPTVBMRVRJ
T04oY29tcCk7DQo+ICANCj4gIG5vdGU6IHRoaXMgc2hvdWxkIGJlIHRoZSBfT05TVEFDSygpIHZh
cmlhbnQsIGFuZCBpcyBpdCBzYWZlIHRvIGV2ZW4gcmV1c2UgaW4gdGhlDQo+ICBsb29wLCBiZWxv
dz8NCj4gIFRoYW5rIHlvdSBKb2huIGZvciBwb2ludGluZyB0aGlzIG91dC4gV2Ugd2lsbCBjaGFu
Z2UgdGhpcyB0byDigJhERUNMQVJFX0NPTVBMRVRJT05fT05TVEFDS+KAmSBhbmQgc3VibWl0IHRo
ZSB1cGRhdGVkIHBhdGNoLiDigJwNCj4gIHBoeSBzdGFydOKAnSByZXF1ZXN0IGlzIHNlcXVlbnRp
YWwgYW5kIGRyaXZlciBzdWJtaXQgdGhlIG5ldyBwaHlfc3RhcnQgcmVxdWVzdCBhZnRlciBjb21w
bGV0aW5nIHRoZSBjdXJyZW50IHJlcXVlc3QuIFNvIEkgdGhpbmsgaXQgaXMgc2FmZSB0byB1c2Ug
dGhhdCBpbiBhIGxvb3AuDQo+ICBQbGVhc2Ugc2hhcmUgeW91IHRob3VnaHQuDQo+ICANCj4gICA+
ICAgICAgcG04MDAxX2hhID0gc2hhLT5sbGRkX2hhOw0KPiAgID4gICAgICAvKiBTQVNfUkVfSU5J
VElBTElaQVRJT04gbm90IGF2YWlsYWJsZSBpbiBTUEN2L3ZlICovDQo+ICAgPiAgICAgIGlmIChw
bTgwMDFfaGEtPmNoaXBfaWQgPT0gY2hpcF84MDAxKQ0KPiAgID4gICAgICAgICAgICAgIFBNODAw
MV9DSElQX0RJU1AtPnNhc19yZV9pbml0X3JlcShwbTgwMDFfaGEpOw0KPiAgID4gLSAgICBmb3Ig
KGkgPSAwOyBpIDwgcG04MDAxX2hhLT5jaGlwLT5uX3BoeTsgKytpKQ0KPiAgID4gLSAgICAgICAg
ICAgIFBNODAwMV9DSElQX0RJU1AtPnBoeV9zdGFydF9yZXEocG04MDAxX2hhLCBpKTsNCj4gICA+
ICsNCj4gICA+ICsgICAgaWYgKHBtODAwMV9oYS0+cGRldi0+ZGV2aWNlID09IDB4ODAwMSB8fA0K
PiAgID4gKyAgICAgICAgICAgIHBtODAwMV9oYS0+cGRldi0+ZGV2aWNlID09IDB4ODA4MSB8fA0K
PiAgID4gKyAgICAgICAgICAgIChwbTgwMDFfaGEtPnNwaW51cF9pbnRlcnZhbCAhPSAwKSkgew0K
PiAgID4gKyAgICAgICAgICAgIGZvciAoaSA9IDA7IGkgPCBwbTgwMDFfaGEtPmNoaXAtPm5fcGh5
OyArK2kpDQo+ICAgPiArICAgICAgICAgICAgICAgICAgICBQTTgwMDFfQ0hJUF9ESVNQLT5waHlf
c3RhcnRfcmVxKHBtODAwMV9oYSwgaSk7DQo+ICAgPiArICAgIH0gZWxzZSB7DQo+ICAgPiArICAg
ICAgICAgICAgZm9yIChpID0gMDsgaSA8IHBtODAwMV9oYS0+Y2hpcC0+bl9waHk7ICsraSkgew0K
PiAgID4gKyAgICAgICAgICAgICAgICAgICAgc3Bpbl9sb2NrX2lycXNhdmUoJnBtODAwMV9oYS0+
bG9jaywgbG9ja19mbGFncyk7DQo+ICAgPiArICAgICAgICAgICAgICAgICAgICBwbTgwMDFfaGEt
PnBoeV9zdGFydGVkID0gaTsNCj4gICA+ICsgICAgICAgICAgICAgICAgICAgIHBtODAwMV9oYS0+
c2Nhbl9jb21wbGV0aW9uID0gJmNvbXA7DQo+ICAgPiArICAgICAgICAgICAgICAgICAgICBwbTgw
MDFfaGEtPnBoeXN0YXJ0X3RpbWVkb3V0ID0gMTsNCj4gICA+ICsgICAgICAgICAgICAgICAgICAg
IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnBtODAwMV9oYS0+bG9jaywgbG9ja19mbGFncyk7DQo+
ICAgPiArICAgICAgICAgICAgICAgICAgICBQTTgwMDFfQ0hJUF9ESVNQLT5waHlfc3RhcnRfcmVx
KHBtODAwMV9oYSwgaSk7DQo+ICAgPiArICAgICAgICAgICAgICAgICAgICB3YWl0X2Zvcl9jb21w
bGV0aW9uX3RpbWVvdXQoJmNvbXAsDQo+ICAgPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
IG1zZWNzX3RvX2ppZmZpZXMoNTAwKSk7DQo+ICAgPiArICAgICAgICAgICAgICAgICAgICBpZiAo
cG04MDAxX2hhLT5waHlzdGFydF90aW1lZG91dCkNCj4gICA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgUE04MDAxX01TR19EQkcocG04MDAxX2hhLCBwbTgwMDFfcHJpbnRrKA0KPiAgID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAiVGltZW91dCBoYXBwZW5lZCBmb3IgcGh5aWQg
PSAlZFxuIiwgaSkpOw0KPiAgID4gKyAgICAgICAgICAgIH0NCj4gICA+ICsgICAgICAgICAgICBz
cGluX2xvY2tfaXJxc2F2ZSgmcG04MDAxX2hhLT5sb2NrLCBsb2NrX2ZsYWdzKTsNCj4gICA+ICsg
ICAgICAgICAgICBwbTgwMDFfaGEtPnBoeV9zdGFydGVkID0gLTE7DQo+ICAgPiArICAgICAgICAg
ICAgcG04MDAxX2hhLT5zY2FuX2NvbXBsZXRpb24gPSBOVUxMOw0KPiAgID4gKyAgICAgICAgICAg
IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnBtODAwMV9oYS0+bG9jaywgbG9ja19mbGFncyk7DQo+
ICAgPiArICAgIH0NCj4gICA+ICAgfQ0KPiAgID4NCj4gIA0KPiAgVGhhbmtzLA0KPiAgSm9obg0K
