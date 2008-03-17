From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: ultrastor.c is a bit-rot
Date: Mon, 17 Mar 2008 19:01:39 +0200
Message-ID: <47DEA3F3.7070908@panasas.com>
References: <47DE8736.8020405@panasas.com>	 <1205767383.6767.139.camel@localhost.localdomain>	 <47DE95A9.8060502@panasas.com> <1205769786.6767.140.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:38921 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbYCQRCD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 13:02:03 -0400
In-Reply-To: <1205769786.6767.140.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>

On Mon, Mar 17 2008 at 18:03 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2008-03-17 at 18:00 +0200, Boaz Harrosh wrote:
>> On Mon, Mar 17 2008 at 17:23 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>> On Mon, 2008-03-17 at 16:59 +0200, Boaz Harrosh wrote:
>>>> Inspecting ultrastor.c it is clear to me that this was never used for
>>>> a loooooooooong time. Not since a PC has more then 2^24 bit of memory.
>>>> Let me explain below.
>>>>
>>>> Now I'm not saying it should be fixed. I'm saying that it should be dumped
>>>> in the account that it is not used by any one and that it does not work.
>>>>
>>>> Why it never worked?
>>>> ~~~~~~~~~~~~~~~~~~~~~
>>>>
>>>> The driver's header says it supports 3 cards
>>>>
>>>>  *	14F - ISA first-party DMA HA with floppy support and WD1003 emulation.
>>>>  *	24F - EISA Bus Master HA with floppy support and WD1003 emulation.
>>>>  *	34F - VL-Bus Bus Master HA with floppy support (no WD1003 emulation).
>>>>
>>>> But Kconfig only specifies ISA. I'm not sure what a VL-Bus is.
>>> VL is vesa local ... it was an ISA like graphics bus that was fast and
>>> could reach > 16MB.
>>>
>>>> now the driver defines a static array of structures like this:
>>>>
>>>> 	struct {
>>>> 	  ...
>>>> 	
>>>> 	  struct mscp mscp[ULTRASTOR_MAX_CMDS];
>>>> 	} config = {0};
>>>>
>>>> and allocates a struct mscp in .queuecommand like this:
>>>> 	    my_mscp = &config.mscp[mscp_index];
>>>>
>>>> it will go on preparing this my_mscp structure including stuffing
>>>> some mapped pointers. Lets put that aside for now.
>>>> At the very end it will pass this my_mscp structure to the card's 
>>>> firmware like this:
>>>>
>>>> 	    /* Store pointer in OGM address bytes */
>>>> 	outl(isa_virt_to_bus(my_mscp), config.ogm_address);
>>>>
>>>> Now this is one hell of a smart ISA card. But putting this aside.
>>>>
>>>> if the machine has more then 2^24 of memory. Then this will never
>>>> work, right? or I'm missing it completely?
>>> It will definitely work for EISA and VL bus.  I think if you analyse the
>>> placement of kernel data segments for compiled in drivers, it might also
>>> work for ISA too, since I think the pfn will be low enough.  It should
>>> fail as a module not just because the area will be out of range for ISA,
>>> but also because the module data segment is in vmalloc space, so the
>>> virt_to_bus assumptions of contiguity could be violated.
>>>
>>> James
>>>
>> So what is the verdict? is it removed? marked broken for ISA?
> 
> It's probably obvious enough to apply the best straight line fix.
> 
>> can I safely say that unchecked_isa_dma can be removed?
> 
> No ... ISA definitely requires it.
> 
> James
> 

In Hebrew we say: "You make me drink Kerosene". 
An "obvious enough to apply the best straight line fix" submitted below:

I say dump it, it's unused.

Boaz
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Mon, 17 Mar 2008 18:40:03 +0200
Subject: [PATCH] ultrastor: Fix for ISA DMA allocation

"obvious enough to apply the best straight line fix" submitted
below.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Andi Kleen <ak@suse.de>
---
 drivers/scsi/ultrastor.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index f385dce..04441eb 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -255,8 +255,9 @@ static struct ultrastor_config
   unsigned long mscp_free;
 #endif
   volatile unsigned char aborted[ULTRASTOR_MAX_CMDS];
-  struct mscp mscp[ULTRASTOR_MAX_CMDS];
-} config = {0};
+  struct mscp *mscp;
+  dma_addr_t dma;
+} config;
 
 /* Set this to 1 to reset the SCSI bus on error.  */
 static int ultrastor_bus_reset;
@@ -646,12 +647,29 @@ static int ultrastor_24f_detect(struct scsi_host_template * tpnt)
 
 static int ultrastor_detect(struct scsi_host_template * tpnt)
 {
+	int ret;
+
 	tpnt->proc_name = "ultrastor";
-	return ultrastor_14f_detect(tpnt) || ultrastor_24f_detect(tpnt);
+
+	if (!config.mscp)
+		config.mscp = dma_alloc_coherent(NULL,
+			sizeof(*config.mscp) * ULTRASTOR_MAX_CMDS,
+			&config.dma, GFP_KERNEL);
+
+	ret = ultrastor_14f_detect(tpnt) || ultrastor_24f_detect(tpnt);
+
+	if (!ret)
+		dma_free_coherent(NULL,
+			sizeof(*config.mscp) * ULTRASTOR_MAX_CMDS,
+			config.mscp, config.dma);
+	return ret;
 }
 
 static int ultrastor_release(struct Scsi_Host *shost)
 {
+	dma_free_coherent(NULL, sizeof(*config.mscp) * ULTRASTOR_MAX_CMDS,
+			  config.mscp, config.dma);
+
 	if (shost->irq)
 		free_irq(shost->irq, NULL);
 	if (shost->dma_channel != 0xff)
-- 
1.5.3.3


