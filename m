Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6D2C3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 16:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDFF721974
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 16:19:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bAALQSS6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xQvujg5H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgEBQTY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 12:19:24 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1211 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgEBQTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2020 12:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588436362; x=1619972362;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3zEhew9gWJTYChTkmuNoXs9KyrWOfZV3SNtd+IY8FZU=;
  b=bAALQSS6nWBTR9UO3Lv+cblGL3GiOVD7vV8ED1yv7x630WAsLqjCUHwP
   rJUoBSxahjlwvF56YgotxN2fKmW3anSQxXeOTNs6t7PVkBadfkOJMoDk4
   vYvdln+/9xJH/OO1CvTonQtK/fdWJ6knikFEFda+J/YxqjwqM1rpdUieM
   Bn70EN1XEqoyEwon8w9OTs0qkHgRlzvPacbz6KbmcfyEua5TYx/26jfK3
   jj2fyo8IBR+g7m4+rP5qfHhHO839vjQHUUkEOcpoCVrMF8c57wT58Fxov
   DoDWbUMZtGij7Arzv7JmNeJT1mN44QCn5KYssiEJym0MFvNQZLAD/dVnk
   A==;
IronPort-SDR: hyEhjHp4cUIoiSXVk0WXDPm/5YkRA1Rcf18PQ+kY1Df0mE0vHyYuGuRR2hycCwd5FQ+Kn89bUq
 +oiYlcur3neGWu5ysQa+eRh49NfpafcwnIF0fO6T/+utE4akiewsD/3ZcO4HKOZEhddXpZrffl
 nCXek5mbD4SKHpxr1JV5Zuy5XJxlQMCosQlr4Mww+g6D9ZbACAZ+WyB8qlmCiTSLXoSpOHfSeW
 hFYg0pUfLxchI7TJnhKl8ckuXuRG6V+9AadOylk7cuqxUmqtfZhO4xgS4eTdjqoMj0NuRqMUSS
 Zvg=
X-IronPort-AV: E=Sophos;i="5.73,343,1583164800"; 
   d="scan'208";a="245566020"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2020 00:19:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XlCO7nmCiLErRB8tdmy7sQYcZ7Db9+Lbz5UN/yJHRFy2EXKQudfMmbvcObXgFIWB1zkyY3DqPrJ3C+qH3GHBsH8S/cW9eBbzk+VZLhhHvpiXoedgVkREfwwUGKbgQlxj/6nwvo2HpdUmses/jUM/31sfEazyuT9MB6Lat0NBHtlqop++FPH5I0gstaBSKyQXEEqlkBJgGqVIBd7b4XcxZoMOxaOUBBQhJ33BxNO+vbssPmSqQyH+mS5dFncRgGRqfcNCRc8XgR9Uc0AsA6/VkqT/gSDVQc5c5xpu4dv+u+g1+G6m5rvkJ2hNonrNZeNp1JMOA9Pl3KAhwe2nteVi7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zEhew9gWJTYChTkmuNoXs9KyrWOfZV3SNtd+IY8FZU=;
 b=amcrrEhOO7SEWC8xjLiNoRROW/I7DAc5syooEwv5posUf/4hXIKE8Rrn9bg64pntSIZ+3afPh9vDf+QIuS8O9lhIMQaBJh/37Llc4/z4fSEHNPxYQn2M3+W7dUcqi9wrd0wl530MyLxyU/++8V3Ab/N1EKyDQWD0Zl2M741Bj9YwQPVHJWelTjK+lwx5+YQu3OBWlJ5lbQ55HG6wr2ccrsn0RE0ZEwNjkpQzCWETKAifmaZ68denWZUOE8rtKV5LX2NPerLi1jEdNlngddgR/4708u3XuFaVKidaAA2FurCWch7UvN5tbSR3SiFQvidzxcU5ch/cK09Xi3fLdQxIrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zEhew9gWJTYChTkmuNoXs9KyrWOfZV3SNtd+IY8FZU=;
 b=xQvujg5HYS+3nGFD8jichPHlTm45Thcj4zYeLKBEpS3gW8bonH2p05s8hevJeurbfc7swdjQZqUL2wiSePlPNbY5wo3hNzi2oyBINR7mSXUMtu5Ex/E0pNlmb+xalqhZlRfqNcXx9/fpRaGWOUkuAhTDXrASmZElwtqi2EMyio0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5200.namprd04.prod.outlook.com (2603:10b6:805:103::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Sat, 2 May
 2020 16:19:17 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.027; Sat, 2 May 2020
 16:19:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>, Bart Van Assche <bvanassche@acm.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Topic: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Index: AQHWFC4dSn/DnOroKESaR41iHFfp4qiF2/SAgAK+MnCAAPi+kIAAmSYAgAJemjCAAWl4gIAASG8QgABD6oCAAtOb8IAAXhUAgANcvzA=
Date:   Sat, 2 May 2020 16:19:17 +0000
Message-ID: <SN6PR04MB46409E525B4AA66C428122EEFCA80@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
         <20200416203126.1210-6-beanhuo@micron.com>
         <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
         <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
         <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
         <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
         <SN6PR04MB4640A33BBE0CD58107D7FC69FCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <b2584ba8-3542-1aae-5802-e59d218e1553@acm.org>
         <SN6PR04MB464009AFAC8F7EFC04184826FCAC0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <15eca4dd2ec8a4ba210ce0844e9f5027251fa6f2.camel@gmail.com>
         <BYAPR04MB4629393BA60AF5E5898FB304FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
 <79278fe0f4e0ce820484386a72bc6044d3c66822.camel@gmail.com>
In-Reply-To: <79278fe0f4e0ce820484386a72bc6044d3c66822.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:c15d:86e6:9e1d:ec73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5a327671-840c-43ec-2f3b-08d7eeb49028
x-ms-traffictypediagnostic: SN6PR04MB5200:
x-microsoft-antispam-prvs: <SN6PR04MB5200786A6CA4B81EF03D93D4FCA80@SN6PR04MB5200.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 039178EF4A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wzsyQ/t+3Dtu0eq4vY57N5KhEe1aNtozWxkdHBz/hQWInPGO1SLf2cX3mFqn+yCt+LOtlh17QgoiN3ZPoEJM5UdPsw+1QX7wb6/ZNRbaZeZModETyY0AeAu28YxplCrkorWGrLcxQAQH8tt/W1WcCiOlfVNw0IYNMhYxe4r9ggFS72MOPfK847rZZE519gccoZedEfF5AP66rYlnJyuKKaNwWkiV2bXWqZiJuxCxeeJIykMD27RyJM2Vl40wNFpM65x6iLqmlWr/LwbC9JN8Ik8C+TXFDNENOrtOzfnYJ+ZYUfOeiR9M3vTh9W2KtNoBhCxITa6t3utkK6jd3OQI4Z5MR7xriuGyMJwHo5e2m6VnI77ripGMIf5sG5kSKaABdXEBc3p47NOCLq7DmmRkMXgYf3LoGl206Lh6m1TSKt3H2Ug8kUd1mMCWLVyXL1PS3/11gchaGefN02jYkuFf+HrDpuuzr9/J+GCNx0Fx7wY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(9686003)(55016002)(6506007)(4326008)(66476007)(64756008)(76116006)(66446008)(66556008)(66946007)(5660300002)(4744005)(186003)(71200400001)(8676002)(52536014)(8936002)(110136005)(54906003)(7696005)(7416002)(33656002)(2906002)(478600001)(316002)(86362001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MyaxCIhwfAh8sjb7Q0rPAVOY9Htq/I1WHl0IQng128prNPXgG9Lm414xxN7CR9Myp/k1yckaztOcnIoQx7Qt9ypMGNYuTszDWPpWRchgs/s6jatlRb1EVhcaQts52VGtkF8jCTkjNKYrc9gtBMQWW1UvN8oNHRAGgpw3wmuZnlNvEherP8jza0CkQ0/VLnGgBdxrwoAhFxUvxaIRIcyR4sSYDuOzApAJjeNv+MTEpPNkOcRc1jEXAMhj7gDKJC+4nx390e4ETQ9sO3CFfEMEWl9r5uwzdGeVtCAyiIrFg2G9ZcAzOGQ/vJHytLt9MAwG8G0HROI77aSxVFuVG+F/3PmGVClAjNPGJWD6GNfIj3CE+DNHKY5iY3KPwHzqOLqBUoZlJJiVB7ie9CHSjNcOku04rotTwh4C/MINUkzYC+R5f8y+yWNe3EO3DqdnzWAadc6vl7ysROnSNVXCjU5sQ0hZ/EA3MdBG+nR7CfCXnLTVspFkuIIGioRQxxjL6cRMKkuCmqHgzZ7HlQGAmK9H7NFztXf5EV5o+ClYKc1t7cFf1UOxzjpQez7E4bqH7Gso61TWURkhC1P7e8NOB4tlBFoimwnb1psJ5cA5JotDJ31nVWDW3CsK+DNELGwQoNP7lPRVLS29ZpN0W4XYQLuDKNtR7xbPK+wmX7TJOoRjbIpeQoVKKpJeGkiaPqbd6VRk27f5jb6VkIPWJVCco68+OwGv/xiWQF3SGSnUSNxcsG3wF/bjFn0J42IrZpv7G6puIbE6TbB3B081k/Cp6ZKh51lm+UpmYmKP5k4TKwBlBYkWs1tp++VILly5WnPsUBEfoBJOl90GJLFkC0ZMDDDuaGGtdQuYExS/WQzPnGvVZrU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a327671-840c-43ec-2f3b-08d7eeb49028
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2020 16:19:17.5231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9D7bSFmfVeALU9EnRpDJua/j2TzVbs257/ZJhnbSmstIpJuI65HYEw0KxdtyH29RLeoiQGlWrxBKEEcN6dSniA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5200
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KPiBUbyBtZSwgaGllcmFyY2hpY2FsIGRlc2lnbiBzb3VuZHMgZ29vZCwgYW5k
IG1vdmUgdGhlIGltcGxlbWVudGF0aW9uIG9mDQo+IEhQQiBtYW5hZ2VyIG1vZHVsZSB0byBTQ1NJ
IGxheWVyIGlzIG5pY2UuIGJ1dCB3aGF0IGlzIG9waW5pb24gb2YNCj4gb3RoZXJzPyBhbmQgd2hp
Y2ggd2F5IHRoZXkgcHJlZmVyLiBvciB0aGV5IHdhbnQgdXMgdG8gY29udGludWUgY3VycmVudA0K
PiBTYW1zdW5nIGFwcHJvYWNoIGFuZCBzb2x2ZSBpdHMgY29ucyBmdXJ0aGVyLg0KSSBjYW4gcHV0
IGFuIFJGQyB0b2dldGhlciBpbiBmZXcgZGF5cy4NCk15IHBsYW4gaXMgdG8gYm9ycm93IGFzIG11
Y2ggYXMgcG9zc2libGUgZnJvbSBTYW1zdW5nIGRyaXZlciwNCkJ1dCB0byBtb3ZlIHRoZSBMMlAg
Y2FjaGUgbWFuYWdlbWVudCBhbmQgSFBCLVJFQUQgY29tbWFuZCBzZXR1cCB0byB0aGUgc2NzaSBt
aWQtbGF5ZXIuDQpBbHNvIG1heWJlIGVsYWJvcmF0ZSB0aGUgaG9zdC1tYW5hZ2VkIG1vZGUgbG9n
aWMgdG8gc29tZSBleHRlbnQuDQpUaGlzIHdpbGwgbm90IGJlIGEgZnVsbC1mbGVkZ2VkIGRyaXZl
ciwgYnV0IG1vcmUgb2YgYSBza2VsZXRvbiAtIA0KVGhlIGdvcnkgZGV0YWlscyBjYW4gY29tZSBh
ZnRlciwgb25jZSB3ZSdsbCBhZ3JlZSBvbiB0aGUgZ2VuZXJhbCBjb25jZXB0Lg0KDQpMZXQncyB3
YWl0IGZldyAgZGF5cyBtb3JlIHRvIGFsbG93IHNvbWUgbW9yZSBwZW9wbGUgdG8gY29tbWVudC4N
CklkZWFsbHksIHRoaXMgc2hvdWxkIGJlIGEgam9pbnQgZWZmb3J0IG9mIHRoZSB1ZnMgY29tbXVu
aXR5LA0KR2l2ZW4gdGhlIHNpemUgb2YgdGhpcyBkcml2ZXIsIGFuZCB0aGUgIGluZHVzdHJ5J3Mg
aW50ZXJlc3QgYW5kIGZvY3VzLg0KDQpUaGFua3MsDQpBdnJpDQo=
