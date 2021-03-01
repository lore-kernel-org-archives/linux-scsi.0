Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2E6C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BF3E64E41
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhCANGG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:06:06 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:65197 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhCANGD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:06:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603962; x=1646139962;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=pmC1S/dL9s/Fk1HF78+evaxvFPzvNLW7XUmTslmH9iw=;
  b=k11P+a7IEej4+/aOq2mBXs113ctQmiP9gUxhAV5JotgYHnMv39eOCFnX
   pj0FzuN2ChPNDzXelKV/TUmUGV0nt2+RRyLlifZw/mGvAWTB0XcIwYoN3
   uqygdOgQMKlcDlmUryogxCXUjuWt3P4tpjOxw69BNuDmQRN8pMdvoXlP3
   J8ZuhrR6kwrQ1VakkpxKeNso+fsOhnYUdkvPbFkGwxkYe0Jc7FmWSMfue
   kjASmumH0ADt1cyBoBv9Yg90Gy1EUqx3qdX65g1hsrb/yk2NNbj+WC9UL
   W1n1scV41OskSiadAfQx76oA1t2pBN6GhDHS3r1iyeo/md9W4XiPpy5jE
   w==;
IronPort-SDR: gtYDdjl4rcZoF7HAe7KTx7VMEfqZpRIUO0A/9hxujFhGd9uNdHY+i/Tx9sWILuGhJZetPy+yAL
 aMk6csRtTE+SiuKv8Ety3mWqZ7A/84Bnbq3lp69vxZLtrazufqJ7B9dCimjkYFOKYzqEmdmkbv
 ISAZGPhYR59t3Bdb+PE4OgBSmG+cHOAavLKFsW0BHGU6ttcjTDnqwfn/Tufpseb7Ps6kLCBxZm
 yxlc719cmsfaZAU+AdBXlaUVR0k7pgFHfxcU3RtqXGRJlCQ5MytAJXsczj6kD7cy+/iLD6HZgR
 VKI=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="161080358"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:04:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5uKS4SSE+vA8hv0s75+RSrOUrYfsPuWUD11VHV0U86VBGh3aRrO4X9Tbk1K9gIM4nxaKqubthVSRkOt52JDrx58tQ67cdHxRgTwRvG4heVz8HmLlMlcNcH3jhWANfy4N8DgRrU2sdjHmp1ZJNp/c07fqv+RNpKi7/8Qjw5Ln+a3w5HApdISigHzxRmFZfMRp7u64VGMWJVC1MWNjs5JCgSPfDePR4AQo3NQYClVb0JxfVuIjtiXWX6ArYtmf1guVKOBetSamK4nkiGpzF+lL/FNRKqBdjnsAkpVk77i2j/le0x5/PEpJbC09t/AvKUgWOIRdDbXpt9+7f+bdKdEQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmC1S/dL9s/Fk1HF78+evaxvFPzvNLW7XUmTslmH9iw=;
 b=oNLhgT0qx2ox9CAw4+7oMRTLNYPdjGbe+BjK+rEM5rCew55rRa3QDatYYNS0OhR6/tjMitVgF3kgPRfHTBtXnyFSX75qsTSTXXCiT9wPZo0qU3vuIrgJAfWPw0ygIlxIiTS1mdgJxM/vGKFnuyFNHrsGT1RyXmOyArTE4sXFjfSyVELV/o3QGaNxgK/ORB7zQ/qznP7xcOfBUI1gXz3gKAgc++M/+hoxPAjWRJ6OgXASFzCwbpMQ5oq0648w/OoOpsEp0rnLlYP1Af9JFv/J8uPd5TD3AiFNL6Q9Sc1jhV4XmGuZR96hL2IGOlF44S0hmlUQhfjsKkFBIvk74e6eGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmC1S/dL9s/Fk1HF78+evaxvFPzvNLW7XUmTslmH9iw=;
 b=WtCARyR67bWOw2NnYEIPqCc6Al3iq3bxN223FrRoICKEVV53R+sXH9gfd7tW4s28GLENKD87978G1kk4kIkip8VbLNYqdDsyjso1cQoM4dqwCxIxEFGGlEP+QFBeC0c7M0PB+H3O9iv0nmXhGx/xFYVDuDMfQTv+LfX2+t9v7WY=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB6482.namprd04.prod.outlook.com (2603:10b6:208:1cf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Mon, 1 Mar
 2021 13:04:55 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:04:55 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Guido Trentalancia <guido@trentalancia.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command failures
 to keep using drives not supporting it
Thread-Topic: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
Thread-Index: AQHXDbGOoQvSctH05k2iblGBdDcQpA==
Date:   Mon, 1 Mar 2021 13:04:55 +0000
Message-ID: <BL0PR04MB651464BF2CC7DAF8C6F812C4E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
 <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
 <1614582394.13266.11.camel@trentalancia.com>
 <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <1614598394.4338.18.camel@trentalancia.com>
 <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <1614602388.6918.8.camel@trentalancia.com>
 <BL0PR04MB6514A85C4B56E1370406B97BE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <1614603429.6918.18.camel@trentalancia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: trentalancia.com; dkim=none (message not signed)
 header.d=none;trentalancia.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:347a:bb00:3286:307b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6c6f097d-bb17-4d2d-ef96-08d8dcb29c50
x-ms-traffictypediagnostic: BL0PR04MB6482:
x-microsoft-antispam-prvs: <BL0PR04MB6482B7E6F591C3801FFF182DE79A9@BL0PR04MB6482.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sUgV6m40yfnFDHN6DG6yJYcnoTdWGlIoqDFowkFSwL+Ndjv7+NXg/GNFoyRmz45TBRYvjU7+FZ0Jkq4e4OXDosZZj+CI1X6w/uv0Le/2Vq6Hl4Wix5bEZwUrtODM5PBVsPk545ntBJxkv7KcZzS4yPJJmVs8hTNfn0xm6my86ire6tV1zfZOpg8BAoEb2cwDoMYQF9uA2LcefGE3nWYPF0Go6UJugQlBOyPeoYJjZ4EK3DbHewNlocqjeXRD/82D10i6YGStgLhSTTFmKf9l1zUBYYS9lYfhoi76HBJcvGERa8USEZoDYU1TwsaiYcqGmYK99zXxdWAMgY0Qh9+/j8jSMd477y2SbcMnLTC62L0mgGGBeaUcmcGqfRWCUiEnHHk9qsdKhxR2bS5UiNuOtjc/mPGurPkyoRRHEPoVZ9l01hlrzFn4s7nRkOOWnHbLIwaXicspdwA9bXexMDob4xtl2bBugBKLI7JgX8YMYxhKWHTgzsVIFkXCDYK8U0k1/L/8YECIZvNeTKRvIsclAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(66946007)(55016002)(76116006)(52536014)(316002)(478600001)(66476007)(91956017)(64756008)(66556008)(5660300002)(110136005)(66446008)(83380400001)(6506007)(53546011)(86362001)(33656002)(186003)(71200400001)(7696005)(9686003)(2906002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cmVTxSke1TAcVdvY8kCDZiopFc4jN2qgdhIcUpdDjDNa3ER+RpTVU+CqKaPi?=
 =?us-ascii?Q?2z0rHCliXbY9w0VTq3yXA7oDtFtzGke+HE/Wg/7hd3qHArjNk2oEUBuuTfs8?=
 =?us-ascii?Q?QTq3t6efAYTtwpjBvwJZIMOs6yvC02p7KtBrmzpV4dsDyH4iuRQcRsHvhJqQ?=
 =?us-ascii?Q?huiKhWW5Cv5429aGkE97X/2q8JXXiXmZ4L9ZSFZt/Qq3p2bmFA8ubWc9pQQ9?=
 =?us-ascii?Q?OWuycLrea0RtumsfNA4HaUVD1HAwOfte5ecwbJk7lYnGFAL9cd8HtcCWqy/V?=
 =?us-ascii?Q?2LtrwMcY21CYOhK69BFC65RJRews4wQX9uTVOtxHXjif5S7qSdGbmi5wDdfA?=
 =?us-ascii?Q?vyxDbg53nlj+o9AFPKRSOMl/HgUQncwpIdHLmFCAfKejQb7MR/EHee4Xt4d8?=
 =?us-ascii?Q?qicK/1c85j7HDJh7L8EWjjYeFQWpCSd7Ee0xqvPPvGfA7hdZPJp3HV/PlY5Q?=
 =?us-ascii?Q?Qk3D01Xc5FDRUFs4qxEeQxAzFZmqeMOxfYXDngYotQ+08wpNeFcPKoiAf1rA?=
 =?us-ascii?Q?pbOHo7UsSXI9oairRLUeks4z/thnRt2jWrKPIqCAw/ZzpwrJvYYrPFGG/VHS?=
 =?us-ascii?Q?Ir32FEuT7yb7ecJCxV899n8OyPw0GZOJ0TQIZy8gVVb5fUrFhO7ZUiHeFtOg?=
 =?us-ascii?Q?P+Dn3JxTPfX/hyuBpk26nMDaQ+/JhrR6rBqIY0V69U1GjTft9dobBbWg0Oxw?=
 =?us-ascii?Q?Kr2HbLCpJwDu9PwU+YOKAd/aT4kwJj7X/Pxp4Cci06MNrdagq9nXlaXlmyi3?=
 =?us-ascii?Q?l9Ztz5W8iObYARZZeeua1wF7WeRfelUzyVVaOXE0oBytmhWNSRfVi6r0IL5j?=
 =?us-ascii?Q?4PP8jy2EhKA3XjuCfZXwGuIc/FYpP45EKqc8SGMWfgqdbXVcfzk4NAT7TN0P?=
 =?us-ascii?Q?roqEwfPWVJZYyIWvikEi7k+VwPbHKW4WvEgsQJD7NewmMOnl/odZ0IB8XbE0?=
 =?us-ascii?Q?IulJRDWO616qNispDYWKyLW3+NmVg7EjsyWwpo7CPtQX+6pAq+Tiat/CNwdq?=
 =?us-ascii?Q?vd4AKbKhEjOCOPdNI7LPpuLosKI1fBQ3O8AskihlHxK1/ARwt+qKFZwmvAx7?=
 =?us-ascii?Q?W/TDHgskzVrLonBOW1nKo6OFR9Ldcs6l0Ou1GzQ7/meCmIywrNpqd2DiUavf?=
 =?us-ascii?Q?nofwVn6gkS2Kp0OjV8y0XXxD0o++CwbVjXY4H2VApGyvRlnEl8HieQTt2Gcy?=
 =?us-ascii?Q?cxeTilF1/S5t4AAWBaA7/YCUvlC0imma1O0YijV9W/TNpqzFaKHoDheXJBxd?=
 =?us-ascii?Q?XZFh+AN/VsjtFWZ+spo87KsJjSXs4FvwX+LFTERon/FUULx2l3y+zdtpfrwK?=
 =?us-ascii?Q?j2k6MwpIPXnoIbftLw/S9p66Zox3nSyWRk1ai6R8D3jeobfr534Phy9lj1s4?=
 =?us-ascii?Q?tsWhqHsYpUswcNs0N/B+R18XnPol+FKbiJpPj7dAvchciaQlyQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6f097d-bb17-4d2d-ef96-08d8dcb29c50
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:04:55.7256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WLrl8gRmK6hi6KuacD+FwH0RdhV4njwsPBzZGRH0Ih8u+fqQY46v0X5zMzyegHrD+18Ll7H7xVhoPkWPOP0JYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6482
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/03/01 21:57, Guido Trentalancia wrote:=0A=
> On Mon, 01/03/2021 at 12.51 +0000, Damien Le Moal wrote:=0A=
>> On 2021/03/01 21:39, Guido Trentalancia wrote:=0A=
>>> If the system is shut down before the sync or drive unmounting and=0A=
>>> the=0A=
>>> write cache is enabled, there might be the loss of data in the=0A=
>>> cache,=0A=
>>> but this is because of the way the drive is designed.=0A=
>>=0A=
>> That drive is not usable. Even the best journaling file system would=0A=
>> get corrupted.=0A=
> =0A=
> It is usable and an ext3 filesystem has not been causing any problem=0A=
> for over a year now.=0A=
=0A=
Yes, I believe that: your patch disables the write cache ! So no synchroniz=
e=0A=
cache command, no caching, no data loss. All good.=0A=
=0A=
> =0A=
>>> I believe the kernel should support the drive as it is - plug and=0A=
>>> play=0A=
>>> - without requiring cumbersome configurations.=0A=
>>=0A=
>> No. That would be lying to the user. The user expect things to work.=0A=
>> Not data=0A=
>> corruptions.=0A=
> =0A=
> Data corruption is what occurs with the current kernel when one of such=
=0A=
> drives is mounted.=0A=
=0A=
Because the drive does not have synchronize cache while caching data, which=
 is=0A=
crazy.=0A=
=0A=
> With the patch the drive can be used normally and no data corruption=0A=
> occurs with the drive that I have tested.=0A=
=0A=
Sure, because you end up with WCE=3D0. All good.=0A=
=0A=
> This is a proposed patch and nobody is lying, I can report the specific=
=0A=
> drive model that I have tested and the tests can be easily replicated=0A=
> to confirm my findings.=0A=
=0A=
I understand the situation perfectly. I am not doubting your result. I look=
ed at=0A=
your patch and understand it. It is sensible, but does not plug all the pos=
sible=0A=
holes with such weird drive. So that is not a good solution to me.=0A=
=0A=
The alternative, safe this one, is a udev rule disabling your drive write c=
ache=0A=
or you setting the permanent drive config with WCE=3D0. That will have *exa=
ctly*=0A=
the same effect as your patch: things will work just fine. Try that solutio=
n=0A=
please. No need for a kernel patch.=0A=
=0A=
> =0A=
> Guido=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
