Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA579C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Feb 2021 19:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E5964E3D
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Feb 2021 19:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBFTSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 14:18:36 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:24423 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhBFTS0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 14:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612640050; x=1644176050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j+FgnUkSUK2lpQ+l//rszX1srNvmEq3h9J3ZagnGxno=;
  b=Aif6dn3Rm8DYM7XDzrjjl/89m0gr8Vw0hD+D0874qPVbThlpfWuaNzg3
   gilbVM9LS15f+dZ5Ogbq1jIHkW786yKxSDJ8Cm5NEOib8WDAch4lHnqEz
   M/UAujSeXuphPinxcc3ku7bpguhzVfUd5IHIoCcFlSS7GmkXAp5267Tt9
   8uphqCVT1FsZaF1ASzcwsWr9SAzEaD0dwSXNcteTapUJTo1iDK9yyXHF9
   dy+m/iXbEhBPGSY+jMOqtr7C2vLgetajkxZVh7+JBnfNiRA8m9EV4aBoZ
   kuIMGoHqg1DPFSi854y5BJbT4lZoTYHNEV4SkQx/P88tQKHHv1xSFwcEv
   A==;
IronPort-SDR: WVbRw2hsrwlVoNG+uz5mTDy8ErPAce6pGJmN3oEN30nM+IyUu2oVMhW7vR7U4F5GZvMTDQTw1p
 ImZfRPPWM1cqBohuV/5qe4iCVVUd8tKujg0hYvHO2wDctnmAmZ6ofWPOnfwg8a9di9cQZn/SYF
 LRu+oLfwsgR14sfv1NnwnLveUn9igq4KZVThaTqWwQoNdLXtZbRpylPWPeZC/dPkM26sE+fvOT
 jY0J51VKsD3gfUzE+d2+iYAKCXkQQq2CV0CJPIg3d+C2jGtZCzXKzKVccCaRxvxG2z8zWlxdOu
 Hvg=
X-IronPort-AV: E=Sophos;i="5.81,158,1610380800"; 
   d="scan'208";a="263453709"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2021 03:32:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIPYN4wqLteFaPABEL5xWgXWjHxy7Zcgefattrvl6sXhqBe9ovsZVOU478fTDhAvJ+BbF2x7C/IIznmLbzLfLH/8ucgWM7mMNa52xoMiZ+TlttuiAph1fun41VZAhygTMV0ZLQomoYU8QG91RH3KrsLkVCUMhr1nqavPkBT5tfPXFliKPG7SXG6rz1IMVTHV7djLKIYrCf29Zmovi6hTOd0VwvVLR95INHH9QiY1Yp51A4YbQaW+p9YmJHw+4fuTaWFZ7TmNqjQjZivakvH19/+k0eCS2Tnok5ixDDtr9QjFJay2iBDVDMaw0H8qDk3iq442ut85DkKoTkGP92wmSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KXjbkwfLBmK8vm5v86X/2NAYPZBcGr+ttsRwn/8zFE=;
 b=J6BD1GtK7nim1jZ/eVBkHf0EsisLenu59kGFVysvde2QO8a3ZCyKP2kmCLiav58QkTsfbhvsXCRuor0Zh7QYVx5oD9dxR50JtaBHNfQkuoQkxN2as17jhmjcs0BKSZRpCxP/NF1YrP1NY6wxmFs8Da/Nr8WazFX4bX2U+quByss1/uQ1XhFaqb2Vg2LTfwE5DFqR8AWZ9T1MZwSHIQij5ygCIhdTb7SKJ4N7fm3YOwObRp9O5H6RQPR+dkW1Y24mGK3N+XOXb0MeH3sTIllhlJfALX1jrWcFntMBHDLlBLz9Rv8VlhYe+wYKZG9/yPZCowpYy6oPIXmiaesRZbG9/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KXjbkwfLBmK8vm5v86X/2NAYPZBcGr+ttsRwn/8zFE=;
 b=sqgOTCXLpK+rg+DfJXB66wz9Ok+MwZAsoQrQjW7SCCTTkBMIbOusugKBC3MDo2V87RzuySYMWpEgXbv5bFrecBVSPLXphWrjpDB6UnclJnnQmuH68avHCn/ZQXH7dm6GB8S0pspkGHUhegIvMAl4GEFRQeEE5t7D4QVWWwJcaHg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5673.namprd04.prod.outlook.com (2603:10b6:5:16a::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.19; Sat, 6 Feb 2021 19:17:17 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.033; Sat, 6 Feb 2021
 19:17:16 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: RE: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
Thread-Topic: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHW9f/TvOegnF+5cUGte/jMckF4fqpKxfkAgADEzjA=
Date:   Sat, 6 Feb 2021 19:17:16 +0000
Message-ID: <DM6PR04MB657586635B8B498C9E9EEDCDFCB19@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
 <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p3>
 <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
 <652fa8013c26df497049abe923eb1b97@codeaurora.org>
In-Reply-To: <652fa8013c26df497049abe923eb1b97@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 602cec8b-9c1d-4dc1-6e00-08d8cad3d120
x-ms-traffictypediagnostic: DM6PR04MB5673:
x-microsoft-antispam-prvs: <DM6PR04MB567377B0A86CC16463BF2B5CFCB19@DM6PR04MB5673.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AZG/FYwRBKo1RjasKKDl3jYNcnAIe3td+CjbhiWka5qB67aJvNrUrExaNrZo6Q8QR0yN98bKcw4TIOYDhlFZSJQpVIt5bkHAMdcIFr+0yg3PuTwydBym+SvUm69qWM1mx5qIjKpl8kWTXoRXndPretJIDNbnjpnJHH2Lt/HyGW19Z8nBum6PXL5/2efFJ28Q0AN+HlD5j4/rM3WuOXFMOT+pahbYDawskOhZANY6i/XLvQ9smXguG0SVyU0ZdpzhZgaOsaYpDA2XDD5JOz0cLRYC00Ky3avd0F7kiljukUTh+G95c/1jJnDhp2V34+DFggyXcpjlgyI9cYUqK4djTd0eBMjMhSzrTjp5NiVioj74TE2QSwD27hoD7WfHxmFvTkIM7hJe4ZqBqUALzQM4Il8mKZPOuKcNbklpT58pVjETFtLClXXRAHSlJ+6ZR/SeMSl2W7F4EGKvNnv61rvJuysgHA4ctBcKNVpWzdf3er/f0uz3NPoF8qnNfpN8Vx+qQN+WfkLkkEe9i6gz+GcFxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(8936002)(4326008)(55016002)(6506007)(9686003)(26005)(478600001)(33656002)(186003)(7416002)(4744005)(8676002)(316002)(71200400001)(7696005)(110136005)(54906003)(2906002)(86362001)(64756008)(5660300002)(76116006)(66556008)(66446008)(52536014)(66476007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5yOHL6hA4L/pKLqjeqkaDcDYScmy8YgG1tHUzONNirL0LJUN+1hVKqI+Aept?=
 =?us-ascii?Q?4R8LD8e76EWh+Ls3gK2p6BZbs1rtUYLipAL0P480D5OXHDy6GxwnYzj4e38z?=
 =?us-ascii?Q?OuMqV0Fpn153bh1Xp/mzcM5QgILFHQ92Ugf83i5BjMnkBpU5g6bETWw8RX4n?=
 =?us-ascii?Q?Qn1IRSGvu/lh0CpW6f+DXpjcV40F0cUJ8Xgh/JB0QFnMXVKJkIDDAR5C6/HY?=
 =?us-ascii?Q?j2/oXxfqM2PqF4+XYf7Cn8QYHb1IaVMsrOMLpr8Z9fOTSrLUC7W5ctUpBwVc?=
 =?us-ascii?Q?Dd552fefgsXxPh9gQHlPgtZ0Zh7uNcSDKS7hznXQgiB0zOTNWQuX76EP9a9R?=
 =?us-ascii?Q?76NJcZgHyA+r3+s164C8cz75IcHSNlr5zsh5MDBi9voKld0cBrUUsVYG6l9q?=
 =?us-ascii?Q?CPQ/vUuXPBs1QoLwScO3sNdOfsswAs2x7nbS9GKzRKOEj+IQ/FY42bzPp1M1?=
 =?us-ascii?Q?pGI0pnvl4cS0AJSzkNwf1R/qmDiAdu0Jy+JtvGKJwi2RffYwo44SxCebH8Yc?=
 =?us-ascii?Q?+ceC7aiWn2/qZPzs2NBrkg3gu3ZsV9FyynWTmPgbnEzAhY//e9kUg/FWI9nj?=
 =?us-ascii?Q?ZLK0uG76BJic5Y56LE+WeuJr+XGvyYNOSKo/98yyQNDo3uhmeQcqjg14Jia9?=
 =?us-ascii?Q?KtIjHm13brEbw/H5BZWXX+WFUvXyN3myCDWxYSTsh0zRCG6HGBEn6z428elJ?=
 =?us-ascii?Q?V1NOKSAEljfWsHJcH9brBwp3uQRJSqBzBTSWVp1ioQa0WMt+VEJUboyL9Gx5?=
 =?us-ascii?Q?UzkMtgV/AwNyliqudVEdWPTL/RC5IpX8/J8zK/qSzJYwb7Z14ICVm1cl1Tdg?=
 =?us-ascii?Q?jyTDqD+RFRynoAWRyDLsKGbLTiXDNp+fNpvqn++YEEJRhuOC6t8GPxbVE/qq?=
 =?us-ascii?Q?WwgEjuMMQxze/PFOTA0pOlU+h6dnJqlm1ZF9aRYKW0VufAzrUDguvRKdA6Qm?=
 =?us-ascii?Q?oAJUV2nkycyWT8Az7eHZOWR0IJ7Scx8XCv9EYhs8rP7mUsA7ku+NT08EvvJL?=
 =?us-ascii?Q?S6q3L0UXNt29SP/eKHkb8kwQJR9ip2C9NQxFsV4B+i1jDT5HfwUljQEoieeA?=
 =?us-ascii?Q?mhm0XL49SlWsr8jDI8ReGIUHUxsbbNYU4OQzM2AinFFyyxnLaIy4kPLsNj0v?=
 =?us-ascii?Q?7a5g7tBLh51z4uMBFw0qASV3gbzsiTYNetu81P2eeEt8AXpZo4ug5TOcK7O+?=
 =?us-ascii?Q?JfvD+j+QL0JYhQqp2aB9lG8qpm+EVZ/dZYKmx656JQfCoCBF3WZtGYHshM0m?=
 =?us-ascii?Q?TRw1oFU4N8acwmrkiGY69JpyrxzDU/rBSkCvTmmTfeXJ6qAxFkhGxQ4KWJRr?=
 =?us-ascii?Q?iCk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 602cec8b-9c1d-4dc1-6e00-08d8cad3d120
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2021 19:17:16.6128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AMXVW4GrfZE0edDFSv9lVS7GZA/G/06ps4MDxcCdu3c6TrwfghAvHdyc3XGQmVqDd/Wcr/5jZmUo4RBsYwkUxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5673
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +struct utp_hpb_rsp {
> > +     __be32 residual_transfer_count;
> > +     __be32 reserved1[4];
> > +     __be16 sense_data_len;
> > +     u8 desc_type;
> > +     u8 additional_len;
> > +     u8 hpb_op;
> > +     u8 reserved2;
While at it - can fix reserved2 -> lun

> > +     u8 active_rgn_cnt;
> > +     u8 inactive_rgn_cnt;
> > +     struct ufshpb_active_field hpb_active_field[2];
> > +     __be16 hpb_inactive_field[2];
> > +};

Thanks,
Avri

> > +void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > +{
> > +     struct ufshpb_lu *hpb =3D ufshpb_get_hpb_data(lrbp->cmd->device);
> > +     struct utp_hpb_rsp *rsp_field;
> > +     int data_seg_len;
> > +
> > +     if (!hpb)
> > +             return;
>=20
> You are assuming HPB recommandations only come in responses to LUs
> with HPB enabled, but the specs says the recommandations can come
> in any responses with GOOD status, meaning you should check the *hpb
> which belongs to the LUN in res_field, but not the one belongs to
> lrbp->cmd->device.
>=20
> Regards,
>=20
> Can Guo
