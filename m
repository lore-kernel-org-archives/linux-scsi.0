Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E27BC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 08:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D579764E24
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 08:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhBQIBd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 03:01:33 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:23498 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhBQIBc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 03:01:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613548891; x=1645084891;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=LWNd3qKJPzgtGnRg+LAQ6cv5qAc/Khpglgz9wYAREeI=;
  b=VzBVWohdXwRgYU3yumg9Vr21YBWQ95BJSGV+Q9GTqMu+U/SOOTrQ4Dme
   HzLiipgKUBiwqu/PhqQjADfkT1YhFK4dum12pxibQ/X6/AsxCy6igKKXt
   L0ZAmTX4NQ4h5kAwqvKGSLUM7eS+VtMbxUHhzSefxF4JSo9XHcG8zbxZh
   Kxtt6SoKEooHCxEhaqMCMCXr6KSYnG9SczTvjiSb/8ukJpe2hE6cWNHOK
   yU/CcqoNCRcnyZ285Adr4KiUoZAYVlEgdksVClkjZ5G82bd/ST0dHp8CR
   V8IcQxhMNqdohzsBMXTGTjqogQTO7rETyKdw/xayTnQTom6m1DVkADs5Z
   Q==;
IronPort-SDR: A+AY44diKpg0BhBTmX1DoPproP22+39xsSY/CRuuBpoPapK5TYaqC3QTiG2/G7xacZfnWKDRNr
 pPGQdF6D+gXAt3X7zF5ix/dyyQsFklNVMvwoYD0KmFiolXQ/Ax0n6miFKcMky9cMNX2d2iJi7G
 t+YjK0YtfF9DQlJqvtLXiI5NDFfTkPW4A5DCQviZtkq3EIalYRw4m+tEwIVm2rju06FSRdA3zI
 fKDhrFBgqL0sys/akZO+nwg0pQ/4FC29RF86yyNcNm5NE//DPuoHu5sD78jFhMS+17k1+rj85X
 s1U=
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; 
   d="scan'208";a="160127862"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2021 16:00:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qorc4OnelrDS6SFm4qxgbSxv3O6+5ZpXVbl/9IaRKa+2oxN9clG31LX7h93Dy1y3kc1fBorTGjk1EwLGw6MBoI+QNIQ47PR1rxvGMfdmua6T3AJrYKNoPKiTUheVLwNdWnru9RhkYq305vDRJJj69nQLe0LCFAzYcjsJSl4I8Av4/Vo1cCRPAgMgLpMcGiEMnG4GbiqO/YODkztt5JyLjLAE0C4BniZ1Ba9156hXicTfNeOn6PMOqBcBJFM/8lVZb+SC5MsrAAJOKZGBbKPhzz0F2Y5pbSOnnB1VRroQhV62rOXABajps20iQ21jIgrJTjoFHEi9571M+zizwZ0ygQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VGk2yZ02MC/UXhKGPbyASJ5N4Q4foI2WC9Ol9CJGYw=;
 b=gGAq5tolh+hPyp9Qyfg8pLHQqYbK5q8PY5cibbiXbcoo2ec2CW8kWv2guRIfbIpVSYeiB9Fp8yjtBkX2trQwKW9PNtf/+qt5QIycJZ6YXLrp/5AwC6DO/aS9sjybseWzYcitbCxk0HO6GSBHslpMFJjXrXvSQxKdHPlkWDBs159n55iRx7/k8TWA/LBjUE0Y1MibIszNP7BmP37leiYaCZ08FCMkakxBTmIrL1hzHRu0+vRcFKlUA6vmfwjFCwl+71kAl7aVYCfvx/WxdeoAWRMwhDw+ClsClvkvFBTwZPiFWhomtLOvQL8DHNsz/AA5IHnDyAI0d7kDevn5mUeNSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VGk2yZ02MC/UXhKGPbyASJ5N4Q4foI2WC9Ol9CJGYw=;
 b=wb/H4so767kRSP5jSWzHRmi7P6d0HNz6LxXwtn8yK1+1U/vQpl/HRMR2sTjHCt+XwnDBuSktqmpGtZ2IeAJMYofi1dT9U0RkhnMnzmd+LqMskZUsLkJz6fie6YveUdRcsaxPuBeuq+G3USuWVZHIFs2aFhhLSo0Lhi6PaOPegx0=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6478.namprd04.prod.outlook.com (2603:10b6:208:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 17 Feb
 2021 08:00:23 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 08:00:23 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Topic: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Index: AQHXBJvkCA9zSw6fl0CK4GSwjGIV/w==
Date:   Wed, 17 Feb 2021 08:00:23 +0000
Message-ID: <BL0PR04MB6514FED9A091D7A7BEA1E626E7869@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:75c0:49b:2210:beaf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5d7178d0-b055-4b90-350d-08d8d31a13ff
x-ms-traffictypediagnostic: MN2PR04MB6478:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6478ED4E7DEB079EC4635E41E7869@MN2PR04MB6478.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QFDFdm3lFyMzpK777R64RnqPCItTtOPdhUsziJ3MunnyFjMOrq5wG7YNQQy9Muds+KA/dVIb79n6vnuLRR5pKAa8MKhQ8hVMZJq2yijA/pTr5uLAwmmE3b91oO7O4kdapPq/yftbyGWVlg005dCyO5Q7pRdlN/FJKQAw4cMcg3WqOORaY/XyhWetUPdJIWuo5aTP1WtACWNANtkfSCwLyA7VHi9jF1WaM5yHZquQxkp39G8z4XmV/KZhcayyQyMR1Qkjzktg+LVmUEKC+YqsvoGsoZZ4mWedRUjf1mMIUqRNjOF6hRybio1gEmLVi0hmc+YeNIrtoAPdXNBQ80RnJC7kiBRYas32t+2/Z/garQxsj6eK+0hbw9CrfwmCqnZiDQituI07XdNW1BdIQ9/uOm0xTNi4AsFoBglICis/Oj9aU+QnCxJs9Hc1UUJShtU6n3WDsTifD0HtJJdfLJwh8lm71aHFRjfUq6BzarvZOV/19NjjU9ozDtskFCGAoRj1qvRBSBysACPvQm+CpoSHHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(66556008)(83380400001)(91956017)(71200400001)(66446008)(76116006)(316002)(66946007)(2906002)(33656002)(54906003)(64756008)(66476007)(9686003)(110136005)(86362001)(55016002)(5660300002)(8936002)(52536014)(53546011)(6506007)(186003)(478600001)(4326008)(7696005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lucConnA9A33hpOn78UXXMV4mtFC/dwc36YDtpcLzqo09bFVswvalyoHXbsG?=
 =?us-ascii?Q?LxVYENv5jdeU6PxF6O4X36INhJzivC27hn3XaPY3r4uFRaI+i2nWYvC4sYLK?=
 =?us-ascii?Q?x8yFRumEhPhfToUeC4CSxVmnslGGrt3x5Fvy10vSYVgKTBUoM/W5XG+s3ZPM?=
 =?us-ascii?Q?WPyc9QJn2Ai3TBqgScKEno8wbLi80UW8o37gtNxq5ZIXL57DcH8He3YQLnYD?=
 =?us-ascii?Q?csf0ER9Ll1+F/2XPG39c9PSJIUrvoAYWJxfYC/m74etDYooTmLLCDTTnQYmX?=
 =?us-ascii?Q?8AEybQDfQZmXWE3hQDJbHohImMN8c3GtxO127cs+Se3a2kMkXR2OqdIZLjGk?=
 =?us-ascii?Q?ggWvBasa8utvXEno7jpmor4INqQzcUpHsw7aViJ47Y/M7EPRV0nZn860cwXh?=
 =?us-ascii?Q?v4noqzslkBm//bQKV9/QDkX6er2cIFg1X0iFJmzvYO8b22Na4xpQYDdZB9EQ?=
 =?us-ascii?Q?uo1w0UWb7K7vTYUK51E9gHYOILjmmB3me1B9NXi1JPewlvcBLATYoni6L90S?=
 =?us-ascii?Q?bBxKVNuEVhJhMmpyVCW3Ori7cHFfSfL9rXEhoWHnKAoQWASW43qhOLepoeF2?=
 =?us-ascii?Q?/SAuW2cxpSsTcI33N6sLpralCYlFV7d6HyUYSHAWYGJPABmrRK10fWcnWmp3?=
 =?us-ascii?Q?F+KHo7vq+d9eevnJqaHyd2m9nq2spiCB7Ztr8XqyLcGzQ8skx3qdlx/cjxyf?=
 =?us-ascii?Q?FEKv1vYzDD9ie5SAylwsCoROIDMOfrbBWtJYFL8e7+ht42Atlajxvy7sL8fs?=
 =?us-ascii?Q?BE4PkAJcDlZndqL4EnSUw72FrzZ8W1/2j82U/ugYym1JHAgeoeiqzLOJpfUs?=
 =?us-ascii?Q?Om/COQ4/MdTE44ajzBUvvkOCjGeOFVzjlBBLhanyLr0JlnOziyhV7UyMF3Tj?=
 =?us-ascii?Q?mLbA+6vR0y0MlhQ0PkG/QdEfiS2Vf+w19b0DdwgW8/pQzbK9op4SmAKg8RwO?=
 =?us-ascii?Q?mXxExIaMaXvec8XoOEFXccGVtLPqyEyUcKiMr/m7iaZ47MQiurqeGVv7+yQG?=
 =?us-ascii?Q?eIKuNy++cDo07xfZRwqgPgTHI+WAFDKPys/S+FQSc5hfQ32WqEuzbAJlPn5V?=
 =?us-ascii?Q?4tYf0+QJ6L+6Uj8p3OfxEK1GENoBtfz8cWLmhSma+xWwSYSR+ZfOVLRrc2uV?=
 =?us-ascii?Q?CaO1u20u5vW4w++W3wT/fWtyCTreUYYcAlKsnWWWXImesPzRlOgDXXKxsPl/?=
 =?us-ascii?Q?Vmh4Ndd3rrKrZ6JIDpl9RAhIG0FXmuSJ6zWGAhgySXC+3HOdSkuZOSOw2NQ6?=
 =?us-ascii?Q?V5deAG4G7JRH8A/mVyvXiNpO4ZKTtzXW0JVtHTzIzCOl8mik6RVSsOOIKiZD?=
 =?us-ascii?Q?g+dSpfMBDQYhCxfxFsjxEMaYRY1kn7U025w56+IOfOU+3C+FOtxIZlh4WJFZ?=
 =?us-ascii?Q?cYBG2UUPmvDrdZET2NFq2MN5dOBTSFFKMBELKona7EKSqq5+Mw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7178d0-b055-4b90-350d-08d8d31a13ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 08:00:23.0281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /jSjlHMCErDX+ceA7cx/gpvSfDxHS2e8MhiP9QfE0aoWtD6cGJ+zNqAnc30yT7XbdFvHKu8Ur1jGhiynleJDrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6478
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/02/17 15:42, Johannes Thumshirn wrote:=0A=
> On 17/02/2021 00:33, Damien Le Moal wrote:=0A=
>> On 2021/02/17 4:42, Dan Carpenter wrote:=0A=
>>> Hello Johannes Thumshirn,=0A=
>>>=0A=
>>> The patch 5795eb443060: "scsi: sd_zbc: emulate ZONE_APPEND commands"=0A=
>>> from May 12, 2020, leads to the following static checker warning:=0A=
>>>=0A=
>>> 	drivers/scsi/sd_zbc.c:741 sd_zbc_revalidate_zones()=0A=
>>> 	error: kvmalloc() only makes sense with GFP_KERNEL=0A=
>>>=0A=
>>> drivers/scsi/sd_zbc.c=0A=
>>>    721          /*=0A=
>>>    722           * There is nothing to do for regular disks, including =
host-aware disks=0A=
>>>    723           * that have partitions.=0A=
>>>    724           */=0A=
>>>    725          if (!blk_queue_is_zoned(q))=0A=
>>>    726                  return 0;=0A=
>>>    727  =0A=
>>>    728          /*=0A=
>>>    729           * Make sure revalidate zones are serialized to ensure =
exclusive=0A=
>>>    730           * updates of the scsi disk data.=0A=
>>>    731           */=0A=
>>>    732          mutex_lock(&sdkp->rev_mutex);=0A=
>>>    733  =0A=
>>>    734          if (sdkp->zone_blocks =3D=3D zone_blocks &&=0A=
>>>    735              sdkp->nr_zones =3D=3D nr_zones &&=0A=
>>>    736              disk->queue->nr_zones =3D=3D nr_zones)=0A=
>>>    737                  goto unlock;=0A=
>>>    738  =0A=
>>>    739          sdkp->zone_blocks =3D zone_blocks;=0A=
>>>    740          sdkp->nr_zones =3D nr_zones;=0A=
>>>    741          sdkp->rev_wp_offset =3D kvcalloc(nr_zones, sizeof(u32),=
 GFP_NOIO);=0A=
>>>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^=0A=
>>> We're passing GFP_NOIO here so it just defaults to kcalloc() and will=
=0A=
>>> not vmalloc() the memory.=0A=
>>=0A=
>> Indeed... And the allocation can get a little too big for kmalloc().=0A=
>>=0A=
>> Johannes, I think we need to move that allocation before the rev_mutex l=
ocking,=0A=
>> using a local var for the allocated address, and then using GFP_KERNEL s=
hould be=0A=
>> safe... But not entirely sure. Using kmalloc would be simpler but on lar=
ge SMR=0A=
>> drives, that allocation will soon need to be 400K or so (i.e. 100,000 zo=
nes or=0A=
>> even more), too large for kmalloc to succeed reliably.=0A=
>>=0A=
> =0A=
> =0A=
> No I don't think so. A mutex isn't a spinlock so we can sleep on the allo=
cation.=0A=
> We can't use GFP_KERNEL as we're about to do I/O. blk_revalidate_disk_zon=
es() called=0A=
> a few line below also does the memalloc_noio_{save,restore}() dance.=0A=
=0A=
Yes, but blk_revalidate_disk_zones() only allocates the zone bitmaps and th=
ese=0A=
are much smaller. So kmalloc is fine and GFP_NOIO is natural. For the wp ar=
ray,=0A=
I think we really need kvmalloc() due to the potential very large size (and=
=0A=
growing with new drive models) and GFP_NOIO does not work for that. Not sur=
e if=0A=
memalloc_noio_{save,restore}() can change that in vmalloc context (I do not=
=0A=
think so).=0A=
=0A=
> Would a kmem_cache for these revalidations help us in any way?=0A=
=0A=
I am not familiar with that... Would need to dig into it.=0A=
=0A=
For this to be safe, we only need to guarantee forward progress, and in thi=
s=0A=
case this means not causing problems if a GFP_KERNEL allocation causes us t=
o=0A=
reenter the scsi driver for I/Os. Since (I think) revalidation never happen=
s in=0A=
FS or I/O context, GFP_KERNEL allocation should be safe if done outside of =
the=0A=
rev_mutex lock. Not 100% sure here, just a hunch... We may need to check th=
e=0A=
block layer level to check if there are any locks being held when revalidat=
ion=0A=
triggers.=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
