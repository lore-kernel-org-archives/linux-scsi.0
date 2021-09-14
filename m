Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FE4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 20:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CEBD60F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 20:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhINUaL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 16:30:11 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4036 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbhINU3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 16:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631651277; x=1663187277;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ny29silVVPKn8NkyWDpQYWLmWqSTs10eyweqNshHG/Y=;
  b=jp+1pGwlx72jar17KLpfD3A3WAsm9oahFUMdcKyaBsDwdSnh/Hsbc3s0
   ZNCgNxWyTNzqQCAV0xrk+EX30ULaeo05P6cscLHGE7SSfYTR5CkYE6I1M
   Zm3twfYoPw7WDJC1F/pk8R/X4h8be6OUtZRS/q1BiBem4CaqP0u+jx8z5
   KNTCJVBqww733bGft5RWmhBue7WY1vJYMew6yXNhdqVEI8uHVZsYWmY3/
   mRAiE6pAp8I4ER9FOH1YeLN8TP98JaTPkh/Y4uGjxNT5MTLfrjBEt7O20
   o7u1cgHPJpoM8x6b3aPLI0AeDkLKk6xnU9Sm2WUDSouSKMvSzzF5fNG01
   A==;
X-IronPort-AV: E=Sophos;i="5.85,292,1624291200"; 
   d="scan'208";a="180525214"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2021 04:27:57 +0800
IronPort-SDR: TQKHTDpB4jxP5c/abCac37U3ZeXt6DjnG81JX4AJwzQ+jgSdgB+po7SkV1Hil0V1fA2OE9JD7/
 L+n9ifYdt11w/XugeOkmlw4eLMekXmnrM0793BgF7Pi4mlvPCthoSZM/CwMpkCyot1Dz9J/V19
 /vkQff+iGWk4ZTUmNO8YK6amD6Xvy7QOpZVt87Tist9/YN1kJh/UAbFLv2/POEENwIR4nashoi
 95kM+guwmTySmiNIby8+Xyj5/ohJWP2XunlquMTNx1R3cOpKodrDRxWeVdFuteMhfrVx203a78
 SZSe9+Hcdmh1rUyJoluUf1GE
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 13:02:46 -0700
IronPort-SDR: 45n98BSFdKgMZOQtB0Zc5Ahd8Ur+7tDD+sxvbYqiKtJHPD5CAUjQKjjRyGRnZ3jGnuLHpgKudj
 IgBy9LyKdWOEKOn2H5EKmUzykxgM0kdOhFLfclhuXrpyVYVwIzkB+Qeotj1F2xpZrXeBDnpLz7
 /pF0FnKS5ztIh461JxZiDUwNu9RLrOuvP4Wfs4tuZK4Qi6crwlQFKKE4TYHEjVZ1jn3kdOnDJy
 hp6fRlEZLyxjR0KISBUkfu2bto/EbB8uSJlj3qREZ3V0XWs7Pm4OG28QoEd5fDbI7Y9BzY7cHO
 UWE=
WDCIronportException: Internal
Received: from h72zxy2.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.116])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Sep 2021 13:27:54 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v6 0/2] Add temperature notification support
Date:   Tue, 14 Sep 2021 23:27:29 +0300
Message-Id: <20210914202731.5242-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
 drivers/scsi/ufs/ufs-hwmon.c | 213 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       |   7 ++
 drivers/scsi/ufs/ufshcd.c    |  47 ++++++++
 drivers/scsi/ufs/ufshcd.h    |  20 ++++
 6 files changed, 297 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-hwmon.c

-- 
2.17.1

