From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Winbond] MS/MS Pro driver for Winbond 528 PCI reader for
	public review
Date: Fri, 28 Jul 2006 17:42:27 -0500
Message-ID: <1154126547.9447.55.camel@mulgrave.il.steeleye.com>
References: <44A0E75F.4090800@winbond.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30612 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161342AbWG1Wmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jul 2006 18:42:39 -0400
In-Reply-To: <44A0E75F.4090800@winbond.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dezheng shen <dzshen@winbond.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-06-27 at 16:07 +0800, dezheng shen wrote:
> Dear all:
>    This email was originally posted on linux-kernel but I didn't get any 
> response yet so that I post it to this linux-scsi again. Hope that we 
> can get reply soon.

Sorry for the delay, I've been a bit busy with KS/OLS and other things.

This, I'm afraid is basically the killer for scsi:

> static int wb_process_scsi_cmd(Scsi_Cmnd * cmd)
> {
> 	unsigned long flags;
> 	wb_host_data_t *host_data;
> 	ENTER();
> 
> 	host_data = g_wb_host_data;
> 	wb_chk_valid_medium(host_data);
> 
> 	wb_unit_ready(cmd);
> 
> 	switch (cmd->cmnd[0]) {
> 
> 	case START_STOP:
> 		WB_PRINTK_SCSI("START_STOP\n");
> 		wb_scsi_start_stop(cmd);
> 		break;
> 
> 	case REQUEST_SENSE:
> 		WB_PRINTK_SCSI("REQUEST_SENSE\n");
> 		wb_scsi_request_sense(cmd);
> 		break;
> 
> 	case ALLOW_MEDIUM_REMOVAL:
> 		WB_PRINTK_SCSI("ALLOW_MEDIUM_REMOVAL\n");
> 		wb_scsi_allow_medium_removal(cmd);
> 		break;
> 
> 	case TEST_UNIT_READY:
> 		WB_PRINTK_SCSI("TEST_UNIT_READY\n");
> 		wb_scsi_test_unit_ready(cmd);
> 		break;
> 
> 	case INQUIRY:
> 		WB_PRINTK_SCSI("INQUIRY\n");
> 		wb_scsi_inquiry(cmd);
> 		break;
> 
> 	case READ_6:
> 		WB_PRINTK_ERROR_SCSI("READ_6\n");
> 		break;
> 
> 	case READ_10:
> 		WB_PRINTK_SCSI("READ_10\n");
> 		wb_scsi_read_wrt(cmd, TRUE);
> 		break;
> 
> 	case WRITE_6:
> 		WB_PRINTK_ERROR_SCSI("WRITE_6\n");
> 		break;
> 
> 	case WRITE_10:
> 		WB_PRINTK_SCSI("WRITE_10\n");
> 		wb_scsi_read_wrt(cmd, FALSE);
> 		break;
> 
> 		// MODE_SENSE is 6-byte command
> 	case MODE_SENSE:
> 		WB_PRINTK_SCSI("MODE_SENSE\n");
> 		wb_scsi_mode_sense(cmd);
> 		break;
> 
> 	case READ_CAPACITY:
> 		WB_PRINTK_SCSI("READ_CAPACITY\n");
> 		wb_scsi_read_capacity(cmd);
> 		break;
> 
> 	case FORMAT_UNIT:
> 		WB_PRINTK_SCSI("FORMAT_UNIT\n");
> 		wb_scsi_format_unit(cmd);
> 		break;
> 
> 		// haven't handled all necessary cases yet
> 	default:
> 		WB_PRINTK_ERROR_SCSI("UNKNOWN command(0x%x)\n", cmd->cmnd[0]);
> 		wb_make_sense_buffer(cmd, ILLEGAL_REQUEST, 0x20, 0x00);
> 		cmd->result =
> 		    WB_CMD_RESULT(DID_OK, COMMAND_COMPLETE, CHECK_CONDITION);
> 		break;
> 	}			// end switch
> 
> 	spin_lock_irqsave(g_wb_host->host_lock, flags);
> 	cmd->scsi_done(cmd);
> 	spin_unlock_irqrestore(g_wb_host->host_lock, flags);
> 
> 	LEAVE();
> 	return 0;
> }

It means there's no actual SCSI command processor anywhere in the
device.  You're simply using the SCSI subsystem as a passthrough.  We
really try to discourage this unless the actual underlying device speaks
SCSI.  Ideally, a driver like this should fit into the existing mmc/sd
subsystem, but if it doesn't, it should be written as a simple block
driver rather than doing the unnecessary round trip conversion to SCSI
protocols and back.

James


