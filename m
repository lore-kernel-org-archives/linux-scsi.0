From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/9] target: clean up transport_subsystem_register
Date: Mon, 08 Nov 2010 14:32:43 -0800
Message-ID: <1289255563.27226.88.camel@haakon2.linux-iscsi.org>
References: <20101108155601.872926000@canuck.infradead.org>
	 <20101108155647.982654567@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38900 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab0KHWh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:37:56 -0500
In-Reply-To: <20101108155647.982654567@canuck.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-08 at 10:56 -0500, Christoph Hellwig wrote:
> plain text document attachment
> (lio-simplify-transport_subsystem_register)
> Move initialization of the list into transport_subsystem_register, set the
> owner field in the operations vector like for most others, remove the
> external_submod field and replace it by not having an owner pointer.
> Remove unessecary initializations to zero for se_subsystem_api fields.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Commited as f1479e8, thanks Christoph!

--nab

> Index: lio-core-2.6/drivers/target/target_core_file.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_file.c	2010-11-08 15:37:15.944863013 +0100
> +++ lio-core-2.6/drivers/target/target_core_file.c	2010-11-08 15:49:05.428196347 +0100
> @@ -953,9 +953,9 @@ static sector_t fd_get_blocks(struct se_
>  
>  static struct se_subsystem_api fileio_template = {
>  	.name			= "fileio",
> +	.owner			= THIS_MODULE,
>  	.type			= FILEIO,
>  	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
> -	.external_submod	= 1,
>  	.attach_hba		= fd_attach_hba,
>  	.detach_hba		= fd_detach_hba,
>  	.cdb_none		= fd_CDB_none,
> @@ -973,7 +973,6 @@ static struct se_subsystem_api fileio_te
>  	.transport_complete	= fd_transport_complete,
>  	.allocate_request	= fd_allocate_request,
>  	.do_task		= fd_do_task,
> -	.do_discard		= NULL,
>  	.do_sync_cache		= fd_emulate_sync_cache,
>  	.free_task		= fd_free_task,
>  	.check_configfs_dev_params = fd_check_configfs_dev_params,
> @@ -989,23 +988,14 @@ static struct se_subsystem_api fileio_te
>  	.get_device_type	= fd_get_device_type,
>  	.get_dma_length		= fd_get_dma_length,
>  	.get_blocks		= fd_get_blocks,
> -	.write_pending		= NULL,
>  };
>  
> -int __init fileio_module_init(void)
> +static int __init fileio_module_init(void)
>  {
> -	int ret;
> -
> -	INIT_LIST_HEAD(&fileio_template.sub_api_list);
> -
> -	ret = transport_subsystem_register(&fileio_template, THIS_MODULE);
> -	if (ret < 0)
> -		return ret;
> -
> -	return 0;
> +	return transport_subsystem_register(&fileio_template);
>  }
>  
> -void fileio_module_exit(void)
> +static void fileio_module_exit(void)
>  {
>  	transport_subsystem_release(&fileio_template);
>  }
> Index: lio-core-2.6/drivers/target/target_core_hba.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_hba.c	2010-11-08 15:41:43.444863012 +0100
> +++ lio-core-2.6/drivers/target/target_core_hba.c	2010-11-08 15:48:43.508196346 +0100
> @@ -100,23 +100,17 @@ int se_core_add_hba(
>  		return -EINVAL;
>  
>  	hba->transport = t;
> +
>  	/*
>  	 * Get TCM subsystem api struct module reference to struct se_hba
>  	 */
> -	if (t->external_submod) {
> -		if (!(t->sub_owner)) {
> -			printk(KERN_ERR "Pointer to struct module does not"
> -				" exist for %s\n", t->name);
> -			hba->transport = NULL;
> -			transport_core_put_sub(t);
> -			return -EINVAL;
> -		}
> +	if (t->owner) {
>  		/*
>  		 * Grab a struct module reference count for subsystem plugin
>  		 */
> -		if (!(try_module_get(t->sub_owner))) {
> -			printk(KERN_ERR "try_module_get() failed for"
> -				" t->sub_owner\n");
> +		if (!try_module_get(t->owner)) {
> +			printk(KERN_ERR "try_module_get() failed for %s\n",
> +				t->owner->name);
>  			hba->transport = NULL;
>  			transport_core_put_sub(t);
>  			return -EINVAL;
> @@ -126,8 +120,8 @@ int se_core_add_hba(
>  	ret = t->attach_hba(hba, plugin_dep_id);
>  	if (ret < 0) {
>  		hba->transport = NULL;
> -		if (t->external_submod)
> -			module_put(t->sub_owner);
> +		if (t->owner)
> +			module_put(t->owner);
>  		transport_core_put_sub(t);
>  		return ret;
>  	}
> @@ -157,8 +151,8 @@ static int se_core_shutdown_hba(
>  	/*
>  	 * Release TCM subsystem api struct module reference from struct se_hba
>  	 */
> -	if (t->external_submod)
> -		module_put(t->sub_owner);
> +	if (t->owner)
> +		module_put(t->owner);
>  
>  	return 0;
>  }
> Index: lio-core-2.6/drivers/target/target_core_iblock.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_iblock.c	2010-11-08 15:38:27.891529681 +0100
> +++ lio-core-2.6/drivers/target/target_core_iblock.c	2010-11-08 15:48:47.868196356 +0100
> @@ -921,9 +921,9 @@ static void iblock_bio_done(struct bio *
>  
>  static struct se_subsystem_api iblock_template = {
>  	.name			= "iblock",
> +	.owner			= THIS_MODULE,
>  	.type			= IBLOCK,
>  	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
> -	.external_submod	= 1,
>  	.cdb_none		= iblock_CDB_none,
>  	.cdb_read_non_SG	= iblock_CDB_read_non_SG,
>  	.cdb_read_SG		= iblock_CDB_read_SG,
> @@ -957,23 +957,14 @@ static struct se_subsystem_api iblock_te
>  	.get_device_type	= iblock_get_device_type,
>  	.get_dma_length		= iblock_get_dma_length,
>  	.get_blocks		= iblock_get_blocks,
> -	.write_pending		= NULL,
>  };
>  
> -int __init iblock_module_init(void)
> +static int __init iblock_module_init(void)
>  {
> -	int ret;
> -
> -	INIT_LIST_HEAD(&iblock_template.sub_api_list);
> -
> -	ret = transport_subsystem_register(&iblock_template, THIS_MODULE);
> -	if (ret < 0)
> -		return ret;
> -
> -	return 0;
> +	return transport_subsystem_register(&iblock_template);
>  }
>  
> -void iblock_module_exit(void)
> +static void iblock_module_exit(void)
>  {
>  	transport_subsystem_release(&iblock_template);
>  }
> Index: lio-core-2.6/drivers/target/target_core_pscsi.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_pscsi.c	2010-11-08 15:38:27.901529680 +0100
> +++ lio-core-2.6/drivers/target/target_core_pscsi.c	2010-11-08 15:48:49.844863013 +0100
> @@ -1485,9 +1485,9 @@ static void pscsi_req_done(struct reques
>  
>  static struct se_subsystem_api pscsi_template = {
>  	.name			= "pscsi",
> +	.owner			= THIS_MODULE,
>  	.type			= PSCSI,
>  	.transport_type		= TRANSPORT_PLUGIN_PHBA_PDEV,
> -	.external_submod	= 1,
>  	.cdb_none		= pscsi_CDB_none,
>  	.cdb_read_non_SG	= pscsi_CDB_read_non_SG,
>  	.cdb_read_SG		= pscsi_CDB_read_SG,
> @@ -1516,23 +1516,14 @@ static struct se_subsystem_api pscsi_tem
>  	.get_device_rev		= pscsi_get_device_rev,
>  	.get_device_type	= pscsi_get_device_type,
>  	.get_dma_length		= pscsi_get_dma_length,
> -	.write_pending		= NULL,
>  };
>  
> -int __init pscsi_module_init(void)
> +static int __init pscsi_module_init(void)
>  {
> -	int ret;
> -
> -	INIT_LIST_HEAD(&pscsi_template.sub_api_list);
> -
> -	ret = transport_subsystem_register(&pscsi_template, THIS_MODULE);
> -	if (ret < 0)
> -		return ret;
> -
> -	return 0;
> +	return transport_subsystem_register(&pscsi_template);
>  }
>  
> -void pscsi_module_exit(void)
> +static void pscsi_module_exit(void)
>  {
>  	transport_subsystem_release(&pscsi_template);
>  }
> Index: lio-core-2.6/drivers/target/target_core_rd.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_rd.c	2010-11-08 15:38:27.911529679 +0100
> +++ lio-core-2.6/drivers/target/target_core_rd.c	2010-11-08 15:49:00.321529680 +0100
> @@ -1283,7 +1283,6 @@ static struct se_subsystem_api rd_dr_tem
>  	.name			= "rd_dr",
>  	.type			= RAMDISK_DR,
>  	.transport_type		= TRANSPORT_PLUGIN_VHBA_VDEV,
> -	.external_submod	= 0,
>  	.cdb_none		= rd_CDB_none,
>  	.cdb_read_non_SG	= rd_CDB_read_non_SG,
>  	.cdb_read_SG		= rd_CDB_read_SG,
> @@ -1314,14 +1313,12 @@ static struct se_subsystem_api rd_dr_tem
>  	.get_dma_length		= rd_get_dma_length,
>  	.get_blocks		= rd_get_blocks,
>  	.do_se_mem_map		= rd_DIRECT_do_se_mem_map,
> -	.write_pending		= NULL,
>  };
>  
>  static struct se_subsystem_api rd_mcp_template = {
>  	.name			= "rd_mcp",
>  	.type			= RAMDISK_MCP,
>  	.transport_type		= TRANSPORT_PLUGIN_VHBA_VDEV,
> -	.external_submod	= 0,
>  	.cdb_none		= rd_CDB_none,
>  	.cdb_read_non_SG	= rd_CDB_read_non_SG,
>  	.cdb_read_SG		= rd_CDB_read_SG,
> @@ -1348,21 +1345,17 @@ static struct se_subsystem_api rd_mcp_te
>  	.get_device_rev		= rd_get_device_rev,
>  	.get_device_type	= rd_get_device_type,
>  	.get_dma_length		= rd_get_dma_length,
> -	.write_pending		= NULL,
>  };
>  
>  int __init rd_module_init(void)
>  {
>  	int ret;
>  
> -	INIT_LIST_HEAD(&rd_dr_template.sub_api_list);
> -	INIT_LIST_HEAD(&rd_mcp_template.sub_api_list);
> -
> -	ret = transport_subsystem_register(&rd_dr_template, NULL);
> +	ret = transport_subsystem_register(&rd_dr_template);
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = transport_subsystem_register(&rd_mcp_template, NULL);
> +	ret = transport_subsystem_register(&rd_mcp_template);
>  	if (ret < 0) {
>  		transport_subsystem_release(&rd_dr_template);
>  		return ret;
> Index: lio-core-2.6/drivers/target/target_core_stgt.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_stgt.c	2010-11-08 15:38:27.924863014 +0100
> +++ lio-core-2.6/drivers/target/target_core_stgt.c	2010-11-08 15:49:02.761529680 +0100
> @@ -833,9 +833,9 @@ static int stgt_transfer_response(struct
>  
>  static struct se_subsystem_api stgt_template = {
>  	.name			= "stgt",
> +	.owner			= THIS_MODULE,
>  	.type			= STGT,
>  	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
> -	.external_submod	= 1,
>  	.cdb_none		= stgt_CDB_none,
>  	.cdb_read_non_SG	= stgt_CDB_read_non_SG,
>  	.cdb_read_SG		= stgt_CDB_read_SG,
> @@ -865,23 +865,14 @@ static struct se_subsystem_api stgt_temp
>  	.get_device_rev		= stgt_get_device_rev,
>  	.get_device_type	= stgt_get_device_type,
>  	.get_dma_length		= stgt_get_dma_length,
> -	.write_pending		= NULL,
>  };
>  
> -int __init stgt_module_init(void)
> +static int __init stgt_module_init(void)
>  {
> -	int ret;
> -
> -	INIT_LIST_HEAD(&stgt_template.sub_api_list);
> -
> -	ret = transport_subsystem_register(&stgt_template, THIS_MODULE);
> -	if (ret < 0)
> -		return ret;
> -
> -	return 0;
> +	return transport_subsystem_register(&stgt_template);
>  }
>  
> -void stgt_module_exit(void)
> +static void stgt_module_exit(void)
>  {
>  	transport_subsystem_release(&stgt_template);
>  }
> Index: lio-core-2.6/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-08 15:37:15.928196347 +0100
> +++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-08 15:44:43.708196346 +0100
> @@ -545,18 +545,11 @@ int transport_subsystem_check_init(void)
>  }
>  
>  int transport_subsystem_register(
> -	struct se_subsystem_api *sub_api,
> -	struct module *sub_owner)
> +	struct se_subsystem_api *sub_api)
>  {
>  	struct se_subsystem_api *s;
> -	/*
> -	 * Save struct module * for TFO [attach,detach]_hba() reference
> -	 * in se_core_add_hba()
> -	 */
> -	if (sub_api->external_submod && (sub_owner != NULL))
> -		sub_api->sub_owner = sub_owner;
> -	else
> -		sub_api->sub_owner = NULL;
> +
> +	INIT_LIST_HEAD(&sub_api->sub_api_list);
>  
>  	mutex_lock(&se_global->g_sub_api_mutex);
>  	list_for_each_entry(s, &se_global->g_sub_api_list, sub_api_list) {
> @@ -572,7 +565,7 @@ int transport_subsystem_register(
>  	mutex_unlock(&se_global->g_sub_api_mutex);
>  
>  	printk(KERN_INFO "TCM: Registered subsystem plugin: %s struct module:"
> -			" %p\n", sub_api->name, sub_api->sub_owner);
> +			" %p\n", sub_api->name, sub_api->owner);
>  	return 0;
>  }
>  EXPORT_SYMBOL(transport_subsystem_register);
> Index: lio-core-2.6/include/target/target_core_transport.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-08 15:42:48.694863012 +0100
> +++ lio-core-2.6/include/target/target_core_transport.h	2010-11-08 15:49:30.924863014 +0100
> @@ -138,8 +138,7 @@ extern int __iscsi_debug_dev(struct se_d
>  extern unsigned char *transport_get_iqn_sn(void);
>  extern void transport_init_queue_obj(struct se_queue_obj *);
>  extern int transport_subsystem_check_init(void);
> -extern int transport_subsystem_register(struct se_subsystem_api *,
> -				struct module *);
> +extern int transport_subsystem_register(struct se_subsystem_api *);
>  extern void transport_subsystem_release(struct se_subsystem_api *);
>  extern void transport_load_plugins(void);
>  extern struct se_subsystem_api *transport_core_get_sub_by_name(const char *);
> @@ -323,13 +322,9 @@ struct se_subsystem_api {
>  	 */
>  	u8 transport_type;
>  	/*
> -	 * For target_core_rd.c internal usage
> -	 */
> -	int external_submod;
> -	/*
>  	 * struct module for struct se_hba references
>  	 */
> -	struct module *sub_owner;
> +	struct module *owner;
>  	/*
>  	 * Counter for struct se_hba reference
>  	 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

