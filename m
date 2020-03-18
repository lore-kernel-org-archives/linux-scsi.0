Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD63C5ACD6
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 11:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E970D2076D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 11:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oaMDPKKL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgCRLSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 07:18:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13841 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCRLSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 07:18:08 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200318111804epoutp0320a1474d01ada251f8c5f3a09eae694e~9YeYYx-Tm3126531265epoutp03A
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2020 11:18:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200318111804epoutp0320a1474d01ada251f8c5f3a09eae694e~9YeYYx-Tm3126531265epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584530284;
        bh=55cxe52jChgOZW7Na66AxnLPO88pMONYr5hUMEzlyDM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=oaMDPKKL/6Qw8rtF4vKUJIjBi1PZ/zCtx/d8I1oNP3DACaM3xULUiJMAIGgwPb26g
         amuCJF6l5Zqd34UMPRIxFeNmjQP/RpSH6k00SOwRW8hYT3rcwQgLRXfF8UECxwDgfj
         GlpHGXpgMuxPV3z8MxiXkO93d/uNlR/puOWGk3O4=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200318111804epcas5p12c1e516f5788d702bafd5cfef625aece~9YeX1y3xi2459224592epcas5p1D;
        Wed, 18 Mar 2020 11:18:04 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        86.4E.04736.C63027E5; Wed, 18 Mar 2020 20:18:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200318111803epcas5p3f1ce09223a1cf97e813b3cbf0c9ba29f~9YeXUaULi1553915539epcas5p3x;
        Wed, 18 Mar 2020 11:18:03 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200318111803epsmtrp1d819d26f04ff4b971c65d48a2dca626e~9YeXSkOvn1841218412epsmtrp1r;
        Wed, 18 Mar 2020 11:18:03 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-f8-5e72036c817e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1D.AD.04158.B63027E5; Wed, 18 Mar 2020 20:18:03 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200318111801epsmtip295cf5d0f2af25c47a04135612fbdd8d3~9YeVmZZIm0257602576epsmtip2d;
        Wed, 18 Mar 2020 11:18:01 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 0/5] exynos-ufs: Add support for UFS HCI
Date:   Wed, 18 Mar 2020 16:41:39 +0530
Message-Id: <20200318111144.39525-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42LZdlhTQzeHuSjO4NQEVosH87axWbz8eZXN
        4tP6ZawW84+cY7U4f34Du8XNLUdZLDY9vsZqcXnXHDaLGef3MVl0X9/BZrH8+D8mi9a9R9gt
        lm69yejA63G5r5fJY9OqTjaPzUvqPVpO7mfx+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKmLNgLWPBcuGKvY8/MDYw3uHrYuTkkBAwkTjY94Wti5GLQ0hgN6PE9ClTWSCc
        T4wSfx6fYgepEhL4xigxZWklTMemNZuYIIr2Mkp87f7DDuG0MEnc+X2IFaSKTUBb4u70LUwg
        tohAgMSl9wfBdjALzGOSWPSoBywhLGAt0bLjANgKFgFViafb54DFeQVsJFrnTmGCWCcvsXrD
        AWaQZgmBE2wS0z/vZoZIuEjM2XSPFcIWlnh1fAs7hC0l8bK/DcjmALKzJXp2GUOEaySWzjvG
        AmHbSxy4MocFpIRZQFNi/S59kDCzAJ9E7+8nTBCdvBIdbUIQ1aoSze+uQnVKS0zs7oZa6iEx
        Z+FUVkgAxUqsu76AcQKjzCyEoQsYGVcxSqYWFOempxabFhjnpZbrFSfmFpfmpesl5+duYgSn
        DS3vHYybzvkcYhTgYFTi4eXYUBAnxJpYVlyZe4hRgoNZSYR3cWF+nBBvSmJlVWpRfnxRaU5q
        8SFGaQ4WJXHeSaxXY4QE0hNLUrNTUwtSi2CyTBycUg2MzMd0jqSvF0rfzbKz8MKpd04XtZfm
        KGfHN0iz8IpMcFrwwUl7Sar6dP4jF7e/fvtUfU9ozdKjNtF3S+aesPVj7Uz/qar1XcWqV9mD
        9YrKneDjN6QrshSN9nk//6KyJVj4Ko+Jjvpj00ki2RuXHDv+du6L35M5BctUFdN3czhkXV51
        +lvHhkfPlFiKMxINtZiLihMBJS2GGRcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSvG42c1GcQfsNJYsH87axWbz8eZXN
        4tP6ZawW84+cY7U4f34Du8XNLUdZLDY9vsZqcXnXHDaLGef3MVl0X9/BZrH8+D8mi9a9R9gt
        lm69yejA63G5r5fJY9OqTjaPzUvqPVpO7mfx+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKmLNgLWPBcuGKvY8/MDYw3uHrYuTkkBAwkdi0ZhNTFyMXh5DAbkaJXa2fmSES
        0hLXN05gh7CFJVb+ew5mCwk0MUls3pYCYrMJaEvcnb6FCcQWEQiSuLdmLSvIIGaBVUwSnb1n
        GUESwgLWEi07DoA1swioSjzdPgesgVfARqJ17hQmiAXyEqs3HGCewMizgJFhFaNkakFxbnpu
        sWGBUV5quV5xYm5xaV66XnJ+7iZGcHhqae1gPHEi/hCjAAejEg9vwqaCOCHWxLLiytxDjBIc
        zEoivIsL8+OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ88rnH4sUEkhPLEnNTk0tSC2CyTJxcEo1
        MMpHb3998r34xbcZof8+G8zmk3KXLf7Ya3XqS+3Hc5kBpj0Xpl1WF7ppmPPoZJvv0cyiyxLr
        WoozHzj8nPzaI8Lv7HGXIxr2jXps29y1XxdM+fpmjY16aCrX432MrJN39rHcXMqv/djU/T9D
        ZFLjXUabaJb3Zyft7tkWcmXaSZYHhycecHz8I1yJpTgj0VCLuag4EQC/yPmiSwIAAA==
X-CMS-MailID: 20200318111803epcas5p3f1ce09223a1cf97e813b3cbf0c9ba29f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200318111803epcas5p3f1ce09223a1cf97e813b3cbf0c9ba29f
References: <CGME20200318111803epcas5p3f1ce09223a1cf97e813b3cbf0c9ba29f@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host controller support
for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.

- Changes since v1:
* fixed make dt_binding_check error as pointed by Rob
* Addressed Krzysztof's review comments
* Added Reviewed-by tags

 
patch 1/5: define devicetree bindings for UFS PHY
patch 2/5: Adds UFS PHY driver
patch 3/5: define devicetree bindings for UFS HCI 
patch 4/5: Adds Samsung UFS HCI driver
patch 5/5: Enabled UFS on exynos7 platform

Note: This series is based on Linux-5.6-rc2 
      In past there was couple of attempt to upstream this driver, but
      it didn't went upstream for some or other reason.


Alim Akhtar (5):
  dt-bindings: phy: Document Samsung UFS PHY bindings
  phy: samsung-ufs: add UFS PHY driver for samsung SoC
  Documentation: devicetree: ufs: Add DT bindings for exynos UFS host
    controller
  scsi: ufs-exynos: add UFS host support for Exynos SoCs
  arm64: dts: Add node for ufs exynos7

 .../bindings/phy/samsung,ufs-phy.yaml         |   62 +
 .../devicetree/bindings/ufs/ufs-exynos.txt    |  104 ++
 .../boot/dts/exynos/exynos7-espresso.dts      |   16 +
 arch/arm64/boot/dts/exynos/exynos7.dtsi       |   44 +-
 drivers/phy/samsung/Kconfig                   |    9 +
 drivers/phy/samsung/Makefile                  |    1 +
 drivers/phy/samsung/phy-exynos7-ufs.h         |   85 +
 drivers/phy/samsung/phy-samsung-ufs.c         |  311 ++++
 drivers/phy/samsung/phy-samsung-ufs.h         |  100 ++
 drivers/scsi/ufs/Kconfig                      |   12 +
 drivers/scsi/ufs/Makefile                     |    1 +
 drivers/scsi/ufs/ufs-exynos.c                 | 1399 +++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                 |  268 ++++
 drivers/scsi/ufs/unipro.h                     |   41 +
 include/linux/phy/phy-samsung-ufs.h           |   70 +
 15 files changed, 2521 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
 create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h
 create mode 100644 include/linux/phy/phy-samsung-ufs.h

-- 
2.17.1

