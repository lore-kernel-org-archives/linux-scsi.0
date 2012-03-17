From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 3/4] libfcoe: Add fcoe_sysfs
Date: Fri, 16 Mar 2012 17:25:17 -0700
Message-ID: <20120317002517.GA22430@kroah.com>
References: <20120316193640.5369.56932.stgit@localhost6.localdomain6>
 <20120316193656.5369.47569.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48702 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031537Ab2CQAZW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2012 20:25:22 -0400
Received: by dajr28 with SMTP id r28so6836947daj.19
        for <linux-scsi@vger.kernel.org>; Fri, 16 Mar 2012 17:25:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120316193656.5369.47569.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

On Fri, Mar 16, 2012 at 12:36:56PM -0700, Robert Love wrote:
> This patch adds infrastructure to libfcoe allow LLDs to
> present FIP (FCoE Initialization Protocol) discovered
> entities and their attributes to user space via sysfs.
> 
> This patch adds the following APIs-
> 
> fcoe_ctlr_attrs_add
> fcoe_ctlr_attrs_delete
> fcoe_fcf_attrs_add
> fcoe_fcf_attrs_delete

Maybe I'm a bit confused, but "traditionally" attrs are sysfs attribute
files, right?  These need to be created _before_ the device is exposed
to userspace through a uevent call.  Having a separate function for
these is usually too late, unless your fcoe core delays the uevent call
until after these are called?

Who would make these function calls, individual drivers?  Why doesn't
the core do this for all fcoe devices?

> They allow the LLD to expose the FCoE ENode Controller
> and any discovered FCFs (Fibre Channel Forwarders, e.g.
> FCoE switches) to the user. Each of these new devices
> has their own class so that they are grouped together
> for easy lookup from a user space application. Each
> new class has an attribute_group to expose attributes
> for any created instances. The attributes are-
> 
> fcoe_ctlr_attrs
> * fcf_dev_loss_tmo
> * lesb_link_fail
> * lesb_vlink_fail
> * lesb_miss_fka
> * lesb_symb_err
> * lesb_err_block
> * lesb_fcs_error
> 
> fcoe_fcf_attrs
> * fabric_name
> * switch_name
> * priority
> * selected
> * fc_map
> * vfid
> * mac
> * fka_peroid
> * fabric_state
> * dev_loss_tmo
> 
> A device loss infrastructre similar to the FC Transport's
> is also added by this patch. It is nice to have so that a
> link flapping adapter doesn't continually advance the count
> used to identify the discovered FCF. FCFs will exist in a
> "Disconnected" state until either the timer expires or the
> FCF is rediscovered and becomes "Connected."
> 
> This patch generates a few checkpatch.pl WARNINGS that
> I'm not sure what to do about. They're macros modeled
> around the FC Transport attribute building macros, which
> have the same 'feature' where the caller can ommit a cast
> in the argument list and no cast occurs in the code. I'm
> not sure how to keep the code condensed while keeping the
> macros. Any advice would be appreciated.
> 
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> Tested-by: Ross Brattain <ross.b.brattain@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-class-fcoe |   77 +++
>  drivers/scsi/fcoe/Makefile                 |    2 
>  drivers/scsi/fcoe/fcoe_sysfs.c             |  840 ++++++++++++++++++++++++++++
>  drivers/scsi/fcoe/fcoe_transport.c         |   13 
>  include/scsi/fcoe_sysfs.h                  |  124 ++++
>  include/scsi/libfcoe.h                     |    1 
>  6 files changed, 1054 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fcoe
>  create mode 100644 drivers/scsi/fcoe/fcoe_sysfs.c
>  create mode 100644 include/scsi/fcoe_sysfs.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-fcoe b/Documentation/ABI/testing/sysfs-class-fcoe
> new file mode 100644
> index 0000000..e9cd7e9
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fcoe
> @@ -0,0 +1,77 @@
> +What:		/sys/class/fcoe_ctlr/ctlr_X

We are really trying to stay away from new classes being created.  Why
can't this be a bus and have the devices attach to that instead?  You
can have one bus with both types of "devices" attached to it, making
things a bit simpler in the end.

> +static atomic_t ctlr_num;
> +static atomic_t fcf_num;

I don't think you want to use an atomic variable here, see below for
why.

> +/**
> + * fcoe_ctlr_attrs_add() - Add a FIP ctlr to sysfs
> + * @parent:    The parent device to which the fcoe_ctlr instance
> + *             should be attached
> + * @f:         The LLD's FCoE sysfs function template pointer
> + * @priv_size: Size to be allocated with the fcoe_ctlr_attrs for the LLD
> + *
> + * This routine allocates a FIP ctlr object with some additional memory
> + * for the LLD. The FIP ctlr is initialized, added to sysfs and then
> + * attributes are added to it.
> + */
> +struct fcoe_ctlr_attrs *fcoe_ctlr_attrs_add(struct device *parent,
> +				    struct fcoe_sysfs_function_template *f,
> +				    int priv_size)
> +{
> +	struct fcoe_ctlr_attrs *ctlr;
> +	int error = 0;
> +
> +	ctlr = kzalloc(sizeof(struct fcoe_ctlr_attrs) + priv_size,
> +		       GFP_KERNEL);
> +	if (!ctlr)
> +		goto out;
> +
> +	ctlr->id = atomic_inc_return(&ctlr_num) - 1;

Does this work properly over the long run?  Shouldn't you use the idr
interface instead, to keep holes from showing up?

> +	ctlr->f = f;
> +	INIT_LIST_HEAD(&ctlr->fcfs);
> +	mutex_init(&ctlr->lock);
> +	device_initialize(&ctlr->dev);
> +	ctlr->dev.parent = get_device(parent);

I thought you dropped these get_device() calls on the parent?  The
driver core handles this for you, please don't do it here, it's not
needed.

> +	ctlr->dev.class = &fcoe_ctlr_class;
> +
> +	ctlr->fcf_dev_loss_tmo = fcoe_fcf_dev_loss_tmo;
> +
> +	snprintf(ctlr->work_q_name, sizeof(ctlr->work_q_name),
> +		 "ctlr_wq_%d", ctlr->id);
> +	ctlr->work_q = create_singlethread_workqueue(
> +		ctlr->work_q_name);
> +	if (!ctlr->work_q)
> +		goto out_del;
> +
> +	snprintf(ctlr->devloss_work_q_name,
> +		 sizeof(ctlr->devloss_work_q_name),
> +		 "ctlr_dl_wq_%d", ctlr->id);
> +	ctlr->devloss_work_q = create_singlethread_workqueue(
> +		ctlr->devloss_work_q_name);
> +	if (!ctlr->devloss_work_q)
> +		goto out_del_q;
> +
> +	dev_set_name(&ctlr->dev, "ctlr_%d", ctlr->id);
> +	error = device_add(&ctlr->dev);
> +	if (error)
> +		goto out_del_q2;
> +
> +	error = sysfs_create_group(&ctlr->dev.kobj,
> +				   &fcoe_ctlr_attribute_group);
> +	if (error)
> +		goto out_del_dev;
> +
> +	error = sysfs_create_group(&ctlr->dev.kobj,
> +				   &fcoe_ctlr_lesb_attribute_group);
> +	if (error)
> +		goto out_del_dev;

You just raced userspace by creating your attributes after device_add()
causing lots of problems in the longrun.  Why not make these default
attribute groups that the driver core automatically creates for you
properly?  That also makes your error path simpler, as well as your
cleanup path for when this device goes away.

> +	return ctlr;
> +
> +out_del_dev:
> +	device_del(&ctlr->dev);
> +out_del_q2:
> +	destroy_workqueue(ctlr->devloss_work_q);
> +	ctlr->devloss_work_q = NULL;
> +out_del_q:
> +	destroy_workqueue(ctlr->work_q);
> +	ctlr->work_q = NULL;
> +out_del:
> +	put_device(parent);
> +	kfree(ctlr);
> +out:
> +	return NULL;
> +}
> +EXPORT_SYMBOL(fcoe_ctlr_attrs_add);

EXPORT_SYMBOL_GPL() for this, and other exports?

> +/**
> + * fcoe_fcf_attrs_add() - Add a FCoE sysfs fcoe_fcf_attrs to the system
> + * @ctlr:    The fcoe_ctlr_attrs that will be the fcoe_fcf_attrs parent
> + * @new_fcf: A temporary FCF used for lookups on the current list of fcfs
> + *
> + * Expects to be called with the ctlr->lock held
> + */
> +struct fcoe_fcf_attrs *fcoe_fcf_attrs_add(struct fcoe_ctlr_attrs *ctlr,
> +					  struct fcoe_fcf_attrs *new_fcf)
> +{
> +	struct fcoe_fcf_attrs *fcf;
> +	int error = 0;
> +
> +	list_for_each_entry(fcf, &ctlr->fcfs, peers) {
> +		if (fcoe_fcf_attrs_match(new_fcf, fcf)) {
> +			if (fcf->state == FCOE_FCF_STATE_CONNECTED)
> +				return fcf;
> +
> +			fcf->state = FCOE_FCF_STATE_CONNECTED;
> +
> +			if (!cancel_delayed_work(&fcf->dev_loss_work))
> +				fcoe_ctlr_attrs_flush_devloss(ctlr);
> +
> +			return fcf;
> +		}
> +	}
> +
> +	fcf = kzalloc(sizeof(struct fcoe_fcf_attrs), GFP_ATOMIC);
> +	if (unlikely(!fcf))
> +		goto out;
> +
> +	INIT_WORK(&fcf->delete_work, fcoe_fcf_attrs_final_delete);
> +	INIT_DELAYED_WORK(&fcf->dev_loss_work, fip_timeout_deleted_fcf);
> +
> +	device_initialize(&fcf->dev);
> +	fcf->dev.parent = get_device(&ctlr->dev);

Same thing with the get_device() call here.

> +	fcf->dev.class = &fcoe_fcf_class;
> +	fcf->id = atomic_inc_return(&fcf_num) - 1;

And the id.

> +	fcf->state = FCOE_FCF_STATE_UNKNOWN;
> +
> +	fcf->dev_loss_tmo = ctlr->fcf_dev_loss_tmo;
> +
> +	dev_set_name(&fcf->dev, "fcf_%d", fcf->id);
> +
> +	fcf->fabric_name = new_fcf->fabric_name;
> +	fcf->switch_name = new_fcf->switch_name;
> +	fcf->fc_map = new_fcf->fc_map;
> +	fcf->vfid = new_fcf->vfid;
> +	memcpy(fcf->mac, new_fcf->mac, ETH_ALEN);
> +	fcf->priority = new_fcf->priority;
> +	fcf->fka_period = new_fcf->fka_period;
> +	fcf->selected = new_fcf->selected;
> +
> +	error = device_add(&fcf->dev);
> +	if (error)
> +		goto out_del;
> +
> +	error = sysfs_create_group(&fcf->dev.kobj,
> +				   &fcoe_fcf_attribute_group);
> +	if (error)
> +		goto out_del_dev;

Same thing here, you just raced userspace.

thanks,

greg k-h
