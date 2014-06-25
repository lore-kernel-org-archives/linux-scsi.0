From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH V2] scsi_lib: removes ambiguous "Unhandled error code"
 messages.
Date: Wed, 25 Jun 2014 20:38:47 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B4C8CD@G9W0745.americas.hpqcorp.net>
References: <1402042235-7246-1-git-send-email-mlombard@redhat.com>
 <20140625110632.GE19181@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:2495 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaFYUlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 16:41:03 -0400
In-Reply-To: <20140625110632.GE19181@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Maurizio Lombardi <mlombard@redhat.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Wednesday, 25 June, 2014 6:07 AM
> To: Maurizio Lombardi
> Cc: James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org;
> hch@infradead.org
> Subject: Re: [PATCH V2] scsi_lib: removes ambiguous "Unhandled error code"
> messages.
> 
> Can I get another review for this one?
> 
> On Fri, Jun 06, 2014 at 10:10:35AM +0200, Maurizio Lombardi wrote:
...
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
...
> > @@ -955,14 +955,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> unsigned int good_bytes)
> >  			action = ACTION_FAIL;
> >  			break;
> >  		default:
> > -			description = "Unhandled sense code";
> > +			description = "Failing command with sense code:";

The default case handles sense keys other than:
	#define NOT_READY           0x02
	#define ILLEGAL_REQUEST     0x05
	#define UNIT_ATTENTION      0x06
	#define ABORTED_COMMAND     0x0b
	#define VOLUME_OVERFLOW     0x0d

which means these #defines (and any other values)
#define NO_SENSE            0x00
#define RECOVERED_ERROR     0x01
#define MEDIUM_ERROR        0x03
#define HARDWARE_ERROR      0x04
#define DATA_PROTECT        0x07
#define BLANK_CHECK         0x08
#define COPY_ABORTED        0x0a
#define MISCOMPARE          0x0e

The other description strings that result in ACTION_FAIL are based
on the sense key and sometimes the additional sense code:
description = "Media Changed";
description = "Host Data Integrity Failure";
description = "Discard failure";
description = "Write same failure";
description = "Invalid command failure";
description = "Target Data Integrity Failure";
description = "Device not ready";

Also, there is this one, which is not based on the sense key:
description = "Command timed out";

Since the ACTION_FAIL case always prints the sense key
and additional sense code:
	if (!(req->cmd_flags & REQ_QUIET)) {
		if (description)
			scmd_printk(KERN_INFO, cmd, " % \n",
				description);
		scsi_print_result(cmd);
		if (driver_byte(result) & DRIVER_SENSE)
			scsi_print_sense("", cmd);
		scsi_print_command(cmd);
	}

perhaps the description string should be removed altogether?

In this example:
	sd 1:0:0:0: [sdb] Unhandled sense code
	sd 1:0:0:0: [sdb]
	Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
	sd 1:0:0:0: [sdb]
	Sense Key : Medium Error [current]
	sd 1:0:0:0: [sdb]
	Add. Sense: Unrecovered read error
	sd 1:0:0:0: [sdb] CDB:
	Read(10): 28 00 00 18 f8 a8 00 00 08 00
	end_request: critical medium error, dev sdb, sector 1636520

"Sense Key : Medium Error" is much more informative than
"Unhandled sense code" or "Failing command with sense code".
All the other descriptions represent failing commands,
so using different wording is a bit confusing.

For the "Unhandled error code" (for which you are proposing
removing the string) and the timeout case, the scsi_print_result 
call already prints hostbyte and driverbyte, which explain what 
happened in more detail:

	sd 1:0:0:0: [sda] Unhandled error code                                          
	sd 1:0:0:0: [sda]                                                               
	Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK                              
	sd 1:0:0:0: [sda] CDB:                                                          
	Test Unit Ready:                                                                
	end_request: I/O error, dev sda, sector 481013632                               

---
Rob Elliott    HP Server Storage




