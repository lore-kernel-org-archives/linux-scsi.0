From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target_core_alua: Referrals infrastructure
Date: Wed, 16 Oct 2013 15:28:16 -0700
Message-ID: <1381962496.19256.667.camel@haakon3.risingtidesystems.com>
References: <1381908324-82135-1-git-send-email-hare@suse.de>
	 <1381908324-82135-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381908324-82135-2-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, Doug Gilber <dgilbert@interlog.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-10-16 at 09:25 +0200, Hannes Reinecke wrote:
> Add infrastructure for referrals.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c     | 151 ++++++++++++++++++++++++++++++++++
>  drivers/target/target_core_alua.h     |   4 +-
>  drivers/target/target_core_configfs.c |  12 ++-
>  drivers/target/target_core_device.c   |   2 +
>  drivers/target/target_core_sbc.c      |   5 +-
>  drivers/target/target_core_spc.c      |  20 +++++
>  include/scsi/scsi.h                   |   1 +
>  include/target/target_core_base.h     |  18 ++++
>  8 files changed, 209 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index 166bee6..8f66146 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -56,6 +56,75 @@ static LIST_HEAD(lu_gps_list);
>  struct t10_alua_lu_gp *default_lu_gp;
>  
>  /*
> + * REPORT REFERRALS
> + *
> + * See sbc3r35 section 5.23
> + */
> +sense_reason_t
> +target_emulate_report_referrals(struct se_cmd *cmd)
> +{
> +	struct se_device *dev = cmd->se_dev;
> +	struct t10_alua_lba_map *map;
> +	struct t10_alua_lba_map_member *map_mem;
> +	unsigned char *buf;
> +	u32 rd_len = 0, off;
> +
> +	if (cmd->data_length < 4) {
> +		pr_warn("REPORT REFERRALS allocation length %u too"
> +			" small\n", cmd->data_length);
> +		return TCM_INVALID_CDB_FIELD;
> +	}
> +
> +	buf = transport_kmap_data_sg(cmd);
> +	if (!buf)
> +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +
> +	off = 4;
> +	spin_lock(&dev->t10_alua.lba_map_lock);
> +	if (list_empty(&dev->t10_alua.lba_map_list)) {
> +		spin_unlock(&dev->t10_alua.lba_map_lock);
> +		transport_kunmap_data_sg(cmd);
> +
> +		return TCM_UNSUPPORTED_SCSI_OPCODE;
> +	}
> +
> +	list_for_each_entry(map, &dev->t10_alua.lba_map_list,
> +			    lba_map_list) {
> +		int desc_num = off + 3;
> +		int pg_num;
> +
> +		off += 4;
> +		put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
> +		off += 8;
> +		put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
> +		off += 8;
> +		rd_len += 20;
> +		pg_num = 0;
> +		list_for_each_entry(map_mem, &map->lba_map_mem_list,
> +				    lba_map_mem_list) {
> +			buf[off++] = map_mem->lba_map_mem_alua_state & 0x0f;
> +			off++;
> +			buf[off++] = (map_mem->lba_map_mem_alua_pg_id >> 8) & 0xff;
> +			buf[off++] = (map_mem->lba_map_mem_alua_pg_id & 0xff);
> +			rd_len += 4;
> +			pg_num++;
> +		}
> +		buf[desc_num] = pg_num;
> +	}
> +	spin_unlock(&dev->t10_alua.lba_map_lock);
> +

For both of these list walks, there needs to be a check against offset
vs. ->data_length to know when the available payload length has been
exhausted..

> +	/*
> +	 * Set the RETURN DATA LENGTH set in the header of the DataIN Payload
> +	 */
> +	put_unaligned_be16(rd_len, &buf[2]);
> +
> +	transport_kunmap_data_sg(cmd);
> +
> +	target_complete_cmd(cmd, GOOD);
> +	return 0;
> +}
> +
> +/*
>   * REPORT_TARGET_PORT_GROUPS
>   *
>   * See spc4r17 section 6.27
> @@ -389,6 +458,80 @@ static inline int core_alua_state_nonoptimized(
>  	return 0;
>  }
>  
> +static inline int core_alua_state_lba_dependent(
> +	struct se_cmd *cmd,
> +	struct t10_alua_tg_pt_gp *tg_pt_gp,
> +	u8 *alua_ascq)
> +{
> +	struct se_device *dev = cmd->se_dev;
> +	u32 segment_size, segment_mult, sectors;
> +	u64 lba;
> +
> +	/* Only need to check for cdb actually containing LBAs */
> +	if (!cmd->se_cmd_flags & SCF_SCSI_DATA_CDB)
> +		return 0;
> +
> +	spin_lock(&dev->t10_alua.lba_map_lock);
> +	segment_size = dev->t10_alua.lba_map_segment_size;
> +	segment_mult = dev->t10_alua.lba_map_segment_multiplier;
> +	sectors = cmd->data_length / dev->dev_attrib.block_size;
> +
> +	lba = cmd->t_task_lba;
> +	while (lba < cmd->t_task_lba + sectors) {
> +		struct t10_alua_lba_map *cur_map = NULL, *map;
> +		struct t10_alua_lba_map_member *map_mem;
> +
> +		list_for_each_entry(map, &dev->t10_alua.lba_map_list,
> +				    lba_map_list) {
> +			u64 start_lba, last_lba;
> +			u64 first_lba = map->lba_map_first_lba;
> +
> +			if (segment_mult) {
> +				start_lba = lba % (segment_size * segment_mult);
> +				last_lba = first_lba + segment_size - 1;
> +				if (start_lba >= first_lba &&
> +				    start_lba <= last_lba) {
> +					lba += segment_size;
> +					cur_map = map;
> +					break;
> +				}
> +			} else {
> +				last_lba = map->lba_map_last_lba;
> +				if (lba >= first_lba && lba <= last_lba) {
> +					lba = last_lba + 1;
> +					cur_map = map;
> +					break;
> +				}
> +			}
> +		}
> +		if (!cur_map) {
> +			spin_unlock(&dev->t10_alua.lba_map_lock);
> +			*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
> +			return 1;
> +		}
> +		list_for_each_entry(map_mem, &cur_map->lba_map_mem_list,
> +				    lba_map_mem_list) {
> +			if (map_mem->lba_map_mem_alua_pg_id !=
> +			    tg_pt_gp->tg_pt_gp_id)
> +				continue;
> +			switch(map_mem->lba_map_mem_alua_state) {
> +			case ALUA_ACCESS_STATE_STANDBY:
> +				spin_unlock(&dev->t10_alua.lba_map_lock);
> +				*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
> +				return 1;
> +			case ALUA_ACCESS_STATE_UNAVAILABLE:
> +				spin_unlock(&dev->t10_alua.lba_map_lock);
> +				*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
> +				return 1;
> +			default:
> +				break;
> +			}
> +		}
> +	}
> +	spin_unlock(&dev->t10_alua.lba_map_lock);
> +	return 0;
> +}
> +
>  static inline int core_alua_state_standby(
>  	struct se_cmd *cmd,
>  	unsigned char *cdb,
> @@ -586,6 +729,9 @@ target_alua_state_check(struct se_cmd *cmd)
>  	case ALUA_ACCESS_STATE_TRANSITION:
>  		ret = core_alua_state_transition(cmd, cdb, &alua_ascq);
>  		break;
> +	case ALUA_ACCESS_STATE_LBA_DEPENDENT:
> +		ret = core_alua_state_lba_dependent(cmd, tg_pt_gp, &alua_ascq);
> +		break;
>  	/*
>  	 * OFFLINE is a secondary ALUA target port group access state, that is
>  	 * handled above with struct se_port->sep_tg_pt_secondary_offline=1
> @@ -670,6 +816,11 @@ core_alua_check_transition(int state, int valid, int *primary)
>  			goto not_supported;
>  		*primary = 1;
>  		break;
> +	case ALUA_ACCESS_STATE_LBA_DEPENDENT:
> +		if (!(valid & ALUA_LBD_SUP))
> +			goto not_supported;
> +		*primary = 1;
> +		break;
>  	case ALUA_ACCESS_STATE_OFFLINE:
>  		/*
>  		 * OFFLINE state is defined as a secondary target port
> diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
> index 1a152cd..47950cd 100644
> --- a/drivers/target/target_core_alua.h
> +++ b/drivers/target/target_core_alua.h
> @@ -13,12 +13,13 @@
>  /*
>   * ASYMMETRIC ACCESS STATE field
>   *
> - * from spc4r17 section 6.27 Table 245
> + * from spc4r36j section 6.37 Table 307
>   */
>  #define ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED	0x0
>  #define ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED	0x1
>  #define ALUA_ACCESS_STATE_STANDBY		0x2
>  #define ALUA_ACCESS_STATE_UNAVAILABLE		0x3
> +#define ALUA_ACCESS_STATE_LBA_DEPENDENT		0x4
>  #define ALUA_ACCESS_STATE_OFFLINE		0xe
>  #define ALUA_ACCESS_STATE_TRANSITION		0xf
>  
> @@ -88,6 +89,7 @@ extern struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
>  
>  extern sense_reason_t target_emulate_report_target_port_groups(struct se_cmd *);
>  extern sense_reason_t target_emulate_set_target_port_groups(struct se_cmd *);
> +extern sense_reason_t target_emulate_report_referrals(struct se_cmd *);
>  extern int core_alua_check_nonop_delay(struct se_cmd *);
>  extern int core_alua_do_port_transition(struct t10_alua_tg_pt_gp *,
>  				struct se_device *, struct se_port *,
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 53e9e00..172a54e 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -2054,7 +2054,13 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
>  			" transition while TPGS_IMPLICIT_ALUA is disabled\n");
>  		return -EINVAL;
>  	}
> -
> +	if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA &&
> +	    new_state == ALUA_ACCESS_STATE_LBA_DEPENDENT) {
> +		/* LBA DEPENDENT is only allowed with implicit ALUA */
> +		pr_err("Unable to process implicit configfs ALUA"
> +		       " transition while TPGS_EXPLICIT_ALUA is enabled\n");
> +		return -EINVAL;
> +	}
>  	ret = core_alua_do_port_transition(tg_pt_gp, dev,
>  					NULL, NULL, new_state, 0);
>  	return (!ret) ? count : -EINVAL;
> @@ -2163,7 +2169,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_supported_states(
>  		return -EINVAL;
>  	}
>  	new_states = (int)tmp;
> -	valid_states = ALUA_T_SUP | ALUA_O_SUP | ALUA_LBD_SUP | \
> +	valid_states = ALUA_T_SUP | ALUA_O_SUP | \
>  	    ALUA_U_SUP | ALUA_S_SUP | ALUA_AN_SUP | ALUA_AO_SUP;
>  
> 
> @@ -2172,6 +2178,8 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_supported_states(
>  				new_states);
>  		return -EINVAL;
>  	}
> +	/* LBD_SUP is set once lba_map has been populated */
> +	new_states |= tg_pt_gp->tg_pt_gp_alua_supported_states & ALUA_LBD_SUP;
>  
>  	tg_pt_gp->tg_pt_gp_alua_supported_states = new_states;
>  	return count;
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index d17e10d..f71cc33 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -1440,6 +1440,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>  	spin_lock_init(&dev->t10_pr.aptpl_reg_lock);
>  	INIT_LIST_HEAD(&dev->t10_alua.tg_pt_gps_list);
>  	spin_lock_init(&dev->t10_alua.tg_pt_gps_lock);
> +	INIT_LIST_HEAD(&dev->t10_alua.lba_map_list);
> +	spin_lock_init(&dev->t10_alua.lba_map_lock);
>  
>  	dev->t10_wwn.t10_dev = dev;
>  	dev->t10_alua.t10_dev = dev;
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 4714c6f..d25683da 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -33,7 +33,7 @@
>  
>  #include "target_core_internal.h"
>  #include "target_core_ua.h"
> -
> +#include "target_core_alua.h"
>  
>  static sense_reason_t
>  sbc_emulate_readcapacity(struct se_cmd *cmd)
> @@ -716,6 +716,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>  		case SAI_READ_CAPACITY_16:
>  			cmd->execute_cmd = sbc_emulate_readcapacity_16;
>  			break;
> +		case SAI_REPORT_REFERRALS:
> +			cmd->execute_cmd = target_emulate_report_referrals;
> +			break;
>  		default:
>  			pr_err("Unsupported SA: 0x%02x\n",
>  				cmd->t_task_cdb[1] & 0x1f);
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index e39d442..282b5bb 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -476,6 +476,11 @@ spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
>  	/* If WriteCache emulation is enabled, set V_SUP */
>  	if (spc_check_dev_wce(dev))
>  		buf[6] = 0x01;
> +	/* If an LBA map is present set R_SUP */
> +	spin_lock(&cmd->se_dev->t10_alua.lba_map_lock);
> +	if (!list_empty(&dev->t10_alua.lba_map_list))
> +		buf[8] = 0x10;
> +	spin_unlock(&cmd->se_dev->t10_alua.lba_map_lock);
>  	return 0;
>  }

Is there ever a case where R_SUP should be reported, but lba_map_list is
empty..?

How about a se_device attribute called 'emulate_referrals' to determine
when to report R_SUP..?  Otherwise, perhaps using the se_lun -> se_port
-> sep_alua_tg_pt_gp_mem -> tg_pt_gp provided bit for
tg_pt_gp_alua_supported_states instead..?

>  
> @@ -627,6 +632,20 @@ spc_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
>  	return 0;
>  }
>  
> +/* Referrals VPD page */
> +static sense_reason_t
> +spc_emulate_evpd_b3(struct se_cmd *cmd, unsigned char *buf)
> +{
> +	struct se_device *dev = cmd->se_dev;
> +
> +	buf[0] = dev->transport->get_device_type(dev);
> +	buf[3] = 0x0c;
> +	put_unaligned_be32(dev->t10_alua.lba_map_segment_size, &buf[8]);
> +	put_unaligned_be32(dev->t10_alua.lba_map_segment_size, &buf[12]);
> +

Typo..  Offset for byte 12 should be the lba_map_segment_multiplier..

> +	return 0;
> +}
> +
>  static sense_reason_t
>  spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf);
>  
> @@ -641,6 +660,7 @@ static struct {
>  	{ .page = 0xb0, .emulate = spc_emulate_evpd_b0 },
>  	{ .page = 0xb1, .emulate = spc_emulate_evpd_b1 },
>  	{ .page = 0xb2, .emulate = spc_emulate_evpd_b2 },
> +	{ .page = 0xb3, .emulate = spc_emulate_evpd_b3 },
>  };
>  
>  /* supported vital product data pages */
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 66d42ed..0a4edfe 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -155,6 +155,7 @@ enum scsi_timeouts {
>  /* values for service action in */
>  #define	SAI_READ_CAPACITY_16  0x10
>  #define SAI_GET_LBA_STATUS    0x12
> +#define SAI_REPORT_REFERRALS  0x13
>  /* values for VARIABLE_LENGTH_CMD service action codes
>   * see spc4r17 Section D.3.5, table D.7 and D.8 */
>  #define VLC_SA_RECEIVE_CREDENTIAL 0x1800
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index b02bb61..34181ad 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -246,10 +246,28 @@ typedef enum {
>  
>  struct se_cmd;
>  
> +struct t10_alua_lba_map_member {
> +	struct list_head lba_map_mem_list;
> +	int lba_map_mem_alua_state;
> +	int lba_map_mem_alua_pg_id;
> +};
> +
> +struct t10_alua_lba_map {
> +	u64 lba_map_first_lba;
> +	u64 lba_map_last_lba;
> +	struct list_head lba_map_list;
> +	struct list_head lba_map_mem_list;
> +};
> +
>  struct t10_alua {
>  	/* ALUA Target Port Group ID */
>  	u16	alua_tg_pt_gps_counter;
>  	u32	alua_tg_pt_gps_count;
> +	/* Referrals support */
> +	spinlock_t lba_map_lock;
> +	u32     lba_map_segment_size;
> +	u32     lba_map_segment_multiplier;
> +	struct list_head lba_map_list;
>  	spinlock_t tg_pt_gps_lock;
>  	struct se_device *t10_dev;
>  	/* Used for default ALUA Target Port Group */
