From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5/5] [SCSI] scsi_dh_alua: add scalable ONTAP lun to dev list
Date: Wed,  5 Jan 2011 16:00:24 -0500
Message-ID: <1294261224-12599-6-git-send-email-snitzer@redhat.com>
References: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab1AEVBD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 16:01:03 -0500
In-Reply-To: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin George <marting@netapp.com>, Mike Christie <michaelc@cs.wisc.edu>

Currently NetApp's VID/PID details in the INQUIRY response shows up as
'NETAPP' and 'LUN'.  With upcoming scalable SAN ONTAP version on NetApp
controllers, the PID entry alone is being modified to 'LUN C-Mode' (to
distinguish current ONTAP LUNs from scalable ONTAP LUNs).

'LUN' would still suffice for matching 'LUN C-Mode' but best to
explicitly add these new NetApp LUNs to the device list.

Reported-by: Martin George <marting@netapp.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index c1fd09d..5b6f9ab 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -732,6 +732,7 @@ static const struct scsi_dh_devlist alua_dev_list[] = {
 	{"Pillar", "Axiom" },
 	{"Intel", "Multi-Flex"},
 	{"NETAPP", "LUN"},
+	{"NETAPP", "LUN C-Mode"},
 	{"AIX", "NVDISK"},
 	{"Promise", "VTrak"},
 	{NULL, NULL}
-- 
1.7.3.4

