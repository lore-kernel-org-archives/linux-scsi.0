Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4489C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD98E20792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cZLB+MKs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Yihzsr8l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgGULRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:17:43 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:29630 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGULRm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:17:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595330261; x=1626866261;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=x26Isbp50+zWhTmlTaVPEjGJ4hfMqF7XLxanddPh4Fk=;
  b=cZLB+MKsbSaoNSNDBzprCgaa7rqNCpvSrZ6IgyXBNxlalqbasho9/Bi0
   KEHplCZmYiAaU7xUn3w0q0DpDTwQ+JU8oWEqRFlYcPoORSlamA6SoLxA4
   TthtgUg/ZEa367iJ9bhqTd8FonvygqV/TmpQxvSkugq9XYPS41nm17Wz5
   6/gEnBM9YkLocpU9T/2nqriqrEU6dUlCwU0bogczBGb7mcASD/WXhd8KR
   utNNOvPEy7KEuevQL1oJzUA22+QTc37Fy63Oh/pNXKirvf1ueb8AswfzY
   JlrHU4RlmhZdaU7gwypVy1NhnodeExkIC07Y0rsHwLzY701D7n2ijQmS1
   Q==;
IronPort-SDR: /2VwMAvP4HxYp6kok3jpcBUG+I1GcLbQ0tQHiUZqcFbZ7idpZea1GiVoJYbaHc2JObKtyzNZ0W
 PNnasznijypzqadfSjkiXDgl8Y4P0xkgduEmOlY1Rv7UGDVyFlv2rMebIG+9mxoR9tmAb4vCrq
 ppCMf4B/mxqUbyHutv6ZEW6MS0vNLrqXqbJnIMobUauh3CZxfVZ97jWgwzqbM8ds6E4cfHlY11
 cFIMF/P2BJJFWvUlSwdnnLSJEY06WUnzuqe/fVwZldRfcqWQautxurjX+ZJjHSW7DJ6/yzRZ5J
 aU4=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="143010693"
Received: from mail-cys01nam02lp2057.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.57])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:17:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tluq2yY2j1LCBXVN3bhmDhnI2E5DrZuGjCUUL7u6bdQKC26fZKd1HC1gzahG05Enj//+Nt844wfrOT6IU3KzyHJuCRxiNc40rcjP7at2603I/H2EvzDtPYc1y8YnuWKz+TJI7crxjRu2EgNJm5HDC0g45uHDX+lYSgOoLtooAlDsRQjIhTUXXhCBwfBgZXQa4utjVXRsDtDtZphjhdGohIDm5Bocs7v8kZe4Zvu9gNl1C8UBb/wDOOQN3M6WwRdPKIJ4zxlg5vp+dKErfRZOqKJbYsk4nZyvrLmkQOlQyj+X4OLMcCv7qgxaLspGA43Ij/ualPI402Co3JDrI+DzHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTPdlSQpT24DNZTM+n7D082QH3awvak6H3W8pMKs0os=;
 b=Uq5ZZOIsdVp3+uQn9gi+I1zVuB/OGS3lQPfR5AbFQ3oV5nI2508c1jddpEkUrMULhmhdGf2yLOMhln+waqZn7TrbHOrX+TUj4ilM3z9I3PVICoVgRHAlbXa2xRVS/O5iKAFgaYgU+J6PD7M1TGkCTQzC1q49ZDzsDvE+agG37BO3boNdmmT2QiOhm2K2JqnfVzc1NY1oSLbq3tLna/2BCZ/ikUDUr5LzCYKi//3D4VVhVzUpEOIbdyM4S1+EMXk6z8DoCKiHlvrpUQ5Q6raXkhtFTXBcHqkPgl/ol+0kJCjCtl4p6+/6l3TT357IM/IOnm1nufLFEU7j+CXjnWTTEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTPdlSQpT24DNZTM+n7D082QH3awvak6H3W8pMKs0os=;
 b=Yihzsr8lXfi+jE7e2JaO3izNY2bQ06eX4WpfIu3Thm7m/ItkEMDtPb65moIecU6Ean80vLKRh3ocieV4kzWOGvg1p98AGaU3ADUqzA+JPUXrAdQz/C3uHgRXlKTuHH52kUmVnIcWe7zPPeLLjNV2ENUnPIyuHlLWiVsnVov/Vjc=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0969.namprd04.prod.outlook.com (2603:10b6:910:55::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 11:17:39 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:17:39 +0000
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
Subject: Re: [PATCH 07/10] block: mspro_blk: use
 blk_is_valid_logical_block_size
Thread-Topic: [PATCH 07/10] block: mspro_blk: use
 blk_is_valid_logical_block_size
Thread-Index: AQHWX01oiDOVnfgGh0CC3FlT/QUR8w==
Date:   Tue, 21 Jul 2020 11:17:38 +0000
Message-ID: <CY4PR04MB375189EEABA0475AB9460DA0E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-8-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0df3efaf-0e8b-446a-f150-08d82d67adba
x-ms-traffictypediagnostic: CY4PR04MB0969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0969DC95F79658DADF52A04AE7780@CY4PR04MB0969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:321;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hoq2t3akd/56mI3Z+dU8Vk+nBpq9qGi8iVgIIeyfJ7q1wya6venVzOef6Yh9UUX2UEUkEwLkKaEARBVFbAv0G01XZzK4qrWWeUtz26tDo13gkHCJJzUhT4aN1IIbA+mHqNKmaqOTKxfHRZlcbG62OX9L6Vu5RD5Mm/OmO2lzahIz/zFSp8DwLdgljC2GPVZYU0uJMJlan5QTV8z6py1TJ35L0i3/IPzRq5sWzS6aEkxTG+xsy8rq5bhYtBTvr+s52kUe+O9Th44aq//1G7h3pVqFFgbVc8OFzSJ7t7A5tz8aTmgNJ+m3qV2tzcyWrPK6T9tpDLooWSlzYy0TbM0tzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(54906003)(316002)(110136005)(66476007)(9686003)(4326008)(186003)(26005)(71200400001)(76116006)(91956017)(66446008)(64756008)(66556008)(66946007)(52536014)(2906002)(6506007)(8676002)(55016002)(83380400001)(33656002)(5660300002)(478600001)(4744005)(86362001)(7416002)(53546011)(8936002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TNUnF/ZyCdxtxWzs4pJlZD50B9HhqMk+Uioo0GFNVsLXB8OgwWD+3+Fq6HTeaWIZPPQuuMu5LMX9tB9oGRFix0BKM3EdHbutKiUqWlwgJm3540YxOgF2JSaCuGJQPNhf6Mgpt+52I4d/cFcnZ933p4HnevrcSkxEvMsF2snEvq6+DFp9yIxmTx967iq7uuYAVzP0A2O0vyqdkA3QCMJUnW6TM1LcOJKwMNqqbhZ6ZKzIukfYwu1Auw9900gtVn7VoDTKOCuZzc37RidOBenrBm28kgE548QPhvKu+KzCeRfHX9jErqZVF9on3EQAzzlWEMyb0xIQbdkktjaBYFMr5TId9pYO9tTuo/5aLVu8i1fnApmGwILgetE/y0u1rLWthp5K+m4+bjF4DECmL9LMsef6R5qqKn57YTbY0a+QRYD9brOkA+AqJiZHxEysb6Dn2VyyJjNCsCKE4helxvrHvi0ZKKlh8jgVSg0a7MYgVRYmZu6wAfLdLCKhCRg1cm9Z
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df3efaf-0e8b-446a-f150-08d82d67adba
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:17:38.9917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x7eVGeCttYUbQMfHljaIDnl75W3H25pp+2B5v/1b65iWc6GaiC7rW2UPQ+sKcxaDrP4yPJJVPRG40VUsXMkgIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0969
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 19:55, Maxim Levitsky wrote:=0A=
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>=0A=
> ---=0A=
>  drivers/memstick/core/mspro_block.c | 6 ++++++=0A=
>  1 file changed, 6 insertions(+)=0A=
> =0A=
> diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/=
mspro_block.c=0A=
> index cd6b8d4f23350..86c9eb0aef512 100644=0A=
> --- a/drivers/memstick/core/mspro_block.c=0A=
> +++ b/drivers/memstick/core/mspro_block.c=0A=
> @@ -1199,6 +1199,12 @@ static int mspro_block_init_disk(struct memstick_d=
ev *card)=0A=
>  =0A=
>  	msb->page_size =3D be16_to_cpu(sys_info->unit_size);=0A=
>  =0A=
> +	if (!(blk_is_valid_logical_block_size(msb->page_size))) {=0A=
> +		dev_warn(&card->dev,=0A=
> +			 "unsupported block size %d", msb->page_size);=0A=
> +		return -EINVAL;=0A=
> +	}=0A=
> +=0A=
>  	mutex_lock(&mspro_block_disk_lock);=0A=
>  	disk_id =3D idr_alloc(&mspro_block_disk_idr, card, 0, 256, GFP_KERNEL);=
=0A=
>  	mutex_unlock(&mspro_block_disk_lock);=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
