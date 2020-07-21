Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1EAC433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDEF22080D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Z70oUX50";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="g3fL7QKK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgGULXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:23:43 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:63680 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgGULXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:23:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595330636; x=1626866636;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=l9N405qexbxoOubHraUX0bkN4p8Fwk4cM/FK1uCOgz0=;
  b=Z70oUX50v7+KI3pjkoL2AiFQR+kpoNqcnryg5uKMLQ+4NJMlWwYmLdvF
   zF+rOsap/1DLn8QCBaEpsweivqGpqspLRgt1maGPUYGCbUbAeRyI0+RGY
   baHQ7+Gn23zhBn0f4k0q541CS2aa8uKOK7y9hGitSpg1rGq3rAhMtX+hs
   BGTqkWKxJrFuQdMldSmoxSahLA4OPLm/u/PxYZZd7KN3h/MfYDOm83Dzy
   JMcT30u2KQem9t+rkMDgXJVjVMu/QbKJBb0K9mBFDPVsoML5YMNzM/Bh5
   BMQRiDW/F8GGPLSEJde6uhRffMKegLSAM10OCE1m84M9QcHbvVpHN32oN
   g==;
IronPort-SDR: r1jiRFvI4v8ncL2fNNf9+r+/914OEaJdlyaYjwHzpm8lQPPYupl9UjJcuU8++y3wRnR8OadyMf
 G8lEiz2hQVcvAmCiYpl5tKH8VbKMx3Cnpk/Mjg+xgOrYvxvyN0WORo5BMLePVLkyF+FaOlt9yu
 xXEivl9IIl7LqkgPl/LgF4/bB1eydBqwKgO14bFsWLv6XqqUCZ18UQJAbLfZ4XDcTLH+yYY/aR
 g4wdsQPSPqVfJ/VjXd2lWHGlCqbCbbYmU5n/3P9+SS6fXJTRJsbtNkA02pV+COzYNI3V2907f3
 KNs=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="246050723"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:23:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvZ1pe+FJnk2UTd+W7T7scJB5TTTnX42WkC1xl6c8vW++iSF9xtEt7ykKSxdLY1vDiZJUYheGK6B0sd/g9EBfw7wQ1n9EGBjGtDruqjbbw2En6mfx0/44jpYsx0PtDQMmZVN/EooGkkXeo9EwUSK0M6AvSpwwKM1Lbv24ryu7h1dAAnq1AzHZNm9wXG1yTgFb5CASzZqeE1Q0n9CmJs0H7jf8VQsc2dPmKHqxbG+HnWxod9iUTdCtrfTSKHZnuz1HTAmskWhqcQ/SNdEaUPdrogNtQPH002m0NERWWt1nM6+mShrQUqb5MKTa1rPhrlpMkN5UaTGvSVE40TDHK7Yqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1tCtlFUYw4hsZhiu57rXD3aGZBnnXMRLbflAwDRcTU=;
 b=Z8cbawGzTBFVxvjCjgy/HiYBDYSeoj2uWfYb3xo9BUtM2IOf/j3+/6VC7/JRa/SZnT0dEVZjMeabBgNeY1wdQ1rBfoXQCL0u2ANM27ZBHxVQRePTsvY+dfqUa0JsP8b2l5aHr6td4qGFmtkCtAYJeo5PRTxwOZfVx2V5OrBpE/VZCohtXYVAC8Ew7QDHJiE1b85DVvjuFlV4DGHg0FzP0WkWoOwxlqQmWFWes30qCTBIdbZE9VMSx+HRjlNon8OPtdg3jhrcltCpJIZzI1vnMzKWn2W3AZWDiCZzZWEOTKv+ayzBnaMNK5ZfpzJ0bSPaA/uOdA60YalF6os/prvz5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1tCtlFUYw4hsZhiu57rXD3aGZBnnXMRLbflAwDRcTU=;
 b=g3fL7QKKNm41SRmv58u5bKzshoVseXkBE2q9lzQfFBMzWAfJdwmV3xftKUfhOHsUGJIaYNCbWdA6rU9WGc1pw9zqSs7wExbS0Mj1VTf6Ap1eiilxrU6FlaXhtktUdCxrezOBS+cqiCmKOxuycY4XhTc5dcjmB0dQUzA+LJqfg8g=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0969.namprd04.prod.outlook.com (2603:10b6:910:55::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 11:23:36 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:23:36 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        "open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        "open list:SCSI CDROM DRIVER" <linux-scsi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <Ajay.Joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "open list:SONY MEMORYSTICK SUBSYSTEM" <linux-mmc@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        "open list:NETWORK BLOCK DEVICE (NBD)" <nbd@other.debian.org>,
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 08/10] block: nvme: use blk_is_valid_logical_block_size
Thread-Topic: [PATCH 08/10] block: nvme: use blk_is_valid_logical_block_size
Thread-Index: AQHWX01xAJ2+5YNXfk6KyPexD076zw==
Date:   Tue, 21 Jul 2020 11:23:36 +0000
Message-ID: <CY4PR04MB3751AA85412F2B654286ED2BE7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-9-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c28b4c65-ddca-4c41-61de-08d82d6882bb
x-ms-traffictypediagnostic: CY4PR04MB0969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0969F3495F3C430B1E1D9354E7780@CY4PR04MB0969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jkRlUsQ9FYKNVJ2sgtpTCPvtSF6Gba9keO1Gg03AogMXbWEaIjPl5zpYe8z9EgX3pmfBtY5vBa6etVSCj6U4tPazBwaldmwsXyni6W/23Ol3vmx2dVyLjSN0NYVhA2kMgT5y9BASaAw2Ko/vV2uUjIaGu05U3ElUtI9ox54hivhdMwTQO0prr0Rh5DRHGXqohLhpjRy+GUHHl2JWa43I8Rv29kO8R2OILhNZeyCZP24FBE4metlAJLSL0ICmNEWAqLucoqMtx9RGMo9yNTldZSvMvwZkdUNDj2EilTa6RhKt54A5OHPRecXQ15nFdp9TOR4MNSaiEMA+cIMxGHZoyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(54906003)(316002)(110136005)(66476007)(9686003)(4326008)(186003)(26005)(71200400001)(76116006)(91956017)(66446008)(64756008)(66556008)(66946007)(52536014)(2906002)(6506007)(8676002)(55016002)(83380400001)(33656002)(5660300002)(478600001)(86362001)(7416002)(53546011)(8936002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JvHE6+m/tUaTgnvF1WX8C6XjepksVEESXKg+hj47x5YSPPB4G/H0aPgKPmw+y0XiD8B+YOmP+AycB26cdgI8C11QVe4VlEaY1cGsaAVR08aRMxcdLkbz9N2BNLJkt4nvsv0x9Yey/sjhwP+BCUAQ5PB9l9rEtoCl/UNpIa7QBj7NhQB974HflEAoiYL1DHE4D9ti3pCgo0fj20kfUbhTiSogVNNgICrP0L5liGOkyUxHGWaff0yBby50T/BkdcTOzWLIXgV4/8L7jfK24XAbEnqbTXZXJl+L2oqR77Pn+2wsGeMrElt4k0vtSuFufipoZRPBrY4+eL4X7Bu2B1evChxmLIEU1eh46KGxQm++e7SIqbxtrDT2cdStBG03U8xBGj7zMPHQ6qei0WswSV6M0mnCBMryWfJYiTFjX1woUBcRFN5JAqStqF0+s/rnr0b9NzP95FTBfYiM1KOSArZ7OrDb4YlZ5tKFMFenoYbnpTn8hIo2GCQFqdw2OVkf8ymR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c28b4c65-ddca-4c41-61de-08d82d6882bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:23:36.3663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yfUCSIV2mVJUHubWpksR25vNVn6FMZd094hSyp1msgNmVLemSzERq2Aa/zvCMg74/f5Gt9VK0EIAsvIJgtISNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0969
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 19:55, Maxim Levitsky wrote:=0A=
> This replaces manual checking in the driver=0A=
> =0A=
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>=0A=
> ---=0A=
>  drivers/nvme/host/core.c | 17 ++++++++---------=0A=
>  1 file changed, 8 insertions(+), 9 deletions(-)=0A=
> =0A=
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c=0A=
> index add040168e67e..8014b3046992a 100644=0A=
> --- a/drivers/nvme/host/core.c=0A=
> +++ b/drivers/nvme/host/core.c=0A=
> @@ -1849,10 +1849,16 @@ static void nvme_update_disk_info(struct gendisk =
*disk,=0A=
>  	unsigned short bs =3D 1 << ns->lba_shift;=0A=
>  	u32 atomic_bs, phys_bs, io_opt =3D 0;=0A=
>  =0A=
> -	if (ns->lba_shift > PAGE_SHIFT) {=0A=
> -		/* unsupported block size, set capacity to 0 later */=0A=
> +	/*=0A=
> +	 * The block layer can't support LBA sizes larger than the page size=0A=
> +	 * yet, so catch this early and don't allow block I/O.=0A=
> +	 */=0A=
> +=0A=
=0A=
No need for the blank line here.=0A=
=0A=
> +	if (!blk_is_valid_logical_block_size(bs)) {=0A=
>  		bs =3D (1 << 9);=0A=
> +		capacity =3D 0;>  	}=0A=
> +=0A=
>  	blk_mq_freeze_queue(disk->queue);=0A=
>  	blk_integrity_unregister(disk);=0A=
>  =0A=
> @@ -1887,13 +1893,6 @@ static void nvme_update_disk_info(struct gendisk *=
disk,=0A=
>  	blk_queue_io_min(disk->queue, phys_bs);=0A=
>  	blk_queue_io_opt(disk->queue, io_opt);=0A=
>  =0A=
> -	/*=0A=
> -	 * The block layer can't support LBA sizes larger than the page size=0A=
> -	 * yet, so catch this early and don't allow block I/O.=0A=
> -	 */=0A=
> -	if (ns->lba_shift > PAGE_SHIFT)=0A=
> -		capacity =3D 0;=0A=
> -=0A=
>  	/*=0A=
>  	 * Register a metadata profile for PI, or the plain non-integrity NVMe=
=0A=
>  	 * metadata masquerading as Type 0 if supported, otherwise reject block=
=0A=
> =0A=
=0A=
Apart from the nit above, this looks OK to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
