Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C7EC4727E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 07:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C282376E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 07:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AiEimnhL";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="u7SffQgD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgIWH73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:59:29 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16709 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWH72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2020 03:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600847967; x=1632383967;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=AiEimnhLjiPurM4/Zle2Cno6vV0sX69kB6ez489cSwmWGg+RmZq/ZsjE
   6saLn0yrsco/GvzXW64BgI/6yPOZ5B2J2qDsvtxVIx9AF/FDkA6UqGZ3o
   TVP6P1K2NL4453dFVWhO9LVAZtaPrXzuRJPusmLXNK0rqTRHOFU3ePO9C
   7quTvoxjDi4boS2To9vIIHm2OLVfADh0pXFUPr7YfsKnhYyovKVZtKQJg
   u8VDtS5E2nW64JREdofc8+OVTikPIi1G5LX1y3qHGf0Rq/PvaKilFgSXZ
   oNWmLIg+9VpUVoljFH64Qp2bEQlN2J+M6V3pgdq9khoohGgcF3dpHBQyV
   g==;
IronPort-SDR: ULIYKAVYtl3Vo1DRGj0p1KH/zv6OYaDL2Aa/MAT5n5CSkZ+DWdOi91zL1VBtVtXfqMSlh1+w/r
 fwOnFUVXWl9nms0jB+rxDepKvbRM02nZYzFdpZdeZpx3ZLfe5M5ZEMkBjzbrwqpLYc3Hxk2KHG
 shSN36sk14kwoXakAqGoRdoFr0G60N4YMbCDImgLlAMHxhavmvs5Xl0gUX9AEJ4r3d7Ma5HVId
 asbyX9FparGuwh09gnmM6y0YEQQ0w5tpJTQjqzPzfZJucSDjeljZSo0fY2TXprZb8Awi0Z155A
 VaY=
X-IronPort-AV: E=Sophos;i="5.77,293,1596470400"; 
   d="scan'208";a="147986423"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 23 Sep 2020 15:59:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMlp0t+YHmGqqlhd5z3jWMt1J9F6QkdJxnJyXkeAt0I7rNs4rUIlIHiQC4sbrqWcNH/0aqdTFiqHXwW4diy5IkhfI5u7RudvXf7B5DvuS3wuckFCNeU6BDmEldAB2Noj+Bjn6b6NS28Ebx0452diUdbhQ/QTC9BPL4a5uItI2lbGbk5vi/8CL/Vjlj32Uh3NBIo7/H6/qgT4Rs9xCq0uRDUH7rrcZoSlMRpyrTwM8yGFA6u6PrPvdLU5CU1QAhiddqb6NDQM2VyU6ODr7imB3phfermTpb45vrRCiYHUyE3pXz0tgg54ZxWo8G1x3d0abfGBfXQwQA+r2kC30OUUlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=L/XONw+78c2GXkz9tQPZlWQdCaAKog+lLyvakqcdbk52EZi4y2Nqy4yozEJOAcJaYCxVN4290u5/+8F2V37uepbtcOJ8+o1TQoEgJfszsu7stFg9JzBgXtWWCCitEQpAokkJ4VJEkXUwa+zcJQJ6ZtZnYT0dPorb2XBvQk6gICpW+x9asgwnvMO48s72lg0USg7LbBMkJT52/m8or4VDMIHHDkmCYTnP/aRgQnvIehOLpHgEA/omNPrSWFvmy1Lnt5CKhHJ5xzSIcBkCAuE8Wr4hHmcYcSWOiepJqVstENVglPO2Mh21JUXsSFTpYWSQOnZha3hohdlhNA3sHNy3WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=u7SffQgDBF+79gUpD/OUKbL7GxfDEhbO1u+7/PzrTKqn5REkcEwDyTGj13stWsmotCQEA6YmRyqAvvlGV10XtTKSRmCXRZPcrGO+6q4vyH2MJTLws5oNCDiCIwI1ukcHsEzo10pjgPf4Z2TripXT3RQ/fi1sJ/H7m3ybJ/VVruI=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5248.namprd04.prod.outlook.com
 (2603:10b6:805:fc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Wed, 23 Sep
 2020 07:59:24 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3370.033; Wed, 23 Sep 2020
 07:59:24 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 for 5.11 01/12] sbitmap: remove
 sbitmap_clear_bit_unlock
Thread-Topic: [PATCH V3 for 5.11 01/12] sbitmap: remove
 sbitmap_clear_bit_unlock
Thread-Index: AQHWkUmilUu9SF7w6kSGPq9iIWvOFQ==
Date:   Wed, 23 Sep 2020 07:59:24 +0000
Message-ID: <SN4PR0401MB3598AA0AE46506FFABA36C109B380@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200923013339.1621784-1-ming.lei@redhat.com>
 <20200923013339.1621784-2-ming.lei@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 89e89bf0-0029-4820-a170-08d85f969659
x-ms-traffictypediagnostic: SN6PR04MB5248:
x-microsoft-antispam-prvs: <SN6PR04MB52483B6BF71C091DA475467E9B380@SN6PR04MB5248.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ghFjDfvl491f94npH6b/qoxOdO86d1jVvnuuJhn1CAlWB0t3L2VSZOml6TXFj3QW23+EPfyvT/9xcHyTfoMnSAruXDZGMC3gOH47ziCZzyOWpAdfKrJ5NMASBTe1yJUpSQUs1zvkBf1TYi4ZG1JQ/6oTvSgff3D67cBgBoikX6+Z0za0gvl0dX9SzAZQBtEU7WHWMJ36m2Bu1xuezqEd8m77KFW44GzWOvI7rHo1Kw7LlgeF7ejZpNvvw1kyq6MlWQVswxLUrh6ldAVhoYBc51IUa5xej9D/CUz6+XeFKR4HaW57ls8ReA2Bqom+RY+lrqjCwuZHr+j70ofLjqOQhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(4326008)(8676002)(19618925003)(5660300002)(7416002)(316002)(54906003)(2906002)(110136005)(4270600006)(52536014)(558084003)(66446008)(86362001)(64756008)(76116006)(71200400001)(478600001)(66556008)(66476007)(91956017)(66946007)(33656002)(7696005)(8936002)(6506007)(26005)(186003)(55016002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fmqcwSQVarsve8aA98VCFxOelJ4KTrSszmoJos2t4u71FvwlWIAykvukP1CMTRRln9gkSMGgzzN2eHJK0MhZ9F3MC0ne18DT7jV1ESKoO57Sf+x5oBA1/n+QgwjuC1w19ZndvGMIEb56MMkEWRxpgmh3UKtWtKoNjiFCGYUo7rJg6QfCFqHYBa2WkPB1fc6NGv8omFtMPgqV7JdvjzqH/PBDZZ5nNRbaD9lQvcqAsEUl0BcenSqgfpeZzTic6pJuGdPmZNfINvgp+BBlR2RfCxt4YfTCFEbk+ejrEeDdB7kUeGhpnw77IfHhx/AuF2f8HqFOjxjsPqoxHERXpvHjl4A6CG9MgUCpuxqTrO7bG/3yvV5NdX24Ngr+nrK2h4jKmtC4HtTHg3zOCsxhbLfdhG6oj6OZPKj9YcaLkdAtP6LBWdqqnKsn5Huhr/c5U0wi0r5I9XaphY06dLNzxu8D63R1ep0NHruCmghOCo4IoTkOG29PsqpDIdJBVSRq3UVPTnCm03sNlhRxg/414zHwL6RfmiVg6W2GYGj8iLFaCGICMFG9AJiG+4fQMIEMzuqBPgwJj25NoG8+PWSkm0cP44lI0TjlCVeCcbeiQfv0Pc3IBnwPhmYNQlD8rO9cr8GjOyzssZKbsGzxL/dw8mlWBg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e89bf0-0029-4820-a170-08d85f969659
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 07:59:24.3975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XpL3TK+2h0w7cFNTMIT4NThdNIfvPzgjpKdHVqcixpyU+cxh4A7+63igZ0rlIF0EwboJjjyrUB9utCuhlargeaqERjgc6hObrYYgAZsdZtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5248
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
