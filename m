From: Libo Chen <libo.chen@huawei.com>
Subject: Re: [PATCH v2] scsi: megaraid: check kzalloc
Date: Tue, 4 Jun 2013 17:33:56 +0800
Message-ID: <51ADB484.3060404@huawei.com>
References: <519ECEF1.9060804@huawei.com> <519F3592.4090207@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:59435 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3FDJfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jun 2013 05:35:11 -0400
In-Reply-To: <519F3592.4090207@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com, JBottomley@parallels.com
Cc: Libo Chen <chenlibo.3@gmail.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com, aradford@gmail.com, Li Zefan <lizefan@huawei.com>, Santosh Y <santoshsy@gmail.com>, Tomas Henzl <thenzl@redhat.com>


we should check kzalloc, avoid to hit oops

Change from v1:
- put kzalloc outside of mutex

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/scsi/megaraid.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 846f475..cc599cc 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4150,6 +4150,12 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	if (!scmd)
 		return -ENOMEM;

+	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	if (!sdev) {
+		scsi_free_command(GFP_KERNEL, scmd);
+		return -ENOMEM;
+	}
+
 	/*
 	 * The internal commands share one command id and hence are
 	 * serialized. This is so because we want to reserve maximum number of
@@ -4160,7 +4166,6 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	scb = &adapter->int_scb;
 	memset(scb, 0, sizeof(scb_t));

-	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
 	scmd->device = sdev;

 	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
-- 
1.7.1


