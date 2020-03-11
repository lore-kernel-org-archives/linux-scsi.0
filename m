Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86492C2BB1D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 18:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2341A20739
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 18:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mc+Zw1RP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NfHz5W1I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbgCKSLL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 14:11:11 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:62313 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730610AbgCKSLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 14:11:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583950304; x=1615486304;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=WVSU5k0MPOzZVHHHl8xA3mwCTCN2Uc2qFlua7Gs+dVA=;
  b=mc+Zw1RPQa4UfqGpnjpOdJTlvarTzlrxwGEURyqEtX7sw26jEhvSRmtj
   Dz9KYPtWmhc6yc+TkX3k+Kc7T1VFdLSFT70iQF3KzddMw16C4fipM4bMR
   zWYUw7d9dTVhmX/9xsznwlwyLUshQwMODk5LkLmULPYumdJuuJuk/6EFx
   wM8AWuTJEViIqu+0KIaDo6EBj02yonmpvH1J3Ra8yvMFvH8GqQr0/Tur7
   rDONLQe7Rfz0T8amt3oncU0gsjmLOFvI6BUq+VnsLEUbGGvnWdE4h/oz9
   hl2mzTnG3cnVX3z4Ced1ycMScf4iXNiq7wdpmTE+glasocRpp4eLTgdWB
   w==;
IronPort-SDR: zTfZ+tFOss8kGlIkxMoOqZGbqm0HOPftdmnLgwRI3Z32tYbkjhMthHDtnQXTEOtt/MdTGRY0Ip
 hKjthPAdmCLBKM6i/reqJRqxVbVHHoGp0lSOdazBDwAfGPBQUBbzuYDoCjPEFO/xexz/nbimvN
 OG/1yzX/b1xAgUgHQ3ptv01cMRJaK6Bfvq015HGrxim/t9uTc6f2R3uDpTuncZkw5CfuE6Dr0N
 y1JH86TMH0lwSg1Sz2CsfHBGqRc9B2drBG5itnZXqKy5G99WRITReKvRDBBjdt/QE60eaq0wso
 cQI=
X-IronPort-AV: E=Sophos;i="5.70,541,1574092800"; 
   d="scan'208";a="234249007"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2020 02:11:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huB+Y7OLmdf6eUnqv/oJX3GCHQXrlLmYv2N4/JNZpeGBF7XrLQaOgrGnNrHY8E02wgE5ZqrahqOGPNoRtplIgoKAda/OQb4Ri6gjh0OXEV+r338NId7KCVmCUqfYHQ82Db6J3fVTGG1lXrJxFIVR50aDW8+/hWuL1uiQUumN6MnfjeD6xRNoCQOC2DBLqkFdBeUJhwPZuy58KNmZAiuxabCgUzAPCjqwa/8PaJMcSYJAiWhvkCCGUon4A7o6lU7LoM9wTs4X5/eTEAphbwqJPbmTsrQvugSXO0gSEzyus8EpdgEICyNN+ViYJfJymQdtm3TKKfa/zthOE6ylAFtmNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBTwmZgnZn8wmvsKFnwOBmVsMOgTGkDjflHagM5X+U0=;
 b=FRMreufwP6+SaIKS2ARQ5ITJ8/Rg4i9+TIn1ZkwBSWajNrJtaILjiJ/itIHejWdEdF4eQqRIZ149aSgeM4ZkUYimVYFTQUuU5avz7fEuaCAitSHac/WRe+jSCyucFaeSacHJoqV5YKS/uen+Aah1PCPLaLYSJHNGVBbPxS2NvAHgIwf7NqA3eHo68ycvRSZYHZ+DXO2hF74/O+s/M/oMXzwY2xZsXmNs3KTKCInyy0povCnB2fjB714xx3kAHzqp1Xoxc77aMApis56Iz2MZsNxQhUxiw8BFHHF0FLOq5GZMWucaZwXGp5MWnLbFHGBes6EZdQ04Ijpm5QQBhQe4lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBTwmZgnZn8wmvsKFnwOBmVsMOgTGkDjflHagM5X+U0=;
 b=NfHz5W1IlS43FFbYDNhh27jcF3bPfYgOKM3ZFX6dtw52CMn3RtRA99ZqOHc5r8kl4qyPi1yY0haPNXBaaTVE9m9ax/Q1KzpK06xRCXXp2jI5H+q6tW4iUn/EsqyIvNIOlboprQc6/BfJn2+/R256IZY89umeEenIdkVkcL6iqTY=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3645.namprd04.prod.outlook.com
 (2603:10b6:803:45::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Wed, 11 Mar
 2020 18:11:08 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32%5]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 18:11:08 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/11] block: introduce bio_add_append_page
Thread-Topic: [PATCH 03/11] block: introduce bio_add_append_page
Thread-Index: AQHV9sDnu/DaGSp11E2pOuo1rZ+eKQ==
Date:   Wed, 11 Mar 2020 18:11:08 +0000
Message-ID: <SN4PR0401MB35988036A80BBC6B5162FC469BFC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-4-johannes.thumshirn@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e85cd72-f467-4022-2214-08d7c5e792be
x-ms-traffictypediagnostic: SN4PR0401MB3645:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB364595248D2ADF5FBA75B8409BFC0@SN4PR0401MB3645.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(199004)(8936002)(316002)(64756008)(66446008)(91956017)(66476007)(55016002)(6916009)(7696005)(71200400001)(9686003)(76116006)(2906002)(66556008)(66946007)(54906003)(53546011)(6506007)(186003)(86362001)(4744005)(5660300002)(52536014)(478600001)(8676002)(26005)(4326008)(33656002)(81166006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR0401MB3645;H:SN4PR0401MB3598.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P7RLS5K/xekLN5Xm255eyPbq0BmqNdIkHY3snLP80Z/zoDU4mTRHCxp/SkGwfZ//0mgvMBijBtSLJ7rC9f80+5rO7x/1BB4Z+7VxHNEH6VA7qy5z+vkyre62eFgwAFmXA/V/u7p5gYdKgyOS/PDW61WG15pAmRsgR/U1+43BGGBx+tmOMmQJONL6f1QCV8vGBT2n9+8DrkSTNIWRGC6ebMO774Z0KrXbXX7HCPmYOaemQqjuXYWR9jnc74NylpmjonOHgZwkHAYn6kJV6SHu9sSQ40IMJaa9EZHTqIHfHHNszKmxC6c13vJ7i+Wt7NCdo2Qkwo6JUucj9VJhMT018cM77JRpoTXV5fYKcRjkGgvDJf1Ay7XEO9nKso2v39beydGEjGc7C4ZzqAp8ISONTBNF8phQ/oZvk8gKU9LXj+RQC1fw1ENOQ+Nw+csfokR8
x-ms-exchange-antispam-messagedata: ohWCP6AWxvlnPS7BMAgfEnICsQc60+vKHM4zoeJt2W8q4+0xMZU11g3suutV07e4Uxbkd46hGLOEpbzY8zMU9srQJyKbbgfzKfEaHERVfZ+Phad/OLCDQoN+FKb6Nxs4q97kKW1oA0wM8ZpOYUAbxA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e85cd72-f467-4022-2214-08d7c5e792be
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 18:11:08.3957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bgkTAaoaDXXf2KJyaGdZKq27jVvrh7SfFXH3Ov1sei0BkTHp5EX2fCmbBTnALU2Z70tGQyUcKnxKKOvyoznTT7jVK3jRIuOiCPKpwlFkDQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3645
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/03/2020 10:47, Johannes Thumshirn wrote:=0A=
[...]=0A=
> @@ -945,8 +955,15 @@ static int __bio_iov_iter_get_pages(struct bio *bio,=
 struct iov_iter *iter)=0A=
>   =0A=
>   		len =3D min_t(size_t, PAGE_SIZE - offset, left);=0A=
>   =0A=
> -		if (__bio_try_merge_page(bio, page, len, offset, &same_page)) {=0A=
> -			if (same_page)=0A=
> +		if (bio_op(bio) =3D=3D REQ_OP_ZONE_APPEND) {=0A=
> +			size =3D bio_add_append_page(bio->bi_disk->queue, bio,=0A=
> +						   page, len, offset);=0A=
> +=0A=
> +			if (size !=3D len)=0A=
> +				return -E2BIG;=0A=
=0A=
=0A=
Converting zonefs/iomap to zone-append found a bug here, should've been:=0A=
=0A=
if (bio_op(bio) =3D=3D REQ_OP_ZONE_APPEND) {=0A=
	int ret;=0A=
=0A=
	ret =3D bio_add_append_page(bio->bi_disk->queue, bio,=0A=
				  page, len, offset);=0A=
	if (ret !=3D len)=0A=
		return -E2BIG;=0A=
