From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [rob@osinvestor.com: Re: SCSI broken]
Date: Wed, 5 Mar 2003 10:56:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305185648.GF1090@beaverton.ibm.com>
References: <20030305144336.GA13722@osinvestor.com> <20030305180346.GB1090@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030305180346.GB1090@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Rob Radez <rob@osinvestor.com>, linux-scsi@vger.kernel.org

Rob,
	The patch below fixed a error handler problem on my system when
	I switch to using the old aic7xxx. Could you try it and let me
	know if it fixes your problem.

I had my list empty checks reversed if aborting and bus device reset
failed. The condition that causes the error handler to run is config
related and I cannot recreate your config with my equipment.

Mike Anderson [andmike@us.ibm.com] wrote:
> Rob,
> 	Would it possible for you to build with CONFIG_SCSI_LOGGING=y
> 	and boot with scsi_logging=1. Then send the output to me.  The
> 	output is quite noisy and if you do not have a serial connected
> 	the last messages maybe all that is needed. This would help
> 	narrow down the section in the diff.
> 
-andmike
--
Michael Anderson
andmike@us.ibm.com


=====
name:		00_scsi_error_ready_devs-1.diff
version:	2003-03-05.10:39:28-0800
against:	2.5.63

 scsi_error.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

=====
===== drivers/scsi/scsi_error.c 1.38 vs edited =====
--- 1.38/drivers/scsi/scsi_error.c	Sat Feb 22 08:17:01 2003
+++ edited/drivers/scsi/scsi_error.c	Wed Mar  5 10:14:22 2003
@@ -1490,9 +1490,9 @@
 			       struct list_head *work_q,
 			       struct list_head *done_q)
 {
-	if (scsi_eh_bus_device_reset(shost, work_q, done_q))
-		if (scsi_eh_bus_reset(shost, work_q, done_q))
-			if (scsi_eh_host_reset(work_q, done_q))
+	if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
+		if (!scsi_eh_bus_reset(shost, work_q, done_q))
+			if (!scsi_eh_host_reset(work_q, done_q))
 				scsi_eh_offline_sdevs(work_q, done_q);
 }
 

