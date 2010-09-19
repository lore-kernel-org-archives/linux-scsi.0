From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] tcm: Add native 32-byte CDB support
Date: Sun, 19 Sep 2010 13:55:18 +0200
Message-ID: <4C95FA26.6040803@panasas.com>
References: <1284701685-18344-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:22605 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753388Ab0ISLzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Sep 2010 07:55:24 -0400
In-Reply-To: <1284701685-18344-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>

On 09/17/2010 07:34 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a '#define TCM_MAX_COMMAND_SIZE 32' and converts all
> inline TCM core and subsystem CDB size defines to use TCM_MAX_COMMAND_SIZE
> instead of the 16-byte MAX_COMMAND_SIZE.  This includes the conversion of
> MAX_COMMAND_SIZE in certain places to use include/scsi/scsi.h:scsi_command_size()
> to properly extract the size of a received CDB based on opcode.
> 
> This patch also includes the conversion of the FILEIO, IBLOCK, PSCSI, RAMDISK
> and STGT subsystem modules to use TCM_MAX_COMMAND_SIZE for their default
> internal inline CDB size.
> 
> It also adds transport_lba_64_ext() and transport_get_sectors_32() callers
> into target_core_transport.c to be used for extracting a 64-bit logical
> block address and 32-bit transfer length (in block) from 32-byte CDBs.
> Finally this patch adds split_cdb_XX_32() and split_cdb_XX_32() for handling
> the generation of 32-byte CDBs for individual struct se_task.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_file.h      |    2 +-
>  drivers/target/target_core_iblock.h    |    2 +-
>  drivers/target/target_core_pscsi.c     |    2 +-
>  drivers/target/target_core_pscsi.h     |    2 +-
>  drivers/target/target_core_rd.h        |    2 +-
>  drivers/target/target_core_scdb.c      |   38 +++++++++++++++++++++++++++
>  drivers/target/target_core_scdb.h      |    2 +
>  drivers/target/target_core_stgt.h      |    2 +-
>  drivers/target/target_core_transport.c |   44 ++++++++++++++++++++++++++++---
>  include/target/target_core_base.h      |   13 +++++++++
>  10 files changed, 98 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
> index 7831034..35726f1 100644
> --- a/drivers/target/target_core_file.h
> +++ b/drivers/target/target_core_file.h
> @@ -26,7 +26,7 @@ extern int linux_blockdevice_check(int, int);
>  
>  struct fd_request {
>  	/* SCSI CDB from iSCSI Command PDU */
> -	unsigned char	fd_scsi_cdb[MAX_COMMAND_SIZE];
> +	unsigned char	fd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
>  	/* Data Direction */
>  	u8		fd_data_direction;
>  	/* Total length of request */
> diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
> index 76c39a9..3582aac 100644
> --- a/drivers/target/target_core_iblock.h
> +++ b/drivers/target/target_core_iblock.h
> @@ -12,7 +12,7 @@
>  extern struct se_global *se_global;
>  
>  struct iblock_req {
> -	unsigned char ib_scsi_cdb[MAX_COMMAND_SIZE];
> +	unsigned char ib_scsi_cdb[TCM_MAX_COMMAND_SIZE];
>  	atomic_t ib_bio_cnt;
>  	u32	ib_sg_count;
>  	void	*ib_buf;
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 803853d..beca807 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -743,7 +743,7 @@ static inline void pscsi_blk_init_request(
>  	 * Load the referenced struct se_task's SCSI CDB into
>  	 * include/linux/blkdev.h:struct request->cmd
>  	 */
> -	pt->pscsi_req->cmd_len = COMMAND_SIZE(pt->pscsi_cdb[0]);
> +	pt->pscsi_req->cmd_len = scsi_command_size(pt->pscsi_cdb);
>  	memcpy(pt->pscsi_req->cmd, pt->pscsi_cdb, pt->pscsi_req->cmd_len);

Boom, only 16 bytes at req->cmd.

For larger than 16 bytes commands at the block/scsi-ml level you need to:

	request->cmd = my_buffer_valid_until_complete;
	request->cmd_len = scsi_command_size()

if above "my_buffer_valid_until_complet" is always available you can just
do this regardless. If you need to dynamically allocate it (and deallocate)
then you should do an if > MAX_COMMAND_SIZE

>  	/*
>  	 * Setup pointer for outgoing sense data.
> diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
> index db09d6a..086e6f1 100644
> --- a/drivers/target/target_core_pscsi.h
> +++ b/drivers/target/target_core_pscsi.h
> @@ -28,7 +28,7 @@ extern int linux_blockdevice_check(int, int);
>  #include <linux/kobject.h>
>  
>  struct pscsi_plugin_task {
> -	unsigned char pscsi_cdb[MAX_COMMAND_SIZE];
> +	unsigned char pscsi_cdb[TCM_MAX_COMMAND_SIZE];
>  	unsigned char pscsi_sense[SCSI_SENSE_BUFFERSIZE];
>  	int	pscsi_direction;
>  	int	pscsi_result;

pscsi is when you directly Q to a scsi LLD via midlayer right? Note that most
scsi LLDs don't support > 16 or 12 bytes. The regular scsi despatch will check
this for you and return an error. How are these dispatched? blk_execute_rq* ?

> diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
> index 8170b41..2008807 100644
> --- a/drivers/target/target_core_rd.h
> +++ b/drivers/target/target_core_rd.h
> @@ -31,7 +31,7 @@ void rd_module_exit(void);
>  
>  struct rd_request {
>  	/* SCSI CDB from iSCSI Command PDU */
> -	unsigned char	rd_scsi_cdb[MAX_COMMAND_SIZE];
> +	unsigned char	rd_scsi_cdb[TCM_MAX_COMMAND_SIZE];
>  	/* Data Direction */
>  	u8		rd_data_direction;
>  	/* Total length of request */
> diff --git a/drivers/target/target_core_scdb.c b/drivers/target/target_core_scdb.c
> index 8bcfeaf..76a7de0 100644
> --- a/drivers/target/target_core_scdb.c
> +++ b/drivers/target/target_core_scdb.c
> @@ -28,6 +28,7 @@
>  
>  #include <linux/net.h>
>  #include <linux/string.h>
> +#include <scsi/scsi.h>
>  
>  #include <target/target_core_base.h>
>  #include <target/target_core_transport.h>
> @@ -147,3 +148,40 @@ void split_cdb_RW_16(
>  	cdb[0] = (rw) ? 0x8a : 0x88;
>  	split_cdb_XX_16(lba, sectors, &cdb[0]);
>  }
> +
> +/*
> + *	split_cdb_XX_32():
> + *	
> + * 	64-bit LBA w/ 32-bit SECTORS such as READ_32, WRITE_32 and XDWRITEREAD_32
> + */
> +void split_cdb_XX_32(
> +	unsigned long long lba,
> +	u32 *sectors,
> +	unsigned char *cdb)
> +{
> +	cdb[12] = (lba >> 56) & 0xff;
> +	cdb[13] = (lba >> 48) & 0xff;
> +	cdb[14] = (lba >> 40) & 0xff;
> +	cdb[15] = (lba >> 32) & 0xff;
> +	cdb[16] = (lba >> 24) & 0xff;
> +	cdb[17] = (lba >> 16) & 0xff;
> +	cdb[18] = (lba >> 8) & 0xff;
> +	cdb[19] = lba & 0xff;

put_unaligned_be64

> +	cdb[28] = (*sectors >> 24) & 0xff;
> +	cdb[29] = (*sectors >> 16) & 0xff;
> +	cdb[30] = (*sectors >> 8) & 0xff;
> +	cdb[31] = *sectors & 0xff;

put_unaligned_be32

> +}
> +
> +void split_cdb_RW_32(
> +	unsigned long long lba,
> +	u32 *sectors,
> +	unsigned char *cdb,
> +	int rw)
> +{
> +	/*
> +	 * Set service action for VARIABLE_LENGTH_CMD
> +	 */
> +	cdb[9] = (rw) ? WRITE_32 : READ_32;
> +	split_cdb_XX_32(lba, sectors, &cdb[0]);	
> +}
> diff --git a/drivers/target/target_core_scdb.h b/drivers/target/target_core_scdb.h
> index 57688e2..1b0dc74 100644
> --- a/drivers/target/target_core_scdb.h
> +++ b/drivers/target/target_core_scdb.h
> @@ -9,5 +9,7 @@ extern void split_cdb_XX_12(unsigned long long, u32 *, unsigned char *);
>  extern void split_cdb_RW_12(unsigned long long, u32 *, unsigned char *, int);
>  extern void split_cdb_XX_16(unsigned long long, u32 *, unsigned char *);
>  extern void split_cdb_RW_16(unsigned long long, u32 *, unsigned char *, int);
> +extern void split_cdb_XX_32(unsigned long long, u32 *, unsigned char *);
> +extern void split_cdb_RW_32(unsigned long long, u32 *, unsigned char *, int);
>  
>  #endif /* TARGET_CORE_SCDB_H */
> diff --git a/drivers/target/target_core_stgt.h b/drivers/target/target_core_stgt.h
> index b82300c..8582776 100644
> --- a/drivers/target/target_core_stgt.h
> +++ b/drivers/target/target_core_stgt.h
> @@ -23,7 +23,7 @@ extern int linux_blockdevice_check(int, int);
>  #include <linux/kobject.h>
>  
>  struct stgt_plugin_task {
> -	unsigned char stgt_cdb[MAX_COMMAND_SIZE];
> +	unsigned char stgt_cdb[TCM_MAX_COMMAND_SIZE];
>  	unsigned char stgt_sense[SCSI_SENSE_BUFFERSIZE];
>  	int	stgt_direction;
>  	int	stgt_result;
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 49d5946..a3016f7 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2636,7 +2636,8 @@ static int transport_process_control_sg_transform(
>  
>  	cdb = TRANSPORT(dev)->get_cdb(task);
>  	if (cdb)
> -		memcpy(cdb, T_TASK(cmd)->t_task_cdb, MAX_COMMAND_SIZE);
> +		memcpy(cdb, T_TASK(cmd)->t_task_cdb,
> +			scsi_command_size(T_TASK(cmd)->t_task_cdb));
>  
>  	task->task_size = cmd->data_length;
>  	task->task_sg_num = 1;
> @@ -2677,7 +2678,8 @@ static int transport_process_control_nonsg_transform(
>  
>  	cdb = TRANSPORT(dev)->get_cdb(task);
>  	if (cdb)
> -		memcpy(cdb, T_TASK(cmd)->t_task_cdb, MAX_COMMAND_SIZE);
> +		memcpy(cdb, T_TASK(cmd)->t_task_cdb,
> +			scsi_command_size(T_TASK(cmd)->t_task_cdb));
>  
>  	task->task_size = cmd->data_length;
>  	task->task_sg_num = 0;
> @@ -2711,7 +2713,8 @@ static int transport_process_non_data_transform(
>  
>  	cdb = TRANSPORT(dev)->get_cdb(task);
>  	if (cdb)
> -		memcpy(cdb, T_TASK(cmd)->t_task_cdb, MAX_COMMAND_SIZE);
> +		memcpy(cdb, T_TASK(cmd)->t_task_cdb,
> +			scsi_command_size(T_TASK(cmd)->t_task_cdb));
>  
>  	task->task_size = cmd->data_length;
>  	task->task_sg_num = 0;
> @@ -2902,7 +2905,7 @@ int transport_generic_allocate_tasks(
>  	/*
>  	 * Copy the original CDB into T_TASK(cmd).
>  	 */
> -	memcpy(T_TASK(cmd)->t_task_cdb, cdb, MAX_COMMAND_SIZE);
> +	memcpy(T_TASK(cmd)->t_task_cdb, cdb, scsi_command_size(cdb));

scsi_command_size can return up to 260 dependent on command. So you'll
need a min() to make sure. I'd do a tsk_cdb_cpy() wrapper that does
the proper min() for everyone. Later that wrapper can be made smarter
for large commands up to 260.

>  	/*
>  	 * Check for SAM Task Attribute Emulation
>  	 */
> @@ -3829,6 +3832,19 @@ static inline unsigned long long transport_lba_64(unsigned char *cdb)
>  	return ((unsigned long long)__v2) | (unsigned long long)__v1 << 32;
>  }
>  
> +/*
> + * For VARIABLE_LENGTH_CDB w/ 32 byte extended CDBs
> + */
> +static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
> +{
> +	unsigned int __v1, __v2;
> +
> +	__v1 = (cdb[12] << 24) | (cdb[13] << 16) | (cdb[14] << 8) | cdb[15];
> +	__v2 = (cdb[16] << 24) | (cdb[17] << 16) | (cdb[18] << 8) | cdb[19];
> +
> +	return ((unsigned long long)__v2) | (unsigned long long)__v1 << 32;

get_unaligned_be64(&cdb[12]);

I'd just drop this wrapper

> +}
> +
>  /*	transport_set_supported_SAM_opcode():
>   *
>   *
> @@ -4370,6 +4386,23 @@ type_disk:
>  		    (cdb[12] << 8) + cdb[13];
>  }
>  
> +/*
> + * Used for VARIABLE_LENGTH_CDB WRITE_32 and READ_32 variants
> + */
> +static inline u32 transport_get_sectors_32(
> +	unsigned char *cdb,
> +	struct se_cmd *cmd,
> +	int *ret)
> +{
> +	/*
> +	 * Assume TYPE_DISK for non struct se_device objects.
> +	 * Use 32-bit sector value.
> +	 */
> +	return (u32)(cdb[28] << 24) + (cdb[29] << 16) +
> +		    (cdb[30] << 8) + cdb[31];
> +

get_unaligned_be32

> +}
> +
>  static inline u32 transport_get_size(
>  	u32 sectors,
>  	unsigned char *cdb,
> @@ -7496,7 +7529,8 @@ u32 transport_generic_get_cdb_count(
>  
>  		cdb = TRANSPORT(dev)->get_cdb(task);
>  		if ((cdb)) {
> -			memcpy(cdb, T_TASK(cmd)->t_task_cdb, MAX_COMMAND_SIZE);
> +			memcpy(cdb, T_TASK(cmd)->t_task_cdb,
> +				scsi_command_size(T_TASK(cmd)->t_task_cdb));
>  			cmd->transport_split_cdb(task->task_lba,
>  					&task->task_sectors, cdb);
>  		}
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 97e9715..eb0a228 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -17,6 +17,19 @@
>  /* Maximum Number of LUNs per Target Portal Group */
>  #define TRANSPORT_MAX_LUNS_PER_TPG		256
>  /*
> + * By default we use 32-byte CDBs in TCM Core and subsystem plugin code.
> + *
> + * Note that both include/scsi/scsi_cmnd.h:MAX_COMMAND_SIZE and
> + * include/linux/blkdev.h:BLOCK_MAX_CDB as of v2.6.36-rc4 still use
> + * 16-byte CDBs by default and require an extra allocation for
> + * 32-byte CDBs to becasue of legacy issues.
> + *
> + * Within TCM Core there are no such legacy limitiations, so we go ahead
> + * use 32-byte CDBs by default and use include/scsi/scsi.h:scsi_command_size()
> + * within all TCM Core and subsystem plugin code.
> + */
> +#define TCM_MAX_COMMAND_SIZE			32
> +/*
>   * From include/scsi/scsi_cmnd.h:SCSI_SENSE_BUFFERSIZE, currently
>   * defined 96, but the real limit is 252 (or 260 including the header)
>   */

