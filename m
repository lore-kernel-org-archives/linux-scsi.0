From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Eliminate signals entirely from the mid-layer
Date: Sat, 11 Jan 2003 10:44:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301111544.h0BFiQD02270@localhost.localdomain>
References: <wrlk@riede.org>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_-2790530500"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA01963
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jan 2003 07:44:34 -0800
In-Reply-To: Message from Willem Riede <wrlk@riede.org>
   of "Sat, 11 Jan 2003 09:23:11 EST." <20030111142311.GQ1378@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_-2790530500
Content-Type: text/plain; charset=us-ascii

wrlk@riede.org said:
> When I apply your patch, rmmod ide-scsi hangs. This is my log: 

Well, we all have these embarassing things we forget from time to time (like 
remembering actually to tell the daemon to die...).  Can you try the attached 
as an additional patch?

Thanks,

James


--==_Exmh_-2790530500
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== drivers/scsi/hosts.c 1.43 vs edited =====
--- 1.43/drivers/scsi/hosts.c	Fri Jan 10 16:13:38 2003
+++ edited/drivers/scsi/hosts.c	Sat Jan 11 10:39:20 2003
@@ -338,6 +338,7 @@
 	if (shost->ehandler) {
 		DECLARE_COMPLETION(sem);
 		shost->eh_notify = &sem;
+		shost->eh_kill = 1;
 		up(shost->eh_wait);
 		wait_for_completion(&sem);
 		shost->eh_notify = NULL;

--==_Exmh_-2790530500--


