Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A30C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 16:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C0964E85
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 16:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhBJQba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 11:31:30 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:9453 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhBJQbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 11:31:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612974660; x=1644510660;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fLy9KMMf34wg5cWVA/7+fQOn8y/qBAuSOiPhdiUazGg=;
  b=VcbMMJtn0qmUNEqgoCXDtm5Z8/qFsHYDMH7puCK4Cr41CRwDst+VO/u1
   N200+s2MzN6J8vbyEY1Hr99dWvRfPpPfkxyoNa5HRKc1fPP4WukIvxmGx
   vWnzltXjbSigAvGI42hHxkdTaWh4E4fZZRLPeI7GmoDoMlAb4boVP4eur
   ZzCnBFXeZjjkt4NoKyf6/rDFbIT8GY7hEnwNoVDJJ57DTBAHpu/k79D6z
   frOm0wxxrU+m3OdjB1vjWwh1YkgTUXKqL86Y26Zs3ua2pKzCv/FmcN0PI
   4kBTZOQrG6kYL1NXrjCp9j4fbGdUpM4lUo3NTnYnF8WED1MmIzXtEeD1a
   A==;
IronPort-SDR: 82/EHru5sx2lsB1P+uneUMetTFmgYbwQfRHp5WNdHhhIJx24pw3mGQ+kFhrRVmNLDezMmWy5Dj
 OQ0ooIOnkdcw6szBw5vqowTKOO02PSW6IKnSBCrEFraBnSExgFrVG6l6gAZiHaQMinJHDxIeZR
 gpIb3609XP1Dg0wS5/TSP9gFC8QKhCeLPU9rxt5uhkP7C42B0Cc6If3uTXVgOR4zAoSfjYKS69
 u/+qe7bbZ4ujWEwb55QI1MvW8j5uv5AM62ay0Nnn+0Q3ayKZ8594TUrfDqUZi0EEYfcw7j2ona
 VaQ=
X-IronPort-AV: E=Sophos;i="5.81,168,1610434800"; 
   d="scan'208";a="114573506"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2021 09:29:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 09:29:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 10 Feb 2021 09:29:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3nXv9kvHLUYSfoRn9yobaP0tnliPw9rnp++y5UZCGBR71NP2x4JRa/U+uukEDe5c5l/jRM/KIRIUoc7ldzu3SkvU1AIfu/sjs81o6d8uFAeUM7fkV2zNRq7pd5lu4LLj4Ad/9+hH1IZkIpCK/grSuOT0yTU+DuLEcepNwC5kSuuyfSSKhkee8NA4fKGpWoxtITb6WjhHOvNXe8VbUM7wwEKgW2gMwhA/ToQwcbhxjzEh3osci6HXvx1C0vJ/IpmBR+H3nfI5o1MkpSGbcabqwY01iARAB/tptLVYUZgl6+YssglD2ehE7rs9LNFyv+BABTVolwEW8nM6npfTBUFiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLy9KMMf34wg5cWVA/7+fQOn8y/qBAuSOiPhdiUazGg=;
 b=RB++oGr+13KEcGP+5pX7DCCtZYZNdJZZFHFWz3SRFEN5QzcOOq0DJIHzXZS0aYG/0/1oArOYsF6ZHkvdLsaleYcvJ+h4jhll+rRpJ8rCvWUSyu2vSyDUNP7ZBcUPcT3yHtWjjvqCltJrncVGuwU/hP6Irh8r887gYdleDCbEzvYP/42VMHMi+mvLUyFqBaZ7ctXYBOhxKHqARExqqXpJZPr96GIw0NLlZ1oLQocYSEEIMoRkpqiu2mRoJcu024MTGX4akLfqbM/mOPWYNGfMuF9SlkfPdQ7NF/L5WEzEzUhajtSLKADDG/PWSM1C6/z70Fff7bdxEVIrgY2s8Zh0eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLy9KMMf34wg5cWVA/7+fQOn8y/qBAuSOiPhdiUazGg=;
 b=Oy/nbB30roqo2FsSY8n4j7pNeXrUGiTaKyOSsbAsndovXOOwun7cUpjVJd10CGn6Bf59T6K6AOh8RQZCbOUB7VzrCM55rN9sniKM167OyTFxaZmUavhAhyeZXEA0vtnevotAbwQwhtVz70NzXrF6+aFeuffwqMbPfR+y7qL7gJQ=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA0PR11MB4528.namprd11.prod.outlook.com (2603:10b6:806:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 10 Feb
 2021 16:29:41 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 16:29:41 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <it+linux-scsi@molgen.mpg.de>,
        <buczek@molgen.mpg.de>, <gregkh@linuxfoundation.org>,
        <ming.lei@redhat.com>
Subject: RE: [PATCH V3 15/25] smartpqi: fix host qdepth limit
Thread-Topic: [PATCH V3 15/25] smartpqi: fix host qdepth limit
Thread-Index: AQHWzzRlWOT1Tjrni0WYgyG85NUWaqn25dQAgAGyXjCAJGc6AIAMaNYwgAWWawCAIuPh4IAABdYAgAAM1OA=
Date:   Wed, 10 Feb 2021 16:29:40 +0000
Message-ID: <SN6PR11MB2848D1442DE98A85A7B8B89EE18D9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <160763254769.26927.9249430312259308888.stgit@brunhilda>
 <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
 <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
 <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
 <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
 <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
 <SN6PR11MB2848ECDD666F0BF867AE04DFE18D9@SN6PR11MB2848.namprd11.prod.outlook.com>
 <6fea70bb-1718-ad02-789b-8e908f57951e@huawei.com>
In-Reply-To: <6fea70bb-1718-ad02-789b-8e908f57951e@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 734ecbfa-10f8-41ef-98e5-08d8cde11116
x-ms-traffictypediagnostic: SA0PR11MB4528:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB452815E6642093816116A681E18D9@SA0PR11MB4528.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gxr04BKSCvWWqRf/0Zmc5syaRAJIqW+jutgu/0hjpqUOQ8zlD9ZYOIp43CryOTvsA3JfQnChabeMmcI2og9gD3nknFSmF75MrPwzy1qd5jiyaauyJsMXQnX3cv3mp9PVjIU6w8lTzzKYhB2PTO+s8AqVW2KmBK27DC2DKAOsfXnUDyzYaLHHYU3BJfcOKy/AR8Kp7+dh1/vfNdr5AVPNk8BlxxMH3Vrg2hR+Bl40WNL0um3kzK5mqEVZqQblYjdY7QygBiYHOkmk662AoC64ZyWc8/NxKKz5Ho5xQr52tihiPYqo/lm9IiUlC/csvOXn7bdbs/1unZk/BGt47e2kVDjXMA9J1T1VhAajSRE9HLJcBSL05INwobEK2wnAzCwjk+KJOg1ilrrL37+CxBGqNmvw4fDtjf1CNvahBOLqGBtmBVokC6zubtOzH7FdiJOfv1CP35+89rF8VX0fjgEfj+wKDqrY9G7xcB63E0rjnK0gUz9ZNLiyxk+nWIn40dQAW5oe9FnnmJR8OukjngbAdwDdSaD/9/qLmaep6JC9zQ4B4autREToDPaQDjHKBmQu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(376002)(136003)(66446008)(76116006)(478600001)(4326008)(66556008)(7696005)(66476007)(86362001)(64756008)(83380400001)(921005)(186003)(66946007)(110136005)(8676002)(7416002)(8936002)(55016002)(316002)(54906003)(5660300002)(6506007)(4744005)(2906002)(26005)(71200400001)(9686003)(33656002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: b1/X/Fm7NhfvoTfEDaJHVVhbya4GUPPMvJ4zYrOC8lfZ6B75+7ucGBXeWtIQ+Ywre2eqlgHNxyiXVuGOL2asS7Vi8sB8aPswGZH9iZNClnv66H3PsxvtYwxY4DFws1RnQsiQiNDWHZHCukWdcXaudd3vBB9PjOu5yKOD2IemM6rS4WcER2z2exhxWU0lodL0tGwrzzIM5QBxgImx9IDpGHDU1JM816ao+tdKhpcf9qMHEkCaPD/9CM+VeUot0XlkSzDPExTb6SdZmm3bLHBV4ArZb2v4kIOnt8aQqCGs82CiQMfsE04VTUpzn3LyeFzYxprABjEWEKrmlVsPGyxzSL/qvb9okJ/2vhjs7vPEk7nPFh+AheU4tBHUWns6zXXqopuTUei8h/YA5b4BC+zcNPDVlKWkKmHQ8oxLZDNokPt8wtJrWJjm5UezbROzXQtyMBvOPe7R+vdErI0zKlz6I2EEtcTjU79NaxJE1jUmOZfTwFNJpjUDeJRqjHYRdsA1hzL3k0dEatd+Yy2iG95tC9MPeJ7evsB0UKGsK7bWD6Koe2REOBPzYthqEJMNtShk+DJW54HjaUsr1wUGHYOcf4C67RdebKDdAZ2gClrgQLUxC45F8jWdJczhZpxUeQ1a9HwM6SR/UKuT/1q9VOtpiHq7nHEztaGlI8IHtfxMJPBZ05p99oxxk53yIbsPN7g2vBOHuFO//QSRbm2s74XG+lZgGaiSXDKFaTrhEtKXX2I=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 734ecbfa-10f8-41ef-98e5-08d8cde11116
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 16:29:40.9625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wBkhfRfD/9bIaAG4l17e7BjK5GqPL3l8Jr9MSfa7SXDP7l48SQIHF3pYR7N3SujlG8LSfwzcMnAOOTpU7mxHbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4528
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaG4gR2FycnkgW21haWx0bzpqb2hu
LmdhcnJ5QGh1YXdlaS5jb21dIA0KU3ViamVjdDogUmU6IFtQQVRDSCBWMyAxNS8yNV0gc21hcnRw
cWk6IGZpeCBob3N0IHFkZXB0aCBsaW1pdA0KDQo+DQo+DQo+IEkgdGhpbmsgdGhhdCB0aGlzIGNh
biBhbHRlcm5hdGl2ZWx5IGJlIHNvbHZlZCBieSBzZXR0aW5nIC5ob3N0X3RhZ3NldCBmbGFnLg0K
Pg0KPiBUaGFua3MsDQo+IEpvaG4NCj4NCj4gRG9uOiBKb2huLCBjYW4gSSBhZGQgYSBTdWdnZXN0
ZWQtYnkgdGFnIGZvciB5b3UgZm9yIG15IG5ldyBwYXRjaCBzbWFydHBxaS11c2UtaG9zdC13aWRl
LXRhZ3NwYWNlPw0KDQpJIGRvbid0IG1pbmQuIEFuZCBJIHRoaW5rIHRoYXQgTWluZyBoYWQgdGhl
IHNhbWUgaWRlYS4NCg0KVGhhbmtzLA0KSm9obg0KDQpEb246IFRoYW5rcyBmb3IgcmVtaW5kaW5n
IG1lLiBNaW5nLCBjYW4gSSBhZGQgeW91ciBTdWdnZXN0ZWQtYnkgdGFnPw0KDQo=
