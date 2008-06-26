From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 6/9] scsi_dh: add generic SPC-3 alua handler
Date: Thu, 26 Jun 2008 18:22:34 -0500
Message-ID: <486424BA.8040301@cs.wisc.edu>
References: <20080624100504.7D8C210B5DE@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52938 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYFZXWq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2008 19:22:46 -0400
In-Reply-To: <20080624100504.7D8C210B5DE@craiglockhart-ipmi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> +
> +static struct request *get_alua_req(struct scsi_device *sdev,
> +				    void *buffer, unsigned buflen, int rw)
> +{
> +	struct request *rq;
> +	struct request_queue *q = sdev->request_queue;
> +
> +	rq = blk_get_request(q, rw, GFP_KERNEL);
> +
> +	if (!rq) {
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: blk_get_request failed\n", __FUNCTION__);
> +		return NULL;
> +	}
> +
> +	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_KERNEL)) {
> +		blk_put_request(rq);
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: blk_rq_map_kern failed\n", __FUNCTION__);
> +		return NULL;
> +	}
> +
> +	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> +	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
> +	rq->retries = ALUA_FAILOVER_RETRIES;
> +	rq->timeout = ALUA_FAILOVER_TIMEOUT;
> +
> +	return rq;
> +}


It looks like this can be called from alua_activate, and we cannot use 
GFP_KERNEL in the same IO path something could get written to.



> +/*
> + * submit_std_inquiry - Issue a standard INQUIRY command
> + * @sdev: sdev the command should be send to
> + */
> +static int submit_std_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
> +{
> +	struct request *rq;
> +	int err = SCSI_DH_RES_TEMP_UNAVAIL;
> +
> +	rq = get_alua_req(sdev, h->inq, ALUA_INQUIRY_SIZE, READ);
> +	if (!rq)
> +		goto done;
> +
> +	/* Prepare the command. */
> +	rq->cmd[0] = INQUIRY;
> +	rq->cmd[1] = 0;
> +	rq->cmd[2] = 0;
> +	rq->cmd[4] = ALUA_INQUIRY_SIZE;
> +	rq->cmd_len = COMMAND_SIZE(INQUIRY);
> +
> +	rq->sense = h->sense;
> +	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> +	rq->sense_len = h->senselen = 0;
> +
> +	err = blk_execute_rq(rq->q, NULL, rq, 1);
> +	if (err == -EIO) {
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: std inquiry failed with %x\n",
> +			    ALUA_DH_NAME, rq->errors);
> +		h->senselen = rq->sense_len;
> +		err = SCSI_DH_IO;
> +	}
> +	blk_put_request(rq);
> +done:
> +	return err;
> +}
> +
> +/*
> + * submit_vpd_inquiry - Issue an INQUIRY VPD page 0x83 command
> + * @sdev: sdev the command should be sent to
> + */
> +static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
> +{
> +	struct request *rq;
> +	int err = SCSI_DH_RES_TEMP_UNAVAIL;
> +
> +	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
> +	if (!rq)
> +		goto done;
> +
> +	/* Prepare the command. */
> +	rq->cmd[0] = INQUIRY;
> +	rq->cmd[1] = 1;
> +	rq->cmd[2] = 0x83;
> +	rq->cmd[4] = h->bufflen;
> +	rq->cmd_len = COMMAND_SIZE(INQUIRY);
> +
> +	rq->sense = h->sense;
> +	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> +	rq->sense_len = h->senselen = 0;
> +
> +	err = blk_execute_rq(rq->q, NULL, rq, 1);
> +	if (err == -EIO) {
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: evpd inquiry failed with %x\n",
> +			    ALUA_DH_NAME, rq->errors);
> +		h->senselen = rq->sense_len;
> +		err = SCSI_DH_IO;
> +	}
> +	blk_put_request(rq);
> +done:
> +	return err;
> +}
> +
> +/*
> + * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
> + * @sdev: sdev the command should be sent to
> + */
> +static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
> +{
> +	struct request *rq;
> +	int err = SCSI_DH_RES_TEMP_UNAVAIL;
> +
> +	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
> +	if (!rq)
> +		goto done;
> +
> +	/* Prepare the command. */
> +	rq->cmd[0] = MAINTENANCE_IN;
> +	rq->cmd[1] = MI_REPORT_TARGET_PGS;
> +	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
> +	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
> +	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
> +	rq->cmd[9] = h->bufflen & 0xff;
> +	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
> +
> +	rq->sense = h->sense;
> +	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> +	rq->sense_len = h->senselen = 0;
> +
> +	err = blk_execute_rq(rq->q, NULL, rq, 1);
> +	if (err == -EIO) {
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: rtpg failed with %x\n",
> +			    ALUA_DH_NAME, rq->errors);
> +		h->senselen = rq->sense_len;
> +		err = SCSI_DH_IO;
> +	}
> +	blk_put_request(rq);
> +done:
> +	return err;
> +}
> +
> +/*
> + * submit_stpg - Issue a SET TARGET GROUP STATES command
> + * @sdev: sdev the command should be sent to
> + *
> + * Currently we're only setting the current target port group state
> + * to 'active/optimized' and let the array firmware figure out
> + * the states of the remaining groups.
> + */
> +static unsigned submit_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
> +{
> +	struct request *rq;
> +	int err = SCSI_DH_RES_TEMP_UNAVAIL;
> +	int stpg_len = 8;
> +
> +	/* Prepare the data buffer */
> +	memset(h->buff, 0, stpg_len);
> +	h->buff[4] = TPGS_STATE_OPTIMIZED & 0x0f;
> +	h->buff[6] = (h->group_id >> 8) & 0x0f;
> +	h->buff[7] = h->group_id & 0x0f;
> +
> +	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
> +	if (!rq)
> +		goto done;
> +
> +	/* Prepare the command. */
> +	rq->cmd[0] = MAINTENANCE_OUT;
> +	rq->cmd[1] = MO_SET_TARGET_PGS;
> +	rq->cmd[6] = (stpg_len >> 24) & 0xff;
> +	rq->cmd[7] = (stpg_len >> 16) & 0xff;
> +	rq->cmd[8] = (stpg_len >>  8) & 0xff;
> +	rq->cmd[9] = stpg_len & 0xff;
> +	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
> +
> +	rq->sense = h->sense;
> +	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> +	rq->sense_len = h->senselen = 0;
> +
> +	err = blk_execute_rq(rq->q, NULL, rq, 1);
> +	if (err == -EIO) {
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: stpg failed with %x\n",
> +			    ALUA_DH_NAME, rq->errors);
> +		h->senselen = rq->sense_len;
> +		err = SCSI_DH_IO;
> +	}
> +	blk_put_request(rq);
> +done:
> +	return err;
> +}
> +
> +/*
> + * alua_std_inquiry - Evaluate standard INQUIRY command
> + * @sdev: device to be checked
> + *
> + * Just extract the TPGS setting to find out if ALUA
> + * is supported.
> + */
> +static int alua_std_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
> +{
> +	int err;
> +
> +	err = submit_std_inquiry(sdev, h);
> +

You could remove the space so it looks like the other code.


> +	if (err != SCSI_DH_OK)
> +		return err;
> +
> +	/* Check TPGS setting */
> +	h->tpgs = (h->inq[5] >> 4) & 0x3;
> +	switch (h->tpgs) {
> +	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: supports implicit and explicit TPGS\n",
> +			    ALUA_DH_NAME);
> +		break;
> +	case TPGS_MODE_EXPLICIT:
> +		sdev_printk(KERN_INFO, sdev, "%s: supports explicit TPGS\n",
> +			    ALUA_DH_NAME);
> +		break;
> +	case TPGS_MODE_IMPLICIT:
> +		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
> +			    ALUA_DH_NAME);
> +		break;
> +	default:
> +		h->tpgs = TPGS_MODE_NONE;
> +		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
> +			    ALUA_DH_NAME);
> +		err = SCSI_DH_DEV_UNSUPP;
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +/*
> + * alua_vpd_inquiry - Evaluate INQUIRY vpd page 0x83
> + * @sdev: device to be checked
> + *
> + * Extract the relative target port and the target port group
> + * descriptor from the list of identificators.
> + */
> +static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
> +{
> +	int len;
> +	unsigned err;
> +	unsigned char *d;
> +
> + retry:
> +	err = submit_vpd_inquiry(sdev, h);
> +
> +	if (err != SCSI_DH_OK)
> +		return err;
> +
> +	/* Check if vpd page exceeds initial buffer */
> +	len = (h->buff[2] << 8) + h->buff[3] + 4;
> +	if (len > h->bufflen) {
> +		/* Resubmit with the correct length */
> +		if (realloc_buffer(h, len)) {
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "%s: kmalloc buffer failed\n",
> +				    ALUA_DH_NAME);
> +			/* Temporary failure, bypass */
> +			return SCSI_DH_DEV_TEMP_BUSY;
> +		}
> +		goto retry;
> +	}
> +
> +	/*
> +	 * Now look for the correct descriptor.
> +	 */
> +	d = h->buff + 4;
> +	while (d < h->buff + len) {
> +		switch (d[1] & 0xf) {
> +		case 0x4:
> +			/* Relative target port */
> +			h->rel_port = (d[6] << 8) + d[7];
> +			break;
> +		case 0x5:
> +			/* Target port group */
> +			h->group_id = (d[6] << 8) + d[7];
> +			break;
> +		default:
> +			break;
> +		}
> +		d += d[3] + 4;
> +	}
> +
> +	if (h->group_id == -1) {
> +		/*
> +		 * Internal error; TPGS supported but required
> +		 * VPD identification descriptors not present.
> +		 * Disable ALUA support
> +		 */
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: No target port descriptors found\n",
> +			    ALUA_DH_NAME);
> +		h->state = TPGS_STATE_OPTIMIZED;
> +		h->tpgs = TPGS_MODE_NONE;
> +		err = SCSI_DH_DEV_UNSUPP;
> +	} else {
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: port group %02x rel port %02x\n",
> +			    ALUA_DH_NAME, h->group_id, h->rel_port);
> +	}
> +
> +	return err;
> +}
> +
> +static char print_alua_state(int state)
> +{
> +	switch (state) {
> +	case TPGS_STATE_OPTIMIZED:
> +		return 'A';
> +	case TPGS_STATE_NONOPTIMIZED:
> +		return 'N';
> +	case TPGS_STATE_STANDBY:
> +		return 'S';
> +	case TPGS_STATE_UNAVAILABLE:
> +		return 'U';
> +	case TPGS_STATE_OFFLINE:
> +		return 'O';
> +	case TPGS_STATE_TRANSITIONING:
> +		return 'T';
> +	default:
> +		return 'X';
> +	}
> +}
> +
> +static int alua_check_sense(struct scsi_device *sdev,
> +			    struct scsi_sense_hdr *sense_hdr)
> +{
> +	switch (sense_hdr->sense_key) {
> +	case NOT_READY:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)
> +			/*
> +			 * LUN Not Accessible - ALUA state transition
> +			 */
> +			return NEEDS_RETRY;
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0b)
> +			/*
> +			 * LUN Not Accessible -- Target port in standby state
> +			 */
> +			return SUCCESS;
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0c)
> +			/*
> +			 * LUN Not Accessible -- Target port in unavailable state
> +			 */
> +			return SUCCESS;
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x12)
> +			/*
> +			 * LUN Not Ready -- Offline
> +			 */
> +			return SUCCESS;
> +		break;
> +	case UNIT_ATTENTION:
> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
> +			/*
> +			 * Power On, Reset, or Bus Device Reset, just retry.
> +			 */
> +			return NEEDS_RETRY;
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
> +			/*
> +			 * ALUA state changed
> +			 */
> +			return NEEDS_RETRY;
> +		}
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
> +			/*
> +			 * Implicit ALUA state transition failed
> +			 */
> +			return NEEDS_RETRY;
> +		}
> +		break;
> +	}
> +
> +	return SCSI_RETURN_NOT_HANDLED;
> +}
> +
> +/*
> + * alua_stpg - Evaluate SET TARGET GROUP STATES
> + * @sdev: the device to be evaluated
> + * @state: the new target group state
> + *
> + * Send a SET TARGET GROUP STATES command to the device.
> + * We only have to test here if we should resubmit the command;
> + * any other error is assumed as a failure.
> + */
> +static int alua_stpg(struct scsi_device *sdev, int state,
> +		     struct alua_dh_data *h)
> +{
> +	struct scsi_sense_hdr sense_hdr;
> +	unsigned err;
> +	int retry = ALUA_FAILOVER_RETRIES;
> +
> + retry:
> +	err = submit_stpg(sdev, h);
> +	if (err == SCSI_DH_IO && h->senselen > 0) {
> +		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> +					   &sense_hdr);
> +		if (!err)
> +			return SCSI_DH_IO;
> +		err = alua_check_sense(sdev, &sense_hdr);
> +		if (retry > 0 && err == NEEDS_RETRY) {
> +			retry--;
> +			goto retry;
> +		}
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: stpg sense code: %02x/%02x/%02x\n",
> +			    ALUA_DH_NAME, sense_hdr.sense_key,
> +			    sense_hdr.asc, sense_hdr.ascq);
> +		err = SCSI_DH_IO;
> +	}
> +	if (err == SCSI_DH_OK) {
> +		h->state = state;
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: port group %02x switched to state %c\n",
> +			    ALUA_DH_NAME, h->group_id,
> +			    print_alua_state(h->state) );
> +	}
> +	return err;
> +}
> +
> +/*
> + * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
> + * @sdev: the device to be evaluated.
> + *
> + * Evaluate the Target Port Group State.
> + * Returns SCSI_DH_DEV_OFFLINED if the path is
> + * found to be unuseable.
> + */
> +static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
> +{
> +	struct scsi_sense_hdr sense_hdr;
> +	int len, k, off, valid_states = 0;
> +	char *ucp;
> +	unsigned err;
> +
> + retry:
> +	err = submit_rtpg(sdev, h);
> +
> +	if (err == SCSI_DH_IO && h->senselen > 0) {
> +		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> +					   &sense_hdr);
> +		if (!err)
> +			return SCSI_DH_IO;
> +
> +		err = alua_check_sense(sdev, &sense_hdr);
> +		if (err == NEEDS_RETRY)
> +			goto retry;
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: rtpg sense code %02x/%02x/%02x\n",
> +			    ALUA_DH_NAME, sense_hdr.sense_key,
> +			    sense_hdr.asc, sense_hdr.ascq);
> +		err = SCSI_DH_IO;
> +	}
> +	if (err != SCSI_DH_OK)
> +		return err;
> +
> +	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
> +		(h->buff[2] << 8) + h->buff[3] + 4;
> +
> +	if (len > h->bufflen) {
> +		/* Resubmit with the correct length */
> +		if (realloc_buffer(h, len)) {
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "%s: kmalloc buffer failed\n",__FUNCTION__);
> +			/* Temporary failure, bypass */
> +			return SCSI_DH_DEV_TEMP_BUSY;
> +		}
> +		goto retry;
> +	}
> +
> +	for (k = 4, ucp = h->buff + 4; k < len; k += off, ucp += off) {
> +		if (h->group_id == (ucp[2] << 8) + ucp[3]) {
> +			h->state = ucp[0] & 0x0f;
> +			valid_states = ucp[1];
> +		}
> +		off = 8 + (ucp[7] * 4);
> +	}
> +
> +	sdev_printk(KERN_INFO, sdev,
> +		    "%s: port group %02x state %c supports %c%c%c%c%c%c\n",
> +		    ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
> +		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
> +		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
> +		    valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
> +		    valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
> +		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
> +		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
> +
> +	if (h->tpgs & TPGS_MODE_EXPLICIT) {
> +		switch (h->state) {
> +		case TPGS_STATE_TRANSITIONING:
> +			/* State transition, retry */
> +			goto retry;
> +			break;
> +		case TPGS_STATE_OFFLINE:
> +			/* Path is offline, fail */
> +			err = SCSI_DH_DEV_OFFLINED;
> +			break;
> +		default:
> +			break;
> +		}
> +	} else {
> +		/* Only Implicit ALUA support */
> +		if (h->state == TPGS_STATE_OPTIMIZED ||
> +		    h->state == TPGS_STATE_NONOPTIMIZED ||
> +		    h->state == TPGS_STATE_STANDBY)
> +			/* Useable path if active */
> +			err = SCSI_DH_OK;
> +		else
> +			/* Path unuseable for unavailable/offline */
> +			err = SCSI_DH_DEV_OFFLINED;
> +	}
> +	return err;
> +}
> +
> +/*
> + * alua_initialize - Initialize ALUA state
> + * @sdev: the device to be initialized
> + *
> + * For the prep_fn to work correctly we have
> + * to initialize the ALUA state for the device.
> + */
> +static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
> +{
> +	int err;
> +
> +	err = alua_std_inquiry(sdev, h);
> +	if (err != SCSI_DH_OK)
> +		goto out;
> +
> +	err = alua_vpd_inquiry(sdev, h);
> +	if (err != SCSI_DH_OK)
> +		goto out;
> +
> +	err = alua_rtpg(sdev, h);
> +	if (err != SCSI_DH_OK)
> +		goto out;
> +
> +out:
> +	return err;
> +}
> +
> +/*
> + * alua_activate - activate a path
> + * @sdev: device on the path to be activated
> + *
> + * We're currently switching the port group to be activated only and
> + * let the array figure out the rest.
> + * There may be other arrays which require us to switch all port groups
> + * based on a certain policy. But until we actually encounter them it
> + * should be okay.
> + */
> +static int alua_activate(struct scsi_device *sdev)
> +{
> +	struct alua_dh_data *h = get_alua_data(sdev);
> +	int err = SCSI_DH_OK;
> +
> +	if (h->group_id != -1) {
> +		err = alua_rtpg(sdev, h);
> +		if (err != SCSI_DH_OK)
> +			goto out;
> +	}
> +
> +	if (h->tpgs == TPGS_MODE_EXPLICIT && h->state != TPGS_STATE_OPTIMIZED)
> +		err = alua_stpg(sdev, TPGS_STATE_OPTIMIZED, h);
> +
> +out:
> +	return err;
> +}
> +
> +/*
> + * alua_prep_fn - request callback
> + *
> + * Fail I/O to all paths not in state
> + * active/optimized or active/non-optimized.
> + */
> +static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
> +{
> +	struct alua_dh_data *h = get_alua_data(sdev);
> +	int ret = BLKPREP_OK;
> +
> +	if (h->state != TPGS_STATE_OPTIMIZED &&
> +	    h->state != TPGS_STATE_NONOPTIMIZED) {
> +		ret = BLKPREP_KILL;
> +		req->cmd_flags |= REQ_QUIET;
> +	}
> +	return ret;
> +
> +}
> +
> +const struct scsi_dh_devlist alua_dev_list[] = {
> +	{"HP", "MSA VOLUME" },
> +	{"HP", "HSV101" },
> +	{"HP", "HSV111" },
> +	{"HP", "HSV200" },
> +	{"HP", "HSV210" },
> +	{"HP", "HSV300" },
> +	{"IBM", "2107900" },
> +	{"IBM", "2145" },
> +	{"Pillar", "Axiom" },
> +	{NULL, NULL}
> +};
> +
> +static int alua_bus_attach(struct scsi_device *sdev);
> +static void alua_bus_detach(struct scsi_device *sdev);
> +
> +static struct scsi_device_handler alua_dh = {
> +	.name = ALUA_DH_NAME,
> +	.module = THIS_MODULE,
> +	.devlist = alua_dev_list,
> +	.attach = alua_bus_attach,
> +	.detach = alua_bus_detach,
> +	.prep_fn = alua_prep_fn,
> +	.check_sense = alua_check_sense,
> +	.activate = alua_activate,
> +};
> +
> +/*
> + * alua_bus_attach - Attach device handler
> + * @sdev: device to be attached to
> + */
> +static int alua_bus_attach(struct scsi_device *sdev)
> +{
> +	struct scsi_dh_data *scsi_dh_data;
> +	struct alua_dh_data *h;
> +	unsigned long flags;
> +	int err = SCSI_DH_OK;
> +
> +	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
> +			       + sizeof(*h) , GFP_KERNEL);
> +	if (!scsi_dh_data) {
> +		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
> +			    ALUA_DH_NAME);
> +		return -ENOMEM;
> +	}
> +
> +	scsi_dh_data->scsi_dh = &alua_dh;
> +	h = (struct alua_dh_data *) scsi_dh_data->buf;
> +	h->tpgs = TPGS_MODE_UNINITIALIZED;
> +	h->state = TPGS_STATE_OPTIMIZED;
> +	h->group_id = -1;
> +	h->rel_port = -1;
> +	h->buff = h->inq;
> +	h->bufflen = ALUA_INQUIRY_SIZE;
> +
> +	err = alua_initialize(sdev, h);
> +	if (err != SCSI_DH_OK)
> +		goto failed;
> +
> +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +	sdev->scsi_dh_data = scsi_dh_data;
> +	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +
> +	try_module_get(THIS_MODULE);


Do we need to handle the case where this fails?
