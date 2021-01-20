Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8662DC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 594BD2333C
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbhATL0k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 06:26:40 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63142 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731403AbhATKsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 05:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611139684; x=1642675684;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=U3ssmbCYg6NvVscu4SdbntHO3Sa6+6ksLuNOg034rCQ=;
  b=H/M1XuX+xko4Rj6LopUseSutT8lidjTIMbPnYysY7ZHa3MeeqG1lPcj+
   jNkLL0hMEivrZ8I/U/jCPtrlvyYCqg5Q+KsH/nRBSL9zA90wJEaYumuIv
   weRdle+fkHxg0sS5CINHQORRmwDvaFUC6CP8ebyIFeR7QtNtE20YYPcvX
   oRrWB9pdzx1GM3ybWEo4N1kWRUDlAQsZ6+3pEB2z1I4EphHQEgyopAOUl
   zD+qbnqAXiKI0q+fuodFSQKkha1mnL/tINuPs0vgQpf8ydrkoEWlmfu+Y
   PV2ay1dW2dVSkljE5LXhn8fYA61SswT2uT9NysnywHdr4BZ7hOKTm40wT
   g==;
IronPort-SDR: j9Mi6rhgnUVxEwL1DHCQbjVu/s7yYRUgSaAH4SHKeul4H8MoiIq6C90m7SyT6mvg6Tnj8tivCL
 ouqQ+esZnRrqyFS8HEaCLFWPBHnzn8n6zX7b4gh+bhtyjLfO5v30OhtAaHdMOrEoKjLQKquln3
 Bpehh5TiCQheBRiONL3rS7ZbOoGxJCnlGSN+rVzF9/vLjTEGAX5PJxZ9+P2UnSHXS3Gs/KsJ7v
 ZsGS3IF1aUTlYQVBsi5uvDQcnoBIXk9Vgd4g9F9Q1gSMLthXWCpO7Ti7Zy6Vr//XA1AgreLPPb
 42w=
X-IronPort-AV: E=Sophos;i="5.79,360,1602518400"; 
   d="scan'208";a="268211173"
Received: from mail-sn1nam02lp2058.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.58])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jan 2021 18:46:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XM8TNUb0AXPvp5Sy7E1UnlMMUPHH1BkWVnIxmodU5e77tV3lLIsudAPBP+NSZWltBu7TFP5eNfJQdJbECxkfvDEXGv/GKtIRRWjY3hfqIQiJDj97k2SS0Hs13qALXYF+rE32XeCgUEYLmy/rROMXav/+Q6kkVm6Ff5ZiVLbWMbAsKEKc+G16xf7cOLZUZYJZ/P1SfzXd+vGQdCWHrX2Bohbwv391r9WS6O/IT2uZzwyzz0P3TzheXcKHIlm4xHyxmr2xR58ldx8M8kC/FtJGudFPum5aRCf5j5tJw25bWVD31g3iD5a0guPrN9DmKng1WEoBcWSGJ8b6W2gE5B62Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3ssmbCYg6NvVscu4SdbntHO3Sa6+6ksLuNOg034rCQ=;
 b=QXHwf1qof/MdA4FibOVFaPPJneWXl3/q8/oi7QcQ8gOWEz392IGpTNuoTnijwh/NKyeeCg834jBgy9hECMIkLkQTT6/UNAGRSf5JdvDqi0/fq0y4i2fXPSJTRZLfy+74/+XsUfxZRrWFEjw1aEtIasLbNkF/6EGuTpQFdA6bmcxzv+k+UqZas4wV9drLq3/xDj+B8/6GaWiNYTozTuT6td9h8CSp0oFR3y+677NVyBdTh+8BaC5kC2IHJHlm/wTBgabs6+aKPuE6EmQ6zB3/MsEg/sLizk51plKLk+mv1JyRm1uDpNP1/0UhCaGGpSTYW/V2KDngGngwNBqFQdgX1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3ssmbCYg6NvVscu4SdbntHO3Sa6+6ksLuNOg034rCQ=;
 b=MOmU3uOx9U3C1+bT8l/kIXD3Mp7ZeTYdu0a5wFkfyjUJi38pjZIoqdPgP5VHysg6nAkos2ttduKltHC78H2Pf6Iu6/aKKhQu1nirjWvYi8+TXNXTHJl26+h3xkCyZZyo+T6qY5aj8JUU0tVZMv+kr+GBExL3lGvZX8gaow6qOX4=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6991.namprd04.prod.outlook.com (2603:10b6:208:1e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Wed, 20 Jan
 2021 10:46:56 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%8]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 10:46:56 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v2 0/2] block: add zone write granularity limit
Thread-Topic: [PATCH v2 0/2] block: add zone write granularity limit
Thread-Index: AQHW7nICpvFo3Xy5NEe3/fjBT56Dcg==
Date:   Wed, 20 Jan 2021 10:46:56 +0000
Message-ID: <BL0PR04MB651400694A65F9FB395C5652E7A20@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210119131723.1637853-1-damien.lemoal@wdc.com>
 <20210120100738.GA25746@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:b0d5:1d20:2559:58ed]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d01c3bd6-029e-4569-469c-08d8bd30b51f
x-ms-traffictypediagnostic: MN2PR04MB6991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB699112F4488E414FF359EFF0E7A29@MN2PR04MB6991.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bo5ojCE/SFnzt2FJu/vcUTcVhyQyRemujxq/4Hs2Wj1irrknhzIenbe4ODaxN7pAY7wye7TobY4IjYgsW7PHgxR3Zc6yM0Crj70PFCypnuMgmQn4wN3zQ8rFA70vr4GKeWZDODnOL2+g93T7WeaL0hKNGCYFjWX5TGv2WdahxfUUC1cYh4yGKb9Z+Tbr0IqRhTsi/VjP1TE6iCY4NLA8XLa4jrZsv6tG+t829BWoU+8FxEVjs8rqhbK+fzyFtj+1Axuvuh/VAWhgs2hu2Cd8VXh3GBzGzWiYhx7sAhgHTOuF8kvfVLooVw90SOyU2GckLOtWHNMjeyhjLbLJCUy3WYdstsUDWWgTltgVT/EGv76tZhjlqYqO3J9Qn0iV5zMB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(66446008)(316002)(52536014)(91956017)(76116006)(2906002)(66476007)(54906003)(64756008)(9686003)(66946007)(66556008)(33656002)(7696005)(86362001)(5660300002)(83380400001)(55016002)(8676002)(71200400001)(558084003)(6506007)(6916009)(8936002)(53546011)(186003)(478600001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?kegjGqWELsfHq1bzEsIl9rgdSkBBFY8vLe3xhJeVtMg/EAkjqDJWf3Dg1G6d?=
 =?us-ascii?Q?1OSx3m6rTMn8JmaQ/ny6OwZcFJWC9oJWAjRF5fjkd5DH7VV1LW4Rj0v4d5NQ?=
 =?us-ascii?Q?bkwNeU8xbB9H6XTcM3TAhGGk+voQp+Zm3hdPh80lCqELIpjmWheNuq5tA9FN?=
 =?us-ascii?Q?9baFYqDd+DH7qx6sUbP8jnRRa/TC/pJsd0mWAgxEP2lHNECWhw//NTttXKxB?=
 =?us-ascii?Q?1Wztl3bs7Xa8ZdkKaEMegIrBd0C3tfm9AmBs1el14hnD0/c8p8yLWgkV0uqG?=
 =?us-ascii?Q?M4/AVQUbtpQY4akJ/oqbl7RWH+QhtjvjapB+TFZVLFX2wJmiM1FBL9BriU+l?=
 =?us-ascii?Q?1Xy0CdwHpQTwleTtidX1fy2Oh8l4Yaf7aMjhQyWllgc71Pf71sR18ZJ8tL0N?=
 =?us-ascii?Q?1lrgzIPHjcmybYzmL5jXtu3OXCqyDuu4neUjrfnPTeI77aWCFMZV4Um7+VsW?=
 =?us-ascii?Q?NjPWr+0tDwDKu1XG74IEkIBluzUGxKr3ekBnFDvL/v1p8PUWsHejSxv4XA6R?=
 =?us-ascii?Q?l812/sQrfJj4cvgLAE98oHqi9S5Q8C4wNOJjPmIkre17svHAMHtrgNFNTlks?=
 =?us-ascii?Q?tmH2Q3ogF2HleU/nvCNjsaKELGChN84NV7OfgCDOL9SV4AnodzhEG1y4liLC?=
 =?us-ascii?Q?hv0dqAgvT79+eEkpZdomJtR9E/5kgdK9nA3iTV7ct50XJa4CU91Xeqff18Ww?=
 =?us-ascii?Q?eUUu2PjFBVv600IE+mU9ckwffuVkCHzGvI9pMBqrY0/sopmuPrFdGis1Yv3r?=
 =?us-ascii?Q?8xmGXt17KUbUOqMa5cMH7kPbzj6lEgRk88+NEmJOgeUBonItmtW6uD1odTsF?=
 =?us-ascii?Q?IwShczaQFny3gC6cKH2BW4NGoR2FMphzL0BY3fP7SGlvVl0wdW3IpkHLurPz?=
 =?us-ascii?Q?VovNXcZtKzGdf6wSUUxI8BPtfJP8OH8yaagR4jO7TY2rJNgKJpIqCmKOv359?=
 =?us-ascii?Q?JYZ4GJCrPG44WQVg0CvKsTzNQK23pVXNo6PDu4i1uLrRuiAHu/d74I0BrsDN?=
 =?us-ascii?Q?b2bt/mTWZr0Ijz1HcmAiNFjYde8jGVfNhe9C59y7CPjQ3yR0qQiMjV5vtAwz?=
 =?us-ascii?Q?mfCXt5gy9lhFzE9w0l1JdGt00+QIjvUItWlt/uepEkKM3TNcUvLiKpkYUG70?=
 =?us-ascii?Q?DyEMwf3m/gpaMKnDg9u+4jK31aI3rQ3OXA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d01c3bd6-029e-4569-469c-08d8bd30b51f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 10:46:56.6804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nn5zOhpwHt7u12rUETG7PRNVsetQa1eGTB9c92/fK3GT0cGeopL6tyJxw8uoPKRqR4NsE402HshNwxfp2JIDvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6991
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/20 19:07, Christoph Hellwig wrote:=0A=
> Shouldn't zonefs (in addition to the pending btrfs and nvmet patches)=0A=
> start using this new value instead pf the physical block size?=0A=
> =0A=
=0A=
And I think null_blk needs that limit set too. Forgot to add it.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
