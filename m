Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701E7C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 07:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4185B61100
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 07:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhIRHOL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Sep 2021 03:14:11 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:40369 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhIRHOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Sep 2021 03:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631949168; x=1663485168;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=rOCap7XHwA8PBexZtZ55vhCQuzQPnzLmFsV1WdtR54Y=;
  b=TQZpusblpfMSE3WKLdIM+5ceSqM9huBMYjYm18wfamiztD7lR+8CMiz2
   DoI9YjzKOIuOYTvY/eU8H5ffD9mkdMUWyWvGy5+QqZRBCP73Q4m5tnX/q
   gdRq+iz1shNlTJdcGO21YOUKo3bq3Xo8cax9dVXxYpiBYRx+v0h1F3oak
   wkXyL3yeLIYAat+QAkeXjX//f1p63rj5SmBM1WURCHMFKmyErKJ6xnJxr
   utttdwFPPeBSRiU8DXY7TcsHuMohC5ESHUKwbs1/agiOwmvGiOoc5SxvY
   bneSC01u+Gcnv3BgTspQvenBTw9CY0qQ0UyVDCiu5hfzsANLQZ4nN/xI5
   A==;
X-IronPort-AV: E=Sophos;i="5.85,303,1624291200"; 
   d="scan'208";a="180847409"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2021 15:12:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTM/28MWjw1oJxllkGObC64sPzU5b0JKfJedc/YgpHc+HyLtLKCvQM4mDVAbhQQ/xnyvJSFYcqOh3QkdTJ5XUosEpLJX86LXWjS3AdLOaKsyW2QSSmqM9YxAWcvwlOEwGNEwqFn7eCrSDhbQPLygKk4s6Cd+8YAVYI+fe0NKe2a4lCYDwcEhkG282OailSA9AneHLm4u/Ay2aOjTHemyQH/dtZVsPlQJgm+gy9UeqtdEUKR8A2AQUKhA7Tqz8zTzvQrxX7FRfEzBYMYziyxYYwTZYuKLOEhjOvhPDI/nIrnElowBuUr6e4vmq+GWFrHmDxOjmAI1//DFK1aPcUJSBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+Oos5lnJh0ZYmq4M3QysOj+Ra0Fo1W606B64hRMp5SQ=;
 b=bqjYI5DnQsHf7Um+uQtoRKMotz8nibycKvriSM973h1l62PSQGVt11iwstujYux8yH7JHZQ4PEA2m9rQoBLCgNELRii0D/+YFqBHx9cdLcCeNnZCRTgJ4PcOH/oMxgWqh7CJ3Tvf0GqryFWTda38u8GJZIFJkg3n4Nzw+G75b8hR2GbI/x5QOxTQr2Ea2+iOwrw5mCNqnwgszbm9oa/PutUutdkbZ+2Nqgm0wbo/GOBM23M68mAt6ZM7+/VkWqpidcISy+F6FTb0lORqlMfNKxyDS0FzNc1eh1khNN0L1jH7h+wxL3JABBtonVGxkDmvUzjZaXrT++Z7tFCrm0N1Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Oos5lnJh0ZYmq4M3QysOj+Ra0Fo1W606B64hRMp5SQ=;
 b=Rv+bOYak4Gf1u9eFDaR3YoaTZDxbvy63jHpKUOkhgM5lB9ixOa3aL9JgYN/QmKxB7lheCyfA8l4R+W8IsBfpK3m8Olf6ieBbom8wXZD/g1HqpSJVW6Iu1IA+JSguCGZwa6QBWh4wbk3oskqIbgfM1Rnyj1QIUI6Xbl6tZ6AwTyk=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5659.namprd04.prod.outlook.com (2603:10b6:5:170::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Sat, 18 Sep
 2021 07:12:46 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70%7]) with mapi id 15.20.4523.018; Sat, 18 Sep 2021
 07:12:46 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: sd_zbc: Support disks with more than 2**32 logical
 blocks
Thread-Topic: [PATCH] scsi: sd_zbc: Support disks with more than 2**32 logical
 blocks
Thread-Index: AQHXrApC9kSgxXrG7E2ZNr7katjB9Q==
Date:   Sat, 18 Sep 2021 07:12:46 +0000
Message-ID: <DM6PR04MB70816DCDAA94B539D83ED0D8E7DE9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210917212314.2362324-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1dd7dc6-e6ef-4b25-a40a-08d97a73b726
x-ms-traffictypediagnostic: DM6PR04MB5659:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB565907402A8E6A80E4D8FD49E7DE9@DM6PR04MB5659.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cXkUHzFrzHBV4hzszMKOmIPS/0/2nrg50hwCBgnQHDfOsWamCbjDcwD8eypVFo6QHksOUWGkTBDeoOtxO8X4U9L48JkTc1++6GTyB0QkB7wDI1P+4NgOoiQE/SdVy3rx4ABRMGhOQuE0HTyhe2mbhd2GsWEWYIsYLYt+dm1uRQk9jWMllkZYdvgZuIN36xMvFW1WLntNleLdb/xQ9QLsuqQMqtyR2eqKyEhzPjo+UEltpAclMz/wagPiBKHHPGbC/uePj5ljfu0iqY9VUcYvfdGA9EZdqfZAPcsZp7/hEybgAKHd5W9emUCHotSlxsnxTF+FjH2B5V8F0z1i/BdFDAB1Zq9n2B9UHTkJjS++tPTYVud4D3D0ZeZu+ALg0KLNBPpvIlrtGNHk2wRNzhrypXpvdY/Bmkbn0myFMoF2TIAqtiqLj9n3G85JLGQwsviXS2FGA4hZzr9eqPgz6AgtER/EFX3RpuPZTNZbp1gvPF8i4sbTGyDXcNzYCGZucFfm0TrhMnj0oteIT8zw7OyQu5jrdDI50RK88wZC7OTbwsxOBLq+uMWUr5UO7lffcO0kYeHlOiY1YVgGP5YtB8VJSlrG4QcEFRoYliUgDosr/9vsXgFxjJGPDZ+9YIn5UUPuALiqdMt15a+8ZSX6kVG0bclnULx34L9k/6RSBavngWGHPvfNtGMIEfQBRqo8rY6NPlTalLUKsbE34BTIrnb/bA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(478600001)(4326008)(86362001)(38070700005)(110136005)(2906002)(53546011)(122000001)(38100700002)(54906003)(55016002)(64756008)(6506007)(7696005)(5660300002)(33656002)(52536014)(71200400001)(9686003)(66476007)(66556008)(66446008)(8676002)(91956017)(76116006)(83380400001)(8936002)(316002)(66946007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9CFkzdRbmCTnSOlurbhJ3KayB+pB01mQbGUh2e6fu6TqEzcvBJZGLTdB3t15?=
 =?us-ascii?Q?s6JOxG4wkvXluXGv3p3hmsEHZZvMoMEUv2jCC592s4y2ceaK1TfvjZqcaPYT?=
 =?us-ascii?Q?W4CWXDrB7mcTC9txPBTQQj592XWNT9Ix2DJUBqw/VGUXgLplSkQKxWchJofO?=
 =?us-ascii?Q?CTxuQVsHrlw/LrUr77j6l4od9yBVNSgpuhfIDgzKuBlmO4jAtUcYyF4o36u1?=
 =?us-ascii?Q?yjBOjUmA3JI4lj0fQdvrPJTgPaho8BQctf3yPyMzMbavJAhOv48OxTKdEQGO?=
 =?us-ascii?Q?DMr7GE/5YZvmuyFtVqTXdEiBAAavEeiwdzMZxFzzHaOXj8drO9jakH0cpgUl?=
 =?us-ascii?Q?Z73PcQ80Sp6qMTQuOmh1nFOHEUd0ZymtoMU8+v5Hgpj8OI/XSYbwi33tHMEj?=
 =?us-ascii?Q?litTP5Sxn4sYSQr7jHbosoC5tnSo+G7FV1rD9XSJnlRUxbh1Np7ECObWxpXr?=
 =?us-ascii?Q?j/YpOwO+PE/J+O+EokPT60taTmSbn64TLO+9faCDUJzm6KkWleFZiwA8oHzA?=
 =?us-ascii?Q?M1QOvIztAZovhJkFfwLOcH1W3JQndZz6Z1Hs0m873t7r59QuAWcT139PAmzf?=
 =?us-ascii?Q?tcU71Ml8NnlVN5yCEwe9d5MH3H1Bx7YLH/SjkV8p+yhN3cg+hwldFQBNY/+8?=
 =?us-ascii?Q?8ybil7B2NY7S+rcrwVEr0tqcXgWZcdHzyw6BgnP13Xw8LPHERG+bJjA3UQ/N?=
 =?us-ascii?Q?RBmiv8MOXGkblEqj5ifFslkqqK2Coz28VYeeiDRXJE6GzMx4OiHcd+KKX7E4?=
 =?us-ascii?Q?0z0iaGNBJbXA9UkSrvZSvXvvBN6MuItRcaRnyZNLLwL4/Fm5adb9HJZy43YU?=
 =?us-ascii?Q?c7tGtBd1I3uJpYUqti3j8HWIgBEoEG9f8GBg3uJ+73YmTz5MEohVKTY5W/ai?=
 =?us-ascii?Q?5GaTFJghbUqvbWqTSwMTVevMdemBVTt3DxNLHMdyl1MG8mmGW5+pI8e5D7lh?=
 =?us-ascii?Q?tA9ZuUlBUCi5JC2P4h5yzjb54RYgxmaqweR1uCzC4xn4XDw75VKwni2ervGr?=
 =?us-ascii?Q?Yug0hxTvVQM8DuIQuBKVQIhMRkeI0kLQ7kzNHPrpXp6LFEmkPQeOTjWHWIWU?=
 =?us-ascii?Q?73uz1yBQvRP/M8RsWNdkQ2KoItfwTkpVPEXI9B61v6HQJIOHQgeWVxmCTWb1?=
 =?us-ascii?Q?km3EZDoHZjn+eYqIw8rKGNbqEkiHLh7C12ZZmPyDrMSHvN15JtyCHrXUYYDa?=
 =?us-ascii?Q?+sy5EhzsUQCmO8EUhvllfq/jtDR/fnkP1RiXeIJgauxhXhOjyXddCUzwrhdk?=
 =?us-ascii?Q?WemnhyQ2d8NSkzpA7zBVSeEtBI3W2sB1jjJhwVq8KPYPnDzYsm1EGhIAVdlN?=
 =?us-ascii?Q?24+4I1OShvikMzghn/cBwl/qpdxFPVerIpKTeSpQJR5FlSl1bbvAtzQDAWFi?=
 =?us-ascii?Q?94cr7aNwWDRBV445DLg4yV2v2Pj9JAo45Km+2L5BVd8R89kMoQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1dd7dc6-e6ef-4b25-a40a-08d97a73b726
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2021 07:12:46.1469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AVlPcTyvqaYzM06Pmcl5DJ2LlEp+KSMaZn8U9OYFoSzfNl/ZGuHfrAkDhtmEiOqAuaPftgoHr91q9exsWRgu2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5659
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/09/18 6:23, Bart Van Assche wrote:=0A=
> This patch addresses the following Coverity report about the=0A=
> zno * sdkp->zone_blocks expression:=0A=
> =0A=
> CID 1475514 (#1 of 1): Unintentional integer overflow (OVERFLOW_BEFORE_WI=
DEN)=0A=
> overflow_before_widen: Potentially overflowing expression zno *=0A=
> sdkp->zone_blocks with type unsigned int (32 bits, unsigned) is evaluated=
=0A=
> using 32-bit arithmetic, and then used in a context that expects an=0A=
> expression of type sector_t (64 bits, unsigned).=0A=
> =0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Fixes: 5795eb443060 ("scsi: sd_zbc: emulate ZONE_APPEND commands")=0A=
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
> ---=0A=
>  drivers/scsi/sd_zbc.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index b9757f24b0d6..ded4d7a070a0 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -280,7 +280,7 @@ static void sd_zbc_update_wp_offset_workfn(struct wor=
k_struct *work)=0A=
>  {=0A=
>  	struct scsi_disk *sdkp;=0A=
>  	unsigned long flags;=0A=
> -	unsigned int zno;=0A=
> +	sector_t zno;=0A=
>  	int ret;=0A=
>  =0A=
>  	sdkp =3D container_of(work, struct scsi_disk, zone_wp_offset_work);=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
