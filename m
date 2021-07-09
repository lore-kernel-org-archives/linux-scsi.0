Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70F7C07E9B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF9C161245
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhGIHAT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18907 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhGIHAS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:18 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210709065733epoutp011a421d03e8bb37de2ab2843bc9173d0f~QDRX1AI-J2700027000epoutp01N
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210709065733epoutp011a421d03e8bb37de2ab2843bc9173d0f~QDRX1AI-J2700027000epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813853;
        bh=9lBLIjfefxpIddL33TYWRmwm+w4y1PAUmGsE0uakKdA=;
        h=From:To:Cc:Subject:Date:References:From;
        b=BZuspo5zt19BdFRQnbC5SXigLaZzWYIPxM/aVVsHXQtHRs3vn4LY2Buik3OCTvJyW
         Ro84TdbjWiUC/rbvpDard32hYR44Loo/+jZXR4w04ykjIOuWMu2pc7MESJMFxwEOtj
         R0eAJNwudEyrcbNaAwXtbTdcPIbomRK0UGL+P8OU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210709065732epcas2p143399e43b70c088ae1747288a09e2ba5~QDRWlSeH82881228812epcas2p1h;
        Fri,  9 Jul 2021 06:57:32 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GLkVx1SQcz4x9Q5; Fri,  9 Jul
        2021 06:57:29 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        4D.4D.09571.353F7E06; Fri,  9 Jul 2021 15:57:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210709065721epcas2p46f7aae35571c10f233b71a6381214419~QDRNLJBf52941029410epcas2p4G;
        Fri,  9 Jul 2021 06:57:21 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210709065721epsmtrp15a6d9b66242433bb4d328c6568f17c52~QDRNI-Lnf3179431794epsmtrp17;
        Fri,  9 Jul 2021 06:57:21 +0000 (GMT)
X-AuditID: b6c32a48-1f5ff70000002563-a7-60e7f353d2d0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.B7.08289.153F7E06; Fri,  9 Jul 2021 15:57:21 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065721epsmtip234807cad7753df7e56bca57ef629e9cc~QDRM8P5ZB3177431774epsmtip2Y;
        Fri,  9 Jul 2021 06:57:21 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 00/15] introduce exynosauto v9 ufs driver
Date:   Fri,  9 Jul 2021 15:56:56 +0900
Message-Id: <20210709065711.25195-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJsWRmVeSWpSXmKPExsWy7bCmhW7w5+cJBk/+iVqcfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORmLPy5nL+hQqJj05RJbA2ObZBcjJ4eEgInE7utbWboYuTiEBHYwSnz4
        MYUVwvnEKPGicQU7hPOZUaLjwiMmmJYXKzaB2UICuxglVh03hSj6yCix6O4DsASbgK7Eluev
        GEESIgL9jBLL988FW8IscJJZ4vSCg+wgVcIClhIPlu8Bs1kEVCXm3dgNZvMK2ElsP9XMArFO
        XuLUsoNMEHFBiZMzn4DFmYHizVtnM4MMlRBYyiFxecE0ZogGF4ktOz6zQtjCEq+Ob2GHsKUk
        Xva3sUM0dDNKtD76D5VYzSjR2egDYdtL/Jq+BaiZA2iDpsT6XfogpoSAssSRW1B7+SQ6Dv9l
        hwjzSnS0CUE0qksc2D4d6mRZie45MBd4SPRNnwYNrViJhd8/s09glJ+F5JtZSL6ZhbB3ASPz
        Kkax1ILi3PTUYqMCE+Ro3cQITshaHjsYZ7/9oHeIkYmD8RCjBAezkgiv0YxnCUK8KYmVValF
        +fFFpTmpxYcYTYHhO5FZSjQ5H5gT8kriDU2NzMwMLE0tTM2MLJTEeTnYDyUICaQnlqRmp6YW
        pBbB9DFxcEo1MIlEPZG88kn/2tl/Z+8ee2H84OuxtC49phs7X0+wKBCPE1y9zn6Vx6+TLEqC
        /VseC/s8Z9rV/Lrh/xrtD8YaCw79Y1bJa/T178qS3ha95N9d360iNR3nvFutprHoc+nfipHJ
        jT6rpFl8Usq7cMmHU3oV01b/Ecpu+bfi15v9jFd8zjVt/RpxT03xjozw79sFcXzCHwU8iv4c
        npSTdUp2a/XbLXyPs8LWOz8W+PN/8zHpKWcYLQJX3na00DTLqVFZMHFrsWTN5dU2P97ahqw5
        oKZV4vmsxzN5SdDymafVJq/bcojpm1GG+eO4vITiZc/8DEUulkQv2ulfK30tgeGLsf+PbbNm
        Ppl0ikP9ew5Tp7kSS3FGoqEWc1FxIgBS+aWOUQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWy7bCSvG7g5+cJBv8umVqcfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuKC6blNSczLLUIn27BK6MxR+Xsxd0KFRM+nKJrYGxTbKLkZNDQsBE4sWK
        TUxdjFwcQgI7GCWmbTzACJGQlXj2bgc7hC0scb/lCCtE0XtGiSMbGlhAEmwCuhJbnr8CaxAR
        mMgoseSeGEgRs8BlZolv064wgySEBSwlHizfAzaJRUBVYt6N3WA2r4CdxPZTzSwQG+QlTi07
        yAQRF5Q4OfMJWJwZKN68dTbzBEa+WUhSs5CkFjAyrWKUTC0ozk3PLTYsMMpLLdcrTswtLs1L
        10vOz93ECI4QLa0djHtWfdA7xMjEwXiIUYKDWUmE12jGswQh3pTEyqrUovz4otKc1OJDjNIc
        LErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamCx8UrfobD4nM7Nhol9fWuChHS189qv0BBIM
        vspIuPau2nFJ0mkpz/6J0Rflf98S3fc0/c3zqwYPo+4evzt3ilXdx3N3nVKz2yIP7ZddphIX
        32V9Um4XY+ICZWnnl3tz3k6e1xgsN2Pt9mrVTgndVfzPPkxpndfBdLlKy0vSauXkmquMyye7
        S92ZdSH2wBwrvefstRYrtBco9sxl1RZa9MKdaVax15nYa/vXLeYRXP/DglVv3oYD351a0v8o
        LGh+zPe+zZdL4R//npD5fQVWNw47XBTavlPWdXGEcjOnlgt78A2FmF2tupyC1ZY1C/9077St
        Zpqlk7N4V+ziifffiVf9v2+lHxHP5MS8VE+QW4mlOCPRUIu5qDgRAGeUU8//AgAA
X-CMS-MailID: 20210709065721epcas2p46f7aae35571c10f233b71a6381214419
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065721epcas2p46f7aae35571c10f233b71a6381214419
References: <CGME20210709065721epcas2p46f7aae35571c10f233b71a6381214419@epcas2p4.samsung.com>
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

Patch 0003 ~ 0012, they are changes of exynos7 ufs driver to apply
exynosauto v9 variant and PH/VH capabilities.
Patch 0013 ~ 0015, they introduce exynosauto v9 ufs MHCI which includes
PH and VH.

Chanho Park (13):
  scsi: ufs: ufs-exynos: change pclk available max value
  scsi: ufs: ufs-exynos: simplify drv_data retrieval
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

jongmin jeong (2):
  scsi: ufs: add quirk to handle broken UIC command
  scsi: ufs: add quirk to enable host controller without interface
    configuration

 drivers/scsi/ufs/ufs-exynos.c | 318 +++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufs-exynos.h |  10 +-
 drivers/scsi/ufs/ufshcd.c     |   6 +
 drivers/scsi/ufs/ufshcd.h     |  12 ++
 4 files changed, 320 insertions(+), 26 deletions(-)

-- 
2.32.0

