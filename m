Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6E9C433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F794204EC
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:46:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UezaK966";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JonVGXdQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgF2Sqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:46:31 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:50424 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgF2Sq3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593456388; x=1624992388;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YSg5i5SN78P1NIptG0Gi3DpGuJ6iBsXQwTEHbDKgci0=;
  b=UezaK966nX48ScEzGuySP8ltN11qGJ14KrTxw6Rhh7WzQ99W0ihSTnhg
   Z9RXa6V744Ddojk59Plmt/rtCNbDd0i+SKqh4c33DxliomRTpy9hm+TQs
   y0cPZ/ntsGcqQijBwsWHqb7s/uye8hbMQsMYSFkB0x5M4SwICMcPajde+
   2UZO51KmqbTlFB98wFVb6nOK45gbH6metjp0MbSaIS7vAt2T2vbdu/e7Y
   rzvB4CU7r7JnbSLH+sz17S6dcTlVMvorUNbNUuEFA1m5kKRgwlxF7R1d5
   9oABNQWCcGxMScTg84Y6nB+NxcqleC2Ues0cHwIVITXG0M4Sh/j0B2WTB
   Q==;
IronPort-SDR: d2AK/867VW/T9C7NVm7jRcvJGjOlCSHstI40u4ImmpdzKyCyVpzATI8nEumb6ClEUDQjZoF29L
 izcLSW3Hpy0S9nFP9N4dY1asV4Opm8RsJABVo93Klfyvv4y+m7W2BJdgoRVOrrZy0xA6UyeUX+
 eI4YFaqPn+UKfEgGKPfBYDSkFlDvxkFbnv7YQQi9XN4qFhfmf9LbfEICOXQuhiKMEfIGs7ubCD
 +Q1JQs3L/2d3yqdDmNSXAJDooyBTqD/SF+TipUjH2t4UvQ89zWmVp3/1ReE6I7kTsNhwDBsobd
 HEM=
X-IronPort-AV: E=Sophos;i="5.75,294,1589212800"; 
   d="scan'208";a="141152198"
Received: from mail-bn3nam04lp2050.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.50])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 13:24:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0NAflR98WE7BWqdAyxVJXxin8l/J3C4DNSD7SGQnwb2/driVuOXIhyrdHQ55OOg+zK0OsXI7IubfTYiu0UEXVdF1XCzwkJ8w4xdG0IN3BkTAZ214xg8LVOVyO2gJj8UAO6k3mgbGFfVrvszO5nfwjH5n5qmkwLAg0LcOA+8KcJizxkt7QLxsiFlohQZ+tcw46sG/zLxo5wDRZ16c/4dSSu1nzGC/Yq9tqv3SLMlawMo1NDycB+IS0JMjATURD/UJev/59pTE49UyVvZL5WOEZ8vUrIxjjlBs8N7gGy2yBcNc6/Zfs5BKbo0bmUEGP4Tq9q9vvUYJQ2Ng41X1fkPkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSg5i5SN78P1NIptG0Gi3DpGuJ6iBsXQwTEHbDKgci0=;
 b=Ywglt3PiFxW4OSojmGTpx6RzNbMnmrVBAZ6P9Wm8SS9Ril4dr7x7KPif34LxcYrgcxD/wpEx4tTN/PII+isCGzPvltchgmorp8upKqR7pUdPqQSvSdxtu9W+hrqhFe/w2eKAMhPfeNDqt2indo8MiRC8/4NNY+ehgD7fuyl/kGBwMelflVjn53hLTeBtg0jYBJM3lfokLwwFXsgDxq9VZ0XHohE6XDSlmDzJvRsyUeoFfD6szhrHDNXa07rJo32pxTNJ+X1WCyilWg+G4ESgWms/ZYSIaVDZ7u+xt77RTpasSO853iCZRVcbdu+r5kq0gLl1OHh5YkgMxdGlDCtE2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSg5i5SN78P1NIptG0Gi3DpGuJ6iBsXQwTEHbDKgci0=;
 b=JonVGXdQ5jF3TifaL7im+VDWWNs7ZIpWTJaxH+CH+HE9XgDC4rUW9gskp29epdKD1KI+NOWXwtqF6d+dl7owSvQ2YUYPvZyDSz6OEOdLjp4AVdDay7eEoVOCojLXdq47vP+0UlSjyLKkoOiZNG0CTCf+UGiQpO53loFB5058YFQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5359.namprd04.prod.outlook.com (2603:10b6:805:104::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 05:24:29 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 05:24:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Topic: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Index: AQHWSQaiS38tkGk5ikmxTYEvPlxKOqjt/IuAgAEaswA=
Date:   Mon, 29 Jun 2020 05:24:29 +0000
Message-ID: <SN6PR04MB464004B3DC7FB046A1E38F43FC6E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
         <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
 <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
In-Reply-To: <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:213f:a600:6b7:4650]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b083b44-79c7-4b83-ea8f-08d81becb280
x-ms-traffictypediagnostic: SN6PR04MB5359:
x-microsoft-antispam-prvs: <SN6PR04MB53596C7F56349C55B60529D3FC6E0@SN6PR04MB5359.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a6wvWSUomWGV5I9fx5CF9BD0lvvNqAPDEEM6U/8UGe+aqFbBatHXAj75UXMdR5JFVyTAF+0us1zVhJrw3x/Tgo7GbVQq9BuoCsY5NC6BHDSz9uxi5UNtKRmt/JYycKceojaLiQINoeR4nndjzwBBa4qnzMzmchSoNit0y+baBgmqBPnx1XBCjeExF0U322FHZxXR/G0Vl/CBaui6WDYTxbHMAxcOvKcJeli8GaJi+aQI4+/dJyicGeB3RLQrB81QkSLu6BmgIeh2WBz1nBOb6ngt2xtTqCHOhi5Iwf6Tw64OPLQPoazKGS6SaI2XIpaX9OXbSxZ9ZZJAfnAR57ShIWnl4ZFtIE/1Od3zBa4PxdXltWbdXsmTNs4HlOXMnO6V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(9686003)(7696005)(4744005)(8936002)(5660300002)(71200400001)(478600001)(33656002)(7416002)(86362001)(6506007)(2906002)(110136005)(8676002)(54906003)(83380400001)(66446008)(186003)(52536014)(316002)(55016002)(66556008)(76116006)(66946007)(66476007)(64756008)(4326008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ohPN0Lqse4+BRb2P+Y46P1dgcBJ9VYG+l3iVULbpywWH2MlBOY/DXx6NSkbTIrgBT4/350kDMfpNNtwxL4X9DY+gWNGZH3uIk5xT4dKYTnKmcG0IA8tuqEWgKPAyFG8IJgxc48xTcBPzzLdvwDMGmoym8yrFRIa3FCby0NWExcRu2M/Zan0WjRQSwj0wyw6Z7T+nkV6IX8xazF5+bxLBoY4ocZ+E+luL5uwMyoMqKRwzpPcLLe6nZj80Tb1oBgsxxJ7l/eVkTY2s34RP0xbFx7SHBEukdnOTseQoOL5ey3t64sBVmoP1X1U4FzlHWoPrsGHp/MTDTIVOOTsRRJtzSOICqpv02aDmnwrL9UCHo+xSQSXTWSZJ0Xts9ZPn0jd+UvezQuH7A8wzQN9nbUJbPc8kVhkUMtpOSWaYJHdA2yfLuxG2wnqOTbldrXxe0wacLhoy5hzlNddKaDmLCmx43eiYjWjPQCoT1wK7IYfWgIHvZta7T9oek4hjtzoMV4lCttliBZbHCG2jnAw/lAB1c0V2NlFbNdhUYNnYN3kW35eOPn8zA2vQ7Ct//5AXFmoG
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b083b44-79c7-4b83-ea8f-08d81becb280
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 05:24:29.3100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XKIILsEprNrJnuqqIbhZtBalloVj2oDdONlo+FsgC1pI3fVK1hH3/lkdTfIZR1pq7u9+CNRuLLYEETGQXvlNpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5359
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCj4gDQo+IEhpIERhZWp1bg0KPiANCj4gU2VlbXMgeW91IGludGVudGlvbmFsbHkg
aWdub3JlZCB0byBnaXZlIHlvdSBjb21tZW50cyBvbiBteSBzdWdnZXN0aW9uLg0KPiBsZXQgbWUg
cHJvdmlkZSB0aGUgcmVhc29uLg0KPiANCj4gQmVmb3JlIHN1Ym1pdHRpbmcgeW91ciBuZXh0IHZl
cnNpb24gcGF0Y2gsIHBsZWFzZSBjaGVjayB5b3VyIEwyUA0KPiBtYXBwaW5nIEhQQiByZXFldXN0
IHN1Ym1pc3Npb24gbG9naWNhbCBhbGdvcml0aGVtLiBJIGhhdmUgZGlkDQo+IHBlcmZvcm1hbmNl
IGNvbXBhcmlzb24gdGVzdGluZyBvbiA0S0IsIHRoZXJlIGFyZSBhYm91dCAxMyUgcGVyZm9ybWFu
Y2UNCj4gZHJvcC4gQWxzbyB0aGUgaGl0IGNvdW50IGlzIGxvd2VyLiBJIGRvbid0IGtub3cgaWYg
dGhpcyBpcyByZWxhdGVkIHRvDQo+IHlvdXIgY3VycmVudCB3b3JrIHF1ZXVlIHNjaGVkdWxpbmcs
IHNpbmNlIHlvdSBkaWRuJ3QgYWRkIHRoZSB0aW1lciBmb3INCj4gZWFjaCBIUEIgcmVxdWVzdC4N
CkluIGRldmljZSBjb250cm9sIG1vZGUsIHRoZSB2YXJpb3VzIGRlY2lzaW9ucywNCmFuZCBzcGVj
aWZpY2FsbHkgdGhvc2UgdGhhdCBhcmUgY2F1c2luZyByZXBldGl0aXZlIGV2aWN0aW9ucywNCmFy
ZSBtYWRlIGJ5IHRoZSBkZXZpY2UuDQpJcyB0aGlzIHRoZSBpc3N1ZSB0aGF0IHlvdSBhcmUgcmVm
ZXJyaW5nIHRvPyANCg0KQXMgZm9yIHRoZSBkcml2ZXIsIGRvIHlvdSBzZWUgYW55IGlzc3VlIHRo
YXQgaXMgY2F1c2luZyB1bm5lY2Vzc2FyeSBsYXRlbmN5PyANCg0KVGhhbmtzLA0KQXZyaSANCg==
