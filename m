Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71BEC4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 02:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DB132343E
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 02:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436560AbgLLCC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 21:02:58 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12061 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728590AbgLLCCQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 21:02:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607738536; x=1639274536;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=/UWhSsSojsI71fvmCUDMNXZ4Fcxa315QYCJYHO05pLI=;
  b=YUj0oJiDJ1N80zf9Z+9L4eASNmU+LzynLXImM0WUsOVcxXj0Di8S55uH
   rr2c8DdgmDaSioPQa4rBpoerR6V8gUPSGR9x64bUjVAExSoMTYih/7YgK
   v1qXPfUMhv5mhG8flcdwSq0+r9f6D5a2ztuuQWNzCO9MacKwTP5/8Botj
   bMm+dy5jl/dvKRakQnS/Mi0uDrmvjIr4H3BlYdjnqE7n1Y+YbdiQM8pKA
   PqNgxrGB96YIDVHaFwxJL9EEYwzCu9npD0tU4xzvUYtJ2fojA8S0zv/lh
   50zeBTVTNWKHupf893x/ZhBUF024/3OD74+COtNQBN9IiYIHcRxvmmrhd
   Q==;
IronPort-SDR: 3/tZj7E9x/XTJmG1HXY7/l6emfat8wyBx/gP3CJ+Mw+zPMVzOQq31+yI33TUWkYYcGCt1gMbaR
 y3JPSK/ZwEgfK9lf6ViC6OBupUFZdJ5e+v7nMDGkzl5qa4DR9uU5iTDoAmMqxvGN+eUcZmdpEv
 lIAZ4FERDVPN+yCmplZ07h4ntNj7YUAVEqJ49HMyFFE6PXCQGpPolluIS/DSmyPB1rb2y6m5Zi
 hYeO684lwnQeiXOayroKzqYFstEnFvf3LtjdzCvbf/+0+pzXL2exTcOc1aEvRUykQI4RX4Bw3e
 Y9g=
X-IronPort-AV: E=Sophos;i="5.78,413,1599494400"; 
   d="scan'208";a="154971104"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2020 10:01:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K00LXRFIk79rHcbyRtal1TJwG9xCyMyHkM0qAQQTWskHUc/rUic9QLB9heHpdfWX+U65K6avAApIWLPKb6wU8CvUwYMAPcqZ5NThbIBimgsZ62eod9XY16P5yjgMO9Gxhld6Jh1mj624cRcWTvofaP2Lw4MEs5EoMses670xJyjqtMBMtuEDPZM5jOrU8VnyFIcQMcI78clw1xM7aNXJmtQgqu/r96iFrhDjT/5w6TDl0OfS4F7E6nQnLpOcJXoemO/ge0jffz7asrPgfNUypNpJP1Hn8ZYrZfn5T4453eAoXY42y3tKvyjb10mZZNBXRQjbvJh7AhIYMC3gpTlI5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UWhSsSojsI71fvmCUDMNXZ4Fcxa315QYCJYHO05pLI=;
 b=b+NM8TjzHqGXr4/hHE3igL0JiZVrEJq/ULv1EwH1KLe1XDylOQ1JGlulNXzxsOjQc1SNNGNqyfybE6HegGDjOxyVIHGls7Rv8apwM04CehRQMdqSi4ADJ5seNXijX6cZw8uhRr5UxsWCbGw5dqJoluu7KeRGNyD6fX7CtRvpaY/WOAZf6A2EGYZIYtSdyp261+5MaOKufNAYQwoYrh1nv3iKq5/lpPqZT54teCtGDP+KF0enOSslx7NExj8/NrOzxhZEKLnrdmftUKyL25ywF+Dkf6kdWtJpsFIZ6U50ixTEval+UXB9rrYaR7ZNNvNxxJ37muw35vuBCiiALZqc8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UWhSsSojsI71fvmCUDMNXZ4Fcxa315QYCJYHO05pLI=;
 b=xVA6tZk7UduyEOn5/DzaB4DNpxQ7NmJj/D6rJRXuR0dcGEA4DpeLO3Irmx4cR7bEWgfvnGvAp0QZtYuQnXPL7QsH0i+RqHGNLwJHTRLh7oGHD3aDieSVqqYOI1xBooJB+JdgSReOne9KSN5iGTAgSjDWWII1NPvkFLlJzQmQVrM=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6422.namprd04.prod.outlook.com (2603:10b6:a03:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Sat, 12 Dec
 2020 02:01:08 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3632.025; Sat, 12 Dec 2020
 02:01:08 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Tom Yan <tom.ty89@gmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [RFC v3] block: avoid the unnecessary blk_bio_discard_split()
Thread-Topic: [RFC v3] block: avoid the unnecessary blk_bio_discard_split()
Thread-Index: AQHWz9kQWxslukhVikm6GzXTa9nMUw==
Date:   Sat, 12 Dec 2020 02:01:08 +0000
Message-ID: <BYAPR04MB49655BAC94BE4A1AB19BE01186C90@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201210113704.1395-1-tom.ty89@gmail.com>
 <20201211161319.1767-1-tom.ty89@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 34e87c38-a723-464b-0321-08d89e41caeb
x-ms-traffictypediagnostic: BY5PR04MB6422:
x-microsoft-antispam-prvs: <BY5PR04MB6422466A3BEE77D20FE4FFC186C90@BY5PR04MB6422.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3kHKUhhP5y7Wj/t1aHPOSfo6FJ+D6Gp5kTrYgtZj5bBMb4LR5Xf6CFUJxi5VPsayu+xHv77vIhQoXHc5RpVlbI6YklJpSZs9nH3vrTcHennbw5r8LfRk6zVdtIAjYNqHL7OijNhuLyGkqkXkNFLFFoEUXhD8dgDthEVrqUeGQ3YPZVtT/KukZJX0eX3szsxeyulzxK+R5KXTEdVI1Ji5bk8YtpZmlP4o6/qwigjxWtG0N6DQNudvY+GKlHq2LA2gGYLc3pMYXtex6gBg6cnTy1TppkN73AxH7bQBiGETXIZoSxkcZRom6BCDZ78cDBNYaYV+jCfeoYaDLAZbXTICsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(86362001)(8676002)(558084003)(83380400001)(7696005)(9686003)(54906003)(6506007)(110136005)(33656002)(71200400001)(8936002)(76116006)(66556008)(26005)(66946007)(4326008)(64756008)(52536014)(55016002)(5660300002)(53546011)(2906002)(508600001)(66446008)(186003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KvNrcQFm0AEbA45/UmcH1TVK9nmNiNxHMY2H7h6aaquEyqAaPadzsxazu+9F?=
 =?us-ascii?Q?QD5BiBsjbtQE826BE3AvtEid/MctJoBFdBTFx7Z1nsfPbhnUFdMPWaMi+wQ0?=
 =?us-ascii?Q?+haTE30+fyhk0uW7dNDT0Isiyee/UmfSeKq7FUzWpmsfvzQfsAYwIPDNdx4j?=
 =?us-ascii?Q?BYJUOrvdJd+IniEWcp/b5HyY19Gd3bVlq8Gg2Eu6nn4nWWlyNdWf14vk2seC?=
 =?us-ascii?Q?6cdBsO+a1aCRv4AUlOXj7R/FlVVYMdlwwSWBNs0ia2vIRnpD4LRPvP+0Ywkl?=
 =?us-ascii?Q?jhPnKi5YpAXBWaFnmwnUwX7H/srYnHH1V0yusGiEYV41fqaBLWtVJESfc0HJ?=
 =?us-ascii?Q?SQheWBnCHtrFicbGspfsman3BY1k6avyvAOTv675cyl5xSHsRxztFNOTUMf4?=
 =?us-ascii?Q?gfihQa72cHu0ZhMidfAu7VMhGQeemcev9cqVlAV4omTGfQ3lFTpVmWWVqgvQ?=
 =?us-ascii?Q?Y1JtSfoxkQF4WOV2c4griKGRNkubut59hOAuNhgQJ9FhoXUUn/DXS/syUq59?=
 =?us-ascii?Q?81RLOr/ogo1MBvG1UMiEh2DfeTtx/bk60MjQpFzjD7dhmp73o5KtQHItQUKH?=
 =?us-ascii?Q?tD7kUZkDhWnGhKyMDSBbQ3zlB8YGS6UxSEy1oVYyZFoK8yNLIj1nLuAkoQbr?=
 =?us-ascii?Q?9q8XfsR/PTRKeOkk7Z8Q527F/xPooQto2c7zJZjirGQZHfEZ33c5yk9LxPow?=
 =?us-ascii?Q?XXJc9fiGTwcJVdvw77gymOQODxLff2fGfyvquaQU3Iv5vt/KN4D+8PvX116a?=
 =?us-ascii?Q?Hdhgloim9bPecKCq/6rL5MV4mJDZmvb6gWJPG2T3aKR0H+UcV2bM/ZIxSd60?=
 =?us-ascii?Q?YsOWCvRHcw9retKQwkM3UzWA4twOKC9aFi8vhg6wDuAmQUCj/0FXxhrcponH?=
 =?us-ascii?Q?xg5a6sBFQhbGKoEy2pCaL9t9OZDQpilisLy2C4j4YKekvkGdNxha4hvIXqoR?=
 =?us-ascii?Q?TuVsZNAn/HfZB3x/O8gS1EJVP6mBeekSXTEQiF70gqPDkUyWSs220eNDHZ+I?=
 =?us-ascii?Q?OLPS?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e87c38-a723-464b-0321-08d89e41caeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2020 02:01:08.6727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oL2C4v+4Ygc/C+XnNQeq+JuYpkFxk1VfK/4qhmkntL5ToHiwR2IhRZ2g+LfHRym+d6Qi+/nYbgMA6wX0mkbaJzwd/PQXf6V2B19pkUBdUMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6422
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/11/20 08:17, Tom Yan wrote:=0A=
> It doesn't seem necessary to have the redundant layer of splitting.=0A=
> The request size will even be more consistent / aligned to the cap.=0A=
>=0A=
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>=0A=
Can you please explain why the change log is missing ?=0A=
