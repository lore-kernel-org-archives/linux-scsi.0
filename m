Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF3EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52649610CE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbhINGy7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 02:54:59 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:42280 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240302AbhINGyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 02:54:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631602412; x=1663138412;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SGJX1LrjKYTDbjRR737j360XKyT3Ftxf17YTpt7/n1I=;
  b=aZk6J6TUnTktMnn3uYTwPiE8G9zNbVm0wBRiLw88I1M/z3MXYS6Rl9rU
   cA/UgKljkTisyQxJ9qVIQ0CXabHOgVOzvcP1h6hhnRGtUEVNMOurHo7gv
   ztTPByTUURj9P/pJDOlkwOOeXeRgem179hMy+orYfcfqqz++giEf+cWK0
   7RUPQygxJ8HTdZl0MB1WSJUM6yBrTMW6JHCiODhZiji1+px24EIaw6d/K
   XczYGz8uxZNDEVFRcXae0z0U1Z+WGbSeqQR5lxlHqxlXRFl6qMsy0f2k5
   MCcvzxlidyYYIYWatfJ0cWEW4JNllUgAT6LMDHYGVI/m3lyD1AyOH5ezt
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,292,1624291200"; 
   d="scan'208";a="291560750"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Sep 2021 14:53:29 +0800
IronPort-SDR: 53IDxdrOlpTyyWNmB1RF4m9ABjvQmqCtesExDxgyRMzrfC/MGuuD8gR4t+1Z9r58/9Qhl0FDvB
 YEN/rcbhhf25Yb9XRZaNFT9ChdcqthtLxRQlqMLWcUzg3VvxFHplCby2hv7EnNe+zh7nwqIvCx
 t9L7VRrNOMTWnj9VhAFpOUBnSwzQIcMIui4yPfkq+76XV24iY1WUWvGfNBavOTPKmXZNGMVjcU
 1yi0DG75Hyl/4/CS5VUa6SJCbPnrQwqvBRPsXlHMy7kzmX7XXezcI/VFa4aI4ZGPGOHhPnga5m
 iBr498Dv3s1ybDPQV0MZCfvV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 23:29:53 -0700
IronPort-SDR: TqNljYPp4YvDcILfpJQtE0hi3he4Q4VBGnARkZPkRlOqpEvR5NFDRl212rdtb1qvW9TQwXqePV
 XL9bra7zl6wtzd8Ap7FMD8ROP0gk9Qw1VLPOd+5sy1a5fhHbqHFpwXjW43Qur1By5SiT4Ai4jE
 yYfaGVW6yFKdF2rKGXN6JsIFhl+oM/ZmOpWc4gPvZfQn5v0lnZ7v9BnUhvJv8G8Oor3UYfZ+X7
 wSrKFv7Mgo4F1ID6YzTJ5VaBtsV8zmx83VcQFk0I0b+j35Sp99Rg3mvKffyWpUDGzPMspN+z1w
 hx4=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Sep 2021 23:53:26 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 0/2] Add temperature notification support
Date:   Tue, 14 Sep 2021 09:53:18 +0300
Message-Id: <20210914065320.8554-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v4 - > v5:
 - Fix improper return error values
 
v3 -> v4:
 - Attend Guenter's comments

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

Avri Altman (2):
  scsi: ufs: Probe for temperature notification support
  scsi: ufs: Add temperature notification exception handling

 drivers/scsi/ufs/Kconfig     |   9 ++
 drivers/scsi/ufs/Makefile    |   1 +
 drivers/scsi/ufs/ufs-hwmon.c | 213 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       |   7 ++
 drivers/scsi/ufs/ufshcd.c    |  47 ++++++++
 drivers/scsi/ufs/ufshcd.h    |  20 ++++
 6 files changed, 297 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-hwmon.c

-- 
2.17.1

