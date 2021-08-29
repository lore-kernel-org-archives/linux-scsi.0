Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F8FC432BE
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 22:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 758F560F45
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 22:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhH2W4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Aug 2021 18:56:55 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:21904 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhH2W4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Aug 2021 18:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630277762; x=1661813762;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=W1FEaLHdOMUdeX84ChEmv53+7syrGGWx5cbbXFa72yg=;
  b=hANXgr/MP+Fojv1AiiBtviBE7xImCNNazf8TmBPXAv8sI/ngHNHRubFE
   QJt0045QXE7/HvyTLsV4hXB0Hlqg8LJvuKlmFu/LpPdgf84z3NoEy0Fjw
   3GJ7PMmn6YNKekQa7osNvHSVDPz+xFk9d6fDph5M545/wvu6VUR886P+o
   gbyN064QLGoM5KueRcXP1v+Ef4fXtWJU/a3bW8eY6K/hwnOsZfno7ycbS
   v+EKdnGbcdWbsCiWVkMzN1zcDtItHwDWTZtZmzUWhu9YAPSkcbbAvJSyY
   lGGvjwSxFxDar/wk3+aFnSRY6Jw1YzdTihIcVZ22Z+h1esQfc7U3j3w53
   A==;
X-IronPort-AV: E=Sophos;i="5.84,362,1620662400"; 
   d="scan'208";a="179269380"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 30 Aug 2021 06:56:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/0n6jII+LbamUEjG/Ys3u49PqoNztKiNJxQSvz+7dp4i+E4GltgwAD4wcBmAN+dMMqWw5O8phlPe7RCDtXBnwE6Jyf3lRlIL86lYxydwYquKK9A/xXHy2E2nD2tL8pAcvdrD3g3ucOcqiyaiaUp7yfcGLZXDGK6LgkSre8VT+vHo0zzIRaADrPob7zPAZd8rDAxAKjOjI/oS5B4SIqwqmm1kjoD6W4NVSgY4y+PCW8PhcOnrxUPXepUyOM/yXbUVThPzKXqK9lul6Jtqt3p4rFRr2AYhvIG3Z+YQQJSTqP+w0S27Der6iCg1I73qLMwf/VAz5WDBXQgl2SA1lzgEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEIojefFyZNRgFI/Dw1dd+U7FV5M1PnFexm95MNnGYA=;
 b=jekizgsFrOa+uihJytGs4VyvZseGN/xpzZ2474Oy1Rhw4arALtYBE7eGVnYegWge3zE2watDqgXJcZIQxW7ttcoWwcaprS0mVxkLwhEXzTELGNaNxOySDf7JEgSU6mwj+aJzpaxGKpylGKOJLB/E4hrNnc/dGmfvWNvRs5iCB3OdrZtrpzmkTLBlwylcsnftBFIhMXRZerrmYlhGrk+CDEzkeYHJw5t5feuhDOc1YQlAf/mHO3ZtUiIDi3ewLq9izQiruha7dlkuCTC0CSM0y1k0DwM6JdmzdPWE231JaUhobe+6t7t4AUwBS54lUV7JNvN9VQj27TF+pTzNIhJj2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEIojefFyZNRgFI/Dw1dd+U7FV5M1PnFexm95MNnGYA=;
 b=N+s9zrtzggR/AERWhvtTq+MYvmf/LWsrrsRDuCwSBt7Ab/DS3BxErz1HrKXpJd9Fimusmv7UbdU2YvHKoa+qOCqpo/72b6oBmw+x9+41QsO3U8COFQdR3/XzMQaC4ldF7jsYII+rNC7HY3ETcLWVkAYc1derNbUPuhH/vuGk85w=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6828.namprd04.prod.outlook.com (2603:10b6:5:22a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Sun, 29 Aug
 2021 22:56:00 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70%6]) with mapi id 15.20.4457.024; Sun, 29 Aug 2021
 22:56:00 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>,
        Tim Walker <tim.t.walker@seagate.com>
CC:     Phillip Susi <phill@thesusis.net>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXmxim3oZIy1vm80ixsAdRU+BqXw==
Date:   Sun, 29 Aug 2021 22:55:59 +0000
Message-ID: <DM6PR04MB70818F92521F56EAF5229BE2E7CA9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
 <874kbbugtw.fsf@vps.thesusis.net>
 <63D90989-AFAF-410B-AD11-EDF71CEEE666@seagate.com>
 <YSkVwSfQ/9RCKfEG@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acf02801-499e-49fc-2559-08d96b402b6c
x-ms-traffictypediagnostic: DM6PR04MB6828:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM6PR04MB6828EDF1EF6927C2650E2B13E7CA9@DM6PR04MB6828.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9uxKklayHAPNhg3FR4ThT9i3390S24EuX9JmqwJymOYHiUhkHiXlltGOVKI/I5xX/0dKR2+KanlDLqYojiyGy/S4VrK75DNfySsSM++aQq6R43GbptQxlbAXuvOMqurGgbS9hn52067mtuFGH4avY3Bhwr//u0Tr/jNNeV8Z2QfW7ympT9tVbAta9ZshFYK6+QZMpThLvg/4oaKHxJTpPP2uD3nnZAp1TkORVRsLUQjcFRESiiTFDvqAHCVYeVK5ZNkp781dckNxuhIT1wdTOv1hOfEWkGkOckWY0iY69zM1kdRS4FUfY4H+IVJIKHAskrDdFKwyDJn2XcljP1Euyk1aqXxo6QGjt5V8r033qQi2yp4BweSo9+ubDHDOGdIMQpClAy2MBiR30QF1TaNhxIUdMl5bEVFtdgB7dEvh18CyvxFJYuINL/znKiY0aDEF3irQ+hVItczp/l94yo2PUtjX8a5rZld+1geIkbdblsFhwZVK4XhIjAICJQwp3mvbf9m+p4R7pkilHVgV3a4IbDefxl4J3AH5S+slCexKfQKGzaobeMpyJWp4P/owrB5k5WSQMvga5UR41Ia1CWy7UGmAI7B17RNh49ANBZeAOHQZbUcWmEPaJE72rR0F43nv6Q6CbJM/XaLBEj44GT6BrTz1jNzCyHkLkG+3idJWueDKjXS0DKRGBOeA31CygNhCu/RbcRcB8MkrplE/m1yrSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(52536014)(66946007)(2906002)(53546011)(66476007)(4326008)(83380400001)(7696005)(64756008)(66446008)(76116006)(8936002)(186003)(66556008)(6506007)(5660300002)(316002)(110136005)(91956017)(8676002)(86362001)(54906003)(55016002)(9686003)(71200400001)(478600001)(33656002)(38100700002)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mbpaP0nx44SOK6Pvof9pko+PIUBIiWZxdTDZpgRg0q25WlaoT4ZpJjQb9RH7?=
 =?us-ascii?Q?ql87s5/fLC/HWsI72T0B1jJet4nSom+a9n0QBj3PCystd5m+nNB0TcfNW587?=
 =?us-ascii?Q?YCzUVxj106+zY8bTg2FcfVzGO0S3ZNZHSI2cNo3ZZl1TkdED+3b1lN+LXFQ1?=
 =?us-ascii?Q?u9X+9q2X79i35r1jhrxjII54DSbzY5Kl4F/W1OqxYmj7zSxTjClIA+Qvo+Pl?=
 =?us-ascii?Q?KzbfMbEACC8zhDUYfgjdMi58IGqjR9SZye1lLywJUBAq3njoZtYIQh6KLatX?=
 =?us-ascii?Q?YmtqO1G7LfTtimzeoIHrS1S84lVZ6bqlXZcOJJuQ+k0k0zPv1GdtUHSy2DM8?=
 =?us-ascii?Q?kKv+kyTQWbay3AdIu669TbEeyAqhnsY4MDzL3ouRVQqo7MONIsX8ixmHHB8z?=
 =?us-ascii?Q?SUJ0THy+h96g8l6mG8P8Bv4iGeDqcJCMcQwIf7YjHgbNI0bZ2CSz734Is3+4?=
 =?us-ascii?Q?ny/JM59Qj5xsA2QbRvtDKUot3uGQ7Q/bWhxe089FMouH9y5JSIHhB2+5lvzz?=
 =?us-ascii?Q?9HOIweFUu/MfXDPGIRsaOXc0gk8g3mqYg3z8xJZyGSe5Ir0jmcxJyG1bIKdP?=
 =?us-ascii?Q?ZG6XTtP89MIfp/9N2Op6MhW91vqi2QzbH7ZB3a9mMoCif4bKnu/m8QJZU8LE?=
 =?us-ascii?Q?7ikc520E+WXEOfxL4eUUqyYwVT+Uxy8tOYaBWxZo2vFDYCA+TXwX4ZNNSBot?=
 =?us-ascii?Q?ri3T3GzJaq+OFrml+y3n9fcCMWhSRjxYPaMQ05oncjibkBS1BOIESUJkRBU1?=
 =?us-ascii?Q?ETfCMS8qpP5u4chawoQnltM65oBMazmJcOWnwmybhzXEVAT0zRcBRTxnqz2X?=
 =?us-ascii?Q?quN+eskAdUZkgs42KinC3oSVS4wZnq1fDAlM6Z4LV1PhNY4pB6aqfZwlHR2M?=
 =?us-ascii?Q?tquhYpCer3e6L/a30xUTnyN99z4Cl8f3fdd3SJOKVYo8qyS+aH4aNrhaMUzo?=
 =?us-ascii?Q?kBZxuw+8tCTefF94MGhvZ8sX/HT/jwGtAgBrYGW6groGqFWyZ0MT5olLhIFb?=
 =?us-ascii?Q?rY3h1S1TbQt4Pa1vc8PUTpSkT57vQlu2M8VM38gs2gO/nBWGn2htYR5WSGVh?=
 =?us-ascii?Q?zYZvPmyRE2qvC6C1xFpMENeqT9Pxgk20edpQQOhr8oVeA0yJjXC8cIaAmGLu?=
 =?us-ascii?Q?k3v66g6qJ9rnUpVtKcGuv4n9IB3YcukfhCL9xG8ULXT9WSGhc5Bod/MNhHo2?=
 =?us-ascii?Q?JBo+y9glMhP+MR3pCg0d5Mfk6m+6OWit+fyWc+nNMhNJKbjMKoH65UzDloxA?=
 =?us-ascii?Q?zyMlPFmLtz0HK4/mDLOsA+keZH/xyD19APSE4J/9qCzHMyS7SeowroOCrPZC?=
 =?us-ascii?Q?V1mGR3++8/vXa/k/gjROjmnSDsQNtmvrpnPESD2lUGDwlf3gyPtOBbjIaR50?=
 =?us-ascii?Q?4SR0X1vxQhVYjaTuHDUw3cAAgHLSvYpA5edDzUS8qmmBH4O7Dg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf02801-499e-49fc-2559-08d96b402b6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2021 22:55:59.9844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YpeGRR/TWcI1XVaL+lCjjvbyRf63pVePfTISD9CiIuF4N7eGAb3LVNXzM4sXEQaO4L0/FrZ42QXeitRSILMIRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6828
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/28 1:43, Christoph Hellwig wrote:=0A=
> On Fri, Aug 27, 2021 at 02:28:58PM +0000, Tim Walker wrote:=0A=
>> There is nothing in the spec that requires the ranges to be contiguous=
=0A=
>> or non-overlapping.=0A=
> =0A=
> Yikes, that is a pretty stupid standard.  Almost as bad as allowing=0A=
> non-uniform sized non-power of two sized zones :)=0A=
> =0A=
>> It's easy to imagine a HDD architecture that allows multiple heads to ac=
cess the same sectors on the disk. It's also easy to imagine a workload sce=
nario where parallel access to the same disk could be useful. (Think of a t=
ypical storage design that sequentially writes new user data gradually fill=
ing the disk, while simultaneously supporting random user reads over the wr=
itten data.)=0A=
> =0A=
> But for those drivers you do not actually need this scheme at all.=0A=
=0A=
Agree.=0A=
=0A=
> Storage devices that support higher concurrency are bog standard with=0A=
> SSDs and if you want to go back storage arrays.  The only interesting=0A=
> case is when these ranges are separate so that the access can be carved=
=0A=
> up based on the boundary.  Now I don't want to give people ideas with=0A=
> overlapping but not identical, which would be just horrible.=0A=
=0A=
Agree too. And looking at my patch again, the function disk_check_iaranges(=
) in=0A=
patch 1 only checks that the overall sector range of all access ranges is f=
orm 0=0A=
to capacity - 1, but it does not check for holes nor overlap. I need to cha=
nge=0A=
that and ignore any disk that reports overlapping ranges or ranges with hol=
es in=0A=
the LBA space. Holes would be horrible and if we have overlap, then the dri=
ve=0A=
can optimize by itself. Will resend a V7 with corrections for that.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
