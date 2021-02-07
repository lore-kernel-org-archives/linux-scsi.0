Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75799C433E6
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 01:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A8B464E26
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 01:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhBGBHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 20:07:43 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:20421 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhBGBHm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 20:07:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612660061; x=1644196061;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5kHmTmWkbQRpXlJxQvJOpvgg8y1birvX34kh2FJervQ=;
  b=lpQSAUoxXTvqNi2PwNSEmyKuKD0dFhhNVp3dlB3eH0vQjAIs+D2GnZBd
   6i5MDMr7rx5gvz6O+DopjKcrdZzHapKkXwTpydxucEr0OjO7E7cPcEjhR
   1uTcAWirOEHS17pDnsooQ+nLWAEcUDbYULKnAGTkVkSF/MfRfB63t9h0E
   30iUVPvrD5NW5pvCbch6EEymDWXJlDu8bud7Yr0hxLeX1dEYF0d0Rh8dZ
   AWtGk7bBZSxK1EutYxksaWBmqWvuF5OhIlCTxcivFwQ9qUkXgSAD9GZAP
   oJ/dTiryLlmCSqvQCCABjlkuI3YgnwmAjgUO5w5Si5zMEJdhD9LYTjJzz
   g==;
IronPort-SDR: 5RWEKt0QPDLhjF2DhQGSNURMEaOHxZplPl1nBFgzmY8s/EV91PbyhXc0y/l7WuOqwZ9yRPt9oV
 fTSyHvv1co3GhzJURecfN0rkmQc4i3jnfs3RE9MHnNCXBnOx01DvnQw5NgZuXwodua0oMdgpxl
 T94bdTn9A8jVYqLtA8UFso5ooylpong8mhs/mwqXOy8w6uzFzAbiCz5FOGEaH7lqyBL3kA9ifP
 ktIRLiHQvrBzwqPYmwhD08SLrYqzIoYB0pA24gXFVM9hqiES1YIZuAHR4F0h85WwR58wt9RF2j
 JNo=
X-IronPort-AV: E=Sophos;i="5.81,158,1610380800"; 
   d="scan'208";a="269823712"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2021 09:06:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lar1VC3PHWWobcZKJhkseIjaIdENjjFHpH0zi/HglmvLpXg0N7T1GRfsBHNbC95cS9TVTPEp8ptvSy82B2GQ0NL/yiYr+9RvCyFWnwk6pKRbpX73q+bVCkOPfjRz3QDioVef8qrMVrbZgfVk+dmis22vRgqRpje6TgxQMY2Hw3VwqRTZhyw3UVWn8Pf3l7ajj4O2XA7B2sIqFj2Us6NMSJiH0JIyItKtizC8RiEdF7Q65GRV93qtJLJencRwK1au1OEUDDxb2Epv3rqsdb7FG0AoqJ1N1iHEyxbZqmU58ILdWg2q3dMWDOi3GSMZXknXH0yQQsW023F8L7wTNmpSVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6GqRAmN4dSVQa5NWuDeA/dUX17EKiCNVnx9x70PyxA=;
 b=Pufm8qz9seUswgQvWtNPHVhj+cXIs/w7BkPeF/M9Pw2f1krn6gFzFQta3gEQrDNeYGlmCX+kncsoZo6l3jubj93HcVUeyY7vOaMZHiLT3Xga41H4tF8m7YK5fPE+3aLUGtBfIKniGPhmDnTRENFLB3NPY1npr2ec0nmq935siDvv3DiojSDCWD+qeR4WL82hVGnnLX4b+xitJVjSfrjZcD7wNVVfra/Jj4LMnyqbZWKMhXw88ukI4cBlzn+3/NXuA1eJKwR81lnQL9PxJCEsRtfj8PFSFdGmFFE1KZGHvW7yk53zQ3w3dAoK5P23kpxsPVrg7SArrrzSo8URSBT7OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6GqRAmN4dSVQa5NWuDeA/dUX17EKiCNVnx9x70PyxA=;
 b=F6zm5zH0SG69U7l5jbn78mjJDE2YUD77y/cyTRCQG1Q5vlX5UfCVWsQoVA+JNDsKA7DZRSuCIhIQ1W2WQ0NIyazHmP9KXpjAIn3ll2FvGXvQXX6Vy8R3Cpfu/wNyck4Kir0YhadvXmeJSKNUTFevwAzWmzAku2XvEhTn/y97VyM=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7693.namprd04.prod.outlook.com (2603:10b6:a03:32b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.22; Sun, 7 Feb
 2021 01:06:34 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Sun, 7 Feb 2021
 01:06:33 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 08/11] target iblock: add backend plug/unplug callouts
Thread-Topic: [PATCH 08/11] target iblock: add backend plug/unplug callouts
Thread-Index: AQHW+uqAXFP9xXHYdUSkJKfdoREP6w==
Date:   Sun, 7 Feb 2021 01:06:33 +0000
Message-ID: <BYAPR04MB496546E04938C9B78B71401586B09@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-9-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c1fdec78-038c-4687-4bfd-08d8cb049c86
x-ms-traffictypediagnostic: SJ0PR04MB7693:
x-microsoft-antispam-prvs: <SJ0PR04MB7693CC070DF3CADBB9153C7386B09@SJ0PR04MB7693.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CQPDF5+GYZ42cxyGZ0ruibp9Ph5NZArn8qlKf7eTinXHpL0DjT5pKZU5497i5ZKfiz+HHLdJmgwWeTig5DkD6rF3Bhl6vJAna+I0CAMlsJQMx6vEBUQV6qati7DUWCLEYYbs5zQK0ghCpqUlRsHEB/JDDJEK2NFHGCQkxqRjd3PYbaxOV7umwzYJy+KbuMYnS1HUZURdQuqWByk3SywAARojzrnNVjhsmMND/lWFg1fus+eO9Zg54VvBzfdcJUqo3/B+p4vZ0HePsfvfELZseHqOCm369/Tom09fhiQUjdO4g1O8ZVlXXHH5c+/32ik/OHyRhfC6s4bJwd7SqlzwFdz07hSLazSpEEEx7gCz9GccjlP6zlWhgjV5ie5t7Qnapy8XGy/hF47vGDTWx5EwqqVcvhnXhv92RFoZNbcm1DZJr98mFlVbu/nLgJlMEexcVDc++rn0wLThIqwMPmLj2sNGFKOSXG9XfHRPTFCcWzG0uEv9zULsm34ZzU0GjF8aAfLLn5IyfMJKX4nfITNcGldOQLZnBXr0VGwGp18gQcIN/ahk4qJutAm2RhtOKxb3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(346002)(136003)(366004)(71200400001)(2906002)(66476007)(316002)(66556008)(64756008)(478600001)(5660300002)(66446008)(8676002)(558084003)(9686003)(76116006)(7696005)(66946007)(6506007)(86362001)(8936002)(33656002)(26005)(186003)(55016002)(53546011)(110136005)(52536014)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WD81EuRA9LaUbDBnG1CeP9tVlc0Cs+lapzf5xNs2fZp/Hmx5yvWIA5Nh5RmB?=
 =?us-ascii?Q?j/JDjsjH+VhFbKvMPyJ3/f4HIGQJ/ZpWcs0i1RpiAnM/b7ttYO9aqxTTqPM8?=
 =?us-ascii?Q?CTKUSfCUZMDzlQAbCBRjVJ3fZrPYoJIeEDzXtoE7bpdPTRi3rxVHYlU/Saod?=
 =?us-ascii?Q?db4g48nok9pvowRiU4QEYtuItbmZacDcxZrJrAqPv2C3R5Lgq3WiCwdI8+YD?=
 =?us-ascii?Q?Oq9C7HWuI7rsSwK1r/w+MQXHrjGhW4Rap7Yj81ZwecWyIci5/MiZTWR25mbv?=
 =?us-ascii?Q?RYp/p9cBXFxeFyHeY5D4n8sGyknOLQBsxtihWNO0T+XMj+vHIXmZuj/IqJq/?=
 =?us-ascii?Q?XsQYPVvi1Sn3julzWmwoBNEmNbAng+fvMEP7uXFc1S69GCSdagJHblDtTZUa?=
 =?us-ascii?Q?M3dlN2hfgz5/N0fIVwLUSbIefWx2TcnHEm/KtswqRTP5BtcSEdfKhE7Qe1y+?=
 =?us-ascii?Q?iFf4rYrtdWArUMc2cvyPU3uY56X/EzM66yrUUXO2rFGaZt7odxIuNiJbsaVn?=
 =?us-ascii?Q?vUqXtD463MiRb64VZU8BFjD+PnbaGYD8mSBo+ZJhm2O0udPRBYs1DDfM/xGz?=
 =?us-ascii?Q?hUXCFIMUUKBQaArXdHf14WVwz4MXoLLazBhvRkypVaEx2bvSR4R+IrDqUZFa?=
 =?us-ascii?Q?gwP64AWc+Qt0Un7wyVxjKfkoPwo4QuF6u6QDdDm0X+VBctrzJMe6UexEufIS?=
 =?us-ascii?Q?9PSxJaqtWxeWaf3OFAkjqBLS3BCmxTDSo/deWg2S+1MJCyGLoEIMYkl+W/o1?=
 =?us-ascii?Q?xbU4yU+d8ZNTXFCxPNhF17o8cPzIwTPrBRtu2rgmdj72VlGn+0JlOvt4uoeK?=
 =?us-ascii?Q?SMi4nGYuDAxW+of0BgOuceHomQ4ObZ9OgWPMdGVyVRBTtdBD1CheDbXeZRfA?=
 =?us-ascii?Q?T408kS1xF72DI1JZ5DcKE8sr7mwKP6NQzT1omQDwViowwa7lMpwx6+Di4Mcm?=
 =?us-ascii?Q?/gcYL4EeL1QDIQDZM4IpBOYc/XTQbNFY8JwTszGuHVoggB6TJwM1lpbRP7y/?=
 =?us-ascii?Q?kSytEc5L2cerjUKBBONitp3HI+Gr3O8kURnggSWGudGaHQ7UO6ZxrV7pEDfn?=
 =?us-ascii?Q?zLGcXjL4yB1e9AH+tPEJyL8yh+4tL4hdZLwCN1XhdJvIsVmk7Lo6YahGBVsX?=
 =?us-ascii?Q?rh5nV5Yu4diupLmAtoRBHC9Eb8ep5Xa8ugMMHUvVQ8yKdG/3uH82qZD28z+O?=
 =?us-ascii?Q?nZgZB55LO6vnfBbfchMeI9XeZ8RIhue0QZ4XglAEJWHjgmhtHLlW5ARYNbuD?=
 =?us-ascii?Q?paDjVF+POYy+K6WifF5Hk0FntIeq6ZsgX1YqPJu6zpkZ4tPkHDJdQQkiq+5B?=
 =?us-ascii?Q?bbv6Dr/R6YfdSET5r1645CP8?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1fdec78-038c-4687-4bfd-08d8cb049c86
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2021 01:06:33.7171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O6/VSTMbNI0rzZ6pf445Vlyr3IiOLdE7lbmd/2qblkgqVXh70xAoADa5aXYsfz+crn2I1j0OmZyynhovedVVl+khzRZkss59XhmsB12mrYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7693
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 03:40, Mike Christie wrote:=0A=
>  =0A=
> +	ib_dev->ibd_plug =3D kcalloc(nr_cpu_ids, sizeof(*ib_dev->ibd_plug),=0A=
> +				   GFP_KERNEL);=0A=
I'd actually prefer struct xxx in sizeof, but maybe that is just my=0A=
preference.=0A=
Not sure what is the standard practice in target code.=0A=
