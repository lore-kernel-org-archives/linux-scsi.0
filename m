Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063A0C11F69
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD40C6138C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 07:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhGNHPJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 03:15:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21282 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238237AbhGNHO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 03:14:59 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210714071204epoutp03636e9a2c860f8128a6ee5144c9f09015~RlseZiuMI1985919859epoutp03g
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 07:12:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210714071204epoutp03636e9a2c860f8128a6ee5144c9f09015~RlseZiuMI1985919859epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626246724;
        bh=ToKck7iujtiUSV8afYAgfpNxW95c8gpYay2ejD4QwZE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ttdNNOKySf80dcK7QIEb6NQLXly23r1/l61EKv9rt8fIXnH0ACO4fT5eV6KeqB+1d
         3T7JMB/uZbPSg4AKnhgoJj5yHAYMDe6XMDTWibIITwtVaFHykWf8wpL59zlqAaqHeG
         Xh3u2Ksha2k0Q12ymFyrzcL6oocG0w7BLVLufj20=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210714071203epcas2p2550b6b127961b4d2f4de5e15437cb28c~RlsdydP_11836418364epcas2p2X;
        Wed, 14 Jul 2021 07:12:03 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.191]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GPpbM5Ddfz4x9QB; Wed, 14 Jul
        2021 07:11:59 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        DF.32.09921.F3E8EE06; Wed, 14 Jul 2021 16:11:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210714071158epcas2p1a7b98fd67b9bcaaa634e59fc224761b1~RlsZGQJ7A0871808718epcas2p1i;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714071158epsmtrp226a1adfafe17ae76b4653f15f461214b~RlsZFTg_10755107551epsmtrp2i;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
X-AuditID: b6c32a45-f9dff700000026c1-0a-60ee8e3f82d5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.43.08394.E3E8EE06; Wed, 14 Jul 2021 16:11:58 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210714071158epsmtip23acf0bc147612f250ba829df8c387cf7~RlsY0abuV2386423864epsmtip2W;
        Wed, 14 Jul 2021 07:11:58 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
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
Subject: [PATCH v2 00/15] introduce exynosauto v9 ufs driver
Date:   Wed, 14 Jul 2021 16:11:16 +0900
Message-Id: <20210714071131.101204-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmua5937sEg3n/1S1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxfnzG9gtbm45
        ymIx4/w+Jovu6zvYLJYf/8fkIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfm
        Fpfmpesl5+daGRoYGJkCVSbkZBybfoatYK5yxbGJexgbGNdLdzFyckgImEj0vpnB1sXIxSEk
        sINRYvfFw6wQzidGid9fJzNCON8YJc6s28MM03Js20GoxF5GibmrF7FDOB8ZJeZNvwtWxSag
        K7Hl+SuwKhGQwasW32UBcZgFTjJLnF5wkB2kSljARmL7gbdgHSwCqhJTZq1hArF5Bewl3t08
        ywaxT17i1LKDUHFBiZMzn7CA2MxA8eats5lBhkoIrOWQaL22lAmiwUXiwJrJUM3CEq+Ob2GH
        sKUkPr/bywbR0M0o0froP1RiNaNEZ6MPhG0v8Wv6FmAYcABt0JRYv0sfxJQQUJY4cgtqL59E
        x+G/7BBhXomONiGIRnWJA9uns0DYshLdcz6zQtgeEkvW7wZ7UUggVmL5zr/MExjlZyH5ZhaS
        b2Yh7F3AyLyKUSy1oDg3PbXYqMAQOV43MYKTs5brDsbJbz/oHWJk4mA8xCjBwawkwrvU6G2C
        EG9KYmVValF+fFFpTmrxIUZTYPhOZJYSTc4H5oe8knhDUyMzMwNLUwtTMyMLJXFeDvZDCUIC
        6YklqdmpqQWpRTB9TBycUg1MFzYEXuN4dXcf40yPD/pLllaWXQ54kBjM6tw+Z7fsRof4NcVM
        ZzqK7pekyu99u2U+7y4l5fB91tybndMDjLfZX/jaePjNjxvM2prtusWi7x4X7Ja7s/iZ/SqF
        Ms7HOxZz7mBcIGhpUviItbskSfbak8mLD0U7Nug6b13felukc1HozGkrfttGVherMdxSl7wV
        k8660qpuZ8kXoeTMx2rHpVQ6Jkkee/yu4uGsTXHXd/6YfYHhzX1L5eVVK1QS/q1SOR4XyBOz
        fNnCItGlagr3vEMy1k6PLK4I2NLldFbu+jT5o3en2HTOmilSmHJBd/GelYtkFj3nmDP7sLXm
        9R+LjzYsCWKUmcBf2n+9jaXpsBJLcUaioRZzUXEiACRNcXZXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSvK5d37sEg9UfVS1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxfnzG9gtbm45
        ymIx4/w+Jovu6zvYLJYf/8fkIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriiuGxSUnMyy1KL9O0SuDKOTT/DVjBXueLYxD2MDYzrpbsYOTkk
        BEwkjm07yNjFyMUhJLCbUWLih15miISsxLN3O9ghbGGJ+y1HWCGK3jNKfFu/CKyITUBXYsvz
        V2DdIgK7GCUOnznMDuIwC1xmlvg27QpYlbCAjcT2A2/BbBYBVYkps9Ywgdi8AvYS726eZYNY
        IS9xatlBqLigxMmZT1hAbGagePPW2cwTGPlmIUnNQpJawMi0ilEytaA4Nz232LDAMC+1XK84
        Mbe4NC9dLzk/dxMjOFq0NHcwbl/1Qe8QIxMH4yFGCQ5mJRHepUZvE4R4UxIrq1KL8uOLSnNS
        iw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgmmzAtiFlQcwmuZ/6sQbFDasU9c7O
        768WeLnQI8vHxK+o+EyH4/MWlSXXpNOu/bJvUhYOf9a5R8tjVlZ4uXf8TH6hHLfeHVHCqt8a
        BesE3pYtSbFzFgy43B6WGjQ78NgniUV31p096fbMJv3DH3elT5U/pP++kpxmLp7p8/hUPUNn
        wqNW4x0bD+3/yavUVNXUcvRjSvweUaWDjldNF3DL9ccmntuzdJbhzjvzPZontr9N/q+5w+XY
        6crQjlvfNZb7zVj84Z/S3RfPJ9YeCCjwfh3672+IQf+WOem3lj7l3WFaEbbxf7W9bsP9uLWH
        i1dwOZUqnjzyW7Vzhco84fojb+4v/6HncCtI8266fv4uJZbijERDLeai4kQAWXsFvQUDAAA=
X-CMS-MailID: 20210714071158epcas2p1a7b98fd67b9bcaaa634e59fc224761b1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210714071158epcas2p1a7b98fd67b9bcaaa634e59fc224761b1
References: <CGME20210714071158epcas2p1a7b98fd67b9bcaaa634e59fc224761b1@epcas2p1.samsung.com>
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

Changes from v1:
- Change quirk name from UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION to
  UFSHCD_QUIRK_SKIP_PH_CONFIGURATION
- Add compatibles to Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
  on top of https://lore.kernel.org/linux-scsi/20200613024706.27975-9-alim.akhtar@samsung.com/

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
  scsi: ufs: add quirk to enable host controller without ph
    configuration

 .../bindings/ufs/samsung,exynos-ufs.yaml      |   7 +
 drivers/scsi/ufs/ufs-exynos.c                 | 318 ++++++++++++++++--
 drivers/scsi/ufs/ufs-exynos.h                 |  10 +-
 drivers/scsi/ufs/ufshcd.c                     |   6 +
 drivers/scsi/ufs/ufshcd.h                     |  12 +
 5 files changed, 327 insertions(+), 26 deletions(-)

-- 
2.32.0

