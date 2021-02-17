Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C72C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05FEE64E24
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhBQJnN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 04:43:13 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:23162 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbhBQJnF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 04:43:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613554984; x=1645090984;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5HifYAFTX+jw9DuMHCo+oQs5dYlmOOKDlcEUqsvOUaE=;
  b=Z6yV3+QJGVYiLQQDZ4R0au818NuCaplthOBqGeWTJ83nqHvmbbl4+Hdo
   xnIxaauQFkbekFLdIDYTNvnoJgjSixaRlKs6SYlcuHj7VLOTmoDRHSSnj
   n/miLvUyOxN2wwXuuOT/w0R127dcm4dBZ41KDdsxEDIzvFkEcjMqx7Em5
   pyIVRturmIFlml+oqcRH5SD4RatCl0W8F/9p86ECK4wCPOGSo8Wt+uWib
   iSXpU0gOm92ROrwb7bp/9uNhr4SdeAJXNrV6sPOZKEA6ohLHqs/1fuKHs
   LhWOXWDHcc2P+kFw6QJWF5jRjshr+zwJuZ4mT9jVmD+JfsXqfDknTg3QO
   w==;
IronPort-SDR: 5CLjVA07vqRDX8Ar2JrFoLKH8/0SU7dNZ2YGOeq9W+uHEtSLQXg3pilVRr6ihbsEHUOYjHRgN/
 fv+XxXrYwVSU28BT1K5drs/417AuFMuXxPViU/8QbF8QMT1mDbm8IueN9ugf7QKprYuEqCgxL4
 GPcVrAa9itaBwlopmvQOTYF4ZJ55ce6jXBhIoxMp0+dgDVC/Z2EfZEQZydGuJJmUxX/Wv3IaBw
 LWQr+Oz67GP2Fe0ihi++rHNl1uBaCBnrDaQt2j0UmabczqUq36dY62JMc9eIm9jLivWHHUR3SR
 uGA=
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; 
   d="scan'208";a="164630577"
Received: from mail-co1nam04lp2052.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.52])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2021 17:41:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNNHft1aJkNzEXETIbJ+3Hi3p9QiS1282MNBGEfbJr8/1Njqcg5VybZpFxoNAduV7uP4NHtpSb57Uuy6KIV6a0q9z1WgPrSv4hrwDoltnM27afeRrwT0U8XdD4pRGcU4g/TpJylzp/ylHgM7jYUY43mx5NWwCodudZJyau3xRmJSmoHpumMxXke8TE9nhMMbnIDF4yzcVR1dHRsmqEcQZMtTae1am1OqfPXAxPq33xjueNV0Vo3OyAqcMbgKAalIvVshrNLiL7LjmhqJK4B5zSDIgSv8HV7bUhs12sWkYZYFg0Sk1JaIts/eKYATDCdChGiQoTJ2gAzbKJHfrYnxbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2EWr+2gvN95E39md7x69r0s4tJ/bBkbkYkwjz/T1bo=;
 b=j3MrG9SZVESCpooy7qnrFAI9QRHJ+RpuYJdpz06aOLXcxChSCmfE5oBijVm6C9P0lTM7rqUplnzAfR3STho39lUeYHQN5QUZ5mws2S2arlxN7zbZesaPR8QyiL3CvQ8MOqx8J+fM9ZOdA0fHabNxE420FIZp7sxvUxxiX1mIaE6EwnmFwzoLTodhUeXEwgCkgXCjfc2n2MUWg5iUKA7NTE5luO4nYeRSsNtWfBOIj1KriyS4dkprtH2p3KvB8TQo5QIVVacgGaiFEIK2rXAhI1DhOta+ECvFW6BPsH6bzHMCZtm44L8bcDBN6FK7CTB0h9WAYE/Wi5RfMWxgjD5ZkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2EWr+2gvN95E39md7x69r0s4tJ/bBkbkYkwjz/T1bo=;
 b=Mi2fEbLU+04jG1OIRaL746dRPIQNo5N5weu55SN6/53ig3c+Fnvg9Tyh+RV2XCHw5JO+y5DFd+1hBOXeqgBca4Z0bQoivpdMU6WQLr1YPaz46l0JD23pPPNIP9jiSF8O0NR3X6BbywzrWqomivXjmu5vRDO1DGH++DBsObinlY0=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SA0PR04MB7372.namprd04.prod.outlook.com
 (2603:10b6:806:da::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Wed, 17 Feb
 2021 09:41:58 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%7]) with mapi id 15.20.3846.038; Wed, 17 Feb 2021
 09:41:58 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Michal Hocko <mhocko@suse.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Topic: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Index: AQHXBJuZNMPC4HbBMEOENoattX2qog==
Date:   Wed, 17 Feb 2021 09:41:58 +0000
Message-ID: <SN4PR0401MB359849D173B08EB61A6CE9F19B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <YCzN4qPicujdSJ7P@dhcp22.suse.cz>
 <SN4PR0401MB3598D86F05613F41049038BB9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <YCzjmfTxDmVtInbu@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:1923:7af3:ae74:5873]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a5c6493-607e-4179-995e-08d8d3284507
x-ms-traffictypediagnostic: SA0PR04MB7372:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR04MB737274FE0E615CD8DCE2DC209B869@SA0PR04MB7372.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jn6iC7VO+8M+/fSGM4V3xdB5Nfx2HH8iSHdpYaPvPOjmwTuYP50zjmOZ0WV2Y3C6sHzNI6ObGp2p12Io0xQxw0KY+EN+Ny+N460bhdZGEiuo1UC70mFWqZBqVjeh2uWi9vaEu8S1qHOeg4kzCMoQoFvpidq9KJKee49bYzYkRibypoDLyjaTKBhx38OqUlYSJUx3o5F9THhu16SZERsqNmtFQKmKbIXaY0RT6FSx9WslKwi/Z5mv2j78c0QuTyiSYkaB+kyaCmNAvqHSALahYDRiIjml86SZNT6ZDgv8Ozqpg+NXxKI2TVtKebBfsXRjqpZ4RqaZHdn4x92/Z9DyU/6OfBr9e5rEupq/RRO0/rFAe45aMAZ3D199KHkHHI+MxtQCxAiieSLKh8LmSzlEKJZcY0GJSo2lo0n/FaErOEA/uLalmvt9tRYSKWKiFmJb0FiHwZ40y4DTmTok1xcCHkxuPOG4UWWa49DNCcFh6f5tNR/6D1ssj6FVGNVYxxCfEexWGBJJW5SwYPAzJGfQwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(39850400004)(346002)(55016002)(54906003)(316002)(86362001)(9686003)(33656002)(478600001)(186003)(83380400001)(6506007)(53546011)(4326008)(7696005)(6916009)(64756008)(66946007)(66446008)(66476007)(8936002)(76116006)(2906002)(91956017)(66556008)(5660300002)(52536014)(71200400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TA96aWHjPjy7A/lV1IZveH6f49cEQQDw8SHr2gDgGwv/lrYUilvNYWY0YqQK?=
 =?us-ascii?Q?acCnJB4GhCbaB0xpepKxk46C83Bpne7qd36EP1YqbDUxcv/UzSMtY/OQWlJB?=
 =?us-ascii?Q?SyC/l2fPWjqCllnsPgekVwL6teyMdMhC7Fo7PvPATfZbmOBvyZQF+jW76aBL?=
 =?us-ascii?Q?w3beAJYWTXF1oCAltpbmkpgVsDQeZQlHUCU2miRyOTkBfr2JtZHXfEJ+DK/v?=
 =?us-ascii?Q?moJtJ28zeYXXcGKBGu1pH6EsCXt6avDJOh6Em0eqZLlEa+6miXgjXK6EMb0B?=
 =?us-ascii?Q?P6HDLZcnhkPnrqN0gXMxl5glxcLXPIVK1IeJriYYSuwluGI8FMERJ3wtWfzr?=
 =?us-ascii?Q?zSDexy8LzxEV4rlGNunM8I9ya2I+GrRzHMgW/9VVMn17QomEfHzP/1f+FcOS?=
 =?us-ascii?Q?W26WOJrv5SaCrPyrOv8ezTJfDrN1MjN1JjUfx3/Ro2i3rfUoEYROc8Z22zk5?=
 =?us-ascii?Q?s2TkSiVu8fa0Agmvh72aIYAZYVheqf5H0TYC+YAGgLGPiB5AdzV5C1ylx808?=
 =?us-ascii?Q?R7EhE6cNeLo+hfr0w/2ADq02LTq//ib7h2HYadF9m+m+vI3iy5DKKBjRHeXz?=
 =?us-ascii?Q?DQQWkn3LMqAbiGufVLtxVSwxcw4/nllaz108AMMvrSVsJ/TjeWEiMS76QF4b?=
 =?us-ascii?Q?MpgdVH/H7oLCAnvj79026PBMX02N3Acy69/r2xDBBS59RSQpxtupx+lrMT8s?=
 =?us-ascii?Q?iZVpEdNsYiQx1ORCt7JMkAWFqXoxPLz+MEkl92gG8o4OW3Jw/txL80IOGIjG?=
 =?us-ascii?Q?yZ/PdtXH7e1FKuQldSHfpoTcx/4bn+EayWHslMz1PhZ9/qGl2+t6wXlgLA3q?=
 =?us-ascii?Q?BwQelmEJ/IFi4QckWoTiPi6Pdq5ZUF5r9d4kCoc7diP45xnlhxPvpVnw55uD?=
 =?us-ascii?Q?1ep46U2Um9f3gfut9gMNFf2C90jCWXloJHsRfw0kIPejvjwjufMlUgjyMWJC?=
 =?us-ascii?Q?IjUGTjY8qSIkhGK4WxyJ43xpwladT7BNg+Kf4xGPQQekZp1EPmC9mKTOi0XO?=
 =?us-ascii?Q?NIHgZpNh2jhq4ZuMoX1z/oxITnzCpmomyMo457kV3gDm9AYNEwPmyvhgHt+s?=
 =?us-ascii?Q?xe3E+/r0LPBV9v2DagG12noHSCEmZf53xaFrK2EZkCMYEwa2Usu4NXFx68uy?=
 =?us-ascii?Q?zyOj6UpcWidwsbwlHPtD8ZQ5xXiVuTxzo4n0MIAbhlI1KaYHoGmDnsBrX6Iu?=
 =?us-ascii?Q?n5DturxUhH3y554Ot8x+azBKeJkZ1M1td7W6SXW58sEDFNEVdh/uDNgiP/an?=
 =?us-ascii?Q?UY/64BcZQeMaV9Ew2cemAvhHYQF7np2aToqAhss7jwymvGcUgCtutKNHU3lK?=
 =?us-ascii?Q?MEjuoVXZAtgnQwpMnJ7aA8H7lPZvGy2U05SqCzWUMg/Z6n1KFwC1Tz9TFwmw?=
 =?us-ascii?Q?bE/ozt8J5GWSad6EmDPSzcjHchO5M0Ajya3FELDrQXDw0nx+Rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5c6493-607e-4179-995e-08d8d3284507
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 09:41:58.2014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M4fXJV9SfOJVTpI0pv5YFx5yCt2IR8X5UaliAKvIyjNyArsFGmZw6zEsJqiP+mG5/kmFfd+wqk0EtnGKus9hwLVL/2oa1WHSgVg0H1qdUmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7372
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/02/2021 10:36, Michal Hocko wrote:=0A=
> On Wed 17-02-21 09:08:07, Johannes Thumshirn wrote:=0A=
>> On 17/02/2021 09:03, Michal Hocko wrote:=0A=
>>>> No I don't think so. A mutex isn't a spinlock so we can sleep on the a=
llocation.=0A=
>>>> We can't use GFP_KERNEL as we're about to do I/O. blk_revalidate_disk_=
zones() called=0A=
>>>> a few line below also does the memalloc_noio_{save,restore}() dance.=
=0A=
>>>=0A=
>>> You should be extending noio scope then if this allocation falls into=
=0A=
>>> the same category. Ideally the scope should start at the recursion plac=
e=0A=
>>> and end where the scope really ened.=0A=
>>=0A=
>> That means all callers of blk_revalidate_disk_zones() should do =0A=
>> memalloc_noio_{save,restore}?=0A=
> =0A=
> I am not really familiar with the IO area to answer this. The base idea=
=0A=
> is to start the NOIO scope at the boundary which defines "unsafe to=0A=
> re-enter or cannot deal with a new IO" from the reclaim path.=0A=
> =0A=
>> If yes, can we somehow runtime assert that this is done, so we don't=0A=
>> end up with bad surprises?=0A=
> =0A=
> Could you elaborate?=0A=
=0A=
I though of lifting the noio scope into the callers of =0A=
blk_revalidate_disk_zones() and then "check" in blk_revalidate_disk_zones()=
=0A=
this has been done. But it looks like memalloc_noio_save() can handle nesti=
ng,=0A=
so this is actually unneeded.=0A=
=0A=
=0A=
>  =0A=
>>>> Would a kmem_cache for these revalidations help us in any way?=0A=
>>>=0A=
>>> I am not sure what you mean here.=0A=
>>>=0A=
>>=0A=
>> Using a kmem_cache for the allocations passed into blk_revalidate_disk_z=
ones().=0A=
>> I've looked into kmem_cache_alloc() and I couldn't find anything that sp=
eaks =0A=
>> against it, but I'm not too familiar with the code.=0A=
> =0A=
> kmem_cache_alloc is only an extension to allow to allocate from a=0A=
> specific cache. I do not really see how it is going to help with larger=
=0A=
> allocation and my current understanding is that kvmalloc is used because=
=0A=
> the requested allocation size can be large.=0A=
> =0A=
=0A=
Ah ok so we can't set aside a big enough pool to do allocations from there,=
=0A=
this was a misunderstanding from my side.=0A=
