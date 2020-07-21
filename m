Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195F0C433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E629820717
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="axq/HKL0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LYGxL/t+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgGULRG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:17:06 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:29555 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgGULRF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:17:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595330224; x=1626866224;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=StP94OLHh+PDzMOB64OOhcKXVzzBMnsSj5AyHnxySEg=;
  b=axq/HKL0F7j2mY/MOQKKFawOCHczhGoUDaw4p5zL14MWF7EuRWer4Hn5
   ds19eZC47CBxoBlRFD1BO2Q+4tIxxvVdL54q1UbF9WSvZr4sm/j9klLY+
   sOCkMUwRnH3NsOOErGym38Xv8EW/R0E2oVJNUAMkxjsE24UPc1qTB3yQk
   M2uaw9kLzEvCHNlZKpI8FBR315ci8LB74Fa6eMh4sLqaF6E30lztJrT71
   9QCVfZQzR0rJP/FmVJm/zEdQ+nopGZgIKg66ZKFS1GCkOCjcLno7dFKaN
   /IfXhuIL3kcZbadUD2wwoBjWrWKHq9U7lYlsoUNNCw9C6hlrLSD3gAcAY
   w==;
IronPort-SDR: reEsHghl/F31AXlteyNCYMjQ5zx97sDuWeIMzp+BFL8jRZQP15aj6c22zPEUqOYHgW2kyqrVFi
 GooVKRHEiC8iyWovYYdxzqJPRaNSZuyyL6FzMmJ9I1DT+zLIreG22+WWTp+kZGDchs7TQMNdah
 3AEeFg9KqkHxChyuS7aQ7/+3Yd6KxIRpnM8dOwpaNKXW30ay/Hgw8QQ51H7cUCPiXijFncEwLR
 AszeJKeshTGc8rc4Gg1kepnK04bJbu1p9uenor73X1HQJvRL3GcScYqC4o3uP8M/W23L/6Dv1p
 IhU=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="143010668"
Received: from mail-cys01nam02lp2057.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.57])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:17:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bf27J8OWW3xDLczbMegQkbQ9spSuISkuJRea/tqP4X9eP/S8sBg4xn5wZEjb0OISqpDTD+QZcfMcjPihFWSWgU53YTkp6kTqX+c/oelQjWKsMkPdtsw2vAXTGo9CjpTmPlLE+SlACUJATAXGFuYJwdr2KNZg3lP7Vd3lp/ZyTyFoBQERn2/ptNO4hbHYQgrQsGFOIX1KgaJIFf2nsZC9RGT1bx9ZNcP3+oeDTCT3WkAAGgGvWU9w8sx44TscN9WLt5Xa011vtMmt4m/SKlnncrVaMOn8LlFI7NjzPbcfkzTwDxQcFI3OCvSn/YEbpmHk5057CN6ZjlBOfF/VfA0BfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvaOanothsTScmhIuzPqJODx/+D/AFeIGd2YRAHJTus=;
 b=Z1TlvrbXxnmwJrTV6WU1favhjUbyNS5V3Cyi2eghAm1yHETeCnnL597+I2MCVPLefoaYYezajiU17hEo+0mSmQRAhfohJ/WSur9ORmoSKj3qWEVsJHkkQ7RtHsTzh0a+8tHiN/PwrzPJT6rcSmwtgXFTVwUWrX0xD3thEoImuRRcmk6N75JdwCBpj4Wbb67O9xBSp4BMnbGb6DOXs/NC/SaUnHZpkOczaMdnty4qJbQ0ZquJAoZTWYiCgnXu/rMJ+Tiv0ncbNMJYin1e6CVYfk9BcJ64ZfdLSJ70JWz7BB2CZejzPS6QLMIVmM6QUITf3pRVjZWZiYT3F99pLcyJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvaOanothsTScmhIuzPqJODx/+D/AFeIGd2YRAHJTus=;
 b=LYGxL/t+R3V9yVEXjuD/qzrWontbqW004qXfNyGpwfWS8HSHTKc2URd+V58nNljBZReaXr1Wwb0Urv+ntyo3SemIZW8bCqhRPu4XrJ2UsvEThEWZl2YmILcq3FQwFrI6HSSy1tj2v2neej65s/kcgYhP2BQ0WK4J6+CeqILfzQM=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0969.namprd04.prod.outlook.com (2603:10b6:910:55::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 11:17:01 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:17:01 +0000
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
Subject: Re: [PATCH 06/10] block: ms_block: use
 blk_is_valid_logical_block_size
Thread-Topic: [PATCH 06/10] block: ms_block: use
 blk_is_valid_logical_block_size
Thread-Index: AQHWX01g75TdosEsGkWUbpiStX7SFw==
Date:   Tue, 21 Jul 2020 11:17:01 +0000
Message-ID: <CY4PR04MB37515103AF92B1BB196ED494E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-7-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ef6f962-47ab-4516-44b9-08d82d679771
x-ms-traffictypediagnostic: CY4PR04MB0969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0969403535D65234DAED6997E7780@CY4PR04MB0969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0MZ/LL1yI7MjrpdwTVATMoUBe+PwN0uPuTUOQS2CEaCAxg/XvxdI84bk+tFNo3FNjrvWYLzZKsN26Jx1bdWfriWp4dphKcV6YFCBFLA1oAADZc8aKaKWf22XKUEShjakBpTDeqT6Mhk37xtUKLnmDMCksxoffxgru1hSP2ABCmnDbq/duANzgof28MKJzIHS+Jt1zxwUQrWiCsIY1RoKL8iVRHGtEHGYxBzHa7ngumBU2AxUUgW/+3zLb5/9LHc0I3UjZpb4siWBOsFmfTYQaE78nYW3xoThlooontALCOw4uczDO1RkfH5b05JyKu843a7X+8bcdDOieBjVxWU0wQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(54906003)(316002)(110136005)(66476007)(9686003)(4326008)(186003)(26005)(71200400001)(76116006)(91956017)(66446008)(64756008)(66556008)(66946007)(52536014)(2906002)(6506007)(8676002)(55016002)(83380400001)(33656002)(5660300002)(478600001)(4744005)(86362001)(7416002)(53546011)(8936002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TPGTHYmJXG1kHOFtFPGDS/UwDnJ/TxNRUnVpbLzl7L+dZinbvHjABnqFG0KpmHaVZLVp5Zy1Xpuh9VLGP++S5RE2MDK8JYA/J2XFO1F2DVygWN1G9bzidhXtDGMXGVI3Mz700d81JKwbKOHNC3TgjauAn5adczivriC33QTmjLGgh7wosZXdv4aRvylhtw3vMq0e/6Gz68lJyi3sOjPkZdUv2P0KabJkUqXJcTl6kilE5IU3OBScdjZmmeMqEVUON6zS9zG9fp9zYdBNEEsApzaWpJCt7ly+ltysfl9acq6dYCaYGZ7glBs82GQ3R5Lu42/HMvjsxT1s1SwziptFZjxiIMyU4HztrRVWV1FAsL/Yt2/CQbsECS1WRxyDwKewVtQ0PWKv3iFfCKmmmMRWuwsvfxDe67TicGgqfYVac6u4jEQqlAHDACEn1ly2QTqn5qVDgshSzFIsRZF4iFWtumxeE4E24ihzyxfTjNSP3o6Bt1O/Eg4Fx1bdz9adk7oY
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef6f962-47ab-4516-44b9-08d82d679771
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:17:01.6380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0RX/r26b2DneM+l0Evdbfr4LLXOUXFGC+xfIj3TmpzCzA5dss9pFwKdCjh8ROzjAUX9L8waPQiOTAID4JHNZZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0969
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 19:54, Maxim Levitsky wrote:=0A=
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>=0A=
> ---=0A=
>  drivers/memstick/core/ms_block.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_=
block.c=0A=
> index d9ee8e3dc72da..e4df03e10fb46 100644=0A=
> --- a/drivers/memstick/core/ms_block.c=0A=
> +++ b/drivers/memstick/core/ms_block.c=0A=
> @@ -1727,7 +1727,7 @@ static int msb_init_card(struct memstick_dev *card)=
=0A=
>  	msb->pages_in_block =3D boot_block->attr.block_size * 2;=0A=
>  	msb->block_size =3D msb->page_size * msb->pages_in_block;=0A=
>  =0A=
> -	if (msb->page_size > PAGE_SIZE) {=0A=
> +	if (!(blk_is_valid_logical_block_size(msb->page_size))) {=0A=
>  		/* this isn't supported by linux at all, anyway*/=0A=
>  		dbg("device page %d size isn't supported", msb->page_size);=0A=
>  		return -EINVAL;=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
