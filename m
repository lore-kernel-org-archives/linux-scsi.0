From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 09/10] Enable clustering and large transfers
Date: Sat, 01 Apr 2006 15:22:08 -0500
Message-ID: <442EE0F0.7000102@torque.net>
References: <1143561824404-git-send-email-matthew@wil.cx> <Pine.LNX.4.63.0604011656490.10426@kai.makisara.local>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:26779 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S932182AbWDAUXW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 15:23:22 -0500
In-Reply-To: <Pine.LNX.4.63.0604011656490.10426@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

Kai Makisara wrote:
> On Tue, 28 Mar 2006, Matthew Wilcox wrote:
> 
> 
>>This patch enables clustering and sets max_sectors to 0xffff to enable
>>reading and writing of large blocks with tapes (and large transfers with
>>sg). This change is needed after the sg and st drivers started using
>>chained bios through scsi_request_async() in 2.6.16.
>>
>>Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
>>Signed-off-by: Matthew Wilcox <matthew@wil.cx>
>>
>>---
>>
>> drivers/scsi/sym53c8xx_2/sym_glue.c |    3 ++-
>> 1 files changed, 2 insertions(+), 1 deletions(-)
>>
>>1c573ec4648b4b4ddadcbd1945a9a608977df513
>>diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
>>index e48409e..2c4e5f1 100644
>>--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
>>+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
>>@@ -1870,7 +1870,8 @@ static struct scsi_host_template sym2_te
>> 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
>> 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
>> 	.this_id		= 7,
>>-	.use_clustering		= DISABLE_CLUSTERING,
>>+	.use_clustering		= ENABLE_CLUSTERING,
>>+	.max_sectors		= 0xFFFF,
>> #ifdef SYM_LINUX_PROC_INFO_SUPPORT
>> 	.proc_info		= sym53c8xx_proc_info,
>> 	.proc_name		= NAME53C8XX,
>>
> 
> Did you approve this patch or just forgot to remove it from the queue 
> after the discussion initiated by Jens Axboe?
> 
> I have done some more investigation based on the message from Gerard 
> Roudier that Jens found. I fetched the FreeBSD driver. It had a 
> work-around for the 896 rev. 1 chips but I did not find that in the Linux 
> version. The work-around does build two device s/g elements for any 
> original s/g segment that crosses a 16 MB boundary.

Kai + Matthew,
In my testing with lk 2.6.16 the 16 MB boundary is a
hard limit, after several other things are tweaked.

The sym53c8xx driver won't even come close due to:
  #define SYM_CONF_MAX_SG             (96)
 ...
  instance->sg_tablesize  = SYM_CONF_MAX_SG;

I assume that the st driver (like sg) limits on .sg_tablesize .
Matthew, if you change this please set it at 256 (not SG_ALL
which is 255).

I have attempted to capture the current (overly complex)
constraints on maximum transfer size at:
http://www.torque.net/sg/sg_io.html
in the section on "Maximum transfer size per command".

> In Linux we can do that by setting the .dma_boundary field in the 
> scsi_host_template. Would it be an acceptable solution to set the 16 MB 
> limit for all sym53c8xx adapters? It would take care of the known errata 
> and Gerards suspicions about possible problems with other chips.
> 
> The patch at the end does compile and it is running in this system but has 
> not had any more testing.

Doug Gilbert

