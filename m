Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB50C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 02:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F121E6023D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 02:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhHRCqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 22:46:31 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:47804 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhHRCqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 22:46:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629254756; x=1660790756;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=1QIZYqvDUQIjZADl4XsDdTSvfgGB/kacw0J4Q+/XNhI=;
  b=XL1Ux/jTUpi7K5VlEldmeXG6uCZcellUfhsrPGjlSXUC7EQ2J5z8rVf2
   4tyHS0lr4Xh3EYiJTrgZqwgARvpELKMWaLYKzm/X+uDi2w+aW8OnFuAj7
   OsL993XXhMazVleNFqMyDbWiGngEBZ/mcmxmf8MeQKmFhAKrzVCZFAslx
   7ms2vh/mynXqtUWMMeAuxdmYkDbZkLc6vITKbt+8BsoOthHv+hD+r4eUY
   3O2yjQ7W2MMEAoPxUF3iGe3BEanbUDqZUwh2XYBP2xe5RxA3TSHcA1H0+
   DgCOLwCf+pBUYfJpxG2azeae93uqLxjqxUvm5sGml5zehVBeYyRL/hMMr
   g==;
X-IronPort-AV: E=Sophos;i="5.84,330,1620662400"; 
   d="scan'208";a="176758570"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 18 Aug 2021 10:45:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+ritEuT4a2J5/kElpHQpGJRsRb6+RZ4URiTXmVNxuX0S1RuNC4Me5sTEBSpBiU3ErUc9CXjrqVIqEQVYGPojLiGTOq+CmMhhJ2gyE/NM+EQ6b3+i74T3Au5fQphXLNLgH4RHsfaqNK1ln/7/MbnsRV+LoBO/aGp4EvcQEk7Lj/P+iJchvWyS9eLzrfFoQIL0/0Iv1tlcYyGglDIKYj311CcNAQ5vSqALwILdzoDS3c1dhy20aKGtxk4ydffDkQdtl2ji9JfcnBO3H6qRk4evElR2Ye4ME5y2F+et9EIRuh6B9pSmxCxrOoXW033R2wg3YGkgrW98fZZVRnEl21Giw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuJA2eUm/6/1ksslCfmGR9ew0cOqbjokA86wNwciQp4=;
 b=LtYJO0DjUQahM3RjwQnbngBFO8dh5nXlxONrHg6QPRS7/xLF0Sj7+oDM8dp7WATzkdMRCz2wPqEAwh1U2PAYA8LOCO9KG5nQ/dfjzFs+g55nbayY5Bwess4UMJBI6Fo8n+vo6t2PvxbOWn8ie/AfHY2HiD34YieFRVW/5sODAMOW6yS5fwpVOmjVbwhwakaWsU0zGdGxo2tMgCf1UIMClftA28LHyoDyhKQIbg9m00DxbnudKPZD1APFIudDcK9kEZcZIudvzuMb/cmrtY8s6FTbi6sQ0aplr8WNOEWcef0pZzuYks2clr8zHw0+TpPJ8DaJn6o5VBZG+E6KrWogpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuJA2eUm/6/1ksslCfmGR9ew0cOqbjokA86wNwciQp4=;
 b=aRQ6/j1V39uOc3QRgbTRUrEEdBRM/cI3umvnDA5dWGsU6+wZ41xgjOmxgQtafazHishQYuePk4vcEHiTOlbvk3pXPNfCPUQnUzFz5zybxtcIuw14d1BG2jdyv13I1wUWau6aX4PWhmGdTP/fpROwfT4AvqPw8O4zeUWj9aoCaOA=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4923.namprd04.prod.outlook.com (2603:10b6:5:fc::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Wed, 18 Aug
 2021 02:45:54 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 02:45:54 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXj060+x8p8fG9EkmgObG6vBUOOw==
Date:   Wed, 18 Aug 2021 02:45:54 +0000
Message-ID: <DM6PR04MB708192A9DAE8BDC018B30420E7FF9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
 <yq18s11qqfk.fsf@ca-mkp.ca.oracle.com>
 <DM6PR04MB7081F31C7933E6C50E10CBB3E7FE9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq1fsv7mrrf.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 963d11af-5b77-47ad-9196-08d961f24c90
x-ms-traffictypediagnostic: DM6PR04MB4923:
x-microsoft-antispam-prvs: <DM6PR04MB492351D7F30415C29419A49FE7FF9@DM6PR04MB4923.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ZW331xEHkHJm2vTks77N53kdV+z56OFiZpPU1JL8aDvYBm5SD6vFKHOiBPvR5TX/O9xB6x4zhAhnF3yXVIeAy2OnOCBjjIovT7nVHlI9zavYZv4R5sMVa3OgcY8P9pEKSBkf+DJw+3xWtcpkVkYGHGxDhZYLvIT1GcrfZ6wmOlYaCxTRy3OQtwMfLMQgO7FwdgEUovFKPWU7Jgrm+NZgoMIbpCkzs9rLsFI2GDkzDEf0LgNKnRGYcyJ02DtlZ/n3fBgjdIJX1dXpsEZeDcSaX8XpWDeiZlZ5kF2SrNMkFWlL2oGGC78RF85qysR943L0G2hoMxhVvpQJnOzR7aTH21Evdb3CWQUojSstO2SdS5FZzarup0rv/8dMqPfF3m6Q92R8h2uwSpeNsc1zkhXmMXKLkMvEtTM+aVCmsvh4PDurlHrcRyMVL/cniHbNMCX+6gmXDVZtG72rcR7vPxMbZTHK/vvul2YW1WZLSHhFOMgLjJdOB+c2+yQ2y3ePe7+3RpwOv6unFcMR2X+mDKDn6Csn2ejmVojXnlEvkh+HHfovRIRW/Y1NimuhX8nRPWFElTQCUWXZE/nE3l0UWBgRg1aXDOuO95MgNbMt5EAPN51jzoMaVkyqzp9C8kdkOYOZJpfBKS1OwqNg8eHSfsr8gOssR9ZvD9NQ2gph3QWQMStBVM2Utg5y/ZS0So3GaT6vtvCWq2OGSmpLi+QTPveRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(91956017)(478600001)(4326008)(6506007)(38070700005)(66946007)(53546011)(2906002)(186003)(7696005)(316002)(9686003)(76116006)(66556008)(26005)(66446008)(64756008)(66476007)(55016002)(8936002)(52536014)(5660300002)(83380400001)(8676002)(6916009)(86362001)(71200400001)(122000001)(33656002)(38100700002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vx1YqbvkHQixLhpcOm4F0JzxLaPpsiTuDfWmnAi3UGG8IX/o0vZHwKGb4fdl?=
 =?us-ascii?Q?Bbys7+cW9mxEwIwgpWST7z+RnvM+Vl+XAdTmsDMFHOBeWraMPCuG0ueB2cnu?=
 =?us-ascii?Q?1Iig8lovgKPSrXuWIGhJZNzgLQw0uP5x81XviUlQIonQO80K18uUyJR8nJ59?=
 =?us-ascii?Q?dTh/IEynNLc8G7eogH2Sg7Aus8gHb/Izx1qTjjwjgz25Uc5e3QkCmtQt95u0?=
 =?us-ascii?Q?76Gkc0cwPaVrMNolwnMfAYodOYcvukV/Qg/5tNn+aG+lCLOHTqxXAazS97Cv?=
 =?us-ascii?Q?ZroNydsB46LpuybDcArkhFwqGHUKC8TyLbnDcesJsM1tGloR3fs3qNOZOnk9?=
 =?us-ascii?Q?Q96lahcmruQ/mN0vTAmQtQN4r5QBpV3Ivqgp4ZD8jSTEXhNmSIVwKubwC1QR?=
 =?us-ascii?Q?HG2ZyY8CfRf9VBdrngcUbHI3jqLcqB8k2QFiQchkGVVtwsYGXoDSszBKnjGU?=
 =?us-ascii?Q?mflC1A+/WGdqlqWHgoyaU+MHTILUAn82EgkIO88GJ6YgJvUFNTAKpZ8+e63M?=
 =?us-ascii?Q?kWr7MI+LlLkDn8bFypXZIn2hJqzy9vIXw+Mnfth9bQGBfb20qe0IFoeYcqwj?=
 =?us-ascii?Q?jNnL//oe/QK/oViX1P45p6V5Oyh9HQ+4J1t/26mwRaT9caANgTvrlffqg1Eh?=
 =?us-ascii?Q?4OdfhmRFqyKAj1lfxP79Xnp62F/FZKP5KfG9A5y/wmeENO1qlJk7TWnVYuec?=
 =?us-ascii?Q?AeljDg66uKHuK4YuCJB3JQji1Sd9WsmVvBya8Reqxzk/iFf9dcI++I30LJ6v?=
 =?us-ascii?Q?lbLIfx98u4zpYhs8Sali7cxIlyqll2SZuKRdUQO2V8xvZk+PKHkdFO0FuFqT?=
 =?us-ascii?Q?sAPe8axJaC9VgHxSDhiy/yavVdbaCRxbKgL+ht+EkWUtCaDwmCwxJxEmwUKF?=
 =?us-ascii?Q?Wh5T28i1QEz9pi7R7Ca9rJ625l03WreFF4zPHjAd26TFbT8dXrXohLtQ+jbU?=
 =?us-ascii?Q?nXRN4WD37+LhB9vmiNFdv0M9n0AwE+BKAUz4xdOx5J3dnUXH37iIuZ83rXuA?=
 =?us-ascii?Q?KLoGt9KmWBwuAwyy9fF2bZq7Ey0s/E8xp00iilA2UYdaga5mdADvaJhgwgXG?=
 =?us-ascii?Q?x3h2AXmabgH9bTZ2bvesGAeVZ5dnWT1PfXf3l9sTCPzV0SwVTXMhRWvVqxOD?=
 =?us-ascii?Q?ALyTX1subhYY1MK4ypC33PG0JcXaKpdasesJ6jtXXXYOP1z+Ah1DRTx4XXgB?=
 =?us-ascii?Q?IvWHBDvKFT7BL1vSILz4rne4OR+yqkRdScVCG4lgTVtU42iShk+pubYk9L4D?=
 =?us-ascii?Q?C1Uv7Au+Jq/07tyOOdyr95G6YWPJMgWJhMSbqwFbrWue137EcrkwFPfT7uYf?=
 =?us-ascii?Q?QYSNpclHnkzEMqqyko8kF5W5pXvVj5+VU9CSXa+LNWAhxQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 963d11af-5b77-47ad-9196-08d961f24c90
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 02:45:54.3103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rx7HD8Wc/WcPXKOEZJo0+zLRTpBIh3XAHEGsZyNEUjLqeKGyQW8G2OOeR3kh2nhMco1Umb/K9rwUtJqs1QhMDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4923
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/18 11:24, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> With the single LUN approach, the fault domain does not really change=0A=
>> from a regular device. The typical use in case of bad heads would be=0A=
>> to replace the drive or reformat it at lower capacity with head=0A=
>> depop. That could be avoided with dm-linear on top (one DM per=0A=
>> actuator) though.=0A=
> =0A=
> I was more thinking along the lines of btrfs making sure to place=0A=
> dup metadata on different actuators or similar.=0A=
> =0A=
>> The above point led me to this informational only implementation.=0A=
>> Without optimization, we get the same as today. No changes in=0A=
>> performance and use.  Better IOPS is gain for lucky workloads=0A=
>> (typically random ones). Going forward, more reliable IOPS &=0A=
>> throughput gains are possible with some additional changes.=0A=
> =0A=
> Sure, but that means the ranges need to affect both I/O scheduling and=0A=
> data placement. We need to make sure that the data placement interface=0A=
> semantics are applicable to other types of media than multi actuator=0A=
> drives. Filesystems shouldn't have to look at different queue limits if=
=0A=
> they sit on top of dm-linear instead of sd. From an I/O scheduling=0A=
> perspective I concur that device implementation details are pertinent.=0A=
=0A=
Currently, FSes cannot know the dm-linear config. The queue crange interfac=
e can=0A=
actually unify this for split/dual actuator and dm-linear like logical disk=
s.=0A=
=0A=
I need to send patches to dm-devel for that though as currently, dm-linear =
does=0A=
not expose its config as cranges. If I recall correctly, Hannes was also=0A=
interested in playing with that too :)=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
