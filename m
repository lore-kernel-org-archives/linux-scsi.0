From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 06/10] aacraid: Fix for aac_command_thread hang
Date: Mon, 25 Apr 2016 23:31:57 -0700
Message-ID: <20160426063157.28402.81341.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0064.outbound.protection.outlook.com ([157.56.111.64]:50989
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752552AbcDZGgQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:36:16 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

Typically under error conditions, it is possible for aac_command_thread()
to miss the wakeup from kthread_stop() and go back to sleep, causing it
to hang aac_shutdown.

In the observed scenario, the adapter is not functioning correctly and so
aac_fib_send() never completes (or time-outs depending on how it was
called). Shortly after aac_command_thread() starts it performs
aac_fib_send(SendHostTime) which hangs. When aac_probe_one
/aac_get_adapter_info send time outs, kthread_stop is called which breaks
the command thread out of it's hang.

The code will still go back to sleep in schedule_timeout() without
checking kthread_should_stop() so it causes aac_probe_one to hang until
the schedule_timeout() which is 30 minutes.

Fixed by: Adding another kthread_should_stop() before schedule_timeout()
Cc: stable@vger.kernel.org

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 725aa78..bb7988d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1996,6 +1996,10 @@ int aac_command_thread(void *data)
 		if (difference <= 0)
 			difference = 1;
 		set_current_state(TASK_INTERRUPTIBLE);
+
+		if (kthread_should_stop())
+			break;
+
 		schedule_timeout(difference);
 
 		if (kthread_should_stop())

