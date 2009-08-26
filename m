From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 5/5] scsi_debug: Implement support for DIF Type 2
Date: Wed, 26 Aug 2009 15:40:52 +0300
Message-ID: <4A952D54.5010102@panasas.com>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com> <1251267481-24135-6-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-67.z220-152-67.customer.algx.net ([67.152.220.67]:52608
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932843AbZHZMkx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 08:40:53 -0400
In-Reply-To: <1251267481-24135-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, Ihab.Hamadi@emulex.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

On 08/26/2009 09:18 AM, Martin K. Petersen wrote:
> Add support for 32-byte READ/WRITE as well as DIF Type 2 protection.
> 
> Reject protected 10/12/16 byte READ/WRITE commands when Type 2 is
> enabled.
> 
> Verify Type 2 reference tag according to Expected Initial LBA in 32-byte
> CDB.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/scsi_debug.c |  135 +++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 112 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index fb9af20..f551ec3 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -50,6 +50,7 @@
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsicam.h>
>  #include <scsi/scsi_eh.h>
> +#include <scsi/scsi_dbg.h>
>  
>  #include "sd.h"
>  #include "scsi_logging.h"
> @@ -64,6 +65,7 @@ static const char * scsi_debug_version_date = "20070104";
>  #define PARAMETER_LIST_LENGTH_ERR 0x1a
>  #define INVALID_OPCODE 0x20
>  #define ADDR_OUT_OF_RANGE 0x21
> +#define INVALID_COMMAND_OPCODE 0x20
>  #define INVALID_FIELD_IN_CDB 0x24
>  #define INVALID_FIELD_IN_PARAM_LIST 0x26
>  #define POWERON_RESET 0x29
> @@ -180,7 +182,7 @@ static int sdebug_sectors_per;		/* sectors per cylinder */
>  #define SDEBUG_SENSE_LEN 32
>  
>  #define SCSI_DEBUG_CANQUEUE  255
> -#define SCSI_DEBUG_MAX_CMD_LEN 16
> +#define SCSI_DEBUG_MAX_CMD_LEN 32
>  
>  struct sdebug_dev_info {
>  	struct list_head dev_list;
> @@ -296,9 +298,25 @@ static void mk_sense_buffer(struct sdebug_dev_info *devip, int key,
>  }
>  
>  static void get_data_transfer_info(unsigned char *cmd,
> -				   unsigned long long *lba, unsigned int *num)
> +				   unsigned long long *lba, unsigned int *num,
> +				   u32 *ei_lba)
>  {
> +	*ei_lba = 0;
> +
>  	switch (*cmd) {
> +	case VARIABLE_LENGTH_CMD:
> +		*lba = (u64)cmd[19] | (u64)cmd[18] << 8 |
> +			(u64)cmd[17] << 16 | (u64)cmd[16] << 24 |
> +			(u64)cmd[15] << 32 | (u64)cmd[14] << 40 |
> +			(u64)cmd[13] << 48 | (u64)cmd[12] << 56;
> +

get_unaligned_be64()

> +		*ei_lba = (u32)cmd[23] | (u32)cmd[22] << 8 |
> +			(u32)cmd[21] << 16 | (u32)cmd[20] << 24;
> +

be32_to_cpup()

> +		*num = (u32)cmd[31] | (u32)cmd[30] << 8 | (u32)cmd[29] << 16 |
> +			(u32)cmd[28] << 24;

be32_to_cpup()

On some arches, above code will produce 96 assembly instructions as opossed to
a single MOV. I understand that the old code is full of this crap, but "new code"?

I know I could never blasphem like that. As if you are not proud of being a programmer

> +		break;
> +
>  	case WRITE_16:
>  	case READ_16:
>  		*lba = (u64)cmd[9] | (u64)cmd[8] << 8 |
> @@ -1589,7 +1607,7 @@ static int do_device_access(struct scsi_cmnd *scmd,
>  }
>  
>  static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
> -			    unsigned int sectors)
> +			    unsigned int sectors, u32 ei_lba)
>  {
>  	unsigned int i, resid;
>  	struct scatterlist *psgl;
> @@ -1636,13 +1654,23 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
>  			return 0x01;
>  		}
>  
> -		if (scsi_debug_dif != SD_DIF_TYPE3_PROTECTION &&
> +		if (scsi_debug_dif == SD_DIF_TYPE1_PROTECTION &&
>  		    be32_to_cpu(sdt[i].ref_tag) != (sector & 0xffffffff)) {
>  			printk(KERN_ERR "%s: REF check failed on sector %lu\n",
>  			       __func__, (unsigned long)sector);
>  			dif_errors++;
>  			return 0x03;
>  		}
> +
> +		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
> +		    be32_to_cpu(sdt[i].ref_tag) != ei_lba) {

Here you do it right

> +			printk(KERN_ERR "%s: REF check failed on sector %lu\n",
> +			       __func__, (unsigned long)sector);
> +			dif_errors++;
> +			return 0x03;
> +		}
> +
> +		ei_lba++;
>  	}
>  
>  	resid = sectors * 8; /* Bytes of protection data to copy into sgl */
> @@ -1670,7 +1698,8 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
>  }
>  
>  static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
> -		     unsigned int num, struct sdebug_dev_info *devip)
> +		     unsigned int num, struct sdebug_dev_info *devip,
> +		     u32 ei_lba)
>  {
>  	unsigned long iflags;
>  	int ret;
> @@ -1699,7 +1728,7 @@ static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
>  
>  	/* DIX + T10 DIF */
>  	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
> -		int prot_ret = prot_verify_read(SCpnt, lba, num);
> +		int prot_ret = prot_verify_read(SCpnt, lba, num, ei_lba);
>  
>  		if (prot_ret) {
>  			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, prot_ret);
> @@ -1735,7 +1764,7 @@ void dump_sector(unsigned char *buf, int len)
>  }
>  
>  static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
> -			     unsigned int sectors)
> +			     unsigned int sectors, u32 ei_lba)
>  {
>  	int i, j, ret;
>  	struct sd_dif_tuple *sdt;
> @@ -1749,11 +1778,6 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
>  
>  	sector = do_div(tmp_sec, sdebug_store_sectors);
>  
> -	if (((SCpnt->cmnd[1] >> 5) & 7) != 1) {
> -		printk(KERN_WARNING "scsi_debug: WRPROTECT != 1\n");
> -		return 0;
> -	}
> -
>  	BUG_ON(scsi_sg_count(SCpnt) == 0);
>  	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
>  
> @@ -1808,7 +1832,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
>  				goto out;
>  			}
>  
> -			if (scsi_debug_dif != SD_DIF_TYPE3_PROTECTION &&
> +			if (scsi_debug_dif == SD_DIF_TYPE1_PROTECTION &&
>  			    be32_to_cpu(sdt->ref_tag)
>  			    != (start_sec & 0xffffffff)) {
>  				printk(KERN_ERR
> @@ -1819,6 +1843,16 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
>  				goto out;
>  			}
>  
> +			if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
> +			    be32_to_cpu(sdt->ref_tag) != ei_lba) {
> +				printk(KERN_ERR
> +				       "%s: REF check failed on sector %lu\n",
> +				       __func__, (unsigned long)sector);
> +				ret = 0x03;
> +				dump_sector(daddr, scsi_debug_sector_size);
> +				goto out;
> +			}
> +
>  			/* Would be great to copy this in bigger
>  			 * chunks.  However, for the sake of
>  			 * correctness we need to verify each sector
> @@ -1832,6 +1866,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
>  				sector = 0;	/* Force wrap */
>  
>  			start_sec++;
> +			ei_lba++;
>  			daddr += scsi_debug_sector_size;
>  			ppage_offset += sizeof(struct sd_dif_tuple);
>  		}
> @@ -1853,7 +1888,8 @@ out:
>  }
>  
>  static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
> -		      unsigned int num, struct sdebug_dev_info *devip)
> +		      unsigned int num, struct sdebug_dev_info *devip,
> +		      u32 ei_lba)
>  {
>  	unsigned long iflags;
>  	int ret;
> @@ -1864,7 +1900,7 @@ static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
>  
>  	/* DIX + T10 DIF */
>  	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
> -		int prot_ret = prot_verify_write(SCpnt, lba, num);
> +		int prot_ret = prot_verify_write(SCpnt, lba, num, ei_lba);
>  
>  		if (prot_ret) {
>  			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, prot_ret);
> @@ -2872,11 +2908,12 @@ static int __init scsi_debug_init(void)
>  
>  	case SD_DIF_TYPE0_PROTECTION:
>  	case SD_DIF_TYPE1_PROTECTION:
> +	case SD_DIF_TYPE2_PROTECTION:
>  	case SD_DIF_TYPE3_PROTECTION:
>  		break;
>  
>  	default:
> -		printk(KERN_ERR "scsi_debug_init: dif must be 0, 1 or 3\n");
> +		printk(KERN_ERR "scsi_debug_init: dif must be 0, 1, 2 or 3\n");
>  		return -EINVAL;
>  	}
>  
> @@ -3121,6 +3158,7 @@ int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
>  	int len, k;
>  	unsigned int num;
>  	unsigned long long lba;
> +	u32 ei_lba;
>  	int errsts = 0;
>  	int target = SCpnt->device->id;
>  	struct sdebug_dev_info *devip = NULL;
> @@ -3254,14 +3292,30 @@ int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
>  	case READ_16:
>  	case READ_12:
>  	case READ_10:
> +		/* READ{10,12,16} and DIF Type 2 are natural enemies */
> +		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
> +		    cmd[1] & 0xe0) {
> +			mk_sense_buffer(devip, ILLEGAL_REQUEST,
> +					INVALID_COMMAND_OPCODE, 0);
> +			errsts = check_condition_result;
> +			break;
> +		}
> +
> +		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
> +		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
> +		    (cmd[1] & 0xe0) == 0)
> +			printk(KERN_ERR "Unprotected RD/WR to DIF device\n");
> +
> +		/* fall through */
>  	case READ_6:
> +read:
>  		errsts = check_readiness(SCpnt, 0, devip);
>  		if (errsts)
>  			break;
>  		if (scsi_debug_fake_rw)
>  			break;
> -		get_data_transfer_info(cmd, &lba, &num);
> -		errsts = resp_read(SCpnt, lba, num, devip);
> +		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
> +		errsts = resp_read(SCpnt, lba, num, devip, ei_lba);
>  		if (inj_recovered && (0 == errsts)) {
>  			mk_sense_buffer(devip, RECOVERED_ERROR,
>  					THRESHOLD_EXCEEDED, 0);
> @@ -3288,14 +3342,30 @@ int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
>  	case WRITE_16:
>  	case WRITE_12:
>  	case WRITE_10:
> +		/* WRITE{10,12,16} and DIF Type 2 are natural enemies */
> +		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
> +		    cmd[1] & 0xe0) {
> +			mk_sense_buffer(devip, ILLEGAL_REQUEST,
> +					INVALID_COMMAND_OPCODE, 0);
> +			errsts = check_condition_result;
> +			break;
> +		}
> +
> +		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
> +		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
> +		    (cmd[1] & 0xe0) == 0)
> +			printk(KERN_ERR "Unprotected RD/WR to DIF device\n");
> +
> +		/* fall through */
>  	case WRITE_6:
> +write:
>  		errsts = check_readiness(SCpnt, 0, devip);
>  		if (errsts)
>  			break;
>  		if (scsi_debug_fake_rw)
>  			break;
> -		get_data_transfer_info(cmd, &lba, &num);
> -		errsts = resp_write(SCpnt, lba, num, devip);
> +		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
> +		errsts = resp_write(SCpnt, lba, num, devip, ei_lba);
>  		if (inj_recovered && (0 == errsts)) {
>  			mk_sense_buffer(devip, RECOVERED_ERROR,
>  					THRESHOLD_EXCEEDED, 0);
> @@ -3341,15 +3411,34 @@ int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
>  			break;
>  		if (scsi_debug_fake_rw)
>  			break;
> -		get_data_transfer_info(cmd, &lba, &num);
> -		errsts = resp_read(SCpnt, lba, num, devip);
> +		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
> +		errsts = resp_read(SCpnt, lba, num, devip, ei_lba);
>  		if (errsts)
>  			break;
> -		errsts = resp_write(SCpnt, lba, num, devip);
> +		errsts = resp_write(SCpnt, lba, num, devip, ei_lba);
>  		if (errsts)
>  			break;
>  		errsts = resp_xdwriteread(SCpnt, lba, num, devip);
>  		break;
> +	case VARIABLE_LENGTH_CMD:
> +		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION) {
> +
> +			if ((cmd[10] & 0xe0) == 0)
> +				printk(KERN_ERR
> +				       "Unprotected RD/WR to DIF device\n");
> +
> +			if (cmd[9] == READ_32)
> +				goto read;
> +
> +			if (cmd[9] == WRITE_32)
> +				goto write;
> +		}
> +
> +		mk_sense_buffer(devip, ILLEGAL_REQUEST,
> +				INVALID_FIELD_IN_CDB, 0);
> +		errsts = check_condition_result;
> +		break;
> +
>  	default:
>  		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
>  			printk(KERN_INFO "scsi_debug: Opcode: 0x%x not "

Boaz
