Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87983C43381
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 23:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7162964E76
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 23:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhBPXe3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Feb 2021 18:34:29 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59365 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhBPXe2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2021 18:34:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613519579; x=1645055579;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Dmk3g6w/jpAG9G/zekQaRkU2RYixOWR0FJbipJLskFg=;
  b=VeKHBDCturJb5RhhB2MFfgxIG/GIO0KCuUXx0sVAHNW3Gc/e7zK7t/Y+
   BFsBzaRpowl72s1Mgrtl3lizzxDAFrXpHYbIDa7xR47/5yef1OGUZuhL8
   u4mi8LRV2JFKyjgHDhWWQxgG6Rg8lHiGgxl0xucjNGqfn8/fyFGtkt+MC
   6qjdF4UE/PX5Bioa08cWMS7mIZhY/qtTS/uhwD+ApWvqt2jhCjzbsnSav
   uMFxgJB66/HmXsvSC7dQRTlcM55j1bAqIOujDqHzjcHh2hUziUhNP9sPQ
   DEHKf44M1RrzlHC31C7xk9f8/r4ZM14s2ks13mtfTJR+E6IpU0hNVYdTJ
   Q==;
IronPort-SDR: ezewgBE0znLPBh7MxEgsHW3va4XxeOdYQKrf7cabkVEb3PqNBRkejbZKVaUa8sNw/bzzLdiCeF
 3L/BjIoheOvy5Agrau9ASX3wRySoIicVs9Z85m6C74/e539Ri36BiOXLrvUmIDJRu46SzYBKhd
 YeDEe3eBmnvFs/Xv/2CTOyfblM96VjS+p+N+DbCKunLTGzROUuPTObNkTfNPLm6k4bmtgNxeti
 pXhRcxkDugF5Y1pvGkKBeYIY6+kBZ8TgMlfanE+v0ogGeDKlfiivtKgcpcmCwdh9JgS+j3VzF3
 N2w=
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; 
   d="scan'208";a="264271853"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2021 07:51:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJoFhATCjCt8IPUbyYnDmPxsI0ZMbdS8sHXPXijDXyEFPQyFS9LRmB2nudi64ma21T5jkBLCMf30UMz3WJMtJgpXeNaLkmgp+awaeFdU/XwINAYkh66WVeeiOUyw3PyfnPL5deGzYV2+yNqut+449UeC8yzor1qJFFbFSaiTRJW0u6wqufh3tbUUvpBJgpb2SElHGE3pKXEMQszqJQgPVuXyNrTRKUaTOwdmI3f/idf8KVBPyOJHSsENGpaZeMxOEZrLGZvU3iR9ydRfnXekuRimqTDP0jY26uJ1p9RG7iXpE46KJ4Uq4DL9Hh2Wg2U3PfmldtsMYMwckY2Hl1mbRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHwHFthhdzKgPxKnDLdJpiiNY1ogp1pOZOSQxexjRDI=;
 b=K2TSl7V7CveIYo8OvDC7Ljgq0Uby9MQO7tkCP3s6zcNvkjJAIBMu5Taseu1FQmaaf9DpRRQNkjL3biAVKPu9uSzdBuzPTWdWGpun0MjiJfEb/Rv5HtlZd1fCqLzcV4x+iDGXDuKXl/0NwH70gbcM8WEW4Tk8m9NW9nFpLNrxMaFOB/Cu1yAQEO9X6ganX0untrZIxYjZNXu7f7OylYJcpx0pEdEP4FjoTqAh4qttyUTGpUzEbCRT3w01IY9IdBUhHruz8hSjPB+Wzgrzct2BNr9XoEhtyrx1p3vi1UcohuXZWkEARkLDRgv9ODUeftkx+kuSeS6byi/GWwL99J1sZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHwHFthhdzKgPxKnDLdJpiiNY1ogp1pOZOSQxexjRDI=;
 b=TdD9TtIR8Uj8X42/jf98IV2L+0FVH40wqSpAxC7IcpqQ3gq9stZPgYDKsNKxOoCHpA/Ex1sai9b+VU+W7syvBbHtpCbbkgW2pc0SFnO6iTGx9baR+mxnlKzgq3TWqnLo5P35fL2yG2in4xm2fiBbaOypVqWMIqZxe0GnBWn5bS4=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB4449.namprd04.prod.outlook.com (2603:10b6:208:4e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Tue, 16 Feb
 2021 23:33:18 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3846.042; Tue, 16 Feb 2021
 23:33:18 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Topic: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Index: AQHXBJvkCA9zSw6fl0CK4GSwjGIV/w==
Date:   Tue, 16 Feb 2021 23:33:18 +0000
Message-ID: <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <YCuvSfKw4qEQBr/t@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:75c0:49b:2210:beaf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0f2576a4-c51b-47a2-d171-08d8d2d33d7d
x-ms-traffictypediagnostic: BL0PR04MB4449:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB4449DED9A8B2960EA91F0F44E7879@BL0PR04MB4449.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L3+UAF5vfzXPIS8QIdQVxVOBqGRjw2Kh5hZnXA3mGeijivfooOkcou5cJTNBF2MJ7258JnpFaHWq+knGUQCSdUd0d30ARCYWPcZYplyHWr7r23mq3at4ztslQNNHueHLTmFLbTmV7WW/HmKrIBMWSclPvVKayPpmaQ1oWvk9+vDb9W0r6alJj7Lbd5bOrFsoAfbRIiX7zVXOWAFMqxpwmAHlRdPqkd6EZx9gB5EK8Sw6ZstITwppPUy8DVRe4dVezUZSm1MffU9YfLUs1lVJgtGVVoI3yKxCWTJzx1XedM2wLqlYutppoePb4coRzweRw45BFnrJUqR+oCqR3iXldpsyEp49/B/Yx9SB68e8p6PfENbQjSWm2OCB2nBK2BINJdT2VAEtYSoTEFbjSgFjnUzb1wKlaKd1J8w2FweRlCh+iE8TuwHJn+7ALRHIz5AR2pU8ZhnJ99eid0zUe3FivGeiC4wZYSlduVwBY1saVr9bveKFWMCVK5Uk51Zns0pDtiTChHkntNYDPydfzHd5cA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(66946007)(8936002)(4326008)(91956017)(54906003)(55016002)(7696005)(33656002)(6506007)(6636002)(316002)(83380400001)(76116006)(186003)(5660300002)(9686003)(8676002)(66476007)(53546011)(110136005)(52536014)(2906002)(86362001)(66446008)(71200400001)(478600001)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zI8Ays4wLUW9zXScjBO7ISpfSS5MThzabDGgPOBcXq8UJdCSWdW0mNaxxu5D?=
 =?us-ascii?Q?EcBz+XuY4+kmoAF99GwH8I9LMzrSFcPiLci8E4N62CaPIz+GASMranqaUCIa?=
 =?us-ascii?Q?wTMzmEhFbZ6CIF5qhkP1Gv5wnfon5mLjotujIbct1LhxMkqfJrXYL7sRVeo3?=
 =?us-ascii?Q?mYrX3UaktzLxsP/CHINGfWkms5uFnFwqyMVLG1nfc+oMQOUlMvXelAChDD10?=
 =?us-ascii?Q?6svC+jYBmSphnAg587awe5rtEgYUM6wYOP8q9JiYoIs4eAEVwvoFtqSW9J1d?=
 =?us-ascii?Q?/+QjXtPUE64shX4fmoFuUWVyHrpFoEhLIvyCs5zoYpIjK08hDFLi5+zV387K?=
 =?us-ascii?Q?E1PzeHeEKgUj5AVy6gbLuVpGDAQLx4mMI8sDbZ7gMkm6BNmVrsqB2Rr5U9dC?=
 =?us-ascii?Q?Uk62C4hDaNF1c3QMGjupdD1UujLGqTUB4y1nSJw3ep6Tt5j0rwNFjTj3KwCP?=
 =?us-ascii?Q?KYFFCIWHGuR41131tsNjMX/e4bAg7e0VSB0m2YRvzF6XjPvNSbyhToQj8851?=
 =?us-ascii?Q?i6GqMVtXxzJ2PN552ZZUXEO1Kc/KCmT/I3JtGXs1E0XTSTOc8vwT4oQN4ALT?=
 =?us-ascii?Q?dF8J05ffsdhxh8/ZAQbswmkNTIO8pVWgQdFIQrHJYjueUa71nzT9QuaY3U5v?=
 =?us-ascii?Q?jhJhbU5KTcsIQwP1g6/lIEj4CzOQUXSSJ4EiR9taulMRajD5cJFPZPHYLXh3?=
 =?us-ascii?Q?z+uMP17obij4qJAy0T1XgQUFxe+NneQHt+iJdqFen7Y0LZKhmFUEJzzDXKam?=
 =?us-ascii?Q?lQZF2UoLrUOOI8X6Y2X/gKpYc02k3XyZE5yzWrpxIk0KDgEU8FphIsBPS38V?=
 =?us-ascii?Q?whzyqlb45Q6zE9y793DHpZqXEkEQ8lRBTELETjZG0iDFCHbjXks8us7iai0B?=
 =?us-ascii?Q?G/fyoP1Mf4DHnHcF7NDBLHBqZQc8TjjSEUGipzzUULjgNrhg9vH0rQCS1EJF?=
 =?us-ascii?Q?9NmJMejbreQ0ItzKjDaH/btcU4vM6gSzfZZtrrAZF/4Fd55/qTdbAN07HU6E?=
 =?us-ascii?Q?mZnYy9GcOaY0hKCIKkTsysDKNkFhBrjOONlMZNRvA5bQvaSKN0OfxAliyDDI?=
 =?us-ascii?Q?8gYcP8gzdIuWr5jonfTAPNpADS9LIIBicZjWTk3yBUMAqt2xZMtl7nsfsPiB?=
 =?us-ascii?Q?afn34U4sNegvdRDdf6tFykGW3D3GJF8iIAnlA8vFIBNag8NR2oz3tJfbojz7?=
 =?us-ascii?Q?AQ4sVnwtSj+AmzrBYGE8yaoMtAxvSbD0MYSHM/ac0/uKSbvjrB1769tYqwSe?=
 =?us-ascii?Q?otJQrs7cof7ZhEgF0wyO4IYqYTMxBvxVVg+jKsdi0nUklQZgcRKHI+TdRSE6?=
 =?us-ascii?Q?elkVChuVxHtZbcB3ld5q+onybPHq3PxlVcRAt8miFbgYm1UzRnVYBYMT7Dr7?=
 =?us-ascii?Q?QHGyZ5VsrfBJ2fq6GbtJNkGaFkVGlmc1dU+FrjqPaLvRQOrGOQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2576a4-c51b-47a2-d171-08d8d2d33d7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 23:33:18.3278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rMka9huO5R/hTgIeIZmy1hKitx84OoSybB+8aaD/Hsxq6SmdtJcvdtjRDonuLVBcLBwBn12H1Lnemm/Lq37MVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4449
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/02/17 4:42, Dan Carpenter wrote:=0A=
> Hello Johannes Thumshirn,=0A=
> =0A=
> The patch 5795eb443060: "scsi: sd_zbc: emulate ZONE_APPEND commands"=0A=
> from May 12, 2020, leads to the following static checker warning:=0A=
> =0A=
> 	drivers/scsi/sd_zbc.c:741 sd_zbc_revalidate_zones()=0A=
> 	error: kvmalloc() only makes sense with GFP_KERNEL=0A=
> =0A=
> drivers/scsi/sd_zbc.c=0A=
>    721          /*=0A=
>    722           * There is nothing to do for regular disks, including ho=
st-aware disks=0A=
>    723           * that have partitions.=0A=
>    724           */=0A=
>    725          if (!blk_queue_is_zoned(q))=0A=
>    726                  return 0;=0A=
>    727  =0A=
>    728          /*=0A=
>    729           * Make sure revalidate zones are serialized to ensure ex=
clusive=0A=
>    730           * updates of the scsi disk data.=0A=
>    731           */=0A=
>    732          mutex_lock(&sdkp->rev_mutex);=0A=
>    733  =0A=
>    734          if (sdkp->zone_blocks =3D=3D zone_blocks &&=0A=
>    735              sdkp->nr_zones =3D=3D nr_zones &&=0A=
>    736              disk->queue->nr_zones =3D=3D nr_zones)=0A=
>    737                  goto unlock;=0A=
>    738  =0A=
>    739          sdkp->zone_blocks =3D zone_blocks;=0A=
>    740          sdkp->nr_zones =3D nr_zones;=0A=
>    741          sdkp->rev_wp_offset =3D kvcalloc(nr_zones, sizeof(u32), G=
FP_NOIO);=0A=
>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^=0A=
> We're passing GFP_NOIO here so it just defaults to kcalloc() and will=0A=
> not vmalloc() the memory.=0A=
=0A=
Indeed... And the allocation can get a little too big for kmalloc().=0A=
=0A=
Johannes, I think we need to move that allocation before the rev_mutex lock=
ing,=0A=
using a local var for the allocated address, and then using GFP_KERNEL shou=
ld be=0A=
safe... But not entirely sure. Using kmalloc would be simpler but on large =
SMR=0A=
drives, that allocation will soon need to be 400K or so (i.e. 100,000 zones=
 or=0A=
even more), too large for kmalloc to succeed reliably.=0A=
=0A=
> =0A=
>    742          if (!sdkp->rev_wp_offset) {=0A=
>    743                  ret =3D -ENOMEM;=0A=
>    744                  goto unlock;=0A=
>    745          }=0A=
>    746  =0A=
>    747          ret =3D blk_revalidate_disk_zones(disk, sd_zbc_revalidate=
_zones_cb);=0A=
>    748  =0A=
> =0A=
> regards,=0A=
> dan carpenter=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
