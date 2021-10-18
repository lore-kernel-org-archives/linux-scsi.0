Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6787FC43219
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 519456103C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhJRMrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18669 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhJRMr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:27 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211018124513epoutp01798b159239cb36071b79d655c15e8183~vIKw1GFUO2805928059epoutp01h
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211018124513epoutp01798b159239cb36071b79d655c15e8183~vIKw1GFUO2805928059epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561113;
        bh=uO1g0rsg2UjAUXqyw5+dlCMZbA/ISIyC5E4IaaBUgGc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ihbrMRmIv06eR8Oq68SZvfHFxinpDfVIPP8skXzAR/wbvMGhsKhDstq2f9dzwlxFj
         KLr9j1FjIt6U025MiP6N6nD4RUWbihjtjZQ9GzJ5pgS9/tHBMQk7aQ1DTwUspSD9Zd
         Rb43saf7u9ppZcXas8yeTsSINUoQRdqSHW3FFN/s=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211018124513epcas2p10b24ba2590e858d75e45db60250bd761~vIKwSpI6a3164231642epcas2p1e;
        Mon, 18 Oct 2021 12:45:13 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.98]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HXxRP4XBVz4x9Q2; Mon, 18 Oct
        2021 12:45:05 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.D9.09823.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p31437a0fae6711edeb9db5b49eb420e56~vIKow1njE0244402444epcas2p3G;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp17a9ae7dbff1db1ce9764baa40aaa12eb~vIKotF9G11580315803epsmtrp1L;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a48-13dff7000000265f-15-616d6c511acc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.50.08902.05C6D616; Mon, 18 Oct 2021 21:45:04 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124504epsmtip2bd0fc0036f71309dbff15093c05ec06e~vIKocD1l-0377703777epsmtip2b;
        Mon, 18 Oct 2021 12:45:04 +0000 (GMT)
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
Subject: [PATCH v5 00/15] introduce exynosauto v9 ufs driver
Date:   Mon, 18 Oct 2021 21:42:01 +0900
Message-Id: <20211018124216.153072-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUwTdxjH87trj8pWd1aQ38gc7Awx4MAWCz0WmCMwcwuMQNiWjYzBWW6U
        0bf0yoJbTNDFjtLJi+CgBYktoAaMdR0CGsEOmAzZ9A/AYU0WERyWiCIvIjDKWg43//s8r9/n
        +b0IUNEtLFhQoNYzOjWtJDB/XkdfeGxkhlJFi/9a20kOTp7HyHuNHRjpXh7FyF/GjTzyx9ll
        lJyzn+GTw9f2kD9cTiKHKm0IOWm3oKRtrAMhx1YMfPKnmecIWXerByFNf3Zh5NkBD0KuLvci
        722jhkdSKEvJcYwaLj+OUD+fi6CarroRytFqxKhKmxNQS/ZSjHr6wMWjyttbATXveJP63mlC
        0l/NKoxXMHQeowtl1HJNXoE6P4FIycxJyomJFUsiJXGkjAhV0yomgUhOTY88UKD07kWEfk0r
        i7yudJplib3vxus0RXomVKFh9QkEo81TamXaKJZWsUXq/Cg1o39HIhZHx3gTcwsVtitfaAf3
        FNd2Wv1KQC9RBrYIIC6F16YugjLgLxDhXQA6Wx7xOGMOwJnVPzDOeAZgVVUf9qJkYfwInwt0
        A2hrOrUREOFPAZy4962PMTwStk9Nb/QNwJ8AODlR4+czUNyJwonLy3xf1nY8Hk67qxEf8/Aw
        OPpgaqOTEN8PjVfNfE4uBPavGFHOvw0Omid5Pka9/u8u1aNcTr8A/uOhOE6Gi+ujgOPtcHqg
        3Y/jYOiuMGwMAXETgMfur28G2gA0HknleD9cqW33Cgu8AuHQfmWvDyG+C/a7NmW3wtK+NT/O
        LYSlBhFXuBs6O2t5HO+Epob5zekpeMFZDXzpIjwbGheDKkGI5aVdLC/tYvlf9jRAW8EORsuq
        8hk2Wiv9707lGpUDbLzsCKoL1M/MRvUCRAB6ARSgRIDw4PsqWiTMow99w+g0OboiJcP2ghjv
        6VahwYFyjfdrqPU5EmmcWBobK5FFx4hlRJAwLrCQFuH5tJ4pZBgto3tRhwi2BJcgln0X37gJ
        4gwn2agnY7mne4ji26abhuGZmi93eNytEip3qOJ5gSnMldYdZOUHr341rD1x99dz5x8iK2+X
        91QLk9tr0p0H78x4ktcy52M/zk4MwW7IE0/4KTOyKrLzwksPH637pHAlrfGjXYGfBlYvK8wt
        B25s7Wk4ZB9J6F5KaW3LLB8NcD3OSKYfzY4o1ptXXSEL+t/E5tebZw2/j6c5ZIv1cutnKXeK
        k5Drh1OPfWBPNDvCw+63dQaojs456kobnyma5J7F14Yi9fvA3yPNHQ9LVGj4pSRrWhLqUT1u
        ybq9tLZw1zzr9L9e5x7fPUBQr7yFfFg2csqacsEl/byhsovgsQpaEoHqWPpfuETt0WIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42LZdlhJXjcgJzfRoPGPqcXJJ2vYLB7M28Zm
        8fLnVTaLgw87WSymffjJbPFp/TJWi8v7tS16djpbnJ6wiMniyfpZzBaLbmxjsrjxq43VYuPb
        H0wWM87vY7Lovr6DzWL58X9MFr9/HmJyEPS4fMXbY1ZDL5vH5b5eJo/NK7Q8Fu95yeSxaVUn
        m8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgieKySUnNySxLLdK3S+DKWLQrruCk
        dsX07QvZGxgPKXUxcnJICJhIfHnYyNrFyMUhJLCbUWLhgl3sEAlZiWfvdkDZwhL3W45AFb1n
        lLjypBcswSagK7Hl+StGEFtE4COjxJxvWiBFzAKnmCXWrtvEApIQFrCRePVyMhOIzSKgKnH1
        6XM2EJtXwF6ic89MVogN8hJHfnUyQ8QFJU7OfALWywwUb946m3kCI98sJKlZSFILGJlWMUqm
        FhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIER5KW5g7G7as+6B1iZOJgPMQowcGsJMKb5Jqb
        KMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAPTxtMHRAtl
        GLXrzYvrrl/4etDr+ac/u54GWs/MVjq955FE7Kk9b2+YnjhXwXLd0+l4wAbT0iumcZrmP5NL
        Ti6Sij5yQvH/m8aL9zImpG6LbDlg+0HELP/k6bi0j8a1B09pJK2cmnk688mRwrW50ttCdTPt
        jB5tf8X4wDLw4FUttq8sraYxeo1R/FxrevUZzhVrLrzSv0g29J9qSfHV/4fdIhy2fjt+1l3o
        0VUb8wiJfuuUg0X9yxn5rdbun7c4VVlRJvzxccVH7ubsj+/41Ny6/i/uwhaFL+ZLzyouWch2
        8vmkuS5Bl1sDGDd/4ndcn9nBPOVOyvRNTm57a70vhL0qCXra/+7eAievc/rnegrnK7EUZyQa
        ajEXFScCAOL/754TAwAA
X-CMS-MailID: 20211018124505epcas2p31437a0fae6711edeb9db5b49eb420e56
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p31437a0fae6711edeb9db5b49eb420e56
References: <CGME20211018124505epcas2p31437a0fae6711edeb9db5b49eb420e56@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ExynosAuto(variant of the Exynos for automotive), the UFS Storage needs
to be accessed from multiple VMs. Traditional virtualization solution
provides para-virtualized block driver such as virtio-blk. However, they
can be highly depends on the Dom0 where the backend of the PV is
located. When the system gets high cpu pressure, the performance of
guest VMs are also affected. To overcome this, the SoC implements the
virtualization concept as the H/W controller level.

Below figure is a conceptual design of the UFS Multi Host architecture.

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
   |   |    Function Arbiter     |
   |   +-------------------------+
 +-------------------------------+
 |           UTP Layer           |
 +-------------------------------+
 +-------------------------------+
 |           UIC Layer           |
 +-------------------------------+

There are two types of host controllers of the UFS host controller
that we designed. The controller has a Function Arbiter that arranges
commands of each hosts. It will arrange the doorbells among the PH and
VHs as Round-Robin. When each host transmits a command to the Arbiter,
the Arbiter transmits it to the UTP layer. Physical Host(PH) support all
UFSHCI functions(all SAPs) same as conventional UFSHCI.
Virtual Hosts(VHs) support only data transfer function(UTP_CMD_SAP and
UTP_TM_SAP).

In an environment where multiple VMs are used, the OS that has the
leadership of the system is called System OS(Dom0). This system OS will
own the PH and has a responsibility to handle UIC errors.

VHs can only supports data transfer functions compared with the PH,
they're necessary to send a request to the PH for error handling of VHs.
To interface among the PH and VHs, the UFSHCI controller supports mailbox.
The mailbox register has 8 bit fields and they can be used as
arguments of the mailbox protocol. In this initial patchset, the PH
ready message is supported and they will be implemented to the next
steps.

To support this virtual host type controller which only supports data
transfer function (TP_CMD_SAP and UTP_TM_SAP), we need to add below two
quirks.
- UFSHCD_QUIRK_BROKEN_UIC_CMD
- UFSHCD_QUIRK_SKIP_PH_CONFIGURATION

First two patches, I picked them up from Jonmin's patchset[1] and the third
patch has been dropped because it's not necessary anymore.

[1]: https://lore.kernel.org/linux-scsi/20210527030901.88403-1-jjmin.jeong@samsung.com/

Patch 0003 ~ 0010, they are changes of exynos7 ufs driver to apply
exynosauto v9 variant and PH/VH capabilities.
Patch 0011 ~ 0015, the patches introduce the exynosauto v9 ufs MHCI which
includes the PH and VHs.

Changes from v4:
- s/Arbitor/Arbiter/g of cover-letter.
- Rephrase descriptions of cover letter from original patchset.
- Except 0007-scsi-ufs-ufs-exynos-correct-timeout-value-setting-re.patch
  from this patchset and sent it independently
- Patch11/12: Consolidate sysreg and samsung,ufs-shareability-reg-offset
  property.
- Patch14:
  Drop wlun_dev_clr_ua configuration
  Add TODO: tag for further implementations

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

Chanho Park (13):
  scsi: ufs: ufs-exynos: change pclk available max value
  scsi: ufs: ufs-exynos: simplify drv_data retrieval
  scsi: ufs: ufs-exynos: add refclkout_stop control
  scsi: ufs: ufs-exynos: add setup_clocks callback
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

 .../bindings/ufs/samsung,exynos-ufs.yaml      |  10 +
 drivers/scsi/ufs/ufs-exynos.c                 | 354 +++++++++++++++++-
 drivers/scsi/ufs/ufs-exynos.h                 |  27 +-
 drivers/scsi/ufs/ufshcd.c                     |   6 +
 drivers/scsi/ufs/ufshcd.h                     |  12 +
 5 files changed, 386 insertions(+), 23 deletions(-)

-- 
2.33.0

