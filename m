From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Wed, 19 Nov 2008 09:18:34 -0800
Message-ID: <49244A6A.5060804@oracle.com>
References: <0F5B06BAB751E047AB5C87D1F77A77883511810894@GVW0547EXC.americas.hpqcorp.net> <48C013D9.7060309@oracle.com> <0F5B06BAB751E047AB5C87D1F77A7788413663D229@GVW0547EXC.americas.hpqcorp.net> <20080905092838.GS20055@kernel.dk> <48DBF583.3050307@oracle.com> <20080925134000.9b133f8c.randy.dunlap@oracle.com> <0F5B06BAB751E047AB5C87D1F77A77884BFF5D1F76@GVW0547EXC.americas.hpqcorp.net> <49232232.10604@oracle.com> <4923237B.9090707@xenotime.net> <4923347D.8000205@oracle.com> <20081119085227.GQ26308@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080308030603080105040007"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:41823 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYKSRTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Nov 2008 12:19:24 -0500
In-Reply-To: <20081119085227.GQ26308@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>

This is a multi-part message in MIME format.
--------------080308030603080105040007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Tue, Nov 18 2008, Randy Dunlap wrote:
>> Randy Dunlap wrote:
>>> Randy Dunlap wrote:
>>>> Miller, Mike (OS Dev) wrote:
>>>>>> -----Original Message-----
>>>>>> From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
>>>>>> Sent: Thursday, September 25, 2008 3:40 PM
>>>>>> To: scsi
>>>>>> Cc: Jens Axboe; Miller, Mike (OS Dev); James Bottomley; lkml; akpm
>>>>>> Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
>>>>>>
>>>>>> On Thu, 25 Sep 2008 13:33:07 -0700 Randy Dunlap wrote:
>>>>>>
>>>>>>> Jens Axboe wrote:
>>>>>>>> On Thu, Sep 04 2008, Miller, Mike (OS Dev) wrote:
>>>>>>>>>>>>> 0x3bb2 <do_cciss_intr+1649>:    mov    0x2(%r8),%dx
>>>>>>>>>>>>> 0x3bb7 <do_cciss_intr+1654>:    test   %dx,%dx
>>>>>>>>>>>>> 0x3bba <do_cciss_intr+1657>:    je     0x3f0e
>>>>>> <do_cciss_intr+2509>
>>>>>>>>>>>>> $ addr2line -e cciss.o -f  do_cciss_intr+0x627 SA5_fifo_full
>>>>>>>>>>>>>
>>>>>> /home/rdunlap/linsrc/linux-2.6.27-rc3-git7/drivers/block/cciss.h:2
>>>>>>>>>> 06
>>>>>>>>>>>> OK ...that's confusing.  It seems to be saying that
>>>>>> ctrlr_info_t
>>>>>>>>>>>> * was NULL.  However, I can't see a way of getting into the
>>>>>>>>>> fifo_full
>>>>>>>>>>>> callback from do_cciss_intr ..
>>>>>>>>>>>> especially not with an NULL host.
>>>>>>>>>>>>
>>>>>>>>>>>> James
>>>>>>>>>>> That is weird. Even if we could get there fifo_full doesn't
>>>>>>>>>> do anything but wait for a bit.
>>>>>>>>>>
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> This just happened again.  This time it's on 2.6.27-rc5-git3.
>>>>>>>>>>
>>>>>>>>>> ~Randy
>>>>>>>>> Thanks Randy. I think. :)
>>>>>>>>>
>>>>>>>>> I'll try to recreate in my lab.
>>>>>>>> This looks somewhat strange, mostly like 'c' is NULL and it's
>>>>>>>> oopsing in in removeQ (I don't think Randy's analysis is
>>>>>> correct in
>>>>>>>> assuming it's 'h' and it's in fifo_full). Given that 'c'
>>>>>> cannot be
>>>>>>>> NULL, it's c->prev or c->next that are NULL.
>>>> This BUG: has happened (now) 5 times today.  Higher frequency than usual for
>>>> some reason.
>>>>
>>>> I enabled CCISS_DEBUG and added one printk in removeQ().  On the first call
>>> s/first/second/
>>>
>>>
>>>> to removeQ(), both c->next and c->prev are NULL.
>>>>
>>>> Here's the kernel log output from cciss:
>> I added a printk() in addQ() as well.  Here's the new output:
>>
>> HP CISS Driver (v 3.6.20)
>> ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54
>> cciss 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high) -> IRQ 54
>> command = 147
>> irq = 36
>> board_id = 3211103c
>> cciss 0000:42:08.0: irq 87 for MSI/MSI-X
>> address 0 = fdf80000
>> cfg base address = 10
>> cfg base address index = 0
>> cfg offset = 400
>> Controller Configuration information
>> ------------------------------------
>>    Signature = CISS
>>    Spec Number = 1
>>    Transport methods supported = 0x6
>>    Transport methods active = 0x3
>>    Requested transport Method = 0x0
>>    Coalesce Interrupt Delay = 0x0
>>    Coalesce Interrupt Count = 0x1
>>    Max outstanding commands = 0x256
>>    Bus Types = 0x200000
>>    Server Name =
>>    Heartbeat Counter = 0x1672
>>
>>
>> Trying to put board into Simple mode
>> I counter got to 1 0
>> Controller Configuration information
>> ------------------------------------
>>    Signature = CISS
>>    Spec Number = 1
>>    Transport methods supported = 0x6
>>    Transport methods active = 0x3
>>    Requested transport Method = 0x0
>>    Coalesce Interrupt Delay = 0x0
>>    Coalesce Interrupt Count = 0x1
>>    Max outstanding commands = 0x256
>>    Bus Types = 0x200000
>>    Server Name =
>>    Heartbeat Counter = 0x1672
>>
>>
>> cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 87 using DAC
>> cciss: intr_pending 8
>> cciss: addQ: Qptr=ffff88027e0100b8, c=ffff88007f83e000
>> cciss: removeQ: Qptr=ffff88027e0100b8, c=ffff88007f83e000, next=ffff88007f83e000, prev=ffff88007f83e000
>> Sending 7f83e000 - down to controller
>> cciss: addQ: Qptr=ffff88027e0100c0, c=ffff88007f83e000
>> cciss: intr_pending 8
>> cciss:  Read 4 back from board
>> cciss: removeQ: Qptr=ffff88027e0100c0, c=ffff88007f840000, next=0000000000000000, prev=0000000000000000
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000248
> 
> Randy, can you post the debug patch you used? The above goes boom when

Sure.  I have 2 patches.  One is a fix for CCISS_DEBUG printk formats that I
posted to linux-scsi yesterday.  The other just adds more debug code.

> it attempts to remove a command that isn't on the list, the Qptr in the
> last example should be empty, hence the oops. So I'd be interested in
> seeing what removeQ() calls this is, I'm assuming it's this bit in
> do_cciss_intr():
> 
>       ...
>               while (c->busaddr != a) {
>                        c = c->next;
>                        if (c == h->cmpQ)
>                                break;
>                }
>        }
>        /*
>         * If we've found the command, take it off the
>         * completion Q and free it
>         */
>        if (c->busaddr == a) {
>                removeQ(&h->cmpQ, c);
>                if (c->cmd_type == CMD_RWREQ) {
>                        complete_command(h, c, 0);
>                         ...
> 
> If so, what part of the c lookup are you hitting - the on that does:
> 
>         c = h->cmd_pool + a2;
> 
> or the c->busaddr check that his shown above?

I don't know that the patch will tell us which call it is.
The added code is inside removeQ() and addQ(), not near the calls
to them.

-- 
~Randy

--------------080308030603080105040007
Content-Type: text/x-patch;
 name="cciss-check-more.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cciss-check-more.patch"

---
 drivers/block/cciss.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- lin2628-rc5.orig/drivers/block/cciss.c
+++ lin2628-rc5/drivers/block/cciss.c
@@ -65,6 +65,7 @@ MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ S
 MODULE_VERSION("3.6.20");
 MODULE_LICENSE("GPL");
 
+#define CCISS_DEBUG	1
 #include "cciss_cmd.h"
 #include "cciss.h"
 #include <linux/cciss_ioctl.h>
@@ -217,6 +218,10 @@ static struct block_device_operations cc
  */
 static inline void addQ(CommandList_struct **Qptr, CommandList_struct *c)
 {
+#ifdef CCISS_DEBUG
+	printk(KERN_DEBUG "cciss: %s: Qptr=%p, c=%p\n",
+		__func__, Qptr, c);
+#endif
 	if (*Qptr == NULL) {
 		*Qptr = c;
 		c->next = c->prev = c;
@@ -231,6 +236,10 @@ static inline void addQ(CommandList_stru
 static inline CommandList_struct *removeQ(CommandList_struct **Qptr,
 					  CommandList_struct *c)
 {
+#ifdef CCISS_DEBUG
+	printk(KERN_DEBUG "cciss: %s: Qptr=%p, c=%p, next=%p, prev=%p\n",
+		__func__, Qptr, c, c ? c->next : 0, c ? c->prev : 0);
+#endif
 	if (c && c->next != c) {
 		if (*Qptr == c)
 			*Qptr = c->next;
@@ -3200,6 +3209,10 @@ static int __devinit cciss_pci_init(ctlr
 	printk("address 0 = %x\n", c->paddr);
 #endif				/* CCISS_DEBUG */
 	c->vaddr = remap_pci_mem(c->paddr, 0x250);
+	if (!c->vaddr) {
+		printk(KERN_ERR "cciss: remap_pci_mem/vaddr failed\n");
+		return -ENOMEM;
+	}
 
 	/* Wait for the board to become ready.  (PCI hotplug needs this.)
 	 * We poll for up to 120 secs, once per 100ms. */
@@ -3239,6 +3252,10 @@ static int __devinit cciss_pci_init(ctlr
 	c->cfgtable = remap_pci_mem(pci_resource_start(pdev,
 						       cfg_base_addr_index) +
 				    cfg_offset, sizeof(CfgTable_struct));
+	if (!c->cfgtable) {
+		printk(KERN_ERR "cciss: remap_pci_mem/cfgtable failed\n");
+		return -ENOMEM;
+	}
 	c->board_id = board_id;
 
 #ifdef CCISS_DEBUG

--------------080308030603080105040007
Content-Type: text/x-patch;
 name="cciss-debug-printk.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cciss-debug-printk.patch"

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings when CCISS_DEBUG is defined.

drivers/block/cciss.c:2856: warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned int'
drivers/block/cciss.c:3205: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
drivers/block/cciss.c:3236: warning: format '%x' expects type 'unsigned int', but argument 2 has type '__u64'
drivers/block/cciss.c:3246: warning: format '%x' expects type 'unsigned int', but argument 2 has type '__u64'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/cciss.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- lin2628-rc5.orig/drivers/block/cciss.c
+++ lin2628-rc5/drivers/block/cciss.c
@@ -2856,7 +2856,7 @@ static void do_cciss_request(struct requ
 		h->maxSG = seg;
 
 #ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss: Submitting %d sectors in %d segments\n",
+	printk(KERN_DEBUG "cciss: Submitting %lu sectors in %d segments\n",
 	       creq->nr_sectors, seg);
 #endif				/* CCISS_DEBUG */
 
@@ -3206,7 +3206,7 @@ static int __devinit cciss_pci_init(ctlr
 
 	c->paddr = pci_resource_start(pdev, 0);	/* addressing mode bits already removed */
 #ifdef CCISS_DEBUG
-	printk("address 0 = %x\n", c->paddr);
+	printk("address 0 = %lx\n", c->paddr);
 #endif				/* CCISS_DEBUG */
 	c->vaddr = remap_pci_mem(c->paddr, 0x250);
 	if (!c->vaddr) {
@@ -3237,7 +3237,8 @@ static int __devinit cciss_pci_init(ctlr
 #endif				/* CCISS_DEBUG */
 	cfg_base_addr_index = find_PCI_BAR_index(pdev, cfg_base_addr);
 #ifdef CCISS_DEBUG
-	printk("cfg base address index = %x\n", cfg_base_addr_index);
+	printk("cfg base address index = %llx\n",
+		(unsigned long long)cfg_base_addr_index);
 #endif				/* CCISS_DEBUG */
 	if (cfg_base_addr_index == -1) {
 		printk(KERN_WARNING "cciss: Cannot find cfg_base_addr_index\n");
@@ -3247,7 +3248,7 @@ static int __devinit cciss_pci_init(ctlr
 
 	cfg_offset = readl(c->vaddr + SA5_CTMEM_OFFSET);
 #ifdef CCISS_DEBUG
-	printk("cfg offset = %x\n", cfg_offset);
+	printk("cfg offset = %llx\n", (unsigned long long)cfg_offset);
 #endif				/* CCISS_DEBUG */
 	c->cfgtable = remap_pci_mem(pci_resource_start(pdev,
 						       cfg_base_addr_index) +

--------------080308030603080105040007--
