Return-Path: <SRS0=+FL9=IF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54493C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Mar 2021 06:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A73D65114
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Mar 2021 06:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhCGGlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Mar 2021 01:41:15 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:60813 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhCGGlL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2021 01:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615099278; x=1646635278;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4tcouaGaCpQCaukMW0Fg+80Ujit3Z6zMHk/kxROKcXM=;
  b=Rg5hSOToeNdB0NNYXx3+vxLbVfi+tapYrVZst8dTNNCGCgQ5WZhZBz8L
   ZlwKjdJFhdtAeoxqPyjOMjdVknigIovne+z/YquHh4WVu6wLcVkCVFeg0
   umfSXWf2QfoIkU8zvDuYluakEp7hQXZMi5AULRw4WqHy/L+pjr2O8sfQ3
   wPESq1r7nLLJeR+flVnlO8k8hlzMQv3kA4sNgSZ+nmT2CdGJl9h2znPSH
   JBBtpdyQOje+cPxovZG3+y8NOA6CAoB2r14Ox02MYDh8bA96ARz2GdTXj
   iccS6sw8RThI4LVIF8grGvAX+CTFjU1frcSFDYv4VjUrcLEaOtycc+4iU
   g==;
IronPort-SDR: kOBME9F4og8CyEIvLN3uIC+mA17c2freAM9y+oVDHSaPG7YFDlCDGFbin9I79NSIQ0LA6SESph
 TFjE8YJzXjTygckFiR8Wlgc+3w4xe6hFOeVDPJACSR1O2UNEKPhgYbEIfFXG6zy14PDexfepsi
 2oPqNFPCHNFdbpgaA0esGv2Lx/I4t5kxUFVJKjN3wRSCw9WWUwVK4YXbsOXj0ayQXr+kZuUmlr
 PHP/tCB+VMXsW17vLRag5J0QzOYDnbGnWKJsHcMNZd3oq2bEGa8TzsoE57ZzHeCnd6H4e0NP8N
 Yto=
X-IronPort-AV: E=Sophos;i="5.81,229,1610380800"; 
   d="scan'208";a="265858368"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2021 14:41:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=niSHfL5omeP6AGpYroe5eamDkwpOXYY3c+rbsZY0luAouW8PYC04U5zREnmiYfXxlKTd73O7C4rlQw+g/llJINQcDclNEuczd5+s+UcpTlBUECLRf5zkC5GT2wATevtYgBsAubzt35efP9rdCcaAebdBmQvLqC4O1rM0gLYu3TcPUyevKIHjq/wrQL3fbLPmiRDFqbeTzWoOkhZpEls1OHfN3k6bjaPqebFA3EpXFGYpie+nUerOYwm8FxsIMNhit+jNEaNbavSV4siULE0l6tikjuZJ+UL/AouHBcztpd6Z1f/TR96Rh1UJdosoKQIu+EYh5dxheSsTjaxOX6jKsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wocrEIAUzxjzaxuFn7qfgoxBTcvXImx//fmJYztEG6o=;
 b=nFQTeDLlXURKiu1CQyG68l8s/UqHj5e+7czlcuhowBHabIlqwgbBQnKPXRJ4GfsmxVVF7q8lk1185uV7rw/SeKv28JSfK8X8iY8mWrq+zigS430GhY2hkq+3ig6DLhurJ2kPn5r+SBCth4oMKVZA+Ww43WN/LJ5JoVqlHcXHOkjCaX7S41nEFj9/qHECpLXHOduBSKg/ZVly0qEsY1FxwhLeGGjitLPIqfTNQSaJiQxnJYf+vUumPG7d1iwzA88IIaMZwDazaxv0TEyiLy+f+cCkRv8S9EUq3atLD4s89NKq5M39eiJhJBpJQT8h2hsW7LAsBMuBzktXMFb5QWYARQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wocrEIAUzxjzaxuFn7qfgoxBTcvXImx//fmJYztEG6o=;
 b=h1ssTYW7XvYjxIXs9fN9Q8rSS1HV+Dmr/RjMu211+tnTexf6Wn90W1vHm4XN/pDIVn8tbxs8ENxM4gpaS74zKrVvfjharnZpDw0aHjWgVQ1rJqurivQYvYn0cs00tmQqVL8GqmqZITFUqutAfFtFhmXLCoc1gtonv8ZcJAi4vQY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6576.namprd04.prod.outlook.com (2603:10b6:5:20d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Sun, 7 Mar 2021 06:41:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.035; Sun, 7 Mar 2021
 06:41:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: fix error return code of
 ufshcd_populate_vreg()
Thread-Topic: [PATCH] scsi: ufs: fix error return code of
 ufshcd_populate_vreg()
Thread-Index: AQHXEZwvRopTDhfxZkyg2no8INMi66p4FQYw
Date:   Sun, 7 Mar 2021 06:41:07 +0000
Message-ID: <DM6PR04MB65751ACC25699CD1DB6229CEFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210305084718.12108-1-baijiaju1990@gmail.com>
In-Reply-To: <20210305084718.12108-1-baijiaju1990@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 29bb0073-71a5-4380-1c46-08d8e133fce1
x-ms-traffictypediagnostic: DM6PR04MB6576:
x-microsoft-antispam-prvs: <DM6PR04MB6576B241D23474201E0257D2FC949@DM6PR04MB6576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:378;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kvPoUUcUepQDj4Edx/EyaZ92zclu//2Z21eGtjcHhyLCHWmPxLRuzwVM4gugSVD4bXp7jmfXihfNMFjCDdJKJpUY5v5ELJ9cfAZkQ/SbAsIVemUKBJpy2Ja5us3jKemCnfVrT/mNILi0NkomOCzcM0853h3/Jb6GJJcejLx/lRsOHCsUD6RAQOI0CYTe1LKCM7s7yfG61wk2HKxWc8P8vHQFl2xuR+O4K14hcFo2VFm7P83cEEy1jGGeIc8+9bORAu/4FlRRKtvndqNgDnrzN0wYWqG+XjaTAwDOXwC4aA9rzGdoBL5UC0B+Mu3pd357Ao536g/rPZes7ALCE/Ee3zbuaPk97rEX4Eh5AaSC5K3kvUz93CbLj9niOQbHWFiboefXe8Auj6LPjq/r4Rj0IP5Qr/CO4jYuC/qzuo3GpwZFcyK1exr1WGWfNpiw2vwfgS/3awByOgGVijgiDB45wCX77H6CThbhJj6tqWOa611WQQDOaH+Wzn3iu0SBpu77Q3/eqvdNS8B514jet3k86A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39850400004)(478600001)(8936002)(54906003)(66556008)(64756008)(4326008)(52536014)(76116006)(7696005)(66476007)(8676002)(5660300002)(71200400001)(316002)(66946007)(6506007)(66446008)(26005)(7416002)(2906002)(110136005)(55016002)(9686003)(33656002)(186003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Pt+Y+6PHvtlUXYoD3O4KsSDzcp/4UYRovetT5v3k5QbIu4wey5W4xoD9O5Cw?=
 =?us-ascii?Q?pI9aFNzTWoWYW7n26qMVXVgtfIRL9/lDYAlKlOqi8PPzcT1IQkQHTAoTzdeD?=
 =?us-ascii?Q?Qvr6qGZfzMFqzcjJPIrZaAVJSmsmcTHEMyrOECegihK/UBxeT9dBjUNVAyYs?=
 =?us-ascii?Q?HcvgD3S7VSrNH8KW+1f21RlqSPXpqIMW6vcL956JEqvURafYE07irB5g74NF?=
 =?us-ascii?Q?RdeI14dGp6HkmcywpDjPiDol5UiyivSeyST3bsS4ckWxfKSEqNTpzSf37lZN?=
 =?us-ascii?Q?vv/m6BSNySr+ccU2vvkCRNQbo7Yh7zFlxrDUezL0guWJ2NoRDWn/AWjxOth+?=
 =?us-ascii?Q?9Y5KQDZhFlaQDeEv16b/B6WUWa8ldWJvjHBY1UZvlISfpmnhqaGDzquK1gce?=
 =?us-ascii?Q?YrOEaejc+dcBY1PT+ciH6SDHntyNEvoiFu7etJL3R/nQAPaGKZyXFGw9Hq/S?=
 =?us-ascii?Q?KDbvYZKVnt89E3rw+j0rxakjJGyW+3gTV9WfvobJjmKQlXaNDb4d749nIQ5L?=
 =?us-ascii?Q?2xPEgX5xHA74f4q6ww531/B4psysF/6GptKzfg620wSIDlmRT9+MoWL5JZyJ?=
 =?us-ascii?Q?IU6qbCn+ACLN4TD/MCkJIJZ5tJuIvAZvxnpH0x2hjq/9a2exBO2FVa9YhzL3?=
 =?us-ascii?Q?q0H07C0IEcfejpnzZZ8QmMCIl5XjYelCfWd5CU5lH0851wyIRxkqwujz8UGN?=
 =?us-ascii?Q?xJY0tYAP6hJNhl4vJJr19IPxOT5iy1EWieCqNKbhWda5UR8PAarv6940JATW?=
 =?us-ascii?Q?NGxVZ/aQoea57brR3NLZFjfno7ybI9C16qQhAw2xE2mDPsVJuY/s+VwrmJMg?=
 =?us-ascii?Q?AyKFuA7D4ClhMCr5TKJQ1E4j4pi0zCOU4sm/wk85kpZut1/oqviH36zsX55H?=
 =?us-ascii?Q?bEjlvucn1a8uLQaky/MjyLHWcT/V0wtsgndqHasTNwgmRXbEvh9p6I0IxKF0?=
 =?us-ascii?Q?FGtdWplYJXB8tHg353kbkUmEsidvdkqd0ieiHwdpX0torbH4w1KSBeqJIzOy?=
 =?us-ascii?Q?oMB/A3VFyp0JGEYa0wgNAUdUH9xJWmsHbve8dQpePEp1959N33T1O6gmFNbw?=
 =?us-ascii?Q?fe8YEWMWNQ4pQt6dVI7eyJf6aSaXwLGRWP0lRITbLnTnOtM0RSNLHMVlHxZs?=
 =?us-ascii?Q?gWxSmRPafen4JRB6BaRiy95dczjS51yUIP48RDaIoTreQfBi0pf1B5tS+hsW?=
 =?us-ascii?Q?Pmo3nx4yG4nmgvypk3/B8V9NvhEjD8SUJVbSkoF3a1THsXPiKU+vHbVi7VuK?=
 =?us-ascii?Q?nKefdlylUqgwUZIQcyMaBVxja5jspR9pxsk/QgQ5saayEl9+GVYQz2JeZFuK?=
 =?us-ascii?Q?XDPSmrLiwc81fHDYcmLKecFu?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29bb0073-71a5-4380-1c46-08d8e133fce1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2021 06:41:07.3485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RdlG6+/CSQ36f5jKvkkjE8L8gCnf+Zaj0ybsO8r5Psr+o6v22q4HR0WJdm+AOyTZn5jVv1BY69r50A9RhqILsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6576
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> When np is NULL or of_parse_phandle() returns NULL, no error return code
> of ufshcd_populate_vreg() is assigned.
> To fix this bug, ret is assigned with -EINVAL or -ENOENT as error return
> code.
This changes the flow of ufshcd_parse_regulator_info so you need to:
a) get a tested-by tag and indicate which platform & devices you used, and
b) explain further why ufshcd_parse_regulator_info doesn't no longer allow
     some of the regulators not to be set via DT, which is the current stat=
e.

Thanks,
Avri

>=20
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-p=
ltfrm.c
> index 1a69949a4ea1..9f11c416a919 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -113,6 +113,7 @@ static int ufshcd_populate_vreg(struct device *dev,
> const char *name,
>=20
>         if (!np) {
>                 dev_err(dev, "%s: non DT initialization\n", __func__);
> +               ret =3D -EINVAL;
>                 goto out;
>         }
>=20
> @@ -120,6 +121,7 @@ static int ufshcd_populate_vreg(struct device *dev,
> const char *name,
>         if (!of_parse_phandle(np, prop_name, 0)) {
>                 dev_info(dev, "%s: Unable to find %s regulator, assuming =
enabled\n",
>                                 __func__, prop_name);
> +               ret =3D -ENOENT;
>                 goto out;
>         }
>=20
> --
> 2.17.1

