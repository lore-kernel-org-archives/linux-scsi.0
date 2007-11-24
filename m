From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.24-rc3-mm1: I/O error, system hangs
Date: Sat, 24 Nov 2007 19:44:13 +0200
Message-ID: <1195926253.3195.16.camel@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	 <4744A6F2.4030302@free.fr>
	 <20071121144116.c932727b.akpm@linux-foundation.org>
	 <4746814F.80502@free.fr> <4746866B.5070207@suse.de>
	 <4746BB9D.2030508@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4746BB9D.2030508@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Laurent Riffard <laurent.riffard@free.fr>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Probing intermittent failures in Domain Validation, even with the fixes
applied leads me to the conclusion that there are further problems with
this commit:

commit fc5eb4facedbd6d7117905e775cee1975f894e79
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Nov 6 09:23:40 2007 +0100

    [SCSI] Do not requeue requests if REQ_FAILFAST is set
 
The essence of the problems is that you're causing REQ_FAILFAST to
terminate commands with error on requeuing conditions, some of which are
relatively common on most SCSI devices.  While this may be the correct
behaviour for multi-path, it's certainly wrong for the previously
understood meaning of REQ_FAILFAST, which was don't retry on error,
which is why domain validation and other applications use it to control
error handling, but don't expect to get failures for a simple requeue
are now spitting errors.

I honestly can't see that, even for the multi-path case, returning an
error when we're over queue depth is the correct thing to do (it may not
matter to something like a symmetrix, but an array that has a non-zero
cost associated with a path change, like a CPQ HSV or the AVT
controllers, will show fairly large slow downs if you do this).  Even if
this is the desired behaviour (and I think that's a policy issue),
DID_NO_CONNECT is almost certainly the wrong error to be sending back.

This patch fixes up domain validation to work again correctly, however,
I really think it's just a bandaid.  Do you want to rethink the above
commit?

James

Index: BUILD-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_lib.c	2007-11-24 11:25:20.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_lib.c	2007-11-24 11:26:22.000000000 -0600
@@ -1552,7 +1552,8 @@ static void scsi_request_fn(struct reque
 			break;
 
 		if (!scsi_dev_queue_ready(q, sdev)) {
-			if (req->cmd_flags & REQ_FAILFAST) {
+			if ((req->cmd_flags & REQ_FAILFAST) &&
+			    !(req->cmd_flags & REQ_PREEMPT)) {
 				scsi_kill_request(req, q);
 				continue;
 			}


