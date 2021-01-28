Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79E1C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9826764DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhA1FkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 00:40:06 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:49418 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhA1FkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 00:40:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611812403; x=1643348403;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=HhG9LKsdkqYoXma+OD3pZBfse78Y6uZJ3xvkLzI1qVs=;
  b=rxs/zgwb5Nj+JLz8qKfM/w26Lbt0Sun7wfN9CBnx0KMxrYs8dBdPaGov
   WjfBITw2W+9dZwQHsZnV7rqWo7IHZhcIlQ1Zo3MpUTvUdJzCNxbHBMaCm
   70w6cTjN7ZupfTjcdOZU6LKg6dWIabxFkE66U5o9beVLH694cEV57+QYj
   M0BzpeohnDphBhSdwliQAZGweG0Rm/0+rOysfGKPJEFzsjTrATa9SRhX4
   IqavLoPf8BxMHcpGn0m8E+B69LpV9MY5GMnXl+LPGnGRRQgZgQ5Dh2qxE
   FE7IGUhMCmHt12byW+k0UHo/NHbJUttv5EytD3mgvGbf8jizAjwTIvZJA
   Q==;
IronPort-SDR: TEOpnZfqnHePTHZRHyke8POpDLvOKPS6B8n87Cl2X3HeKuF23m2AKiw0oYN4fcChvlGxhl/pqx
 uhCXud7YteNuowerU1PJkjMJEXvv4izIaEc+G/LxpwkRin9p6Kq9xEQrpmJURL0SoHEJ+Os7fD
 4bJqmRjpgoS8Qu2JzCp6IFMWuKGB9Bt/pVXM4+PmELa3+qzp0FlK/KviPmtQEtPQXueO80X0iU
 ercUAk3btB9i9fGxgqfpWw6H2NFSBcEMYVCiXErFJeyoL/PqrMA5vna+Nkt4IYEgzNyR3zTy/f
 RvE=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="268886271"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 13:38:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCTsUEdpnRsKiXMSK2V3AKJ80jZ0hM/HiNkqGfqAL88Kjoay5Bhge27ih9j2Orf9WEPUKZLF7h8ZrxEc6S1RJCCY1F4HhR9WCCoyiAYF9Pvxc9odedjWqqLKrRG9MiZFGuMfbGi6McKgl6b49rZMfPW4sZGXBIm+oHsdX5kVnA4as4vbMFMDe2/FEyU1Vqo4LiwEXZQCwTo4drXw4HFXGxTsSJrZeDT/LhP9u0zh6ZlfQL39cvGqhIZ/Zuzl21ju1om/FZmKSYqwytbftcZiemRJPZ2L8qxruy6VLlIhPDkfg9Q2po9GZBgwpQ+UQ0MshWzAi5rsWDhLdp9F+lWGxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZGbeGlyw/3Fl4jr2zCW47FdSOv4keCnCVqvmAvS2HM=;
 b=UdxGTZCGqBembyZzYNv1R0NN8F1ZksBKXsQ4/nMsEh4zHrypVO7drikCrPboyXZ6ddGfBT5zcTKd/jjWIAVh4r0wbs+DjvEPO8o9+dbHZYR/CQgtfAJfQbUFhvLPwnnwMIbFOHqigeXhGYNKNgZTwS1shyiyql1S8YdPbq+yQJfh3MYgtzETBiR8klkbT97z+D5uGcHVLmbh0tJwS9V/Et8jdSlXlO+1AIlvqFx0W8Vs/YccG0bWt/8/B78fLNMrshZW6RerrxtvMJEwueewc+T6TsHukrINbsBz1pJtIYB7AkSMHaWLzHvbsPTeiIOODzEql1SnSb5aMpCmeHmQWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZGbeGlyw/3Fl4jr2zCW47FdSOv4keCnCVqvmAvS2HM=;
 b=k467QEdvW90cSCTRdj4qINn3mpsk2KtB57b571FWj3jIoBfDac/Zux3fjldwCVA/2oVM0YMr9nY4NVZ+tY+E6AqUJA4WmgtaV1qK6v1hNS5m+OLfYJm0O1H/jzmkh9gVToUhRkZ8DWEqjgDPC3x5RVPcWYZcIfWm09Q6qt770/4=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7390.namprd04.prod.outlook.com (2603:10b6:a03:293::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Thu, 28 Jan
 2021 05:38:55 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3784.016; Thu, 28 Jan 2021
 05:38:55 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v4 8/8] sd_zbc: clear zone resources for non-zoned case
Thread-Topic: [PATCH v4 8/8] sd_zbc: clear zone resources for non-zoned case
Thread-Index: AQHW9TC+BUxJe+ZTzEeR0bRrNuapqQ==
Date:   Thu, 28 Jan 2021 05:38:55 +0000
Message-ID: <BYAPR04MB49655B5B6075B83CEFE57C6D86BA9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-9-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d12d4289-dd3f-43ac-c8a3-08d8c34f00c9
x-ms-traffictypediagnostic: SJ0PR04MB7390:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB739001171C3E69AF737D101F86BA9@SJ0PR04MB7390.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i1aGZXdatK8+PdE2Aix3m4oBbEYxpqPiTqErDW61JgcPZpXCF0FdQkzfFf26O9SMHqTSlr+b/yzEsDaM+z3+8AxzMX2fdM4fBGscxnAxGw+LN7ZWrhUcH7nb3gwfqwCc845ugiZpakqtPa48xCz794LPKlEvO31CBaVNWQq2sYOFR2r8q9pKl/oq+X5ceLA5sbYbwzCzLrhFVu6+vTaDRsQNznH6QaKf6QfEBekyNOrrG3wsAq6TO5XjdnVyvchn6Mr30ru4gfAYmWqUjyuOK/V7/JQgS0tQgopFqANlDo1dCC9ECeelBon6pn9WQsGar1rQYN6WfxW288eLZ3946amCHvCpQp24mRB6lhiVt1NvnDFCQLh/zubSO97gNT4XwaBa4mkrKNU1lYfO0FYdHGYLGnB/HnYMEtcZLaUxd+qXZNNZkPwkxnK+kkcVbanSX2N5x9rwM+pbybJxDuP+RvLBa9vyQ5638uuv/oC9G25ErPMylw/Kf4kba4fD/m5TM91htYL6J+ViwJ+wMccWag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(76116006)(4326008)(91956017)(5660300002)(316002)(2906002)(55016002)(52536014)(83380400001)(66946007)(66446008)(64756008)(53546011)(6506007)(66476007)(66556008)(54906003)(71200400001)(186003)(9686003)(8676002)(110136005)(7696005)(478600001)(86362001)(26005)(8936002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cAzk6R6YVJwXSs2jB3buiI672R1X/kPx9VohDykKo75GtukVnObXo/rMsHtd?=
 =?us-ascii?Q?g3ESuEAxMVU4o3LwlV5Ue5AzN2DUfwQbVlix37ltAETrd7CT26l5KvIzj2Fd?=
 =?us-ascii?Q?bxF4BGeZ7kjfB1IAJh7ak8pRhpM7iZa3tl6BkYllroDTR5ByKuAbqAgz9oHM?=
 =?us-ascii?Q?IH/JANI1LhKFyRrXRDY/UC1u27pmAlRW3mGaguYxusYNjHJpd5btuZKFXTVl?=
 =?us-ascii?Q?63xpY6H7CsrCJs83fBefRzBk2AMQxTYko/pwAmpFNpEU6//vsbdfp1BDDEsT?=
 =?us-ascii?Q?ACTUZlV9MKCRJMYUPXj5OtzzxGgls5YV3XDBaUruqyHvX7l1Tqcedb/i1ink?=
 =?us-ascii?Q?ufOEKIeh/CqoT8gjYSDXOa9f/qVZrITNm8J+/gKHtrKT6AGnXssX24pIXf1S?=
 =?us-ascii?Q?0mdAVAjETqBMKM2H/YozOCBZXNASXKy3EvVH8qiETxoRsyWPd/HuJBQvzeSY?=
 =?us-ascii?Q?9HZwY8ESO3KXnstu9L+LU4V6dAszxfrPnixBYCZHo1cHMpkwVvRK8ARCDkgD?=
 =?us-ascii?Q?Itw4Lnd+rdGKcfDxDh6C4HB6DgP0LWyKJcyjagwIuQNtdinSVvWPGWmbZPf8?=
 =?us-ascii?Q?lBHjFnMj4ixB9lpE6Mexgf47UuYd7G3rb5OFEpN4ZaPCLB0e6AUvBlRbzjgk?=
 =?us-ascii?Q?TF3s1K+xbJU6iJ8ediYBnF2X5QwOFd3la0iwqX/u40nrPE+sVVTqYpuCLUqj?=
 =?us-ascii?Q?AOx5yDn781e1ucdDCeXRtviWowAlec4j6oofsDnmiFnCXrI8DkOURz6380ou?=
 =?us-ascii?Q?15RPjgX8gZT6pdf4kQ0U7Bwr3QAAiZBjwnq0LUXhzTUHjOFxuQzA1gh1xI5i?=
 =?us-ascii?Q?SzvqGadJZPolAAWpLldq8LAaUIjjxzkqQveNBb5IGNJz5b67w/sFv/ZQWxiI?=
 =?us-ascii?Q?UdHsDeXFZEF96tvG8V0F/9G69uxM+1JFSQ9W+Bh60kNnNPeDxD8MEAq6R/ke?=
 =?us-ascii?Q?4LsQWNyY9hxULr8VwOAXngxyiClNC9qw28G3hdmGq9FBcqcYUMDNvHM8JgZP?=
 =?us-ascii?Q?5JH2hXX8VRaMwBZWuUcGOjRng9GbZBE5qOYc5kr/rjtW7kzRBxhBRyW8SCym?=
 =?us-ascii?Q?cmOZ9duVc/JPYIAAo7CJcxZ7HU9zig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d12d4289-dd3f-43ac-c8a3-08d8c34f00c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 05:38:55.4542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j+wqsnks1xESfYE6Cqx7uOL4k0iZcn3WyFzfzl5tPU4hfrKPkttId6fNsXbQ2IBm7ohA7ie00H5+2nu1Scx2WxI/S24Q5ZJNCg//uR436bA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7390
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 20:47, Damien Le Moal wrote:=0A=
> -void sd_zbc_release_disk(struct scsi_disk *sdkp)=0A=
> +static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)=0A=
>  {=0A=
> +	/* Serialize against revalidate zones */=0A=
> +	mutex_lock(&sdkp->rev_mutex);=0A=
> +=0A=
>  	kvfree(sdkp->zones_wp_offset);=0A=
>  	sdkp->zones_wp_offset =3D NULL;=0A=
>  	kfree(sdkp->zone_wp_update_buf);=0A=
>  	sdkp->zone_wp_update_buf =3D NULL;=0A=
> +=0A=
> +	sdkp->nr_zones =3D 0;=0A=
> +	sdkp->rev_nr_zones =3D 0;=0A=
> +	sdkp->zone_blocks =3D 0;=0A=
> +	sdkp->rev_zone_blocks =3D 0;=0A=
> +=0A=
> +	mutex_unlock(&sdkp->rev_mutex);=0A=
> +}=0A=
> +=0A=
> +void sd_zbc_release_disk(struct scsi_disk *sdkp)=0A=
> +{=0A=
> +	if (sd_is_zoned(sdkp))=0A=
> +		sd_zbc_clear_zone_info(sdkp);=0A=
>  }=0A=
>  =0A=
If I'm not wrong there is only one caller for sd_zbc_clear_zone_info().=0A=
Is there any reason why sd_zbc_clear_zone_info() is notopen coded with=0A=
a meaningful comment in sd_zbc_release_disk() ? e.g. :-=0A=
=0A=
void sd_zbc_release_disk(struct scsi_disk *sdkp)=0A=
{=0A=
	if (!sd_is_zoned(sdkp))=0A=
		return; =0A=
	/* Serialize against revalidate zones */=0A=
	mutex_lock(&sdkp->rev_mutex);=0A=
=0A=
 	kvfree(sdkp->zones_wp_offset);=0A=
 	sdkp->zones_wp_offset =3D NULL;=0A=
 	kfree(sdkp->zone_wp_update_buf);=0A=
 	sdkp->zone_wp_update_buf =3D NULL;=0A=
=0A=
	/* clear zone info */=0A=
	sdkp->nr_zones =3D 0;=0A=
	sdkp->rev_nr_zones =3D 0;=0A=
	sdkp->zone_blocks =3D 0;=0A=
	sdkp->rev_zone_blocks =3D 0;=0A=
=0A=
	mutex_unlock(&sdkp->rev_mutex);=0A=
 }=0A=
=0A=
=0A=
unless I miss something, in either case LGTM.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
