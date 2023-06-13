Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93FBC7EE2E
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 12:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239724AbjFMMwx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 08:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjFMMww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 08:52:52 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5459D10FA
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2023 05:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686660771; x=1718196771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=C6R6txlFeaOB6zFhaZcF/WQ4ul0wjqNnb8wXP6katgs=;
  b=QImC3vYXJLOsXj3t/clAboeQsiPrZwCtcTHJ12yhc7eYzaaE5MoR3gUg
   Ebfx3KDsDcVXwFK58f2G4S48FCJv2oIuHyh7dIdFUGnRQdPgnaU1pxEmk
   ise6v616i0ERerppYQGu84pP4BXyrT9iKq1KIgOFybNOBRAZEq4WEvNeu
   SOknhp1WIyIZqugkj9fL3q/okGckXLd7z+t85ZyocwXOxGuLNTGZ5Z+7B
   48mp8MgffMXnKa5rFhKxAOyGgJnpZQoFgrTaD94XMVkCudHwxGBnzwRuh
   qlPJlyJs9KHf6g+m2t7ASQHkcu12WEOlx/JEom0KHNyoRjrmt6ITuE8yg
   w==;
X-IronPort-AV: E=Sophos;i="6.00,239,1681142400"; 
   d="scan'208";a="235555363"
Received: from mail-mw2nam04lp2176.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.176])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2023 20:52:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mA7akmlP9pNrl3OlneBQ+JkDpeDRkTeap1Cfm8f+hMjMJ7HQAZ0IbaI022DfhzuA2wjpF8c5sYNqdG11xfZq9+I2g5ZxNAr8EUTE4yOc1I73m/xSoPXvhT/Rz0T+obgWmcLbaug2YNS1sFLT/ELE0J4DvK2khiDRukStbyMwkewovbXD7cj4RwNxdhJmiqRCXTrqc3dunryvy1tAfgLmALL45CXH/yT2ZZjS9sYg7DpPdP+n6mIuqRXvMhmA7+QRXFJJzFHqArWqADLo0wbE2fB/mBHwmpsVn2SU1uf5eXWdOLabTf9/JxPXGDAln1nEvvzERb/S0Gt1bvc0kBErjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKX7xzZ6sgftlnE1aH15542zbcHE82n9TVdbWc0sKu8=;
 b=dMPaUotKIrOva4mV5VVwZOdPZgj81XQq9I5aGzb32gR/LLzBunwa8dvxzg5Q2zGzu7ecryVqdhn2oDQu1OiaPD1wV8gVe8g/jUbaI50T1UfIWUc0Hr0gWDlRMXajYJ+avY0eaJI9R3zDakaJVxBeEiwKw3ZG6/S0SP0jk75Yzwqc7HbDK2cYKteeDWPG++tT1rrAp7Vbnve7Cg81YocjkNCZo6HUfitNzibHdDp2qpTe5J0+bFQd6IXg+sQ6FgYFh3tso6xaDX33kUX7h8y6OxqUbbuZoeOjCKJsd5sQpSGr8C3KGpMtODoSAa5+5zKu4Y7q2RM+JK2Eq6mdAICHjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKX7xzZ6sgftlnE1aH15542zbcHE82n9TVdbWc0sKu8=;
 b=yin5pNl2mkqoWwqW51l9YHYuDzCCRhnU/r/33KJo/efMk0BvsZtGD5z8ONsWuynAWLtg+Vdyg8w6a4/D6N2RBelLHLQCDB/gmDUyELQeq3838xu9kuRIVgFNOAO2pQh8aiImf4lNmT+1hjsf8VWcYEKGCV+xF2YM8CYZlFMdK6I=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH7PR04MB8633.namprd04.prod.outlook.com (2603:10b6:510:245::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Tue, 13 Jun
 2023 12:52:47 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.039; Tue, 13 Jun 2023
 12:52:47 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: use PAGE_SECTORS_SHIFT
Thread-Topic: [PATCH] scsi: sd_zbc: use PAGE_SECTORS_SHIFT
Thread-Index: AQHZnfX0uKNCNjLEpEmPvDWGqlyVAQ==
Date:   Tue, 13 Jun 2023 12:52:47 +0000
Message-ID: <ZIhmmGmVdavs7B5D@x1-carbon>
References: <20230613-sd_zbc-page_sectors-v1-1-363460a4413d@wdc.com>
In-Reply-To: <20230613-sd_zbc-page_sectors-v1-1-363460a4413d@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH7PR04MB8633:EE_
x-ms-office365-filtering-correlation-id: 34e4d957-84ae-482f-db70-08db6c0d16a2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PUXUvNSa/BVQOKyYOeDwN0Bhfj5wR2/vIHuCRqkuEQzunGjn42kX+NEpntASoawayqmPdjUUnepzLa4zX0nbCoN28+ypFTTQiqT+ILzLDrA21v7IF6tnUyGZsfMrQqEfntCcmw0jYFRZ4xPjIAHCwYwBAo2wtMNxZem90eEyy/aCHi1pTafe036FCe5ctbIwsjos7O3G7ymHcOrmVDZtIfnx3stOOPIBZZB0x4j97zIglUXaEOKAvWPX+XzAEXQmGZ4+Swts+eMBlE234tt7hLSGSMk7oSd3WvO/Z2VE09nfSqdj3Lanv1iJAi9D1OPF2HG5wwLL3SkHlsPtwoAVNNxnEArwak/YCkkZufYYp6Icwkl7bVuRlGumRAaz+stFPWl+ENE1ng7LMafZyBB8LNhYf/1kGeWMHGrp8Wmt/MobYoM7bPzbxjVh4IOGMMNBTsyb8Ny70W+2DqzXrUqatheXGrjLzNPcSQjYucI7WJnL0K6KncqmmTu3BklNnotn+Leo3oMId4Y4mTUYKNI51GQpp8yp+8Vc6wBDBNmbmHsItBXNDpcH4m1Z2PwLSskYs9XEoqB5eX/NAbI8wgWUMUwoghRGJSWwLUd+HJorS7mc6vW+ql6zw+ZnTisZYt9b
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199021)(83380400001)(33716001)(66476007)(82960400001)(122000001)(4326008)(6636002)(38070700005)(41300700001)(38100700002)(316002)(6486002)(6512007)(6506007)(26005)(71200400001)(9686003)(64756008)(66556008)(66946007)(66446008)(76116006)(91956017)(4744005)(2906002)(86362001)(5660300002)(6862004)(8936002)(8676002)(54906003)(478600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z1GaoS4coNeHt6xWXMH5XxBf3kgdFOArH/1GLQfYDLQg+ZNfd55DYFaeAsx9?=
 =?us-ascii?Q?kVO7r+tIw8HCkAOzqOAuEPi1/siHMfL1dDEhf4GUVa7yaKYRxQ9NC4rU2GPe?=
 =?us-ascii?Q?BO1BAQZWcnXao1COjI9dR+8RxS7iNQLQOT1pufDVW0Y3UPfvDTSaMr6YXwQy?=
 =?us-ascii?Q?S/3Z2WUJQMzRxu0xmcGETJvBHryuXDkVA+R+zyNdVqeKMSrDSEH33wbrlKWn?=
 =?us-ascii?Q?NUtJP0C0h4rwuILxtmdyKytIEKDUdsIgSyyGOW6PRS9WcS+lqSVkgw7P+F1x?=
 =?us-ascii?Q?y01MwtcTEDxW1+sJOkyYBR6Cudi04lCGj2urssUNCP4xljTiuu8oeAItmXfe?=
 =?us-ascii?Q?xf+U/UlnkJNrPjF76f48qZMxZ8zyjVuhGMIZmf0QKQJ3FwKhO+vwK29pNYnr?=
 =?us-ascii?Q?PWpCTMXjXl1kvVsld6CQDz7XZbjaEUhe5KOl8pdxzKYpI59JyAo7EdpWHgDQ?=
 =?us-ascii?Q?PYPnt8HAOyZ7Q/43DRqDPUC1T28If7+VakN3OVZvVQjddnlsgugzC3NNQ3Hv?=
 =?us-ascii?Q?g64DR8Y5CHbAw8XZJsUX5BLLzkRXS5g/s2R4AhqoYnuWNafTmIcfC2yIPQWO?=
 =?us-ascii?Q?POkBACURT8U8e94OQDBUfLrgjWvAo5SB9cu777+XZdTVFy/Twjs5TVSwtI0K?=
 =?us-ascii?Q?nCzDBr0Y0VzXcXIbZ8sDrYo6e525jRDDSbtkAHw7/vfErikrQp9DBRLg1V8O?=
 =?us-ascii?Q?tAtuUz3/7j0ooL7A599D1Re0Gd+1VwF4k/vhDVnQDGvjIPuC/5jRMTWm3LCl?=
 =?us-ascii?Q?tXQgba+3S59tPNKdbJh5iwuZtlBLCpKEUI2tb4E72jXozQI28MWySTSwoHHA?=
 =?us-ascii?Q?6jrXa6+fVwiG4mfZMKYEUHpJSzmrMZQA5AEsscXfzx/9YdgU0nVr9LDSsIym?=
 =?us-ascii?Q?cLqzklQ5DnD0gf03Yr8y0mkfkw3fOUMLTEjW3beaFVt2lFgMV+1kA8oNDI+N?=
 =?us-ascii?Q?qOpNli38JEI3oU/8smLB+4ezdgGS5mqtnOYMRmZmH6ie61Cx3aTHpGKllQaK?=
 =?us-ascii?Q?jM9G4Hq81d1G7RuYTXoGyZ7Y2J7sgbZKHEmCCVHSeei+qxJYwarrWUaxwpO4?=
 =?us-ascii?Q?yhOpoNePqrdsQB7gbLfPcLWZ3jKCeQ8hLSukjgcL4lRLgF3pqf9dm6ORcDjr?=
 =?us-ascii?Q?2OoHDCFDwgbI9xllJwTIgheODqu4MlTIpXJ9HlWd0R6aycPbkiUUBttXEEK5?=
 =?us-ascii?Q?hChnZSvxF+2nYcf5mfiYJWiwIg87xDcMU2FbK+YTf7FFTm0LQiwDcs/ZqwWJ?=
 =?us-ascii?Q?T5Rjz8Ie2lPbNoKWGiX2DAx0dPpcmfdFA4ZAbq3IMWPzEPeZvSS+2+x/paQ9?=
 =?us-ascii?Q?MlqvPQqOgrxkrsOHlN4dFH8Ia1gyvz/YdwqPla56KXaYefwa8N9LyGyMH3Rn?=
 =?us-ascii?Q?1YfKZ6P6lJ0EsxPXKKj+xsBS4LYT0sX5ZY73OFasq2go5Fxw7E0ZFep2ZnFT?=
 =?us-ascii?Q?V6dwXOPf+qw23C7QIiX1XrhkjyO/pboVDHuD28erICfBcizaXcSwlocDfl2i?=
 =?us-ascii?Q?rLkbl1B4beXyQik+LY/zrCzZyCoqttKddSOsC+2fHngoAL7y7GozFnpBnynN?=
 =?us-ascii?Q?k/thpcc13NTsO+RGgM/LiW0Bv9p9zomOSZhtNciymUbNW2W+ncqn8Ylfbvtq?=
 =?us-ascii?Q?yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <71BE043A44999E419F62DF87E4868B4B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: e7wbe+ACvBsq2k4CxQMx6Yprz7/FwdLWaEO6HNZFMtGmeiu12TadUhAeIPhTQWMgzwjuNf3c5dTkJFAP4jzTFWvtOe3X3ttogfffOwr/LQQIoH5f/oCJYcu/7fyRG8JYMFKtQzCUAfyhvI1aJ1jntA/GGxvOkFz7oe1BwnQAg1AEB9QsOcquAV+Q1L/AdsCh48hhv900+Pvy3nVdhgd16fN5ZtFgQNbW8nmrre/prXK6584e57yaQU9MOCW0M+psZsxwxG3uX4uqviJ4jOKXYs4YWasZJO7vQ3wFA7TcbBhnCFGIV70WzUIsZ2hss5W7b6m30+eN48SjzXqmgVEZNPJuO5JwpP9r5fsDFYHIaEVjZwGDyxeTc2Fs8eIcpQ58/+y12iP4BAZzoPO3nT/w+OuKPyBaauqxhqaLXB7y/ve9PLhM7TwZlh1dw2DreGXbQt38N1N7uN19UWrzFjxWoxuJFZ/aBjx7kQ29rd9ddhgl9nd0/TcsOqan1OaIgWXwvVMUbZqO7uNYjPXQzBkJN9cMttQieLtXf4TF2scWFoihtpV3Ni7nNOKcOLW12UcTYkkty/uDhHNzUsdXMkZbxQ+zRlJfS5kk1uOpRUxE2vh0K5S6UAorfK2RiQwKZcAtJTpmkOTrFRNnSGDuGHTDU+oQEeO6Itz+MJReANV6owup5uXTP9oon/9hpkTc7Y0PYuV2X8cBigjCNcLX99hlp4KWAgUfzO7iSftew2PwyEOmVv4SCZGaU/DoTAsbbI+bh4AdHoyvtTHYtx6ZwWSGKNIb05jDYLu61sk9citUVemzL3ziYAddmmvTCmEkj6aCFXmlzY9okhTZAqagh0txnQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e4d957-84ae-482f-db70-08db6c0d16a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 12:52:47.2933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W3gP0ZAzTeeydlawmKK20nuciXQX4V6/Qny29Dt1NbpwsCON9OtRSpAwmT8/E4aE709yskOnPsfjhNNDgKSgmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8633
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 13, 2023 at 05:31:45AM -0700, Johannes Thumshirn wrote:
> Use PAGE_SECTORS_SHIFT instead of open-coding it.
>=20
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  drivers/scsi/sd_zbc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 22801c24ea19..abbd08933ac7 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -889,7 +889,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
>  	}
> =20
>  	max_append =3D min_t(u32, logical_to_sectors(sdkp->device, zone_blocks)=
,
> -			   q->limits.max_segments << (PAGE_SHIFT - 9));
> +			   q->limits.max_segments << PAGE_SECTORS_SHIFT);
>  	max_append =3D min_t(u32, max_append, queue_max_hw_sectors(q));
> =20
>  	blk_queue_max_zone_append_sectors(q, max_append);
>=20
> ---
> base-commit: 467e6cc73ef290f0099b1b86cec4f14060984916
> change-id: 20230613-sd_zbc-page_sectors-f462501f7ab4
>=20
> Best regards,
> --=20
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
