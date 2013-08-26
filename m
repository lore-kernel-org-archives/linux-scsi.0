From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 2/9] target: Make spc_parse_naa_6h_vendor_specific non static
Date: Mon, 26 Aug 2013 22:03:01 +0000
Message-ID: <1377554588-28394-3-git-send-email-nab@daterainc.com>
References: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch makes spc_parse_naa_6h_vendor_specific() available to
other target code, which is required by EXTENDED_COPY when comparing
the received NAA WWN device identifer for locating the associated
se_device backend.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Zach Brown <zab@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_spc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ed7077a..bd16a93 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -126,8 +126,8 @@ spc_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
 	return 0;
 }
 
-static void spc_parse_naa_6h_vendor_specific(struct se_device *dev,
-		unsigned char *buf)
+void spc_parse_naa_6h_vendor_specific(struct se_device *dev,
+				      unsigned char *buf)
 {
 	unsigned char *p = &dev->t10_wwn.unit_serial[0];
 	int cnt;
-- 
1.7.2.5
