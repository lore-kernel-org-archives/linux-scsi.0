Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6295DC433EA
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3046F2077D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WYipmML3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="sIbDG+Y/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgGULIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:08:50 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:28175 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729647AbgGULIq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595329726; x=1626865726;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=GxkgTXW1uqE93KuW8wrEgu3CEhk1EzooCuCq2Z/dzeg=;
  b=WYipmML3+zK1NSwxebmIUUBi78BuJYYVbSBF2jLWu+SPvQrJiFc4uCfp
   KHiwrO0cc/ZJQBsYFNwyBFdBA2wpQ2r04P2X1k+YYbL6K7THH5JrQS3Pm
   Nb2py1NjizpKTGdBIbvz1ImgsBioAcTCeDc3qupxIBg/z81dipHNArBzG
   T4r66R1N/TMbrfGmQEeqr6wHqbiSL66xASWvmcCJYGYtMEqbJd5SVZyqg
   X6ZY8bmmysaa30X+04yNfD+UlG+1MoQ7IHASFs4PWt6l5tZOhcKPHpd29
   XJ2YwEnrxlEjUFj6YWFaAr8Kx4palnyVbzeMfBvbmpnMp4YZk6VOboHBQ
   w==;
IronPort-SDR: 69GzNWJsWctOH0+YFvs22U4d2Hz8gYY4R1q7VlGfChIjcF6cD9LYILKvxRhpF7BTnVejz9W6Ae
 8W908C9a75qdIHRufsQfk86LxIjDPbn+0VZlvxKi3T4FTeCgORLRtpI39KbZsYKxTFMxsgTcVc
 xrqVpAO7Kx5qmAu0FVtLvh3GahuPW3tj/Y/XZ4YSgdZb/2o5GyI8TD/woGl6moTNMJK0hBXSBp
 aysgXICZBh7GS3BmMdISV+qd8nO8mFAslYq0cXJOsqPFwJFvwsxukTXisau8bNjpw0vnNWFVzy
 k0Y=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="143102529"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:08:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMlf0rr5MoFpOLOpCVhxsbHAmX5324IMQx87NsKnEHLf+P3JtZJavZzUSTF6X4dlPjstTXAyx7M5tg8CCQkiBWuTGsNo6o99/Swgh2xsMGl1q2GquaIFXibVH2fSe8yJCgdt8TsZ+Gk2OD7mKjO9zTYzEipPfCj5VFsMN2GEmN5LQtr3Ck6z8v3NxYLg/qzmDFFxEdI39VOP+EA7ObsRpZFzpaY/q5jPs1CIk+Iaf0FlYLzWyG6TXnDJ/ywtJWIC2zQZK3SCiStolVgAhuefcqzGwK1iDDE8tdKOlxSbdzok5ibuGJUnw/GGw/h8UzqCKwdlPBjs5nCn1N7GZCa1JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4v1I5m7OABcKfWLpv3al52trVS03+DKq6uRaF1Nohc=;
 b=cvRMS4mqilMady+vIsukTQERgPSqVA3+A/TR+xkah65jRfcxWc3wTRwZm/7Q7avFBWYRa5ko34QrtuDMKJW7trd3uh9TEEFKEKwKKf0Pwm/bNyFzSYdKycZhv3h9248SRogTNefMvMMhb5q+j6UbogmXG2Xm2fIV+AqM1tQQ2rCIm60U2cqrGzR40VSwLAgSJe8dv+3RBE+XeOiPCzqucIJki3QYXs0v5BYijojSHUJYXDmILVaQVssHTEk9bPMhvgio6PHwsKYjR7N3uaV4pDWQKSpvnv54QFRWtXsH+pe9I8AhTCWqqYQFQAs/kN5IWDQ2TQLAtDwvNeelrSlycA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4v1I5m7OABcKfWLpv3al52trVS03+DKq6uRaF1Nohc=;
 b=sIbDG+Y/bMe2KGOaK8kaw8kW33dcXRnMfbRJ+ac+pi59Y2rP3FMm4X4uQMA3K0kb1iHj1YYEpeWU8s/nU6J20ggeRysgqDjgM3r13WOF02lVjF4khu4YMBzNX/c10Q4C1492kAExd6o3KOUGmF9pIF5xrB0wmi8vRA13L2GZcqs=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0422.namprd04.prod.outlook.com (2603:10b6:903:bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 21 Jul
 2020 11:08:41 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:08:41 +0000
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
Subject: Re: [PATCH 03/10] block: loop: use blk_is_valid_logical_block_size
Thread-Topic: [PATCH 03/10] block: loop: use blk_is_valid_logical_block_size
Thread-Index: AQHWX01LIw4xf3qcak+F7qOi/18XOA==
Date:   Tue, 21 Jul 2020 11:08:40 +0000
Message-ID: <CY4PR04MB375172789B9725F132B94216E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-4-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a9163c0e-ae63-4cb8-2841-08d82d666d0a
x-ms-traffictypediagnostic: CY4PR04MB0422:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0422245941CD28F6B5CD6814E7780@CY4PR04MB0422.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 83pl7kM0JCnEywOtKelAGhwCie72ilBeWbJnQrwj2TZvQYY8AeqfO2OW0ujMnVvQuDTaOvpW2Gtl8KgR9MGk3uuoLu2Ud7+u0p1phzL+P1XTo5lllBVGlz3BKn3rocaIYcQoaH82HxAIgqyCutarBzMYJ1LGWdAYPqYm5h3VaTO2wxHeaVzlm7364dXQ+j51i63NVEfyKSbobRAnMoQg3+z7VSy7zohKn1rx01kSQViXcYgQKhjhEud1OV4UM8mxNOqZ0/YbP1hKyyNdZ3/v0XD7fdZa/DYSxqGXQp3LscZyF1+h2vSIL91/E6V7gphWBYnaGSird4FCSzrB8gBuTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(110136005)(2906002)(8936002)(7416002)(498600001)(86362001)(7696005)(54906003)(55016002)(6506007)(26005)(53546011)(186003)(9686003)(4326008)(91956017)(52536014)(5660300002)(71200400001)(66446008)(66556008)(76116006)(83380400001)(64756008)(66476007)(33656002)(8676002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2xoQL2q/JObW6TZmyf/bgFbkH000F1lpmw1XCNVXEZXEEhAU51RCphoBmwcAsWl7iZxIWjRu9qkJwv0dIKIO8Ulz57rpYE43TAexR+7pu0XRlrXMX4LwAVTJaQLewTEWFZy3qt/Vz2uCOpqn+njjewMIGyKo1tUQUV7fccc3CNmCY9xmBGxLUBhWB89t24c1DDtYKzaFOvAHm5DJo0Ww+ema1VD1FvHQO5gtDiCLJWwlgb27Gca9Wi98AakpMtLkcUE0H1bvR3vqcEl1md/Kl08Zkn2BhpyDaiFrpHo3UREUDWu1FFfag9mfaOYlfa+PYbaCD1j+vocadE82eMRzArWdoGAkam6jXaELMOSuv+GOIEOWfqRZ4VNBg5az2DLuerqeSVOrkOkgmdvrHfHdHsE3aWdC8iz12E6yjx0+li5cyve+X4BPIeSDd5pkgad413FpG2X7pOo36V1j137WH1ErKAo+T5BnLoW5mDUe4zoEFzBWteaz/ANTc2W9A9wx
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9163c0e-ae63-4cb8-2841-08d82d666d0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:08:40.9532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y2HEtUYBTXMrMgPO9H1FDdhJf8Bozws/9cnksKGUAyYDjx8KjxdfvY4+82NUgZZ97imWYQAsTTnZolBXxdVOeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0422
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 19:54, Maxim Levitsky wrote:=0A=
> This allows to remove loop's own check for supported block size=0A=
> =0A=
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>=0A=
> ---=0A=
>  drivers/block/loop.c | 23 +++++------------------=0A=
>  1 file changed, 5 insertions(+), 18 deletions(-)=0A=
> =0A=
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c=0A=
> index 475e1a738560d..9984c8f824271 100644=0A=
> --- a/drivers/block/loop.c=0A=
> +++ b/drivers/block/loop.c=0A=
> @@ -228,19 +228,6 @@ static void __loop_update_dio(struct loop_device *lo=
, bool dio)=0A=
>  		blk_mq_unfreeze_queue(lo->lo_queue);=0A=
>  }=0A=
>  =0A=
> -/**=0A=
> - * loop_validate_block_size() - validates the passed in block size=0A=
> - * @bsize: size to validate=0A=
> - */=0A=
> -static int=0A=
> -loop_validate_block_size(unsigned short bsize)=0A=
> -{=0A=
> -	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))=0A=
> -		return -EINVAL;=0A=
> -=0A=
> -	return 0;=0A=
> -}=0A=
> -=0A=
>  /**=0A=
>   * loop_set_size() - sets device size and notifies userspace=0A=
>   * @lo: struct loop_device to set the size for=0A=
> @@ -1119,9 +1106,10 @@ static int loop_configure(struct loop_device *lo, =
fmode_t mode,=0A=
>  	}=0A=
>  =0A=
>  	if (config->block_size) {=0A=
> -		error =3D loop_validate_block_size(config->block_size);=0A=
> -		if (error)=0A=
> +		if (!blk_is_valid_logical_block_size(config->block_size)) {=0A=
> +			error =3D -EINVAL;=0A=
>  			goto out_unlock;=0A=
> +		}=0A=
>  	}=0A=
>  =0A=
>  	error =3D loop_set_status_from_info(lo, &config->info);=0A=
> @@ -1607,9 +1595,8 @@ static int loop_set_block_size(struct loop_device *=
lo, unsigned long arg)=0A=
>  	if (lo->lo_state !=3D Lo_bound)=0A=
>  		return -ENXIO;=0A=
>  =0A=
> -	err =3D loop_validate_block_size(arg);=0A=
> -	if (err)=0A=
> -		return err;=0A=
> +	if (!blk_is_valid_logical_block_size(arg))=0A=
> +		return -EINVAL;=0A=
>  =0A=
>  	if (lo->lo_queue->limits.logical_block_size =3D=3D arg)=0A=
>  		return 0;=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
