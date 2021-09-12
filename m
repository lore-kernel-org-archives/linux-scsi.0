Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72194C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 13:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE3861209
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 13:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhILNUk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 09:20:40 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34412 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhILNUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2021 09:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631452766; x=1662988766;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YQZ+zwPEYQ1QV+zKMg1yg3Va8gHNfILejX5ulgRBH3E=;
  b=OfGXSdQfLzRQWJMdoCLsXChqLOKzjTj/jSXsREKKVBXY9AeZoZsPkJqA
   IVMKHW2OesM5q6xQhlbBEHFGZWU6qiydttNd+w/vSjvqoFzTusx3w0Vj4
   uV9VtifYrVlJqXvXrFML8ukLEBHvNOpnRukw28/SIW7+6/8hfNQHaEMDs
   fXNlsVGAM+hl8ltraTbnTbcp/x5sVp54NWMs2YephcIhfq9lsHa4aVWgB
   pfZJzXxwjbT/F9ER1HGLz+X+rxVBKC1TUUyMRw+gJ+tY9n4LBtDYigN7+
   QL0l/EcdewX5QyuDnY0K2lZnbyWa3Ecvv+Rao3d5wIi30I85+4Zo6AWdQ
   A==;
X-IronPort-AV: E=Sophos;i="5.85,287,1624291200"; 
   d="scan'208";a="283580305"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2021 21:19:25 +0800
IronPort-SDR: E3ixQDXeHbVMl9yYxdOxQ6zd4fI2SyWxBZ68atuIDgQu8/F5EtKUO6UNFC/AYgWrxuGw5tcCdk
 9JCBZdvoAYPMdRbPjI9eH7tS9zh4RiTA+oVu1aSvm7XyGR+487tc799Vo4ZSGLQzy0u8OeKzMX
 RT6DUHKEnrTPHLTU00YoHqSJkgab2uodV6ilw5/IJ0l10dsDZsU8Q+S+x6+aba7U9CyOMkrC8W
 3dIORvIbKKdpKKmyHKme8lAc8p/1of0WAC7ubCJ1QnkyFO2c10gEYwXWcJVre1QklUed7aDv5D
 DaawzFNONiRFH8MwbW29f57H
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2021 05:54:18 -0700
IronPort-SDR: 41ZbyaYrvyu1mrYcLg9HCBAjUUotaNvOcaQZNfxSXzs3W4gkqp+O2nbdrxDW7jPmb7LSqGxgfR
 4Lj6PaP/iJdbAzbllOyQCdc9VbxaDVu3mEjGdfQzruckCeHQGaA5tHnXgNaolrpC2gsF3I5Qhd
 jZbJoOB1DuCFsHU8sqRCdrGcVXe1CLAA4EBbpV6SyjKUIoXj6q/Efppln48Ak7DXWIKGqC5D5H
 Np94bBwCC2Ya7ph6vMXgHZdaz4bZmra1xfl3fHMGa0NfjJyRV3/MIO6IlpXUq2D5iFVYJQfjq6
 yqI=
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.225.32.116])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Sep 2021 06:19:23 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 0/2] Add temperature notification support
Date:   Sun, 12 Sep 2021 16:19:17 +0300
Message-Id: <20210912131919.12962-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2 -> v3:
 - Attend Bart's & Guenter's comments

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
 drivers/scsi/ufs/ufs-hwmon.c | 193 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       |   8 ++
 drivers/scsi/ufs/ufshcd.c    |  49 +++++++++
 drivers/scsi/ufs/ufshcd.h    |  20 ++++
 6 files changed, 281 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-hwmon.c

-- 
2.17.1

