Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD3CC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E645C2076C
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:49:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fPeUCeSj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XjJQ3pDM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgF3Btq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 21:49:46 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:38142 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgF3Btp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 21:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593481786; x=1625017786;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=uE5YdxXmVu/h414GPvQBfGDaWvp9WdIVHsEs+mleto8=;
  b=fPeUCeSjSFvmOR+NgfAz76B/yrZs/2tT7J15LIUDT+S8cT+WWWWYCCXU
   U9SPz+9czgz5B2XEMTRT9tRYPKsccliyPjM0fcpTVhaqnWOZAGZlSRgA3
   TBvF/PQNFATDnQbBci3DxbJGyabZX1VbW1/BAturzf1kLugGI5YR5YnXN
   yeeOFdfpmY99UZWRx4ooZTjyxiExTRgmuj4W7DJViwDEwPm3I57qZzcSK
   xmDAIcR++gqf4EDag0OXqpnRyQN0CLpW3DDiUIdvcBJsith6ZbEMDQue7
   26P+F3DdDI4mt2FnJ/Z74usgLrO+ey/KYTv9HQnG6TTMhfytzJhEPAGdM
   w==;
IronPort-SDR: o7ljCzyP6xVoUMb2jdfev5wlbOexYyRtiK+jD4Y7iRfwfT0b4mXJnEj1kJfpcTwd/RCDyMKJ2s
 77k7oZ9qkPwVCBNu4EKMO9X6VcG2tz85B5SQdPD3Wp/PsNRGfV/vO9zZrV/pxxcOaRnJs4+alA
 mx+xfSQ64hDi+m37u7UtGxtwahICUR925Tr4x15fumCAHzaVOa1dgWQedGo8LPbdU01P3H3pSN
 qy38F+B54zH24Zximth8WGaCd0O1YGXXG18UO2rrPOMnDfEH4z9f9gj7QwBXNvklQhQ7ievUjQ
 PNQ=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="142588538"
Received: from mail-cys01nam02lp2058.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.58])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 09:49:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGL+lL64tG5UR393vdMOUB85KjdsdNgn2oVZa1ivgleZJQ1u2IRVu6PDNaeevWccvpZVPtqXf6T0nzsCBYfYkSYSXdE1QOLAWPukoaW/BjitNjdk4iGGNyAj6VONEgg9YR9t7UktRDfn2n6AFsjYAeEZeiGLgDuAY2aAMrnfaiAOwRA+JLsKTIWNuXg23s2dnOqGgQVpRMRwCq+U6LlUUDDIWpYCPa5Be0h0nkLd92P67HNgSJeMYAE0tMHF/kScEngcxHKBM0EAncubusqVpylNsvhMMR/V2X08Wp6ziKntWMxnG5GKYROE9ZPpest8/LQQcnVi2YkHdtu7s/HaRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI/9WSzNIoj8q80Hg/Zi9Tg1oU8/R4r+rp5oMbuCmRY=;
 b=WF1fuvITR8qly8m7Lb4cmsv9wJdBKEbouTKqXhHqC31900JxplokRbzsob8vI0GqfzYVNuVPfc1p/vJ5pSgqZ82/zY5FvBpDU/jgUu+ZOHXBLT49tN7WoFQAGxsQk6iDsSPtpOKELyhjHwN9Ei8iCckyPdUoXP/YpJCaHFDD9EcmdSXK8QRSQ6xNZyz6Mw0+lzG5iX7yq8YSPQaWuelRu2gByJua1TRw+2Ms4VJ9UaKRH17Oz6zWUCrJjZa/gnMCUbCED1FYfX5IxTY/XMujq5m2VJLQMUHaFp2MIueMdIwk9mkt1Fe5GQvZJbtTBar+KjSfk9nH8EpA7VveMdG4bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI/9WSzNIoj8q80Hg/Zi9Tg1oU8/R4r+rp5oMbuCmRY=;
 b=XjJQ3pDMV38pmW/M6/ylYsffQkCgaG5lU46zqWzAO9WaItW36c8RSdJiQTB00OWp0xB/V2q8MQvxZD5UzHXd0xa31g4ITFohNiNnxxz6VEYwFlFUBoaDEovfeDusZMBeAZDxpQ6/DsVSfiQxOjNJUGrBEQ7wiitqLYOT7ppXFWc=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1048.namprd04.prod.outlook.com (2603:10b6:910:54::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 30 Jun
 2020 01:49:42 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Tue, 30 Jun 2020
 01:49:41 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] block: add max_open_zones to blk-sysfs
Thread-Topic: [PATCH 1/2] block: add max_open_zones to blk-sysfs
Thread-Index: AQHWQ8jtlLWiiEumE0+QMSt8tXUnYw==
Date:   Tue, 30 Jun 2020 01:49:41 +0000
Message-ID: <CY4PR04MB3751C2C03ACCA263541DA348E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200616102546.491961-1-niklas.cassel@wdc.com>
 <20200616102546.491961-2-niklas.cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d29a0415-47c3-4431-177b-08d81c97db6b
x-ms-traffictypediagnostic: CY4PR04MB1048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB1048D483E83E21C12C890CAEE76F0@CY4PR04MB1048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xuu+bN/3I+dwDuVB8wvNubH+6aOgOLh2EkMzWjutZuFPgH3bkMQrqBVP88TaMMuKe2hbeyGhto3RBGc2IXQFwOzluWIoo1f6t9s/M8PjM9O1jgjNAwGkdBMyjrMPHdIK95ZTAAYWhiadZe8SBQ95JL47maNP5+tFZ4QyU46VpfgUpLtFuzJiR3zIhNwK+ge/9DeLYWd6d6D/yq6GT+7YwkgINwkLMRAA14TljIQT74L8tkQKhuHZwD8Jo84RdGBiA47tqt5EAuQJf/luCwWRqswS4zyWZhM5i5kAbH1IvXehrFMyghLp00UbFc1yAkQr9wk2pXZC2x/p/DwPIdu93Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(52536014)(54906003)(86362001)(9686003)(8676002)(33656002)(55016002)(7416002)(8936002)(71200400001)(5660300002)(7696005)(4326008)(110136005)(66556008)(64756008)(66446008)(66476007)(186003)(66946007)(26005)(91956017)(498600001)(2906002)(6506007)(53546011)(83380400001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Ys0ErRnaLlc9rjB+txW0PD8N5jpXstxphhZOe+x6+2G/3RstLG+g8iB+SYSutC0byIb8j/GpyuAh86zohPNdREl8nCxrUDE8CDCSPDmx78Soo+JxyTAV1exxxoqTrre3bRyvGZ6hIw8VZqThsg0yhgaF1RpHKC3vMMr//EJVK8CnnrMb0PvSRhzLHuzZN9toAB6Igi2sfejCXDpZz8mJkhorC1VPvoxiljh4iuk2+VLjeZMiMEepRMb18JuDqhyFdryPJP+iYJdGC+83cQcFq3b14mTDUbvTw3vGdvbgPcMkdltrcXoc6GmzDesOvLjJqAUmRVtLv3DY8Ya68KIkcpufZsrFhzeijZzJ2s6mjC2wX7BhycxUbd2PKTImsYTcnPihY+U3pT82hRX4IFawOp3fIbi3PaOEyQfK7n28B8aqRtr1Qpo13rqyBZmJo34uFqHt4YghVOLl+3MqrzfFscYnpP3d/c8bgLUGfksZ9WQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d29a0415-47c3-4431-177b-08d81c97db6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 01:49:41.8413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RVwJH6JEMcY3ZozY6C8oevQ73FzHw4/vmfkgAYJL+M7IzfcO+Izz168RvUw8MMxOAGszP6AKq0E3hp/DDjVvmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1048
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/16 19:28, Niklas Cassel wrote:=0A=
> Add a new max_open_zones definition in the sysfs documentation.=0A=
> This definition will be common for all devices utilizing the zoned block=
=0A=
> device support in the kernel.=0A=
> =0A=
> Export max open zones according to this new definition for NVMe Zoned=0A=
> Namespace devices, ZAC ATA devices (which are treated as SCSI devices by=
=0A=
> the kernel), and ZBC SCSI devices.=0A=
> =0A=
> Add the new max_open_zones struct member to the request_queue, rather=0A=
=0A=
Add the new max_open_zones member to struct request_queue...=0A=
=0A=
> than as a queue limit, since this property cannot be split across stackin=
g=0A=
> drivers.=0A=
=0A=
But device-mapper target device have a request queue too and it looks like =
your=0A=
patch is not setting any value, using the default 0 for dm-linear and dm-fl=
akey.=0A=
Attaching the new attribute directly to the request queue rather than addin=
g it=0A=
as part of the queue limits seems odd. Even if DM case is left unsupported=
=0A=
(using the default 0 =3D no limit), it may be cleaner to add the field as p=
art of=0A=
the limit struct.=0A=
=0A=
Adding the field as a device attribute rather than a queue limit, similarly=
 to=0A=
the device maximum queue depth would be another option. In such case, inclu=
ding=0A=
the field directly as part of the request queue makes more sense.=0A=
=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  Documentation/block/queue-sysfs.rst |  7 +++++++=0A=
>  block/blk-sysfs.c                   | 15 +++++++++++++++=0A=
>  drivers/nvme/host/zns.c             |  1 +=0A=
>  drivers/scsi/sd_zbc.c               |  4 ++++=0A=
>  include/linux/blkdev.h              | 20 ++++++++++++++++++++=0A=
>  5 files changed, 47 insertions(+)=0A=
> =0A=
> diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/qu=
eue-sysfs.rst=0A=
> index 6a8513af9201..f01cf8530ae4 100644=0A=
> --- a/Documentation/block/queue-sysfs.rst=0A=
> +++ b/Documentation/block/queue-sysfs.rst=0A=
> @@ -117,6 +117,13 @@ Maximum number of elements in a DMA scatter/gather l=
ist with integrity=0A=
>  data that will be submitted by the block layer core to the associated=0A=
>  block driver.=0A=
>  =0A=
> +max_open_zones (RO)=0A=
> +-------------------=0A=
> +For zoned block devices (zoned attribute indicating "host-managed" or=0A=
> +"host-aware"), the sum of zones belonging to any of the zone states:=0A=
> +EXPLICIT OPEN or IMPLICIT OPEN, is limited by this value.=0A=
> +If this value is 0, there is no limit.=0A=
> +=0A=
>  max_sectors_kb (RW)=0A=
>  -------------------=0A=
>  This is the maximum number of kilobytes that the block layer will allow=
=0A=
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c=0A=
> index 02643e149d5e..fa42961e9678 100644=0A=
> --- a/block/blk-sysfs.c=0A=
> +++ b/block/blk-sysfs.c=0A=
> @@ -305,6 +305,11 @@ static ssize_t queue_nr_zones_show(struct request_qu=
eue *q, char *page)=0A=
>  	return queue_var_show(blk_queue_nr_zones(q), page);=0A=
>  }=0A=
>  =0A=
> +static ssize_t queue_max_open_zones_show(struct request_queue *q, char *=
page)=0A=
> +{=0A=
> +	return queue_var_show(queue_max_open_zones(q), page);=0A=
> +}=0A=
> +=0A=
>  static ssize_t queue_nomerges_show(struct request_queue *q, char *page)=
=0A=
>  {=0A=
>  	return queue_var_show((blk_queue_nomerges(q) << 1) |=0A=
> @@ -667,6 +672,11 @@ static struct queue_sysfs_entry queue_nr_zones_entry=
 =3D {=0A=
>  	.show =3D queue_nr_zones_show,=0A=
>  };=0A=
>  =0A=
> +static struct queue_sysfs_entry queue_max_open_zones_entry =3D {=0A=
> +	.attr =3D {.name =3D "max_open_zones", .mode =3D 0444 },=0A=
> +	.show =3D queue_max_open_zones_show,=0A=
> +};=0A=
> +=0A=
>  static struct queue_sysfs_entry queue_nomerges_entry =3D {=0A=
>  	.attr =3D {.name =3D "nomerges", .mode =3D 0644 },=0A=
>  	.show =3D queue_nomerges_show,=0A=
> @@ -765,6 +775,7 @@ static struct attribute *queue_attrs[] =3D {=0A=
>  	&queue_nonrot_entry.attr,=0A=
>  	&queue_zoned_entry.attr,=0A=
>  	&queue_nr_zones_entry.attr,=0A=
> +	&queue_max_open_zones_entry.attr,=0A=
>  	&queue_nomerges_entry.attr,=0A=
>  	&queue_rq_affinity_entry.attr,=0A=
>  	&queue_iostats_entry.attr,=0A=
> @@ -792,6 +803,10 @@ static umode_t queue_attr_visible(struct kobject *ko=
bj, struct attribute *attr,=0A=
>  		(!q->mq_ops || !q->mq_ops->timeout))=0A=
>  			return 0;=0A=
>  =0A=
> +	if (attr =3D=3D &queue_max_open_zones_entry.attr &&=0A=
> +	    !blk_queue_is_zoned(q))=0A=
> +		return 0;=0A=
> +=0A=
>  	return attr->mode;=0A=
>  }=0A=
>  =0A=
> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c=0A=
> index c08f6281b614..af156529f3b6 100644=0A=
> --- a/drivers/nvme/host/zns.c=0A=
> +++ b/drivers/nvme/host/zns.c=0A=
> @@ -82,6 +82,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct =
nvme_ns *ns,=0A=
>  =0A=
>  	q->limits.zoned =3D BLK_ZONED_HM;=0A=
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);=0A=
> +	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);=0A=
>  free_data:=0A=
>  	kfree(id);=0A=
>  	return status;=0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index 183a20720da9..aa3564139b40 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -717,6 +717,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsign=
ed char *buf)=0A=
>  	/* The drive satisfies the kernel restrictions: set it up */=0A=
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);=0A=
>  	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);=0A=
> +	if (sdkp->zones_max_open =3D=3D U32_MAX)=0A=
> +		blk_queue_max_open_zones(q, 0);=0A=
> +	else=0A=
> +		blk_queue_max_open_zones(q, sdkp->zones_max_open);=0A=
=0A=
This is correct only for host-managed drives. Host-aware models define the=
=0A=
"OPTIMAL NUMBER OF OPEN SEQUENTIAL WRITE PREFERRED ZONES" instead of a maxi=
mum=0A=
number of open sequential write required zones.=0A=
=0A=
Since the standard does not actually explicitly define what the value of th=
e=0A=
maximum number of open sequential write required zones should be for a=0A=
host-aware drive, I would suggest to always have the max_open_zones value s=
et to=0A=
0 for host-aware disks.=0A=
=0A=
>  	nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks=
);=0A=
>  =0A=
>  	/* READ16/WRITE16 is mandatory for ZBC disks */=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 8fd900998b4e..2f332f00501d 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -520,6 +520,7 @@ struct request_queue {=0A=
>  	unsigned int		nr_zones;=0A=
>  	unsigned long		*conv_zones_bitmap;=0A=
>  	unsigned long		*seq_zones_wlock;=0A=
> +	unsigned int		max_open_zones;=0A=
>  #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>  =0A=
>  	/*=0A=
> @@ -729,6 +730,17 @@ static inline bool blk_queue_zone_is_seq(struct requ=
est_queue *q,=0A=
>  		return true;=0A=
>  	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);=
=0A=
>  }=0A=
> +=0A=
> +static inline void blk_queue_max_open_zones(struct request_queue *q,=0A=
> +		unsigned int max_open_zones)=0A=
> +{=0A=
> +	q->max_open_zones =3D max_open_zones;=0A=
> +}=0A=
> +=0A=
> +static inline unsigned int queue_max_open_zones(const struct request_que=
ue *q)=0A=
> +{=0A=
> +	return q->max_open_zones;=0A=
> +}=0A=
>  #else /* CONFIG_BLK_DEV_ZONED */=0A=
>  static inline unsigned int blk_queue_nr_zones(struct request_queue *q)=
=0A=
>  {=0A=
> @@ -744,6 +756,14 @@ static inline unsigned int blk_queue_zone_no(struct =
request_queue *q,=0A=
>  {=0A=
>  	return 0;=0A=
>  }=0A=
> +static inline void blk_queue_max_open_zones(struct request_queue *q,=0A=
> +		unsigned int max_open_zones)=0A=
> +{=0A=
> +}=0A=
=0A=
Why is this one necessary ? For the !CONFIG_BLK_DEV_ZONED case, no driver s=
hould=0A=
ever call this function.=0A=
=0A=
> +static inline unsigned int queue_max_open_zones(const struct request_que=
ue *q)=0A=
> +{=0A=
> +	return 0;=0A=
> +}=0A=
>  #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>  =0A=
>  static inline bool rq_is_sync(struct request *rq)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
