From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/4] target: Move subdev release logic into ->release()
	callback
Date: Thu, 03 Feb 2011 13:19:55 -0800
Message-ID: <1296767995.902.159.camel@haakon2.linux-iscsi.org>
References: <1296635211-6269-1-git-send-email-nab@linux-iscsi.org>
	 <1296635211-6269-3-git-send-email-nab@linux-iscsi.org>
	 <AANLkTikO_5nukkv_9-h0U8uuUzYa9Pxf0mUEBXFAp2Hz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33828 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1BCVUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2011 16:20:00 -0500
In-Reply-To: <AANLkTikO_5nukkv_9-h0U8uuUzYa9Pxf0mUEBXFAp2Hz@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Thu, 2011-02-03 at 20:48 +0100, Fubo Chen wrote:
> On Wed, Feb 2, 2011 at 9:26 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch moves the se_free_virtual_device() / se_subsystem_api->free_device()
> > and subsequent release of struct se_subsystem_dev memory to inside of the
> > configfs callback target_core_dev_item_ops->release() called from within
> > fs/configfs/item.c:config_item_cleanup() context.  This patch resolves the
> > following SLUB 'Poison overwritten' warning when calling target_core_drop_subdev()
> > -> kfree(se_dev) directly after config_item_put():
> >
> > [ 5147.638639] =============================================================================
> > [ 5147.638959] BUG kmalloc-4096: Poison overwritten
> > [ 5147.639124] -----------------------------------------------------------------------------
> > [ 5147.639124]
> > [ 5147.639294] INFO: 0xffff88000d2f887c-0xffff88000d2f887c. First byte 0x6a instead of 0x6b
> > [ 5147.639294] INFO: Allocated in kzalloc+0xf/0x11 [target_core_mod] age=2602 cpu=0 pid=14639
> > [ 5147.639294] INFO: Freed in target_core_drop_subdev+0x18d/0x199 [target_core_mod] age=25 cpu=0 pid=14654
> > [ 5147.639294] INFO: Slab 0xffffea00002e2640 objects=7 used=1 fp=0xffff88000d2f8000 flags=0x1000000000040c1
> > [ 5147.639294] INFO: Object 0xffff88000d2f8000 @offset=0 fp=0xffff88000d2fb0d8
> >
> > Cc: Joel Becker <jlbec@evilplan.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_configfs.c |   64 ++++++++++++++++-----------------
> >  1 files changed, 31 insertions(+), 33 deletions(-)
> >
> > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> > index ccb5554..3715c91 100644
> > --- a/drivers/target/target_core_configfs.c
> > +++ b/drivers/target/target_core_configfs.c
> > @@ -2004,9 +2004,35 @@ static void target_core_dev_release(struct config_item *item)
> >  {
> >        struct se_subsystem_dev *se_dev = container_of(to_config_group(item),
> >                                struct se_subsystem_dev, se_dev_group);
> > +       struct se_hba *hba = item_to_hba(&se_dev->se_dev_hba->hba_group.cg_item);
> > +       struct se_subsystem_api *t = hba->transport;
> >        struct config_group *dev_cg = &se_dev->se_dev_group;
> >
> >        kfree(dev_cg->default_groups);
> > +       /*
> > +        * This pointer will set when the storage is enabled with:
> > +        *`echo 1 > $CONFIGFS/core/$HBA/$DEV/dev_enable`
> > +        */
> > +       if (se_dev->se_dev_ptr) {
> > +               printk(KERN_INFO "Target_Core_ConfigFS: Calling se_free_"
> > +                       "virtual_device() for se_dev_ptr: %p\n",
> > +                       se_dev->se_dev_ptr);
> > +
> > +               se_free_virtual_device(se_dev->se_dev_ptr, hba);
> > +       } else {
> > +               /*
> > +                * Release struct se_subsystem_dev->se_dev_su_ptr..
> > +                */
> > +               printk(KERN_INFO "Target_Core_ConfigFS: Calling t->free_"
> > +                       "device() for se_dev_su_ptr: %p\n",
> > +                       se_dev->se_dev_su_ptr);
> > +
> > +               t->free_device(se_dev->se_dev_su_ptr);
> > +       }
> > +
> > +       printk(KERN_INFO "Target_Core_ConfigFS: Deallocating se_subsystem"
> > +                       "_dev_t: %p\n", se_dev);
> > +       kfree(se_dev);
> >  }
> >
> >  static ssize_t target_core_dev_show(struct config_item *item,
> > @@ -2847,13 +2873,11 @@ static void target_core_drop_subdev(
> >        struct se_subsystem_api *t;
> >        struct config_item *df_item;
> >        struct config_group *dev_cg, *tg_pt_gp_cg, *dev_stat_grp;
> > -       int i, ret;
> > +       int i;
> >
> >        hba = item_to_hba(&se_dev->se_dev_hba->hba_group.cg_item);
> >
> > -       if (mutex_lock_interruptible(&hba->hba_access_mutex))
> > -               goto out;
> > -
> > +       mutex_lock(&hba->hba_access_mutex);
> >        t = hba->transport;
> >
> >        spin_lock(&se_global->g_device_lock);
> > @@ -2884,38 +2908,12 @@ static void target_core_drop_subdev(
> >                dev_cg->default_groups[i] = NULL;
> >                config_item_put(df_item);
> >        }
> > -
> > -       config_item_put(item);
> >        /*
> > -        * This pointer will set when the storage is enabled with:
> > -        * `echo 1 > $CONFIGFS/core/$HBA/$DEV/dev_enable`
> > +        * The releasing of se_dev and associated se_dev->se_dev_ptr is done
> > +        * from target_core_dev_item_ops->release() ->target_core_dev_release().
> >         */
> > -       if (se_dev->se_dev_ptr) {
> > -               printk(KERN_INFO "Target_Core_ConfigFS: Calling se_free_"
> > -                       "virtual_device() for se_dev_ptr: %p\n",
> > -                               se_dev->se_dev_ptr);
> > -
> > -               ret = se_free_virtual_device(se_dev->se_dev_ptr, hba);
> > -               if (ret < 0)
> > -                       goto hba_out;
> > -       } else {
> > -               /*
> > -                * Release struct se_subsystem_dev->se_dev_su_ptr..
> > -                */
> > -               printk(KERN_INFO "Target_Core_ConfigFS: Calling t->free_"
> > -                       "device() for se_dev_su_ptr: %p\n",
> > -                       se_dev->se_dev_su_ptr);
> > -
> > -               t->free_device(se_dev->se_dev_su_ptr);
> > -       }
> > -
> > -       printk(KERN_INFO "Target_Core_ConfigFS: Deallocating se_subsystem"
> > -               "_dev_t: %p\n", se_dev);
> > -
> > -hba_out:
> > +       config_item_put(item);
> >        mutex_unlock(&hba->hba_access_mutex);
> > -out:
> > -       kfree(se_dev);
> >  }
> >
> >  static struct configfs_group_operations target_core_hba_group_ops = {
> 
> Hello Nicholas,
> 
> How to apply this patch ? This is what I get:
> 
> # git diff v2.6.38-rc2 | wc
>       0       0       0
> # patch -p1 < ../p2.patch
> patching file drivers/target/target_core_configfs.c
> Hunk #1 FAILED at 2004.
> Hunk #2 FAILED at 2847.
> Hunk #3 succeeded at 2800 (offset -84 lines).
> 2 out of 3 hunks FAILED -- saving rejects to file
> drivers/target/target_core_configfs.c.rej
> 

Hi Fubo,

Note that these are all incremental patches against the LIO upstream
lio-core-2.6.git/linus-38-rc3 tree, and not against the mainline target
code.

If you really want to apply these by hand (you should really be using
git btw ;), then you will need to first apply the series of 24 patches
against .38-rc2 mainline target code from my
scsi-post-merge-2.6.git/for-38-rc3-v2 here:

http://marc.info/?l=linux-scsi&m=129632617326015&w=2

--nab

