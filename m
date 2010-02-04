From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 26/30] hpsa: Fix hpsa_find_scsi_entry so that it doesn't try
	to dereference NULL pointers
Date: Thu, 04 Feb 2010 08:43:36 -0600
Message-ID: <20100204144336.10406.60034.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:32079 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab0BDOks (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 09:40:48 -0500
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: Fix hpsa_find_scsi_entry so that it doesn't try to dereference NULL pointers

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 42295c4..2764cb6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -776,6 +776,8 @@ static int hpsa_scsi_find_entry(struct hpsa_scsi_dev_t *needle,
 #define DEVICE_CHANGED 1
 #define DEVICE_SAME 2
 	for (i = 0; i < haystack_size; i++) {
+		if (haystack[i] == NULL) /* previously removed. */
+			continue;
 		if (SCSI3ADDR_EQ(needle->scsi3addr, haystack[i]->scsi3addr)) {
 			*index = i;
 			if (device_is_the_same(needle, haystack[i]))

