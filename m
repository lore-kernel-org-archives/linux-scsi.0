Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E16C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 12:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F312A6124C
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 12:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244151AbhERMnt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 08:43:49 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:56785 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242243AbhERMns (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 08:43:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621341778; x=1652877778;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YKddN30JnpUNSkqNni9E6UNMn2BpHbxVRuUCN1q4y+s=;
  b=f8hSid6jD99OVktC9FdY9evKvoj4tkjx9npAaIqO2q6r/+MyhehNnkW6
   pB7TI8OSjQq8b9xcEkDRl7GKhKNJtMT40M/FeBFV896K8gG3L1RKH27RT
   kcuRfJTE+UhKHrSLeSkdw86heonXvWF1m/PbKXQ/sIZPg9of8U2YEEGDw
   qG1Zlx1Qd21njgISwQDfNSRvD+zjcxWP+8qUEuZ0H95byj3dmJumiYayX
   J1+zPn4IFtdprw/Dn4wx7C2DnVhePjg9+yYtBlaoI+Ld8EGPhBiBTWtD8
   UrbmcIMttIBMB/w1DgI+YJOzYiMyQ6/NXgFdThsu5DoXxgbOFtJ7kwTLc
   Q==;
IronPort-SDR: W8LdrqqoL9hNsY/wMgJYZh5KPgiJSBDtutDm8XZUISciWTQvPNb320gvYdFV+e2bNiyuHUoM1g
 Dp+GzN/8yUsi5L0eAsNRdXXEqxAccpYHXQGSYp6oK8B5Yb+24Lcv6wWJi+YXzvy+R0lGI/tHU7
 7UV8nW7wvJUlpjHBqFpEdoVP05K8zobXVycl6pO42JGMJA81uZdo2LpDwapZjhcII2Ott4r1fU
 0whouG9Jtc7nHXDCbMb0klYnVsrKYQiyqwFmQYlK1L5WQWSDqppzg+rVcYEGixIz9KJlftbizo
 ++A=
X-IronPort-AV: E=Sophos;i="5.82,310,1613404800"; 
   d="scan'208";a="272508394"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2021 20:42:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JHRqC3pCjPBrkfYgixnTXbAVybQc6bV8x3HXz1Cd0N60ta9y9bmHCNaxpA7Y2phsCtm+BgGlksRihPR6iwUuHq/xi+2liwv1HoNAY/bu80lkWTsVVSoYTbph1a1Xel4AvL3qRW6WBetczhYNqDPCqePzAZa3Kqm82NAi3AFxXVax8k8+k3vEPxWxazHiusq6xvmIKdCFXff1qe04tNqwOBHM8TQTjS03LPTbiZkKxyPXs1cVeluPtQU3qgZTV7DHxCkFaFM/75VYXhv4rp0uSglegl4ko+vFVoxs8ffaqL46oeumopyMLvbbgYQvhEtmL+gSci+OCBf4Pj5H720Bkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zi8Oa4874lEo1c00q9rp4ATaow8IhT5EHeYV2iux/8Q=;
 b=BgPLaWmbxVp9HY7lHhLAa2VCz6hEZPd+ZdCoab5UNnX2XLG5dqbyo36hD+Ldn2xEXFr7oR80jwTqDTAGt0N/ZKCyW6PH9ICPS+hKGllMRrAbo3mLQQHJz1Lmg/DL3hBnXLmnLHYZ5MvT/fxBEQzQQUFsO9taSoj+598UdaZPwRfO956GBglLDNIvRWebgJxr7Pmfo0bTBWTsfbfzNexhIV/pnxIBd/htPRQrXEDd5KHh3I74nZRm6EertN9RdhnDwZBfIi5KLuO6ma35ZkuquAXRZvhktAubWqh5iWJLzlXmUdfbEilgEmFXhWlS76v+1jnH7EnjMw7va78PUwux2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zi8Oa4874lEo1c00q9rp4ATaow8IhT5EHeYV2iux/8Q=;
 b=hCbb4m7V2GnohYHZnZJkpBgzIDxB+E0bM/3/jsqZOIhQhCpyPvdJmKD1z6z6K+TluNetAaF9jsDJLZ5N/6FABhHDWabYrveZ9EyDgXjDDvoeNDTksbDoBIOlnQ0wLl7nNknPSpXN4ec/ktyPtZKjdq+XuylnOTx4KLIttXodpkI=
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com (2603:10b6:a03:291::7)
 by BYAPR04MB3941.namprd04.prod.outlook.com (2603:10b6:a02:ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Tue, 18 May
 2021 12:42:26 +0000
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd]) by SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd%5]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 12:42:26 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Bodo Stroesser <bostroesser@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] scsi: target: tcmu: Fix xarray RCU warning
Thread-Topic: [PATCH v2] scsi: target: tcmu: Fix xarray RCU warning
Thread-Index: AQHXSVaRzzAuyMxoz0ii8PHkjH8HQKrmS1mAgAEt4gCAADuAgIABfxmA
Date:   Tue, 18 May 2021 12:42:26 +0000
Message-ID: <20210518124225.mzkdldte2xgy7jpe@shindev.dhcp.fujisawa.hgst.com>
References: <20210515065006.210238-1-shinichiro.kawasaki@wdc.com>
 <c736b783-9965-2bd9-e38b-b5188b34872e@gmail.com>
 <20210517101818.7sxuceu2sxnsplc6@shindev.dhcp.fujisawa.hgst.com>
 <f361f937-bc9f-bd78-387d-44b8a4c5cf00@gmail.com>
In-Reply-To: <f361f937-bc9f-bd78-387d-44b8a4c5cf00@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16d710af-1e3e-4bfd-df62-08d919fa648d
x-ms-traffictypediagnostic: BYAPR04MB3941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB39410FD849E7F5DF19DAF500ED2C9@BYAPR04MB3941.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Asf1HI2sfNZ1qsZ5TsOZTPCTCrvsMixhB4WbsNqQNQB3ZjmEIOZukv5AlvyMYWAFSNWhy2Rnae08JkORejZ7KyJvcvKtnpjy0K8iN+EHYHC80PAbkaZKPd4AYzrSjU4IGzlC0EwwOfRtH11UMStJsZ2yyFneJMK2CgLVIJpsbigntNtM1BzCrZWHrcc2yZtzTR48EYBC0xj4p1505gaKOWw9mlbK6aLsqh7xmgna5SeTzL0mnSjBmlhd/a+FO9/3QmnIh76tI9LSQFGQobhODONZ7g9+FDaxLzdmbU6/B8Flh4is1YKPO4qgIXKgFw/yZy/COqMK0t8M0DTFpfyYz2nl1nX5ItsWHiRsn4RGwcQx4SaccfFpSvT2UKXyRGzj7p1GF2vdnnGAvqlfMuVKb5qx3Axn+ukzuFBpkwFGi4MpOXRf5CwT+TL5nxXwUCdaNMEL73hwnZp2/jwhPiewOJqnCajZfy74m5CinuwTjM7bGvZn6QKWuNxTCe2UdWlFaoXucgS6ZiQdm04KFn774DODwH8JnBdd2XFvXVxKdQT3VkCVc9tQD3G8aO03HCvBjQEC4Wp5I8ZrrOmPkG7q9RY5s90MripVwpwfkD9RkEk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7184.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(396003)(346002)(376002)(8936002)(71200400001)(4326008)(186003)(6486002)(478600001)(44832011)(91956017)(76116006)(54906003)(8676002)(316002)(66946007)(6916009)(66446008)(66556008)(66476007)(64756008)(2906002)(5660300002)(1076003)(53546011)(86362001)(38100700002)(26005)(6506007)(9686003)(6512007)(83380400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lquVwKnRwQipiNQevWk8MdZ/8cyvOlZJ0WjChjGHTjaiFw0B++AnfsOIPjdc?=
 =?us-ascii?Q?HjXPMM0b7Kx93nBgJ/jl7QsBEWotzy7Q/NzhrZahXo0aCLYHHCnFf39+nRVS?=
 =?us-ascii?Q?+O3cnWbLStgyngV7tUpMrMgR62t4pmbn2uC34J6dfEmafNf48n4yCpyqMb9K?=
 =?us-ascii?Q?YaFS7oK45Lf/Hcnl993+zW+MpdcrgMjCLc2ae6I2T+lKfyuilqKnIvGbw9HH?=
 =?us-ascii?Q?uN/E2+zgmbk6cvPLPbHrJn/ZmmtTV1CwfRgvyZJBk+D7HwRQ4ejTEs6GXl8a?=
 =?us-ascii?Q?dbx7HbWO50YPyMBHfuHjzoBbRizNxSTATqeJeVDDRA38tNPP9nX27aPd8b9u?=
 =?us-ascii?Q?JyB5CNErahfY/yVx7iSkbscBmqn64Cbt3xzR4X71Q+hADE8yAReB+0NLtvDN?=
 =?us-ascii?Q?vVL/55ms87VEQ63zUul/+VlolyTXSVVmEx8mRZ5ZR2OZkPnxOr82EJ8IfW3C?=
 =?us-ascii?Q?6AnRo4hf7nH/kl5yOxeJR0jG8OHuizr5kwAh/Y1wnISt/Nor8nfvem6sg5mQ?=
 =?us-ascii?Q?dKZRp9Nf1reyZEe0pYLMBRnU7fXPwma8xoPj6t2DE3wDRphANMn/sSF6vnw0?=
 =?us-ascii?Q?6k49MQdrNhexd67WrJLrlVbfUqbgfptgZttvdAQ1uDxt1dm0VSxlHw8Yo37M?=
 =?us-ascii?Q?AHTVzaqx+X39uOMUnsyYQSjw3d/LwOQ9mAMYSoCgKIeRO+Wmf6Yqy0iN6gjM?=
 =?us-ascii?Q?AWbOKY4BFsu4RJLUlBXYnlj0FqrXZ9BfND+uFjfoo6xbmQ7wRdvw8H1OY5eN?=
 =?us-ascii?Q?TZjYuAsaISumUhVs9xeVUoTnnI0XPvdW4YTL/lolDZPo4TOba4BJIsGS/1Uw?=
 =?us-ascii?Q?km7qvKCgd3HUYT/vsBJEbWs0fobkGlKlQu97cYMAZzokb6sJ0Tn7N6/Svuym?=
 =?us-ascii?Q?08rtgee3ouRdBeHC8kw8aF6Rh+AGoAzBS7Ox/GKJrMX3W4AiQwCRhzCT3uec?=
 =?us-ascii?Q?WQhlh4PuK3LQxvrw24fAouitqjbvGZnPHbnf24Tuz3hYLr6DiqUoVqftd5W9?=
 =?us-ascii?Q?XeZ6SV5f7rQ8NR4Ne2uPQz9jhbrCF+o8ldi1tJXQRRSFu6rvnp8MzAKmLG3p?=
 =?us-ascii?Q?pp7/4d2mpNpSeWKHr0R0m7JsbITmRQBgrvFyX7BoGZswqNlyLZbJcyF8JE4Q?=
 =?us-ascii?Q?fzgu8/Fioh3jIdqdHHG3I2MnDtT9GH1A3L278wogYVH498NSBKuPnq901w0+?=
 =?us-ascii?Q?ZPmL02F+xHr6VvSb271yBj6ujsUkk1hfgWCHfjEvRbpHAvnB1cU/ai3o+CSq?=
 =?us-ascii?Q?iIgf8Rbgb+stTKyePWURp/CmKTGzJEJW8D2cZWUfgnF1e/i+Zy0493YG0wp6?=
 =?us-ascii?Q?yOxXqYH0Qgw3cOIL3Ca0D34Cxh3A5eheLycaG+dMksMJnQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18FA9508AC2E734D8B3B4B9AA6E7DC48@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7184.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d710af-1e3e-4bfd-df62-08d919fa648d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2021 12:42:26.7431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zEO3G7pHtxZ2g3YHWkS1Mx1skzLA6niqZpUyuP67zTajd6DLgrykrRtgf0tAYA7lXFAzbi6FDvsO+ZF0bgS+kfFmLFHVGwgcVKHCIcXeDic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3941
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On May 17, 2021 / 15:51, Bodo Stroesser wrote:
> On 17.05.21 12:18, Shinichiro Kawasaki wrote:
> > On May 16, 2021 / 18:17, Bodo Stroesser wrote:
> > > On 15.05.21 08:50, Shin'ichiro Kawasaki wrote:
> > > > Commit f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE =
=3D N *
> > > > PAGE_SIZE") introduced xas_next() calls to iterate xarray elements.
> > > > These calls triggered the WARNING "suspicious RCU usage" at tcmu de=
vice
> > > > set up [1]. In the call stack of xas_next(), xas_load() was called.
> > > > According to its comment, this function requires "the xa_lock or th=
e RCU
> > > > lock".
> > > >=20
> > > > To avoid the warning, guard xas_next() calls. For the small loop of
> > > > xas_next(), guard with the RCU lock. For the large loop of xas_next=
(),
> > > > guard with the xa_lock using xas_lock().
> > > >=20
> > > > [1]
> > > >=20
> > > > [ 1899.867091] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > [ 1899.871199] WARNING: suspicious RCU usage
> > > > [ 1899.875310] 5.13.0-rc1+ #41 Not tainted
> > > > [ 1899.879222] -----------------------------
> > > > [ 1899.883299] include/linux/xarray.h:1182 suspicious rcu_dereferen=
ce_check() usage!
> > > > [ 1899.890940] other info that might help us debug this:
> > > > [ 1899.899082] rcu_scheduler_active =3D 2, debug_locks =3D 1
> > > > [ 1899.905719] 3 locks held by kworker/0:1/1368:
> > > > [ 1899.910161]  #0: ffffa1f8c8b98738 ((wq_completion)target_submiss=
ion){+.+.}-{0:0}, at: process_one_work+0x1ee/0x580
> > > > [ 1899.920732]  #1: ffffbd7040cd7e78 ((work_completion)(&q->sq.work=
)){+.+.}-{0:0}, at: process_one_work+0x1ee/0x580
> > > > [ 1899.931146]  #2: ffffa1f8d1c99768 (&udev->cmdr_lock){+.+.}-{3:3}=
, at: tcmu_queue_cmd+0xea/0x160 [target_core_user]
> > > > [ 1899.941678] stack backtrace:
> > > > [ 1899.946093] CPU: 0 PID: 1368 Comm: kworker/0:1 Not tainted 5.13.=
0-rc1+ #41
> > > > [ 1899.953070] Hardware name: System manufacturer System Product Na=
me/PRIME Z270-A, BIOS 1302 03/15/2018
> > > > [ 1899.962459] Workqueue: target_submission target_queued_submit_wo=
rk [target_core_mod]
> > > > [ 1899.970337] Call Trace:
> > > > [ 1899.972839]  dump_stack+0x6d/0x89
> > > > [ 1899.976222]  xas_descend+0x10e/0x120
> > > > [ 1899.979875]  xas_load+0x39/0x50
> > > > [ 1899.983077]  tcmu_get_empty_blocks+0x115/0x1c0 [target_core_user=
]
> > > > [ 1899.989318]  queue_cmd_ring+0x1da/0x630 [target_core_user]
> > > > [ 1899.994897]  ? rcu_read_lock_sched_held+0x3f/0x70
> > > > [ 1899.999695]  ? trace_kmalloc+0xa6/0xd0
> > > > [ 1900.003501]  ? __kmalloc+0x205/0x380
> > > > [ 1900.007167]  tcmu_queue_cmd+0x12f/0x160 [target_core_user]
> > > > [ 1900.012746]  __target_execute_cmd+0x23/0xa0 [target_core_mod]
> > > > [ 1900.018589]  transport_generic_new_cmd+0x1f3/0x370 [target_core_=
mod]
> > > > [ 1900.025046]  transport_handle_cdb_direct+0x34/0x50 [target_core_=
mod]
> > > > [ 1900.031517]  target_queued_submit_work+0x43/0xe0 [target_core_mo=
d]
> > > > [ 1900.037837]  process_one_work+0x268/0x580
> > > > [ 1900.041952]  ? process_one_work+0x580/0x580
> > > > [ 1900.046195]  worker_thread+0x55/0x3b0
> > > > [ 1900.049921]  ? process_one_work+0x580/0x580
> > > > [ 1900.054192]  kthread+0x143/0x160
> > > > [ 1900.057499]  ? kthread_create_worker_on_cpu+0x40/0x40
> > > > [ 1900.062661]  ret_from_fork+0x1f/0x30
> > > >=20
> > > > Fixes: f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE =
=3D N * PAGE_SIZE")
> > > > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > > > ---
> > > > Changes from v1:
> > > > * Used xas_(un)lock() instead of rcu_read_(un)lock() for the large =
loop
> > > >=20
> > > >    drivers/target/target_core_user.c | 4 ++++
> > > >    1 file changed, 4 insertions(+)
> > > >=20
> > > > diff --git a/drivers/target/target_core_user.c b/drivers/target/tar=
get_core_user.c
> > > > index 198d25ae482a..834bd3910de8 100644
> > > > --- a/drivers/target/target_core_user.c
> > > > +++ b/drivers/target/target_core_user.c
> > > > @@ -516,8 +516,10 @@ static inline int tcmu_get_empty_block(struct =
tcmu_dev *udev,
> > > >    	dpi =3D dbi * udev->data_pages_per_blk;
> > > >    	/* Count the number of already allocated pages */
> > > >    	xas_set(&xas, dpi);
> > > > +	rcu_read_lock();
> > > >    	for (cnt =3D 0; xas_next(&xas) && cnt < page_cnt;)
> > > >    		cnt++;
> > > > +	rcu_read_unlock();
> > > >    	for (i =3D cnt; i < page_cnt; i++) {
> > > >    		/* try to get new page from the mm */
> > > > @@ -727,6 +729,7 @@ static inline void tcmu_copy_data(struct tcmu_d=
ev *udev,
> > > >    			page_cnt =3D udev->data_pages_per_blk;
> > > >    		xas_set(&xas, dbi * udev->data_pages_per_blk);
> > > > +		xas_lock(&xas);
> > > >    		for (page_inx =3D 0; page_inx < page_cnt && data_len; page_inx=
++) {
> > > >    			page =3D xas_next(&xas);
> > > > @@ -763,6 +766,7 @@ static inline void tcmu_copy_data(struct tcmu_d=
ev *udev,
> > > >    			if (direction =3D=3D TCMU_SG_TO_DATA_AREA)
> > > >    				flush_dcache_page(page);
> > > >    		}
> > > > +		xas_unlock(&xas);
> > > >    	}
> > > >    }
> > > >=20
> > >=20
> > > Thank you for v2 patch.
> > >=20
> > > May I ask you to put xas_lock before the big outer "while" loop and t=
he
> > > xas_unlock behind it? Since we hold the cmdr_lock mutex when calling
> > > tcmu_copy_data, it doesn't harm to hold xas lock for duration of enti=
re
> > > data copy. So let's take the lock once before starting the loop and
> > > release it after data copy is done. That saves some cpu cycles if
> > > data consists of multiple data blocks.
> >=20
> > Okay, less lock/unlock sounds better. Will send v3.
> >=20
>=20
> Hey Shin'ichiro,
>=20
> sorry, sorry, I was wrong. I forgot that taking spinlocks also disables
> preemption. So using the spinlocks is _not_ better than rcu_read_lock.
> We end up disabling preemption for a possibly long time.

Indeed, xa_lock() is spin_lock()!

>=20
> I'm wondering, whether the change should be to go back to xa_load
> instead of XA_STATE, xas_set, xas_next. I switched to xas_* as an
> optimization. But meanwhile I think one should not use it if the loop
> is very long.
>=20
> With xa_load() the loop should look somewhat like:
>=20
> ...
>    int dpi;
> ...
>    dpi =3D dbi * udev->data_pages_per_blk;
>    for (page_inx =3D 0; page_inx < page_cnt && data_len; page_inx++, dpi+=
+) {
> 	page =3D xa_load(&udev->data_pages, dpi);
> ...
>=20
> What do you think?

This is the discussion about the balance between critical section size and
critical section entry cost, isn't it?. To make the critical sections small=
,
the RCU lock within xa_load() should be good. But it repeats RCU lock in th=
e
loop: costly. On the other hand, one shot lock for the whole loop has less =
RCU
lock cost, but has larger critical section. Though I don't have very clear =
view
about the work in the loop, it looks large and lengthy.

So my +1 is for the xa_load() approach.

--=20
Best Regards,
Shin'ichiro Kawasaki=
