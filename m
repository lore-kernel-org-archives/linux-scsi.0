Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026A9C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 00:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD3E92076C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 00:52:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PRpx+82g";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IUrSYzk0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgF2Awu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 20:52:50 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:19882 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgF2Awt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 20:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593391969; x=1624927969;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=8p/AWzdBhDohe13OXG6nCYcpDtv0GFKiA2RyAFw536U=;
  b=PRpx+82g4zYfGmu/e3mMUTmw7MBpHSrIF3gELS9wT8n6I4oeD+gzQro/
   qY28RArRk9yzdV3Ggx7p12ZmhIntKuQl2WQ1bs1SGXwJvNOcOX0gP8L4+
   P3YaPeq5jYNSkQUHF36NyZY744+iPYQTMKIqNXw9Lepe6XKoKns8ODRgI
   Oouhz0CXBHNc6taScgbjSb5cl98te+ZiYCk7K6qwpkjznUdczx0YBuItM
   n0Hq755yDbpGUo4AWTKxU9IAGHpPLrIYr47W+cr04AQEBxuoWM2GIIi4X
   LtgjO9Igl9P2ucSIlX/U87M7GKNtMf4uoL6a9wb4MvsPcAMpvrV26e1Qw
   g==;
IronPort-SDR: bpz0PmIxdBRfOYpYf6hPYUr1XFXrguGqOeTojtFwNDp2TdfIREBSUAWiHqRTW+UG7mCwr2UgME
 sBwYwHFdZNOpOjfdlG9l2Tt0xQ/3UH27sn+nyS6FgoJjSvZz6+NN3esP9BrSV/i4XPRUIod9P+
 ajQ61IAqr/PSVPBaxH2V1e7fxdbyA4gvyjL92hSFNHVNF1QD5VsvWruYkJUwZbHuk0RuqecUUf
 CJSX59kb1ZBPhMN44dBwp4uYS1orOd1rX3zMDCCoPRmEgp4gAmWNOw9FnD2ZKidhlkqcaGhslD
 UXo=
X-IronPort-AV: E=Sophos;i="5.75,293,1589212800"; 
   d="scan'208";a="141138083"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 08:52:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhsjuCMmcdknd3J7MW+V14p3RyjbMLknb3CtwpWqRBDzqBY4TVqLjqAzJr1NmjlCi+az9KjPAN+M52+ArfgD/+HYVQz4KlaGstHxb3vQId/LPuUTd2oV2/pIjwzeJbz7+7T9HP0tU5bRj08ugkMHLf9oKS2srn/tnRGEX0GVFotKO0R3pBt2QuSElnCAkHozNeb6dMrbMMjYiJ/8BUPzn6Qn2algCtzpsxPLQt+Z7zoeAN9T4oTFAeloon74IveEm0xLHPD6nWrbkm54zVfEDYNt7rIPPUR4MSjOGfiB1MoXjAPPb3dfKi3PnkcrW4XuJ7cWohDhtAgO93A0f1WRiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eP4LRVkC7Ky36RmxTuw1XIN7TOZoqaS/uf+ppiLPrzk=;
 b=kiVbshqgwEU1gd3uV0MeNBWZtQ9e8TYV+iVZnwnUe1R9Kxf+0M95KgbM79PDBgeoIoo6PWI9qn3qag620Nw53oR+2C/Q8URp1aj7adiZI0bsnQRXYuSYJWO+LN+isUWiokKbo2cWkbQ9otuP98/0Fq8IR4DcR8D7XCuJusviGU9UIHuupTKtX51d020CJgT2tiYCjR6+FzcvtfeY1n2Au37ijFEUKyxEs/Eo4kYZmkY0heloexfslzrWf3a2v5xDD3cBqnjoLeBFI2YaN5YWlESbO4ZuFuszN5S8Mqsux1fGMbQwYhnXk8ODltG79f6I2eeOJmLK2M7iJtqPctV9Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eP4LRVkC7Ky36RmxTuw1XIN7TOZoqaS/uf+ppiLPrzk=;
 b=IUrSYzk0M/Qgf+D/R9P3Yzo+3FmQGLBvFwR5nUC0hJw0H+pCEpx9Pa+5VMD/imC+iYweePCVWJP/rBWyvQq+x1k8S7Xsb/lm6petISTtDntt+VHtTX71ERBBlDfqO6Qdwq6p8Nvr9UJmi1SC9exj9BwlEJcPbnXJEEPWwpx8iqs=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1048.namprd04.prod.outlook.com (2603:10b6:910:54::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Mon, 29 Jun
 2020 00:52:46 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Mon, 29 Jun 2020
 00:52:46 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Matias Bjorling <Matias.Bjorling@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH 1/2] block: add zone_desc_ext_bytes to sysfs
Thread-Topic: [PATCH 1/2] block: add zone_desc_ext_bytes to sysfs
Thread-Index: AQHWTaAexT5EBQ0B+0awwAwr0pDYRw==
Date:   Mon, 29 Jun 2020 00:52:46 +0000
Message-ID: <CY4PR04MB375197387D94CE4E60E836F4E76E0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200628230102.26990-1-matias.bjorling@wdc.com>
 <20200628230102.26990-2-matias.bjorling@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c3037fa4-1b95-4f0d-eae4-08d81bc6bd20
x-ms-traffictypediagnostic: CY4PR04MB1048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB104869B527FF299CA1C5E076E76E0@CY4PR04MB1048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MLirVJeHxGCkk1ia/RwPoFvifukjV98e9WdHdLD5dhTG0Z+WEL920GTO+W9IlpxtNq1hCqe0oYFp3FYLWI0HP2jF2pujvJjWuE/CP+n/eQ/QruuICkUpjoLmbQCxiZC08D9JcslYPeIzuEUtYqM8dPcEVtUAmYQ27h50+Ito66XzV9UDYuSj8Fg3wQnIUSKl56azfshPHqVuOsTR81VVsV+BsRyRoLZHvajEMfU82kmKHzGJiqGJNBpoPMPldSIJYy8h4tEdB6neP6JtF2SjWF2iCbbjuHAI+fgfpqT5SBM7eyGfv0k+lrBwMYHt4FSencrCKiu3f+cd8LRXC46pbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(6636002)(4326008)(83380400001)(52536014)(478600001)(71200400001)(66574015)(64756008)(66446008)(316002)(8676002)(66476007)(76116006)(5660300002)(91956017)(66556008)(66946007)(55016002)(86362001)(33656002)(110136005)(54906003)(9686003)(26005)(2906002)(6506007)(53546011)(186003)(7696005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ZPW8TQoi7MLaxAPuAfYYPr0ybRpM6qLXaD80wxVg7jot6zeVjGTGB+LAAqCsGmLSa0xGelKaI0uFoFEW3EFN2H2XWMQPdilra/46XtYIrM9vdDM7fytk/g2YtxYD+Au7R8zS6ExDEqprGYcV00UZ58yjsIpwuwwyRl0G16hSWzJ1OIk/dktCRFWD85dCFcKHALAOqzrogGfuSpmk/zA69YsG45TBiGOafq9prB7dvxP++4oBDQDwnkwH+2zKeOxiIQPWQG+chWpnt9+kW6RjcF5iOHJ1UJXvDaOTMlFkOFkp3P39S7a0pd2TO69SZYoiQ76SNxrhhHkpM97atGa5+ESseVCDUtUyPWi8pEXOR4ChKeAOWx3wR1Rb3FX8h/mBA531jIJQOBmXwpQBirF4jUwqg4QmS/u37FcDZwWWCMSYcX58fgK2NXcBChRQ8Uyd2+Ggzg1MQHKJeLK4lVgsr/u/GxIPL/axfk1K+DrLCqo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3037fa4-1b95-4f0d-eae4-08d81bc6bd20
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 00:52:46.1821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1lsXYaJ2NWr62aPBv/0AG+UdE5ekLlbvlG8Wr7XZxE+2TYBhvvtofP97MeWQbQGKaag7U5fkSHXFDCDBiyZsAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1048
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/29 8:01, Matias Bjorling wrote:=0A=
> The NVMe Zoned Namespace Command Set adds support for associating=0A=
> data to a zone through the Zone Descriptor Extension feature.=0A=
> =0A=
> The Zone Descriptor Extension size is fixed to a multiple of 64=0A=
> bytes. A value of zero communicates the feature is not available.=0A=
> A value larger than zero communites the feature is available, and=0A=
> the specified Zone Descriptor Extension size in bytes.=0A=
> =0A=
> The Zone Descriptor Extension feature is only available in the=0A=
> NVMe Zoned Namespaces Command Set. Devices that supports ZAC/ZBC=0A=
> therefore reports this value as zero, where as the NVMe device=0A=
> driver reports the Zone Descriptor Extension size from the=0A=
> specific device.=0A=
> =0A=
> Signed-off-by: Matias Bj=F8rling <matias.bjorling@wdc.com>=0A=
> ---=0A=
>  Documentation/block/queue-sysfs.rst |  6 ++++++=0A=
>  block/blk-sysfs.c                   | 15 ++++++++++++++-=0A=
>  drivers/nvme/host/zns.c             |  1 +=0A=
>  drivers/scsi/sd_zbc.c               |  1 +=0A=
>  include/linux/blkdev.h              | 22 ++++++++++++++++++++++=0A=
>  5 files changed, 44 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/qu=
eue-sysfs.rst=0A=
> index f261a5c84170..c4fa195c87b4 100644=0A=
> --- a/Documentation/block/queue-sysfs.rst=0A=
> +++ b/Documentation/block/queue-sysfs.rst=0A=
> @@ -265,4 +265,10 @@ devices are described in the ZBC (Zoned Block Comman=
ds) and ZAC=0A=
>  do not support zone commands, they will be treated as regular block devi=
ces=0A=
>  and zoned will report "none".=0A=
>  =0A=
> +zone_desc_ext_bytes (RO)=0A=
> +-------------------------=0A=
> +This indicates the zone description extension (ZDE) size, in bytes, of a=
 zoned=0A=
> +block device. A value of '0' means that zone description extension is no=
t=0A=
> +supported.=0A=
> +=0A=
>  Jens Axboe <jens.axboe@oracle.com>, February 2009=0A=
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c=0A=
> index 624bb4d85fc7..0c99454823b7 100644=0A=
> --- a/block/blk-sysfs.c=0A=
> +++ b/block/blk-sysfs.c=0A=
> @@ -315,6 +315,12 @@ static ssize_t queue_max_active_zones_show(struct re=
quest_queue *q, char *page)=0A=
>  	return queue_var_show(queue_max_active_zones(q), page);=0A=
>  }=0A=
>  =0A=
> +static ssize_t queue_zone_desc_ext_bytes_show(struct request_queue *q,=
=0A=
> +		char *page)=0A=
> +{=0A=
> +	return queue_var_show(queue_zone_desc_ext_bytes(q), page);=0A=
> +}=0A=
> +=0A=
>  static ssize_t queue_nomerges_show(struct request_queue *q, char *page)=
=0A=
>  {=0A=
>  	return queue_var_show((blk_queue_nomerges(q) << 1) |=0A=
> @@ -687,6 +693,11 @@ static struct queue_sysfs_entry queue_max_active_zon=
es_entry =3D {=0A=
>  	.show =3D queue_max_active_zones_show,=0A=
>  };=0A=
>  =0A=
> +static struct queue_sysfs_entry queue_zone_desc_ext_bytes_entry =3D {=0A=
> +	.attr =3D {.name =3D "zone_desc_ext_bytes", .mode =3D 0444 },=0A=
> +	.show =3D queue_zone_desc_ext_bytes_show,=0A=
> +};=0A=
> +=0A=
>  static struct queue_sysfs_entry queue_nomerges_entry =3D {=0A=
>  	.attr =3D {.name =3D "nomerges", .mode =3D 0644 },=0A=
>  	.show =3D queue_nomerges_show,=0A=
> @@ -787,6 +798,7 @@ static struct attribute *queue_attrs[] =3D {=0A=
>  	&queue_nr_zones_entry.attr,=0A=
>  	&queue_max_open_zones_entry.attr,=0A=
>  	&queue_max_active_zones_entry.attr,=0A=
=0A=
Which tree is this patch based on ? Not I have seen any patch introducing m=
ax=0A=
active zones.=0A=
=0A=
> +	&queue_zone_desc_ext_bytes_entry.attr,=0A=
>  	&queue_nomerges_entry.attr,=0A=
>  	&queue_rq_affinity_entry.attr,=0A=
>  	&queue_iostats_entry.attr,=0A=
> @@ -815,7 +827,8 @@ static umode_t queue_attr_visible(struct kobject *kob=
j, struct attribute *attr,=0A=
>  			return 0;=0A=
>  =0A=
>  	if ((attr =3D=3D &queue_max_open_zones_entry.attr ||=0A=
> -	     attr =3D=3D &queue_max_active_zones_entry.attr) &&=0A=
> +	     attr =3D=3D &queue_max_active_zones_entry.attr ||=0A=
> +	     attr =3D=3D &queue_zone_desc_ext_bytes_entry.attr) &&=0A=
>  	    !blk_queue_is_zoned(q))=0A=
>  		return 0;=0A=
>  =0A=
> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c=0A=
> index 502070763266..5792d953a8f3 100644=0A=
> --- a/drivers/nvme/host/zns.c=0A=
> +++ b/drivers/nvme/host/zns.c=0A=
> @@ -84,6 +84,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct =
nvme_ns *ns,=0A=
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);=0A=
>  	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);=0A=
>  	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);=0A=
> +	blk_queue_zone_desc_ext_bytes(q, id->lbafe[lbaf].zdes << 6);=0A=
>  free_data:=0A=
>  	kfree(id);=0A=
>  	return status;=0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index d8b2c49d645b..a4b6d6cf5457 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -722,6 +722,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigne=
d char *buf)=0A=
>  	else=0A=
>  		blk_queue_max_open_zones(q, sdkp->zones_max_open);=0A=
>  	blk_queue_max_active_zones(q, 0);=0A=
> +	blk_queue_zone_desc_ext_bytes(q, 0);=0A=
>  	nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks=
);=0A=
>  =0A=
>  	/* READ16/WRITE16 is mandatory for ZBC disks */=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 3776140f8f20..2ed55055f68d 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -522,6 +522,7 @@ struct request_queue {=0A=
>  	unsigned long		*seq_zones_wlock;=0A=
>  	unsigned int		max_open_zones;=0A=
>  	unsigned int		max_active_zones;=0A=
> +	unsigned int		zone_desc_ext_bytes;=0A=
=0A=
Why is this not a queue limit ? This may need to be to be gracefully handle=
d by=0A=
device mapper for a target device using multiple zoned drives.=0A=
=0A=
>  #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>  =0A=
>  	/*=0A=
> @@ -753,6 +754,18 @@ static inline unsigned int queue_max_active_zones(co=
nst struct request_queue *q)=0A=
>  {=0A=
>  	return q->max_active_zones;=0A=
>  }=0A=
> +=0A=
> +static inline void blk_queue_zone_desc_ext_bytes(struct request_queue *q=
,=0A=
> +		unsigned int zone_desc_ext_bytes)=0A=
> +{=0A=
> +	q->zone_desc_ext_bytes =3D zone_desc_ext_bytes;=0A=
> +}=0A=
> +=0A=
> +static inline unsigned int queue_zone_desc_ext_bytes(=0A=
> +		const struct request_queue *q)=0A=
> +{=0A=
> +	return q->zone_desc_ext_bytes;=0A=
> +}=0A=
>  #else /* CONFIG_BLK_DEV_ZONED */=0A=
>  static inline unsigned int blk_queue_nr_zones(struct request_queue *q)=
=0A=
>  {=0A=
> @@ -784,6 +797,15 @@ static inline unsigned int queue_max_active_zones(co=
nst struct request_queue *q)=0A=
>  {=0A=
>  	return 0;=0A=
>  }=0A=
> +static inline void blk_queue_zone_desc_ext_bytes(struct request_queue *q=
,=0A=
> +		unsigned int zone_desc_ext_bytes)=0A=
> +{=0A=
> +}=0A=
> +static inline unsigned int queue_zone_desc_ext_bytes(=0A=
> +		const struct request_queue *q)=0A=
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
