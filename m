Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B22C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 17:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53EA823DC2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 17:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395083AbgLKQ1V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 11:27:21 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22500 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732836AbgLKQ1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 11:27:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607704183; x=1639240183;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=/0LRgM6P7Jw0ITHgnURkK9KPdHGJx3EOGYmQvmd4TBU=;
  b=lMHEpYtNGxqYSP0nESxgiBDndejbLFYb77X7Wd7zvQTbjQnG8G4Rd27T
   ksEgSlKnPBn7LSg/IehbtNw8PMVuGR+zJcPvgpPrIOo5kb4LZs8iFMwtd
   P52VJr1mgLGWPMq4irGN83QHOCekajchfxlEYRFQNSN39sQxOevR1zQwJ
   Vm8S1TdxzSurzo9wZvkZur/a4sgFwufB4Vj/j0ixC8u3mgojQwrs2wPsV
   YaN82ubRZ0nDyGYrxHtor2mwaWK1fPkDGpFEc/96ZKBvMSIv1CEiUeO9W
   jaNH2vcMIqUetX3oyZz/toYp+rc5jjHj/iT1B/45qKi/5PSLbFEibesS4
   w==;
IronPort-SDR: 3KFJbNYFL8JmzKKepNliLy4A9LmIeAaXx/Y0Xr3GF+GVUEk76BG9X0ex2Cs3RYbAPBPfcO/DAh
 wxxtTdFc1CSFkDhMaxtJPbtzJJCJ6oo3jfEq8iYkmJcelAmE+l4sN3hTGPZZ58f+OxBik6Qyrj
 tE3WkUkvYcDAKUVCCoz/tqmuoawmvfDmg7zvw/idgCe1UCZcCXp5RimGLiePVUAL35nOo68ksu
 oSrZlRaWuWAQDKGdb5g5MmMgmNUStrzF348M+XHQ0YtICIyI5JbaWyVH7vyo4+Pvlm1CKHGQ9c
 4K8=
X-IronPort-AV: E=Sophos;i="5.78,411,1599494400"; 
   d="scan'208";a="258685781"
Received: from mail-bl2nam02lp2056.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.56])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2020 00:28:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJJpMSdn6mH/E43AdtJz35QXgn5BNsWNoFOxgeKGKFP44pruEXKMGH/Ffrz2d6WMJF8Dplk2BT6uEClJwkI0ZFgZIJjuvGaZBX0jvkrHGb7sgEiSc4BVR5X1CrM5BSwl+MZ8gJ7UobT0VrIRFrzzlomgu8SgB+UjoCF5MvA3XD/5e8ZCW0kfAutjKK21PWUYDmpBBTJfrCOyU5DG3HDpgkDXgo42aNBAe3mZvRZOYxB5PrpZUU19YcGDJx0TlaTdmdb4B4Swj9CH4YuI0lb2ALQ0UxKxaOwB+9AdtKNMnmXFt3ItCog8kzJBkxkmRgonMf7ZWm2CNvzWAo8ijwggMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pU8po3KooHPk9dZPeptM1TmsRMACH+3oAr2oqpho3zA=;
 b=aJPwqxsJphJXyXwBXrIb5Sx5PTZWCEmGogBVDTzPhhAPNM0qAyA53T3tM8uIcv4qT6F4r6NVY5oqWHIzIs7PzneJ4dzW5VrQ70zwHbCx+TLkh+2xb/aOYPh79QGaMcIz5J7ystB5oNm+IN/HB2zgA7UeMobV8Obp++HuH/s1HszZOULR60t5TLBEjS8R47Gb7BPo4AwbtwoxSvN7om6ktWuxkYckcpK9EMo2lQWNxVGK6nMdbodmfZpTNzKc2UM456yKbg/sgooBp34HCje9ugPEw/QXXaDiXxmcFE1+E1L5nTHt/G7zHxl2Pnywh7I15R+xcdQrLcoNE7QMlc1BuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pU8po3KooHPk9dZPeptM1TmsRMACH+3oAr2oqpho3zA=;
 b=TmB0pZg5Lp/yhBiTBEJfNLu1/Wy6fC4iDxwz1tYUehruRv2s2TvDbLbTOBinFHNS+rGrRysFt2oT5orWBShGzznEnWEqPRgceUZ5CUyF9vvGzgqpIWsPOw+zxPLIIPJuAUQ1crHRHsAXJqkJwQD42Xh3ilizMpcUETf6As8ub20=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN2PR04MB2143.namprd04.prod.outlook.com
 (2603:10b6:804:e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Fri, 11 Dec
 2020 16:25:57 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038; Fri, 11 Dec 2020
 16:25:57 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
CC:     "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
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
Subject: Re: [RFC PATCH v3 1/2] block: add simple copy support
Thread-Topic: [RFC PATCH v3 1/2] block: add simple copy support
Thread-Index: AQHWz83y7bUu+jQhLUujuAOdfzAPcw==
Date:   Fri, 11 Dec 2020 16:25:57 +0000
Message-ID: <SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
 <CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com>
 <20201211135139.49232-2-selvakuma.s1@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 350dcab8-f7d2-4aef-4f64-08d89df170a1
x-ms-traffictypediagnostic: SN2PR04MB2143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN2PR04MB21439BAF7E03A5EE175205B59BCA0@SN2PR04MB2143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0/z9C2lKihgmLqDmO0DBr1PGZyf00HH7Ob61BT6gRF43tEFb/ZsGSQcXGJ93yhS1JWh12J6Y8WIOL1CEdH9F0Of+l6NCqGJVQj1bYipHxfltEK/1vJmSGobAboNiu/VP2FiezXjeppSwVNmHhIWM2iknZ/u6neQ6oUyADEXq++EKDqqZlV/bOpEudkP5bavTPDyWGjVVzZzU9Lf1HVe1Su9Oq9o+4UkCT3aoSUmKp47J3V+hs5HWEkn11RbvTizEVJQjWUMfpURqBdqZZp5ItHO/dHR6jKSP6HpjkSOSm45LU1hpZ8vTHoowt9jYdNCZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(2906002)(76116006)(66476007)(64756008)(186003)(66446008)(71200400001)(110136005)(53546011)(7416002)(33656002)(55016002)(52536014)(8676002)(66946007)(8936002)(86362001)(7696005)(83380400001)(66556008)(9686003)(4326008)(91956017)(508600001)(54906003)(26005)(6506007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?o/8mc+OP6SxgDy2SY29553XGgMWUazCqlMZ/q7HEJN0FxceCRvbYOLZ3Tanu?=
 =?us-ascii?Q?/A/4I8KgrP67ni/BwPHFOOA+2Wtim9bhg84QAfq1oXKfHYsMmKtQjzffjVu2?=
 =?us-ascii?Q?lEqs1wwEBB59nFJlKHpBrAm6JBUN6GinBc2wWpi+6LLXO3M+ovivARgVctqm?=
 =?us-ascii?Q?Tka24Jjx0EA7eULiMDgJyeizzxnYmjLggBkkoER7Gho3rfQBkny1MRDSVuUJ?=
 =?us-ascii?Q?KtGr5658jfXz5Rse9wktl4L3gHtXpiHS3AypJKuDFjE2AHRkz54u201GtKvN?=
 =?us-ascii?Q?uzjxkZLAn9AHU7usg89Gev2sb2sYaSGB5jsixjknObyE9EyofhrWj0wcbEud?=
 =?us-ascii?Q?jIEm7rZO+3UqI6kLBgIRwoktzilB1ZuDsoDObX3436vLScDyu1hCLWlhzY1u?=
 =?us-ascii?Q?EtE51lgejkbncUGvnZus718YG81NGL9ylXx1R3Lget+a9wOoiOIZMy+2sF4V?=
 =?us-ascii?Q?KyeTLQG0Ilpz4XuO84883FURUKJBl+3u/2pT8d8nouMrNFJQFTknXsxnXv5H?=
 =?us-ascii?Q?EAzvfpPyZXSiqUZgDXuSACA/XfSQ9LDlte73tXDEd/945NKQMC9EeQxbluP7?=
 =?us-ascii?Q?0lp3UhWASumQMmCrsFWlzAnglQICpfBE7+JUrG5GmlH9B5yKsYA9Pi+yywlK?=
 =?us-ascii?Q?gRJbo1Aa4icr3QB4Dt2hnxzgLggw/zXPC2YS8vS2OPROe9ggBMe+Z8/0r6DS?=
 =?us-ascii?Q?OEjfZ+/HKaYHIBIOaI1DX9LVPchVZIJZgnV+TqN1yAqvLsxcO7mKVjB9O/4s?=
 =?us-ascii?Q?zEBuC7dP/Rv8SZXhZERznY8HzqdeuYyPBFenWz/vmaeuzKBzWWWtYFrJSdj2?=
 =?us-ascii?Q?rpvPkQLXc0a5NwUXlqM66MxJRBSB5OVYRhChA2ncFA55DlvVc6I1+xFUpBsI?=
 =?us-ascii?Q?qOoRvIteb6KCNVCL25ohU1lXc+skO7wPSgA/15LS55UcQs91YaiFmNtGVNr1?=
 =?us-ascii?Q?r9Q4o1gQxa2iDEBO/5Q8NW40wCr/uNZAA2TRdmNF+bavxG0+9r0TFVfC80Cn?=
 =?us-ascii?Q?Wl3R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350dcab8-f7d2-4aef-4f64-08d89df170a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2020 16:25:57.3695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: djyFGdR9AjKUyY8KLcZJgBfxKBS+dY9MYgddnJvK575qF22vOpzJ26qaDm+jl3oxtgEGEWDkuazNWm9hj4Faqg2nvJo7nYsgbgksG/0Yd9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2143
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/12/2020 15:57, SelvaKumar S wrote:=0A=
[...] =0A=
> +int blk_copy_emulate(struct block_device *bdev, struct blk_copy_payload =
*payload,=0A=
> +		gfp_t gfp_mask)=0A=
> +{=0A=
> +	struct request_queue *q =3D bdev_get_queue(bdev);=0A=
> +	struct bio *bio;=0A=
> +	void *buf =3D NULL;=0A=
> +	int i, nr_srcs, max_range_len, ret, cur_dest, cur_size;=0A=
> +=0A=
> +	nr_srcs =3D payload->copy_range;=0A=
> +	max_range_len =3D q->limits.max_copy_range_sectors << SECTOR_SHIFT;=0A=
> +	cur_dest =3D payload->dest;=0A=
> +	buf =3D kvmalloc(max_range_len, GFP_ATOMIC);=0A=
=0A=
Why GFP_ATOMIC and not the passed in gfp_mask? Especially as this is a kvma=
lloc()=0A=
which has the potential to grow quite big.=0A=
=0A=
> +int __blkdev_issue_copy(struct block_device *bdev, sector_t dest,=0A=
> +		sector_t nr_srcs, struct range_entry *rlist, gfp_t gfp_mask,=0A=
> +		int flags, struct bio **biop)=0A=
> +{=0A=
=0A=
[...]=0A=
=0A=
> +	total_size =3D struct_size(payload, range, nr_srcs);=0A=
> +	payload =3D kmalloc(total_size, GFP_ATOMIC | __GFP_NOWARN);=0A=
=0A=
Same here. =0A=
=0A=
=0A=
> diff --git a/block/ioctl.c b/block/ioctl.c=0A=
> index 6b785181344f..a4a507d85e56 100644=0A=
> --- a/block/ioctl.c=0A=
> +++ b/block/ioctl.c=0A=
> @@ -142,6 +142,47 @@ static int blk_ioctl_discard(struct block_device *bd=
ev, fmode_t mode,=0A=
>  				    GFP_KERNEL, flags);=0A=
>  }=0A=
>  =0A=
> +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,=0A=
> +		unsigned long arg, unsigned long flags)=0A=
> +{=0A=
=0A=
[...]=0A=
=0A=
> +=0A=
> +	rlist =3D kmalloc_array(crange.nr_range, sizeof(*rlist),=0A=
> +			GFP_ATOMIC | __GFP_NOWARN);=0A=
=0A=
And here. I think this one can even be GFP_KERNEL.=0A=
=0A=
 =0A=
=0A=
