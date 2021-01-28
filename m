Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	TVD_SPACE_RATIO,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA82C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70DE064DDD
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhA1LpC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 06:45:02 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:9622 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhA1LpA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 06:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611834300; x=1643370300;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=msmoECZ/e6DDfs08qSbcNqoFn9ihS2cF0+YxIOBftL8aTQZMUxNwAigN
   AVQIs5aWKNrTcx/9iM1+3fXA4rDULd+60eNMg8h6NJlVYblNGzyK4L1KF
   R+4Pi3SrBxvylkkFKIQ8DUjgF5MFBsc8CgkLWtwC8uagw6m7oa7tubK0T
   J8cmy0NyOJ0yOJhj0/AASMGl6duSedH3aoczMSaPzZYmKZvIe9/SWrrpi
   xvZSe9d82NASoOnS5B2DSBifNjGwMsJRMrfRGZ7HSgJcYAqnWK2y1lUkb
   xs0ndI7476SezXiNqN5vtzoFLt96/YXJTE4ZhVawZAErIkKQklG0OIL5X
   A==;
IronPort-SDR: BHTN2CmZRatQqlBkQHI4yiM7LqEIbkwD8+bQ2wNvo7Kv83F+q6vTkzqI0mx4m26Ht3CGBvkcF4
 pYZZ9LZ4F3vA6+P4EMrCwTf/yRZQ0/dRv6V1WDheJFEjS1pCs6hRFfufT76UZzOJNoijZs7GG3
 euAaNaq/C0PJ/11q1YQscKZzBjZ53i1mJuj04pXVlEiVzU/x+eQAjcXdpqW+XGkZOkaMkwTkqU
 PmRxXXyeFfKFOFuF4oTxxufuIyRY9NhMU129C+L0GH55TqZjzX/NKRi5lBFNKFjPaH1JLcAAah
 P6s=
X-IronPort-AV: E=Sophos;i="5.79,382,1602518400"; 
   d="scan'208";a="268912311"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 19:43:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzdvEQzlFZrDCYZyO8b+sQGh+xn2fROsQj03SYcrIxqx7ulqN7569Ctay8JdW5NRCHBNJfIM7GucQvL4esdq5eXQ+0kXBm6I4k3FIVpmNG8elM3hRGOB8cRx4YbFkweO9mmHbtoev/6JD/XaVcUq1hshR8AGq/B5LIHUZetpUYxi0MdlAq7yjV1QimuWmWbN2T6mun0VJ7MUboYUc0sHVm2QZkfGVBQbf719bWc7j4bgXPKK9bcxDLz7R/qRQyV6qCjAbkooCDzGqSRuVKNNKkpcb6w6NqGK/8IrWJrzkau3Ko50Zk/PTHzbC4LGxMmoj6xgx/dblCEinYEdr6ytnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=a2+X+vscPBWyKQDZNVB1rryFjYGEQBvvEO2ISwfy/KAdBccG4167MQQcre3gp/zw3713y06K0HEOtMSepQSkttfP3wznZagBEuXJAKt4ML4gC6FXEiln9x/9vOxPm4S4CEbgSwiX8xiKPbH1rUkr7dwxf27LW3EU3Lbx7L0K9G9sEMFfJd4PfzTjMWBgOGAvc3vbbjnLaPwN2yZgc4hDaUkYUf6mBmyJwxtmNBoEI+4PxuCwvXQL+1uabygxzn7R0b6KCyrPvive2tjMuDgmv1B3z/6WGoQhmEShnGrCuXP8uOX5CzeLwZHKPaLtL6IeNwCRWSMyJiiQJfXiBvdLaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=AFftYb0tdWW2NsUxtKEH+eQIX/HmNnBiTe26U1oSTmASnzODi2lMR4fwHLdat4CSW2iXxuLOBy5qK9MMIVfX1bq392qWLfoPx8grFRoHmvE8J+Wgw2NEoEouL/B9aElAyVjT00PdGk6Djp2HV9PIOiyapPHjcjB1Lr+nNGCMtik=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3597.namprd04.prod.outlook.com
 (2603:10b6:803:45::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 28 Jan
 2021 11:43:52 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 11:43:52 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 7/8] block: introduce blk_queue_clear_zone_settings()
Thread-Topic: [PATCH v4 7/8] block: introduce blk_queue_clear_zone_settings()
Thread-Index: AQHW9TFLFVS5j7eQbkewhHZC6LR8XQ==
Date:   Thu, 28 Jan 2021 11:43:52 +0000
Message-ID: <SN4PR0401MB35988E69F613B4C91929370A9BBA9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-8-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1d0b0ed4-eb82-4960-cdaa-08d8c381fc4c
x-ms-traffictypediagnostic: SN4PR0401MB3597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB3597B056FAF01974997E2B6B9BBA9@SN4PR0401MB3597.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sKEUqwG9Cz7Beq6VeRzPn++eyVoxSICpgC627c41VBNx4ZLEBbuTKihINrxz83DlLe2PQ+++Z1m9IZTlxGRpi8N/ozALhvORrhYS7Io4UL/vjL3g91UnKNe060oPWd/aFMeYtsqj+mxjnOvRgs3B3Joog2pqm4M30GyOL0qkYQKHpnmpM8WW94PuLPidl1njSG0XyIPd3XdStcUqTqEOC8UB3K3uP6Suk8av0eGDbUw+tcMA56ZiCurIHm2G0pFRuqDLrjuWKI9iwVt20+45Q7m0OJqxqCogm0jvQzPhgOCo245IxxcMck9Vf8Wday07gDDSgUVYgl3nuqJbzPGJqbdLFGBzBd2CDvXGGId7gK9Yvf1RTBzOPTcjdSyn3W8bmzxjGxzh9sT7lLuPmG9Q9RPjbO7mHgUO6MY4g+qUHlDf8Z9OAKE3L//gp0uTN7KrbiYaeJ/0Ek3NN4ylW/i/AF0Z9v9kSqxfy1Lv7xnEzTPq/jwernXAs3GQzdqQ/bVD0CYlwoYu7I01QZZM4QXp8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(316002)(186003)(558084003)(9686003)(33656002)(86362001)(55016002)(7696005)(71200400001)(6506007)(54906003)(4326008)(8676002)(19618925003)(26005)(64756008)(2906002)(66446008)(66476007)(66946007)(66556008)(76116006)(91956017)(4270600006)(8936002)(52536014)(5660300002)(478600001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nmP5DViED8S2qBASR+ShfQU+yBGExQ4dSUVX/2j5nbbtlRE/ZcUeeF8ghsUM?=
 =?us-ascii?Q?SU87UBeD1GubbH3LmtBmyiO7kDLP1UFHG5Sag3ni3cqZyNohUDBt0ugzbiKv?=
 =?us-ascii?Q?gUtFLj+0RTyHR36ciBzy1QgjTmdOoeqEiT4eNwAHvkbGEzqfpPks4v2nigT9?=
 =?us-ascii?Q?1k02Ez4z08u9oMIqqwDPlSHoLZXGkgYgb8p3uofntJWlvtDPJILrgmDCJL3r?=
 =?us-ascii?Q?pcZCz82pMfiNJKeBJarH10KvLu9vCd/lR9Ixflea2pDqIzdMrLqs5Buwffg4?=
 =?us-ascii?Q?TVCN2fB4tOLe2Ut3QNRriEjUpFCOIepj7vdbj7SLjYtldC42ZUfCBQsPGaDC?=
 =?us-ascii?Q?BZr6BMerA2xgfhUigobe815cqTS7l6x7an30zhKiC5p6bw3YtPoOssAtoDk6?=
 =?us-ascii?Q?o1NRhA/L/EhUMvHX5VjoU/TRKtXs54sIZwn/o0F0bDbkHzg1xaK3nIJyLfvt?=
 =?us-ascii?Q?FAg1VJrgmsB9ugpTCVrpW6mLr8ZCmtVmiHpPMCK/JlR5DzAp5gMjNQ9MlvnH?=
 =?us-ascii?Q?QFpENoIgozmLz7t8KUbu7qule6OJxqHSxK3ndvKTIJBrlmiQLCbWDWCT3ng4?=
 =?us-ascii?Q?K88DZ33zVzmDzn6VHyvnAfdDlrb5vOJF4WJvtoXGBqFwy6IxxVILKHxIR3PT?=
 =?us-ascii?Q?Vuuq0mbl3G9A5xr4VqgN5KjFmACNNBb2nqBAMtKo+VI6tq8v2wA98ZFOOcLy?=
 =?us-ascii?Q?WAA8iYbnyFPubP618vwjoX8VEvR3hiKQdbfE/0f/ZT20V3f8I5mqmPoj4TBg?=
 =?us-ascii?Q?zYNVE46sfJF4iNl9WYVEq/yYDTsXHqidWnyWs7qVFpbOL0UmWarWCrjE76lx?=
 =?us-ascii?Q?x0FF/Is605PMZmkFH/ozxqnPvDW/KmTBfVcDjlvRugjzJVnlLDQYsUoqtGyI?=
 =?us-ascii?Q?lgqYDBURMSv47b3BD29Lqe0WNZ0XxK4x1myJ0+eHV39bgyvIwIZZVH23n6xs?=
 =?us-ascii?Q?BNM0OlSo94PqN/oqBqPsz1US2tFn9fLPqlddLJfTe5r5OdqpRMUj33V5L/lB?=
 =?us-ascii?Q?zlmL3E/sZp0FZjIouOQeUyx6CeQ0awWPKoLSj12D14VsjbGWFvQ0DDGvvMMK?=
 =?us-ascii?Q?v1+RlGvpRsjLPS/kIkc3pIdbnEufaA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0b0ed4-eb82-4960-cdaa-08d8c381fc4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 11:43:52.3384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Py3OclO6hVIpDqtuAc8y7OcYbu1A9MDBVRwm7nL4qpqhE5DYrrgzgIhAXyxSAWLUbAzus2uJ5yXLT04PKLa68xgTxN3+wVcowO4gE+0NWO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3597
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
