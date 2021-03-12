Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A823C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 10:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76466500E
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 10:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhCLKGU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 05:06:20 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6010 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbhCLKFt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 05:05:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615543550; x=1647079550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=G5pvnZj3fy4pPE7LK4MiZxtS3unZ9RTe6fe6ob3Cgp8=;
  b=nNOn99AlZ2/yndjYFqs+By2BlVbaIzqCsuOz7EbnfJJiXRMC/bGnvM4X
   9SGOphhe7WqUDgpW+X8PQNyaLLPmCqjNGoRYvbAaSsphWc3+S0qJhTjnR
   GpmhzhtI/5ZEy9xnwmP3fvFBuJRN2la7KHt1rhL16PfLskAiUvKxE27o8
   eQLLXkJIMA9xwhdDZrN2v0KHh9jWxyhvXlMCiiP7MM3aL0TfBC5zEhvD5
   pTE79ZzW+xPMSJRlyljTf2YXd3Yutj+PVzf1jq3udd8sX7cFM0jzk3jDt
   fGTeL3PmJsycmn5YHdYjO0RozcDydvKRkT0pDyyVSbsNtJptY8UT1zayG
   g==;
IronPort-SDR: or+MBFanbIBr/cOSuawZWSqYZLu4VVSpbxNkgmUmFJhZOq1JsZzs7XQOthW0swilA6uTprdnXl
 4lPvzqb6xRzr4vTDk2qK+ahU86DAmpc/AZ+5txQ93ABInI/pD+htfQKAgleov3v/CYF168dx1d
 wOCvqVu3ZF19AzLyrQxVlRKYI4DOBFTA4KYaSyM/QtuSYTc1il06gIawcJyH7b44n/5pYRcOuj
 Mb5I4JATbrDbMmyu3Bt02ZkQGxgLXYYEfkBras7A/Prn6LFDIb8NAHaRNXKv0XII+flZYPHmMV
 9Ts=
X-IronPort-AV: E=Sophos;i="5.81,243,1610380800"; 
   d="scan'208";a="163154304"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 18:05:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnlIQyP9LG+SG7WBuTN3MOxdJdM5NL968vz3i6qQb42Aa9lnXcLzPxVw3dtulY/NvhU/43Wre/omWMEtfs6sRWoKGZvBwEGxcPN3wp26XfQ3Ylr/ubYJGGi725qPq9x87HaByshTWH+ILzjQ+VgZYLA+QeUJugc6b4huY9eMXKU23pofSy6x/P0Emkny7evgdl5H1Dyls8gcqoLqdLjcO2GoBKpzPpXR7sBnTP8xvMORXDSt+JDU951Rqg8p367q/gE1GW0FZyi4TdnJzT6C7iyCa/b7sFufFrh8VZfwSl0HSsnpb6tjlvuh/Id1VRwqiSdfh1geS1MyiT6a6b+PSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVcbcRryPTPthfaAvzgB6BYcwI7mVhc6lb5PpXgIvRs=;
 b=aPX1BnFzVUaq13WI2512f9hwUBB+nVMKZtMzxBNWras/Z4jCk9nFa+gXOuqoHkXThxnCcVRekAk8TJnHQ6Ihbrp5eQge5ioWTHpJkvhsem/lSjsFL1FvH9cTwmFefgvrKpraVXuYJphf7mAMgMHm0opSZz8DbGlTe2yssY1Gcqh/Qul2Zg3hZjB6+hk8HOZZlyD4oKIZL75QQQcPVtmY819exM9RDd6+TcGRF70/9Vm8EcKjuamR/dSU7fvt+sN14K7HS1c/wa1nUgCQ905r/2Hfl5Ly0MQOrM2IuSnejQF+OyUu8ocwnaZRCcY0HzlKj1fbCHklY3Yqpt5id8f9tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVcbcRryPTPthfaAvzgB6BYcwI7mVhc6lb5PpXgIvRs=;
 b=TmuKLTKleL6WoRfMO5sXxwdqKiPjooLyyqEOR2XNl0+Se5Cxr5zOEWbXKe69n92S7U62td0Idqstw3t7vDr70FVUX71w+8kh3URuTKUVgQOIhy7gFrVNGT9SEUCh8cuKF/5LEj+s/YhedAPzxKBO/OtZ71GykaiHiAuyHtFVxLI=
Received: from BYAPR04MB3800.namprd04.prod.outlook.com (2603:10b6:a02:ad::20)
 by BYAPR04MB4503.namprd04.prod.outlook.com (2603:10b6:a03:57::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Fri, 12 Mar
 2021 10:05:47 +0000
Received: from BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::61ad:9cbe:7867:6972]) by BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::61ad:9cbe:7867:6972%7]) with mapi id 15.20.3890.041; Fri, 12 Mar 2021
 10:05:46 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Q2LbIxWjkkW7HLcT3Xe81KqAI2OA
Date:   Fri, 12 Mar 2021 10:05:46 +0000
Message-ID: <20210312100545.cf5m7yd22prkbdx6@shindev.dhcp.fujisawa.hgst.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
 <BL0PR04MB651449ABC126A9FEA02CCB08E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C8F6506400FECB7207AC9B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <BL0PR04MB6514879C187E6C81593F41B7E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C0E44B45C3FCDA7127989B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
In-Reply-To: <PH0PR04MB7416C0E44B45C3FCDA7127989B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83448597-1058-44bd-775e-08d8e53e67fc
x-ms-traffictypediagnostic: BYAPR04MB4503:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB450353B5F06A9FE06C834F9FED6F9@BYAPR04MB4503.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5P0BQMzRo59XSUuxZtvfYM1Wy6XqM4I/Vjn6BhNsCcSCqDVLqdatXgcK4je6INQJwto6n87HbC+5x4fmmNLqUzzWaNW0O+B0wVQvAhnEWwnF97WsePjGgXZ6/C1CpqUz7BWInnWVJFs3qB623k6rqAQ3LW4ANcfVQ6PGhYVZDHevwoCm+st3YL3K+WwY+a6183lHXHlax97Gp4VniQMa+cLNiMN69x6WzVV+i01Gne75z7bpNMJ8uHYrQp6rcF1PhUliwtajw/gMkO29Ht2JKSxkl4WOpSfwyI5ab4Hov+PsRlXdGK8hY+IY2LDDj7ar/cKBD3xTSsafgI0vesUigjUk9EzE+UNBoFru4LyqjfDR9MkkDwYHGFlujyTFQ8nhPc5a+Z1Sic3XUEdLE3Cp/237hoMLbbCgP9Lh268hiSEssjZPbkIG0MA1DV48NX/pw8aBeAWtjGoVqWpybbD46H4HkPYq2/SPG8tgEcpxUswMPKzB95oVYzJ5MvHF7gBSwQLVpgZaVkThpCcKPScyKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB3800.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(53546011)(6506007)(26005)(64756008)(1076003)(8676002)(478600001)(6486002)(44832011)(66476007)(91956017)(66556008)(66946007)(71200400001)(2906002)(76116006)(66446008)(8936002)(4326008)(15650500001)(5660300002)(6636002)(6862004)(54906003)(316002)(6512007)(9686003)(86362001)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eDU6gBvfIFD6+Jams1JddK0NdeQAiNIvzo/WgWrTc0W5Sg0vukZh+wNeGH9B?=
 =?us-ascii?Q?bbosHwDGTuEImKb3X/X551thOCIhjabq4YQ4rcyPbr3yH4PK34oX65sHDY06?=
 =?us-ascii?Q?/JNZ0wJ9F0vtuDcjdA0UCXVr0FqOdvNckn8DcSqA8WsBc+i+/dWI8be/glJ+?=
 =?us-ascii?Q?ra0XekT01mRctQBLl81RcZsiEn4JID+I55IyZWLQbqTv9okUev8IXRSdZmcn?=
 =?us-ascii?Q?lQf8GZ0WgZIGzyYNYe3xRWae/rleFmLUlNEyEGzutTMfOgZ6AhqGkcVJTqn+?=
 =?us-ascii?Q?G0BYMh2qBOg3gHqmuSSlJt/wJujz0tFZB6UxWPKvPuyXBA1dsoFFrANn0G9W?=
 =?us-ascii?Q?/STFit42629rYN0edPgqUA98hGeTXCmrrxlx6Iwq7a/UQH7ET6NJnWez59D/?=
 =?us-ascii?Q?14B9r6exiOOnjTLRaMQXUe0GDyOtbIqMi6F3nOP93YF2HcBcFiGLYjn/ThI3?=
 =?us-ascii?Q?aaASbdY6tpjoA+ez4eWYj0P0BOGoIEuEzQyPkHhLneuJ0BSR+JXxMfww+lFa?=
 =?us-ascii?Q?mlhVPo719/QQlT8rlzBYHN1wvDXfQTa8AYMpnlxYYCBJ9Py0RQ0E1M2lbVpX?=
 =?us-ascii?Q?FGokmiFZtKYwDwMrJAOddWB7HZp7EL65Xhf/1+/cXBQ4CYcT+tIuiuKGVQ8X?=
 =?us-ascii?Q?Lf6dUulJTQ3dIe4ckF0XdK5zy8dW/gkVPOVrVEk7HTcuV7s4uoAVfZnIlxqq?=
 =?us-ascii?Q?1qbKnqKRiuOykW4w9lgPzv4j2kTq57Q03/6mqmkZbmJZ0D8J0Y4B0P57QXrm?=
 =?us-ascii?Q?HtyltEEjyDd4ZBqB6DetJVzP9n9eT572JXRKJ/ZxPKZeyQK2/l91dgiunBLa?=
 =?us-ascii?Q?A+U4HkLohcfEp/aCH5m8RlQ+2CB9cwYBIsd8B1bHIpRnC4t3tDqFk411aoiN?=
 =?us-ascii?Q?5cX1+KQevOpEskaFLb6Ema/g6uXn+rHo5wljW8R8s7PiY8qA/I2l09H8FBfI?=
 =?us-ascii?Q?/iR0wmHX1+M6oOby5bX7wWt+lFMiVaez7tht+qoDwV8E7pzdYBRJwaKRBydI?=
 =?us-ascii?Q?AHtAWAi77MXnpuLj2SBVrzvdFvYmfiGy6dDIjuw0/ndke1P+jbrB8w3uaHKu?=
 =?us-ascii?Q?yrHSGZ++tXMuaBQ00gaZQ5aRkgWXeF+oKDtFRwV/3Fmz5VQokERP31RRP8xV?=
 =?us-ascii?Q?QmFMXRd8Nq5t3hcQxDW8svgXxFsCb9yvAC/aS5o8ynpKhXZNthPistO/n831?=
 =?us-ascii?Q?Bwgc++8D3hhkhXKLc3y0qAF7390G7DLg6MqFHEpeBnJlan8stOoUCmPLgdJz?=
 =?us-ascii?Q?fA9sDOl9j0CKZVABBqheHvwmV0vwFYHPX0nTwcP5T04/D3y3KeYpYIOK+DTJ?=
 =?us-ascii?Q?uLZ7a0eCyEWQMjfbZ/q8Wj2WCqBbmIe2ELjW6BAz8K95uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <801AA2FD536C694FA2760C13958736FD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB3800.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83448597-1058-44bd-775e-08d8e53e67fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 10:05:46.6627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HSMfBEZhHiQIxBHsNT9vdMwwu7k1SontZi9HO6ySLcFhMVhDv1upjkdz2VYwrWQDeDIkGW6Rqr57nb+QAa6apxSrx8JA7WnJ5Tf5W6vizr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4503
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mar 12, 2021 / 08:58, Johannes Thumshirn wrote:
> On 12/03/2021 09:20, Damien Le Moal wrote:
> > On 2021/03/12 16:59, Johannes Thumshirn wrote:
> >> On 12/03/2021 08:27, Damien Le Moal wrote:
> >>> On 2021/03/12 13:38, Shinichiro Kawasaki wrote:
> >>>> On Mar 11, 2021 / 15:54, Johannes Thumshirn wrote:
> >>>>> On 11/03/2021 16:48, Bart Van Assche wrote:
> >>>>>> On 3/11/21 7:18 AM, Johannes Thumshirn wrote:
> >>>>>>> On 11/03/2021 16:13, Bart Van Assche wrote:
> >>>>>>>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:
> >>>>>>>>> Recent changes [ ... ]
> >>>>>>>>
> >>>>>>>> Please add Fixes: and/or Cc: stable tags as appropriate.
> >>>>>>>
> >>>>>>> I couldn't pin down the offending commit and I can't reproduce it=
 locally
> >>>>>>> as well, so I opted out of this. But it must be something between=
 v5.11 and v5.12-rc2.
> >>>>>>
> >>>>>> That's weird. Did Shinichiro use a HBA? Could this be the result o=
f a
> >>>>>> behavior change in the HBA driver?
> >>>>>
> >>>>> Yes I've looked at the commits in mpt3sas, but can't really pinpoin=
t the=20
> >>>>> offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support for=
 shared=20
> >>>>> host tagset for CPU hotplug") is the only one that /looks/ as if it=
 could
> >>>>> be causing it, but I don't know mpt3sas well enough.
> >>>>>
> >>>>> FWIW added Sreekanth
> >>>>
> >>>> The WARNING was found in kernel v5.12-rc2 test with a SAS SMR drive =
and HBA
> >>>> Broadcom 9400. It can be recreated by running blktests block/004 on =
the drive
> >>>> (after reboot). It is also recreated with SATA SMR drive with the HB=
A, but not
> >>>> observed with SATA drives connected to AHCI.
> >>>>
> >>>> I reverted the commit 664f0dce2058, then the WARNING disappeared. I =
suppose
> >>>> it indicates that the commit changed HBA driver behavior.
> >>>
> >>> Can you send the warning splat with backtrace ?
> >>>
> >>
> >> The warning splat is in the commit message:
> >> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2
> >>  Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015
> >>  RIP: 0010:__local_bh_disable_ip+0x3f/0x50
> >>  RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006
> >>  RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013
> >>  RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd
> >>  RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0
> >>  R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200
> >>  R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218
> >>  FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:000000000=
0000000
> >>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>  CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0
> >>  Call Trace:
> >>   <IRQ>
> >>   _raw_spin_lock_bh+0x18/0x40
> >>   sd_zbc_complete+0x43d/0x1150
> >>   sd_done+0x631/0x1040
> >>   ? mark_lock+0xe4/0x2fd0
> >>   ? provisioning_mode_store+0x3f0/0x3f0
> >>   scsi_finish_command+0x31b/0x5c0
> >>   _scsih_io_done+0x960/0x29e0 [mpt3sas]
> >>   ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]
> >>   ? __lock_acquire+0x166b/0x58b0
> >>   ? _get_st_from_smid+0x4a/0x80 [mpt3sas]
> >>   _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]
> >>   ? lock_is_held_type+0x98/0x110
> >>   ? find_held_lock+0x2c/0x110
> >>   ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]
> >>   _base_interrupt+0x8d/0xd0 [mpt3sas]
> >>   ? rcu_read_lock_sched_held+0x3f/0x70
> >>   __handle_irq_event_percpu+0x24d/0x600
> >>   handle_irq_event+0xef/0x240
> >>   ? handle_irq_event_percpu+0x110/0x110
> >>   handle_edge_irq+0x1f6/0xb60
> >>   __common_interrupt+0x75/0x160
> >>   common_interrupt+0x7b/0xa0
> >>   </IRQ>
> >>   asm_common_interrupt+0x1e/0x40
> >>
> >=20
> > Looking at patch 664f0dce2058, all that seems to be done is to enable
> > nr_hw_queue > 1. I do not see any change of locking context or irq hand=
ling.
> > From the backtrace, it does not look like scsi_finish_command() is call=
ed from
> > softirq... Probably a change in that area is responsible ?
> >=20
>=20
>=20
> In scsi_lib.c we only have these two patches in that area:
>=20
> 684da7628d93 ("block: remove unnecessary argument from blk_execute_rq")
> 962c8dcdd5fa ("scsi: core: Add a new error code DID_TRANSPORT_MARGINAL in=
 scsi.h")
>=20
> and none of them can cause the failure either. In block we have:
>=20
> 0a2efafbb1c7 ("blk-mq: Always complete remote completions requests in sof=
tirq")
>=20
> but this doesn't look guilty as well, all it does is raising a softirq fo=
r all
> block completions local and remote.

In blk_mq_complete_request_remote(), I found the following code.

	if (rq->q->nr_hw_queues =3D=3D 1) {
		blk_mq_raise_softirq(rq);
		return true;
	}
	return false;

My mere guess is that the commit 664f0dce2058 changed the shost->nr_hw_queu=
e
from zero to a value larger than 1 (with my test system, it is 8), it is
propagated to rq->q->nr_hw_queues, then blk_mq_raise_softirq() is no longer
called.

The call stack I assume is as follows: without calling blk_mq_raise_softirq=
(),
there are all executed in IRQ context, probably.

  _scsih_io_done()
    scmd->scsi_done() =3D scsi_mq_done()
      blk_mq_complete_request()
        blk_mq_complete_request_remote() ... did not call blk_mq_raise_soft=
irq()
        rq->q->mq_ops->complete() =3D scsi_soft_irq_done()
	  scsi_finish_command()
	    drv->done() =3D sd_done()

Will confirm this guess further.

--=20
Best Regards,
Shin'ichiro Kawasaki=
