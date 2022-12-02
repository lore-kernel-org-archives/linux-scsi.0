Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E829C636F8
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 20:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiLBUv5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiLBUvq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 15:51:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC20FF1
        for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2022 12:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670014186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lmJqjycXnIm3mfXptIlpVA/MYamH6IUZDJJdpxDnvuY=;
        b=furHu/+5S4wDOlm9o41tC646Ow2GfW0MleghzH3CkvH3K3QD0IFjsa621Ew0fwzsL/6bMS
        qsogmDm359w7chz54TG6VdqPUfM/gD9RQJjsc22ydFX2/Qb/oaI5c/AYNEpaAOxb2QA+fb
        QF0M9z/OKc7sDy0Hq1aOdL4BNLomu9Q=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-588-ZRDih1UMN_ieyF2QcpP6gw-1; Fri, 02 Dec 2022 15:49:45 -0500
X-MC-Unique: ZRDih1UMN_ieyF2QcpP6gw-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-144236f3debso2327811fac.18
        for <linux-scsi@vger.kernel.org>; Fri, 02 Dec 2022 12:49:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmJqjycXnIm3mfXptIlpVA/MYamH6IUZDJJdpxDnvuY=;
        b=X8RraepTKJAGtwOGRoSgylDwl6s0aFQO/pgwXH2zJ4TZ98SjNcEo2RXufIinhVEN0m
         Tch1juTGLrYXQ4G81qAIkrGR9BvRWQy+FcoZa/gXrjh+tFyfGg8hQLFmUn3h8jZr4NmM
         kRxexjGsvi5vaeASZ6SUiEQzga9oXV9tdAsf8tg5I6TGLovkvvBaqQgBGl4lLTH5p47G
         F/DePRYAKErA2alZeBmVZJuC0KHxIIc6HC3bxVaTN6qj1d9gTLkbi0KtzAa5K1Yn2z5y
         y2LBKyRRvx6HIvd1rnEcsADvRF8KIPrqUbFqB+HLsuelug45GOvv3197+7i6KO+QWO6F
         hkpQ==
X-Gm-Message-State: ANoB5pl9Jf5/41p0g/Rrq/aXXbcUQDs7axS6Px+ciK+1z+fHbW3iPPk7
        5ZKsMu4L3E3iwmzDYmd151Kvg8mT3HZ++t8am8HiE8yrM0Qi/v1wHrUzDTWovIc24rxV2Tdy2YD
        zax7Vg20xxkzAmqPKeX981A==
X-Received: by 2002:a54:4714:0:b0:35a:7a65:5b76 with SMTP id k20-20020a544714000000b0035a7a655b76mr26774389oik.108.1670014184129;
        Fri, 02 Dec 2022 12:49:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6noLIf8pat9k4yYYZCWskVIULw37YazTQF+DxXXYYiq1qokYwFtLvCMg92rUjW390wZnssIw==
X-Received: by 2002:a54:4714:0:b0:35a:7a65:5b76 with SMTP id k20-20020a544714000000b0035a7a655b76mr26774375oik.108.1670014183872;
        Fri, 02 Dec 2022 12:49:43 -0800 (PST)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::41])
        by smtp.gmail.com with ESMTPSA id fo12-20020a0568709a0c00b001431bf4e5a0sm4724774oab.38.2022.12.02.12.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 12:49:43 -0800 (PST)
Date:   Fri, 2 Dec 2022 14:49:40 -0600
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org, quic_cang@quicinc.com,
        quic_asutoshd@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, dmitry.baryshkov@linaro.org,
        abel.vesa@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org
Subject: Re: [PATCH v4 00/23] ufs: qcom: Add HS-G4 support
Message-ID: <20221202204940.ojk5e43mu3lbmr2r@halaney-x13s>
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 01, 2022 at 11:13:05PM +0530, Manivannan Sadhasivam wrote:
> Hello,
>
> This series adds HS-G4 support to the Qcom UFS driver and PHY driver.
> The newer Qcom platforms support configuring the UFS controller and PHY
> in dual gears (i.e., controller/PHY can be configured to run in two gear
> speeds). This is accomplished by adding two different PHY init sequences
> to the PHY driver and the UFS driver requesting the one that's required
> based on the platform configuration.
>
> Initially the ufs-qcom driver will use the default gear G2 for enumerating
> the UFS device. Afer enumeration, the max gear supported by both the
> controller and device would be found out and that will be used thereafter.
> But for using the max gear after enumeration, the ufs-qcom driver requires
> the UFS device to be reinitialized. For this purpose, a separate quirk has
> been introduced in the UFS core along with a callback and those will be used
> by the ufs-qcom driver.
>
> This series has been tested on following platforms:
>
> * Qcom RB5 development platform powered by SM8250 SoC
> * SM8450 based dev board
>
> Merging Strategy:
> -----------------
>
> The PHY patches are expected to go through PHY tree and UFS, MAINTAINERS
> patches are expected to go through SCSI tree.
>
> NOTE: Since this series targets multiple SoCs (base like SM8350) and
> (derivative like SC8280XP), testing on all of these platforms is really
> appreciated. Although, if the series works for base SoC, then for derivatives
> also it should work.

Tested-by: Andrew Halaney <ahalaney@redhat.com> # Qdrive3/sa8540p-ride

Without this patch series, the board's operating in gear 3. With it the
board's operating in gear 4. Gentle reminder sa8540p-ride is a SC8280XP
derivative.

I'm not really proficient in storage benchmarking, but a simple dd test
showed the following (sorry for the poor output, console got a
little wacky on the output).

Gear 3:
    [root@localhost ~]# dd bs=4k oflag=direct if=/dev/zero of=/dev/disk/by-partlabel/userdata
    dd: error writing '/dev/disk/by-partlabel/userdata': No space left on device
    19873276+0 records in
    19873275+0 records out
    81400934400 bytes (81 GB, 76 GiB) copied, 864.111 s, 94.2 MB/s
    [root@localhost ~]# dd bs=4k if=/dev/disk/by-partlabel/userdata of=/dev/null
    19873275+0 records in
    19873275+0 records out
    81400934400 bytes (81 GB, 76 GiB) copied, 75.7823 s, 1.1 GB/s
    [root@localhost ~]#

Gear 4:
    [root@localhost ~]# dd bs=4k oflag=direct if=/dev/zero of=/dev/disk/by-partlabel/userdata
    [   81.651598] ufshcd-qcom 1d84000.ufs: ufs_qcom_get_hs_gear: 296: UFS_HS_G4
    [   81.658592] ufshcd-qcom 1d84000.ufs: ufs_qcom_pwr_change_notify: 731: Agreed gear: 4
    [root@localhost ~]#  GB, 76 GiB) copied, 738.015 s, 110 MB/s
    [root@localhost ~]# dd bs=4k if=/dev/disk/by-partlabel/userdata of=/dev/null
    19873275+0 records in
    19873275+0 records out
    81400934400 bytes (81 GB, 76 GiB) copied, 63.9846 s, 1.3 GB/s
    [root@localhost ~]#

So a bit of a performance gain was seen with this patch series :)

Thanks,
Andrew

>
> Thanks,
> Mani
>
> Changes in v4:
>
> * Dropped HS G3 specific setting from SM8350 default init sequence
> * Added G4 support to SM8350 and SC8280XP
> * Covered all qcom files under drivers/ufs/host in MAINTAINERS file
> * Added missing Suggested-by tags for Can Guo
> * Rebased on top of linux-next 20221201
>
> Changes in v3:
>
> * Dropped the "device-max-gear" DT property and switched to reinitialization (Krzysztof)
> * Added HS-G4 support to all compatible SoCs (SM8150, SM8250 and SM8450). This will also
>   benefit the derivative SoCs of these platforms like SC8180x, SC8280x etc...
> * Splitted the qmp_phy_init_tbl changes into separate patches (Vinod)
> * Collected reviews from Andrew H
>
> Changes in v2:
>
> * Collected reviews from Dmitry
> * Renamed "max-gear" property to "max-device-gear"
> * Used min() for deciding which gear to use instead of open comparision
> * Added comment about the old register name
>
> Manivannan Sadhasivam (23):
>   phy: qcom-qmp-ufs: Remove _tbl suffix from qmp_phy_init_tbl
>     definitions
>   phy: qcom-qmp-ufs: Rename MSM8996 PHY definitions
>   phy: qcom-qmp-ufs: Move register settings to qmp_phy_cfg_tbls struct
>   phy: qcom-qmp-ufs: Add support for configuring PHY in HS Series B mode
>   phy: qcom-qmp-ufs: Add support for configuring PHY in HS G4 mode
>   phy: qcom-qmp-ufs: Move HS Rate B register setting to tbls_hs_b
>   phy: qcom-qmp-ufs: Add HS G4 mode support to SM8150 SoC
>   phy: qcom-qmp-ufs: Add HS G4 mode support to SM8250 SoC
>   phy: qcom-qmp-ufs: Avoid setting HS G3 specific registers
>   phy: qcom-qmp-ufs: Add HS G4 mode support to SM8350 SoC
>   phy: qcom-qmp-ufs: Add HS G4 mode support to SM8450 SoC
>   phy: qcom-qmp-ufs: Add HS G4 mode support to SC8280XP SoC
>   scsi: ufs: ufs-qcom: Remove un-necessary goto statements
>   scsi: ufs: ufs-qcom: Remove un-necessary WARN_ON()
>   scsi: ufs: ufs-qcom: Use bitfields where appropriate
>   scsi: ufs: ufs-qcom: Use dev_err_probe() for printing probe error
>   scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0
>   scsi: ufs: core: Add reinit_notify() callback
>   scsi: ufs: core: Add support for reinitializing the UFS device
>   scsi: ufs: ufs-qcom: Factor out the logic finding the HS Gear
>   scsi: ufs: ufs-qcom: Add support for reinitializing the UFS device
>   scsi: ufs: ufs-qcom: Add support for finding max gear on new platforms
>   MAINTAINERS: Add myself as the maintainer for Qcom UFS drivers
>
>  MAINTAINERS                                   |   8 +
>  .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v5.h    |   1 +
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 454 +++++++++++++-----
>  drivers/ufs/core/ufshcd-priv.h                |   6 +
>  drivers/ufs/core/ufshcd.c                     |  63 ++-
>  drivers/ufs/host/ufs-qcom.c                   | 170 +++----
>  drivers/ufs/host/ufs-qcom.h                   |  70 +--
>  include/ufs/ufshcd.h                          |   8 +
>  8 files changed, 532 insertions(+), 248 deletions(-)
>
> --
> 2.25.1
>

