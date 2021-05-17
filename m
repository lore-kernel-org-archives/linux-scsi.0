Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B775C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 10:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E148961184
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 10:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhEQKTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 06:19:38 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:5615 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbhEQKTh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 06:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621246700; x=1652782700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5XSlhais9lWLZ/neaZGlTkDerpEtGfIPRw74hBKtU9Y=;
  b=HdPb819jSUeSh3iUHs05kLIhsUjXNRCLtp+klYCv4Ryc7RwFH207XnOs
   HdrQS7MVnnZDtF3D3b/Jlmi2cqsF7rY1DFFhWHp3s5rL8hmB9MzKPMX4T
   pwNm+7KYSDdebqrirgf2vkymg+gK0AA6bMIQEaAvQQs6Bz7RRAOowarVg
   /bKw/fyEmViDIHwQKdHjPZEviNwEbVF1GrhKAJCoW0WU21EuqVZ26qJtf
   JEmCOHRBv5HTo0WPAR+dv9cTNck0M4jM4K3POQ9ycp3LsmHGAQiKbOtLO
   2TZOZWo9/jJqsLvVoxDraTVdufjxIWbs30ZlVu9bkkep1xRyXVEOBiKXJ
   Q==;
IronPort-SDR: Sn/P/3ebpMU3t3Xbr/DLMpZlkxyyySchnKgokux7YZ4nERETx9CpbImzdsqNhGYxxFvdT5raRa
 W8qvF+NFmjDfUrJAvQZbbyBRiK+ZbU0UqIGstTBaYgK83518KPwaEN4xjTktUiKcMOhfLKA7xw
 2atXAFSzV4JEVRjB9WU8PS68gqij/hUvrKfkJkPZEVrMs6s2XbpfIDf2L9XIN3rrWfvqA1Qlg7
 FH6Ixbrj3wYlO0/W5lWa+dJtbqKSCwBPoSM7n0lYRsbjnukWXRRacqPzunBQok3IquSzFlWQdc
 XnI=
X-IronPort-AV: E=Sophos;i="5.82,307,1613404800"; 
   d="scan'208";a="173049289"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 17 May 2021 18:18:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6mJE04d5QYZG7j7pqFOwPphTvNQu3qnmVbS9+Ja3hGqHF23XrOYCNzG5sbcF3u9TGIb9iA/goRRbAFH7rTpjuma3hGra1xw1E7TxC1WMASmX4sVKglX2A0/Zkg19qiePrGyr3trpP0fZX+lBxdvxHKs8ge/C5W/+7JD3Yatr6dsvG9KwHgFv00kDNM2u2PD5ZGfssr1lEK6lRA5rE3pk/NAf6FynGDj8To6BaNQ7dSxWj/Hlqez0cVWbyVe1XqP2MKxg+EkovKkD+RWrdsaDfVHtNCplKPfO6J/eqTJbrUVjn/4rIV0Qf5F+ed1Hj9lch3x+iyF2yl6hFyfyKNZ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPRlxd8nWfbh8my74TxKJgmhLcp0fDjdmqyn+KTFyjY=;
 b=eaYfPpowQ/uWFEcDrWap7XuyRehGa4XBaIVT5ndiyp4MK0O+NACy671P0tKmIjlxIMDyCDRwDUxRnxpTCdzx4RfgnjSguZcob3UBz82BcRaAXVlEuxdtgbbEYwzbWZwoxNdCbo/zee7z1mYtomNYGNOa7tL4KZ18ER7yqaKm+8QTguiErq3UuuIn5UEzBZ2MjDiRGKHmNc+yVqnoEp+ZVqNO+ORBZJUzYwHh+LrNHZjTRvGlDmuFJJQIwS0fv2A1jbUxqiIojP4ie7LaTxcY8oW35gSsIyoDiNfxzRR0LJSk3F4HgxYL/Ms2uLWrzN3arJou34ozNtRvNGSrbzjDXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPRlxd8nWfbh8my74TxKJgmhLcp0fDjdmqyn+KTFyjY=;
 b=FlOVBQWBEkTir6zNydfA0uD7LoFHGc022tJMmEutR7dtAGugBGJTp3LOtHTUZ1hoY4k7OlIrQdKkrHEz3LQgmSaLLVqFBnySMfj+G/0FHD1rKX5paK8xxmH2dHpHaZbIJj3CQcLf7hIPQ0ajmVRHX0PnBRZtxhsNkNSWR+G6/Hg=
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com (2603:10b6:a03:291::7)
 by BY5PR04MB6820.namprd04.prod.outlook.com (2603:10b6:a03:223::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 10:18:19 +0000
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd]) by SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd%5]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 10:18:19 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Bodo Stroesser <bostroesser@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] scsi: target: tcmu: Fix xarray RCU warning
Thread-Topic: [PATCH v2] scsi: target: tcmu: Fix xarray RCU warning
Thread-Index: AQHXSVaRzzAuyMxoz0ii8PHkjH8HQKrmS1mAgAEt4gA=
Date:   Mon, 17 May 2021 10:18:19 +0000
Message-ID: <20210517101818.7sxuceu2sxnsplc6@shindev.dhcp.fujisawa.hgst.com>
References: <20210515065006.210238-1-shinichiro.kawasaki@wdc.com>
 <c736b783-9965-2bd9-e38b-b5188b34872e@gmail.com>
In-Reply-To: <c736b783-9965-2bd9-e38b-b5188b34872e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60ba1d43-0f76-4b59-d5be-08d9191d180d
x-ms-traffictypediagnostic: BY5PR04MB6820:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB682075ED3BAA79A5C4A5D2CCED2D9@BY5PR04MB6820.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TengYoRh3YGR2Fh7FPWCOmUzYdSyHe04rfSW7C8eoBqYDrnHQuvhacxcuV2DSzIvLV9mNxWBS4sEP3iX8ljgWkmdqTXv4GsnAkWVf3JgbqUkdCZjZ1F3Rv3ThHFceEMu0jRU3e0FNtyH90aj+YQidxxDPriPnfjnrtd9nSXHGIVcWpb6F8s+TNE5nKReHylUShIzWcoxt5Na/8GULkU/O/dr8Gf6mrpowSaRXznWzdCroQzwXmdoNSmRoniE5ymv7eSMQYnfbOARPWSO5cYKZylYcrFTBXYq7fvZlIgqXZ/pvwxDBdRxPpKsBGyxF/35AmA4lNnueAytNisjSsz0ki5K+3r2yRPoFR1HsyL8AjNy9RmByJzg8z61fjnOOrjoZiCsVjCVHklO8ACPuma+Ckrps0tLBzxYkUV4HiM+O+boZXpK8ZHmy+SHSyHY7+Ls3blCdfIuilgNbDeLXiOU2+po59Z+MO+dOnSg7VqZAiiPKkkqoywxZuEeTJtv7Bp2bi59LgMyqv9awchsm2/y7mopj7UnpSt6209yE2Va/JzE88D6n68heDdxfEXQOtM3vdHlRFSTI8jcZjaOcwdHXpC6EKmeSjwaNy1lDLsGrpw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7184.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(6512007)(71200400001)(9686003)(2906002)(1076003)(26005)(83380400001)(44832011)(5660300002)(4326008)(66446008)(6506007)(64756008)(53546011)(54906003)(122000001)(316002)(38100700002)(186003)(8936002)(91956017)(76116006)(8676002)(66946007)(478600001)(66556008)(6916009)(66476007)(6486002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?K0MR3s3iTcyFvn3hFMLrspEjJLmbSxt18rFFnKT6NqrQb/mCvucWpIhxo3+G?=
 =?us-ascii?Q?sUYbEVKhtNLLKvlv98A4JCLApiVnLtQJj6/13KtFKyVDGQoCUX5MF7eBbYdT?=
 =?us-ascii?Q?ghz2gJ0IGRmB5qhq7MSn2A6XOr3OCdCRZYMa6NlGAPnO7oy1aHJI5hCxZGfn?=
 =?us-ascii?Q?odeyAUN5rqJqwhFEYHbiiolLq6ciw5JRQn4EkXeAm0+gz4vOYzLB9XPjPii/?=
 =?us-ascii?Q?bRPo/xnxL7JlM7rH6fuvLz63H3HUepILfQMJdcksqha8Cq/u7kOIq2FU5u7K?=
 =?us-ascii?Q?g3ckn/sOUnCZf4Jq8mHymniQkb4Qe+j8TjZp6hfqMOx/2ehY9YGbpHTezKCb?=
 =?us-ascii?Q?E682Tu8iNrT8RVqXKLTAhubh3HU70W32spli50a/x/7nEUzv30p+I7t/twbx?=
 =?us-ascii?Q?+PMdzse8Z1I2mq+ZTykVTGZQkxPhxUIOg/uwfSxKMpIDNEK/wHr5Gcfz3fW6?=
 =?us-ascii?Q?yst3fHnHZbJiFayE6qgllAbJ1BdMY1kh5Bk1OPFZplDEm0Pd+yt1kqrorMAt?=
 =?us-ascii?Q?ol7EpQZ0RWbXMYNBNI+dMP3h9gdgQebIbZotcyrim2SolznnupRLRdKG+lbh?=
 =?us-ascii?Q?HVn+UCe9BbXtK4xRoCRo5vL2FvruY4nXh7D6oVX1BPahQmCHvsKSFzjg1Sgw?=
 =?us-ascii?Q?5XllbXXrZXQeIEZCf+qY5+Yv9YCZU0bZgt59Y6PZkUWvURJBWEraBtq2e3Uh?=
 =?us-ascii?Q?jf0KpknBS1sFN1Q+q92DL7TzWPYlBWVmyC90F3owdgG/IIVLa92IwCyvBYae?=
 =?us-ascii?Q?wqmjMdtDy/g7yZvzajsr2M/Fe0YAHk2C6U8MUWUZHwqVootMTKcebsx67Dhk?=
 =?us-ascii?Q?vWZgMecUnEjjPICS68waM0E4vTpnWnKczS/cKYfOdGWgq+nbKHvLqej8cDV/?=
 =?us-ascii?Q?uXF4Es9ICyK1n38dqP3lz5Hw44pMlhDSMFmPWgApj+k3kx08MTBUkBb9aWTD?=
 =?us-ascii?Q?Y5cbYcAvAqO5pt3Cp5Q9b1xkFnDqB7u7ZZMpRiZ7iXtR1dKSHwDXv4qAmqbd?=
 =?us-ascii?Q?P8mkgToUy+CJ/I6aXDUpboUDLoAaCkzqBuE1joQva1d5JFg3GoAt4GVhY0rI?=
 =?us-ascii?Q?Cp5DW+3nWFvGz96Uae3x03DUNp4uSPZKNofPQeYYP67R6seYqpE20tJUwdHJ?=
 =?us-ascii?Q?YUPuAP+sDMUV9mNr6tasm7j2RsD+0a5sA7ohnAk/f3/TF3aoaUH9euhImPUv?=
 =?us-ascii?Q?FoMVL3hpwoMSP/Izyjm3cPeysz7kes5DqMxGL0S6jFS4uoWU3u8r4V9iabsW?=
 =?us-ascii?Q?aeHSFquC1821xxidDe0BRxNt6eAA0BioG7PJxqe/gZiAVHyUuWJkCSHv3b8S?=
 =?us-ascii?Q?p9E0CyI7UlvvZhZbqgAyGv1aVGhwLSW9laO2Rz7xKJIAsg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC533DCCBCEF234FA1EBB6C319801AEE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7184.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ba1d43-0f76-4b59-d5be-08d9191d180d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 10:18:19.6517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kmclX0l57T9zTQGrjPwHhsLdJuyTfphqDEnAoxvDHF4H4434mRn6uju1gwYAlPx1XQ0spjAFxUbnxpnFQ0uTeOheOmprvQGWTq5VUQhIKRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6820
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On May 16, 2021 / 18:17, Bodo Stroesser wrote:
> On 15.05.21 08:50, Shin'ichiro Kawasaki wrote:
> > Commit f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE =3D N=
 *
> > PAGE_SIZE") introduced xas_next() calls to iterate xarray elements.
> > These calls triggered the WARNING "suspicious RCU usage" at tcmu device
> > set up [1]. In the call stack of xas_next(), xas_load() was called.
> > According to its comment, this function requires "the xa_lock or the RC=
U
> > lock".
> >=20
> > To avoid the warning, guard xas_next() calls. For the small loop of
> > xas_next(), guard with the RCU lock. For the large loop of xas_next(),
> > guard with the xa_lock using xas_lock().
> >=20
> > [1]
> >=20
> > [ 1899.867091] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [ 1899.871199] WARNING: suspicious RCU usage
> > [ 1899.875310] 5.13.0-rc1+ #41 Not tainted
> > [ 1899.879222] -----------------------------
> > [ 1899.883299] include/linux/xarray.h:1182 suspicious rcu_dereference_c=
heck() usage!
> > [ 1899.890940] other info that might help us debug this:
> > [ 1899.899082] rcu_scheduler_active =3D 2, debug_locks =3D 1
> > [ 1899.905719] 3 locks held by kworker/0:1/1368:
> > [ 1899.910161]  #0: ffffa1f8c8b98738 ((wq_completion)target_submission)=
{+.+.}-{0:0}, at: process_one_work+0x1ee/0x580
> > [ 1899.920732]  #1: ffffbd7040cd7e78 ((work_completion)(&q->sq.work)){+=
.+.}-{0:0}, at: process_one_work+0x1ee/0x580
> > [ 1899.931146]  #2: ffffa1f8d1c99768 (&udev->cmdr_lock){+.+.}-{3:3}, at=
: tcmu_queue_cmd+0xea/0x160 [target_core_user]
> > [ 1899.941678] stack backtrace:
> > [ 1899.946093] CPU: 0 PID: 1368 Comm: kworker/0:1 Not tainted 5.13.0-rc=
1+ #41
> > [ 1899.953070] Hardware name: System manufacturer System Product Name/P=
RIME Z270-A, BIOS 1302 03/15/2018
> > [ 1899.962459] Workqueue: target_submission target_queued_submit_work [=
target_core_mod]
> > [ 1899.970337] Call Trace:
> > [ 1899.972839]  dump_stack+0x6d/0x89
> > [ 1899.976222]  xas_descend+0x10e/0x120
> > [ 1899.979875]  xas_load+0x39/0x50
> > [ 1899.983077]  tcmu_get_empty_blocks+0x115/0x1c0 [target_core_user]
> > [ 1899.989318]  queue_cmd_ring+0x1da/0x630 [target_core_user]
> > [ 1899.994897]  ? rcu_read_lock_sched_held+0x3f/0x70
> > [ 1899.999695]  ? trace_kmalloc+0xa6/0xd0
> > [ 1900.003501]  ? __kmalloc+0x205/0x380
> > [ 1900.007167]  tcmu_queue_cmd+0x12f/0x160 [target_core_user]
> > [ 1900.012746]  __target_execute_cmd+0x23/0xa0 [target_core_mod]
> > [ 1900.018589]  transport_generic_new_cmd+0x1f3/0x370 [target_core_mod]
> > [ 1900.025046]  transport_handle_cdb_direct+0x34/0x50 [target_core_mod]
> > [ 1900.031517]  target_queued_submit_work+0x43/0xe0 [target_core_mod]
> > [ 1900.037837]  process_one_work+0x268/0x580
> > [ 1900.041952]  ? process_one_work+0x580/0x580
> > [ 1900.046195]  worker_thread+0x55/0x3b0
> > [ 1900.049921]  ? process_one_work+0x580/0x580
> > [ 1900.054192]  kthread+0x143/0x160
> > [ 1900.057499]  ? kthread_create_worker_on_cpu+0x40/0x40
> > [ 1900.062661]  ret_from_fork+0x1f/0x30
> >=20
> > Fixes: f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE =3D N=
 * PAGE_SIZE")
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> > Changes from v1:
> > * Used xas_(un)lock() instead of rcu_read_(un)lock() for the large loop
> >=20
> >   drivers/target/target_core_user.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >=20
> > diff --git a/drivers/target/target_core_user.c b/drivers/target/target_=
core_user.c
> > index 198d25ae482a..834bd3910de8 100644
> > --- a/drivers/target/target_core_user.c
> > +++ b/drivers/target/target_core_user.c
> > @@ -516,8 +516,10 @@ static inline int tcmu_get_empty_block(struct tcmu=
_dev *udev,
> >   	dpi =3D dbi * udev->data_pages_per_blk;
> >   	/* Count the number of already allocated pages */
> >   	xas_set(&xas, dpi);
> > +	rcu_read_lock();
> >   	for (cnt =3D 0; xas_next(&xas) && cnt < page_cnt;)
> >   		cnt++;
> > +	rcu_read_unlock();
> >   	for (i =3D cnt; i < page_cnt; i++) {
> >   		/* try to get new page from the mm */
> > @@ -727,6 +729,7 @@ static inline void tcmu_copy_data(struct tcmu_dev *=
udev,
> >   			page_cnt =3D udev->data_pages_per_blk;
> >   		xas_set(&xas, dbi * udev->data_pages_per_blk);
> > +		xas_lock(&xas);
> >   		for (page_inx =3D 0; page_inx < page_cnt && data_len; page_inx++) {
> >   			page =3D xas_next(&xas);
> > @@ -763,6 +766,7 @@ static inline void tcmu_copy_data(struct tcmu_dev *=
udev,
> >   			if (direction =3D=3D TCMU_SG_TO_DATA_AREA)
> >   				flush_dcache_page(page);
> >   		}
> > +		xas_unlock(&xas);
> >   	}
> >   }
> >=20
>=20
> Thank you for v2 patch.
>=20
> May I ask you to put xas_lock before the big outer "while" loop and the
> xas_unlock behind it? Since we hold the cmdr_lock mutex when calling
> tcmu_copy_data, it doesn't harm to hold xas lock for duration of entire
> data copy. So let's take the lock once before starting the loop and
> release it after data copy is done. That saves some cpu cycles if
> data consists of multiple data blocks.

Okay, less lock/unlock sounds better. Will send v3.

--=20
Best Regards,
Shin'ichiro Kawasaki=
