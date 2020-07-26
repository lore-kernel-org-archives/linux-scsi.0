Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4B4C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 06:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EA7F206E3
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 06:39:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZDYGT1+F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dTbsJk6Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgGZGjj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 02:39:39 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:15322 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgGZGjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2020 02:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595745578; x=1627281578;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=C/4yOHv2/76/zJSnhsW44Ssls26BvyA2Usnf+xR60E0=;
  b=ZDYGT1+FMT17mPq62d+MfmosjJf/9dNFAHm7kW3urJo1BVWorUxrXO6y
   AZeAu9nhGDsnMfUyJ4WwM//+JManoloZYt/VBZbQSHcET/mEp2l3bScMG
   0O4xWOgi7KMvJcJaA0HRXVzFTK0bBy0HE3ub25E3yymh9yyBuHqrQeymC
   aX2XJpWVAMvMvoaDIP1sxUrSQpANtYXLx0RE52neEbumqb0nPZ7VWIU+6
   xHzWDrLN3mWupq3FfbooZ0Tve3+JvQbhb+W0cFvyRiG3AHfd6o+dqGaeu
   lBYts3Uh31BXRlR8wvPIevfo6qs45olqPWXuZwQ7n5bnET51+WujX53LE
   A==;
IronPort-SDR: cncpd9qbrHCf3Z8AqwBQAhq4IOckswzzortQD02Fp1Dz4OxImZ6ovzBisbl7yhtg2OiKDH7spW
 qYwNbemQ46uqFW1GJw4wcgK7VJUsWIJ/j9BqpJgNVdWooRIO8ECxWBcgyJk2YVKHit4EAMxN4U
 H+IsV9i3e6I9aZCmorrEyc17Q/ssws4V4egzPm2wYMCv3cFwGCBepLOGztdvYwrx8dLKDgGk07
 LnqjcYe2jlFXBj8byD9hiACdKPf4eYTVm4bKc/5OOOSmWNOkipM/AWM9unFFdrirH5hY9ulRDW
 UvQ=
X-IronPort-AV: E=Sophos;i="5.75,397,1589212800"; 
   d="scan'208";a="143387864"
Received: from mail-sn1nam02lp2058.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.58])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jul 2020 14:39:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYnOAhTotZ+eZpOpW24dOu9K7/7FEQVu9Ll1Rd/QxmoUVleB5ZnsXWmiEXKODJ5a6iI+HUSOr/l0s1G9aZC+i5T1mz7XYVg7xD5px7Ue+fbN71Nqo0pSZc+1YTA7mRJg6clARUELFKzrtB1Z59hrf1C6xQi9WCweM36qQNK6ZTF4kEZjqLCOFvWWDjKyPA5U0LtAbAm+T6b0ZerAtyXH3QZEnV0FOG1tgJz+TDDX5asghifOYTBEngpncm6w7vrct2QRCbS4SUK9Gj1beWaemG4Ttvp/xOGu9gqNnraBIKHZRAWCfguOjBbxWzlzIRGuuhldfztWM7pPJYQ0j9opig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/4yOHv2/76/zJSnhsW44Ssls26BvyA2Usnf+xR60E0=;
 b=H5T3SGCD0+DENwQ9e0ca1QdD5yj/jd76NcSyO+5VWo0QVMGfADlv//Iv++T1Siy/mjDTXQ1ID0RgYUQTYZgmwH0hq7vzzj97gMZ8zSuQx/G97VwDduzjx6M/LBqi27SQNt2dG/G+p5/+zTOtoGKgCS0CGUbJlsl3i9QNzB3XNc9mHSAWFzwdu+c5vGQa5/YAujS/vObBGxVNKcoihK50JN4L0IOFcmk70eEraot6r4jwghejnkrtN9C+ik1UtPa16j9PysjO4sFcSHmAn5MATbEgkIX1C/A3UnQaZ5M52PrEgxUOAVEMhV8oiD1YCA/JPLwPKgIbqtuOoSYXYtInhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/4yOHv2/76/zJSnhsW44Ssls26BvyA2Usnf+xR60E0=;
 b=dTbsJk6YQ8mZU6jHza1MkszZW87Kwmmugeyav1v5GluRWagZPnNALZQQcHQJxms0hcBwSu3ONqgqQA7JffCldBT5BUG+GO6+YUwvY/1VBpMpogl+3gLzYEd9OSX3BONwwwcPFl/D2EkEyAGAKtTE5ol6gH2ssJyjEPsvldd16DE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5038.namprd04.prod.outlook.com (2603:10b6:805:9e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Sun, 26 Jul
 2020 06:39:35 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.030; Sun, 26 Jul 2020
 06:39:35 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     SEO HOYOUNG <hy50.seo@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>
Subject: RE: [RFC PATCH v3 3/3] scsi: ufs: add vendor specific write booster
Thread-Topic: [RFC PATCH v3 3/3] scsi: ufs: add vendor specific write booster
Thread-Index: AQHWX0VM6JkEFzlP8Um0JzIY2ycXUqkZblNw
Date:   Sun, 26 Jul 2020 06:39:35 +0000
Message-ID: <SN6PR04MB4640CC1AFA0B88F4BEBEFAC2FC750@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095655epcas2p13c10101ef53de47384762754271c1ca5@epcas2p1.samsung.com>
 <f509c9bc4847f3f0527fb0c8a5b0aa68c223418e.1595325064.git.hy50.seo@samsung.com>
In-Reply-To: <f509c9bc4847f3f0527fb0c8a5b0aa68c223418e.1595325064.git.hy50.seo@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fcf2adfc-d409-4368-58d7-08d8312ea95e
x-ms-traffictypediagnostic: SN6PR04MB5038:
x-microsoft-antispam-prvs: <SN6PR04MB5038DA174E25C260041720ECFC750@SN6PR04MB5038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mr6PEY3ZCNcag7h/aM3GLu2Z0nm58H8UyeDXfQAR9x3s0KQThcVoGloZmdOGvzv6fSaxK/gUXhCsMQYgXNcomHI1Fwh/GTrcsma6fF3SgRj0dJirS1oDNzJk7o4WKMQA7m/hXFVYAU91XugAJMaCeZaHxqv2HCp+te9oqufZFXa8xj3zqkILbZVA9wdODsX+50WFhKoF5NDIBAa+5WV3vlvdrm+i82YIAGwJxK7jcwwuXmCv9y5WSMw3RqNBb4HM2+0AxS/n5GM1bdVyb2f6KMzHlOQR492GiWzFtXpTUlB4DEHXCX3g+5vHpuSB7mG+Rd7fNfJBj8l8VO27lWxoIT9EDWxXWubrYmZjwQ2hC9uG8o0KTf5/tvOabsZRI6zr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39850400004)(52536014)(76116006)(478600001)(66946007)(110136005)(86362001)(316002)(5660300002)(8676002)(26005)(7416002)(186003)(9686003)(2906002)(55016002)(33656002)(66476007)(64756008)(66556008)(6506007)(66446008)(71200400001)(8936002)(7696005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Zchk8Q5SolLoInC6cJZV4k5dBIHlJbhJIcEnhhBJKEphLjO/LbokMAfgZhp8Ot3W+iwuuASzJ2RpTLZTLu1wApxBXvLxElJbyxZ+F9PlIs+pifOg+LO173E8VrtlUl1ThJAyDN0MEmucevcaLoeFv9OrtnDcoj1V7RCG8BaNKSgCYcNo7aImR7gJaEB1hIoucU1o2YoqecgidHa1UF5tee/ICD2JkcbWVfJkX4v/06faSw+6KudzyxEQseLfIkc03k+vbAwlu28Og4xnMz2H7s2u8rfbSIEcCUWjRHH6N/okV0a+wYa6BqeSaLu7leB6shiUcpNibVYkOCfKJwxBQhnGXiKU9VgDOXLBge6CmazF8449alaTTEucK/UL+UVh4A+ct8UDpACSuKlM/SVKP0QA2sTKajWKq5bkpxjf1+h/Tnwyx05VxXhoe+gVKBN5BXXo1w5KD8QKn53ba96LyatqulX8Kkn3bywWHlfzbCw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf2adfc-d409-4368-58d7-08d8312ea95e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2020 06:39:35.1814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1xjZK5OaBoQ7YgqWZL4SlIvsOI+5HYatLT0Dc/DrItUFQdN1hrbWBR7EhfQBc7XQfsZcPdyXpZAt7d2/QHbksQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5038
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IFRvIHN1cHBvcnQgdGhlIGZ1Y3Rpb24gb2Ygd3JpdGVib29zdGVyIGJ5IHZlbmRv
ci4NCj4gVGhlIFdCIGJlaGF2aW9yIHRoYXQgdGhlIHZlbmRvciB3YW50cyBpcyBzbGlnaHRseSBk
aWZmZXJlbnQuDQo+IEJ1dCB3ZSBoYXZlIHRvIHN1cHBvcnQgaXQNCkkgZ3Vlc3MgdGhhdCBtYWlu
bHkgeW91IGFyZSBsb29raW5nIGZvciBvdGhlciBvcHRpb25zIHRoYW4gZGV2ZnJlcS4NClBsZWFz
ZSBhZGQgZmV3IGxpbmVzIGhvdyBhcmUgeW91IGdvaW5nIHRvIHJlcGxhY2UgaXQuDQoNCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IFNFTyBIT1lPVU5HIDxoeTUwLnNlb0BzYW1zdW5nLmNvbT4NCj4gLS0t
DQo+ICBkcml2ZXJzL3Njc2kvdWZzL01ha2VmaWxlICAgICB8ICAgMSArDQo+ICBkcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1leHlub3MuYyB8ICAgNiArDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc19jdG13
Yi5jICB8IDI3MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBkcml2ZXJz
L3Njc2kvdWZzL3Vmc19jdG13Yi5oICB8ICAyNiArKysrDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDMw
MyBpbnNlcnRpb25zKCspDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9zY3NpL3Vmcy91
ZnNfY3Rtd2IuYw0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvc2NzaS91ZnMvdWZzX2N0
bXdiLmgNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL01ha2VmaWxlIGIvZHJp
dmVycy9zY3NpL3Vmcy9NYWtlZmlsZQ0KPiBpbmRleCA5ODEwOTYzYmMwNDkuLmIxYmEzNmM3ZDY2
ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy9NYWtlZmlsZQ0KPiArKysgYi9kcml2
ZXJzL3Njc2kvdWZzL01ha2VmaWxlDQo+IEBAIC01LDYgKzUsNyBAQCBvYmotJChDT05GSUdfU0NT
SV9VRlNfRFdDX1RDX1BMQVRGT1JNKSArPSB0Yy1kd2MtDQo+IGcyMTAtcGx0ZnJtLm8gdWZzaGNk
LWR3Yy5vIHRjLWQNCj4gIG9iai0kKENPTkZJR19TQ1NJX1VGU19DRE5TX1BMQVRGT1JNKSArPSBj
ZG5zLXBsdGZybS5vDQo+ICBvYmotJChDT05GSUdfU0NTSV9VRlNfUUNPTSkgKz0gdWZzLXFjb20u
bw0KPiAgb2JqLSQoQ09ORklHX1NDU0lfVUZTX0VYWU5PUykgKz0gdWZzLWV4eW5vcy5vDQo+ICtv
YmotJChDT05GSUdfU0NTSV9VRlNfVkVORE9SX1dCKSArPSB1ZnNfY3Rtd2Iubw0KWW91IG5lZWQg
dG8gZGVmaW5lIGl0IGZpcnN0IGluIEtjb25maWcNCg0K
