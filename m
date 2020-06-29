Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50E1C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 01:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A078206C0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 01:00:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XzsLylOt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bvk5J1h7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgF2BAL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 21:00:11 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:60795 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgF2BAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 21:00:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593392412; x=1624928412;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=JTCrS8CjlptUiymm+4AUF8QbZQI4Ws++ALILMjufE94=;
  b=XzsLylOtstmION20Yepj7BPu+AujjJlIeXS5Ms5ksdBPrYpZ+Kj+p+RF
   t8abdvcdqNv7kqgX4pz9n7oa6bksuk7yodXhLQvoxhjmpHwMk2qxg4+st
   SsuQxsn0GV9JLs81rSmAtCMt8XKYgOzlc4C9JxI3HiPREniMGZRLUrKIB
   fl4cUuCqm69W8aouBcLQMgVqqCIVOc6PlDJo9YK3kaRE2p567x3YTy3z2
   HnCbD/sg4kdSBRbMvV7Ib6VzOavTWqHvIeP7bvQRBFj+NsiW+/83II08A
   PxkgEuRSsnWiSsh75VikJM2PBS9jvGAfY2jUwbxXbdbfk0rLPaDN/yu63
   A==;
IronPort-SDR: 1qZJpHUlEjxcriXvOY+DSqB6Az+d0uG0AQU1GIOX84pNrJTwSRmcYGG7wODFFaHsExORRYWbaR
 e6U2RTLRk+UHW6AWsS+7Q+WCCLgucwzXbr0gNfEI7fdaTiVW5UUNhWPu1n7nPffW/1RUkQWeGM
 x3w3S7GHb7DCtlu+cEEf+TOnvVvdcJTGiZijWV2+8+TniroEQSkUcf9EJpiJR8G0crApVv8U20
 QVocY7lpbsQhsmM0q0LiB6Pp8Rug1jwx1ZnsLhs0dUWX3XnlHFiQCOx/CIa7fg1c0OzDRapFk0
 3uM=
X-IronPort-AV: E=Sophos;i="5.75,293,1589212800"; 
   d="scan'208";a="244157395"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 09:00:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hc01Bl338ZyN344WuIf6Py8f+3CpYJbGI044+P0B3Yk17QB+CbMbG159vxDAvZ90AX+vS1xrbWNytsAQ91banAJXYKf0jC+LFIVPHAESvWjuWY6xK8MHMOcOxxJ+Sd765qM5uur/nibtQPg+meTFW5sWMVSzfXZBJEqXQDVeuGqzYiH+jOqXIFUhP7zsOerLx3euFG7NCez4hcF4MFSXbpKn0mwEJLnmFmAPQtuMoUfnw2Ud4MJM1Ss4ylG+MZG7RVCmPSQVCKaz3M4RQGe1tZtv2ZQ7ri48YbopR1WWsllG3vuoDqQ+wD4D69bU9LpDkhK3Ac+dKd5cAWibVhArYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/4qOEEcze1gvpUQp6NdbGgP0HT2EspkzrJ4MPYV7gY=;
 b=MtqhMyR5Gv0igqhzUq6ijRzq3mTphjwBu+oGQ5mmp8gzJ5b9luqnWSRAt7PtI4dmIlQG3XR5iCOEiTu+aykq/huNHaUrMjwohV8m+Kwns0Dr5oYcwe7yMH/rv2XooPnX1ZpIuvJqZbXKeYT5pFWXkePx53lrL/+1O2eb/iQDdrFRa4h4o8t/NGEd291uClJ8YoHZtyW25/co+Se05PlGyybLMQrHlnW3YuoA/+9k/ykDigwXIffntLzOzctS4pAMq7nSrA9zU9g4iyi8zvzjQ3Ro+OwWuy1NdSAcReKnxZ4HLHQbwxU84D9wvmswpgCxq0lsut6QtEH+BLsidlX/fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/4qOEEcze1gvpUQp6NdbGgP0HT2EspkzrJ4MPYV7gY=;
 b=bvk5J1h7a1KAp7wneAd/efjAj7zP27pLDeP9fkyob1wpgcD0oczDtO2uULFahpuL4RfIgi+BbXLZQgObA5gwrpdsmSRtd4QMxRG8UcCMkxQvQ5RkTX89m7ut6k2LPO7qCnYInn0fRcfDm17ngrW7GPViQ2N/fw/unDTwCQtRKaM=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0374.namprd04.prod.outlook.com (2603:10b6:903:bb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Mon, 29 Jun
 2020 01:00:06 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Mon, 29 Jun 2020
 01:00:05 +0000
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
Subject: Re: [PATCH 2/2] block: add BLKSETDESCZONE ioctl for Zoned Block
 Devices
Thread-Topic: [PATCH 2/2] block: add BLKSETDESCZONE ioctl for Zoned Block
 Devices
Thread-Index: AQHWTaAf9fLinKVA0kyZGzXPFf2RKQ==
Date:   Mon, 29 Jun 2020 01:00:05 +0000
Message-ID: <CY4PR04MB37518908765B458987C57702E76E0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200628230102.26990-1-matias.bjorling@wdc.com>
 <20200628230102.26990-3-matias.bjorling@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1d2d17e8-87f6-4e8a-e26d-08d81bc7c301
x-ms-traffictypediagnostic: CY4PR04MB0374:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0374C274B0B5E3652ECAD167E76E0@CY4PR04MB0374.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jl3dPh7wiMTPd6yCtTzvbxBVMnJ+izPr5I/g+2/VEkC9GDSPeXLJZOA9R99zxUEw+I2dPDnxMNDilpWhxcU6tqJ5X51pddiFDAVbBKGo0RTmP9kj1BglTTo7GslCatlDjCDFivcd0aXdxkU7zUWhv5lBxSmul3n4csnJC8RFS7mvo2rvqVip2svv2ii1EsE+H28s2vpNKcMPsglGhiI0sIpoWoOI30TloT3+mlqcaT+TtcuOs4fnojLo7+DnjdJaYxgITKVWfOZCZeYojbkydlvkuvj6SfirzWzqTL7eWVeY7fAPkql3z8UyFobKxeR83MWb15PNjAcuAfVr40kpKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(30864003)(86362001)(5660300002)(7696005)(6636002)(8936002)(186003)(498600001)(54906003)(110136005)(4326008)(26005)(71200400001)(33656002)(52536014)(83380400001)(9686003)(91956017)(55016002)(6506007)(2906002)(66476007)(64756008)(53546011)(66446008)(76116006)(66946007)(66556008)(8676002)(66574015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: arY97rY0Yi4veUSXTAaXprSn36Gc+DQD1p/2Zct7zwR7svKowQ1MQg3tIc1u4W92z/SgXNycIfQTgtwlfSKathgs56h8xqaZkNRSvTWBw9wWrE39R/lR60KpAcG0ScR7YthRiL4aSUEOY+gZwtP0M9HcHoDspDr0vnUhFKlv8Mmrt3GMOPInqGYv6mqBeoI4k2UnT8JUTcIXWaZeigPYCNz+AbjwxBPzd7d5e2tGmS2rDKNv8D4S8622MbY01PtTJ3aO/mpahJej7PqjfZ0O5aVAqeg+trmWtsgDyJslvxd1wHciW9D67D801hMN1qmz50ZZreO1EY26O+ENdg4RTZMo7aybgZ8574jUK9qFqiXyZHRkUdFI8vvtS38Pk0C7J3OSQU+cwAtBpTr1u69GEImgGJWJqqt8PcFBcuHnV7VId8tHwgVPJsrWm2ib9cwbSwIdmlAnwrAwX6oQSoEOSPpk13qLKiJXsfTKfn+zHYo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d2d17e8-87f6-4e8a-e26d-08d81bc7c301
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 01:00:05.5498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6/ZkRp6fqsh/7F33iuVdovIyU7+FJMbt7OPDQ7LVb5yEAMo8VB5dffWlYKk46XinVCCQTxYSNnyEGY/vmX7Vkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0374
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/29 8:01, Matias Bjorling wrote:=0A=
> The NVMe Zoned Namespace Command Set adds support for associating=0A=
> data to a zone through the Zone Descriptor Extension feature.=0A=
> =0A=
> To allow user-space to associate data to a zone, add support through=0A=
> the BLKSETDESCZONE ioctl. The ioctl requires that it is issued to=0A=
> a zoned block device, and that it supports the Zone Descriptor=0A=
> Extension feature. Support is detected through the=0A=
> the zone_desc_ext_bytes sysfs queue entry for the specific block=0A=
> device. A value larger than zero communicates that the device supports=0A=
> the feature.=0A=
> =0A=
> The ioctl associates data to a zone by issuing a Zone Management Send=0A=
> command with the Zone Send Action set as the Set Zone Descriptor=0A=
> Extension.=0A=
> =0A=
> For the command to complete successfully, the specified zone must be=0A=
> in the Empty state, and active resources must be available. On=0A=
> success, the specified zone is transioned to Closed state by the=0A=
> device. If less data is supplied by user-space then reported by the=0A=
> the Zone Descriptor Extension size, the rest is zero-filled. If more=0A=
> data or no data is supplied by user-space, the ioctl fails.=0A=
> =0A=
> To issue the ioctl, a new blk_zone_set_desc data structure is defined.=0A=
> It has following parameters:=0A=
> =0A=
>  * the sector of the specific zone.=0A=
>  * the length of the data to be associated to the zone.=0A=
>  * any flags be used by the ioctl. None is defined.=0A=
>  * data associated to the zone.=0A=
> =0A=
> The data is laid out after the flags parameter, and it is the caller's=0A=
> responsibility to allocate memory for the data that is specified in the=
=0A=
> length parameter.=0A=
> =0A=
> Signed-off-by: Matias Bj=F8rling <matias.bjorling@wdc.com>=0A=
> ---=0A=
>  block/blk-zoned.c             | 108 ++++++++++++++++++++++++++++++++++=
=0A=
>  block/ioctl.c                 |   2 +=0A=
>  drivers/nvme/host/core.c      |   3 +=0A=
>  drivers/nvme/host/nvme.h      |   9 +++=0A=
>  drivers/nvme/host/zns.c       |  11 ++++=0A=
>  include/linux/blk_types.h     |   2 +=0A=
>  include/linux/blkdev.h        |   9 ++-=0A=
>  include/uapi/linux/blkzoned.h |  20 ++++++-=0A=
>  8 files changed, 162 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
> index 81152a260354..4dc40ec006a2 100644=0A=
> --- a/block/blk-zoned.c=0A=
> +++ b/block/blk-zoned.c=0A=
> @@ -259,6 +259,50 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum=
 req_opf op,=0A=
>  }=0A=
>  EXPORT_SYMBOL_GPL(blkdev_zone_mgmt);=0A=
>  =0A=
> +/**=0A=
> + * blkdev_zone_set_desc - Execute a zone management set zone descriptor=
=0A=
> + *                        extension operation on a zone=0A=
> + * @bdev:	Target block device=0A=
> + * @sector:	Start sector of the zone to operate on=0A=
> + * @data:	Pointer to the data that is to be associated to the zone=0A=
> + * @gfp_mask:	Memory allocation flags (for bio_alloc)=0A=
> + *=0A=
> + * Description:=0A=
> + *    Associate zone descriptor extension data to a specified zone.=0A=
> + *    The block device must support zone descriptor extensions.=0A=
> + *    i.e., by exposing a positive zone descriptor extension size.=0A=
> + */=0A=
> +int blkdev_zone_set_desc(struct block_device *bdev, sector_t sector,=0A=
> +			 struct page *data, gfp_t gfp_mask)=0A=
=0A=
struct page for the data ? Why not just a "void *" to allow for kmalloc/vma=
lloc=0A=
data ? And no length for the data ? This is a bit odd.=0A=
=0A=
> +{=0A=
> +	struct request_queue *q =3D bdev_get_queue(bdev);=0A=
> +	sector_t zone_sectors =3D blk_queue_zone_sectors(q);=0A=
> +	struct bio_vec bio_vec;=0A=
> +	struct bio bio;=0A=
> +=0A=
> +	if (!blk_queue_is_zoned(q))=0A=
> +		return -EOPNOTSUPP;=0A=
> +=0A=
> +	if (bdev_read_only(bdev))=0A=
> +		return -EPERM;=0A=
=0A=
You are not checking the zone_desc_ext_bytes limit here. You should.=0A=
> +=0A=
> +	/* Check alignment (handle eventual smaller last zone) */=0A=
> +	if (sector & (zone_sectors - 1))=0A=
> +		return -EINVAL;=0A=
=0A=
The comment is incorrect. There is nothing special for handling the last zo=
ne in=0A=
this test.=0A=
=0A=
> +=0A=
> +	bio_init(&bio, &bio_vec, 1);=0A=
> +	bio.bi_opf =3D REQ_OP_ZONE_SET_DESC | REQ_SYNC;=0A=
> +	bio.bi_iter.bi_sector =3D sector;=0A=
> +	bio_set_dev(&bio, bdev);=0A=
> +	bio_add_page(&bio, data, queue_zone_desc_ext_bytes(q), 0);=0A=
> +=0A=
> +	/* This may take a while, so be nice to others */=0A=
> +	cond_resched();=0A=
=0A=
This is not a loop, so you do not need this.=0A=
=0A=
> +=0A=
> +	return submit_bio_wait(&bio);=0A=
> +}=0A=
> +EXPORT_SYMBOL_GPL(blkdev_zone_set_desc);=0A=
> +=0A=
>  struct zone_report_args {=0A=
>  	struct blk_zone __user *zones;=0A=
>  };=0A=
> @@ -370,6 +414,70 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev=
, fmode_t mode,=0A=
>  				GFP_KERNEL);=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * BLKSETDESCZONE ioctl processing.=0A=
> + * Called from blkdev_ioctl.=0A=
> + */=0A=
> +int blkdev_zone_set_desc_ioctl(struct block_device *bdev, fmode_t mode,=
=0A=
> +			       unsigned int cmd, unsigned long arg)=0A=
> +{=0A=
> +	void __user *argp =3D (void __user *)arg;=0A=
> +	struct request_queue *q;=0A=
> +	struct blk_zone_set_desc zsd;=0A=
> +	void *zsd_data;=0A=
> +	int ret;=0A=
> +=0A=
> +	if (!argp)=0A=
> +		return -EINVAL;=0A=
> +=0A=
> +	q =3D bdev_get_queue(bdev);=0A=
> +	if (!q)=0A=
> +		return -ENXIO;=0A=
> +=0A=
> +	if (!blk_queue_is_zoned(q))=0A=
> +		return -ENOTTY;=0A=
> +=0A=
> +	if (!capable(CAP_SYS_ADMIN))=0A=
> +		return -EACCES;=0A=
> +=0A=
> +	if (!(mode & FMODE_WRITE))=0A=
> +		return -EBADF;=0A=
> +=0A=
> +	if (!queue_zone_desc_ext_bytes(q))=0A=
> +		return -EOPNOTSUPP;=0A=
> +=0A=
> +	if (copy_from_user(&zsd, argp, sizeof(struct blk_zone_set_desc)))=0A=
> +		return -EFAULT;=0A=
> +=0A=
> +	/* no flags is currently supported */=0A=
> +	if (zsd.flags)=0A=
> +		return -ENOTTY;=0A=
> +=0A=
> +	if (!zsd.len || zsd.len > queue_zone_desc_ext_bytes(q))=0A=
> +		return -ENOTTY;=0A=
=0A=
This should go into blkdev_zone_set_desc() as well so that in-kernel users =
are=0A=
checked. So there may be no need to check this here.=0A=
=0A=
> +=0A=
> +	/* allocate the size of the zone descriptor extension and fill=0A=
> +	 * with the data in the user data buffer. If the data size is less=0A=
> +	 * than the zone descriptor extension size, then the rest of the=0A=
> +	 * zone description extension data buffer is zero-filled.=0A=
> +	 */=0A=
> +	zsd_data =3D (void *) get_zeroed_page(GFP_KERNEL);=0A=
> +	if (!zsd_data)=0A=
> +		return -ENOMEM;=0A=
> +=0A=
> +	if (copy_from_user(zsd_data, argp + sizeof(struct blk_zone_set_desc),=
=0A=
> +			   zsd.len)) {=0A=
> +		ret =3D -EFAULT;=0A=
> +		goto free;=0A=
> +	}=0A=
> +=0A=
> +	ret =3D blkdev_zone_set_desc(bdev, zsd.sector, virt_to_page(zsd_data),=
=0A=
> +	      GFP_KERNEL);=0A=
> +free:=0A=
> +	free_page((unsigned long) zsd_data);=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
>  static inline unsigned long *blk_alloc_zone_bitmap(int node,=0A=
>  						   unsigned int nr_zones)=0A=
>  {=0A=
> diff --git a/block/ioctl.c b/block/ioctl.c=0A=
> index bdb3bbb253d9..b9744705835b 100644=0A=
> --- a/block/ioctl.c=0A=
> +++ b/block/ioctl.c=0A=
> @@ -515,6 +515,8 @@ static int blkdev_common_ioctl(struct block_device *b=
dev, fmode_t mode,=0A=
>  	case BLKCLOSEZONE:=0A=
>  	case BLKFINISHZONE:=0A=
>  		return blkdev_zone_mgmt_ioctl(bdev, mode, cmd, arg);=0A=
> +	case BLKSETDESCZONE:=0A=
> +		return blkdev_zone_set_desc_ioctl(bdev, mode, cmd, arg);=0A=
>  	case BLKGETZONESZ:=0A=
>  		return put_uint(argp, bdev_zone_sectors(bdev));=0A=
>  	case BLKGETNRZONES:=0A=
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c=0A=
> index e961910da4ac..b8f25b0d00ad 100644=0A=
> --- a/drivers/nvme/host/core.c=0A=
> +++ b/drivers/nvme/host/core.c=0A=
> @@ -776,6 +776,9 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struc=
t request *req,=0A=
>  	case REQ_OP_ZONE_FINISH:=0A=
>  		ret =3D nvme_setup_zone_mgmt_send(ns, req, cmd, NVME_ZONE_FINISH);=0A=
>  		break;=0A=
> +	case REQ_OP_ZONE_SET_DESC:=0A=
> +		ret =3D nvme_setup_zone_set_desc(ns, req, cmd);=0A=
> +		break;=0A=
>  	case REQ_OP_WRITE_ZEROES:=0A=
>  		ret =3D nvme_setup_write_zeroes(ns, req, cmd);=0A=
>  		break;=0A=
> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h=0A=
> index 662f95fbd909..5bd5a437b038 100644=0A=
> --- a/drivers/nvme/host/nvme.h=0A=
> +++ b/drivers/nvme/host/nvme.h=0A=
> @@ -708,6 +708,9 @@ int nvme_report_zones(struct gendisk *disk, sector_t =
sector,=0A=
>  blk_status_t nvme_setup_zone_mgmt_send(struct nvme_ns *ns, struct reques=
t *req,=0A=
>  				       struct nvme_command *cmnd,=0A=
>  				       enum nvme_zone_mgmt_action action);=0A=
> +=0A=
> +blk_status_t nvme_setup_zone_set_desc(struct nvme_ns *ns, struct request=
 *req,=0A=
> +				       struct nvme_command *cmnd);=0A=
>  #else=0A=
>  #define nvme_report_zones NULL=0A=
>  =0A=
> @@ -718,6 +721,12 @@ static inline blk_status_t nvme_setup_zone_mgmt_send=
(struct nvme_ns *ns,=0A=
>  	return BLK_STS_NOTSUPP;=0A=
>  }=0A=
>  =0A=
> +static inline blk_status_t nvme_setup_zone_set_desc(struct nvme_ns *ns,=
=0A=
> +		struct request *req, struct nvme_command *cmnd)=0A=
> +{=0A=
> +	return BLK_STS_NOTSUPP;=0A=
> +}=0A=
> +=0A=
>  static inline int nvme_update_zone_info(struct gendisk *disk,=0A=
>  					struct nvme_ns *ns,=0A=
>  					unsigned lbaf)=0A=
> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c=0A=
> index 5792d953a8f3..bfa64cc685d3 100644=0A=
> --- a/drivers/nvme/host/zns.c=0A=
> +++ b/drivers/nvme/host/zns.c=0A=
> @@ -239,3 +239,14 @@ blk_status_t nvme_setup_zone_mgmt_send(struct nvme_n=
s *ns, struct request *req,=0A=
>  =0A=
>  	return BLK_STS_OK;=0A=
>  }=0A=
> +=0A=
> +blk_status_t nvme_setup_zone_set_desc(struct nvme_ns *ns, struct request=
 *req,=0A=
> +		struct nvme_command *c)=0A=
> +{=0A=
> +	c->zms.opcode =3D nvme_cmd_zone_mgmt_send;=0A=
> +	c->zms.nsid =3D cpu_to_le32(ns->head->ns_id);=0A=
> +	c->zms.slba =3D cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));=0A=
> +	c->zms.action =3D NVME_ZONE_SET_DESC_EXT;=0A=
> +=0A=
> +	return BLK_STS_OK;=0A=
> +}=0A=
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
> index ccb895f911b1..53b7b05b0004 100644=0A=
> --- a/include/linux/blk_types.h=0A=
> +++ b/include/linux/blk_types.h=0A=
> @@ -316,6 +316,8 @@ enum req_opf {=0A=
>  	REQ_OP_ZONE_FINISH	=3D 12,=0A=
>  	/* write data at the current zone write pointer */=0A=
>  	REQ_OP_ZONE_APPEND	=3D 13,=0A=
> +	/* associate zone desc extension data to a zone */=0A=
> +	REQ_OP_ZONE_SET_DESC	=3D 14,=0A=
>  =0A=
>  	/* SCSI passthrough using struct scsi_request */=0A=
>  	REQ_OP_SCSI_IN		=3D 32,=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 2ed55055f68d..c5f092dd5aa3 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -370,7 +370,8 @@ extern int blkdev_report_zones_ioctl(struct block_dev=
ice *bdev, fmode_t mode,=0A=
>  				     unsigned int cmd, unsigned long arg);=0A=
>  extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mod=
e,=0A=
>  				  unsigned int cmd, unsigned long arg);=0A=
> -=0A=
> +extern int blkdev_zone_set_desc_ioctl(struct block_device *bdev, fmode_t=
 mode,=0A=
> +				      unsigned int cmd, unsigned long arg);=0A=
>  #else /* CONFIG_BLK_DEV_ZONED */=0A=
>  =0A=
>  static inline unsigned int blkdev_nr_zones(struct gendisk *disk)=0A=
> @@ -392,6 +393,12 @@ static inline int blkdev_zone_mgmt_ioctl(struct bloc=
k_device *bdev,=0A=
>  	return -ENOTTY;=0A=
>  }=0A=
>  =0A=
> +static inline int blkdev_zone_set_desc_ioctl(struct block_device *bdev,=
=0A=
> +					     fmode_t mode, unsigned int cmd,=0A=
> +					     unsigned long arg)=0A=
> +{=0A=
> +	return -ENOTTY;=0A=
> +}=0A=
>  #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>  =0A=
>  struct request_queue {=0A=
> diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.=
h=0A=
> index 42c3366cc25f..68abda9abf33 100644=0A=
> --- a/include/uapi/linux/blkzoned.h=0A=
> +++ b/include/uapi/linux/blkzoned.h=0A=
> @@ -142,6 +142,20 @@ struct blk_zone_range {=0A=
>  	__u64		nr_sectors;=0A=
>  };=0A=
>  =0A=
> +/**=0A=
> + * struct blk_zone_set_desc - BLKSETDESCZONE ioctl requests=0A=
> + * @sector: Starting sector of the zone to operate on.=0A=
> + * @flags: Feature flags.=0A=
> + * @len: size, in bytes, of the data to be associated to the zone.=0A=
> + * @data: data to be associated.=0A=
> + */=0A=
> +struct blk_zone_set_desc {=0A=
> +	__u64		sector;=0A=
> +	__u32		flags;=0A=
> +	__u32		len;=0A=
> +	__u8		data[0];=0A=
> +};=0A=
> +=0A=
>  /**=0A=
>   * Zoned block device ioctl's:=0A=
>   *=0A=
> @@ -158,6 +172,10 @@ struct blk_zone_range {=0A=
>   *                The 512 B sector range must be zone aligned.=0A=
>   * @BLKFINISHZONE: Mark the zones as full in the specified sector range.=
=0A=
>   *                 The 512 B sector range must be zone aligned.=0A=
> + * @BLKSETDESCZONE: Set zone description extension data for the zone=0A=
> + *                  in the specified sector. On success, the zone=0A=
> + *                  will transition to the closed zone state.=0A=
> + *                  The 512B sector must be zone aligned.=0A=
>   */=0A=
>  #define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)=0A=
>  #define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)=0A=
> @@ -166,5 +184,5 @@ struct blk_zone_range {=0A=
>  #define BLKOPENZONE	_IOW(0x12, 134, struct blk_zone_range)=0A=
>  #define BLKCLOSEZONE	_IOW(0x12, 135, struct blk_zone_range)=0A=
>  #define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)=0A=
> -=0A=
> +#define BLKSETDESCZONE	_IOW(0x12, 137, struct blk_zone_set_desc)=0A=
>  #endif /* _UAPI_BLKZONED_H */=0A=
> =0A=
=0A=
How to you retreive an extended descriptor that was set ? I do not see any =
code=0A=
doing that. Report zones is not changed, but I would leave that one as is a=
nd=0A=
implement a BLKGETDESCZONE ioctl & in-kernel API.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
