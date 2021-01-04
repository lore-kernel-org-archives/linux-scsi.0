Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10788C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 12:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C83E821D93
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 12:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbhADMsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 07:48:23 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:41698 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbhADMsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 07:48:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609764502; x=1641300502;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=lT7gZsaO1E1rdk9Aixw39N/e8+yfoVrDxDLoqxzWDmI=;
  b=HsVOkjm0nVg4S3RCRLXYZSl2f83XO5O7e2dqAXWLHk+6OiYwyoMqi/XY
   xnIm5Op01ACA+I1AR434V6QIvVCLX5JZ6MBQFi8EUvQp03KQJNIIgm3zv
   7acHWVF97SYQSki09KmXIluwYLXX8WDI4/FhCbrGyrazHh7ZImcV5iCmZ
   r8wG4jy2Pppn6MyVm8b3LTvy3bTJYIgUZ0lxgFBvoEVjx8Kq1ydwc7ccY
   7mtyJ6a98S3sr7cRAR21iHAOLeA8PrBUOMM/pxdhDTL43jvnV3/EafxTM
   6gpKMOY+yIl7Gg058qAxImhncMFocNfo2fB4K+g/IFnuGTTIyBy8kvLyr
   A==;
IronPort-SDR: ryQfaLyUgE9/LIGC4+8Z8zX6zyskNahgjTqxo4FK+74kz8IYEQu4Opp1ddqYUPJiKTKURFNcpG
 k1s046zrkJSeEw+M7pAl8LOjaQoWBShSvLelekA3lQ68g9A2JGTKH5ABudXVD8iXWDKu63sbgI
 2Fb2npOHtW64AJadUfHm9RhK34KI/wjGFhGPbCYsUatRb3kOQH33bKtCFZoUMi7vUF+jfGQZAZ
 DNtWum1h23NojpXgjiAkcqdiwT0i9TI5geNmlx6gAAgmHC8o/54ExoAx/Frf/DedoDItJ1cdR4
 G+8=
X-IronPort-AV: E=Sophos;i="5.78,474,1599494400"; 
   d="scan'208";a="157682311"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 20:47:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gK2kO0cNkqgQjeBwwbIki4VfDVlS1X3kGP671B5ITdrhkJKORY/cA+fqrMhzfhl4gji8nKcM+W1aSBeWGwpZWQK5eQq+pGCklME/0ifp5O3NiSCwinc7p/JmjwuSFhhCTfdZx5ux6vOTmIQujektIAY81jKRfzt5WxoNJgV8jc3saK16lLz5wim5zfM1l6k9RHpINwNPPOX1H0mBNEsym9trciKnhS0879uZV0sYaSwkRJZgdGsljVd3xzuGDXw1CEifISB+BnrTg0/iWvzCfV7iZdcJb2LFjmObnAzz3auXoboasysfjOVvhZh7Q6vYziaeHiFWOJ6ou2U4AaC4aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1Rgduml+ewGksjFW7gD25GDYcw3uG6fPBwP1mT7ocQ=;
 b=eDBHUJ8Kr5X5JNI0pZykyEnrI8bqy4zEY1930e8NvjAaglECgOaCMN8hYwMCplcIGZ1iBByGDBPgzmjp95XGD70jwaIAuhTE+8isKXlkkSd++09v+1gTnK0DHiCWTyKUbU9mNY97wU5SYYsgyogtMnpB3r74C2mNMzpTcP5LC38K09urx280n2sBt7Tzob59uKmVpw32TMPilLn9fBL37rrarkcvdYtg/y5nc+O5rgccX4WbtpVa2EBz/5SA7tVM6pF8iDEaCwJQlc6ME+luTht/wfyHjASwiQ5qGz/Yhlt/0KGHtnzzettOgcRvGTq4lTGSD0XZ3T82KLMTqsnZFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1Rgduml+ewGksjFW7gD25GDYcw3uG6fPBwP1mT7ocQ=;
 b=yGc2f0XNdpkaN7j+uVa3ugtqJSUf37QQlUxIFipuUjcJG+gObQwrBuEkx4CCb/oVtXcBIlPOg+GaddNt1i1c6/p5nna320/Dfy42xV2xH0v1+XDoh2AJnFU5Wib9ao5iikKoZmeknoVmMV5w0lzNVzfssoKGjE7ihpT0B9gsuGQ=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB4612.namprd04.prod.outlook.com (2603:10b6:208:47::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Mon, 4 Jan
 2021 12:47:11 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 12:47:11 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
CC:     "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "selvajove@gmail.com" <selvajove@gmail.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC PATCH v4 2/3] block: add simple copy support
Thread-Topic: [RFC PATCH v4 2/3] block: add simple copy support
Thread-Index: AQHW4ocZGQHbBBU/JES2xoCYHwM80A==
Date:   Mon, 4 Jan 2021 12:47:11 +0000
Message-ID: <BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
 <CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
 <20210104104159.74236-3-selvakuma.s1@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:4d2:96cc:b27d:4f9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a00fc8d3-18d2-4d26-fdcd-08d8b0aedafd
x-ms-traffictypediagnostic: BL0PR04MB4612:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB4612C28EFF1470A6CBBA755BE7D20@BL0PR04MB4612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MbOZiEO1wAR/IrJmIQH55XpV1fJ5yZIORDy5qo3uQXBtvL673Vi3zVAwHzqgJyWitReW/HrNi30V1pK3QiNCMnLvpPQP//eU2B9ug5QI140Lb30E9vkKEMCTStQ85BB3fNtPj+fRqIukZAKdy0R/g2sWWa92sgjJIKUt5muwZAf/cKcwuTN79NY7nLHsT/8fwPTOaFBkibOyxk5fRYdqC+zTfOsXB76C0x1CZGW9qb5e5JvL5M75BpQSwlvzUPvX0UHtzQAbFO+9FCrSEWWSrGmkX/C/z+xoEK4VWWCZlguvgEnrPf3uVFiDIb9rgoXOY2+NkUbQVn7TQui2femD8KHKf+rZCG3igj4Wbfh0djc79HD17t5Nw/6kJDUtQbtCu3Awi3Ln6SttH1dn/6EK1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(6506007)(33656002)(66946007)(66556008)(83380400001)(86362001)(53546011)(2906002)(66476007)(110136005)(4326008)(7416002)(478600001)(52536014)(5660300002)(54906003)(71200400001)(186003)(66446008)(9686003)(8936002)(30864003)(76116006)(8676002)(64756008)(91956017)(7696005)(316002)(55016002)(66574015)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?p3YMngy2QtvS65DJ3nE45Qx6gkfBHFHdFKpqpzBVuNJ2XsUV/WlAv9Z4j5?=
 =?iso-8859-1?Q?jY4yNCYxygQEnU3iFblf5zz6n56vnYPnxtTu5rX9gYAdLKhT8HQnQ0N9Bv?=
 =?iso-8859-1?Q?kdI6WiAHF9AWaOHAWgwELwuvKH7+CNu5Tm2WpakE6D31WrtKz/SbHeTuVF?=
 =?iso-8859-1?Q?Z7NRnzDG7OQSIfnlfPpTbeJwSEd6OQIy5dUyh9FcztOS5dF5RsqxMimdig?=
 =?iso-8859-1?Q?YRZfFb3chc6LBK/RGVyqy9jKe9pL9GNBTWy7/3tMOGQySUTfTbt7OvqfeC?=
 =?iso-8859-1?Q?Q4b6Cf2etQuq9nRanPRtwgTpUhXd8r+qao9MnDOhPtkQsLzSwVbySXYYob?=
 =?iso-8859-1?Q?BDItphtiq4rRwXxWO2s0A5tX4aWiE4eYvoKfl82OAvmw4qPw3dF0kcX6ZT?=
 =?iso-8859-1?Q?mGO+f+KQjf0l9pvOfrulswCyzjbrjkeE699IwWnYpbbtdkNhRVYIRkIxIN?=
 =?iso-8859-1?Q?3pEjxkwGOkweVvgozVw8839dg4AxBlCIbaZJjk5/2Z2MtxGqGja5AfKhqP?=
 =?iso-8859-1?Q?oeNCRtLsKC+cBLxxAAdNve9JH7WahjAf03bDoWNsEbzsiAhPnWWRj0Brp4?=
 =?iso-8859-1?Q?eD2AO7m4D9hI6yPzfeM7g8a9m/GwHJYA7gpFj1YbH4sqV+jXmh/OLJ+H95?=
 =?iso-8859-1?Q?+BUDD8+edX7mU8q45YQcB6+yEvjUARIwoYI/M+i1N54E+1f996cQgqvd7a?=
 =?iso-8859-1?Q?WwkUsMrL/XJJAmwjOSa5784irSdyV2a1IBC2LDKl9l6cE9I06W9/mAof7y?=
 =?iso-8859-1?Q?zUQPtSR8tybbrnpIVHntei1Ngj/8IiIbcY020QAje7XzdZxzivveWIQxmC?=
 =?iso-8859-1?Q?lGtot7uGBkxX8Zs4KGq53Bi8ViJRMT8s8JdPlJ1G90CpPXT9DWk9V856SY?=
 =?iso-8859-1?Q?vttUErB1JXs9384/cQ/emMTNp/tbOz3x9SdRCJrrviBFX6/42xujt83j+7?=
 =?iso-8859-1?Q?qpjMktSgdRGTempcO3j+Bm6RkJHOdzz+MTubv5XS31mngF6bd6a3zQq+OV?=
 =?iso-8859-1?Q?ikyoPePdXm+6Yli2rZqtqI5CCG2TZyWkRFO4CEkifVe7o2hcCJz8Q5J7A9?=
 =?iso-8859-1?Q?YXVPpHzzubXyiVvWwxwncezqAp5FIpBVw6B8zQ+vjYhM?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a00fc8d3-18d2-4d26-fdcd-08d8b0aedafd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 12:47:11.6995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T2XIryl4kelYWH2ZfRsH2h+EwZm4i4kLbRd+0NRY4tD4ZMYA2vZ+ZmxlUk//qC47fCOpN6ga+kA/enfhpQM6hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4612
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/04 19:48, SelvaKumar S wrote:=0A=
> Add new BLKCOPY ioctl that offloads copying of one or more sources=0A=
> ranges to a destination in the device. Accepts copy_ranges that contains=
=0A=
> destination, no of sources and pointer to the array of source=0A=
> ranges. Each range_entry contains start and length of source=0A=
> ranges (in bytes).=0A=
> =0A=
> Introduce REQ_OP_COPY, a no-merge copy offload operation. Create=0A=
> bio with control information as payload and submit to the device.=0A=
> REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted=0A=
> to zoned device.=0A=
> =0A=
> If the device doesn't support copy or copy offload is disabled, then=0A=
> copy is emulated by allocating memory of total copy size. The source=0A=
> ranges are read into memory by chaining bio for each source ranges and=0A=
> submitting them async and the last bio waits for completion. After data=
=0A=
> is read, it is written to the destination.=0A=
> =0A=
> bio_map_kern() is used to allocate bio and add pages of copy buffer to=0A=
> bio. As bio->bi_private and bio->bi_end_io is needed for chaining the=0A=
> bio and over written, invalidate_kernel_vmap_range() for read is called=
=0A=
> in the caller.=0A=
> =0A=
> Introduce queue limits for simple copy and other helper functions.=0A=
> Add device limits as sysfs entries.=0A=
> 	- copy_offload=0A=
> 	- max_copy_sectors=0A=
> 	- max_copy_ranges_sectors=0A=
> 	- max_copy_nr_ranges=0A=
> =0A=
> copy_offload(=3D 0) is disabled by default.=0A=
> max_copy_sectors =3D 0 indicates the device doesn't support native copy.=
=0A=
> =0A=
> Native copy offload is not supported for stacked devices and is done via=
=0A=
> copy emulation.=0A=
> =0A=
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
> Signed-off-by: Javier Gonz=E1lez <javier.gonz@samsung.com>=0A=
> ---=0A=
>  block/blk-core.c          |  94 ++++++++++++++--=0A=
>  block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++=
=0A=
>  block/blk-merge.c         |   2 +=0A=
>  block/blk-settings.c      |  10 ++=0A=
>  block/blk-sysfs.c         |  50 +++++++++=0A=
>  block/blk-zoned.c         |   1 +=0A=
>  block/bounce.c            |   1 +=0A=
>  block/ioctl.c             |  43 ++++++++=0A=
>  include/linux/bio.h       |   1 +=0A=
>  include/linux/blk_types.h |  15 +++=0A=
>  include/linux/blkdev.h    |  13 +++=0A=
>  include/uapi/linux/fs.h   |  13 +++=0A=
>  12 files changed, 458 insertions(+), 8 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-core.c b/block/blk-core.c=0A=
> index 96e5fcd7f071..4a5cd3f53cd2 100644=0A=
> --- a/block/blk-core.c=0A=
> +++ b/block/blk-core.c=0A=
> @@ -719,6 +719,17 @@ static noinline int should_fail_bio(struct bio *bio)=
=0A=
>  }=0A=
>  ALLOW_ERROR_INJECTION(should_fail_bio, ERRNO);=0A=
>  =0A=
> +static inline int bio_check_copy_eod(struct bio *bio, sector_t start,=0A=
> +		sector_t nr_sectors, sector_t maxsector)=0A=
> +{=0A=
> +	if (nr_sectors && maxsector &&=0A=
> +	    (nr_sectors > maxsector || start > maxsector - nr_sectors)) {=0A=
> +		handle_bad_sector(bio, maxsector);=0A=
> +		return -EIO;=0A=
> +	}=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * Check whether this bio extends beyond the end of the device or partit=
ion.=0A=
>   * This may well happen - the kernel calls bread() without checking the =
size of=0A=
> @@ -737,6 +748,65 @@ static inline int bio_check_eod(struct bio *bio, sec=
tor_t maxsector)=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * Check for copy limits and remap source ranges if needed.=0A=
> + */=0A=
> +static int blk_check_copy(struct bio *bio)=0A=
> +{=0A=
> +	struct block_device *p =3D NULL;=0A=
> +	struct request_queue *q =3D bio->bi_disk->queue;=0A=
> +	struct blk_copy_payload *payload;=0A=
> +	int i, maxsector, start_sect =3D 0, ret =3D -EIO;=0A=
> +	unsigned short nr_range;=0A=
> +=0A=
> +	rcu_read_lock();=0A=
> +=0A=
> +	p =3D __disk_get_part(bio->bi_disk, bio->bi_partno);=0A=
> +	if (unlikely(!p))=0A=
> +		goto out;=0A=
> +	if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))=0A=
> +		goto out;=0A=
> +	if (unlikely(bio_check_ro(bio, p)))=0A=
> +		goto out;=0A=
> +=0A=
> +	maxsector =3D  bdev_nr_sectors(p);=0A=
> +	start_sect =3D p->bd_start_sect;=0A=
> +=0A=
> +	payload =3D bio_data(bio);=0A=
> +	nr_range =3D payload->copy_range;=0A=
> +=0A=
> +	/* cannot handle copy crossing nr_ranges limit */=0A=
> +	if (payload->copy_range > q->limits.max_copy_nr_ranges)=0A=
> +		goto out;=0A=
=0A=
If payload->copy_range indicates the number of ranges to be copied, you sho=
uld=0A=
name it payload->copy_nr_ranges.=0A=
=0A=
> +=0A=
> +	/* cannot handle copy more than copy limits */=0A=
=0A=
Why ? You could loop... Similarly to discard, zone reset etc.=0A=
=0A=
> +	if (payload->copy_size > q->limits.max_copy_sectors)=0A=
> +		goto out;=0A=
=0A=
Shouldn't the list of source ranges give the total size to be copied ?=0A=
Otherwise, if payload->copy_size is user provided, you would need to check =
that=0A=
the sum of the source ranges actually is equal to copy_size, no ? That mean=
s=0A=
that dropping copy_size sound like the right thing to do here.=0A=
=0A=
> +=0A=
> +	/* check if copy length crosses eod */=0A=
> +	if (unlikely(bio_check_copy_eod(bio, bio->bi_iter.bi_sector,=0A=
> +					payload->copy_size, maxsector)))=0A=
> +		goto out;=0A=
> +	bio->bi_iter.bi_sector +=3D start_sect;=0A=
> +=0A=
> +	for (i =3D 0; i < nr_range; i++) {=0A=
> +		if (unlikely(bio_check_copy_eod(bio, payload->range[i].src,=0A=
> +					payload->range[i].len, maxsector)))=0A=
> +			goto out;=0A=
> +=0A=
> +		/* single source range length limit */=0A=
> +		if (payload->range[i].src > q->limits.max_copy_range_sectors)=0A=
> +			goto out;=0A=
> +		payload->range[i].src +=3D start_sect;=0A=
> +	}=0A=
> +=0A=
> +	bio->bi_partno =3D 0;=0A=
> +	ret =3D 0;=0A=
> +out:=0A=
> +	rcu_read_unlock();=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * Remap block n of partition p to block n+start(p) of the disk.=0A=
>   */=0A=
> @@ -826,14 +896,16 @@ static noinline_for_stack bool submit_bio_checks(st=
ruct bio *bio)=0A=
>  	if (should_fail_bio(bio))=0A=
>  		goto end_io;=0A=
>  =0A=
> -	if (bio->bi_partno) {=0A=
> -		if (unlikely(blk_partition_remap(bio)))=0A=
> -			goto end_io;=0A=
> -	} else {=0A=
> -		if (unlikely(bio_check_ro(bio, bio->bi_disk->part0)))=0A=
> -			goto end_io;=0A=
> -		if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk))))=0A=
> -			goto end_io;=0A=
> +	if (likely(!op_is_copy(bio->bi_opf))) {=0A=
> +		if (bio->bi_partno) {=0A=
> +			if (unlikely(blk_partition_remap(bio)))=0A=
> +				goto end_io;=0A=
> +		} else {=0A=
> +			if (unlikely(bio_check_ro(bio, bio->bi_disk->part0)))=0A=
> +				goto end_io;=0A=
> +			if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk))))=0A=
> +				goto end_io;=0A=
> +		}=0A=
>  	}=0A=
>  =0A=
>  	/*=0A=
> @@ -857,6 +929,12 @@ static noinline_for_stack bool submit_bio_checks(str=
uct bio *bio)=0A=
>  		if (!blk_queue_discard(q))=0A=
>  			goto not_supported;=0A=
>  		break;=0A=
> +	case REQ_OP_COPY:=0A=
> +		if (!blk_queue_copy(q))=0A=
> +			goto not_supported;=0A=
=0A=
This check could be inside blk_check_copy(). In any case, since you added t=
he=0A=
read-write emulation, why are you even checking this ? That will prevent th=
e use=0A=
of the read-write emulation for devices that lack the simple copy support, =
no ?=0A=
=0A=
> +		if (unlikely(blk_check_copy(bio)))=0A=
> +			goto end_io;=0A=
> +		break;=0A=
>  	case REQ_OP_SECURE_ERASE:=0A=
>  		if (!blk_queue_secure_erase(q))=0A=
>  			goto not_supported;=0A=
> diff --git a/block/blk-lib.c b/block/blk-lib.c=0A=
> index 752f9c722062..4c0f12e2ed7c 100644=0A=
> --- a/block/blk-lib.c=0A=
> +++ b/block/blk-lib.c=0A=
> @@ -150,6 +150,229 @@ int blkdev_issue_discard(struct block_device *bdev,=
 sector_t sector,=0A=
>  }=0A=
>  EXPORT_SYMBOL(blkdev_issue_discard);=0A=
>  =0A=
> +int blk_copy_offload(struct block_device *bdev, struct blk_copy_payload =
*payload,=0A=
> +		sector_t dest, gfp_t gfp_mask)=0A=
> +{=0A=
> +	struct bio *bio;=0A=
> +	int ret, total_size;=0A=
> +=0A=
> +	bio =3D bio_alloc(gfp_mask, 1);=0A=
> +	bio->bi_iter.bi_sector =3D dest;=0A=
> +	bio->bi_opf =3D REQ_OP_COPY | REQ_NOMERGE;=0A=
> +	bio_set_dev(bio, bdev);=0A=
> +=0A=
> +	total_size =3D struct_size(payload, range, payload->copy_range);=0A=
> +	ret =3D bio_add_page(bio, virt_to_page(payload), total_size,=0A=
=0A=
How is payload allocated ? If it is a structure on-stack in the caller, I a=
m not=0A=
sure it would be wise to do an IO using the thread stack page...=0A=
=0A=
> +					   offset_in_page(payload));=0A=
> +	if (ret !=3D total_size) {=0A=
> +		ret =3D -ENOMEM;=0A=
> +		bio_put(bio);=0A=
> +		goto err;=0A=
> +	}=0A=
> +=0A=
> +	ret =3D submit_bio_wait(bio);=0A=
> +err:=0A=
> +	bio_put(bio);=0A=
> +	return ret;=0A=
> +=0A=
> +}=0A=
> +=0A=
> +int blk_read_to_buf(struct block_device *bdev, struct blk_copy_payload *=
payload,=0A=
> +		gfp_t gfp_mask, void **buf_p)=0A=
> +{=0A=
> +	struct request_queue *q =3D bdev_get_queue(bdev);=0A=
> +	struct bio *bio, *parent =3D NULL;=0A=
> +	void *buf =3D NULL;=0A=
> +	bool is_vmalloc;=0A=
> +	int i, nr_srcs, copy_len, ret, cur_size, t_len =3D 0;=0A=
> +=0A=
> +	nr_srcs =3D payload->copy_range;=0A=
> +	copy_len =3D payload->copy_size << SECTOR_SHIFT;=0A=
> +=0A=
> +	buf =3D kvmalloc(copy_len, gfp_mask);=0A=
> +	if (!buf)=0A=
> +		return -ENOMEM;=0A=
> +	is_vmalloc =3D is_vmalloc_addr(buf);=0A=
> +=0A=
> +	for (i =3D 0; i < nr_srcs; i++) {=0A=
> +		cur_size =3D payload->range[i].len << SECTOR_SHIFT;=0A=
> +=0A=
> +		bio =3D bio_map_kern(q, buf + t_len, cur_size, gfp_mask);=0A=
> +		if (IS_ERR(bio)) {=0A=
> +			ret =3D PTR_ERR(bio);=0A=
> +			goto out;=0A=
> +		}=0A=
> +=0A=
> +		bio->bi_iter.bi_sector =3D payload->range[i].src;=0A=
> +		bio->bi_opf =3D REQ_OP_READ;=0A=
> +		bio_set_dev(bio, bdev);=0A=
> +		bio->bi_end_io =3D NULL;=0A=
> +		bio->bi_private =3D NULL;=0A=
> +=0A=
> +		if (parent) {=0A=
> +			bio_chain(parent, bio);=0A=
> +			submit_bio(parent);=0A=
> +		}=0A=
> +=0A=
> +		parent =3D bio;=0A=
> +		t_len +=3D cur_size;=0A=
> +	}=0A=
> +=0A=
> +	ret =3D submit_bio_wait(bio);=0A=
> +	bio_put(bio);=0A=
> +	if (is_vmalloc)=0A=
> +		invalidate_kernel_vmap_range(buf, copy_len);=0A=
> +	if (ret)=0A=
> +		goto out;=0A=
> +=0A=
> +	*buf_p =3D buf;=0A=
> +	return 0;=0A=
> +out:=0A=
> +	kvfree(buf);=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
> +int blk_write_from_buf(struct block_device *bdev, void *buf, sector_t de=
st,=0A=
> +		int copy_len, gfp_t gfp_mask)=0A=
> +{=0A=
> +	struct request_queue *q =3D bdev_get_queue(bdev);=0A=
> +	struct bio *bio;=0A=
> +	int ret;=0A=
> +=0A=
> +	bio =3D bio_map_kern(q, buf, copy_len, gfp_mask);=0A=
> +	if (IS_ERR(bio)) {=0A=
> +		ret =3D PTR_ERR(bio);=0A=
> +		goto out;=0A=
> +	}=0A=
> +	bio_set_dev(bio, bdev);=0A=
> +	bio->bi_opf =3D REQ_OP_WRITE;=0A=
> +	bio->bi_iter.bi_sector =3D dest;=0A=
> +=0A=
> +	bio->bi_end_io =3D NULL;=0A=
> +	ret =3D submit_bio_wait(bio);=0A=
> +	bio_put(bio);=0A=
> +out:=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
> +int blk_prepare_payload(struct block_device *bdev, int nr_srcs, struct r=
ange_entry *rlist,=0A=
> +		gfp_t gfp_mask, struct blk_copy_payload **payload_p)=0A=
> +{=0A=
> +=0A=
> +	struct request_queue *q =3D bdev_get_queue(bdev);=0A=
> +	struct blk_copy_payload *payload;=0A=
> +	sector_t bs_mask;=0A=
> +	sector_t src_sects, len =3D 0, total_len =3D 0;=0A=
> +	int i, ret, total_size;=0A=
> +=0A=
> +	if (!q)=0A=
> +		return -ENXIO;=0A=
> +=0A=
> +	if (!nr_srcs)=0A=
> +		return -EINVAL;=0A=
> +=0A=
> +	if (bdev_read_only(bdev))=0A=
> +		return -EPERM;=0A=
> +=0A=
> +	bs_mask =3D (bdev_logical_block_size(bdev) >> 9) - 1;=0A=
> +=0A=
> +	total_size =3D struct_size(payload, range, nr_srcs);=0A=
> +	payload =3D kmalloc(total_size, gfp_mask);=0A=
> +	if (!payload)=0A=
> +		return -ENOMEM;=0A=
=0A=
OK. So this is what goes into the bio. The function blk_copy_offload() assu=
mes=0A=
this is at most one page, so total_size <=3D PAGE_SIZE. Where is that check=
ed ?=0A=
=0A=
> +=0A=
> +	for (i =3D 0; i < nr_srcs; i++) {=0A=
> +		/*  copy payload provided are in bytes */=0A=
> +		src_sects =3D rlist[i].src;=0A=
> +		if (src_sects & bs_mask) {=0A=
> +			ret =3D  -EINVAL;=0A=
> +			goto err;=0A=
> +		}=0A=
> +		src_sects =3D src_sects >> SECTOR_SHIFT;=0A=
> +=0A=
> +		if (len & bs_mask) {=0A=
> +			ret =3D -EINVAL;=0A=
> +			goto err;=0A=
> +		}=0A=
> +=0A=
> +		len =3D rlist[i].len >> SECTOR_SHIFT;=0A=
> +=0A=
> +		total_len +=3D len;=0A=
> +=0A=
> +		WARN_ON_ONCE((src_sects << 9) > UINT_MAX);=0A=
> +=0A=
> +		payload->range[i].src =3D src_sects;=0A=
> +		payload->range[i].len =3D len;=0A=
> +	}=0A=
> +=0A=
> +	/* storing # of source ranges */=0A=
> +	payload->copy_range =3D i;=0A=
> +	/* storing copy len so far */=0A=
> +	payload->copy_size =3D total_len;=0A=
=0A=
The comments here make the code ugly. Rename the variables and structure fi=
elds=0A=
to have something self explanatory.=0A=
=0A=
> +=0A=
> +	*payload_p =3D payload;=0A=
> +	return 0;=0A=
> +err:=0A=
> +	kfree(payload);=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
> +/**=0A=
> + * blkdev_issue_copy - queue a copy=0A=
> + * @bdev:       source block device=0A=
> + * @nr_srcs:	number of source ranges to copy=0A=
> + * @rlist:	array of source ranges (in bytes)=0A=
> + * @dest_bdev:	destination block device=0A=
> + * @dest:	destination (in bytes)=0A=
> + * @gfp_mask:   memory allocation flags (for bio_alloc)=0A=
> + *=0A=
> + * Description:=0A=
> + *	Copy array of source ranges from source block device to=0A=
> + *	destination block devcie.=0A=
> + */=0A=
> +=0A=
> +=0A=
> +int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,=0A=
> +		struct range_entry *src_rlist, struct block_device *dest_bdev,=0A=
> +		sector_t dest, gfp_t gfp_mask)=0A=
> +{=0A=
> +	struct request_queue *q =3D bdev_get_queue(bdev);=0A=
> +	struct blk_copy_payload *payload;=0A=
> +	sector_t bs_mask, dest_sect;=0A=
> +	void *buf =3D NULL;=0A=
> +	int ret;=0A=
> +=0A=
> +	ret =3D blk_prepare_payload(bdev, nr_srcs, src_rlist, gfp_mask, &payloa=
d);=0A=
> +	if (ret)=0A=
> +		return ret;=0A=
> +=0A=
> +	bs_mask =3D (bdev_logical_block_size(dest_bdev) >> 9) - 1;=0A=
> +	if (dest & bs_mask) {=0A=
> +		return -EINVAL;=0A=
> +		goto out;=0A=
> +	}=0A=
> +	dest_sect =3D dest >> SECTOR_SHIFT;=0A=
=0A=
dest should already be a 512B sector as all block layer functions interface=
 use=0A=
this unit. What is this doing ?=0A=
=0A=
> +=0A=
> +	if (bdev =3D=3D dest_bdev && q->limits.copy_offload) {=0A=
> +		ret =3D blk_copy_offload(bdev, payload, dest_sect, gfp_mask);=0A=
> +		if (ret)=0A=
> +			goto out;=0A=
> +	} else {=0A=
> +		ret =3D blk_read_to_buf(bdev, payload, gfp_mask, &buf);=0A=
> +		if (ret)=0A=
> +			goto out;=0A=
> +		ret =3D blk_write_from_buf(dest_bdev, buf, dest_sect,=0A=
> +				payload->copy_size << SECTOR_SHIFT, gfp_mask);=0A=
=0A=
Arg... This is really not pretty. At the very least, this should all be in =
a=0A=
blk_copy_emulate() helper or something named like that.=0A=
=0A=
My worry though is that this likely slow for large copies, not to mention t=
hat=0A=
buf is likely to fail to allocate for large copy cases. As commented previo=
usly,=0A=
dm-kcopyd already does such copy well, with a read-write streaming pipeline=
 and=0A=
zone support too for the write side. This should really be reused, at least=
=0A=
partly, instead of re-implementing this read-write here.=0A=
=0A=
> +	}=0A=
> +=0A=
> +	if (buf)=0A=
> +		kvfree(buf);=0A=
> +out:=0A=
> +	kvfree(payload);=0A=
> +	return ret;=0A=
> +}=0A=
> +EXPORT_SYMBOL(blkdev_issue_copy);=0A=
> +=0A=
>  /**=0A=
>   * __blkdev_issue_write_same - generate number of bios with same page=0A=
>   * @bdev:	target blockdev=0A=
> diff --git a/block/blk-merge.c b/block/blk-merge.c=0A=
> index 808768f6b174..4e04f24e13c1 100644=0A=
> --- a/block/blk-merge.c=0A=
> +++ b/block/blk-merge.c=0A=
> @@ -309,6 +309,8 @@ void __blk_queue_split(struct bio **bio, unsigned int=
 *nr_segs)=0A=
>  	struct bio *split =3D NULL;=0A=
>  =0A=
>  	switch (bio_op(*bio)) {=0A=
> +	case REQ_OP_COPY:=0A=
> +			break;=0A=
>  	case REQ_OP_DISCARD:=0A=
>  	case REQ_OP_SECURE_ERASE:=0A=
>  		split =3D blk_bio_discard_split(q, *bio, &q->bio_split, nr_segs);=0A=
> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
> index 43990b1d148b..93c15ba45a69 100644=0A=
> --- a/block/blk-settings.c=0A=
> +++ b/block/blk-settings.c=0A=
> @@ -60,6 +60,10 @@ void blk_set_default_limits(struct queue_limits *lim)=
=0A=
>  	lim->io_opt =3D 0;=0A=
>  	lim->misaligned =3D 0;=0A=
>  	lim->zoned =3D BLK_ZONED_NONE;=0A=
> +	lim->copy_offload =3D 0;=0A=
> +	lim->max_copy_sectors =3D 0;=0A=
> +	lim->max_copy_nr_ranges =3D 0;=0A=
> +	lim->max_copy_range_sectors =3D 0;=0A=
>  }=0A=
>  EXPORT_SYMBOL(blk_set_default_limits);=0A=
>  =0A=
> @@ -565,6 +569,12 @@ int blk_stack_limits(struct queue_limits *t, struct =
queue_limits *b,=0A=
>  	if (b->chunk_sectors)=0A=
>  		t->chunk_sectors =3D gcd(t->chunk_sectors, b->chunk_sectors);=0A=
>  =0A=
> +	/* simple copy not supported in stacked devices */=0A=
> +	t->copy_offload =3D 0;=0A=
> +	t->max_copy_sectors =3D 0;=0A=
> +	t->max_copy_range_sectors =3D 0;=0A=
> +	t->max_copy_nr_ranges =3D 0;=0A=
> +=0A=
>  	/* Physical block size a multiple of the logical block size? */=0A=
>  	if (t->physical_block_size & (t->logical_block_size - 1)) {=0A=
>  		t->physical_block_size =3D t->logical_block_size;=0A=
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c=0A=
> index b513f1683af0..51b35a8311d9 100644=0A=
> --- a/block/blk-sysfs.c=0A=
> +++ b/block/blk-sysfs.c=0A=
> @@ -166,6 +166,47 @@ static ssize_t queue_discard_granularity_show(struct=
 request_queue *q, char *pag=0A=
>  	return queue_var_show(q->limits.discard_granularity, page);=0A=
>  }=0A=
>  =0A=
> +static ssize_t queue_copy_offload_show(struct request_queue *q, char *pa=
ge)=0A=
> +{=0A=
> +	return queue_var_show(q->limits.copy_offload, page);=0A=
> +}=0A=
> +=0A=
> +static ssize_t queue_copy_offload_store(struct request_queue *q,=0A=
> +				       const char *page, size_t count)=0A=
> +{=0A=
> +	unsigned long copy_offload;=0A=
> +	ssize_t ret =3D queue_var_store(&copy_offload, page, count);=0A=
> +=0A=
> +	if (ret < 0)=0A=
> +		return ret;=0A=
> +=0A=
> +	if (copy_offload < 0 || copy_offload > 1)=0A=
=0A=
err... "copy_offload !=3D 1" ?=0A=
=0A=
> +		return -EINVAL;=0A=
> +=0A=
> +	if (q->limits.max_copy_sectors =3D=3D 0 && copy_offload =3D=3D 1)=0A=
> +		return -EINVAL;=0A=
> +=0A=
> +	q->limits.copy_offload =3D copy_offload;=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
> +static ssize_t queue_max_copy_sectors_show(struct request_queue *q, char=
 *page)=0A=
> +{=0A=
> +	return queue_var_show(q->limits.max_copy_sectors, page);=0A=
> +}=0A=
> +=0A=
> +static ssize_t queue_max_copy_range_sectors_show(struct request_queue *q=
,=0A=
> +		char *page)=0A=
> +{=0A=
> +	return queue_var_show(q->limits.max_copy_range_sectors, page);=0A=
> +}=0A=
> +=0A=
> +static ssize_t queue_max_copy_nr_ranges_show(struct request_queue *q,=0A=
> +		char *page)=0A=
> +{=0A=
> +	return queue_var_show(q->limits.max_copy_nr_ranges, page);=0A=
> +}=0A=
> +=0A=
>  static ssize_t queue_discard_max_hw_show(struct request_queue *q, char *=
page)=0A=
>  {=0A=
>  =0A=
> @@ -591,6 +632,11 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");=0A=
>  QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");=0A=
>  QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");=0A=
>  =0A=
> +QUEUE_RW_ENTRY(queue_copy_offload, "copy_offload");=0A=
> +QUEUE_RO_ENTRY(queue_max_copy_sectors, "max_copy_sectors");=0A=
> +QUEUE_RO_ENTRY(queue_max_copy_range_sectors, "max_copy_range_sectors");=
=0A=
> +QUEUE_RO_ENTRY(queue_max_copy_nr_ranges, "max_copy_nr_ranges");=0A=
> +=0A=
>  QUEUE_RW_ENTRY(queue_nomerges, "nomerges");=0A=
>  QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");=0A=
>  QUEUE_RW_ENTRY(queue_poll, "io_poll");=0A=
> @@ -636,6 +682,10 @@ static struct attribute *queue_attrs[] =3D {=0A=
>  	&queue_discard_max_entry.attr,=0A=
>  	&queue_discard_max_hw_entry.attr,=0A=
>  	&queue_discard_zeroes_data_entry.attr,=0A=
> +	&queue_copy_offload_entry.attr,=0A=
> +	&queue_max_copy_sectors_entry.attr,=0A=
> +	&queue_max_copy_range_sectors_entry.attr,=0A=
> +	&queue_max_copy_nr_ranges_entry.attr,=0A=
>  	&queue_write_same_max_entry.attr,=0A=
>  	&queue_write_zeroes_max_entry.attr,=0A=
>  	&queue_zone_append_max_entry.attr,=0A=
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
> index 7a68b6e4300c..02069178d51e 100644=0A=
> --- a/block/blk-zoned.c=0A=
> +++ b/block/blk-zoned.c=0A=
> @@ -75,6 +75,7 @@ bool blk_req_needs_zone_write_lock(struct request *rq)=
=0A=
>  	case REQ_OP_WRITE_ZEROES:=0A=
>  	case REQ_OP_WRITE_SAME:=0A=
>  	case REQ_OP_WRITE:=0A=
> +	case REQ_OP_COPY:=0A=
>  		return blk_rq_zone_is_seq(rq);=0A=
>  	default:=0A=
>  		return false;=0A=
> diff --git a/block/bounce.c b/block/bounce.c=0A=
> index d3f51acd6e3b..5e052afe8691 100644=0A=
> --- a/block/bounce.c=0A=
> +++ b/block/bounce.c=0A=
> @@ -254,6 +254,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_s=
rc, gfp_t gfp_mask,=0A=
>  	bio->bi_iter.bi_size	=3D bio_src->bi_iter.bi_size;=0A=
>  =0A=
>  	switch (bio_op(bio)) {=0A=
> +	case REQ_OP_COPY:=0A=
>  	case REQ_OP_DISCARD:=0A=
>  	case REQ_OP_SECURE_ERASE:=0A=
>  	case REQ_OP_WRITE_ZEROES:=0A=
> diff --git a/block/ioctl.c b/block/ioctl.c=0A=
> index d61d652078f4..d50b6abe2883 100644=0A=
> --- a/block/ioctl.c=0A=
> +++ b/block/ioctl.c=0A=
> @@ -133,6 +133,47 @@ static int blk_ioctl_discard(struct block_device *bd=
ev, fmode_t mode,=0A=
>  				    GFP_KERNEL, flags);=0A=
>  }=0A=
>  =0A=
> +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,=0A=
> +		unsigned long arg)=0A=
> +{=0A=
> +	struct copy_range crange;=0A=
> +	struct range_entry *rlist;=0A=
> +	struct request_queue *q =3D bdev_get_queue(bdev);=0A=
> +	sector_t dest;=0A=
> +	int ret;=0A=
> +=0A=
> +	if (!(mode & FMODE_WRITE))=0A=
> +		return -EBADF;=0A=
> +=0A=
> +	if (!blk_queue_copy(q))=0A=
> +		return -EOPNOTSUPP;=0A=
=0A=
But you added the read-write emulation. So what is the point here ? This io=
ctl=0A=
should work for any device, with or without simple copy support. Did you te=
st that ?=0A=
=0A=
> +=0A=
> +	if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))=0A=
> +		return -EFAULT;=0A=
> +=0A=
> +	if (crange.dest & ((1 << SECTOR_SHIFT) - 1))=0A=
> +		return -EFAULT;=0A=
> +	dest =3D crange.dest;=0A=
> +=0A=
> +	rlist =3D kmalloc_array(crange.nr_range, sizeof(*rlist),=0A=
> +			GFP_KERNEL);=0A=
> +=0A=
=0A=
Unnecessary blank line here.=0A=
=0A=
> +	if (!rlist)=0A=
> +		return -ENOMEM;=0A=
> +=0A=
> +	if (copy_from_user(rlist, (void __user *)crange.range_list,=0A=
> +				sizeof(*rlist) * crange.nr_range)) {=0A=
> +		ret =3D -EFAULT;=0A=
> +		goto out;=0A=
> +	}=0A=
> +=0A=
> +	ret =3D blkdev_issue_copy(bdev, crange.nr_range, rlist, bdev, dest,=0A=
> +			GFP_KERNEL);=0A=
> +out:=0A=
> +	kfree(rlist);=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
>  static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,=0A=
>  		unsigned long arg)=0A=
>  {=0A=
> @@ -458,6 +499,8 @@ static int blkdev_common_ioctl(struct block_device *b=
dev, fmode_t mode,=0A=
>  	case BLKSECDISCARD:=0A=
>  		return blk_ioctl_discard(bdev, mode, arg,=0A=
>  				BLKDEV_DISCARD_SECURE);=0A=
> +	case BLKCOPY:=0A=
> +		return blk_ioctl_copy(bdev, mode, arg);=0A=
>  	case BLKZEROOUT:=0A=
>  		return blk_ioctl_zeroout(bdev, mode, arg);=0A=
>  	case BLKREPORTZONE:=0A=
> diff --git a/include/linux/bio.h b/include/linux/bio.h=0A=
> index 1edda614f7ce..164313bdfb35 100644=0A=
> --- a/include/linux/bio.h=0A=
> +++ b/include/linux/bio.h=0A=
> @@ -71,6 +71,7 @@ static inline bool bio_has_data(struct bio *bio)=0A=
>  static inline bool bio_no_advance_iter(const struct bio *bio)=0A=
>  {=0A=
>  	return bio_op(bio) =3D=3D REQ_OP_DISCARD ||=0A=
> +	       bio_op(bio) =3D=3D REQ_OP_COPY ||=0A=
>  	       bio_op(bio) =3D=3D REQ_OP_SECURE_ERASE ||=0A=
>  	       bio_op(bio) =3D=3D REQ_OP_WRITE_SAME ||=0A=
>  	       bio_op(bio) =3D=3D REQ_OP_WRITE_ZEROES;=0A=
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
> index 866f74261b3b..d4d11e9ff814 100644=0A=
> --- a/include/linux/blk_types.h=0A=
> +++ b/include/linux/blk_types.h=0A=
> @@ -380,6 +380,8 @@ enum req_opf {=0A=
>  	REQ_OP_ZONE_RESET	=3D 15,=0A=
>  	/* reset all the zone present on the device */=0A=
>  	REQ_OP_ZONE_RESET_ALL	=3D 17,=0A=
> +	/* copy ranges within device */=0A=
> +	REQ_OP_COPY		=3D 19,=0A=
>  =0A=
>  	/* SCSI passthrough using struct scsi_request */=0A=
>  	REQ_OP_SCSI_IN		=3D 32,=0A=
> @@ -506,6 +508,11 @@ static inline bool op_is_discard(unsigned int op)=0A=
>  	return (op & REQ_OP_MASK) =3D=3D REQ_OP_DISCARD;=0A=
>  }=0A=
>  =0A=
> +static inline bool op_is_copy(unsigned int op)=0A=
> +{=0A=
> +	return (op & REQ_OP_MASK) =3D=3D REQ_OP_COPY;=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * Check if a bio or request operation is a zone management operation, w=
ith=0A=
>   * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special =
case=0A=
> @@ -565,4 +572,12 @@ struct blk_rq_stat {=0A=
>  	u64 batch;=0A=
>  };=0A=
>  =0A=
> +struct blk_copy_payload {=0A=
> +	sector_t	dest;=0A=
> +	int		copy_range;=0A=
> +	int		copy_size;=0A=
> +	int		err;=0A=
> +	struct	range_entry	range[];=0A=
> +};=0A=
> +=0A=
>  #endif /* __LINUX_BLK_TYPES_H */=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 81f9e7bec16c..4c7e861e57e4 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -340,10 +340,14 @@ struct queue_limits {=0A=
>  	unsigned int		max_zone_append_sectors;=0A=
>  	unsigned int		discard_granularity;=0A=
>  	unsigned int		discard_alignment;=0A=
> +	unsigned int		copy_offload;=0A=
> +	unsigned int		max_copy_sectors;=0A=
>  =0A=
>  	unsigned short		max_segments;=0A=
>  	unsigned short		max_integrity_segments;=0A=
>  	unsigned short		max_discard_segments;=0A=
> +	unsigned short		max_copy_range_sectors;=0A=
> +	unsigned short		max_copy_nr_ranges;=0A=
>  =0A=
>  	unsigned char		misaligned;=0A=
>  	unsigned char		discard_misaligned;=0A=
> @@ -625,6 +629,7 @@ struct request_queue {=0A=
>  #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */=0A=
>  #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active =
*/=0A=
>  #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */=0A=
> +#define QUEUE_FLAG_COPY		30	/* supports copy */=0A=
=0A=
I think this should be called QUEUE_FLAG_SIMPLE_COPY to indicate more preci=
sely=0A=
the type of copy supported. SCSI XCOPY is more advanced...=0A=
=0A=
>  =0A=
>  #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\=0A=
>  				 (1 << QUEUE_FLAG_SAME_COMP) |		\=0A=
> @@ -647,6 +652,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, s=
truct request_queue *q);=0A=
>  #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_fl=
ags)=0A=
>  #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->qu=
eue_flags)=0A=
>  #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_fl=
ags)=0A=
> +#define blk_queue_copy(q)	test_bit(QUEUE_FLAG_COPY, &(q)->queue_flags)=
=0A=
>  #define blk_queue_zone_resetall(q)	\=0A=
>  	test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)=0A=
>  #define blk_queue_secure_erase(q) \=0A=
> @@ -1061,6 +1067,9 @@ static inline unsigned int blk_queue_get_max_sector=
s(struct request_queue *q,=0A=
>  		return min(q->limits.max_discard_sectors,=0A=
>  			   UINT_MAX >> SECTOR_SHIFT);=0A=
>  =0A=
> +	if (unlikely(op =3D=3D REQ_OP_COPY))=0A=
> +		return q->limits.max_copy_sectors;=0A=
> +=0A=
>  	if (unlikely(op =3D=3D REQ_OP_WRITE_SAME))=0A=
>  		return q->limits.max_write_same_sectors;=0A=
>  =0A=
> @@ -1335,6 +1344,10 @@ extern int __blkdev_issue_discard(struct block_dev=
ice *bdev, sector_t sector,=0A=
>  		sector_t nr_sects, gfp_t gfp_mask, int flags,=0A=
>  		struct bio **biop);=0A=
>  =0A=
> +extern int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,=0A=
> +		struct range_entry *src_rlist, struct block_device *dest_bdev,=0A=
> +		sector_t dest, gfp_t gfp_mask);=0A=
> +=0A=
>  #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */=0A=
>  #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes =
*/=0A=
>  =0A=
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h=0A=
> index f44eb0a04afd..5cadb176317a 100644=0A=
> --- a/include/uapi/linux/fs.h=0A=
> +++ b/include/uapi/linux/fs.h=0A=
> @@ -64,6 +64,18 @@ struct fstrim_range {=0A=
>  	__u64 minlen;=0A=
>  };=0A=
>  =0A=
> +struct range_entry {=0A=
> +	__u64 src;=0A=
> +	__u64 len;=0A=
> +};=0A=
> +=0A=
> +struct copy_range {=0A=
> +	__u64 dest;=0A=
> +	__u64 nr_range;=0A=
> +	__u64 range_list;=0A=
> +	__u64 rsvd;=0A=
> +};=0A=
> +=0A=
>  /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definit=
ions */=0A=
>  #define FILE_DEDUPE_RANGE_SAME		0=0A=
>  #define FILE_DEDUPE_RANGE_DIFFERS	1=0A=
> @@ -184,6 +196,7 @@ struct fsxattr {=0A=
>  #define BLKSECDISCARD _IO(0x12,125)=0A=
>  #define BLKROTATIONAL _IO(0x12,126)=0A=
>  #define BLKZEROOUT _IO(0x12,127)=0A=
> +#define BLKCOPY _IOWR(0x12, 128, struct copy_range)=0A=
>  /*=0A=
>   * A jump here: 130-131 are reserved for zoned block devices=0A=
>   * (see uapi/linux/blkzoned.h)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
