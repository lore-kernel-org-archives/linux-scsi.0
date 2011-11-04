From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [SCSI] mpt2sas: New feature - Fast Load Support
Date: Fri, 4 Nov 2011 17:20:06 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6047262C24D@inbmail02.lsi.com>
References: <20111103122021.GA25772@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:42848 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321Ab1KDLuY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2011 07:50:24 -0400
In-Reply-To: <20111103122021.GA25772@elgon.mountain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thank you for the feedback. Will post a fix.

Regards,
Nagalakshmi


-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Thursday, November 03, 2011 5:50 PM
To: Nandigama, Nagalakshmi
Cc: linux-scsi@vger.kernel.org
Subject: re: [SCSI] mpt2sas: New feature - Fast Load Support

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

