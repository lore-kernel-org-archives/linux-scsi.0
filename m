From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 2/2] iop13xx: imu scsi driver
Date: Thu, 25 Jan 2007 16:15:54 -0500
Message-ID: <1169759754.3037.78.camel@mulgrave.il.steeleye.com>
References: <20070124182245.6029.43097.stgit@dwillia2-linux.ch.intel.com>
	 <20070124182421.6029.68109.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56340 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030574AbXAYVQR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 16:16:17 -0500
In-Reply-To: <20070124182421.6029.68109.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk, linux-scsi@vger.kernel.org, greg.b.tucker@intel.com

There are quite a few commented out debugging statements and deprecated
C++ style comments dotted throughout this driver ... could these be
corrected? (move to C style comments and either implement a debugging
strategy or pull out the statements).

Another thing that strikes me is on the ARM side, it looks like this is
effectively vectoring up to a user space target ... is that true?  And
if so, would the existing in-kernel target infrastructure be a better
way of doing this?

On Wed, 2007-01-24 at 11:24 -0700, Dan Williams wrote:
> +static int imu_queuecommand(struct scsi_cmnd *scp,
[...]
> +	if (!imu_scsi->connection_handle) {
> +		scp->result = (DID_RESET << 16) | (SUGGEST_RETRY << 24);
> +		done(scp);
> +		return SCSI_MLQUEUE_HOST_BUSY;
> +	}

Absolutely wrong.  Either you execute done() on the command and return
zero, or you *don't* execute done on the command and return a queueing
condition.  Doing both will lead to double completions and really
horrible things.

> +       switch (scp->cmnd[0]) {
> +       case TEST_UNIT_READY:
> +               break;
> +	case READ_10:
> +	case READ_6:
> +	case WRITE_10:
> +	case WRITE_6:
> +	case READ_CAPACITY:
> +	default:

The predicate for this switch looks wrong.  You're not really
interpreting the commands, you appear to be interested in whether they
have data buffers attached.  Might I suggest this might be better done
by

if (scp->sc_data_direction == DMA_NONE)
	break;
else if (scp->use_sg == 0)
	/* request buffer case; hopefully disappearing soon */
else
	/* sg case */



> +		if (scp->use_sg == 0) {
> +			dma_addr_t buff = 0;
> +			if (NULL == scp->request_buffer)
> +				imu_warn("got cmd with NULL request_buffer\n");
> +			else
> +				buff =
> +				    dma_map_single(NULL, scp->request_buffer,
> +						   scp->request_bufflen,
> +						   DMA_BIDIRECTIONAL);
> +			if (buff == 0) {
> +				imu_warn("null return from dma_map_single\n");
> +				msg->flags = IMU_FCODE_STATUS;
> +				msg->status = 0;	//todo: what is error status?
> +				iop_queue_postmsg(Q_NUM, msg);
> +				return 1;
> +			}
> +			sge = &(msg->cdb_cmd.sge);
> +			sge->addr_l = buff;
> +			sge->addr_h = 0;
> +			sge->flen = scp->request_bufflen | FLAG_LAST_ELEMENT;
> +
> +			// This shouldn't be necessary
> +			//dma_sync_single(NULL, buff, scp->request_bufflen, DMA_BIDIRECTIONAL);
> +			imu_debug("cmd msg with 1 sgl entry, addr=0x%x\n",
> +				  buff);

Why BIDIRECTIONAL?  This can be expensive on some architectures
(although I don't know about ARM).  However, for these commands, the
scp->sc_data_direction should contain the exact direction you need to
program into the DMA engines. (Consider this the same comment for the
use_sg > 0 portion as well).


> +	iop_queue_postmsg(Q_NUM, msg);

This has error returns ... should you be handling them?


> +static int imu_eh_abort(struct scsi_cmnd *cmd)
> +{
> +	imu_warn("Received eh command abort\n");
> +	//dbg_print_cmd(cmd);
> +	return SUCCESS;
> +}
> +
> +static int imu_eh_device_reset(struct scsi_cmnd *cmd)
> +{
> +	int target = cmd->device->id;
> +	imu_warn("Received eh device reset for target %d\n", target);
> +	return SUCCESS;
> +}
> +
> +static int imu_eh_host_reset(struct scsi_cmnd *cmd)
> +{
> +	imu_warn("Received eh host reset\n");
> +	return SUCCESS;
> +}
> +
> +static int imu_eh_bus_reset(struct scsi_cmnd *cmd)
> +{
> +	imu_warn("Received eh bus reset\n");
> +	return SUCCESS;
> +}

This lot all look really wrong.  All you're doing is printing a message
and then telling the mid-layer the device is recovered, when in fact
you've done nothing to alleviate the error condition.  The mid-layer's
next action will be to send down a TUR to check the device condition,
which will likely fail and continue on to offline the device.

James


