Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02816C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 06:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10336113E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 06:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhIOGFz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 02:05:55 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:50105 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbhIOGFu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 02:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631685872; x=1663221872;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Nmb35ZzUMk/Bcq3sZcxgczUnIx+eqXSj4ITQNBXyMr8=;
  b=PEBJUCOHhE8heAJNKsbLI2fBCP+7PxIlYAfJuaQfEQdZeNG08gEJzbcu
   XOI5FlC/b7GdKx65uH5IuQs9xjvVhjNci2bJDhNPiaPjNMPbhlMo1kVha
   JyyLhTmWHwXLU8h9PqhuJ8UyXrl/SbFvzDX2R0qsA7TFkQf0eL94Gz68u
   Y3LOxGN8NC0+oyz6eoaQFnnKXMG97ZzVQjg+wKtj+kd8cYLUoAQwa81mT
   p7g52f+LuJRpMPaqN/s8SJLjnBf5AQl0wXnipBlEAEzUoNkc5aHKj6Yu8
   zRJo7LTTl5yIzlM23eODQNSrlJbQHJFBQfUz0DfkxiVDb63KwvauyxUa6
   g==;
X-IronPort-AV: E=Sophos;i="5.85,294,1624291200"; 
   d="scan'208";a="180561591"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2021 14:04:19 +0800
IronPort-SDR: bGIbeJUJOiWxsRev1fVww2jJH9fExfWXETS6n7GO8cDeMKJucBHZVA84JqAFdmqxNlcZ2LOeqL
 FHs9Jg993EfBUyKPbfdiXwm/cD3Zpezn8Y7HICLCuiYtcVNF7EJe97ztYXBG49kDJIuRi8aKHZ
 4Z2Rs+z8QxpZA4Igee1gVlnA7oChkxnr6MV1SPGivr3zarZUtGxwaaVF+yBxEn3KruvgEc97zL
 50f01NtQGWQLMrGL8jc/DoKEEc6ptExTTmNV1W44VoNLRWKTxjDmGyW2CY/3SZpMiGKPGY9cGf
 /FMFYgf04xZ6E7X6VxvDI15a
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 22:40:41 -0700
IronPort-SDR: YAi/nDJnLjP7qxAo/IT3hy/5nG3jhU1Pnt20pooO1886HajueAk5olK45RXpJHNs17VO4kth59
 Nb5jIkZuBYIWO0y8FQ1+gcMtSZrjz4Qn5W6joZfz0l8neC+nUVqEuqL2LZ53ohFamMDR8WD4QN
 LvhT9M4s9qtoqz2JARlnwEMRiNExObWp7CKjAOWyuZd+XNXs+f/KjU86Vlm3X6GGIx/NUbB7eP
 WgO4C1bKhs5BYyHmXgZbIdUo13Lr/k79ZGgKrko2qsql5mdnheGJ7CJbs0HgXTQ4kItho3s+Fp
 8Vg=
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.225.32.116])
  by uls-op-cesaip02.wdc.com with ESMTP; 14 Sep 2021 23:04:15 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v7 0/2] Add temperature notification support
Date:   Wed, 15 Sep 2021 09:04:05 +0300
Message-Id: <20210915060407.40-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v6 -> v7:
 - some more useless initializations
 
v5 -> v6:
 - remove useless initializations
 
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

[1] https://lore.kernel.org/lkml/1582450522-13256-1-git-send-email-avi.shchislowski@wdc.com/


Avri Altman (2):
  scsi: ufs: Probe for temperature notification support
  scsi: ufs: Add temperature notification exception handling

 drivers/scsi/ufs/Kconfig     |   9 ++
 drivers/scsi/ufs/Makefile    |   1 +
 drivers/scsi/ufs/ufs-hwmon.c | 210 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       |   7 ++
 drivers/scsi/ufs/ufshcd.c    |  47 ++++++++
 drivers/scsi/ufs/ufshcd.h    |  20 ++++
 6 files changed, 294 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-hwmon.c

-- 
2.17.1

