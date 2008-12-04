From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12163] mptsas driver cannot discover some hotplugged SATA/SAS disks
Date: Thu,  4 Dec 2008 07:30:45 -0800 (PST)
Message-ID: <20081204153045.AFF7110800F@picon.linux-foundation.org>
References: <bug-12163-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232AbYLDPar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 10:30:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB4FUjJC012092
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2008 07:30:46 -0800
In-Reply-To: <bug-12163-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12163





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-12-04 07:30 -------
Reply-To: James.Bottomley@HansenPartnership.com

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

+       printk("mptsas hotplug event: event %d ioc%d SAS addr %llx device info
%x phy_id %d phys_disk_num %d\n", ev->event_type, ioc->id, ev->sas_address,
ev->device_info, ev->phy_id, ev->phys_disk_num);
+
        mutex_lock(&ioc->sas_discovery_mutex);
        switch (ev->event_type) {
        case MPTSAS_DEL_DEVICE:


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
