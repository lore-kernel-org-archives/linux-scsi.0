Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8DF6C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D9120776
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="gUmMSvEE";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="eJ8XdRpO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgDXMId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:08:33 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:44760 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726699AbgDXMIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 08:08:32 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6DDF3C033A;
        Fri, 24 Apr 2020 12:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587730111; bh=OjRBBrKUEqS3V7tLF2nS+bk4t3bXk24laE631iWStXA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=gUmMSvEEkLCi1bi58bnSXy1415oRKg7lSfG2UPWsv9W+K+R/TVPA0teCLpG/bqlQY
         GqljLnE3zBWuq8E3oBBjPXH3qQPm65eOeugd0yt1F9rPrhzk4yQIR3BwkvGkFpFm50
         q3Et3vsp/CaR1PyJ5/rnV+VFjfSg0xUQfrll6hBNRkZ+Mqc7pqVTMVi3nOvOwt0IOc
         n0otmE3FY/qrTGfndGujvGOzPxXMr/lu3cBnOAyEBiGg0d+A96XFjtqJgk5mOaDBbH
         6Nx58K0LaBeXDgygXN2U9GnGc6Xe4Z1+dSOlC0L8DGs9O3xnDyxSwd5noHGY9C8Hj1
         d55k+GQjC3y8w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C7C87A0067;
        Fri, 24 Apr 2020 12:08:21 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 24 Apr 2020 05:08:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 24 Apr 2020 05:08:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSZ0CD3BMBHsmXItdwI/kcoshCW+2A+2aCrdogOlkhJeGTna+a9OtdtDOdR5c18ejnOO7rIkkNwcA/rO1ke8YSVf4EXBZQrA3xczWcQ4Qo92KWAjEFnOyKnobvoizwtur4KE1CjnUFn8fpdBYKpGeuksn57DPwRKdNFTDAsaTSIY3TntNlo1LvPY2R4ES9aduGYOJ5SP8ukIcrc5lgLwksW8vTjqmwz3yjMSod6CVwdCraT67dp2VVqD4Cq7bIUCEEffyHBHoIgDrSB4Q7TMKGHn91GQzdKlwzLQfAhFAYyniHVBepQHhR9luVs/iPP+UZqPGmquJTq/lJzOVOCn6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3ZFceULi3fEFKfUt5WrDLtezCMiyrCH1UghAsPZOck=;
 b=hzMSrRafL+y1aHg3tkYKOwXo48+Rfw+jPh89B0hyV7kjqGUspLUNY8FH3KEZf9FJ9WMWotbfAg4ZAdpGbLPiSyoAbQrfJpR8764w8cMEdo55haXDkUIH3sdE2f2dvNuRu1PPEGHRfCOJnL+MG5SSDRzYqBJidiOJS3J2KjhSW6PxROLj8wKovF9jCzuuflPHdO8R46KMeRZ1r4PFYYCAanXG/H7qDNHywqQsNx0zxWmeT4UeWrzV9sha5iEoD+py5F6fwpp4QwMMTZoX/OMAqFsh7Kmj3xllhuA1XBtAGwWRnPRFiWK5FKR/QDPTEMeXy5JyvMwOkTvvzx38HJpgeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3ZFceULi3fEFKfUt5WrDLtezCMiyrCH1UghAsPZOck=;
 b=eJ8XdRpONpfgpI3C9RmpUL/PRSfPfMZbzk1eHfTGFGSdZgvprOg+LqwjPp41ZLjouFJkEiSgNl94SB8Phtag46rmaxrO3lk9U15HZLRB89N1DSGsLH7z6bc+KlZBML3h8k8PHE+58UWfMotY3BgFtQRqGykF9BbvILmkSs7gHoI=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB2978.namprd12.prod.outlook.com (2603:10b6:408:42::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:08:11 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 12:08:11 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "Winkler, Tomas" <tomas.winkler@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/5] scsi: ufs: tc-dwc-pci: Use PDI ID to match Test Chip
 type
Thread-Topic: [PATCH 3/5] scsi: ufs: tc-dwc-pci: Use PDI ID to match Test Chip
 type
Thread-Index: AQHWGizL85eiXEn8NkKQ2LMZaAyhmKiIK5CAgAAAxWA=
Date:   Fri, 24 Apr 2020 12:08:11 +0000
Message-ID: <BN8PR12MB32662BD6478A0FCF0F29353AD3D00@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
 <8427c06b92bae656ab3ef75c7edc980900cdf075.1587727756.git.Jose.Abreu@synopsys.com>
 <a0656591acea47e2b6765d2411f0a362@intel.com>
In-Reply-To: <a0656591acea47e2b6765d2411f0a362@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 971e6b69-78f9-4264-74ef-08d7e84828d3
x-ms-traffictypediagnostic: BN8PR12MB2978:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB2978B2E800EE79D1F68AD788D3D00@BN8PR12MB2978.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(39860400002)(376002)(346002)(136003)(66556008)(66476007)(26005)(66446008)(478600001)(76116006)(6506007)(110136005)(52536014)(9686003)(54906003)(55016002)(316002)(5660300002)(7696005)(86362001)(64756008)(33656002)(66946007)(2906002)(71200400001)(186003)(8936002)(8676002)(4326008)(81156014);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BRHd8CGeml4uXHo8xOXA+mg+N9n332uflCvXJJtJZJuXNpByAGWiEa3WPwbzygYD8F7JOn1sn05Gua/2f19eQyHOTtD7qYg1ZSGx0F7zh10GsFHTZpQqd480lO8P6dgk5H6skbd8yrnQcws3SbDpcb2iaEA0dKiJNCufNFtyg3PstN71f/exRC6kz+Pwg1TqvY6tpsr3wHfQw0hgmRppvNxf320xtL8emgkWjpy7CubxkeS1ZgEoFpZCk8IBcPtJ+OyaDVIYfiHSRnOvx0AVxIcXVY/GuMJigdIDG2fHTQORsfX+nwV11QIIldbnOyB6ILk1PjyLRvSvnJu19qKg8memK5PY7fRNYFD4FJgBu/GG2fJimIl3N40lhzn0WyfjrMUOQqlKP7qyUSo/E5epCdz0GX9fSx2+95g0qdvdMHruxmPgVxm4qzz7lNg9WEcn
x-ms-exchange-antispam-messagedata: 34gr5chxkX/OJ1xCyNUldqNtKXAQrjUv5zA51lwvSrGrvRXPUIx79wtn6gxYrpkTvbkIzkiezyiqjtXaDVql/A+HboLszs54b7mH1LdvtP08RPbZWfJ2kMEUbRNPaNR+xHg01lTn+/X1Mxl9lCV/OQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 971e6b69-78f9-4264-74ef-08d7e84828d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 12:08:11.4851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3frypppl85qKLuyWplI/bjuLzCoNF/OYSwx6AVVQF/lxCu2qi+uabWZ3IPsZi0yEMngp9/du4nY9pEmPaCOYWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2978
X-OriginatorOrg: synopsys.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Winkler, Tomas <tomas.winkler@intel.com>
Date: Apr/24/2020, 13:00:33 (UTC+00:00)

> >=20
> > In preparation for the addition of new Test Chips, we re-arrange the
> > initialization sequence so that we rely on PCI ID to match for given Te=
st Chip
> > type.
> >=20
> > Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> >=20
> > ---
> > Cc: Joao Lima <Joao.Lima@synopsys.com>
> > Cc: Jose Abreu <Jose.Abreu@synopsys.com>
> > Cc: Alim Akhtar <alim.akhtar@samsung.com>
> > Cc: Avri Altman <avri.altman@wdc.com>
> > Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > Cc: linux-scsi@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/scsi/ufs/tc-dwc-pci.c | 68 ++++++++++++++++++++++++++++-------=
----
> > ----
> >  1 file changed, 44 insertions(+), 24 deletions(-)
> >=20
> > diff --git a/drivers/scsi/ufs/tc-dwc-pci.c b/drivers/scsi/ufs/tc-dwc-pc=
i.c index
> > aeb11f7f0c91..74a2d80d32bd 100644
> > --- a/drivers/scsi/ufs/tc-dwc-pci.c
> > +++ b/drivers/scsi/ufs/tc-dwc-pci.c
> > @@ -14,6 +14,11 @@
> >  #include <linux/pci.h>
> >  #include <linux/pm_runtime.h>
> >=20
> > +struct tc_dwc_data {
> > +	struct ufs_hba_variant_ops ops;
> > +	int (*setup)(struct pci_dev *pdev, struct tc_dwc_data *data); };
> > +
> >  /* Test Chip type expected values */
> >  #define TC_G210_20BIT 20
> >  #define TC_G210_40BIT 40
> > @@ -23,6 +28,20 @@ static int tc_type =3D TC_G210_INV;
> > module_param(tc_type, int, 0);  MODULE_PARM_DESC(tc_type, "Test Chip
> > Type (20 =3D 20-bit, 40 =3D 40-bit)");
> >=20
> > +static int tc_dwc_g210_set_config(struct pci_dev *pdev, struct
> > +tc_dwc_data *data) {
> > +	if (tc_type =3D=3D TC_G210_20BIT) {
> > +		data->ops.phy_initialization =3D tc_dwc_g210_config_20_bit;
> > +	} else if (tc_type =3D=3D TC_G210_40BIT) {
> > +		data->ops.phy_initialization =3D tc_dwc_g210_config_40_bit;
> > +	} else {
> > +		dev_err(&pdev->dev, "test chip version not specified\n");
> > +		return -EPERM;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int tc_dwc_pci_suspend(struct device *dev)  {
> >  	return ufshcd_system_suspend(dev_get_drvdata(dev));
> > @@ -48,14 +67,6 @@ static int tc_dwc_pci_runtime_idle(struct device *de=
v)
> >  	return ufshcd_runtime_idle(dev_get_drvdata(dev));
> >  }
> >=20
> > -/*
> > - * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
> > - */
> > -static struct ufs_hba_variant_ops tc_dwc_pci_hba_vops =3D {
> > -	.name                   =3D "tc-dwc-pci",
> > -	.link_startup_notify	=3D ufshcd_dwc_link_startup_notify,
> > -};
> > -
> >  /**
> >   * tc_dwc_pci_shutdown - main function to put the controller in reset =
state
> >   * @pdev: pointer to PCI device handle
> > @@ -89,22 +100,11 @@ static void tc_dwc_pci_remove(struct pci_dev *pdev=
)
> > static int  tc_dwc_pci_probe(struct pci_dev *pdev, const struct pci_dev=
ice_id
> > *id)  {
> > -	struct ufs_hba *hba;
> > +	struct tc_dwc_data *data =3D (struct tc_dwc_data *)id->driver_data;
> >  	void __iomem *mmio_base;
> > +	struct ufs_hba *hba;
> >  	int err;
> >=20
> > -	/* Check Test Chip type and set the specific setup routine */
> > -	if (tc_type =3D=3D TC_G210_20BIT) {
> > -		tc_dwc_pci_hba_vops.phy_initialization =3D
> > -						tc_dwc_g210_config_20_bit;
> > -	} else if (tc_type =3D=3D TC_G210_40BIT) {
> > -		tc_dwc_pci_hba_vops.phy_initialization =3D
> > -						tc_dwc_g210_config_40_bit;
> > -	} else {
> > -		dev_err(&pdev->dev, "test chip version not specified\n");
> > -		return -EPERM;
> > -	}
> > -
> >  	err =3D pcim_enable_device(pdev);
> >  	if (err) {
> >  		dev_err(&pdev->dev, "pcim_enable_device failed\n"); @@ -
> > 127,7 +127,16 @@ tc_dwc_pci_probe(struct pci_dev *pdev, const struct
> > pci_device_id *id)
> >  		return err;
> >  	}
> >=20
> > -	hba->vops =3D &tc_dwc_pci_hba_vops;
> > +	/* Check Test Chip type and set the specific setup routine */
> > +	if (data && data->setup) {
> > +		err =3D data->setup(pdev, data);
> > +		if (err)
> > +			return err;
> > +	} else {
> > +		return -ENOENT;
> > +	}
> > +
> > +	hba->vops =3D &data->ops;
> >=20
> >  	err =3D ufshcd_init(hba, mmio_base, pdev->irq);
> >  	if (err) {
> > @@ -150,9 +159,20 @@ static const struct dev_pm_ops tc_dwc_pci_pm_ops
> > =3D {
> >  	.runtime_idle    =3D tc_dwc_pci_runtime_idle,
> >  };
> >=20
> > +static struct tc_dwc_data tc_dwc_g210_data =3D {
>=20
> Constify the struct, if possible.=20

Actually, I can't because I overwrite one of the ops callback in the=20
probe() depending on TC specified.

---
Thanks,
Jose Miguel Abreu
