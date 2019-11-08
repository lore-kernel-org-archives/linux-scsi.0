Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9397C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 07:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E47F20869
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 07:28:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nmwKgN4e";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="PLesGg+G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKHH2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:28:19 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30497 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfKHH2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 02:28:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573198098; x=1604734098;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=AlWzrJvZTn61uYjf2p05KR9Javiuy/gUyexLq4pxunA=;
  b=nmwKgN4ea8sqv06mZXOwF90DgF/z6VvLdY1PKCWSjViMrueexY5JdBlh
   /ZFYd1DEBcxpPvjFOwCZE1B6/VkL6A3WjgK/E2Hw3cjB2ygVeNkvfbLQT
   lkI4ZCx+TQKu6j5nM7Q8DtSMV8f5JW7QMF4PsWe5MC5mhvSANodHz5NH7
   dZzTHLqa9KBlMTiY58cY4kYFjeD/9koLvUxOZLOW/R6O31hvcQna3/gyF
   lUZjCCeUPcXCw38U/vosuY1AcehkyhJSgXoG0/ekuFPcybucLamayv/aJ
   y4ggQMaH+1AVDPH3fpQQx2ZBhruoNut0vHz7VEni7bsWJpRNBpffh2pi9
   Q==;
IronPort-SDR: Lk5I/pExm5TYSdyPitSOXqHTvkLvI/OMrCA2Zd39EWIRb6JtCznKCkLRLF3I7gs+Y4UgsYsa04
 8EjsqIqD7jwTEk69FHaLIqNA5ZvOUz1ZGU+pCOHuSFgpuMzqsgItEo3RqNyCSs7DMW4X4PVQYx
 4eRgyxsbbNMnk+KR9DV5N2hWyLtbuqbe8p6sVByRDF0IVSyi3NY8Sxgyf2UZXCFYFpX9pnTZ6Z
 WwwHeEArhcbdTyxC6NWTRU2Os6Bx0/RVHpHyo9/TJKS9IaUeceZbq+cBnWEHhBVlxx+Ihsebl+
 kz8=
X-IronPort-AV: E=Sophos;i="5.68,280,1569254400"; 
   d="scan'208";a="124065165"
Received: from mail-dm3nam03lp2055.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.55])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 15:28:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abR7v2BcJFpTRsbU81mPHz5tns7TxSxTiHnLT0gBMEqHRzd/RRB0kojyibNwXnTtN2Z7xyTB/b5rD3cl6HEtp1ay0+3VDViR44fPjJIKRPKJRndKsMRoxymdv8OlvbSYEeXJre8chyyg1xH/9oJxY268qjNrwRgJlooy8ARKx2tflYb2tkzzCfw3CnYEqDxqzAjXk4ykQAxRRzmZzttLuQJ4OyKMeVsn0NNYwTPjWn7E4Kp+iwEbCdlEnF0UqPCk2HBXbDGJiUprzN8ihxtkEXQ21wbEK/FYi43FVHCZGNUDqHVfUupN1s3tHEA4X3c5889332MAT4sBMiBr6NjlqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ss2V/ER9g5yWzQ3tVvAFSh5TWnyddYtuHm3g9hxM/DY=;
 b=lVwV2/rPLddhTzlqezOVUKNURPmxVGOe6KR4nZsDT77kuqsHOk7qkiGX1YoVPnfR6j/zTbtdRTgXp+0ZYnk+2BQzWmXku4pE4kmQP/gcHyWtnSLYkRCuKQnbzmem4+/LDZoGVnCtuatMHTJrN2MRZ5E8X/54eOsXDnowxOmPzgipNtXwiUHM2VCRQ4pFN8RFiOFJQdxUajvvGe8nGpLGtWYvIjGryKaPu4hzgZFwQPZ1aYdSb2RBsKncPLdAZn+pVeFG0QtEI0Ew6zzvE/ftTdLxrdhJhNuCsVLDSEldCYjFCyuGlw+xnq+otbCTU5J0JU1oUYelGNs8L0UTMBShdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ss2V/ER9g5yWzQ3tVvAFSh5TWnyddYtuHm3g9hxM/DY=;
 b=PLesGg+GUzwRAPgVPSoNvJHRMxmEttMkPYuskJZY8DNlD6Tod3xkpc/J8yNzeLzzJ0ifSTe6qJWlLF7OJSiMk3hU07Tg35gCtJuQYwOf7hfTY2pwFSmdPZD6ooDCQ8wd/zGxJ1FEZauxCt1YD98XCjM97Qns8lJFIJx+NPGFDkA=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5206.namprd04.prod.outlook.com (20.178.51.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 07:28:15 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 07:28:15 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 4/9] block: Remove partition support for zoned block
 devices
Thread-Topic: [PATCH 4/9] block: Remove partition support for zoned block
 devices
Thread-Index: AQHVldfeu12TZig53UG+k8UT5XvAMg==
Date:   Fri, 8 Nov 2019 07:28:15 +0000
Message-ID: <BYAPR04MB58161069E47E24E188FC91EEE77B0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-5-damien.lemoal@wdc.com>
 <160bfb8f-2793-af74-df2b-5f30ae9383db@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e99cd6f5-594e-440a-aa7a-08d7641d384b
x-ms-traffictypediagnostic: BYAPR04MB5206:
x-microsoft-antispam-prvs: <BYAPR04MB5206934BE7B4CC3B14741168E77B0@BYAPR04MB5206.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(199004)(189003)(478600001)(33656002)(66066001)(2501003)(316002)(25786009)(110136005)(52536014)(3846002)(6116002)(5660300002)(99286004)(14454004)(14444005)(256004)(102836004)(66556008)(64756008)(66446008)(2906002)(81166006)(486006)(91956017)(76116006)(71200400001)(71190400001)(66946007)(8676002)(66476007)(8936002)(9686003)(7416002)(55016002)(74316002)(446003)(305945005)(476003)(7736002)(229853002)(186003)(6246003)(6506007)(53546011)(26005)(6436002)(86362001)(76176011)(7696005)(81156014)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5206;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: przTLT6j71kTy6kg6TYhYq7/cVr+hH4MWhqTdsCbcUnADj6hyYr76PAbX7dy9t7ZSFfwPzpj0g6L4mHy3QyEJWW0e+CSUQ3fTSwn31SLnH4iK0XnjNU6n54eapNmypX+YGT8lQA6YoeT40l2bbRxuChFYk0XAcHcPOeQfrW6zLhoKStroHoOZ0pvbR5isondF026kb9FZ+T0SDC/EBxpxBZX+qypYSMVavk6I4OnwMw7dDbWLw+EiWnzVrgld/q2k32PAcgSQ8zTvPUT/0/LwbM+D4ZL31XrPDeZ3+9OHtFv0/aU+EJqIiEzIok6uTccsW8qAly8zwmE3OcVAssicJ918ySoLDgPMYiI85obPS9453zyJ/RM1otHs6a4X3xfQvYZBY+AS7rok2GHDBD5CcPmsyW/CUSj6ZwuJ+sM3oJMu2NwMybkHTFm7/98jV9j
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e99cd6f5-594e-440a-aa7a-08d7641d384b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 07:28:15.6057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DFudmtEauViss3XiZE/rfHREgGgagVqhL4ZRQPo8fVwNDNyRh2dC2jnbR9m0eL8fskDMK9sj6oU+eSCSdQJn2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5206
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/08 16:17, Hannes Reinecke wrote:=0A=
> On 11/8/19 2:56 AM, Damien Le Moal wrote:=0A=
>> No known partitioning tool supports zoned block devices, especially the=
=0A=
>> host managed flavor with strong sequential write constraints.=0A=
>> Furthermore, there are also no known user nor use cases for partitioned=
=0A=
>> zoned block devices.=0A=
>>=0A=
>> This patch removes partition device creation for zoned block devices,=0A=
>> which allows simplifying the processing of zone commands for zoned=0A=
>> block devices. A warning is added if a partition table is found on the=
=0A=
>> device.=0A=
>>=0A=
>> For report zones operations no zone sector information remapping is=0A=
>> necessary anymore, simplifying the code. Of note is that remapping of=0A=
>> zone reports for DM targets is still necessary as done by=0A=
>> dm_remap_zone_report().=0A=
>>=0A=
>> Similarly, remaping of a zone reset bio is not necessary anymore.=0A=
>> Testing for the applicability of the zone reset all request also becomes=
=0A=
>> simpler and only needs to check that the number of sectors of the=0A=
>> requested zone range is equal to the disk capacity.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>  block/blk-core.c          |  6 +---=0A=
>>  block/blk-zoned.c         | 62 ++++++--------------------------=0A=
>>  block/partition-generic.c | 74 +++++----------------------------------=
=0A=
>>  drivers/md/dm.c           |  3 --=0A=
>>  4 files changed, 21 insertions(+), 124 deletions(-)=0A=
>>=0A=
>> diff --git a/block/blk-core.c b/block/blk-core.c=0A=
>> index 3306a3c5bed6..df6b70476187 100644=0A=
>> --- a/block/blk-core.c=0A=
>> +++ b/block/blk-core.c=0A=
>> @@ -851,11 +851,7 @@ static inline int blk_partition_remap(struct bio *b=
io)=0A=
>>  	if (unlikely(bio_check_ro(bio, p)))=0A=
>>  		goto out;=0A=
>>  =0A=
>> -	/*=0A=
>> -	 * Zone management bios do not have a sector count but they do have=0A=
>> -	 * a start sector filled out and need to be remapped.=0A=
>> -	 */=0A=
>> -	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio))) {=0A=
>> +	if (bio_sectors(bio)) {=0A=
>>  		if (bio_check_eod(bio, part_nr_sects_read(p)))=0A=
>>  			goto out;=0A=
>>  		bio->bi_iter.bi_sector +=3D p->start_sect;=0A=
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
>> index ea4e086ba00e..ae665e490858 100644=0A=
>> --- a/block/blk-zoned.c=0A=
>> +++ b/block/blk-zoned.c=0A=
>> @@ -93,32 +93,10 @@ unsigned int blkdev_nr_zones(struct block_device *bd=
ev)=0A=
>>  	if (!blk_queue_is_zoned(q))=0A=
>>  		return 0;=0A=
>>  =0A=
>> -	return __blkdev_nr_zones(q, bdev->bd_part->nr_sects);=0A=
>> +	return __blkdev_nr_zones(q, get_capacity(bdev->bd_disk));=0A=
>>  }=0A=
>>  EXPORT_SYMBOL_GPL(blkdev_nr_zones);=0A=
>>  =0A=
>> -/*=0A=
>> - * Check that a zone report belongs to this partition, and if yes, fix =
its start=0A=
>> - * sector and write pointer and return true. Return false otherwise.=0A=
>> - */=0A=
>> -static bool blkdev_report_zone(struct block_device *bdev, struct blk_zo=
ne *rep)=0A=
>> -{=0A=
>> -	sector_t offset =3D get_start_sect(bdev);=0A=
>> -=0A=
>> -	if (rep->start < offset)=0A=
>> -		return false;=0A=
>> -=0A=
>> -	rep->start -=3D offset;=0A=
>> -	if (rep->start + rep->len > bdev->bd_part->nr_sects)=0A=
>> -		return false;=0A=
>> -=0A=
>> -	if (rep->type =3D=3D BLK_ZONE_TYPE_CONVENTIONAL)=0A=
>> -		rep->wp =3D rep->start + rep->len;=0A=
>> -	else=0A=
>> -		rep->wp -=3D offset;=0A=
>> -	return true;=0A=
>> -}=0A=
>> -=0A=
>>  /**=0A=
>>   * blkdev_report_zones - Get zones information=0A=
>>   * @bdev:	Target block device=0A=
>> @@ -140,8 +118,7 @@ int blkdev_report_zones(struct block_device *bdev, s=
ector_t sector,=0A=
>>  {=0A=
>>  	struct request_queue *q =3D bdev_get_queue(bdev);=0A=
>>  	struct gendisk *disk =3D bdev->bd_disk;=0A=
>> -	unsigned int i, nrz;=0A=
>> -	int ret;=0A=
>> +	sector_t capacity =3D get_capacity(disk);=0A=
>>  =0A=
>>  	if (!blk_queue_is_zoned(q))=0A=
>>  		return -EOPNOTSUPP;=0A=
>> @@ -154,27 +131,14 @@ int blkdev_report_zones(struct block_device *bdev,=
 sector_t sector,=0A=
>>  	if (WARN_ON_ONCE(!disk->fops->report_zones))=0A=
>>  		return -EOPNOTSUPP;=0A=
>>  =0A=
>> -	if (!*nr_zones || sector >=3D bdev->bd_part->nr_sects) {=0A=
>> +	if (!*nr_zones || sector >=3D capacity) {=0A=
>>  		*nr_zones =3D 0;=0A=
>>  		return 0;=0A=
>>  	}=0A=
>>  =0A=
>> -	nrz =3D min(*nr_zones,=0A=
>> -		  __blkdev_nr_zones(q, bdev->bd_part->nr_sects - sector));=0A=
>> -	ret =3D disk->fops->report_zones(disk, get_start_sect(bdev) + sector,=
=0A=
>> -				       zones, &nrz);=0A=
>> -	if (ret)=0A=
>> -		return ret;=0A=
>> +	*nr_zones =3D min(*nr_zones, __blkdev_nr_zones(q, capacity - sector));=
=0A=
>>  =0A=
>> -	for (i =3D 0; i < nrz; i++) {=0A=
>> -		if (!blkdev_report_zone(bdev, zones))=0A=
>> -			break;=0A=
>> -		zones++;=0A=
>> -	}=0A=
>> -=0A=
>> -	*nr_zones =3D i;=0A=
>> -=0A=
>> -	return 0;=0A=
>> +	return disk->fops->report_zones(disk, sector, zones, nr_zones);=0A=
>>  }=0A=
>>  EXPORT_SYMBOL_GPL(blkdev_report_zones);=0A=
>>  =0A=
>> @@ -185,15 +149,11 @@ static inline bool blkdev_allow_reset_all_zones(st=
ruct block_device *bdev,=0A=
>>  	if (!blk_queue_zone_resetall(bdev_get_queue(bdev)))=0A=
>>  		return false;=0A=
>>  =0A=
>> -	if (sector || nr_sectors !=3D part_nr_sects_read(bdev->bd_part))=0A=
>> -		return false;=0A=
>>  	/*=0A=
>> -	 * REQ_OP_ZONE_RESET_ALL can be executed only if the block device is=
=0A=
>> -	 * the entire disk, that is, if the blocks device start offset is 0 an=
d=0A=
>> -	 * its capacity is the same as the entire disk.=0A=
>> +	 * REQ_OP_ZONE_RESET_ALL can be executed only if the number of sectors=
=0A=
>> +	 * of the applicable zone range is the entire disk.=0A=
>>  	 */=0A=
>> -	return get_start_sect(bdev) =3D=3D 0 &&=0A=
>> -	       part_nr_sects_read(bdev->bd_part) =3D=3D get_capacity(bdev->bd_=
disk);=0A=
>> +	return !sector && nr_sectors =3D=3D get_capacity(bdev->bd_disk);=0A=
>>  }=0A=
>>  =0A=
>>  /**=0A=
>> @@ -218,6 +178,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum=
 req_opf op,=0A=
>>  {=0A=
>>  	struct request_queue *q =3D bdev_get_queue(bdev);=0A=
>>  	sector_t zone_sectors =3D blk_queue_zone_sectors(q);=0A=
>> +	sector_t capacity =3D get_capacity(bdev->bd_disk);=0A=
>>  	sector_t end_sector =3D sector + nr_sectors;=0A=
>>  	struct bio *bio =3D NULL;=0A=
>>  	int ret;=0A=
>> @@ -231,7 +192,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum=
 req_opf op,=0A=
>>  	if (!op_is_zone_mgmt(op))=0A=
>>  		return -EOPNOTSUPP;=0A=
>>  =0A=
>> -	if (!nr_sectors || end_sector > bdev->bd_part->nr_sects)=0A=
>> +	if (!nr_sectors || end_sector > capacity)=0A=
>>  		/* Out of range */=0A=
>>  		return -EINVAL;=0A=
>>  =0A=
>> @@ -239,8 +200,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum=
 req_opf op,=0A=
>>  	if (sector & (zone_sectors - 1))=0A=
>>  		return -EINVAL;=0A=
>>  =0A=
>> -	if ((nr_sectors & (zone_sectors - 1)) &&=0A=
>> -	    end_sector !=3D bdev->bd_part->nr_sects)=0A=
>> +	if ((nr_sectors & (zone_sectors - 1)) && end_sector !=3D capacity)=0A=
>>  		return -EINVAL;=0A=
>>  =0A=
>>  	while (sector < end_sector) {=0A=
>> diff --git a/block/partition-generic.c b/block/partition-generic.c=0A=
>> index aee643ce13d1..31bff3fb28af 100644=0A=
>> --- a/block/partition-generic.c=0A=
>> +++ b/block/partition-generic.c=0A=
>> @@ -459,56 +459,6 @@ static int drop_partitions(struct gendisk *disk, st=
ruct block_device *bdev)=0A=
>>  	return 0;=0A=
>>  }=0A=
>>  =0A=
>> -static bool part_zone_aligned(struct gendisk *disk,=0A=
>> -			      struct block_device *bdev,=0A=
>> -			      sector_t from, sector_t size)=0A=
>> -{=0A=
>> -	unsigned int zone_sectors =3D bdev_zone_sectors(bdev);=0A=
>> -=0A=
>> -	/*=0A=
>> -	 * If this function is called, then the disk is a zoned block device=
=0A=
>> -	 * (host-aware or host-managed). This can be detected even if the=0A=
>> -	 * zoned block device support is disabled (CONFIG_BLK_DEV_ZONED not=0A=
>> -	 * set). In this case, however, only host-aware devices will be seen=
=0A=
>> -	 * as a block device is not created for host-managed devices. Without=
=0A=
>> -	 * zoned block device support, host-aware drives can still be used as=
=0A=
>> -	 * regular block devices (no zone operation) and their zone size will=
=0A=
>> -	 * be reported as 0. Allow this case.=0A=
>> -	 */=0A=
>> -	if (!zone_sectors)=0A=
>> -		return true;=0A=
>> -=0A=
>> -	/*=0A=
>> -	 * Check partition start and size alignement. If the drive has a=0A=
>> -	 * smaller last runt zone, ignore it and allow the partition to=0A=
>> -	 * use it. Check the zone size too: it should be a power of 2 number=
=0A=
>> -	 * of sectors.=0A=
>> -	 */=0A=
>> -	if (WARN_ON_ONCE(!is_power_of_2(zone_sectors))) {=0A=
>> -		u32 rem;=0A=
>> -=0A=
>> -		div_u64_rem(from, zone_sectors, &rem);=0A=
>> -		if (rem)=0A=
>> -			return false;=0A=
>> -		if ((from + size) < get_capacity(disk)) {=0A=
>> -			div_u64_rem(size, zone_sectors, &rem);=0A=
>> -			if (rem)=0A=
>> -				return false;=0A=
>> -		}=0A=
>> -=0A=
>> -	} else {=0A=
>> -=0A=
>> -		if (from & (zone_sectors - 1))=0A=
>> -			return false;=0A=
>> -		if ((from + size) < get_capacity(disk) &&=0A=
>> -		    (size & (zone_sectors - 1)))=0A=
>> -			return false;=0A=
>> -=0A=
>> -	}=0A=
>> -=0A=
>> -	return true;=0A=
>> -}=0A=
>> -=0A=
>>  int rescan_partitions(struct gendisk *disk, struct block_device *bdev)=
=0A=
>>  {=0A=
>>  	struct parsed_partitions *state =3D NULL;=0A=
>> @@ -544,6 +494,14 @@ int rescan_partitions(struct gendisk *disk, struct =
block_device *bdev)=0A=
>>  		}=0A=
>>  		return -EIO;=0A=
>>  	}=0A=
>> +=0A=
>> +	/* Partitions are not supported on zoned block devices */=0A=
>> +	if (bdev_is_zoned(bdev)) {=0A=
>> +		pr_warn("%s: ignoring partition table on zoned block device\n",=0A=
>> +			disk->disk_name);=0A=
>> +		goto out;=0A=
>> +	}=0A=
>> +=0A=
>>  	/*=0A=
>>  	 * If any partition code tried to read beyond EOD, try=0A=
>>  	 * unlocking native capacity even if partition table is=0A=
> =0A=
> While I do applaud removing special cases for zoned devices, we do have=
=0A=
> the GENHD_FL_NO_PART_SCAN for precisely this use case.=0A=
> Any particular reason why this isn't being used, nor even set?=0A=
=0A=
If we set the flag, indeed partitions will be ignored, which is exactly=0A=
what we want. But that also means that there will be no warning message=0A=
whatsoever in the very unlikely case of a user using an SMR disk with=0A=
partitions. I fully agree with you that we should set this flag, but I=0A=
decided against it initially to have the "partition table ignored"=0A=
warning printed for now.=0A=
=0A=
If, as I expect, there are no screams coming from the field/users, we=0A=
can then safely add the flag and remove some more code (the test and=0A=
pr_warn call in rescan_partitions()).=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
