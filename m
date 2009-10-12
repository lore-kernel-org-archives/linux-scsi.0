From: "jack wang" <jack_wang@usish.com>
Subject: Re: [RFC][PATCH v2]Add pm8001 SAS/SATA HBA driver
Date: Mon, 12 Oct 2009 10:35:45 +0800
Message-ID: <B57F7BF9016A4477ADE453FDB25B64CC@usish.com.cn>
References: <9A9AF0C219C5433DB5A8D61D4914C599@usish.com.cn> <200909150807.36222.eike-kernel@sf-tec.de> <4E716EE5A6E14CBEB7C6A982E2347934@usish.com.cn> <1253826242.5183.178.camel@mulgrave.site> <08BF47025E834582AAA7FE0AE45FE2D3@usish.com.cn> <1254518156.3874.139.camel@mulgrave.site> <A00AC85A58F649ACB9E1738AD668638F@usish.com.cn> <9510C503D9D946EDB9AD0B61044881EF@usish.com.cn> <da824cf30910091937l761e1b8bo311dc2a0bbf1c115@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:39799 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZJLCg1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Oct 2009 22:36:27 -0400
In-Reply-To: <da824cf30910091937l761e1b8bo311dc2a0bbf1c115@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Grant Grundler' <grundler@google.com>
Cc: 'James Bottomley' <James.Bottomley@suse.de>, 'lindar_liu' <lindar_liu@usish.com>, 'Rolf Eike Beer' <eike-kernel@sf-tec.de>, matthew@wil.cx, linux-scsi@vger.kernel.org, tom_peng@usish.com, 'aoqingy' <aoqingyun@usish.com>, roy_wang@usish.com


Jack,
Sorry to nit pick after you've posted several updates. But so many
still remain that I didn't have time to get past what is posted below.
[Jack] Grant
Thanks so much for your carefully comments.

On Fri, Oct 9, 2009 at 3:01 AM, jack wang <jack_wang@usish.com> wrote:
...
> Add sign-off-by && fix bug when do io on some 6g sas disk will cause
> open-retry-timeout error.

diff --git a/MAINTAINERS b/MAINTAINERS
...
+F:     drivers/scsi/pm8001/*.*

This can just be "*". Few people use DOS to store linux source trees. :)
[Jack] Will fix it.

diff --git a/drivers/scsi/pm8001/pm8001_chips.h
b/drivers/scsi/pm8001/pm8001_chips.h
...
+#define PM8001_READ_32(ADDR32, DMA_ADDR, OFFSET)       \
+       (*((u32 *)ADDR32)) = (*((u32 *)(((u8 *)DMA_ADDR) + (OFFSET))))
+
+#define PM8001_WRITE_32(DMA_ADDR, OFFSET, VALUE32)     \
+       (*((u32 *)(((u8 *)DMA_ADDR)+(OFFSET)))) = (u32)(VALUE32)

I really don't like the name of this macro nor the fact that its a macro.

1) "READ_32" implies MMIO access and DMA_ADDR implies it's touching
host memory. Something is fundamentally wrong if everything is needed
to be cast to u32 to compile correctly.

2) If there were an inline function, we'd have type checking and
probably would't need the casts.

The upside is if the macro is only used to touch data that is
read/written by the device, then it would be a good place to put
cpu_to_le32()  (write case) and le32_to_cpu() (read case) calls.

[Jack] Thanks for suggestion .Will replace this by inline function,and
rename the parameter function name.
...
+static inline u32 pm8001_mr32(dma_addr_t addr, u32 offset)
+{
+       return readl((void *)addr + offset);
+}
+static inline void pm8001_mw32(dma_addr_t addr, u32 offset, u32 val)
+{
+       writel(val, (void *)addr + offset);
+}

This is definitely wrong. dma_addr_t is not an MMIO address. Someone
didn't understand
that dma_addr_t is ONLY to be used by devices for accessing host
memory (ie DMA).

This line in init_pci_device_addresses() seems to be the root of the
problem:
+       pm8001_ha->cfg_addr = cfg_addr =
+               (dma_addr_t)pm8001_ha->io_mem[pcibar].memvirtaddr + offset;

cfg_addr is also a poorly named variable since PCI has a config space
and I'm sure that's not meant here.
[Jack] yes, cfg_addr means the main config table address of MPI.
I suggest taking some inspiration (ie copy the coding style and/or
code) from drivers/net/bnx2.h:
...
#define REG_ADDR(bp, offset)            (bp->regview + offset)

#define REG_RD(bp, offset)              readl(REG_ADDR(bp, offset))
#define REG_RD8(bp, offset)             readb(REG_ADDR(bp, offset))
...
struct bnx2x {
        /* Fields used in the tx and intr/napi performance paths
         * are grouped together in the beginning of the structure
         */
        struct bnx2x_fastpath   fp[MAX_CONTEXT];
        void __iomem            *regview;
        void __iomem            *doorbells;
...

(even though I wished they had used inline functions instead of macros as
well).
[Jack] Thanks for give a good example. I will follow your suggestion to
modify
our patch.

+static inline u32 get_pci_bar_index(u32 pcibar)
+{
+               switch (pcibar) {
+               case 0x10:
+               case 0x14:
+                       return 0;
...

Don't need these two cases. The default case will return 0.
[Jack]Ok.
diff --git a/drivers/scsi/pm8001/pm8001_ctl.c
b/drivers/scsi/pm8001/pm8001_ctl.c
...
+/**
+ * pm8001_ctl_fw_version_show - firmware version
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned

Almost but not quite docbook correct. See
Documentation/kernel-doc-nano-HOWTO.txt
Lots of functions are missing the ":" for the args. "make docbook"
shouldn't add any warnings for this driver.
[Jack] Sorry ,will fix it.
+static ssize_t pm8001_ctl_fw_version_show(struct device *cdev,
+       struct device_attribute *attr, char *buf)
+{
+       struct Scsi_Host *shost = class_to_shost(cdev);
+       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+
+       return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",
+       (pm8001_ha->cfg_data.firmware_rev & 0xFF000000) >> 24,
+       (pm8001_ha->cfg_data.firmware_rev & 0x00FF0000) >> 16,
+       (pm8001_ha->cfg_data.firmware_rev & 0x0000FF00) >> 8,
+       pm8001_ha->cfg_data.firmware_rev & 0x000000FF);
+}

The "& 0xFF" byte masks aren't needed if the resulting value were cast to
u8.
e.g. (u8) (foo >> 24)
[Jack]Will fix.


+       return snprintf(buf, PAGE_SIZE, "%d\n",
+       pm8001_ha->cfg_data.max_out_io);

Continued lines should be indented at least one (or more) tabs from
the first line.  This shows up in a bunch of places.
[Jack] will fix it.
Here's another example:
+static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,
...
+       for (i = 0; i < max; i++) {
+               str += sprintf(str, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x
0x%08x"
+                              "0x%08x 0x%08x\n",
+               *(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr +
+               i * 32),
+               *(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr
+               + 4 + i * 32),
+               *(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr
+               + 8 + i * 32),
+               *(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr
+               + 12 + i * 32),
+               *(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr
+               + 16 + i * 32),
+               *(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr
+               + 20 + i * 32),
+               *(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr
+               + 24 + i * 32),
+               *(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr
+               + 28 + i * 32));
+       }

Define a macro before the first line with something like this:
#define AAP1_MEMMAP(r,c)  (*(u32 *)((u8
*)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32 + (c)))

Then the code would be:
   AAP1_MEMMAP(i,0), AAP1_MEMMAP(i,4), ...
[Jack] Good suggestion . Will fix it.
...
+static ssize_t pm8001_store_update_fw(struct device *cdev,
+                                     struct device_attribute *attr,
+                                     const char *buf, size_t count)
...
+       default:
+               pm8001_ha->fw_status = FAIL_PARAMETERS;
+               break;
+       }
+       release_firmware(pm8001_ha->fw_image);
+out1:
+       kfree(cmd_ptr);
+out:
+       pm8001_ha->fw_status = err;


err will clobber the fw_status set in the default case.
Ie the default case should be setting "err" instead.
[Jack] Will fix it.

diff --git a/drivers/scsi/pm8001/pm8001_defs.h
b/drivers/scsi/pm8001/pm8001_defs.h
...
+/* unchangeable hardware details */
+enum hardware_details {
+       PM8001_MAX_PHYS         = 8,    /* max. possible phys */
+       PM8001_MAX_PORTS        = 8,    /* max. possible ports */
+       PM8001_MAX_DEVICES      = 1024, /* max supported device */
+};

Does it make any sense to declare these as enum?
[Jack] Yes, maybe move out of enum will be better.
Later in the patch I see:
+       pm8001_ha->tags = kmalloc(sizeof(unsigned long)*PM8001_MAX_DEVICES,
+               GFP_KERNEL);

What are we limiting to 1024 devices? LUNS?
I noticed the constant was also used in an initialization loop too.
[Jack] tags are used to be a BITMAP to limit the max io.
 
This use needs a more descriptive error:
+       if (dev == PM8001_MAX_DEVICES) {
+               PM8001_FAIL_DBG(pm8001_ha,
+                       pm8001_printk("max support %d devices, ignore ..\n",
+                       PM8001_MAX_DEVICES));
+       }

The error message should indicate exactly what is getting ignored.
[Jack] Will fix it.

...
+ /*error code*/
+#define MPI_IO_STATUS_SUCCESS  0
+#define MPI_IO_STATUS_BUSY     1
+#define MPI_IO_STATUS_FAIL     -1

These look like they should be enum. Just guessing.
[Jack] Yes , you are right ,will fix it.

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
...
+       pm8001_ha->cfg_data.event_log_size                      = 128*1024;

Do these need to be hard coded? Isn't there a #define'd constant for them?
[Jack]The event log size are allocated to save some error event from
firmware.
Will define constant to replace the hard code.
...
+update_outbound_queue_table(struct pm8001_hba_info *pm8001_ha, int number)
+{
+       dma_addr_t address = pm8001_ha->outb_addr;
...

While "outb" here certainly means "outbound",  can the field please be
named "outbnd_addr" or "outbound_addr" to avoid any confusion with IO
Port space accessors (inb() and outb())?

Ditto for pm8001_ha->inb_addr.
[Jack]Will use more clear name.
...
+/**
+ * bar4_shift - function is called to shift BAR base address
+ * @pm8001_ha : our hba card infomation
+ * @shiftValue : shifting value in memory bar.
+ */
+static u32 bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue)
+{
+       u32 regVal;
+       u32 max_wait_time;
+       u32 max_wait_count;
+
+       /* program the inbound AXI translation Lower Address */
+       pm8001_cw32(pm8001_ha, 1, SPC_IBW_AXI_TRANSLATION_LOW, shiftValue);
+
+       /* confirm the setting is written */
+       max_wait_time = 1 * 1000 * 1000;  /* 1 sec */
+       max_wait_count = max_wait_time;
+       do {
+               mdelay(1);
+               regVal = pm8001_cr32(pm8001_ha, 1,
SPC_IBW_AXI_TRANSLATION_LOW);
+       } while ((regVal != shiftValue) && (--max_wait_count));


Comment about "1 sec" is definitely wrong.
mdelay() is millisecond delay.
Was udelay() meant to be used here? Probably not.
Any hangs for 1000 seconds (< 17 minutes) could be explained....
[Jack] Sorry. udelay is what I want.
Can we drop max_wait_time variable? It's not helping in this case.
[Jack] will drop it ,and use max_time_count directly.
Is there any guarantee bar4_shift() will never get called from
the interrupt context?
I just ran out of time to double check.
Just want to point out it's not OK to spin on the
cpu for milliseconds at a time in that context.
[Jack] Yes it only called in process context.

....
+static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)

Doesn't this need __devinit since it's being called from pm8001_chip_init()
?

+static int __devinit pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
[Jack]__devinit will be added.
sorry...only 1500 lines or so into a 2000 line patch. Gotta run.
[Jack] Thank once more.

hope this helps,
grant

