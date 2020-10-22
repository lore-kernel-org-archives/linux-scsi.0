Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B7DC388F7
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 06:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AE1F2245F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 06:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kCaFk8gu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vmaMTUqz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504386AbgJVGwL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 02:52:11 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:30990 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409800AbgJVGwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2020 02:52:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603349530; x=1634885530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8r6C5eG90sGLmXXzqK2ip9oeh1aKanwiFax6n9RwSvk=;
  b=kCaFk8guN/xSn6L5n4ONYyj1VJkDzjhXKh0eY06DmAjfnIaAy4WXeot5
   Ge86fogJCB1s7IY7NEIllUR9t/YEmZJF4UPyX4KO8tZPlcVQD76lSsnFw
   py7whFdtEmZdfVmBQYjLwMrsalc/uf4ll7lYFn6oOvqs2j1fycbUM+jZ8
   rJI+DLsdHxC2BnD2+8ol2S0UT73vF/8twkT753zaF+gfx5veymjeYyOm+
   jVksiL8AVZcvq6Cm396nfe+pFhF28+D50aJoKYKrwLK/AdsuMdUw5s3HO
   xsrkJQwW1zhbKeFCVtkvfeAZ8Ku3AIMdZRkoq4tu8JO3hoFOLpSqAd0eG
   A==;
IronPort-SDR: MvZCOgLR5eFKL7Tye0DkqxmYhlmqc73zkh/Di1LSoFpwPVcO8T2mnT5tjTy/CSC5vKk2kuczvr
 FAGvIQhfoRxWr8b5rO6XJSIpzUeW41iVwr2259uuyVqW5Ves74HtnfpqBBF0NO5e0KHzOrN42C
 /jrGXi1ggyttFpbvgWNk7CrPJA69oxaENWrRfjjtHaLsKetwbcj6kptIJMAuxxjMyS4kChThTn
 AvfT770NTy7Wx0CkTXDZrcMSlQpa8tQ6OkoC30Lk/9clbKvm2J+tD/n+1U6MyWNtRWWaKGNnO8
 mvI=
X-IronPort-AV: E=Sophos;i="5.77,403,1596470400"; 
   d="scan'208";a="260487770"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2020 14:52:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9oy6fKlAZt0PJ4yuIExEGyWGpyB0e16AVIerosm0GSmLEIjeGYMY2RdEuT8FjD7ZA3wHKk0F5CWRa9sjia7VjbuHH95JUc5+JXFVEXufT9siH6oqRP3XnL2jXYVgRy7u+VYUIVrRjP/43M80MJq5ToQjujqBY7wDMC8yEW1g2bYAp2dLZGSRx8OLc/mfYvqg90ArZ81YdsWTEI489wG8FF9uQ4vPcg0waPIRE3Wk2wpaoNNgPqyLqYc6HxLDbtpXAtRH8QCfhHCL8dmcJaTbUclK7BqRh2iyPIxEV1O1VryvxpjblnXyDR6mdJ5PiIXBmXAnO8SabRS2QTgeTpq1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8r6C5eG90sGLmXXzqK2ip9oeh1aKanwiFax6n9RwSvk=;
 b=I3uSEypfS8Qh/HGCZM+giltPiEr2VudicCg4PLd+ljRqeSDzcJNQLinbp+Ezxd19UFbBPSANnxKWwKCwDpTlp5HE7LkHC5OKrlxBmqUd+bjwMsmYEJga9tltnTX0qP4fyxVboCGjeR9VtN/jPr/h9i3QDINFTrWzakhwEIKeoHDUJh0yTBozr8uvfQ9iS/5rhHp1h8IYXfkxGXHsvs/VoLBLDJ9F9dahOnYr9GZn7xZ7KQ+uAtbW4p6WZnAQHGEmfmWQrmnlXF5lIhn4U4e41b2I+5NemsWWS7RtThRgAIgx90UTL2/ydyervaeKZOgQUHQg+YjBKTh//bURgLQObQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8r6C5eG90sGLmXXzqK2ip9oeh1aKanwiFax6n9RwSvk=;
 b=vmaMTUqz9tE8b8y6jMmWzD+7inDus/QuFRrqAeKS+XzjjHpdGvKpwIsE8TTFbds+j68OCu8B8lIRsstEIe5ZmmcpAPl9JVB279/SMs6PFA8FD7SMdpl2hs/bFAbcNtzn1vIdx+HqhRicYCerVkv5ymVGZH5bmy6ATJ25+lQzXRs=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6536.namprd04.prod.outlook.com (2603:10b6:a03:1c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Thu, 22 Oct
 2020 06:52:06 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::709c:ec54:b10b:2d90]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::709c:ec54:b10b:2d90%9]) with mapi id 15.20.3477.029; Thu, 22 Oct 2020
 06:52:06 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        'Bart Van Assche' <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
Thread-Topic: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
Thread-Index: AQHWpq9q7Lr7WY87fUG0cXv3FjTmmamix4tSgABLSQCAAB6KQA==
Date:   Thu, 22 Oct 2020 06:52:06 +0000
Message-ID: <BY5PR04MB6705B7357AFEDF3AB07E1560FC1D0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <CGME20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d@epcas2p2.samsung.com>
        <20201020070516.129273-1-chanho61.park@samsung.com>
        <7fafcc82-2c42-8ef5-14a6-7906b5956363@acm.org>
        <000a01d6a761$efafcaf0$cf0f60d0$@samsung.com>
        <0a5eb555-af2a-196a-2376-01dc4a92ae0c@acm.org>
 <008a01d6a830$1a109800$4e31c800$@samsung.com>
In-Reply-To: <008a01d6a830$1a109800$4e31c800$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bb5904e6-e4e7-40b1-91f7-08d87656fda8
x-ms-traffictypediagnostic: BY5PR04MB6536:
x-microsoft-antispam-prvs: <BY5PR04MB653637E3821B04BB4265C771FC1D0@BY5PR04MB6536.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RFkq9cklWiVp9SHFJcY2urJBrGNzR5KjoIx0iyOENyBZEQ9FodvofzHD5eiKalUNATras7hsBBsM9M7pm/Lopg0MKjzePjCy9zKxTCwzknXY0/B1v+ph5elOgvIfebeUvtbcer65BUqC2Cu2fyFA2f7ei1pgTbWM3h5rQ4cE7H4VQpsDrEanHaYnpREOMTQn1uiQE1J7SnfWMArVpITmYT2HPZTwOHgGQq6eBwTFv+BE19dEp12Wz/hOQYaamgiqORLFTz66rE08JS9q2LR2QTn4wGDClTQmhRDwmBHWgscc7cD8gcQWdbyF6vobWG37SnOtqaGKdXuNP64+XNHDTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(7696005)(6506007)(5660300002)(478600001)(8676002)(26005)(186003)(66446008)(66946007)(52536014)(2906002)(76116006)(64756008)(8936002)(55016002)(54906003)(86362001)(66476007)(9686003)(66556008)(316002)(33656002)(71200400001)(4326008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eTFqFnAFTFdpCoRBX9Ta4FPocYeMz/Sh2BzypY4Nc/Fx1aP70xnlffJedyffhMdlqF8CcCnokhDqL0SaZSMOrlYRNWXoXvC+fUu5OfNdcQFSQe+oI7rUAY7/WpFXtjdR3JhQtwZAHg6OswyORE/56blo/WV25c5at6Nm2zC6LfRMfV/EfZo8YAM6Ky8g+/g0Ixwgm1weotFXvNM4GxX5GBWO1I8C4m5e0ZAyeJsCfR7mtOJRL728KHLDJDTe7FyBkIZTvCy+ZvtMW50HaqaBPAOWNDwyfV9whjU94g+TwKAxDRYBDnIoB4Cvx9MJFg54S2tOdpDKqHif9qzNddW5lXU6yyOoKSKxHtOXMT4mrO4pPp3bC5M8rhN/rrQiw8B/OXcVMHDfzt923W0NAUPhOZbO3F/x3yT054dwsamTlmwkopNZbBuYbmwFSPizh5gQjcYfZns9/UpY/bDh/Qts+MDMd8qXPoRu/zUrLbjvs8/OKa7q3fF5sV1RfC+G7pFFRpUGiCM53xOsxbAGDuD0z08RxgoagT3V+4b5MQAIAqS/qvFyom4JiZ5fZ43ZYwudGSj0pkhBCIooueL2dJrpNJ0SnRz498on6vH/Ff13a5bJz2pRiSg2yWseNCt/kUUg4GmRYuVEUs4UjH4BJuBh/w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5904e6-e4e7-40b1-91f7-08d87656fda8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 06:52:06.6240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zhdkI13QrdIfXy/imzmiTrZt8IzcRDZCkwCdzmOouEJu33kl/jj0ucE9c8GIFQ9pZIhoiFFP1vXH9aO8XHxsnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6536
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gPiA+IERpZCB5b3UgbWVhbiAvZGV2L2Rpc2svYnktW3BhcnRdbGFiZWwvIHN5bWxpbms/
IEl0J3MgcXVpdGUgcmVhc29uYWJsZSB0bw0KPiA+ID4gdXNlIHRoZW0gYnkgdWRldiBpbiB1c2Vy
c3BhY2Ugc3VjaCBhcyBpbml0cmFtZnMgYnV0IHNvbWUgY2FzZXMgZG9lcyBub3QNCj4gPiB1c2UN
Cj4gPiA+IGluaXRyYW1mcyBvciBpbml0cmQuIEluIHRoYXQgY2FzZSwgd2UgbmVlZCB0byBsb2Fk
IHRoZSByb290DQo+ID4gPiBkZXZpY2UoL2Rldi9zZGFbTl0pIGRpcmVjdGx5IGZyb20ga2VybmVs
Lg0KPiA+DQo+ID4gUGxlYXNlIHVzZSB1ZGV2IG9yIHN5c3RlbWQgaW5zdGVhZCBvZiBhZGRpbmcg
Y29kZSBpbiB0aGUgVUZTIGRyaXZlciB0aGF0DQo+ID4gaXMNCj4gPiBub3QgbmVjZXNzYXJ5IHdo
ZW4gdWRldiBvciBzeXN0ZW1kIGlzIHVzZWQuDQo+ID4NCj4gDQo+IFdoYXQgSSBtZW50aW9uZWQg
d2FzIGhvdyBpdCBjYW4gYmUgaGFuZGxlZCB3aGVuIHdlIG1vdW50IHJvb3RmcyBkaXJlY3RseQ0K
PiBmcm9tIGtlcm5lbC4NCj4gDQo+IDEpIGtlcm5lbCAtPiBpbml0cmFtZnMgKG1vdW50IHJvb3Qp
IC0+IHN5c3RlbWQNCj4gMikga2VybmVsIChtb3VudCByb290KSAtPiBzeXN0ZW1kDQo+ICAtPiBJ
biB0aGlzIGNhc2UsIHdlIG5vcm1hbGx5IHVzZSByb290PS9kZXYvc2RhMSBmcm9tIGtlcm5lbCBj
b21tYW5kbGluZSB0bw0KPiBtb3VudCB0aGUgcm9vdGZzLg0KPiANCj4gTGlrZSBmc3RhYiBjYW4g
c3VwcG9ydCBsZWdhY3kgbm9kZSBtb3VudCwgdWZzIGRyaXZlciBhbHNvIG5lZWRzIHRvIHByb3Zp
ZGUgYW4NCj4gb3B0aW9uIGZvciB1c2luZyB0aGUgcGVybWFuZW50IGxlZ2FjeSBub2RlLiBJZiB5
b3UncmUgcmVhbGx5IHdvcnJ5IGFib3V0IGFkZGluZw0KPiBhIG5ldyBjb2RlcyBmb3IgYWxsIFVG
UyBkcml2ZXIsIHdlIGNhbiBwdXQgdGhpcyBhcyBjb250cm9sbGVyIHNwZWNpZmljIG9yIG9wdGlv
bmFsDQo+IGZlYXR1cmUuDQpJbiBjYXNlIHlvdSdsbCBjb252aW5jZSBCYXJ0IHRoYXQgdGhpcyBj
b2RlIGlzIG5lZWRlZCwgbWF5YmUgdXNlIGEgSURBIGhhbmRsZSBmb3IgdGhhdD8NCg0KVGhhbmtz
LA0KQXZyaQ0K
