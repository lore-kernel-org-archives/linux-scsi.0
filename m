From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12163] mptsas driver cannot discover some hotplugged
	SATA/SAS disks
Date: Thu, 04 Dec 2008 09:30:39 -0600
Message-ID: <1228404639.3363.6.camel@localhost.localdomain>
References: <20081204084754.63F38108043@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36147 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260AbYLDPag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 10:30:36 -0500
In-Reply-To: <20081204084754.63F38108043@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-12-04 at 00:47 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12163


> Latest working kernel version: No
> Earliest failing kernel version: 2.6.22.16
> Distribution: LinuxFromScratch-6.4
> Hardware Environment: LSI-MPTSAS-1068E
> (http://www.lsi.com/storage_home/products_home/standard_product_ics/sas_ics/lsisas1068e/index.html)
> Software Environment:
> Problem Description: mptsas driver cannot discover some hotplugged SATA/SAS
> disks
> 
> Steps to reproduce:
> 1. use LSI-SAS-1068E controller to manage multiple disks, including disks on
> multiple JBODs;
> 2. hotunplug and hotplug the disks at random places;
> 
> Result:
> 1. disks direct attached can can rediscovered, disks on the last JBOD can also
> be rediscovered, other disks cannot.
> 
> Like this, disks on HEAD and JBOD3 can be rediscovered, others on JBOD1 and
> JBOD2 cannot.
> 
> HEAD  <=> JBOD1 <=> JBOD2 <=> JBOD3

My suspicion is that this is because there's no firmware event triggered
(the LSI is a fat firmware device, it relies on firmware for almost
everything to function including hotplug).  If this is true, it's
unfixable in the driver.

To verify, try this patch which will print out all the fw events and see
if it prints anything when you hotplug.

James

---

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 12b7325..e755bdd 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2600,6 +2600,8 @@ mptsas_hotplug_work(struct work_struct *work)
 	VirtTarget *vtarget;
 	VirtDevice *vdevice;
 
+	printk("mptsas hotplug event: event %d ioc%d SAS addr %llx device info %x phy_id %d phys_disk_num %d\n", ev->event_type, ioc->id, ev->sas_address, ev->device_info, ev->phy_id, ev->phys_disk_num);
+
 	mutex_lock(&ioc->sas_discovery_mutex);
 	switch (ev->event_type) {
 	case MPTSAS_DEL_DEVICE:


