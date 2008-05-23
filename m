From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/7] scsi_dh: Implement common device table handling
Date: Thu, 22 May 2008 19:08:13 -0700
Message-ID: <1211508493.21974.502.camel@chandra-ubuntu>
References: <20080520140524.EDE3010B5DF@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43079 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbYEWCGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2008 22:06:09 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4N266e1014217
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 22:06:06 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4N266g9155660
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 22:06:06 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4N265fq021923
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 22:06:06 -0400
In-Reply-To: <20080520140524.EDE3010B5DF@craiglockhart-ipmi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Hi Hannes,

One of my comments (regarding creating a cache of vendor-product-scsi_dh
trio of already found device type). I will code it and send it.

Looks good except for the minor comments as noted below.

On Tue, 2008-05-20 at 16:05 +0200, Hannes Reinecke wrote:

<snip>

> +	spin_lock(&list_lock);
> +	list_for_each_entry(tmp, &scsi_dh_list, list) {
> +		for(i = 0; tmp->devlist[i].vendor; i++) {
> +			if (!strncmp(sdev->vendor, tmp->devlist[i].vendor,
> +				     strlen(tmp->devlist[i].vendor)) &&
> +			    !strncmp(sdev->model, tmp->devlist[i].model,
> +				     strlen(tmp->devlist[i].model))) {
> +				devinfo = tmp;
> +				break;
> +			}
> +		}
> +		if (devinfo)
> +			break;
> +	}
> +	spin_unlock(&list_lock);

The above block of code can be made into a function (as there are more
than one usage).

> +
> +	if (!devinfo)
> +		goto out;
> +
> +	if (action == BUS_NOTIFY_ADD_DEVICE) {
> +		err = scsi_dh_handler_attach(sdev, devinfo);
> +	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> +		if (sdev->scsi_dh_data == NULL)
> +			goto out;

Check above is done in scsi_dh_handler_detach. Do you think it is needed
here ?

> +		scsi_dh_handler_detach(sdev);
> +	}
> +out:
> +	return err;
> +}
> +
> +/*
> + * scsi_dh_notifier_add - Callback for scsi_register_device_handler
> + */
>  static int scsi_dh_notifier_add(struct device *dev, void *data)
>  {
>  	struct scsi_device_handler *scsi_dh = data;
> +	struct scsi_device *sdev;
> +	int i;
> +
> +	if (!scsi_is_sdev_device(dev))
> +		return 0;
> +
> +	if (!get_device(dev))
> +		return 0;
> +
> +	sdev = to_scsi_device(dev);
> +
> +	for(i = 0; scsi_dh->devlist[i].vendor; i++) {
> +		if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
> +			     strlen(scsi_dh->devlist[i].vendor)) &&
> +		    !strncmp(sdev->model, scsi_dh->devlist[i].model,
> +			     strlen(scsi_dh->devlist[i].model))) {
> +			scsi_dh_handler_attach(sdev, scsi_dh);
> +			break;
> +		}
> +	}
> +
> +	put_device(dev);
> +
> +	return 0;
> +}
> +
> +/*
> + * scsi_dh_notifier_remove - Callback for scsi_unregister_device_handler
> + */
> +static int scsi_dh_notifier_remove(struct device *dev, void *data)
> +{
> +	struct scsi_device_handler *scsi_dh = data;
> +	struct scsi_device *sdev;
> +
> +	if (!scsi_is_sdev_device(dev))
> +		return 0;
> +
> +	sdev = to_scsi_device(dev);
> +
> +	if (!sdev->scsi_dh_data || sdev->scsi_dh_data->scsi_dh != scsi_dh)
> +		return 0;
> +
> +	scsi_dh_handler_detach(sdev);
> 
> -	scsi_dh->nb.notifier_call(&scsi_dh->nb, BUS_NOTIFY_ADD_DEVICE, dev);
>  	return 0;
>  }
notifier_add above does get_device() and put_device(). We don't need it
in notifier_remove ?
> 
> @@ -59,33 +186,19 @@ static int scsi_dh_notifier_add(struct device *dev, void *data)
>   */
>  int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
>  {
> -	int ret = -EBUSY;
> -	struct scsi_device_handler *tmp;
> -
> -	tmp = get_device_handler(scsi_dh->name);
> -	if (tmp)
> -		goto done;
> +	if (get_device_handler(scsi_dh->name))
> +		return -EBUSY;
> 
> -	ret = bus_register_notifier(&scsi_bus_type, &scsi_dh->nb);
> -
> -	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
>  	spin_lock(&list_lock);
>  	list_add(&scsi_dh->list, &scsi_dh_list);
>  	spin_unlock(&list_lock);
> +	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
> +	printk(KERN_INFO "%s: device handler registered\n", scsi_dh->name);
> 
> -done:
> -	return ret;
> +	return SCSI_DH_OK;
>  }
>  EXPORT_SYMBOL_GPL(scsi_register_device_handler);
> 
> -static int scsi_dh_notifier_remove(struct device *dev, void *data)
> -{
> -	struct scsi_device_handler *scsi_dh = data;
> -
> -	scsi_dh->nb.notifier_call(&scsi_dh->nb, BUS_NOTIFY_DEL_DEVICE, dev);
> -	return 0;
> -}
> -
>  /*
>   * scsi_unregister_device_handler - register a device handler personality
>   *      module.
> @@ -95,23 +208,18 @@ static int scsi_dh_notifier_remove(struct device *dev, void *data)
>   */
>  int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
>  {
> -	int ret = -ENODEV;
> -	struct scsi_device_handler *tmp;
> -
> -	tmp = get_device_handler(scsi_dh->name);
> -	if (!tmp)
> -		goto done;
> -
> -	ret = bus_unregister_notifier(&scsi_bus_type, &scsi_dh->nb);
> +	if (!get_device_handler(scsi_dh->name))
> +		return -ENODEV;
> 
>  	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh,
> -					scsi_dh_notifier_remove);
> +			 scsi_dh_notifier_remove);
> +
>  	spin_lock(&list_lock);
>  	list_del(&scsi_dh->list);
>  	spin_unlock(&list_lock);
> +	printk(KERN_INFO "%s: device handler unregistered\n", scsi_dh->name);
> 
> -done:
> -	return ret;
> +	return SCSI_DH_OK;
>  }
>  EXPORT_SYMBOL_GPL(scsi_unregister_device_handler);
> 
> @@ -157,6 +265,27 @@ int scsi_dh_handler_exist(const char *name)
>  }
>  EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
> 
> +static struct notifier_block scsi_dh_nb = {
> +	.notifier_call = scsi_dh_notifier
> +};
> +
> +static int __init scsi_dh_init(void)
> +{
> +	int r;
> +
> +	r = bus_register_notifier(&scsi_bus_type, &scsi_dh_nb);
> +
> +	return r;
> +}
> +
> +static void __exit scsi_dh_exit(void)
> +{
> +	bus_unregister_notifier(&scsi_bus_type, &scsi_dh_nb);
> +}
> +
> +module_init(scsi_dh_init);
> +module_exit(scsi_dh_exit);
> +
>  MODULE_DESCRIPTION("SCSI device handler");
>  MODULE_AUTHOR("Chandra Seetharaman <sekharan@us.ibm.com>");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
> index ed53f14..6b81ee5 100644
> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -390,21 +390,21 @@ static int clariion_check_sense(struct scsi_device *sdev,
>  	return SUCCESS;
>  }
> 
> -static const struct {
> -	char *vendor;
> -	char *model;
> -} clariion_dev_list[] = {
> +const struct scsi_dh_devlist clariion_dev_list[] = {
>  	{"DGC", "RAID"},
>  	{"DGC", "DISK"},
>  	{NULL, NULL},
>  };
> 
> -static int clariion_bus_notify(struct notifier_block *, unsigned long, void *);
> +static int clariion_bus_attach(struct scsi_device *sdev);
> +static void clariion_bus_detach(struct scsi_device *sdev);
> 
>  static struct scsi_device_handler clariion_dh = {
>  	.name		= CLARIION_NAME,
>  	.module		= THIS_MODULE,
> -	.nb.notifier_call = clariion_bus_notify,
> +	.devlist	= clariion_dev_list,
> +	.attach		= clariion_bus_attach,
> +	.detach		= clariion_bus_detach,
>  	.check_sense	= clariion_check_sense,
>  	.activate	= clariion_activate,
>  };
> @@ -412,68 +412,57 @@ static struct scsi_device_handler clariion_dh = {
>  /*
>   * TODO: need some interface so we can set trespass values
>   */
> -static int clariion_bus_notify(struct notifier_block *nb,
> -				unsigned long action, void *data)
> +static int clariion_bus_attach(struct scsi_device *sdev)
>  {
> -	struct device *dev = data;
> -	struct scsi_device *sdev = to_scsi_device(dev);
>  	struct scsi_dh_data *scsi_dh_data;
>  	struct clariion_dh_data *h;
> -	int i, found = 0;
>  	unsigned long flags;
> 
> -	if (action == BUS_NOTIFY_ADD_DEVICE) {
> -		for (i = 0; clariion_dev_list[i].vendor; i++) {
> -			if (!strncmp(sdev->vendor, clariion_dev_list[i].vendor,
> -				     strlen(clariion_dev_list[i].vendor)) &&
> -			    !strncmp(sdev->model, clariion_dev_list[i].model,
> -				     strlen(clariion_dev_list[i].model))) {
> -				found = 1;
> -				break;
> -			}
> -		}
> -		if (!found)
> -			goto out;
> -
> -		scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
> -				+ sizeof(*h) , GFP_KERNEL);
> -		if (!scsi_dh_data) {
> -			sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
> -				    CLARIION_NAME);
> -			goto out;
> -		}
> +	if (sdev->scsi_dh_data)
> +		return -EBUSY;

This check has already been done at scsi_dh level. Do we still need it
here ?

> 
> -		scsi_dh_data->scsi_dh = &clariion_dh;
> -		h = (struct clariion_dh_data *) scsi_dh_data->buf;
> -		h->default_sp = CLARIION_UNBOUND_LU;
> -		h->current_sp = CLARIION_UNBOUND_LU;
> +	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
> +			       + sizeof(*h) , GFP_KERNEL);
> +	if (!scsi_dh_data) {
> +		sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
> +			    CLARIION_NAME);
> +		return -ENOMEM;
> +	}
> 
> -		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> -		sdev->scsi_dh_data = scsi_dh_data;
> -		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +	scsi_dh_data->scsi_dh = &clariion_dh;
> +	h = (struct clariion_dh_data *) scsi_dh_data->buf;
> +	h->default_sp = CLARIION_UNBOUND_LU;
> +	h->current_sp = CLARIION_UNBOUND_LU;
> 
> -		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
> -		try_module_get(THIS_MODULE);
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +	sdev->scsi_dh_data = scsi_dh_data;
> +	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> 
> -	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> -		if (sdev->scsi_dh_data == NULL ||
> -				sdev->scsi_dh_data->scsi_dh != &clariion_dh)
> -			goto out;
> +	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
> +	try_module_get(THIS_MODULE);
> 
> -		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> -		scsi_dh_data = sdev->scsi_dh_data;
> -		sdev->scsi_dh_data = NULL;
> -		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +	return 0;
> +}
> 
> -		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n",
> -			    CLARIION_NAME);
> +static void clariion_bus_detach(struct scsi_device *sdev)
> +{
> +	struct scsi_dh_data *scsi_dh_data;
> +	unsigned long flags;
> 
> -		kfree(scsi_dh_data);
> -		module_put(THIS_MODULE);
> -	}
> +	if (sdev->scsi_dh_data == NULL ||
> +	    sdev->scsi_dh_data->scsi_dh != &clariion_dh)
> +		return;

first check is already done in scsi_dh level.

> 
> -out:
> -	return 0;
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +	scsi_dh_data = sdev->scsi_dh_data;
> +	sdev->scsi_dh_data = NULL;
> +	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +
> +	sdev_printk(KERN_NOTICE, sdev, "Detached %s.\n",
> +		    CLARIION_NAME);
> +
> +	kfree(scsi_dh_data);
> +	module_put(THIS_MODULE);
>  }
> 
>  static int __init clariion_init(void)
> diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> index 12ceab7..505c5dd 100644
> --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -108,80 +108,67 @@ done:
>  	return ret;
>  }
> 
> -static const struct {
> -	char *vendor;
> -	char *model;
> -} hp_sw_dh_data_list[] = {
> +const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
>  	{"COMPAQ", "MSA"},
>  	{"HP", "HSV"},
>  	{"DEC", "HSG80"},
>  	{NULL, NULL},
>  };
> 
> -static int hp_sw_bus_notify(struct notifier_block *, unsigned long, void *);
> +static int hp_sw_bus_attach(struct scsi_device *sdev);
> +static void hp_sw_bus_detach(struct scsi_device *sdev);
> 
>  static struct scsi_device_handler hp_sw_dh = {
>  	.name		= HP_SW_NAME,
>  	.module		= THIS_MODULE,
> -	.nb.notifier_call = hp_sw_bus_notify,
> +	.devlist	= hp_sw_dh_data_list,
> +	.attach		= hp_sw_bus_attach,
> +	.detach		= hp_sw_bus_detach,
>  	.activate	= hp_sw_activate,
>  };
> 
> -static int hp_sw_bus_notify(struct notifier_block *nb,
> -			    unsigned long action, void *data)
> +static int hp_sw_bus_attach(struct scsi_device *sdev)
>  {
> -	struct device *dev = data;
> -	struct scsi_device *sdev = to_scsi_device(dev);
>  	struct scsi_dh_data *scsi_dh_data;
> -	int i, found = 0;
>  	unsigned long flags;
> 
> -	if (action == BUS_NOTIFY_ADD_DEVICE) {
> -		for (i = 0; hp_sw_dh_data_list[i].vendor; i++) {
> -			if (!strncmp(sdev->vendor, hp_sw_dh_data_list[i].vendor,
> -				     strlen(hp_sw_dh_data_list[i].vendor)) &&
> -			    !strncmp(sdev->model, hp_sw_dh_data_list[i].model,
> -				     strlen(hp_sw_dh_data_list[i].model))) {
> -				found = 1;
> -				break;
> -			}
> -		}
> -		if (!found)
> -			goto out;
> -
> -		scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
> -				+ sizeof(struct hp_sw_dh_data) , GFP_KERNEL);
> -		if (!scsi_dh_data) {
> -			sdev_printk(KERN_ERR, sdev, "Attach Failed %s.\n",
> -				    HP_SW_NAME);
> -			goto out;
> -		}
> +	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
> +			       + sizeof(struct hp_sw_dh_data) , GFP_KERNEL);
> +	if (!scsi_dh_data) {
> +		sdev_printk(KERN_ERR, sdev, "Attach Failed %s.\n",
> +			    HP_SW_NAME);
> +		return 0;
> +	}
> 
> -		scsi_dh_data->scsi_dh = &hp_sw_dh;
> -		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> -		sdev->scsi_dh_data = scsi_dh_data;
> -		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> -		try_module_get(THIS_MODULE);
> +	scsi_dh_data->scsi_dh = &hp_sw_dh;
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +	sdev->scsi_dh_data = scsi_dh_data;
> +	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +	try_module_get(THIS_MODULE);
> +
> +	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", HP_SW_NAME);
> +
> +	return 0;
> +}
> 
> -		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", HP_SW_NAME);
> -	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> -		if (sdev->scsi_dh_data == NULL ||
> -				sdev->scsi_dh_data->scsi_dh != &hp_sw_dh)
> -			goto out;
> +static void hp_sw_bus_detach( struct scsi_device *sdev )
> +{
> +	struct scsi_dh_data *scsi_dh_data;
> +	unsigned long flags;
> 
> -		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> -		scsi_dh_data = sdev->scsi_dh_data;
> -		sdev->scsi_dh_data = NULL;
> -		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> -		module_put(THIS_MODULE);
> +	if (sdev->scsi_dh_data == NULL ||
> +	    sdev->scsi_dh_data->scsi_dh != &hp_sw_dh)
> +		return;
first check is already done in scsi_dh level.

> 
> -		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n", HP_SW_NAME);
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +	scsi_dh_data = sdev->scsi_dh_data;
> +	sdev->scsi_dh_data = NULL;
> +	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +	module_put(THIS_MODULE);
> 
> -		kfree(scsi_dh_data);
> -	}
> +	sdev_printk(KERN_NOTICE, sdev, "Detached %s\n", HP_SW_NAME);
> 
> -out:
> -	return 0;
> +	kfree(scsi_dh_data);
>  }
> 
>  static int __init hp_sw_init(void)
> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
> index 6fff077..e61cde6 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -569,10 +569,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
>  	return SCSI_RETURN_NOT_HANDLED;
>  }
> 
> -static const struct {
> -	char *vendor;
> -	char *model;
> -} rdac_dev_list[] = {
> +const struct scsi_dh_devlist rdac_dev_list[] = {
>  	{"IBM", "1722"},
>  	{"IBM", "1724"},
>  	{"IBM", "1726"},
> @@ -590,84 +587,67 @@ static const struct {
>  	{NULL, NULL},
>  };
> 
> -static int rdac_bus_notify(struct notifier_block *, unsigned long, void *);
> +static int rdac_bus_attach(struct scsi_device *sdev);
> +static void rdac_bus_detach(struct scsi_device *sdev);
> 
>  static struct scsi_device_handler rdac_dh = {
>  	.name = RDAC_NAME,
>  	.module = THIS_MODULE,
> -	.nb.notifier_call = rdac_bus_notify,
> +	.devlist = rdac_dev_list,
>  	.prep_fn = rdac_prep_fn,
>  	.check_sense = rdac_check_sense,
> +	.attach = rdac_bus_attach,
> +	.detach = rdac_bus_detach,
>  	.activate = rdac_activate,
>  };
> 
> -/*
> - * TODO: need some interface so we can set trespass values
> - */
> -static int rdac_bus_notify(struct notifier_block *nb,
> -			    unsigned long action, void *data)
> +static int rdac_bus_attach(struct scsi_device *sdev)
>  {
> -	struct device *dev = data;
> -	struct scsi_device *sdev = to_scsi_device(dev);
>  	struct scsi_dh_data *scsi_dh_data;
>  	struct rdac_dh_data *h;
> -	int i, found = 0;
>  	unsigned long flags;
> 
> -	if (action == BUS_NOTIFY_ADD_DEVICE) {
> -		for (i = 0; rdac_dev_list[i].vendor; i++) {
> -			if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
> -				     strlen(rdac_dev_list[i].vendor)) &&
> -			    !strncmp(sdev->model, rdac_dev_list[i].model,
> -				     strlen(rdac_dev_list[i].model))) {
> -				found = 1;
> -				break;
> -			}
> -		}
> -		if (!found)
> -			goto out;
> -
> -		scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
> -				+ sizeof(*h) , GFP_KERNEL);
> -		if (!scsi_dh_data) {
> -			sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
> -				    RDAC_NAME);
> -			goto out;
> -		}
> -
> -		scsi_dh_data->scsi_dh = &rdac_dh;
> -		h = (struct rdac_dh_data *) scsi_dh_data->buf;
> -		h->lun = UNINITIALIZED_LUN;
> -		h->state = RDAC_STATE_ACTIVE;
> -		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> -		sdev->scsi_dh_data = scsi_dh_data;
> -		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> -		try_module_get(THIS_MODULE);
> -
> -		sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", RDAC_NAME);
> -
> -	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> -		if (sdev->scsi_dh_data == NULL ||
> -				sdev->scsi_dh_data->scsi_dh != &rdac_dh)
> -			goto out;
> -
> -		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> -		scsi_dh_data = sdev->scsi_dh_data;
> -		sdev->scsi_dh_data = NULL;
> -		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> -
> -		h = (struct rdac_dh_data *) scsi_dh_data->buf;
> -		if (h->ctlr)
> -			kref_put(&h->ctlr->kref, release_controller);
> -		kfree(scsi_dh_data);
> -		module_put(THIS_MODULE);
> -		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n", RDAC_NAME);
> +	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
> +			       + sizeof(*h) , GFP_KERNEL);
> +	if (!scsi_dh_data) {
> +		sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
> +			    RDAC_NAME);
> +		return 0;
>  	}
> 
> -out:
> +	scsi_dh_data->scsi_dh = &rdac_dh;
> +	h = (struct rdac_dh_data *) scsi_dh_data->buf;
> +	h->lun = UNINITIALIZED_LUN;
> +	h->state = RDAC_STATE_ACTIVE;
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +	sdev->scsi_dh_data = scsi_dh_data;
> +	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +	try_module_get(THIS_MODULE);
> +
> +	sdev_printk(KERN_NOTICE, sdev, "Attached %s\n", RDAC_NAME);
> +
>  	return 0;
>  }
> 
> +static void rdac_bus_detach( struct scsi_device *sdev )
> +{
> +	struct scsi_dh_data *scsi_dh_data;
> +	struct rdac_dh_data *h;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +	scsi_dh_data = sdev->scsi_dh_data;
> +	sdev->scsi_dh_data = NULL;
> +	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +
> +	h = (struct rdac_dh_data *) scsi_dh_data->buf;
> +	if (h->ctlr)
> +		kref_put(&h->ctlr->kref, release_controller);
> +	kfree(scsi_dh_data);
> +	module_put(THIS_MODULE);
> +	sdev_printk(KERN_NOTICE, sdev, "Detached %s\n", RDAC_NAME);
> +}
> +
>  static int __init rdac_init(void)
>  {
>  	int r;
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 06b979f..62ce167 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -166,15 +166,22 @@ struct scsi_device {
>  	unsigned long		sdev_data[0];
>  } __attribute__((aligned(sizeof(unsigned long))));
> 
> +struct scsi_dh_devlist {
> +	char *vendor;
> +	char *model;
> +};
> +
>  struct scsi_device_handler {
>  	/* Used by the infrastructure */
>  	struct list_head list; /* list of scsi_device_handlers */
> -	struct notifier_block nb;
> 
>  	/* Filled by the hardware handler */
>  	struct module *module;
>  	const char *name;
> +	const struct scsi_dh_devlist *devlist;
>  	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
> +	int (*attach)(struct scsi_device *);
> +	void (*detach)(struct scsi_device *);
>  	int (*activate)(struct scsi_device *);
>  	int (*prep_fn)(struct scsi_device *, struct request *);
>  };
> -- 
> 1.5.2.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

