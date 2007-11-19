From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering
 guarantees required by e.g. journaling filesystems
Date: Mon, 19 Nov 2007 15:22:17 -0600
Message-ID: <4741FE89.4020307@cs.wisc.edu>
References: <bug-9405-10286@http.bugzilla.kernel.org/>	 <20071119125040.9f6eb1e2.akpm@linux-foundation.org> <1195505766.3963.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010004090502060900010503"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54806 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbXKSVXj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 16:23:39 -0500
In-Reply-To: <1195505766.3963.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

This is a multi-part message in MIME format.
--------------010004090502060900010503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Mon, 2007-11-19 at 12:50 -0800, Andrew Morton wrote:
>> On Mon, 19 Nov 2007 05:44:01 -0800 (PST)
>> bugme-daemon@bugzilla.kernel.org wrote:
>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=9405
>>>
>>>            Summary: iSCSI does not implement ordering guarantees required by
>>>                     e.g. journaling filesystems
>>>            Product: IO/Storage
>>>            Version: 2.5
>>>      KernelVersion: 2.6.23.1
>>>           Platform: All
>>>         OS/Version: Linux
>>>               Tree: Mainline
>>>             Status: NEW
>>>           Severity: high
>>>           Priority: P1
>>>          Component: SCSI
>>>         AssignedTo: io_scsi@kernel-bugs.osdl.org
>>>         ReportedBy: bart.vanassche@gmail.com
>>>
>>>
>>> Most recent kernel where this bug did not occur: (new issue)
>>> Distribution: any
>>> Hardware Environment: (does not apply)
>>> Software Environment: (does not apply) 
>>> Problem Description: The sd (SCSI disk) driver ignores block device barriers
>>> (REQ_HARDBARRIER). The iSCSI code in the kernel sends all iSCSI commands with
>>> flag ISCSI_ATTR_SIMPLE to the iSCSI target. This means that the target may
>>> reorder these commands. Since a.o. correct operation of journaling filesystems
>>> depends on being able to enforce the order of certain block write operations,
>>> not enforcing write ordering is a bug. This can be solved by either adding
>>> support for REQ_HARDBARRIER in the sd device or by replacing ISCSI_ATTR_SIMPLE
>>> by ISCSI_ATTR_ORDERED.
>>>
>>> Steps to reproduce: Source reading of drivers/scsi/sd.c and
>>> drivers/scsi/libiscsi.c.
>>>
>>> References: SCSI Architecture Model - 3, paragraph 8.6
>>> (http://www.t10.org/ftp/t10/drafts/sam3/sam3r14.pdf).
>>>
>> (does iscsi have a maintainer?)
> 
> Yes, mike christie
> 
> And please close this as invalid.  FS ordering guarantees in linux
> aren't done via ordered tags.
> 

I had a related question. I was working on the attached patch for soe 
other testing (patch made against scsi-rc-fixes, but is not stable so do 
not apply), which does the scsi_populate_tag_msg conversion from MSG_* 
to ISCSI_ATTR and sets the proper iscsi bits.

If I do this patch where I call scsi_activate_tcq on a device and that 
concertsion, does this require that my driver not reorder commands? I 
was just a little worried on some of the error handling paths where we 
requeue commands to the mid layer.

--------------010004090502060900010503
Content-Type: text/x-patch;
 name="add-tcq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-tcq.patch"

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 57ce225..d256cf3 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -37,6 +37,7 @@
 #include <linux/scatterlist.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
@@ -2211,8 +2212,17 @@ static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 
 static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
 {
+	int depth = 1, tag = 0;
+
 	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
 	blk_queue_dma_alignment(sdev->request_queue, 0);
+
+	if (sdev->tagged_supported) {
+		scsi_activate_tcq(sdev, ISCSI_DEF_CMD_PER_LUN);
+		depth = ISCSI_DEF_CMD_PER_LUN;
+		tag = MSG_ORDERED_TAG;
+	}
+	scsi_adjust_queue_depth(sdev, tag, depth);
 	return 0;
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8b57af5..7e13a03 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -122,6 +122,27 @@ void iscsi_prep_unsolicit_data_pdu(struct iscsi_cmd_task *ctask,
 }
 EXPORT_SYMBOL_GPL(iscsi_prep_unsolicit_data_pdu);
 
+static uint32_t iscsi_command_attr(struct scsi_cmnd *cmd)
+{
+	unsigned int attr = ISCSI_ATTR_UNTAGGED;
+	char msg[2];
+
+	if (scsi_populate_tag_msg(cmd, msg) == 2) {
+		switch (msg[0]) {
+		case MSG_SIMPLE_TAG:
+			attr = ISCSI_ATTR_SIMPLE;
+			break;
+		case MSG_HEAD_TAG:
+			attr = ISCSI_ATTR_HEAD_OF_QUEUE;
+			break;
+		case MSG_ORDERED_TAG:
+			attr = ISCSI_ATTR_ORDERED;
+			break;
+		}
+	}
+	return attr;
+}
+
 /**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
  * @ctask: iscsi cmd task
@@ -137,7 +158,8 @@ static void iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	struct scsi_cmnd *sc = ctask->sc;
 
         hdr->opcode = ISCSI_OP_SCSI_CMD;
-        hdr->flags = ISCSI_ATTR_SIMPLE;
+        hdr->flags = hdr->flags = (iscsi_command_attr(sc) &
+						ISCSI_FLAG_CMD_ATTR_MASK);
         int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
         hdr->itt = build_itt(ctask->itt, conn->id, session->age);
         hdr->data_length = cpu_to_be32(scsi_bufflen(sc));

--------------010004090502060900010503--
