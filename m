Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE884C54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8888C20736
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="SPsdmaTQ";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="FUYXGW/j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgDXMC7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:02:59 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:42402 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726289AbgDXMC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 08:02:59 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4465440409;
        Fri, 24 Apr 2020 12:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587729778; bh=YZTSLrq/PcXCbmRZ0KpkQqv8RCyn0Qwc22iyOjYFDCw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=SPsdmaTQ61Oi8ImgsBNb27xwNDIp0IoV+onFwnaWV09Dxja8kwlZhKRwU0Tx26HLE
         fuUMOdmavO6F8s+ojKcW/0I4tqXcD63JKQGLjdjHcafIGpnJ0w6wWTTeMW2qvDrzmg
         0czsnaTXiPuo77D3vRmLkZO4oIWFK3iHTRPLDV6SgQIgkgxDFUQDoMOqjmxsUKxIIW
         YGsqovMtRjsxbvRAeb1Xto3KsXMXOv4HFmjZowJjVzF36PkquyS5MKqszZCM5uyEAn
         ClI+n+XIyCW/Wn8Fv1A8q7Dt2UH1cZppxza2bVm3hc0FWsTcGhYymclXAz/7wza5+g
         wS258zUwT78RQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 98C07A0067;
        Fri, 24 Apr 2020 12:02:48 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 24 Apr 2020 05:02:14 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 24 Apr 2020 05:02:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lk9fYGgS2CDu0j/ppD4cNVDAHryaLsYQigqdUjPYDR633gs9VKq/XduYWseJj5G1Q1oLoRnoQFNXk0UJ5+uav5TqVdzZ+ggcmTSVs6oiaTVRjsoIOiVj5Gq/vGa/1libXEM8QHCRZ7wgN78NzLcXLP3w7eFtgjetTV5NypTQACHjSw20UK8+0WQfLCIF1c91aIfjBkbt5kk/jo6Sc4lqLIIGj7Jc8FoVX9vZyIxO9wPu0pHlmt+0YpsJZaYFvywuTOO/cyhDlLYPLxb74aIXZFcjDSISkYVqEOOF99YvMu7s8ojQR1sRLfBsXeXgAGYrr5hjVpbDI9WVMXtGeKUjdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUfEINpY3GPWtAO7w4Rtg0ntnqYE357ydip7Hu9tykg=;
 b=oRdxeY++zrKV07m5j2JjCSKZVcQ9wnh8V6L/4yoaKC/Y358gLYksPwbPTCtMEaoVWyZNeqeF6poMYFCSsraRPHR3BNbXf94uspdrmF61xddf8HmYGQp16jIIazS/oSztK7mEUiRsvoLasM4ESgdHLJ7jajXZOqHDM4aAH46ydF6DhWucYdYqAauSECFL/90NMNFMNOKi+pl2gaNuUzN7h4+pa9RAUFGEIXf0beo/4CRPU5RpBDhn5f29N31oZJnzHc+aCWpm2D7WdiM8w1dD0zlCiDhOF3JxoJBSj0MvWw0AOVtyjeNoP+KsTUdamNWpfSK91IjQ+Km1LWqk/Mufbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUfEINpY3GPWtAO7w4Rtg0ntnqYE357ydip7Hu9tykg=;
 b=FUYXGW/jccFFO7adYrV+s0s0mEWwKjemJz+7hX7S5Mv9hDgFHJQMDOlekVmGxRo4MHHZSVoT2Q0zwwJRbG4EaxPpetBK2w9QlOcQ1VMKQPBzftVOEtiIShdkGMgQ4tWZ5er9dzJgDX162DCGHOVUCX3QzGnrOBGMxxHpYlutTA8=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3620.namprd12.prod.outlook.com (2603:10b6:408:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:02:12 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 12:02:12 +0000
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
Subject: RE: [PATCH 4/5] scsi: ufs: tc-dwc-pci: Allow for MSI interrupt type
Thread-Topic: [PATCH 4/5] scsi: ufs: tc-dwc-pci: Allow for MSI interrupt type
Thread-Index: AQHWGizLweIWC0leREOPucyddXRWn6iIKkeAgAAAomA=
Date:   Fri, 24 Apr 2020 12:02:12 +0000
Message-ID: <BN8PR12MB326683F270F887D309490462D3D00@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
 <9b5c2d47997629c55ac14ce594771e9e8f254c74.1587727756.git.Jose.Abreu@synopsys.com>
 <a8a9d40b0bef460c8e593e0add88094d@intel.com>
In-Reply-To: <a8a9d40b0bef460c8e593e0add88094d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71bdfd06-91e9-4556-d003-08d7e84752c4
x-ms-traffictypediagnostic: BN8PR12MB3620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB36204A637AE8A9F78C13FA89D3D00@BN8PR12MB3620.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(346002)(39860400002)(396003)(366004)(316002)(66946007)(76116006)(8676002)(64756008)(66556008)(66476007)(478600001)(52536014)(186003)(81156014)(8936002)(2906002)(66446008)(86362001)(7696005)(71200400001)(6506007)(110136005)(5660300002)(33656002)(26005)(9686003)(54906003)(4326008)(55016002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zqohiYyiG2vzQ57nWrLi/gGIKhmcD3yjP5JI0q4RMKPPxT7/K/YQcLGdkJEVsALEf3Yv4Z2hg9Rr51nam6+VZIufyT9QjdQIJJ3lWoH+J+dhL8XoJeFbxNuXjtoLJYil7aar4tl+PWT5HWJE9+MbZJiIiXmO3UUmXRP3Q7kYusZOob1XLioh/WDjHXBuQxWk9btgFprUZ0H+xZgzwybbjFZqqfjc5+RbtqrfQSGkCFxS6BXrpPlWCeWvQr4qug5VGr24SdKxnXcNO8BMXsWD3/zYO11BP+JC6REe32yIpdrvM54zgGPBXQ4bMH2KI9US9zNQjrOVksHGTtPz132j6ejt33Vi3OOGo1cRLrnJlIolfyXwJp2QbaRsc92W7FwwBA98DbdI7wHflOpJrpqTr4M2XQoRO56r3WKHhyJ3A+b8YW2D2ogS8zcJ0fY5axLe
x-ms-exchange-antispam-messagedata: udfokRABUuhe/pSY2CH9jYkuUYnsS94DvKMPzYSZgTZJKTp2xgDW23cmbRtjp/Jy4bFu2jC6+XwH320s84z4t+hWf+LcZF6vaAE6PQNxS3iyK7GlxYE072bLrF6Q8cEG+OGlnxGFLbyZM2q3pJrHEQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 71bdfd06-91e9-4556-d003-08d7e84752c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 12:02:12.3797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 12HSJ212Ds2gAtjlcSxFfd5Lkrb7ylp9CwQ8nvVTJ74XWBC/mEslC92wUD6vZ7G75ewiDqjpS9OMNr/9rd0qhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3620
X-OriginatorOrg: synopsys.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Winkler, Tomas <tomas.winkler@intel.com>
Date: Apr/24/2020, 12:55:57 (UTC+00:00)

> >=20
> > Newer Test Chips boards have MSI support. It does no harm to try to req=
uest it
> > as the function will fallback to legacy interrupts if MSI is not suppor=
ted.
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
> >  drivers/scsi/ufs/tc-dwc-pci.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/scsi/ufs/tc-dwc-pci.c b/drivers/scsi/ufs/tc-dwc-pc=
i.c index
> > 74a2d80d32bd..e0a880cbbe68 100644
> > --- a/drivers/scsi/ufs/tc-dwc-pci.c
> > +++ b/drivers/scsi/ufs/tc-dwc-pci.c
> > @@ -136,9 +136,15 @@ tc_dwc_pci_probe(struct pci_dev *pdev, const struc=
t
> > pci_device_id *id)
> >  		return -ENOENT;
> >  	}
> >=20
> > +	err =3D pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
> PCI_IRQ_LEGACY | PCI_IRQ_MSI , is enough  you don't have MSIX

Makes sense :)

> > +	if (err < 0) {
> > +		dev_err(&pdev->dev, "Allocation failed\n");
> > +		return err;
> > +	}
> > +
> Where do you call pci_free_irq_vectors() ?=20

Right ... Will be fixed in v2. Thanks!

---
Thanks,
Jose Miguel Abreu
