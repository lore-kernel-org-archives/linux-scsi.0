Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A23C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA3A661163
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240687AbhJGIOo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43209 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240649AbhJGIOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:14 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211007081218epoutp011d18ca9fff6f6265b7b90c9c8804ade1~rsWVoJJlh1645416454epoutp01W
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211007081218epoutp011d18ca9fff6f6265b7b90c9c8804ade1~rsWVoJJlh1645416454epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594338;
        bh=VsFD0Ei7GiaGOGFOGxs6Ulu5UvY/QlgMVDzrjrMJKSU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=tFftpVWGtHpdINUcTmWf5SNX8l2vF6z+rJtiC3VLZtZIY7Qq/B5idqURkBgym9jZ4
         /1Q3yEW9x4sHzlEOnqop/TuCtfG0P2sR1UzURwCC3dLyXrqAmM2IULCtDxC+Jfc3Tf
         gA+ue4UdjUxJ8mF4CJFyENUxozp0cxltEEuqcezg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211007081205epcas2p27578ad1382e07584d086bb71a859d402~rsWI8K7ky3113331133epcas2p2z;
        Thu,  7 Oct 2021 08:12:05 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.97]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HQ3vG3xZLz4x9Q2; Thu,  7 Oct
        2021 08:11:54 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.18.09472.4CBAE516; Thu,  7 Oct 2021 17:11:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211007081133epcas2p31f973709609d82dbbc76bd7b51232cb2~rsVriJgSl1907519075epcas2p3q;
        Thu,  7 Oct 2021 08:11:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211007081133epsmtrp132454e4420d210217c20e61ee1fd2360~rsVrhMWUo2164721647epsmtrp1e;
        Thu,  7 Oct 2021 08:11:33 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-e7-615eabc4285c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.A7.08750.5BBAE516; Thu,  7 Oct 2021 17:11:33 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081133epsmtip2318694ee4194b9da0247d5a5e3cf9edc~rsVrSdnOQ0802008020epsmtip2-;
        Thu,  7 Oct 2021 08:11:33 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v4 00/16] introduce exynosauto v9 ufs driver
Date:   Thu,  7 Oct 2021 17:09:18 +0900
Message-Id: <20211007080934.108804-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwbdRj2d1euB1g9uk1/wTiacxsZBmihhZuBoYzoGTCSsbiFjLETTiC0
        vaYfxm3GsDg6SgeyTcdWnN2K+yrMutLxJUplzcYCbplFZfAH33GFsA8IYgHB0mO6/573eZ8n
        z/v+PnBU7MUi8RK1ntWqGSWJhQmab2xVxHoa9jHS3gs4dXu8EaOGv2nGKJ//N4z6ecQkoE49
        9qPUjONiCOXtfJ061raD6qmxIdS4w4JStv5mhOpfMIZQ16b/RqjTd39CKPMfrRh16dYyQi36
        u5A3I2hvXyZtKavCaG91FUI3XY6h6zt8CO20mzC6xuYG9LyjAqOfTAwI6GqXHdCzzo30UbcZ
        yX4+tzSlmGUKWa2EVRdwhSXqolQyMyd/R74iSSqLlW2jkkmJmlGxqWRGVnbs2yXKwF6k5GNG
        aQhQ2YxOR8ZvT9FyBj0rKeZ0+lSS1RQqNcmaOB2j0hnURXFqVv+GTCpNUASE+0uLKx94hJo7
        0Z9Y206hZaA8qhKE4pCQw++WhoSVIAwXE60AOj0+hC9mAKyvOIfxxSyA1dWXkKeW+rlGlG+0
        A2gxGteKJwCODZ0VrqowIha6/pwEq431xCMAx8e+DKaghBuFY23+kFXVOiIF9i7XC1axgNgM
        56yng1hEpMEWWxPg86KgZ8GE8nwEvH1mPKhBA/zn1+uC0ZDw4PDqqF3AGzJg+8rvITxeBydv
        uYQ8joS+L4xC3mAGsHx0Za3RAKDpcBaP0+BCrStgxgMJW6GjPX4VQuI16BlYy30BVtz4R8jT
        IlhhFPPGaOhuqV2b4FVo/np2bQIarlhvBnkxkQevL/0QUgOiLM9sY3lmG8v/uecAagcvsRqd
        qojVJWjk/91rAadyguDrjqFbQd3047gugOCgC0AcJdeLuLQ8RiwqZA4cZLVcvtagZHVdQBE4
        3+No5IYCLvA91Pp8mXybVJ6UJEtOUEiTyZdFZ5fTGTFRxOjZUpbVsNqnPgQPjSxD0L6shl/L
        o6tOJBVPhTVKc5YHP2oe/j7PWTuRU3Qv/3xihrA5/BXDxQOxvp6B0fO7B+8c609Xn+iyzt9X
        yEZ6pKbeh8kl3Ry1x71JuTNC+uHsLlQypnp0tfxHzd4rhyxWscP+gWhfrn/x/mf9CqfL1bTp
        nXBq52SHjXQvDb/H9rwomt+VviWKw/ae3JhDqxhrYYc11JByfHv4luhv94/8MpV6swYbfDdn
        1nX5gpD+9CsuYvdD9ebEKXldS0rJjPfImb75ic7yBHef0bfCHXFs8L5/OFumyux+zkEfjcGv
        PEjstt+Vo3NvmbOH9kweMpG18Z3XDlbOTPzVsZh7L2OaRkmBrpiRxaBaHfMv5z1xkmYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LZdlhJXnfr6rhEg6UPlC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8WNX22sFhvf
        /mCymHF+H5NF9/UdbBbLj/9jsvj98xCTg6DH5SveHrMaetk8Lvf1MnlsXqHlsXjPSyaPTas6
        2TwmLDrA6PF9fQebx8ent1g8+rasYvT4vEnOo/1AN1MATxSXTUpqTmZZapG+XQJXRteLI+wF
        59Qr5u+cxtzA2CrfxcjJISFgIrH46xrmLkYuDiGBHYwS26evZIZIyEo8e7eDHcIWlrjfcoQV
        oug9o8TKmztZQBJsAroSW56/YgSxRQQ+MkrM+aYFUsQscIpZYu26TWBFwgI2Emf+LQazWQRU
        Jb7OnwFm8wrYS2xftJkRYoO8xJFfncwQcUGJkzOfgNUwA8Wbt85mnsDINwtJahaS1AJGplWM
        kqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMGxpKW1g3HPqg96hxiZOBgPMUpwMCuJ8Obb
        xyYK8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwDTT8sCG
        VdbVd3/e3JsueVnybFpE4uqflxef+B7L5q4kurL1qeW6Tr8FFjl5u/sn/zrMsim8tN2Rh/F4
        wJ4TdjMy1HUOHPT2jV4Tci8+/MYshSQeidorQQxvL+yYI/Uxg6e/8K5p9LeF2ffsb/tKrbpk
        8dRCQ/bSRa6LZna+qhm778i4ppZGS83l2fZu07+HxfGyLzQrm9hurVS4d+Dfo/keWzgeCVlk
        cDt+fOX5ODLSmy1K+4vDmfoAC8EeAbPrs7OyzwT6c6QmP/13Xa1KTJFXJ+sFv+Lne7n/jnVf
        vXJsU8axnNzvuyI6V2SIHZq1zv1REYtcuwD79k87k+UOaHw9LdXmxGqrYruc00XnsxJLcUai
        oRZzUXEiALVwobAUAwAA
X-CMS-MailID: 20211007081133epcas2p31f973709609d82dbbc76bd7b51232cb2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081133epcas2p31f973709609d82dbbc76bd7b51232cb2
References: <CGME20211007081133epcas2p31f973709609d82dbbc76bd7b51232cb2@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ExynosAuto(variant of the Exynos for automotive), the UFS Storage needs
to be accessed from multi-OS. To increase IO performance and reduce SW
complexity, we implemented UFS-IOV to support storage IO virtualization
feature on UFS.

IO virtualization increases IO performance and reduce SW complexity
with small area cost. And IO virtualization supports virtual machine
isolation for Security and Safety which are requested by Multi-OS system
such as automotive application.

Below figure is the conception of UFS-IOV architeture.

    +------+          +------+
    | OS#1 |          | OS#2 |
    +------+          +------+
       |                 |
 +------------+     +------------+
 |  Physical  |     |   Virtual  |
 |    Host    |     |    Host    |
 +------------+     +------------+
   |      |              | <-- UTP_CMD_SAP, UTP_TM_SAP
   |   +-------------------------+
   |   |    Function Arbitor     |
   |   +-------------------------+
 +-------------------------------+
 |           UTP Layer           |
 +-------------------------------+
 +-------------------------------+
 |           UIC Layer           |
 +-------------------------------+

There are two types of host controllers on the UFS host controller
that we designed.
The UFS device has a Function Arbitor that arranges commands of each host.
When each host transmits a command to the Arbitor, the Arbitor transmits it
to the UTP layer.
Physical Host(PH) support all UFSHCI functions(all SAPs) same as
conventional UFSHCI.
Virtual Host(VH) support only data transfer function(UTP_CMD_SAP and
UTP_TM_SAP).

In an environment where multiple OSs are used, the OS that has the
leadership of the system is called System OS(Dom0). This system OS uses
PH and controls error handling.

Since VH can only use less functions than PH, it is necessary to send a
request to PH for Detected Error Handling in VH. To interface among PH
and VHs, UFSHCI HW supports mailbox. PH can broadcast mail to other VH at
the same time with arguments and VH can mail to PH with arguments.
PH and VH generate interrupts when mails from PH or VH.

In this structure, the virtual host can't support some feature and need
to skip the some part of ufshcd code by using quirk.
This patchs add quirks so that the UIC command is ignored and the ufshcd
init process can be skipped for VH. Also, according to our UFS-IOV policy,

First two patches, I picked them up from Jonmin's patchset[1] and the third
patch has been dropped because we need to check it again.

[1]: https://lore.kernel.org/linux-scsi/20210527030901.88403-1-jjmin.jeong@samsung.com/

Patch 0003 ~ 0013, they are changes of exynos7 ufs driver to apply
exynosauto v9 variant and PH/VH capabilities.
Patch 0014 ~ 0017, the patches introduce exynosauto v9 ufs MHCI which
includes PH and VH.

Changes from v3:
- Drop "[PATCH v3 06/17] scsi: ufs: ufs-exynos: get sysreg regmap for
  io-coherency" and squash it to Patch12
- Patch12: Use macro to avoid raw value usage and describe the value of M-Phy setting
- Patch13: Add dma-coherent property
- Patch14: Use macro to avoid raw value and describe the value of HCI_MH_ALLOWABLE_TRAN_OF_VH

Changes from v2:
- Separate dt-binding patches on top of
  https://lore.kernel.org/linux-devicetree/YUNdqnZ2kYefxFUC@robh.at.kernel.org/

Changes from v1:
- Change quirk name from UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION to
  UFSHCD_QUIRK_SKIP_PH_CONFIGURATION
- Add compatibles to Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
  on top of https://lore.kernel.org/linux-scsi/20200613024706.27975-9-alim.akhtar@samsung.com/

Chanho Park (14):
  scsi: ufs: ufs-exynos: change pclk available max value
  scsi: ufs: ufs-exynos: simplify drv_data retrieval
  scsi: ufs: ufs-exynos: add refclkout_stop control
  scsi: ufs: ufs-exynos: add setup_clocks callback
  scsi: ufs: ufs-exynos: correct timeout value setting registers
  scsi: ufs: ufs-exynos: support custom version of ufs_hba_variant_ops
  scsi: ufs: ufs-exynos: add EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
  scsi: ufs: ufs-exynos: factor out priv data init
  scsi: ufs: ufs-exynos: add pre/post_hce_enable drv callbacks
  scsi: ufs: ufs-exynos: support exynosauto v9 ufs driver
  dt-bindings: ufs: exynos-ufs: add io-coherency property
  scsi: ufs: ufs-exynos: multi-host configuration for exynosauto
  scsi: ufs: ufs-exynos: introduce exynosauto v9 virtual host
  dt-bindings: ufs: exynos-ufs: add exynosautov9 compatible

jongmin jeong (2):
  scsi: ufs: add quirk to handle broken UIC command
  scsi: ufs: add quirk to enable host controller without ph
    configuration

 .../bindings/ufs/samsung,exynos-ufs.yaml      |  13 +
 drivers/scsi/ufs/ufs-exynos.c                 | 359 ++++++++++++++++--
 drivers/scsi/ufs/ufs-exynos.h                 |  27 +-
 drivers/scsi/ufs/ufshcd.c                     |   6 +
 drivers/scsi/ufs/ufshcd.h                     |  12 +
 5 files changed, 391 insertions(+), 26 deletions(-)

-- 
2.33.0

