Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565B4C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 16:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F0A61131
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 16:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhDOQmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 12:42:23 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:23726 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhDOQmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 12:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618504920; x=1650040920;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=roNx1u05ZO1ZhfvWONW/ALpZ47d58IBiS726lrr8u/w=;
  b=xU6D83aBi4J/mzpmgz1Fm4ao41d84AR342U6ZZuyX5Gcd9XDrcd5lsC2
   9mW3LKOgKtQKXUkpTzJAqWjKmAnrXi8dVScHpxWqSIk/GIR0SJuQOfqMq
   pdFD+cxDYFQiSmYoS0qVnZJa4AVNTCribTgzbGJXXJYv6GlxAeRmze4BZ
   kz1QtOj9u2tPq4k9fu7mFDkb+K38ha9TEP8ONEOeU7K8k4Zg/de48zscs
   C6jpfNG1LsbJG4ohbHgs/Ea0fNU25j3PuE64zNwCSjbInycJ2Yqisz7OZ
   YaIfBfT51Y9KvyU/7WnMf+14BQYUwL72n0//DAgxmTk+1+V4X3bcQkUA9
   A==;
IronPort-SDR: XAe4G01Tfr5zG3GKkY0uiLGuyIzhyFXZJKDud1mARsFJ5z29nnD6viCkQThPBJurSpzwh3iTdu
 IV24GU6fGJ/L0F6JhhY1pOP2G2Lir1A+QVVDRgE6FCcgVFt+SDJqiCYHQrGLm6wCo1Zp52bzbE
 m/nOD6DbUD4hRdmor4zlHRQhWhV/xAAxqKP59jsY6+T3soyNwUmXemc9cqUq1f+sC/YybzPEvM
 3Rybl+26dHLbGNeOgqEk0tfFaMCEHQwmxBNlV6LX4i/CRtI/z8ZdnZCQEgffgrDUeapta9r+DN
 s4Q=
X-IronPort-AV: E=Sophos;i="5.82,225,1613458800"; 
   d="scan'208";a="113734473"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 09:41:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 09:41:59 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 09:41:58 -0700
Subject: [PATCH 0/2] smartpqi fix static checker issues
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 15 Apr 2021 11:41:58 -0500
Message-ID: <161850488487.7302.7018870513204678832.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Peterson's 5.13/scsi-queue tree

This set corrects two static checker warnings found by
Dan Carpenter <dan.carpenter@oracle.com>

smartpqi-fix-blocks_per_row-static-checker-issue
 Link: https://lore.kernel.org/linux-scsi/YG%2F5kWHHAr7w5dU5@mwanda/
 Fixes: 6702d2c40f31 ("scsi: smartpqi: Add support for RAID5 and RAID6 writes")
        Using rmd->blocks_per_row as a divisor without checking
        it for 0 first.
 The variable blocks_per_row is used as a divisor in many
 raid_map calculations. This can lead to a divide by 0.
 This patch prevents a possible divide by 0. If the member
 is 0, return PQI_RAID_BYPASS_INELIGIBLE before any division is
 performed. The current check for a non-0 value was after multiple
 divisions were performed.

smartpqi-fix-device-pointer-variable-reference
 Link: ("https://www.mail-archive.com/kbuild@lists.01.org/msg06329.html")
 Fixes: ec504b23df9d ("[304/324] scsi: smartpqi: Add phy ID support for the physical drives")
        drivers/scsi/smartpqi/smartpqi_sas_transport.c:97
        pqi_sas_port_add_rphy() warn: variable dereferenced before
        check 'pqi_sas_port->device' (see line 95)
 In function pqi_sas_port_add_rphy there is a pointer dereference
 without a check for NULL value. Correct this by moving the
 pointer dereference after the check for non-NULL value.

Note: I could not find the e-mail for
      smartpqi-fix-device-pointer-variable-reference issue in
      lore.kernel.org so I used mail-archive.com.
      It may have not been forwarded to lore.kernel.org. Not sure.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>

---

Don Brace (2):
      smartpqi: fix blocks_per_row static checker issue
      smartpqi: fix device pointer variable reference static checker issue


 drivers/scsi/smartpqi/smartpqi_sas_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--
Signature
