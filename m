From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] [v2] aha152x cmnd->device oops
Date: Tue, 28 Oct 2003 12:45:36 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028124536.3ce82c23.rddunlap@osdl.org>
References: <20031027155713.GA28140@lst.de>
	<20031027160101.76d5291b.rddunlap@osdl.org>
	<20031028090600.GA7370@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:52098 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261733AbTJ1UsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 15:48:12 -0500
In-Reply-To: <20031028090600.GA7370@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fischer@norbit.de

On Tue, 28 Oct 2003 10:06:00 +0100 Christoph Hellwig <hch@lst.de> wrote:

| On Mon, Oct 27, 2003 at 04:01:01PM -0800, Randy.Dunlap wrote:
| > Hi,
| > 
| > Even before this patch (which isn't merged AFAIK), are
| > scsi_device_get() and scsi_device_put() intended to be used
| > by SCSI LLDD's for scsi_device reference counts?
| 
| Yes, if they need to.  But usually they should not have to worry.
| 
| > I'm trying to determine what needs to be done to fix aha152x.c,
| > where it creates a struct scsi_cmnd and then inits as follows,
| > with my example patch:
| 
| A driver is not allowed to "create" a scsi_cmnd.  It must use
| scsi_get_command to allocate one.

Here's the updated patch.  Comments on it?

Thanks for your help, Christoph.

--
~Randy


description:	(a) aha152x oopses when it references cmnd->device->...
		before cmd->device has been init;
		(b) use scsi_get_command() instead of kmalloc() to
		allocate a scsi_cmnd;
		(c) no need to check/free cmnd on failure;
maintainer:	Juergen Fischer <fischer@norbit.de>
product_versions: Linux 2.6.0-test9
patch_name:	aha152x-cmd-dev.patch
author:		Randy.Dunlap <rddunlap@osdl.org>
patch_version:	2003-10-28.12:35:35

diffstat:=
 drivers/scsi/aha152x.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -Naurp ./drivers/scsi/aha152x.c~aha152xfix ./drivers/scsi/aha152x.c
--- ./drivers/scsi/aha152x.c~aha152xfix	2003-10-25 11:42:50.000000000 -0700
+++ ./drivers/scsi/aha152x.c	2003-10-28 12:32:48.000000000 -0800
@@ -2001,7 +2001,7 @@ static void busfree_run(struct Scsi_Host
 #endif
 
 			if(!(DONE_SC->SCp.Status & not_issued)) {
-				Scsi_Cmnd *cmnd = kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC);
+				Scsi_Cmnd *cmnd = scsi_get_command(DONE_SC->device, GFP_ATOMIC);
 
 				if(cmnd) {
 					Scsi_Cmnd *ptr=DONE_SC;
@@ -2018,6 +2018,7 @@ static void busfree_run(struct Scsi_Host
 					cmnd->cmnd[4]         = sizeof(ptr->sense_buffer);
 					cmnd->cmnd[5]         = 0;
 					cmnd->cmd_len	      = 6;
+					cmnd->device          = ptr->device;
 					cmnd->device->host    = ptr->device->host;
 					cmnd->device->id      = ptr->device->id;
 					cmnd->device->lun     = ptr->device->lun;
@@ -2030,8 +2031,6 @@ static void busfree_run(struct Scsi_Host
 					DO_LOCK(flags);
 				} else {
 					printk(ERR_LEAD "allocation failed\n", CMDINFO(CURRENT_SC));
-					if(cmnd)
-						kfree(cmnd);
 				}
 			} else {
 #if 0
