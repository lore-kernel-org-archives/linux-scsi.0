Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F937C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DABBC64F1D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577357AbhCBSuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:50:06 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:5955 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836444AbhCBHCl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 02:02:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614668560; x=1646204560;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yuYMErnNW0A+24F5rN2RS9uOttmCrd+0Gj2JlPoXRaM=;
  b=mWYY9vjbF8z1KOGXrHzFW3AGYjI/9ddtetAjtmrf3c+iIvUHB/qDhjXx
   fsyNQg7wzsa4tWptq5FZ3RnHNwl4xjXtxGasHvqNyZHfzjZJqztNn80Q7
   r01ejgnLGiPcMWHdnKebPqguGkj4KlW+4t2OSjTzKsacYwO7zkvpAN0Ss
   m7RsdOHKXMPaI4IEmeBkS/XoC8SU4FnzdeCy4RlgLFCQwPb7prN8JCvSN
   9pGBYnSODrQcQAoYmEXwy4emgfMc6mCyUedp+vcUbnMVjxws9x9XvtM7g
   /Ss+iXCTpaLDuxQog3IDU/z1PgRl9emIPGEfV/LzoeZlZ1zYwN1GWuKF0
   A==;
IronPort-SDR: uHJVictUU0hpHt3izabcGVLq1ac2CzmX1Xmcd32hlic++50sm6O3EW33PJvSn7Osi/GBRQlfVw
 Ub0xhSqxVxMDS6v00AZwyfTnjucgOmDct0Howuf1dphHqpwDtsUdSvXVKMSGMUOrjoOuYqomsk
 bUKMJ0wVjACeLdpl99Qv06nlpZXxfUrgkn29ux9car3fCg26o7MOTy4p6bij5PxAykc7fG7QOT
 P+HS9IUVU9IOijLliU2VgKK9LLCXUK0y4dEuYLbEIbMU9PvrhJFqBddIEqlDFFj9eLR4HPoPMQ
 IYI=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="161121234"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 15:01:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lG0RI5DEstDHQWjshvrg5gYdVyqpoLYlxxlXfBENcaPcn844KZckIXOLcEuNuYf25qXTliEwLmfO+MMt26wcvWxpadBws/MM9SnN0MHU8oT9/5o+B6UZtp8B8u/nvciOgOr8EdBCtO9OMnMv4WK8Jiok/tsPGi9LcbsXtDWW5lIuouQ8wVDPx4AXhuGlEzEkPEF7vIoguI6RhsDMVeqobopyNmVAhpxNthZjcJ2JissfELOSJk5hsUTWDZYA6EIW/izG5mfNi/dHMOBeUD8r0NAQRDTCq51thUCIfil8jXVRIUHN0fnDVKrhsH2fw1EkIqyZt0ul9A+Q+QTAUsu6Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gf02Z9+XvbyIX6ApYVXhx5LnMz/l3+o3vLVA1Li9OxI=;
 b=c5Gic1DIzQHCv91HZngCvS26iOY0vgaAlil2tWgV0Cx2seCiHHUYe45Soxv1aDkvpLsel+miwXU+jRzjlXMqh1O6D06yosD7dEraz6JX2kxMnObBu0dmwuU5qnmXfWcC66CeVAg2FrszJKSUGQzQgT5/mdjemlJkvUZ7AUaExccDucxGkvpr6VY+qs6rVDMRVx3N1KxEIYt+Vw7m2Z5TSrwsfuaXpfcmW7Zd7yDeQ6V/IaC3eV7zM3YE36Y9fAPolcivWxoh247BEbJb6vUuPAO53Pfu6V0fAOTCMRQs6hwi+a8HywTXiynNOqPpF/ekKc9Mt8bTAEJW7OI8KfFX6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gf02Z9+XvbyIX6ApYVXhx5LnMz/l3+o3vLVA1Li9OxI=;
 b=El3ueRt9lLM7jT1DfvlNwqXWpBlRLZ8ZXyy/P3sWgjik+QWGoSyBKGUjywrGhs4TEJinei7e2Ye+dKAjnvHBM9rBNjXSYoM0cjy9EyihMXU3/UE336POYeGVEwQv6HdGArOmXA/rvXwnG9/hNP4Yjo3zVntIIzelpLaSRl4e40A=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4491.namprd04.prod.outlook.com (2603:10b6:5:1f::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Tue, 2 Mar 2021 07:01:14 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 07:01:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after
 ufshcd_reset_and_restore()
Thread-Topic: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after
 ufshcd_reset_and_restore()
Thread-Index: AQHXDs/Xkhs8QX6wuUWaLAgULwpYvqpwRSFA
Date:   Tue, 2 Mar 2021 07:01:14 +0000
Message-ID: <DM6PR04MB65753E738C556F035A56F77CFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210301191940.15247-1-adrian.hunter@intel.com>
In-Reply-To: <20210301191940.15247-1-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd5456f6-185f-4de3-d5d7-08d8dd48f855
x-ms-traffictypediagnostic: DM6PR04MB4491:
x-ms-exchange-minimumurldomainage: kernel.org#8761
x-microsoft-antispam-prvs: <DM6PR04MB449177127266A657F4548960FC999@DM6PR04MB4491.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D1USMWfeBSPVtvum9xHZ2jXZ6y5Ox5jj7FXtAFeKMPT0RfAFDY82pli3gw97ph9rqNOZt4/2ohLyq5n8DVTRuRDTTy43fy3CiPRsHqY3xNEpmSRf6FPtbx2YkIqCSDl1u3Fc+oLdjrf7DcPUZpjj/R473+FFg7lDoHsHto6mZzUkWvZkP9dX44RoFgcgdSIKUJRoGzwBzHQqsb8SfDg5zySmvYibHybqVSkNuzV06XAvLmMlUQ57CnD1fYWO7iseMZtoyoxNzrRtmLzY0JGcilpJv8pkHRikhq/K13uCV1QVBSS6lcH2bjfLBIFwaWYH6ntQ3eqZiezmqVpWLvL0vSNQD7W5L85TAEx4swUCxKrCqHu7ebN166vwQqNXBxV+CDSb1zbmo7+XLAHQ9blKEg+XeveMUKLeMfkj9b0B5RCGvKiyFq//YOwrS34ZOCX+p/xkXJfwJPZK1+dKsdnZ1hfaMx9lhkkYL5SIuAJi5f9GaxMiRQhrf8zYbBqHZygx+kjg8cY+feDRflKHBytB7QSRmQGOqBZzR+mnPWJ7FdI4txV7c5kPSAhcE1IB+dA1Hto3ZJ/UX/NhJ5adOQES/wYCNoEneVFmME2dEQoIINc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(7416002)(9686003)(55016002)(71200400001)(83380400001)(86362001)(7696005)(26005)(8676002)(8936002)(186003)(33656002)(5660300002)(76116006)(66476007)(4326008)(66446008)(64756008)(110136005)(52536014)(966005)(316002)(478600001)(66946007)(54906003)(6506007)(2906002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bgLyH13roy8UJiF2/kWppapKY9Gnd9TrFuHC5OIlfpB33mV0B4oW+cbILLKi?=
 =?us-ascii?Q?iRqCgOemRwF4Z9XLkCAnaYXVRYeqtpY1p1a+pFcyyMmf6OtmCn2pt1JNePqq?=
 =?us-ascii?Q?LvBMdG7cQV9odW97IeunE9kQmyS7LkfMHtRRy3gcpf2Gu6eASTHPdV6J7g71?=
 =?us-ascii?Q?Y66KlEQ40xLqyTOOWkRseulxscaNEit6r4TFBI0fYjuvPssWm2N5p7I8E0uL?=
 =?us-ascii?Q?StuHdkV7sYE5aSjeHMOiW/ccRfP0betg3njNuxIqXQay3b3ZYvXd0vuWNtQ9?=
 =?us-ascii?Q?uCi7VXU4i5jP5wiYabKKFtD2atNPC646izjoA/WXnPcrUf5TQRWU0EDMwK97?=
 =?us-ascii?Q?e1l/O6YKb7n7gbRbMI8Yc5wfYJL1S+U2Mf1TTe4RX0NbJnS8PPvspxt62K/i?=
 =?us-ascii?Q?m5Ud4y8wB3svv1alSAvd0j2jMDL1IBqvKM41tkHcv7EUd7SGy9iGyXaEv+Rd?=
 =?us-ascii?Q?pML+yZBMJDnonHFioiG7xkhGxwbjbXk86TeOdgjwkvOELRoc6bZcGSm+ZFp/?=
 =?us-ascii?Q?AiB5lPbgIQDrmBBhRF67UOSCPoPHAbJHed5yfXO5UwCI5YXJg6/SVY/HkNCS?=
 =?us-ascii?Q?HbswgdPuPTDxmAYEI6orff8xSh4IF56G9Ce9/ZH47s9OqRpWY6VK58VBnyF2?=
 =?us-ascii?Q?oYan5DirE3Wh8m5AkiomNV7tZ2i19x/QoZwZt1h/brtbiqsZO045GeLu8K2b?=
 =?us-ascii?Q?Vcdccbjjne2IpdJylpdGbhU1zXeHZYJtVOeobd1RF8FdcPVgCBxK2xJz5QIF?=
 =?us-ascii?Q?5NQqIkIpGcbPXqpYfJPcgh+GxuAsD5VPz0TnaRbJVdi1M7ntBtrMRMJkDXif?=
 =?us-ascii?Q?Y16mHKmJ7cUTeNiljE4TXjE4XLy+LUvF4cmOvk0ghgU/Ba2BamT03MHe1Q5l?=
 =?us-ascii?Q?sdOagPvFCIXvVJTGhqYr/xuGoDfbmpWrI2KLAHRJGa2AWYZWGififp9FZnDI?=
 =?us-ascii?Q?26PLhagRhW9M5S1/LEYmjH1qdTX/4G6IWmPAREinYf1l5sq1BPJbmZKm0J30?=
 =?us-ascii?Q?bEkFPkpVSAThXENXflEMAAQPewNM2/IHnDkIXbiaspTuKkWx3k39cObkE7mV?=
 =?us-ascii?Q?zL0w3/TkMQRWfw7LJso8PLZZ+FtNn7npSOw4hXeC4VzKGzuvo3BAAMJN1A3e?=
 =?us-ascii?Q?fK5uEDzrKRBd/ltuG0694lJQckKDUba6ItpnzHdwr9rAwhloYK/dECfXOQEi?=
 =?us-ascii?Q?7gQTSpzBuoBDmb4DncRgZxB6tsSmIRWAwAdZAOp31Oij6pJpV9VryaiZMWRS?=
 =?us-ascii?Q?MPhtUuN8jvKwDeSsGI5VQOv+OYEHtY46dcTZMHMtR1Mg4SnTGyReOmqnGq6g?=
 =?us-ascii?Q?KCNBgSLObPseQJ0iG80Vp1h9?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5456f6-185f-4de3-d5d7-08d8dd48f855
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 07:01:14.5827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RHkBRgp9BM0LqF4BTKfSLgevzUhnE+xYVJoSi1Vi6XRDK/5LPjpnnESRwtywNp/7N8VziPX3Kr4o0soU7BvJPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4491
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> If ufshcd_probe_hba() fails it sets ufshcd_state to UFSHCD_STATE_ERROR,
> however, if it is called again, as it is within a loop in
> ufshcd_reset_and_restore(), and succeeds, then it will not set the state
> back to UFSHCD_STATE_OPERATIONAL unless the state was
> UFSHCD_STATE_RESET.
>=20
> That can result in the state being UFSHCD_STATE_ERROR even though
> ufshcd_reset_and_restore() is successful and returns zero.
>=20
> Fix by initializing the state to UFSHCD_STATE_RESET in the start of each
> loop in ufshcd_reset_and_restore().  If there is an error,
> ufshcd_reset_and_restore() will change the state to UFSHCD_STATE_ERROR,
> otherwise ufshcd_probe_hba() will have set the state appropriately.
>=20
> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and oth=
er
> error recovery paths")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
I think that CanG recent series addressed that issue as well, can you take =
a look?
https://lore.kernel.org/lkml/1614145010-36079-2-git-send-email-cang@codeaur=
ora.org/


> ---
>  drivers/scsi/ufs/ufshcd.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 77161750c9fb..91a403afe038 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7031,6 +7031,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba
> *hba)
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
>         do {
> +               hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +
>                 /* Reset the attached device */
>                 ufshcd_device_reset(hba);
>=20
> --
> 2.17.1

