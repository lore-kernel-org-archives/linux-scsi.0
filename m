From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: [PATCH RESEND] scsi: megaraid: check kzalloc
Date: Fri, 24 May 2013 17:40:34 +0800
Message-ID: <519F3592.4090207@huawei.com>
References: <519ECEF1.9060804@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <519ECEF1.9060804@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: megaraidlinux@lsi.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com, aradford@gmail.com, Li Zefan <lizefan@huawei.com>, Santosh Y <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org


we should check kzalloc, avoid to hit oops

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/scsi/megaraid.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

instead of checking scmd->device, sdev is more appropriate.

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 846f475..6b623cb 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4161,6 +4161,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	memset(scb, 0, sizeof(scb_t));

 	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	if (sdev) {
+		scsi_free_command(GFP_KERNEL, scmd);
+		return -ENOMEM;
+	}
 	scmd->device = sdev;

 	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
-- 
1.7.1
