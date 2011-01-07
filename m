From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/3] hpsa: avoid leaking stack contents to userland
Date: Fri, 07 Jan 2011 10:55:53 -0600
Message-ID: <20110107165553.14259.46247.stgit@beardog.cce.hp.com>
References: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:39870 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab1AGQzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 11:55:54 -0500
In-Reply-To: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com

From: Vasiliy Kulikov <segooon@gmail.com>

memset arg64 to zero in the passthrough ioctls to avoid leaking contents
of kernel stack memory to userland via uninitialized padding fields
inserted by the compiler for alignment reasons.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5828bcb..959eeb2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2310,6 +2310,7 @@ static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |= copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
 			   sizeof(arg64.LUN_info));
@@ -2346,6 +2347,7 @@ static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |= copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
 			   sizeof(arg64.LUN_info));

