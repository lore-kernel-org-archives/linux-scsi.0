Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE5FC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 06:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B32B120707
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 06:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Xy8s2RGV";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="L5cb5HUZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgHZGOH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 02:14:07 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:57159 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgHZGOE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2020 02:14:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598422442; x=1629958442;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2fCYA/32IWBQCh7LzCxGLkKYtkG1QqxnpFXwwqT4pyQ=;
  b=Xy8s2RGVYSOCn2oHF0AoAVneAdAXRohBmcqZNcK13cLX3EDSlf8odciy
   RH/orpf4WNliUUCQXHTkBOUuyKSyZShVN6rbod/UIWs871dUYLMDeesft
   RW7t539+Kp5J0GUEHbwBVCG8w1i+bnhmoXvQpz6OdvN2E96jnqc6KI5eg
   lr5jjmLufo1ASHr7U26kNC3g52dmrz/ZaVQcCYvQbz6aaq4YtIJsjU23N
   3ClGfy1QCp/FfMpCT2mh4BxHgu3zf0IvRsN9pTCGITIcOsKJ8EiVu5BIl
   nABp5+JWYbmQXm3VzCbisbTtDAPUd5zNrA4GJhPp7gbmiBIteehV/3J+M
   Q==;
IronPort-SDR: ASRTf2325ZL4jVRxoASwsoRWgfmpYicFgy5mATsQQUCxPnd0ArURFjC16QAjf98TbR9eDoNDs5
 hwhby3OJMuptfBa5rrmz9Xtr6Qk6R+4Pe3m6FSRfUXQOAKajC6mC/j6isiAato0eNPdwNOyccS
 gOdhQIRuwI1cCdwiQ6WRBnG2C6nUSdxVuXWdtHRvO84q0oqMCwMHPxtrVa7WvLp5B/qMhaYoD6
 ZcgIQrRzr4O7A1Zf9SSfCaI+D44xscEv/WDkyv6sIlS4xTAeqG1qNWRb4HkoQEEU6Rh5tZL0Ib
 oSg=
X-IronPort-AV: E=Sophos;i="5.76,354,1592841600"; 
   d="scan'208";a="150183474"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 26 Aug 2020 14:14:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImW75GXgi+nHj4+DxnjuOZzoSVGAi8FSNzb6TrlrXWONY79NNJ39yWdE7HtUQqucNC7ePRvbvvTqkMzc28C2dAJ/TbvQUIwzdLr4Zs/zallfwrH14/XGOD2gg5BC4fOjgrVA8LL5oKRK4SgrZRzXuuvJlxjuXqP0hnxAoAMgDxIsOsBP7KL1TpmHzdYIEyo117wdt2yMK67EwWk9FAe5HyuZ+CDFdGNlYmrYb0qta83814ZXyLz//OyanPPR4sPcZYU9wfwS97cFwSrijH4rncSH3gFUp/KgbqfZQnH11qAKIiCIoQ3SLe1u7H1xlx+TXsqtmr66BCuM/2lM7G4dtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DM9iAhw1egtVcd+8x08/iKIw0+Wedh3ZmsMXEZFfMH0=;
 b=Vb+KFzD4p0Mey+zOyiX32dh3rmDLGihsA4j2wW+ASl3GvxkDtWZq8c2CEFXBT/8hxuHuAT+JUskyuw2uueA5cWD3XNkcdY/gM0S9RO043aY2/Jd3Cg4IHryUNawo9ZLzocctI/ZHGnmInOEf79+whIw+aSD4PBgF9lQsi19i2PlAlSm2dOdMsv6vzNntNN4/DOiBkjRP9F/IRqYIkjlLDqU1UbnkoV7j2Gk9I7zdj4ti3mC/a51902/lHOcBKf7N542dbcXS+NL0HwG9CgbuROUkjIWylh4NWuorxV17iLoU7NaCYfmhd+SPt3R2v/l04113pSRKSPw2PJP/MEbu9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DM9iAhw1egtVcd+8x08/iKIw0+Wedh3ZmsMXEZFfMH0=;
 b=L5cb5HUZRxv98JRsvK72VobGA/7mtfOSET4+bOMyLaVEFZoaIvIlQvrjuuOC68QnhdzHNy4gGSWacdIX1rL+XT6lMPFuSsRPsEYljygNPi7xYafM17ZcFdWAkOcWRcBWpXESqdCjbHRtyVAz7g7az0ACuVrJ+XlCJDYRovJoiVQ=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BYAPR04MB5446.namprd04.prod.outlook.com (2603:10b6:a03:d0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Wed, 26 Aug
 2020 06:14:00 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd%2]) with mapi id 15.20.3305.032; Wed, 26 Aug 2020
 06:14:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH] scsi: ufs-pci: Add LTR support for Intel controllers
Thread-Topic: [PATCH] scsi: ufs-pci: Add LTR support for Intel controllers
Thread-Index: AQHWerh8jAraRVcWhEiaxLeTYGSkdKlJ5ztg
Date:   Wed, 26 Aug 2020 06:13:59 +0000
Message-ID: <BY5PR04MB67054EC026978782F129F88EFC540@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20200825081854.7222-1-adrian.hunter@intel.com>
In-Reply-To: <20200825081854.7222-1-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 07c8f140-99b0-42fe-5e4f-08d849873927
x-ms-traffictypediagnostic: BYAPR04MB5446:
x-microsoft-antispam-prvs: <BYAPR04MB5446A628A68A80466F977B2EFC540@BYAPR04MB5446.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: syO+lOHu6pGxqVRsC3NttDEk69dKJvrn8Ze8HMqTV0hhNeyYYhqY3Cy903eEefAAUSww0Uw90g+xysSQr21IDg5aHwc/tLmFRUnLISQdH7Xv9Plv50PMTZDaVXh1Ia4FhJP/ZWeEe/oLaexbPfaRjr0WNpwKgjYzq1n9QhnTW8YLG5aMNFQjm0w31fOJwkpKzlTuJ8h26rnbW9s31DyAzfr7lmreo3/QjO9rYuUpZ0J4wZwIy1+j1ynNY+xRe3evCrO6/TalRnpMNQv4QoXkfagZyJiii+4FOO2dZTmo/H7twnHGyxLAPQrjkKqx0m46TradLyRA7tDuLk4EKrMmYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(64756008)(110136005)(66476007)(4326008)(5660300002)(71200400001)(66556008)(2906002)(7696005)(52536014)(76116006)(54906003)(66946007)(478600001)(55016002)(26005)(186003)(86362001)(33656002)(83380400001)(8936002)(316002)(66446008)(6506007)(9686003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: meT6GXrtQyW5CfzUFKdUuR/buAqQD6xYhL4Etnz/7jMHIfVgPTPix/JK8S9Y6rH7cngp7fwRZucoLI1zexcc5GH8P3QzkXP4hpU/lXFyE9dNSnYCnMl5oGXjsPsmyx6xSXhw3L8Xlr39wBJ6iChTkxSqlcICfZ61qRkyLRAaTwPF0qp9njT6b8aQTufL2QEO17yNZrfqu7ZElqYwNnKptvWA2P3btXlDB2vOsOsw3usETNVmjiPirNeoZh5bXmPx0nBHXGHay6lUx1lFCKCh7ZqNq6hNgYJ4fCvr/7idpI49B1snIUWZjpz6wtsemBfQUpSZWcr6g3QBLX30KprgP4KJ5gUiHjkJZ9kwE1zRZ5u4WC6JXCopOjI3MnbsL5rd2WLOc1KMfZVj7XlnRFbOeZkcwOhqAeL9R688jwdsqk6WmoTn+4t4imUBzwWB1tSB9TXmQlowMfv4OxuuiOonp5rK0dMmqDFqikr0vjjY+vynU5AUDbNYkMvGnCu+jwlHhY4bJWSMftThPbF77iZZySxYp/ImjdZga7CEKaS6DIWhRJX4TfYjWXsiXhkCJBbToTpb54nTNBje1jmWFKsbrlenpGNjqXyEUVn/65fG5jLi10tpD10z5d3TXqhtNlC1D3lF1R76aO2Vv8mSVoKYfA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c8f140-99b0-42fe-5e4f-08d849873927
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 06:14:00.0114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IkoimDkEwAsHgXZzk4NaewbrBdySnkPYSW4wiPgt+PbD3SXWSEMPh8tRBTFsV7uXufjk074boHVD/cSJMTbJdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5446
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Intel host controllers support the setting of latency tolerance.
> Accordingly, implement the PM QoS ->set_latency_tolerance() callback. The
> raw register values are also exposed via debugfs.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Some nits below.

Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufshcd-pci.c | 122 +++++++++++++++++++++++++++++++++-
>  1 file changed, 120 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.=
c
> index 5a95a7bfbab0..e10f05013ae6 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -13,6 +13,14 @@
>  #include "ufshcd.h"
>  #include <linux/pci.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pm_qos.h>
> +#include <linux/debugfs.h>
> +
> +struct intel_host {
> +       u32             active_ltr;
> +       u32             idle_ltr;
> +       struct dentry   *debugfs_root;
> +};
>=20
>  static int ufs_intel_disable_lcc(struct ufs_hba *hba)
>  {
> @@ -44,20 +52,129 @@ static int ufs_intel_link_startup_notify(struct ufs_=
hba
> *hba,
>         return err;
>  }
>=20
> +#define INTEL_ACTIVELTR                0x804
> +#define INTEL_IDLELTR          0x808
> +
> +#define INTEL_LTR_REQ          BIT(15)
> +#define INTEL_LTR_SCALE_MASK   GENMASK(11, 10)
> +#define INTEL_LTR_SCALE_1US    (2 << 10)
> +#define INTEL_LTR_SCALE_32US   (3 << 10)
> +#define INTEL_LTR_VALUE_MASK   GENMASK(9, 0)
> +
> +static void intel_cache_ltr(struct ufs_hba *hba)
> +{
> +       struct intel_host *host =3D ufshcd_get_variant(hba);
> +
> +       host->active_ltr =3D readl(hba->mmio_base + INTEL_ACTIVELTR);
> +       host->idle_ltr =3D readl(hba->mmio_base + INTEL_IDLELTR);
You might want to use the standard ufshcd_readl

> +}
> +
> +static void intel_ltr_set(struct device *dev, s32 val)
> +{
> +       struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +       struct intel_host *host =3D ufshcd_get_variant(hba);
> +       u32 ltr;
> +
> +       pm_runtime_get_sync(dev);
> +
> +       /*
> +        * Program latency tolerance (LTR) accordingly what has been aske=
d
> +        * by the PM QoS layer or disable it in case we were passed
> +        * negative value or PM_QOS_LATENCY_ANY.
> +        */
> +       ltr =3D readl(hba->mmio_base + INTEL_ACTIVELTR);
> +
> +       if (val =3D=3D PM_QOS_LATENCY_ANY || val < 0) {
> +               ltr &=3D ~INTEL_LTR_REQ;
> +       } else {
> +               ltr |=3D INTEL_LTR_REQ;
> +               ltr &=3D ~INTEL_LTR_SCALE_MASK;
> +               ltr &=3D ~INTEL_LTR_VALUE_MASK;
> +
> +               if (val > INTEL_LTR_VALUE_MASK) {
> +                       val >>=3D 5;
> +                       if (val > INTEL_LTR_VALUE_MASK)
> +                               val =3D INTEL_LTR_VALUE_MASK;
> +                       ltr |=3D INTEL_LTR_SCALE_32US | val;
> +               } else {
> +                       ltr |=3D INTEL_LTR_SCALE_1US | val;
> +               }
> +       }
> +
> +       if (ltr =3D=3D host->active_ltr)
> +               goto out;
> +
> +       writel(ltr, hba->mmio_base + INTEL_ACTIVELTR);
> +       writel(ltr, hba->mmio_base + INTEL_IDLELTR);
> +
> +       /* Cache the values into intel_host structure */
> +       intel_cache_ltr(hba);
> +out:
> +       pm_runtime_put(dev);
> +}
> +
> +static void ufs_intel_ltr_expose(struct ufs_hba *hba)
> +{
> +       struct intel_host *host =3D ufshcd_get_variant(hba);
> +       struct dentry *dir =3D host->debugfs_root;
> +       struct device *dev =3D hba->dev;
> +
> +       dev->power.set_latency_tolerance =3D intel_ltr_set;
> +       dev_pm_qos_expose_latency_tolerance(dev);
> +
> +       intel_cache_ltr(hba);
> +
> +       debugfs_create_x32("active_ltr", 0444, dir, &host->active_ltr);
> +       debugfs_create_x32("idle_ltr", 0444, dir, &host->idle_ltr);
You might as well allow those values to be traced, e.g. use dev_pm_qos_upda=
te_user_latency_tolerance

> +}
> +
> +static void ufs_intel_ltr_hide(struct ufs_hba *hba)
> +{
> +       struct device *dev =3D hba->dev;
> +
> +       dev_pm_qos_hide_latency_tolerance(dev);
> +       dev->power.set_latency_tolerance =3D NULL;
> +}
> +
> +static int ufs_intel_common_init(struct ufs_hba *hba)
> +{
> +       struct device *dev =3D hba->dev;
> +       struct intel_host *host;
> +
> +       host =3D devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +       if (!host)
> +               return -ENOMEM;
> +       ufshcd_set_variant(hba, host);
> +       host->debugfs_root =3D debugfs_create_dir(dev_name(dev), NULL);
Maybe pack the debugfs code together, i.e. move this just above debugfs_cre=
ate_x32 ....

> +       ufs_intel_ltr_expose(hba);
> +       return 0;
> +}
> +
> +static void ufs_intel_common_exit(struct ufs_hba *hba)
> +{
> +       struct intel_host *host =3D ufshcd_get_variant(hba);
> +
> +       debugfs_remove_recursive(host->debugfs_root);
> +       ufs_intel_ltr_hide(hba);
> +}
> +
>  static int ufs_intel_ehl_init(struct ufs_hba *hba)
>  {
>         hba->quirks |=3D UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
> -       return 0;
> +       return ufs_intel_common_init(hba);
>  }
>=20
>  static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops =3D {
>         .name                   =3D "intel-pci",
> +       .init                   =3D ufs_intel_common_init,
> +       .exit                   =3D ufs_intel_common_exit,
>         .link_startup_notify    =3D ufs_intel_link_startup_notify,
>  };
>=20
>  static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops =3D {
>         .name                   =3D "intel-pci",
>         .init                   =3D ufs_intel_ehl_init,
> +       .exit                   =3D ufs_intel_common_exit,
>         .link_startup_notify    =3D ufs_intel_link_startup_notify,
>  };
>=20
> @@ -162,6 +279,8 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
>                 return err;
>         }
>=20
> +       pci_set_drvdata(pdev, hba);
> +
>         hba->vops =3D (struct ufs_hba_variant_ops *)id->driver_data;
>=20
>         err =3D ufshcd_init(hba, mmio_base, pdev->irq);
> @@ -171,7 +290,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
>                 return err;
>         }
>=20
> -       pci_set_drvdata(pdev, hba);
>         pm_runtime_put_noidle(&pdev->dev);
>         pm_runtime_allow(&pdev->dev);
>=20
> --
> 2.17.1

