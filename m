From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] iscsi: select CRYPTO and CRYPTO_CRC32C* by default
Date: Sun, 16 Jan 2011 00:06:39 -0800
Message-ID: <1295165199-28464-2-git-send-email-nab@linux-iscsi.org>
References: <1295165199-28464-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm24.bullet.mail.ac4.yahoo.com ([98.139.52.221]:29840 "HELO
	nm24.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751017Ab1APIHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Jan 2011 03:07:40 -0500
In-Reply-To: <1295165199-28464-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes LIO_TARGET to select CRYPTO, CRYPTO_CRC32C and
CRYPTO_CRC32C_INTEL by default to ensure that the crypto_alloc_hash()
calls in iscsi_login_setup_crypto() are able to function as expected.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/target/lio-target/Kconfig b/drivers/target/lio-target/Kconfig
index 1998ba3..5cbd9e3 100644
--- a/drivers/target/lio-target/Kconfig
+++ b/drivers/target/lio-target/Kconfig
@@ -1,5 +1,8 @@
 config LIO_TARGET
 	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
+	select CRYPTO
+	select CRYPTO_CRC32C
+	select CRYPTO_CRC32C_INTEL
 	help
 	Say Y here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
 	Target Mode Stack.
-- 
1.5.6.5

