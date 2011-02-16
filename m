From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [GIT PULL] SCSI fixes for 2.6.38-rc5
Date: Wed, 16 Feb 2011 08:46:28 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8722614B5D0@AVEXMB1.qlogic.org>
References: <1297873350.3014.62.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:13898
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab1BPQqp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 11:46:45 -0500
In-Reply-To: <1297873350.3014.62.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of James Bottomley
> Sent: Wednesday, February 16, 2011 8:23 AM
> To: Andrew Morton; Linus Torvalds
> Cc: linux-scsi; linux-kernel
> Subject: [GIT PULL] SCSI fixes for 2.6.38-rc5
>
> This is slightly bigger than I would like.  It's mostly small fixes,
> especially the module removal oops related ones (slub poisoning oops on
> module removal and configfs shutdown oops) in the new target stuff.  The
> big diff is the removal of a /proc interface in target (the mib code)
> that shouldn't have made it in in the first place.  We need to do this
> in -rc so we don't get tied into a deprecated interface (it will be
> reintroduced at a /sys based interface in one of the merge windows).
>
> The patch is available here:
>
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
>
> The short changelog is:
>
> Andrew Vasquez (1):
>       qla2xxx: Return DID_NO_CONNECT when FC device is lost.
>

James, Thanks for including the above patch.

> Dan Carpenter (1):
>       target: iblock/pscsi claim checking for NULL instead of IS_ERR
>
> Darrick J. Wong (1):
>       scsi_debug: Fix 32-bit overflow in do_device_access causing memory
> corruption
>
> Fubo Chen (1):
>       target: fixed missing lock drop in error path
>
> James Bottomley (1):
>       qla2xxx: Fix race that could hang kthread_stop()
>
> Kashyap, Desai (3):
>       mptfusion: Bump version 03.04.18
>       mptfusion: Fix Incorrect return value in mptscsih_dev_reset
>       mptfusion: mptctl_release is required in mptctl.c
>
> Madhuranath Iyengar (1):
>       qla2xxx: Change from irq to irqsave with host_lock
>

James, thanks for including our patch above. There was an update version patch that I had submitted along with the above and Andrew Vasquesz's patch (also above) on Jan 28th, that's missing in this list. Just curious if it was accidentally missed or if it's intentionally not going to added for a reason. As you might be aware, we have the practice of bumping up the version of the driver after every scsi-rc and scsi-misc updates.

> Nicholas Bellinger (6):
>       target: fix use after free detected by SLUB poison
>       target: Remove procfs based target_core_mib.c code
>       target: Fix SCF_SCSI_CONTROL_SG_IO_CDB breakage
>       target: Fix top-level configfs_subsystem default_group shutdown
> breakage
>       target: Fix demo-mode MappedLUN shutdown UA/PR breakage
>       target/iblock: Fix failed bd claim NULL pointer dereference
>
> And the diffstat:
>
>  drivers/message/fusion/mptbase.h             |    4 +-
>  drivers/message/fusion/mptctl.c              |    8 +
>  drivers/message/fusion/mptscsih.c            |    7 +-
>  drivers/scsi/qla2xxx/qla_attr.c              |    5 +-
>  drivers/scsi/qla2xxx/qla_init.c              |   10 +-
>  drivers/scsi/qla2xxx/qla_os.c                |   10 +-
>  drivers/scsi/scsi_debug.c                    |    2 +-
>  drivers/target/Makefile                      |    3 +-
>  drivers/target/target_core_configfs.c        |  155 ++--
>  drivers/target/target_core_device.c          |   13 +-
>  drivers/target/target_core_fabric_configfs.c |   92 ++-
>  drivers/target/target_core_iblock.c          |    8 +-
>  drivers/target/target_core_mib.c             | 1078 ---------------------
> -----
>  drivers/target/target_core_mib.h             |   28 -
>  drivers/target/target_core_pscsi.c           |    4 +-
>  drivers/target/target_core_tpg.c             |   29 +-
>  drivers/target/target_core_transport.c       |   48 +-
>  include/target/target_core_base.h            |   28 +-
>  include/target/target_core_transport.h       |    2 +
>  19 files changed, 278 insertions(+), 1256 deletions(-)
>  delete mode 100644 drivers/target/target_core_mib.c
>  delete mode 100644 drivers/target/target_core_mib.h
>
> The full diff is below.
>
> James
>
> ---
>
> diff --git a/drivers/message/fusion/mptbase.h
> b/drivers/message/fusion/mptbase.h
> index f71f229..1735c84 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -76,8 +76,8 @@
>  #define COPYRIGHT    "Copyright (c) 1999-2008 " MODULEAUTHOR
>  #endif
>
> -#define MPT_LINUX_VERSION_COMMON     "3.04.17"
> -#define MPT_LINUX_PACKAGE_NAME               "@(#)mptlinux-3.04.17"
> +#define MPT_LINUX_VERSION_COMMON     "3.04.18"
> +#define MPT_LINUX_PACKAGE_NAME               "@(#)mptlinux-3.04.18"
>  #define WHAT_MAGIC_STRING            "@" "(" "#" ")"
>
>  #define show_mptmod_ver(s,ver)  \
> diff --git a/drivers/message/fusion/mptctl.c
> b/drivers/message/fusion/mptctl.c
> index a3856ed..e8deb8e 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -597,6 +597,13 @@ mptctl_event_process(MPT_ADAPTER *ioc,
> EventNotificationReply_t *pEvReply)
>  }
>
>  static int
> +mptctl_release(struct inode *inode, struct file *filep)
> +{
> +     fasync_helper(-1, filep, 0, &async_queue);
> +     return 0;
> +}
> +
> +static int
>  mptctl_fasync(int fd, struct file *filep, int mode)
>  {
>       MPT_ADAPTER     *ioc;
> @@ -2815,6 +2822,7 @@ static const struct file_operations mptctl_fops = {
>       .llseek =       no_llseek,
>       .fasync =       mptctl_fasync,
>       .unlocked_ioctl = mptctl_ioctl,
> +     .release =      mptctl_release,
>  #ifdef CONFIG_COMPAT
>       .compat_ioctl = compat_mpctl_ioctl,
>  #endif
> diff --git a/drivers/message/fusion/mptscsih.c
> b/drivers/message/fusion/mptscsih.c
> index 59b8f53..0d9b82a 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1873,8 +1873,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
>       }
>
>   out:
> -     printk(MYIOC_s_INFO_FMT "task abort: %s (sc=%p)\n",
> -         ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), SCpnt);
> +     printk(MYIOC_s_INFO_FMT "task abort: %s (rv=%04x) (sc=%p)
> (sn=%ld)\n",
> +         ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), retval,
> +         SCpnt, SCpnt->serial_number);
>
>       return retval;
>  }
> @@ -1911,7 +1912,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
>
>       vdevice = SCpnt->device->hostdata;
>       if (!vdevice || !vdevice->vtarget) {
> -             retval = SUCCESS;
> +             retval = 0;
>               goto out;
>       }
>
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c
> b/drivers/scsi/qla2xxx/qla_attr.c
> index 44578b5..d3e58d7 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1561,6 +1561,7 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
>  {
>       struct Scsi_Host *host = rport_to_shost(rport);
>       fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
> +     unsigned long flags;
>
>       if (!fcport)
>               return;
> @@ -1573,10 +1574,10 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport
> *rport)
>        * Transport has effectively 'deleted' the rport, clear
>        * all local references.
>        */
> -     spin_lock_irq(host->host_lock);
> +     spin_lock_irqsave(host->host_lock, flags);
>       fcport->rport = fcport->drport = NULL;
>       *((fc_port_t **)rport->dd_data) = NULL;
> -     spin_unlock_irq(host->host_lock);
> +     spin_unlock_irqrestore(host->host_lock, flags);
>
>       if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
>               return;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c
> b/drivers/scsi/qla2xxx/qla_init.c
> index f948e1a..d9479c3 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2505,11 +2505,12 @@ qla2x00_rport_del(void *data)
>  {
>       fc_port_t *fcport = data;
>       struct fc_rport *rport;
> +     unsigned long flags;
>
> -     spin_lock_irq(fcport->vha->host->host_lock);
> +     spin_lock_irqsave(fcport->vha->host->host_lock, flags);
>       rport = fcport->drport ? fcport->drport: fcport->rport;
>       fcport->drport = NULL;
> -     spin_unlock_irq(fcport->vha->host->host_lock);
> +     spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
>       if (rport)
>               fc_remote_port_delete(rport);
>  }
> @@ -2879,6 +2880,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha,
> fc_port_t *fcport)
>       struct fc_rport_identifiers rport_ids;
>       struct fc_rport *rport;
>       struct qla_hw_data *ha = vha->hw;
> +     unsigned long flags;
>
>       qla2x00_rport_del(fcport);
>
> @@ -2893,9 +2895,9 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha,
> fc_port_t *fcport)
>                   "Unable to allocate fc remote port!\n");
>               return;
>       }
> -     spin_lock_irq(fcport->vha->host->host_lock);
> +     spin_lock_irqsave(fcport->vha->host->host_lock, flags);
>       *((fc_port_t **)rport->dd_data) = fcport;
> -     spin_unlock_irq(fcport->vha->host->host_lock);
> +     spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
>
>       rport->supported_classes = fcport->supported_classes;
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c194c23..f27724d 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -562,7 +562,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void
> (*done)(struct scsi_cmnd *)
>       }
>       if (atomic_read(&fcport->state) != FCS_ONLINE) {
>               if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
> -                     atomic_read(&fcport->state) == FCS_DEVICE_LOST ||
>                       atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
>                       cmd->result = DID_NO_CONNECT << 16;
>                       goto qc24_fail_command;
> @@ -2513,6 +2512,7 @@ qla2x00_schedule_rport_del(struct scsi_qla_host
> *vha, fc_port_t *fcport,
>  {
>       struct fc_rport *rport;
>       scsi_qla_host_t *base_vha;
> +     unsigned long flags;
>
>       if (!fcport->rport)
>               return;
> @@ -2520,9 +2520,9 @@ qla2x00_schedule_rport_del(struct scsi_qla_host
> *vha, fc_port_t *fcport,
>       rport = fcport->rport;
>       if (defer) {
>               base_vha = pci_get_drvdata(vha->hw->pdev);
> -             spin_lock_irq(vha->host->host_lock);
> +             spin_lock_irqsave(vha->host->host_lock, flags);
>               fcport->drport = rport;
> -             spin_unlock_irq(vha->host->host_lock);
> +             spin_unlock_irqrestore(vha->host->host_lock, flags);
>               set_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
>               qla2xxx_wake_dpc(base_vha);
>       } else
> @@ -3282,10 +3282,10 @@ qla2x00_do_dpc(void *data)
>
>       set_user_nice(current, -20);
>
> +     set_current_state(TASK_INTERRUPTIBLE);
>       while (!kthread_should_stop()) {
>               DEBUG3(printk("qla2x00: DPC handler sleeping\n"));
>
> -             set_current_state(TASK_INTERRUPTIBLE);
>               schedule();
>               __set_current_state(TASK_RUNNING);
>
> @@ -3454,7 +3454,9 @@ qla2x00_do_dpc(void *data)
>               qla2x00_do_dpc_all_vps(base_vha);
>
>               ha->dpc_active = 0;
> +             set_current_state(TASK_INTERRUPTIBLE);
>       } /* End of while(1) */
> +     __set_current_state(TASK_RUNNING);
>
>       DEBUG(printk("scsi(%ld): DPC handler exiting\n", base_vha-
> >host_no));
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 7b31093..a6b2d72 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1671,7 +1671,7 @@ static int do_device_access(struct scsi_cmnd *scmd,
>                           unsigned long long lba, unsigned int num, int write)
>  {
>       int ret;
> -     unsigned int block, rest = 0;
> +     unsigned long long block, rest = 0;
>       int (*func)(struct scsi_cmnd *, unsigned char *, int);
>
>       func = write ? fetch_to_dev_buffer : fill_from_dev_buffer;
> diff --git a/drivers/target/Makefile b/drivers/target/Makefile
> index 5cfd708..973bb19 100644
> --- a/drivers/target/Makefile
> +++ b/drivers/target/Makefile
> @@ -13,8 +13,7 @@ target_core_mod-y           := target_core_configfs.o \
>                                  target_core_transport.o \
>                                  target_core_cdb.o \
>                                  target_core_ua.o \
> -                                target_core_rd.o \
> -                                target_core_mib.o
> +                                target_core_rd.o
>
>  obj-$(CONFIG_TARGET_CORE)    += target_core_mod.o
>
> diff --git a/drivers/target/target_core_configfs.c
> b/drivers/target/target_core_configfs.c
> index 2764510..caf8dc1 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -37,7 +37,6 @@
>  #include <linux/parser.h>
>  #include <linux/syscalls.h>
>  #include <linux/configfs.h>
> -#include <linux/proc_fs.h>
>
>  #include <target/target_core_base.h>
>  #include <target/target_core_device.h>
> @@ -1971,13 +1970,35 @@ static void target_core_dev_release(struct
> config_item *item)
>  {
>       struct se_subsystem_dev *se_dev =
> container_of(to_config_group(item),
>                               struct se_subsystem_dev, se_dev_group);
> -     struct config_group *dev_cg;
> -
> -     if (!(se_dev))
> -             return;
> +     struct se_hba *hba = item_to_hba(&se_dev->se_dev_hba-
> >hba_group.cg_item);
> +     struct se_subsystem_api *t = hba->transport;
> +     struct config_group *dev_cg = &se_dev->se_dev_group;
>
> -     dev_cg = &se_dev->se_dev_group;
>       kfree(dev_cg->default_groups);
> +     /*
> +      * This pointer will set when the storage is enabled with:
> +      *`echo 1 > $CONFIGFS/core/$HBA/$DEV/dev_enable`
> +      */
> +     if (se_dev->se_dev_ptr) {
> +             printk(KERN_INFO "Target_Core_ConfigFS: Calling se_free_"
> +                     "virtual_device() for se_dev_ptr: %p\n",
> +                     se_dev->se_dev_ptr);
> +
> +             se_free_virtual_device(se_dev->se_dev_ptr, hba);
> +     } else {
> +             /*
> +              * Release struct se_subsystem_dev->se_dev_su_ptr..
> +              */
> +             printk(KERN_INFO "Target_Core_ConfigFS: Calling t->free_"
> +                     "device() for se_dev_su_ptr: %p\n",
> +                     se_dev->se_dev_su_ptr);
> +
> +             t->free_device(se_dev->se_dev_su_ptr);
> +     }
> +
> +     printk(KERN_INFO "Target_Core_ConfigFS: Deallocating se_subsystem"
> +                     "_dev_t: %p\n", se_dev);
> +     kfree(se_dev);
>  }
>
>  static ssize_t target_core_dev_show(struct config_item *item,
> @@ -2140,7 +2161,16 @@ static struct configfs_attribute
> *target_core_alua_lu_gp_attrs[] = {
>       NULL,
>  };
>
> +static void target_core_alua_lu_gp_release(struct config_item *item)
> +{
> +     struct t10_alua_lu_gp *lu_gp = container_of(to_config_group(item),
> +                     struct t10_alua_lu_gp, lu_gp_group);
> +
> +     core_alua_free_lu_gp(lu_gp);
> +}
> +
>  static struct configfs_item_operations target_core_alua_lu_gp_ops = {
> +     .release                = target_core_alua_lu_gp_release,
>       .show_attribute         = target_core_alua_lu_gp_attr_show,
>       .store_attribute        = target_core_alua_lu_gp_attr_store,
>  };
> @@ -2191,9 +2221,11 @@ static void target_core_alua_drop_lu_gp(
>       printk(KERN_INFO "Target_Core_ConfigFS: Releasing ALUA Logical Unit"
>               " Group: core/alua/lu_gps/%s, ID: %hu\n",
>               config_item_name(item), lu_gp->lu_gp_id);
> -
> +     /*
> +      * core_alua_free_lu_gp() is called from target_core_alua_lu_gp_ops-
> >release()
> +      * -> target_core_alua_lu_gp_release()
> +      */
>       config_item_put(item);
> -     core_alua_free_lu_gp(lu_gp);
>  }
>
>  static struct configfs_group_operations target_core_alua_lu_gps_group_ops
> = {
> @@ -2549,7 +2581,16 @@ static struct configfs_attribute
> *target_core_alua_tg_pt_gp_attrs[] = {
>       NULL,
>  };
>
> +static void target_core_alua_tg_pt_gp_release(struct config_item *item)
> +{
> +     struct t10_alua_tg_pt_gp *tg_pt_gp =
> container_of(to_config_group(item),
> +                     struct t10_alua_tg_pt_gp, tg_pt_gp_group);
> +
> +     core_alua_free_tg_pt_gp(tg_pt_gp);
> +}
> +
>  static struct configfs_item_operations target_core_alua_tg_pt_gp_ops = {
> +     .release                = target_core_alua_tg_pt_gp_release,
>       .show_attribute         = target_core_alua_tg_pt_gp_attr_show,
>       .store_attribute        = target_core_alua_tg_pt_gp_attr_store,
>  };
> @@ -2602,9 +2643,11 @@ static void target_core_alua_drop_tg_pt_gp(
>       printk(KERN_INFO "Target_Core_ConfigFS: Releasing ALUA Target Port"
>               " Group: alua/tg_pt_gps/%s, ID: %hu\n",
>               config_item_name(item), tg_pt_gp->tg_pt_gp_id);
> -
> +     /*
> +      * core_alua_free_tg_pt_gp() is called from
> target_core_alua_tg_pt_gp_ops->release()
> +      * -> target_core_alua_tg_pt_gp_release().
> +      */
>       config_item_put(item);
> -     core_alua_free_tg_pt_gp(tg_pt_gp);
>  }
>
>  static struct configfs_group_operations
> target_core_alua_tg_pt_gps_group_ops = {
> @@ -2771,13 +2814,11 @@ static void target_core_drop_subdev(
>       struct se_subsystem_api *t;
>       struct config_item *df_item;
>       struct config_group *dev_cg, *tg_pt_gp_cg;
> -     int i, ret;
> +     int i;
>
>       hba = item_to_hba(&se_dev->se_dev_hba->hba_group.cg_item);
>
> -     if (mutex_lock_interruptible(&hba->hba_access_mutex))
> -             goto out;
> -
> +     mutex_lock(&hba->hba_access_mutex);
>       t = hba->transport;
>
>       spin_lock(&se_global->g_device_lock);
> @@ -2791,7 +2832,10 @@ static void target_core_drop_subdev(
>               config_item_put(df_item);
>       }
>       kfree(tg_pt_gp_cg->default_groups);
> -     core_alua_free_tg_pt_gp(T10_ALUA(se_dev)->default_tg_pt_gp);
> +     /*
> +      * core_alua_free_tg_pt_gp() is called from ->default_tg_pt_gp
> +      * directly from target_core_alua_tg_pt_gp_release().
> +      */
>       T10_ALUA(se_dev)->default_tg_pt_gp = NULL;
>
>       dev_cg = &se_dev->se_dev_group;
> @@ -2800,38 +2844,12 @@ static void target_core_drop_subdev(
>               dev_cg->default_groups[i] = NULL;
>               config_item_put(df_item);
>       }
> -
> -     config_item_put(item);
>       /*
> -      * This pointer will set when the storage is enabled with:
> -      * `echo 1 > $CONFIGFS/core/$HBA/$DEV/dev_enable`
> +      * The releasing of se_dev and associated se_dev->se_dev_ptr is done
> +      * from target_core_dev_item_ops->release() -
> >target_core_dev_release().
>        */
> -     if (se_dev->se_dev_ptr) {
> -             printk(KERN_INFO "Target_Core_ConfigFS: Calling se_free_"
> -                     "virtual_device() for se_dev_ptr: %p\n",
> -                             se_dev->se_dev_ptr);
> -
> -             ret = se_free_virtual_device(se_dev->se_dev_ptr, hba);
> -             if (ret < 0)
> -                     goto hba_out;
> -     } else {
> -             /*
> -              * Release struct se_subsystem_dev->se_dev_su_ptr..
> -              */
> -             printk(KERN_INFO "Target_Core_ConfigFS: Calling t->free_"
> -                     "device() for se_dev_su_ptr: %p\n",
> -                     se_dev->se_dev_su_ptr);
> -
> -             t->free_device(se_dev->se_dev_su_ptr);
> -     }
> -
> -     printk(KERN_INFO "Target_Core_ConfigFS: Deallocating se_subsystem"
> -             "_dev_t: %p\n", se_dev);
> -
> -hba_out:
> +     config_item_put(item);
>       mutex_unlock(&hba->hba_access_mutex);
> -out:
> -     kfree(se_dev);
>  }
>
>  static struct configfs_group_operations target_core_hba_group_ops = {
> @@ -2914,6 +2932,13 @@ SE_HBA_ATTR(hba_mode, S_IRUGO | S_IWUSR);
>
>  CONFIGFS_EATTR_OPS(target_core_hba, se_hba, hba_group);
>
> +static void target_core_hba_release(struct config_item *item)
> +{
> +     struct se_hba *hba = container_of(to_config_group(item),
> +                             struct se_hba, hba_group);
> +     core_delete_hba(hba);
> +}
> +
>  static struct configfs_attribute *target_core_hba_attrs[] = {
>       &target_core_hba_hba_info.attr,
>       &target_core_hba_hba_mode.attr,
> @@ -2921,6 +2946,7 @@ static struct configfs_attribute
> *target_core_hba_attrs[] = {
>  };
>
>  static struct configfs_item_operations target_core_hba_item_ops = {
> +     .release                = target_core_hba_release,
>       .show_attribute         = target_core_hba_attr_show,
>       .store_attribute        = target_core_hba_attr_store,
>  };
> @@ -2997,10 +3023,11 @@ static void target_core_call_delhbafromtarget(
>       struct config_group *group,
>       struct config_item *item)
>  {
> -     struct se_hba *hba = item_to_hba(item);
> -
> +     /*
> +      * core_delete_hba() is called from target_core_hba_item_ops-
> >release()
> +      * -> target_core_hba_release()
> +      */
>       config_item_put(item);
> -     core_delete_hba(hba);
>  }
>
>  static struct configfs_group_operations target_core_group_ops = {
> @@ -3022,7 +3049,6 @@ static int target_core_init_configfs(void)
>       struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
>       struct config_group *lu_gp_cg = NULL;
>       struct configfs_subsystem *subsys;
> -     struct proc_dir_entry *scsi_target_proc = NULL;
>       struct t10_alua_lu_gp *lu_gp;
>       int ret;
>
> @@ -3128,21 +3154,10 @@ static int target_core_init_configfs(void)
>       if (core_dev_setup_virtual_lun0() < 0)
>               goto out;
>
> -     scsi_target_proc = proc_mkdir("scsi_target", 0);
> -     if (!(scsi_target_proc)) {
> -             printk(KERN_ERR "proc_mkdir(scsi_target, 0) failed\n");
> -             goto out;
> -     }
> -     ret = init_scsi_target_mib();
> -     if (ret < 0)
> -             goto out;
> -
>       return 0;
>
>  out:
>       configfs_unregister_subsystem(subsys);
> -     if (scsi_target_proc)
> -             remove_proc_entry("scsi_target", 0);
>       core_dev_release_virtual_lun0();
>       rd_module_exit();
>  out_global:
> @@ -3178,8 +3193,7 @@ static void target_core_exit_configfs(void)
>               config_item_put(item);
>       }
>       kfree(lu_gp_cg->default_groups);
> -     core_alua_free_lu_gp(se_global->default_lu_gp);
> -     se_global->default_lu_gp = NULL;
> +     lu_gp_cg->default_groups = NULL;
>
>       alua_cg = &se_global->alua_group;
>       for (i = 0; alua_cg->default_groups[i]; i++) {
> @@ -3188,6 +3202,7 @@ static void target_core_exit_configfs(void)
>               config_item_put(item);
>       }
>       kfree(alua_cg->default_groups);
> +     alua_cg->default_groups = NULL;
>
>       hba_cg = &se_global->target_core_hbagroup;
>       for (i = 0; hba_cg->default_groups[i]; i++) {
> @@ -3196,20 +3211,20 @@ static void target_core_exit_configfs(void)
>               config_item_put(item);
>       }
>       kfree(hba_cg->default_groups);
> -
> -     for (i = 0; subsys->su_group.default_groups[i]; i++) {
> -             item = &subsys->su_group.default_groups[i]->cg_item;
> -             subsys->su_group.default_groups[i] = NULL;
> -             config_item_put(item);
> -     }
> +     hba_cg->default_groups = NULL;
> +     /*
> +      * We expect subsys->su_group.default_groups to be released
> +      * by configfs subsystem provider logic..
> +      */
> +     configfs_unregister_subsystem(subsys);
>       kfree(subsys->su_group.default_groups);
>
> -     configfs_unregister_subsystem(subsys);
> +     core_alua_free_lu_gp(se_global->default_lu_gp);
> +     se_global->default_lu_gp = NULL;
> +
>       printk(KERN_INFO "TARGET_CORE[0]: Released ConfigFS Fabric"
>                       " Infrastructure\n");
>
> -     remove_scsi_target_mib();
> -     remove_proc_entry("scsi_target", 0);
>       core_dev_release_virtual_lun0();
>       rd_module_exit();
>       release_se_global();
> diff --git a/drivers/target/target_core_device.c
> b/drivers/target/target_core_device.c
> index 317ce58..5da051a 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -373,11 +373,11 @@ int core_update_device_list_for_node(
>               /*
>                * deve->se_lun_acl will be NULL for demo-mode created LUNs
>                * that have not been explictly concerted to MappedLUNs ->
> -              * struct se_lun_acl.
> +              * struct se_lun_acl, but we remove deve->alua_port_list from
> +              * port->sep_alua_list. This also means that active UAs and
> +              * NodeACL context specific PR metadata for demo-mode
> +              * MappedLUN *deve will be released below..
>                */
> -             if (!(deve->se_lun_acl))
> -                     return 0;
> -
>               spin_lock_bh(&port->sep_alua_lock);
>               list_del(&deve->alua_port_list);
>               spin_unlock_bh(&port->sep_alua_lock);
> @@ -395,12 +395,14 @@ int core_update_device_list_for_node(
>                               printk(KERN_ERR "struct se_dev_entry->se_lun_acl"
>                                       " already set for demo mode -> explict"
>                                       " LUN ACL transition\n");
> +                             spin_unlock_irq(&nacl->device_list_lock);
>                               return -1;
>                       }
>                       if (deve->se_lun != lun) {
>                               printk(KERN_ERR "struct se_dev_entry->se_lun does"
>                                       " match passed struct se_lun for demo mode"
>                                       " -> explict LUN ACL transition\n");
> +                             spin_unlock_irq(&nacl->device_list_lock);
>                               return -1;
>                       }
>                       deve->se_lun_acl = lun_acl;
> @@ -865,9 +867,6 @@ static void se_dev_stop(struct se_device *dev)
>               }
>       }
>       spin_unlock(&hba->device_lock);
> -
> -     while (atomic_read(&hba->dev_mib_access_count))
> -             cpu_relax();
>  }
>
>  int se_dev_check_online(struct se_device *dev)
> diff --git a/drivers/target/target_core_fabric_configfs.c
> b/drivers/target/target_core_fabric_configfs.c
> index 32b148d..b65d1c8 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -214,12 +214,22 @@ TCM_MAPPEDLUN_ATTR(write_protect, S_IRUGO |
> S_IWUSR);
>
>  CONFIGFS_EATTR_OPS(target_fabric_mappedlun, se_lun_acl, se_lun_group);
>
> +static void target_fabric_mappedlun_release(struct config_item *item)
> +{
> +     struct se_lun_acl *lacl = container_of(to_config_group(item),
> +                             struct se_lun_acl, se_lun_group);
> +     struct se_portal_group *se_tpg = lacl->se_lun_nacl->se_tpg;
> +
> +     core_dev_free_initiator_node_lun_acl(se_tpg, lacl);
> +}
> +
>  static struct configfs_attribute *target_fabric_mappedlun_attrs[] = {
>       &target_fabric_mappedlun_write_protect.attr,
>       NULL,
>  };
>
>  static struct configfs_item_operations target_fabric_mappedlun_item_ops =
> {
> +     .release                = target_fabric_mappedlun_release,
>       .show_attribute         = target_fabric_mappedlun_attr_show,
>       .store_attribute        = target_fabric_mappedlun_attr_store,
>       .allow_link             = target_fabric_mappedlun_link,
> @@ -337,15 +347,21 @@ static void target_fabric_drop_mappedlun(
>       struct config_group *group,
>       struct config_item *item)
>  {
> -     struct se_lun_acl *lacl = container_of(to_config_group(item),
> -                     struct se_lun_acl, se_lun_group);
> -     struct se_portal_group *se_tpg = lacl->se_lun_nacl->se_tpg;
> -
>       config_item_put(item);
> -     core_dev_free_initiator_node_lun_acl(se_tpg, lacl);
> +}
> +
> +static void target_fabric_nacl_base_release(struct config_item *item)
> +{
> +     struct se_node_acl *se_nacl = container_of(to_config_group(item),
> +                     struct se_node_acl, acl_group);
> +     struct se_portal_group *se_tpg = se_nacl->se_tpg;
> +     struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
> +
> +     tf->tf_ops.fabric_drop_nodeacl(se_nacl);
>  }
>
>  static struct configfs_item_operations target_fabric_nacl_base_item_ops =
> {
> +     .release                = target_fabric_nacl_base_release,
>       .show_attribute         = target_fabric_nacl_base_attr_show,
>       .store_attribute        = target_fabric_nacl_base_attr_store,
>  };
> @@ -404,9 +420,6 @@ static void target_fabric_drop_nodeacl(
>       struct config_group *group,
>       struct config_item *item)
>  {
> -     struct se_portal_group *se_tpg = container_of(group,
> -                     struct se_portal_group, tpg_acl_group);
> -     struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
>       struct se_node_acl *se_nacl = container_of(to_config_group(item),
>                       struct se_node_acl, acl_group);
>       struct config_item *df_item;
> @@ -419,9 +432,10 @@ static void target_fabric_drop_nodeacl(
>               nacl_cg->default_groups[i] = NULL;
>               config_item_put(df_item);
>       }
> -
> +     /*
> +      * struct se_node_acl free is done in
> target_fabric_nacl_base_release()
> +      */
>       config_item_put(item);
> -     tf->tf_ops.fabric_drop_nodeacl(se_nacl);
>  }
>
>  static struct configfs_group_operations target_fabric_nacl_group_ops = {
> @@ -437,7 +451,18 @@ TF_CIT_SETUP(tpg_nacl, NULL,
> &target_fabric_nacl_group_ops, NULL);
>
>  CONFIGFS_EATTR_OPS(target_fabric_np_base, se_tpg_np, tpg_np_group);
>
> +static void target_fabric_np_base_release(struct config_item *item)
> +{
> +     struct se_tpg_np *se_tpg_np = container_of(to_config_group(item),
> +                             struct se_tpg_np, tpg_np_group);
> +     struct se_portal_group *se_tpg = se_tpg_np->tpg_np_parent;
> +     struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
> +
> +     tf->tf_ops.fabric_drop_np(se_tpg_np);
> +}
> +
>  static struct configfs_item_operations target_fabric_np_base_item_ops = {
> +     .release                = target_fabric_np_base_release,
>       .show_attribute         = target_fabric_np_base_attr_show,
>       .store_attribute        = target_fabric_np_base_attr_store,
>  };
> @@ -466,6 +491,7 @@ static struct config_group *target_fabric_make_np(
>       if (!(se_tpg_np) || IS_ERR(se_tpg_np))
>               return ERR_PTR(-EINVAL);
>
> +     se_tpg_np->tpg_np_parent = se_tpg;
>       config_group_init_type_name(&se_tpg_np->tpg_np_group, name,
>                       &TF_CIT_TMPL(tf)->tfc_tpg_np_base_cit);
>
> @@ -476,14 +502,10 @@ static void target_fabric_drop_np(
>       struct config_group *group,
>       struct config_item *item)
>  {
> -     struct se_portal_group *se_tpg = container_of(group,
> -                             struct se_portal_group, tpg_np_group);
> -     struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
> -     struct se_tpg_np *se_tpg_np = container_of(to_config_group(item),
> -                             struct se_tpg_np, tpg_np_group);
> -
> +     /*
> +      * struct se_tpg_np is released via target_fabric_np_base_release()
> +      */
>       config_item_put(item);
> -     tf->tf_ops.fabric_drop_np(se_tpg_np);
>  }
>
>  static struct configfs_group_operations target_fabric_np_group_ops = {
> @@ -814,7 +836,18 @@ TF_CIT_SETUP(tpg_param,
> &target_fabric_tpg_param_item_ops, NULL, NULL);
>   */
>  CONFIGFS_EATTR_OPS(target_fabric_tpg, se_portal_group, tpg_group);
>
> +static void target_fabric_tpg_release(struct config_item *item)
> +{
> +     struct se_portal_group *se_tpg = container_of(to_config_group(item),
> +                     struct se_portal_group, tpg_group);
> +     struct se_wwn *wwn = se_tpg->se_tpg_wwn;
> +     struct target_fabric_configfs *tf = wwn->wwn_tf;
> +
> +     tf->tf_ops.fabric_drop_tpg(se_tpg);
> +}
> +
>  static struct configfs_item_operations target_fabric_tpg_base_item_ops =
> {
> +     .release                = target_fabric_tpg_release,
>       .show_attribute         = target_fabric_tpg_attr_show,
>       .store_attribute        = target_fabric_tpg_attr_store,
>  };
> @@ -872,8 +905,6 @@ static void target_fabric_drop_tpg(
>       struct config_group *group,
>       struct config_item *item)
>  {
> -     struct se_wwn *wwn = container_of(group, struct se_wwn, wwn_group);
> -     struct target_fabric_configfs *tf = wwn->wwn_tf;
>       struct se_portal_group *se_tpg = container_of(to_config_group(item),
>                               struct se_portal_group, tpg_group);
>       struct config_group *tpg_cg = &se_tpg->tpg_group;
> @@ -890,15 +921,28 @@ static void target_fabric_drop_tpg(
>       }
>
>       config_item_put(item);
> -     tf->tf_ops.fabric_drop_tpg(se_tpg);
>  }
>
> +static void target_fabric_release_wwn(struct config_item *item)
> +{
> +     struct se_wwn *wwn = container_of(to_config_group(item),
> +                             struct se_wwn, wwn_group);
> +     struct target_fabric_configfs *tf = wwn->wwn_tf;
> +
> +     tf->tf_ops.fabric_drop_wwn(wwn);
> +}
> +
> +static struct configfs_item_operations target_fabric_tpg_item_ops = {
> +     .release        = target_fabric_release_wwn,
> +};
> +
>  static struct configfs_group_operations target_fabric_tpg_group_ops = {
>       .make_group     = target_fabric_make_tpg,
>       .drop_item      = target_fabric_drop_tpg,
>  };
>
> -TF_CIT_SETUP(tpg, NULL, &target_fabric_tpg_group_ops, NULL);
> +TF_CIT_SETUP(tpg, &target_fabric_tpg_item_ops,
> &target_fabric_tpg_group_ops,
> +             NULL);
>
>  /* End of tfc_tpg_cit */
>
> @@ -932,13 +976,7 @@ static void target_fabric_drop_wwn(
>       struct config_group *group,
>       struct config_item *item)
>  {
> -     struct target_fabric_configfs *tf = container_of(group,
> -                             struct target_fabric_configfs, tf_group);
> -     struct se_wwn *wwn = container_of(to_config_group(item),
> -                             struct se_wwn, wwn_group);
> -
>       config_item_put(item);
> -     tf->tf_ops.fabric_drop_wwn(wwn);
>  }
>
>  static struct configfs_group_operations target_fabric_wwn_group_ops = {
> diff --git a/drivers/target/target_core_iblock.c
> b/drivers/target/target_core_iblock.c
> index c6e0d75..67f0c09 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -154,7 +154,7 @@ static struct se_device *iblock_create_virtdevice(
>
>       bd = blkdev_get_by_path(ib_dev->ibd_udev_path,
>                               FMODE_WRITE|FMODE_READ|FMODE_EXCL, ib_dev);
> -     if (!(bd))
> +     if (IS_ERR(bd))
>               goto failed;
>       /*
>        * Setup the local scope queue_limits from struct request_queue-
> >limits
> @@ -220,8 +220,10 @@ static void iblock_free_device(void *p)
>  {
>       struct iblock_dev *ib_dev = p;
>
> -     blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
> -     bioset_free(ib_dev->ibd_bio_set);
> +     if (ib_dev->ibd_bd != NULL)
> +             blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
> +     if (ib_dev->ibd_bio_set != NULL)
> +             bioset_free(ib_dev->ibd_bio_set);
>       kfree(ib_dev);
>  }
>
> diff --git a/drivers/target/target_core_mib.c
> b/drivers/target/target_core_mib.c
> deleted file mode 100644
> index d5a48aa..0000000
> --- a/drivers/target/target_core_mib.c
> +++ /dev/null
> @@ -1,1078 +0,0 @@
> -
> /*************************************************************************
> ******
> - * Filename:  target_core_mib.c
> - *
> - * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
> - * Copyright (c) 2007-2010 Rising Tide Systems
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> - *
> - * Nicholas A. Bellinger <nab@linux-iscsi.org>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
> USA.
> - *
> -
> **************************************************************************
> ****/
> -
> -
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/delay.h>
> -#include <linux/timer.h>
> -#include <linux/string.h>
> -#include <linux/version.h>
> -#include <generated/utsrelease.h>
> -#include <linux/utsname.h>
> -#include <linux/proc_fs.h>
> -#include <linux/seq_file.h>
> -#include <linux/blkdev.h>
> -#include <scsi/scsi.h>
> -#include <scsi/scsi_device.h>
> -#include <scsi/scsi_host.h>
> -
> -#include <target/target_core_base.h>
> -#include <target/target_core_transport.h>
> -#include <target/target_core_fabric_ops.h>
> -#include <target/target_core_configfs.h>
> -
> -#include "target_core_hba.h"
> -#include "target_core_mib.h"
> -
> -/* SCSI mib table index */
> -static struct scsi_index_table scsi_index_table;
> -
> -#ifndef INITIAL_JIFFIES
> -#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> -#endif
> -
> -/* SCSI Instance Table */
> -#define SCSI_INST_SW_INDEX           1
> -#define SCSI_TRANSPORT_INDEX         1
> -
> -#define NONE         "None"
> -#define ISPRINT(a)   ((a >= ' ') && (a <= '~'))
> -
> -static inline int list_is_first(const struct list_head *list,
> -                             const struct list_head *head)
> -{
> -     return list->prev == head;
> -}
> -
> -static void *locate_hba_start(
> -     struct seq_file *seq,
> -     loff_t *pos)
> -{
> -     spin_lock(&se_global->g_device_lock);
> -     return seq_list_start(&se_global->g_se_dev_list, *pos);
> -}
> -
> -static void *locate_hba_next(
> -     struct seq_file *seq,
> -     void *v,
> -     loff_t *pos)
> -{
> -     return seq_list_next(v, &se_global->g_se_dev_list, pos);
> -}
> -
> -static void locate_hba_stop(struct seq_file *seq, void *v)
> -{
> -     spin_unlock(&se_global->g_device_lock);
> -}
> -
> -
> /*************************************************************************
> ***
> - * SCSI MIB Tables
> -
> **************************************************************************
> **/
> -
> -/*
> - * SCSI Instance Table
> - */
> -static void *scsi_inst_seq_start(
> -     struct seq_file *seq,
> -     loff_t *pos)
> -{
> -     spin_lock(&se_global->hba_lock);
> -     return seq_list_start(&se_global->g_hba_list, *pos);
> -}
> -
> -static void *scsi_inst_seq_next(
> -     struct seq_file *seq,
> -     void *v,
> -     loff_t *pos)
> -{
> -     return seq_list_next(v, &se_global->g_hba_list, pos);
> -}
> -
> -static void scsi_inst_seq_stop(struct seq_file *seq, void *v)
> -{
> -     spin_unlock(&se_global->hba_lock);
> -}
> -
> -static int scsi_inst_seq_show(struct seq_file *seq, void *v)
> -{
> -     struct se_hba *hba = list_entry(v, struct se_hba, hba_list);
> -
> -     if (list_is_first(&hba->hba_list, &se_global->g_hba_list))
> -             seq_puts(seq, "inst sw_indx\n");
> -
> -     seq_printf(seq, "%u %u\n", hba->hba_index, SCSI_INST_SW_INDEX);
> -     seq_printf(seq, "plugin: %s version: %s\n",
> -                     hba->transport->name, TARGET_CORE_VERSION);
> -
> -     return 0;
> -}
> -
> -static const struct seq_operations scsi_inst_seq_ops = {
> -     .start  = scsi_inst_seq_start,
> -     .next   = scsi_inst_seq_next,
> -     .stop   = scsi_inst_seq_stop,
> -     .show   = scsi_inst_seq_show
> -};
> -
> -static int scsi_inst_seq_open(struct inode *inode, struct file *file)
> -{
> -     return seq_open(file, &scsi_inst_seq_ops);
> -}
> -
> -static const struct file_operations scsi_inst_seq_fops = {
> -     .owner   = THIS_MODULE,
> -     .open    = scsi_inst_seq_open,
> -     .read    = seq_read,
> -     .llseek  = seq_lseek,
> -     .release = seq_release,
> -};
> -
> -/*
> - * SCSI Device Table
> - */
> -static void *scsi_dev_seq_start(struct seq_file *seq, loff_t *pos)
> -{
> -     return locate_hba_start(seq, pos);
> -}
> -
> -static void *scsi_dev_seq_next(struct seq_file *seq, void *v, loff_t
> *pos)
> -{
> -     return locate_hba_next(seq, v, pos);
> -}
> -
> -static void scsi_dev_seq_stop(struct seq_file *seq, void *v)
> -{
> -     locate_hba_stop(seq, v);
> -}
> -
> -static int scsi_dev_seq_show(struct seq_file *seq, void *v)
> -{
> -     struct se_hba *hba;
> -     struct se_subsystem_dev *se_dev = list_entry(v, struct
> se_subsystem_dev,
> -                                             g_se_dev_list);
> -     struct se_device *dev = se_dev->se_dev_ptr;
> -     char str[28];
> -     int k;
> -
> -     if (list_is_first(&se_dev->g_se_dev_list, &se_global-
> >g_se_dev_list))
> -             seq_puts(seq, "inst indx role ports\n");
> -
> -     if (!(dev))
> -             return 0;
> -
> -     hba = dev->se_hba;
> -     if (!(hba)) {
> -             /* Log error ? */
> -             return 0;
> -     }
> -
> -     seq_printf(seq, "%u %u %s %u\n", hba->hba_index,
> -                dev->dev_index, "Target", dev->dev_port_count);
> -
> -     memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
> -
> -     /* vendor */
> -     for (k = 0; k < 8; k++)
> -             str[k] = ISPRINT(DEV_T10_WWN(dev)->vendor[k]) ?
> -                             DEV_T10_WWN(dev)->vendor[k] : 0x20;
> -     str[k] = 0x20;
> -
> -     /* model */
> -     for (k = 0; k < 16; k++)
> -             str[k+9] = ISPRINT(DEV_T10_WWN(dev)->model[k]) ?
> -                             DEV_T10_WWN(dev)->model[k] : 0x20;
> -     str[k + 9] = 0;
> -
> -     seq_printf(seq, "dev_alias: %s\n", str);
> -
> -     return 0;
> -}
> -
> -static const struct seq_operations scsi_dev_seq_ops = {
> -     .start  = scsi_dev_seq_start,
> -     .next   = scsi_dev_seq_next,
> -     .stop   = scsi_dev_seq_stop,
> -     .show   = scsi_dev_seq_show
> -};
> -
> -static int scsi_dev_seq_open(struct inode *inode, struct file *file)
> -{
> -     return seq_open(file, &scsi_dev_seq_ops);
> -}
> -
> -static const struct file_operations scsi_dev_seq_fops = {
> -     .owner   = THIS_MODULE,
> -     .open    = scsi_dev_seq_open,
> -     .read    = seq_read,
> -     .llseek  = seq_lseek,
> -     .release = seq_release,
> -};
> -
> -/*
> - * SCSI Port Table
> - */
> -static void *scsi_port_seq_start(struct seq_file *seq, loff_t *pos)
> -{
> -     return locate_hba_start(seq, pos);
> -}
> -
> -static void *scsi_port_seq_next(struct seq_file *seq, void *v, loff_t
> *pos)
> -{
> -     return locate_hba_next(seq, v, pos);
> -}
> -
> -static void scsi_port_seq_stop(struct seq_file *seq, void *v)
> -{
> -     locate_hba_stop(seq, v);
> -}
> -
> -static int scsi_port_seq_show(struct seq_file *seq, void *v)
> -{
> -     struct se_hba *hba;
> -     struct se_subsystem_dev *se_dev = list_entry(v, struct
> se_subsystem_dev,
> -                                             g_se_dev_list);
> -     struct se_device *dev = se_dev->se_dev_ptr;
> -     struct se_port *sep, *sep_tmp;
> -
> -     if (list_is_first(&se_dev->g_se_dev_list, &se_global-
> >g_se_dev_list))
> -             seq_puts(seq, "inst device indx role busy_count\n");
> -
> -     if (!(dev))
> -             return 0;
> -
> -     hba = dev->se_hba;
> -     if (!(hba)) {
> -             /* Log error ? */
> -             return 0;
> -     }
> -
> -     /* FIXME: scsiPortBusyStatuses count */
> -     spin_lock(&dev->se_port_lock);
> -     list_for_each_entry_safe(sep, sep_tmp, &dev->dev_sep_list, sep_list)
> {
> -             seq_printf(seq, "%u %u %u %s%u %u\n", hba->hba_index,
> -                     dev->dev_index, sep->sep_index, "Device",
> -                     dev->dev_index, 0);
> -     }
> -     spin_unlock(&dev->se_port_lock);
> -
> -     return 0;
> -}
> -
> -static const struct seq_operations scsi_port_seq_ops = {
> -     .start  = scsi_port_seq_start,
> -     .next   = scsi_port_seq_next,
> -     .stop   = scsi_port_seq_stop,
> -     .show   = scsi_port_seq_show
> -};
> -
> -static int scsi_port_seq_open(struct inode *inode, struct file *file)
> -{
> -     return seq_open(file, &scsi_port_seq_ops);
> -}
> -
> -static const struct file_operations scsi_port_seq_fops = {
> -     .owner   = THIS_MODULE,
> -     .open    = scsi_port_seq_open,
> -     .read    = seq_read,
> -     .llseek  = seq_lseek,
> -     .release = seq_release,
> -};
> -
> -/*
> - * SCSI Transport Table
> - */
> -static void *scsi_transport_seq_start(struct seq_file *seq, loff_t *pos)
> -{
> -     return locate_hba_start(seq, pos);
> -}
> -
> -static void *scsi_transport_seq_next(struct seq_file *seq, void *v,
> loff_t *pos)
> -{
> -     return locate_hba_next(seq, v, pos);
> -}
> -
> -static void scsi_transport_seq_stop(struct seq_file *seq, void *v)
> -{
> -     locate_hba_stop(seq, v);
> -}
> -
> -static int scsi_transport_seq_show(struct seq_file *seq, void *v)
> -{
> -     struct se_hba *hba;
> -     struct se_subsystem_dev *se_dev = list_entry(v, struct
> se_subsystem_dev,
> -                                             g_se_dev_list);
> -     struct se_device *dev = se_dev->se_dev_ptr;
> -     struct se_port *se, *se_tmp;
> -     struct se_portal_group *tpg;
> -     struct t10_wwn *wwn;
> -     char buf[64];
> -
> -     if (list_is_first(&se_dev->g_se_dev_list, &se_global-
> >g_se_dev_list))
> -             seq_puts(seq, "inst device indx dev_name\n");
> -
> -     if (!(dev))
> -             return 0;
> -
> -     hba = dev->se_hba;
> -     if (!(hba)) {
> -             /* Log error ? */
> -             return 0;
> -     }
> -
> -     wwn = DEV_T10_WWN(dev);
> -
> -     spin_lock(&dev->se_port_lock);
> -     list_for_each_entry_safe(se, se_tmp, &dev->dev_sep_list, sep_list) {
> -             tpg = se->sep_tpg;
> -             sprintf(buf, "scsiTransport%s",
> -                             TPG_TFO(tpg)->get_fabric_name());
> -
> -             seq_printf(seq, "%u %s %u %s+%s\n",
> -                     hba->hba_index, /* scsiTransportIndex */
> -                     buf,  /* scsiTransportType */
> -                     (TPG_TFO(tpg)->tpg_get_inst_index != NULL) ?
> -                     TPG_TFO(tpg)->tpg_get_inst_index(tpg) :
> -                     0,
> -                     TPG_TFO(tpg)->tpg_get_wwn(tpg),
> -                     (strlen(wwn->unit_serial)) ?
> -                     /* scsiTransportDevName */
> -                     wwn->unit_serial : wwn->vendor);
> -     }
> -     spin_unlock(&dev->se_port_lock);
> -
> -     return 0;
> -}
> -
> -static const struct seq_operations scsi_transport_seq_ops = {
> -     .start  = scsi_transport_seq_start,
> -     .next   = scsi_transport_seq_next,
> -     .stop   = scsi_transport_seq_stop,
> -     .show   = scsi_transport_seq_show
> -};
> -
> -static int scsi_transport_seq_open(struct inode *inode, struct file
> *file)
> -{
> -     return seq_open(file, &scsi_transport_seq_ops);
> -}
> -
> -static const struct file_operations scsi_transport_seq_fops = {
> -     .owner   = THIS_MODULE,
> -     .open    = scsi_transport_seq_open,
> -     .read    = seq_read,
> -     .llseek  = seq_lseek,
> -     .release = seq_release,
> -};
> -
> -/*
> - * SCSI Target Device Table
> - */
> -static void *scsi_tgt_dev_seq_start(struct seq_file *seq, loff_t *pos)
> -{
> -     return locate_hba_start(seq, pos);
> -}
> -
> -static void *scsi_tgt_dev_seq_next(struct seq_file *seq, void *v, loff_t
> *pos)
> -{
> -     return locate_hba_next(seq, v, pos);
> -}
> -
> -static void scsi_tgt_dev_seq_stop(struct seq_file *seq, void *v)
> -{
> -     locate_hba_stop(seq, v);
> -}
> -
> -
> -#define LU_COUNT     1  /* for now */
> -static int scsi_tgt_dev_seq_show(struct seq_file *seq, void *v)
> -{
> -     struct se_hba *hba;
> -     struct se_subsystem_dev *se_dev = list_entry(v, struct
> se_subsystem_dev,
> -                                             g_se_dev_list);
> -     struct se_device *dev = se_dev->se_dev_ptr;
> -     int non_accessible_lus = 0;
> -     char status[16];
> -
> -     if (list_is_first(&se_dev->g_se_dev_list, &se_global-
> >g_se_dev_list))
> -             seq_puts(seq, "inst indx num_LUs status non_access_LUs"
> -                     " resets\n");
> -
> -     if (!(dev))
> -             return 0;
> -
> -     hba = dev->se_hba;
> -     if (!(hba)) {
> -             /* Log error ? */
> -             return 0;
> -     }
> -
> -     switch (dev->dev_status) {
> -     case TRANSPORT_DEVICE_ACTIVATED:
> -             strcpy(status, "activated");
> -             break;
> -     case TRANSPORT_DEVICE_DEACTIVATED:
> -             strcpy(status, "deactivated");
> -             non_accessible_lus = 1;
> -             break;
> -     case TRANSPORT_DEVICE_SHUTDOWN:
> -             strcpy(status, "shutdown");
> -             non_accessible_lus = 1;
> -             break;
> -     case TRANSPORT_DEVICE_OFFLINE_ACTIVATED:
> -     case TRANSPORT_DEVICE_OFFLINE_DEACTIVATED:
> -             strcpy(status, "offline");
> -             non_accessible_lus = 1;
> -             break;
> -     default:
> -             sprintf(status, "unknown(%d)", dev->dev_status);
> -             non_accessible_lus = 1;
> -     }
> -
> -     seq_printf(seq, "%u %u %u %s %u %u\n",
> -                hba->hba_index, dev->dev_index, LU_COUNT,
> -                status, non_accessible_lus, dev->num_resets);
> -
> -     return 0;
> -}
> -
> -static const struct seq_operations scsi_tgt_dev_seq_ops = {
> -     .start  = scsi_tgt_dev_seq_start,
> -     .next   = scsi_tgt_dev_seq_next,
> -     .stop   = scsi_tgt_dev_seq_stop,
> -     .show   = scsi_tgt_dev_seq_show
> -};
> -
> -static int scsi_tgt_dev_seq_open(struct inode *inode, struct file *file)
> -{
> -     return seq_open(file, &scsi_tgt_dev_seq_ops);
> -}
> -
> -static const struct file_operations scsi_tgt_dev_seq_fops = {
> -     .owner   = THIS_MODULE,
> -     .open    = scsi_tgt_dev_seq_open,
> -     .read    = seq_read,
> -     .llseek  = seq_lseek,
> -     .release = seq_release,
> -};
> -
> -/*
> - * SCSI Target Port Table
> - */
> -static void *scsi_tgt_port_seq_start(struct seq_file *seq, loff_t *pos)
> -{
> -     return locate_hba_start(seq, pos);
> -}
> -
> -static void *scsi_tgt_port_seq_next(struct seq_file *seq, void *v, loff_t
> *pos)
> -{
> -     return locate_hba_next(seq, v, pos);
> -}
> -
> -static void scsi_tgt_port_seq_stop(struct seq_file *seq, void *v)
> -{
> -     locate_hba_stop(seq, v);
> -}
> -
> -static int scsi_tgt_port_seq_show(struct seq_file *seq, void *v)
> -{
> -     struct se_hba *hba;
> -     struct se_subsystem_dev *se_dev = list_entry(v, struct
> se_subsystem_dev,
> -                                             g_se_dev_list);
> -     struct se_device *dev = se_dev->se_dev_ptr;
> -     struct se_port *sep, *sep_tmp;
> -     struct se_portal_group *tpg;
> -     u32 rx_mbytes, tx_mbytes;
> -     unsigned long long num_cmds;
> -     char buf[64];
> -
> -     if (list_is_first(&se_dev->g_se_dev_list, &se_global-
> >g_se_dev_list))
> -             seq_puts(seq, "inst device indx name port_index in_cmds"
> -                     " write_mbytes read_mbytes hs_in_cmds\n");
> -
> -     if (!(dev))
> -             return 0;
> -
> -     hba = dev->se_hba;
> -     if (!(hba)) {
> -             /* Log error ? */
> -             return 0;
> -     }
> -
> -     spin_lock(&dev->se_port_lock);
> -     list_for_each_entry_safe(sep, sep_tmp, &dev->dev_sep_list, sep_list)
> {
> -             tpg = sep->sep_tpg;
> -             sprintf(buf, "%sPort#",
> -                     TPG_TFO(tpg)->get_fabric_name());
> -
> -             seq_printf(seq, "%u %u %u %s%d %s%s%d ",
> -                  hba->hba_index,
> -                  dev->dev_index,
> -                  sep->sep_index,
> -                  buf, sep->sep_index,
> -                  TPG_TFO(tpg)->tpg_get_wwn(tpg), "+t+",
> -                  TPG_TFO(tpg)->tpg_get_tag(tpg));
> -
> -             spin_lock(&sep->sep_lun->lun_sep_lock);
> -             num_cmds = sep->sep_stats.cmd_pdus;
> -             rx_mbytes = (sep->sep_stats.rx_data_octets >> 20);
> -             tx_mbytes = (sep->sep_stats.tx_data_octets >> 20);
> -             spin_unlock(&sep->sep_lun->lun_sep_lock);
> -
> -             seq_printf(seq, "%llu %u %u %u\n", num_cmds,
> -                     rx_mbytes, tx_mbytes, 0);
> -     }
> -     spin_unlock(&dev->se_port_lock);
> -
> -     return 0;
> -}
> -
> -static const struct seq_operations scsi_tgt_port_seq_ops = {
> -     .start  = scsi_tgt_port_seq_start,
> -     .next   = scsi_tgt_port_seq_next,
> -     .stop   = scsi_tgt_port_seq_stop,
> -     .show   = scsi_tgt_port_seq_show
> -};
> -
> -static int scsi_tgt_port_seq_open(struct inode *inode, struct file *file)
> -{
> -     return seq_open(file, &scsi_tgt_port_seq_ops);
> -}
> -
> -static const struct file_operations scsi_tgt_port_seq_fops = {
> -     .owner   = THIS_MODULE,
> -     .open    = scsi_tgt_port_seq_open,
> -     .read    = seq_read,
> -     .llseek  = seq_lseek,
> -     .release = seq_release,
> -};
> -
> -/*
> - * SCSI Authorized Initiator Table:
> - * It contains the SCSI Initiators authorized to be attached to one of
> the
> - * local Target ports.
> - * Iterates through all active TPGs and extracts the info from the ACLs
> - */
> -static void *scsi_auth_intr_seq_start(struct seq_file *seq, loff_t *pos)
> -{
> -     spin_lock_bh(&se_global->se_tpg_lock);
> -     return seq_list_start(&se_global->g_se_tpg_list, *pos);
> -}
> -
> -static void *scsi_auth_intr_seq_next(struct seq_file *seq, void *v,
> -                                      loff_t *pos)
> -{
> -     return seq_list_next(v, &se_global->g_se_tpg_list, pos);
> -}
> -
> -static void scsi_auth_intr_seq_stop(struct seq_file *seq, void *v)
> -{
> -     spin_unlock_bh(&se_global->se_tpg_lock);
> -}
> -
> -static int scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
> -{
> -     struct se_portal_group *se_tpg = list_entry(v, struct
> se_portal_group,
> -                                             se_tpg_list);
> -     struct se_dev_entry *deve;
> -     struct se_lun *lun;
> -     struct se_node_acl *se_nacl;
> -     int j;
> -
> -     if (list_is_first(&se_tpg->se_tpg_list,
> -                       &se_global->g_se_tpg_list))
> -             seq_puts(seq, "inst dev port indx dev_or_port intr_name "
> -                      "map_indx att_count num_cmds read_mbytes "
> -                      "write_mbytes hs_num_cmds creation_time row_status\n");
> -
> -     if (!(se_tpg))
> -             return 0;
> -
> -     spin_lock(&se_tpg->acl_node_lock);
> -     list_for_each_entry(se_nacl, &se_tpg->acl_node_list, acl_list) {
> -
> -             atomic_inc(&se_nacl->mib_ref_count);
> -             smp_mb__after_atomic_inc();
> -             spin_unlock(&se_tpg->acl_node_lock);
> -
> -             spin_lock_irq(&se_nacl->device_list_lock);
> -             for (j = 0; j < TRANSPORT_MAX_LUNS_PER_TPG; j++) {
> -                     deve = &se_nacl->device_list[j];
> -                     if (!(deve->lun_flags &
> -                                     TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) ||
> -                         (!deve->se_lun))
> -                             continue;
> -                     lun = deve->se_lun;
> -                     if (!lun->lun_se_dev)
> -                             continue;
> -
> -                     seq_printf(seq, "%u %u %u %u %u %s %u %u %u %u %u %u"
> -                                     " %u %s\n",
> -                             /* scsiInstIndex */
> -                             (TPG_TFO(se_tpg)->tpg_get_inst_index != NULL) ?
> -                             TPG_TFO(se_tpg)->tpg_get_inst_index(se_tpg) :
> -                             0,
> -                             /* scsiDeviceIndex */
> -                             lun->lun_se_dev->dev_index,
> -                             /* scsiAuthIntrTgtPortIndex */
> -                             TPG_TFO(se_tpg)->tpg_get_tag(se_tpg),
> -                             /* scsiAuthIntrIndex */
> -                             se_nacl->acl_index,
> -                             /* scsiAuthIntrDevOrPort */
> -                             1,
> -                             /* scsiAuthIntrName */
> -                             se_nacl->initiatorname[0] ?
> -                                     se_nacl->initiatorname : NONE,
> -                             /* FIXME: scsiAuthIntrLunMapIndex */
> -                             0,
> -                             /* scsiAuthIntrAttachedTimes */
> -                             deve->attach_count,
> -                             /* scsiAuthIntrOutCommands */
> -                             deve->total_cmds,
> -                             /* scsiAuthIntrReadMegaBytes */
> -                             (u32)(deve->read_bytes >> 20),
> -                             /* scsiAuthIntrWrittenMegaBytes */
> -                             (u32)(deve->write_bytes >> 20),
> -                             /* FIXME: scsiAuthIntrHSOutCommands */
> -                             0,
> -                             /* scsiAuthIntrLastCreation */
> -                             (u32)(((u32)deve->creation_time -
> -                                         INITIAL_JIFFIES) * 100 / HZ),
> -                             /* FIXME: scsiAuthIntrRowStatus */
> -                             "Ready");
> -             }
> -             spin_unlock_irq(&se_nacl->device_list_lock);
> -
> -             spin_lock(&se_tpg->acl_node_lock);
> -             atomic_dec(&se_nacl->mib_ref_count);
> -             smp_mb__after_atomic_dec();
> -     }
> -     spin_unlock(&se_tpg->acl_node_lock);
> -
> -     return 0;
> -}
> -
> -static const struct seq_operations scsi_auth_intr_seq_ops = {
> -     .start  = scsi_auth_intr_seq_start,
> -     .next   = scsi_auth_intr_seq_next,
> -     .stop   = scsi_auth_intr_seq_stop,
> -     .show   = scsi_auth_intr_seq_show
> -};
> -
> -static int scsi_auth_intr_seq_open(struct inode *inode, struct file
> *file)
> -{
> -     return seq_open(file, &scsi_auth_intr_seq_ops);
> -}
> -
> -static const struct file_operations scsi_auth_intr_seq_fops = {
> -     .owner   = THIS_MODULE,
> -     .open    = scsi_auth_intr_seq_open,
> -     .read    = seq_read,
> -     .llseek  = seq_lseek,
> -     .release = seq_release,
> -};
> -
> -/*
> - * SCSI Attached Initiator Port Table:
> - * It lists the SCSI Initiators attached to one of the local Target
> ports.
> - * Iterates through all active TPGs and use active sessions from each TPG
> - * to list the info fo this table.
> - */
> -static void *scsi_att_intr_port_seq_start(struct seq_file *seq, loff_t
> *pos)
> -{
> -     spin_lock_bh(&se_global->se_tpg_lock);
> -     return seq_list_start(&se_global->g_se_tpg_list, *pos);
> -}
> -
> -static void *scsi_att_intr_port_seq_next(struct seq_file *seq, void *v,
> -                                      loff_t *pos)
> -{
> -     return seq_list_next(v, &se_global->g_se_tpg_list, pos);
> -}
> -
> -static void scsi_att_intr_port_seq_stop(struct seq_file *seq, void *v)
> -{
> -     spin_unlock_bh(&se_global->se_tpg_lock);
> -}
> -
> -static int scsi_att_intr_port_seq_show(struct seq_file *seq, void *v)
> -{
> -     struct se_portal_group *se_tpg = list_entry(v, struct
> se_portal_group,
> -                                             se_tpg_list);
> -     struct se_dev_entry *deve;
> -     struct se_lun *lun;
> -     struct se_node_acl *se_nacl;
> -     struct se_session *se_sess;
> -     unsigned char buf[64];
> -     int j;
> -
> -     if (list_is_first(&se_tpg->se_tpg_list,
> -                       &se_global->g_se_tpg_list))
> -             seq_puts(seq, "inst dev port indx port_auth_indx port_name"
> -                     " port_ident\n");
> -
> -     if (!(se_tpg))
> -             return 0;
> -
> -     spin_lock(&se_tpg->session_lock);
> -     list_for_each_entry(se_sess, &se_tpg->tpg_sess_list, sess_list) {
> -             if ((TPG_TFO(se_tpg)->sess_logged_in(se_sess)) ||
> -                 (!se_sess->se_node_acl) ||
> -                 (!se_sess->se_node_acl->device_list))
> -                     continue;
> -
> -             atomic_inc(&se_sess->mib_ref_count);
> -             smp_mb__after_atomic_inc();
> -             se_nacl = se_sess->se_node_acl;
> -             atomic_inc(&se_nacl->mib_ref_count);
> -             smp_mb__after_atomic_inc();
> -             spin_unlock(&se_tpg->session_lock);
> -
> -             spin_lock_irq(&se_nacl->device_list_lock);
> -             for (j = 0; j < TRANSPORT_MAX_LUNS_PER_TPG; j++) {
> -                     deve = &se_nacl->device_list[j];
> -                     if (!(deve->lun_flags &
> -                                     TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) ||
> -                        (!deve->se_lun))
> -                             continue;
> -
> -                     lun = deve->se_lun;
> -                     if (!lun->lun_se_dev)
> -                             continue;
> -
> -                     memset(buf, 0, 64);
> -                     if (TPG_TFO(se_tpg)->sess_get_initiator_sid != NULL)
> -                             TPG_TFO(se_tpg)->sess_get_initiator_sid(
> -                                     se_sess, (unsigned char *)&buf[0], 64);
> -
> -                     seq_printf(seq, "%u %u %u %u %u %s+i+%s\n",
> -                             /* scsiInstIndex */
> -                             (TPG_TFO(se_tpg)->tpg_get_inst_index != NULL) ?
> -                             TPG_TFO(se_tpg)->tpg_get_inst_index(se_tpg) :
> -                             0,
> -                             /* scsiDeviceIndex */
> -                             lun->lun_se_dev->dev_index,
> -                             /* scsiPortIndex */
> -                             TPG_TFO(se_tpg)->tpg_get_tag(se_tpg),
> -                             /* scsiAttIntrPortIndex */
> -                             (TPG_TFO(se_tpg)->sess_get_index != NULL) ?
> -                             TPG_TFO(se_tpg)->sess_get_index(se_sess) :
> -                             0,
> -                             /* scsiAttIntrPortAuthIntrIdx */
> -                             se_nacl->acl_index,
> -                             /* scsiAttIntrPortName */
> -                             se_nacl->initiatorname[0] ?
> -                                     se_nacl->initiatorname : NONE,
> -                             /* scsiAttIntrPortIdentifier */
> -                             buf);
> -             }
> -             spin_unlock_irq(&se_nacl->device_list_lock);
> -
> -             spin_lock(&se_tpg->session_lock);
> -             atomic_dec(&se_nacl->mib_ref_count);
> -             smp_mb__after_atomic_dec();
> -             atomic_dec(&se_sess->mib_ref_count);
> -             smp_mb__after_atomic_dec();
> -     }
> -     spin_unlock(&se_tpg->session_lock);
> -
> -     return 0;
> -}
> -
> -static const struct seq_operations scsi_att_intr_port_seq_ops = {
> -     .start  = scsi_att_intr_port_seq_start,
> -     .next   = scsi_att_intr_port_seq_next,
> -     .stop   = scsi_att_intr_port_seq_stop,
> -     .show   = scsi_att_intr_port_seq_show
> -};
> -
> -static int scsi_att_intr_port_seq_open(struct inode *inode, struct file
> *file)
> -{
> -     return seq_open(file, &scsi_att_intr_port_seq_ops);
> -}
> -
> -static const struct file_operations scsi_att_intr_port_seq_fops = {
> -     .owner   = THIS_MODULE,
> -     .open    = scsi_att_intr_port_seq_open,
> -     .read    = seq_read,
> -     .llseek  = seq_lseek,
> -     .release = seq_release,
> -};
> -
> -/*
> - * SCSI Logical Unit Table
> - */
> -static void *scsi_lu_seq_start(struct seq_file *seq, loff_t *pos)
> -{
> -     return locate_hba_start(seq, pos);
> -}
> -
> -static void *scsi_lu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> -{
> -     return locate_hba_next(seq, v, pos);
> -}
> -
> -static void scsi_lu_seq_stop(struct seq_file *seq, void *v)
> -{
> -     locate_hba_stop(seq, v);
> -}
> -
> -#define SCSI_LU_INDEX                1
> -static int scsi_lu_seq_show(struct seq_file *seq, void *v)
> -{
> -     struct se_hba *hba;
> -     struct se_subsystem_dev *se_dev = list_entry(v, struct
> se_subsystem_dev,
> -                                             g_se_dev_list);
> -     struct se_device *dev = se_dev->se_dev_ptr;
> -     int j;
> -     char str[28];
> -
> -     if (list_is_first(&se_dev->g_se_dev_list, &se_global-
> >g_se_dev_list))
> -             seq_puts(seq, "inst dev indx LUN lu_name vend prod rev"
> -             " dev_type status state-bit num_cmds read_mbytes"
> -             " write_mbytes resets full_stat hs_num_cmds creation_time\n");
> -
> -     if (!(dev))
> -             return 0;
> -
> -     hba = dev->se_hba;
> -     if (!(hba)) {
> -             /* Log error ? */
> -             return 0;
> -     }
> -
> -     /* Fix LU state, if we can read it from the device */
> -     seq_printf(seq, "%u %u %u %llu %s", hba->hba_index,
> -                     dev->dev_index, SCSI_LU_INDEX,
> -                     (unsigned long long)0, /* FIXME: scsiLuDefaultLun */
> -                     (strlen(DEV_T10_WWN(dev)->unit_serial)) ?
> -                     /* scsiLuWwnName */
> -                     (char *)&DEV_T10_WWN(dev)->unit_serial[0] :
> -                     "None");
> -
> -     memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
> -     /* scsiLuVendorId */
> -     for (j = 0; j < 8; j++)
> -             str[j] = ISPRINT(DEV_T10_WWN(dev)->vendor[j]) ?
> -                     DEV_T10_WWN(dev)->vendor[j] : 0x20;
> -     str[8] = 0;
> -     seq_printf(seq, " %s", str);
> -
> -     /* scsiLuProductId */
> -     for (j = 0; j < 16; j++)
> -             str[j] = ISPRINT(DEV_T10_WWN(dev)->model[j]) ?
> -                     DEV_T10_WWN(dev)->model[j] : 0x20;
> -     str[16] = 0;
> -     seq_printf(seq, " %s", str);
> -
> -     /* scsiLuRevisionId */
> -     for (j = 0; j < 4; j++)
> -             str[j] = ISPRINT(DEV_T10_WWN(dev)->revision[j]) ?
> -                     DEV_T10_WWN(dev)->revision[j] : 0x20;
> -     str[4] = 0;
> -     seq_printf(seq, " %s", str);
> -
> -     seq_printf(seq, " %u %s %s %llu %u %u %u %u %u %u\n",
> -             /* scsiLuPeripheralType */
> -                TRANSPORT(dev)->get_device_type(dev),
> -                (dev->dev_status == TRANSPORT_DEVICE_ACTIVATED) ?
> -             "available" : "notavailable", /* scsiLuStatus */
> -             "exposed",      /* scsiLuState */
> -             (unsigned long long)dev->num_cmds,
> -             /* scsiLuReadMegaBytes */
> -             (u32)(dev->read_bytes >> 20),
> -             /* scsiLuWrittenMegaBytes */
> -             (u32)(dev->write_bytes >> 20),
> -             dev->num_resets, /* scsiLuInResets */
> -             0, /* scsiLuOutTaskSetFullStatus */
> -             0, /* scsiLuHSInCommands */
> -             (u32)(((u32)dev->creation_time - INITIAL_JIFFIES) *
> -                                                     100 / HZ));
> -
> -     return 0;
> -}
> -
> -static const struct seq_operations scsi_lu_seq_ops = {
> -     .start  = scsi_lu_seq_start,
> -     .next   = scsi_lu_seq_next,
> -     .stop   = scsi_lu_seq_stop,
> -     .show   = scsi_lu_seq_show
> -};
> -
> -static int scsi_lu_seq_open(struct inode *inode, struct file *file)
> -{
> -     return seq_open(file, &scsi_lu_seq_ops);
> -}
> -
> -static const struct file_operations scsi_lu_seq_fops = {
> -     .owner   = THIS_MODULE,
> -     .open    = scsi_lu_seq_open,
> -     .read    = seq_read,
> -     .llseek  = seq_lseek,
> -     .release = seq_release,
> -};
> -
> -
> /*************************************************************************
> ***/
> -
> -/*
> - * Remove proc fs entries
> - */
> -void remove_scsi_target_mib(void)
> -{
> -     remove_proc_entry("scsi_target/mib/scsi_inst", NULL);
> -     remove_proc_entry("scsi_target/mib/scsi_dev", NULL);
> -     remove_proc_entry("scsi_target/mib/scsi_port", NULL);
> -     remove_proc_entry("scsi_target/mib/scsi_transport", NULL);
> -     remove_proc_entry("scsi_target/mib/scsi_tgt_dev", NULL);
> -     remove_proc_entry("scsi_target/mib/scsi_tgt_port", NULL);
> -     remove_proc_entry("scsi_target/mib/scsi_auth_intr", NULL);
> -     remove_proc_entry("scsi_target/mib/scsi_att_intr_port", NULL);
> -     remove_proc_entry("scsi_target/mib/scsi_lu", NULL);
> -     remove_proc_entry("scsi_target/mib", NULL);
> -}
> -
> -/*
> - * Create proc fs entries for the mib tables
> - */
> -int init_scsi_target_mib(void)
> -{
> -     struct proc_dir_entry *dir_entry;
> -     struct proc_dir_entry *scsi_inst_entry;
> -     struct proc_dir_entry *scsi_dev_entry;
> -     struct proc_dir_entry *scsi_port_entry;
> -     struct proc_dir_entry *scsi_transport_entry;
> -     struct proc_dir_entry *scsi_tgt_dev_entry;
> -     struct proc_dir_entry *scsi_tgt_port_entry;
> -     struct proc_dir_entry *scsi_auth_intr_entry;
> -     struct proc_dir_entry *scsi_att_intr_port_entry;
> -     struct proc_dir_entry *scsi_lu_entry;
> -
> -     dir_entry = proc_mkdir("scsi_target/mib", NULL);
> -     if (!(dir_entry)) {
> -             printk(KERN_ERR "proc_mkdir() failed.\n");
> -             return -1;
> -     }
> -
> -     scsi_inst_entry =
> -             create_proc_entry("scsi_target/mib/scsi_inst", 0, NULL);
> -     if (scsi_inst_entry)
> -             scsi_inst_entry->proc_fops = &scsi_inst_seq_fops;
> -     else
> -             goto error;
> -
> -     scsi_dev_entry =
> -             create_proc_entry("scsi_target/mib/scsi_dev", 0, NULL);
> -     if (scsi_dev_entry)
> -             scsi_dev_entry->proc_fops = &scsi_dev_seq_fops;
> -     else
> -             goto error;
> -
> -     scsi_port_entry =
> -             create_proc_entry("scsi_target/mib/scsi_port", 0, NULL);
> -     if (scsi_port_entry)
> -             scsi_port_entry->proc_fops = &scsi_port_seq_fops;
> -     else
> -             goto error;
> -
> -     scsi_transport_entry =
> -             create_proc_entry("scsi_target/mib/scsi_transport", 0, NULL);
> -     if (scsi_transport_entry)
> -             scsi_transport_entry->proc_fops = &scsi_transport_seq_fops;
> -     else
> -             goto error;
> -
> -     scsi_tgt_dev_entry =
> -             create_proc_entry("scsi_target/mib/scsi_tgt_dev", 0, NULL);
> -     if (scsi_tgt_dev_entry)
> -             scsi_tgt_dev_entry->proc_fops = &scsi_tgt_dev_seq_fops;
> -     else
> -             goto error;
> -
> -     scsi_tgt_port_entry =
> -             create_proc_entry("scsi_target/mib/scsi_tgt_port", 0, NULL);
> -     if (scsi_tgt_port_entry)
> -             scsi_tgt_port_entry->proc_fops = &scsi_tgt_port_seq_fops;
> -     else
> -             goto error;
> -
> -     scsi_auth_intr_entry =
> -             create_proc_entry("scsi_target/mib/scsi_auth_intr", 0, NULL);
> -     if (scsi_auth_intr_entry)
> -             scsi_auth_intr_entry->proc_fops = &scsi_auth_intr_seq_fops;
> -     else
> -             goto error;
> -
> -     scsi_att_intr_port_entry =
> -           create_proc_entry("scsi_target/mib/scsi_att_intr_port", 0,
> NULL);
> -     if (scsi_att_intr_port_entry)
> -             scsi_att_intr_port_entry->proc_fops =
> -                             &scsi_att_intr_port_seq_fops;
> -     else
> -             goto error;
> -
> -     scsi_lu_entry = create_proc_entry("scsi_target/mib/scsi_lu", 0,
> NULL);
> -     if (scsi_lu_entry)
> -             scsi_lu_entry->proc_fops = &scsi_lu_seq_fops;
> -     else
> -             goto error;
> -
> -     return 0;
> -
> -error:
> -     printk(KERN_ERR "create_proc_entry() failed.\n");
> -     remove_scsi_target_mib();
> -     return -1;
> -}
> -
> -/*
> - * Initialize the index table for allocating unique row indexes to
> various mib
> - * tables
> - */
> -void init_scsi_index_table(void)
> -{
> -     memset(&scsi_index_table, 0, sizeof(struct scsi_index_table));
> -     spin_lock_init(&scsi_index_table.lock);
> -}
> -
> -/*
> - * Allocate a new row index for the entry type specified
> - */
> -u32 scsi_get_new_index(scsi_index_t type)
> -{
> -     u32 new_index;
> -
> -     if ((type < 0) || (type >= SCSI_INDEX_TYPE_MAX)) {
> -             printk(KERN_ERR "Invalid index type %d\n", type);
> -             return -1;
> -     }
> -
> -     spin_lock(&scsi_index_table.lock);
> -     new_index = ++scsi_index_table.scsi_mib_index[type];
> -     if (new_index == 0)
> -             new_index = ++scsi_index_table.scsi_mib_index[type];
> -     spin_unlock(&scsi_index_table.lock);
> -
> -     return new_index;
> -}
> -EXPORT_SYMBOL(scsi_get_new_index);
> diff --git a/drivers/target/target_core_mib.h
> b/drivers/target/target_core_mib.h
> deleted file mode 100644
> index 2772046..0000000
> --- a/drivers/target/target_core_mib.h
> +++ /dev/null
> @@ -1,28 +0,0 @@
> -#ifndef TARGET_CORE_MIB_H
> -#define TARGET_CORE_MIB_H
> -
> -typedef enum {
> -     SCSI_INST_INDEX,
> -     SCSI_DEVICE_INDEX,
> -     SCSI_AUTH_INTR_INDEX,
> -     SCSI_INDEX_TYPE_MAX
> -} scsi_index_t;
> -
> -struct scsi_index_table {
> -     spinlock_t      lock;
> -     u32             scsi_mib_index[SCSI_INDEX_TYPE_MAX];
> -} ____cacheline_aligned;
> -
> -/* SCSI Port stats */
> -struct scsi_port_stats {
> -     u64     cmd_pdus;
> -     u64     tx_data_octets;
> -     u64     rx_data_octets;
> -} ____cacheline_aligned;
> -
> -extern int init_scsi_target_mib(void);
> -extern void remove_scsi_target_mib(void);
> -extern void init_scsi_index_table(void);
> -extern u32 scsi_get_new_index(scsi_index_t);
> -
> -#endif   /*** TARGET_CORE_MIB_H ***/
> diff --git a/drivers/target/target_core_pscsi.c
> b/drivers/target/target_core_pscsi.c
> index 742d246..f2a0847 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -462,8 +462,8 @@ static struct se_device *pscsi_create_type_disk(
>        */
>       bd = blkdev_get_by_path(se_dev->se_dev_udev_path,
>                               FMODE_WRITE|FMODE_READ|FMODE_EXCL, pdv);
> -     if (!(bd)) {
> -             printk("pSCSI: blkdev_get_by_path() failed\n");
> +     if (IS_ERR(bd)) {
> +             printk(KERN_ERR "pSCSI: blkdev_get_by_path() failed\n");
>               scsi_device_put(sd);
>               return NULL;
>       }
> diff --git a/drivers/target/target_core_tpg.c
> b/drivers/target/target_core_tpg.c
> index abfa81a..c26f674 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -275,7 +275,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
>       spin_lock_init(&acl->device_list_lock);
>       spin_lock_init(&acl->nacl_sess_lock);
>       atomic_set(&acl->acl_pr_ref_count, 0);
> -     atomic_set(&acl->mib_ref_count, 0);
>       acl->queue_depth = TPG_TFO(tpg)->tpg_get_default_depth(tpg);
>       snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s",
> initiatorname);
>       acl->se_tpg = tpg;
> @@ -318,12 +317,6 @@ void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl
> *nacl)
>               cpu_relax();
>  }
>
> -void core_tpg_wait_for_mib_ref(struct se_node_acl *nacl)
> -{
> -     while (atomic_read(&nacl->mib_ref_count) != 0)
> -             cpu_relax();
> -}
> -
>  void core_tpg_clear_object_luns(struct se_portal_group *tpg)
>  {
>       int i, ret;
> @@ -480,7 +473,6 @@ int core_tpg_del_initiator_node_acl(
>       spin_unlock_bh(&tpg->session_lock);
>
>       core_tpg_wait_for_nacl_pr_ref(acl);
> -     core_tpg_wait_for_mib_ref(acl);
>       core_clear_initiator_node_from_tpg(acl, tpg);
>       core_free_device_list_for_node(acl, tpg);
>
> @@ -701,6 +693,8 @@ EXPORT_SYMBOL(core_tpg_register);
>
>  int core_tpg_deregister(struct se_portal_group *se_tpg)
>  {
> +     struct se_node_acl *nacl, *nacl_tmp;
> +
>       printk(KERN_INFO "TARGET_CORE[%s]: Deallocating %s struct
> se_portal_group"
>               " for endpoint: %s Portal Tag %u\n",
>               (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) ?
> @@ -714,6 +708,25 @@ int core_tpg_deregister(struct se_portal_group
> *se_tpg)
>
>       while (atomic_read(&se_tpg->tpg_pr_ref_count) != 0)
>               cpu_relax();
> +     /*
> +      * Release any remaining demo-mode generated se_node_acl that have
> +      * not been released because of TFO->tpg_check_demo_mode_cache() ==
> 1
> +      * in transport_deregister_session().
> +      */
> +     spin_lock_bh(&se_tpg->acl_node_lock);
> +     list_for_each_entry_safe(nacl, nacl_tmp, &se_tpg->acl_node_list,
> +                     acl_list) {
> +             list_del(&nacl->acl_list);
> +             se_tpg->num_node_acls--;
> +             spin_unlock_bh(&se_tpg->acl_node_lock);
> +
> +             core_tpg_wait_for_nacl_pr_ref(nacl);
> +             core_free_device_list_for_node(nacl, se_tpg);
> +             TPG_TFO(se_tpg)->tpg_release_fabric_acl(se_tpg, nacl);
> +
> +             spin_lock_bh(&se_tpg->acl_node_lock);
> +     }
> +     spin_unlock_bh(&se_tpg->acl_node_lock);
>
>       if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL)
>               core_tpg_release_virtual_lun0(se_tpg);
> diff --git a/drivers/target/target_core_transport.c
> b/drivers/target/target_core_transport.c
> index 28b6292..236e22d 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -379,6 +379,40 @@ void release_se_global(void)
>       se_global = NULL;
>  }
>
> +/* SCSI statistics table index */
> +static struct scsi_index_table scsi_index_table;
> +
> +/*
> + * Initialize the index table for allocating unique row indexes to
> various mib
> + * tables.
> + */
> +void init_scsi_index_table(void)
> +{
> +     memset(&scsi_index_table, 0, sizeof(struct scsi_index_table));
> +     spin_lock_init(&scsi_index_table.lock);
> +}
> +
> +/*
> + * Allocate a new row index for the entry type specified
> + */
> +u32 scsi_get_new_index(scsi_index_t type)
> +{
> +     u32 new_index;
> +
> +     if ((type < 0) || (type >= SCSI_INDEX_TYPE_MAX)) {
> +             printk(KERN_ERR "Invalid index type %d\n", type);
> +             return -EINVAL;
> +     }
> +
> +     spin_lock(&scsi_index_table.lock);
> +     new_index = ++scsi_index_table.scsi_mib_index[type];
> +     if (new_index == 0)
> +             new_index = ++scsi_index_table.scsi_mib_index[type];
> +     spin_unlock(&scsi_index_table.lock);
> +
> +     return new_index;
> +}
> +
>  void transport_init_queue_obj(struct se_queue_obj *qobj)
>  {
>       atomic_set(&qobj->queue_cnt, 0);
> @@ -437,7 +471,6 @@ struct se_session *transport_init_session(void)
>       }
>       INIT_LIST_HEAD(&se_sess->sess_list);
>       INIT_LIST_HEAD(&se_sess->sess_acl_list);
> -     atomic_set(&se_sess->mib_ref_count, 0);
>
>       return se_sess;
>  }
> @@ -546,12 +579,6 @@ void transport_deregister_session(struct se_session
> *se_sess)
>               transport_free_session(se_sess);
>               return;
>       }
> -     /*
> -      * Wait for possible reference in drivers/target/target_core_mib.c:
> -      * scsi_att_intr_port_seq_show()
> -      */
> -     while (atomic_read(&se_sess->mib_ref_count) != 0)
> -             cpu_relax();
>
>       spin_lock_bh(&se_tpg->session_lock);
>       list_del(&se_sess->sess_list);
> @@ -574,7 +601,6 @@ void transport_deregister_session(struct se_session
> *se_sess)
>                               spin_unlock_bh(&se_tpg->acl_node_lock);
>
>                               core_tpg_wait_for_nacl_pr_ref(se_nacl);
> -                             core_tpg_wait_for_mib_ref(se_nacl);
>                               core_free_device_list_for_node(se_nacl, se_tpg);
>                               TPG_TFO(se_tpg)->tpg_release_fabric_acl(se_tpg,
>                                               se_nacl);
> @@ -4827,6 +4853,8 @@ static int transport_do_se_mem_map(
>
>               return ret;
>       }
> +
> +     BUG_ON(list_empty(se_mem_list));
>       /*
>        * This is the normal path for all normal non BIDI and BIDI-COMMAND
>        * WRITE payloads..  If we need to do BIDI READ passthrough for
> @@ -5008,7 +5036,9 @@ transport_map_control_cmd_to_task(struct se_cmd
> *cmd)
>               struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
>               u32 se_mem_cnt = 0, task_offset = 0;
>
> -             BUG_ON(list_empty(cmd->t_task->t_mem_list));
> +             if (!list_empty(T_TASK(cmd)->t_mem_list))
> +                     se_mem = list_entry(T_TASK(cmd)->t_mem_list->next,
> +                                     struct se_mem, se_list);
>
>               ret = transport_do_se_mem_map(dev, task,
>                               cmd->t_task->t_mem_list, NULL, se_mem,
> diff --git a/include/target/target_core_base.h
> b/include/target/target_core_base.h
> index 07fdfb6..0828b6c 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -8,7 +8,6 @@
>  #include <scsi/scsi_cmnd.h>
>  #include <net/sock.h>
>  #include <net/tcp.h>
> -#include "target_core_mib.h"
>
>  #define TARGET_CORE_MOD_VERSION              "v4.0.0-rc6"
>  #define SHUTDOWN_SIGS
>       (sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
> @@ -195,6 +194,21 @@ typedef enum {
>       SAM_TASK_ATTR_EMULATED
>  } t10_task_attr_index_t;
>
> +/*
> + * Used for target SCSI statistics
> + */
> +typedef enum {
> +     SCSI_INST_INDEX,
> +     SCSI_DEVICE_INDEX,
> +     SCSI_AUTH_INTR_INDEX,
> +     SCSI_INDEX_TYPE_MAX
> +} scsi_index_t;
> +
> +struct scsi_index_table {
> +     spinlock_t      lock;
> +     u32             scsi_mib_index[SCSI_INDEX_TYPE_MAX];
> +} ____cacheline_aligned;
> +
>  struct se_cmd;
>
>  struct t10_alua {
> @@ -578,8 +592,6 @@ struct se_node_acl {
>       spinlock_t              stats_lock;
>       /* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
>       atomic_t                acl_pr_ref_count;
> -     /* Used for MIB access */
> -     atomic_t                mib_ref_count;
>       struct se_dev_entry     *device_list;
>       struct se_session       *nacl_sess;
>       struct se_portal_group *se_tpg;
> @@ -595,8 +607,6 @@ struct se_node_acl {
>  } ____cacheline_aligned;
>
>  struct se_session {
> -     /* Used for MIB access */
> -     atomic_t                mib_ref_count;
>       u64                     sess_bin_isid;
>       struct se_node_acl      *se_node_acl;
>       struct se_portal_group *se_tpg;
> @@ -806,7 +816,6 @@ struct se_hba {
>       /* Virtual iSCSI devices attached. */
>       u32                     dev_count;
>       u32                     hba_index;
> -     atomic_t                dev_mib_access_count;
>       atomic_t                load_balance_queue;
>       atomic_t                left_queue_depth;
>       /* Maximum queue depth the HBA can handle. */
> @@ -845,6 +854,12 @@ struct se_lun {
>
>  #define SE_LUN(c)            ((struct se_lun *)(c)->se_lun)
>
> +struct scsi_port_stats {
> +       u64     cmd_pdus;
> +       u64     tx_data_octets;
> +       u64     rx_data_octets;
> +} ____cacheline_aligned;
> +
>  struct se_port {
>       /* RELATIVE TARGET PORT IDENTIFER */
>       u16             sep_rtpi;
> @@ -867,6 +882,7 @@ struct se_port {
>  } ____cacheline_aligned;
>
>  struct se_tpg_np {
> +     struct se_portal_group *tpg_np_parent;
>       struct config_group     tpg_np_group;
>  } ____cacheline_aligned;
>
> diff --git a/include/target/target_core_transport.h
> b/include/target/target_core_transport.h
> index 66f44e5..2469405 100644
> --- a/include/target/target_core_transport.h
> +++ b/include/target/target_core_transport.h
> @@ -111,6 +111,8 @@ struct se_subsystem_api;
>
>  extern int init_se_global(void);
>  extern void release_se_global(void);
> +extern void init_scsi_index_table(void);
> +extern u32 scsi_get_new_index(scsi_index_t);
>  extern void transport_init_queue_obj(struct se_queue_obj *);
>  extern int transport_subsystem_check_init(void);
>  extern int transport_subsystem_register(struct se_subsystem_api *);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

