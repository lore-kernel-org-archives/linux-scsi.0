From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 04/10] aacraid: Relinquish CPU during timeout wait
Date: Mon, 25 Apr 2016 23:31:26 -0700
Message-ID: <20160426063126.28402.85984.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0080.outbound.protection.outlook.com ([157.56.111.80]:23130
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752473AbcDZGfo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:35:44 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

aac_fib_send has a special function case for initial commands during
driver initialization using wait < 0(pseudo sync mode). In this case,
the command does not sleep but rather spins checking for timeout.This
loop is calls cpu_relax() in an attempt to allow other processes/threads
to use the CPU, but this function does not relinquish the CPU and so the
command will hog the processor. This was observed in a KDUMP
"crashkernel" and that prevented the "command thread" (which is
responsible for completing the command from being timed out) from
starting because it could not get the CPU.

Fixed by replacing "cpu_relax()" call with "schedule()"
Cc: stable@vger.kernel.org

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 511bbc5..725aa78 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -637,10 +637,10 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 					}
 					return -EFAULT;
 				}
-				/* We used to udelay() here but that absorbed
-				 * a CPU when a timeout occured. Not very
-				 * useful. */
-				cpu_relax();
+				/*
+				 * Allow other processes / CPUS to use core
+				 */
+				schedule();
 			}
 		} else if (down_interruptible(&fibptr->event_wait)) {
 			/* Do nothing ... satisfy

