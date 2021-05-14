Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52680C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 12:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F951613D6
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 12:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbhENMda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 08:33:30 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43637 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbhENMda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 08:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620995540; x=1652531540;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IXhiVzlzBA6eUvghfYCp1Nd8em84bfUkrLrwcJz3+Mo=;
  b=cW+oSGJJZhMRr3DRCLTX+F2VwDJTi5aOPLIGE/ObVUGKHAqei6Wz/W5h
   SVA0sh0MwnySwEwkYGuXeTi4tQGAeAXTyqnEVip3Wo8+Sh0zyn6TF9+7u
   IZQm6DlZNpaLcsms0yBtzZtcdR9oGEib7fYUJQEgVtvph6miXWvE7URDu
   Vcyq6VwDHcA+j99qsMLOlpqM02UxJRlUWh3CDxb5qxNayygfms7QPANyF
   VyeS/r3iJMIC71XbcC1DWoGG9azlax9WwzbR1ogwcaFdlUJLzP508n2UJ
   4xeo792WMYZuTltwo3rDfIWqV3gINW4T+22VtDqUkyJX95L2JiZVBCYMI
   Q==;
IronPort-SDR: FNfZT9K5M5czkF4FVVlzxo2+r+9b+73p4uQ6f4MEEhov6aNk1NA5D7OzsVmvu2yH8hOtyRceia
 gvvyLd28KVblIiuCp2r7CVT4L6kB/QhPGEygAax7kYZT/BhX0pwCslfYzjyXqSGPlfn16gikJl
 Hh6aoee2vkMaDBw7vVt/enUAyVSTrqHpJgdCuspc9qfULsMqRmdtRSgkXek49Rw6k5M6AtZBso
 nbrjX4wpvig4s3JayWCSTOAUX9+CEKL11oMW9JOSEls7VQDLfy1U0NDsMvD2CZnXnLSW2f+y+y
 BIQ=
X-IronPort-AV: E=Sophos;i="5.82,299,1613404800"; 
   d="scan'208";a="168743432"
Received: from mail-bn8nam08lp2041.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 20:32:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9OV8uPKvsyPjDMDZXW6HXdInkpLiOwC3oomviFXs2Lla1eWYNwDnKAOpx1DK+pF0mmVr9+8gOE5y7XxFx4mcZBh+YZOslbyp6dLcUFhfLon3ekdOTgeGSS836R7MwaRbCoIxMlb10xtKcGddyQKxwiLZsXachDK/j3+3V0pwkjpswUmtxYyUJPsD/6pgtNFbxpwJDdO5HEmOoNJ90ImQl/seKpD+TAhiTLm0FRwkE4Ci0j6Py1nT74YFMhCrYAPBJbtv13QvSpursy8ke2kbQIb8uJl3HmDgwVG/k7m5lYU0ArbtuZj3KNn8z5dtGCz7ajANe6w+QGfvjrijhGEfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNxjWfT2087dYOvrqI7Dsgm/H45EMNgLDpcSjZQl8rg=;
 b=JUY4v88kAGxC9voMCbY4PunJJWXrltmEiqT+f0WEVZD78NlmhmB3qShbvR6VUM2Em4JEQZrkMapg6tWkI640U0j7ADatJOnsmy4R5lt1dSGTyin6Awz4XsTSpD08FDN3euOZ3rbEGTbdsqqZsfDLGp1gNT7GleXf1vkwELzdrWMKT9hamSWd6gmVZzl7r3MGMqR2UgytW0jy8EU1oZIvTm+btYgsXXPRo45j7Esn/TjIqe5OeRrXMMt6m7+OjiDLjbyq1LxvsMY8/eVeTWG2d/+6WHL+ntw9J3wqEpuMvjqBPyJAJBYLamT6FboVSt50FY31MITuOpZDV9sHBrMX5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNxjWfT2087dYOvrqI7Dsgm/H45EMNgLDpcSjZQl8rg=;
 b=hyFaNhQXeia+lyYAHRpD5HBhc8icstdUfCla+nmir2ZKACM4uqTvm1TKm9YwP/dT56yV0TBp77MFWnpMmAcMzb0+FRW58HRFqvmTv+6jfoAcXeGoiKnKUi3KF+ii1uYFsvY/n8X1MPUn7KeWAjrLyJ0pAlaG+uBUVH5BDX1lINY=
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com (2603:10b6:a03:291::7)
 by BY5PR04MB6405.namprd04.prod.outlook.com (2603:10b6:a03:1ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Fri, 14 May
 2021 12:32:16 +0000
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd]) by SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd%5]) with mapi id 15.20.4129.028; Fri, 14 May 2021
 12:32:16 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Bodo Stroesser <bostroesser@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] scsi: target: tcmu: Fix xarray RCU warning
Thread-Topic: [PATCH] scsi: target: tcmu: Fix xarray RCU warning
Thread-Index: AQHXR7EipmBTW+x8Bkmt28XsmxnY0qritZgAgAA1XYA=
Date:   Fri, 14 May 2021 12:32:16 +0000
Message-ID: <20210514123215.enrmwjsf23ejqsyx@shindev.dhcp.fujisawa.hgst.com>
References: <20210513043329.1571849-1-shinichiro.kawasaki@wdc.com>
 <8370eeda-c009-c030-77b8-aac72c915cde@gmail.com>
In-Reply-To: <8370eeda-c009-c030-77b8-aac72c915cde@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f1431a4-8026-4f59-1ddc-08d916d44f04
x-ms-traffictypediagnostic: BY5PR04MB6405:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB64059C364423508937DA678BED509@BY5PR04MB6405.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DmkzD2Y8dcWHuZhBJlj3oOWfpAx1hXx17dmhigw/CYbXSasu2BDoEiZy0gXTKobMsSgCg1bVMBC/JH1g/9UbS4rZWYXxEfB9/nO3y+xyPamqv7mDH70B0O1/WeG6rEyF9SCEXr0CjpiQjCceEwjxHM7oJQ0Exw98eR9h7zZdH0yilEvmSVMohXIz8q5WeHMjzuUKppKJXwsL8GOwlzvTtY5MIb2k0c3UeY1BPDLAPt0Vqiqa9IDOG6g2lN/l/7UKJa7o9+CZNRaoC1H11m4Te9jNsIkldcq+3Ws4JV3p+Du2ycRwKnOLppIzXeUdc2iwkfQsjQde3jw/1jV7ozR+dD9vgC0e+FmyrzDTgItHWP54mV57xh8Q4issNr74fIjJqvmudK2Hd9hgt1zmMQFryr788hmhwfjtr7PPbzUWxmyI2H/zr+Fvli1zdi3o94Zgwn2xrWlh0rQVnYo4gFk7gDLWNUpiD1BaX/PgZDn1kc2d47XiB1vW8tesj/jVpxqE4hKKO8/jkSoe4t2xzdVrjfC77O/Sikuh5L+3ILZs2c93lnEn29MRXxfulgbQecsgHvYi7CXUb1nYN3CLqcsQ757JmkHYCAjKXhHCiYkf9bo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7184.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(71200400001)(8676002)(8936002)(83380400001)(4326008)(44832011)(2906002)(86362001)(186003)(1076003)(26005)(6486002)(64756008)(53546011)(66476007)(478600001)(66556008)(122000001)(6916009)(54906003)(6506007)(38100700002)(316002)(5660300002)(66446008)(91956017)(9686003)(6512007)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tlRkCdGbZBL5LdHriIZhn0zuPMTU+0rtog+bN5n3lD4Ohgcz2w2pbKG2CJNn?=
 =?us-ascii?Q?ObW6m3dFUMxYbrPm6SEBx2Q29189jXoc//TLhdwKwuFCr26nqwnGZncGEmye?=
 =?us-ascii?Q?2bq/NeRvpQ/etBYxWc1ScScwavkljc2M5F3quXo0avBAxoFOZ4u6lJ/VXMZo?=
 =?us-ascii?Q?23om6IKIITFaxhYpyzo9C9xCM37tcv2NKCNiV4V27Qot3KY5TVVoB/cugUoB?=
 =?us-ascii?Q?2LW7EFUcbceCxwSXNjdsK6zPQ5omXYJDAyUXxPQOfB5TK0dsbcgBWUtTdHQu?=
 =?us-ascii?Q?GK8QrX5VIWahbH0jy4aBuu5eOguNaV1Uyuby9lpRPjFsBRD6IJTef4rQgotK?=
 =?us-ascii?Q?B7DEyg5f/xuvg6a/tbkqIx1K+n0Ocle71PazjpacEHVEg9VZ6hqMqTFLT64H?=
 =?us-ascii?Q?SrB1MDxPt4It3+pJ2jYRHc/KOIlkhkzS01ze3lOGEeX1Jb673E62FkKf6bXf?=
 =?us-ascii?Q?Ld1JcxkeFqrhWHyap+ptRwrEwcXqY1yAzy6vd4pbfNCn36foKWYja1YJzem7?=
 =?us-ascii?Q?HsAGXExRhZ/Is2ZjP7fAHaCKIJBfFBTTG2+rtsX7xRpNfjZEkrvsiTUpzxp4?=
 =?us-ascii?Q?ia79iFh7vWr/0IfFENuHBdf+NpuBdpebV+1unddO+aWXRf0+hzympJianXVU?=
 =?us-ascii?Q?vDY+c60vFpKgy2F9hk0VW26UaU3Ii5kZl2Oi43hGfIDG7d+jgSs/7aVg8kkO?=
 =?us-ascii?Q?Smg4rpKJQXi8HauYcxrTg8KkV2KBS1kGrZU4UC6DZR1aAFFIKVrZWm70Zeqo?=
 =?us-ascii?Q?0Vn+Xo4Lj3TVGw+5/k5+lZ9vDrJWVJKY7fjfKcXIatWmKR4iEeOEQQoKLOJ3?=
 =?us-ascii?Q?XAID45WyOm5QDGgfMMFbwYQXYYFjGPW88zgQlyDPj4uc/JFw95p6a5/TodwR?=
 =?us-ascii?Q?/hnk95zR0K6NwZOsflctVnDB/c5OV8sckbd9MfRrSH9QZKpoTXd23p5TYIUR?=
 =?us-ascii?Q?38nqPvosDfCVZZLm2LINW063IjlG3K9NsuNgzP50CxtYobv3atG6hudnMQsE?=
 =?us-ascii?Q?I21weA+jCtS1TqHX0VR9mzuHyo11zhIbYD3Lkx1WXYd9x8BaJb33aLCtdiez?=
 =?us-ascii?Q?7+BgQXyOF7LI+nADQ34Imqe09bpyxAmkqy6RartDxku2G7bxRcPa0dwnqsWX?=
 =?us-ascii?Q?87gCAaUS7e7FVlRzZeTH3G603IIqJu/+6fftIaILs01mY7ckhiPEpIiUSdHS?=
 =?us-ascii?Q?t5reXTMAbJnl71rBs7QEf7V99xlIv28EYT8BpYhjuDGBvsehwyJmva67gq0R?=
 =?us-ascii?Q?WGgde3RxPxz94yGIISKhQAX6SXGFyoFctthmRvfy+I5fzITUQWC4fZGOMkk+?=
 =?us-ascii?Q?ei4m2Anc3S3MeoaRsqY2/j+QMH/KlQjNSi+6lPof50EpPg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8217B88F1FB3374386187BD57E3EBBC1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7184.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1431a4-8026-4f59-1ddc-08d916d44f04
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 12:32:16.2381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0/VFmaZ8vdu/t3qVjLT6h/SCmU9BzD0SoVY0HGBh3KD+RO4XMgdxpAyCCxjqiyOhR77808WCNB5Y2XzlBCcULEUSTqHBAe0LSfiA1zbD4zg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6405
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On May 14, 2021 / 11:21, Bodo Stroesser wrote:
> On 13.05.21 06:33, Shin'ichiro Kawasaki wrote:
> > Commit f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE =3D N=
 *
> > PAGE_SIZE") introduced xas_next() calls to iterate xarray elements.
> > These calls triggered the WARNING "suspicious RCU usage" at tcmu device
> > set up [1]. In the call stack of xas_next(), xas_load() was called.
> > According to its comment, this function requires "the xa_lock or the RC=
U
> > lock".
> >=20
> > To avoid the warning, guard xas_next() calls with the RCU lock, adding
> > rcu_read_lock() and rcu_read_unlock().
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
> >   drivers/target/target_core_user.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >=20
> > diff --git a/drivers/target/target_core_user.c b/drivers/target/target_=
core_user.c
> > index 198d25ae482a..8be0f40ffa2b 100644
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
> > +		rcu_read_lock();
> >   		for (page_inx =3D 0; page_inx < page_cnt && data_len; page_inx++) {
> >   			page =3D xas_next(&xas);
> > @@ -763,6 +766,7 @@ static inline void tcmu_copy_data(struct tcmu_dev *=
udev,
> >   			if (direction =3D=3D TCMU_SG_TO_DATA_AREA)
> >   				flush_dcache_page(page);
> >   		}
> > +		rcu_read_unlock();
> >   	}
> >   }
> >=20
>=20
> Thank you for catching and fixing this.
>=20
> Regarding 2nd and 3rd hunk, I'm not sure using rcu_read_(un)lock is a
> good choice. From a pure technical point of view, the missing RCU locks
> are not a problem, since all all accesses to the xarray are protected by
> the cmdr_lock mutex. If we now do rcu_read_lock() this might disable
> preemtion for the duration of copying a complete data block, which might
> be multiple MB worst case.
>=20
> Therefore I think it would be better to add xas_(un)lock(&xas) before
> and after the big while loop in tcmu_copy_data. Because we already hold
> the cmdr_lock mutex, we know we will always immediately get the lock.
> It will not disable preemption, but it will make the RCU warning
> disappear.

Thanks for the considerations. I agree to use xas_(un)lock(&xas) instead
of rcu_read_(un)lock() for the 2nd and 3rd hunks. Will post v2.

--=20
Best Regards,
Shin'ichiro Kawasaki=
