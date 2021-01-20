Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D08DC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 08:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C37A723341
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 08:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbhATICd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 03:02:33 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1407 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbhATIBr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 03:01:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611129708; x=1642665708;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=I3f/7EQQ2VcSuxPqXKLMDSyvCAtUgvv47Yc0ideXZUs=;
  b=b3+FATzJ9IwHhau8LN6jJVpgqTzG9SweliyXkPL2zg8HccMMQbLodpbd
   V4DeTZwviy9ZL7bQuFAtR2em+6Tg5YVwWgJLw9mbs0ap6WTN2mGLhAx3g
   V9sGyhHV9LZUacWD44wz9yNeZej6kQ5MMm1KGSHqpwKULb1kiCRjg1Bgl
   WN9ae9aevPDTOzASFMnzoQRXNpkBknJry45mzzwB05QSbpKM3aS6fk0aV
   fs4N8DYcst8PgvpI6qj7+CctKXaIajmgcoqM5dBPZDkFBQzjHLHbRfg1q
   I66tBN/AeijoyX5nHDYgyYoh9F+bJBp/OQC3HgCtgKqfxuaXwUjdI3pAq
   Q==;
IronPort-SDR: dHVO28iSpuornUii3/eIARsaSRcww2V9rCPNAOYWFc9PhMnr4oon7LUR4AA8BiHKSVkLZExWel
 dAigFrt/okJDztCAtSC4td1sWGl5mnkKbLhqNioVOOH/gbFbT/YAdM2HxC69fyhe6VjDBj+bZL
 6p5vbUm+pelyFNMRNEEywzNc1D7KKfWY3ByCe7g05ffXbTNvclC/BwXfM73oa7YYZDIDiGar+2
 v7GrNT9yZpwOZxKVfj9GfGZuBWHUeN2ddIJ4YHF5YUiulTp4jQAKNtMH9DVb90p0tZWhXUTxDW
 z5k=
X-IronPort-AV: E=Sophos;i="5.79,360,1602518400"; 
   d="scan'208";a="159053474"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jan 2021 16:00:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPJyGvqnM9D0XXAHK9rfFGYi9Aac7RJOAvMnieWD6DGIIeqXbGWPNxpBO6XCWvINAzWlLES5tlCPeon1QhIyfZbIdqb4mOj9FsEWcekpUvp0vMz22tVjBZZByuPb3jKeDZ30EEUJbqf4Q6ifMT0jZvJ2Tsz+Q3hDpZrnJUm/7vapoRhl0vab5VzcuPXyg2VSPfAN9pm2vXAMDvFV7qYu6MuGdROIOKslW4JMQQmq1FW+sSuHlCJF5Ca24h5q7vH3q9iR57w43P/0Fe+5BiubkOShFZHXIUYr4JuoBrMEHtpKKYoNgQWES1gGwsfyVNPu4vJ9LnG1qVTNCOBCexWI3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBqKJhdZGPpMFdgEWd4ddROgKU0wz/Kiz/hXxx7uWF0=;
 b=akjXgEvZZsMr/4zLiZ3iSkTOVlZFy6ZS4MtabAbC1cQo7UvLPwBVgfiXbMzS6VFDHeEw7KmOnTn8JrobNeDTCOKqfH0qDtsmHkVu1Vzgj8Vuwssz/+QO+IO2XcZ5kCamCUqX1Fwh7lLgEETbBeJ+meBzBRAyFG0+dFmYMaqxCdwFoCgOpnfMluB4Uw7ycKfoAxOl5/BY+ZA8Dyx6Fs2dg9js58xQsh3FNU8miYM+JuC8rPZADweRdrcQhIj+Kw3GMhNUa85urUm/bDg0qWYWAPDCZg3T9S36G0/tUGBm8sBgcyLeeByyQm17g/hW4mHvrFhTPMXdwvKeT4freckZaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBqKJhdZGPpMFdgEWd4ddROgKU0wz/Kiz/hXxx7uWF0=;
 b=tJDmthe1+/2TloLGYSpymsC+kEpUXkOLLbS0joqt1VjsUxCRt2oajjSVbJZR5dDZpfV1NVgzvRPNoJxQDEI8GrK8Jdo+H+hQuCkz5dVr8Oc2ZM/N/1M+uTHhGzzJlptroSDYzVAoMlwg2WhB1E5Jqz3r6fB32jI7O4BXEPyv2uo=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB6482.namprd04.prod.outlook.com (2603:10b6:208:1cf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Wed, 20 Jan
 2021 08:00:28 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%8]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 08:00:28 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Manjong Lee <mj0123.lee@samsung.com>, "hch@lst.de" <hch@lst.de>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "oneukum@suse.com" <oneukum@suse.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "jisoo2146.oh@samsung.com" <jisoo2146.oh@samsung.com>,
        "junho89.kim@samsung.com" <junho89.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "nanich.lee@samsung.com" <nanich.lee@samsung.com>,
        "seunghwan.hyun@samsung.com" <seunghwan.hyun@samsung.com>,
        "sookwan7.kim@samsung.com" <sookwan7.kim@samsung.com>,
        "woosung2.lee@samsung.com" <woosung2.lee@samsung.com>,
        "yt0928.kim@samsung.com" <yt0928.kim@samsung.com>
Subject: Re: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
Thread-Topic: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
Thread-Index: AQHW6XfKh7ukksSNykCpKuE87ZdU0Q==
Date:   Wed, 20 Jan 2021 08:00:28 +0000
Message-ID: <BL0PR04MB65144693C61F2192038FA5C0E7A20@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210113155009.9592-1-mj0123.lee@samsung.com>
 <CGME20210120064450epcas1p1b00b7a040e0951a2da44abce916e1698@epcas1p1.samsung.com>
 <20210113155009.9592-1-mj0123.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:b0d5:1d20:2559:58ed]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cc385185-bbd1-418a-9574-08d8bd1973a5
x-ms-traffictypediagnostic: BL0PR04MB6482:
x-microsoft-antispam-prvs: <BL0PR04MB64827600BDAD73C3F11C88E5E7A20@BL0PR04MB6482.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HAlF7wFdG1InKVXDI6SE8bKYRtNYX49QQvHi+t8JIYhOJx9sqVIZ1PulIvJqhjRJDXI774j0pcOb3iE7sjKD93eFkDwJsjjoTHUcu11yoKwRAsvRC9zIe2yl1ICBqtDxOwj6xCSo2nJd91PxUR85sJh6FHTOQ6Rzy9N6PuKaiBem2UTx1uX7pesm+lOkbxRUr02y2IcIUIGTEYZ/ap8Xb2VbM+HoXwO/qdjabNjcmx9eZvkgY8NeQJq+qzFjV8k/xeCYjJNlowb1AdkN6V2SRb1WxB4HdjKd/p0VF/ApNAAXywb3EnDB4yZxBHxA5pH+Mzye7e5kbjHpRTLnp4mjx+UupvascNNQ87YvUGiaVL5PTDnUxsLix0YxbOnVeRIfVvuBNXHGXtYCGzD5rGB0meYXeY1dC9JtUiAQ7++G2nEstW9BiMFfE8S2QMGfMmcl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(52536014)(186003)(5660300002)(66476007)(33656002)(83380400001)(66556008)(71200400001)(7696005)(2906002)(7416002)(54906003)(478600001)(91956017)(64756008)(110136005)(53546011)(66946007)(316002)(86362001)(55016002)(66446008)(76116006)(4326008)(9686003)(8936002)(8676002)(6506007)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VC9wfuv9QjBUD+8OV9bJZmCMdZYfoQF5Y7CwH/qCHW8qN7zyhoAC4/wzj+S2?=
 =?us-ascii?Q?VhI05cKBpiSESOCeKxrTvSB43F2fNCy1U1DLqYJCTLQoZ4btYCTt2nM6SUu6?=
 =?us-ascii?Q?JlBSg9tf0GaddhoJ/mvOMjRS7ayvkKqJ7yE/R5NXkthWraeEfjlJkDbwPi+l?=
 =?us-ascii?Q?1VQThsv1xAphJ04TZy1rdaulqHEi36ozxFcyAbtav71RQdAXEqpxDQev06Au?=
 =?us-ascii?Q?ibY4zj/uBMaoV/2zV8gYtYDdq7TkoB19dryrKkdCkWCIG1VafHdmKlZPF9bb?=
 =?us-ascii?Q?Xg8FUANBVA0jzK/PFvidze0Yt2nQ9gdxNfJzrP2Kkuj3MguCB5kGKP8PlqqT?=
 =?us-ascii?Q?mJXs99byhEqcYe58ePhr5wvVj1pBNXXRe3V4NgeCcXnUq2y9nQqYj+yra+A9?=
 =?us-ascii?Q?MM/lQfrrJMl7eD/mQLGzl5zIxnjTmKTgopoZP3wjknAizXgxKfLguI7QtbSs?=
 =?us-ascii?Q?+wDNyice08PFgx60DO7LwL73Wmd09sCrPxC0oE+853Y/+EIRbUF9EUPuLjHK?=
 =?us-ascii?Q?p4K8CXabBpGhaggl+ZA3a/uJUOgIUr1m/jDoT/iqhWJyjT7cmZ942WiCwhYW?=
 =?us-ascii?Q?R7qFqKiehxMtKNDDYfsVN4ZvIp1Hd9s44gzlxmsEnjVF+fAXxkoIl04L9m+U?=
 =?us-ascii?Q?e44nmIVIYxlgt00NQd7fkXDW+FzxLYfiXIH9iqc52lNveaetnJrGUKVAxri+?=
 =?us-ascii?Q?s1LgVsXGGGFNBK9rza4cE7q6XAca4ogo+8RWaNyxoarCkUE/jgORWDATNrOF?=
 =?us-ascii?Q?9p3emDfqwlIXXrx58pePHIHg7xnLJv3m26OJ1OAh3wXxSx9MQKAQJ2VyMEWt?=
 =?us-ascii?Q?lcZDXs3MkqjP0v2E4bfsnwd44+e2KBbabOIcYeduIVBRxKzEThUaeq93c82c?=
 =?us-ascii?Q?TCsvtAdIxFBX7f4iWvtGUV1mHe570gUwCOZgSn92ytPtGYiMICe6Uu5TV1mN?=
 =?us-ascii?Q?uNL/spWAjy5Sdp2sBVLK0LVzdQO40GTzV9HnvL379zemTDRt+jN6khOym4X3?=
 =?us-ascii?Q?7IzqE+smu8swJ7ZIuBYQr//aqQs/EGicZQz2QayLBigR7Pfs0Shkw65uvTfG?=
 =?us-ascii?Q?52t0SDTuzlkbcpreUWelCzo3BctTbnFLKZDlrRvVNAmDaqbxERO1/8PHrXOS?=
 =?us-ascii?Q?eZUw8GtbiOpPmwS7TUcsHcE5NjxEKkMKvw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc385185-bbd1-418a-9574-08d8bd1973a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 08:00:28.3555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oBzr5Xp3xJP/dSKUbGhdBJC/Fke2K96VR2AmURJRfHy78i4SACaixXNEHXnh5C7FT1jeGwoJEUnl59Pr9Mv5PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6482
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/20 15:45, Manjong Lee wrote:=0A=
> Add recipients for more reviews.=0A=
=0A=
Please resend instead of replying to your own patch. The reply quoting corr=
upts=0A=
the patch.=0A=
=0A=
The patch title is very long.=0A=
=0A=
> =0A=
>> SCSI device has max_xfer_size and opt_xfer_size,=0A=
>> but current kernel uses only opt_xfer_size.=0A=
>>=0A=
>> It causes the limitation on setting IO chunk size,=0A=
>> although it can support larger one.=0A=
>>=0A=
>> So, I propose this patch to use max_xfer_size in case it has valid value=
.=0A=
>> It can support to use the larger chunk IO on SCSI device.=0A=
>>=0A=
>> For example,=0A=
>> This patch is effective in case of some SCSI device like UFS=0A=
>> with opt_xfer_size 512KB, queue depth 32 and max_xfer_size over 512KB.=
=0A=
>>=0A=
>> I expect both the performance improvement=0A=
>> and the efficiency use of smaller command queue depth.=0A=
=0A=
This can be measured, and this commit message should include results to sho=
w how=0A=
effective this change is.=0A=
=0A=
>>=0A=
>> Signed-off-by: Manjong Lee <mj0123.lee@samsung.com>=0A=
>> ---=0A=
>> drivers/scsi/sd.c | 56 +++++++++++++++++++++++++++++++++++++++++++----=
=0A=
>> 1 file changed, 52 insertions(+), 4 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c=0A=
>> index 679c2c025047..de59f01c1304 100644=0A=
>> --- a/drivers/scsi/sd.c=0A=
>> +++ b/drivers/scsi/sd.c=0A=
>> @@ -3108,6 +3108,53 @@ static void sd_read_security(struct scsi_disk *sd=
kp, unsigned char *buffer)=0A=
>> sdkp->security =3D 1;=0A=
>> }=0A=
>>=0A=
>> +static bool sd_validate_max_xfer_size(struct scsi_disk *sdkp,=0A=
>> +				      unsigned int dev_max)=0A=
>> +{=0A=
>> +	struct scsi_device *sdp =3D sdkp->device;=0A=
>> +	unsigned int max_xfer_bytes =3D=0A=
>> +		logical_to_bytes(sdp, sdkp->max_xfer_blocks);=0A=
>> +=0A=
>> +	if (sdkp->max_xfer_blocks =3D=3D 0)=0A=
>> +		return false;=0A=
>> +=0A=
>> +	if (sdkp->max_xfer_blocks > SD_MAX_XFER_BLOCKS) {=0A=
>> +		sd_first_printk(KERN_WARNING, sdkp,=0A=
>> +				"Maximal transfer size %u logical blocks " \=0A=
>> +				"> sd driver limit (%u logical blocks)\n",=0A=
>> +				sdkp->max_xfer_blocks, SD_DEF_XFER_BLOCKS);=0A=
>> +		return false;=0A=
>> +	}=0A=
>> +=0A=
>> +	if (sdkp->max_xfer_blocks > dev_max) {=0A=
>> +		sd_first_printk(KERN_WARNING, sdkp,=0A=
>> +				"Maximal transfer size %u logical blocks "=0A=
>> +				"> dev_max (%u logical blocks)\n",=0A=
>> +				sdkp->max_xfer_blocks, dev_max);=0A=
>> +		return false;=0A=
>> +	}=0A=
>> +=0A=
>> +	if (max_xfer_bytes < PAGE_SIZE) {=0A=
>> +		sd_first_printk(KERN_WARNING, sdkp,=0A=
>> +				"Maximal transfer size %u bytes < " \=0A=
>> +				"PAGE_SIZE (%u bytes)\n",=0A=
>> +				max_xfer_bytes, (unsigned int)PAGE_SIZE);=0A=
>> +		return false;=0A=
>> +	}=0A=
>> +=0A=
>> +	if (max_xfer_bytes & (sdkp->physical_block_size - 1)) {=0A=
>> +		sd_first_printk(KERN_WARNING, sdkp,=0A=
>> +				"Maximal transfer size %u bytes not a " \=0A=
>> +				"multiple of physical block size (%u bytes)\n",=0A=
>> +				max_xfer_bytes, sdkp->physical_block_size);=0A=
>> +		return false;=0A=
>> +	}=0A=
>> +=0A=
>> +	sd_first_printk(KERN_INFO, sdkp, "Maximal transfer size %u bytes\n",=
=0A=
>> +			max_xfer_bytes);=0A=
>> +	return true;=0A=
>> +}=0A=
=0A=
Except for the order of the comparisons against SD_MAX_XFER_BLOCKS and dev_=
max,=0A=
this function looks identical to sd_validate_opt_xfer_size(), modulo the us=
e of=0A=
max_xfer_blocks instead of opt_xfer_blocks. Can't you turn this into someth=
ing like:=0A=
=0A=
static bool sd_validate_max_xfer_size(struct scsi_disk *sdkp,=0A=
				const char *name,=0A=
				unsigned int xfer_blocks,=0A=
				unsigned int dev_max)=0A=
=0A=
To allow checking both opt_xfer_blocks and max_xfer_blocks ?=0A=
=0A=
>> +=0A=
>> /*=0A=
>> * Determine the device's preferred I/O size for reads and writes=0A=
>> * unless the reported value is unreasonably small, large, not a=0A=
>> @@ -3233,12 +3280,13 @@ static int sd_revalidate_disk(struct gendisk *di=
sk)=0A=
>>=0A=
>> /* Initial block count limit based on CDB TRANSFER LENGTH field size. */=
=0A=
>> dev_max =3D sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOCKS=
;=0A=
=0A=
This looks weird: no indentation. Care to resend ?=0A=
=0A=
>> -=0A=
>> -	/* Some devices report a maximum block count for READ/WRITE requests. =
*/=0A=
>> -	dev_max =3D min_not_zero(dev_max, sdkp->max_xfer_blocks);=0A=
>> q->limits.max_dev_sectors =3D logical_to_sectors(sdp, dev_max);=0A=
>>=0A=
>> -	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {=0A=
>> +	if (sd_validate_max_xfer_size(sdkp, dev_max)) {=0A=
>> +		q->limits.io_opt =3D 0;=0A=
>> +		rw_max =3D logical_to_sectors(sdp, sdkp->max_xfer_blocks);=0A=
>> +		q->limits.max_dev_sectors =3D rw_max;=0A=
>> +	} else if (sd_validate_opt_xfer_size(sdkp, dev_max)) {=0A=
=0A=
This does not look correct to me. This renders the device reported=0A=
opt_xfer_blocks useless.=0A=
=0A=
The unmodified code sets dev_max to the min of SD_MAX_XFER_BLOCKS or=0A=
SD_DEF_XFER_BLOCKS and of the device reported max_xfer_blocks. The result o=
f=0A=
this is used as the device max_dev_sectors queue limit, which in turn is us=
ed to=0A=
set the max_hw_sectors queue limit accounting for the adapter limits too.=
=0A=
=0A=
opt_xfer_blocks, if it is valid, will be used to set the io_opt queue limit=
,=0A=
which is a hint. This hint is used to optimize the "soft" max_sectors comma=
nd=0A=
limit used by the block layer to limit command size if the value of=0A=
opt_xfer_blocks is smaller than the limit initially set with max_xfer_block=
s.=0A=
=0A=
So if for your device max_sectors end up being too small, it is likely beca=
use=0A=
the device itself is reporting an opt_xfer_blocks value that is too small f=
or=0A=
its own good. The max_sectors limit can be manually increased with "echo xx=
x >=0A=
/sys/block/sdX/queue/max_sectors_kb". A udev rule can be used to handle thi=
s=0A=
autmatically if needed.=0A=
=0A=
But to get a saner default for that device, I do not think that this patch =
is=0A=
the right solution. Ideally, the device peculiarity should be handled with =
a=0A=
quirk, but that is not used in scsi. So beside the udev rule trick, I am no=
t=0A=
sure what the right approach is here.=0A=
=0A=
>> q->limits.io_opt =3D logical_to_bytes(sdp, sdkp->opt_xfer_blocks);=0A=
>> rw_max =3D logical_to_sectors(sdp, sdkp->opt_xfer_blocks);=0A=
>> } else {=0A=
>> -- =0A=
>> 2.29.0=0A=
>>=0A=
>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
