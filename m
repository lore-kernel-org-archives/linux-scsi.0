From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 4/5] scsi_debug: change SCSI command parser to table
 driven
Date: Tue, 25 Nov 2014 11:08:03 -0500
Message-ID: <5474A963.2030006@interlog.com>
References: <5474000A.2030501@interlog.com> <1416928359.2194.23.camel@HansenPartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44344 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaKYQIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 11:08:25 -0500
In-Reply-To: <1416928359.2194.23.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>

On 14-11-25 10:12 AM, James Bottomley wrote:
> On Mon, 2014-11-24 at 23:05 -0500, Douglas Gilbert wrote:
>> From: Douglas Gilbert <dgilbert@interlog.com>
>> Date: Mon, 24 Nov 2014 20:46:29 -0500
>> Subject: [PATCH 4/5] change SCSI command parser to table driven
>>
>> The existing 'big switch' parser in queuecommand() is changed to
>> a table driven parser. The old and new queuecommand() were moved
>> in the source so diff would not shuffle them. Apart from the new
>> tables most other changes are refactoring existing response code
>> to be more easily called out of the table parser. The 'strict'
>> parameter is added so that cdb_s can be checked for non-zero
>> values in parts of the cdb that are reserved. Some other changes
>> include: tweak request sense response when D_SENSE differs; support
>> NDOB in Write Same(16); and fix crash in Get LBA Status when LBP
>> was inactive.
>> ---
>>    drivers/scsi/scsi_debug.c | 1391 +++++++++++++++++++++++++++------------------
>>    1 file changed, 833 insertions(+), 558 deletions(-)
>
> There's a massive amount of apparently unnecessary code motion in this
> patch (like moving the whole of scsi_debug_queuecommand).  This caused a
> reject today on the merger of the drivers-for-3.19 with core-for-3.19
> (conflict with the queue depth reason elimination). Can we not do large
> pieces of code motion unless there's good reason.

I was asked to break up the code to make it easier to
review. The critical part of this chunk was the replacement
of the big switch in queuecommand() with a table driven
version. Without that move, the diff (both in git and by hand)
shuffles the two versions of queuecommand() in such a way
that I cannot even understand what is going on (and I wrote
half of the old one and all of the new one).

There are two audiences to a presented patch: those who
might review it (and Hannes has been the only volunteer
to date) and those that might apply it after it is
reviewed. Until today, I was still at the first hurdle.

Is there a way to tell (git) diff not to shuffle the old and
new versions of a function? Would changing the name of the
new version have helped (e.g. qcommand() )?

> Perhaps, also, it's time to reconsider whether we do actually need a
> core and drivers branch separation.

I did a git pull on the drivers-for-3.19 just before I
built this patch. That caused conflict due to the queue
depth reason elimination so I rebuilt my patch. The kernel
was then built as every chunk was applied. Not every step
was tested (i.e. kernel was not run) but the end result
is what was presented a month ago and tested then (modulo
changes in drivers-for-3.19 since then).

> The merge was trivial but I've attached it below, just in case.

I don't understand the patch below. It seems to add
back the old, big-switch parser. That will set up a conflict
with the new one which has the same function signature.

Doug Gilbert

> commit 5055a627a05df34f88265095cdf5da01b2b22a7a
> Merge: 7ec0579 38d5c83
> Author: James Bottomley <JBottomley@Parallels.com>
> Date:   Tue Nov 25 06:54:28 2014 -0800
>
>      Merge remote-tracking branch 'scsi-queue/drivers-for-3.19' into for-next
>
>      Conflicts:
>      	drivers/scsi/scsi_debug.c
>
> diff --cc drivers/scsi/scsi_debug.c
> index 378e0aa,aa4b6b8..6183419
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@@ -4083,396 -4957,9 +4957,394 @@@ static void sdebug_remove_adapter(void
>    }
>
>    static int
>   +scsi_debug_queuecommand(struct scsi_cmnd *SCpnt)
>   +{
>   +	unsigned char *cmd = SCpnt->cmnd;
>   +	int len, k;
>   +	unsigned int num;
>   +	unsigned long long lba;
>   +	u32 ei_lba;
>   +	int errsts = 0;
>   +	int target = SCpnt->device->id;
>   +	struct sdebug_dev_info *devip = NULL;
>   +	int inj_recovered = 0;
>   +	int inj_transport = 0;
>   +	int inj_dif = 0;
>   +	int inj_dix = 0;
>   +	int inj_short = 0;
>   +	int delay_override = 0;
>   +	int unmap = 0;
>   +
>   +	scsi_set_resid(SCpnt, 0);
>   +	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) &&
>   +	    !(SCSI_DEBUG_OPT_NO_CDB_NOISE & scsi_debug_opts)) {
>   +		char b[120];
>   +		int n;
>   +
>   +		len = SCpnt->cmd_len;
>   +		if (len > 32)
>   +			strcpy(b, "too long, over 32 bytes");
>   +		else {
>   +			for (k = 0, n = 0; k < len; ++k)
>   +				n += scnprintf(b + n, sizeof(b) - n, "%02x ",
>   +					       (unsigned int)cmd[k]);
>   +		}
>   +		sdev_printk(KERN_INFO, SCpnt->device, "%s: cmd %s\n", my_name,
>   +			    b);
>   +	}
>   +
>   +	if ((SCpnt->device->lun >= scsi_debug_max_luns) &&
>   +	    (SCpnt->device->lun != SAM2_WLUN_REPORT_LUNS))
>   +		return schedule_resp(SCpnt, NULL, DID_NO_CONNECT << 16, 0);
>   +	devip = devInfoReg(SCpnt->device);
>   +	if (NULL == devip)
>   +		return schedule_resp(SCpnt, NULL, DID_NO_CONNECT << 16, 0);
>   +
>   +	if ((scsi_debug_every_nth != 0) &&
>   +	    (atomic_inc_return(&sdebug_cmnd_count) >=
>   +	     abs(scsi_debug_every_nth))) {
>   +		atomic_set(&sdebug_cmnd_count, 0);
>   +		if (scsi_debug_every_nth < -1)
>   +			scsi_debug_every_nth = -1;
>   +		if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
>   +			return 0; /* ignore command causing timeout */
>   +		else if (SCSI_DEBUG_OPT_MAC_TIMEOUT & scsi_debug_opts &&
>   +			 scsi_medium_access_command(SCpnt))
>   +			return 0; /* time out reads and writes */
>   +		else if (SCSI_DEBUG_OPT_RECOVERED_ERR & scsi_debug_opts)
>   +			inj_recovered = 1; /* to reads and writes below */
>   +		else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & scsi_debug_opts)
>   +			inj_transport = 1; /* to reads and writes below */
>   +		else if (SCSI_DEBUG_OPT_DIF_ERR & scsi_debug_opts)
>   +			inj_dif = 1; /* to reads and writes below */
>   +		else if (SCSI_DEBUG_OPT_DIX_ERR & scsi_debug_opts)
>   +			inj_dix = 1; /* to reads and writes below */
>   +		else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & scsi_debug_opts)
>   +			inj_short = 1;
>   +	}
>   +
>   +	if (devip->wlun) {
>   +		switch (*cmd) {
>   +		case INQUIRY:
>   +		case REQUEST_SENSE:
>   +		case TEST_UNIT_READY:
>   +		case REPORT_LUNS:
>   +			break;  /* only allowable wlun commands */
>   +		default:
>   +			if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
>   +				printk(KERN_INFO "scsi_debug: Opcode: 0x%x "
>   +				       "not supported for wlun\n", *cmd);
>   +			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +					INVALID_OPCODE, 0);
>   +			errsts = check_condition_result;
>   +			return schedule_resp(SCpnt, devip, errsts, 0);
>   +		}
>   +	}
>   +
>   +	switch (*cmd) {
>   +	case INQUIRY:     /* mandatory, ignore unit attention */
>   +		delay_override = 1;
>   +		errsts = resp_inquiry(SCpnt, target, devip);
>   +		break;
>   +	case REQUEST_SENSE:	/* mandatory, ignore unit attention */
>   +		delay_override = 1;
>   +		errsts = resp_requests(SCpnt, devip);
>   +		break;
>   +	case REZERO_UNIT:	/* actually this is REWIND for SSC */
>   +	case START_STOP:
>   +		errsts = resp_start_stop(SCpnt, devip);
>   +		break;
>   +	case ALLOW_MEDIUM_REMOVAL:
>   +		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
>   +		if (errsts)
>   +			break;
>   +		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
>   +			printk(KERN_INFO "scsi_debug: Medium removal %s\n",
>   +			       cmd[4] ? "inhibited" : "enabled");
>   +		break;
>   +	case SEND_DIAGNOSTIC:     /* mandatory */
>   +		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
>   +		break;
>   +	case TEST_UNIT_READY:     /* mandatory */
>   +		/* delay_override = 1; */
>   +		errsts = check_readiness(SCpnt, UAS_TUR, devip);
>   +		break;
>   +	case RESERVE:
>   +		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
>   +		break;
>   +	case RESERVE_10:
>   +		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
>   +		break;
>   +	case RELEASE:
>   +		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
>   +		break;
>   +	case RELEASE_10:
>   +		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
>   +		break;
>   +	case READ_CAPACITY:
>   +		errsts = resp_readcap(SCpnt, devip);
>   +		break;
>   +	case SERVICE_ACTION_IN_16:
>   +		if (cmd[1] == SAI_READ_CAPACITY_16)
>   +			errsts = resp_readcap16(SCpnt, devip);
>   +		else if (cmd[1] == SAI_GET_LBA_STATUS) {
>   +
>   +			if (scsi_debug_lbp() == 0) {
>   +				mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +						INVALID_COMMAND_OPCODE, 0);
>   +				errsts = check_condition_result;
>   +			} else
>   +				errsts = resp_get_lba_status(SCpnt, devip);
>   +		} else {
>   +			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +					INVALID_OPCODE, 0);
>   +			errsts = check_condition_result;
>   +		}
>   +		break;
>   +	case MAINTENANCE_IN:
>   +		if (MI_REPORT_TARGET_PGS != cmd[1]) {
>   +			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +					INVALID_OPCODE, 0);
>   +			errsts = check_condition_result;
>   +			break;
>   +		}
>   +		errsts = resp_report_tgtpgs(SCpnt, devip);
>   +		break;
>   +	case READ_16:
>   +	case READ_12:
>   +	case READ_10:
>   +		/* READ{10,12,16} and DIF Type 2 are natural enemies */
>   +		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
>   +		    cmd[1] & 0xe0) {
>   +			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +					INVALID_COMMAND_OPCODE, 0);
>   +			errsts = check_condition_result;
>   +			break;
>   +		}
>   +
>   +		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
>   +		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
>   +		    (cmd[1] & 0xe0) == 0)
>   +			printk(KERN_ERR "Unprotected RD/WR to DIF device\n");
>   +
>   +		/* fall through */
>   +	case READ_6:
>   +read:
>   +		errsts = check_readiness(SCpnt, UAS_TUR, devip);
>   +		if (errsts)
>   +			break;
>   +		if (scsi_debug_fake_rw)
>   +			break;
>   +		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
>   +
>   +		if (inj_short)
>   +			num /= 2;
>   +
>   +		errsts = resp_read(SCpnt, lba, num, ei_lba);
>   +		if (inj_recovered && (0 == errsts)) {
>   +			mk_sense_buffer(SCpnt, RECOVERED_ERROR,
>   +					THRESHOLD_EXCEEDED, 0);
>   +			errsts = check_condition_result;
>   +		} else if (inj_transport && (0 == errsts)) {
>   +			mk_sense_buffer(SCpnt, ABORTED_COMMAND,
>   +					TRANSPORT_PROBLEM, ACK_NAK_TO);
>   +			errsts = check_condition_result;
>   +		} else if (inj_dif && (0 == errsts)) {
>   +			/* Logical block guard check failed */
>   +			mk_sense_buffer(SCpnt, ABORTED_COMMAND, 0x10, 1);
>   +			errsts = illegal_condition_result;
>   +		} else if (inj_dix && (0 == errsts)) {
>   +			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, 0x10, 1);
>   +			errsts = illegal_condition_result;
>   +		}
>   +		break;
>   +	case REPORT_LUNS:	/* mandatory, ignore unit attention */
>   +		delay_override = 1;
>   +		errsts = resp_report_luns(SCpnt, devip);
>   +		break;
>   +	case VERIFY:		/* 10 byte SBC-2 command */
>   +		errsts = check_readiness(SCpnt, UAS_TUR, devip);
>   +		break;
>   +	case WRITE_16:
>   +	case WRITE_12:
>   +	case WRITE_10:
>   +		/* WRITE{10,12,16} and DIF Type 2 are natural enemies */
>   +		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
>   +		    cmd[1] & 0xe0) {
>   +			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +					INVALID_COMMAND_OPCODE, 0);
>   +			errsts = check_condition_result;
>   +			break;
>   +		}
>   +
>   +		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
>   +		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
>   +		    (cmd[1] & 0xe0) == 0)
>   +			printk(KERN_ERR "Unprotected RD/WR to DIF device\n");
>   +
>   +		/* fall through */
>   +	case WRITE_6:
>   +write:
>   +		errsts = check_readiness(SCpnt, UAS_TUR, devip);
>   +		if (errsts)
>   +			break;
>   +		if (scsi_debug_fake_rw)
>   +			break;
>   +		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
>   +		errsts = resp_write(SCpnt, lba, num, ei_lba);
>   +		if (inj_recovered && (0 == errsts)) {
>   +			mk_sense_buffer(SCpnt, RECOVERED_ERROR,
>   +					THRESHOLD_EXCEEDED, 0);
>   +			errsts = check_condition_result;
>   +		} else if (inj_dif && (0 == errsts)) {
>   +			mk_sense_buffer(SCpnt, ABORTED_COMMAND, 0x10, 1);
>   +			errsts = illegal_condition_result;
>   +		} else if (inj_dix && (0 == errsts)) {
>   +			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, 0x10, 1);
>   +			errsts = illegal_condition_result;
>   +		}
>   +		break;
>   +	case WRITE_SAME_16:
>   +	case WRITE_SAME:
>   +		if (cmd[1] & 0x8) {
>   +			if ((*cmd == WRITE_SAME_16 && scsi_debug_lbpws == 0) ||
>   +			    (*cmd == WRITE_SAME && scsi_debug_lbpws10 == 0)) {
>   +				mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +						INVALID_FIELD_IN_CDB, 0);
>   +				errsts = check_condition_result;
>   +			} else
>   +				unmap = 1;
>   +		}
>   +		if (errsts)
>   +			break;
>   +		errsts = check_readiness(SCpnt, UAS_TUR, devip);
>   +		if (errsts)
>   +			break;
>   +		if (scsi_debug_fake_rw)
>   +			break;
>   +		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
>   +		errsts = resp_write_same(SCpnt, lba, num, ei_lba, unmap);
>   +		break;
>   +	case UNMAP:
>   +		errsts = check_readiness(SCpnt, UAS_TUR, devip);
>   +		if (errsts)
>   +			break;
>   +		if (scsi_debug_fake_rw)
>   +			break;
>   +
>   +		if (scsi_debug_unmap_max_desc == 0 || scsi_debug_lbpu == 0) {
>   +			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +					INVALID_COMMAND_OPCODE, 0);
>   +			errsts = check_condition_result;
>   +		} else
>   +			errsts = resp_unmap(SCpnt, devip);
>   +		break;
>   +	case MODE_SENSE:
>   +	case MODE_SENSE_10:
>   +		errsts = resp_mode_sense(SCpnt, target, devip);
>   +		break;
>   +	case MODE_SELECT:
>   +		errsts = resp_mode_select(SCpnt, 1, devip);
>   +		break;
>   +	case MODE_SELECT_10:
>   +		errsts = resp_mode_select(SCpnt, 0, devip);
>   +		break;
>   +	case LOG_SENSE:
>   +		errsts = resp_log_sense(SCpnt, devip);
>   +		break;
>   +	case SYNCHRONIZE_CACHE:
>   +		delay_override = 1;
>   +		errsts = check_readiness(SCpnt, UAS_TUR, devip);
>   +		break;
>   +	case WRITE_BUFFER:
>   +		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
>   +		break;
>   +	case XDWRITEREAD_10:
>   +		if (!scsi_bidi_cmnd(SCpnt)) {
>   +			mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +					INVALID_FIELD_IN_CDB, 0);
>   +			errsts = check_condition_result;
>   +			break;
>   +		}
>   +
>   +		errsts = check_readiness(SCpnt, UAS_TUR, devip);
>   +		if (errsts)
>   +			break;
>   +		if (scsi_debug_fake_rw)
>   +			break;
>   +		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
>   +		errsts = resp_read(SCpnt, lba, num, ei_lba);
>   +		if (errsts)
>   +			break;
>   +		errsts = resp_write(SCpnt, lba, num, ei_lba);
>   +		if (errsts)
>   +			break;
>   +		errsts = resp_xdwriteread(SCpnt, lba, num, devip);
>   +		break;
>   +	case VARIABLE_LENGTH_CMD:
>   +		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION) {
>   +
>   +			if ((cmd[10] & 0xe0) == 0)
>   +				printk(KERN_ERR
>   +				       "Unprotected RD/WR to DIF device\n");
>   +
>   +			if (cmd[9] == READ_32) {
>   +				BUG_ON(SCpnt->cmd_len < 32);
>   +				goto read;
>   +			}
>   +
>   +			if (cmd[9] == WRITE_32) {
>   +				BUG_ON(SCpnt->cmd_len < 32);
>   +				goto write;
>   +			}
>   +		}
>   +
>   +		mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +				INVALID_FIELD_IN_CDB, 0);
>   +		errsts = check_condition_result;
>   +		break;
>   +	case 0x85:
>   +		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
>   +			sdev_printk(KERN_INFO, SCpnt->device,
>   +			"%s: ATA PASS-THROUGH(16) not supported\n", my_name);
>   +		mk_sense_buffer(SCpnt, ILLEGAL_REQUEST,
>   +				INVALID_OPCODE, 0);
>   +		errsts = check_condition_result;
>   +		break;
>   +	default:
>   +		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
>   +			sdev_printk(KERN_INFO, SCpnt->device,
>   +				    "%s: Opcode: 0x%x not supported\n",
>   +				    my_name, *cmd);
>   +		errsts = check_readiness(SCpnt, UAS_ONLY, devip);
>   +		if (errsts)
>   +			break;	/* Unit attention takes precedence */
>   +		mk_sense_buffer(SCpnt, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
>   +		errsts = check_condition_result;
>   +		break;
>   +	}
>   +	return schedule_resp(SCpnt, devip, errsts,
>   +			     (delay_override ? 0 : scsi_debug_delay));
>   +}
>   +
>   +static int
>   +sdebug_queuecommand_lock_or_not(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>   +{
>   +	if (scsi_debug_host_lock) {
>   +		unsigned long iflags;
>   +		int rc;
>   +
>   +		spin_lock_irqsave(shost->host_lock, iflags);
>   +		rc = scsi_debug_queuecommand(cmd);
>   +		spin_unlock_irqrestore(shost->host_lock, iflags);
>   +		return rc;
>   +	} else
>   +		return scsi_debug_queuecommand(cmd);
>   +}
>   +
> - static int
> - sdebug_change_qdepth(struct scsi_device *sdev, int qdepth, int reason)
> + sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
>    {
>    	int num_in_q = 0;
> - 	int bad = 0;
>    	unsigned long iflags;
>    	struct sdebug_dev_info *devip;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

