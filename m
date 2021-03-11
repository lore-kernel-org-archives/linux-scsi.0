Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9E6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 03:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F4664FCC
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 03:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhCKDOh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:14:37 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:56357 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhCKDOQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 22:14:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615432458; x=1646968458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LWte9AatFw9kzPJFCyfxzz6/Rq9Q9jS24uta6qXgUbc=;
  b=gNO7NncWJU8UvYhdGXNolcpVqX23BhGprtRhXdrnpA5bb6bpRI6BzOUq
   zqf1Jf31IF8BaM7GaftdwwunfYJMM5/j7kQPduZbpNAhLTRnLX8F80Yga
   2SOnMdwyU/5sdiBOYxhT6fnMslGOOVJ3w7McFsatPvFYvsMvz2HtASLwz
   A/Zw9lhIzJx13wjrp86TyBpbD4WOpBNAPu6TuztsOEX03JwbzrbezA2yN
   2seAL6wiSbV3bTlI9hd4StVbNd5ssqNwSntklnEfiuoNh+4A9PqATbZ8X
   3BbrPV9pg0MB/Qb0tI5agiWKAFZvk9WriuyxtZ1rvD6g2QhXPa2vzvW/E
   A==;
IronPort-SDR: Rj6nmYYkQIDBPd/F1ZImmkcRWOzYHaoVrovi9HzfugNLe6bai6v/S2DjUPgXTjeV1AMmUP6mNl
 G7LuYv5BVUs0tclcjG/Qvclc1nc2WkoocWLeOLnRzhW9O3q+7L3HZZfyyMaCp/QXzw7sJEVZ6d
 VMQQOViKmjr59T6G9n4BxY5BQFmp6YZgqwx5t7Y5nmMejM4fBPJRtWg5W8dG3HgZcOzsmulKph
 ZZiyjtlUK+R5FwXEx9PxZXPF3b0nz1hRsiuwaZP9Q6oHcO8qp+AJtnCWtS4dgPpkeQY/S6cYdc
 VoM=
X-IronPort-AV: E=Sophos;i="5.81,238,1610380800"; 
   d="scan'208";a="266223927"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 11:14:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9FlcBh7x7FvNz4+YVdHBg4Sd+Wb+NIfMqxIf6xXbzMJyT4cqUhbpFZdnX6rrZHZwCnNxqSkm7UfRJUGOIJxORb/5o4Tddesfh41aLGI99Qi862vP78N+rkrC8TwGHNjAtuzS47StBcfo72/T+oMdWsf8JZ2PudqraAzDsU9Qb+r6AIV93/MFfFgthMKPWbnryxuA+Db6z2xd7IFTBAXFiKT0f7iHcYvkr7G0nuwU0dMtSCPSZ1zvUhI9B9AUcGCH/wA6Cq1aFNp1FfTh7NfubwUiHTtmFknKHDK/TlM0lCfu35wDiarGIMFq44VKeRTnPlVGIbQSi2/DppbyUt0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV0jTncTVVpZHVopSAYwua3JlxLsHlnvBn3H6ifj9YY=;
 b=iOZj405SFTYmr0il4xneVHhAoGTMIp3GPXxdV9v1pygMSkMZZ+3Q68pWkTscyyMuMQXvtTVmfWAF1lCvm/6ogTuN7cGu0QoybW7NxG7bi2+ISgsLZzatnsKfbVPINgcUIv/wUdyV41OwE9LX3gvu9C9iSGcnpvEzBbPoDRM8/aw/cBz5JAF4CKSuyfz6mWvaqwl1yWIv72Tn5gjlBxlL6t+PLCczazQs4CuecT/PC9MzvqR5XhexBEtL0HXAxlzZiwb1V5oUtSM57V82Lk6WE2LtfIdcb1fXDTOEGeD6na4antydiWpNv0tDjNm3Mp8WQe6DszPrSPZhmy/K71+Pvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV0jTncTVVpZHVopSAYwua3JlxLsHlnvBn3H6ifj9YY=;
 b=gkLVEmnDodo3Gryp8ot5NTLTlGKcLvnLgj5t5Ui6qewOxV1dpldA0KnyjOJEKyUxwT0JZKduBvM2/s8I9zMSfHZlvcxVz+TauwndqrsWlpLOYxcv/ZDiNFMLofF2J+2pwd+2o0drt/i3usknbKlIIKL7rJwNk15AjLaD1fu0UvM=
Received: from BYAPR04MB3800.namprd04.prod.outlook.com (2603:10b6:a02:ad::20)
 by BYAPR04MB3798.namprd04.prod.outlook.com (2603:10b6:a02:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Thu, 11 Mar
 2021 03:14:14 +0000
Received: from BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::61ad:9cbe:7867:6972]) by BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::61ad:9cbe:7867:6972%7]) with mapi id 15.20.3890.041; Thu, 11 Mar 2021
 03:14:14 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Q2LbIxWjkkW7HLcT3Xe81Kp+HhOA
Date:   Thu, 11 Mar 2021 03:14:14 +0000
Message-ID: <20210311031413.lxxffhw2jy2lgrxe@shindev.dhcp.fujisawa.hgst.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
In-Reply-To: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a8681bda-bd26-4e34-6797-08d8e43bbfde
x-ms-traffictypediagnostic: BYAPR04MB3798:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB3798692851DC44B6E5150473ED909@BYAPR04MB3798.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GvCB//bhh7nKBPYUroi8r+Y5Rg+7CiXDH7sAl8Xd851RiGG/d+8MeMpVMVTikrdEV6im2onn1FqyIpjdCs5Wl9vpI4eoTVC2MNTwX3XeEnHi0IxQQw0b5PYt9i3YU6/WAIEilqMT2AjHuzVqtDpXQJG4gz+kfhMvtiBAX/V7SLUMQqF62x1adRforWt1e+AhZqnfGpQJEVC5dvVRVgthBOfD509Wyo3rWBz7quMilVhsWwblC6XS6vhDVM3EGSxMXHXcrAbtS4QMR0OeswjogSEELFsqPzHdCVAmxH999vQVF5NXp7uohxEhgdEp2THQ6OrgfkQUksvcyvfao6BFmorjGUteOFjLh/kSmb8tRG15rimV7RpiqZFs6jd+gD1L+p8pKShjje1f35mznws8b/JRddkL6dM0iTx/Kyz65mbjKOb+hovCgqUf5sfnw8/14pHtb5etrofR7g7sgsbDTrZS8h1enU7T8fvp8dKSpiIDbXB0hneNFFR8IOnP1fjZOeLt/pXqzoRLIJoPQDVaGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB3800.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(83380400001)(6486002)(66946007)(6862004)(186003)(44832011)(66446008)(86362001)(316002)(8936002)(54906003)(15650500001)(76116006)(6506007)(4326008)(1076003)(26005)(91956017)(478600001)(64756008)(9686003)(6636002)(66476007)(2906002)(6512007)(5660300002)(8676002)(66556008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XaP/V6WhoEjLVJZSkHcoETjXOLBgzuL4ayU+YUj1UmPbssk3LsUVF5+LB1Wp?=
 =?us-ascii?Q?LcT0y3dVHigUWCOfwCLc29OG+ipTyg0etUm7ST5cX7ln3osTcuyS5NRO5xhp?=
 =?us-ascii?Q?6BWMzam/0Yh23lUlAHJzbs0R8RMk60grkj3mxUvkigwvN7fqxdEOCKOw6F7j?=
 =?us-ascii?Q?7LG+TJ49M2cyB6yVnksCetig5sw0yc/b5Ds7didayu2CCDTzeIC/XuujeUsO?=
 =?us-ascii?Q?+FBV1ScteYqg5cpBioRVB3ewu1KYng9D0JHMmumP+s9kVRQ44Po27+MtOTAE?=
 =?us-ascii?Q?nXYI/1975ZBtMqdZsFjc6ze4+XeKlZ9PoQsElBWg2Y4XavjPp7HIdwf3i87W?=
 =?us-ascii?Q?XuvtsejRRHq912/Xdnc5+eMk+B0NOHEdj00z31ewUb6idj/uUj1uoGusu0TZ?=
 =?us-ascii?Q?KY7Ui8tK+t7lsnaAkK9pMVMvoMzZC6QR68Jimj+8rMF0j4m85m01fQTdIvWO?=
 =?us-ascii?Q?f44jTdzY6ljccL6f4XHnOcMp17svOlt4EJmpUz0uWQDg2tuHG56jagUpB835?=
 =?us-ascii?Q?gBXOacDXj2yAaYc3QOjeEFQ88WRkkK8mxNzmyydIumxv2wToG48mYb0moYgq?=
 =?us-ascii?Q?YfubSrIyF3r151JiDtCa11FLS2iukPWqf+XnoS9lgH46yb/39eU/p6WMpgNi?=
 =?us-ascii?Q?YWu2IjFUKC2SaKYJd8LHwiCeEgKYpdSyzg2NjkLC3oJAsyFsgmJJu5HUCi+3?=
 =?us-ascii?Q?s3tHrHprv8w2CN1gzG2jLnu6XseZ6WZqC/0XSOAlLGzPdad5AwkOSgC1Xnx5?=
 =?us-ascii?Q?xveRA7Bz1SfpPW6zTBPIG2XY5zEtASEybvN+OlvpeNgcWcVTIG097ksTxUbr?=
 =?us-ascii?Q?kD4kpwkM9wo9Um1F9HkdzN3cMQQOdjZVrl+E76rVckxToDVNjasbJ2NSAWHF?=
 =?us-ascii?Q?Xwi+SE+mxZKXmU2jqFpwGMoS79cfa+t5j7dy3HJnEPSNjt1veV7yGJinlDYA?=
 =?us-ascii?Q?vG3XHmZp97aZYRljVqWm1JJu6qKGVHvgDlTn0lkT+K+j3CLzKTHnSGuOnIqm?=
 =?us-ascii?Q?0wn6wonqAojqPa+X/fPZ9kRLX1hgFP1HZ7i1AD6pZMxRd4sWLkhR27UQ+tq7?=
 =?us-ascii?Q?cr9g6Nohj3SJSr/n4YAE/rCxeRiBFw8XTqoSEAbUmN/UCzrZ/PN36Pp8LJMx?=
 =?us-ascii?Q?Fj2H94ZjQHBUdRqYf9Zd9+zVO/GyYx8C6N13O8R4VU885jTj3qRTGTJwdnOY?=
 =?us-ascii?Q?7WyHsS3uqWJ9KPMIgBtuHl/PiG5VVk+98c3A1zbESp5GtIjwqauwGUp+5GZX?=
 =?us-ascii?Q?YsN5W+5aA8du2aXCKDl5kq+xzreJn2dv9gtNNog4/86/bov0HxTB3NHgVlAx?=
 =?us-ascii?Q?+npOSZb0IdC/lR5EyW6ImGVRlFZ6l9KC9LH4Y6nanasnug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6CDE0AE801EC7F49A67F6C43B1AE21FF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB3800.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8681bda-bd26-4e34-6797-08d8e43bbfde
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 03:14:14.4613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Bq7GOFZqJBbSQhvqOgoTjFGQ98CbOwjIkGcO80TF/udi+DlZ1/NfFD4h71zNP+f/w/KXv59J/jcZM7slpYnKNFx26I2h6rxQOQGeAOKGMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3798
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mar 10, 2021 / 18:48, Johannes Thumshirn wrote:
> Recent changes changed the completion of SCSI commands from Soft-IRQ
> context to IRQ context. This triggers the following warning, when we're
> completing writes to zoned block devices that go through the zone append
> emulation:
>=20
>  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2
>  Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015
>  RIP: 0010:__local_bh_disable_ip+0x3f/0x50
>  RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006
>  RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013
>  RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd
>  RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0
>  R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200
>  R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218
>  FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0
>  Call Trace:
>   <IRQ>
>   _raw_spin_lock_bh+0x18/0x40
>   sd_zbc_complete+0x43d/0x1150
>   sd_done+0x631/0x1040
>   ? mark_lock+0xe4/0x2fd0
>   ? provisioning_mode_store+0x3f0/0x3f0
>   scsi_finish_command+0x31b/0x5c0
>   _scsih_io_done+0x960/0x29e0 [mpt3sas]
>   ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]
>   ? __lock_acquire+0x166b/0x58b0
>   ? _get_st_from_smid+0x4a/0x80 [mpt3sas]
>   _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]
>   ? lock_is_held_type+0x98/0x110
>   ? find_held_lock+0x2c/0x110
>   ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]
>   _base_interrupt+0x8d/0xd0 [mpt3sas]
>   ? rcu_read_lock_sched_held+0x3f/0x70
>   __handle_irq_event_percpu+0x24d/0x600
>   handle_irq_event+0xef/0x240
>   ? handle_irq_event_percpu+0x110/0x110
>   handle_edge_irq+0x1f6/0xb60
>   __common_interrupt+0x75/0x160
>   common_interrupt+0x7b/0xa0
>   </IRQ>
>   asm_common_interrupt+0x1e/0x40
>=20
> Don't use spin_lock_bh() to protect the update of the write pointer offse=
t
> cache, but use spin_lock_irqsave() for it.
>=20
> Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

I tested and confirmed that this patch fixes the WARNING. Thanks!

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=
