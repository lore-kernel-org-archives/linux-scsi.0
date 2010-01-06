From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: BSG - 32 bit application running on 64 bit kernel
Date: Wed, 6 Jan 2010 15:57:35 -0800
Message-ID: <DE68D24E-3326-4BB6-90F7-D4F58EC86C16@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:18232 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab0AFX5g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2010 18:57:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Smart@Emulex.Com Smart" <James.Smart@Emulex.Com>, LinuxSCSI <linux-scsi@vger.kernel.org>
Cc: Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Hi James,

Running  32 bit BSG application on a 64 bit kernel fails because of   
mismatch in fc_bsg_request structure elements. Packing the  
fc_bsg_request structure solves the issue. Please find the changes  
below. Can u please review.

Thanks,
Giridhar Malavali


The 32bit kernel does not add padding bytes in the fc_bsg_request  
structure
whereas the 64bit kernel adds padding bytes in the fc_bsg_request  
structure.
Due to this, structure elements gets mismatched with 32bit application  
and
64bit kernel.
To resolve this, used packed modifier to avoid adding padding bytes.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
---
include/scsi/scsi_bsg_fc.h |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_bsg_fc.h b/include/scsi/scsi_bsg_fc.h
index a4b2333..00e50ff 100644
--- a/include/scsi/scsi_bsg_fc.h
+++ b/include/scsi/scsi_bsg_fc.h
@@ -292,7 +292,7 @@ struct fc_bsg_request {
                struct fc_bsg_rport_els         r_els;
                struct fc_bsg_rport_ct          r_ct;
        } rqst_data;
-};
+} __attribute__ ((packed));
