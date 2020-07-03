Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CBCC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCEBA20771
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:04:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Z+4Srb7v";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TC8JTSvg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGCFEc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:04:32 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19695 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCFEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593752671; x=1625288671;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=V7q6loCXsqhfXIfP198rwYP5h6IYjGU9hlyYaKVtoQY=;
  b=Z+4Srb7v275YJlShZ/Wul/2DxSHAR/8+aUCQ9DQ4pHWHAETVPuiPM4Qq
   bWhBOiInEWiAgHtcYDvZGtZhSldB2Tfw5GMtO90mwr6uSIuMdVz5+cjlj
   yn7mDqjWgtLgXQXjADO/Jbvm10NZU6rLFqQnz/VnCLzteRZRa6lYYOoas
   SLM9KE08YzM60PV5mWo4xkxqax19iJeb4L6bLHJ8LWp7E0WZm6RLtyLX3
   0ZEmwLkJ8UniJtyVu5f6lDSBlN8cTCZI5mPqSEHqO2c6iXdYgu34ICnch
   xNPJH/0oN0Y+uc5HB8sLRStcp9PxX//vTbe+2vtuzqB9YGTBH9XQES5gr
   g==;
IronPort-SDR: 6hXlHYEYvw/KqpryjBunBcTQKkWwtw8A11wfeUpMa6GgXHQc2spCUoc7Qzsmguq/IXx3st9ljl
 U/xZ25L+ptNDaERr+qm1G1Gfput45/9g9p4DIRjsGOt+4zJm/V3JlQEqBTkbYJxEmDcOY79ilh
 arO3bF59u1PQ+2d9d6ds1OuTCAsuFxjkyY2NjxCOO6RPha1GVu1EIJLWcgyDVrZs3oSG075lJe
 6+hlWyhTEet1Jih19pLdTCp2yrngdtWH/UiDlRd9rCnpX2MoCIPgH70f1pUY/OYni3OE8/SNBN
 Epk=
X-IronPort-AV: E=Sophos;i="5.75,307,1589212800"; 
   d="scan'208";a="250783622"
Received: from mail-cys01nam02lp2056.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.56])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2020 13:04:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Si6I8Wo7DyuPx2TA6Nipni2wJx1LP3PlY42Rq10iFAKUnro1QH8WD/NOw/+FJP7zy7jNCq/teK866UmY6y5QysUMER8AyQuok139nh3InMlV10qRsP93ekvKI3VqDpuLcj0XB8Qx6K0NIXkNsqd/e9J5nvaf9VF2m6JtHXmKtXma7nPRmuoBZMf7kbFw/ImDpdDFixdcNh+7CytXAAdK5C6QofazEScu8SlO1VDybPhqMDOXZJmNFTLbsWv5n0TvAz6xA1KNDlD6yHrZNBfyBDSvnXTBkHbvNzWK4oD+lCi5VC4D2vxX0I75AQnuP9fh8OciWptMkIcgGjf4SZB7Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70am78hERB52pFinT74h8uB0Uh68Tkwtnwz6PiSF5c0=;
 b=FanRBCMhJFL657LNaIXVKsWEj0VsCEjKn8ykTa0quCe9w0h+QtAEG53B5kNLSu7S5+EYfoFMKlWS93zOBSFtyAQfTFEk/Czs30B18R3b+rpm6di/fpCYtH4mNq7roBMPAUI6S1K+MhS9eRqT0kEMTrZFgnRVm1G9lr2kZWLynQmC34ksDpqh3M2D9xaPKfJQ/JGw3EbSRKDe2OMUZNo+pkSPq0rmJRe+SLbRv348jv1mkmc+T/T30q6noQ37PGTkSYlPwE9uceHcZNLAvWJ33QEFTTc/74kNe2JHwXcqfLWCfquRMy2SC4YOKqch2aqGdIg5mzWAjPOKz1W98PhSnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70am78hERB52pFinT74h8uB0Uh68Tkwtnwz6PiSF5c0=;
 b=TC8JTSvgtk+NAxq7ZNsdUu57KxNP0QmhAK62MFPBf/cHMNFRzR83Ban4Cf+G6LmhwpXsgNKWcGUCTMeQ/azqAKmmU9/Ok4118hkhj+7jpwSaPUqF2WxeuO33JlhaaNitD6ziqWb3CXGIaUY2UNWEHMAEdIUgZWhXKt9yoFgRC/w=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1256.namprd04.prod.outlook.com (2603:10b6:910:52::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Fri, 3 Jul
 2020 05:04:29 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3153.022; Fri, 3 Jul 2020
 05:04:29 +0000
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
Subject: Re: [PATCH v2 2/2] block: add max_active_zones to blk-sysfs
Thread-Topic: [PATCH v2 2/2] block: add max_active_zones to blk-sysfs
Thread-Index: AQHWUJ1p06hnAS8BF0W4ErHH9Q9yUQ==
Date:   Fri, 3 Jul 2020 05:04:29 +0000
Message-ID: <CY4PR04MB37511CA70FD74491827DF025E76A0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200702181922.24190-1-niklas.cassel@wdc.com>
 <20200702181922.24190-3-niklas.cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1510ffdd-193f-457d-e014-08d81f0e90e1
x-ms-traffictypediagnostic: CY4PR04MB1256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB12567517D1B306A162C417C6E76A0@CY4PR04MB1256.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZWSiHgih0vOzG04T92znhDuGdicaBdGPlkVIicmxGmXFbk3HSPIVySgQdBg75Aa2E/Kum8WplPEUu1EflCE7w3fuvocrOYamMkJ51SQLKdv9ORouqWn3eDb8nEPEH1muDv/3Mic0sPX+sXmi2TGx5gPODQ34RWd8qIy/1Wpln09LtL4mdxz0zQeEOb8LoXpbOOTi7yPEka9Akz8VGgZetDeJFXl3bNdJonKeiwZUJ/TgJ/KEuaLM6/+uequ0Dk7W7yxz8Z6Kj9Q/yhDpnKYKtQPVMbgEg3X1HepTzB94rQGSEYow96rBl0iSA+x2zpmEk+HMIOb/etmGA5zf+yF+FQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(66574015)(83380400001)(5660300002)(86362001)(2906002)(66946007)(8936002)(8676002)(66476007)(66556008)(64756008)(66446008)(76116006)(91956017)(478600001)(7696005)(186003)(26005)(6506007)(53546011)(54906003)(71200400001)(4326008)(110136005)(55016002)(52536014)(9686003)(33656002)(316002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zqQnBzRpRDNQaxkD9l2VEUNFdyKLRGS2TZLe6oWX4ZiGngnETNoQKjpKa9Q+ByqSJuJVFS57wekjj8RfOueBm6RbHrgbvgBxLLCPtaZdDsMwWJ8iXGnqgO1YSxl7t/MD+etb05dXt5XRDS+Scb8TRlYJUwDCa6hZ1IRIaU+N381Qo/HbnHChPf2/GZU52VgpXeV38bBLLucKLrd3P8bKG9vvsmgzwdqc0txKEe/8zEl5G4pmXnItnpJ2gJoU++KNf+JZl4EwEf+g0cgl14187SV4q76HNdcoPCPMkOaUT8SUZ0PYiMg15edrjjJ8GNMfJhzFFVXVyYZI21yQ/3inmP1KpqvvpUv8dn/Nee00gQjsH+aHt4GbKtznr2BGWqJyPpVYMeB8mMoEPHlI8+VW4E9Z1r4Wug8Kaq3LiCk+m/awRagAXrbnCvl5cAdycY93eVe13oA8DG2H/Y7eB/LGtbAGDWucUHXZyXfrPN9BKaBuAKysfbZs+6oJMbiqhOIn
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1510ffdd-193f-457d-e014-08d81f0e90e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 05:04:29.2650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JxcbarzDMxyjULR98RJV8BUnYF+vbtpGZxkS09LVkOh6KPW6E2q6fccc1mFvBEiyR+jR8JvELxCeFPAvgCns+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1256
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/03 3:20, Niklas Cassel wrote:=0A=
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
> Add the new max_active_zones member to struct request_queue, rather=0A=
> than as a queue limit, since this property cannot be split across stackin=
g=0A=
> drivers.=0A=
> =0A=
> For SCSI devices, even though max active zones is not part of the ZBC/ZAC=
=0A=
> spec, export max_active_zones as 0, signifying "no limit".=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> Reviewed-by: Javier Gonz=E1lez <javier@javigon.com>=0A=
> ---=0A=
>  Documentation/block/queue-sysfs.rst |  7 +++++++=0A=
>  block/blk-sysfs.c                   | 14 +++++++++++++-=0A=
>  drivers/nvme/host/zns.c             |  1 +=0A=
>  drivers/scsi/sd_zbc.c               |  1 +=0A=
>  include/linux/blkdev.h              | 16 ++++++++++++++++=0A=
>  5 files changed, 38 insertions(+), 1 deletion(-)=0A=
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
> index 3d80b9cf6bfc..57cfd78731fb 100644=0A=
> --- a/drivers/nvme/host/zns.c=0A=
> +++ b/drivers/nvme/host/zns.c=0A=
> @@ -97,6 +97,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct =
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
> index fe168abcfdda..bb9e6eb6a7e6 100644=0A=
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
> @@ -760,6 +772,10 @@ static inline unsigned int queue_max_open_zones(cons=
t struct request_queue *q)=0A=
>  {=0A=
>  	return 0;=0A=
>  }=0A=
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
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
