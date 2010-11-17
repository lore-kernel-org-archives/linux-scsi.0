From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target-stgt: fix initializaiton
Date: Wed, 17 Nov 2010 11:50:31 -0800
Message-ID: <1290023431.31890.3.camel@haakon2.linux-iscsi.org>
References: <20101116175807.GA26311@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44790 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935187Ab0KQTzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 14:55:54 -0500
In-Reply-To: <20101116175807.GA26311@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-16 at 12:58 -0500, Christoph Hellwig wrote:
> It looks like STGT got left behind when removing the plugin_init/free methods.
> Change it to initialize/remove its device in module_init/exit and drop the
> leftovers of the plugin_init/free methods.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Commited as d048020.  Thanks!

--nab

> Index: lio-core/drivers/target/target_core_stgt.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_stgt.c	2010-11-16 18:40:09.693004611 +0100
> +++ lio-core/drivers/target/target_core_stgt.c	2010-11-16 18:43:57.511253529 +0100
> @@ -113,49 +113,6 @@ static void stgt_release_adapter(struct
>  	kfree(stgt_hba);
>  }
>  
> -static int stgt_plugin_init(void)
> -{
> -	int ret;
> -
> -	ret = device_register(&stgt_primary);
> -	if (ret) {
> -		printk(KERN_ERR "device_register() failed for stgt_primary\n");
> -		return ret;
> -	}
> -
> -	ret = bus_register(&stgt_lld_bus);
> -	if (ret) {
> -		printk(KERN_ERR "bus_register() failed for stgt_ldd_bus\n");
> -		goto dev_unreg;
> -	}
> -
> -	ret = driver_register(&stgt_driverfs_driver);
> -	if (ret) {
> -		printk(KERN_ERR "driver_register() failed for"
> -			" stgt_driverfs_driver\n");
> -		goto bus_unreg;
> -	}
> -	stgt_host_no_cnt = 0;
> -
> -	printk(KERN_INFO "CORE_STGT[0]: Bus Initalization complete\n");
> -	return 0;
> -
> -bus_unreg:
> -	bus_unregister(&stgt_lld_bus);
> -dev_unreg:
> -	device_unregister(&stgt_primary);
> -	return ret;
> -}
> -
> -static void stgt_plugin_free(void)
> -{
> -	driver_unregister(&stgt_driverfs_driver);
> -	bus_unregister(&stgt_lld_bus);
> -	device_unregister(&stgt_primary);
> -
> -	printk(KERN_INFO "CORE_STGT[0]: Bus release complete\n");
> -}
> -
>  /*	stgt_attach_hba():
>   *
>   */
> @@ -680,8 +637,6 @@ static struct se_subsystem_api stgt_temp
>  	.check_configfs_dev_params = stgt_check_configfs_dev_params,
>  	.set_configfs_dev_params = stgt_set_configfs_dev_params,
>  	.show_configfs_dev_params = stgt_show_configfs_dev_params,
> -	.plugin_init		= stgt_plugin_init,
> -	.plugin_free		= stgt_plugin_free,
>  	.get_plugin_info	= stgt_get_plugin_info,
>  	.get_hba_info		= stgt_get_hba_info,
>  	.check_lba		= stgt_check_lba,
> @@ -694,12 +649,48 @@ static struct se_subsystem_api stgt_temp
>  
>  static int __init stgt_module_init(void)
>  {
> -	return transport_subsystem_register(&stgt_template);
> +	int ret;
> +
> +	ret = device_register(&stgt_primary);
> +	if (ret) {
> +		printk(KERN_ERR "device_register() failed for stgt_primary\n");
> +		return ret;
> +	}
> +
> +	ret = bus_register(&stgt_lld_bus);
> +	if (ret) {
> +		printk(KERN_ERR "bus_register() failed for stgt_ldd_bus\n");
> +		goto out_unregister_device;
> +	}
> +
> +	ret = driver_register(&stgt_driverfs_driver);
> +	if (ret) {
> +		printk(KERN_ERR "driver_register() failed for"
> +			" stgt_driverfs_driver\n");
> +		goto out_unregister_bus;
> +	}
> +
> +	ret = transport_subsystem_register(&stgt_template);
> +	if (ret)
> +		goto out_unregister_driver;
> +
> +	return 0;
> +out_unregister_driver:
> +	driver_unregister(&stgt_driverfs_driver);
> +out_unregister_bus:
> +	bus_unregister(&stgt_lld_bus);
> +out_unregister_device:
> +	device_unregister(&stgt_primary);
> +	return ret;
>  }
>  
>  static void stgt_module_exit(void)
>  {
>  	transport_subsystem_release(&stgt_template);
> +
> +	driver_unregister(&stgt_driverfs_driver);
> +	bus_unregister(&stgt_lld_bus);
> +	device_unregister(&stgt_primary);
>  }
>  
>  MODULE_DESCRIPTION("TCM STGT subsystem plugin");
> Index: lio-core/include/target/target_core_transport.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_transport.h	2010-11-16 18:42:38.925004541 +0100
> +++ lio-core/include/target/target_core_transport.h	2010-11-16 18:42:56.769254717 +0100
> @@ -410,14 +410,6 @@ struct se_subsystem_api {
>  	ssize_t (*show_configfs_dev_params)(struct se_hba *, struct se_subsystem_dev *,
>  						char *);
>  	/*
> -	 * plugin_init():
> -	 */
> -	int (*plugin_init)(void);
> -	/*
> -	 * plugin_free():
> -	 */
> -	void (*plugin_free)(void);
> -	/*
>  	 * get_plugin_info():
>  	 */
>  	void (*get_plugin_info)(void *, char *, int *);

