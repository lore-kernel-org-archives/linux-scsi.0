Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFC4C001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 01:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbjGMBWj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 21:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjGMBWi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 21:22:38 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F17D1FE1;
        Wed, 12 Jul 2023 18:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689211356; x=1720747356;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qW/0WuVyyz36ONAK/igwH+JRiHjbsT+BzO6AP7VYII4=;
  b=mLYRXhMIdOoWA4EiMWWKyDTk6Ncaxzo9/VBvEZTa87LtSOiJBh+cHrfn
   DGryRFWCLkgIc3xO+kBtlvCGtCoRTBba2CSjZ9GHgjhgdsfpF5WvpBl2p
   aPgjdGU1yWuyYf8JFzmZk1hiS1lckAeutTIo9aFet8WnCyFYJ01AZ2R2A
   MC23fzeQpFVpGTfjK+4r+CBd+ZOrNdMZucFX2/9Trbrv7kk2YjGuAAviz
   EDc6lnOoJr0ULIJj6yECNFAlsfJdYIOulB0tb0RjilDu3pbGOgHnpBl7z
   F7XT3u/12quBT6B/OoJ5fsoe+mOwtRnhgsfTmeWOeYcpwC1hf5LG8fnN/
   g==;
X-IronPort-AV: E=Sophos;i="6.01,201,1684771200"; 
   d="scan'208";a="238236252"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2023 09:22:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jo+SxnnoFuB3F6Ja5AsbHs1nYhNrLNmdQL669Gcb6TaATln/GxxcOU+bB1YWYlQ2IHRzYysr9jlIucpY9X8rG3ADb+7tXSYRl27k0C4/UEVEY6YZdV3I0wTZvOfyWwI1nee/mrFYiktg4WlGcS2UWy6ys3y9DFvRTMXDdn1c6jqq6rucP7395GS0JanGbAN7q85mocMxLC/2a4flvDYDAs1XAQagTFLmlyVhX9+hjj9aaZRP2TaNOKfvQ4WMUBt61iv5+Do1eU/l8bV+3gEObnJPrlEZLHBcdg1cPKmebb4pYMq5q5PcqoB4YPP/blNpfxLl6lorTlwFD+pOz+eBfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cC8IDc1w6N5Ljw00E4DLYjPXfNeitxZzfM1TSAKIuus=;
 b=XG9C/0YkU5igttnE0GX/zjYjkZhoPljaH8pLLgzbUPfGOLNGDAxhFDf1Vb/ElgcQklVHTiG3jHu6zLj2jqqrdkylOWtOaR3DMJXUlM/hh08sEA7GD/meaqUeVPkdL6f7zkxWdJTzZl2d3kjkeJbSRb+L9F0rm3EwQtqptrmqxyWnSeSt45bWRO/OlnjIB3adnHofFSVblCsDfvK0KB8UFr99wpaeS8Ye6b7eztqDmiiTIrZvw/heElnBzOkizoR/ZaEunfP61+clUIe+8/7hTvyUUFV5OZZOo9dlzW+6QduwEt1Psll197oteixaj6Pvy4CMPi3TV2QSsVeRvXBziw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cC8IDc1w6N5Ljw00E4DLYjPXfNeitxZzfM1TSAKIuus=;
 b=nAkmXmP1E8HFUVt6gMq9nKR9hLR+1hptdOwMQxBcdHMYscYEwfsxyGYWkvm388bkpikOtA6qMxh+z96sKgcbgqNhWlxjeux0/SKe1PlBSaQPv+QCi9bvdIwtXaZP9ASqMUxF7WnltNCgWWehBUtWvPNyajgdnnE17qFwlA6uTpc=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SA1PR04MB8519.namprd04.prod.outlook.com (2603:10b6:806:330::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 01:22:33 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::bfa:d453:e7e9:8f98]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::bfa:d453:e7e9:8f98%7]) with mapi id 15.20.6588.017; Thu, 13 Jul 2023
 01:22:32 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Sagi Grimberg <sagi@grimberg.me>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: blktests failures with v6.4
Thread-Topic: blktests failures with v6.4
Thread-Index: AQHZsKSBQcb4sCyybku6gR7M5LNTu6+xgyIAgAVskoA=
Date:   Thu, 13 Jul 2023 01:22:32 +0000
Message-ID: <v3n4k4gk5uhbuh6ijl2pwaysvxzidzhrmjejourfnmobebwbzi@hejuqcryp4nc>
References: <lkmloyrqpebispffur5udxdiubmevvodtsvnap3jz7tv5ihstr@jg7ejye3bein>
 <165eceaa-55d4-f9c7-7e02-18115e6df6fe@grimberg.me>
In-Reply-To: <165eceaa-55d4-f9c7-7e02-18115e6df6fe@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SA1PR04MB8519:EE_
x-ms-office365-filtering-correlation-id: d96a5489-96f6-48c8-416a-08db833fa1fd
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LhpkxIqbBK5WXOtw+4MAyEtfQHDYSsRif8o0PF792dabVzanFVUQZPMt5GvbjBgRwOz6Z5kyhDW1DW9sl+Valv2n04H1zwY5HyfY5WcuCsamEbBL4XNc10YAkd9g5oxi1RmdFayBgCzdd8TCYj7ubVJI8noPn78aDMT036c4caVaYkLmaeBe6t2HdeG9mn5fZBeGU/70Fljttq2B9vgKDQXzSnTzhH8ECa29cBAdr/IicE7ZS4/7M3zuPXSpzjhpP2YP9T/4WT7IxTlkbUu9IrOQvl3l2LAIu+pIw6CQcUzrY8sRDc8giQtQrTGb/Yba1o4O1gmFnmymceZgtmZQiO4RFPbd7AWtjo1xp0Kk1iRP/NAQrB/DhnS204fRzw4lJpEP17heaCLdjLRYzvDt8xnGDPYmdumrg7bnyX2Z3wBM5L9BIxUU2iQHBjDxAWwqVTn+KWTpSZRdVSBEZ3Uphsf02cLCzm4giXSewIR1Zh5mtCxIThwWEbeaGKPhOunToYSP/MjlPQ5h+FRL8TZ4n3PmlKbKSSyz8gi61kttVoNOKzcQ2poLjGpCK6cqqM6eC5s4f6c/jwDbPykpMPFMdixArA/sHh/TcBZf8+Qsixg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199021)(54906003)(316002)(91956017)(71200400001)(186003)(4326008)(66946007)(6916009)(6486002)(76116006)(66556008)(66476007)(66446008)(64756008)(41300700001)(966005)(478600001)(9686003)(6512007)(8676002)(8936002)(86362001)(6506007)(44832011)(5660300002)(26005)(83380400001)(122000001)(38070700005)(2906002)(33716001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hdM4mVivxRtmohlInbFOiDNgUVm74P4t/1L3hV97F4szM2HNayHVUManv/8I?=
 =?us-ascii?Q?hlXvqfFfsdF7v+NRKH272OCHHQkjDUoABfWaZ1WPCTYg2Wb8CMMuPThwGxJ0?=
 =?us-ascii?Q?eRbyb1z3bh00+b76b6mKfpif4bmTXvy60iVqezWAvxBsyjfUiPWv18WgP+Ry?=
 =?us-ascii?Q?vOM7A+cAIosrbHwmTmaEqCk2guCx+A1l4QEYZ1D39twpQE6ZbllJVUIoQpLQ?=
 =?us-ascii?Q?ZYp23+VsoWN7QUIkDfwtD/N4ztjuZItC7Zu58B8Ep3i4vrG/pCxli6YHcUKH?=
 =?us-ascii?Q?5LZlbJObQ9lg3BajfJKNriSP6qii0JnOaxOZ5mOVbWN87Ad2+zeV/CBRfbPt?=
 =?us-ascii?Q?eUd+uSBiy4BI9C1Y0iDx66uJXs0PxwCmLCRl6/4LT8RKXlfoCm8fLhUAHC64?=
 =?us-ascii?Q?14JdY1pEUFzW/SVJzMG7bgWpz2uu0CRX3dAMwsJ1VjpEkz/l7I6hl61YG4oS?=
 =?us-ascii?Q?Zbk+RWqklN3v+mVN6qkS2wZ2SAWKwT4nmGM3IDhrmIgrczHffKThzKaFOb7y?=
 =?us-ascii?Q?ADdwZPfBj5ZHL5zLCVgtgKT35OuWJolv4TqTYkJhUhMrBI4SL6xlBhjA7pJ9?=
 =?us-ascii?Q?X6AjZRAY/8ICSTjjKDUk/S2UdD74TYB/lXoqN0yovCrYJuqdFwvS/GsI5QsJ?=
 =?us-ascii?Q?lyV9JW+47E308IEt8XleAPvFpA/cn97REGHGct0dZnMH+IptMXhTvfxMOX4z?=
 =?us-ascii?Q?mjOxPoMvNhtYyN2+TewrIrqHgW1+wJdDd9/epqAeWVPgLjCl4Xl1G262TilP?=
 =?us-ascii?Q?AipvJyzusvU/uIXyCALRLOlH4ejeU6q9xdaLyiZNxsMkvzUEL7ULw1JsrIEX?=
 =?us-ascii?Q?akl99oI9rHs0b3AtRgJlp2iPMQMXG/kyijAbJJexhSgomoTEkQq6fDX4xGSv?=
 =?us-ascii?Q?rxs8304a3ONeVdyIDOem/guaep/vjpI3JSTBzgCkiRjXEDzoK03urWaLAuI9?=
 =?us-ascii?Q?TsRlyDcqRC50m1Hp8PCEonRAWPdDo2ujac4DE+eFbOfT4sE0cICPqpWRXgBG?=
 =?us-ascii?Q?7ks5pON1tZ6TNqyJtTQyQL0/Q8i9NJ4BFONPZF3tOVIbix7nRpixwee+ALC4?=
 =?us-ascii?Q?QsNg7UD2TuWlWP3gYhO4x1zOoQDj0uf5eSvCgZgbmScCOE/22neXJv0Jjg8s?=
 =?us-ascii?Q?jC3Dsf0tEwByNSW1LbXniK2YbwUaz6515zaL3o9KwmOs1QPqvl5Ca67HGHD8?=
 =?us-ascii?Q?ohW88D2YOkb4jm5A3EmhfZw9WeyS9lp4s3tTjT66olT/N0xsoNlR4gN708i8?=
 =?us-ascii?Q?2j862sGv4az86T9Dq1+0b0lU//Jq6R25ftTcgSCc0mJSWDH7Iagf9YPVAHbc?=
 =?us-ascii?Q?RtaBzTDYJIbsugfvEQ5IKojEr+dUrb0M6AeTvakVEHkyPIY860xzwn9HYc+c?=
 =?us-ascii?Q?qXRSKk3yOY9rx4mjRp1g660SmqB7/RUbdEqGDITMiY8KQ+X/yuTXDVdejhl0?=
 =?us-ascii?Q?s3ELcRu+D6F+uKElUe6x40w7qG7qAap1hQKRzp9INNov3KcceRSYcyxoqMlC?=
 =?us-ascii?Q?izulVs7PVayUOQae+KL/FKeXDNI/VaR9KxKgC30PE87LXADHzC38qnjkfzNv?=
 =?us-ascii?Q?bBfxj8O+yAojeQHcUGrpmOLBdNQSm3WkSQz7VMyWAnjI6KcjQsvscCX/W6cR?=
 =?us-ascii?Q?BWa1bN8IVUwnOYp2f2p5dic=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26C7274D4F2AF24E862C6633883231CA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3AATwSrogwiMO94GGW74gmzjX2JbvYtvOJ2gWqoxR4TXxSDQSBFyZgkUyP+eCjOve3w7iBfVrXF2pYm0ETiIUij//pmNKbkNYU8poef5yv1Gz43x9CDt9+Ce7s/jsxgLln/xpVR1KT4ZAXZ4Bip2iDjKk0Ytj2NgE5nanBwJkvTmbfXKJc18K2BXk4scvwz04yYvOrnKCjze25Puk85IWBF9CT88/uIMwwCJ0o9kiV7+hgG7/w6VKnnMDaPH5t5tNG49lE62DKRsQ4Qq6sU/DvZ57nMr9aLW+TuuskHG55mSMS9mRr6Fl31rtri3ka0O2wcfAUgMrWmSvS6yWp87UVzIpC0hoLNmIXD1rybY5BqT6YT5ZSHdFl/l6zKxkGfbZ19H4872rvgvpscN0uLF2Z3godVpngs4bUTBJkXuJDWoutEm+OOruber2SwcUmbexWO0AF1dPQGTwmUz83szCLICpoRnT4j7gVhRWvK9qjdJQno0yfCACE+igxB4rComeAxbiPSpQTVrTyxSDPZFCy3EXnU5rat67rdXxRSWTmCfG0R47h7ioCVAAsTWNKH4l7pH+wzJ/CWlbl+rf1C3ctOomEPijzDEF+mgoEQQ7uKdS2uhVfytcJPRAcPKNTxlN6tA1M/VN1qCIvxSj9BTLeUunoiKpY+aPQ5nDFOX7+4U44/lXXj1RuzeT/ECSGJJy+y/zBAhKwhCB67UxJUGXGJgfChJSq6+8CxgK2tVBHu7tPhua+OVThebZjWmzBdZKq0BP1wI5DAZ5UyBgCD2OYdmA6tA0jIq364rLALz6wCUQrbEDYoBtKykq2LdnUzSg0pBQr6nucP5WdIWAcG26WD8HQYGm+GTwvRvMxfZsOc=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d96a5489-96f6-48c8-416a-08db833fa1fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 01:22:32.6459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y6CtHImPcFAgBM9/Xh/4ve2OH2uN853jT/kce+zAe9ljmeM6u3rJNc2AuLntMugFhhZy2tAd6Vx7C9cK7VzOsU4gsfMWlg3LyzWYyQoD/Gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8519
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Jul 09, 2023 / 17:32, Sagi Grimberg wrote:
>=20
> > #3: nvme/003 (fabrics transport)
> >=20
> >     When nvme test group is run with trtype=3Drdma or tcp, the test cas=
e fails
> >     due to lockdep WARNING "possible circular locking dependency detect=
ed".
> >     Reported in May/2023. Bart suggested a fix for trytpe=3Drdma [4] bu=
t it
> >     needs more discussion.
> >=20
> >     [4] https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvan=
assche@acm.org/
>=20
> This patch is unfortunately incorrect and buggy.
>=20
> This will likely make the issue go away, but adds another
> old issue where a client can DDOS a target by bombarding it
> with connect/disconnect. When releases are async and we don't
> have any back-pressure, it is likely to happen.
> --
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index 4597bca43a6d..8b4f4aa48206 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1582,11 +1582,6 @@ static int nvmet_rdma_queue_connect(struct rdma_cm=
_id
> *cm_id,
>                 goto put_device;
>         }
>=20
> -       if (queue->host_qid =3D=3D 0) {
> -               /* Let inflight controller teardown complete */
> -               flush_workqueue(nvmet_wq);
> -       }
> -
>         ret =3D nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
>         if (ret) {
>                 /*
> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
> index 868aa4de2e4c..c8cfa19e11c7 100644
> --- a/drivers/nvme/target/tcp.c
> +++ b/drivers/nvme/target/tcp.c
> @@ -1844,11 +1844,6 @@ static u16 nvmet_tcp_install_queue(struct nvmet_sq
> *sq)
>         struct nvmet_tcp_queue *queue =3D
>                 container_of(sq, struct nvmet_tcp_queue, nvme_sq);
>=20
> -       if (sq->qid =3D=3D 0) {
> -               /* Let inflight controller teardown complete */
> -               flush_workqueue(nvmet_wq);
> -       }
> -
>         queue->nr_cmds =3D sq->size * 2;
>         if (nvmet_tcp_alloc_cmds(queue))
>                 return NVME_SC_INTERNAL;
> --

Thanks Sagi, I tried the patch above and confirmed the lockdep WARN disappe=
ars
for both rdma and tcp. It indicates that the flush_workqueue(nvmet_wq)
introduced the circular lock dependency. I also found the two commits below
record why the flush_workqueue(nvmet_wq) was introduced.

 777dc82395de ("nvmet-rdma: occasionally flush ongoing controller teardown"=
)
 8832cf922151 ("nvmet: use a private workqueue instead of the system workqu=
eue")

The left question is how to avoid both the connect/disconnect bombarding DD=
OS
and the circular lock possibility related to the nvmet_wq completion.=
