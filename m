Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB96C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 985456112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbhIQG5G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28980 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237610AbhIQG4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:51 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210917065526epoutp04692a2e420e20da42c0175d8d8c414e99~liZg7MmsE2950429504epoutp04K
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210917065526epoutp04692a2e420e20da42c0175d8d8c414e99~liZg7MmsE2950429504epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861726;
        bh=T6fTs4UBgN0HP3lMf/8KragGhrkueFAfG5eRajMehT8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=VU0/oZADYizVQG/8qJ0rsYxlEXbrCphNMTuP3g8l4YALAcRO+/NuSxWObWBQqd1m0
         hcvEG4Xv7+m6hiZaqTZUeuH7crgQjsJwBtEwPg9FDZDl+3N1dggCa8gZLHYvgQtg1b
         n8e0SZ/nWWKq+QbfHQZriTCzqKqpCt3qv38Iz6i4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210917065526epcas2p3b41e82a5bfde4c6df977ed1d797a2986~liZghHagM1851718517epcas2p3i;
        Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4H9l8C3xVYz4x9Q3; Fri, 17 Sep
        2021 06:55:23 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        83.DF.09472.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epcas2p2c9c7baccfc82b3798804c351dbf676eb~liZc6alF00686706867epcas2p2d;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065522epsmtrp264e6f551974173235fb5249bc80487d7~liZc5Osrq1371513715epsmtrp2O;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
X-AuditID: b6c32a48-d75ff70000002500-46-61443bdb50c1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.91.08750.ADB34416; Fri, 17 Sep 2021 15:55:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epsmtip2b8fb21e232e9031a708d34d46ab16bca~liZcp0rgB2163221632epsmtip2u;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
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
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v3 00/17] introduce exynosauto v9 ufs driver
Date:   Fri, 17 Sep 2021 15:54:19 +0900
Message-Id: <20210917065436.145629-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmme5ta5dEg8XfZS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLGac
        38dk0X19B5vF8uP/mBz4PS5f8faY1dDL5nG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaP7+s7
        2Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAniicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUN
        LS3MlRTyEnNTbZVcfAJ03TJzgL5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQY
        GhboFSfmFpfmpesl5+daGRoYGJkCVSbkZCzbnVuwWrXievdRpgbG6bJdjJwcEgImEqufNLJ1
        MXJxCAnsYJR4MOUjO4TziVHi8axbUJnPjBIzl95lg2k5tOotVGIXo8SHDZuYIJyPjBILTlxl
        AqliE9CV2PL8FSNIQkTgPaPEk8dTwAYzC3xlkth98DvYLGEBG4mFt3aygNgsAqoSzSf+gHXz
        CthLPJnYygixT17iyK9OZoi4oMTJmU/A6pmB4s1bZzODDJUQ2MMh0ffxFDtEg4vEnKkNTBC2
        sMSr41ug4lISn9/tZYNo6GaUaH30HyqxmlGis9EHwraX+DV9C2sXIwfQBk2J9bv0QUwJAWWJ
        I7eg9vJJdBz+yw4R5pXoaBOCaFSXOLB9OguELSvRPeczK4TtIfHl32awRUICsRLX1x5jnMAo
        PwvJN7OQfDMLYe8CRuZVjGKpBcW56anFRgUmyNG6iRGcprU8djDOfvtB7xAjEwfjIUYJDmYl
        Ed4LNY6JQrwpiZVVqUX58UWlOanFhxhNgeE7kVlKNDkfmCnySuINTY3MzAwsTS1MzYwslMR5
        5/5zShQSSE8sSc1OTS1ILYLpY+LglGpgCm3cp/Tk+7FJV2ofvVbK3h7QvyKO4eelx39FH76y
        61nTvFGsUG2L4bpbHGtW/A1l8A5ivZAaqdnX5m7QYXdI1Vvuorh7+QVzx2JN1ocVDssT3qaJ
        P1wZYqeixujby8RU9tTewHObxefr3wN/zeJKbq+aZ/WjU049Yf75gq4Cz97QV1F57V68Pjax
        v3KPzKhXOn/jsN3ivQkaUibTJ9p6Bnvw3Sto2FmdVeZu39VwiHlv5rbOVdm7y/k6rhWU3d8n
        t6J6c7Vo8hfOqr03+qew+Z+Ylvii84OtLLvKbGvDY5X2KgqakTGnlr+b4tK4s62tO0nz3ULf
        bTOdQv1FlNZ83nW+7ZZ9Yfu/NJ7PPkosxRmJhlrMRcWJABDluuZcBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWy7bCSvO4ta5dEg7cX5CxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XGtz+YLGac
        38dk0X19B5vF8uP/mBz4PS5f8faY1dDL5nG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaP7+s7
        2Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDKW7c4tWK1acb37KFMD43TZ
        LkZODgkBE4lDq96ydTFycQgJ7GCUeHZ2DytEQlbi2bsd7BC2sMT9liOsEEXvGSVuNc5kAUmw
        CehKbHn+ihHEFhH4yCgx55sWSBGzwF8midbWDUwgCWEBG4mFt3aCNbAIqEo0n/gDFucVsJd4
        MrGVEWKDvMSRX53MEHFBiZMzn4DVMwPFm7fOZp7AyDcLSWoWktQCRqZVjJKpBcW56bnFhgVG
        eanlesWJucWleel6yfm5mxjBUaOltYNxz6oPeocYmTgYDzFKcDArifBeqHFMFOJNSaysSi3K
        jy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoEph5nref6Tr4c2zZK9p75+
        Sriif5HF7vOnbMWlNk5fdsqggmlZ/Lbrf2S7fVMfKH3UZLqxewLrP///0qam7iFneL4aGb/5
        MVN5peKzwN6eo7pPFk7e9ZTdNz3o1vmieTpKc9qvHTp1+VdB+KqPW7bWbtG9uG/FLaHkU7Ll
        NrN+pn5qmcv4WeHZ/1UPDDuu/11/8bdj4PJdSxcru4TP85nbIrJA8Ty70bOHAibtk84+SXnh
        pLir65pP87GrMc95F5TUzLkf+3axKsdtj7d7Cjg8rjwKtti2YuLnboVNS7gVfCY+l6grKRBn
        3vNpmdLkwsYNEinfqlbVuOkFZSQVzI5R2nY2a9e3PfUL72b+WceQfkqJpTgj0VCLuag4EQDe
        xPJlCQMAAA==
X-CMS-MailID: 20210917065522epcas2p2c9c7baccfc82b3798804c351dbf676eb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065522epcas2p2c9c7baccfc82b3798804c351dbf676eb
References: <CGME20210917065522epcas2p2c9c7baccfc82b3798804c351dbf676eb@epcas2p2.samsung.com>
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

Changes from v2:
- Separate dt-binding patches on top of
  https://lore.kernel.org/linux-devicetree/YUNdqnZ2kYefxFUC@robh.at.kernel.org/

Changes from v1:
- Change quirk name from UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION to
  UFSHCD_QUIRK_SKIP_PH_CONFIGURATION
- Add compatibles to Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
  on top of https://lore.kernel.org/linux-scsi/20200613024706.27975-9-alim.akhtar@samsung.com/

Chanho Park (15):
  scsi: ufs: ufs-exynos: change pclk available max value
  scsi: ufs: ufs-exynos: simplify drv_data retrieval
  dt-bindings: ufs: exynos-ufs: add sysreg regmap property
  scsi: ufs: ufs-exynos: get sysreg regmap for io-coherency
  scsi: ufs: ufs-exynos: add refclkout_stop control
  scsi: ufs: ufs-exynos: add setup_clocks callback
  scsi: ufs: ufs-exynos: correct timeout value setting registers
  scsi: ufs: ufs-exynos: support custom version of ufs_hba_variant_ops
  scsi: ufs: ufs-exynos: add EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
  scsi: ufs: ufs-exynos: factor out priv data init
  scsi: ufs: ufs-exynos: add pre/post_hce_enable drv callbacks
  scsi: ufs: ufs-exynos: support exynosauto v9 ufs driver
  scsi: ufs: ufs-exynos: multi-host configuration for exynosauto
  scsi: ufs: ufs-exynos: introduce exynosauto v9 virtual host
  dt-bindings: ufs: exynos-ufs: add exynosautov9 compatible

jongmin jeong (2):
  scsi: ufs: add quirk to handle broken UIC command
  scsi: ufs: add quirk to enable host controller without ph
    configuration

 .../bindings/ufs/samsung,exynos-ufs.yaml      |   7 +
 drivers/scsi/ufs/ufs-exynos.c                 | 318 ++++++++++++++++--
 drivers/scsi/ufs/ufs-exynos.h                 |  10 +-
 drivers/scsi/ufs/ufshcd.c                     |   6 +
 drivers/scsi/ufs/ufshcd.h                     |  12 +
 5 files changed, 327 insertions(+), 26 deletions(-)

-- 
2.33.0

