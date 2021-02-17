Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FBEC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 22:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EF9A64E58
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 22:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhBQW7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 17:59:16 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:49060 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhBQW7P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 17:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613602755; x=1645138755;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Q/iX/CUGdTzjxsMqdVBXjcyUp15z5iuVcFV7TELuPAE=;
  b=f7zECaS5Fc4XOvcv/e+mw9PzPa5O3crfEFqs0GTcI0oRmlKDIgYMd5vy
   Yst2oZGHrvgVLmUPzb0PCxZ54H6Y89nRvVrT02ZhacpOerWifMIf/94IG
   sSead7pNcRnKFC0DEURIU9aZJ3RIuFqtTZWQjOwBciTcqQqY7DI7HCRqL
   GsA4eVd8/QlhFOXfx9GIxL5C0uVaHVaf8Ay+CnCfVsNwxV6EbKYOWz0q3
   UR0Yhm6iiFObK7rQ80llGp5++Ex1BBWAGNF3aqCfEMfLxV4zVMXoMRof3
   zWOl1en/WEjVbrYiT1fQ5GEpQNABavsO+hp95b9PQrC0b6nVCHzyecom4
   A==;
IronPort-SDR: awBKYQyweEwXNJXjRRRNWKjBo7Q9bcysfc/c7TLkvV0SMgXxBR9dl9vwLqCth0m7WWkuk+vVfW
 J+qQB133x18wa9+uxHRiqnRlR6iUoO9q1zYBMLgw1fFbMAvT1wSkQ7xq3zb2sLyDQ3zZarrGyt
 Mv4TRtgu4Ne7rPY9cKp0K9AMJntODoFlQVc0Of6NzFKWPiMj2ISt632MznXOUt959ukYmMlh8O
 ibGQTxuHrKCy13DvV8loJZlBxqTIpzJHgWEq1rCX+lyaJrG8p6pkTn46+W3BXgz1Vv7+ljq1+1
 pL0=
X-IronPort-AV: E=Sophos;i="5.81,185,1610380800"; 
   d="scan'208";a="161381512"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 06:58:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3iEecI43gSeoFYoDHYl691rhvyuln93xK8WS/RPP5VxEAKBp67hs1tx++gdk28IoP1GlqWiHS80qizqs8U3jduNsTuPIUIyTLftpegel7I/o4KS7HZbSlyxT7xtnw6LE9JqFL6bAICqhDXXqOJIcMVVEhB5G3ANQ/37QMtUKPzu2VvVjV848RY5rnQPmGg7RIxkl7d19Oqaz8SMof3N8FDr1ThwtXJ8MK0OmFWJXL+0zAadgNQPvM0SzSMX03XNUTaaCjbjOcegtCvMOED3XqS5HYAIBWhEYedalvlP+I5h6FvNfBgFzizferwjzelwV+LamoUyDK6hvV/Bey5ytA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bE71gvi5q3uXTbZW/sw6r5+AQqpaHOdBBtrQ8oWihiQ=;
 b=LZYGF/BmgKIGN3+CQe91RT179/c8BC5FLwmLuGon1MX04HplD+aCL7EwBrS4pSngmcSg85d3F6ew5OfBpv97SqegEq0pbWnjWK2AqFAmxtL/HmS0y9D9545feSBbp5nROvuCeJqJLe8+aAuaVJWEfpIbQ8DBQCRIANHISGUbKDAX1Sewj8C9hdS3cxP8JffMqsnWjAB8x9M4aVdVHBEqYF8jH1rRPaOnjhZaBbVedIyDGzNny6HwY871iqsmSlRB/8zlfTHXWjUlHDVZOdaynyXzBq4IgQy/sQruWkiunuzlZwV2xIkQp9BzuXqDfqp/mpG7I0lVTY8xUs2PH46ftg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bE71gvi5q3uXTbZW/sw6r5+AQqpaHOdBBtrQ8oWihiQ=;
 b=vsKAKrqylVjz2gVPZ0gvK2IF/AZwfqqMLKzTseBroGnZLzoykLKPTNC2mKFhc4oSEk2AYgdp82L6eRH4xBbR2x+n236e8JgsJBjA7JKMHOwvK2Kf6gs3P6mwmtWmC6BGlBNZ6oh7HG71xeZtCxxv4CkkH2yjbsi+90ei+99E7Dg=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6846.namprd04.prod.outlook.com (2603:10b6:208:1e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 17 Feb
 2021 22:58:07 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 22:58:07 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "martin . petersen @ oracle . com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] sd: sd_zbc: don't pass GFP_NOIO to kvcalloc
Thread-Topic: [PATCH] sd: sd_zbc: don't pass GFP_NOIO to kvcalloc
Thread-Index: AQHXBTQxZkbUK6AIMUGlm2ZZXKNtJg==
Date:   Wed, 17 Feb 2021 22:58:07 +0000
Message-ID: <BL0PR04MB65140865F253B2E81B2CF8CBE7869@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <5a6345e2989fd06c049ac4e4627f6acb492c15b8.1613569821.git.johannes.thumshirn@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:75c0:49b:2210:beaf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e7cd6a4b-2b8e-41d1-be4c-08d8d3977db1
x-ms-traffictypediagnostic: MN2PR04MB6846:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6846CEBBDA020EDE66C156BAE7869@MN2PR04MB6846.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M9iYVYMN37trajjPeNaIL4ZZotTCA2J3NktufHqpspwPo0s2TpxoAHGtJ9t7mnbL7dVRWAiaikFBqcSvp1hmVGBZM5xVPQaOUhhqTp169RbQZ08UFCblIXg36+KcYVebDreftWdvVd5soyjWrDpsndr3v9PemJfDOzDvEm/7TLagkwJof7IvZ+fPJI8gijTVIZR1ms8GVpHQj5UVP6oBcZeOzeA/88RrndEPoYZXTRHtwJfsThnmGkZQR8BIXcTf13MXzEB0N8okTG9CF5xqbVqqcvHptH9P6xFW3kTbbKWvXAFzbacHA2y3/cuR5do5E8cgup5hJWWAkmiQw99yeCUnfj1oPwZW4uORL/YjGMSCJJICay7SovmqWNdwot85jI4da7mZqbZ90Y4rnXsQUI73X4dbLN0akLJXb8mSvygZCm7Ykha9FJ3xpxeRab8PEAHmkbFDHTytULXTCY0XgAZLudOTdEBJBMJIfBytm7sZSB2H8YI8XUEZ6ZNWnQw5Ogcy+zsuvhYVmsZDBvEOSMu582iq+2ZqV4W/uQZPx86RQIqN65RVr2344OcateGnBEii6FRFncIPRkskajNvVAngDhvA4FEJiNzONppvj3M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(4326008)(110136005)(76116006)(2906002)(55016002)(64756008)(52536014)(316002)(53546011)(54906003)(966005)(5660300002)(478600001)(83380400001)(9686003)(91956017)(33656002)(8676002)(86362001)(7696005)(66556008)(66946007)(66476007)(8936002)(186003)(66446008)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?RZIuFbN/AKsLQLmaTituN9BoLviQr2GxlCbbOhwXbIW+Bp+HxzzaQPBggT0P?=
 =?us-ascii?Q?+dNH1PKkSGcMSTbjeLdNwuxgFO5eejXXbQrjF/pTtIMGknB+DD0JjYnON3iW?=
 =?us-ascii?Q?OofcX5jj5bNkqmuEJbGD4XITd0kBifpbz6jFp3o7AIFPOBTbIreXXBrKpaQy?=
 =?us-ascii?Q?lwCuWrD5Gxq4UITAsRWKrxYEs5y6swCp8dxUij6/lWcO1mEXBp/XdKI5itJm?=
 =?us-ascii?Q?mj2NCH/teN3AT9blzBAFOpBltMAxpAXg9Db8zycmCv81PkeL/FCiSKAtGoX6?=
 =?us-ascii?Q?aiuxWTTYEf9pj3RngLoKsB5u/KV37t5rChu0ZRtYIeTKbUG8BCh0yKysHyja?=
 =?us-ascii?Q?wFu4uRdM0bMImPmdD6RoRJq6SH2Qbe0v7wSJEh1pJyFv8gD9FOvSP4x4qS6v?=
 =?us-ascii?Q?ZD6+fwLDGB0l8wQEmntsEHuzV2tTBpI336wspnMfXl3lt6l91fh4U0OXKdrc?=
 =?us-ascii?Q?u4EEYHerpvoIMQ3mrbceA6/xRNO2yQUyHDxV9xvN5fy16AKXybF29E2/pzR8?=
 =?us-ascii?Q?xGlKi/6/6aYCteUJ+QJjPXtKKILpaDIPu6J+ohLaeBoCofNEehFoo2PRX03K?=
 =?us-ascii?Q?NLfCWc21mlG7FrgvZE+Ozp/D2J83eFeB60fyxsthgPy+PMjTk6qMOY6DUA1x?=
 =?us-ascii?Q?qUVsmjqGYCBXAYTa+YhjsBnP+AB0ZrZa1MySop3utJcGaNtVJHf1ITpmKBvA?=
 =?us-ascii?Q?CHZxusInKYihVSDD5GYuCAdyFWXW3QUnq6ghbvXiFp+C57kSA5bPXltLoPtl?=
 =?us-ascii?Q?u3uGZ7wPgw1I9/PPJpwoZ3XF0hot0k3MZAT7wb9ukXcu3fh6689ekEu89s/W?=
 =?us-ascii?Q?/aN2CR/+9GesSXRE5jXDG3I8jR7rODTtme6B1IRuqFdEclWHdfBXr/OeObOt?=
 =?us-ascii?Q?1XrUeBxR+bNbpRP7wwxpHbKdyl3W74oqnWtydO949VTbxIE+5y3HxmcccP0Y?=
 =?us-ascii?Q?mtnPQMQtdHydtlDkH/09c2U+PfD9K4Kp4/JOePud/8g2HDGqO0SEXK3gQTQZ?=
 =?us-ascii?Q?oAKNyTy8uo3AekGPZZAeItpuIBi0WWN8axqPwEYE13BKowvTVHhLWz2F0VGj?=
 =?us-ascii?Q?gChLD9QKJoYypDQMV+xkKEoljLbMm3nHntgT/3MhhgYPuGnWgcTqZbfaIrW7?=
 =?us-ascii?Q?zawtWJ5cyYtI2AIwToTE+MFEuHJ6t72wQvI5uYTLoi6v5F2UzC5eucih/zsc?=
 =?us-ascii?Q?SlWHrrhTuUNuHLvE8C0PCWNfbfWdrSIpWXr0fIhOTEWEUcKP8l1nl/8A2qcN?=
 =?us-ascii?Q?C9l/YJarhhmkjX1N94F2xuMe0B155HN1GEVCTrwWxemfrne/3E6r2E5aPEBr?=
 =?us-ascii?Q?2SBaO/uIN1UePbZUwX0z2jHnNpAQ4dm5v2H8nfAkw+Zyr7XOUGvek4Q4V7lE?=
 =?us-ascii?Q?I+7Udux4EGR97StGUcg/eZV0neio+IHUtsebh7p1Asv9Jc+csA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7cd6a4b-2b8e-41d1-be4c-08d8d3977db1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 22:58:07.4073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1LpLQySorg0MMgB/2yR4Sb7L//0xDk3Elc80PaaiHu2V8XPBdqcCrTD4No/srDgZyFML7HS9YRdQRSYUt7F5lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6846
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/02/17 22:52, Johannes Thumshirn wrote:=0A=
> Dan reported we're passing in GFP_NOIO to kvmalloc() which will then=0A=
> fallback to doing kmalloc() instead of an optional vmalloc() if the size=
=0A=
> exceeds kmalloc()s limits. This will break with drives that have zone=0A=
> numbers exceeding PAGE_SIZE/sizeof(u32).=0A=
> =0A=
> Instead of passing in GFP_NOIO, enter an implicit GFP_NOIO allocation=0A=
> scope.=0A=
> =0A=
> Link: https://lore.kernel.org/r/YCuvSfKw4qEQBr/t@mwanda=0A=
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>=0A=
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>=0A=
> Fixes: 5795eb443060: ("scsi: sd_zbc: emulate ZONE_APPEND commands")=0A=
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/scsi/sd_zbc.c | 6 +++++-=0A=
>  1 file changed, 5 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index cf07b7f93579..87a7274e4632 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -688,6 +688,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)=
=0A=
>  	unsigned int nr_zones =3D sdkp->rev_nr_zones;=0A=
>  	u32 max_append;=0A=
>  	int ret =3D 0;=0A=
> +	unsigned int flags;=0A=
>  =0A=
>  	/*=0A=
>  	 * For all zoned disks, initialize zone append emulation data if not=0A=
> @@ -720,16 +721,19 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)=
=0A=
>  	    disk->queue->nr_zones =3D=3D nr_zones)=0A=
>  		goto unlock;=0A=
>  =0A=
> +	flags =3D memalloc_noio_save();=0A=
>  	sdkp->zone_blocks =3D zone_blocks;=0A=
>  	sdkp->nr_zones =3D nr_zones;=0A=
> -	sdkp->rev_wp_offset =3D kvcalloc(nr_zones, sizeof(u32), GFP_NOIO);=0A=
> +	sdkp->rev_wp_offset =3D kvcalloc(nr_zones, sizeof(u32), GFP_KERNEL);=0A=
>  	if (!sdkp->rev_wp_offset) {=0A=
>  		ret =3D -ENOMEM;=0A=
> +		memalloc_noio_restore(flags);=0A=
>  		goto unlock;=0A=
>  	}=0A=
>  =0A=
>  	ret =3D blk_revalidate_disk_zones(disk, sd_zbc_revalidate_zones_cb);=0A=
>  =0A=
> +	memalloc_noio_restore(flags);=0A=
>  	kvfree(sdkp->rev_wp_offset);=0A=
>  	sdkp->rev_wp_offset =3D NULL;=0A=
>  =0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
