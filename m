From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Fw: aic94xx breaks with SATA drives that have medium errors
Date: Tue, 28 Nov 2006 12:06:13 -0800
Message-ID: <456C96B5.3080301@us.ibm.com>
References: <20061127200550.4de27bc6.akpm@osdl.org>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34510 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S936086AbWK1UGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 15:06:18 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kASK6Geq013964
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2006 15:06:16 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kASK6FNl120110
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2006 15:06:15 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kASK6FQS017963
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2006 15:06:15 -0500
In-Reply-To: <20061127200550.4de27bc6.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Dan Aloni <da-x@monatomic.org>, Alexis Bruemmer <alexisb@us.ibm.com>

> Everything works okay until I perform a read I/O to the media-error-causing
> location. Immediately I get:
> 
> aic94xx: escb_tasklet_complete: phy2: REQ_TASK_ABORT

Interesting that you get REQ_TASK_ABORT for a media error...

> But the I/O only returns to the SCSI layer after its full designated
> timeout, instead of returning quickly with MEDIUM_ERROR.

Yep.  The abort function doesn't know how to tell libata to abort the
command.  I suppose the "proper" thing to do would be to modify
sas_ata_task_done to check if the SAS_TASK_ABORTED or
SAS_TASK_INITIATOR_ABORTED flags are set and send some sort of ATA error
code back that would cause a retry.  Though, I don't see why the
sequencer sends back REQ_TASK_ABORT--presumably the drive generates some
media error data that could be fed to libata.

> After that particular I/O fails, every I/O to the driver will immediately
> return as aborted. Unloading and loading the driver reverses the problem
> but may crash the kernel not long after printing this:
> 
> Nov 28 02:13:58 pro210 kernel: aic94xx: Uh-oh! Pending is not empty!
> Nov 28 02:13:58 pro210 kernel: aic94xx: freeing from pending

Yep.  Side effect of above.  I'll send you a patch later today when I
get this sorted out.  In any case, thank you for testing out the driver! :)

--D
