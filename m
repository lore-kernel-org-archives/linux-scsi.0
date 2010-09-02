From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [RFC 04/22] tcm: Add v4 base data structures and struct target_core_fabric_ops
Date: Thu, 2 Sep 2010 01:56:52 -0400
Message-ID: <201009020156.53803.konrad@darnok.org>
References: <1283160040-6636-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:52955 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0IBF7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 01:59:21 -0400
In-Reply-To: <1283160040-6636-1-git-send-email-nab@linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

On Monday 30 August 2010 05:20:40 Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>

Hey Nicholas,

I did a cursory review .

>
> This patch adds TCM Core v4 base data structures definitions + macros
> and fabric module function pointer API in struct target_core_fabric_ops.
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  include/target/target_core_base.h       |  985
> +++++++++++++++++++++++++++++++ include/target/target_core_fabric_ops.h |  
> 89 +++
>  2 files changed, 1074 insertions(+), 0 deletions(-)
>  create mode 100644 include/target/target_core_base.h
>  create mode 100644 include/target/target_core_fabric_ops.h
>
> diff --git a/include/target/target_core_base.h
> b/include/target/target_core_base.h new file mode 100644
> index 0000000..f4d0c70
> --- /dev/null
> +++ b/include/target/target_core_base.h
> @@ -0,0 +1,985 @@
> +#ifndef TARGET_CORE_BASE_H
> +#define TARGET_CORE_BASE_H
> +
> +#include <linux/in.h>
> +#include <linux/configfs.h>
> +#include <net/sock.h>
> +#include <net/tcp.h>
> +#include "target_core_mib.h"
> +
> +#define TARGET_CORE_MOD_VERSION		"v4.0.0-rc3"
> +#define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
> +
> +/* SCSI Command Descriptor Block Size a la SCSI's MAX_COMMAND_SIZE */
> +#define SCSI_CDB_SIZE			16
> +#define TRANSPORT_IOV_DATA_BUFFER	5
> +
> +/* Maximum Number of LUNs per Target Portal Group */
> +#define TRANSPORT_MAX_LUNS_PER_TPG	    256
> +
> +/* From include/scsi/scsi_cmnd.h:SCSI_SENSE_BUFFERSIZE */
> +#define TRANSPORT_SENSE_BUFFER              SCSI_SENSE_BUFFERSIZE
> +
> +#define SPC_SENSE_KEY_OFFSET			2
> +#define SPC_ASC_KEY_OFFSET			12
> +#define SPC_ASCQ_KEY_OFFSET			13
> +

.. from here on
> +/* Currently same as ISCSI_IQN_LEN */
> +#define TRANSPORT_IQN_LEN			224
> +#define LU_GROUP_NAME_BUF			256
> +#define TG_PT_GROUP_NAME_BUF			256
> +/* Used to parse VPD into struct t10_vpd */
> +#define VPD_TMP_BUF_SIZE			128
> +/* Used for target_core-pscsi.c:pscsi_transport_complete() */
> +#define VPD_BUF_LEN				256
> +/* Used for struct se_subsystem_dev-->se_dev_alias, must be less than
> +   PAGE_SIZE */
> +#define SE_DEV_ALIAS_LEN			512
> +/* Used for struct se_subsystem_dev->se_dev_udev_path[], must be less than
> +   PAGE_SIZE */
> +#define SE_UDEV_PATH_LEN			512
> +/* Used for struct se_dev_snap_attrib->contact */
> +#define SNAP_CONTACT_LEN			128
> +/* Used for struct se_dev_snap_attrib->lv_group */
> +#define SNAP_GROUP_LEN				128
> +/* Used for struct se_dev_snap_attrib->lvc_size */
> +#define SNAP_LVC_LEN				32
> +/* Used by struct t10_reservation_template->pr_[i,t]_port[] */
> +#define PR_APTPL_MAX_IPORT_LEN			256
> +#define PR_APTPL_MAX_TPORT_LEN			256
> +/* Used by struct t10_reservation_template->pr_aptpl_buf_len */
> +#define PR_APTPL_BUF_LEN			8192
> +/* Used by struct t10_alua_tg_pt_gp->tg_pt_gp_md_buf_len */
> +#define ALUA_MD_BUF_LEN				1024
> +/* Used by struct t10_pr_registration->pr_reg_isid */
> +#define PR_REG_ISID_LEN				16
> +/* PR_REG_ISID_LEN + ',i,0x' */
> +#define PR_REG_ISID_ID_LEN			(PR_REG_ISID_LEN + 5)

to here I am unsure which one of these are defined by a spec (like the IQN 
length) and which ones are Linux nomenclature. Perhaps it might be prudent to 
split them in two camps. And how did you come up with some of the length 
values that don't correspond to a spec?
> +
> +/* used by PSCSI and iBlock Transport drivers */
> +#define READ_BLOCK_LEN          		6
> +#define READ_CAP_LEN            		8
> +#define READ_POSITION_LEN       		20
> +#define INQUIRY_LEN				36
> +#define INQUIRY_VPD_SERIAL_LEN			254
> +#define INQUIRY_VPD_DEVICE_IDENTIFIER_LEN	254
> +
> +/* struct se_cmd->data_direction */
> +#define SE_DIRECTION_NONE			0
> +#define SE_DIRECTION_READ			1
> +#define SE_DIRECTION_WRITE			2
> +#define SE_DIRECTION_BIDI			3

Ugh, how about an enum instead?

> +
> +/* struct se_hba->hba_flags */
> +#define HBA_FLAGS_INTERNAL_USE			0x00000001
> +#define HBA_FLAGS_PSCSI_MODE			0x00000002
> +
> +/* struct se_hba->hba_status and iscsi_tpg_hba->thba_status */
> +#define HBA_STATUS_FREE				0x00000001
> +#define HBA_STATUS_ACTIVE			0x00000002
> +#define HBA_STATUS_INACTIVE			0x00000004
> +#define HBA_STATUS_SHUTDOWN			0x00000008
> +

> +/* struct se_lun->lun_status */
> +#define TRANSPORT_LUN_STATUS_FREE		0
> +#define TRANSPORT_LUN_STATUS_ACTIVE		1
> +
> +/* struct se_lun->lun_type */
> +#define TRANSPORT_LUN_TYPE_NONE			0
> +#define TRANSPORT_LUN_TYPE_DEVICE		1
> +
> +/* struct se_portal_group->se_tpg_type */
> +#define TRANSPORT_TPG_TYPE_NORMAL		0
> +#define TRANSPORT_TPG_TYPE_DISCOVERY		1

These sound quite generic. Perhaps they should be moved to a more generic 
header file?
> +
> +/* Used for se_node_acl->nodeacl_flags */

That "nodeacl" prefix for "flags" looks unnecessary. Why not
just have it defined as "se_node_acl->flags"
> +#define NAF_DYNAMIC_NODE_ACL                    0x01

> +
> +/* struct se_map_sg->map_flags */
Ditto
> +#define MAP_SG_KMAP				0x01

> +
> +/* Used for generate timer flags */
> +#define TF_RUNNING				0x01
> +#define TF_STOP					0x02
> +
> +/* Special transport agnostic struct se_cmd->t_states */
> +#define TRANSPORT_NO_STATE			240
> +#define TRANSPORT_NEW_CMD			241
> +#define TRANSPORT_DEFERRED_CMD			242
> +#define TRANSPORT_WRITE_PENDING			243
> +#define TRANSPORT_PROCESS_WRITE			244
> +#define TRANSPORT_PROCESSING			245
> +#define TRANSPORT_COMPLETE_OK			246
> +#define TRANSPORT_COMPLETE_FAILURE		247
> +#define TRANSPORT_COMPLETE_TIMEOUT		248
> +#define TRANSPORT_PROCESS_TMR			249
> +#define TRANSPORT_TMR_COMPLETE			250
> +#define TRANSPORT_ISTATE_PROCESSING 		251
> +#define TRANSPORT_ISTATE_PROCESSED  		252
> +#define TRANSPORT_KILL				253
> +#define TRANSPORT_REMOVE			254
> +#define TRANSPORT_FREE				255

These really look generic to me. Perhaps you can move them to a separate 
header file?
> +
> +#define SCF_SUPPORTED_SAM_OPCODE                0x00000001
> +#define SCF_TRANSPORT_TASK_SENSE                0x00000002
> +#define SCF_EMULATED_TASK_SENSE                 0x00000004
> +#define SCF_SCSI_DATA_SG_IO_CDB                 0x00000008
> +#define SCF_SCSI_CONTROL_SG_IO_CDB              0x00000010
> +#define SCF_SCSI_CONTROL_NONSG_IO_CDB           0x00000020
> +#define SCF_SCSI_NON_DATA_CDB                   0x00000040
> +#define SCF_SCSI_CDB_EXCEPTION                  0x00000080
> +#define SCF_SCSI_RESERVATION_CONFLICT           0x00000100
> +#define SCF_CMD_PASSTHROUGH                     0x00000200
> +#define SCF_CMD_PASSTHROUGH_NOALLOC             0x00000400
> +#define SCF_SE_CMD_FAILED                       0x00000800
> +#define SCF_SE_LUN_CMD                          0x00001000
> +#define SCF_SE_ALLOW_EOO                        0x00002000
> +#define SCF_SE_DISABLE_ONLINE_CHECK             0x00004000
> +#define SCF_SENT_CHECK_CONDITION		0x00008000
> +#define SCF_OVERFLOW_BIT                        0x00010000
> +#define SCF_UNDERFLOW_BIT                       0x00020000
> +#define SCF_SENT_DELAYED_TAS			0x00040000
> +#define SCF_ALUA_NON_OPTIMIZED			0x00080000
> +#define SCF_DELAYED_CMD_FROM_SAM_ATTR		0x00100000
> +#define SCF_PASSTHROUGH_SG_TO_MEM		0x00200000
> +#define SCF_PASSTHROUGH_CONTIG_TO_SG		0x00400000
> +#define SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC	0x00800000
> +#define SCF_EMULATE_SYNC_CACHE			0x01000000
> +#define SCF_EMULATE_CDB_ASYNC			0x02000000

Maybe an explanation what 'SCF' stands for?
> +
> +/* struct se_device->type */
> +#define PSCSI					1
> +#define STGT					2
> +#define PATA					3
> +#define IBLOCK					4
> +#define RAMDISK_DR				5
> +#define RAMDISK_MCP				6
> +#define FILEIO					7
> +#define VROM					8
> +#define VTAPE					9
> +#define MEDIA_CHANGER				10

Enum?
> +
> +/* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
> +#define TRANSPORT_LUNFLAGS_NO_ACCESS		0x00000000
> +#define TRANSPORT_LUNFLAGS_INITIATOR_ACCESS	0x00000001
> +#define TRANSPORT_LUNFLAGS_READ_ONLY		0x00000002
> +#define TRANSPORT_LUNFLAGS_READ_WRITE		0x00000004
> +
> +/* struct se_device->dev_status */
> +#define TRANSPORT_DEVICE_ACTIVATED		0x01
> +#define	TRANSPORT_DEVICE_DEACTIVATED		0x02
> +#define TRANSPORT_DEVICE_QUEUE_FULL		0x04
> +#define	TRANSPORT_DEVICE_SHUTDOWN		0x08
> +#define TRANSPORT_DEVICE_OFFLINE_ACTIVATED	0x10
> +#define TRANSPORT_DEVICE_OFFLINE_DEACTIVATED	0x20

Hmm.. Maybe it might be prudent to restructure this file altogether so that
the #defines are right next to the variables. Something akin to how 'ehci.h' 
has it setup?

It would make it so much simpler to figure out what are the possible states of 
a variable in a structure.

> +
> +#define	DEV_STATUS_THR_TUR			1
> +#define DEV_STATUS_THR_TAKE_ONLINE		2
> +#define DEV_STATUS_THR_TAKE_OFFLINE		3
> +#define DEV_STATUS_THR_SHUTDOWN			4

For most if not all of the #define you mentioned to what the variable the 
#defines correspond to. You missed it for these four above.

> +
> +/* struct se_dev_entry->deve_flags */
> +#define DEF_PR_REGISTERED			0x01
> +
> +/* Used for struct t10_pr_registration->pr_reg_flags */
> +#define PRF_ISID_PRESENT_AT_REG			0x01

> +
> +/* transport_send_check_condition_and_sense() */

That is one lengthy function name, but I don't see it in this patch?

> +#define NON_EXISTENT_LUN			0x1
> +#define UNSUPPORTED_SCSI_OPCODE			0x2
> +#define INCORRECT_AMOUNT_OF_DATA		0x3
> +#define UNEXPECTED_UNSOLICITED_DATA		0x4
> +#define SERVICE_CRC_ERROR			0x5
> +#define SNACK_REJECTED				0x6
> +#define SECTOR_COUNT_TOO_MANY			0x7
> +#define INVALID_CDB_FIELD			0x8
> +#define INVALID_PARAMETER_LIST			0x9
> +#define LOGICAL_UNIT_COMMUNICATION_FAILURE	0xa
> +#define UNKNOWN_MODE_PAGE			0xb
> +#define WRITE_PROTECTED				0xc
> +#define CHECK_CONDITION_ABORT_CMD		0xd
> +#define CHECK_CONDITION_UNIT_ATTENTION		0xe
> +#define CHECK_CONDITION_NOT_READY		0xf

So these #defines have nothing to do with SAM values. And looking at
include/scsi/iscsi_proto.h, it also has an incremental list, but it has a 
prefix.

Should these #defines have a prefix? Say TARGET_
> +
> +struct se_obj {
> +	atomic_t obj_access_count;
> +} ____cacheline_aligned;
> +
> +typedef enum {
> +	SPC_ALUA_PASSTHROUGH,
> +	SPC2_ALUA_DISABLED,
> +	SPC3_ALUA_EMULATED
> +} t10_alua_index_t;

Could you reference which spec has this defined?
> 
> +typedef enum {
> +	SAM_TASK_ATTR_PASSTHROUGH,
> +	SAM_TASK_ATTR_UNTAGGED,
> +	SAM_TASK_ATTR_EMULATED
> +} t10_task_attr_index_t;
> +
Ditto.

> +struct se_cmd;
> +
> +struct t10_alua {
> +	t10_alua_index_t alua_type;
> +	/* ALUA Target Port Group ID */
> +	u16	alua_tg_pt_gps_counter;
> +	u32	alua_tg_pt_gps_count;

So the ALUA tpg id is the alua_tg_pt_gps_counter or the alua_tg_pt_gps_count? 
Or both? That is a mouthfull. Can you just call them 'counter' and 'count' 
respectively?

> +	spinlock_t tg_pt_gps_lock;
> +	struct se_subsystem_dev *t10_sub_dev;

Just call it "sub_dev" ?
> +	/* Used for default ALUA Target Port Group */
> +	struct t10_alua_tg_pt_gp *default_tg_pt_gp;

You don't seem to define the "struct t10_alua_tg_pt_gp" - won't the compiler 
throw a fit here? Can you call it 'default'?

> +	/* Used for default ALUA Target Port Group ConfigFS group */
> +	struct config_group alua_tg_pt_gps_group;

And here 'group' instead of 'alua_tg_pt_gps_group'?
> +	int (*alua_state_check)(struct se_cmd *, unsigned char *, u8 *);

> +	struct list_head tg_pt_gps_list;

how about just 'list' ?
> +} ____cacheline_aligned;

> +
> +struct t10_alua_lu_gp {
> +	u16	lu_gp_id;
> +	int	lu_gp_valid_id;
> +	u32	lu_gp_members;
> +	atomic_t lu_gp_shutdown;
> +	atomic_t lu_gp_ref_cnt;
> +	spinlock_t lu_gp_lock;
> +	struct config_group lu_gp_group;
> +	struct list_head lu_gp_list;
> +	struct list_head lu_gp_mem_list;

How about getting rid of the 'lu_gp' prefix for all members?
> +} ____cacheline_aligned;
> +
> +struct t10_alua_lu_gp_member {
> +	int lu_gp_assoc;
> +	atomic_t lu_gp_mem_ref_cnt;
> +	spinlock_t lu_gp_mem_lock;
> +	struct t10_alua_lu_gp *lu_gp;
> +	struct se_device *lu_gp_mem_dev;
> +	struct list_head lu_gp_mem_list;

Ditto
> +} ____cacheline_aligned;
> +
> +struct t10_alua_tg_pt_gp {
> +	u16	tg_pt_gp_id;
> +	int	tg_pt_gp_valid_id;
> +	int	tg_pt_gp_alua_access_status;
> +	int	tg_pt_gp_alua_access_type;
> +	int	tg_pt_gp_nonop_delay_msecs;
> +	int	tg_pt_gp_trans_delay_msecs;
> +	int	tg_pt_gp_pref;
> +	int	tg_pt_gp_write_metadata;
> +	u32	tg_pt_gp_md_buf_len;
> +	u32	tg_pt_gp_members;
> +	atomic_t tg_pt_gp_alua_access_state;
> +	atomic_t tg_pt_gp_ref_cnt;
> +	spinlock_t tg_pt_gp_lock;
> +	struct mutex tg_pt_gp_md_mutex;
> +	struct se_subsystem_dev *tg_pt_gp_su_dev;
> +	struct config_group tg_pt_gp_group;
> +	struct list_head tg_pt_gp_list;
> +	struct list_head tg_pt_gp_mem_list;

Ditto
> +} ____cacheline_aligned;
> +
> +struct t10_alua_tg_pt_gp_member {
> +	int tg_pt_gp_assoc;
> +	atomic_t tg_pt_gp_mem_ref_cnt;
> +	spinlock_t tg_pt_gp_mem_lock;
> +	struct t10_alua_tg_pt_gp *tg_pt_gp;
> +	struct se_port *tg_pt;
> +	struct list_head tg_pt_gp_mem_list;

Ditto
> +} ____cacheline_aligned;
> +
> +struct t10_vpd {
> +	unsigned char device_identifier[INQUIRY_VPD_DEVICE_IDENTIFIER_LEN];
> +	int protocol_identifier_set;
> +	u32 protocol_identifier;
> +	u32 device_identifier_code_set;
> +	u32 association;
> +	u32 device_identifier_type;
> +	struct list_head vpd_list;
> +} ____cacheline_aligned;

The 't10' makes this sound official. If so, can you provide in the comment 
section the appropriate spec number?
> +
> +struct t10_wwn {
> +	unsigned char vendor[8];
> +	unsigned char model[16];
> +	unsigned char revision[4];
> +	unsigned char unit_serial[INQUIRY_VPD_SERIAL_LEN];
> +	spinlock_t t10_vpd_lock;

vpd_lock or wwn_lock? Why do you need a spinlock for this structure?
BTW, if you run checkpatch I think it throws a fit if you don't document the 
spinlock usage. You did use checkpatch.pl ,right?

> +	struct se_subsystem_dev *t10_sub_dev;

How about 'sub_dev' instead?
> +	struct config_group t10_wwn_group;

Take out the 't10_wwn'
> +	struct list_head t10_vpd_list;
And make this 'list' by itself.

> +} ____cacheline_aligned;


> +
> +typedef enum {
> +	SPC_PASSTHROUGH,
> +	SPC2_RESERVATIONS,
> +	SPC3_PERSISTENT_RESERVATIONS
> +} t10_reservations_index_t;

Are those official values ? Spec number, page?
> +
> +struct t10_pr_registration {
> +	/* Used for fabrics that contain WWN+ISID */
> +	char pr_reg_isid[PR_REG_ISID_LEN];
> +	/* Used during APTPL metadata reading */
> +	unsigned char pr_iport[PR_APTPL_MAX_IPORT_LEN];
> +	/* Used during APTPL metadata reading */
> +	unsigned char pr_tport[PR_APTPL_MAX_TPORT_LEN];
> +	/* For writing out live meta data */
> +	unsigned char *pr_aptpl_buf;
> +	u16 pr_aptpl_rpti;
> +	u16 pr_reg_tpgt;
> +	/* Reservation effects all target ports */
> +	int pr_reg_all_tg_pt;
> +	/* Activate Persistence across Target Power Loss */
> +	int pr_reg_aptpl;
> +	int pr_res_holder;
> +	int pr_res_type;
> +	int pr_res_scope;
> +	u32 pr_reg_flags;
> +	u32 pr_res_mapped_lun;
> +	u32 pr_aptpl_target_lun;
> +	u32 pr_res_generation;
> +	u64 pr_reg_bin_isid;
> +	u64 pr_res_key;
> +	atomic_t pr_res_holders;
> +	struct se_node_acl *pr_reg_nacl;
> +	struct se_dev_entry *pr_reg_deve;
> +	struct se_lun *pr_reg_tg_pt_lun;
> +	struct list_head pr_reg_list;
> +	struct list_head pr_reg_abort_list;
> +	struct list_head pr_reg_aptpl_list;
> +	struct list_head pr_reg_atp_list;
> +	struct list_head pr_reg_atp_mem_list;
> +} ____cacheline_aligned;
> +
What is 'pr' ? Pringles? You could call that structure 'persist_reg' and
remove all of those 'pr_reg_' prefixes.

> +struct t10_reservation_template {
> +	/* Reservation effects all target ports */
> +	int pr_all_tg_pt;

Um, not sure what the comment has to do with 'pr_all_tg_pt' ? What 
does 'pr_all_tg_tg' do?
> +	/* Activate Persistence across Target Power Loss enabled
> +	 * for SCSI device */
> +	int pr_aptpl_active;

Perhaps 'is_active' ?

> +	u32 pr_aptpl_buf_len;

Where is the buf? 

> +	u32 pr_generation;
> +	t10_reservations_index_t res_type;
> +	spinlock_t registration_lock;
> +	spinlock_t aptpl_reg_lock;
> +	/* Reservation holder when pr_all_tg_pt=1 */

Ah, and when it is another value?

> +	struct se_node_acl *pr_res_holder;
> +	struct list_head registration_list;
> +	struct list_head aptpl_reg_list;
> +	int (*t10_reservation_check)(struct se_cmd *, u32 *);
> +	int (*t10_seq_non_holder)(struct se_cmd *, unsigned char *, u32);
> +	int (*t10_pr_register)(struct se_cmd *);
> +	int (*t10_pr_clear)(struct se_cmd *);

You can get rid of the t10_ prefix.
> +} ____cacheline_aligned;
> +

This is the second structure I see where you mix data with functions.

I don't know what the actual StyleGuide is for this, but would it be prudent 
to split the data (spinlocks, list, values) from the behavior (functions?) 
This could be done by embedding another struct - which only has function 
pointers?

> +struct se_queue_req {
> +	int			state;
> +	void			*cmd;
> +	struct list_head	qr_list;
> +} ____cacheline_aligned;
> +
> +struct se_queue_obj {
> +	atomic_t		queue_cnt;
> +	spinlock_t		cmd_queue_lock;
> +	struct list_head	qobj_list;
> +	wait_queue_head_t	thread_wq;
> +	struct completion	thread_create_comp;
> +	struct completion	thread_done_comp;
> +} ____cacheline_aligned;
> +
> +struct se_transport_task {
> +	unsigned char		t_task_cdb[SCSI_CDB_SIZE];
> +	unsigned long long	t_task_lba;
> +	int			t_tasks_failed;
> +	int			t_task_fua;
> +	u32			t_task_cdbs;
> +	u32			t_task_check;
> +	u32			t_task_no;
> +	u32			t_task_sectors;
> +	u32			t_task_se_num;
> +	atomic_t		t_fe_count;
> +	atomic_t		t_se_count;
> +	atomic_t		t_task_cdbs_left;
> +	atomic_t		t_task_cdbs_ex_left;
> +	atomic_t		t_task_cdbs_timeout_left;
> +	atomic_t		t_task_cdbs_sent;
> +	atomic_t		t_transport_aborted;
> +	atomic_t		t_transport_active;
> +	atomic_t		t_transport_complete;
> +	atomic_t		t_transport_queue_active;
> +	atomic_t		t_transport_sent;
> +	atomic_t		t_transport_stop;
> +	atomic_t		t_transport_timeout;
> +	atomic_t		transport_dev_active;
> +	atomic_t		transport_lun_active;
> +	atomic_t		transport_lun_fe_stop;
> +	atomic_t		transport_lun_stop;
> +	spinlock_t		t_state_lock;
> +	struct completion	t_transport_stop_comp;
> +	struct completion	t_transport_passthrough_comp;
> +	struct completion	t_transport_passthrough_wcomp;
> +	struct completion	transport_lun_fe_stop_comp;
> +	struct completion	transport_lun_stop_comp;
> +	void			*t_task_buf;
> +	void			*t_task_pt_buf;
> +	struct list_head	t_task_list;
> +	struct list_head	*t_mem_list;
> +} ____cacheline_aligned;

I think you can remove the "t_" prefix.  I am though a bit confused, the 
struct is called 'transport_task' and there are values that are 
transport_task related, but then there are also some that are clearly related 
to a task:t_task_no, t_task_check? Should they just be plural?

> +
> +struct se_task {
> +	unsigned char	task_sense;
> +	struct scatterlist *task_sg;
> +	void		*transport_req;
> +	u8		task_scsi_status;
> +	u8		task_flags;
> +	int		task_error_status;
> +	int		task_state_flags;
> +	unsigned long long	task_lba;
> +	u32		task_no;
> +	u32		task_sectors;
> +	u32		task_size;
> +	u32		task_sg_num;
> +	u32		task_sg_offset;
> +	struct se_cmd *task_se_cmd;
> +	struct se_device	*se_dev;
> +	struct completion	task_stop_comp;
> +	atomic_t	task_active;
> +	atomic_t	task_execute_queue;
> +	atomic_t	task_timeout;
> +	atomic_t	task_sent;
> +	atomic_t	task_stop;
> +	atomic_t	task_state_active;
> +	struct timer_list	task_timer;
> +	int (*transport_map_task)(struct se_task *, u32);
> +	struct se_device *se_obj_ptr;
> +	struct list_head t_list;
> +	struct list_head t_execute_list;
> +	struct list_head t_state_list;
> +} ____cacheline_aligned;
> +
> +#define TASK_CMD(task)	((struct se_cmd *)task->task_se_cmd)
> +#define TASK_DEV(task)	((struct se_device *)task->se_dev)
> +

I stopped the review here. I think that using the ideas of how ehci.h mixes 
the struct variables with #defines will make this much easier to read?
