From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [PATCH 2/4] target: Move subdev release logic into ->release() callback
Date: Thu, 3 Feb 2011 20:48:17 +0100
Message-ID: <AANLkTikO_5nukkv_9-h0U8uuUzYa9Pxf0mUEBXFAp2Hz@mail.gmail.com>
References: <1296635211-6269-1-git-send-email-nab@linux-iscsi.org>
	<1296635211-6269-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57172 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab1BCTsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2011 14:48:18 -0500
Received: by iyj18 with SMTP id 18so1406683iyj.19
        for <linux-scsi@vger.kernel.org>; Thu, 03 Feb 2011 11:48:17 -0800 (PST)
In-Reply-To: <1296635211-6269-3-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>

On Wed, Feb 2, 2011 at 9:26 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch moves the se_free_virtual_device() / se_subsystem_api->fre=
e_device()
> and subsequent release of struct se_subsystem_dev memory to inside of=
 the
> configfs callback target_core_dev_item_ops->release() called from wit=
hin
> fs/configfs/item.c:config_item_cleanup() context. =A0This patch resol=
ves the
> following SLUB 'Poison overwritten' warning when calling target_core_=
drop_subdev()
> -> kfree(se_dev) directly after config_item_put():
>
> [ 5147.638639] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 5147.638959] BUG kmalloc-4096: Poison overwritten
> [ 5147.639124] ------------------------------------------------------=
-----------------------
> [ 5147.639124]
> [ 5147.639294] INFO: 0xffff88000d2f887c-0xffff88000d2f887c. First byt=
e 0x6a instead of 0x6b
> [ 5147.639294] INFO: Allocated in kzalloc+0xf/0x11 [target_core_mod] =
age=3D2602 cpu=3D0 pid=3D14639
> [ 5147.639294] INFO: Freed in target_core_drop_subdev+0x18d/0x199 [ta=
rget_core_mod] age=3D25 cpu=3D0 pid=3D14654
> [ 5147.639294] INFO: Slab 0xffffea00002e2640 objects=3D7 used=3D1 fp=3D=
0xffff88000d2f8000 flags=3D0x1000000000040c1
> [ 5147.639294] INFO: Object 0xffff88000d2f8000 @offset=3D0 fp=3D0xfff=
f88000d2fb0d8
>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
> =A0drivers/target/target_core_configfs.c | =A0 64 ++++++++++++++++---=
--------------
> =A01 files changed, 31 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/t=
arget_core_configfs.c
> index ccb5554..3715c91 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -2004,9 +2004,35 @@ static void target_core_dev_release(struct con=
fig_item *item)
> =A0{
> =A0 =A0 =A0 =A0struct se_subsystem_dev *se_dev =3D container_of(to_co=
nfig_group(item),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 se_subsystem_dev, se_dev_group);
> + =A0 =A0 =A0 struct se_hba *hba =3D item_to_hba(&se_dev->se_dev_hba-=
>hba_group.cg_item);
> + =A0 =A0 =A0 struct se_subsystem_api *t =3D hba->transport;
> =A0 =A0 =A0 =A0struct config_group *dev_cg =3D &se_dev->se_dev_group;
>
> =A0 =A0 =A0 =A0kfree(dev_cg->default_groups);
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* This pointer will set when the storage is enabled =
with:
> + =A0 =A0 =A0 =A0*`echo 1 > $CONFIGFS/core/$HBA/$DEV/dev_enable`
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (se_dev->se_dev_ptr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "Target_Core_ConfigFS:=
 Calling se_free_"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "virtual_device() for s=
e_dev_ptr: %p\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 se_dev->se_dev_ptr);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 se_free_virtual_device(se_dev->se_dev_p=
tr, hba);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Release struct se_subsystem_dev->s=
e_dev_su_ptr..
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "Target_Core_ConfigFS:=
 Calling t->free_"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "device() for se_dev_su=
_ptr: %p\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 se_dev->se_dev_su_ptr);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->free_device(se_dev->se_dev_su_ptr);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 printk(KERN_INFO "Target_Core_ConfigFS: Deallocating se=
_subsystem"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "_dev_t: %p\n", se_dev)=
;
> + =A0 =A0 =A0 kfree(se_dev);
> =A0}
>
> =A0static ssize_t target_core_dev_show(struct config_item *item,
> @@ -2847,13 +2873,11 @@ static void target_core_drop_subdev(
> =A0 =A0 =A0 =A0struct se_subsystem_api *t;
> =A0 =A0 =A0 =A0struct config_item *df_item;
> =A0 =A0 =A0 =A0struct config_group *dev_cg, *tg_pt_gp_cg, *dev_stat_g=
rp;
> - =A0 =A0 =A0 int i, ret;
> + =A0 =A0 =A0 int i;
>
> =A0 =A0 =A0 =A0hba =3D item_to_hba(&se_dev->se_dev_hba->hba_group.cg_=
item);
>
> - =A0 =A0 =A0 if (mutex_lock_interruptible(&hba->hba_access_mutex))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> -
> + =A0 =A0 =A0 mutex_lock(&hba->hba_access_mutex);
> =A0 =A0 =A0 =A0t =3D hba->transport;
>
> =A0 =A0 =A0 =A0spin_lock(&se_global->g_device_lock);
> @@ -2884,38 +2908,12 @@ static void target_core_drop_subdev(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_cg->default_groups[i] =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0config_item_put(df_item);
> =A0 =A0 =A0 =A0}
> -
> - =A0 =A0 =A0 config_item_put(item);
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* This pointer will set when the storage is enabled =
with:
> - =A0 =A0 =A0 =A0* `echo 1 > $CONFIGFS/core/$HBA/$DEV/dev_enable`
> + =A0 =A0 =A0 =A0* The releasing of se_dev and associated se_dev->se_=
dev_ptr is done
> + =A0 =A0 =A0 =A0* from target_core_dev_item_ops->release() ->target_=
core_dev_release().
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (se_dev->se_dev_ptr) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "Target_Core_ConfigFS:=
 Calling se_free_"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "virtual_device() for s=
e_dev_ptr: %p\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 se_dev-=
>se_dev_ptr);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D se_free_virtual_device(se_dev->=
se_dev_ptr, hba);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto hba_out;
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Release struct se_subsystem_dev->s=
e_dev_su_ptr..
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "Target_Core_ConfigFS:=
 Calling t->free_"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "device() for se_dev_su=
_ptr: %p\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 se_dev->se_dev_su_ptr);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->free_device(se_dev->se_dev_su_ptr);
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 printk(KERN_INFO "Target_Core_ConfigFS: Deallocating se=
_subsystem"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 "_dev_t: %p\n", se_dev);
> -
> -hba_out:
> + =A0 =A0 =A0 config_item_put(item);
> =A0 =A0 =A0 =A0mutex_unlock(&hba->hba_access_mutex);
> -out:
> - =A0 =A0 =A0 kfree(se_dev);
> =A0}
>
> =A0static struct configfs_group_operations target_core_hba_group_ops =
=3D {

Hello Nicholas,

How to apply this patch ? This is what I get:

# git diff v2.6.38-rc2 | wc
      0       0       0
# patch -p1 < ../p2.patch
patching file drivers/target/target_core_configfs.c
Hunk #1 FAILED at 2004.
Hunk #2 FAILED at 2847.
Hunk #3 succeeded at 2800 (offset -84 lines).
2 out of 3 hunks FAILED -- saving rejects to file
drivers/target/target_core_configfs.c.rej

=46ubo.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
