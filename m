From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 47] drivers/scsi/megaraid.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:34:14 +0200
Message-ID: <200707312034.15089.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, megaraidlinux@lsi.com
List-Id: linux-scsi@vger.kernel.org

This patch does kmalloc + memset conversion to kzalloc and adds missing check for
kzaloc return value.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/megaraid.c | 116109 -> 116094 (-15 bytes)
 drivers/scsi/megaraid.o | 257872 -> 257772 (-100 bytes)

 drivers/scsi/megaraid.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/megaraid.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/megaraid.c	2007-07-31 11:11:58.000000000 +0200
@@ -4408,8 +4408,10 @@ mega_internal_command(adapter_t *adapter
 	scmd = &adapter->int_scmd;
 	memset(scmd, 0, sizeof(Scsi_Cmnd));

-	sdev = kmalloc(sizeof(struct scsi_device), GFP_KERNEL);
-	memset(sdev, 0, sizeof(struct scsi_device));
+	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	if (!sdev)
+		return -ENOMEM;
+
 	scmd->device = sdev;

 	scmd->device->host = adapter->host;
