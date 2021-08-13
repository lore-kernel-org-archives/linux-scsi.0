Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4B0C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 00:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F186109F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 00:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbhHMAai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 20:30:38 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:17429 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbhHMAai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 20:30:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628814611; x=1660350611;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=i9Xyu7P4fBngX2nd8m5ctW2cE3xN27Ca7GVNSQDO3DM=;
  b=h8oqOQMTvVCWn7nH5pKkKgf7XiWA3grWQ02lFVbuaXfqcxvIYoaVTnXF
   xBlswlndXzp01Ff4gig15ZkNJuwVvUiMI1LHwBD/WgeAPtBI19dUPtrfb
   8DgP8Hwy/jnpvIwCO6JRvge6WtKXOXoecdDn0cfTW+Xz0N1g6+niRgS8v
   y7/70F62PIqPxRqsXRtvDeBixKRmCvYYLRGfuD8AewZcP7QhD8YpLUOKp
   jBKGYY49vdUhT3Z9lh9wlARaaINYE2GzXuWR6bmj5VQJWprHPh8cfQgOM
   V1N1oyM+6FL3OZ0PXMkV89ewFF9mr73mm6oWbFNqVtRhobp+OMyYU7WHT
   g==;
X-IronPort-AV: E=Sophos;i="5.84,317,1620662400"; 
   d="scan'208";a="181902410"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 13 Aug 2021 08:30:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WW/jSDslZIjHNvHiHFIkmBUs6f97sSW1lkTzICGcFkAx2XUyrF3n8TMvB8aE1wik6G0cj8S5/IL18PqpGW0iwNy4wAk2zhpLzW0OIiqYv54l5pzqPzz1Ky0FrswDxT+v3O3l7ET1qVVi2gVfR/v2dvAKc4qO3zD2+5e6mm7emeNBmo82nngvLodabXIwisZ3rxEBqwTPnuryqziuWipXaTGDEiX2Ygb+rjvBeY/CGisnzQs1qH/HH48c1l5lHlvE4kD6WA4WGyWB0qVvlGDYBtR4wa8nSj/16g9zH7Us/sFL8U+kcgI3C6oN0webiVYZAHtHPS+jmlMF9qPAebc8RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9Xyu7P4fBngX2nd8m5ctW2cE3xN27Ca7GVNSQDO3DM=;
 b=Swqi1uQVANMLTYkSjVXm33Rt45PqyYfR7ZtQ+XvYuKx0xrV0BTmreiqf+mXTONGhYIK/gKy1TMIDeSpolqC72Iw0Uv9L8aySg7akQ+xzIzPpGAUR28HOdD0JvMLYxUwEGaWwgiooIpJY0fEsEBXbaeQYHiWKIn64tpbRFwatYrArzK6gtY8G8nzpMvh9custetiGdkfc7jfE3+FOA1AUXdYA66E6gSmDKFaCNpbV+N8+moNCim6odPsTdTrRuxIUYC0mVVy8mg0i9NH3orvKv83ofDWvEiZQvCJm/5wNU/u1KiS0E+YiEsxBf+p3uWl5UAh+G7rCF35YRhVWoGR7QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9Xyu7P4fBngX2nd8m5ctW2cE3xN27Ca7GVNSQDO3DM=;
 b=bS9XWnD2E8FotrPB3JP5p88+ySO7BLLLmguA4HurOGR9VZPPZ+FpQ5B0v8q4UKlYuEvAzSZNlvhyJKHui13RHz6u86lG4VI2sOwbs0InZs4M9IILldxnc8ZeijYzECHRNEIr7VbCyvGbwKf3modBZO+ogpS1XgqaJ5BG8tpYZo8=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4346.namprd04.prod.outlook.com (2603:10b6:5:a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Fri, 13 Aug
 2021 00:30:11 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4415.016; Fri, 13 Aug 2021
 00:30:11 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXj060+x8p8fG9EkmgObG6vBUOOw==
Date:   Fri, 13 Aug 2021 00:30:11 +0000
Message-ID: <DM6PR04MB708184CD5F221364BFCFDF47E7FA9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
 <a968069d-07df-396e-8ac6-04dfe3ee3040@kernel.dk>
 <yq1r1eyshs3.fsf@ca-mkp.ca.oracle.com>
 <743ace9d-2d10-f903-aa7f-cae3fbd1872f@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11206db3-8a43-47ed-638f-08d95df182cb
x-ms-traffictypediagnostic: DM6PR04MB4346:
x-microsoft-antispam-prvs: <DM6PR04MB4346538CA1D14E1FB577A61EE7FA9@DM6PR04MB4346.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8/1SNrfcq9j3cFGDNGOHT0+TN0lRV7F1e6B++Vk9zE7G6i01+wUETVOT9l/dqb6omkIg8iP02LlZFACpBTk6OPOjyv1sSFHIVSm1DumRdHyiSR8CDGFML0cK+RXCzGDl6z5icm5A+MCmxch6mdAxMXqNomBiv1nydq/G2J2m57SdPR2Zc5jCs3Qx2w4PtlovgZWNr1zqAm7LgGZd5qEQ681uI2DhnwSkEq3lR99OG260cpfRIhtKL2KVNENEDRJlGIAiySAAa5Njcsu5RimqJLr4hNxHgaEIZOjldES8Y+9a0w3NlbPhjj7vmt2735vFqm54otebF7WC/g+fmkUM5jRQ94D1kwLrKtowgCtwebpJc9F6cSkftsoINj94n9l78VnQ5GPBJiB5iU5Dkuu2PVJXzpBqrcfAW2QmBJ7fvu2JidDpHTUHrU9ZwYZXBSosRUElbOV+PJ7mFzIGpQLQSaFH/7RhF6qsqtNngHrcHW/qNeHwXei6uaPSenbHp1c15P20DKQllwayvNKfiYsvDBOWEi9m/bSN10VziC/r6WZI/X/PlKKWZx1n8OHjLhI0UR8h5tx2X/y1nvtSlM6XTm6mqjoLw/Ldgsxfp2gaSbvq23Z/g1BpzWD1l0vmrXuqJ+prulPsj3Zx0sNZy0/Hwhdfq7gP+i2Dho0+kEQ5i16aZ+lpDOyBhJ4cRfnsmAmje4FJ0y7q407fxhu+vQNW9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(55016002)(4744005)(83380400001)(7696005)(53546011)(8936002)(2906002)(33656002)(5660300002)(6506007)(86362001)(316002)(9686003)(38070700005)(54906003)(66446008)(66476007)(66556008)(66946007)(64756008)(4326008)(186003)(122000001)(38100700002)(76116006)(91956017)(8676002)(478600001)(71200400001)(110136005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K7xGUug0Yj2oV6mma+vW4tSnIwoPqHrFn9EfkgTg3nzlAhKdDwVRGlaiVs65?=
 =?us-ascii?Q?h8XjzPxJezmusgA9ZfWlrYlhA2z6fUufYRw438Zza5XFEabDe7lgsHpilSXC?=
 =?us-ascii?Q?C4oCiRZTdOLq7RALixthqWaIJak7qVwsjz0PL9z1A+oHKm5JteWb10xGQdei?=
 =?us-ascii?Q?8dNUIbGvOZK0wjEuefc62S4XVlk/Wk/VxmsE4TS1cFpQiWZ8QY+BepIk6hTG?=
 =?us-ascii?Q?SWZwvpMDb5mx4tg2su3nxgtEayjt8KHD7aM+CJe5wKdS+9qbrU4Zy/BpZe71?=
 =?us-ascii?Q?SGT5e8yF9bl694+nfT98Oz0Of/aRVY1wabvz3lWdquhJjcrXPM+dePxW83eA?=
 =?us-ascii?Q?2R5ouHaMN+MKUJZOn+W0wiLWX7JpWMwBTVuvrIt8+6CduCvN6WLDrUd7ij3M?=
 =?us-ascii?Q?8TPVL0FMxG1By3+N/0APkZRoUBLYltiY3GmZDTgimo/gOy85sAiiZnXEMg7B?=
 =?us-ascii?Q?9yTNGrXpIc9f8EkwqCEiqGIWxZMQX1d84UZ7/TpdsfZeKUT2BTEsLc7QPJuN?=
 =?us-ascii?Q?gVhox8G3P960ys1rdF/OwBlgmEjD07AfWVMLhXbkFpLXUi8TNklClm4PPsxS?=
 =?us-ascii?Q?G0InejyfBUcJt2Ols0zK64oo/7ROA/dWPIN8OXG5LTrNxWLIKzszPQhOyDU4?=
 =?us-ascii?Q?ax6XMi2x2JWxrKXCWI08FxkxoqTzWFn95+m/wQiuvBo1PmLjHYrrHZHURZuR?=
 =?us-ascii?Q?rwDTbjpw/CL2pftItOoiVN81jOXCFk4IGGeltON7UtZ+yMf+TJfcE4sp/xkJ?=
 =?us-ascii?Q?kvTfxUdHxi5BxjNuwlJ9LoJD0NJA6ecuMwF2h430+IMY4i4OBB+8sA16FHNN?=
 =?us-ascii?Q?l/EEkAvEsYkSlhJOKv3gEdqSvZgSvUWc+gKBMiJxULq/qaryDHZjjDup6zKo?=
 =?us-ascii?Q?LcFjynKyJKwmpYn+k2d0v5NA+Gr8pjDwutDaInLIKGDNN8DAcZcPrax3y7p2?=
 =?us-ascii?Q?b8Yqyrok0ulTJ4Vt+CGrt9D5VNrgH20wAXczG8rMi9SStMAjNCre6B8XyNTP?=
 =?us-ascii?Q?HIqseiCJx/IkXn5ucwYjWh5ktmjXW3C+DujfEC/CiULfjdkt2UCH1cNR5rRr?=
 =?us-ascii?Q?vN14Dl1/oTLbAxnbZvoyrzmQ8NXn9XqU2V0L8R2VoKcmr/VuFKo8kmx9GXfI?=
 =?us-ascii?Q?arTvV9hqpgCyzK/ZMSYZtmSfK3XBcSVdegVMN2MRWU6yfoIfDyrqhQByo/WF?=
 =?us-ascii?Q?9itM7nt1RGH8dOVfbrhIbIUzx18xSf4V0LWMnA8kOqxpi53Cu1slpkYnzySn?=
 =?us-ascii?Q?NKT7bz7ST+Wp+CspBPYkcHoVHnCuWQY16CrvC91o+1RXlsMVrC/4w7LGSw2y?=
 =?us-ascii?Q?i8KHBtaGi/TE/BCyrJvg5yoK9Nu+7xrQEPXCdaZMqyz97PjU5P42Pis8EGGk?=
 =?us-ascii?Q?LzC1+TaDX6D++s1cnW1z+gEGUOjZFxtf4Lwe0dzQ3rOlhRxUQw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11206db3-8a43-47ed-638f-08d95df182cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 00:30:11.0931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G/yFj0vZKD/78vPh+V0lFiMLjpAKSWAG/pr9o1g3h9iUDFfMIfNQzQg8Wfi0op2UptfkzgNGlIod9fXjPWoP2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4346
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/13 2:25, Jens Axboe wrote:=0A=
> On 8/12/21 11:21 AM, Martin K. Petersen wrote:=0A=
>>=0A=
>> Jens,=0A=
>>=0A=
>>> This looks good to me now - are we taking this through the block tree?=
=0A=
>>> If so, would be nice to get a SCSI signoff on patch 2.=0A=
>>=0A=
>> I'd like to do one more review pass. Also, it may be best to take patch=
=0A=
>> 2 through my tree since I suspect it will interfere with my VPD shuffle.=
=0A=
> =0A=
> That's fine, we can do it like that. I'll wait a day or two and pending=
=0A=
> any last minute changes, take 1,3-5 through block.=0A=
=0A=
Jens, Martin,=0A=
=0A=
Thanks.=0A=
=0A=
Without patch 1, patch 2 will cause compilation errors (disk_alloc_cranges(=
) and=0A=
disk_register_cranges() will be undefined). So may be both patch 1 & 2 shou=
ld=0A=
got through the scsi tree ?=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
