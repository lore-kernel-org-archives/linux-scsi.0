From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: [PATCH] retry HARDWARE ERROR for IBM ESS
Date: Fri, 19 Nov 2004 18:50:50 +0100
Message-ID: <OFEBA9F7AA.4CED279D-ONC1256F51.00512489-C1256F51.0062A4A4@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:23236 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261512AbUKSRuy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 12:50:54 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id iAJHoovU227818
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 17:50:50 GMT
Received: from d12ml067.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iAJHorug113398
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 18:50:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org





Under certain conditions IBM's Enterprise Storage Server returns sense data
HARDWARE ERROR - INTERNAL TARGET FAILURE, while it wants the OS
to retry the very command.
Although this is apparently a firmware issue (ABORTED COMMAND would be
an appropriate choice), a Linux workaround would be needed to handle it.
It doesn't look like we'll ever get hold of a firmware fix for the model
addressed
by the patch below.

Martin

Signed-off-by: Martin Peschke <mpeschke@de.ibm.com>

--- linux-2.6/drivers/scsi/scsi_error.c   2004-11-19 18:38:45.000000000 +0000
+++ linux-2.6/drivers/scsi/scsi_error.c   2004-11-19 18:39:04.000000000 +0000
@@ -325,10 +325,16 @@
      case MEDIUM_ERROR:
            return NEEDS_RETRY;

+     case HARDWARE_ERROR:
+           if ((strncmp(SCpnt->device->vendor, "IBM", 3) == 0) &&
+               (strncmp(SCpnt->device->model, "2105", 4) == 0))
+                 return NEEDS_RETRY;
+           else
+                 return SUCCESS;
+
      case ILLEGAL_REQUEST:
      case BLANK_CHECK:
      case DATA_PROTECT:
-     case HARDWARE_ERROR:
      default:
            return SUCCESS;
      }

