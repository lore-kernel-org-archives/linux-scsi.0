From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Linux-2.6.0-test4: Kernel Panic in scsi_host_dev_release
Date: Mon, 25 Aug 2003 16:42:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825234232.GA2470@beaverton.ibm.com>
References: <1061844849.486.12.camel@felicia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:53997 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261705AbTHYXig
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 19:38:36 -0400
Content-Disposition: inline
In-Reply-To: <1061844849.486.12.camel@felicia>
List-Id: linux-scsi@vger.kernel.org
To: "Dr. Ernst Molitor" <molitor@uni-bonn.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Dr. Ernst Molitor [molitor@uni-bonn.de] wrote:
> Dear James E.J. Bottomley, 
> 
> while Linux-2.6.0-test3 runs like a charm on my (testbed) box, I ran
> into a kernel panic with Linux-2.6.0-test4 (and 2.6.0-test4-bk4). 
> 
> The call trace is:
> 
> scsi_host_dev_release
> device_releases
> kobject_cleanup
> aha1542_detect
> init_this_scsi_driver
> do_initcalls
> init_workqueues
> init
> init
> kernel_thread_helper

I believe the problem you are hitting is a bug in the code I added for a
doing a put on the parent in the release function. If a driver calls
scsi_register, but then has a problem in there detect where they need to
call scsi_unregister the parent pointer of the struct device may never
be set.

I you have time could you please try the patch below. I have compiled it
only. I will try to run it with a modified driver that will fail in
detect shortly.

> The last line of both functions is identical: kfree is called with the
> pointer shost. From a very superficial analysis, I would feel that
> freeing *dev rather than *shost would be logical, but I might very well
> be way off the real source of the panic I have seen.
> 

We need to kfree the shost as the struct device is contained inside the
scsi_host structure.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 drivers/scsi/hosts.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/hosts.c~scsi_host_dev_release-parent-fix drivers/scsi/hosts.c
--- qla-bleed-2.5/drivers/scsi/hosts.c~scsi_host_dev_release-parent-fix	Mon Aug 25 15:42:53 2003
+++ qla-bleed-2.5-andmike/drivers/scsi/hosts.c	Mon Aug 25 15:43:19 2003
@@ -158,7 +158,8 @@ static void scsi_host_dev_release(struct
 	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
 
-	put_device(parent);
+	if (parent)
+		put_device(parent);
 	kfree(shost);
 }
 

_

