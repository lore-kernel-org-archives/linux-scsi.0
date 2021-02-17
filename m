Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D198CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8277864E2E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhBQJPZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 04:15:25 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:57078 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhBQJPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 04:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613553305; x=1645089305;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=zJ/ggUAnXsrrwFZXXrRx2uf+biz0RDqRUCXQaqY8fAA=;
  b=HUYDhNHvILYyD0X06Y8hiccZWegzG1pDnSAZfISJQvyk6R4XNluExaty
   jeH4ilwuhgCeI7rYktn36u3Dv4U2vZ8Nlz7HjCz3G4ZHcO4CGD5HzsqE5
   Zbf0cBN3iQ9Bb15NSWYWtwvUlhcJ/ioiTF1esh0vGWUWn1Inieb5e8+6C
   nBfBDwGbKgfkPx+fH+ZJXpUphjhUdL6US1+EyWsh2Jjd3kz6oHHjkYJBk
   A93xIQhRacnlWOFMdoRxONLbkZF8aaRkL/LrkcczGjkHGDIscU7jFtYbf
   2yFey5h6A2GlcPkqvAaz+V1M6EzmthOCGj8E+EL0dcFEG1ol7VGWaaHoA
   g==;
IronPort-SDR: 28HioJ+fFXtJ4rK3USw3PtQzh0r1xPUYtikzANcqCTyNdEisCg1R28zAUdUdpwH72umjjNuyb7
 x2fGjIm0nTn66FoYuk+Uodk/dNRuCuMhhJ7CtfQOUkahqhGdWTi3rvgR736yGcSuBKE8pbMVPP
 3KoUcJbbzLArIu19CCkb3ISroPPIb2ik1qCxXAiDqxxp/ST0+0PJL8HwhejLRYI168txjYpcW/
 njc7Sv+0xVyfzRtoqBKxd11SKou5+v6BK0XQh+qLOcdJJHtskxmSaTr5ottbve4Z8fipjNh/EV
 0a0=
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; 
   d="scan'208";a="161315997"
Received: from mail-bn3nam04lp2050.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.50])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2021 17:13:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DagLzdRLGNzzKXGyyHpTM4vomuw9G1FiCTjZot8b2/Fk3/J5H35TFjzmnSsxBpTGPPhyGyqbmVruUOStSdETqJnCoZV2Snbs50OXsyFEEaK37cHEYd/Qa2+XG45Vza+u1LYxx2RyL78b6s3VLGa2ntlJqgYajOfnhlTXHkoawV/jukcc4KueMWPd4NUNHIclgba/cviHRO3yDWPhkfyDMUPn7+wkeVixBtkr2aAEJTLxx5igMSefYyMsjvFNHw8qRHU+/AmkKDIlBq9BDsUdRLubXQ1lqERy//FvRVA8fEMMbtM60mJZfc57Y2T2/RIMAT7rkH/YMm27q0gWqMwrjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PeraGw1BYFVg/vwffU5sZmRJm8EVE/6MVP3ikcsk5w=;
 b=Rj8dWAUR7OTTlm90ygQNHAM0gBbYgdH4waqmlwPDdcw0qgNRgnWlcPjTtr23LWo56wcmmuG/u6W9F5kO1PC028S5HTy1ZV4uXS/xLMiv6fxYipiSCdqW9bnwqSSbw9k1RMALx1gkkuLMcSXX4DSsP/wrHr6QDiRaWrYe984xn3E3bWAPZ9SfqlZbjqko2ExZeofS9YsiwOyduW0TIhuRhc/I37IFqzEtPEZ/R9H3vOs08tZH8LVtDI5SLc4mlif+j1uQXsuJOSoMcY6KxSR6QktU7XgRSW6ug4u/1CDKkBxYUObD5idkvj18IwSHVsFeBXwAtCo3GCCB8fQZpiqcWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PeraGw1BYFVg/vwffU5sZmRJm8EVE/6MVP3ikcsk5w=;
 b=EmGCtufStz6+H2UO7FXxNj2gg06LgaMCSf64XoCcBIyJR+ZRaBZyzjq7dHJxB/XQxKtCVH0la2gUUJghOgyPbbaHd9MuDR/11g6CqWJXHPAO1dpzGGuOcplImdhfpSP35Fp63zw1qiuqGzJH5Y1grpC8ioHqlXs9PXwf8zi+lvY=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6688.namprd04.prod.outlook.com (2603:10b6:208:1ea::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 17 Feb
 2021 09:13:57 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 09:13:57 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Michal Hocko <mhocko@suse.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Topic: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Index: AQHXBJvkCA9zSw6fl0CK4GSwjGIV/w==
Date:   Wed, 17 Feb 2021 09:13:57 +0000
Message-ID: <BL0PR04MB651453A8B57118B3C1818ECDE7869@BL0PR04MB6514.namprd04.prod.outlook.com>
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
x-originating-ip: [2400:2411:43c0:6000:75c0:49b:2210:beaf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6f47295a-af10-44f7-ca79-08d8d3245b02
x-ms-traffictypediagnostic: MN2PR04MB6688:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB668894A945E24BA4AFFF03CFE7869@MN2PR04MB6688.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JtM5g38+H/v3P/IdiJ2+g2q0K05oAPk/5vAm+frYZkASaqYF4E6c7Kar5uLFD+au/bfmQfjzWiifuhBo8nJPekB3isUnJMAkzI2+ttnCVdraJUm+fvcpfZqdUYF6x3xEBfJQwczIN3V11Amh2mDtJYcKV2duMDGOb85qAysDi1qopRVysXVwlvxr6fX0GiI3A+uvK7qlb1IkvlmLZ0S54b+s5iGMy/Z397+QA1KyOMk8/G3ycWE+yg+0N9rdfG7SlCkjfRrB9p4cXFp/cdqO6IPY6lGzFA/C7k5UQqZeGGm9RAiSz4ZiKgpn8MkQLnD3tuW4Caq94CE0JXHVwoqQEmCrbJk1szAZYJ/hZ+Id4hXCM/p60Vj3zXEKr5wR1O0ZOkKBcISjnlBYtSwQzpcmoa1Dc+sBXNwWTaxa6ImKLn2zVtJRsetKkejmuueUemgV5+5HPi2CnsfIkmz/nfhc1nvodnnbOEh3xHUGIOUd+gqt3zADax+DjzEsuG4/9F9c/v8Esbt+leGDsqQMkzZxkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39850400004)(396003)(346002)(366004)(6636002)(71200400001)(66556008)(86362001)(83380400001)(66476007)(66946007)(110136005)(2906002)(9686003)(66446008)(33656002)(54906003)(64756008)(4326008)(186003)(7696005)(5660300002)(8936002)(52536014)(478600001)(76116006)(53546011)(6506007)(8676002)(91956017)(55016002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VAxZYXwu5XZv3Kaz4Xl3xrRykBZlg7aSHbKyJyTExit5wFMLmtqw8AMx/OV9?=
 =?us-ascii?Q?JfcMrQDrLnr8W/h8kXEqfpzngni+GzjqDf7AoUeYFerTN4nMxxvPHCRVu8uY?=
 =?us-ascii?Q?jSUaMd+QyfJB5TJ2ydBbqPD9tPKxLbHiIakV6DaZ90gN7XuDxTvFWEZVJplE?=
 =?us-ascii?Q?551SnzeMsB+cLVfR34LEBuQx+xaCDWqJZrcwIo1MsWpfvqw/yFU70HOiaUiG?=
 =?us-ascii?Q?Sa6TZZ5EyI++FhHVtjqQWmm4Xy+bX2DyQXfLvoVbm/5+8Ld7dRC0zU6Ubc+a?=
 =?us-ascii?Q?CuhOVVlngR68qpsX8oXP4SEfBJEqG6mUaUe3H+bDmxQDjpXnaJ+4EUG11NXp?=
 =?us-ascii?Q?i20B+lc5ljGjN13uHRmbCpfj0XM0NUXdfaZZro7obwGJY2l8a3BCQ0LiAT/h?=
 =?us-ascii?Q?hsmxOrUS0NejdCzCQWCCXfd3I8fjrP+s1Es01/4t+amx3vj5pvQpTx3Xg1vw?=
 =?us-ascii?Q?EavL0xYiO5gnyJGxzBs8FOQ23lDmLy/7KUVlViBAUhVEKdCFQ8fuQXlIRSPO?=
 =?us-ascii?Q?SLkhbwSwDdkcXxDBDxfiPALQyQ5DjqnC6g6RZMi+C6vLWJHK/3clByg4yrzm?=
 =?us-ascii?Q?SXdiE/JVi+uMY7+Q98bxZ0Jgj9QglZB9b0svVyi5PaTYh/pKCrp0m+T4EqtN?=
 =?us-ascii?Q?0MtbHzrmVr5Pe5XehqQ++tvjQ1aEFG++FQ0ZpV4u7ereGPewv23p1nBSuL4s?=
 =?us-ascii?Q?Jp2fHYSBOVG8sV5R5te/3XSZ9ZTv33/ulVN+K9HwB7HKMeTXEmCn/jQT8f0e?=
 =?us-ascii?Q?nBfYWWbZiNmKPkELHhrPAwNNhQ7bE1Zv1bHcFQ6tE0IU8TrnRJSnrwWK4IIh?=
 =?us-ascii?Q?LuW1H1XIQC/AzH6UyL/QAICEdXHi+KarixqUd3q7T65STBIRVXqJieO2wH6P?=
 =?us-ascii?Q?bFIWN4oaQKllOpQtvBdKAxfwRSVLbQGePDYdp5LmHn46QwBwvx8otbdRMmRH?=
 =?us-ascii?Q?znuabO0H56QwSHdtaAanTPhPlpLATju6imf/s3Jxw4+qP88rqE4gj0UzzuTj?=
 =?us-ascii?Q?Og2Pg71czRhlpP6SOg7OLt4HwSuzGW+ytmQt9RniHqGlN4rqpCdEhUE+aPUP?=
 =?us-ascii?Q?SbZS7h0bT2QifEWDHa5LWn/eCxreKTYrfLvo2Zs1foipRLp3PZZUmuCzN1Lc?=
 =?us-ascii?Q?aqGPcXrjAXs8kvct+YxAWvDzgJETrj0KWM785E5z5Qtd3Xs4EJ6/9WTe/Bl4?=
 =?us-ascii?Q?uEtlG9rf1D0HmBrLoLxYC0RYdgjbGiYKKBfwVIFPs7OXOokdbze8HHIFjdxR?=
 =?us-ascii?Q?CJsntsgJBjfahzrLD0T/TclruGqvHKtH+V3KIEzd2pfgcPILzQCH78YT5/bh?=
 =?us-ascii?Q?gxqMj8zd2bbbnfX86Ag11ByNUg/CyZ21zD8pSNY9PS+pvAWjRrbB6ZI+DCBr?=
 =?us-ascii?Q?NCOxCw9g5UPRd904iUNsHH1DNDnJCQpMGM/iVMLTGO5hbrnXPQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f47295a-af10-44f7-ca79-08d8d3245b02
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 09:13:57.1052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SnJVroyZs6LgjIc2s0WB7lfVfLxRCGXInl1PYjQ8Lkt5ugkvIPV05DQbyHjjTnszN3dWV4/ObNZLiZ5llVNuwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6688
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/02/17 17:03, Michal Hocko wrote:=0A=
> On Wed 17-02-21 06:42:37, Johannes Thumshirn wrote:=0A=
>> On 17/02/2021 00:33, Damien Le Moal wrote:=0A=
>>> On 2021/02/17 4:42, Dan Carpenter wrote:=0A=
>>>> Hello Johannes Thumshirn,=0A=
>>>>=0A=
>>>> The patch 5795eb443060: "scsi: sd_zbc: emulate ZONE_APPEND commands"=
=0A=
>>>> from May 12, 2020, leads to the following static checker warning:=0A=
>>>>=0A=
>>>> 	drivers/scsi/sd_zbc.c:741 sd_zbc_revalidate_zones()=0A=
>>>> 	error: kvmalloc() only makes sense with GFP_KERNEL=0A=
>>>>=0A=
>>>> drivers/scsi/sd_zbc.c=0A=
>>>>    721          /*=0A=
>>>>    722           * There is nothing to do for regular disks, including=
 host-aware disks=0A=
>>>>    723           * that have partitions.=0A=
>>>>    724           */=0A=
>>>>    725          if (!blk_queue_is_zoned(q))=0A=
>>>>    726                  return 0;=0A=
>>>>    727  =0A=
>>>>    728          /*=0A=
>>>>    729           * Make sure revalidate zones are serialized to ensure=
 exclusive=0A=
>>>>    730           * updates of the scsi disk data.=0A=
>>>>    731           */=0A=
>>>>    732          mutex_lock(&sdkp->rev_mutex);=0A=
>>>>    733  =0A=
>>>>    734          if (sdkp->zone_blocks =3D=3D zone_blocks &&=0A=
>>>>    735              sdkp->nr_zones =3D=3D nr_zones &&=0A=
>>>>    736              disk->queue->nr_zones =3D=3D nr_zones)=0A=
>>>>    737                  goto unlock;=0A=
>>>>    738  =0A=
>>>>    739          sdkp->zone_blocks =3D zone_blocks;=0A=
>>>>    740          sdkp->nr_zones =3D nr_zones;=0A=
>>>>    741          sdkp->rev_wp_offset =3D kvcalloc(nr_zones, sizeof(u32)=
, GFP_NOIO);=0A=
>>>>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^=0A=
>>>> We're passing GFP_NOIO here so it just defaults to kcalloc() and will=
=0A=
>>>> not vmalloc() the memory.=0A=
>>>=0A=
>>> Indeed... And the allocation can get a little too big for kmalloc().=0A=
>>>=0A=
>>> Johannes, I think we need to move that allocation before the rev_mutex =
locking,=0A=
>>> using a local var for the allocated address, and then using GFP_KERNEL =
should be=0A=
>>> safe... But not entirely sure. Using kmalloc would be simpler but on la=
rge SMR=0A=
>>> drives, that allocation will soon need to be 400K or so (i.e. 100,000 z=
ones or=0A=
>>> even more), too large for kmalloc to succeed reliably.=0A=
>>>=0A=
>>=0A=
>>=0A=
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
But it does not look like __vmalloc_node() (fallback in kvmalloc_node() if=
=0A=
kmalloc() fails) cares about the context allocation flags... I can't see=0A=
if/where the context allocation flags are taken into account. It looks like=
 only=0A=
the gfp_mask argument is used. Am I missing something ?=0A=
=0A=
>>=0A=
>> Would a kmem_cache for these revalidations help us in any way?=0A=
> =0A=
> I am not sure what you mean here.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
