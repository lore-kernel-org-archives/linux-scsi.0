From: Alan Stern <stern@rowland.harvard.edu>
Subject: Suggestion for addition to Documentation/scsi/scsi_mid_low_api.txt
Date: Wed, 9 Jun 2004 10:39:33 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406091016490.1088-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4868 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265796AbUFIOje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2004 10:39:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Douglas:

As an addition to the scsi_mid_low_api.txt documentation, it might be nice 
to put near the end a description of the things a low-level driver is 
responsible for doing/checking when carrying out a SCSI command.  While 
this is perhaps unnecessary for people with loads of experience in the 
SCSI world, it would definitely help someone who (like me) has a weaker 
background.  Struct scsi_cmnd is so large and redundant that it's hard to 
tell what's important and what isn't.

The discussion doesn't need to be too detailed -- in fact it can't be, 
since the details of each host driver are different.  But in general 
terms, you could list something like the following (this essentially 
captures my knowledge of what needs to be done):

	Convey the CDB contents, stored in scmd->cmnd[] and having
	length scmd->cmd_len, to the device.

	The data transfer length (in bytes) is in scmd->request_bufflen 
	and the direction of the transfer is in scmd->sc_data_direction.  
	If the transfer length is 0 then there is no data phase.

	The data to be transferred is pointed to by scmd->request_buffer
	if scmd->use_sg is 0.  If scmd->use_sg is non-zero then it tells
	how many scatter-gather elements there are, and
	scmd->request_buffer points to the array of scatterlist elements.

	If possible, set scmd->resid to the requested transfer length
	minus the actual transfer length.

	Determine the status of the command and store the various parts
	of scmd->result.

	If the status is CHECK CONDITION, obtain the sense data (perhaps
	by issuing a REQUEST SENSE command).  The sense data should be
	stored in scmd->sense_buffer[] and the data length should be 
	at least 18.

	If the status is GOOD but the amount transferred was smaller than
	scmd->underflow then set scmd->result to (DID_ERROR << 16) |
	(SUGGEST_RETRY << 24).

No doubt there are additional complications and steps that I have missed
or don't know about.  Please feel free to embellish this list.

Alan Stern

