From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Date: Mon, 30 May 2011 00:26:48 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAD84C40@SC-VEXCH4.marvell.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
 <20110526021809.GA22496@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
 <20110526141430.GD4164@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD848FB@SC-VEXCH4.marvell.com>
 <20110527073302.GA16178@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110527073302.GA16178@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "jslaby@suse.cz" <jslaby@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 26, 2011 at 08:23:18PM -0700, Xiangliang Yu wrote:
>> > >>Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt >>>>coalescing to device attributes in sysfs
>> 
>> > >>On Thu, May 26, 2011 at 02:00:21AM -0700, Xiangliang Yu wrote:
>> > >
>> > >Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt >>coalescing to device attributes in sysfs
>> > >> 
>> > >> -- Add support for driver version and interrupt coalescing device attributes.
>> > >>
>> > >>When you add a sysfs file, you must also add a Documentation/ABI file as
>> > >>well.  Please do that here.
>> > >
> > >>These device attributes are sysft class properties for the scsi host,
>> >> >and the sysfs files are within scsi host sysfs directory. so, do you
>> >> think I need add a ABI file?  and , I can't find anything about scsi
>> >> host sysfs file under directory Documentation/ABI.
>> 
>> >Yes, again, if you add a sysfs file, you need to add documentation
>> >explaining exactly what it is there for and what it does.
>> >
>> >And if there isn't already a file for this device, then please add it.
>> How about this:
>> 
>> .../ABI/testing/sysfs-bus-pci-scsi-devices-mvsas   |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas
>> 
>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas b/Documentation/ABI/testing/sysfs-bus-pci-scsi
>> -devices-mvsas
>> new file mode 100644
>> index 0000000..45f597e
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas
>> @@ -0,0 +1,13 @@
>> +What:          >/sys/devices/pci/<devices>/<dev>/host/scsi_host/host/driver_version
>> +Date:          May 2011
>> +Kernel Version:        2.6.39
>> +Contact:       yuxiangl@marvell.com
> >+Description:   Display the mvsas drivers version

>A driver version should never show up down here in sysfs, use the proper
>place for this like the rest of the kernel's drivers do (hint, look at
>MODULE_VERSION() and where that ends up, in your module's sysfs
>directory.)
OK! Thanks!

>> +What:          /sys/devices/pci/<devices>/<dev>/host/scsi_host/host/interrupt_coalescing
>> +Date:          May 2011
>> +Kernel Version:        2.6.39

>2.6.39 was released already, is this file in that release?
Yes.

>> +Contact:       yuxiangl@marvell.com
>> +Description:   Determines the maximum time the 88SE94XX waits after the occurrence of a
>> +               Command Done before generating an interrupt.The maximum number of the 
>> +               variable is less than 0x10000.

>Why would a user, or anyone else, ever want to be able to change this?
Because different platform can get better performance by setting different value

>Why wouldn't this just be something that the driver handles
>automagically so the user never has to worry about it at all?
As for now, driver can't do it. The value need to be test, and get the best.

>You also don't specify the units involved here, which is not good.
OK, thanks!

>See, when you document things, it's easier to notice when you did
>something you didn't need to do (i.e. the driver version thing).  :)
Yes, thanks!

I modify this patch, pls review it, thanks!

.../ABI/testing/sysfs-bus-pci-scsi-devices-mvsas   |    7 ++
 drivers/scsi/mvsas/mv_64xx.c                       |   25 ++++++++-
 drivers/scsi/mvsas/mv_94xx.c                       |   26 ++++++++-
 drivers/scsi/mvsas/mv_init.c                       |   62 ++++++++++++++++++++
 drivers/scsi/mvsas/mv_sas.h                        |    2 +
 5 files changed, 120 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas b/Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas
new file mode 100644
index 0000000..fe8a87c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas
@@ -0,0 +1,7 @@
+What:		/sys/devices/pci/<devices>/<dev>/host/scsi_host/host/interrupt_coalescing
+Date:		May 2011
+Kernel Version:	2.6.39
+Contact:	yuxiangl@marvell.com
+Description:	Determines the maximum time the 88SE94XX waits after the occurrence of a
+		Command Done before generating an interrupt.You can get better HBA performance
+		by changing interrupt_coalescing value.
diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 0e13e64..c88b8a7 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -402,7 +402,7 @@ static int __devinit mvs_64xx_init(struct mvs_info *mvi)
 	tmp = 0;
 	mw32(MVS_INT_COAL, tmp);
 
-	tmp = 0x100;
+	tmp = 0x10000 | interrupt_coalescing;
 	mw32(MVS_INT_COAL_TMOUT, tmp);
 
 	/* ladies and gentlemen, start your engines */
@@ -758,6 +758,28 @@ void mvs_64xx_fix_dma(dma_addr_t buf_dma, int buf_len, int from, void *prd)
 }
 #endif
 
+static void mvs_64xx_tune_interrupt(struct mvs_info *mvi, u32 time)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp = 0;
+	/* interrupt coalescing may cause missing HW interrput in some case,
+	 * and the max count is 0x1ff, while our max slot is 0x200,
+	 * it will make count 0.
+	 */
+	if (time == 0) {
+		mw32(MVS_INT_COAL, 0);
+		mw32(MVS_INT_COAL_TMOUT, 0x10000);
+	} else {
+		if (MVS_CHIP_SLOT_SZ > 0x1ff)
+			mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
+		else
+			mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
+
+		tmp = 0x10000 | time;
+		mw32(MVS_INT_COAL_TMOUT, tmp);
+	}
+}
+
 const struct mvs_dispatch mvs_64xx_dispatch = {
 	"mv64xx",
 	mvs_64xx_init,
@@ -811,6 +833,7 @@ const struct mvs_dispatch mvs_64xx_dispatch = {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	mvs_64xx_fix_dma,
 #endif
+	mvs_64xx_tune_interrupt,
 	NULL,
 };
 
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 3f2ad93..e589f31 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -475,7 +475,7 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	tmp = 0;
 	mw32(MVS_INT_COAL, tmp);
 
-	tmp = 0x100;
+	tmp = 0x10000 | interrupt_coalescing;
 	mw32(MVS_INT_COAL_TMOUT, tmp);
 
 	/* ladies and gentlemen, start your engines */
@@ -894,6 +894,29 @@ static void mvs_94xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set,
 {
 }
 
+static void mvs_94xx_tune_interrupt(struct mvs_info *mvi, u32 time)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp = 0;
+	/* interrupt coalescing may cause missing HW interrput in some case,
+	 * and the max count is 0x1ff, while our max slot is 0x200,
+	 * it will make count 0.
+	 */
+	if (time == 0) {
+		mw32(MVS_INT_COAL, 0);
+		mw32(MVS_INT_COAL_TMOUT, 0x10000);
+	} else {
+		if (MVS_CHIP_SLOT_SZ > 0x1ff)
+			mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
+		else
+			mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
+
+		tmp = 0x10000 | time;
+		mw32(MVS_INT_COAL_TMOUT, tmp);
+	}
+
+}
+
 const struct mvs_dispatch mvs_94xx_dispatch = {
 	"mv94xx",
 	mvs_94xx_init,
@@ -947,6 +970,7 @@ const struct mvs_dispatch mvs_94xx_dispatch = {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	mvs_94xx_fix_dma,
 #endif
+	mvs_94xx_tune_interrupt,
 	mvs_94xx_non_spec_ncq_error,
 };
 
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 9f1cccc..eb5fb91 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -34,6 +34,8 @@ MODULE_PARM_DESC(collector, "\n"
 	"\tThe mvsas SAS LLDD supports both modes.\n"
 	"\tDefault: 1 (Direct Mode).\n");
 
+int interrupt_coalescing = 0x80;
+
 static struct scsi_transport_template *mvs_stt;
 struct kmem_cache *mvs_task_list_cache;
 static const struct mvs_chip_info mvs_chips[] = {
@@ -48,6 +50,8 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 };
 
+struct device_attribute *mvst_host_attrs[];
+
 #define SOC_SAS_NUM 2
 #define SG_MX 64
 
@@ -74,6 +78,7 @@ static struct scsi_host_template mvs_sht = {
 	.slave_alloc		= mvs_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+	.shost_attrs		= mvst_host_attrs,
 };
 
 static struct sas_domain_function_template mvs_transport_ops = {
@@ -706,6 +711,58 @@ static struct pci_driver mvs_pci_driver = {
 	.remove		= __devexit_p(mvs_pci_remove),
 };
 
+static ssize_t
+mvs_store_interrupt_coalescing(struct device *cdev,
+			struct device_attribute *attr,
+			const char *buffer, size_t size)
+{
+	int val = 0;
+	struct mvs_info *mvi = NULL;
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	u8 i, core_nr;
+	if (buffer == NULL)
+		return size;
+
+	if (sscanf(buffer, "%d", &val) != 1)
+		return -EINVAL;
+
+	if (val >= 0x10000) {
+		mv_dprintk("interrupt coalescing timer %d us is"
+			"too long\n", val);
+		return strlen(buffer);
+	}
+
+	interrupt_coalescing = val;
+
+	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
+	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
+
+	if (unlikely(!mvi))
+		return -EINVAL;
+
+	for (i = 0; i < core_nr; i++) {
+		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
+		if (MVS_CHIP_DISP->tune_interrupt)
+			MVS_CHIP_DISP->tune_interrupt(mvi,
+				interrupt_coalescing);
+	}
+	mv_dprintk("set interrupt coalescing time to %d us\n",
+		interrupt_coalescing);
+	return strlen(buffer);
+}
+
+static ssize_t mvs_show_interrupt_coalescing(struct device *cdev,
+			struct device_attribute *attr, char *buffer)
+{
+	return snprintf(buffer, PAGE_SIZE, "%d\n", interrupt_coalescing);
+}
+
+static DEVICE_ATTR(interrupt_coalescing,
+			 S_IRUGO|S_IWUSR,
+			 mvs_show_interrupt_coalescing,
+			 mvs_store_interrupt_coalescing);
+
 /* task handler */
 struct task_struct *mvs_th;
 static int __init mvs_init(void)
@@ -742,6 +799,11 @@ static void __exit mvs_exit(void)
 	kmem_cache_destroy(mvs_task_list_cache);
 }
 
+struct device_attribute *mvst_host_attrs[] = {
+	&dev_attr_interrupt_coalescing,
+	NULL,
+};
+
 module_init(mvs_init);
 module_exit(mvs_exit);
 
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 8740b78..fed8495 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -64,6 +64,7 @@
 #endif
 #define MV_MAX_U32			0xffffffff
 
+extern int interrupt_coalescing;
 extern struct mvs_tgt_initiator mvs_tgt;
 extern struct mvs_info *tgt_mvi;
 extern const struct mvs_dispatch mvs_64xx_dispatch;
@@ -170,6 +171,7 @@ struct mvs_dispatch {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	void (*dma_fix)(dma_addr_t buf_dma, int buf_len, int from, void *prd);
 #endif
+	void (*tune_interrupt)(struct mvs_info *mvi, u32 time);
 	void (*non_spec_ncq_error)(struct mvs_info *mvi);
 
 };
-- 
1.7.4.4
