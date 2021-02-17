Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB06C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C5F64DF0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhBQJJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 04:09:15 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:45598 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbhBQJJO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 04:09:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613552954; x=1645088954;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=4Adlvc7r7VprTky0vUIEID9o6uS40l2xsXmV+bVlfqA=;
  b=RKjHo//7AMNGMnpCbqrFzLDKSMczPC/Gi438Iydf2p8KVerKACZp1U7f
   18EiXzZ4jVv0jX+4ErpO9QLNzoo3pUS44SahKOJkvVjEnlWd17g9C6KBz
   btr5TukRvsfhBTmUui3oCLjI6mOIHzZ4cJ9lhnUYgXk77mFxlrOR1PTjb
   WlE5/C23eveFMO+IYHhsUJLwsNvTPTVBKiRMI7iIkKunS+u9v13H/usaF
   2XkGdDNCDGkbhp0Js0mEsuO0ayHqIZQW0Uqdvt4MGw4bIBlJOzT8JCtbv
   HEm3qtN4/oiLAEpPRN58YJuZHwtNv3YI+3B9VYdTK0iCUao87W5APHEKK
   A==;
IronPort-SDR: DjvUcTo79ez7usSfXYDwp1zXD0OaCsdGDAd/GmapWA2OkXeho1YiKgrlFqMD8GZ4KtmN5bxGng
 YCAbbKn4+2FyPWCoSjkfyCesi0xiCY/Y5/x9rENm3g8V2/EVSUriX1YhkNm0JgbM5/ehUF7JcD
 KKB8d07xPrZwlT+YbnnRbXubVpHBDw8iXLh30hthL+K0qws4Bs+e/zyVLPrFwdLNHivwnNDK+A
 y4FK4UoXe0TKVNKbzrVLartnLTWXq0OtfqtpW6iY4acSPYxys7YHxw/mjJkTAuKufVEvdiVV8T
 yA4=
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; 
   d="scan'208";a="164627562"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2021 17:08:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofC1vf/gXe/E2O8plouNzS4eczeHZxEqNDKvmUT4b2jZl4TjdWSCxBDjOgZMu7MtgiCHnltbmdCxXXukv2SApFNPZ+J5s09V1L+6UuHmoj3qJedjI1puU/yzp6bgjAhWPWyDP3X6G8PReb2fgXqxAXsONfwhibIYrXl3OgMBVlZjoeR3JqsGDlhLKHl+Q0LDYJpb/Y4bwRZF2y0u4ovPHJmhUKq4swYW2FDTvIyttTENY+M3ecuQUZu1UPenXLJHprtI1syLdKXI0M/BxZPBSw3F9L4PgKR98+DQqdZoJx0UxLXqWPDGcAC8EdCbPRqf75z2TcYc4KX9cDPc5WOL1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Adlvc7r7VprTky0vUIEID9o6uS40l2xsXmV+bVlfqA=;
 b=a3t3psZ/tg7WTWgp3P7vV6Wjxc0tVAKuO3wPulncg95Eg0Ij/SOMLiyky+HYk+CfMuhR1/8DnjxApBZeourQKZdOVVX2tKl4XbEA5L3VQIvT2qGS1FIFNSmnIdVuvKxr1c2w3FizKJ6v8hVGzbYsjdHa7wmHsWBZgIX7pnM8M+IbgsutN4CPh69+PAzMj0hgOMHi7flbm7ioaWTQvAbO6Z/NNRzE2nmAF0uv4VqzTfusrCq69dNAI78k9QGGDhDf9wRS2dGoP126hVY84Krghx1wRKH0HCWbd/IRFJh+C1XlQWN4moJhWO+bIoJ88bbhoN6xxShIXmkC6sl6WIY2nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Adlvc7r7VprTky0vUIEID9o6uS40l2xsXmV+bVlfqA=;
 b=RgW/2qFZtR9+/WeL488f1MVN8E9avg2LqVNm+6/nBrcwrHLDm6cF4HXpM4ZboLxmz5I/8eZALhjbrIC5izvoBu3FmpOuRhbeQmGwQ/QWT7BAg2QEfjts7+rwcrD/CRpOPp4fQPeYA17ojZmHJicwygIMN4W0cSJjfbzXd1HDszw=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SA2PR04MB7612.namprd04.prod.outlook.com
 (2603:10b6:806:147::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.35; Wed, 17 Feb
 2021 09:08:08 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%7]) with mapi id 15.20.3846.038; Wed, 17 Feb 2021
 09:08:07 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Michal Hocko <mhocko@suse.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Topic: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Index: AQHXBJuZNMPC4HbBMEOENoattX2qog==
Date:   Wed, 17 Feb 2021 09:08:07 +0000
Message-ID: <SN4PR0401MB3598D86F05613F41049038BB9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <YCzN4qPicujdSJ7P@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:1923:7af3:ae74:5873]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f2b80507-1a8d-4487-f7eb-08d8d3238ad5
x-ms-traffictypediagnostic: SA2PR04MB7612:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR04MB761211D4C5066CBB928D3EF39B869@SA2PR04MB7612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S9+smy/ucnCe7LxFNWEXMhvTX83cbGd+uaW0Gwhz53yHZi+A14IUqpE1IomtvDY2yvNmsY6Hdm+x5Miow3C0xsiBroIJir4AezfkJF4tc4Hbg0/5+IdTF54j58LoulsYL+knJU6k3AzFvpXshcdy6zlFd8KDYYnxKYMn9IvTqGUi9lxyeYn+zelG747egRlD/ff/yi/a/8RIwd6FOWZDhOg5cQN7SUJhySqwvNR82dCvyHkEg/04pPwSxOxwf5RqCfhCT7FJkrQO16pyUlnZAbG8tUxAtuuQlLSU7u6MK7b0wH+yNyTLbtv8+yqfjTqeMHWmnF/xnWeMg6OnBTNZbapbixYFR3zCLDKsmAtROAzD/cbJcaRFIg9BRPRn1r83Ydv18Dy/bUlqDf4KFCQ5YqNtK5DOORJZ9YK9cbJS01NqH+d3cd34F8nUVL/XIYEZeJk212mRmpdkmsKHJJkzWTjwKX5+N1pCARXV+OJY/siEcvJkB3ucsdVRSBHGBBpZ+P0TepIlt76v7zRr4WuLdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39850400004)(91956017)(8676002)(4744005)(66946007)(52536014)(54906003)(86362001)(66446008)(76116006)(478600001)(4326008)(7696005)(66476007)(64756008)(186003)(66556008)(33656002)(5660300002)(6916009)(9686003)(8936002)(2906002)(55016002)(83380400001)(53546011)(316002)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bOTMC+BLia2FqhA4biXcwLvtRjvDoMBv1lz2BZ/6Zh5PJWbdQtU7uxy7KLaq?=
 =?us-ascii?Q?tvt983qY+It76e7944M2w2gdGvP30a8/twLaL4fwZqfgJKLL8UOvv2WbtPuL?=
 =?us-ascii?Q?7lQeM98952r8Ng9vuly+XgIpveRYFA9VqcmhPl4v/oX+V/4mG8tVTaPPwAfq?=
 =?us-ascii?Q?QNFg3FdizuF2qt3uMesqBdzDlZotzAxINLZKkEnuTb/yB3A7TnNDVbQ3X+/Q?=
 =?us-ascii?Q?6v24O7MW9oJdl/BL8RpDjq6Lrf1LxFbpXWDtp0JgiVDiLlUpospcGWpUVeHn?=
 =?us-ascii?Q?cQCuBUZg3kHpJamcSjHBD67teLbbraF6iHiCOkhoMtanZ/E0RCLk4hkUlH9o?=
 =?us-ascii?Q?rkTVNVxxzNqFjK108zmN4XhcynZLSPyrPe6ZxnOtf70SZAn8v4yC7LyncSp8?=
 =?us-ascii?Q?FJBB/6Ulf5lLrEbjOzt7fMxtF6/COJL+j5yJ83ox6EkuTqHTsRfBrOk8Auvx?=
 =?us-ascii?Q?2x+YplAQbgwXhUurhxE66uqGYYonRvd3wgH+MgSmHdJs9LJi1/vm631bHAwR?=
 =?us-ascii?Q?S5j5oe+HYJTIHcLtEu0OGeugRuWLSg6jaAMHZNKfNEUB0bWIsh+QE4O/n12Z?=
 =?us-ascii?Q?L4fVWR5tvhZIGHD+e2GQEkDkdpavEJdB2y+XupmTyumCZ6BoG/ZPxGDipies?=
 =?us-ascii?Q?Dw5X6+2qrNzeOQdJxe+cmr/PaDF8RaqloDbqSibhiWTINJHWzSJIh5a96fOX?=
 =?us-ascii?Q?RLlsoifmogLEaR8RvuTOCYuhHW6f0SJkqcHcIS8hmlqtMAvXWpjd4xFN/rWb?=
 =?us-ascii?Q?ZcwYJWtXrhLAUJX7cyFnG8f2WsqYrdOabdNXdpKlQsRfV9AizrEP4wuAoRxB?=
 =?us-ascii?Q?JSMcOvmjP3bfJaE8XvZAJkZLGlcYU0qNx0Bawjuv+OH+ttPyjkoyWRGZvBEc?=
 =?us-ascii?Q?dyQK7ZaJ7hVvdR0nj/Ya6E68LMO8j+FbTfb0MmL4aF9hI61eiGVX2pX2SRvj?=
 =?us-ascii?Q?WX2tACYboJjvsDvITLk6MbyXgVLKuWJPRMmcdMccn/SMw2JHiYHaqL0lAL0g?=
 =?us-ascii?Q?2MUKJT0pFXZOCK/h13RK9e3LOA2OXMZIf8d9m3sEobtPiNrIc73J/6cw+WEX?=
 =?us-ascii?Q?sE+kGMDJlPcsEsKtj0gl8vwv3lB1giikl7VgEGWXetn5eMgJy/EqVoPhq57P?=
 =?us-ascii?Q?lvwS5p2z+/4qcFMbTytRJR6lBg1SLE6VKkvAk3dNll9orWaw7SizBVdcEKjE?=
 =?us-ascii?Q?gg0bbCaVKrxsRGnLmQJi0H+Z4N7aQGdlpRwXqF0nCcW5uCrX0B/AH4VDVwiZ?=
 =?us-ascii?Q?4s2kAycqOviMCYWYNeupY76WSv9DVjG+pLWo7JBWLcIlgkHDeY+5SnXTjpFV?=
 =?us-ascii?Q?ISk7U13XjfpxO8g0FXAMeJ0o0nF5CGZ4nFc7tESU3UK5/PMiaqRz8StTJtlY?=
 =?us-ascii?Q?0neWvVcXpqa2AydJ0pzmnEXJXcPls7ZLRsDVlKCGmBD/AkeQ6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b80507-1a8d-4487-f7eb-08d8d3238ad5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 09:08:07.8160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mj84aomaJhiXaKA0qQwc2SyHNBmboKxNRZP2+gtJMMKebaz9Jix9M3bzNyEUhag1AFskt2uEaQynUVil9+aK/2ldo7jZH4NDCxzxoMbHwQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7612
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/02/2021 09:03, Michal Hocko wrote:=0A=
>> No I don't think so. A mutex isn't a spinlock so we can sleep on the all=
ocation.=0A=
>> We can't use GFP_KERNEL as we're about to do I/O. blk_revalidate_disk_zo=
nes() called=0A=
>> a few line below also does the memalloc_noio_{save,restore}() dance.=0A=
> =0A=
> You should be extending noio scope then if this allocation falls into=0A=
> the same category. Ideally the scope should start at the recursion place=
=0A=
> and end where the scope really ened.=0A=
=0A=
That means all callers of blk_revalidate_disk_zones() should do =0A=
memalloc_noio_{save,restore}? If yes, can we somehow runtime assert=0A=
that this is done, so we don't end up with bad surprises?=0A=
=0A=
>>=0A=
>> Would a kmem_cache for these revalidations help us in any way?=0A=
> =0A=
> I am not sure what you mean here.=0A=
> =0A=
=0A=
Using a kmem_cache for the allocations passed into blk_revalidate_disk_zone=
s().=0A=
I've looked into kmem_cache_alloc() and I couldn't find anything that speak=
s =0A=
against it, but I'm not too familiar with the code.=0A=
