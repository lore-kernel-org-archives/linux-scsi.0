From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] target: mark as much as possible static
Date: Wed, 17 Nov 2010 14:47:51 -0800
Message-ID: <1290034071.31890.77.camel@haakon2.linux-iscsi.org>
References: <20101117213910.GC26557@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53503 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935627Ab0KQWxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:53:15 -0500
In-Reply-To: <20101117213910.GC26557@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-11-17 at 16:39 -0500, Christoph Hellwig wrote:
> Mark all functions that scripts/namespace.pl noticed static, and
> perform a simple garbage collection as second pass.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Committed as c869585a04 and pushed to lio-core-2.6.git.

Thanks!

--nab

> Index: lio-core/drivers/target/target_core_alua.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_alua.c	2010-11-17 11:01:16.124015508 +0100
> +++ lio-core/drivers/target/target_core_alua.c	2010-11-17 22:25:25.592004262 +0100
> @@ -41,6 +41,11 @@
>  #include "target_core_hba.h"
>  #include "target_core_ua.h"
>  
> +static int core_alua_check_transition(int state, int *primary);
> +static int core_alua_set_tg_pt_secondary_state(
> +		struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
> +		struct se_port *port, int explict, int offline);
> +
>  /*
>   * REPORT_TARGET_PORT_GROUPS
>   *
> @@ -434,7 +439,7 @@ static inline int core_alua_state_transi
>   * in transport_cmd_sequencer().  This function is assigned to
>   * struct t10_alua *->state_check() in core_setup_alua()
>   */
> -int core_alua_state_check_nop(
> +static int core_alua_state_check_nop(
>  	struct se_cmd *cmd,
>  	unsigned char *cdb,
>  	u8 *alua_ascq)
> @@ -454,7 +459,7 @@ int core_alua_state_check_nop(
>   * return 0: Used to signal success
>   * reutrn -1: Used to signal failure, and TGCS_INVALID_CDB_FIELD
>   */
> -int core_alua_state_check(
> +static int core_alua_state_check(
>  	struct se_cmd *cmd,
>  	unsigned char *cdb,
>  	u8 *alua_ascq)
> @@ -526,7 +531,7 @@ int core_alua_state_check(
>  /*
>   * Check implict and explict ALUA state change request.
>   */
> -int core_alua_check_transition(int state, int *primary)
> +static int core_alua_check_transition(int state, int *primary)
>  {
>  	switch (state) {
>  	case ALUA_ACCESS_STATE_ACTIVE_OPTMIZED:
> @@ -554,7 +559,7 @@ int core_alua_check_transition(int state
>  	return 0;
>  }
>  
> -char *core_alua_dump_state(int state)
> +static char *core_alua_dump_state(int state)
>  {
>  	switch (state) {
>  	case ALUA_ACCESS_STATE_ACTIVE_OPTMIZED:
> @@ -620,7 +625,7 @@ EXPORT_SYMBOL(core_alua_check_nonop_dela
>   * Called with tg_pt_gp->tg_pt_gp_md_mutex or tg_pt_gp_mem->sep_tg_pt_md_mutex
>   *
>   */
> -int core_alua_write_tpg_metadata(
> +static int core_alua_write_tpg_metadata(
>  	const char *path,
>  	unsigned char *md_buf,
>  	u32 md_buf_len)
> @@ -660,7 +665,7 @@ int core_alua_write_tpg_metadata(
>  /*
>   * Called with tg_pt_gp->tg_pt_gp_md_mutex held
>   */
> -int core_alua_update_tpg_primary_metadata(
> +static int core_alua_update_tpg_primary_metadata(
>  	struct t10_alua_tg_pt_gp *tg_pt_gp,
>  	int primary_state,
>  	unsigned char *md_buf)
> @@ -686,7 +691,7 @@ int core_alua_update_tpg_primary_metadat
>  	return core_alua_write_tpg_metadata(path, md_buf, len);
>  }
>  
> -int core_alua_do_transition_tg_pt(
> +static int core_alua_do_transition_tg_pt(
>  	struct t10_alua_tg_pt_gp *tg_pt_gp,
>  	struct se_port *l_port,
>  	struct se_node_acl *nacl,
> @@ -923,7 +928,7 @@ int core_alua_do_port_transition(
>  /*
>   * Called with tg_pt_gp_mem->sep_tg_pt_md_mutex held
>   */
> -int core_alua_update_tpg_secondary_metadata(
> +static int core_alua_update_tpg_secondary_metadata(
>  	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
>  	struct se_port *port,
>  	unsigned char *md_buf,
> @@ -955,7 +960,7 @@ int core_alua_update_tpg_secondary_metad
>  	return core_alua_write_tpg_metadata(path, md_buf, len);
>  }
>  
> -int core_alua_set_tg_pt_secondary_state(
> +static int core_alua_set_tg_pt_secondary_state(
>  	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
>  	struct se_port *port,
>  	int explict,
> @@ -1023,7 +1028,8 @@ int core_alua_set_tg_pt_secondary_state(
>  	return 0;
>  }
>  
> -struct t10_alua_lu_gp *core_alua_allocate_lu_gp(const char *name, int def_group)
> +struct t10_alua_lu_gp *
> +core_alua_allocate_lu_gp(const char *name, int def_group)
>  {
>  	struct t10_alua_lu_gp *lu_gp;
>  
> @@ -1093,8 +1099,8 @@ again:
>  	return 0;
>  }
>  
> -struct t10_alua_lu_gp_member *core_alua_allocate_lu_gp_mem(
> -	struct se_device *dev)
> +static struct t10_alua_lu_gp_member *
> +core_alua_allocate_lu_gp_mem(struct se_device *dev)
>  {
>  	struct t10_alua_lu_gp_member *lu_gp_mem;
>  
> @@ -1480,7 +1486,7 @@ void core_alua_free_tg_pt_gp_mem(struct
>  	kmem_cache_free(t10_alua_tg_pt_gp_mem_cache, tg_pt_gp_mem);
>  }
>  
> -struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
> +static struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
>  	struct se_subsystem_dev *su_dev,
>  	const char *name)
>  {
> @@ -1504,7 +1510,7 @@ struct t10_alua_tg_pt_gp *core_alua_get_
>  	return NULL;
>  }
>  
> -void core_alua_put_tg_pt_gp_from_name(
> +static void core_alua_put_tg_pt_gp_from_name(
>  	struct t10_alua_tg_pt_gp *tg_pt_gp)
>  {
>  	struct se_subsystem_dev *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
> @@ -1533,7 +1539,7 @@ void __core_alua_attach_tg_pt_gp_mem(
>  /*
>   * Called with struct t10_alua_tg_pt_gp_member->tg_pt_gp_mem_lock held
>   */
> -void __core_alua_drop_tg_pt_gp_mem(
> +static void __core_alua_drop_tg_pt_gp_mem(
>  	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
>  	struct t10_alua_tg_pt_gp *tg_pt_gp)
>  {
> Index: lio-core/drivers/target/target_core_alua.h
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_alua.h	2010-11-17 11:01:16.142255206 +0100
> +++ lio-core/drivers/target/target_core_alua.h	2010-11-17 22:25:25.592004262 +0100
> @@ -70,22 +70,13 @@ extern struct kmem_cache *t10_alua_tg_pt
>  
>  extern int core_emulate_report_target_port_groups(struct se_cmd *);
>  extern int core_emulate_set_target_port_groups(struct se_cmd *);
> -extern int core_alua_check_transition(int, int *);
>  extern int core_alua_check_nonop_delay(struct se_cmd *);
> -extern int core_alua_do_transition_tg_pt(struct t10_alua_tg_pt_gp *,
> -				struct se_port *, struct se_node_acl *,
> -				unsigned char *, int, int);
>  extern int core_alua_do_port_transition(struct t10_alua_tg_pt_gp *,
>  				struct se_device *, struct se_port *,
>  				struct se_node_acl *, int, int);
> -extern int core_alua_set_tg_pt_secondary_state(
> -		struct t10_alua_tg_pt_gp_member *, struct se_port *, int, int);
> -extern char *core_alua_dump_state(int);
>  extern char *core_alua_dump_status(int);
>  extern struct t10_alua_lu_gp *core_alua_allocate_lu_gp(const char *, int);
>  extern int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *, u16);
> -extern struct t10_alua_lu_gp_member *core_alua_allocate_lu_gp_mem(
> -					struct se_device *);
>  extern void core_alua_free_lu_gp(struct t10_alua_lu_gp *);
>  extern void core_alua_free_lu_gp_mem(struct se_device *);
>  extern struct t10_alua_lu_gp *core_alua_get_lu_gp_by_name(const char *);
> @@ -102,13 +93,8 @@ extern struct t10_alua_tg_pt_gp_member *
>  					struct se_port *);
>  extern void core_alua_free_tg_pt_gp(struct t10_alua_tg_pt_gp *);
>  extern void core_alua_free_tg_pt_gp_mem(struct se_port *);
> -extern struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
> -				struct se_subsystem_dev *, const char *);
> -extern void core_alua_put_tg_pt_gp_from_name(struct t10_alua_tg_pt_gp *);
>  extern void __core_alua_attach_tg_pt_gp_mem(struct t10_alua_tg_pt_gp_member *,
>  					struct t10_alua_tg_pt_gp *);
> -extern void __core_alua_drop_tg_pt_gp_mem(struct t10_alua_tg_pt_gp_member *,
> -					struct t10_alua_tg_pt_gp *);
>  extern ssize_t core_alua_show_tg_pt_gp_info(struct se_port *, char *);
>  extern ssize_t core_alua_store_tg_pt_gp_info(struct se_port *, const char *,
>  						size_t);
> Index: lio-core/drivers/target/target_core_file.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_file.c	2010-11-17 22:24:18.000000000 +0100
> +++ lio-core/drivers/target/target_core_file.c	2010-11-17 22:25:25.597003564 +0100
> @@ -432,12 +432,12 @@ static void fd_emulate_sync_cache(struct
>   * Tell TCM Core that we are capable of WriteCache emulation for
>   * an underlying struct se_device.
>   */
> -int fd_emulated_write_cache(struct se_device *dev)
> +static int fd_emulated_write_cache(struct se_device *dev)
>  {
>  	return 1;
>  }
>  
> -int fd_emulated_dpo(struct se_device *dev)
> +static int fd_emulated_dpo(struct se_device *dev)
>  {
>  	return 0;
>  }
> @@ -445,12 +445,12 @@ int fd_emulated_dpo(struct se_device *de
>   * Tell TCM Core that we will be emulating Forced Unit Access (FUA) for WRITEs
>   * for TYPE_DISK.
>   */
> -int fd_emulated_fua_write(struct se_device *dev)
> +static int fd_emulated_fua_write(struct se_device *dev)
>  {
>  	return 1;
>  }
>  
> -int fd_emulated_fua_read(struct se_device *dev)
> +static int fd_emulated_fua_read(struct se_device *dev)
>  {
>  	return 0;
>  }
> Index: lio-core/drivers/target/target_core_iblock.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_iblock.c	2010-11-17 22:24:18.000000000 +0100
> +++ lio-core/drivers/target/target_core_iblock.c	2010-11-17 22:25:25.602004122 +0100
> @@ -379,12 +379,12 @@ static void iblock_emulate_sync_cache(st
>   * Tell TCM Core that we are capable of WriteCache emulation for
>   * an underlying struct se_device.
>   */
> -int iblock_emulated_write_cache(struct se_device *dev)
> +static int iblock_emulated_write_cache(struct se_device *dev)
>  {
>  	return 1;
>  }
>  
> -int iblock_emulated_dpo(struct se_device *dev)
> +static int iblock_emulated_dpo(struct se_device *dev)
>  {
>  	return 0;
>  }
> @@ -393,12 +393,12 @@ int iblock_emulated_dpo(struct se_device
>   * Tell TCM Core that we will be emulating Forced Unit Access (FUA) for WRITEs
>   * for TYPE_DISK.
>   */
> -int iblock_emulated_fua_write(struct se_device *dev)
> +static int iblock_emulated_fua_write(struct se_device *dev)
>  {
>  	return 1;
>  }
>  
> -int iblock_emulated_fua_read(struct se_device *dev)
> +static int iblock_emulated_fua_read(struct se_device *dev)
>  {
>  	return 0;
>  }
> Index: lio-core/drivers/target/target_core_mib.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_mib.c	2010-11-17 11:01:16.189267149 +0100
> +++ lio-core/drivers/target/target_core_mib.c	2010-11-17 22:25:25.606004052 +0100
> @@ -48,7 +48,7 @@
>  #include "target_core_mib.h"
>  
>  /* SCSI mib table index */
> -struct scsi_index_table scsi_index_table;
> +static struct scsi_index_table scsi_index_table;
>  
>  #ifndef INITIAL_JIFFIES
>  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> Index: lio-core/drivers/target/target_core_pr.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_pr.c	2010-11-17 11:01:16.207265403 +0100
> +++ lio-core/drivers/target/target_core_pr.c	2010-11-17 22:25:25.612004332 +0100
> @@ -72,7 +72,7 @@ int core_pr_dump_initiator_port(
>  static void __core_scsi3_complete_pro_release(struct se_device *, struct se_node_acl *,
>  			struct t10_pr_registration *, int);
>  
> -int core_scsi2_reservation_seq_non_holder(
> +static int core_scsi2_reservation_seq_non_holder(
>  	struct se_cmd *cmd,
>  	unsigned char *cdb,
>  	u32 pr_reg_type)
> Index: lio-core/drivers/target/target_core_tmr.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_tmr.c	2010-11-17 11:01:16.223256114 +0100
> +++ lio-core/drivers/target/target_core_tmr.c	2010-11-17 22:25:25.620004052 +0100
> @@ -69,23 +69,14 @@ struct se_tmr_req *core_tmr_alloc_req(
>  }
>  EXPORT_SYMBOL(core_tmr_alloc_req);
>  
> -/*
> - * Called with struct se_device->se_tmr_lock held.
> - */
> -void __core_tmr_release_req(
> -	struct se_tmr_req *tmr)
> -{
> -	list_del(&tmr->tmr_list);
> -	kmem_cache_free(se_tmr_req_cache, tmr);
> -}
> -
>  void core_tmr_release_req(
>  	struct se_tmr_req *tmr)
>  {
>  	struct se_device *dev = tmr->tmr_dev;
>  
>  	spin_lock(&dev->se_tmr_lock);
> -	__core_tmr_release_req(tmr);
> +	list_del(&tmr->tmr_list);
> +	kmem_cache_free(se_tmr_req_cache, tmr);
>  	spin_unlock(&dev->se_tmr_lock);
>  }
>  
> Index: lio-core/drivers/target/target_core_configfs.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_configfs.c	2010-11-17 11:01:16.239255695 +0100
> +++ lio-core/drivers/target/target_core_configfs.c	2010-11-17 22:25:25.626003564 +0100
> @@ -52,8 +52,8 @@
>  #include "target_core_pr.h"
>  #include "target_core_rd.h"
>  
> -struct list_head g_tf_list;
> -struct mutex g_tf_lock;
> +static struct list_head g_tf_list;
> +static struct mutex g_tf_lock;
>  
>  struct target_core_configfs_attribute {
>  	struct configfs_attribute attr;
> @@ -61,7 +61,7 @@ struct target_core_configfs_attribute {
>  	ssize_t (*store)(void *, const char *, size_t);
>  };
>  
> -struct se_hba *target_core_get_hba_from_item(
> +static struct se_hba *target_core_get_hba_from_item(
>  	struct config_item *item)
>  {
>  	struct se_hba *hba = container_of(to_config_group(item),
> @@ -368,25 +368,6 @@ void target_fabric_configfs_free(
>  EXPORT_SYMBOL(target_fabric_configfs_free);
>  
>  /*
> - * Note that config_group_find_item() calls config_item_get() and grabs the
> - * reference to the returned struct config_item *
> - * It will be released with config_put_item() in
> - * target_fabric_configfs_deregister()
> - */
> -struct config_item *target_fabric_configfs_find_by_name(
> -	struct configfs_subsystem *target_su,
> -	const char *name)
> -{
> -	struct config_item *fabric;
> -
> -	mutex_lock(&target_su->su_mutex);
> -	fabric = config_group_find_item(&target_su->su_group, name);
> -	mutex_unlock(&target_su->su_mutex);
> -
> -	return fabric;
> -}
> -
> -/*
>   * Perform a sanity check of the passed tf->tf_ops before completing
>   * TCM fabric module registration.
>   */
> @@ -3228,7 +3209,7 @@ static struct config_item_type target_co
>  
>  /* Stop functions for struct config_item_type target_core_hba_cit */
>  
> -int target_core_init_configfs(void)
> +static int target_core_init_configfs(void)
>  {
>  	struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
>  	struct config_group *lu_gp_cg = NULL;
> @@ -3372,7 +3353,7 @@ out_global:
>  	return -1;
>  }
>  
> -void target_core_exit_configfs(void)
> +static void target_core_exit_configfs(void)
>  {
>  	struct configfs_subsystem *subsys;
>  	struct config_group *hba_cg, *alua_cg, *lu_gp_cg;
> Index: lio-core/drivers/target/target_core_device.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_device.c	2010-11-17 11:01:16.255255625 +0100
> +++ lio-core/drivers/target/target_core_device.c	2010-11-17 22:25:25.631003633 +0100
> @@ -51,8 +51,12 @@
>  #include "target_core_pr.h"
>  #include "target_core_ua.h"
>  
> -extern int __transport_get_lun_for_cmd(
> +static void se_dev_start(struct se_device *dev);
> +static void se_dev_stop(struct se_device *dev);
> +
> +int transport_get_lun_for_cmd(
>  	struct se_cmd *se_cmd,
> +	unsigned char *cdb,
>  	u32 unpacked_lun)
>  {
>  	struct se_dev_entry *deve;
> @@ -171,8 +175,9 @@ out:
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL(transport_get_lun_for_cmd);
>  
> -extern int transport_get_lun_for_tmr(
> +int transport_get_lun_for_tmr(
>  	struct se_cmd *se_cmd,
>  	u32 unpacked_lun)
>  {
> @@ -484,7 +489,7 @@ void core_clear_lun_from_tpg(struct se_l
>  	return;
>  }
>  
> -struct se_port *core_alloc_port(struct se_device *dev)
> +static struct se_port *core_alloc_port(struct se_device *dev)
>  {
>  	struct se_port *port, *port_tmp;
>  
> @@ -536,7 +541,7 @@ again:
>  	return port;
>  }
>  
> -void core_export_port(
> +static void core_export_port(
>  	struct se_device *dev,
>  	struct se_portal_group *tpg,
>  	struct se_port *port,
> @@ -578,7 +583,7 @@ void core_export_port(
>  /*
>   *	Called with struct se_device->se_port_lock spinlock held.
>   */
> -void core_release_port(struct se_device *dev, struct se_port *port)
> +static void core_release_port(struct se_device *dev, struct se_port *port)
>  {
>  	/*
>  	 * Wait for any port reference for PR ALL_TG_PT=1 operation
> @@ -769,15 +774,6 @@ void se_release_vpd_for_dev(struct se_de
>  	return;
>  }
>  
> -int transport_get_lun_for_cmd(
> -	struct se_cmd *se_cmd,
> -	unsigned char *cdb,
> -	u32 unpacked_lun)
> -{
> -	return __transport_get_lun_for_cmd(se_cmd, unpacked_lun);
> -}
> -EXPORT_SYMBOL(transport_get_lun_for_cmd);
> -
>  /*
>   * Called with struct se_hba->device_lock held.
>   */
> @@ -828,7 +824,7 @@ int se_free_virtual_device(struct se_dev
>  	return 0;
>  }
>  
> -void se_dev_start(struct se_device *dev)
> +static void se_dev_start(struct se_device *dev)
>  {
>  	struct se_hba *hba = dev->se_hba;
>  
> @@ -848,7 +844,7 @@ void se_dev_start(struct se_device *dev)
>  	spin_unlock(&hba->device_lock);
>  }
>  
> -void se_dev_stop(struct se_device *dev)
> +static void se_dev_stop(struct se_device *dev)
>  {
>  	struct se_hba *hba = dev->se_hba;
>  
> Index: lio-core/include/target/target_core_configfs.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_configfs.h	2010-11-17 11:01:16.311006149 +0100
> +++ lio-core/include/target/target_core_configfs.h	2010-11-17 22:25:25.634003145 +0100
> @@ -7,14 +7,11 @@
>  
>  extern struct se_global *se_global;
>  
> -extern struct se_hba *target_core_get_hba_from_item(struct config_item *);
>  extern struct target_fabric_configfs *target_fabric_configfs_init(
>  				struct module *, const char *);
>  extern void target_fabric_configfs_free(struct target_fabric_configfs *);
>  extern int target_fabric_configfs_register(struct target_fabric_configfs *);
>  extern void target_fabric_configfs_deregister(struct target_fabric_configfs *);
> -extern int target_core_init_configfs(void);
> -extern void target_core_exit_configfs(void);
>  
>  struct target_fabric_configfs_template {
>  	struct config_item_type tfc_discovery_cit;
> Index: lio-core/include/target/target_core_device.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_device.h	2010-11-17 11:01:16.330256882 +0100
> +++ lio-core/include/target/target_core_device.h	2010-11-17 22:25:25.638004052 +0100
> @@ -15,10 +15,6 @@ extern int core_update_device_list_for_n
>  					u32, struct se_node_acl *,
>  					struct se_portal_group *, int);
>  extern void core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
> -extern struct se_port *core_alloc_port(struct se_device *);
> -extern void core_export_port(struct se_device *, struct se_portal_group *,
> -					struct se_port *, struct se_lun *);
> -extern void core_release_port(struct se_device *, struct se_port *);
>  extern int core_dev_export(struct se_device *, struct se_portal_group *,
>  					struct se_lun *);
>  extern void core_dev_unexport(struct se_device *, struct se_portal_group *,
> @@ -28,8 +24,6 @@ extern void se_release_device_for_hba(st
>  extern void se_release_vpd_for_dev(struct se_device *);
>  extern void se_clear_dev_ports(struct se_device *);
>  extern int se_free_virtual_device(struct se_device *, struct se_hba *);
> -extern void se_dev_start(struct se_device *);
> -extern void se_dev_stop(struct se_device *);
>  extern int se_dev_check_online(struct se_device *);
>  extern int se_dev_check_shutdown(struct se_device *);
>  extern void se_dev_set_default_attribs(struct se_device *, struct se_dev_limits *);
> Index: lio-core/drivers/target/target_core_tpg.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_tpg.c	2010-11-17 11:01:16.275005591 +0100
> +++ lio-core/drivers/target/target_core_tpg.c	2010-11-17 22:25:25.643003145 +0100
> @@ -771,7 +771,7 @@ int core_tpg_post_addlun(
>  	return 0;
>  }
>  
> -void core_tpg_shutdown_lun(
> +static void core_tpg_shutdown_lun(
>  	struct se_portal_group *tpg,
>  	struct se_lun *lun)
>  {
> Index: lio-core/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_transport.c	2010-11-17 22:25:24.576003983 +0100
> +++ lio-core/drivers/target/target_core_transport.c	2010-11-17 22:25:25.646003145 +0100
> @@ -188,9 +188,9 @@
>  struct se_global *se_global;
>  EXPORT_SYMBOL(se_global);
>  
> -struct kmem_cache *se_cmd_cache;
> +static struct kmem_cache *se_cmd_cache;
> +static struct kmem_cache *se_sess_cache;
>  struct kmem_cache *se_tmr_req_cache;
> -struct kmem_cache *se_sess_cache;
>  struct kmem_cache *se_hba_cache;
>  struct kmem_cache *se_ua_cache;
>  struct kmem_cache *se_mem_cache;
> @@ -207,6 +207,32 @@ static int transport_generic_write_pendi
>  static int transport_processing_thread(void *);
>  static int transport_new_cmd_obj(struct se_cmd *cmd,
>  		struct se_transform_info *ti, int post_execute);
> +static int __transport_execute_tasks(struct se_device *dev);
> +static void transport_complete_task_attr(struct se_cmd *cmd);
> +static void transport_direct_request_timeout(struct se_cmd *cmd);
> +static void transport_free_dev_tasks(struct se_cmd *cmd);
> +static u32 transport_generic_get_cdb_count(
> +		struct se_cmd *cmd, struct se_transform_info *ti,
> +		unsigned long long starting_lba, u32 sectors,
> +		enum dma_data_direction data_direction,
> +		struct list_head *mem_list);
> +static int transport_generic_get_mem(struct se_cmd *cmd, u32 length,
> +		u32 dma_size);
> +static int transport_generic_remove(struct se_cmd *cmd,
> +		int release_to_pool, int session_reinstatement);
> +static int transport_get_sectors(struct se_cmd *cmd);
> +static struct list_head *transport_init_se_mem_list(void);
> +static int transport_map_sg_to_mem(struct se_cmd *cmd,
> +		struct list_head *se_mem_list, void *in_mem,
> +		u32 *se_mem_cnt);
> +static void transport_memcpy_se_mem_read_contig(struct se_cmd *cmd,
> +		unsigned char *dst, struct list_head *se_mem_list);
> +static void transport_new_cmd_failure(struct se_cmd *se_cmd);
> +static void transport_release_fe_cmd(struct se_cmd *cmd);
> +static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
> +		struct se_queue_obj *qobj);
> +static int transport_set_sense_codes(struct se_cmd *cmd, u8 asc, u8 ascq);
> +static void transport_stop_all_task_timers(struct se_cmd *cmd);
>  
>  int transport_emulate_control_cdb(struct se_task *task);
>  
> @@ -242,7 +268,7 @@ static u16 transport_passthrough_get_fab
>  	return 0;
>  }
>  
> -struct target_core_fabric_ops passthrough_fabric_ops = {
> +static struct target_core_fabric_ops passthrough_fabric_ops = {
>  	.release_cmd_direct	= transport_passthrough_release_cmd_direct,
>  	.get_fabric_name	= transport_passthrough_get_fabric_name,
>  	.get_task_tag		= transport_passthrough_get_task_tag,
> @@ -717,57 +743,10 @@ static void transport_all_task_dev_remov
>  	}
>  }
>  
> -/*
> - * Called with T_TASK(cmd)->t_state_lock held.
> - */
> -void transport_task_dev_remove_state(struct se_task *task, struct se_device *dev)
> -{
> -	struct se_cmd *cmd = task->task_se_cmd;
> -	unsigned long flags;
> -
> -	/*
> -	 * We cannot remove the task from the state list while said task is
> -	 * still active and probably timed out.
> -	 */
> -	if (atomic_read(&task->task_active)) {
> -#if 0
> -		printk(KERN_ERR "Skipping Removal of state for ITT: 0x%08x"
> -			" dev: %p task[%p]\n"
> -			CMD_TFO(task->task_se_cmd)->tfo_get_task_tag(
> -			task->task_se_cmd), dev, task);
> -#endif
> -		return;
> -	}
> -
> -	if (atomic_read(&task->task_state_active)) {
> -		spin_lock_irqsave(&dev->execute_task_lock, flags);
> -		list_del(&task->t_state_list);
> -		DEBUG_TSTATE("Removed ITT: 0x%08x dev: %p task[%p]\n",
> -			CMD_TFO(task->task_se_cmd)->tfo_get_task_tag(
> -			task->task_se_cmd), dev, task);
> -		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
> -
> -		atomic_set(&task->task_state_active, 0);
> -		atomic_dec(&T_TASK(cmd)->t_task_cdbs_ex_left);
> -	}
> -}
> -
>  static void transport_passthrough_check_stop(struct se_cmd *cmd)
>  {
> -	if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
> -		return;
> -
> -	if (!cmd->transport_passthrough_done) {
> -		if (cmd->callback) {
> -			cmd->callback(cmd, cmd->callback_arg,
> -				transport_passthrough_complete(cmd));
> -		} else
> -			complete(&T_TASK(cmd)->t_transport_passthrough_comp);
> -
> -		return;
> -	}
> -
> -	cmd->transport_passthrough_done(cmd);
> +	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
> +		complete(&T_TASK(cmd)->t_transport_passthrough_comp);
>  }
>  
>  /*	transport_cmd_check_stop():
> @@ -927,7 +906,7 @@ void transport_cmd_finish_abort_tmr(stru
>  	transport_generic_remove(cmd, 0, 0);
>  }
>  
> -int transport_add_cmd_to_queue(
> +static int transport_add_cmd_to_queue(
>  	struct se_cmd *cmd,
>  	int t_state)
>  {
> @@ -967,7 +946,8 @@ int transport_add_cmd_to_queue(
>  /*
>   * Called with struct se_queue_obj->cmd_queue_lock held.
>   */
> -struct se_queue_req *__transport_get_qr_from_queue(struct se_queue_obj *qobj)
> +static struct se_queue_req *
> +__transport_get_qr_from_queue(struct se_queue_obj *qobj)
>  {
>  	struct se_cmd *cmd;
>  	struct se_queue_req *qr = NULL;
> @@ -988,7 +968,8 @@ struct se_queue_req *__transport_get_qr_
>  	return qr;
>  }
>  
> -struct se_queue_req *transport_get_qr_from_queue(struct se_queue_obj *qobj)
> +static struct se_queue_req *
> +transport_get_qr_from_queue(struct se_queue_obj *qobj)
>  {
>  	struct se_cmd *cmd;
>  	struct se_queue_req *qr;
> @@ -1014,7 +995,8 @@ struct se_queue_req *transport_get_qr_fr
>  	return qr;
>  }
>  
> -void transport_remove_cmd_from_queue(struct se_cmd *cmd, struct se_queue_obj *qobj)
> +static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
> +		struct se_queue_obj *qobj)
>  {
>  	struct se_cmd *q_cmd;
>  	struct se_queue_req *qr = NULL, *qr_p = NULL;
> @@ -1045,24 +1027,6 @@ void transport_remove_cmd_from_queue(str
>  	}
>  }
>  
> -void transport_complete_cmd(struct se_cmd *cmd, int success)
> -{
> -	int t_state;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
> -	if (!success) {
> -		cmd->transport_error_status = PYX_TRANSPORT_LU_COMM_FAILURE;
> -		t_state = TRANSPORT_COMPLETE_FAILURE;
> -	} else {
> -		t_state = TRANSPORT_COMPLETE_OK;
> -	}
> -	atomic_set(&T_TASK(cmd)->t_transport_complete, 1);
> -	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
> -
> -	transport_add_cmd_to_queue(cmd, t_state);
> -}
> -
>  /*
>   * Completion function used by TCM subsystem plugins (such as FILEIO)
>   * for queueing up response from struct se_subsystem_api->do_task()
> @@ -1302,11 +1266,7 @@ static void transport_add_tasks_to_state
>  	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
>  }
>  
> -/*	transport_add_tasks_from_cmd():
> - *
> - *
> - */
> -void transport_add_tasks_from_cmd(struct se_cmd *cmd)
> +static void transport_add_tasks_from_cmd(struct se_cmd *cmd)
>  {
>  	struct se_device *dev = SE_DEV(cmd);
>  	struct se_task *task, *task_prev = NULL;
> @@ -1620,7 +1580,8 @@ void transport_dump_vpd_proto_id(
>  		printk(KERN_INFO "%s", buf);
>  }
>  
> -void transport_set_vpd_proto_id(struct t10_vpd *vpd, unsigned char *page_83)
> +static void
> +transport_set_vpd_proto_id(struct t10_vpd *vpd, unsigned char *page_83)
>  {
>  	/*
>  	 * Check if the Protocol Identifier Valid (PIV) bit is set..
> @@ -1725,7 +1686,8 @@ int transport_dump_vpd_ident_type(
>  	return ret;
>  }
>  
> -int transport_set_vpd_ident_type(struct t10_vpd *vpd, unsigned char *page_83)
> +static int
> +transport_set_vpd_ident_type(struct t10_vpd *vpd, unsigned char *page_83)
>  {
>  	/*
>  	 * The VPD identifier type..
> @@ -1774,7 +1736,8 @@ int transport_dump_vpd_ident(
>  	return ret;
>  }
>  
> -int transport_set_vpd_ident(struct t10_vpd *vpd, unsigned char *page_83)
> +static int
> +transport_set_vpd_ident(struct t10_vpd *vpd, unsigned char *page_83)
>  {
>  	int j = 0, i = 4; /* offset to start of the identifer */
>  
> @@ -2266,13 +2229,8 @@ void transport_device_setup_cmd(struct s
>  }
>  EXPORT_SYMBOL(transport_device_setup_cmd);
>  
> -struct se_cmd *__transport_alloc_se_cmd(
> -	struct target_core_fabric_ops *tfo,
> -	struct se_session *se_sess,
> -	void *fabric_cmd_ptr,
> -	u32 data_length,
> -	int data_direction,
> -	int task_attr)
> +static struct se_cmd *
> +transport_alloc_passthrough_cmd(u32 data_length, int data_direction)
>  {
>  	struct se_cmd *cmd;
>  	unsigned char *sense_buffer;
> @@ -2284,10 +2242,9 @@ struct se_cmd *__transport_alloc_se_cmd(
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	sense_buffer = kzalloc(
> -			TRANSPORT_SENSE_BUFFER + tfo->get_fabric_sense_len(),
> -			gfp_type);
> -	if (!(sense_buffer)) {
> +	sense_buffer = kzalloc(TRANSPORT_SENSE_BUFFER +
> +			passthrough_fabric_ops.get_fabric_sense_len(), gfp_type);
> +	if (!sense_buffer) {
>  		printk(KERN_ERR "Unable to allocate memory for"
>  			" cmd->sense_buffer\n");
>  		kmem_cache_free(se_cmd_cache, cmd);
> @@ -2296,13 +2253,14 @@ struct se_cmd *__transport_alloc_se_cmd(
>  	/*
>  	 * Initialize the new struct se_cmd descriptor
>  	 */
> -	transport_init_se_cmd(cmd, tfo, se_sess, data_length, data_direction,
> -			task_attr, sense_buffer);
> +	transport_init_se_cmd(cmd, &passthrough_fabric_ops, NULL,
> +			      data_length, data_direction,
> +			      TASK_ATTR_SIMPLE, sense_buffer);
>  	/*
>  	 * Setup the se_fabric_cmd_ptr assignment which will signal
>  	 * TCM allocation of struct se_cmd in the release and free codepaths
>  	 */
> -	cmd->se_fabric_cmd_ptr = fabric_cmd_ptr;
> +	cmd->se_fabric_cmd_ptr = (void *)1;
>  	return cmd;
>  }
>  
> @@ -2345,7 +2303,7 @@ void transport_init_se_cmd(
>  }
>  EXPORT_SYMBOL(transport_init_se_cmd);
>  
> -int transport_check_alloc_task_attr(struct se_cmd *cmd)
> +static int transport_check_alloc_task_attr(struct se_cmd *cmd)
>  {
>  	/*
>  	 * Check if SAM Task Attribute emulation is enabled for this
> @@ -2371,19 +2329,6 @@ int transport_check_alloc_task_attr(stru
>  	return 0;
>  }
>  
> -struct se_cmd *transport_alloc_se_cmd(
> -	struct target_core_fabric_ops *tfo_api,
> -	struct se_session *se_sess,
> -	void *fabric_cmd_ptr,
> -	u32 data_length,
> -	int data_direction,
> -	int task_attr)
> -{
> -	return __transport_alloc_se_cmd(tfo_api, se_sess, fabric_cmd_ptr,
> -				data_length, data_direction, task_attr);
> -}
> -EXPORT_SYMBOL(transport_alloc_se_cmd);
> -
>  void transport_free_se_cmd(
>  	struct se_cmd *se_cmd)
>  {
> @@ -2651,11 +2596,7 @@ int transport_generic_handle_tmr(
>  }
>  EXPORT_SYMBOL(transport_generic_handle_tmr);
>  
> -/*	transport_stop_tasks_for_cmd():
> - *
> - *
> - */
> -int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
> +static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
>  {
>  	struct se_task *task, *task_tmp;
>  	unsigned long flags;
> @@ -2731,11 +2672,10 @@ static void transport_failure_reset_queu
>  	spin_unlock_irqrestore(&SE_HBA(dev)->hba_queue_lock, flags);
>  }
>  
> -/*	transport_generic_request_failure():
> - *
> - *	Handle SAM-esque emulation for generic transport request failures.
> +/*
> + * Handle SAM-esque emulation for generic transport request failures.
>   */
> -void transport_generic_request_failure(
> +static void transport_generic_request_failure(
>  	struct se_cmd *cmd,
>  	struct se_device *dev,
>  	int complete,
> @@ -2865,7 +2805,7 @@ check_stop:
>  		transport_passthrough_check_stop(cmd);
>  }
>  
> -void transport_direct_request_timeout(struct se_cmd *cmd)
> +static void transport_direct_request_timeout(struct se_cmd *cmd)
>  {
>  	unsigned long flags;
>  
> @@ -2884,7 +2824,7 @@ void transport_direct_request_timeout(st
>  	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
>  }
>  
> -void transport_generic_request_timeout(struct se_cmd *cmd)
> +static void transport_generic_request_timeout(struct se_cmd *cmd)
>  {
>  	unsigned long flags;
>  
> @@ -2953,11 +2893,7 @@ static inline unsigned long long transpo
>  	return ((unsigned long long)__v2) | (unsigned long long)__v1 << 32;
>  }
>  
> -/*	transport_set_supported_SAM_opcode():
> - *
> - *
> - */
> -void transport_set_supported_SAM_opcode(struct se_cmd *se_cmd)
> +static void transport_set_supported_SAM_opcode(struct se_cmd *se_cmd)
>  {
>  	unsigned long flags;
>  
> @@ -2969,7 +2905,7 @@ void transport_set_supported_SAM_opcode(
>  /*
>   * Called from interrupt context.
>   */
> -void transport_task_timeout_handler(unsigned long data)
> +static void transport_task_timeout_handler(unsigned long data)
>  {
>  	struct se_task *task = (struct se_task *)data;
>  	struct se_cmd *cmd = TASK_CMD(task);
> @@ -3028,7 +2964,7 @@ void transport_task_timeout_handler(unsi
>  /*
>   * Called with T_TASK(cmd)->t_state_lock held.
>   */
> -void transport_start_task_timer(struct se_task *task)
> +static void transport_start_task_timer(struct se_task *task)
>  {
>  	struct se_device *dev = task->se_obj_ptr;
>  	int timeout;
> @@ -3075,31 +3011,7 @@ void __transport_stop_task_timer(struct
>  	task->task_flags &= ~TF_STOP;
>  }
>  
> -void transport_stop_task_timer(struct se_task *task)
> -{
> -	struct se_cmd *cmd = TASK_CMD(task);
> -	unsigned long flags;
> -#if 0
> -	printk(KERN_INFO "Stopping task timer for cmd: %p task: %p\n",
> -			cmd, task);
> -#endif
> -	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
> -	if (!(task->task_flags & TF_RUNNING)) {
> -		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
> -		return;
> -	}
> -	task->task_flags |= TF_STOP;
> -	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
> -
> -	del_timer_sync(&task->task_timer);
> -
> -	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
> -	task->task_flags &= ~TF_RUNNING;
> -	task->task_flags &= ~TF_STOP;
> -	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
> -}
> -
> -void transport_stop_all_task_timers(struct se_cmd *cmd)
> +static void transport_stop_all_task_timers(struct se_cmd *cmd)
>  {
>  	struct se_task *task = NULL, *task_tmp;
>  	unsigned long flags;
> @@ -3209,7 +3121,7 @@ static inline int transport_execute_task
>   * Called from fabric module context in transport_generic_new_cmd() and
>   * transport_generic_process_write()
>   */
> -int transport_execute_tasks(struct se_cmd *cmd)
> +static int transport_execute_tasks(struct se_cmd *cmd)
>  {
>  	int add_tasks;
>  
> @@ -3256,7 +3168,7 @@ execute_tasks:
>   *
>   * Called from transport_processing_thread()
>   */
> -int __transport_execute_tasks(struct se_device *dev)
> +static int __transport_execute_tasks(struct se_device *dev)
>  {
>  	int error;
>  	struct se_cmd *cmd = NULL;
> @@ -3359,11 +3271,7 @@ check_depth:
>  	return 0;
>  }
>  
> -/*	transport_new_cmd_failure():
> - *
> - *
> - */
> -void transport_new_cmd_failure(struct se_cmd *se_cmd)
> +static void transport_new_cmd_failure(struct se_cmd *se_cmd)
>  {
>  	unsigned long flags;
>  	/*
> @@ -3611,7 +3519,7 @@ out:
>  /*
>   * Used to obtain Sense Data from underlying Linux/SCSI struct scsi_cmnd
>   */
> -int transport_get_sense_data(struct se_cmd *cmd)
> +static int transport_get_sense_data(struct se_cmd *cmd)
>  {
>  	unsigned char *buffer = cmd->sense_buffer, *sense_buffer = NULL;
>  	struct se_device *dev;
> @@ -4283,14 +4191,6 @@ static int transport_generic_cmd_sequenc
>  	return ret;
>  }
>  
> -static inline struct se_cmd *transport_alloc_passthrough_cmd(
> -	u32 data_length,
> -	int data_direction)
> -{
> -	return __transport_alloc_se_cmd(&passthrough_fabric_ops, NULL,
> -		(void *)1, data_length, data_direction, TASK_ATTR_SIMPLE);
> -}
> -
>  static inline void transport_release_tasks(struct se_cmd *);
>  
>  struct se_cmd *transport_allocate_passthrough(
> @@ -4421,7 +4321,7 @@ void transport_passthrough_release(
>  }
>  EXPORT_SYMBOL(transport_passthrough_release);
>  
> -int transport_passthrough_complete(
> +static int transport_passthrough_complete(
>  	struct se_cmd *cmd)
>  {
>  	if (se_dev_check_shutdown(cmd->se_orig_obj_ptr) != 0)
> @@ -4503,7 +4403,7 @@ static void transport_memcpy_read_contig
>  	}
>  }
>  
> -void transport_memcpy_se_mem_read_contig(
> +static void transport_memcpy_se_mem_read_contig(
>  	struct se_cmd *cmd,
>  	unsigned char *dst,
>  	struct list_head *se_mem_list)
> @@ -4529,25 +4429,10 @@ void transport_memcpy_se_mem_read_contig
>  	}
>  }
>  
> -
> -/*     transport_generic_passthrough():
> - *
> - *
> - */
> -int transport_generic_passthrough_async(
> -	struct se_cmd *cmd,
> -	void (*callback)(struct se_cmd *cmd,
> -		void *callback_arg, int complete_status),
> -	void *callback_arg)
> +int transport_generic_passthrough(struct se_cmd *cmd)
>  {
>  	int write = (cmd->data_direction == DMA_TO_DEVICE);
>  	int no_alloc = (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH_NOALLOC);
> -	int pt_done = (cmd->transport_passthrough_done != NULL);
> -
> -	if (callback) {
> -		cmd->callback = callback;
> -		cmd->callback_arg = callback_arg;
> -	}
>  
>  	if (transport_generic_handle_cdb(cmd) < 0)
>  		return -1;
> @@ -4560,18 +4445,10 @@ int transport_generic_passthrough_async(
>  		transport_generic_process_write(cmd);
>  	}
>  
> -	if (callback || pt_done)
> -		return 0;
> -
>  	wait_for_completion(&T_TASK(cmd)->t_transport_passthrough_comp);
>  
>  	return transport_passthrough_complete(cmd);
>  }
> -
> -int transport_generic_passthrough(struct se_cmd *cmd)
> -{
> -	return transport_generic_passthrough_async(cmd, NULL, NULL);
> -}
>  EXPORT_SYMBOL(transport_generic_passthrough);
>  
>  /*
> @@ -4579,7 +4456,7 @@ EXPORT_SYMBOL(transport_generic_passthro
>   * transport_generic_request_failure() to determine which dormant/delayed
>   * and ordered cmds need to have their tasks added to the execution queue.
>   */
> -void transport_complete_task_attr(struct se_cmd *cmd)
> +static void transport_complete_task_attr(struct se_cmd *cmd)
>  {
>  	struct se_device *dev = SE_DEV(cmd);
>  	struct se_cmd *cmd_p, *cmd_tmp;
> @@ -4644,11 +4521,7 @@ void transport_complete_task_attr(struct
>  		wake_up_interruptible(&dev->dev_queue_obj->thread_wq);
>  }
>  
> -/*	transport_generic_complete_ok():
> - *
> - *
> - */
> -void transport_generic_complete_ok(struct se_cmd *cmd)
> +static void transport_generic_complete_ok(struct se_cmd *cmd)
>  {
>  	int reason = 0;
>  	/*
> @@ -4742,7 +4615,7 @@ void transport_generic_complete_ok(struc
>  	transport_cmd_check_stop_to_fabric(cmd);
>  }
>  
> -void transport_free_dev_tasks(struct se_cmd *cmd)
> +static void transport_free_dev_tasks(struct se_cmd *cmd)
>  {
>  	struct se_task *task, *task_tmp;
>  	unsigned long flags;
> @@ -4875,7 +4748,7 @@ static inline void transport_release_se_
>  	}
>  }
>  
> -void transport_release_fe_cmd(struct se_cmd *cmd)
> +static void transport_release_fe_cmd(struct se_cmd *cmd)
>  {
>  	unsigned long flags;
>  
> @@ -4901,11 +4774,7 @@ free_pages:
>  	transport_release_se_cmd(cmd);
>  }
>  
> -/*	transport_generic_remove():
> - *
> - *
> - */
> -int transport_generic_remove(
> +static int transport_generic_remove(
>  	struct se_cmd *cmd,
>  	int release_to_pool,
>  	int session_reinstatement)
> @@ -5063,7 +4932,7 @@ static inline long long transport_dev_en
>  	return dev->dev_sectors_total + 1;
>  }
>  
> -int transport_get_sectors(struct se_cmd *cmd)
> +static int transport_get_sectors(struct se_cmd *cmd)
>  {
>  	struct se_device *dev = SE_DEV(cmd);
>  
> @@ -5159,12 +5028,7 @@ static int transport_new_cmd_obj(
>  	return 0;
>  }
>  
> -unsigned char *transport_get_vaddr(struct se_mem *se_mem)
> -{
> -	return page_address(se_mem->se_page) + se_mem->se_off;
> -}
> -
> -struct list_head *transport_init_se_mem_list(void)
> +static struct list_head *transport_init_se_mem_list(void)
>  {
>  	struct list_head *se_mem_list;
>  
> @@ -5178,21 +5042,8 @@ struct list_head *transport_init_se_mem_
>  	return se_mem_list;
>  }
>  
> -void transport_free_se_mem_list(struct list_head *se_mem_list)
> -{
> -	struct se_mem *se_mem, *se_mem_tmp;
> -
> -	if (!se_mem_list)
> -		return;
> -
> -	list_for_each_entry_safe(se_mem, se_mem_tmp, se_mem_list, se_list) {
> -		list_del(&se_mem->se_list);
> -		kmem_cache_free(se_mem_cache, se_mem);
> -	}
> -	kfree(se_mem_list);
> -}
> -
> -int transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
> +static int
> +transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
>  {
>  	unsigned char *buf;
>  	struct se_mem *se_mem;
> @@ -5432,7 +5283,7 @@ static inline int transport_set_tasks_se
>  				max_sectors_set);
>  }
>  
> -int transport_map_sg_to_mem(
> +static int transport_map_sg_to_mem(
>  	struct se_cmd *cmd,
>  	struct list_head *se_mem_list,
>  	void *in_mem,
> @@ -5748,7 +5599,7 @@ static int transport_do_se_mem_map(
>  				task_offset_in);
>  }
>  
> -u32 transport_generic_get_cdb_count(
> +static u32 transport_generic_get_cdb_count(
>  	struct se_cmd *cmd,
>  	struct se_transform_info *ti,
>  	unsigned long long starting_lba,
> @@ -5944,7 +5795,7 @@ transport_map_control_cmd_to_task(struct
>   *	 by transport_generic_cmd_sequencer() from the iSCSI Target RX process.
>   *	 Any non zero return here is treated as an "out of resource' op here.
>   */
> -int transport_generic_new_cmd(struct se_cmd *cmd)
> +static int transport_generic_new_cmd(struct se_cmd *cmd)
>  {
>  	struct se_portal_group *se_tpg;
>  	struct se_transform_info ti;
> @@ -6501,7 +6352,7 @@ remove:
>  	transport_generic_free_cmd(cmd, 0, 0, session_reinstatement);
>  }
>  
> -int transport_get_sense_codes(
> +static int transport_get_sense_codes(
>  	struct se_cmd *cmd,
>  	u8 *asc,
>  	u8 *ascq)
> @@ -6512,7 +6363,7 @@ int transport_get_sense_codes(
>  	return 0;
>  }
>  
> -int transport_set_sense_codes(
> +static int transport_set_sense_codes(
>  	struct se_cmd *cmd,
>  	u8 asc,
>  	u8 ascq)
> @@ -6804,7 +6655,8 @@ int transport_generic_do_tmr(struct se_c
>   *	Called with spin_lock_irq(&dev->execute_task_lock); held
>   *
>   */
> -struct se_task *transport_get_task_from_state_list(struct se_device *dev)
> +static struct se_task *
> +transport_get_task_from_state_list(struct se_device *dev)
>  {
>  	struct se_task *task;
>  
> Index: lio-core/include/target/target_core_base.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_base.h	2010-11-17 22:25:24.577004053 +0100
> +++ lio-core/include/target/target_core_base.h	2010-11-17 22:25:25.653003843 +0100
> @@ -576,13 +576,9 @@ struct se_cmd {
>  	int (*transport_emulate_cdb)(struct se_cmd *);
>  	u32 (*transport_get_lba)(unsigned char *);
>  	unsigned long long (*transport_get_long_lba)(unsigned char *);
> -	void (*transport_passthrough_done)(struct se_cmd *);
>  	void (*transport_split_cdb)(unsigned long long, u32 *, unsigned char *);
>  	void (*transport_wait_for_tasks)(struct se_cmd *, int, int);
>  	void (*transport_complete_callback)(struct se_cmd *);
> -	void (*callback)(struct se_cmd *cmd, void *callback_arg,
> -			int complete_status);
> -	void *callback_arg;
>  } ____cacheline_aligned;
>  
>  #define T_TASK(cmd)     ((struct se_transport_task *)(cmd->t_task))
> Index: lio-core/include/target/target_core_tpg.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_tpg.h	2010-11-17 11:01:16.362265822 +0100
> +++ lio-core/include/target/target_core_tpg.h	2010-11-17 22:25:25.659003913 +0100
> @@ -31,8 +31,6 @@ extern int core_tpg_deregister(struct se
>  extern struct se_lun *core_tpg_pre_addlun(struct se_portal_group *, u32);
>  extern int core_tpg_post_addlun(struct se_portal_group *, struct se_lun *, u32,
>  				void *);
> -extern void core_tpg_shutdown_lun(struct se_portal_group *,
> -				struct se_lun *);
>  extern struct se_lun *core_tpg_pre_dellun(struct se_portal_group *, u32, int *);
>  extern int core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
>  
> Index: lio-core/include/target/target_core_transport.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_transport.h	2010-11-17 22:24:18.000000000 +0100
> +++ lio-core/include/target/target_core_transport.h	2010-11-17 22:25:25.664003284 +0100
> @@ -142,23 +142,13 @@ extern void transport_register_session(s
>  extern void transport_free_session(struct se_session *);
>  extern void transport_deregister_session_configfs(struct se_session *);
>  extern void transport_deregister_session(struct se_session *);
> -extern void transport_task_dev_remove_state(struct se_task *,
> -						struct se_device *);
>  extern void transport_cmd_finish_abort(struct se_cmd *, int);
>  extern void transport_cmd_finish_abort_tmr(struct se_cmd *);
> -extern int transport_add_cmd_to_queue(struct se_cmd *, int);
> -extern struct se_queue_req *__transport_get_qr_from_queue(
> -					struct se_queue_obj *);
> -extern void transport_remove_cmd_from_queue(struct se_cmd *,
> -					    struct se_queue_obj *);
>  extern void transport_complete_sync_cache(struct se_cmd *, int);
> -extern void transport_complete_cmd(struct se_cmd *, int);
>  extern void transport_complete_task(struct se_task *, int);
>  extern void transport_add_task_to_execute_queue(struct se_task *,
>  						struct se_task *,
>  						struct se_device *);
> -extern void transport_add_tasks_from_cmd(struct se_cmd *);
> -extern struct se_queue_req *transport_get_qr_from_queue(struct se_queue_obj *);
>  unsigned char *transport_dump_cmd_direction(struct se_cmd *);
>  extern void transport_dump_dev_state(struct se_device *, char *, int *);
>  extern void transport_dump_dev_info(struct se_device *, struct se_lun *,
> @@ -179,10 +169,6 @@ extern struct se_device *transport_add_d
>  					const char *, const char *);
>  extern int transport_generic_allocate_iovecs(struct se_cmd *);
>  extern void transport_device_setup_cmd(struct se_cmd *);
> -extern int transport_check_alloc_task_attr(struct se_cmd *);
> -extern struct se_cmd *transport_alloc_se_cmd(struct target_core_fabric_ops *,
> -					struct se_session *, void *,
> -					u32, int, int);
>  extern void transport_init_se_cmd(struct se_cmd *,
>  					struct target_core_fabric_ops *,
>  					struct se_session *, u32, int, int,
> @@ -193,66 +179,26 @@ extern int transport_generic_handle_cdb(
>  extern int transport_generic_handle_cdb_map(struct se_cmd *);
>  extern int transport_generic_handle_data(struct se_cmd *);
>  extern int transport_generic_handle_tmr(struct se_cmd *);
> -extern int transport_stop_tasks_for_cmd(struct se_cmd *);
> -extern void transport_generic_request_failure(struct se_cmd *, struct se_device *,
> -						int, int);
> -extern void transport_direct_request_timeout(struct se_cmd *);
> -extern void transport_generic_request_timeout(struct se_cmd *);
> -extern int __transport_execute_tasks(struct se_device *);
> -extern void transport_new_cmd_failure(struct se_cmd *);
> -extern void transport_set_supported_SAM_opcode(struct se_cmd *);
> -extern void transport_start_task_timer(struct se_task *);
>  extern void __transport_stop_task_timer(struct se_task *, unsigned long *);
> -extern void transport_stop_task_timer(struct se_task *);
> -extern void transport_stop_all_task_timers(struct se_cmd *);
> -extern int transport_execute_tasks(struct se_cmd *);
>  extern unsigned char transport_asciihex_to_binaryhex(unsigned char val[2]);
> -extern int transport_get_sense_data(struct se_cmd *);
>  extern struct se_cmd *transport_allocate_passthrough(unsigned char *, int, u32,
>  						void *, u32, u32, void *);
>  extern void transport_passthrough_release(struct se_cmd *);
> -extern int transport_passthrough_complete(struct se_cmd *);
> -extern void transport_memcpy_se_mem_read_contig(struct se_cmd *,
> -				unsigned char *, struct list_head *);
> -extern int transport_generic_passthrough_async(struct se_cmd *cmd,
> -				void(*callback)(struct se_cmd *cmd,
> -				void *callback_arg, int complete_status),
> -				void *callback_arg);
>  extern int transport_generic_passthrough(struct se_cmd *);
> -extern void transport_complete_task_attr(struct se_cmd *);
> -extern void transport_generic_complete_ok(struct se_cmd *);
> -extern void transport_free_dev_tasks(struct se_cmd *);
> -extern void transport_release_fe_cmd(struct se_cmd *);
> -extern int transport_generic_remove(struct se_cmd *, int, int);
>  extern int transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *, u32,
>  				struct scatterlist *, u32);
>  extern int transport_clear_lun_from_sessions(struct se_lun *);
>  extern int transport_check_aborted_status(struct se_cmd *, int);
> -extern int transport_get_sense_codes(struct se_cmd *, u8 *, u8 *);
> -extern int transport_set_sense_codes(struct se_cmd *, u8, u8);
>  extern int transport_send_check_condition_and_sense(struct se_cmd *, u8, int);
>  extern void transport_send_task_abort(struct se_cmd *);
>  extern void transport_release_cmd_to_pool(struct se_cmd *);
>  extern void transport_generic_free_cmd(struct se_cmd *, int, int, int);
>  extern void transport_generic_wait_for_cmds(struct se_cmd *, int);
> -extern int transport_get_sectors(struct se_cmd *);
> -extern unsigned char *transport_get_vaddr(struct se_mem *);
> -extern struct list_head *transport_init_se_mem_list(void);
> -extern void transport_free_se_mem_list(struct list_head *);
> -extern int transport_generic_get_mem(struct se_cmd *, u32, u32);
>  extern u32 transport_calc_sg_num(struct se_task *, struct se_mem *, u32);
> -extern int transport_map_sg_to_mem(struct se_cmd *, struct list_head *,
> -					void *, u32 *);
>  extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
>  					void *, struct se_mem *,
>  					struct se_mem **, u32 *, u32 *);
>  extern void transport_do_task_sg_chain(struct se_cmd *);
> -extern u32 transport_generic_get_cdb_count(struct se_cmd *,
> -					struct se_transform_info *,
> -					unsigned long long, u32,
> -					enum dma_data_direction,
> -					struct list_head *);
> -extern int transport_generic_new_cmd(struct se_cmd *);
>  extern void transport_generic_process_write(struct se_cmd *);
>  extern int transport_generic_do_tmr(struct se_cmd *);
>  /* From target_core_alua.c */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

