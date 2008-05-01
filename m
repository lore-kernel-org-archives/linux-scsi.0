From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 19:25:18 +0300
Message-ID: <4819EEEE.5030205@panasas.com>
References: <4819C9DB.60104@panasas.com>	 <1209651854.3067.8.camel@localhost.localdomain>	 <4819DA39.70505@panasas.com>	 <1209655360.3067.14.camel@localhost.localdomain>	 <4819E371.2040403@panasas.com>	 <1209656838.3067.16.camel@localhost.localdomain>	 <4819E8C7.3040808@panasas.com> <1209657731.3067.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1209657731.3067.19.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 01 2008 at 19:02 +0300, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Thu, 2008-05-01 at 18:59 +0300, Boaz Harrosh wrote:
>> On Thu, May 01 2008 at 18:47 +0300, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>>> On Thu, 2008-05-01 at 18:36 +0300, Boaz Harrosh wrote:
>>>> On Thu, May 01 2008 at 18:22 +0300, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>>>>> On Thu, 2008-05-01 at 17:56 +0300, Boaz Harrosh wrote:
>>>>>> The call to pci_map_page() on an ISA case will it not bounce the
>>>>>> buffer?
>>>>> Only if the system isn't a PCI_DMA_BUS_IS_PHYS one.
>>>>>
>>>>> That means basically either has an iommu/gart or has some silly swiotlb
>>>>> to emulate one.
>>>>>
>>>>> That means for standard x86 isa systems the answer is no: the buffer has
>>>>> to be allocated within the isa region because pci_map is simply a
>>>>> virt_to_phys.
>>>>>
>>>>> James
>>>>>
>>>> OK Thanks, so the second patch then. That will solve it.
>>> Um, your second patch is only changing isd200; it's hard to see how that
>>> can fix a gdth problem ...
>>>
>>> James
>>>
>>>
>> Sorry I meant the second version of the patch that uses scsi_get_command()
>>
>> http://marc.info/?l=linux-scsi&m=120965483126936&w=2
> 
> No ... it still needs to use scsi_allocate_command() and pass the gfp
> flags for DMA if necessary.
> 
> James
> 
> 

But I'm removing all that very soon.

Here is a patch that fixes that ISA thing. Please submit it before the 
original [PATCH 4/4].

--
From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3.5/4] gdth: Fix sense handling in the ISA case

Allocate the 16 bytes buffer from host space which is of the right mask
in the ISA case.

Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
---
 drivers/scsi/gdth.c |   11 ++++++++---
 drivers/scsi/gdth.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3cfbab6..fb61c79 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2647,8 +2647,8 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
         }
 
     } else {
-        page = virt_to_page(scp->sense_buffer);
-        offset = (ulong)scp->sense_buffer & ~PAGE_MASK;
+        page = virt_to_page(cmndinfo->sense);
+        offset = (ulong)cmndinfo->sense & ~PAGE_MASK;
         sense_paddr = pci_map_page(ha->pdev,page,offset,
                                    16,PCI_DMA_FROMDEVICE);
 
@@ -3317,9 +3317,14 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
             pci_unmap_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                          cmndinfo->dma_dir);
 
-        if (cmndinfo->sense_paddr)
+        if (cmndinfo->sense_paddr) {
             pci_unmap_page(ha->pdev, cmndinfo->sense_paddr, 16,
                                                            PCI_DMA_FROMDEVICE);
+            /* this here is called before gdth_next so it will not
+             * overwrite fake sense returned there.
+             */
+            memcpy(scp->sense_buffer, cmndinfo->sense, 16);
+	}
 
         if (ha->status == S_OK) {
             cmndinfo->status = S_OK;
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index ca92476..445ea7f 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -914,6 +914,7 @@ typedef struct {
         int index;
         int internal_command;                   /* don't call scsi_done */
         gdth_cmd_str *internal_cmd_str;         /* crier for internal messages*/
+        u8 sense[16];                           /* 16 is used allover */
         dma_addr_t sense_paddr;                 /* sense dma-addr */
         unchar priority;
         int timeout;
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
