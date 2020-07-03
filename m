Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD76C433E1
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9865A207CD
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FJHo3jnk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oR4ZPZlz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgGCFD0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:03:26 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19607 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCFDZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593752604; x=1625288604;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=N2UqwvJ9kfNsiNAmmtPTrLUptgCeWN9ZSiPEs5zOhco=;
  b=FJHo3jnk6H8R4GVTltxQhkJLMDzvOZ31ejdrkeIdElNo7zv94qDt0mtS
   bIdL90q63rnjVaqN2fNPvkZCtSpZYVQ5/NEjocVVWYqGWItuDnmUqBMEY
   /Sok7uiJHocRA+6o4Qir5VCkVw2BQeK2C7B9Scu09JwajH4/PpL0fTo7O
   jwd6EormD6e7dUkj0viQlbCbqKRL0T1tqyeo0Q7ZaSfoTnb+Uxiq8O77l
   NupSGj0ENIHmplgM8en357P4A3SDxJAYHzpAiwMtgqSVb7n09Uz+3u/5f
   l1qGRi2bc9095htPhoHovVMv8G1vrW+OPPP4dN5044kUz9jqM+Rag9hFD
   A==;
IronPort-SDR: yqAvVeHv+oS31yR6vLmfZn2K2UDm/yn4mUCp4L59rPTLw4lZLs0jzbJRc0AXl+tfCadfDCnFzY
 QNTf3VMT7VJDFj4ZwBtjW5F69BtLFW1a8wwUy0zZFc0g6qKpn8wk1FHXBljI1PfsiQvdO0DwN7
 NZolq84tuE/P0amgByxtVeS6u+MK/WLB0VgllAwkNC93vx0ceQihR1YRGKNagLgOBJ7kS2nbeB
 DT+JiqxRyhBwd7rKrdwxldT7vMncxz+/YUJmVovD+sGw0CljL5mIS4BH6cjCe5vOpOS3yE7aEL
 R5U=
X-IronPort-AV: E=Sophos;i="5.75,307,1589212800"; 
   d="scan'208";a="250783527"
Received: from mail-cys01nam02lp2056.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.56])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2020 13:03:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5DEFWwIeDyqr+03LXZiXf1ootWg8x5Ph8s2x4BT7CzDKVICyTIQnSDG3sn60L9lJ5UNKO6ghAo7kEZ7MDcNRWnN8Ge21Mof9KYR6AwBc3vm01HJMUpADJLdsPvhIZu7dwiNjU6Kz/Gs0JdSAzbC3UD31SZZEXmZo7qVp8yS83Ja6wWlClVHQCv9KxK09jAEqHyiiTEeXk35419nPywuiSa2K01fzwBCLzPYtVswZyaf94o8RG53OCweM+aZnUjmhQOttxl/8xte0m/mMHtSS2I/thzwiiUWu49WM41P78AcRRmvTfXOYnypTutgSp3c0fgiYRnexNZXCPOe3W+/uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJ7j8yYIJeJ4Xa2J+3zZ+VoD+MCIz+nCmypaFJMT+wI=;
 b=ZxvDp7zjlmtkKMurs2Vx8u7wQSf/HUC3ZzzUzI7oQ7iKxbqSqRl361Z298x5ulm3k3vvWvtykYc8FVOhZMwbzBMjgANNpiQ0XYnwUFVAajH4VWYp8CnlDJZdYZeNCi8j8WWV+3GW2Vd6Fsmul15fuBZ/fEwE9WKRfb84wJVR0iEXG8qrdM+cmFNqSO3LDxsGVHnoja1sid+nXmXhq1SeOJVYOyZhVvXD6bXFVMRBA6mDPTyF8Y6bIMUFu1qTBAexUWn1LOY0KhTNnQbiGSi/tGxBK4cbv1M3X/CbIVEMLV9amuPDi/4wd3Ak3jqjtU2akWL1CMkj4jKN3jmnPbSaZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJ7j8yYIJeJ4Xa2J+3zZ+VoD+MCIz+nCmypaFJMT+wI=;
 b=oR4ZPZlzwZyQqWTtQlzb6j4boCL6EHK7ezNfO41SxOd9xsFdmSnfaun7ODC6S1iazJs5EqXlTHf9bP2WeDjWG6GWQN2TasQWh/Qq0bMWhN4PgKumINYUZRGvRTrrzNOWvO9vXNIsAqeVAFQdey6zMBTPXyvdDcd2M2mOQ5GOR+M=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1256.namprd04.prod.outlook.com (2603:10b6:910:52::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Fri, 3 Jul
 2020 05:03:21 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3153.022; Fri, 3 Jul 2020
 05:03:21 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] block: add max_open_zones to blk-sysfs
Thread-Topic: [PATCH v2 1/2] block: add max_open_zones to blk-sysfs
Thread-Index: AQHWUJ1lxUIFGXZs1EKrt/jHY/9h1g==
Date:   Fri, 3 Jul 2020 05:03:21 +0000
Message-ID: <CY4PR04MB375175BB7359179C8256FA38E76A0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200702181922.24190-1-niklas.cassel@wdc.com>
 <20200702181922.24190-2-niklas.cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ab69b13f-3ea6-4f5b-0c40-08d81f0e687f
x-ms-traffictypediagnostic: CY4PR04MB1256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB12564E9149BC7917D3D5CD24E76A0@CY4PR04MB1256.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UpQG/twH4QY3BLHZB6sGARV/wSTHnx69RH6hkaa7bAvKyR88JY9h1Wvq1s6w62Pb4gNsZhqnr2C2Tn96IADdZJUqQfy580osYC6rSoaqnmXlLUAjk3WUc8wLQ3hcS8h7LZ9x6UN5MhFb+gw4A/XMjuBDzaPJVCCIp+ra+LEIvcpXqWbUoEg9MoUX63WUgN84kRQnDw1tbtySNmBF9ENv9Um5s3znoz4f0jIC9DA35L7QnDWqrDto43Xc+qsBXdUNsWTKYvvZRxh1WkNs2io8nUw9IBLskZYoxVLY3sFNX2FXi5rWwlIm7LCjEBIEO+whCpptn92pJEV31xvXpN/lmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(66574015)(83380400001)(5660300002)(86362001)(2906002)(66946007)(8936002)(8676002)(66476007)(66556008)(64756008)(66446008)(76116006)(91956017)(478600001)(7696005)(186003)(26005)(6506007)(53546011)(54906003)(71200400001)(4326008)(110136005)(55016002)(52536014)(9686003)(33656002)(316002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: dmd5riCP2ZxaPSXh5pzu07K2QUwayYN1wqZacimjIUmTp1RljbjYPlM+ybCHfOeiUyIvKKtWaLAvpHaRfRf5m0wcWHz3g6mElNIlNS/PRlH0CpEI0xRpHv1JzJfawHIGMQtNknh8dpE0HhcAw4Woatc2pwuXuvLb/HksdEBJwOfUYQtJCnwt23OnF/VH/bh2yYz5dMWqoGzcMeoXF7Igh1TpBfyYm/UltBA8/BKqZroJXCQNZwNrgCD6pnQCxVRNAbXUwht83oniLHMZBFaUxVfPAdRB0CDPwMi1qBV6KumqcxHLJ0c7vwdyl+L8EEbLtybGolKXobgMR/7peip7ZBLVVmMCn2S2ZX8nbgRm/WOZAy1n4vugZCHBr0m46ieYUw/JiQAvd3684Ib/1cRtmhU5Bt9vMFRxuzt3tlh6C9iPdJ7UcCrYGMdXe5HpU0erYVP8/G3pXLWhzo18RupgQw3wPNKh8NMSoq94OIM9YPRSCUNzru5SXRa745ReJ0y0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab69b13f-3ea6-4f5b-0c40-08d81f0e687f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 05:03:21.4355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iqW20NCoFTIFSiqZ6d+Fw1pbbzlzMmC5myenDtsJ+OTqOrHZ6PwBa1lO1qb8Te6pugafNrZAedpkUFoHlqpUqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1256
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/03 3:20, Niklas Cassel wrote:=0A=
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
> Add the new max_open_zones member to struct request_queue, rather=0A=
> than as a queue limit, since this property cannot be split across stackin=
g=0A=
> drivers.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> Reviewed-by: Javier Gonz=E1lez <javier@javigon.com>=0A=
> ---=0A=
>  Documentation/block/queue-sysfs.rst |  7 +++++++=0A=
>  block/blk-sysfs.c                   | 15 +++++++++++++++=0A=
>  drivers/nvme/host/zns.c             |  1 +=0A=
>  drivers/scsi/sd_zbc.c               |  4 ++++=0A=
>  include/linux/blkdev.h              | 16 ++++++++++++++++=0A=
>  5 files changed, 43 insertions(+)=0A=
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
> index 04e5b991c00c..3d80b9cf6bfc 100644=0A=
> --- a/drivers/nvme/host/zns.c=0A=
> +++ b/drivers/nvme/host/zns.c=0A=
> @@ -96,6 +96,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct =
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
>  	nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks=
);=0A=
>  =0A=
>  	/* READ16/WRITE16 is mandatory for ZBC disks */=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 8fd900998b4e..fe168abcfdda 100644=0A=
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
> @@ -744,6 +756,10 @@ static inline unsigned int blk_queue_zone_no(struct =
request_queue *q,=0A=
>  {=0A=
>  	return 0;=0A=
>  }=0A=
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
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
