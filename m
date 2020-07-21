Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C41C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914612080D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:15:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YcUfABZ+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LdgrahiG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgGULPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:15:55 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:32630 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgGULPz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:15:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595330155; x=1626866155;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Zx6Ii2KS8rsaZutsZNeQFW3MmzvXoX0RRsCGUgnINug=;
  b=YcUfABZ+y4pmvAHymnqasOOcgC8Ml9JOPZc5cqBGRL5x7XmxBiX3Qufz
   RJso5DOX44mGmZo4P4BlxXpeTDi5zLgx7ZcPO1/sxUbIP9HVNYHh4TvXw
   N4z6frhx4st2K9Tlac+Pw/Nt2FmQl7zkDZXoyBLVhySa70sFU9nwgOPCl
   2jUcJ/9C8/teLfWVLXznd7094Nq7D37vaHMc8+me2r2dyVst+miB9B+4P
   8X5d62XmpiCdVqaKw/Aqq0fdA2+RNPvkAB+qlbC2rV67pZCa/GRR07Oxa
   LKo1y/wOkkkmrQCl12Ry/eb+3J2vgQgMG4XniKELUWZ6NQs/ZgWxVq37q
   g==;
IronPort-SDR: Z7/KiS9Ox2HFjDsLLEjeiXJIly2FNDj9j6IPAK+YJKygL3U/bN22DK7Nx2U5WXkdeEYR3ZcOvF
 LAhRZcLbQWQ1n2vcHVs9qXj14AidpDdpF+2KeEFC6x7mayGvjaHcDNIgYHzb08Qvuii4DgqPOo
 NrspC0gYgEYjoaXaNmoh+geKaJ58If3UCIxR6Q/nN/8UAwQmOVcOnPQCezfpVR1cEUzKUtp33i
 /V+sB+Ma5jtD9AMQWoUc4Dfj26IGQ6KSw17DZRp+GJkH10zdcgl5YPDADWgBp5zXM8CnpPw/Nf
 AkM=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="144276373"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:15:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6WFNB8MGHeaavQELzQE5Fypgbu0KG4f45hOrDv/QbVzZiPGHHZ9UdDs3lP9pn6iQoDeG5jcA7MVmgK1+y/ErsWInbRNXTIDoMIcFnYp0uY5SIBEiqMnzq325gFDNfrmocrXd8j/NY3tNWOac1pB6WgUDZwwGXre+mS+xZYVoJ/gqQA1hIbN4RiNBX40CsaxU++FJ2SReAnG75qnx0xZAgIgqlOqFtpi4oEixJ+p+/HxragDUHex6SqSVR/xuMOEm6g7lbE0n7ujxSDa3uQ+SWcAWfJUVQBKsIrnTKLFgnbOXdFTebMwCW5aZUsNq6jHE+p7NzwP363Im9SB0MIIlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVZfXO9rM2yBDtJXvxSBOeJf3P2o9DP9XWZSD0j35wQ=;
 b=Pt3PbIyQdVn1WTAvlMwyC+4339I+A2scOF3wi/sreBNWM/vLURVAKWAf94GIB8yLObpGZFuIhKATR87wsYBGTcro26W3er3x8BoBmVlVL0T7h9sO+aRlwZ18IPTEW5YV6jewrPXQL3uWLvIE841oY67zTuE9iDCZhZRz3NppiJnwwL8XuHdH1zcnSGlzk9yBwcyH15R+JmU/Fef9BVrrPWrefTwj23p9vDc3owSIOT+QSB/P85iD9kKCg34Y3YLKRqdvQJNbnaYC+BI4upudOYz9YyE4ixdlUZtQmF1sShfWnriTRIHEuIYX+m1M5+ZWX/XEs7ZH74NSC7MpzgVDow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVZfXO9rM2yBDtJXvxSBOeJf3P2o9DP9XWZSD0j35wQ=;
 b=LdgrahiGTqXLHcj7bUiTqleRjN7+gpiS6QRuggHMJ7gp47afuBwgR2z0a1E8+2fz/bTHMdThZG/4I7Omrn1WE/Mo9YbUk11WIqrdlN7JsFqWsYMGSSt6Ty1vsZwIZNIlzbY+ChiyuYC6uR7wsQ2NY8cV2egmGR7vBw5NctT2lOc=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0969.namprd04.prod.outlook.com (2603:10b6:910:55::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 11:15:51 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:15:51 +0000
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
Subject: Re: [PATCH 05/10] block: null: use blk_is_valid_logical_block_size
Thread-Topic: [PATCH 05/10] block: null: use blk_is_valid_logical_block_size
Thread-Index: AQHWX01Yw77hI9ihkECd8bf86hXuBg==
Date:   Tue, 21 Jul 2020 11:15:51 +0000
Message-ID: <CY4PR04MB3751882A6BDF7C073D6ECF88E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-6-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: afc79abe-6a75-4fc3-f163-08d82d676d79
x-ms-traffictypediagnostic: CY4PR04MB0969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB09692931FB39FFDB52AF9B34E7780@CY4PR04MB0969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kLnbJ8Ru8UyXyV2/SvIgpCeNGEjiTp1Xq88c70hXMv7sDWMu83psr4iuQIYYdIFtJQ4e3YJWhvgNMifD6HGoBSE5wrJ6mYsOv1oC/vfakuc4o6VDg6R+3dEenQcQCuDwPRjzibZsAJjbGiMw9RNjD7XaWbK86b32nGQ5Oj2KvfxUS9jW3T18wfD0A6IjB/F3nlJxPNA3OOrjcw1hIjgMZ2lA6HwL6iMIAL2ikv4wLNccP/DZOLAxmfpAmMh+A6Hwo8rARnM6QV/3sjr2QGcXYxtpiZ9MY6iaNanvs7X3bzgFeROg23XrtesivAX8ZpMDFP/ck8A5DMIC7KUlLgXCiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(54906003)(316002)(110136005)(66476007)(9686003)(4326008)(186003)(26005)(71200400001)(76116006)(91956017)(66446008)(64756008)(66556008)(66946007)(52536014)(2906002)(6506007)(8676002)(55016002)(83380400001)(33656002)(5660300002)(478600001)(86362001)(7416002)(53546011)(8936002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: GaPGQGDdib8G8c3JdLvgWdsUoaJDWQYPni9GIcbRnCR8j4rUxXimTFJiQd3irrRL9pBbbgt0KjR92LCzyKTaXJC3p+fQqIi0kB2T6nQ+KAcapiVwhxplBMf2xtpxs3ObAUnwc17OwciittGpPgW4XOFgUk91IBDKuzLGhEgI9H/2l+wHbHG/3zHm0e10XVR+l5nZ0iRccpLonEje7yiI7jg9/tsLaLCsxh4xc9mXFrwglI4jbjZVY32ENrJ5+HHRSQFquCybd82aLSgPlkmXfCryd5ZzkrQClYHsJ5oymllGOr52uOXf957r+/TLBmhxqYSbN68UIHQwEtXJyQxXvydm2dRegbBt8cxG2oPYlm2LkogUp6d0qTkfO1/x4GwDoS9eL8W9aigz1MG0EUKGkELxYozoTpw1Elj48MpnQIQWFH59V5szJYJ2Tf0dyzSS7VewD8hkzJz7rTc9q1h6LqetB6ViDy+dwy5ogNmQl+DVVslw/xmkkSZ7O7ZlKGbL
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc79abe-6a75-4fc3-f163-08d82d676d79
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:15:51.2365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +u7VYWbUdOY2dzOt08hBMUAqqwn0bPnpGlZFX6nFC3QNsmVRmhJrfSW6EUFmEHQli485XiQ3KH6d2WVF0sj3LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0969
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 19:54, Maxim Levitsky wrote:=0A=
> This slightly changes the behavier of the driver,=0A=
=0A=
s/behavier/behavior=0A=
=0A=
> when given invalid block size (non power of two, or below 512 bytes),=0A=
> but shoudn't matter.=0A=
> =0A=
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>=0A=
> ---=0A=
>  drivers/block/null_blk_main.c | 6 +++---=0A=
>  1 file changed, 3 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.=
c=0A=
> index 87b31f9ca362e..e4df4b903b90b 100644=0A=
> --- a/drivers/block/null_blk_main.c=0A=
> +++ b/drivers/block/null_blk_main.c=0A=
> @@ -1684,8 +1684,8 @@ static int null_init_tag_set(struct nullb *nullb, s=
truct blk_mq_tag_set *set)=0A=
>  =0A=
>  static int null_validate_conf(struct nullb_device *dev)=0A=
>  {=0A=
> -	dev->blocksize =3D round_down(dev->blocksize, 512);=0A=
> -	dev->blocksize =3D clamp_t(unsigned int, dev->blocksize, 512, 4096);=0A=
> +	if (!blk_is_valid_logical_block_size(dev->blocksize))=0A=
> +		return -ENODEV;=0A=
>  =0A=
>  	if (dev->queue_mode =3D=3D NULL_Q_MQ && dev->use_per_node_hctx) {=0A=
>  		if (dev->submit_queues !=3D nr_online_nodes)=0A=
> @@ -1865,7 +1865,7 @@ static int __init null_init(void)=0A=
>  	struct nullb *nullb;=0A=
>  	struct nullb_device *dev;=0A=
>  =0A=
> -	if (g_bs > PAGE_SIZE) {=0A=
> +	if (!blk_is_valid_logical_block_size(g_bs)) {=0A=
>  		pr_warn("invalid block size\n");=0A=
>  		pr_warn("defaults block size to %lu\n", PAGE_SIZE);=0A=
>  		g_bs =3D PAGE_SIZE;=0A=
=0A=
Not sure if this change is OK. Shouldn't the if here be kept as is and=0A=
blk_is_valid_logical_block_size() called after it to check values lower tha=
n 4K ?=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
