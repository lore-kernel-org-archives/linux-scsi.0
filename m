From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] 2.4.21 fix race condition in sg.c
Date: Fri, 27 Jun 2003 08:15:22 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFB707A.2060604@torque.net>
References: <002801c33bf6$24672940$e0019d89@cybernetics.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:35080 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263271AbTFZWBR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2003 18:01:17 -0400
In-Reply-To: <002801c33bf6$24672940$e0019d89@cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: linux-scsi@vger.kernel.org

Tony Battersby wrote:
> The function sg_cmd_done_bh() sets srp->done = 1 before setting other fields
> to be returned to userspace (such as srp->header.resid).  This is a race
> condition since other code assumes that done == 1 means that all fields to
> be returned to userspace (via read()) have already been set.  I am seeing
> this race condition manifest in a program that uses poll() to wait for any
> one of several outstanding commands to complete.  The symptom is that every
> once in a while the resid value returned for the command is 0 rather than
> the correct value, since poll() showed that the command was complete and
> read() returned the completion status for it before sg_cmd_done_bh() had
> gotten to the line "srp->header.resid = SCpnt->resid".
> 
> This patch against 2.4.21 fixes the problem.
> 
> --- drivers/scsi/sg.c.orig	Fri Jun 13 10:51:36 2003
> +++ drivers/scsi/sg.c	Thu Jun 26 11:07:28 2003
> @@ -1241,7 +1241,6 @@
>      SRpnt->sr_request.rq_dev = MKDEV(0, 0);  /* "sg" _disowns_ request blk
> */
> 
>      srp->my_cmdp = NULL;
> -    srp->done = 1;
>      read_unlock(&sg_dev_arr_lock);
> 
>      SCSI_LOG_TIMEOUT(4, printk("sg...bh: dev=%d, pack_id=%d, res=0x%x\n",
> @@ -1274,6 +1273,8 @@
>      }
>      /* Rely on write phase to clean out srp status values, so no "else" */
> 
> +    srp->done = 1;
> +
>      scsi_release_request(SRpnt);
>      SRpnt = NULL;
>      if (sfp->closed) { /* whoops this fd already released, cleanup */
> 
> ---------------

Tony,
Yes, that is a problem and the same fix is needed in
the lk 2.5 series. Could you forward this match onto
Marcelo and Alan for inclusion.

Doug Gilbert


