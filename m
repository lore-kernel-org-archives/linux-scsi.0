From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 15:47:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015194705.GD4391@redhat.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>
Cc: 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 15, 2002 at 02:55:46PM -0400, Jeffery, David wrote:
> Dave,
> 
> Here's a patch that should restore the queue depths to what they were before
> the
> queue depths change was merged in.  Hopefully this well restore your lost
> performance.  If I don't hear or find anything bad about it, it will be
> going
> to Linus shortly.
> 
> And thanks goes to Mike Anderson for his initial version.  That made writing
> this patch all the easier.


I actually sent a patch to linus already to do this but it hasn't come 
through yet.  However, my patch and yours differ in one key point that I 
don't understand.

The scsi mid layer will never send you more than host->can_queue commands 
at one time, so why do all the scsi driver authors feel it is necessary to 
split their queue depth up amongst devices?  Justin Gibbs is the only one 
that gets it right IMHO.  Set the depth on each device as deep as that 
device can take (if that happens to be host->can_queue - 1 or such, then 
so be it).  Then, let the mid layer and the request function worry about 
fairness across devices.  That's its job after all.  If everyone is going 
to moderate their queue depths like that, then we might as well yank 
can_queue out of the host struct entirely because *it serves no purpose*.

Now, simple scsi controllers like the aic7xxx and intelligent raid 
controllers are two different beasts.  On simple controllers, the max 
queue depth on a target is typically whatever that target can handle.  On 
raid controllers, it's all up to what the firmware can handle (for all I 
know, the ServeRAID firmware may have one queue depth limit for total 
commands and a separate queue depth limit on each logical device).  So, I 
can't say for sure what the ips driver can and can't do, but I'm 
relatively sure that you are artificially limiting your own performance by 
handling queue depths the way you are.

Oh, also, host->cmd_per_lun is suppossed to be the automatic queue depth
on untagged devices.  16 is typically way excessive for an untagged device
(and I'm not even sure you support untagged pass-through devices on ips,
and if you do I have no clue if the firmware will properly queue up
untagged commands on a pass through device), so I changed that as well.  
So, attached are the 3 different patches I sent to linus on this driver.  
I would be interested to know what happens to performance on this driver 
if you follow my suggestion of letting the mid layer take care of watching 
the card's maximum queue depth and start letting the drives have queues as 
deep as they can handle.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ips.patch"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.754   -> 1.755  
#	  drivers/scsi/ips.c	1.26    -> 1.27   
#	  drivers/scsi/ips.h	1.9     -> 1.10   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/10/11	dledford@aladin.rdu.redhat.com	1.755
# Make the rest of the world happy with ips again
# --------------------------------------------
#
diff -Nru a/drivers/scsi/ips.c b/drivers/scsi/ips.c
--- a/drivers/scsi/ips.c	Fri Oct 11 14:28:18 2002
+++ b/drivers/scsi/ips.c	Fri Oct 11 14:28:18 2002
@@ -433,6 +433,7 @@
 int ips_eh_reset(Scsi_Cmnd *);
 int ips_queue(Scsi_Cmnd *, void (*) (Scsi_Cmnd *));
 int ips_biosparam(Disk *, struct block_device *, int *);
+int ips_slave_attach(Scsi_Device *);
 const char * ips_info(struct Scsi_Host *);
 void do_ipsintr(int, void *, struct pt_regs *);
 static int ips_hainit(ips_ha_t *);
@@ -481,7 +482,7 @@
 static void ips_free_flash_copperhead(ips_ha_t *ha);
 static void ips_get_bios_version(ips_ha_t *, int);
 static void ips_identify_controller(ips_ha_t *);
-static void ips_select_queue_depth(struct Scsi_Host *, Scsi_Device *);
+//static void ips_select_queue_depth(struct Scsi_Host *, Scsi_Device *);
 static void ips_chkstatus(ips_ha_t *, IPS_STATUS *);
 static void ips_enable_int_copperhead(ips_ha_t *);
 static void ips_enable_int_copperhead_memio(ips_ha_t *);
@@ -1087,7 +1088,7 @@
          sh->n_io_port = io_addr ? 255 : 0;
          sh->unique_id = (io_addr) ? io_addr : mem_addr;
          sh->irq = irq;
-         sh->select_queue_depths = ips_select_queue_depth;
+         //sh->select_queue_depths = ips_select_queue_depth;
          sh->sg_tablesize = sh->hostt->sg_tablesize;
          sh->can_queue = sh->hostt->can_queue;
          sh->cmd_per_lun = sh->hostt->cmd_per_lun;
@@ -1827,7 +1828,7 @@
 /*   Select queue depths for the devices on the contoller                   */
 /*                                                                          */
 /****************************************************************************/
-static void
+/*static void
 ips_select_queue_depth(struct Scsi_Host *host, Scsi_Device *scsi_devs) {
    Scsi_Device *device;
    ips_ha_t    *ha;
@@ -1860,6 +1861,30 @@
       }
    }
 }
+*/
+
+/****************************************************************************/
+/*                                                                          */
+/* Routine Name: ips_slave_attach                                           */
+/*                                                                          */
+/* Routine Description:                                                     */
+/*                                                                          */
+/*   Set queue depths on devices once scan is complete                      */
+/*                                                                          */
+/****************************************************************************/
+int
+ips_slave_attach(Scsi_Device *SDptr)
+{
+   ips_ha_t    *ha;
+   int          min;
+
+   ha = IPS_HA(SDptr->host);
+   min = ha->max_cmds / 4;
+   if (min < 8)
+      min = ha->max_cmds - 1;
+   scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);
+   return 0;
+}
 
 /****************************************************************************/
 /*                                                                          */
@@ -7407,7 +7432,7 @@
     sh->n_io_port = io_addr ? 255 : 0;
     sh->unique_id = (io_addr) ? io_addr : mem_addr;
     sh->irq = irq;
-    sh->select_queue_depths = ips_select_queue_depth;
+    //sh->select_queue_depths = ips_select_queue_depth;
     sh->sg_tablesize = sh->hostt->sg_tablesize;
     sh->can_queue = sh->hostt->can_queue;
     sh->cmd_per_lun = sh->hostt->cmd_per_lun;
diff -Nru a/drivers/scsi/ips.h b/drivers/scsi/ips.h
--- a/drivers/scsi/ips.h	Fri Oct 11 14:28:18 2002
+++ b/drivers/scsi/ips.h	Fri Oct 11 14:28:18 2002
@@ -60,6 +60,7 @@
    extern int ips_eh_reset(Scsi_Cmnd *);
    extern int ips_queue(Scsi_Cmnd *, void (*) (Scsi_Cmnd *));
    extern int ips_biosparam(Disk *, struct block_device *, int *);
+   extern int ips_slave_attach(Scsi_Device *);
    extern const char * ips_info(struct Scsi_Host *);
    extern void do_ips(int, void *, struct pt_regs *);
 
@@ -481,7 +482,8 @@
     eh_host_reset_handler : ips_eh_reset, \
     abort : NULL,                         \
     reset : NULL,                         \
-    slave_attach : NULL,                  \
+    slave_attach : ips_slave_attach,      \
+    slave_detach : NULL,                  \
     bios_param : ips_biosparam,           \
     can_queue : 0,                        \
     this_id: -1,                          \

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ip2-2.patch"

diff -Nru a/drivers/scsi/ips.c b/drivers/scsi/ips.c
--- a/drivers/scsi/ips.c	Fri Oct 11 16:42:41 2002
+++ b/drivers/scsi/ips.c	Fri Oct 11 16:42:41 2002
@@ -1879,10 +1879,12 @@
    int          min;
 
    ha = IPS_HA(SDptr->host);
-   min = ha->max_cmds / 4;
-   if (min < 8)
-      min = ha->max_cmds - 1;
-   scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);
+   if (SDptr->tagged_supported) {
+      min = ha->max_cmds / 2;
+      if (min <= 16)
+         min = ha->max_cmds - 1;
+      scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);
+   }
    return 0;
 }
 

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ips.h.patch"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.782.2.2 -> 1.782.2.3
#	  drivers/scsi/ips.h	1.11    -> 1.12   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/10/12	dledford@aladin.rdu.redhat.com	1.782.2.3
# ips.h:
#   Since we now have proper tagged depth setting, make
#   the cmd_per_lun value reasonable for untagged devices
#   like it is suppossed to be.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/ips.h b/drivers/scsi/ips.h
--- a/drivers/scsi/ips.h	Mon Oct 14 15:06:26 2002
+++ b/drivers/scsi/ips.h	Mon Oct 14 15:06:26 2002
@@ -429,7 +429,7 @@
     can_queue : 0,                        \
     this_id: -1,                          \
     sg_tablesize : IPS_MAX_SG,            \
-    cmd_per_lun: 16,                      \
+    cmd_per_lun: 3,                       \
     present : 0,                          \
     unchecked_isa_dma : 0,                \
     use_clustering : ENABLE_CLUSTERING,   \
@@ -458,7 +458,7 @@
     can_queue : 0,                        \
     this_id: -1,                          \
     sg_tablesize : IPS_MAX_SG,            \
-    cmd_per_lun: 16,                      \
+    cmd_per_lun: 3,                       \
     present : 0,                          \
     unchecked_isa_dma : 0,                \
     use_clustering : ENABLE_CLUSTERING,   \
@@ -488,7 +488,7 @@
     can_queue : 0,                        \
     this_id: -1,                          \
     sg_tablesize : IPS_MAX_SG,            \
-    cmd_per_lun: 16,                      \
+    cmd_per_lun: 3,                       \
     present : 0,                          \
     unchecked_isa_dma : 0,                \
     use_clustering : ENABLE_CLUSTERING,   \

--fUYQa+Pmc3FrFX/N--
