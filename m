Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BDEC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 599062077D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Rtpwkvgp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Zt4OJA+l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgGULJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:09:29 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:32106 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729565AbgGULJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:09:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595329759; x=1626865759;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=N5dhqBRhDEy/yn79YudoO4zA2LKbqYtf20pFz0eOHKs=;
  b=RtpwkvgpndqOS98LVhZKHyiwRGkSKCqylj1o498ajTzzMwyPrS+Ddlzj
   p2/V2PzAY+iqcovECyRu3U7MhuFU4oM9CylObrS/bzStLWh0p3k1ESOYD
   Z8VdBJz65m04v3HQJcVZp9Lbul/a1rZKltK3493UHb6h5Zu+7Jo+HRwHW
   fS98UFXoAfysp/Li4NFIJ+GM7WVugfppbyYW6k3SmCa/U9ZNu5NtfKVCu
   iGWN7yXjBaJd34t6T5sn6JZM3GjkA3ekqnxJgYX1tcHS9IFublBMiqAQG
   bdwLhiVgi5b+ntOz2MEQ3aCj9p50Kx/xSoNMjUuTWlJYAg03ZznXtNaYI
   A==;
IronPort-SDR: fzaxD7TyosAp/YwzYsF6MEhpyasbJXr7phnMMqI/jZO2Fh9gHz8TrbwAh7C6MkDGjYUfM3EqqY
 NwbbMrUA9xzN0mob9e4EsSbgZb9wgsQVbdS6bJUCfCyQwaZrUGhKW43LrgEyWqBkGnHni7RYXm
 cKeYm2vJzYWJcgK8Sx0aYF3qW8sRu+cixk0G211on/wAJ4swa53+QI3M1dyhB5spbyoCADwsTe
 Dr1Ft9R/9zr3drGHVxZRs3YrWJtDoeq3tzy/Ilv89+kn71qSqvkV/+menyF6AitT/ACBOsbg/t
 A8g=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="144275930"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:09:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMLnuGHEvL6q1WYRR4ddT9HM6lxmzmhhscy2g3efafz5Yix4oYNg+BFg0aPflKUtVhfxUyV3S9rO2oPoMmHdPFlbS5lcpmEVpEELSbpb8Q5sWImH/K7WKwk/mSHZdxbbHzPLRZgKGtqXZhvBVk8V93HCeoYCZXBIV3WfZegmcZRvtR4ekngtFymta3MtnI6IJavES0anVjda5KuuTktTd8o8AzVhAawuBHlEP/HrKcABxkWpfVjpWxRtyNwMEIykwfmjj//GChBAWO67+SqmQJjwOt18td3ei+GgZWOzE2p+9JeAkZQCoGPYYRanH3Aj6tPutI8YCpVf6eYhhPkt2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEN6FavZSDqoi1vTM7Yi/g47UteRnUXWdSqu5rCGr9c=;
 b=Q3hYHzNnPU6W0z6PeYY9/pCkpu/2n1OJSxI3fT6cLoEOt56cgY27uDpR9koBNT9Si+mUdOQiCPNWFb+nSgQQSaMsYNQFQV9t6+MjwEEWKPkmG/gfNWtB3Ro5l8ypHMaeahhQ7MjIA4Pr14QxQlc6vdSdLook/0SsNg7TPQ6CIcmiaNkiUpsrPVzI7ftd4pNcyIIJ1YY6K4nHP+7T/8Qn9wT+AiqMS76MVlxymHatZEDsKiXkIlE/ftkaigG5i4WYtKnvJ3HLZsDJGJ1PbmNNwMeV1OcMDO/hL3dO635f3LLYP2vOYWL7PVzYPGWr7Ohs2atms4/zugvp9mbwlHiNMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEN6FavZSDqoi1vTM7Yi/g47UteRnUXWdSqu5rCGr9c=;
 b=Zt4OJA+lRVOfnnyOtYOVcrnzHrc0XNUEGngKPu3RzZRWqpr79Yp5Mty9tVmnhZabCQ44D3tZQ/At+seI8c1Y3Jf7nZm/NTA2r92sWyY+rM00Z5s9/jQitQfq4cFf1dbfLkpa5vFdOAco1+rwLWmmomSGje3XGPiJ7SaN3WoluaM=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0422.namprd04.prod.outlook.com (2603:10b6:903:bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 21 Jul
 2020 11:09:16 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:09:16 +0000
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
Subject: Re: [PATCH 04/10] block: nbd: use blk_is_valid_logical_block_size
Thread-Topic: [PATCH 04/10] block: nbd: use blk_is_valid_logical_block_size
Thread-Index: AQHWX01TPRBfw0JfSk+HzrCJWVECoA==
Date:   Tue, 21 Jul 2020 11:09:15 +0000
Message-ID: <CY4PR04MB3751EED308BB3AE6E028E3DFE7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-5-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dce41ae4-c311-42c5-8e51-08d82d6681e1
x-ms-traffictypediagnostic: CY4PR04MB0422:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0422D5637E8014B9B18622F9E7780@CY4PR04MB0422.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h4H4zjAD09DAR+pt8CFir6YH3ZmySVvLU2rC+5eOHFwePlMnME2yk1Pzo84pP3YXegpTg0Zd57+GbaZav2ITUQ+Gn9V+jVF6djFffw9QiQSmF8eMl9d9eZ0PYsQMdItTyzqBd3QHLCjrgUDYFmEYfYjjTpgOXoLsg/Yjpts2Yd4In7YyL48vHhPoxNdoDcnfAw0nIeuT2Sql5G0o3QUlkHzJ7iECE4wsqe2zEVTwWnvhzWL41s7rxb2WrKN1CH0Wikwr7w/SuzMDMtTbygHu4x7QEe1KaKhVqJoAryrfOLzEJb9tHPRWgUuYJZYopMYY6jJwB7gFpqE/UbxJRbMRng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(110136005)(2906002)(478600001)(316002)(8936002)(7416002)(86362001)(7696005)(54906003)(55016002)(6506007)(26005)(53546011)(186003)(9686003)(4326008)(91956017)(52536014)(5660300002)(71200400001)(66446008)(66556008)(76116006)(83380400001)(64756008)(66476007)(33656002)(8676002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mt5CajmB72pum/P0yPi5sQjetWBc6tRbU8/4r3+tY0x703IhgHWzFPPz/kb10RVauywr5dh3FQt5AZ1moytke3F0/nP+rIi5m7zKfBf3ZpmHwwD72ovVHw7awkYSGfej06XpG+4wYgD18OYwqv2J5qretqRhN7MEzqypHTG6YHFbl22dx3JlGUz6dfYFAlrS+Xl3nikDcwHUaL0We3YNw2JC+kH4AVZFVcftyQDtWtATs1ruqol+kt1MKbtOTGi5hG0DGgvm5EalBhXOvoFvFfhA25sMpBouc8VUbdlHQ7/QTYAywVwd+ySVj3YuqsEmTcnPKeJxSB6ruaCMFYBKrpmrQIUehhHRa4Cf8lTzLuUOwbhY/1xyojgNfwrST2VkUVTKxwQ3dgnKZEnSZ3w8QtnTQT06ux/F6lVr8y28UeO3hqNhqidHSqAKCRglEiYI+AaTxTjuKhkNYaLWBMbGFXj92BnMCGBM+Y5WBSS+RuYv6+B6X9mgYiTz+bPs3Rz6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dce41ae4-c311-42c5-8e51-08d82d6681e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:09:15.8723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gwSpojT8CvgOo1b5AE150AYx7HiLfSz9eJQpzzFQ4hy7hW9Ht+sLc22+M/tJH2GVIxTetzYwtWHh15y69XFFCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0422
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 19:54, Maxim Levitsky wrote:=0A=
> This allows to remove nbd's own check for valid block size=0A=
> =0A=
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>=0A=
> ---=0A=
>  drivers/block/nbd.c | 12 ++----------=0A=
>  1 file changed, 2 insertions(+), 10 deletions(-)=0A=
> =0A=
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c=0A=
> index ce7e9f223b20b..2cd9c4e824f8b 100644=0A=
> --- a/drivers/block/nbd.c=0A=
> +++ b/drivers/block/nbd.c=0A=
> @@ -1347,14 +1347,6 @@ static void nbd_clear_sock_ioctl(struct nbd_device=
 *nbd,=0A=
>  		nbd_config_put(nbd);=0A=
>  }=0A=
>  =0A=
> -static bool nbd_is_valid_blksize(unsigned long blksize)=0A=
> -{=0A=
> -	if (!blksize || !is_power_of_2(blksize) || blksize < 512 ||=0A=
> -	    blksize > PAGE_SIZE)=0A=
> -		return false;=0A=
> -	return true;=0A=
> -}=0A=
> -=0A=
>  static void nbd_set_cmd_timeout(struct nbd_device *nbd, u64 timeout)=0A=
>  {=0A=
>  	nbd->tag_set.timeout =3D timeout * HZ;=0A=
> @@ -1379,7 +1371,7 @@ static int __nbd_ioctl(struct block_device *bdev, s=
truct nbd_device *nbd,=0A=
>  	case NBD_SET_BLKSIZE:=0A=
>  		if (!arg)=0A=
>  			arg =3D NBD_DEF_BLKSIZE;=0A=
> -		if (!nbd_is_valid_blksize(arg))=0A=
> +		if (!blk_is_valid_logical_block_size(arg))=0A=
>  			return -EINVAL;=0A=
>  		nbd_size_set(nbd, arg,=0A=
>  			     div_s64(config->bytesize, arg));=0A=
> @@ -1811,7 +1803,7 @@ static int nbd_genl_size_set(struct genl_info *info=
, struct nbd_device *nbd)=0A=
>  		bsize =3D nla_get_u64(info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]);=0A=
>  		if (!bsize)=0A=
>  			bsize =3D NBD_DEF_BLKSIZE;=0A=
> -		if (!nbd_is_valid_blksize(bsize)) {=0A=
> +		if (!blk_is_valid_logical_block_size(bsize)) {=0A=
>  			printk(KERN_ERR "Invalid block size %llu\n", bsize);=0A=
>  			return -EINVAL;=0A=
>  		}=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
