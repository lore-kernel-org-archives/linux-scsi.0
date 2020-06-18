Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219B8C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 06:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF93F217A0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 06:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ENrgw/Zs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nfRDg7Te"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgFRGMl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 02:12:41 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:17291 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFRGMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 02:12:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592460759; x=1623996759;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WPg92gyNN6XxsXwZFMk3+60uZxMdIzuDXLW1HHfpIuI=;
  b=ENrgw/Zs/yGraYYh1B7NUOeJ1A4EWO+tAq31D046OIx+nbGy4YY7rj5v
   /EqVhXztALke29Cy/6E8Wt4Dtnnb+mirTH0NPJXPafBS+fUMSnGrJ+TY7
   VN7qqkbKw7Jv/RTCI5vKQq0HQ+kHoQCKh2NzXxLFCy4ChJr/X/n+EnKdB
   P07/a/Abu4n7uASCdXQEyDO+tGoLfpRoKfqRDuGROLghOIurU8U50Z/h6
   XPjZtXL43ATkEUQpJyB/SQxdrh8rkBzryVPul6WwzJtpYq8dy20r2XzIP
   +x3LtAsNDNwU+9z70kxYnrcMnf92xL8t1uPT5g5JLd8kfEhCKCd7K0SE+
   w==;
IronPort-SDR: lGO9abXat9wIgx7NOLAFqg12QumIDBL1KrNJcU01keC4FYw+kpZ3jC8DUGagFxq7KYpiWmNDHO
 xPbmDHvZ0vKrxgsB8CxyBDtRVEltJYNtX6WNhtc/eFwu8t9kr0f+ivJw3OIwSR3Rd/B8RO3o25
 gEdjFVHopJ0pFJHjkKrYbtRBOKhzFJXXvQtgP1emad3oIhnKKQ5t2jKLXyQInbr+Iw0s8wfBw/
 vFhlGMZDlbApf5bcv+44xHSAnYxeWTZqMU7X8QD5Ffe3EJJLy6VgzfMuf4sJ7FShs0al3oOtLq
 CDE=
X-IronPort-AV: E=Sophos;i="5.73,525,1583164800"; 
   d="scan'208";a="144612629"
Received: from mail-co1nam04lp2052.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.52])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2020 14:12:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1QGCEOygrNJxM8uZgIEr+kP0JHmzEGE9RBRstRB2QJsydCIhxBxNXb0rwQ8TAcvInMOEhv3zQ/kO17E4TEcmtz7EEMMbN/z6F8tQrI7g+YTEsvpPIzjlwEzzAycDS8vxY6hgku32Z/m6Y+2/Kg8C7xvakidCdcETCY2Y2nNeMuhx5P07TmFa7dCS3vKg2fFsv0eTxWHU72+gWoY9/uT8uLiIS9wQ6x8WZ1pyEi0Zyr3/mVH8CJaf508JECeD5g0fXiuSbPFTxeoeTpqyK8C4+6A5vBQaz3ARulbZa3tWjBtnAEfgC+rkmjG6B74FMmwApfhkuSaugAsLfTpOQy1uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPg92gyNN6XxsXwZFMk3+60uZxMdIzuDXLW1HHfpIuI=;
 b=XKWuHb5lNbr1s1m41EdqJQnxB4ncIniXJ2R/el8a1nYgNAuSip6JOtDMyEDjDR68JuJH8FkfmEzUKeoT1F8vqIJz9onkgCj00HjIqDYUaZ7PH4wKjAdOdcWHuWc12+ayjy9jSO9ju7R/2Ii4l2ylz/jP+FAlikrNlxwlK98AYWNXRJp1oSQ0JUdF6y9Pa4INthnlG8cfvpk4eRtzipYyMaPpJ9hu3zuyWIzxcIk20/KwG6DQta8dU352Vkr2eCAk57BHmL2Fg1MDWWw0kLw9t/ZrjfLsd7T9L65C5bfch/uC5hYU80STho88LXlmFJvTbj4VvBfoi7YNyAuCzMnVGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPg92gyNN6XxsXwZFMk3+60uZxMdIzuDXLW1HHfpIuI=;
 b=nfRDg7Tet2B/BVleY46luFCJfA4eGAKYf0x/FBmc8LSwnKN7qAoeAqQ2k5UFkLYfVWlLLc8Tn85CRnRtCLyDJDZ2z8qLqnszKE8GAA1ISm17EvMVNldAFc3FwbzMXB+w2n6Drh8OdcPkJKyi5gLqzGaHtQ0C5jym8NpQRA3gF6w=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN2PR04MB2270.namprd04.prod.outlook.com (2603:10b6:804:15::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 06:12:35 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 06:12:35 +0000
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
Subject: RE: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
Thread-Topic: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHWQvj3YPr08JZ2QEy1VbmJ7tAyW6jcr+TwgADiy4CAAFKbgA==
Date:   Thu, 18 Jun 2020 06:12:35 +0000
Message-ID: <SN6PR04MB4640A9A9A78456A1A9AB827AFC9B0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <SN6PR04MB4640114902AEFE69CCC54C01FC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p6>
 <1210830415.21592444702291.JavaMail.epsvc@epcpadp1>
In-Reply-To: <1210830415.21592444702291.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 868a78ef-91d1-4d41-20b9-08d8134e9824
x-ms-traffictypediagnostic: SN2PR04MB2270:
x-microsoft-antispam-prvs: <SN2PR04MB2270102D64792C8F48899129FC9B0@SN2PR04MB2270.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wSq1HZUHdGJSKK7VDZqVYYXsvJxtCvqxifxyY1SS9Y8JMSPd7MXYP5MvfMId12VC+1+5KoYCM1JtEiJrHaPw/eAJkjtZe7V6rz0Z54frHh2cMzMtvyk8lQQrdKz5aEseMSQYe3SPVxNLTdwjOpbtqXaSZJgIbkli3nzO8rUR2cFnAuLPuvpXA10zstjCeKBiSwKMapumjq/C5EZDgxN9FrRyE1tmnUmG0W9cyuH2gpJr9keMEZbb7yhjcnOUR3Z187n4RvWkJSo5efN0AxFnR/MhWH+VLwer8RC/WjynSaorPLvuVX+Hg8pRVuXCjuGuGmcizPc+qGm48QJ6pbeX2HD1H3qcWv6mLgLqdpbCU1ZYNi6AzVPVxScP+DGFMXIo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(76116006)(110136005)(86362001)(66476007)(66946007)(54906003)(71200400001)(4326008)(33656002)(316002)(8936002)(83380400001)(7696005)(5660300002)(2906002)(6506007)(52536014)(55016002)(7416002)(26005)(186003)(9686003)(478600001)(8676002)(66556008)(64756008)(66446008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +HTQhaL6MEf8IjQLG42ke9IqQGSblg8F2CDLCSYLVARGnvBZ1bbrQ2+xoYle2MgkENHfu/gdMdjotwWpjKRqD61+0or3twJBLAqlod1xF1tyPHKIVetdBAl1cQp7N/3/s78Y8S+jqA4UwDm/vsfJxguZGYvcbOLVqvVt6ZBurU0x3Pb9oi3iM3aUteE1B3u1hLidMHsm33ttax2VDmIL/4jl1a5Nx9n3XXoct1CbReyHnxkvwhXsh1rQPo+3BOq6/lbPOWmA+9d+56nQ0+Fq9GeSEwVksO079jfTAV5l9pORhvOU6uZfygMhn5fTA95QKGl6uGETs1jaq3ZDpCAzHcGzraaLa0MlSv4bn4+oHSWDnYD3DqIyBz/t/51jjV5B+28zVgsrIIXxFF0ihou4tSaZY+YPmQE8hben8WsqewpcVU5JhngjjYdY45wrOGH1WSt6i9MFgoEDHhJHIwQpG7MRaP+PVy3rmDwddpntidm/6hJFYqhBoE9DhvR4GXlC
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 868a78ef-91d1-4d41-20b9-08d8134e9824
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 06:12:35.2157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oibTwjYFKQ0IyJ7HuV7w9bjsKfObuVVuEltsTC/AC9DzHHgo1lWmqlHGSYi7Su2p+kCVc4vK+AewZ3py8nCSfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2270
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiA+ICsNCj4gPiA+ICtzdGF0aWMgc3RydWN0IHVmc2hwYl9tYXBfY3R4ICp1ZnNocGJfZ2V0
X21hcF9jdHgoc3RydWN0IHVmc2hwYl9sdQ0KPiAqaHBiKQ0KPiA+ID4gK3sNCj4gPiA+ICsgICAg
ICAgc3RydWN0IHVmc2hwYl9tYXBfY3R4ICptY3R4Ow0KPiA+ID4gKyAgICAgICBpbnQgaSwgajsN
Cj4gPiA+ICsNCj4gPiA+ICsgICAgICAgbWN0eCA9IG1lbXBvb2xfYWxsb2ModWZzaHBiX2Rydi51
ZnNocGJfbWN0eF9wb29sLCBHRlBfS0VSTkVMKTsNCj4gPiA+ICsgICAgICAgaWYgKCFtY3R4KQ0K
PiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KPiA+IFNvIHlvdSB1c2UgdWZzaHBi
X2hvc3RfbWFwX2tieXRlcyBhcyB0aGUgbWluX25yIGluIHlvdXINCj4gbWVtcG9vbF9jcmVhdGUs
DQo+ID4gQnV0IHlvdSBrbm93IHRoYXQgeW91IG5lZWQgbWF4X2xydV9hY3RpdmVfY250IHggc3Jn
bnNfcGVyX3JnbiBzdWNoDQo+IG1hcHBpbmcgY29udGV4dCBlbGVtZW50cy4NCj4gPiBTbyB5b3Ug
YXJlDQo+ID4gYSkgZmFpbGluZyB0byBwcm92aWRlIHRoZSBzbGFiIGFsbG9jYXRvciBhbiBpbmZv
cm1hdGlvbiB0aGF0IHlvdSBhbHJlYWR5IGhhdmUsDQo+IGFuZA0KPiA+IGIpIHNlbGVjdGluZyBm
cm9tIGEgZmluaXRlIHBvb2wgd2lsbCBhc3N1cmUgdGhhdCB5b3UnbGwgbmV2ZXIgZXhjZWVkIG1h
eC0NCj4gYWN0aXZlLXJlZ2lvbnMsDQo+ID4gICAgZXZlbiBpZiBzb21lIGNvcm5lciBjYXNlIGZh
aWxzIHlvdXIgbG9naWMuDQo+IEl0IHdhcyBpbnRlbmQgdG8gcHJvdmlkZSB1c2VyLWNvbmZpZ3Vy
YWJsZSBwcmUtYWxsb2NhdGVkIG1lbW9yeSB0byByZWR1Y2UNCj4gbGF0ZW5jeSBkdWUgdG8gbWVt
b3J5IGFsbG9jYXRpb24uIFRoZSB2YWx1ZSBvZiB1ZnNocGJfaG9zdF9tYXBfa2J5dGVzIGNhbg0K
PiBiZSBzZXQgdG8gbWF4X2xydV9hY3RpdmVfY250IHggc3JnbnNfcGVyX3JnbiwgaWYgdGhlIHVz
ZXIgd2FudCB0by4NCk9rLCBJIHNlZSB5b3VyIHBvaW50Lg0KSXQgaXMgYXMgaWYgeW91IGV4cGVj
dCB0aGF0IGEgInVzZXIiIHdpbGwgcXVlcnkgdGhlIHVuaXQgZGVzY3JpcHRvcnMgZmlyc3QsDQpN
YWtlIHNvbWUgY2FsY3VsYXRpb25zLCBhbmQgdGhlbiB3aWxsIHJ1biBtb2Rwcm9iZSB3aXRoIHRo
ZSBwcm9wZXIgdmFsdWUuDQpBcmUgeW91IGFzc3VtaW5nIHRoYXQgYW4gImludGVsbGlnZW50IiB1
c2VyIGRvZXMgYWxsIHRoYXQ/DQoNClRoZSByZWFzb25hYmxlIHNjZW5hcmlvIElNTywgaXMgdGhh
dCBPRU1zIHdpbGwgaW5pdGlhdGUgYSBzZXJ2aWNlIGluIHRoZWlyDQpyYW1kaXNrL2luaXQucmMg
d2l0aCBzb21lIGRlZmF1bHQgdmFsdWUuDQoNCkRvbid0IHlvdSBzZWUgdGhlIGRhbWFnZSBwb3Rl
bnRpYWwgaW4gdXNpbmcgYSB3cm9uZyB2YWx1ZSBoZXJlPw0K
