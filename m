From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: lpfc PCIe error recovey
Date: Thu, 11 Jan 2007 16:26:02 -0600
Message-ID: <20070111222602.GA25183@austin.ibm.com>
References: <332A49C36DB0F64198D1A011FB1AA79135B2BA@xbl3.emulex.com> <20070110225939.GB6177@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:59651 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667AbXAKW0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 17:26:05 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMQ4CB023625
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:26:04 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMQ3UV552048
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 15:26:03 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMQ2uG005629
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 15:26:03 -0700
Content-Disposition: inline
In-Reply-To: <20070110225939.GB6177@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bino.Sebastian@Emulex.Com
Cc: James.Smart@Emulex.Com, rlary@us.ibm.com, Laurie.Barry@Emulex.Com, strosake@us.ibm.com, vaios.papadimitriou@Emulex.Com, linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-scsi@vger.kernel.org

On Wed, Jan 10, 2007 at 04:59:39PM -0600, linas wrote:
> 
> > However, on a Power4 architecture there are errors reported
> > in upper layer (we discussed this in one of earlier emails) followed 
> > by SCSI errors.
> 
> I'm trying to investigate now.

I found two distinct power4 bugs. I posted a patch for one yesterday,
under the subject heading 

  [PATCH] Urgent: powerpc 2.6.20-rc4 dma broken on non-LPAR pseries

This affects only recent mainline kernels; it would not affect
older or distro kernels.   

The other patch is attached below.  After some more testing,
I'll submit to mainline.

--linas


Subject: [PATCH] pSeries: EEH improperly enabled for some Power4 systems

It appears that EEH is improperly enabled for some Power4 systems.
On these systems, the ibm,set-eeh-option returns a value of success
even when EEH is not supported on the given node. Thus, an explicit
check for support is required.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com> 

----
 arch/powerpc/platforms/pseries/eeh.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6.20-rc4/arch/powerpc/platforms/pseries/eeh.c
===================================================================
--- linux-2.6.20-rc4.orig/arch/powerpc/platforms/pseries/eeh.c	2007-01-11 14:15:02.000000000 -0600
+++ linux-2.6.20-rc4/arch/powerpc/platforms/pseries/eeh.c	2007-01-11 15:14:39.000000000 -0600
@@ -748,6 +748,7 @@ struct eeh_early_enable_info {
 /* Enable eeh for the given device node. */
 static void *early_enable_eeh(struct device_node *dn, void *data)
 {
+	unsigned int rets[3];
 	struct eeh_early_enable_info *info = data;
 	int ret;
 	const char *status = get_property(dn, "status", NULL);
@@ -804,16 +805,14 @@ static void *early_enable_eeh(struct dev
 		                regs[0], info->buid_hi, info->buid_lo,
 		                EEH_ENABLE);
 
+		enable = 0;
 		if (ret == 0) {
-			eeh_subsystem_enabled = 1;
-			pdn->eeh_mode |= EEH_MODE_SUPPORTED;
 			pdn->eeh_config_addr = regs[0];
 
 			/* If the newer, better, ibm,get-config-addr-info is supported, 
 			 * then use that instead. */
 			pdn->eeh_pe_config_addr = 0;
 			if (ibm_get_config_addr_info != RTAS_UNKNOWN_SERVICE) {
-				unsigned int rets[2];
 				ret = rtas_call (ibm_get_config_addr_info, 4, 2, rets, 
 					pdn->eeh_config_addr, 
 					info->buid_hi, info->buid_lo,
@@ -821,6 +820,20 @@ static void *early_enable_eeh(struct dev
 				if (ret == 0)
 					pdn->eeh_pe_config_addr = rets[0];
 			}
+
+			/* Some older systems (Power4) allow the
+			 * ibm,set-eeh-option call to succeed even on nodes
+			 * where EEH is not supported. Verify support
+			 * explicitly. */
+			ret = read_slot_reset_state(pdn, rets);
+			if ((ret == 0) && (rets[1] == 1))
+				enable = 1;
+		}
+
+		if (enable) {
+			eeh_subsystem_enabled = 1;
+			pdn->eeh_mode |= EEH_MODE_SUPPORTED;
+
 #ifdef DEBUG
 			printk(KERN_DEBUG "EEH: %s: eeh enabled, config=%x pe_config=%x\n",
 			       dn->full_name, pdn->eeh_config_addr, pdn->eeh_pe_config_addr);

