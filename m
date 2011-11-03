From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] mpt2sas: New feature - Fast Load Support
Date: Thu, 3 Nov 2011 15:20:21 +0300
Message-ID: <20111103122021.GA25772@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:38930 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab1KCMUh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 08:20:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nagalakshmi.nandigama@lsi.com
Cc: linux-scsi@vger.kernel.org

Hello nagalakshmi.nandigama@lsi.com,

This is a semi-automatic email about new static checker warnings.

The patch 921cd8024b90: "[SCSI] mpt2sas: New feature - Fast Load 
Support" from Oct 19, 2011, leads to the following Smatch complaint:

drivers/scsi/mpt2sas/mpt2sas_base.c +3506 mpt2sas_port_enable_done()
	 error: we previously assumed 'mpi_reply' could be null (see line 3499)

drivers/scsi/mpt2sas/mpt2sas_base.c
  3498		ioc->port_enable_cmds.status |= MPT2_CMD_COMPLETE;
  3499		if (mpi_reply) {
                    ^^^^^^^^^
check.

  3500			ioc->port_enable_cmds.status |= MPT2_CMD_REPLY_VALID;
  3501			memcpy(ioc->port_enable_cmds.reply, mpi_reply,
  3502			    mpi_reply->MsgLength*4);
  3503		}
  3504		ioc->port_enable_cmds.status &= ~MPT2_CMD_PENDING;
  3505	
  3506		ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
                                         ^^^^^^^^^^^
dereference.

  3507	
  3508		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)

regards,
dan carpenter

