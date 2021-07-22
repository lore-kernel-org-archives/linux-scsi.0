Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4EBC4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 23:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FBB660E9B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 23:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhGVWpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 18:45:34 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:7497 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGVWpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 18:45:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626996368; x=1658532368;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ixDpfOa2AfBVk7JlPa4MErvy/+F2sacjR9UtObypX1E=;
  b=Aa0ONXZCsqkwlQajpkXBoJamYzM/tMqlnahl3v2Wb4nJJ1ZG0co6Gpi5
   ekV/RFfebndQD3Egqjxwn+pGS+8hynoa8+xB2kJzOXQnYjj6AzWi37Tqb
   iPcU72CkT5786bk6tFR7xsXEqFXHkexMdczSWBWbOBjQ6y7kVbuk3DcZZ
   vsaPCeNXAkau0Jn1aTBBZeUncizwo4erARSKSmutuPt5YaMc3yFDPFOGD
   q/5TtmFQx9YDIN0U5M/AnPwVJGB62Srjdfb73OHaHIy1l+3zju6V4w7zk
   Cow5dvFf5aI2hLfE+MA8Ng1FA8zg7DOJhCldWFSgvyurT6WCfCZjTKMxz
   w==;
X-IronPort-AV: E=Sophos;i="5.84,262,1620662400"; 
   d="scan'208";a="279113653"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2021 07:26:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFgoJnMcBQ3HrlD3JAOwx8psOww0qfaPoRIiuROTrQrYITCcTNxZUaiKwGYE6HOI6N6cEek4Cxi/ZzjVnvRwXPGNcCIzvq7mY6hNf7kewHM+JNUKcSFTuw7iiSEY6ORTgSa8XX7B9EbeuX2AXl53JQizSZXotDjghXJq4O3joDmI6CVWm7LVm2kBiQo6yqNS8mwFSq8TGGRkl3Fywm4bQlEQ9ytogaEPfi8Kj6t6cYe77HO/a/qPgg/Zcc2HhOSj3pqlAG46oHiCkEQufa5oSX0+DeJwd6VYCnS3MiARCuhD4GP4QWb2kjj1XvU3NTPvzeaFK1C+FNXwk120cgyYhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bft7etbuIu2ABIBJnEpix+7yGS/zrr7ZXvbIf4YX5zM=;
 b=S+nNAE82xoqKRiT1MzZd2v8vuN99TgaJkTs7Y/3v4tthsgiGy0mh+uVZcneO3V3h2l/xMmTwDciGfth1YP2+e5YAWXexjCdNFtHKCs7+yJa43UAG5dVPLgxCKKpfo4ww4jAMKT21P+8f4FFWPnr/itIzuG8YW4GhPXwtYD7Hd7HcUmUOjO9yifJNoOpJnTOEYERvN7LYWlKb3OaP8i85BxYFjoiAphvihppwzVIPK18arEqkzwrjiI0LgefAE8C/+zbIlSfumh1GHcMFH8oamirhQMAUq0FhQidBaUOgcQ2iCczQqwS+qm/iUlcJJoyNFZbBXoFVL3Ho3DV0NjfmHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bft7etbuIu2ABIBJnEpix+7yGS/zrr7ZXvbIf4YX5zM=;
 b=P9YP08ln274KORvzcrT9BmwG19PTxFxrBo7f4qWIOX+Hc136kZedTuxLYeqQnehrmvpS/k1RWiDOq9tCIz4zIG8nFWOzxtVFfTwzL8sy2Oo4zb2fQa8TII6U/0cRwQtOhmfxto1U4t4rtnhePlF9kb327SuU4eIAVSyaIgCvQpo=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6940.namprd04.prod.outlook.com (2603:10b6:5:241::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Thu, 22 Jul
 2021 23:26:06 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%8]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 23:26:06 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 2/4] scsi: sd: add concurrent positioning ranges support
Thread-Topic: [PATCH 2/4] scsi: sd: add concurrent positioning ranges support
Thread-Index: AQHXfh34bL0O+n0UlUuJPJrjf9ZNzg==
Date:   Thu, 22 Jul 2021 23:26:05 +0000
Message-ID: <DM6PR04MB70810B6EAE9FBF2F37EBB836E7E49@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
 <20210721104205.885115-3-damien.lemoal@wdc.com>
 <c24e49dd-2605-aa9d-a6d7-47e519788d51@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d5a707d-5d53-445f-4ac7-08d94d681437
x-ms-traffictypediagnostic: DM6PR04MB6940:
x-microsoft-antispam-prvs: <DM6PR04MB694020B5F84CAFEC5B60DA3CE7E49@DM6PR04MB6940.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2IZvli+Zlx2jmgEevOY+gaqeiKFwZGs0F6zVKx1y8a+4Vsa+kFmP+1nAE6c5oU/dof4Fz4O9oFY+ZeF4waGk1K97+M5h2ajRY8D5yguX/lhBSrzCBk3gbgy5hII6tp7MPufrYSvdlJAQ/LmGAtjVSeDGtKgKjJ5p1EGfgtR9/266nJk+GbalBY1rtt0rCw3pVZUruAJdTlOtiPhRIBWnshay+XvoxuldHyYKjOgVU69X5uQAxpoZyWRv7iaQ9kDnNywmQc8ZSSSlyohJzKAvtb76jiz6sz67lSHCp1UWWvoq+JMjSBznLFTBevQQ3lkNfVdZDc7pcC1cloP5yb7tJqAUhSePC7Im6E8+72VZObaoguHF2sWZLAEoeN1aL0B8JOvVroQXfj9hV20G//ox8Md4htoaJI6o2S6yGQ3D1fXJmwxriAN3x1zO+p1Y9St/LDI5woY9TpgrXyEpdHOeit5QqGs3IgMzextHU2fVfTz0jvc7nkEwjBszcBa1tVZ57+MQVRIJ7Da1iDrcDlYK0iGVAJdkT8dTjiKYxySd3VlOhEOFsmUZHJ/mjsV6rUvvGkxeagvg2HpYiM56k6T9ZdXk5jcVO3h13lEHcrQG/pHxCfAMsc2AEh0HNNXYkn27hERhTcRUE6qIvjIXbCBlCFekgWtwulNm1fpN0yfpk2xzdcY9jHbwjiGQNNEm5Nbse7Fs2Y36QoIlPoAeWH9q3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(5660300002)(71200400001)(53546011)(8676002)(186003)(122000001)(478600001)(110136005)(33656002)(8936002)(64756008)(38100700002)(86362001)(66446008)(6506007)(66556008)(2906002)(7696005)(91956017)(76116006)(55016002)(316002)(66476007)(9686003)(66946007)(52536014)(83380400001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wMaFTmd2JVsWEK30f5k6e/ySRjtzuHL0p9nfLgnfmr5QhDWk4QQlz/p66RBB?=
 =?us-ascii?Q?a8uBFnD1UUMiLO+0OnBElYhfx7TIxdaCYFfXfd2G18PcrwHXev9XgcM+KqUX?=
 =?us-ascii?Q?iCEnVwfZP+MjPU6DEve2MbtPRh//5mqpvYCu8OS5/xd81chZFnodX9jF6uO2?=
 =?us-ascii?Q?xNOz1pWQ8zJd4QehQxTdWq6PDTAMnZ7cGai0/Tl5H/crGCuHO+HCIkfyVxPe?=
 =?us-ascii?Q?nkH6TrjVQVUeJGp7v085tl8SJejTGvoVr7kiB8S9BthIGj7dEg5d5GPddKmg?=
 =?us-ascii?Q?NUVsdfR4/zOI15ldkt2kdFeYd0OSHuA1XMLhXOELamIPzbGh0YKUm1AhIlAJ?=
 =?us-ascii?Q?EM5E2ylvuhpHy5p2jrOcEfoQvYOqlq+sRxOV5TAedmsalJinscbFxXw1Jac2?=
 =?us-ascii?Q?vrEaiTkNsLDemRdU3Zcr3MrJ56BuLfHDAv4Cgt0ap22op1emxw5x2gv8YXyW?=
 =?us-ascii?Q?3DCj05nC61ioqg9GgTBVc2+ZvDuefFZLaqPIP3OO5jRrrAPY3UwXZ5Liiksf?=
 =?us-ascii?Q?VLWbebaE8/5Yxd1wVbLcApIxHsC0thnSFD1k2CTstl/dX5zQuHkq6Xu4wenv?=
 =?us-ascii?Q?SV4v1Vgb1iqa5YK353CBKCvX+xolQAlfsMJG220J96rnd+Z/sZA2BC+ReJ8d?=
 =?us-ascii?Q?yn7/XPdUu3wIqwRiWIJqxQtWtQB3fH/PbD9lKaTu9q7ltngw2JTammn+hQnW?=
 =?us-ascii?Q?KU9ovByJr8DJjP38syxajKcPnc1736BZZD6x6vNTsl3i2bNkFu+7VlbCVdCu?=
 =?us-ascii?Q?VOQKu+xCWT8mWd2FoNiFLikI2/RjVJvcaQe5u2LFBn+e+AjHq3nw6N2WWqiX?=
 =?us-ascii?Q?z14jV8OUKQnyp1lT8qjsH/m+BDoN3jmHSmX3HykfDneOu721Ym/tNOOp1cJ2?=
 =?us-ascii?Q?C4mF+zWu60bR4rl9op+4/3XbfiLjZqtxy7vsYs41ActKG+LN7XOGW8CE6goz?=
 =?us-ascii?Q?HrYjQF/QL55HwhhEOxAWrEfxGFF4z/zL4fR06LbuZDYJ1Jt/S+ZagUI1UjPH?=
 =?us-ascii?Q?VpmqZ74i70UAWsgzQdT7s7rZWmaZm/jlDDW/aL1RMLAUn2b8a1V9KT44jhIh?=
 =?us-ascii?Q?nPBzWYWr/IlZfJEC+VPxuTXg6DuEgv+U7sIpfdsUZ1HMnrBosSM99AnaFW6L?=
 =?us-ascii?Q?P+1dwXmE0px+4F+yn67oxDiQCTaYQ/3+jsGbRI9v9SOQNVrjijnBjUd7yEiI?=
 =?us-ascii?Q?muyoZulVsEfM8PQ7n5VLKvbSKxF2eAvFmBY4UH7HZgojwRFTXZ+WQsZh5rqT?=
 =?us-ascii?Q?sn9vKIi7DyrNFkB5FZlAsE4gzCLqODCxrMvLDDclOGNE9e7f79luW3HUCpDq?=
 =?us-ascii?Q?I1+8zYHeVCGA6QVXvRjg+ZvzEsr7HUSt2W6QL8+jqaVvctQKZZq0x3AoGW1b?=
 =?us-ascii?Q?xpzXEUWXO0GA+uyIYfACTmM0RCbWfhCw2m4lh/6rc21vlqZ9aw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5a707d-5d53-445f-4ac7-08d94d681437
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2021 23:26:05.9666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oyKeqBWZYRbG1G7YYjlYMed0PWZgrCiFWzbhtF0s8X/K7nrf2I9ovko0SowbsAA7bU70+yE4c8Xfr9+vJfHBFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6940
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/07/23 1:14, Hannes Reinecke wrote:=0A=
> On 7/21/21 12:42 PM, Damien Le Moal wrote:=0A=
>> Add the sd_read_cpr() function to the sd scsi disk driver to discover=0A=
>> if a device has multiple concurrent positioning ranges (i.e. multiple=0A=
>> actuators on an HDD). This new function is called from=0A=
>> sd_revalidate_disk() and uses the block layer functions=0A=
>> blk_alloc_cranges() and blk_queue_set_cranges() to set a device=0A=
>> cranges according to the information retrieved from log page B9h,=0A=
>> if the device supports it.=0A=
>>=0A=
>> The format of the Concurrent Positioning Ranges VPD page B9h is defined=
=0A=
>> in section 6.6.6 of SBC-5.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>   drivers/scsi/sd.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++=
=0A=
>>   drivers/scsi/sd.h |  1 +=0A=
>>   2 files changed, 81 insertions(+)=0A=
>>=0A=
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c=0A=
>> index b8d55af763f9..b1e767a01b9f 100644=0A=
>> --- a/drivers/scsi/sd.c=0A=
>> +++ b/drivers/scsi/sd.c=0A=
>> @@ -3125,6 +3125,85 @@ static void sd_read_security(struct scsi_disk *sd=
kp, unsigned char *buffer)=0A=
>>   		sdkp->security =3D 1;=0A=
>>   }=0A=
>>   =0A=
>> +static inline sector_t sd64_to_sectors(struct scsi_disk *sdkp, u8 *buf)=
=0A=
>> +{=0A=
>> +	return logical_to_sectors(sdkp->device, get_unaligned_be64(buf));=0A=
>> +}=0A=
>> +=0A=
>> +/**=0A=
>> + * sd_read_cpr - Query concurrent positioning ranges=0A=
>> + * @sdkp:	disk to query=0A=
>> + */=0A=
>> +static void sd_read_cpr(struct scsi_disk *sdkp)=0A=
>> +{=0A=
>> +	unsigned char *buffer, *desc;=0A=
>> +	struct blk_cranges *cr =3D NULL;=0A=
>> +	unsigned int nr_cpr =3D 0;=0A=
>> +	int i, vpd_len, buf_len =3D SD_BUF_SIZE;=0A=
>> +=0A=
>> +	/*=0A=
>> +	 * We need to have the capacity set first for the block layer to be=0A=
>> +	 * able to check the ranges.=0A=
>> +	 */=0A=
>> +	if (sdkp->first_scan)=0A=
>> +		return;=0A=
>> +=0A=
>> +	if (!sdkp->capacity)=0A=
>> +		goto out;=0A=
>> +=0A=
>> +	/*=0A=
>> +	 * Concurrent Positioning Ranges VPD: there can be at most 256 ranges,=
=0A=
>> +	 * leading to a maximum page size of 64 + 256*32 bytes.=0A=
>> +	 */=0A=
>> +	buf_len =3D 64 + 256*32;=0A=
>> +	buffer =3D kmalloc(buf_len, GFP_KERNEL);=0A=
>> +	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))=
=0A=
>> +		goto out;=0A=
>> +=0A=
>> +	/* We must have at least a 64B header and one 32B range descriptor */=
=0A=
>> +	vpd_len =3D get_unaligned_be16(&buffer[2]) + 3;=0A=
>> +	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {=0A=
>> +		sd_printk(KERN_ERR, sdkp,=0A=
>> +			  "Invalid Concurrent Positioning Ranges VPD page\n");=0A=
>> +		goto out;=0A=
>> +	}=0A=
>> +=0A=
>> +	nr_cpr =3D (vpd_len - 64) / 32;=0A=
>> +	if (nr_cpr =3D=3D 1) {=0A=
>> +		nr_cpr =3D 0;=0A=
>> +		goto out;=0A=
>> +	}=0A=
>> +=0A=
>> +	cr =3D blk_alloc_cranges(sdkp->disk, nr_cpr);=0A=
>> +	if (!cr) {=0A=
>> +		nr_cpr =3D 0;=0A=
>> +		goto out;=0A=
>> +	}=0A=
>> +=0A=
>> +	desc =3D &buffer[64];=0A=
>> +	for (i =3D 0; i < nr_cpr; i++, desc +=3D 32) {=0A=
>> +		if (desc[0] !=3D i) {=0A=
>> +			sd_printk(KERN_ERR, sdkp,=0A=
>> +				"Invalid Concurrent Positioning Range number\n");=0A=
>> +			nr_cpr =3D 0;=0A=
>> +			break;=0A=
>> +		}=0A=
>> +=0A=
>> +		cr->ranges[i].sector =3D sd64_to_sectors(sdkp, desc + 8);=0A=
>> +		cr->ranges[i].nr_sectors =3D sd64_to_sectors(sdkp, desc + 16);=0A=
>> +	}=0A=
>> +=0A=
>> +out:=0A=
>> +	blk_queue_set_cranges(sdkp->disk, cr);=0A=
> =0A=
> See? We are _are_ creating a new set of ranges.=0A=
> So why bother updating the old ones?=0A=
=0A=
See my reply to my comments on patch 1. We do not update the old ones. The =
cases=0A=
are:=0A=
1) This is the first call, q->cranges is NULL: cr will become q->cranges.=
=0A=
2) q->cranges is already set and cr has the same info as q->cranges (no cha=
nge):=0A=
cr will be freed by blk_queue_set_cranges().=0A=
3) q->cranges is already set and cr is different from q-cranges: q->cranges=
 will=0A=
be completely dropped and cr become the new q->cranges.=0A=
=0A=
So we never directly update anything inside q->cranges. We just swap in a n=
ew=0A=
full structure in case of change.=0A=
=0A=
>> +	if (nr_cpr && sdkp->nr_actuators !=3D nr_cpr) {=0A=
>> +		sd_printk(KERN_NOTICE, sdkp,=0A=
>> +			  "%u concurrent positioning ranges\n", nr_cpr);=0A=
>> +		sdkp->nr_actuators =3D nr_cpr;=0A=
>> +	}=0A=
>> +=0A=
>> +	kfree(buffer);=0A=
>> +}=0A=
>> +=0A=
>>   /*=0A=
>>    * Determine the device's preferred I/O size for reads and writes=0A=
>>    * unless the reported value is unreasonably small, large, not a=0A=
>> @@ -3240,6 +3319,7 @@ static int sd_revalidate_disk(struct gendisk *disk=
)=0A=
>>   		sd_read_app_tag_own(sdkp, buffer);=0A=
>>   		sd_read_write_same(sdkp, buffer);=0A=
>>   		sd_read_security(sdkp, buffer);=0A=
>> +		sd_read_cpr(sdkp);=0A=
>>   	}=0A=
>>   =0A=
>>   	/*=0A=
>> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h=0A=
>> index b59136c4125b..2e5932bde43d 100644=0A=
>> --- a/drivers/scsi/sd.h=0A=
>> +++ b/drivers/scsi/sd.h=0A=
>> @@ -106,6 +106,7 @@ struct scsi_disk {=0A=
>>   	u8		protection_type;/* Data Integrity Field */=0A=
>>   	u8		provisioning_mode;=0A=
>>   	u8		zeroing_mode;=0A=
>> +	u8		nr_actuators;		/* Number of actuators */=0A=
>>   	unsigned	ATO : 1;	/* state of disk ATO bit */=0A=
>>   	unsigned	cache_override : 1; /* temp override of WCE,RCD */=0A=
>>   	unsigned	WCE : 1;	/* state of disk WCE bit */=0A=
>>=0A=
> Otherwise:=0A=
> =0A=
> Reviewed-by: Hannes Reinecke <hare@suse.de>=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
