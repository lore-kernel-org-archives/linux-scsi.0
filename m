From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] target: remove dead backend methods
Date: Wed, 17 Nov 2010 11:54:21 -0800
Message-ID: <1290023661.31890.8.camel@haakon2.linux-iscsi.org>
References: <20101116175820.GB26311@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44794 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935187Ab0KQT7o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 14:59:44 -0500
In-Reply-To: <20101116175820.GB26311@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-16 at 12:58 -0500, Christoph Hellwig wrote:
> Remove various backend methods that don't have any callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Also looks good and commited as 107bf7a5d.  So the grad total 

The grand total for this cleanup:

 23 files changed, 722 insertions(+), 1766 deletions(-)

Wow, I honestly did not think at this point there was another 1K LOC to
be shaved off in the core + backend pieces..  

Pushed into lio-core-2.6.git/lio-4.0 and master.

Thank you!

--nab

> 
> Index: lio-core/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_transport.c	2010-11-16 18:50:17.704003913 +0100
> +++ lio-core/drivers/target/target_core_transport.c	2010-11-16 18:52:11.887253809 +0100
> @@ -1458,15 +1458,6 @@ static void transport_release_all_cmds(s
>  #endif
>  }
>  
> -/*	transport_dev_write_pending_nop():
> - *
> - *
> - */
> -static int transport_dev_write_pending_nop(struct se_task *task)
> -{
> -	return 0;
> -}
> -
>  static int transport_get_inquiry(
>  	struct t10_wwn *wwn,
>  	void *obj_ptr)
> @@ -2053,9 +2044,6 @@ struct se_device *transport_add_device_t
>  
>  	se_dev_set_default_attribs(dev, dev_limits);
>  
> -	dev->write_pending = (transport->write_pending) ?
> -		transport->write_pending : &transport_dev_write_pending_nop;
> -
>  	dev->dev_index = scsi_get_new_index(SCSI_DEVICE_INDEX);
>  	dev->creation_time = get_jiffies_64();
>  	spin_lock_init(&dev->stats_lock);
> Index: lio-core/include/target/target_core_transport.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_transport.h	2010-11-16 18:50:18.378254088 +0100
> +++ lio-core/include/target/target_core_transport.h	2010-11-16 18:52:11.888252831 +0100
> @@ -338,21 +338,7 @@ struct se_subsystem_api {
>  	 * free_device():
>  	 */
>  	void (*free_device)(void *);
> -	/*
> -	 * cmd_sequencer():
> -	 *
> -	 * Use transport_generic_cmd_sequencer() for majority of DAS transport
> -	 * drivers with a scsi_transport_spc_t struct as mentioned below.
> -	 * Provided out of convenience.
> -	 */
> -	int (*cmd_sequencer)(struct se_cmd *cmd);
> -	/*
> -	 * do_tmr():
> -	 *
> -	 * Use transport_do_tmr() for majority of DAS transport drivers.
> -	 * Provided out of convenience.
> -	 */
> -	int (*do_tmr)(struct se_cmd *cmd);
> +
>  	/*
>  	 * dpo_emulated():
>  	 */
> @@ -410,18 +396,6 @@ struct se_subsystem_api {
>  	ssize_t (*show_configfs_dev_params)(struct se_hba *, struct se_subsystem_dev *,
>  						char *);
>  	/*
> -	 * get_plugin_info():
> -	 */
> -	void (*get_plugin_info)(void *, char *, int *);
> -	/*
> -	 * get_hba_info():
> -	 */
> -	void (*get_hba_info)(struct se_hba *, char *, int *);
> -	/*
> -	 * check_lba():
> -	 */
> -	int (*check_lba)(unsigned long long lba, struct se_device *);
> -	/*
>  	 * get_cdb():
>  	 */
>  	unsigned char *(*get_cdb)(struct se_task *);
> @@ -438,10 +412,6 @@ struct se_subsystem_api {
>  	 */
>  	u32 (*get_dma_length)(u32, struct se_device *);
>  	/*
> -	 * get_max_cdbs():
> -	 */
> -	u32 (*get_max_cdbs)(struct se_device *);
> -	/*
>  	 * Get the sector_t from a subsystem backstore..
>  	 */
>  	sector_t (*get_blocks)(struct se_device *);
> @@ -454,14 +424,6 @@ struct se_subsystem_api {
>  	 * get_sense_buffer():
>  	 */
>  	unsigned char *(*get_sense_buffer)(struct se_task *);
> -	/*
> -	 * map_task_to_SG():
> -	 */
> -	void (*map_task_to_SG)(struct se_task *);
> -	/*
> -	 * write_pending():
> -	 */
> -	int (*write_pending)(struct se_task *);
>  } ____cacheline_aligned;
>  
>  #define TRANSPORT(dev)		((dev)->transport)
> Index: lio-core/include/target/target_core_base.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_base.h	2010-11-16 18:50:17.709004611 +0100
> +++ lio-core/include/target/target_core_base.h	2010-11-16 18:52:11.891253040 +0100
> @@ -855,7 +855,6 @@ struct se_device {
>  	struct task_struct	*process_thread;
>  	pid_t			process_thread_pid;
>  	struct task_struct		*dev_mgmt_thread;
> -	int (*write_pending)(struct se_task *);
>  	struct list_head	delayed_cmd_list;
>  	struct list_head	ordered_cmd_list;
>  	struct list_head	execute_task_list;
> Index: lio-core/drivers/target/target_core_file.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_file.c	2010-11-16 18:50:17.654004332 +0100
> +++ lio-core/drivers/target/target_core_file.c	2010-11-16 18:52:11.895259466 +0100
> @@ -611,20 +611,6 @@ static ssize_t fd_check_configfs_dev_par
>  	return 0;
>  }
>  
> -static void fd_get_plugin_info(void *p, char *b, int *bl)
> -{
> -	*bl += sprintf(b + *bl, "TCM FILEIO Plugin %s\n", FD_VERSION);
> -}
> -
> -static void fd_get_hba_info(struct se_hba *hba, char *b, int *bl)
> -{
> -	struct fd_host *fd_host = (struct fd_host *)hba->hba_ptr;
> -
> -	*bl += sprintf(b + *bl, "SE Host ID: %u  FD Host ID: %u\n",
> -		 hba->hba_id, fd_host->fd_host_id);
> -	*bl += sprintf(b + *bl, "        TCM FILEIO HBA\n");
> -}
> -
>  static ssize_t fd_show_configfs_dev_params(
>  	struct se_hba *hba,
>  	struct se_subsystem_dev *se_dev,
> @@ -641,15 +627,6 @@ static ssize_t fd_show_configfs_dev_para
>  	return bl;
>  }
>  
> -/*	fd_check_lba():
> - *
> - *
> - */
> -static int fd_check_lba(unsigned long long lba, struct se_device *dev)
> -{
> -	return 0;
> -}
> -
>  /*	fd_get_cdb(): (Part of se_subsystem_api_t template)
>   *
>   *
> @@ -719,9 +696,6 @@ static struct se_subsystem_api fileio_te
>  	.check_configfs_dev_params = fd_check_configfs_dev_params,
>  	.set_configfs_dev_params = fd_set_configfs_dev_params,
>  	.show_configfs_dev_params = fd_show_configfs_dev_params,
> -	.get_plugin_info	= fd_get_plugin_info,
> -	.get_hba_info		= fd_get_hba_info,
> -	.check_lba		= fd_check_lba,
>  	.get_cdb		= fd_get_cdb,
>  	.get_device_rev		= fd_get_device_rev,
>  	.get_device_type	= fd_get_device_type,
> Index: lio-core/drivers/target/target_core_iblock.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_iblock.c	2010-11-16 18:50:17.659003494 +0100
> +++ lio-core/drivers/target/target_core_iblock.c	2010-11-16 18:52:11.899259256 +0100
> @@ -544,20 +544,6 @@ static ssize_t iblock_check_configfs_dev
>  	return 0;
>  }
>  
> -static void iblock_get_plugin_info(void *p, char *b, int *bl)
> -{
> -	*bl += sprintf(b + *bl, "TCM iBlock Plugin %s\n", IBLOCK_VERSION);
> -}
> -
> -static void iblock_get_hba_info(struct se_hba *hba, char *b, int *bl)
> -{
> -	struct iblock_hba *ib_host = (struct iblock_hba *)hba->hba_ptr;
> -
> -	*bl += sprintf(b + *bl, "SE Host ID: %u  iBlock Host ID: %u\n",
> -		hba->hba_id, ib_host->iblock_host_id);
> -	*bl += sprintf(b + *bl, "        TCM iBlock HBA\n");
> -}
> -
>  static ssize_t iblock_show_configfs_dev_params(
>  	struct se_hba *hba,
>  	struct se_subsystem_dev *se_dev,
> @@ -721,11 +707,6 @@ fail:
>  	return ret;
>  }
>  
> -static int iblock_check_lba(unsigned long long lba, struct se_device *dev)
> -{
> -	return 0;
> -}
> -
>  static unsigned char *iblock_get_cdb(struct se_task *task)
>  {
>  	return IBLOCK_REQ(task)->ib_scsi_cdb;
> @@ -827,9 +808,6 @@ static struct se_subsystem_api iblock_te
>  	.check_configfs_dev_params = iblock_check_configfs_dev_params,
>  	.set_configfs_dev_params = iblock_set_configfs_dev_params,
>  	.show_configfs_dev_params = iblock_show_configfs_dev_params,
> -	.get_plugin_info	= iblock_get_plugin_info,
> -	.get_hba_info		= iblock_get_hba_info,
> -	.check_lba		= iblock_check_lba,
>  	.get_cdb		= iblock_get_cdb,
>  	.get_device_rev		= iblock_get_device_rev,
>  	.get_device_type	= iblock_get_device_type,
> Index: lio-core/drivers/target/target_core_pscsi.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_pscsi.c	2010-11-16 18:50:17.688004751 +0100
> +++ lio-core/drivers/target/target_core_pscsi.c	2010-11-16 18:52:11.903253879 +0100
> @@ -905,24 +905,6 @@ static ssize_t pscsi_check_configfs_dev_
>  	return 0;
>  }
>  
> -static void pscsi_get_plugin_info(void *p, char *b, int *bl)
> -{
> -	*bl += sprintf(b + *bl, "TCM SCSI Plugin %s\n", PSCSI_VERSION);
> -}
> -
> -static void pscsi_get_hba_info(struct se_hba *hba, char *b, int *bl)
> -{
> -	struct pscsi_hba_virt *phv = hba->hba_ptr;
> -	struct Scsi_Host *sh = phv->phv_lld_host;
> -
> -	*bl += sprintf(b + *bl, "Core Host ID: %u  PHV Host ID: %u\n",
> -		 hba->hba_id, phv->phv_host_id);
> -	if (sh)
> -		*bl += sprintf(b + *bl, "        SCSI HBA ID %u: %s  <local>\n",
> -			sh->host_no, (sh->hostt->name) ?
> -			(sh->hostt->name) : "Unknown");
> -}
> -
>  static ssize_t pscsi_show_configfs_dev_params(
>          struct se_hba *hba,
>          struct se_subsystem_dev *se_dev,
> @@ -1205,15 +1187,6 @@ static int pscsi_CDB_none(struct se_task
>  	return pscsi_blk_get_request(task);
>  }
>  
> -/*	pscsi_check_lba():
> - *
> - *
> - */
> -static int pscsi_check_lba(unsigned long long lba, struct se_device *dev)
> -{
> -	return 0;
> -}
> -
>  /*	pscsi_get_cdb():
>   *
>   *
> @@ -1344,9 +1317,6 @@ static struct se_subsystem_api pscsi_tem
>  	.check_configfs_dev_params = pscsi_check_configfs_dev_params,
>  	.set_configfs_dev_params = pscsi_set_configfs_dev_params,
>  	.show_configfs_dev_params = pscsi_show_configfs_dev_params,
> -	.get_plugin_info	= pscsi_get_plugin_info,
> -	.get_hba_info		= pscsi_get_hba_info,
> -	.check_lba		= pscsi_check_lba,
>  	.get_cdb		= pscsi_get_cdb,
>  	.get_sense_buffer	= pscsi_get_sense_buffer,
>  	.get_device_rev		= pscsi_get_device_rev,
> Index: lio-core/drivers/target/target_core_rd.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_rd.c	2010-11-16 18:50:17.669004611 +0100
> +++ lio-core/drivers/target/target_core_rd.c	2010-11-16 18:52:11.910270920 +0100
> @@ -1003,25 +1003,6 @@ static ssize_t rd_check_configfs_dev_par
>  	return 0;
>  }
>  
> -static void rd_dr_get_plugin_info(void *p, char *b, int *bl)
> -{
> -	*bl += sprintf(b + *bl, "TCM RAMDISK_DR Plugin %s\n", RD_DR_VERSION);
> -}
> -
> -static void rd_mcp_get_plugin_info(void *p, char *b, int *bl)
> -{
> -	*bl += sprintf(b + *bl, "TCM RAMDISK_MCP Plugin %s\n", RD_MCP_VERSION);
> -}
> -
> -static void rd_get_hba_info(struct se_hba *hba, char *b, int *bl)
> -{
> -	struct rd_host *rd_host = (struct rd_host *)hba->hba_ptr;
> -
> -	*bl += sprintf(b + *bl, "SE Host ID: %u  RD Host ID: %u\n",
> -		hba->hba_id, rd_host->rd_host_id);
> -	*bl += sprintf(b + *bl, "        TCM RamDisk HBA\n");
> -}
> -
>  static ssize_t rd_show_configfs_dev_params(
>  	struct se_hba *hba,
>  	struct se_subsystem_dev *se_dev,
> @@ -1037,25 +1018,6 @@ static ssize_t rd_show_configfs_dev_para
>  	return bl;
>  }
>  
> -/*	rd_DIRECT_check_lba():
> - *
> - *
> - */
> -static int rd_DIRECT_check_lba(unsigned long long lba, struct se_device *dev)
> -{
> -	return ((do_div(lba, PAGE_SIZE / DEV_ATTRIB(dev)->block_size)) *
> -		 DEV_ATTRIB(dev)->block_size) ? 1 : 0;
> -}
> -
> -/*	rd_MEMCPY_check_lba():
> - *
> - *
> - */
> -static int rd_MEMCPY_check_lba(unsigned long long lba, struct se_device *dev)
> -{
> -	return 0;
> -}
> -
>  /*	rd_get_cdb(): (Part of se_subsystem_api_t template)
>   *
>   *
> @@ -1111,9 +1073,6 @@ static struct se_subsystem_api rd_dr_tem
>  	.check_configfs_dev_params = rd_check_configfs_dev_params,
>  	.set_configfs_dev_params = rd_set_configfs_dev_params,
>  	.show_configfs_dev_params = rd_show_configfs_dev_params,
> -	.get_plugin_info	= rd_dr_get_plugin_info,
> -	.get_hba_info		= rd_get_hba_info,
> -	.check_lba		= rd_DIRECT_check_lba,
>  	.get_cdb		= rd_get_cdb,
>  	.get_device_rev		= rd_get_device_rev,
>  	.get_device_type	= rd_get_device_type,
> @@ -1138,9 +1097,6 @@ static struct se_subsystem_api rd_mcp_te
>  	.check_configfs_dev_params = rd_check_configfs_dev_params,
>  	.set_configfs_dev_params = rd_set_configfs_dev_params,
>  	.show_configfs_dev_params = rd_show_configfs_dev_params,
> -	.get_plugin_info	= rd_mcp_get_plugin_info,
> -	.get_hba_info		= rd_get_hba_info,
> -	.check_lba		= rd_MEMCPY_check_lba,
>  	.get_cdb		= rd_get_cdb,
>  	.get_device_rev		= rd_get_device_rev,
>  	.get_device_type	= rd_get_device_type,
> Index: lio-core/drivers/target/target_core_stgt.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_stgt.c	2010-11-16 18:50:18.374254018 +0100
> +++ lio-core/drivers/target/target_core_stgt.c	2010-11-16 18:52:11.915272806 +0100
> @@ -459,22 +459,6 @@ static ssize_t stgt_check_configfs_dev_p
>  	return 0;
>  }
>  
> -static void stgt_get_plugin_info(void *p, char *b, int *bl)
> -{
> -	*bl += sprintf(b + *bl, "TCM STGT <-> Target_Core_Mod Plugin %s\n",
> -		STGT_VERSION);
> -}
> -
> -static void stgt_get_hba_info(struct se_hba *hba, char *b, int *bl)
> -{
> -	struct Scsi_Host *sh = hba->hba_ptr;
> -
> -	*bl += sprintf(b + *bl, "Core Host ID: %u  SCSI Host ID: %u\n",
> -			 hba->hba_id, sh->host_no);
> -	*bl += sprintf(b + *bl, "        SCSI HBA: %s  <local>\n",
> -		(sh->hostt->name) ? (sh->hostt->name) : "Unknown");
> -}
> -
>  static ssize_t stgt_show_configfs_dev_params(
>  	struct se_hba *hba,
>  	struct se_subsystem_dev *se_dev,
> @@ -490,15 +474,6 @@ static ssize_t stgt_show_configfs_dev_pa
>  	return bl;
>  }
>  
> -/*	stgt_check_lba():
> - *
> - *
> - */
> -static int stgt_check_lba(unsigned long long lba, struct se_device *dev)
> -{
> -	return 0;
> -}
> -
>  /*	stgt_get_cdb():
>   *
>   *
> @@ -637,9 +612,6 @@ static struct se_subsystem_api stgt_temp
>  	.check_configfs_dev_params = stgt_check_configfs_dev_params,
>  	.set_configfs_dev_params = stgt_set_configfs_dev_params,
>  	.show_configfs_dev_params = stgt_show_configfs_dev_params,
> -	.get_plugin_info	= stgt_get_plugin_info,
> -	.get_hba_info		= stgt_get_hba_info,
> -	.check_lba		= stgt_check_lba,
>  	.get_cdb		= stgt_get_cdb,
>  	.get_sense_buffer	= stgt_get_sense_buffer,
>  	.get_device_rev		= stgt_get_device_rev,

