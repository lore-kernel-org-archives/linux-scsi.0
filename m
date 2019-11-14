Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59873C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 09:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 246CC206C0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 09:23:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fyj4HxWq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ywOrHAxp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfKNJXL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:23:11 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:32291 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfKNJXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 04:23:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573723391; x=1605259391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5VT+kaQ03lXqDAN6MipTRWVxrDKhpcgz+r7mnVnEEzQ=;
  b=fyj4HxWqZbFz1UlxjLjOXlUUt67PHfyw+s4Tk6W+bV7npqkwuQSaTjJl
   iSPNqTlYuVD5Ne3SgT6du+aN8lvnjdvbC/7tTG0DotEGgU1BvmGsDr82x
   VS3JUiJ7eLtSiLgVCSmq3KC7Sl60/Gbl84tgK3h7DkREXWynrI/2BEkLA
   q06AZGxpKtZhg2AoykkWzuoZLrvCGEL6TWdoWjabQfnN8k1OhjFVVO9HB
   BPy3//P6X+fsZCa7c83/nK3Vekdl3z0c8aLZOjBeo7dC+K96NVHVKktQD
   q830SDzLxpB5+jzNy9nWdkKI9d5v1G6wRvf2OnzsEe7O0wAd4gteDvVPW
   g==;
IronPort-SDR: j1630EsLVyHICqlZbPaoDTLRfow8l8n/Ew82QQLb8cZkv3BOyZSe5czP2spILPif7kPtIyTrVH
 gAPw/eLDpQd0tanADcP8s2F+I7WO3v/h2o4O9+47AM1/ThnETj0r1o/8Ii0SWmb27MbdQuPNV7
 ODKfxnNJxKtLFmh7y+bKvy2OTVR4wJU2Ly/t9zVWyXng1VQ2zgJ2isaRIlJT6h5ymsjCxguHYR
 FWFQ5tG562DCERIyrSgdSfimPdZBGnwP2Gsk9K6EFcv4r0fKXEOubNqqPkSz55+SMG5e8shSHN
 Da8=
X-IronPort-AV: E=Sophos;i="5.68,302,1569254400"; 
   d="scan'208";a="230313223"
Received: from mail-bn3nam01lp2056.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.56])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2019 17:23:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjWFTEcoG8IS+HMNX0pZTufb78KQPlFbTF6LG2xpCLUGter6hVL7PzJ13zJ19YdY0UU/o5UeayOBNBC4vS7ikGEMUWOe9eD56riFvLoQQU0lVidq2QP3q6F+n9LEb6w65e7h97OghwQl48Oti1P9kFQbiGn09kuB0vzURFZgz4KzEfJ6g2PYCje7iQfLiXH6GCawPb6hJF6NFih7/84kW4/jayuoecPoDwwUmc64xtGXYUa5pzAFx2fSPUCtNXLPYNrgpAiCX7IPg6ENfTFVfoTWClkZUSy10hZvFL9KUCWEZZwFcIEvkCrBhqLPHzShHkk8GKFmvnc1SMr+vtEJZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xldPNlNURP6rL0/VpCIXmoKevq86ZW1O+B+I6hGgDPs=;
 b=bGrwN6A/cdGL005eitLi/JtUSjSFgeVIALGrJgCtduyAwq+jIyuDvDAPtF6Dsh7Iingu2Pxwrh8lQtDQ/Sj4fGscUHEnNFa0uagGnxpcO4suxsK8TBUkNd6f480O9Wlvqzr/wfVxfg8SaRzvDk8HivlphzqH+18a8DeZbmT75wIELHsIaJFu8NgP3xJ5d71mmyUDqVJZYAz4qqLznS9em9Q9Kd6J8r38DJX+zP3J4V0fFKmuHHoVD85O9UcS17Rxdisdxx/M43s34fv0Q+bhf90tuBmUBdRqz4nuxYzIfuEwhkMQZ0vJMvrqGtu7iyFJCHLTpQUmUeP9celhJ6P3+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xldPNlNURP6rL0/VpCIXmoKevq86ZW1O+B+I6hGgDPs=;
 b=ywOrHAxpcDENpdTYi3m4pyDgQGQWOjJTWafht0km2KItE1et0QZnwm1vySPVxqUf88CtXSWSEQQzkpaRnoh4A6IdX2L44En4XOQKdF7smfK+eA4GNQbDoetCul30U7OQoJdGxjaz37uV8KlsCXEmL84+ve6RG0CM/Z95Wo/QHCE=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB7037.namprd04.prod.outlook.com (10.186.147.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 09:23:08 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Thu, 14 Nov 2019
 09:23:08 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 3/7] scsi: ufs: Fix up auto hibern8 enablement
Thread-Topic: [PATCH v4 3/7] scsi: ufs: Fix up auto hibern8 enablement
Thread-Index: AQHVme4fVbWYprW9XEWIKx6qvICz0aeKZSMQ
Date:   Thu, 14 Nov 2019 09:23:08 +0000
Message-ID: <MN2PR04MB69913B9DBCEE72322A741F14FC710@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573627552-12615-1-git-send-email-cang@codeaurora.org>
 <1573627552-12615-4-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573627552-12615-4-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ebe4d2f3-6ec1-4611-70bf-08d768e4431f
x-ms-traffictypediagnostic: MN2PR04MB7037:
x-microsoft-antispam-prvs: <MN2PR04MB70374D5BE344146FC1DBE1B3FC710@MN2PR04MB7037.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(199004)(189003)(229853002)(25786009)(478600001)(14454004)(66066001)(7696005)(102836004)(2501003)(6506007)(33656002)(76176011)(486006)(446003)(476003)(26005)(11346002)(186003)(6246003)(7736002)(55016002)(6436002)(6116002)(9686003)(8676002)(2906002)(4326008)(3846002)(81166006)(64756008)(8936002)(2201001)(66446008)(81156014)(110136005)(316002)(86362001)(7416002)(66556008)(54906003)(66476007)(256004)(5660300002)(14444005)(99286004)(74316002)(71190400001)(71200400001)(76116006)(305945005)(52536014)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7037;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 22SHiON/lgATydqGHaRX1CnON2Ucbcpw/QV/Dus5ptNORijygDD+6XMy94polN5qOSG3lDOAg3W932McvcvHQg4UC9UdISwQzCvm3n00e4h9z+DPYJxP7x9cOBTo+4QsleXkVTP1td1bCav/DtMweYJQAwDwqFY90pmqeCJXVBZEP7lzzJZsL/dWoFFdDnBJFKEOFM4vApexyF284FziOLcGtH4Ffr0fzux6XaJrdveaqVwkcY4XXsDxtvhyJuVKGPwoevdRqsmvmnWsiwNoU5CYww+kIGx9W3udCQxMP25x2YtvcFfWOFwAlZuaD+2yOV5D7gGG3Tq7W7yMvJKngd1pSBQCv5XM5LR1SSFdN/GqEy2afsxteVF4kc/OCQOmnUhgiy8hqTHhamHR52XgLQqBEU9sf4HDvk1LDMsUKCjUQO3sMOQ6ldAFiCEdFCDF
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebe4d2f3-6ec1-4611-70bf-08d768e4431f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 09:23:08.2766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9eCtadQ/k/Z54IxG4mWOVZjWAdHX8RpdFVYRazw87jhS9QxSzS9GCeXHHmwYcqtvAoCcl60xaaVZ1YCfeERu5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> Fix up possible unclocked register access to auto hibern8 register in res=
ume path
> and through sysfs entry. Meanwhile, enable auto hibern8 only after device=
 is
> fully initialized in probe path.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Acked-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 17 +++++++++++------
>  drivers/scsi/ufs/ufshcd.c    | 12 ++++++------
>  2 files changed, 17 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c =
index
> 969a36b..6c2f19e 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -126,13 +126,18 @@ static void ufshcd_auto_hibern8_update(struct
> ufs_hba *hba, u32 ahit)
>                 return;
>=20
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       if (hba->ahit =3D=3D ahit)
> -               goto out_unlock;
> -       hba->ahit =3D ahit;
> -       if (!pm_runtime_suspended(hba->dev))
> -               ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIM=
ER);
> -out_unlock:
> +       if (hba->ahit !=3D ahit)
> +               hba->ahit =3D ahit;
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
> +       if (!pm_runtime_suspended(hba->dev)) {
> +               pm_runtime_get_sync(hba->dev);
> +               ufshcd_hold(hba, false);
> +               spin_lock_irqsave(hba->host->host_lock, flags);
> +               ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIM=
ER);
> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
Call ufshcd_auto_hibern8_enable instead of open coding?=20

> +               ufshcd_release(hba);
> +               pm_runtime_put(hba->dev);
> +       }
>  }
>=20
>  /* Convert Auto-Hibernate Idle Timer register value to microseconds */ d=
iff --git
> a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index 525f8e6..f1=
2f5a7
> 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6892,9 +6892,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>         /* UniPro link is active now */
>         ufshcd_set_link_active(hba);
>=20
> -       /* Enable Auto-Hibernate if configured */
> -       ufshcd_auto_hibern8_enable(hba);
> -
>         ret =3D ufshcd_verify_dev_init(hba);
>         if (ret)
>                 goto out;
> @@ -6945,6 +6942,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>         /* set the state as operational after switching to desired gear *=
/
>         hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
>=20
> +       /* Enable Auto-Hibernate if configured */
> +       ufshcd_auto_hibern8_enable(hba);
> +
>         /*
>          * If we are in error handling context or in power management cal=
lbacks
>          * context, no need to scan the host @@ -7962,12 +7962,12 @@ stat=
ic int
> ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>         if (hba->clk_scaling.is_allowed)
>                 ufshcd_resume_clkscaling(hba);
>=20
> -       /* Schedule clock gating in case of no access to UFS device yet *=
/
> -       ufshcd_release(hba);
> -
>         /* Enable Auto-Hibernate if configured */
>         ufshcd_auto_hibern8_enable(hba);
>=20
> +       /* Schedule clock gating in case of no access to UFS device yet *=
/
> +       ufshcd_release(hba);
> +
>         goto out;
>=20
>  set_old_link_state:
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

