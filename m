Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF55C433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F35A2064C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:25:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YEaMw5kw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="e4u6Yqq8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgGULZP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:25:15 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:63836 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGULZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595330746; x=1626866746;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=53P7LU6XAUCPrmBLx9j9hHqJ8t9N53oTfAEAwAb+IVU=;
  b=YEaMw5kwpM2RqBBvnUIumg5KNAN0OxHp9F/WuhnLN+Nbqjo0wfg8x+Iw
   2k6nqE5YwRO+9oiwihE7EP94F7IPCy2weMXLgAzZi1L0DTztd7kMrzC1+
   udSf8XfUw4lYIiqdKVCEAh4otFwscSyoASEWtRGiF1IE7CJHyacZ9tYvK
   6/ujeajFMQtcKNf+/415k6kxZlhe+Ma3l45P/U53sISk1tZzUk7aRMolv
   U887d36IPD+bvW8iZRT2vSdKuLAaEiXCtjTpMW1HVVQKOktqr8nLzQA9Q
   Nr43F4AnqqAC/KGYKIPNsTM4XD6H6p5U9Y0rxdPucmqjqWlLGwlA1HxFq
   Q==;
IronPort-SDR: D93AF5g/SQzDKNfgZq5thyukwAJElqnYMMXZhM66HsKCgktM6K540n4yKSESIiccVb4XsjUyEl
 xTIvdzRuIUVoWmLn77z2tY/jHI0kb9meuTaex1iJeqokbzrbMDSjpKc6An8fkoKa141uQUR8/0
 AQCA4w60h/oa3Xa2/5fbSo9VYE5f8cusLBM+Th1zBKN/TzHgl0NeRXxUL2LAjKVkEmODsJpcVd
 tt9nJVKqmfEWoU+bzZzrf0kSTmAjT/Qo9lS6n8oyiHL2DZkpaCFEcnWOrXjVQwF6H7M8Ko92TD
 KzI=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="246050805"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:25:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hprplEM5Ew2J2+n/wX6Oa6/A2jCUz5g6Ce1fDiBN1B/bp9693/66h8DsrHeQ2/1mfMuCPQrAjzG6LvbGfT688VyBXGdfhbDjvwlHsYSpP/AYVshDQT9IJ3NbsviOzeWbTJ0JTVRge275LxA0jJE5aS5Q/lAdQCdS111oes1hoRP4oxQAU6VHrCKQMWfJAmQcvpFfpQDeA1ek+/YGlQNr5EfUxtAcqzjLxaEb9pqaN1MHOABJqWY/X+bG/Cky7sljbIsXJvxnM/qQb/vWxZCse5appnTnTTO6HILYWI22Ttg8tRdf9JxUVWi7CzjNGBOxZgMl7pJAt6QPQmu5KtKNgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kj0SIXSNDNBSk5LrKFg2xDCiHNUXttUAVHceOIjyU58=;
 b=Am6MbMz7OynD2lcuklvSftT/o1DbEMxsjNx83HlfS9GTR/OiTYqHaqAZHglobHXqX3EFgVkimMnNwTqa/ZllVew3DhtTS8SsK5abXUbCvw5ZUgRgm2s7L8mtZAtL399YT0eTY7eM4hdog+Hppcd/Q8FYpKnfsGHntgMtqFfK5EYIihIUDMbVaEth6Z07nw2MFM9lGfWthR5dUpLhvJeLPe6OSrS6jszlCkqXOPFh1T5Xsog0n8qxgcjziL7TKycw9yVnUVFQS7r0R/dq7Mv41/HkLPgE/5z9SGMY5LEmzjOBz8VwGIP3ryQfUW1SKfdRG3aJL4akuP0xJEWXHF9HgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kj0SIXSNDNBSk5LrKFg2xDCiHNUXttUAVHceOIjyU58=;
 b=e4u6Yqq8UyXJEIWzaRZjc9swFnEAXmaKFHgQRxkYttVJbjS5M905COyZP1iAOjuXv6PtiSDrbxiepDED8fXilPZ2D+ld0vkygjwaVdaqc8go+KQ/ft7SeMhkC4UfSmk947ruVcV5Fo4kCafF5O4GaRX5tX+y1b41nHmIiLU+2qc=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1176.namprd04.prod.outlook.com (2603:10b6:903:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Tue, 21 Jul
 2020 11:25:06 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:25:06 +0000
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
Subject: Re: [PATCH 09/10] block: scsi: sd: use
 blk_is_valid_logical_block_size
Thread-Topic: [PATCH 09/10] block: scsi: sd: use
 blk_is_valid_logical_block_size
Thread-Index: AQHWX013XUfOciPpqUa+Od1IzTz9Vw==
Date:   Tue, 21 Jul 2020 11:25:06 +0000
Message-ID: <CY4PR04MB375113B7D781BF2949FE5B33E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-10-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 22318541-8eb1-42be-2a55-08d82d68b85c
x-ms-traffictypediagnostic: CY4PR04MB1176:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB11761F7F9F09118E11217DC1E7780@CY4PR04MB1176.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:109;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d+cMiDuvMX5AOaQqbDjHboxUPKqmURmbiWjO9xVyWxneJ5NPKuoir4+M6hpLYPXWodDNdiOQ652mQs7LjKpC3OQribkQkU5eHJ9AleJJ757Vc70kZooc8pHOft7EASOE/ixuqzosDzt3f+Ir4X8yziRXg44CfvI+ccVz7fC3mAQYLujCfRbX7sPn299wpENvuy25R4KIBp+11glz6evDiqIQsIettrcTu/XrcMnPeU8PTuW7cIV3cT9WW1++cpK2uBdv1aEk1uaj8hz0SR9yHTuhEAt4SqIT6WjFrIpNtSrnFLYw2SueEdN0RGUe7meOCpW2N9syFDGQwHwQS+2Opg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(39850400004)(376002)(366004)(76116006)(91956017)(7416002)(86362001)(83380400001)(71200400001)(26005)(66556008)(66446008)(5660300002)(52536014)(55016002)(7696005)(478600001)(8936002)(6506007)(4744005)(110136005)(2906002)(54906003)(53546011)(66476007)(9686003)(33656002)(316002)(64756008)(186003)(8676002)(66946007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2YRqlL20Yt3JAsQVA6ibq/lc1hZfkLI/MOBCJCyDQSPuI0TPOQ/gGd8muC/dXYXJYo43W2coD4kWiISbdmIc8MheYBSKKjs2Q6nggSszPONP9ZiMXcB4RJnmkz/gtyYFTH6wCF3ca6+nMf7aIf6LFBrl+GmhJcGJg9GrbjJQC2PkL7bTImbXkKyscBoXNKMnHKpb+usvlmYPGAn4tCMFPzsE/WDodu4zKSoy34DnMoLo20hAEkg99Fw2KD0bXp+RthOAjf5iflNbWT200xgwtPVBnMcP2uxoRG1YhsxTwQrQZHc89GCDeF30ADLYFQDZAqDBFd0olUkKpOGwYXKylN96nUwLw0slEPpOgiw0T3rd4E8Bbmmc7Eb898ryGXFAFVF+u4oVT72iQPlJewbJBSjb/HTzda3+I9g7vYJjAlSW9tJTMOLh5AOWOSGfJMEMeb4RkFok2uKXI8njr4mfGeXkb9rsdTQcJ0chgo83aiIEiWH9D6rxbv/rOcYEXM3v
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22318541-8eb1-42be-2a55-08d82d68b85c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:25:06.2683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YwLUMBdiktOCfxMEtamPgamaGsVgenMpvGnn4ZPKps4PQWO/W5fIc8a8CYi8P4PLIXS2X5j4+jo4622b1P6vFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1176
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 19:55, Maxim Levitsky wrote:=0A=
> Use blk_is_valid_logical_block_size instead of hardcoded list=0A=
=0A=
s/hardcoded list/hardcoded checks./=0A=
=0A=
> =0A=
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>=0A=
> ---=0A=
>  drivers/scsi/sd.c | 5 +----=0A=
>  1 file changed, 1 insertion(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c=0A=
> index d90fefffe31b7..f012e7397b058 100644=0A=
> --- a/drivers/scsi/sd.c=0A=
> +++ b/drivers/scsi/sd.c=0A=
> @@ -2520,10 +2520,7 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned =
char *buffer)=0A=
>  			  "assuming 512.\n");=0A=
>  	}=0A=
>  =0A=
> -	if (sector_size !=3D 512 &&=0A=
> -	    sector_size !=3D 1024 &&=0A=
> -	    sector_size !=3D 2048 &&=0A=
> -	    sector_size !=3D 4096) {=0A=
> +	if (!blk_is_valid_logical_block_size(sector_size)) {=0A=
>  		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",=0A=
>  			  sector_size);=0A=
>  		/*=0A=
> =0A=
=0A=
With the commit message fixed, looks OK.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
