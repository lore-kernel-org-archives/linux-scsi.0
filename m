From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH] qla2xxx data transfer direction
Date: Thu, 13 May 2004 10:12:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04May13.101302edt.332201@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:62471 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S264229AbUEMONP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 10:13:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

I am using a QLogic QLA2200 under Linux 2.4.26 with qla2200.o version
6.06.10 from QLogic's website.

The qla2200 driver doesn't do auto-sense if the sense length is greater
than 32 bytes.  When a command fails with check condition and the driver
doesn't do auto-sense, the SCSI midlayer sends a request sense command
with scsi_cmnd::cmnd holding the request sense CDB and
scsi_cmnd::data_cmnd holding the CDB of the failed command.  The qla2200
driver determines the expected data direction by looking at
scsi_cmnd::data_cmd[0].  If the original command was a data out command
(e.g. mode select), then the qla2200 driver sets the data direction for
the request sense command incorrectly, causing it to fail.  The midlayer
gets into an endless loop trying to retrieve the sense data.

The following patch fixes the problem.  Note that there are a few other
uses of scsi_cmnd::data_cmnd in qla2x00.c under #if VSA, but I'm not
sure if they are correct or not.  Someone else will have to determine
that.

Anthony J. Battersby
Cybernetics

--- drivers/scsi/qla2xxx/qla2x00.c.orig	Thu May 13 09:24:22 2004
+++ drivers/scsi/qla2xxx/qla2x00.c	Thu May 13 09:29:05 2004
@@ -9642,7 +9642,7 @@
 		if (1)
 #endif //__VMWARE__
 		{
-			switch (cmd->data_cmnd[0]) {
+			switch (cmd->cmnd[0]) {
 				case FORMAT_UNIT:
 				case WRITE_6:
 				case MODE_SELECT:
@@ -9666,7 +9666,7 @@
 			}
 		}
 #else
-		switch (cmd->data_cmnd[0]) {
+		switch (cmd->cmnd[0]) {
 			case FORMAT_UNIT:
 			case WRITE_6:
 			case MODE_SELECT:
@@ -10173,7 +10173,7 @@
 		if (1)
 #endif //__VMWARE__
 		{
-			switch (cmd->data_cmnd[0]) {
+			switch (cmd->cmnd[0]) {
 				case FORMAT_UNIT:
 				case WRITE_6:
 				case MODE_SELECT:
@@ -10197,7 +10197,7 @@
 			}
 		}
 #else
-		switch (cmd->data_cmnd[0]) {
+		switch (cmd->cmnd[0]) {
 			case FORMAT_UNIT:
 			case WRITE_6:
 			case MODE_SELECT:


