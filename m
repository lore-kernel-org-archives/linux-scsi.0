Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB58C33CA8
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 09:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 459FA2082E
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 09:26:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="YsoqI4q2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgAMJ0p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 04:26:45 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:23654 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgAMJ0p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2020 04:26:45 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Deepak.Ukey@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="Deepak.Ukey@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Deepak.Ukey@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: HBnLNtNmden+70aVsZr0ZhoxSP9UH1UHfXFn7vp7H16TL6RXQiK7QGTO9Y23OlzcLEtji6LJjo
 zhGe8/dOWHduWv+EW56F71d4zQl3LiMSudP7wL7wX2l5VDEVtplKv4RKjFE+201LzOhLjZlYqY
 T4P1rSPb0ghB8i9/r4wt9DinlFO6XAfGPhX37q1g+H6xda4eiMrfs3LiiU6JSX1PoZSSfyCImu
 pKEu+DrNlr157VZOB35qzgXXIrPuMKDWgd59lIDvNFTSR0/vrpXjWaYWL1Sc57QmnJ6PNGnEfT
 LsU=
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="61690971"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2020 02:26:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 02:26:42 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 13 Jan 2020 02:26:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QINHPn6S3xYBa/LPZf0iGK/VFSQsza1YN76JqijpczW1MMfphfYDHS9/8bhUa1tQzlE0PbCPKgW/RRC0+M6lNkdLD1Z7U3mzaa+Zi/HMOGl34/z8trvID0ZEU86+JFrLNdx7Z5/ZY/K3ozDZSqoPswEIY0wgfCYUIgB6ydPJ6bIHFS7lrWNpeaCK9h5IOXFQi7mCLKXEqkz+5mbQVUbQIl6y9/x/ud4jRucXZ/r3uyCzWD3tHvYQiNhM1MZedorzdTmUz9VCZNGUQNV3kcJon+DI33s9dcU1qu41Z5L0qZQGtxbPt05c+U6cQXllgcJ1YNz6T5iXJ5MZ1tQQMgkBsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwGdi5rdTk5OTVJBQbObA4E608zB/0D+bA4LeMju+Fo=;
 b=jyhqiVsmTdQBGuxsjtsYUiDQbs867JANsWxa/+LuuYV4gIvusATIEKODjzmK42ek3HnhboTGgJtWjWXwc/GLSgOEidSwIyUZWhqX5OdpXy3OeIxYf5aSkEX2WoCe+GvM6wng4vEJw/s6pjC0/wtogne/EjJRwMFUsjKe/Bi27hxkVFKywEdovlCY/dSu6GwYIZ6pYDAWlHsuOrKV0tVuTkAnUZMAgRo0wX7Y0an50AEt8/QllyzhG08h/nA1uLHcSn8B/uchuBhuqXQBxlEfp2JtCR9hcMXaIs48sO7FhWxBARVCbj+hTOvw8o65YqA2UHR/XKgdGZG9WpsYKjWTAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwGdi5rdTk5OTVJBQbObA4E608zB/0D+bA4LeMju+Fo=;
 b=YsoqI4q2XtuH1w/XzS6u+in/lNFXYA6uTETrbvLcC4L0HxRCJ24oKnRQX6vqk9zMnRh+IjkZXVEsDA8ce1/Z/V7UMvy2FGAbwquHIctzAya7f2UlMjdwWKnWyXLZNtelhlboiKAjdR9U9lM5rD0hI02aFGXObA45Sj3PPRr50hQ=
Received: from MN2PR11MB3550.namprd11.prod.outlook.com (20.178.251.149) by
 MN2PR11MB4397.namprd11.prod.outlook.com (52.135.38.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Mon, 13 Jan 2020 09:26:41 +0000
Received: from MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961]) by MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961%5]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 09:26:41 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <Viswas.G@microchip.com>, <john.garry@huawei.com>,
        <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH 06/12] pm80xx : sysfs attribute for number of phys.
Thread-Topic: [PATCH 06/12] pm80xx : sysfs attribute for number of phys.
Thread-Index: AQHVuhReKpapp/0TjEm/3+3JVDpnv6fXVlyAgAAHEACAAESpAIAQzspA
Date:   Mon, 13 Jan 2020 09:26:41 +0000
Message-ID: <MN2PR11MB35500F70F6F82FE1C57D99E5EF350@MN2PR11MB3550.namprd11.prod.outlook.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
 <20191224044143.8178-7-deepak.ukey@microchip.com>
 <CAMGffEkzAt4FrP2DbhZhGE20nFWPpuGkN83t7Tvw6+LsQg=m3Q@mail.gmail.com>
 <32f47ddd-72c5-7846-f0a7-cba3ad1e0c6b@huawei.com>
 <BL0PR11MB29804B87E0768D41793E15A49D200@BL0PR11MB2980.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB29804B87E0768D41793E15A49D200@BL0PR11MB2980.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df2a0ee9-081a-44cc-cf65-08d7980ab2ef
x-ms-traffictypediagnostic: MN2PR11MB4397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB43970C2C93EB4EBB5D0CFF0CEF350@MN2PR11MB4397.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(346002)(396003)(376002)(199004)(189003)(7696005)(81166006)(33656002)(53546011)(6506007)(55016002)(71200400001)(2906002)(9686003)(86362001)(54906003)(7416002)(316002)(110136005)(8676002)(186003)(81156014)(26005)(66446008)(5660300002)(8936002)(52536014)(64756008)(66556008)(66946007)(76116006)(4326008)(478600001)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4397;H:MN2PR11MB3550.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yH+jyFTReU+aayi8WR0BMrVap/W3tSIOB3p/4wd3MqZdtd+Fuk2DSTbYm7eUrGovI3Pl3FUJZwLmzNiMm+g//pu9B7vURSQjtZD4gSoBFz4BYvhd+cRyDfy2FNUfTGH3pV/k7AiA/ZeykwKvhJ0S2HJXoGONr6wghLzRica9CkPsNtIbfpXNwLAZoFWUF+j2yjZAQOaHypowuRdbb3V8XchqqHjZWc/9w3LrSvGYBdc/+EHacRYKx3xt0Vx4Jj8P1tbnu1Ke31a03sHc8f9dlmmEYr9izdxZNfwDCzlUo9ZT9D1K3tAQPxJwwRbciBFrdlHurN1eUVpuhXwIQCxxlOp4ixFL0mpsRabb2QEVFIdPAb0O6flrdO+EYRmyykS6moELvZM8OIjijktXlnp0eFELZaDvb6UCLwDT/sZK2Fkig2LL34uGB8DS1lXxuo6e
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: df2a0ee9-081a-44cc-cf65-08d7980ab2ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 09:26:41.4430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q1eYHHMPRtEc9FxhdQCtvUJbVhrGMeCHFnaRnTMfq7Aq+qP1ENl/q1Ld51mQ6Hvj254R2ZLLEPZnft/Mgu7BNsGQS8yrVMjody69heoiprQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4397
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSmlucHUsDQoNCnBsZWFzZSB1c2UgcG04MDAxX2N0bF9udW1fcGh5c19zaG93IGFzIGZ1bmN0
aW9uIG5hbWUsIHNvIGl0IGZvbGxvd3MgDQo+IHNhbWUgY29udmVyc2lvbiBhcyBvdGhlciBmdW5j
dGlvbnMuDQo+IEJldHRlciBhbHNvIHJlbmFtZSBjb250cm9sbGVyX2ZhdGFsX2Vycm9yIHRvby4N
Cg0KSWYgSSB0cmllZCB0byBrZWVwIHRoZSBmdW5jdGlvbiBuYW1lIGFzIHBtODAwMV9jdGxfbnVt
X3BoeXNfc2hvdyBhcyBvdGhlciBmdW5jdGlvbiBmb2xsb3dzIHRoZW4gY2hlY2twYXRjaC5wbCBn
aXZlcyB0aGUgYmVsb3cgd2FybmluZy4gDQoNCi0tLS0tLQ0KV0FSTklORzogQ29uc2lkZXIgcmVu
YW1pbmcgZnVuY3Rpb24ocykgJ3BtODAwMV9jdGxfbnVtX3BoeXNfc2hvdycgdG8gJ251bV9waHlz
X3Nob3cnDQojMzc6IEZJTEU6IGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2N0bC5jOjEwODoN
Cit9DQoNCnRvdGFsOiAwIGVycm9ycywgMSB3YXJuaW5ncywgMzIgbGluZXMgY2hlY2tlZA0KLS0t
LS0tLQ0KDQpUaGF04oCZcyB0aGUgb25seSByZWFzb24gIEkgaGF2ZSBjaGFuZ2VzIHRoZSBmdW5j
dGlvbiBuYW1lLiBGb3IgbWFraW5nIHRoZSBvdGhlciBmdW5jdGlvbiB3aXRoIHNhbWUgbmFtaW5n
IGNvbnZlbnRpb24sIEkgd2lsbCBjaGFuZ2UgdGhlIGZ1bmN0aW9uIG5hbWUgb2YgYWxsIG90aGVy
IGZ1bmN0aW9uIGxpa2UgbnVtX3BoeXNfc2hvdycgYW5kIHdlIHdpbGwgc3VibWl0IHRoaXMgcGF0
Y2ggaW4gIG91ciB1cGNvbWluZyBwYXRjaCBzZXQuDQoNClJlZ2FyZHMsDQpEZWVwYWsNCiAgDQot
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogVmlzd2FzIEcgLSBJMzA2NjcgDQpTZW50
OiBUaHVyc2RheSwgSmFudWFyeSAyLCAyMDIwIDEwOjA5IFBNDQpUbzogSm9obiBHYXJyeSA8am9o
bi5nYXJyeUBodWF3ZWkuY29tPjsgSmlucHUgV2FuZyA8amlucHUud2FuZ0BjbG91ZC5pb25vcy5j
b20+OyBEZWVwYWsgVWtleSAtIEkzMTE3MiA8RGVlcGFrLlVrZXlAbWljcm9jaGlwLmNvbT4NCkNj
OiBMaW51eCBTQ1NJIE1haWxpbmdsaXN0IDxsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZz47IFZh
c2FudGhhbGFrc2htaSBUaGFybWFyYWphbiAtIEkzMDY2NCA8VmFzYW50aGFsYWtzaG1pLlRoYXJt
YXJhamFuQG1pY3JvY2hpcC5jb20+OyBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tz
LmNvbT47IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+OyBk
cGZAZ29vZ2xlLmNvbTsgeXV1emhlbmdAZ29vZ2xlLmNvbTsgVmlrcmFtIEF1cmFka2FyIDxhdXJh
ZGthckBnb29nbGUuY29tPjsgdmlzaGFraGF2Y0Bnb29nbGUuY29tOyBiamFzaG5hbmlAZ29vZ2xl
LmNvbTsgUmFkaGEgUmFtYWNoYW5kcmFuIDxyYWRoYUBnb29nbGUuY29tPjsgYWtzaGF0emVuQGdv
b2dsZS5jb20NClN1YmplY3Q6IFJFOiBbUEFUQ0ggMDYvMTJdIHBtODB4eCA6IHN5c2ZzIGF0dHJp
YnV0ZSBmb3IgbnVtYmVyIG9mIHBoeXMuDQoNClRoYW5rcyBKb2huIEdhcnJ5LiBUaGUgaW50ZW50
aW9uIGhlcmUgaXMgdG8gZ2V0IHRoZSB0b3RhbCBudW1iZXIgb2YgcGh5cyBmb3IgdGhlIGNvbnRy
b2xsZXIgdGhyb3VnaCBzeXNmcyBhbmQgaXQgaXMgdXNlZCBieSB0aGUgbWFuYWdlbWVudCB1dGls
aXR5IGFzIHdlbGwuIA0KDQpSZWdhcmRzLA0KVmlzd2FzIEcNCg0KLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCkZyb206IEpvaG4gR2FycnkgPGpvaG4uZ2FycnlAaHVhd2VpLmNvbT4NClNlbnQ6
IFRodXJzZGF5LCBKYW51YXJ5IDIsIDIwMjAgNjowMyBQTQ0KVG86IEppbnB1IFdhbmcgPGppbnB1
LndhbmdAY2xvdWQuaW9ub3MuY29tPjsgRGVlcGFrIFVrZXkgLSBJMzExNzIgPERlZXBhay5Va2V5
QG1pY3JvY2hpcC5jb20+DQpDYzogTGludXggU0NTSSBNYWlsaW5nbGlzdCA8bGludXgtc2NzaUB2
Z2VyLmtlcm5lbC5vcmc+OyBWYXNhbnRoYWxha3NobWkgVGhhcm1hcmFqYW4gLSBJMzA2NjQgPFZh
c2FudGhhbGFrc2htaS5UaGFybWFyYWphbkBtaWNyb2NoaXAuY29tPjsgVmlzd2FzIEcgLSBJMzA2
NjcgPFZpc3dhcy5HQG1pY3JvY2hpcC5jb20+OyBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0
YnJpY2tzLmNvbT47IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5j
b20+OyBkcGZAZ29vZ2xlLmNvbTsgeXV1emhlbmdAZ29vZ2xlLmNvbTsgVmlrcmFtIEF1cmFka2Fy
IDxhdXJhZGthckBnb29nbGUuY29tPjsgdmlzaGFraGF2Y0Bnb29nbGUuY29tOyBiamFzaG5hbmlA
Z29vZ2xlLmNvbTsgUmFkaGEgUmFtYWNoYW5kcmFuIDxyYWRoYUBnb29nbGUuY29tPjsgYWtzaGF0
emVuQGdvb2dsZS5jb20NClN1YmplY3Q6IFJlOiBbUEFUQ0ggMDYvMTJdIHBtODB4eCA6IHN5c2Zz
IGF0dHJpYnV0ZSBmb3IgbnVtYmVyIG9mIHBoeXMuDQoNCkVYVEVSTkFMIEVNQUlMOiBEbyBub3Qg
Y2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRl
bnQgaXMgc2FmZQ0KDQpPbiAwMi8wMS8yMDIwIDEyOjA3LCBKaW5wdSBXYW5nIHdyb3RlOg0KPiBP
biBUdWUsIERlYyAyNCwgMjAxOSBhdCA1OjQxIEFNIERlZXBhayBVa2V5IDxtYWlsdG86ZGVlcGFr
LnVrZXlAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+Pg0KPj4gRnJvbTogVmlzd2FzIEcgPG1haWx0
bzpWaXN3YXMuR0BtaWNyb2NoaXAuY29tPg0KPj4NCj4+IEFkZGVkIHN5c2ZzIGF0dHJpYnV0ZSB0
byBzaG93IG51bWJlciBvZiBwaHlzLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IERlZXBhayBVa2V5
IDxtYWlsdG86ZGVlcGFrLnVrZXlAbWljcm9jaGlwLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFZp
c3dhcyBHIDxtYWlsdG86Vmlzd2FzLkdAbWljcm9jaGlwLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6
IFZpc2hha2hhIENoYW5uYXBhdHRhbiA8bWFpbHRvOnZpc2hha2hhdmNAZ29vZ2xlLmNvbT4NCj4+
IFNpZ25lZC1vZmYtYnk6IEJoYXZlc2ggSmFzaG5hbmkgPG1haWx0bzpiamFzaG5hbmlAZ29vZ2xl
LmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFJhZGhhIFJhbWFjaGFuZHJhbiA8bWFpbHRvOnJhZGhh
QGdvb2dsZS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBa3NoYXQgSmFpbiA8bWFpbHRvOmFrc2hh
dHplbkBnb29nbGUuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogWXUgWmhlbmcgPG1haWx0bzp5dXV6
aGVuZ0Bnb29nbGUuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAx
X2N0bC5jIHwgMjAgKysrKysrKysrKysrKysrKysrKysNCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDIw
IGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAwMS9w
bTgwMDFfY3RsLmMNCj4+IGIvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfY3RsLmMNCj4+IGlu
ZGV4IDY5NDU4YjMxOGEyMC4uNzA0YzBkYWE3OTM3IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9z
Y3NpL3BtODAwMS9wbTgwMDFfY3RsLmMNCj4+ICsrKyBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04
MDAxX2N0bC5jDQo+PiBAQCAtODksNiArODksMjUgQEAgc3RhdGljIHNzaXplX3QgY29udHJvbGxl
cl9mYXRhbF9lcnJvcl9zaG93KHN0cnVjdCBkZXZpY2UgKmNkZXYsDQo+PiAgIH0NCj4+ICAgc3Rh
dGljIERFVklDRV9BVFRSX1JPKGNvbnRyb2xsZXJfZmF0YWxfZXJyb3IpOw0KPj4NCj4+ICsvKioN
Cj4+ICsgKiBwbTgwMDFfY3RsX251bV9waHlzX3Nob3cgLSBOdW1iZXIgb2YgcGh5cw0KPj4gKyAq
IEBjZGV2OnBvaW50ZXIgdG8gZW1iZWRkZWQgY2xhc3MgZGV2aWNlDQo+PiArICogQGJ1Zjp0aGUg
YnVmZmVyIHJldHVybmVkDQo+PiArICogQSBzeXNmcyAncmVhZC1vbmx5JyBzaG9zdCBhdHRyaWJ1
dGUuDQo+PiArICovDQo+PiArc3RhdGljIHNzaXplX3QgbnVtX3BoeXNfc2hvdyhzdHJ1Y3QgZGV2
aWNlICpjZGV2LA0KPj4gKyAgICAgICAgICAgICAgIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICph
dHRyLCBjaGFyICpidWYpDQo+IHBsZWFzZSB1c2UgcG04MDAxX2N0bF9udW1fcGh5c19zaG93IGFz
IGZ1bmN0aW9uIG5hbWUsIHNvIGl0IGZvbGxvd3MgDQo+IHNhbWUgY29udmVyc2lvbiBhcyBvdGhl
ciBmdW5jdGlvbnMuDQo+IEJldHRlciBhbHNvIHJlbmFtZSBjb250cm9sbGVyX2ZhdGFsX2Vycm9y
IHRvby4NCg0KSWYgeW91IGRvbid0IG1pbmQgbWUgc2F5aW5nLCB0aGlzIGluZm8gaXMgYWxyZWFk
eSBhdmFpbGFibGUgaW4gc3lzZnMgZm9yIGFueSBsaWJzYXMgb3IgZXZlbiBTQVMgaG9zdCAodXNp
bmcgc2NzaV90cmFuc3BvcnRfc2FzLmMpLCBsaWtlIHRoaXM6DQoNCmpvaG5AdWJ1bnR1Oi9zeXMv
Y2xhc3Mvc2FzX3BoeSQgbHMNCnBoeS0wOjAgICAgIHBoeS0wOjA6MTIgIHBoeS0wOjA6MTcgIHBo
eS0wOjA6MjEgIHBoeS0wOjA6NCAgcGh5LTA6MDo5DQpwaHktMDo1DQpwaHktMDowOjAgICBwaHkt
MDowOjEzICBwaHktMDowOjE4ICBwaHktMDowOjIyICBwaHktMDowOjUgIHBoeS0wOjENCnBoeS0w
OjYNCnBoeS0wOjA6MSAgIHBoeS0wOjA6MTQgIHBoeS0wOjA6MTkgIHBoeS0wOjA6MjMgIHBoeS0w
OjA6NiAgcGh5LTA6Mg0KcGh5LTA6Nw0KcGh5LTA6MDoxMCAgcGh5LTA6MDoxNSAgcGh5LTA6MDoy
ICAgcGh5LTA6MDoyNCAgcGh5LTA6MDo3ICBwaHktMDozDQpwaHktMDowOjExICBwaHktMDowOjE2
ICBwaHktMDowOjIwICBwaHktMDowOjMgICBwaHktMDowOjggIHBoeS0wOjQNCg0KDQpBbnkgcGh5
LVg6WSBpcyBhIHJvb3QgcGh5LCBhbmQgWCBkZW5vdGVzIHRoZSBob3N0IGluZGV4IGFuZCBZIGlz
IHRoZSBwaHkgaW5kZXguDQoNCj4NCj4gVGhhbmtzDQo+PiArew0KPj4gKyAgICAgICBpbnQgcmV0
Ow0KPj4gKyAgICAgICBzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCA9IGNsYXNzX3RvX3Nob3N0KGNk
ZXYpOw0KPj4gKyAgICAgICBzdHJ1Y3Qgc2FzX2hhX3N0cnVjdCAqc2hhID0gU0hPU1RfVE9fU0FT
X0hBKHNob3N0KTsNCj4+ICsgICAgICAgc3RydWN0IHBtODAwMV9oYmFfaW5mbyAqcG04MDAxX2hh
ID0gc2hhLT5sbGRkX2hhOw0KPj4gKw0KPj4gKyAgICAgICByZXQgPSBzcHJpbnRmKGJ1ZiwgIiVk
IiwgcG04MDAxX2hhLT5jaGlwLT5uX3BoeSk7DQo+PiArICAgICAgIHJldHVybiByZXQ7DQo+PiAr
fQ0KPj4gK3N0YXRpYyBERVZJQ0VfQVRUUl9STyhudW1fcGh5cyk7DQo+PiArDQo+PiAgIC8qKg0K
Pj4gICAgKiBwbTgwMDFfY3RsX2Z3X3ZlcnNpb25fc2hvdyAtIGZpcm13YXJlIHZlcnNpb24NCj4+
ICAgICogQGNkZXY6IHBvaW50ZXIgdG8gZW1iZWRkZWQgY2xhc3MgZGV2aWNlIEBAIC04MjUsNiAr
ODQ0LDcgQEAgDQo+PiBzdGF0aWMgREVWSUNFX0FUVFIodXBkYXRlX2Z3LCBTX0lSVUdPfFNfSVdV
U1J8U19JV0dSUCwNCj4+ICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKnBtODAwMV9ob3N0X2F0
dHJzW10gPSB7DQo+PiAgICAgICAgICAmZGV2X2F0dHJfaW50ZXJmYWNlX3JldiwNCj4+ICAgICAg
ICAgICZkZXZfYXR0cl9jb250cm9sbGVyX2ZhdGFsX2Vycm9yLA0KPj4gKyAgICAgICAmZGV2X2F0
dHJfbnVtX3BoeXMsDQo+PiAgICAgICAgICAmZGV2X2F0dHJfZndfdmVyc2lvbiwNCj4+ICAgICAg
ICAgICZkZXZfYXR0cl91cGRhdGVfZncsDQo+PiAgICAgICAgICAmZGV2X2F0dHJfYWFwX2xvZywN
Cj4+IC0tDQo+PiAyLjE2LjMNCj4+DQo+IC4NCj4NCg0K
