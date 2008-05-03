From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 06/10] scsi_dh: Do not allow arguments for
	hardware handlers
Date: Fri, 02 May 2008 17:01:07 -0700
Message-ID: <1209772867.21974.90.camel@chandra-ubuntu>
References: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
	 <20080501215017.27759.37314.sendpatchset@chandra-ubuntu>
	 <20080502224731.GH18935@agk.fab.redhat.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:58598 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915AbYECAAH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 20:00:07 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m43004Tv011520
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2008 20:00:04 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m43003Rn183048
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2008 18:00:03 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m43002Xj028887
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2008 18:00:03 -0600
In-Reply-To: <20080502224731.GH18935@agk.fab.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com, michaelc@cs.wisc.edu, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com


On Fri, 2008-05-02 at 23:47 +0100, Alasdair G Kergon wrote:
> On Thu, May 01, 2008 at 02:50:17PM -0700, Chandra Seetharaman wrote:
> > Subject: [PATCH 06/10] scsi_dh: Do not allow arguments for hardware handlers
> > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > The new implementation does not use the arguments provided with the
> > hardware handler. This patch makes the change visible to the user by
> > failing table load when arguments are provided with the hardware handler.
> 
> But then someone supplying such an arg may need to update their
> userspace multipath config file before they can use this new kernel.
> 
> Past experience suggests that changes like that usually come back
> and bite us.  Let's instead just have the kernel log a message noting
> that the args have been ignored and allow people to deal with it at
> their leisure.

Understand.

How does the following patch look ?
--------------------
Subject: [PATCH 06/10] scsi_dh: Print warning when arguments were provided for hardware handlers

From: Chandra Seetharaman <sekharan@us.ibm.com>

The new implementation does not use the arguments provided with the
hardware handler. This patch makes the change visible to the user by
printing a warning to the kernel log.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.25/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.25.orig/drivers/md/dm-mpath.c
+++ linux-2.6.25/drivers/md/dm-mpath.c
@@ -656,8 +656,11 @@ static int parse_hw_handler(struct arg_s
 		{0, 1024, "invalid number of hardware handler args"},
 	};
 
-	if (read_param(_params, shift(as), &hw_argc, &ti->error))
-		return -EINVAL;
+	if (read_param(_params, shift(as), &hw_argc, &ti->error)) {
+		if (hw_argc > 1)
+			printk(KERN_WARN "Additional arguments provided to "
+				"hardware handler were ignored\n");
+	}
 
 	if (!hw_argc)
 		return 0;
------------------------
> 
> Alasdair

