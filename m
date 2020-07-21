Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F22EC433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49B5F21702
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YWYlnOiU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AC1u95oC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgGUL3z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:29:55 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:30658 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgGUL3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:29:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595330991; x=1626866991;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=C6I4GoH0FruEuw/0Xp3DSehLlb0iXRVsA+YOZPnoxBY=;
  b=YWYlnOiUXYzk2HYiPRb5q28FkW9uZrqGwDEUhWaH35NbspIMqrH39TC0
   v32ZUJDxR/jZmdCvIP4rr8GBTaD7OmXFLUDNxzeC2Pt+70WkKOpk96X/n
   KlNVwHPgR5cJjQSWlKe65PzNZJCBohqb7127l+8xzqYZEg6aKJ8WVZsru
   UWRmvlI9TtSRwag2tIKzxLPTh85NCrYyZ6X1/0o0fjRukRPmAdGVNXj5N
   S1m2FLnQ5NoZ/KxrAwaB7UJw799+9k5SMXuTGeDJNCvwe5450WLopxWRg
   VNFX6TVmT3UVDqP7b0u9nhgzlLk9627CB6UGjlxrFDsFWKHpRxQsrvaIL
   w==;
IronPort-SDR: ku4Iy5afuPNUIj5oO5yNgwUUGYHGMiWnjYeItw3gGUyKXFKv2CEvurlhaWAtMdJUEyGFd3FrUu
 na7HaKvkqDeiaoKs256xfbZQTB1oa05VCRdRcdkAKr0c7txDmZwsGZRnUTajXncWLvKI1N6woq
 y79QiAAdCG4RkVrkv3joCerL5aqt6g56eGEfIMOsyTZK8dvmWASmhvljLuMxEEAN0xhhAJpdNp
 1TupQe2a7sCqve8mQ5ASmasp9e2AZiCXoI5cJWLhB0seXwmKbL0AP8U0FFPVZKOCygU6IbFvb4
 qds=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="143011381"
Received: from mail-co1nam04lp2057.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.57])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:29:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTbj4pEFoMfT6c9wyarApKYZsbdmxu20wYdC9F7uQ+5Wj4tHCfrFZrksbUrT8Yv2snrbsD5FxLabDzpR2qpHHzZPbtHXonmqdehzgKdLj1PifkpIuvX1sonzy1P8TuJOiTK6a66DXvVibve1j5kZRDuZ9b1fFgbcPwRXud+n16prRe/2OGJu72GpUVeLyww1gGySQarVBqBHDt71hgqN4CSqAMM96GhNERzdkjIo7tNTmeDotGY0mIVcO1oWM/j9Sv6iMj+UmZu0vFaT4LkQ12O1ZdRMkIlh03ixfhVo7r+hIF26LojYiF83sBDtTUv9YnDtITLvWV/QGWVK1g90uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RpkeK6dM77XgKav28mgxPLcyy6f22K2rkbeawzNJRo=;
 b=LmULh250u6l8cMO9T7FZHdYfZUsH889+0DjU3lWnQXJNsS2CRX+z3Il/Xf9jXGUHsrF/EaefNrGvmujvd1cMx2IP3yb17bTTJ9wPmTD9uasMAl6Wo5Th7/5IloSUBKOtBUA9vzADpGWq9mAAgIK9y0xs0fAkCSPimZoIDSj931l/Z/HWkE39sBpT3M3A296mPWnrBmpfEcZgfuD+ZySc14xEufptVVbN2vEiwI+LgvO25z6btOi3HBo9Fb/uzFT4LJPZ9t2WCsHe8X56ivNPmaNelB4TOCw3yr70OYBknJAKQat+Rz3ud3Nf43ZMgex6snwkvy75IPawWufKyjmT1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RpkeK6dM77XgKav28mgxPLcyy6f22K2rkbeawzNJRo=;
 b=AC1u95oCiWrje/QiwD+tMYL3ynDlclsGgDlU3PVS+IHwAuzolIutGbRgKyXU/QG3i2DR7LvwEOijF/PPRvh0nScVXYNBNieWrnPC88lyvntffJ6kCdZWzLczNuDPcUnUbaceyKxehcgcMIUPKcsX0avZz0QfoyWlcGBbQ5VPUKs=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1176.namprd04.prod.outlook.com (2603:10b6:903:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Tue, 21 Jul
 2020 11:29:48 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:29:48 +0000
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
Subject: Re: [PATCH 10/10] block: scsi: sr: use
 blk_is_valid_logical_block_size
Thread-Topic: [PATCH 10/10] block: scsi: sr: use
 blk_is_valid_logical_block_size
Thread-Index: AQHWX019CvZXuI6pdEKIdYQL4AgTSA==
Date:   Tue, 21 Jul 2020 11:29:48 +0000
Message-ID: <CY4PR04MB37517861074A4A448180E136E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-11-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0e8bc580-4ae2-44df-5ee3-08d82d696040
x-ms-traffictypediagnostic: CY4PR04MB1176:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB1176A9EA9BE5383CE2FF7CECE7780@CY4PR04MB1176.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CD++Hfi5jeC49fNUP35OwONqlDfKzav/Wk5XdIiByJ2ms4czIAhw081HoNq8Bk34JVeJXrP3kjIl1aaAmJ8af7A8xwksJmjJvq3uGoBW7nyvNgvhqRcz5a5w3JHOhs3szZURW1Berz0gWn5Ggnxn4RQsYAgGQRvJh1bC6E1tXpV0Zk3Jr3+pWJAfZXOB/PyeY1qsr/jvuWmSFp47wMAAK48bW0yttTWcmH8I7kSv1jz1B6iUQ9vAKReffaw64d1+qv9TJ/AcJ7eWsVT4qS52XsHIU535kPmvHBavrmOGr+B9W2ArLIn2yVkD7WdWlEyu/SQJLAAJsFPHH5WRv07IxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(76116006)(91956017)(7416002)(86362001)(83380400001)(71200400001)(26005)(66556008)(66446008)(5660300002)(52536014)(55016002)(7696005)(478600001)(8936002)(6506007)(110136005)(2906002)(54906003)(53546011)(66476007)(9686003)(33656002)(316002)(64756008)(186003)(8676002)(66946007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: nW+kQ2nX5CP1VxOHSGLruICPvUP48Q3yKjhqF213DFSU2leAqfROtjU6D1YhHIxxvq/RLE0IBA9KKRAWSyJA9z0n7o0yRkS/RZ8uFr8EXjZNw8w12PkojvS7c9fog9Wvo7Plh5pmXaVRpPPe1QIwzewx4JQ8shVQo1dCNWv6I0Kkppi2JmBsGJUjUvGpDb3syWhRgETeJhxN+Bx+fqCq0bkjLtLo3wBSE6qYAZqTPmQFAaOzfBYyMa93KBrRi2NR5K0yLV7Ne0BBrk6jXpBK5rTPX+QqY2geop8zey+ve3maZSKYgg4AA80eUV2Iul8HyxV3nzq8pg2fK3Q227ZTLg2ksu+SmgeT+I90v7YZiijS6N4P1RZ73/PaQ4xBKt5FmHcHjimt969UAuLQVT3LTK1pED+CxoqKty3j/gTS3gA2wVCpDis0aXJ0s01pmfq7chvzYTIynzr9YEHIkYDMNv5xh+FPbIX+hRIS+Fax7hNAEjZW+EAwUT7JkBEIw7L2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8bc580-4ae2-44df-5ee3-08d82d696040
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:29:48.0203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gLY8pDDRMak6fdLiSqc0WgUr6sksn8NLB+shZ9kjcrQnUw+7YG+THc36s4RUmGX+QKRZ0h91ZSsBzn5Gs2UaZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1176
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 19:55, Maxim Levitsky wrote:=0A=
> Plus some tiny refactoring.=0A=
> =0A=
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>=0A=
> ---=0A=
>  drivers/scsi/sr.c | 31 +++++++++++++------------------=0A=
>  1 file changed, 13 insertions(+), 18 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c=0A=
> index 0c4aa4665a2f9..0e96338029310 100644=0A=
> --- a/drivers/scsi/sr.c=0A=
> +++ b/drivers/scsi/sr.c=0A=
> @@ -866,31 +866,26 @@ static void get_sectorsize(struct scsi_cd *cd)=0A=
>  			cd->capacity =3D max_t(long, cd->capacity, last_written);=0A=
>  =0A=
>  		sector_size =3D get_unaligned_be32(&buffer[4]);=0A=
> -		switch (sector_size) {=0A=
> -			/*=0A=
> -			 * HP 4020i CD-Recorder reports 2340 byte sectors=0A=
> -			 * Philips CD-Writers report 2352 byte sectors=0A=
> -			 *=0A=
> -			 * Use 2k sectors for them..=0A=
> -			 */=0A=
> -		case 0:=0A=
> -		case 2340:=0A=
> -		case 2352:=0A=
> +=0A=
> +		/*=0A=
> +		 * HP 4020i CD-Recorder reports 2340 byte sectors=0A=
> +		 * Philips CD-Writers report 2352 byte sectors=0A=
> +		 *=0A=
> +		 * Use 2k sectors for them..=0A=
> +		 */=0A=
> +=0A=
=0A=
No need for the blank line here.=0A=
=0A=
> +		if (!sector_size || sector_size =3D=3D 2340 || sector_size =3D=3D 2352=
)=0A=
>  			sector_size =3D 2048;=0A=
> -			/* fall through */=0A=
> -		case 2048:=0A=
> -			cd->capacity *=3D 4;=0A=
> -			/* fall through */=0A=
> -		case 512:=0A=
> -			break;=0A=
> -		default:=0A=
> +=0A=
> +		cd->capacity *=3D (sector_size >> SECTOR_SHIFT);=0A=
=0A=
Where does this come from ? There is no such code in sr get_sectorsize()...=
=0A=
=0A=
> +=0A=
> +		if (!blk_is_valid_logical_block_size(sector_size)) {=0A=
>  			sr_printk(KERN_INFO, cd,=0A=
>  				  "unsupported sector size %d.", sector_size);=0A=
>  			cd->capacity =3D 0;=0A=
>  		}=0A=
>  =0A=
>  		cd->device->sector_size =3D sector_size;=0A=
> -=0A=
=0A=
White line change.=0A=
=0A=
>  		/*=0A=
>  		 * Add this so that we have the ability to correctly gauge=0A=
>  		 * what the device is capable of.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
