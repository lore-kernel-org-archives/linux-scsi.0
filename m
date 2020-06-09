Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96AFEC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 06:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EB142074B
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 06:51:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NzslsOsP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BzSadtug"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgFIGvq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 02:51:46 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45806 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgFIGvp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 02:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591685504; x=1623221504;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RIcF2HDct05GhVaVWlxKII78iEQHJCHivcKRmcj8BEQ=;
  b=NzslsOsPx7/q+MoiZfTx+1hsiQMk8N9s03V8ifQS7Ll5la4iX0yNTqrd
   PahLmKE3bFWKMI0tyTPdBU5HDfAFdJWrHNTSEWY1Iyom6gba0vbQzdKM1
   WHG3rTQUTOMtS6C6GDwR9RUjpWINEua9u4+ARJR/Bl3ZKaDIHFaY4gzrO
   lyBLQ8UXo8Dg/gQizwo/RzRqoAqEyZJdp+XMqaceKxEquE63jQa0pUE8A
   pJjXGbYXcytQsbEjJdoEVvoDJKlWtDopu26nhAMYA/7D67RLMmhUMl0Pw
   ciXTQo24P3nAcfhlE1VoSELndaX2UdJFQ+DaGhAkPKnxfBtH9YsnwpvMi
   Q==;
IronPort-SDR: h5btNXkPxXDxk2KEsLr8NaxwWsJppfRYZuMdu0GOu+Zp4PCPGhdqtHvfOzSd9qaZ12v4TLv6yP
 X+sZdp7s5ef5FfiTZl4CUo4hdqV70vIp/uJcwO3NZl6KaPcSMYsf+jlfR8T1kU1DQEQyjCWLgi
 WrFe/1n7iyRfA8gbT59tBnwS4hV6lgyqZY3MrS63GbWUQvJVZTReDlimmnOqQOxI+IWW50aUu+
 nFHAXPksKaT+qYRfS7u0vg+4SiPx7hHV7Zl9CG9h2KNT68PDWl27mg2kSIzqFRgqD/z+AB9GRY
 NSI=
X-IronPort-AV: E=Sophos;i="5.73,490,1583164800"; 
   d="scan'208";a="248647346"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2020 14:51:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQOHorp62hrR3GIzC89vc3W/guyZ/YhSL1H7yV2/ljsezYPZJbv8uNrfAZziToSiPPxI7111ghtCtVHScUzTcFbJDAoNDi6W+rohFGsUsPTF7Uqg2NvqSwAvgxJY++RjkW9jDjlJF4oTTczXPxy2moWQUZ1RRYcKzIVud+x+TbQ5CuAVzV6mX8zmegvtpeItYkjpKHwJJmDscD8U3+fgojn7/4EOuXD3wGaQguidyTsTVYc1n7gTh9Y24jey5NvsMBD2gMp3vv/gRPZXaDBEDYJuSbISXU6pzDNLdyB5+8GdAo3kKQshdfZvhEkzAyCcaIbyZx05MOguj1GIqDx83Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIcF2HDct05GhVaVWlxKII78iEQHJCHivcKRmcj8BEQ=;
 b=aSancgZ1WIQpUCKUREZbfO9IL9UiBy59Z5zvCxJwIeNcN0AEL31vXylyO0hkUzyO5kperzFcbJEDU0Myu87CTFnrt1jUwUQtGEZe1ZFUqdSUpO5hWnuJPCNWQg63vn3mVKmo+9Oj8mBV7oMOypBQNwuYc65jhOwueuX0/OBjTSljZuEPMFi/PW8DqMufS2hSf4RAkXUUW4u5FBE5LL+jhmb5V1bsJbSPK7eVTLVL9ehNur/xlB5WTvYLiBguGj23WCFQGI5+cHr2GOiWkVaPYO6THJ/xV0D7jM/t3ChsMHWARpW79pRHkARg1LUDx9LYYmxoqAz3Vh1WTLMW0j2xTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIcF2HDct05GhVaVWlxKII78iEQHJCHivcKRmcj8BEQ=;
 b=BzSadtuglEf70mhEcnwpnIgP36yJU71kX4w9OIIChu/QPZhpquo/V3miRdiUtsp+BsbgXh4YUS2kif+vRQLrpuZRvInBnftkLuEcK+RSvReO0r8EsNnksFSaq6r5Mo8biq+brRT4jhN5W2bJlw3o3YKiAsY5Buv513HG2Gl20N0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4255.namprd04.prod.outlook.com (2603:10b6:805:3c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 9 Jun
 2020 06:51:40 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 06:51:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH 3/5] scsi: ufs: Introduce HPB module
Thread-Topic: [RFC PATCH 3/5] scsi: ufs: Introduce HPB module
Thread-Index: AQHWOtxXhjJ5JD6j7UapdYSyFhANFKjLg3wggAP3KoCAAGQIEA==
Date:   Tue, 9 Jun 2020 06:51:39 +0000
Message-ID: <SN6PR04MB4640638EAF31B0E3D11256DBFC820@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <SN6PR04MB46404CA953E4006BDCC61A65FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p8>
 <1431530910.81591664283090.JavaMail.epsvc@epcpadp2>
In-Reply-To: <1431530910.81591664283090.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: df87fd95-8187-49cb-39e4-08d80c419000
x-ms-traffictypediagnostic: SN6PR04MB4255:
x-microsoft-antispam-prvs: <SN6PR04MB4255F6672004FDE9C76E99ABFC820@SN6PR04MB4255.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: osd/fD/Jfb400vOOavWRRBdhG1I4wkt1/yJKyqcaCO+1uoHWa4FCttx2J0X6/kBvkLtMxfK6Tnz7GSXGBX+m9q7wmA+h7TNRgvJ9T0IzOrG3oDoL+TULg3yJ78bB+nYaHNXyQT6FURXXobgIn/qQJEMhOFEq+5fV1in1/yzWOsvfZ8UzJDwiGwwqfi7GmCQL5yNXA5a4MB4EOG4sXOr63q9iW8PAWTBDkPhoT5Jv8IN4Ass1a6fL7tq4bSGGygvYOnYk1aaIGCvjpbe4BoDEFUIT39MzQq5ERkzefhIlLz3C9ffsoXHIu4cgjy4q0nM9z6Ngjlch+MusV/oVO2fBziBXQTnNANDQFlFNe0+jJwFVc4Tjz2yxgUex+Cu50ppV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(9686003)(55016002)(33656002)(7696005)(54906003)(8676002)(316002)(8936002)(110136005)(478600001)(6506007)(86362001)(83380400001)(66476007)(26005)(66946007)(66446008)(66556008)(64756008)(5660300002)(7416002)(4744005)(2906002)(4326008)(71200400001)(76116006)(52536014)(186003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vBnX6dJRJSBReVOw7MOm7S1gKhhl8Y4IWqdEmykvph3rOsb4ddSq0yTuBWepKPUZw0hlTFdxjiMgHYUAgKYQ+Fb3SX3kgwZGy4+1gi7TCQdn9+aore9UOcxbGcahe+q86TzpXB1XlTe1DlbVxGzoxy8q0Zo6tYRbIkhZYAtFcuZUo529iLQ06YwGASp+zDTEQiC6uO6vBx8FRr9JYrUbZOPadAhMH5mKZMOX3cny6TecfXLIlc59OpVx7lEP1nPh5gH/ityGbbHyiKleOGe3R5xE9aAA8tX7dqZ6qte1HChIAYJkIxlrN27UuhctP7YVjBDeFklv/qUgvX9xDLO5HQmPW0yaD4ui6ar5tQFdE/RQszHqVtpZr/Hb7z/1W4oP9wlP/G10uUI5YI/iRoHtN9ANwfC5QLhOqd03ASE0SLi86w6Wil6sCxeM5nxCNe48oKlLOGMJfOu8tFOR2fZEiQ4F1JamtN7azQULE8AQpks=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df87fd95-8187-49cb-39e4-08d80c419000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 06:51:39.9667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3CB1ac5khrQA7l5eSjS1G1YcI3dpDzOlHLPIfl+JZ+t6u5t8avPlBtqy9F/74z5mAyPa4FhAUva1Fk9BstqrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4255
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gK3Vuc2lnbmVkIGludCB1ZnNocGJfaG9zdF9tYXBfa2J5dGVzID0gMSAqIDEwMjQ7DQo+
ID4gPiArbW9kdWxlX3BhcmFtKHVmc2hwYl9ob3N0X21hcF9rYnl0ZXMsIHVpbnQsIDA2NDQpOw0K
PiA+ID4gK01PRFVMRV9QQVJNX0RFU0ModWZzaHBiX2hvc3RfbWFwX2tieXRlcywNCj4gPiA+ICsg
ICAgICAgICJ1ZnNocGIgaG9zdCBtYXBwaW5nIG1lbW9yeSBraWxvLWJ5dGVzIGZvciB1ZnNocGIg
bWVtb3J5LXBvb2wiKTsNCj4gPiBZb3Ugc2hvdWxkIGludHJvZHVjZSB0aGlzIG1vZHVsZSBwYXJh
bWV0ZXIgaW4gdGhlIHBhdGNoIHRoYXQgdXNlcyBpdC4NCj4gT0ssIGNvdWxkIHlvdSByZWNvbW1l
bmQgZ29vZCBsb2NhdGlvbiBvZiBpbnRyb2R1Y2luZyBtZXNzYWdlPyBBdCB0aGUNCj4gcGF0Y2gg
bGV0dGVyIG9yIGluIHRoZSBjb2Rlcz8NCkkgdGhpbmsgdGhpcyBtb2R1bGUgcGFyYW1ldGVyIG1h
a2VzIGl0cyBmaXJzdCBhcHBlYXJhbmNlIGluIHBhdGNoIDQvNSAtIHNvIG1heWJlIHRoZXJlPw0K
DQo+IA0KPiBUaGFua3MsDQo+IERhZWp1bg0KDQo=
