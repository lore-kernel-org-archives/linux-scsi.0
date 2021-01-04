Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239E4C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 23:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E09E6225AC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 23:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhADXmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 18:42:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADXmX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 18:42:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA442253A;
        Mon,  4 Jan 2021 23:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609803702;
        bh=HcjfSk9jtUTttCAPsHGyHCv++22UOGHXgsPS0pGqMi8=;
        h=From:To:Cc:Subject:Date:From;
        b=oGa41UtBkdLJEHhmfTD7zAyxVAeH4iZic7396UY70u8ZgQKlOwxDTa+ryHPcNItW5
         tfQ4I9wwN1ygbMPMZsI8LJpA34tBt70mA8W+ZofJ+mJ6Du9IZWdB13l3ahwmfznFWR
         dsVKcB/+qL+Cv24gCwLZQ5XujZwyZwEjEcFglyrhpLapIib6SJL1YMm/0HQTcnsCW3
         2/PUlah9K+SU74ypbxHsGeXDbzSaXlyyUpp8fScArEG+dDUhcRtxvKahi3atvUSB+A
         xGEWBHVgh7QTXURYgP+N+k7Rmtbgs51065dJ9g9tpDxDCw7R4Kx19XHt/EUmAX8Ua4
         mVsFwKtjCdJ5g==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Phil Oester <kernel@linuxace.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Jason Yan <yanaijie@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression
Date:   Tue,  5 Jan 2021 00:41:04 +0100
Message-Id: <20210104234137.438275-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Phil Oester reported that a fix for a possible buffer overrun that I
sent caused a regression that manifests in this output:

 Event Message: A PCI parity error was detected on a component at bus 0 device 5 function 0.
 Severity: Critical
 Message ID: PCI1308

The original code tried to handle the sense data pointer differently
when using 32-bit 64-bit DMA addressing, which would lead to a 32-bit
dma_addr_t value of 0x11223344 to get stored

32-bit kernel:       44 33 22 11 ?? ?? ?? ??
64-bit LE kernel:    44 33 22 11 00 00 00 00
64-bit BE kernel:    00 00 00 00 44 33 22 11

or a 64-bit dma_addr_t value of 0x1122334455667788 to get stored as

32-bit kernel:       88 77 66 55 ?? ?? ?? ??
64-bit kernel:       88 77 66 55 44 33 22 11

In my patch, I tried to ensure that the same value is used on both
32-bit and 64-bit kernels, and picked what seemed to be the most sensible
combination, storing 32-bit addresses in the first four bytes (as 32-bit
kernels already did), and 64-bit addresses in eight consecutive bytes
(as 64-bit kernels already did), but evidently this was incorrect.

Always storing the dma_addr_t pointer as 64-bit little-endian,
i.e. initializing the second four bytes to zero in case of 32-bit
addressing, apparently solved the problem for Phil, and is consistent
with what all 64-bit little-endian machines did before.

I also checked in the history that in previous versions of the code,
the pointer was always in the first four bytes without padding, and that
previous attempts to fix 64-bit user space, big-endian architectures
and 64-bit DMA were clearly flawed and seem to have introduced made
this worse.

Reported-by: Phil Oester <kernel@linuxace.com>
Fixes: 381d34e376e3 ("scsi: megaraid_sas: Check user-provided offsets")
Fixes: 107a60dd71b5 ("scsi: megaraid_sas: Add support for 64bit consistent DMA")
Fixes: 94cd65ddf4d7 ("[SCSI] megaraid_sas: addded support for big endian architecture")
Fixes: 7b2519afa1ab ("[SCSI] megaraid_sas: fix 64 bit sense pointer truncation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6e4bf05c6d77..3b574c453414 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8205,11 +8205,9 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 			goto out;
 		}
 
+		/* always store 64 bits regardless of addressing */
 		sense_ptr = (void *)cmd->frame + ioc->sense_off;
-		if (instance->consistent_mask_64bit)
-			put_unaligned_le64(sense_handle, sense_ptr);
-		else
-			put_unaligned_le32(sense_handle, sense_ptr);
+		put_unaligned_le64(sense_handle, sense_ptr);
 	}
 
 	/*
-- 
2.29.2

