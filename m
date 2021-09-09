Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FECC28B27
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 06:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22CA861101
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 06:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352554AbhIIGgS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 02:36:18 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:25535 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352517AbhIIGgS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 02:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631169309; x=1662705309;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6Szz45xnYb/E2zF+G7svDhiYLqm5PULqroK9cBEAk4g=;
  b=V8zngHYF2emnnKckI2QY42sHltcacMuwxTKyl01koi9Snjma6JtDuFTT
   /OMpvFXwXEIebU6OlRnBIBBPWv3hQ+YJSnvjgiIa9Bll8IDEAPmcW+Hiu
   g5HQVkDPkpiRRDK1HabSFCvtiLvbPDx1dfEFR19Vjn0Iif8SatyRnIHsG
   9Slte4l94tciglFbWakNi/EpL8P2tC+d5Vw19CBPLTRPZYCsY4eqHuZ01
   M/+xktysHfGOrfBTLLRhdrP9idOmdi3PAe/5O+U+/s6B077YZPpOTWGwJ
   bMHQbu4BpAzQhkNQsCDBr1DvhOkh7BMTTUVRgd/R6/NbGA14PbuzH8w21
   w==;
X-IronPort-AV: E=Sophos;i="5.85,279,1624291200"; 
   d="scan'208";a="179551093"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Sep 2021 14:35:07 +0800
IronPort-SDR: 4U6oN3BLV1OfBLZaIQheGHFHkv15ilcjViaZeSqrrFQo7TiihfQt/Z4tRUszSx5GIAIcor9ZEF
 Zl8mziT6v2jr6+pIL4drUscUeF2Yl7HQYKyxgBxfQL5l2oE90etRxZKzqbDQ6WxJQ+0v9CHVc+
 Tk2n3WO9nIC3KuJA/fd6UCRDF/dkkw9ekMU4DP4AiDJj5evpOdjfQbqkZOWlYicNqR9s7j1U0v
 c38k8GuTKQOygbsoWCsDSF00bzFBNz7OI77QzZiaIKjT2nVoFfGKVLVRliw4XANfqYvyI2Jh2G
 b8WVvgyDAc7Bd+qf5JKTPOf9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 23:11:43 -0700
IronPort-SDR: TxjQRD4kOHIMHWI+jbQmptf1qaZZilWCwiv54Waw2WZ+5hH6CFDl4j4PWQtzVAKnu60temN9Rb
 Vk3ShzcvXAzqwcL3oD+ME2xkXxrxATU3W+cLO1Y5g0twoddaPZn2/RJ7Rv9TlYtPaBr3kn4+kR
 2uZBwRc5Wq2fYUiERJKvgVAFQu8OFRCHMBQ14gsjA+SYTa3X5WjZWvaDx4uI4jh+1qNYh/rcLg
 DjhZN9AXx7KS+ED7k7t+TIJkn9/t+yBCXw73xuCt0E5mJdRSWKec6ZykG+3Viesyd2rhzOYBG6
 k0o=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Sep 2021 23:35:04 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 0/2] Add temperature notification support
Date:   Thu,  9 Sep 2021 09:34:42 +0300
Message-Id: <20210909063444.22407-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2:
 - Add a hw monitor device if both the platform & the device support it
 - Remove the sysfs patch: no need to duplicate /sys/class/hwmon

UFS3.0 allows using the ufs device as a temperature sensor. The purpose
of this optional feature is to provide notification to the host of the
UFS device case temperature. It allows reading of a rough estimate
(+-10 degrees centigrade) of the current case temperature, and setting a
lower and upper temperature bounds, in which the device will trigger an
applicable exception event.

A previous attempt [1] tried a comprehensive approach.  Still, it was
unsuccessful. Here is a more modest approach that introduces just the
bare minimum to support temperature notification.

Thanks,
Avri

[1] https://lore.kernel.org/lkml/1582450522-13256-1-git-send-email-avi.shchislowski@wdc.com/

Avri Altman (2):
  scsi: ufs: Probe for temperature notification support
  scsi: ufs: Add temperature notification exception handling

 drivers/scsi/ufs/Kconfig     |  10 ++
 drivers/scsi/ufs/Makefile    |   1 +
 drivers/scsi/ufs/ufs-hwmon.c | 180 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       |   8 ++
 drivers/scsi/ufs/ufshcd.c    |  46 +++++++++
 drivers/scsi/ufs/ufshcd.h    |  18 ++++
 6 files changed, 263 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-hwmon.c

-- 
2.17.1

