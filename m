Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF855C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 02:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A227723A5D
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 02:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgLRCPt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 21:15:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48041 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732574AbgLRCPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 21:15:49 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201218021505epoutp01bc9410ecbcd8f3d3362359b2d18dd719~RrdzQfffM0653906539epoutp01T
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2020 02:15:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201218021505epoutp01bc9410ecbcd8f3d3362359b2d18dd719~RrdzQfffM0653906539epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608257705;
        bh=wx1FRvC7dUGiq44E8FDc2IOzuLyp1v9f10ohCHmmrT0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=k7nPBB5eAyzOLGFgCAVyeGwC20Ak6TsYA9Ttxc6YL6O+gg4Mfk07n4FTtzuNlWTcQ
         NeTlsqBHWQQpFJpIPEPx+8ct9plwXJNhy0U5528f28bCP0djSLJhcZ5SwSLORDUJpV
         pwuWx3NOc/h5VGH5Drd1WL6uq+NZf8Qia4xk1dxs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201218021504epcas2p3eb429b96d04121bf6ea90da34a572efe~RrdydDtVi1747117471epcas2p3r;
        Fri, 18 Dec 2020 02:15:04 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Cxsrk5TKwzMqYkq; Fri, 18 Dec
        2020 02:15:02 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-2b-5fdc10a6fe59
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.FD.05262.6A01CDF5; Fri, 18 Dec 2020 11:15:02 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: Subject: [PATCH v14 1/3] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <1608256903.10163.39.camel@mtkswgap22>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201218021502epcms2p2a66c2aa01b084edd3b06323812116c4d@epcms2p2>
Date:   Fri, 18 Dec 2020 11:15:02 +0900
X-CMS-MailID: 20201218021502epcms2p2a66c2aa01b084edd3b06323812116c4d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12TbUxTVxjHub2X20LS5VBhOwMVuDpH2YAWVnYYMJdhtk6mYVGzDNeVa3tD
        yUrb9FJ0miiLbCoCMpIBY4CCGzgG62AUCmgoLWL5wBKobsprMSJTx9v84KpD1zem2bff+Z/n
        PP/nec45PFwwQ4bz8jQFjF5DqykymOi2CSVxzWBKLuobF6KO6buByNnQTaJLX9q56I7rGols
        k0tcVLXiwtFfxuZAdMcqRK3OD9Hx80YS1Y0WcVDZGROJmq53c5Cjr45Ep383k6jlymMOmuwK
        Rt+bbmDoVHUbgZoa+4m3QqWOq5lSR3kZR9pbO82VVjRZMOlAfRtXWjwyQEhX5ycIaXlXKya9
        37lZesJympMVnK1OUzG0ktFHMRqFVpmnyU2nMvfIM+SSZJE4TpyCXqeiNHQ+k07teD8r7p08
        tbs5KqqQVhvcUhbNslTCm2l6raGAiVJp2YJ0itEp1TqxWBfP0vmsQZMbr9DmvyEWiRIl7sgc
        teryBQehM8Ycqqkvx4qwycgSLIgHwWuwc6KMLMGCeQJgxuB8W4d7wePxQQhcM2/wxGwAO+HX
        t6sCPSwAFDSO1XJ9ejycmGvDPEyCV2G1fdarh4K90NE4SHhy4uAbEl4eb8Z8ZnxYc2Ke8HEE
        7GkxefUgkAStT7r8egz8u7kM93EYvPHjInedl4fP+vOEwi9mRv0xIdDp6vfrL8Lh/hWOj49B
        09RDzFMEBKUYtPVOBPo2EuBvJzu8ZnywC5aUPvLqBHgJVg7e9xexA/7ptHiNcRAJexbrcM9Q
        cCCExr4ED0KwBQ5NEOttFXU84v6fcfAcPGlb+083N9zyl7YN/uQyciqwLbVPJ137jFftU69z
        GN6KPc/o2Pxchk3UJT17uZ2Y96HHvmvGahZX4q0Yh4dZMcjDqVD+PuekXMBX0p8dZvRaud6g
        ZlgrJnF3+RUeHqbQun+KpkAuliQmJ4tSJEiSnIioF/j7fiiXC0AuXcB8yjA6Rr9+jsMLCi/i
        FJrfLlNtNoNCQ3sAY1+QjZYeOMCkdlzMMP0asTC/vX0373Ga+Y9N5xyszPHxTILIcdBeeXMZ
        HzJvjMhePRpQpzi0Fj3bmZljXFamVm68Qq0yNSOj1fLvFpbCoqwJ3z44dW8sLvYswUQLhZ9c
        222zRHbJqyr23rsNcgd0AbKrSlHvrQxmsKlpp8U+7fq5x5C6P3r8yP6IJOfxUgVd/MS1re76
        GaBqaKzPXpIctNxN3XT0g10P+e/Zpy+VVGyN7jtysUX8YE/72MvbDw+/EgKmpmVzI+Ujs4m2
        3p5/mOILrswiU2tSzkcxnx/bqlYszVE1v9yUdZ0XxPS4huyr2hSZjSJYFS2OxfUs/S+9g3/5
        cQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306
References: <1608256903.10163.39.camel@mtkswgap22>
        <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
        <20201216024532epcms2p22b8aadbce9f0d2aae7915bdf22e2fe8f@epcms2p2>
        <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daejun,
> 
> On Wed, 2020-12-16 at 11:45 +0900, Daejun Park wrote:
> > This is a patch for the HPB initialization and adds HPB function calls to
> > UFS core driver.
> > 
> > NAND flash-based storage devices, including UFS, have mechanisms to
> > translate logical addresses of IO requests to the corresponding physical
> > addresses of the flash storage.
> > In UFS, Logical-address-to-Physical-address (L2P) map data, which is
> > required to identify the physical address for the requested IOs, can only
> > be partially stored in SRAM from NAND flash. Due to this partial loading,
> > accessing the flash address area where the L2P information for that address
> > is not loaded in the SRAM can result in serious performance degradation.
> > 
> > The basic concept of HPB is to cache L2P mapping entries in host system
> > memory so that both physical block address (PBA) and logical block address
> > (LBA) can be delivered in HPB read command.
> > The HPB READ command allows to read data faster than a read command in UFS
> > since it provides the physical address (HPB Entry) of the desired logical
> > block in addition to its logical address. The UFS device can access the
> > physical block in NAND directly without searching and uploading L2P mapping
> > table. This improves read performance because the NAND read operation for
> > uploading L2P mapping table is removed.
> > 
> > In HPB initialization, the host checks if the UFS device supports HPB
> > feature and retrieves related device capabilities. Then, some HPB
> > parameters are configured in the device.
> > 
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Reviewed-by: Can Guo <cang@codeaurora.org>
> > Acked-by: Avri Altman <Avri.Altman@wdc.com>
> > Tested-by: Bean Huo <beanhuo@micron.com>
> > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > ---
> >  Documentation/ABI/testing/sysfs-driver-ufs |  80 +++
> >  drivers/scsi/ufs/Kconfig                   |   9 +
> >  drivers/scsi/ufs/Makefile                  |   1 +
> >  drivers/scsi/ufs/ufs-sysfs.c               |  18 +
> >  drivers/scsi/ufs/ufs.h                     |  13 +
> >  drivers/scsi/ufs/ufshcd.c                  |  48 ++
> >  drivers/scsi/ufs/ufshcd.h                  |  23 +-
> >  drivers/scsi/ufs/ufshpb.c                  | 562 +++++++++++++++++++++
> >  drivers/scsi/ufs/ufshpb.h                  | 167 ++++++
> >  9 files changed, 920 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/scsi/ufs/ufshpb.c
> >  create mode 100644 drivers/scsi/ufs/ufshpb.h
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> > index d1a352194d2e..8b16a353392c 100644
> > --- a/Documentation/ABI/testing/sysfs-driver-ufs
> > +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> > @@ -1019,3 +1019,83 @@ Contact:	Asutosh Das <asutoshd@codeaurora.org>
> >  Description:	This entry shows the configured size of WriteBooster buffer.
> >  		0400h corresponds to 4GB.
> >  		The file is read only.
> > +
> > +What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/hpb_version
> > +Date:		December 2020
> > +Contact:	Daejun Park <daejun7.park@samsung.com>
> > +Description:	This entry shows the HPB specification version.
> > +		The full information about the descriptor could be found at UFS
> > +		HPB (Host Performance Booster) Extension specifications.
> > +		Example: version 1.2.3 = 0123h
> > +		The file is read only.
> > +
> > +What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/hpb_control
> > +Date:		December 2020
> > +Contact:	Daejun Park <daejun7.park@samsung.com>
> > +Description:	This entry shows an indication of the HPB control mode.
> > +		00h: Host control mode
> > +		01h: Device control mode
> > +		The file is read only.
> > +
> > +What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/hpb_region_size
> > +Date:		December 2020
> > +Contact:	Daejun Park <daejun7.park@samsung.com>
> > +Description:	This entry shows the bHPBRegionSize which can be calculated
> > +		as in the following (in bytes):
> > +		HPB Region size = 512B * 2^bHPBRegionSize
> > +		The file is read only.
> > +
> > +What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/hpb_number_lu
> > +Date:		December 2020
> > +Contact:	Daejun Park <daejun7.park@samsung.com>
> > +Description:	This entry shows the maximum number of HPB LU supported	by
> > +		the device.
> > +		00h: HPB is not supported by the device.
> > +		01h ~ 20h: Maximum number of HPB LU supported by the device
> > +		The file is read only.
> > +
> > +What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/hpb_number_lu
> > +Date:		December 2020
> > +Contact:	Daejun Park <daejun7.park@samsung.com>
> > +Description:	This entry shows the maximum number of HPB LU supported	by
> > +		the device.
> > +		00h: HPB is not supported by the device.
> > +		01h ~ 20h: Maximum number of HPB LU supported by the device
> > +		The file is read only.
> 
> Please remove above duplicated item.
> 
> Thanks,
> Stanley Chu

OK, I will remove them.

Thanks,
Daejun
