From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 09/10] Enable clustering and large transfers
Date: Sun, 2 Apr 2006 17:18:05 +0300 (EEST)
Message-ID: <Pine.LNX.4.63.0604021706270.4221@kai.makisara.local>
References: <1143561824404-git-send-email-matthew@wil.cx>
 <Pine.LNX.4.63.0604011656490.10426@kai.makisara.local> <442EE0F0.7000102@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:25156 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932346AbWDBOSN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Apr 2006 10:18:13 -0400
In-Reply-To: <442EE0F0.7000102@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On Sat, 1 Apr 2006, Douglas Gilbert wrote:

> Kai Makisara wrote:
> > On Tue, 28 Mar 2006, Matthew Wilcox wrote:
> > 
> > 
> >>This patch enables clustering and sets max_sectors to 0xffff to enable
> >>reading and writing of large blocks with tapes (and large transfers with
> >>sg). This change is needed after the sg and st drivers started using
> >>chained bios through scsi_request_async() in 2.6.16.
> >>
> >>Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
> >>Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> >>
> >>---
> >>
> >> drivers/scsi/sym53c8xx_2/sym_glue.c |    3 ++-
> >> 1 files changed, 2 insertions(+), 1 deletions(-)
> >>
> >>1c573ec4648b4b4ddadcbd1945a9a608977df513
> >>diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
> >>index e48409e..2c4e5f1 100644
> >>--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> >>+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> >>@@ -1870,7 +1870,8 @@ static struct scsi_host_template sym2_te
> >> 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
> >> 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
> >> 	.this_id		= 7,
> >>-	.use_clustering		= DISABLE_CLUSTERING,
> >>+	.use_clustering		= ENABLE_CLUSTERING,
> >>+	.max_sectors		= 0xFFFF,
> >> #ifdef SYM_LINUX_PROC_INFO_SUPPORT
> >> 	.proc_info		= sym53c8xx_proc_info,
> >> 	.proc_name		= NAME53C8XX,
> >>
...
> Kai + Matthew,
> In my testing with lk 2.6.16 the 16 MB boundary is a
> hard limit, after several other things are tweaked.
> 
> The sym53c8xx driver won't even come close due to:
>   #define SYM_CONF_MAX_SG             (96)
>  ...
>   instance->sg_tablesize  = SYM_CONF_MAX_SG;
> 
I was able to read 65535 blocks (32 MB - 512 B) for each SCSI command from 
my disk using the sym53c8xx_2 driver and SG_IO through the sg driverv. I 
did not change SYM_CONF_MAX but I did add

	blk_queue_max_segment_size(sdev->request_queue, 256 * 1024);

to sym53c8xx_slave_configure to increase the maximum segment size for the 
queue. Did you do also this?

> I assume that the st driver (like sg) limits on .sg_tablesize .
> Matthew, if you change this please set it at 256 (not SG_ALL
> which is 255).
> 
> I have attempted to capture the current (overly complex)
> constraints on maximum transfer size at:
> http://www.torque.net/sg/sg_io.html
> in the section on "Maximum transfer size per command".
> 
The maximum segments size limitation is mentioned on your page. Maybe you 
emphasize that without changing this you can't get beyond 16 MB with only 
128 segments.

-- 
Kai
