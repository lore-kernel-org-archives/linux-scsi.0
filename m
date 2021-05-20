Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3414CC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 02:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F6F360FE3
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 02:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhETCE3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 22:04:29 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25319 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETCE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 22:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621476188; x=1653012188;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IkMDOXUmvAJi/gsqEgoMvaerXcxeVa6M22qugzlGcyU=;
  b=bBADkFSEJG8kLwb7Tp+utjG/YoHdPTaA7bA7OpLywG12NcOT9RWTi8s9
   x0SphHPiUJ9v2W4M9IBO6wyWRDL94w7zHbzu2KObrQZ1pPchV50d+89ss
   700vNaW3aV2d7jMAZ2bdvzFX/72ObH/kPXmLLwcYx33+9WP6/prMqVrnE
   hDx5eOgK4gnxowgq4v7yJV2To/IB7Ftp1vrEHUw1AgQbC3zkGs1GVogvC
   ROQ1XsxzY1Q5pM5G9Yk8HHvqFe1cGqktShkxIR4EzJ+5pwT52dW8/IDtm
   LHn2AirasMLK7WM88i8/BNAvXkTKTg74+b4K0pnbdytzV1QnHk6rfgI/M
   Q==;
IronPort-SDR: ko+/3mLoLd+uMHuyuNprtVkqRq5ftE2Y6VZHeF10Q8YWk1PR4FZMcsx4yPVDPOU5ERPY0Mau5V
 mi0Op2JbmkzOC6KH2R5Z7XifRfU0MuqGP9XWvlzAIQpkA2lkw99M6uheR3oRfuL7BX3qn1AwKc
 n70LFqrHACKDCMLrPY3pvPXD42OOW7rYqQ4md+jwhCoQHGVQOusHhRR931pE60OXGu3HbjRJwF
 KcrBUfw8iy32XNc8x+khrtwjH/Zu7rQks18CqTioTpOhPgUxVhgPTi4JdxSmxepJzWm1sSts5U
 y40=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; 
   d="scan'208";a="280027089"
Received: from mail-bn1nam07lp2048.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.48])
  by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 10:03:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAz+uN9qaMYhQdLMeoAFkvB0VZLp22P7+JzqiztnjM/zoDVhZftNRVRoGvvjmhirEDPjDRy7BnhmVGhOQYC4I5a0HGo0Ynb0mGfqLPTWugSpEquHdh5AFcBRIfnff1OSibyhei677zXk+1H7IGPN4Tn+7HqPb8aPXgyzFzKGJgqdTvA4fKaAWUPMacxjTkRFj9GJWMIi1KDskCJunqnAQ8eJprfOVmGevdrXHBcs071vJwl2BSF82G3AwKTcqppJyRkzz/sB8ZvT0Rq3rwKFOsTftsD6fcX3fYraVuJi9qHYVdNbMcfRhP9646jfKGocVNglY44Gq2rBHZ4xYcMfLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2xWBbIydid4aEuzwIkJ7/RDuO11di+QU4D6IvhBGSY=;
 b=Xlk7AUjC0keyA6XOXe15g2Q8Hmhjb4f8slb17o1iIX5bsCNpPrymzTaGOvcB2NTqX/FucLJjF1C2YJCQeFhpZ+7OJ230uh+akkpwGNTkSIxjLgV+k/uloHpkIR47ERip8L4sJjp4sjTpG+U6EPr5jG05pTVCXEP1bBXptroWWLJHkBzVQGpJITVIm0cVsAOSSIqIWWFN6Dzdu07s3rF4ci2jHhuulP2Swdu3KY0EipbZqdOMtVfZ/NSfcLhs+0B/WvmPqwubP5CVRuNV+c85nxIabkWKYu1bSzyvmlLU0Lw5WW1+o4xbt1GNZP6DHh47JcdDk2E9EEjp9JmFj97Klg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2xWBbIydid4aEuzwIkJ7/RDuO11di+QU4D6IvhBGSY=;
 b=WSZY92rZDFQdMQI+b/TAeB+3MXe6SLZkwceJOhAhOtjpGb1zV+V3x6MXy8ZcetNjZB5RWhSGIAqpdCh43AegsMDEDyaNzzHDSjXpCE9Pfv2Wq7hVcl7l2WiJZqn4Z8XYgTRfBdfFuk05ZW5g29NvrSQOWpMlEMFwuL/lwuMy3nQ=
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com (2603:10b6:a03:291::7)
 by BYAPR04MB4198.namprd04.prod.outlook.com (2603:10b6:a02:fd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 02:03:06 +0000
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd]) by SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 02:03:04 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Bodo Stroesser <bostroesser@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3] scsi: target: tcmu: Fix xarray RCU warning
Thread-Topic: [PATCH v3] scsi: target: tcmu: Fix xarray RCU warning
Thread-Index: AQHXTLaRzu8H4aIky0+Sqy2lf4WdDarrnxuA
Date:   Thu, 20 May 2021 02:03:04 +0000
Message-ID: <20210520020303.expoootocyx422ua@shindev.dhcp.fujisawa.hgst.com>
References: <20210519135440.26773-1-bostroesser@gmail.com>
In-Reply-To: <20210519135440.26773-1-bostroesser@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bd69061-29ad-4d60-df19-08d91b336769
x-ms-traffictypediagnostic: BYAPR04MB4198:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB419894259DCE6838AAC6AFFBED2A9@BYAPR04MB4198.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mEwUwd3iwRRcjmvrCsgNH5d95mTmR+chkSqKymE/P7vwBza/suPwnUklmLTkA8YIWb9tbk7cV9e06ALRztjuqfgAbqhOiRioMAzg6603HpXQC+/vVdJRwxXIwYX5tEfi2tRHBWed9tthi3adNbhLAcRhRFkSTGGnEcaOqJbMzGsj9GePBNPCTMdY1HauDvY/R8ImYQJIKKgnghSz4bsedzeII3J4vC4dxfBGvPvBmDtMvpVv8zHb3vigc4pOAmLXKMpoFzdlLMibgnqleFvfcO4c0YqpOA/P7gIyVjMCDHQEOM4lEnjO5ClOsgeowrrmK0zQs6lTvFB6WJCcurZjM0ZEIT041ggNl+ZucCBtYrF3KK5FKUoiz2CGc7K3PPu72NPDo21HXBzryWYtFIedtjNVRyMAq7RqfA+w1UpEM8uzA8fs0rNV/w078SASq1i68Z0188uv9NMLQWKiqHe4Fuapw8OFq+tlF6+hZcoxmfBNt1PecGRAjwN00mhSIFVnGCCtzcbuWvJkDBB4d6VPwCHKaQn+mkuC47G/V3r9lN9T+PmHlwB2CSIAKy7l545Mbq1Rlu/ET4NuwUEj1t4NsCOwu54Kv6Jafakl9i6WTUQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7184.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(6486002)(66446008)(64756008)(66556008)(66476007)(8936002)(5660300002)(91956017)(6916009)(76116006)(186003)(478600001)(54906003)(4326008)(86362001)(66946007)(8676002)(316002)(1076003)(44832011)(2906002)(26005)(6506007)(122000001)(6512007)(71200400001)(9686003)(38100700002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xM/IC/QeHuqWRC1XaNOHjXg9cKnkD6agVHWkpu4ZeWM2Qi8Eoz7CvpjEal7v?=
 =?us-ascii?Q?sh2mz1OmyfyH4UVD+houZ82s6oIkea6Pq0o+MgBunTOJeifz/Pw98GYLLb0Q?=
 =?us-ascii?Q?gx0QYDqPAyJT1htcAvJZDC1wj8k3ekIHWY7hDTBY1qh8VhrTi1k0KHk3/Xv0?=
 =?us-ascii?Q?uDtZz9Qp0TpiHAJXa2O2ytMZ84258KRWX6us1Ay2E6Q1WAYnKM7VEi6KgVRx?=
 =?us-ascii?Q?+X7UGFuDzSwPJqwjK995Ey51cnnqhDmWSpWNxThsJQPDY3Wd3AfxG85cK3Xf?=
 =?us-ascii?Q?KEVn8vZk2Ku25Rvh46dQgX7nyqVRXiLvWQBdRjlku2GpEbgD3C6qF9iP2yBj?=
 =?us-ascii?Q?+mdVMVKLmIGhYKLZ/WNsc7NgURZGiRk55UDo9/X0XOeD14/PuIsl2fctIyy2?=
 =?us-ascii?Q?/CgK1qAyxu0Q5KSS+X6uazEy9+4fk8cdbhD4guBo2j9pMlOnCWHXHS45Zqq2?=
 =?us-ascii?Q?V7snKNft4oCtpKzR0nWyBtQvusD8uLsXwXUKurfeMpSiU8jpe0Gc5vNKqbfp?=
 =?us-ascii?Q?UgHRLfqBh2gVxrmcY0OuL8T8G66E9DtG3Ql/Ie/b8WtnuvQvMGozVOJwTGG1?=
 =?us-ascii?Q?sKYsi1xhtDe9j4btjEATzFYI7CcpYjt0etR8PAIzvTU33PSkaFLqgnclYfd7?=
 =?us-ascii?Q?f7xNQLpbvUn45OxOuRfQspfKK820/bJ0FtoaVJBJNyt4UFF/HyJJOH+mgk+x?=
 =?us-ascii?Q?BQ8NatiIZPyzm1xryyfzDjmNkqYg38tlPRkl78xDl1n+8argL8u5A2gZyFUa?=
 =?us-ascii?Q?c2BT42QeRQ7WMV+Vlu4j5LR3YUZm9zzUeMM3s7xGFP3LBT41w3vdNYRDKLFJ?=
 =?us-ascii?Q?Kw5ZFxMh4bPHqFwSgwGPyG2LdgnvYYN7+wYauxd2ODBXWOhs/6WB/Ft7huow?=
 =?us-ascii?Q?K6WVLcIIXabCXzmGjnveel+LbaJmM9Poima01x2buKL3ycw1jxt0xy+qlVUl?=
 =?us-ascii?Q?4jsaM3XN1Zxbqz+MgLIlEZJUFo0Q0JpeGX+Gi37Y6ARuicoiSCjFqnxNg73y?=
 =?us-ascii?Q?WaOqB433H6nmio2mtX0FIGIuwyE2/jAJa1sVl1yHJZtvmlTAFFvd1ElFaJBZ?=
 =?us-ascii?Q?B+N2NElx4D9k1RylHrI9iL28Pn+xpdcWwdT5afLbDUpBgpOpI2iVYVOL9Nx1?=
 =?us-ascii?Q?loRNMJNQbjg2kxpJpgdcZtvBwMmDRD8vY6xvyXy4NHYatx5eLPqjSK/9fxNx?=
 =?us-ascii?Q?0b02sj2novygEBnhtpC53QtkSGWgrCAYaEfQyFY1SZo6Dg1JSYGtU2IYgRi0?=
 =?us-ascii?Q?DytoaxvQ/HGoAtGsgNp3ofi6/tPSeKiINCpH4qo8+QG9c3LYUQ7I4HPN3vJC?=
 =?us-ascii?Q?dKFlD8RWCZ4ZIUPun74mfZka8whf48jDxJcKd1JgKO8aFQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1299CBC95C42244184C23EE8DFCB7871@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7184.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd69061-29ad-4d60-df19-08d91b336769
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 02:03:04.0953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ibv1+7VOYRg1Fwz6qbNwrqRgXr2UA2+jbn9/GVMWb5KhhuHfp4pcxPvzk9ClVyZU/iyjQrNwfipHZLS55N4uIxUcCfkJ9sD4FpW4FZvp5Bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4198
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On May 19, 2021 / 15:54, Bodo Stroesser wrote:
> Commit f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE =3D N *
> PAGE_SIZE") introduced xas_next() calls to iterate xarray elements.
> These calls triggered the WARNING "suspicious RCU usage" at tcmu device
> set up [1]. In the call stack of xas_next(), xas_load() was called.
> According to its comment, this function requires "the xa_lock or the RCU
> lock".
>=20
> To avoid the warning
>  - guard the small loop calling xas_next() in tcmu_get_empty_block with
>    RCU lock
>  - In the large loop in tcmu_copy_data using RCU lock would possibly
>    disable preemtion for a long time (copy multi MBs). Therefore replace
>    XA_STATE, xas_set and xas_next with a single xa_load.
>=20
> [1]
>=20
> [ 1899.867091] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 1899.871199] WARNING: suspicious RCU usage
> [ 1899.875310] 5.13.0-rc1+ #41 Not tainted
> [ 1899.879222] -----------------------------
> [ 1899.883299] include/linux/xarray.h:1182 suspicious rcu_dereference_che=
ck() usage!
> [ 1899.890940] other info that might help us debug this:
> [ 1899.899082] rcu_scheduler_active =3D 2, debug_locks =3D 1
> [ 1899.905719] 3 locks held by kworker/0:1/1368:
> [ 1899.910161]  #0: ffffa1f8c8b98738 ((wq_completion)target_submission){+=
.+.}-{0:0}, at: process_one_work+0x1ee/0x580
> [ 1899.920732]  #1: ffffbd7040cd7e78 ((work_completion)(&q->sq.work)){+.+=
.}-{0:0}, at: process_one_work+0x1ee/0x580
> [ 1899.931146]  #2: ffffa1f8d1c99768 (&udev->cmdr_lock){+.+.}-{3:3}, at: =
tcmu_queue_cmd+0xea/0x160 [target_core_user]
> [ 1899.941678] stack backtrace:
> [ 1899.946093] CPU: 0 PID: 1368 Comm: kworker/0:1 Not tainted 5.13.0-rc1+=
 #41
> [ 1899.953070] Hardware name: System manufacturer System Product Name/PRI=
ME Z270-A, BIOS 1302 03/15/2018
> [ 1899.962459] Workqueue: target_submission target_queued_submit_work [ta=
rget_core_mod]
> [ 1899.970337] Call Trace:
> [ 1899.972839]  dump_stack+0x6d/0x89
> [ 1899.976222]  xas_descend+0x10e/0x120
> [ 1899.979875]  xas_load+0x39/0x50
> [ 1899.983077]  tcmu_get_empty_blocks+0x115/0x1c0 [target_core_user]
> [ 1899.989318]  queue_cmd_ring+0x1da/0x630 [target_core_user]
> [ 1899.994897]  ? rcu_read_lock_sched_held+0x3f/0x70
> [ 1899.999695]  ? trace_kmalloc+0xa6/0xd0
> [ 1900.003501]  ? __kmalloc+0x205/0x380
> [ 1900.007167]  tcmu_queue_cmd+0x12f/0x160 [target_core_user]
> [ 1900.012746]  __target_execute_cmd+0x23/0xa0 [target_core_mod]
> [ 1900.018589]  transport_generic_new_cmd+0x1f3/0x370 [target_core_mod]
> [ 1900.025046]  transport_handle_cdb_direct+0x34/0x50 [target_core_mod]
> [ 1900.031517]  target_queued_submit_work+0x43/0xe0 [target_core_mod]
> [ 1900.037837]  process_one_work+0x268/0x580
> [ 1900.041952]  ? process_one_work+0x580/0x580
> [ 1900.046195]  worker_thread+0x55/0x3b0
> [ 1900.049921]  ? process_one_work+0x580/0x580
> [ 1900.054192]  kthread+0x143/0x160
> [ 1900.057499]  ? kthread_create_worker_on_cpu+0x40/0x40
> [ 1900.062661]  ret_from_fork+0x1f/0x30
>=20
> Fixes: f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE =3D N *=
 PAGE_SIZE")
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
> ---
> Changes from v2:
> * In the large loop of tcmu_copy_data use xa_load instead of xas_*.

Thank you, Bodo. I confirmed that v3 patch avoids the warning, and it passe=
d my
test set.

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=
