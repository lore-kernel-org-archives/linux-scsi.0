From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fusion: streamline ->slave_alloc/->slave_destroy
Date: Mon, 11 Oct 2004 14:39:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5705262988@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34525 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S269175AbUJKSkN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 14:40:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Saturday, October 09, 2004 8:51 AM, Christoph Hellwig wrote:
> 
> On Wed, Oct 06, 2004 at 02:25:53PM -0400, Moore, Eric Dean wrote:
> > On Saturday, October 02, 2004 2:24 AM,  Christoph Hellwig wrote:
> > > @@ -2812,59 +2796,33 @@
> > >  mptscsih_slave_destroy(struct scsi_device *device)
> > >  {
> > >  	struct Scsi_Host	*host = device->host;
> > > -	MPT_SCSI_HOST		*hd;
> > > -	VirtDevice		*vdev;
> > > -	int 			raid_volume=0;
> > > +	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
> > > +	VirtDevice		*vdev =  hd->Targets[device->id];
> > > +	uint			target = device->id;
> > > +	uint			lun = device->lun;
> > >  
> > > -	hd = (MPT_SCSI_HOST *)host->hostdata;
> > > +	mptscsih_search_running_cmds(hd, target, lun);
> > >  
> > > -	if (hd == NULL)
> > > +	vdev->luns[0] &= ~(1 << lun);
> > 
> > Ok - I'm finally getting around to testing this patch.
> > 
> > The driver will oops on this line because this routine is 
> > sometimes called when vdev=NULL.  Your patch had removed the
> > check for this NULL pointer. We probally should add it back.
> 
> Do you have a backtrace of such a case?  It really shouldn't happen
> as the vdev is allocated in ->slave_alloc, and that one returns an
> error if it couldn't allocate.
>


The problem is mptscsih_slave_destroy is being called twice. The first
time we free hd->Targets, the second time we hit the oops.  I'm still
investigating. Here is back trace using source level debugger.   Also
beyond the back trace is snip of source, having the embedded printks.



Fusion MPT base driver 3.02.05
Copyright (c) 1999-2004 LSI Logic Corporation
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities={Initiator}
Fusion MPT SCSI Host driver 3.02.05
scsi0 : ioc0: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=222, IRQ=52
allocating vdev for target=00
  Vendor: FUJITSU   Model: MAP3367NC       <7>Losing some ticks... checking
if CPU frequency changed.
  Rev: 0106
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 71775284 512-byte hdwr sectors (36749 MB)
SCSI device sda: drive cache: write through
 sda: sda1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
allocating vdev for target=01
  Vendor: FUJITSU   Model: MAP3367NC       <7>Losing some ticks... checking
if CPU frequency changed.
  Rev: 0106
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdb: 71775284 512-byte hdwr sectors (36749 MB)
SCSI device sdb: drive cache: write through
 sdb: sdb1
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
allocating vdev for target=02
  Vendor: SEAGATE   Model: ST318406LW        Rev: 0109
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdc: 35843670 512-byte hdwr sectors (18352 MB)
SCSI device sdc: drive cache: write through
 sdc: sdc1
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
allocating vdev for target=03
setting vdev=NULL, target=03
[New Thread 1]
[Switching to Thread 1]

Breakpoint 1, mptscsih_slave_destroy (device=Variable "device" is not
available.
) at drivers/message/fusion/mptscsih.c:2863
2863                    printk("BAD vdev=NULL, target=0%x\n",target);
(gdb) bt
#0  mptscsih_slave_destroy (device=Variable "device" is not available.
) at drivers/message/fusion/mptscsih.c:2863
#1  0xc025d8ca in scsi_probe_and_add_lun (host=0xc1559800, channel=Variable
"channel" is not available.
) at drivers/scsi/scsi_scan.c:775
#2  0xc025df75 in scsi_scan_target (shost=0xc1559800, channel=0x0, id=0x3,
lun=0xc1560114, rescan=0x0)
    at drivers/scsi/scsi_scan.c:1179
#3  0xc025e030 in scsi_scan_channel (shost=0xc1559800, channel=0x0, id=0x4,
lun=0xffffffff, rescan=0x0)
    at drivers/scsi/scsi_scan.c:1224
#4  0xc025e0ca in scsi_scan_host_selected (shost=0xc1559800, channel=0x1,
id=0xffffffff, lun=0xffffffff, rescan=0x0)
    at drivers/scsi/scsi_scan.c:1244
#5  0xc025e142 in scsi_scan_host (shost=Variable "shost" is not available.
) at drivers/scsi/scsi_scan.c:1258
#6  0xc0268daa in mptscsih_probe (pdev=0xdfebb000, id=Variable "id" is not
available.
) at drivers/message/fusion/mptscsih.c:1328
#7  0xc0262214 in mpt_device_driver_register (dd_cbfunc=0xc0390800,
cb_idx=Variable "cb_idx" is not available.
) at drivers/message/fusion/mptbase.c:770
#8  0xc03f49a3 in mptscsih_init () at drivers/message/fusion/mptscsih.c:1682
#9  0xc03d8683 in do_initcalls () at init/main.c:523
#10 0xc01003ea in init (unused=Variable "unused" is not available.
) at init/main.c:629
#11 0xc0104265 in kernel_thread_helper () at arch/i386/kernel/process.c:229
(gdb)


----------------------------------------------------------------------------
--

Source Snip


static int
mptscsih_slave_alloc(struct scsi_device *device)
{
	struct Scsi_Host	*host = device->host;
	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
	VirtDevice		*vdev;
	uint			target = device->id;

	if (hd == NULL)
		return -ENODEV;

	if ((vdev = hd->Targets[target]) != NULL) {
		printk("returning for target=0%x\n",target);
		goto out;
	}

	vdev = kmalloc(sizeof(VirtDevice), GFP_KERNEL);
	if (!vdev) {
		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
				hd->ioc->name, sizeof(VirtDevice));
		return -ENOMEM;
	}

	printk("allocating vdev for target=0%x\n",target);

.
.
.
.
[snip]



/*
 *	OS entry point to allow for host driver to free allocated memory
 *	Called if no device present or device being unloaded
 */
static void
mptscsih_slave_destroy(struct scsi_device *device)
{
	struct Scsi_Host	*host = device->host;
	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
	VirtDevice		*vdev;
	uint			target = device->id;
	uint			lun = device->lun;

	if (hd == NULL){
		printk("hd=NULL\n");
		return;
	}

	mptscsih_search_running_cmds(hd, target, lun);

	if ((vdev = hd->Targets[target]) == NULL) {
		printk("BAD vdev=NULL, target=0%x\n",target);
		return;
	}

	vdev->luns[0] &= ~(1 << lun);
	if (--vdev->num_luns)
		return;

	kfree(hd->Targets[target]);
	hd->Targets[target] = NULL;
	printk("setting vdev=NULL, target=0%x\n",target);

.
.
.
.
[snip]



 




 
