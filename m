Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1EAC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 08:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C700120884
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 08:41:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ewzt/yc3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RJ9MTxzd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgGBIlK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 04:41:10 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22908 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgGBIlJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 04:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593679269; x=1625215269;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+dDiG4qpRmfshEeRv6xwYI70Yj4gH0uPhch+7f9kfPU=;
  b=Ewzt/yc3irzvP4CYz59wtHgDDE0mG1hrUjk0rYV0MJXlh4MMkprMQG7e
   PtzBD3W7P2GcKC21yDU8NfsXbPJZ5IMw9xEFZ8sEkQ3JJVFqPG9Rh+Adi
   YfP1x6Td87u9Ov6Ay20uf0X9fT6Q8tth4WcuxL2W2O3bUX704C7+hIZVE
   li0CjC9faUU8fPU2+p3v9PFTthK2lOXYnAM+l1RqP90haIIA5wX2HSVRs
   3vA0niX5XpoMmRzCCtCUOC1UctPxGfbvZTUbBlfTSZJ5V8vI0ywvsgnQh
   G5XsP2cQrJf3A8+oTma6lwR3ghjJeO8ReMw7ghAUk5gSx2+8WVLh7jLsg
   Q==;
IronPort-SDR: WFbOym90J41xoZqo8+KXSRuzbo8DKsd2DQuSFeuySOG3/6XmqlxwWAB16+3Qz1Mi6hPZ5hjzbW
 nbJ4RHNsCGAmgBLE07EW1BtTURRs1SUk33pFlJajWobb0j0tf/3w5jSOmJq39bGnNObtBt5fNf
 Gp1Rd7V0IdaiN9SgnXu8+HYG2X4QepwoWO+AloTF68hceoRYo73OzMnNhB9oz0xqY1ZUdKrrAS
 vtiuiI6KqDwiunMgrKIvHF3bEccWMedfhTn42SYClYXMWWTohMy7En3AsEQI8XsbftvBEJpinV
 CWo=
X-IronPort-AV: E=Sophos;i="5.75,303,1589212800"; 
   d="scan'208";a="145792956"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jul 2020 16:41:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCBCwljt5/O7uhqxBGByze7R/09Mo3DYq2GLK6iYk9o8R1V/6fE57VC6qe1f017Xv7SXJnnqFbci4WO3Rqs9AiniBVaXr3Lzgl2puwd7ArD+KoMY+zRprr5/8dBv+paDwfRYhTc/xXWCLjA2Lye4R5AbxrnoTCvajwGBu/Vgbv3YJrq+s4m+pWN+1ylPKAu1P1m6pwx/0OzQc/f2/G8qh7PogZz3kGVCH03HUbeuXQDJPJvz4qYhi30KAmCE/W/L9qcWV7sDnXGNJfbijS5Srl9irdhRZnO+4TfufthdfbSEnkOvE3YOpUOp5q6SD39qTtnewgIPSp3IOZN9io8/KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dDiG4qpRmfshEeRv6xwYI70Yj4gH0uPhch+7f9kfPU=;
 b=oD9Ta234vkwpIxZ0oxNmaaCdCzCPM3ULPRb0nKRMGPk0ijG5OjUdiYZS0HDKiKypXVJNHPRr6BbvJBAx0v2r6ifygZ9QzxD4vweXhJ6k8MZUoORlfR+eqwrFoyGVF+2yflzYYWsdVVX1pqY9Zvumd7j/AhKKygfhC2g8tVv4/iVptxdLqj2AF96HYu7efPmKUm2Tz/vCroKHi9Mc9GF5e9WVxLVPfuWEgxcvMZFDvtLlTUMlD2/ULyzJoPfl6Bq05+Nig1h3jlnba9YCcRdI8at3Yp5BTTU14Fzdy0XsMVF5BMaZPaziB5frVbmAfGhsi9RUyvaooi7P/l+QVOj6Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dDiG4qpRmfshEeRv6xwYI70Yj4gH0uPhch+7f9kfPU=;
 b=RJ9MTxzd5ZJDiq0FQwVQkTYs7oLfElaS30ZNhL0GRHsERiCCfonGFpAmjOzXmH/hiFtUFttkSIx6Qp0xlxrfi9D6iLtA0GxbqJ0lrpJNuiwKC/uiFi8pzNpPEWWT+7f2hHNL7FTizm/V0UhDX5N5sGLLbcKYspdPiyRUXOBmI9Y=
Received: from BYAPR04MB5112.namprd04.prod.outlook.com (2603:10b6:a03:45::10)
 by BYAPR04MB4934.namprd04.prod.outlook.com (2603:10b6:a03:4f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Thu, 2 Jul
 2020 08:41:05 +0000
Received: from BYAPR04MB5112.namprd04.prod.outlook.com
 ([fe80::a442:4836:baba:c84b]) by BYAPR04MB5112.namprd04.prod.outlook.com
 ([fe80::a442:4836:baba:c84b%6]) with mapi id 15.20.3131.036; Thu, 2 Jul 2020
 08:41:05 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>
CC:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: add max_active_zones to blk-sysfs
Thread-Topic: [PATCH 2/2] block: add max_active_zones to blk-sysfs
Thread-Index: AQHWQ8iQJj1cyFXZ4EOOAcdNj7JGfqjyqqwAgAFmzQA=
Date:   Thu, 2 Jul 2020 08:41:05 +0000
Message-ID: <20200702084104.GA607715@localhost.localdomain>
References: <20200616102546.491961-1-niklas.cassel@wdc.com>
 <20200616102546.491961-3-niklas.cassel@wdc.com>
 <20200701111330.3vpivrovh3i46maa@mpHalley.local>
In-Reply-To: <20200701111330.3vpivrovh3i46maa@mpHalley.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: javigon.com; dkim=none (message not signed)
 header.d=none;javigon.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [85.224.200.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: be7026da-0a5e-4620-f32f-08d81e63a8da
x-ms-traffictypediagnostic: BYAPR04MB4934:
x-microsoft-antispam-prvs: <BYAPR04MB4934C8167CBE6B4E0180D95BF26D0@BYAPR04MB4934.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0452022BE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QoQbkdbu4cgiKlj3AtgXXJZF/l+5sq4fiuG31alrdsk8SKT1KM1l1YQbqGlYQK8rvlvrdCBATgsRMOmJ3ewdk0QJNZJj4S4yQEmJcVCpg4Xd/ERfBuWS5wkzJkdHJVvtAqUWyQyu70r4QsETy+y6S4T78fmTCJ8NmJn47iZGGm5DpwAcoh+u3BbaJqL+r2BDlh7bvbyzkyMtqmnXFRH5z00Hcm3e6IVbHI9CbycTL5c55zyPB/uikci8szsQbvpOsCUNMow97Fxy1kSGl1H3B4KZfsDlFvin7+8sTvNzg4OZAj3xhSNz3G/da6yqHDeTxs542sCJ3tz93F2kzfGpEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB5112.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(6486002)(9686003)(54906003)(6512007)(71200400001)(478600001)(4326008)(8676002)(66946007)(6916009)(66446008)(53546011)(66476007)(66556008)(316002)(76116006)(66574015)(26005)(186003)(64756008)(6506007)(91956017)(86362001)(83380400001)(2906002)(33656002)(7416002)(5660300002)(8936002)(1076003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NBt/luJiIEMUJ7q3E814qU4pjb9Zp7UFgE+4KV8yUiSmHT6aRwLeppTht61T8Uy7OFkXymgKJiCHy+Cb4ndJZSYLhyYKe0mZs+Y9Co3pky/dfCyj+o4KPttScD/2N2P1AOvXWZqgsYbPoWIbxFdNcra7tmyze3Tu4gufFjILtfOj1D4vXeHcO0FFqf0zg51/EFJBmgAXgd1fE8JgTztQL5RsTTejLpcWVqdkAqsXfmRqAdtA/EybqEC9bTf53wd6FHIVWI6aYfoHAeywrW5j++QOlqRNGuhGCpfGdIirbmBZtMHPHbUaSsbqqtuQ6RPr1C663rjyG6diUjuSF3ueQyJ0o8sL39uPacbUSQGwEJTOV36E/9WAznFyFU/Bj9UUD/lvblf3G3seMNUN2DDJ8Odwpen/Sfjxc+DHsKrPrFKOB2smZzxwUbzG7rU0IEtAptODDXAnPNSdFRiddTjbNlnttssnSBeLdi/HA1Jd7KsezBzXzpZ4oWm7ZYaPXEXC
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <19353BAB97C4E8439B6A6481F7A385D2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB5112.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be7026da-0a5e-4620-f32f-08d81e63a8da
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2020 08:41:05.5452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CMCEhO+Zr+42GZcycNkXw9hVi9Nv8tyPZxdgm0x59ln7GJ14gDCKmpo8m9Zdj2ZBETDia65oBGkg/wSnZMg9tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4934
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 01, 2020 at 01:16:52PM +0200, Javier Gonz=E1lez wrote:
> On 16.06.2020 12:25, Niklas Cassel wrote:
> > Add a new max_active zones definition in the sysfs documentation.
> > This definition will be common for all devices utilizing the zoned bloc=
k
> > device support in the kernel.
> >=20
> > Export max_active_zones according to this new definition for NVMe Zoned
> > Namespace devices, ZAC ATA devices (which are treated as SCSI devices b=
y
> > the kernel), and ZBC SCSI devices.
> >=20
> > Add the new max_active_zones struct member to the request_queue, rather
> > than as a queue limit, since this property cannot be split across stack=
ing
> > drivers.
> >=20
> > For SCSI devices, even though max active zones is not part of the ZBC/Z=
AC
> > spec, export max_active_zones as 0, signifying "no limit".
> >=20
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---

(snip)
=20
> Looking a second time at these patches, wouldn't it make sense to move
> this to queue_limits?

Hello Javier,

The problem with having MAR/MOR as queue_limits, is that they
then would be split across stacking drivers/device-mapper targets.
However, MAR/MOR are not splittable, at least not the way the
block layer works today.

If the block layer and drivers ever change so that they do
accounting of zone conditions, then we could divide the MAR/MOR to
be split over stacking drivers, but because of performance reasons,
this will probably never happen.
In the unlikely event that it did happen, we would still use the
same sysfs-path for these properties, the only thing that would
change would be that these would be moved into queue_limits.


So the way the code looks right now, these properties cannot
be split, therefore I chose to put them inside request_queue
(just like nr_zones), rather than request_queue->limits
(which is of type struct queue_limits).

nr_zones is also exposed as a sysfs property, even though it
is part of request_queue, so I don't see why MAR/MOR can't do
the same. Also see Damien's replies to PATCH 1/2 of this series,
which reaches the same conclusion.


Kind regards,
Niklas=
