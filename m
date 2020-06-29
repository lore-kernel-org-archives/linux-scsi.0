Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28360C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBE78206A1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oqFsggA7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="eXQNbYTa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgF2SzC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:55:02 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57271 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729909AbgF2SzA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593456903; x=1624992903;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6acM9xpylVregUcLgxo03dakaGiRmdfj2Enb6u/SGeg=;
  b=oqFsggA7OYmZMKwKCE+4AYmwPJy4kxfnUJ4Q2SpiH5fysAcRMmdYfdEI
   cLwrkdVO1HLxfIdwN0EMY1Uw7fIrQPr4vCBH66Cta1M4b2akaxRkasEZk
   qhhaLxmj/oBKQlAZKLYpM4XYG9++1aOTizqXb1dhbk/OMkrBpA8EwZYUU
   MHwOASBEHteOTXcuJjYg16hM3vbJRrSFCMeGqTEM/BdyeHXl7h+7AE4TS
   mxiwza+97lCMZF2emwrA/WSWsNZ7IpX8sQdvjrzZoefAuvdz2l+E+AkC3
   hOsgQpRG9fL6VXOFEud9bUaJcP3bV6yrBuqvxDGXOfGE7iH6kAZsq3eq1
   A==;
IronPort-SDR: GDQ0hGp9tiI2h++dOOJgSgoVgQqLWu/kYSG4AcnI5b005EY5W42uwA8Hqh/VGOY5T+fs+qTPti
 RBqStqPRbHy2PeLd5mQSM/Bw/7IkiO+gVNq/esHG+VzFsJtOSltyIQmJtvdHQix+rSiGggxafv
 Pbe7LtQstA0/1BTZyH15pLnO1sjZoO76Z71gsQd6qfycDj+nlmUAu/Qj1HjftyisHGFm29ESob
 WsESOmnalN+iyUK8jw7alHjTIE/SMBR6reveQLbiVXLw48BaPDjrobLIyh/GpUAfs4TqnZwJMS
 ifw=
X-IronPort-AV: E=Sophos;i="5.75,294,1589212800"; 
   d="scan'208";a="244187532"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 17:04:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nB7tC2X6IRg2ddPHEnU/LsswHobDiCoA6IX7zWEw+enOi0spsoWqxs5wHUXV6zIXS/8fSKpc2Uqq2+25PkaFIDTV9wX49FfwHz9+vWyHP43+jlSzsUxaBWNPFZ/Ly2p3pwFWwU7mO78ZNfD87WHJn0JciaQqM3tiqgY8ka2PCPBxGMlSoBRinDgNnA8yUkPjQmBsO1OWlA45adFH9VeC4A5g7r/3VjABngkRacMFEfYHOmUumVDtxdKmHI9EWJKrpuJiShwCE+4LwFYICfXG64UnJBeJweS8H9J4Yhs6Ipu0bcKjX04SZl890AS/mzbSMgWqU3fGk7ja3ODjkxuJYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKwWAB1xpnyns5hqFEw0Cvuv8gNmxEIPpG5h/5HhQj8=;
 b=dwtq1wS3rvfGK3WNDnAOU93Nfba05Wa4lnPSd1+3GpVEQNpJWLm4zok8zhHlnCe6MK/FjeodmWZ2foXaP/gZk9E6WYpnl8lW1h0mJ/L/5IdPHr1hNMxBP0cH6o7pz30MtfVP5tuN1rTXz0HvDcuyjL8LJdgqA/43NLEG/6O6F4kNTcfnLnoNLz2GY2+alPv9YStUGx94jNsdYmAhgiY+Tg3n8Qdt66kZG4njFNAGAdl78TJUwc9MGOIewlvPy5fZUZ79H3Jn3N2j+Z1gy5iK0mtOBeuoJPniSYv1sqarmuLYraskEKCmDxRBZ1x+0KX9YHObfzcOc4Tuh3CGucl8Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKwWAB1xpnyns5hqFEw0Cvuv8gNmxEIPpG5h/5HhQj8=;
 b=eXQNbYTaiWAMql+dAJS8qQnBMv9eMDRpU55QdlAVaJMuXTRQOx6YhqFwMG+YnJWQZppSBcRZSAjl150uABtEzC+ji7veyrhdfXGgYNo0XlyBgIZxB7WjQveCCCg3ZxZ1fnkQSjdFhBxC+MqjyP+w+gXcrvOWWSq7ZLPC2FEvp+0=
Received: from BYAPR04MB5112.namprd04.prod.outlook.com (2603:10b6:a03:45::10)
 by BYAPR04MB5783.namprd04.prod.outlook.com (2603:10b6:a03:112::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 09:03:58 +0000
Received: from BYAPR04MB5112.namprd04.prod.outlook.com
 ([fe80::a442:4836:baba:c84b]) by BYAPR04MB5112.namprd04.prod.outlook.com
 ([fe80::a442:4836:baba:c84b%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 09:03:58 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     Matias Bjorling <Matias.Bjorling@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH 1/2] block: add zone_desc_ext_bytes to sysfs
Thread-Topic: [PATCH 1/2] block: add zone_desc_ext_bytes to sysfs
Thread-Index: AQHWTaAfatwqFYUzT0SXO2cOAFMc8qjvTS8A
Date:   Mon, 29 Jun 2020 09:03:58 +0000
Message-ID: <20200629090356.GA521026@localhost.localdomain>
References: <20200628230102.26990-1-matias.bjorling@wdc.com>
 <20200628230102.26990-2-matias.bjorling@wdc.com>
 <CY4PR04MB375197387D94CE4E60E836F4E76E0@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB375197387D94CE4E60E836F4E76E0@CY4PR04MB3751.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [85.224.200.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8169bcc9-24b6-45e1-2e48-08d81c0b5c11
x-ms-traffictypediagnostic: BYAPR04MB5783:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5783462B45B1E98F6B5A56FFF26E0@BYAPR04MB5783.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nUjTuhIBw5LP0lK7w8Wgi0HTq6JB25hlERwsW94KJcOzwih5SKejS7kOM5NgAKZyUkGbPp5zly73XZaE+fmAimA/pfjyEKf1xZxf/PxBOaALIruxrGDzJoypAKKcp4EAcWECbILXWoQHxPNaB1elz0cQOYnZG4/iYH05eyynEwDsF6dE1XVGU3KEQPGbC6e0GCk/pt6LuF1cqwXTht24XUM9VOm7WGsH2Hfzg1KiQtKUcF+mg8hy/ICcxFJ1cweFpRQzr9nFgU2b/a5sUBnfk5HMwPZ9235yxFVrAEkaW59fcW3DEqq0EUTiclksx2MqI59mx0whUyOGcf8XNuF0V/5okdrMh3o3gJZADJcGCI8JNlp7CbRGQ04UfJ8WGlM0xWfL4ZiyG/BKBsgWPUIprw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB5112.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(478600001)(2906002)(186003)(6486002)(8936002)(86362001)(6636002)(1076003)(6512007)(8676002)(71200400001)(66574015)(66446008)(64756008)(66556008)(66476007)(33656002)(66946007)(6862004)(4326008)(54906003)(76116006)(83380400001)(316002)(53546011)(966005)(91956017)(26005)(6506007)(5660300002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PpGST/+wBAz/IWWYrNEU9BADbDQ1L4nXvWpWpW/uZPD8+r9KemI3kdBhzGCdZhhrSpDqfP/IDM0CYT3qrqqY2ke8qWUHzFzMYCJLLYRkKzGo03/c4GUa3bIcCX7yyj/kIOqWzL69i1wMu6c1pGcvVXqs5NgrXVpUwW7JcvJUTsMSbgQf/B8RcNogxOB5dnT0aFrDHtaYee/HCBT8WrqZVPx8HVdcHSpzRtlrPMsUZWwKmaKbp6G8BrxtJnncZNXm+kHnlfy79v1342H9uG3CbIefmpDZdYcAhp6Y2OotzytLHrDQZVMSzdh/Vb0qt3tEgJq3/U7UphSumkx6VCkYv6EaQbmoVtEn46cW/Ljt23CKWHa9Trf1L0ZiaxnyZ7xkduHjDe6rZ8GxsnKFXRqPmSQj5bwLKURFf3Be73Jl+6BXwXPjU+5+oWQzrIPLR7V0qSIBqsRMl5jq7NSiPMx6f3/CFFHtb4DS0Od2287CbU1jmW4J2m6AOrh/pMDmZweq
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <16E428DEE464C14EBD113635E6B45B7C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB5112.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8169bcc9-24b6-45e1-2e48-08d81c0b5c11
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 09:03:58.6103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W3OzWRj0BZ2GupmMs1QpEm3RvQQi2ooNGFhVCW2hSZjCQSe8IGR/4UEnJNCFlT5kZEve/UrIoGpIFX7vXSeuoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5783
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 29, 2020 at 12:52:46AM +0000, Damien Le Moal wrote:
> On 2020/06/29 8:01, Matias Bjorling wrote:
> > The NVMe Zoned Namespace Command Set adds support for associating
> > data to a zone through the Zone Descriptor Extension feature.
> >=20
> > The Zone Descriptor Extension size is fixed to a multiple of 64
> > bytes. A value of zero communicates the feature is not available.
> > A value larger than zero communites the feature is available, and
> > the specified Zone Descriptor Extension size in bytes.
> >=20
> > The Zone Descriptor Extension feature is only available in the
> > NVMe Zoned Namespaces Command Set. Devices that supports ZAC/ZBC
> > therefore reports this value as zero, where as the NVMe device
> > driver reports the Zone Descriptor Extension size from the
> > specific device.
> >=20
> > Signed-off-by: Matias Bj=F8rling <matias.bjorling@wdc.com>
> > ---
> >  Documentation/block/queue-sysfs.rst |  6 ++++++
> >  block/blk-sysfs.c                   | 15 ++++++++++++++-
> >  drivers/nvme/host/zns.c             |  1 +
> >  drivers/scsi/sd_zbc.c               |  1 +
> >  include/linux/blkdev.h              | 22 ++++++++++++++++++++++
> >  5 files changed, 44 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/=
queue-sysfs.rst
> > index f261a5c84170..c4fa195c87b4 100644

(snip)

> >  static struct queue_sysfs_entry queue_nomerges_entry =3D {
> >  	.attr =3D {.name =3D "nomerges", .mode =3D 0644 },
> >  	.show =3D queue_nomerges_show,
> > @@ -787,6 +798,7 @@ static struct attribute *queue_attrs[] =3D {
> >  	&queue_nr_zones_entry.attr,
> >  	&queue_max_open_zones_entry.attr,
> >  	&queue_max_active_zones_entry.attr,
>=20
> Which tree is this patch based on ? Not I have seen any patch introducing=
 max
> active zones.

The cover letter forgot to mention this patch series' dependencies.
I assume that it is based on the following patch series:
https://lore.kernel.org/linux-block/20200622162530.1287650-1-kbusch@kernel.=
org/
https://lore.kernel.org/linux-block/20200616102546.491961-1-niklas.cassel@w=
dc.com/


Kind regards,
Niklas=
