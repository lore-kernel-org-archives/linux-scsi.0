Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E42C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CAED20792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:06:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UL0hVNIE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vZ2+kFlZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgGULGA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:06:00 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:31798 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgGULF7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:05:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595329559; x=1626865559;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=CoEhfmm4jX66FpCwpatzkWF4ODQgVzFeZSkWSu6njAA=;
  b=UL0hVNIEsyNnEf25jW81kVLepowqoDB/iVeaL1UZrVT2XGJGhMIIH7pN
   JVjGvoaf01BPsxp7MdxiTREn6vBwu8xRI9Fd81J1m8scavTmS1ZJmFnKq
   lkeh8fIzTbK6SV0o+yFH73yVZHX5DPsZ9smoLvbbJlMJCS9zPOljW23W8
   8drzPmsDPm+QHftlIwDrSION3n8tCyNROsWimJOvKOLuV+RJo5l5UPXSV
   n/gAejsNGP/pMS1N38PMG4PDeT3p5YaDyLtEkGZXGUasKV5p+sT3DNfSD
   VCwWENvyMCTUggJQXvqLrjcEYg2imvF9+pHNpMqku50fHkR/L/rlwnr+J
   Q==;
IronPort-SDR: ygJATbjXCG0g5ASGmPba9yZCA0mOkZ3iOCRlx8SbG5Bb5rNAR6dsOIWZcgLNitxSSz9L8EaeU2
 goT+azISiSBIBPsKoMvMt1dk8QtEnwHWElKTf2k2juUwd3swcO2zuHzZwsF2LFpxNuLHW9R7ka
 Y9t96KeLTZEZxwTqDUFlZ8OyhkNW3cY2NQdAv//ub7hq5tu8zSJKOjUHJeGHMkce/dmU3LMIkd
 pUuk5S6D5NkIXNoH8zxEB3iXsnWIpvQ5bj7eOfICcu78/9CbXolKvnaAzsQeDSW9/3G9R6WQZR
 JVs=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="144275718"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:05:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4o0VRydxaFTmKsRcfg4zLRCYHgJ11rkDptNhfLJxcsJAZqLMYpCaQenrt2rDbvQhiuCP/yp/2lIcF5bSvjxLDLqBRjWkjuqaIbn0avrgIXdVAp34GArcnenyP6MIBj9wt9+/OsokhOY7SSLeoXRw+5h4DxvTq6LfqjCxgZZUlPesRaS8zA2ih/abMIm5MjHsuT2uVjjxee4QQW0Xj2zWvrIY5gznMBI+zVMnTj7krx00odaINyenSUTeyAha7LcUyQFtwcotNb9t95qfDBzK4ulnlRRvBDLp/CXSA5iOd949IUBwAxDPU3MzGADjiE96fAirbaGxetLcRbztXqogA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZsD3rpHjn32rYozCOXnEz7HcV8R2No7ZKi7IKQSzZg=;
 b=juojf3evxtFPmWpONPrto+1MH9/yAO6AQBaVy2KyTtETvB+7Ha3zmbtVvelDvzgh5pVx3yRv8g0Y3UaT69tL8pdc+wO/gFCgvjA9ou/n3iSelPtQEsRK1ee1CbAaofeEdwsikGo4UYNEQXn54HSNI/g+HF7YXMMyaLPmdZBle1YiEOxSryH7Eh6HszS3sSpYki7uZ2XzFsqD5x55LTqaecnH1G+iFlWVpP6a1VgrmztF3u7yJi25R/OBLQJdknCiuywUBaz7GtB1fA+Cqqm1NU37lQwULJYd6mB984fsDg0uhceaAzPuBiTSUcYYTx0hnP9j9tLA28/DZhBIsBqUgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZsD3rpHjn32rYozCOXnEz7HcV8R2No7ZKi7IKQSzZg=;
 b=vZ2+kFlZIX/TH/K2K53iSb6mv62bm/wQjQ7wWr3znOU8DeJ5R14e3daS6x9uLz35WcNMe5x4Bwfva9gRdPYVOx2p18UyxlCRDJyLJwpCe8DRkAHsKyvDczjWw4cSSsjm/vDjt10+QfIYNM09ijUfUtaFXTiU8S7srZBQqv3DnkE=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0422.namprd04.prod.outlook.com (2603:10b6:903:bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 21 Jul
 2020 11:05:55 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:05:55 +0000
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
Subject: Re: [PATCH 01/10] block: introduce blk_is_valid_logical_block_size
Thread-Topic: [PATCH 01/10] block: introduce blk_is_valid_logical_block_size
Thread-Index: AQHWX00wSEUVG8TRcky47gGqEX5tBw==
Date:   Tue, 21 Jul 2020 11:05:55 +0000
Message-ID: <CY4PR04MB37512BDEFD7B977FCD32A10AE7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-2-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 93980b43-74cc-412d-cbb6-08d82d660a29
x-ms-traffictypediagnostic: CY4PR04MB0422:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB042244680790D0CF619925C3E7780@CY4PR04MB0422.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NQ8jGGP0HRjNuXmy3E6js5UZFeuuJxomqbo9IkIoEkSnuUC6W3RrTL1nFFjxgDunp1dsSs3wWsnDzv1aSGrKK6Fzstqb7R2DMpXmmepgYR9hRCQ8ATYbKoKBh4ufpsN4M1qnezwQFaJn+MZseK0428a/issZVSxChqtRUZIBb6d8lridMcxGP5pBZ5TDSN91GhLPkgHxPqw+kgVS+pXMeAel2weyC6e8b8IAc5BSVi+pPztHXn9bYXTR8K7KVkEzbPMvtdETO4l8GWy1oa3IpBliRcQasYcmNM6N+60NLJmZpUK/nNSGAvqjq6q6o4U/b0GEsZjH2NB9YwitLZL2mA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(110136005)(2906002)(478600001)(316002)(8936002)(7416002)(86362001)(7696005)(54906003)(55016002)(6506007)(26005)(53546011)(186003)(9686003)(4326008)(91956017)(52536014)(5660300002)(71200400001)(66446008)(66556008)(76116006)(83380400001)(64756008)(66476007)(33656002)(8676002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: p1GYpyhVZt8uctt4HxKHdJhZ3rW6Oe/HvM/tIMeuo40AzXRlxgyF7w0Cpd3dDv+YSSpiuWZcMAjGQ/vu8sFZ5YWLjDdKqbpcjmanoypspY33xmFo0GxSx/xrm2kJOgVZJrPARKG9fN8tbT4IcWy1mDctgcrnBxdoT3KNpMk8deb1fARO3rg5tgmNye5t+eTfgSIsCFT6ueUwFI9qSXq9zRSDjf0kZFsOolvBQ//Jpt3jCNJS0aD2Zs7ocnJgo78g2mn53SOFuqo+phb3q51AVpVoF/UTc0k3jk5GXn34j4+Sw1YrXPea0zFd5DZplKbtdfRdzcm5mF+6cZgxCYiQiR3ZNdvGXSClYLxovn3XV035NcjkQQ9qzjWWZKzwoEjOMZJLP9yVEgS86cm6lbLVH9BAJEFH5itJIwufJ3i8/bsDsZBo8JBExyotzLpbosS4H79OoS0LzMh3aWQteSIQnv3x0SMS5N7UbC85XQuFNJXvYGXgT9doTs9skeZY5dng
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93980b43-74cc-412d-cbb6-08d82d660a29
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:05:55.0261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJlZoTLu95oo9Q+vGWQBSVBY/qaazUx7OJ6ekQ8sQydxos05WdNdw9ugKz6zhXV0VEsOyXc8XmYd6CIx48sagg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0422
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 19:53, Maxim Levitsky wrote:=0A=
> Kernel block layer has never supported logical block=0A=
> sizes less that SECTOR_SIZE nor larger that PAGE_SIZE.=0A=
> =0A=
> Some drivers have runtime configurable block size,=0A=
> so it makes sense to have common helper for that.=0A=
=0A=
...common helper to check the validity of the logical block size set by the=
 driver.=0A=
=0A=
("for that" does not refer to a clear action)=0A=
=0A=
> =0A=
> Signed-off-by: Maxim Levitsky  <mlevitsk@redhat.com>=0A=
> ---=0A=
>  block/blk-settings.c   | 18 ++++++++++++++++++=0A=
>  include/linux/blkdev.h |  1 +=0A=
>  2 files changed, 19 insertions(+)=0A=
> =0A=
> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
> index 9a2c23cd97007..3c4ef0d00c2bc 100644=0A=
> --- a/block/blk-settings.c=0A=
> +++ b/block/blk-settings.c=0A=
> @@ -311,6 +311,21 @@ void blk_queue_max_segment_size(struct request_queue=
 *q, unsigned int max_size)=0A=
>  }=0A=
>  EXPORT_SYMBOL(blk_queue_max_segment_size);=0A=
>  =0A=
> +=0A=
> +/**=0A=
> + * blk_check_logical_block_size - check if logical block size is support=
ed=0A=
> + * by the kernel=0A=
> + * @size:  the logical block size, in bytes=0A=
> + *=0A=
> + * Description:=0A=
> + *   This function checks if the block layers supports given block size=
=0A=
> + **/=0A=
> +bool blk_is_valid_logical_block_size(unsigned int size)=0A=
> +{=0A=
> +	return size >=3D SECTOR_SIZE && size <=3D PAGE_SIZE && !is_power_of_2(s=
ize);=0A=
> +}=0A=
> +EXPORT_SYMBOL(blk_is_valid_logical_block_size);=0A=
> +=0A=
>  /**=0A=
>   * blk_queue_logical_block_size - set logical block size for the queue=
=0A=
>   * @q:  the request queue for the device=0A=
> @@ -323,6 +338,8 @@ EXPORT_SYMBOL(blk_queue_max_segment_size);=0A=
>   **/=0A=
>  void blk_queue_logical_block_size(struct request_queue *q, unsigned int =
size)=0A=
>  {=0A=
> +	WARN_ON(!blk_is_valid_logical_block_size(size));=0A=
> +=0A=
>  	q->limits.logical_block_size =3D size;=0A=
>  =0A=
>  	if (q->limits.physical_block_size < size)=0A=
> @@ -330,6 +347,7 @@ void blk_queue_logical_block_size(struct request_queu=
e *q, unsigned int size)=0A=
>  =0A=
>  	if (q->limits.io_min < q->limits.physical_block_size)=0A=
>  		q->limits.io_min =3D q->limits.physical_block_size;=0A=
> +=0A=
=0A=
white line change.=0A=
=0A=
>  }=0A=
>  EXPORT_SYMBOL(blk_queue_logical_block_size);=0A=
>  =0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 57241417ff2f8..2ed3151397e41 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -1099,6 +1099,7 @@ extern void blk_queue_max_write_same_sectors(struct=
 request_queue *q,=0A=
>  		unsigned int max_write_same_sectors);=0A=
>  extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,=
=0A=
>  		unsigned int max_write_same_sectors);=0A=
> +extern bool blk_is_valid_logical_block_size(unsigned int size);=0A=
>  extern void blk_queue_logical_block_size(struct request_queue *, unsigne=
d int);=0A=
>  extern void blk_queue_max_zone_append_sectors(struct request_queue *q,=
=0A=
>  		unsigned int max_zone_append_sectors);=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
