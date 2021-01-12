Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828B8C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DCC022CBE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbhALRlQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:41:16 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:29969 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbhALRlO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 12:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610473274; x=1642009274;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Qltq/w8iNNwRkRBFrGK73/KaGwLU1qpKTAVsaUfIqtI=;
  b=CvvMMfqbS2p81ozphdYkaX2x1UpNSZijaiZT+Dhaf8EPYeSl3xS9KOiU
   VdF5j+594rzg6Zf3Lw+MOHix8jSy3BhPFhmTxKnF44++ZKtaWZx9wBmFV
   UwqM4mYBA+qgLMMXHYsGePWZkSKDhhUGqrJP9AkCg6/SmgdBLiCoVPJIp
   5RpehisZEmlCliTRAsdI9Gkc8K33p84TphJLLh0xFVg/tzNUo7TQXJq8V
   rV9YHwCVrb8+GlCza87JT4UWu9eYxOcNvjGdbO6RZ1p42OINlstsmaTB6
   SiFfgv7heHHNIE7Hyj3yRA9vMDYKPKXuhjmrztafo8hXYWZNd1NJF49G8
   Q==;
IronPort-SDR: 6yFPfVgr/AaSPpHtAsytXFJOUfCw8AlzPc/9jmAS4MP6qEQMMsHLkROFGuk2nd6EpewQxm5qMT
 fHzwpToG0Cr9WHE/jhO5Ce0qWAW8T7a0/4iT5XCKUbVExaU1YjcVwLH4hKiuw/wR3ItBJbWYlF
 RNiYNDk3zXIDH0Gwh7mYn/P+LRnGonPV3n0s87S6prwl1Q2+UaIR5xxxrfqldGEBo6+yVdtiIH
 bKNXoBWCradmvUDiiFnzJWa+/INmltXW/43GKtphvCsakdXXeaWR9BhqsB2kDBukPk0MIWcKVi
 LMg=
X-IronPort-AV: E=Sophos;i="5.79,342,1602518400"; 
   d="scan'208";a="158436723"
Received: from mail-dm6nam08lp2043.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.43])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jan 2021 01:40:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npCI5JinFvHYP+ykr1QIk2FpdaV3KO9hGru0lpJNAlLciF0lu085tbQtPzFLEvhV7dN9t4mA/zLudb4Qjcwykiwu7WFxU0UdtEqdAsfs/j4KkLT++9VOUEZtVQ5Kx2Qx5CcJCWH5xcMHzjURoyfmVYKmvKVsVQ74a4DaWS2n0wGm/AAIyuiPhiUd0pRnFBLu4kMB3V9CrekvmezMGw3HeKO/r/XXm7+QT6B0ra0ABMr+0my4TLhMAiWB5F38NoroYIbP+i4Rrg4pg1Ca74XND0WZd4UjH9M1WYy+RmgbA9rkVKree3u60Y2ZH9oQlgSEWCBcw7s+4ZN8AgzMJmkmGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjPJ2RyiXJVJG4/rdWTgOTAhH6lhXNZObETjGqYiSW8=;
 b=n3O5Zao4I5cLY3L7snd3FbnYknP6n4brKodvMKQDAoPnnKSvFsBS2uIIargUGnFcJH5vd6BEBuEwVJioGcyltIyLhRKp6MhnLN2f8w/v1kCDSCkx6wogrXC5P5myGY4tpCZQ1wCKa9lkMJ7+Rw5jqExIb+3O+IdwuuYFcheCxlohmahmVegoiU+fbFHj0tJT0s175xEj4/2AHVIuF/c0l4KknDaukKdj19m7hCNtna+ZmYBMDDtGvwnxrE01EN+yJy0p7xvTdyhQ9X2ObeoQaCG8uXpH662Ly6zzhYfx1OoT+hTRPnqgbNzZpi75DdWh369slxmDgG94tGX38gHunQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjPJ2RyiXJVJG4/rdWTgOTAhH6lhXNZObETjGqYiSW8=;
 b=TcKcTxf73l1SLGfIQk0kfIPd5hzdMIlNAhej6EO5ruRloCga08jbz5Ie1x5s1M0md17F2JfuFvaFpUnYSiutFYNs7RrTwVXOlQO2X2NSQ6E7ZiajXpPCMHyyMHebSpTn6+iC/PlDyAXFQ4v9s2JRwfLVggRRQ3eaUBHvM2HrR4Y=
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com (2603:10b6:4:7e::15)
 by DM6PR04MB4218.namprd04.prod.outlook.com (2603:10b6:5:9e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 17:40:07 +0000
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::61b3:1707:5b14:6b59]) by DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::61b3:1707:5b14:6b59%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 17:40:07 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Joe Perches <joe@perches.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: mpt3sas: Simplify _base_display_OEMs_branding
Thread-Topic: [PATCH] scsi: mpt3sas: Simplify _base_display_OEMs_branding
Thread-Index: AQHW6Qmw275IgTBBHkaQuKGUJRLK6g==
Date:   Tue, 12 Jan 2021 17:40:07 +0000
Message-ID: <DM5PR0401MB3591D23001DAC0AFB4F11D589BAA0@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <b4a0b8c97a95f56c64532eff83289831449e2b0d.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:15c4:1c01:38c1:d5fb:3079:ba93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c5cf3b44-77a2-4dc2-5dff-08d8b7211a36
x-ms-traffictypediagnostic: DM6PR04MB4218:
x-microsoft-antispam-prvs: <DM6PR04MB4218CCCDE1E880822F34DBD69BAA0@DM6PR04MB4218.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MszP9te8CuAxItvtIbwH2Y8bS8AW3mz+a69wHgRvg67x14+77oVmhcBOFrzjVIohZu3Z6uxumZ+sbfCnMbmCn6aXkzX1gd9WhF3Xvndg7bCYJ4qh6PcwATVLiNr2qU/IKkW3PS+0BWX3eC3yuhZMt4C356mt08osBdiTQrb0bf8i69loggCxlEbGy2NWTI1Hzv0NAuMJ2UiHU2xmZBkiZWMEz9OThF0hbvAdRbFptjqRxkpf83CwL6P+GAvYJPz/IzSJaTBQwOjxvHtVZmn7i1ZUvbWNJ0XxhvZ7gt9PfwPEhxZu1AmfAkbt50BGepCummLGY7yLfYOXpeemNAHTfmYUzdMDHsXG/wp0IqSPOo93z4Eaw1nxAxItfog+hL/HSQ/ZA4Lc/UAycrLM4yOYJCFlmUv1feNy53r4UexLe8gSQwwbJb3F1T2OAbdKY3UB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR0401MB3591.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39850400004)(71200400001)(4326008)(7696005)(53546011)(8676002)(316002)(6506007)(558084003)(186003)(478600001)(9686003)(55016002)(2906002)(110136005)(54906003)(52536014)(66946007)(91956017)(66476007)(86362001)(76116006)(33656002)(66556008)(64756008)(5660300002)(66446008)(8936002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wNnWy3hlCqvEt11LHbTatmjMJ2HEwuDnQT4WOHYQzE3Yxkuu2ZuwpKF/aiUE?=
 =?us-ascii?Q?P9W1DA5VYmIP06E6j/flb41ZTonW2UYl2r1uLZqOmRHh5g1bnNc6Jdih1KhU?=
 =?us-ascii?Q?uk0s02mEJYD1jnf1ukFdNL+K4DQtFf5TYsqrD61uF4OkEHPknpjplwkE6ide?=
 =?us-ascii?Q?xHEqkqhqD12fd+InNbs3sWb3/O0OfR3dzMSQJ5PVkeyZ/JVqcEnKevasIs3m?=
 =?us-ascii?Q?bhaSQ6+XNm8VT7jm8eTazMacVfJ5nntSHww1rCLq74WBRPiPKDLxBIRvIAu8?=
 =?us-ascii?Q?6sa4PHb4uW3oUNXDjEwWnpUC39KDpm65phdLdo5WpCpN+4XgX1sh91eV35fJ?=
 =?us-ascii?Q?6l3hL5ZXSShBAsFxop4BXhSUlRBZDSTTgCNVxWAVxnoqdCd7Kk/7/FUkQmOb?=
 =?us-ascii?Q?uOzFRmRZTVbUFXRWGHjQVRHh2JvHKISKCCj0SKdAGfPr2GlKq6J3TyDrQvKB?=
 =?us-ascii?Q?8Qw6UzngDUf7GF3zYsJa1vdgynvFB9aAr+KZ36qjfWy1UUcVO8UFItnvqsxr?=
 =?us-ascii?Q?gV790MQoAA50nBW1q22TQ/CgAFMWV7cdZ4Y6PGLWwSiKi23Gj1m5QmJXYHH4?=
 =?us-ascii?Q?VzNypNOPQtSpZBTANnQ3Evz4+zESa9Q2AY9I4MOgb/XDcaH0036ATkXNureX?=
 =?us-ascii?Q?a77Iev42hHsXoXsmTqs+bAb5gGij3q6BL/ODZpgpaTKSCQlEkioIpels4E4S?=
 =?us-ascii?Q?XrKMnhIlMTfZL1ScO63bxEH46J/hIN6tQ3SBvCAINBmCal8ySB8LRVl4WizN?=
 =?us-ascii?Q?FwBsZNC9+IRxVA1l3oj+2ZD+zuIq+lv0nScG1XOOawDvJKZ9Nwwc+6PEnrnp?=
 =?us-ascii?Q?lij+PFWdz/dF/YH4vpov15gsC4IyryOhMfN9cfleZvR19PM9H4oSSF/HI3+K?=
 =?us-ascii?Q?2PpM9JmiLhUnTdIMnHkMk3ytn3ebUDKXHocStXyWaq8GqEc50oTD1kj0bqOB?=
 =?us-ascii?Q?YlDJsfmVgUOaNelr3+wUZUy3sENzIuoE1AnQ/Q19aKTSFkn4dn3cW8sFcyvZ?=
 =?us-ascii?Q?IpNO+qVK0GnCU2Wt4LomDh98HHfwpJPm771n9wBurK1xYY0zosO9I90AhFp7?=
 =?us-ascii?Q?n6psP161?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR0401MB3591.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5cf3b44-77a2-4dc2-5dff-08d8b7211a36
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 17:40:07.3500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IrnQk7FJofQCVDahzppycwNIRfM1f/olIO+qCG4cYTlbr+YXmxJuI96IEs1lvmAx/mmavb5zDGdBZYUcYN3jpFx/n9/rtHDkdjK0clXjVp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4218
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/01/2021 18:38, Joe Perches wrote:=0A=
>  static void=0A=
>  _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)=0A=
>  {=0A=
> +	const char *b =3D NULL;	/* brand */=0A=
> +	const char *v =3D NULL;	/* vendor */=0A=
=0A=
Any reason you didn't spell out brand and vendor as the variable names?=0A=
