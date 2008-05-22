From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] unable to handle kernel paging request in next-20080516
Date: Thu, 22 May 2008 12:34:41 +0100
Message-ID: <1211456081.3956.39.camel@localhost.localdomain>
References: <g0mkaf$i1r$1@ger.gmane.org>
	 <20080518021423.3dcf0ddd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51157 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759146AbYEVXp5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2008 19:45:57 -0400
In-Reply-To: <20080518021423.3dcf0ddd.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

On Sun, 2008-05-18 at 02:14 -0700, Andrew Morton wrote:
> (cc's added)
> 
> On Sat, 17 May 2008 12:50:24 +0000 (UTC) Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> 
> > Sometimes when booting next-20080516 on Ubuntu Gutsy an oops then a panic 
> > will occur. At first I thought it might be provoked by vga=0x164 but this 
> > does not appear to be the case and the issue is seemingly random. I've 
> > hand transcribed the oops so there may be errors in it but hopefully it 
> > will still help:
> > 
> > BUG: unable to handle kernel paging request at e6f17fac
> > IP: [<c02604d6>] scsi_bus_uevent+0x1/0x17
> > *pde = 2714b163 *pte = 26f17160
> > Oops: 0000 [#1] DEBUG_PAGEALLOC
> > last sysfs file:
> > 
> > Pid:  1, comm: swapper Not tainted (2.6.26-rc2-next-20080516skw #30)
> > EIP: 0060:[<c02604d6>] EFLAGS: 00010282 CPU: 0
> > EIP is at scsi_bus_uevent+0x1/0x17
> > EAX: e6f18014 EBX: e6f18014 ECX: c02604d5 EDX: e7173000
> > ESI: e7173000 EDI: e7173000 EBP: e7851ca0 ESP: e7851c90
> >  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> > Process swapper (pid: 1, ti=e7850000 task=e7848000 task.ti=e7850000)
> > Stack: e7851ca0 c0237f3a c0237eac 00000000 e7851ce4 c01da36d 00000000 e6f180fc
> >        e7835000 c03ebf42 e7163240 c03af631 c040b050 c040b598 00000000 e6f18014
> >        00000000 e7851cdc 00000000 e6f18014 00000000 e7851cec c01da52a e7851d2c
> > Call Trace:
> >  [<c0237f3a>] ? dev_uevent+0x8e/0xca
> >  [<c0237eac>] ? dev_uevent+0x0/0xca
> >  [<c01da36d>] ? kobject_uevent_env+0x14c/0x2ff
> >  [<c01da52a>] ? kobject_uevent_env+0xa/0xc
> >  [<c023884b>] ? device_add+0x2bf/0x3f0
> >  [<c0321905>] ? mutex_unlock+0x8/0xa
> >  [<c02607b4>] ? scsi_sysfs_add_sdev+0x39/0x1d3
> >  [<c025f037>] ? scsi_probe_and_add_lun+0x714/0x08
> >  [<c025f9ef>] ? __scsi_add_device+0x85/0xab
> >  [<c026a70c>] ? ata_scsi_scan_host+0x7f/0x15e
> >  [<c0267ec8>] ? ata_host_register+0x1c8/0x1e5
> >  [<c026ec75>] ? ata_pci_sff_activate_host+0x179/0x19f
> >  [<c0270b61>] ? ata_sff_interupt+0x0/0x1d7
> >  [<c026f076>] ? ata_pci_sff_init_one+0x97/0xe1
> >  [<c027219c>] ? via_init_one+0x1da/0x1e3
> >  [<c01e5670>] ? pci_device_probe+0x39/0x59
> >  [<c023a0a1>] ? driver_probe_device+0x9f/0x119
> >  [<c023a158>] ? __driver_attach+0x3d/0x5f
> >  [<c023990a>] ? bus_for_each_dev+0x3e/0x60
> >  [<c0239f39>] ? driver_attach+0x14/0x16
> >  [<c023a11b>] ? __driver_attach+0x0/0x5f
> >  [<c0239c9d>] ? bus_add_driver+0x99/0x1a0
> >  [<c023a2d6>] ? driver_register+0x71/0xcd
> >  [<c01e5852>] ? __pci_register_driver+0x53/0x81
> >  [<c04205b1>] ? kernel_init+0x0/0xc4
> >  [<c04378fc>] ? via_init+0x14/0x16
> >  [<c0132800>] ? trace_softirqs_on+0x78/0x7e
> >  [<c01dd90c>] ? trace_hardirqs_on_thunk+0xc/0x10
> >  [<c0102c3a>] ? restore_nocheck_notrace+0x0/0xe
> >  [<c04205b1>] ? kernel_init+0x0/0x1c4
> >  [<c04205b1>] ? kernel_init+0x0/0x1c4
> >  [<c010373f>] ? kernel_thread_helper+0x7/0x10
> >  =======================
> > 
> 
> I thought we'd already fixed this?

Actually, I think this is a very subtle bug; what I think is happening
is that after Hannes sysfs changes, we now add scsi_bus_type to the
target device.  However, scsi_bus_uevent() unconditionally casts from
dev to a struct scsi_device and then looks at the type entry.  My theory
is that in this particular config going from struct scsi_target to
struct device and back to struct scsi_device actually tips us over into
unmapped space for the -> type deref.

Hopefully this should fix it by checking the device type before doing
the deref.

James

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 049103f..93d2b67 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -359,7 +359,12 @@ static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 
 static int scsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_device *sdev;
+
+	if (dev->type != &scsi_dev_type)
+		return 0;
+
+	sdev = to_scsi_device(dev);
 
 	add_uevent_var(env, "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
 	return 0;


