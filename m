Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7568C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 13:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5AE8619F9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 13:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242562AbhIMNgu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 09:36:50 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47565 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242988AbhIMNeo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 09:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631540008; x=1663076008;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pGp6s8OXSV13dUq3hfMuAIW/HNTvZVlyt23W1OpT7yo=;
  b=NUetyUEx0JUtBW5EqoJkH0BFFVHksDn49NflRlaPy41byL40uovyZ5Td
   jkklnxncPEIOsOADZaefNv62etEAz92rG48y+S+1qoiWKMHaBkQiMuBHY
   ih7rxwGvZpx150IUa47WwBHLg4ZCaqMdETDHUts7VvV9adJFwFDqLzW+g
   T3YDziIVOk4X4dhExpOlARhuUU2ROUEsm9cXZDNJ4n7ES7f/yN2i747Eh
   5HMTiIZuqndqIS3XvFpt+CZUekn42begDrqOXll91kStp8wc6maTOzOim
   ZmTiyFzqkN9E3C9w9w5+FHCsfWXlRIvPplo67+CYuPLfIg1Qf6Y5pmWsH
   w==;
X-IronPort-AV: E=Sophos;i="5.85,290,1624291200"; 
   d="scan'208";a="291474599"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2021 21:33:25 +0800
IronPort-SDR: UgFTwvG7eCnjZZi2UvMbOvFgL1UUNfGyi5lHekcA5Onmzjq+jMDdFw7FJhO0W0R6fSDEeb/s55
 wB8fXRyBo+EdIZKPqoLyc+iDjLOHfFFYWmr92n/54OY5GbVehh1vHcycehEmMVMWeg72mBe/X3
 DU6FnZpltkPPcTfcd6Lb8ibk+xQRpGy89L91lkCOOnOrFpOWM29PteQGrxLzsyIIctZzA+eKXp
 6VYl2rFs4zb+PWlGI/jiDP7rzp4RQdtthABcMMvgzwFPUmqF64yKl2kjtoFzdil2eEI2zTyp3G
 zayqnLJFhgoCkfbGjmlJTVYC
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 06:08:16 -0700
IronPort-SDR: J9P/tHWteB5xzEXTLb4/izfiWw7nZKWqyy7qJA9Ku2ZTYM5pJriYCU0O92k2ZgSfU8OsI9Gorv
 VqQ+kdZsQ+z8CUtt/XdPC8FxxwMEPSA1A9bgbckiitxjP3i09jcsy7YgfY8iYrge7RrIC41Xwe
 N+OlbJY6JuPsPyDTrd0+wEFl0s1L3Ewzsq5rUSNnH+d4abZ7NufiqXgQDDEteZqOkSObbOkn7V
 wzQBm5Hn2lfPpG2DuQBediOaUGt7hVcRF4rb97G2hfGm0/+kvtEGMt09/s3ZGOOkje7xYrznRt
 cdc=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Sep 2021 06:33:23 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 0/2] Add temperature notification support
Date:   Mon, 13 Sep 2021 16:33:01 +0300
Message-Id: <20210913133303.10154-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

[1] https://lore.kernel.org/lkml/1582450522-13256-1-git-send-email-avi.shchislowski@wdc.com/

Avri Altman (2):
  scsi: ufs: Probe for temperature notification support
  scsi: ufs: Add temperature notification exception handling

 drivers/scsi/ufs/Kconfig     |   9 ++
 drivers/scsi/ufs/Makefile    |   1 +
 drivers/scsi/ufs/ufs-hwmon.c | 206 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       |   7 ++
 drivers/scsi/ufs/ufshcd.c    |  47 ++++++++
 drivers/scsi/ufs/ufshcd.h    |  20 ++++
 6 files changed, 290 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-hwmon.c

-- 
2.17.1

