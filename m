Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5048DC77B7F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 May 2023 09:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjEPJPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 05:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbjEPJPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 05:15:12 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B669C7685
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 02:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684228458; x=1715764458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OqR+2AOCBlvt910R29a6PPeGMZe02ZRy+DsOCkHXKjE=;
  b=Gun7ZXsny57nuYLaMwVmK6cfRU4VFFB+Oh0CnQfS7IVDAlGRu6VKmjhr
   8sYNcKeR2uvw8keOgk66Ym4QmA68PFVbgeR1XJLmVoQHlZYQHpwvu3SxE
   fUJkl4TIC97OGiA1hrhu8eyqGWlpeK22HqrrVLvL+Tx04UX0txClWolxu
   d6AeBHQWCWWubAhhCpxf54jclH440Tn2VDZhe/BIEgaspvk4alOzyIzDs
   NNaFJuTFfFHNsiVZLik0ZGnPBRyx1uBOjauT1zjPDrTys3vGCYPDGb/aC
   +bwq4cAj0RKNizFs4bzzFCMHE34fyUS6Fg4l2BAB/0waJ+RlfGkLYI14U
   w==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677513600"; 
   d="scan'208";a="235843293"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2023 17:12:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxebWG20oGiB92OT95ePJrtyuHvQjApzY7KiqZKFd8Lz19qGHPAnKvSMLywkT6F8dJ1G5uCTvY3NeCBTfiPP91b9/t6xraPM1am3UBl7LBMU80pwR52pLtbOiwBeNKS2Y/LWmgtn5NNOmgy9BEr9JaddkKM8OMo7WMjmdvCNmBwT1/3ZmmJB5o6Zi/tGDDAlKmRuh8f8wLiE6r8G9+lKqi6bn/VID8z/+mcumNeKSztWN81Wyjg1/a3VYMAr3g+/FhDtdky7IQeE4Ki7CVCRa1B7HRiUi8wc0du7/3eXN3AD6XWoJ7/d4E9O6IEG2WxT9sXKpl98PNFtDp6Mmd9ADg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMGE8MRpLNRNswa1e3rhPZYhcVejYIxrn5RxJUlAwpc=;
 b=G9oEiGfIOy7BfrshC3kiViQvpopS6rEZDBdRHT8qQOQN9TXpr4biQ0oSLcfa1EO9/WOYVjuPXTUoin2UBMBfMgKPRbvxdja8MxLvtJ793vh8nMGGAFyzzFsp2zBrx1pafnboJRcGKVBUUEOm46ZE8aC7+RitJ63MIQZU143sZkTR09xL1AMYsLnpdz6jkrsazX/l0UY8wFduAukUyHNTfeYE80/gNFHXm3WyOTUxDF2UPauR9HVjDZBX59nI2+BNKMATH+385L0NBvTBvAmL3LGynTeWSaHMJwIwHnn9sjj/OXqYqmT1Fjct5X9zsTL0q/Ydly0MoKH/gaZSo0HqEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMGE8MRpLNRNswa1e3rhPZYhcVejYIxrn5RxJUlAwpc=;
 b=qRYX108vSDsRbKW7byOQa2yxVYMmw4SkE/ujqIeN3uA99EKzr+l+HlkCs8a3ZPcC8q79OW42OVEVgxqTl//MHCrWsZjCLMeE0ijqTGVtJLr3KTXa8/Fa4TbUsWZ8lEhfM1/wZKOJTk3ekg4b6XeJFFVtS/LDBIIVPxWBEsdrVt8=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SA2PR04MB7706.namprd04.prod.outlook.com (2603:10b6:806:140::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 09:12:56 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 09:12:55 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jason Yan <yanaijie@huawei.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] scsi: MAINTAINERS: Add a libsas entry
Thread-Topic: [PATCH] scsi: MAINTAINERS: Add a libsas entry
Thread-Index: AQHZh9aZoKgRSustokus68/rtytpMw==
Date:   Tue, 16 May 2023 09:12:54 +0000
Message-ID: <ZGNJFQztGO+bj6jV@x1-carbon>
References: <20230516025343.2050704-1-yanaijie@huawei.com>
In-Reply-To: <20230516025343.2050704-1-yanaijie@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SA2PR04MB7706:EE_
x-ms-office365-filtering-correlation-id: 16034d01-b101-4fc5-f367-08db55edbbbc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iKwmtZ0Gopxgphu4VI3hrXuaYMjoTTQtv6lsVOfQjuVWyk0jOtLyLeqnTKKkd3jKaxWdGJxYcKHLBWb78K/XL/1Z3YiQa67p7/C+RmkybSpePvZVn3p8jYSEpBQw1jvaL+5xwoy/2ydxI7aTMIz5NI2UX1dpjkmfqRmuNUXQ1bf79Oloueo1CzoXQv30tLmHCLE8kUZXu+8zI1zslTt6/N90Zzlg8evWKrYTz6PWs/YmkBcrj+LOBE9S+j44NYBOe1iagpfYk7d0I4WIZ6X/bcjDguHhoiBFF7xqVwFhafpUXR3VhKgzFarFaXIthIzdJ3VDx1gQ+OPXxjxbdaDf5j4X445WpZEklmdSSaV/FEEINH4s4mCa1VcyWjZxsIyEhG+tAlkQK1wbwHGbxlsXlMNnmsMGBS6oWwC4I6A8REGtS5ki+Keb0mLzNkqnKzWF/vM0iXWDDSB31B5l6Zhk7L5yzyKt3ohRzjW9/83URpx7YA0q56rIxm/IGUIqymCVWogvcIAEDXrY+YcEV3DvJ0vGbxwjpPrFu6RDAym7U2Ip0lw2M4qqOm1p/JtgbVanC96xYBU8ijf6QDJBIDJ355Q2uQ8TB16TXPWPNMQE5pNSBe6PbhsmcgdIrDOg20+cUweX1S3W+3fo2q4NBrcbZfxKKXC+902I5N4u0J012tIxVBpA3dg1CJNFBZIL0bYR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199021)(64756008)(4326008)(66556008)(478600001)(66476007)(6916009)(66946007)(76116006)(6486002)(66446008)(86362001)(91956017)(316002)(54906003)(6512007)(26005)(186003)(9686003)(6506007)(71200400001)(8936002)(8676002)(5660300002)(2906002)(82960400001)(33716001)(38070700005)(38100700002)(41300700001)(122000001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6Yl+sh4Kqe0iuF8v2RbfVHppAMDxeVRe7k/C58Tb4LDn0DXcV1eg+lyeqVxx?=
 =?us-ascii?Q?XvA4J1k1SmntN8LlWmKHb3bs0HVCOlmpE8Z4MirUbc+Hf4IZTz/bVooZgTZM?=
 =?us-ascii?Q?ucw3YC+bmVAiBMqus8iigd/QkUT6alanhTROsMb/btJYHsAbj3sFMHsjiGxm?=
 =?us-ascii?Q?GFVPM1ssTcHN0chGkkbdHo/Ukx7RxJEGQnnOisMDO5W9rdmCTHZ4aNedtg9p?=
 =?us-ascii?Q?5mlLxpafOw9wMLiITO1a1CJkG9OZPJseHXnCVYiUn6fKZrBiR1TR+vTMX4E4?=
 =?us-ascii?Q?UZtauK20dR9jKSs/1Txl/4JUIqAoe/iC19BqdQ31NmTgUX7BuFzzXerCHPz6?=
 =?us-ascii?Q?hsIzzNzNhBvynfE/e4W5krZOfL/RQfEC3sbP1oY6uRctOsMuM4FM/1TdAGWX?=
 =?us-ascii?Q?eNxMTWfDUb8BvY7SCdBXliE9TEWfftylzXQqht7n8Y9lAVdTmPKdJJVbeTIH?=
 =?us-ascii?Q?xial+bydEDBV2sdVNsyb1eecBlAvaXLRDla5YDwRQ2FtvFDk5/Nw6TIhQB3J?=
 =?us-ascii?Q?yC+Klz/4bBv9PJAnxYgngDJEVXzYtnUtl3yj5TnpNuHO3I9upO65/vqsaRDD?=
 =?us-ascii?Q?0heRuF7y7DWP5lxPrUQWn8HdNhT0FJpZH8vGk6kJ8JOy7hiH8GopQweI8cMd?=
 =?us-ascii?Q?+B2XFxvjqtITwO5eRT5Ldk2eif5fUWpZhyGnP+Qq2Sp/vmvMHKOim6A3UWwC?=
 =?us-ascii?Q?EdN4xCcFzQBEIpRh6ssYKEJhbEgU+r2bo2PyuTIcyOv9e7XbpS0CBc3bLsGc?=
 =?us-ascii?Q?Rs5xpcS5SKWVoUdqvuBGjhc2NFASBpGHgTneA/T9QmRJz4sfYtZnTVV7R35W?=
 =?us-ascii?Q?h9dGE0akLgdFV8avoex0RZeGyPLhZpOFgi93SNN3F9B0PkmF10d7LtlozLhX?=
 =?us-ascii?Q?4MGHv48LtlkOd3MUfVyikzZghxIx6B/zDSxoEb9CRQ3MyxKLq/LukbYtkVCz?=
 =?us-ascii?Q?VvdnFaqi6DeeJehmD77AqrBxPGy8eS8ObgFzs2YtzLFrRb1MEYgXpKtQNBZk?=
 =?us-ascii?Q?uLS9FYVa1bwwMbDQxQUuz3WF+/TKiKlJ//XeuitVZpXDFgEnkSZi8JG9CBZ1?=
 =?us-ascii?Q?Ui/SbJ5dl7YVvaTMYc/a/Q+JhCu4GaxgvIbK30WOsppyLulYFmlv+kOp53LU?=
 =?us-ascii?Q?iQFIb7OzmnUVwniFN3rpOc/3VAMud3rdfoSFXeeuBOsOLYMF/pOYQeiVbwhT?=
 =?us-ascii?Q?H/xVLkHXy+gjvWF8JC6PGILPTFZmgD780V4VPQHrW0uCWn0v+r0jHbsXy5hO?=
 =?us-ascii?Q?8LD2vQjNL4UPMGm6S+j+ES3z0HrWFBGwYNJFzbgbnGlffzWTzswhu9JDK7zz?=
 =?us-ascii?Q?OY0urPX5BIP1S0M3vlh5K/4WbXodxqYDdheQWmkFcn3dJVW8CPXPN8ug6TkA?=
 =?us-ascii?Q?d3+IPX9s9+UDp7zj/5nCmLse0AVWQqYwcT/Vzl5UlWIrG63koeSONPvZAAuu?=
 =?us-ascii?Q?YfqZlDmndmUf/Ha1ue0yhpFCB1gkNrd0htulluyDs4MM38n6wjrh3b0Ul52P?=
 =?us-ascii?Q?aveI44bqk4Cxruq5yP23ZhD4t5G1/UYXr4s5y/fgBBckLm9rc+B93ZsoWlxh?=
 =?us-ascii?Q?vMbCfHJBOTJREX/7FP35WQcajVUWo5RBi+v1mmzidCFxuAHLP+aVGDImY4GJ?=
 =?us-ascii?Q?PQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B6D61166EDB0E244BED08BD733B738A3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: R7xs2VLjVJCQDZXTEcCgAsWlrp6Ws3zclkUG8C0dhWPbOen2nJw4A7MyafnjAGYbsS5maFKIPEbXcgKdcGL9+KcDYLFQ57e39d9rEIhlMymJO+dbqxvQqbfu1xCgS3pRpX6R0E6jrSgA2jyEV/JTLPScu5PZBsWavOumJfgfsdBVp8lWZjqdjfZFIKJCb4Xz8nBGx0UGgUzwEK8omS9omanVD4le8sXa0GXKuLkT2jvsWCd7j5BhCHXlLH4DIu3NT2yDEPk/X7VkdL3blDntK9IuGg13edktYsmHBH1S8JJMJKyNDkOQZ69x0vywBxPM0tYv1lHl0sQ+SP+pevkfN9DDB+A28yjznKKH+qGS0oEs2x4+awWLRV+fhRwzCl/KC+z05j0CdW0Rt+MLJTpkZqM2OOIK6rDmnZBDdJBBQxRdxGeqvQPR7d/2YYzBxYBOzu6eVDgDbafRpLUkZRwIN8UxhpjWxdyQYNnPWvreJLApvvOw748CeQI2DG0tOz1+/s2sW+JoJqT0sHGe17JwM11+zhBjrzVzXGmB9tYhvvzFurzQdl6N0JG3N6VmA7KlbgIeylj5R63Ir3BnlnJabOxnjguGvHtYQmwfiUzT8btpRDiB4NqXWw/QCpeUQtjpNRv371UFDvwkpikyLPErTqFyqlHNG7G2r4QWDdwcKRJNsW0V2ybW69w9etJvErvQXcS1EP8SfOdV/gEFOXtsVQP4gsh/IyTHFIhuyV98yZP3R9b2nuEBj28roBVlwhWAqLFJ8UCG1RjFNrnQZjTDm+VSmWv8qwACiKV8KYL/k8R2MEy8LmS7z6foXeJQKBhXjqQWM41UHqkZEgJEwDIsxsXlmL3ikZ1EGi8gQOHSQ3JQEt+Q6x+0VePleMbMfoyC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16034d01-b101-4fc5-f367-08db55edbbbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 09:12:54.7885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RHjequ2oeSjzm41yPKbMzC3r+HdnW/Gr+49iV+xfcWMZ8Mdj8z/kFBilASiTM1CDu46zL1vD9pUM71aIGc/MPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7706
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 16, 2023 at 10:53:43AM +0800, Jason Yan wrote:
> John has been reviewing libsas patches for years. And I have been
> contributing to libsas for years and I am interested in reviewing and
> testing libsas patches too. So add a libsas entry and add John and me
> as reviewer.
>=20
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e0b87d5aa2e..a789811f6092 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18767,6 +18767,16 @@ F:	include/linux/wait.h
>  F:	include/uapi/linux/sched.h
>  F:	kernel/sched/
> =20
> +SCSI LIBSAS SUBSYSTEM
> +R:	John Garry <john.g.garry@oracle.com>
> +R:	Jason Yan <yanaijie@huawei.com>
> +L:	linux-scsi@vger.kernel.org
> +S:	Supported
> +F:	drivers/scsi/libsas

I would have preferred a final slash after libsas to more clearly highlight
that it is a directory, similar to how e.g. drivers/scsi/ or drivers/nvme/
is specified.

> +F:	include/scsi/libsas.h
> +F:	include/scsi/sas_ata.h
> +F:	Documentation/scsi/libsas.rst
> +
>  SCSI RDMA PROTOCOL (SRP) INITIATOR
>  M:	Bart Van Assche <bvanassche@acm.org>
>  L:	linux-rdma@vger.kernel.org
> --=20
> 2.31.1
>=20

Regardless:
Acked-by: Niklas Cassel <niklas.cassel@wdc.com>=
