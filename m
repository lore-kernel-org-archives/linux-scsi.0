From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/2] hpsa: add the Smart Array 5i to the kdump blacklist
Date: Mon, 28 Nov 2011 15:39:55 +0100
Message-ID: <4ED39D3B.9080305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab1K1Okh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2011 09:40:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>

The '5i' controller freezes when a kdump is attemted.
This patch admits it and adds the controller
to the unresetable list.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

---
 drivers/scsi/hpsa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e011937..b21491b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -292,12 +292,14 @@ static u32 unresettable_controller[] = {
 	0x3215103C, /* Smart Array E200i */
 	0x3237103C, /* Smart Array E500 */
 	0x323D103C, /* Smart Array P700m */
+	0x40800E11, /* Smart Array 5i */
 	0x409C0E11, /* Smart Array 6400 */
 	0x409D0E11, /* Smart Array 6400 EM */
 };
 
 /* List of controllers which cannot even be soft reset */
 static u32 soft_unresettable_controller[] = {
+	0x40800E11, /* Smart Array 5i */
 	/* Exclude 640x boards.  These are two pci devices in one slot
 	 * which share a battery backed cache module.  One controls the
 	 * cache, the other accesses the cache through the one that controls
-- 
1.7.6.4



