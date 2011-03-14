From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/13] qla4xxx: Add support for ql4xmaxqdepth command line
 parameter
Date: Sun, 13 Mar 2011 22:24:38 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B150E@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:13912
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192Ab1CNFYp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:24:45 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

This provides the flexibility to modify the qdepth based on different
target devices to make the best use of system resources.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 59c5552..c7c675b 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -56,6 +56,11 @@ MODULE_PARM_DESC(ql4xenablemsix,
                " 2 = enable MSI interrupt mechanism.");

 #define QL4_DEF_QDEPTH 32
+static int ql4xmaxqdepth = QL4_DEF_QDEPTH;
+module_param(ql4xmaxqdepth, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ql4xmaxqdepth,
+               "Maximum queue depth to report for target devices.\n"
+               " Default: 32.");

 /*
  * SCSI host template entry points
@@ -1912,10 +1917,15 @@ static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 {
        struct iscsi_cls_session *sess = starget_to_session(sdev->sdev_target);
        struct ddb_entry *ddb = sess->dd_data;
+       int queue_depth = QL4_DEF_QDEPTH;

        sdev->hostdata = ddb;
        sdev->tagged_supported = 1;
-       scsi_activate_tcq(sdev, QL4_DEF_QDEPTH);
+
+       if (ql4xmaxqdepth != 0 && ql4xmaxqdepth <= 0xffffU)
+               queue_depth = ql4xmaxqdepth;
+
+       scsi_activate_tcq(sdev, queue_depth);
        return 0;
 }

--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

