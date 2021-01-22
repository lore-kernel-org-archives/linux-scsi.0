Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE6EC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 07:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EB7D22DBF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 07:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbhAVHpR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 02:45:17 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:29227 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbhAVHpL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 02:45:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611301510; x=1642837510;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ULhtDML8fJvrWSbeOx1FIf2uY43Q0feRH/mC+cfBqxU=;
  b=Oxy2rhOz6E5sdpbNPspO4T4HgywY7xdMXlu9w+9BIHiAR241ppchXsQC
   pj7qJ0uXfhQ7sIiM6otb7qTkpVOQCpevjE7s8TqMJ55QcLCSW/nf1g+Py
   qarPtS3IQaPvWEEkh8wmcXUvuZZM1PDqrbohyi7YjdlvBmffO4Hpem0vz
   f+dx44odvAAq07+hcshRR9kPLq+4UgrjsczAYQH23PaUSrRgnQ1OL6UBx
   TliRLCu9BeWx+LkZ9ilAIUHdLLqiEJiKDqfuziVb4jyurJGqJ2j/g6ILY
   5vRdyQsy+drrW+l3kmhS/AzC14muT5kWsZH3KJGkD0OOIvni+MT6U/Q/i
   A==;
IronPort-SDR: A8FeYjfeBd9PCa1HUsRMUO4ipOi7yw6CHiC+xaNBEsgiIoHBJH9k/BrLw9JWUqPpbmp+kQWhuR
 eu59PuE/S3qa9WJOwjaz67nuU19umd9wR/87wkqMMD/2LT0x0cYExFoscTVtMfK7YZAhLeRE60
 KYHG8XN3uHk5cRAqriMExBzBV/m0j7t9to2LIRlEvml9G+ErymnNTnOv2tjInZDNyaVbLqgGTt
 DW5KzxgBpV0lRmgMlRdyjaK9htOg+t2k0fBR2D1R+ape45tMKX7zFXm4/gpiMJJOoduADyf3pb
 Uyc=
X-IronPort-AV: E=Sophos;i="5.79,366,1602518400"; 
   d="scan'208";a="268397862"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2021 15:44:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RN8LIiDGJbcm+fahf6uysK1yWXauRGE0O9dfhgYp3Sfimk88crcndtJalwxycFOHu9L3u4JAvNQ7KIzxdfaoXE4T6iR4R/+t8hSNr5wlzapJ7eUyojXSBn6WOyuKtCiMUFwI1etNFEhW+Paxpbv0QTKxFTiv3Us2nS3A6bk+ZmVIr5IMHF/VjOZPIZGgiLt1mTvzWgYQ2W651+MHc+YPFcn58k4FCil8LeXaCaenHY05QbxWxY7vc3WCf8SF9k5A8hYPpXCWXKfdZvNngDpwC5j7GsYydsXo1vqt6C+KAoe5nrp5rtmctYcOD0QQcSjtBCNsESKkrwV05/z6MaMDxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVfVRs1kB5/3cy/tZtfcNbFwbzPu7u3fhJj3OSNP6Mc=;
 b=ZzVCJEqRYtqNGOv39ABP0I187t0aM7HO4BVpUvVrwvfBW76ymcN1GtRJe+/vRQ37A+76N/71iR+r3/ewHYhvwFy8KhL4/xgNGo8K+eobiKxVLvvKk0aBit3jyd3niFafqGXc2FMpGTUHWAeMrPRh12y7Jgd1YBL8XpVaRldxfuXEMWaCJpYYhJF7nXPtYYFhdUhb5yFJsWStgxvnmk6n2Wp7+y+e/twc2r9Zom54WopoJmYFp/BAl4G1aa7NOfOmcMz+W8pJUU8cZHPFUQr44lDiz8VPMPCkU2Y5EHcnhvWAxYt4AK6hcjG18v6eC/RiGzmyD22skq7V7Rx61NjheQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVfVRs1kB5/3cy/tZtfcNbFwbzPu7u3fhJj3OSNP6Mc=;
 b=OjuazlWFJMWJ4n/1uOP4WJhDCOQcfK0BiA2+/i2pTmMhD8odR6LiHwMlqnMW0oFWdoOfP23lG13I3uy+w7zqE7Y8ezvFUJcm7Bnd3bUzwqBenekPMOD4vgLtVMuKgq7TowFHU5zvIK1wB8cguetjYT4qeb9zHcsgPdNHidbJHw0=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB4737.namprd04.prod.outlook.com (2603:10b6:208:46::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14; Fri, 22 Jan
 2021 07:44:00 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%8]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 07:44:00 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Changheun Lee <nanich.lee@samsung.com>
CC:     "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "jisoo2146.oh@samsung.com" <jisoo2146.oh@samsung.com>,
        "junho89.kim@samsung.com" <junho89.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "mj0123.lee@samsung.com" <mj0123.lee@samsung.com>,
        "oneukum@suse.com" <oneukum@suse.com>,
        "seunghwan.hyun@samsung.com" <seunghwan.hyun@samsung.com>,
        "sookwan7.kim@samsung.com" <sookwan7.kim@samsung.com>,
        "woosung2.lee@samsung.com" <woosung2.lee@samsung.com>,
        "yt0928.kim@samsung.com" <yt0928.kim@samsung.com>
Subject: Re: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
Thread-Topic: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
Thread-Index: AQHW6XfKh7ukksSNykCpKuE87ZdU0Q==
Date:   Fri, 22 Jan 2021 07:44:00 +0000
Message-ID: <BL0PR04MB6514C248B950F5FDB77B96EAE7A00@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <BL0PR04MB65144693C61F2192038FA5C0E7A20@BL0PR04MB6514.namprd04.prod.outlook.com>
 <CGME20210122072413epcas1p2d7bd97c9eae97b9b77d13e2c4a2f02f2@epcas1p2.samsung.com>
 <20210122070851.16105-1-nanich.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:2db5:5c10:5640:816d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8645ab4b-91ae-47ff-addb-08d8bea97bac
x-ms-traffictypediagnostic: BL0PR04MB4737:
x-microsoft-antispam-prvs: <BL0PR04MB47370AB19B9040E59AEB7609E7A09@BL0PR04MB4737.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4PrQuWYjTsKICCjFnPwjLIwDu9JGYkHzMEx35owvzOktTU6fQv6ZFgy5/4CQUxjmZAm+NkHsH8oT1uyZ1OdfMyyMhWmF8l33zB4RGwCEksKOF35pTkPkrN5p9Ll9q5G9SAXCnRuPGBbrfjWO3W4EduHMAEV3R0fKGBUjCp73ypDKKv2vyG4WCz31u6rSJ2ESHAR7x9RjjIT3/6YFsGGMTr98Rzq6UwCZ3XrpV7EHiVssp7EhF+9L5e6blWaMf8FLLUdPbmsOoUKycsEESV0amRuqa4cJp+D60G7IKvUwnCz8bo9yK6mL0dixBOc7IWcMLfBs6fOn7KemeiPvAdtdhHDkXNFtxdqKpSaYswhFASDPiBsd95B7x6Eltvsm0Z7kLhzW25fW70Plmp+na+gPVQX3pxmkZG9Sk7xiQiTrNDmhpAyQi8dvG+mARIDYgGrM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(83380400001)(478600001)(6506007)(53546011)(86362001)(7696005)(4326008)(5660300002)(64756008)(66946007)(8676002)(66556008)(66476007)(91956017)(76116006)(2906002)(66446008)(55016002)(8936002)(316002)(6916009)(9686003)(71200400001)(186003)(33656002)(52536014)(7416002)(54906003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CyF6mA6a9Ewrppb8b3RNmIugH+I9FSMOuUDVHDVXbtdatWpuntGddCk9rGcy?=
 =?us-ascii?Q?Hy/tmAiEzzuHv/qTpz9vEMHlnXFRGyyu+sMzIu404gRPzCEa0w4BI3nzGOGb?=
 =?us-ascii?Q?xbYC62LG2s3btjEvNkP50Bb15hKpXolQIV+U8XOfXoaMTgyxCzlSvxaG1GrF?=
 =?us-ascii?Q?6eMTgvLkc14BuLDCPiVN9Cm5EIb73atZ8BMEKJ0TIlJ5oqHPgejePYMDRcse?=
 =?us-ascii?Q?7zCbpUDBoVcbvj9GLOA7653TqxPy3a4XOeAoWsylKbCYIdYqzI6eBgyxhXNm?=
 =?us-ascii?Q?HNx2q2SHA18HvBpjuL7F2iZVX4PPmZeoKfXRsZNS8K6MyZGScm+kc3U3O39b?=
 =?us-ascii?Q?zlBMrVTYdyAHkm6u8e+aItta6RhaiJVolpqSxsQO/E0tkhsyxFns206RttFe?=
 =?us-ascii?Q?ys5PkQvp8l7A5IeNnZROSMYcZ4f+upQQz1xXZHVS7WeoNZ7OLKD+OIUJhu/b?=
 =?us-ascii?Q?DX2TNc8kcY+Cov9jGsoyUtjTwrsr90222JNuzmHj5hdFS7Tg0+G/6SM51O17?=
 =?us-ascii?Q?kjZtrLHKmTWZyQ4iq1KaL4TA0bEFNgRob8udexEK7tAuXnywQPwthpw+/kZi?=
 =?us-ascii?Q?s9q9DCXtCXvQmN8xuH3+ZefcTYXsfE1Lvvk3HKxrH1tUhHYtpGLwMbfK+vI6?=
 =?us-ascii?Q?2/DbmF+3rd/0LDR0aeDnOhk8jaCGX/WeFC1Y/5SNHpxCIG4S7gSDVz4yldCW?=
 =?us-ascii?Q?8ahMDfugjQwJ8EneplOShx+ezG+YvOclyJ7d43CAdRHcQJUdMzDjQEMinsFY?=
 =?us-ascii?Q?TdHcZPGnWN0gZ5+3tb1MO0Kh2BikmeKuirtwQ8j8rMR2Ylqao2llFxQR9Fd/?=
 =?us-ascii?Q?jmy+FwuD+x2lmGM0PfbNRV0N13x/CKWIGYd89utISCnl5O1v8VtBgmPhza6K?=
 =?us-ascii?Q?DmrxbityMigbLzl+FKX1G3dlBXZxPzsPnlE4UYgx0O1Kn7Svg/PsBHMC8+ot?=
 =?us-ascii?Q?woeJ+INT0rtfYGuhQJwvFoQCxukMOPMbrEDWZLuZuD0586KDYfT3tSff/NAE?=
 =?us-ascii?Q?eo0w+B2pDTukK9LxJq/6jHOZba1Nw31FhEibN0dN3LrXLwKFY7vSBTuyZo/1?=
 =?us-ascii?Q?pXSMKWOpHTWAdbQLg6+KO221XbQCL7DcIFBKJLiHSCSeRBKH0ErVn7fLZ5Zd?=
 =?us-ascii?Q?0CQwqufGA09PpzgH/nUC4wZrUUr0+UnZEw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8645ab4b-91ae-47ff-addb-08d8bea97bac
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 07:44:00.5166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1IyioOCzHE+ob1KP/io7wU/qgMJ3zdkhNEFuO89T1mt6L7+JgbH1Uj4srYwC7H6pv9o9ati+R1Osoyw/QdjgeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4737
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/22 16:24, Changheun Lee wrote:=0A=
>> On 2021/01/20 15:45, Manjong Lee wrote:=0A=
>>> Add recipients for more reviews.=0A=
>>=0A=
>> Please resend instead of replying to your own patch. The reply quoting c=
orrupts=0A=
>> the patch.=0A=
>>=0A=
>> The patch title is very long.=0A=
>>=0A=
>>>=0A=
>>>> SCSI device has max_xfer_size and opt_xfer_size,=0A=
>>>> but current kernel uses only opt_xfer_size.=0A=
>>>>=0A=
>>>> It causes the limitation on setting IO chunk size,=0A=
>>>> although it can support larger one.=0A=
>>>>=0A=
>>>> So, I propose this patch to use max_xfer_size in case it has valid val=
ue.=0A=
>>>> It can support to use the larger chunk IO on SCSI device.=0A=
>>>>=0A=
>>>> For example,=0A=
>>>> This patch is effective in case of some SCSI device like UFS=0A=
>>>> with opt_xfer_size 512KB, queue depth 32 and max_xfer_size over 512KB.=
=0A=
>>>>=0A=
>>>> I expect both the performance improvement=0A=
>>>> and the efficiency use of smaller command queue depth.=0A=
>>=0A=
>> This can be measured, and this commit message should include results to =
show how=0A=
>> effective this change is.=0A=
>>=0A=
>>>>=0A=
>>>> Signed-off-by: Manjong Lee <mj0123.lee@samsung.com>=0A=
>>>> ---=0A=
>>>> drivers/scsi/sd.c | 56 +++++++++++++++++++++++++++++++++++++++++++----=
=0A=
>>>> 1 file changed, 52 insertions(+), 4 deletions(-)=0A=
>>>>=0A=
>>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c=0A=
>>>> index 679c2c025047..de59f01c1304 100644=0A=
>>>> --- a/drivers/scsi/sd.c=0A=
>>>> +++ b/drivers/scsi/sd.c=0A=
>>>> @@ -3108,6 +3108,53 @@ static void sd_read_security(struct scsi_disk *=
sdkp, unsigned char *buffer)=0A=
>>>> sdkp->security =3D 1;=0A=
>>>> }=0A=
>>>>=0A=
>>>> +static bool sd_validate_max_xfer_size(struct scsi_disk *sdkp,=0A=
>>>> +				      unsigned int dev_max)=0A=
>>>> +{=0A=
>>>> +	struct scsi_device *sdp =3D sdkp->device;=0A=
>>>> +	unsigned int max_xfer_bytes =3D=0A=
>>>> +		logical_to_bytes(sdp, sdkp->max_xfer_blocks);=0A=
>>>> +=0A=
>>>> +	if (sdkp->max_xfer_blocks =3D=3D 0)=0A=
>>>> +		return false;=0A=
>>>> +=0A=
>>>> +	if (sdkp->max_xfer_blocks > SD_MAX_XFER_BLOCKS) {=0A=
>>>> +		sd_first_printk(KERN_WARNING, sdkp,=0A=
>>>> +				"Maximal transfer size %u logical blocks " \=0A=
>>>> +				"> sd driver limit (%u logical blocks)\n",=0A=
>>>> +				sdkp->max_xfer_blocks, SD_DEF_XFER_BLOCKS);=0A=
>>>> +		return false;=0A=
>>>> +	}=0A=
>>>> +=0A=
>>>> +	if (sdkp->max_xfer_blocks > dev_max) {=0A=
>>>> +		sd_first_printk(KERN_WARNING, sdkp,=0A=
>>>> +				"Maximal transfer size %u logical blocks "=0A=
>>>> +				"> dev_max (%u logical blocks)\n",=0A=
>>>> +				sdkp->max_xfer_blocks, dev_max);=0A=
>>>> +		return false;=0A=
>>>> +	}=0A=
>>>> +=0A=
>>>> +	if (max_xfer_bytes < PAGE_SIZE) {=0A=
>>>> +		sd_first_printk(KERN_WARNING, sdkp,=0A=
>>>> +				"Maximal transfer size %u bytes < " \=0A=
>>>> +				"PAGE_SIZE (%u bytes)\n",=0A=
>>>> +				max_xfer_bytes, (unsigned int)PAGE_SIZE);=0A=
>>>> +		return false;=0A=
>>>> +	}=0A=
>>>> +=0A=
>>>> +	if (max_xfer_bytes & (sdkp->physical_block_size - 1)) {=0A=
>>>> +		sd_first_printk(KERN_WARNING, sdkp,=0A=
>>>> +				"Maximal transfer size %u bytes not a " \=0A=
>>>> +				"multiple of physical block size (%u bytes)\n",=0A=
>>>> +				max_xfer_bytes, sdkp->physical_block_size);=0A=
>>>> +		return false;=0A=
>>>> +	}=0A=
>>>> +=0A=
>>>> +	sd_first_printk(KERN_INFO, sdkp, "Maximal transfer size %u bytes\n",=
=0A=
>>>> +			max_xfer_bytes);=0A=
>>>> +	return true;=0A=
>>>> +}=0A=
>>=0A=
>> Except for the order of the comparisons against SD_MAX_XFER_BLOCKS and d=
ev_max,=0A=
>> this function looks identical to sd_validate_opt_xfer_size(), modulo the=
 use of=0A=
>> max_xfer_blocks instead of opt_xfer_blocks. Can't you turn this into som=
ething like:=0A=
>>=0A=
>> static bool sd_validate_max_xfer_size(struct scsi_disk *sdkp,=0A=
>> const char *name,=0A=
>> unsigned int xfer_blocks,=0A=
>> unsigned int dev_max)=0A=
>>=0A=
>> To allow checking both opt_xfer_blocks and max_xfer_blocks ?=0A=
>>=0A=
>>>> +=0A=
>>>> /*=0A=
>>>> * Determine the device's preferred I/O size for reads and writes=0A=
>>>> * unless the reported value is unreasonably small, large, not a=0A=
>>>> @@ -3233,12 +3280,13 @@ static int sd_revalidate_disk(struct gendisk *=
disk)=0A=
>>>>=0A=
>>>> /* Initial block count limit based on CDB TRANSFER LENGTH field size. =
*/=0A=
>>>> dev_max =3D sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOC=
KS;=0A=
>>=0A=
>> This looks weird: no indentation. Care to resend ?=0A=
>>=0A=
>>>> -=0A=
>>>> -	/* Some devices report a maximum block count for READ/WRITE requests=
. */=0A=
>>>> -	dev_max =3D min_not_zero(dev_max, sdkp->max_xfer_blocks);=0A=
>>>> q->limits.max_dev_sectors =3D logical_to_sectors(sdp, dev_max);=0A=
>>>>=0A=
>>>> -	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {=0A=
>>>> +	if (sd_validate_max_xfer_size(sdkp, dev_max)) {=0A=
>>>> +		q->limits.io_opt =3D 0;=0A=
>>>> +		rw_max =3D logical_to_sectors(sdp, sdkp->max_xfer_blocks);=0A=
>>>> +		q->limits.max_dev_sectors =3D rw_max;=0A=
>>>> +	} else if (sd_validate_opt_xfer_size(sdkp, dev_max)) {=0A=
>>=0A=
>> This does not look correct to me. This renders the device reported=0A=
>> opt_xfer_blocks useless.=0A=
>>=0A=
>> The unmodified code sets dev_max to the min of SD_MAX_XFER_BLOCKS or=0A=
>> SD_DEF_XFER_BLOCKS and of the device reported max_xfer_blocks. The resul=
t of=0A=
>> this is used as the device max_dev_sectors queue limit, which in turn is=
 used to=0A=
>> set the max_hw_sectors queue limit accounting for the adapter limits too=
.=0A=
>>=0A=
>> opt_xfer_blocks, if it is valid, will be used to set the io_opt queue li=
mit,=0A=
>> which is a hint. This hint is used to optimize the "soft" max_sectors co=
mmand=0A=
>> limit used by the block layer to limit command size if the value of=0A=
>> opt_xfer_blocks is smaller than the limit initially set with max_xfer_bl=
ocks.=0A=
>>=0A=
>> So if for your device max_sectors end up being too small, it is likely b=
ecause=0A=
>> the device itself is reporting an opt_xfer_blocks value that is too smal=
l for=0A=
>> its own good. The max_sectors limit can be manually increased with "echo=
 xxx >=0A=
>> /sys/block/sdX/queue/max_sectors_kb". A udev rule can be used to handle =
this=0A=
>> autmatically if needed.=0A=
>>=0A=
>> But to get a saner default for that device, I do not think that this pat=
ch is=0A=
>> the right solution. Ideally, the device peculiarity should be handled wi=
th a=0A=
>> quirk, but that is not used in scsi. So beside the udev rule trick, I am=
 not=0A=
>> sure what the right approach is here.=0A=
>>=0A=
> =0A=
> This approach is for using sdkp->max_xfer_blocks as a rw_max.=0A=
> There are no way to use it now when sdkp->opt_xfer_blocks is valid.=0A=
> In my case, scsi device reports both of sdkp->max_xfer_blocks, and=0A=
> sdkp->opt_xfer_blocks.=0A=
> =0A=
> How about set larger valid value between sdkp->max_xfer_blocks,=0A=
> and sdkp->opt_xfer_blocks to rw_max?=0A=
=0A=
Again, if your device reports an opt_xfer_blocks value that is too small fo=
r its=0A=
own good, that is a problem with this device. The solution for that is not =
to=0A=
change something that will affect *all* other storage devices, including th=
ose=0A=
with a perfectly valid opt_xfer_blocks value.=0A=
=0A=
I think that the solution should be at the LLD level, for that device only.=
 But=0A=
I am not sure how to communicate a quirk for opt_xfer_blocks back to the ge=
neric=0A=
sd driver. You should explore a solution like that. Others may have ideas a=
bout=0A=
this too. Wait for more comments.=0A=
=0A=
> =0A=
>>>> q->limits.io_opt =3D logical_to_bytes(sdp, sdkp->opt_xfer_blocks);=0A=
>>>> rw_max =3D logical_to_sectors(sdp, sdkp->opt_xfer_blocks);=0A=
>>>> } else {=0A=
>>>> -- =0A=
>>>> 2.29.0=0A=
>>>>=0A=
>>>>=0A=
>>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
