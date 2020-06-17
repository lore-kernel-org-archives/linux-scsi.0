Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED2EC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 10:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A02FB208B8
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 10:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RDT6t/Gv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFQKNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 06:13:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15685 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFQKNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 06:13:05 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200617101302epoutp0463ecc9ad2fcc7e63dc80d75cbe1b06a0~ZTSkjMWKL2997129971epoutp04B
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 10:13:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200617101302epoutp0463ecc9ad2fcc7e63dc80d75cbe1b06a0~ZTSkjMWKL2997129971epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592388782;
        bh=V7Pmg8P23tSg6zHCQM++ZngYdQm25qEhVAfLSM6EzEg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=RDT6t/Gvuw/HuH+5T6OQH1Ame1TlSBkHdguRV2p5DeRVIWNOIIjJDhS+XYgNRF1kT
         LXETGrheI+oRPRUVC68DDF0RL9rALgVLfJEXsiNB8sN6Dxppp2PjEx9jWEhns6U+P7
         N2ZijzUoZLn1lv+Oox5F7I5U+JFUwBVJcnhQxgfE=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200617101301epcas1p387e3954fd36343176ec3e70dd70a8d45~ZTSkHiDTE1159011590epcas1p3_;
        Wed, 17 Jun 2020 10:13:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <SN6PR04MB46402D067BE2BFE003170FB8FC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01592388781837.JavaMail.epsvc@epcpadp2>
Date:   Wed, 17 Jun 2020 19:09:56 +0900
X-CMS-MailID: 20200617100956epcms2p85d3c46ecb34bebe8c7d6c1c2b3e05589
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <SN6PR04MB46402D067BE2BFE003170FB8FC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p8>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > This patch is adding UFS feature layer to UFS core driver.
> >=20
> > UFS Driver data structure (struct ufs_hba)
> >         =E2=94=82
> > =E2=94=8C--------------=E2=94=90
> > =E2=94=82 UFS feature  =E2=94=82 <-- HPB module
> > =E2=94=82    layer     =E2=94=82 <-- other extended feature module
> > =E2=94=94--------------=E2=94=98
> > Each extended UFS-Feature module has a bus of ufs-ext feature type.
> > The UFS feature layer manages common APIs used by each extended feature
> > module. The APIs are set of UFS Query requests and UFS Vendor commands
> > related to each extended feature module.
> >=20
> > Other extended features can also be implemented using the proposed APIs=
.
> > For example, in Write Booster, "prep_fn" can be used to guarantee the
> > lifetime of UFS by updating the amount of write IO.
> > And reset/reset_host/suspend/resume can be used to manage the kernel ta=
sk
> > for checking lifetime of UFS.
> >=20
> > The following 6 callback functions have been added to "ufshcd.c".
> > prep_fn: called after construct upiu structure
> > reset: called after proving hba
> > reset_host: called before ufshcd_host_reset_and_restore
> > suspend: called before ufshcd_suspend
> > resume: called after ufshcd_resume
> > rsp_upiu: called in ufshcd_transfer_rsp_status with SAM_STAT_GOOD state
> >=20
> > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > ---
> >  drivers/scsi/ufs/Makefile     |   2 +-
> >  drivers/scsi/ufs/ufsfeature.c | 148 ++++++++++++++++++++++++++++++++++
> >  drivers/scsi/ufs/ufsfeature.h |  69 ++++++++++++++++
> >  drivers/scsi/ufs/ufshcd.c     |  17 ++++
> >  drivers/scsi/ufs/ufshcd.h     |   3 +
> >  5 files changed, 238 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/scsi/ufs/ufsfeature.c
> >  create mode 100644 drivers/scsi/ufs/ufsfeature.h
> >=20
> > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> > index 94c6c5d7334b..fe3a92b06c87 100644
> > --- a/drivers/scsi/ufs/Makefile
> > +++ b/drivers/scsi/ufs/Makefile
> > @@ -5,7 +5,7 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-
> > g210-pltfrm.o ufshcd-dwc.o tc-d
> >  obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
> >  obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
> >  obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
> > -ufshcd-core-y                          +=3D ufshcd.o ufs-sysfs.o
> > +ufshcd-core-y                          +=3D ufshcd.o ufs-sysfs.o ufsfe=
ature.o
> How about making it
> >  ufshcd-core-$(CONFIG_UFS_FEATURES)     +=3D ufsfeature.o
> So that you won't check none-hpb driver on every response etc.

It's not a big problem because it only needs a simple checking.
In addition, I think that it is not necessary to separate them because the =
UFS feature is enabled in most of the user cases.

Thanks,
Daejun
