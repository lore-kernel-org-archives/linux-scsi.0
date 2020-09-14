Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F02C2D0E3
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 09:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14233207C3
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 09:04:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bEr8Oich";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pyi+hKo/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgINJE3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 05:04:29 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:12510 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgINJDw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 05:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600074232; x=1631610232;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=WQ3IDAQNzQe0opwu/28ZdkXaP+VEpNO4Fh81VybnYQY=;
  b=bEr8Oichfo7kjNTTObjvFpPc/lEDpF9FD2SFIj4tvsDCZ3hFYHSwGwA+
   EeQPk5MH7l7F88SKroKnKpHNTwtcRr9hxkjY58t7vQdIN9LqvATmU7g6I
   Wo+luse9QDIazZkGLfYOnfXgmDTtD21lA7ZgPqPLFImmbNXnwomd+FJ4N
   dBGRxtytuEJ1R5Tc1N3HrnowirU9UsR2K0QYsvKMEuoDf8Y+9MoOmrH0e
   dLpV1C3SuKtkp62soTjEiNAnTg/FUdgvHEKg2D66Lq0Odaj8oQ3kgMZce
   t8xdEe3ABYSVnQVeEAryDPAY6aCJ4k6l0zTOL6JmOVvVA34sj11x6kE5I
   g==;
IronPort-SDR: bSXgzRK1l3aNUViYE/DSFFHWE2mH600gSTXe4G2HWCY/StAva+kq1AYX9aAIP8p0UDyO4CfPWV
 J6dqMdGT6W/0OYYVIif1OYHniIL8IKCnWP0KSWra9mW+j1e/V9A/fwXdbgGih2KPTAmETkCxoe
 e7t48eQDNFy16h3wdvFzr74iLWscJaM4uCDGkjX8lNlpred1K6Oi3rryBKdzFT9KndtFMl70SR
 wqtBbikFzqg2II8613o9KLBPIqF/AzSMT/M0pIjq8EpC6WNmBZ++6YB8kZ7+ao7a5o8pasyMXB
 piY=
X-IronPort-AV: E=Sophos;i="5.76,425,1592841600"; 
   d="scan'208";a="148526747"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 14 Sep 2020 17:03:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTQR+mXjyj6SsPHLa6dS1XHqV9yMuaH25g4CsC9MYPjjmLnjeCot4DUUReqrF0b05z8P+LIozB9H2nWPbMIJyW0aCCuXmkyMUOpnjBhCTmgZizL7wrYiYrJnRdzal9SQF9dcghW38jbyJdVwQdnNmfmq+zz+PVUTX03lx5jBAcgo1HRfk2V3zd6TXmh0aaPQPJn5Mmbxp11w2G9qYItPPwrsjxGbP8IR5GPr5FVl9jr/w8bEd0bqc/ooA5AUHS5at2F+D/kBKY82CjNy76IrYbizYwxb7B3e4oVmDV5qScrTsy4H0qkVhqlQPORr0nnz9ta/VJeJ5o8hD0lEMn9Lvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGzjok4OuMGa6eeDsJzY63lVYeCZ9r7V6IRW5YOVSuo=;
 b=gMGPA2/SsJNkCQckWpqLoRfsADCMKMMo+whh/iL0PZSN9Xj9c1P9rWRBy0LBrKyD65DOrg/NuNSBuLsiR5eDTVUHN/Yw1NSKEJA5GY8d4YZyvjZcaIdAL7ruU33Q0AtdFI9A2/HKozSVztS6C1W8Aneu8xAFWPNIdGtQgByhGojHMEAn1Ns7MLX0w52ev614+BDku6+SXcs1TXSAa0ymEZe79x0CyKgQbp/b6RkCmkJNjU8d14S56SQyoA/2xO1b6+6Odj5iX00LG4EVD5zaUfEj5UB+/KNbGrgktRUTM+3cFEQ9r/Z894MF1/fnUZOA+82+K5YPCRlicgGCbsoxaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGzjok4OuMGa6eeDsJzY63lVYeCZ9r7V6IRW5YOVSuo=;
 b=pyi+hKo/EOxKtyKIKjnSSxac3qvxW0qSE1ZGEl8F3D6Uk6VqeeietW7Nbf0khnjq+e1e5ZZ0+cQpoo5TAEpj4so7ZwDMcykmmNNQ2jCSyTzKNTe9QdUxDcfnBnVFO/Lt4cB7J8uOMWVk2xK+KbHdGxZVt6iRtfVhPrwBK9F6suw=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1257.namprd04.prod.outlook.com (2603:10b6:910:53::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Mon, 14 Sep
 2020 09:03:49 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 09:03:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH v2 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Topic: [PATCH v2 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Index: AQHWii7iTImXf29o1UGELyu7sFgFmg==
Date:   Mon, 14 Sep 2020 09:03:49 +0000
Message-ID: <CY4PR04MB3751877C568C7F8B3E458960E7230@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200914003448.471624-1-damien.lemoal@wdc.com>
 <20200914003448.471624-2-damien.lemoal@wdc.com>
 <20200914072034.GA25808@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:f58c:fb44:b59e:e65e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b908fba-1ec4-4b1b-c3ae-08d8588d1837
x-ms-traffictypediagnostic: CY4PR04MB1257:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB1257C7D922961A392DB9B9BEE7230@CY4PR04MB1257.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6VoX0rvHLAGhb6I0cA2zxop7H3w2h3io1hWgxcxUQGHo1BR6zt912F3G2ioZMv14/Zz6+YDnIShLWfa4jRKll3CvSJGvypn3ifwInfg8rYN5DcMyHZUxmJVoxqAcB90BumKXOqa5eeIH70JvwgLyXTqtc3guGHoUZIqOhRjbfugV12VtLn/MqGgM1kfzLFXOgRgSZQ3OPRriSN9vBMEbev9t1ygGA9thFMx+rRx7j5xRmUAspf7kTOK45G6Wt6Wz/e4HLgpDbiMqptMlIhft4TZ6DzrSalEQUpxN5ERLT0rELvs5wJnnfbVT2g08ui7OF81od9SPFij1CPuy1ivQJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(83380400001)(54906003)(186003)(91956017)(76116006)(478600001)(53546011)(71200400001)(66446008)(7696005)(66476007)(2906002)(86362001)(64756008)(5660300002)(66556008)(6916009)(52536014)(8676002)(4326008)(316002)(66946007)(6506007)(55016002)(8936002)(9686003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uP1LrYPkYix34mrah6Wyrkk9RWYZB+0DggYRkFytwIQ+Gr5Gaf+T7EkhRXQhM+F5gvmEreOw/yW/vE+i2I5QXWn8Artw4XZ4OmXDp03o0e3EcpIOUwky/0Vg7ikZmfZqlTV0Ta4FyVIauziSQZhrLtw9EnNy1TntZ9TR4JV84VHBltih3/9fvNCkkDEpxB38poxF52pn0jJGqOxr90aF4HjyO9o+IooP7I274BwGO+opRUREqXzZfzWjO8XKrtilmxgRPlNk5qjoxIRNm4W7VS5nRcjhcXlcCGzfJ0uFmastvzBn4aMVmpTvUHBtPcqRjPT4Ur3LVTGd+JM6gx+lpsm9+/mjIo+jKGdfY/Q2mVKRW/P+vk1yEsg2VOIqWSsjwqtxdlH8XPh7P5Krh0pDSnyN3Gja2pIUer9kWUjNWYRZLCxZict7RkCfebcAP2HRyuiL8/LoetiE2id1k5e1u4DyMiZAPSixsZoJPCgrE0U8rXEdVFOiHx+wFkFztePo4hQTrf1zCpcQLkHKUqua5qcc9c0aTZOLPSOd+/0XsdnaNkYRNe4vjLwiwzNX7g6OFaKVXpqarhyw29+yDG0SottKYaoOH6BH3yTBvpDcwMqCHwWTPftJd+N+bHA79Hj447eIBiFEVvAScdjaABS/gOkx1WD43TfKKKcg60+Fb1IpRb1AD1xerEK8Xsv51IFU2qI6zD4F2cnrLm84Ub1YtQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b908fba-1ec4-4b1b-c3ae-08d8588d1837
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 09:03:49.2056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 70/Ne45DL3wkouJw2AqNc8mI4CHNV0WvraeVCG1xCNJkAaFh2+xgaHP88+WWFfIC+AV9r0xuoacUe85Fkh/XZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1257
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/14 16:20, Christoph Hellwig wrote:=0A=
> On Mon, Sep 14, 2020 at 09:34:47AM +0900, Damien Le Moal wrote:=0A=
>> When CONFIG_BLK_DEV_ZONED is disabled, allow using host-aware ZBC=0A=
>> disks as regular disks. In this case, ensure that command completion=0A=
>> is correctly executed by changing sd_zbc_complete() to return good_bytes=
=0A=
>> instead of 0, causing a hang during device probe (endless retries).=0A=
>>=0A=
>> When CONFIG_BLK_DEV_ZONED is enabled and a host-aware disk is detected=
=0A=
>> to have partitions, it will be used as a regular disk. In this case,=0A=
>> make sure to not do anything in sd_zbc_revalidate_zones() as that=0A=
>> triggers warnings.=0A=
>>=0A=
>> Reported-by: Borislav Petkov <bp@alien8.de>=0A=
>> Fixes: b72053072c0b ("block: allow partitions on host aware zone devices=
")=0A=
>> Cc: <stable@vger.kernel.org>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> Tested-by: Borislav Petkov <bp@suse.de>=0A=
>> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
>> ---=0A=
>>  drivers/scsi/sd.c     | 28 ++++++++++++++++++++++------=0A=
>>  drivers/scsi/sd.h     |  2 +-=0A=
>>  drivers/scsi/sd_zbc.c |  6 +++++-=0A=
>>  3 files changed, 28 insertions(+), 8 deletions(-)=0A=
>>=0A=
>>  	} else {=0A=
>>  		sdkp->zoned =3D (buffer[8] >> 4) & 3;=0A=
>>  		if (sdkp->zoned =3D=3D 1 && !disk_has_partitions(sdkp->disk)) {=0A=
>> +			/*=0A=
>> +			 * Host-aware disk without partition: use the disk as=0A=
>> +			 * such if support for zoned block devices is enabled.=0A=
>> +			 * Otherwise, use it as a regular disk.=0A=
>> +			 */=0A=
>> +			if (IS_ENABLED(CONFIG_BLK_DEV_ZONED))=0A=
>> +				q->limits.zoned =3D BLK_ZONED_HA;=0A=
>> +			else=0A=
>> +				q->limits.zoned =3D BLK_ZONED_NONE;=0A=
>>  		} else {=0A=
>>  			/*=0A=
>>  			 * Treat drive-managed devices and host-aware devices=0A=
>>  			 * with partitions as regular block devices.=0A=
>>  			 */=0A=
>>  			q->limits.zoned =3D BLK_ZONED_NONE;=0A=
>>  		}=0A=
> =0A=
> I think we need to lift much of this into a block layer helper,=0A=
> as the logic is way subtile.  Something like this (written in the MUA=0A=
> editor, not even compile tested).=0A=
> =0A=
> static inline void blk_queue_set_zoned(struct gendisk *disk,=0A=
> 		enum blk_zoned_model model)=0A=
> {=0A=
> 	switch (model) {=0A=
> 	case BLK_ZONED_HM:=0A=
> 		WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED));=0A=
> 		break;=0A=
> 	/*=0A=
> 	 * Host aware drivers are neither fish nor fowl.  We can either=0A=
> 	 * treat them like a drive managed devices, in which case they=0A=
> 	 * aren't different from a normal block device, or we can try=0A=
> 	 * to take advantage of the Zone command set, but in that case=0A=
> 	 * we need to treat them like a host managed device.  We try=0A=
> 	 * the latter if there are not partitions and zoned block device=0A=
> 	 * set support is enabled, else we do nothing special as far as=0A=
> 	 * the block layer is concerned.=0A=
> 	 */=0A=
> 	case BLK_ZONED_HA:=0A=
> 		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||=0A=
> 		    disk_has_partitions(disk)) {=0A=
> 			model =3D BLK_ZONED_NONE;=0A=
> 		break;=0A=
> 	default:=0A=
> 		break;=0A=
> =0A=
> 	disk->queue->limits.zoned =3D model;=0A=
> }=0A=
> =0A=
> Then in sd do:=0A=
> =0A=
> 	if (sdkp->device->type =3D=3D TYPE_ZBC) {=0A=
> 		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);=0A=
> 	} else {=0A=
> 		sdkp->zoned =3D (buffer[8] >> 4) & 3;=0A=
> 		if (sdkp->zoned =3D=3D 1)=0A=
> 			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HA);=0A=
> 		else=0A=
> 			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_NONE);=0A=
> 	}=0A=
> =0A=
=0A=
Yes, that's nice. Will send something along these lines. But since this is =
a bug=0A=
fix for the current cycle & stable, we probably should keep the patch as is=
 and=0A=
add the improvement on top for 5.10, no ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
