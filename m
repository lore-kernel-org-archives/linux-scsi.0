Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A6ECA9EBD
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 07:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75FA32184C
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 07:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mXbTohgR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jVXKc6qY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733050AbfJ1HtX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 03:49:23 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:38606 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729695AbfJ1HtX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 03:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572248963; x=1603784963;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=LYCQoOw5DhwW5Z79fqWtlxnacucitA+yEKP46BfeOr4=;
  b=mXbTohgRipDxjxT1B+Z4iqWUD/wZVJuW5hBaPAPHPYkdrUc2KsgIVy5I
   c38MRoW8fZmJVXMY1QnaKm2vOr6k+SMS2WwU121wF53IM4HAmdozIFOFM
   g99XgidSvX1v+razwQ5TffzlwggDBWnWtX0nnKso5QIFXv8+Y5wYzmDIh
   l3n4588PczUa4hdVc3GkSDj9kGAJhrS6g3XljtddNw9vYetKzbzEzMBHh
   BhQ7CcmMYQyP2IUgTJ7yml2AmvZK0m49RxERKKWxPiDeRqQt2XXV5nlfm
   9VhgqYlRjAkEwaRp2Ksb4LANYepchuboMgEuTNMcVf8jHL9m8QBJd1fb6
   w==;
IronPort-SDR: spCGvcWF4pJTfSXV7c73+uU0+uW2Rs9upAJj3Q5HsGG1N/W0Jep8kx2rZDx71TLag7vQujx0CH
 jvcc42qVI9RBLVBasX8TgSm/gM8qDxL2xZ/wiLCZlyfruVwNngWQJBF98Ef53KXK4pmYPkKGMB
 XyDWm66KAvTMYKTgfLj+5eKF9G7h8b3xSnptunpkwA2Ldeq/OheFzdgntRPgw78xDIH88OrVcC
 bFURBdSJYHEdMUc2n/dPSnhA8RNk5CYooQSuP9RCT6ycIJ2995VKIfG0fDq7wSJlRGqalJcuSJ
 +2g=
X-IronPort-AV: E=Sophos;i="5.68,239,1569254400"; 
   d="scan'208";a="125882894"
Received: from mail-bl2nam02lp2057.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.57])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2019 15:49:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWCeNEYU9FoSouJwcvsjK3a6a7Qt/0+fiQiLcOI0g6fxQNVASqpaLNBsuVNwvzcXvDWT50r9mfR7crnj6gxnhU5CAVk9WrpQhYcv5tQeFLMkR/gDGyVnphr234paNi3K+ZxRYnH1Alohi3FnbGi+PYsC4qxQBFajuUOFimKt1bvlDyDnOLmNysFirFx/HlsID5iso6MJ14hKZHkxWyXiEiHAfv3wepEnjOqgNuEW4slLQdSpL6gH+y0yi/93OqgJeKZlnyxJt7VQNfJZ08UwrmoAxPRpQsJ+XtbFfA+V0ySdtOk4FHH/+/Dz6t5uatItYFKxo7z8KXrzKIi4owbzFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYCQoOw5DhwW5Z79fqWtlxnacucitA+yEKP46BfeOr4=;
 b=IN2N7KIqTcWkJc4pdD09G96Bk6XS5JvSN5bXWyMKb46ogAyJXcq7A6dTmTmpeOLARbBK7NE+eu28SCdfTtphjrJVn2MUrcWtm6hYUAikb93nQep7YjEA7RIbM3Gp8PYKi5ljYWj/CYSmUHoXm9ra2RjbIoMBAieZuT1fPC6DLDR4TeIf1IGkPV5cLiTiLGZ0+Wky1gf0vJXE680ppyIj3JxuRETQm6W/xiKdc70N1qIy+fZ6EAeKaE6kU1+M5GmGT8cZ/Do7eDutZFT/Pr2in5QcjFAXQa5bQ6TiDWlx8MtteyIzcXtvQQom4DNqHTj3cjhhpBTzTxKb3l76MAyddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYCQoOw5DhwW5Z79fqWtlxnacucitA+yEKP46BfeOr4=;
 b=jVXKc6qYyojvqJp26VlD28fzonzWTZSSZYMrM4aW/36bALAZnS6ejD+ZQRWe8sCCiFB03n1LsyvXO7A3/xamKsnD7AnoM9SvpZ5paLvXRyXSx2+/7aNzHMrAjDXCYgYOyxQm7iCluprEdQFnN4rzBhsqyZXeOlY8krGTUvraRlA=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB4728.namprd04.prod.outlook.com (52.135.239.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Mon, 28 Oct 2019 07:49:20 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::34a1:afd2:e5c1:77c7]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::34a1:afd2:e5c1:77c7%6]) with mapi id 15.20.2387.023; Mon, 28 Oct 2019
 07:49:20 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
CC:     Ajay Joshi <Ajay.Joshi@wdc.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 2/8] block: Simplify REQ_OP_ZONE_RESET_ALL handling
Thread-Topic: [PATCH 2/8] block: Simplify REQ_OP_ZONE_RESET_ALL handling
Thread-Index: AQHVjM+qshxVC7ah2EOUEKAVKMXumA==
Date:   Mon, 28 Oct 2019 07:49:19 +0000
Message-ID: <BYAPR04MB5749C25A8558C0ED9AB3EA6786660@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-3-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.44.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ea6f626-76af-48a5-937d-08d75b7b576e
x-ms-traffictypediagnostic: BYAPR04MB4728:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4728BAD2B681C6FEE1B2943986660@BYAPR04MB4728.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(199004)(189003)(71190400001)(71200400001)(99286004)(186003)(7696005)(53546011)(2906002)(74316002)(256004)(476003)(5660300002)(86362001)(6506007)(486006)(8936002)(4744005)(66066001)(76176011)(8676002)(52536014)(81166006)(76116006)(81156014)(102836004)(9686003)(4326008)(66946007)(446003)(6436002)(6246003)(2501003)(66556008)(66476007)(55016002)(26005)(64756008)(316002)(54906003)(229853002)(110136005)(305945005)(7736002)(14454004)(25786009)(66446008)(3846002)(6116002)(478600001)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4728;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rP2RhoK8CdyPLZWnrmCUUdknJXYeZ8JxI+uVPjnL/9BbPW6gRhU0yW7q2VAV4AWzrM5ujyA3mKPxjHnP+HXaNLaWF5uhmfeDoHL0+Kfs8H0zZgjBVCkXTC4wCDxIZaqPd7YxP0Vb/0EEhGbGVlKWugb48coUwxKLwfuGEIEZAcieruqqBI+0KaQSUW1TCNsf0x840JE2UA2S/iXnun6Gmdov5DKPnSEG8S4iXRm4RxfdabKt/v38jdbIdjwTJT/MvNfrw7R8oxEV9djtsqz7ecId6v5gDZiqFyW7SAV8gQMZMwZpONNWMEMg1Df9okM2xAYHEtb6UggxlHojg+y8BQzNgjyG6ZQGeAq+89LN2uvEzedA8bF+m8Q/qEFpbIpoby9Y3sox9gYMJIos2HRo4d6cvv063004CVuFatDXQuZetXEDSFmX+q9lwCexDVE6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea6f626-76af-48a5-937d-08d75b7b576e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 07:49:19.9685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XPc2A87OAkaGZCLOOY9YC4fhe8oohf3V5qJgSLFRTl1at/61XLFVix0e9UKPjem6TLsbPx/hVFes+UvFwdoMnP9SlL6aJ8JfVMNTWBGTTAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4728
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The reason code for REQ_OP_RESET_ALL is kept in a different function so=0A=
we can clearly differentiate between REQ_OP_RESET and REQ_OP_RESET_ALL=0A=
when we add new tracepoints with blktrace framework.=0A=
=0A=
But if that is acceptable, then,=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
On 10/27/19 7:06 AM, Damien Le Moal wrote:=0A=
> There is no need for the function __blkdev_reset_all_zones() as=0A=
> REQ_OP_ZONE_RESET_ALL can be handled directly in blkdev_reset_zones()=0A=
> bio loop with an early break from the loop. This patch removes this=0A=
> function and modifies blkdev_reset_zones(), simplifying the code.=0A=
> =0A=
> Signed-off-by: Damien Le Moal<damien.lemoal@wdc.com>=0A=
=0A=
