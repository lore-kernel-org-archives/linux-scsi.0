From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 21 Nov 2003 09:56:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121095640.A8648@beaverton.ibm.com>
References: <DBEOIJFONILFHFGKLPGFCECICEAA.shkiran@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:58515 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S264401AbTKUR44
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 12:56:56 -0500
Content-Disposition: inline
In-Reply-To: <DBEOIJFONILFHFGKLPGFCECICEAA.shkiran@cisco.com>; from shkiran@cisco.com on Fri, Nov 21, 2003 at 05:10:09PM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Shashi Kiran T.R" <shkiran@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 21, 2003 at 05:10:09PM +0530, Shashi Kiran T.R wrote:

> In the existing code upon seeing ASC/ASCQ 04/02, the failed I/O are retried
> in the iSCSI driver after issuing START_STOP using iscsi_do_cmnd(). This
> ensures that application does not see an I/O error.
> 
>  We tried replacing  iscsi_do_cmnd() call  by kernel_scsi_ioctl() , but  the
> ioctl call never completed. Looks like scsi mid layer prevents the
> processing of START_STOP command until responses for earlier commands are
> obtained. The response is deferred upstream from iSCSI driver since it
> retries any failed I/O. Probably this is creating a deadlock situation
> making this alternative infeasible!.

So we sent a START_STOP via sd.c to spin up the drive, and since then
it has been spun down. Correct?

What spun it down? 

Whatever caused the spin down should spin it back up.

-- Patrick Mansfield
