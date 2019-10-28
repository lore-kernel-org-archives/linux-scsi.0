Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F86ECA9EBD
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 07:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D79C8208C0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 07:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZKU7Zu0o";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pY9gb60n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbfJ1HvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 03:51:02 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:26380 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733036AbfJ1HvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 03:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572249060; x=1603785060;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=V1gmZOpBOLQRs6zq4BNOYoHszY+yMsRtC+5ijdE6cfw=;
  b=ZKU7Zu0oAdcZUmt0wm+rJlCG8jg0Qr3oX5YeICxMgtQpRNmp66jp9CSz
   OXpt4aL+vs5FZkPcVt+VfYWK8PpDdvvtz05m3QugJ/Axf7BTj8YlDLfzs
   anH4Irjb5Y4HwOqxulZ2E0NGOXTXeByDwvAIco5ctktc4QlxldkZagI47
   nU3x72C1wD+ZSjlWH0C6Y6yFd5xf5G4OFEeitPaCRk1+okl7I9MYV/AVr
   u2iONCdkiH8gTvqn58e3ni6EQAJogJtb937XBcXbC/TuBCVhLNQ+4Sx52
   pRgkKhhAlibCG8vTjweq/ixY14TQ4ZR0YT/I8RMf5mojj6GnKEob7kfy8
   w==;
IronPort-SDR: Uyu+79IypycjKlc6IAtjpWu3+drtS+4i63gWFqCejMcShpwqP6mqxlsVDsrnM7Cfih/TB8meov
 hA9uSBCU3wpqZEMj4RPCHl6PtPSRwJ+eT47WL/ngJylgAbzhoPHujVVh68+IB+OhBL40pfOr9G
 uNin7kzqqHex2IEMw1GW/UMf+k7DuMVvfgMM5RvMIxA4GpIA8vUwxWaUKxWfXAoZrT4ZaxXvlA
 L2yVZ1As+GGPOJIjTi3mAMh3T8+hNIjhtscA94btjY2yIz+xKMkRra/eOSkwsllBCFAPiwmFvo
 BJM=
X-IronPort-AV: E=Sophos;i="5.68,239,1569254400"; 
   d="scan'208";a="122235739"
Received: from mail-bl2nam02lp2059.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.59])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2019 15:50:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lx2h+QZTtX/2p0qjFrytV+bFGzAiIby0h11LgqTprndbeBBKzs2ha7aMRnhhTO73IZnYxp9Z1TGgB3V1+ekfwJSU8zEJpii+/0k51KvjShmpT+0TXjs751/xIAGi3HVQTi1cESkHlQy0LnJ8ptJ+LmUj5C7tAQj1e6N+90tqrxR7fg+JO/EwalHG6IA6aUphuHB4snlItxEMJyE2WpFtFYllCbjKp0PajcSyJgvKhwNLqgkJuwCfhb6vI+zdwkYs6QDkcv3vMgecTod9S4hkDJ2HCdNDW5V6W6misYYIWkew1Bw04Ha1EAuvMN1NrDY1/6Hc/M8DzIWaCS36IMsvLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyOazGmS8LWzRIbeMtRAhAC92GgtCyYX4+1ooPMOSI8=;
 b=QkLQ6ldlbPXZCUfkefGu5bcIqI4umqhdgUodXXJZ0XqPYt31F+ezGSmJi8Y2juyQ2/+h4QmIBUERZQKNextgh/ZQ6WE3TeX3xIAdXDaF7WPyOk1eLcB8SK+m6gcZdB7nLHg2tvmnR562DY/vnL7eYD8MbU/5/gSJAoF9Bj9eg8KS3JzdKH7y/o0cx53m5Cq/KqHcXuA9R81Dqv1r5xfpKYrnu4qT1cR1USaCuc7viCm8rVHCYmtB2Ch6ce6vyG7v5mQ5BnefqEN02f90DTLETKlKVBrXT8Wsnp8n9AuWxSVdCLfG9TAwJCqzM75+QKnuP5+QKJg1aIPbQtavgTCVLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyOazGmS8LWzRIbeMtRAhAC92GgtCyYX4+1ooPMOSI8=;
 b=pY9gb60nOorbF1er0R2csCUAH6vXeZC7js52yiH35gKARmbYveJiY8fWwfPmzu4P5M47M178XS8ubSPrid7grPSaiMScDhkQgHjRU6twNswCaQE3el5PpOtzlwX1loWR1kF/zR28qR8T2r+j3FzCObraorvvngNDpq46mEE3K1o=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB4728.namprd04.prod.outlook.com (52.135.239.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Mon, 28 Oct 2019 07:50:58 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::34a1:afd2:e5c1:77c7]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::34a1:afd2:e5c1:77c7%6]) with mapi id 15.20.2387.023; Mon, 28 Oct 2019
 07:50:58 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
CC:     Ajay Joshi <Ajay.Joshi@wdc.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 1/8] block: Remove REQ_OP_ZONE_RESET plugging
Thread-Topic: [PATCH 1/8] block: Remove REQ_OP_ZONE_RESET plugging
Thread-Index: AQHVjM+qK1sykgq+9kCK6kQl06F7sA==
Date:   Mon, 28 Oct 2019 07:50:57 +0000
Message-ID: <BYAPR04MB57491FE7167788107DD1BE0086660@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-2-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.44.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 36011605-2eb5-41a7-6b20-08d75b7b91c5
x-ms-traffictypediagnostic: BYAPR04MB4728:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4728070D41301BFB059E95D286660@BYAPR04MB4728.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(199004)(189003)(71190400001)(71200400001)(99286004)(186003)(7696005)(53546011)(2906002)(74316002)(256004)(476003)(5660300002)(86362001)(6506007)(486006)(8936002)(66066001)(76176011)(8676002)(52536014)(81166006)(76116006)(81156014)(102836004)(9686003)(4326008)(66946007)(446003)(6436002)(6246003)(2501003)(66556008)(66476007)(55016002)(26005)(64756008)(316002)(54906003)(229853002)(110136005)(305945005)(7736002)(14454004)(25786009)(66446008)(3846002)(6116002)(478600001)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4728;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CZuxqfKzL2er1LBeF4X8JS04riAnSQejaRMbTykJBXp43pNAUG0Y8GrFIGeYNaz0jFQ8TbTSGWkjw4xdA5vSUYWN9h/2idOkuHkmX1V0+Y5aDFrLbl9Uknt46fsZ/cJXQop5PDrr616vRJwf3BLI4Tt1CN3rvRSbeTS7s0ANW368Ooqx59XdPLvazmnM8KsNNAt8Ay2CEEcu+8JEUoFF9p6UYnd89xQwx47XU4dF0jJPksw/Rs59ZrKih5VyLoUKW7GvDkERfT0mttj7jX0xVj3jUKrOG3J4Q6nV6Sh4+wISVjG2XTR8Ye4vXuXOmDhywgg72skmT9cG7buXxWoBP7KAjt1RmWItGYdzoBJfwd1GTrbUAS/9Pi6EODCjirvbxW8mKYRH56qXRU4amLf/ofyH5o9gyvgA6CpLnwZrUfPCF1vXx9I2p8K84Fam9j9h
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36011605-2eb5-41a7-6b20-08d75b7b91c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 07:50:57.9044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZTOJosqz9xZavaA3hBCDRM4UInqX8BeYnHg4TkPW26vF/d4VstQnQu2nn0Oa3xH7cfjnQpl3QY9LqaLH+vNsZOYGaB4plDu3lHWTHvYOtoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4728
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
On 10/27/19 7:06 AM, Damien Le Moal wrote:=0A=
> REQ_OP_ZONE_RESET operations cannot be merged as these bios and requests=
=0A=
> do not have a size and are never sequential due to the zone start sector=
=0A=
> position required for their execution. As a result, there is no point in=
=0A=
> using a plug around blkdev_reset_zones() bio issuing loop. This patch=0A=
> removes this unnecessary plugging.=0A=
> =0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> ---=0A=
>   block/blk-zoned.c | 4 ----=0A=
>   1 file changed, 4 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
> index 4bc5f260248a..7fe376eede86 100644=0A=
> --- a/block/blk-zoned.c=0A=
> +++ b/block/blk-zoned.c=0A=
> @@ -258,7 +258,6 @@ int blkdev_reset_zones(struct block_device *bdev,=0A=
>   	sector_t zone_sectors;=0A=
>   	sector_t end_sector =3D sector + nr_sectors;=0A=
>   	struct bio *bio =3D NULL;=0A=
> -	struct blk_plug plug;=0A=
>   	int ret;=0A=
>   =0A=
>   	if (!blk_queue_is_zoned(q))=0A=
> @@ -283,7 +282,6 @@ int blkdev_reset_zones(struct block_device *bdev,=0A=
>   	    end_sector !=3D bdev->bd_part->nr_sects)=0A=
>   		return -EINVAL;=0A=
>   =0A=
> -	blk_start_plug(&plug);=0A=
>   	while (sector < end_sector) {=0A=
>   =0A=
>   		bio =3D blk_next_bio(bio, 0, gfp_mask);=0A=
> @@ -301,8 +299,6 @@ int blkdev_reset_zones(struct block_device *bdev,=0A=
>   	ret =3D submit_bio_wait(bio);=0A=
>   	bio_put(bio);=0A=
>   =0A=
> -	blk_finish_plug(&plug);=0A=
> -=0A=
>   	return ret;=0A=
>   }=0A=
>   EXPORT_SYMBOL_GPL(blkdev_reset_zones);=0A=
> =0A=
=0A=
