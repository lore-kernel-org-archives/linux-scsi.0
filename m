Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A589FC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 04:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89F3560241
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 04:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhHQEHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 00:07:13 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:18879 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhHQEHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 00:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629173200; x=1660709200;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=61IfAiWL8FlvsMgAbcyuFBk8xoNFA18+A+i5q1wjS6c=;
  b=JC/cpOkROCtpK1VZR+k63OOG42fJD+AFkwvrdWiGDXg+gCElFvMnySLp
   YNdVZKsqg+Krr7q8bRQbt9PHvRm8IUp6Lu0F29ijUaHjxOF3w2t8hLR60
   qC1wEj3HHotTO1l0zQIwiEItS89K7rj4R3HsfONRDXwr1cF4JGqOUikTi
   NEUlBadyeLkNVHIadwZ60Bmnj2ZspTbGVJ/QfLQw8pOSLLKGsq7HvSztf
   uETi25ACVe+OGgQfG2AcGEN0atscCj3ETPbNuSBUpDd6hhO4WZmCBk8OG
   oQhOTn311aX1lOShQTVXMaZ4aEeAWZtBSptO39EX/FmnCcNDP49j5jaFb
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,327,1620662400"; 
   d="scan'208";a="289048731"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 17 Aug 2021 12:06:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwktI7jHwAUkt6IZsCntqkI8LfyBEN5LhCI0B27p7vrZa8cLLTkt9+qvNsvpNpme1QqnTqDTXqjzq9SAEp1uYwAexalJ6TkH6eBAMDwDcjfyAP7qMJWDQtbsK1Rv5qfIX12yyZzxZs9Vtydd6TQQgXNHI14/LtugqPK2kSc5Z7HqfLoeyGbujMZP2sq/FOw8gNJpmEn/vTW1V3OEUZhDJ1gXdmUiVr0A/9sLwkIBSJRwaetvmFVLzPrRxVMuSAMDyEmkZoX8gjwg26qx3axaYNUVRwvZYFYEEkGZ/aldHbe9PtMN2olu0AkNHc7UKCXgg7f9tmx00qbPo6fSsH+ksQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61IfAiWL8FlvsMgAbcyuFBk8xoNFA18+A+i5q1wjS6c=;
 b=ajCT8+9VUpVwZgK929+3rmEYX+cr2ete4XuhohAGjNuH+h6Q+bDL8nJUtGJg0JSWM5YhR/rOB6HXMbXTasjzK0FyKeM97vPPi2y4okaG76zLalGXNPEZ1r8JjDoE/ft9lFTcCfYLics4qRabmcd/4OCjT1WdOcV4zcq4oPYz1bLNbJn9ylSRG8nTS8fGT6PD9JSHfFTgT8hwLFfdN6/k4yaZJRHJwU7mLwFoRiOaeNnpmYL6fR9okQqM6uOD+ytg73pap0UxOp5w3eq9RlDra1QtgBgaxdsAJdtXj68TBKlGoVAa/Wdgb0UTxIsnRmGWWXavmpuu5glMEEAKY7lbCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61IfAiWL8FlvsMgAbcyuFBk8xoNFA18+A+i5q1wjS6c=;
 b=FKrjnEUYLN/BUXiYat7RQuOiJZj3thwLfLUOFI+VPMetv35TJMntonsI3O750e/wD/yuNMpERmm1e0eELjVkBWIdnU28PoEGPKb6iuAWNAMaMvX20Qtc2aaUqF+3GJXlDqlBGYZibaDhYBlto/fwagwPpBE9pD/3M9NDfDkJULo=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5564.namprd04.prod.outlook.com (2603:10b6:5:12a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 04:06:39 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 04:06:39 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXj060+x8p8fG9EkmgObG6vBUOOw==
Date:   Tue, 17 Aug 2021 04:06:38 +0000
Message-ID: <DM6PR04MB708184B4EB9A1C98C2EC3962E7FE9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
 <a968069d-07df-396e-8ac6-04dfe3ee3040@kernel.dk>
 <yq1r1eyshs3.fsf@ca-mkp.ca.oracle.com>
 <743ace9d-2d10-f903-aa7f-cae3fbd1872f@kernel.dk>
 <DM6PR04MB708184CD5F221364BFCFDF47E7FA9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq135r9qpr5.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 905ba1db-a17e-4804-3752-08d9613469c7
x-ms-traffictypediagnostic: DM6PR04MB5564:
x-microsoft-antispam-prvs: <DM6PR04MB556468F2410F46B183607854E7FE9@DM6PR04MB5564.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: by4KJbYQsf0TUjYw4yP3FDze7F+J+P15H3vGSIplM27EmORN3KwvBKI7RVK2PPUCfPRta7DaiecSk+EEZ56d8KuG0Jrg0L/xEoGuCWmTndJTyceCaw3pufy0YIE87Eq62kWDgFv6+j6Z7T5dNnIUDORV0hUeCfnkPwDazD667MBLvjA4qqYi7Uxn+EHDHEp23wrHlm970jX/YwJwtIgpugfT/03lHOgm+Vd6uua4hNkXxn/hr/L9YDOtMNMjc/8FuxtknH5iwpl0Fiu+ZOIkf34Rp4mMjuEAQBTN1PdWqmP8e7xzTvqvcCl1h93ctEAmGcdoN9W4e41+f6DqnOAl4kIDB+VPRas0+iz8Emyj7NxVc38drH+amlwOO/Mo5I4tqTanU+L6oqw6RrXKgtk+UU9lsxPCi/zJK8zNcKVrAovq30irnnC28xlnBBl0xnmuPYSB+UJk0+Z7fiKEhWIod0RfXqFOHbgLqwfqgvgVmRVyh+UrvqR4v04SFl1LotpgRAGW/tyiGfy4nTgTX00WFymZhYtK4TKxmyuE0HUXb7cWZA14TwFik9Vy9US23bMkuev1UC561U7YzfQiasTiJMH8/hcbU2eJLWydWDFHHmEv1c9+ayevU2Lt64WrIO4vrCwRHlAQcHu9dLtKe98omd8gX5A4/QCt0hoI0yS/J5O8Gc49xZp1Fp6UU7r9LMS3BqJV+QuITlEy/CFXNhGVmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(52536014)(6506007)(2906002)(9686003)(86362001)(7696005)(55016002)(54906003)(53546011)(6916009)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(316002)(478600001)(71200400001)(38100700002)(4326008)(186003)(122000001)(91956017)(76116006)(33656002)(8936002)(4744005)(38070700005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BENB+S5SVyGa923PjJEatB37/VepKL2l09k3xz8DLrZ/2HYI1ZA+QWUnoqf7?=
 =?us-ascii?Q?/65SQiQAizfvDGQhURO6Ez3kb0SM9Q1IFGFrJNiyLuz062zgfJOEv+RdCnQa?=
 =?us-ascii?Q?Aba1P7xeIspS1eg6DcmwhYPaMlHV+ZTBEKoD0kaQUhpV5qPx6FQU9U+peRPu?=
 =?us-ascii?Q?3Y26rnV+NyY/l8ihMxWR+4BbqozA2CTuS8TCS/mqIvxvylakTYk+nKop8yrJ?=
 =?us-ascii?Q?W8UmuTKAMhuHSuz9G0V6kw9EdUdgjJd0lGfuY+a8UgW9rnBiDY9EadluxrIx?=
 =?us-ascii?Q?es076VaZx86bWJZx01kkxLOtL7LiXKJ+LMExElLHcDq5EPdJrPm2nuSZUwFv?=
 =?us-ascii?Q?qYPIMsVguW638XTzM2f0IAE7hQZbDSjsC1xap0SO8KwpE0KZBcfVwRJCima8?=
 =?us-ascii?Q?e3uo+bjefi6/ORhsH/st7aVS2iay42m+is07OP4hsL13uUcAmDMHZw1/aIX9?=
 =?us-ascii?Q?Olt1IJp1/rsvQifNBDWfu3l93gtfiFgCwbX5nxJvJW2cT6v2N1ls9X+0AW22?=
 =?us-ascii?Q?bQkU1v4j0Ra9JSvIC51hcqkKcJ/rKVULH9mEY5wb4MCPgloZM3l/MCwoxJXZ?=
 =?us-ascii?Q?GB0a9jDMfQxiS6gfK1cKx8KDZUjcOGYbob+vmVTS9r3iLiwfDfoKOHqFmMNZ?=
 =?us-ascii?Q?r7ePn/mntF6jLueOWpychblyu0QwP5tG6XPNx6Kb4Tmol1YPnJjwc4r08QTo?=
 =?us-ascii?Q?eMcGr3u1lanSWKZxeQcNBUsqCLyBqIavrrq1J7g+VjrkZNQFoG9HGclyYAqX?=
 =?us-ascii?Q?p19YDDQjTCPXUBvX3744+PlPfgYM92HuZ4brdSTm8t2fOluRAmF0OdMu/f5W?=
 =?us-ascii?Q?pBrfXSAsLR5jJViHnqp3QQUOe/bx6jJ7JdcpRzeXjgrhxP8o9uKZzEpHiYXq?=
 =?us-ascii?Q?nCSyee7mFmgYBWR12LQtVK8HMFRw6Kq0DwAnx8h7YMmKDm12a2cEIFnWXSrE?=
 =?us-ascii?Q?stDRyVU+BqZUv0syQGxOAgx0h3V6qIgpt/+067VCL3iFvgKg6af55022NmEy?=
 =?us-ascii?Q?gw6Tl4HQsBiRqn+62Pu3UMT7XYVDo0Jd+JQyWAxgijuETVtp7SAG5GRIn8U5?=
 =?us-ascii?Q?UO7ccfDvupW3xrSYUeYevsAnXS/cyCkp/UiqUIZCsB/Yqtu8jr+wJHnFq1Xf?=
 =?us-ascii?Q?p6uY7h1cWyVfwmob3QafMRBnk853pwnQuZZxS1Ej0HuKCd+lyjh+Y/PJJuxt?=
 =?us-ascii?Q?qq6kq3SdFraHpGEQKRo4Zxbr0peNofcahR+sMoJQhFMdWkEUQQ+jbqp5MWh7?=
 =?us-ascii?Q?5pC8gHO66TCdurBE9a+YDUjPDZH1EYd5J8IVjbL2qVRjiCcNCW1bKjjIl8NI?=
 =?us-ascii?Q?RD6KZntUj5+4zgz2PA5G5NUP8Lx926afUm9VZUsYLw63hCwvYSeenU+VgSb7?=
 =?us-ascii?Q?+G4ygD9GKmIU0mC6TViNaDmYD+uOKnO4g5dh/KfTrFVpQs9q3w=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 905ba1db-a17e-4804-3752-08d9613469c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 04:06:38.9547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FGF6DE8WjbNr+UsLQ7OWmIbPYcav8iQjCv0+BNf847puc9g+a20Yt/6rRiDtG58s2Nqk4neQ4sn+UtgHGcPxxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5564
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/17 2:12, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> Without patch 1, patch 2 will cause compilation errors=0A=
>> (disk_alloc_cranges() and disk_register_cranges() will be=0A=
>> undefined). So may be both patch 1 & 2 should got through the scsi=0A=
>> tree ?=0A=
> =0A=
> The sd patch would go into -rc2.=0A=
=0A=
Makes sense. Thanks !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
