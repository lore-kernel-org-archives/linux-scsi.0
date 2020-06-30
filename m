Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1C2C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31E9520781
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kiaVoI8/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xPVy3zfE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgF3BvZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 21:51:25 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:38263 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgF3BvY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 21:51:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593481884; x=1625017884;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=o+oV32HedIgcdOkiWXogG2J1Je+6ZH9VB/9AKgFswLg=;
  b=kiaVoI8/gK0QrPaBbMP30OP219izgm/7eE4VFpEQ9fC15ZRrhbMgC7ZH
   wU+P5ZxZYG1xRys99l2zKZ9yUs6MAl37NYkIpClH2AD3tmw3r6AxaaWaI
   RvKItof2v8ZCguZwMJRcTdUd20WX3cHpbkBLBX6NXw6WCHst5kw1OrHEW
   6o+QC2jGWPVGrwgU+c6yDn8OKHVnCcN8intcTXO9SNr7neduZLHEJhUwV
   0hj8J9jTtGI7wPCe6GjmrsZqhX1qAdmjVzRHXPlHrXQ094VAkzCCbFBAa
   sJHtPOiCQjhCsalE92P9EDU8MWSoyLGo4U3A9LRbE3gEQJmcqEZfq+5Z+
   w==;
IronPort-SDR: TEhXTbMdcIE8QIeR/J/gYCNt0tc9nLW6J9eZojW9VTINMgLDca7cxzFC5cCCHQCVwLgkPLu4r4
 SdRs4cwtuAOmeQNGuwKPtrbIswt6ddPN8uvQ91+2ze41VNTB/mjpWf16/YcmNSAlq9THHizXme
 DpxpnVLDGyXRSLNMZDaqiIoz4Dx6nq0RJrwi31+sudNK6Buvp7e0dtwW31i2qxqOMVk+PWmosc
 9oeIavX6VBzTIdBue3PYyreUZlT5LHDemeeehSqwQRSl5/2hgvBeBg2SalCcr+i3wlrSOtrkHQ
 EIg=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="142588640"
Received: from mail-cys01nam02lp2058.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.58])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 09:51:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdycULo8P5KKpV7oKw5y0AsLF1lFy5Lg6jtRkimU51xLnFWvdIwJ+LzsoW0hWd/jn7IF38aZxQLCNuGYEsUnTHQSL5QKusv2NP8N4U6MVPzQRm5aY5pxMhHRLEEQFmc78PPJXKENGOqq+wRK7uGUt/GgaJv63ueToUbJ5sDgVyYOM25Vj+fiE+ZmDMsMn2ezRNsP2Kz2Uj+3xUgNzGSJVgfemHQ2PVJ+wcMD076OGEwHS1OrQXujyTgC7XcP6w/CA7tEZ2IM6Zip1AacdGuvO2/WXMIrAAEJpmdR9OoLcT8ybsBYGy6/cB9rwgoCUMvtpbcgOzi/OMIOsi14lVtFxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MX9WO8f6bzhpThZfFO4AYsYK9xAMgCjjFn4TgqPhs80=;
 b=W6w9ZzAyDiw/VaYD3ysSZ6kj4A3ahGofchOj5wCRft6oUkLcZny7SkgK9ZaCVcFBtSiGwob0IHPgXcB17Z9/xSbNBUnUAj+OVsGfDRFFnhu5Vt/dOgLFmSbba1azaD5gv6ym1GHbOeyDtQZuN92jJwRpd6pq/Oj3Y6ToaqParImxXG39/89qH9G7q6SAEmOg4DQDCJf9GyjArKV5llgFgIBtW8i7olx+tItkTxoQdRqUKUKbmGsTV5ge0EsltdapGvN01i8bXCwHQPZK3ADqnRGm+yX/07Bhq4detYJ6Ujr1yCD15gafUCu+AfoRGZ43BTBCT4tCSJY1RLiLQDc79w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MX9WO8f6bzhpThZfFO4AYsYK9xAMgCjjFn4TgqPhs80=;
 b=xPVy3zfErHITDT81aqPXJ6oMCIn8Z9u3gaGwI1M3MLI6iSZ7UrrkETq8aLJQ1jFSWRfhb/U5UIzyCM6mJiA8VFsV6Ocr05qQHDiEdxIkkXf5NDaWhBxEIY73Hxm1HgzPnC3XQeyHHEECkXIbMnE8qVv47MglJuZDybmiC3V4VZY=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1048.namprd04.prod.outlook.com (2603:10b6:910:54::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 30 Jun
 2020 01:51:19 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Tue, 30 Jun 2020
 01:51:19 +0000
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
Subject: Re: [PATCH 2/2] block: add max_active_zones to blk-sysfs
Thread-Topic: [PATCH 2/2] block: add max_active_zones to blk-sysfs
Thread-Index: AQHWQ8jrhcOfnCbsu0iJ3Vrt3ow7ZA==
Date:   Tue, 30 Jun 2020 01:51:18 +0000
Message-ID: <CY4PR04MB3751FA9C0659EB7D3C8D1843E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200616102546.491961-1-niklas.cassel@wdc.com>
 <20200616102546.491961-3-niklas.cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5861355b-fd53-42da-d7da-08d81c981547
x-ms-traffictypediagnostic: CY4PR04MB1048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB1048278CCA7794F9B2E4F014E76F0@CY4PR04MB1048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I/iR7YByRVyuxMQ23RYITmsJfynzf8VTWy/SNuc8Kl3AdT5Q/lhgRyhVWaXLfVhdo4h+BPnN/e1iMvKKVLzLsDqSPvF6+3tZMPhMx9eTj2B/+IsJNQyom/wQYqdHX0+kehsLgc085ue3eqezA5IHd4v0mwKnGAxAOcoznec6c1s+e7ukKIyyG2eIME7mAKKzBckWpyQFs78ma6tm7eYAhEmndcvnMUTAAe36LdLuKO8EQ36kU7ch197pYdMswDFlPX4lRoMQLZQ1kFEUw1RLpb7bIqBF4RvVS0lJ+OnWZP4ulVGc6jpX1h8idVPh8XAJ3Tttpj1z/i4ArxIKvSwbLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(52536014)(54906003)(86362001)(316002)(9686003)(8676002)(33656002)(55016002)(7416002)(8936002)(71200400001)(5660300002)(7696005)(4326008)(110136005)(66556008)(64756008)(66446008)(66476007)(186003)(66946007)(26005)(91956017)(478600001)(2906002)(6506007)(53546011)(83380400001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yuKC6X9rO2+4lqs8rhCouv8nHDiHS7EW0ZOmGi0dMjbHWgcRpjoDsD9xhtD0fF6cNLr5orM3qgR8K8LkEgAIXKo8iXf5nTv/9PEva9Om96qjrsGQySbIzn0uo4k3rGvwWlP4RH8b9jCoas1VSZHjB60CHnGPaRNs6Pguo1uvRxuc8tokwqjqYjuA6g2ZVDxmIufAtEyzpZQ9o7JYKdkykA8jTEZ1mVfpE6ZWsedEueOL8rI16tbsMu3kHGH99l6yOgk89KwXL9MMxPHMGjzK65f9zj8GjaDc0Is3nL/UllpVUnS+WDD53ShDgxE6tEN/OXrKNwAjtZiQ/hjzbzzzznCHJyHtrVLR7X3dAh6XuYQPEWdONAwCx51JaVLA/czq8eMrgyf83KybIJvXs76YJrp3ea+ZlRLYcaIbrCN2JtjLm577dp7T2BizSGk2Xp20rMKK4JXNf0ahVN6atAAe4Cmbw7p0AKXZ3tplwMW3Zmk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5861355b-fd53-42da-d7da-08d81c981547
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 01:51:18.9392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BjIgcdNah+mfKDAMKnVa4tUqMOqWnadRJH6QbYWSTNN8a4ibaxTmNrdccDtg+ANUq7XAG2HVBIxmf+intDjwkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1048
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/16 19:28, Niklas Cassel wrote:=0A=
> Add a new max_active zones definition in the sysfs documentation.=0A=
> This definition will be common for all devices utilizing the zoned block=
=0A=
> device support in the kernel.=0A=
> =0A=
> Export max_active_zones according to this new definition for NVMe Zoned=
=0A=
> Namespace devices, ZAC ATA devices (which are treated as SCSI devices by=
=0A=
> the kernel), and ZBC SCSI devices.=0A=
> =0A=
> Add the new max_active_zones struct member to the request_queue, rather=
=0A=
> than as a queue limit, since this property cannot be split across stackin=
g=0A=
> drivers.=0A=
=0A=
Same comment as for max_open_zones.=0A=
=0A=
> =0A=
> For SCSI devices, even though max active zones is not part of the ZBC/ZAC=
=0A=
> spec, export max_active_zones as 0, signifying "no limit".=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  Documentation/block/queue-sysfs.rst |  7 +++++++=0A=
>  block/blk-sysfs.c                   | 14 +++++++++++++-=0A=
>  drivers/nvme/host/zns.c             |  1 +=0A=
>  drivers/scsi/sd_zbc.c               |  1 +=0A=
>  include/linux/blkdev.h              | 20 ++++++++++++++++++++=0A=
>  5 files changed, 42 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/qu=
eue-sysfs.rst=0A=
> index f01cf8530ae4..f261a5c84170 100644=0A=
> --- a/Documentation/block/queue-sysfs.rst=0A=
> +++ b/Documentation/block/queue-sysfs.rst=0A=
> @@ -117,6 +117,13 @@ Maximum number of elements in a DMA scatter/gather l=
ist with integrity=0A=
>  data that will be submitted by the block layer core to the associated=0A=
>  block driver.=0A=
>  =0A=
> +max_active_zones (RO)=0A=
> +---------------------=0A=
> +For zoned block devices (zoned attribute indicating "host-managed" or=0A=
> +"host-aware"), the sum of zones belonging to any of the zone states:=0A=
> +EXPLICIT OPEN, IMPLICIT OPEN or CLOSED, is limited by this value.=0A=
> +If this value is 0, there is no limit.=0A=
> +=0A=
>  max_open_zones (RO)=0A=
>  -------------------=0A=
>  For zoned block devices (zoned attribute indicating "host-managed" or=0A=
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c=0A=
> index fa42961e9678..624bb4d85fc7 100644=0A=
> --- a/block/blk-sysfs.c=0A=
> +++ b/block/blk-sysfs.c=0A=
> @@ -310,6 +310,11 @@ static ssize_t queue_max_open_zones_show(struct requ=
est_queue *q, char *page)=0A=
>  	return queue_var_show(queue_max_open_zones(q), page);=0A=
>  }=0A=
>  =0A=
> +static ssize_t queue_max_active_zones_show(struct request_queue *q, char=
 *page)=0A=
> +{=0A=
> +	return queue_var_show(queue_max_active_zones(q), page);=0A=
> +}=0A=
> +=0A=
>  static ssize_t queue_nomerges_show(struct request_queue *q, char *page)=
=0A=
>  {=0A=
>  	return queue_var_show((blk_queue_nomerges(q) << 1) |=0A=
> @@ -677,6 +682,11 @@ static struct queue_sysfs_entry queue_max_open_zones=
_entry =3D {=0A=
>  	.show =3D queue_max_open_zones_show,=0A=
>  };=0A=
>  =0A=
> +static struct queue_sysfs_entry queue_max_active_zones_entry =3D {=0A=
> +	.attr =3D {.name =3D "max_active_zones", .mode =3D 0444 },=0A=
> +	.show =3D queue_max_active_zones_show,=0A=
> +};=0A=
> +=0A=
>  static struct queue_sysfs_entry queue_nomerges_entry =3D {=0A=
>  	.attr =3D {.name =3D "nomerges", .mode =3D 0644 },=0A=
>  	.show =3D queue_nomerges_show,=0A=
> @@ -776,6 +786,7 @@ static struct attribute *queue_attrs[] =3D {=0A=
>  	&queue_zoned_entry.attr,=0A=
>  	&queue_nr_zones_entry.attr,=0A=
>  	&queue_max_open_zones_entry.attr,=0A=
> +	&queue_max_active_zones_entry.attr,=0A=
>  	&queue_nomerges_entry.attr,=0A=
>  	&queue_rq_affinity_entry.attr,=0A=
>  	&queue_iostats_entry.attr,=0A=
> @@ -803,7 +814,8 @@ static umode_t queue_attr_visible(struct kobject *kob=
j, struct attribute *attr,=0A=
>  		(!q->mq_ops || !q->mq_ops->timeout))=0A=
>  			return 0;=0A=
>  =0A=
> -	if (attr =3D=3D &queue_max_open_zones_entry.attr &&=0A=
> +	if ((attr =3D=3D &queue_max_open_zones_entry.attr ||=0A=
> +	     attr =3D=3D &queue_max_active_zones_entry.attr) &&=0A=
>  	    !blk_queue_is_zoned(q))=0A=
>  		return 0;=0A=
>  =0A=
> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c=0A=
> index af156529f3b6..502070763266 100644=0A=
> --- a/drivers/nvme/host/zns.c=0A=
> +++ b/drivers/nvme/host/zns.c=0A=
> @@ -83,6 +83,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct =
nvme_ns *ns,=0A=
>  	q->limits.zoned =3D BLK_ZONED_HM;=0A=
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);=0A=
>  	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);=0A=
> +	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);=0A=
>  free_data:=0A=
>  	kfree(id);=0A=
>  	return status;=0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index aa3564139b40..d8b2c49d645b 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -721,6 +721,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigne=
d char *buf)=0A=
>  		blk_queue_max_open_zones(q, 0);=0A=
>  	else=0A=
>  		blk_queue_max_open_zones(q, sdkp->zones_max_open);=0A=
> +	blk_queue_max_active_zones(q, 0);=0A=
>  	nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks=
);=0A=
>  =0A=
>  	/* READ16/WRITE16 is mandatory for ZBC disks */=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 2f332f00501d..3776140f8f20 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -521,6 +521,7 @@ struct request_queue {=0A=
>  	unsigned long		*conv_zones_bitmap;=0A=
>  	unsigned long		*seq_zones_wlock;=0A=
>  	unsigned int		max_open_zones;=0A=
> +	unsigned int		max_active_zones;=0A=
>  #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>  =0A=
>  	/*=0A=
> @@ -741,6 +742,17 @@ static inline unsigned int queue_max_open_zones(cons=
t struct request_queue *q)=0A=
>  {=0A=
>  	return q->max_open_zones;=0A=
>  }=0A=
> +=0A=
> +static inline void blk_queue_max_active_zones(struct request_queue *q,=
=0A=
> +		unsigned int max_active_zones)=0A=
> +{=0A=
> +	q->max_active_zones =3D max_active_zones;=0A=
> +}=0A=
> +=0A=
> +static inline unsigned int queue_max_active_zones(const struct request_q=
ueue *q)=0A=
> +{=0A=
> +	return q->max_active_zones;=0A=
> +}=0A=
>  #else /* CONFIG_BLK_DEV_ZONED */=0A=
>  static inline unsigned int blk_queue_nr_zones(struct request_queue *q)=
=0A=
>  {=0A=
> @@ -764,6 +776,14 @@ static inline unsigned int queue_max_open_zones(cons=
t struct request_queue *q)=0A=
>  {=0A=
>  	return 0;=0A=
>  }=0A=
> +static inline void blk_queue_max_active_zones(struct request_queue *q,=
=0A=
> +		unsigned int max_active_zones)=0A=
> +{=0A=
> +}=0A=
=0A=
Same comment as for max_open_zones here.=0A=
=0A=
> +static inline unsigned int queue_max_active_zones(const struct request_q=
ueue *q)=0A=
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
