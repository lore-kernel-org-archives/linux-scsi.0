From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patch?: Eliminate scsi_disk.driver from 2.6.0-test5
Date: Mon, 15 Sep 2003 18:00:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030915180052.A12217@beaverton.ibm.com>
References: <200309152247.h8FMlvA12498@freya.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:1925 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261733AbTIPBBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 21:01:15 -0400
Content-Disposition: inline
In-Reply-To: <200309152247.h8FMlvA12498@freya.yggdrasil.com>; from adam@yggdrasil.com on Mon, Sep 15, 2003 at 03:47:57PM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Sep 15, 2003 at 03:47:57PM -0700, Adam J. Richter wrote:
> 	The following is a completely untested patch to
> linux-2.6.0-test5/drivers/sd.c to eliminate scsi_disk.driver.
> I'm out of town right now, so I can't readily test it.  I would
> appreciate it if someone would give this patch a try and
> submit it for integration if it does work.

Adam -

I tried it, and it didn't work too well, oopsing in scsi_prep_fn on the
first REQ_CMD sent via sd :-(

We use req->rq_disk->private_data to figure out the matching upper level
driver init_command to call in scsi_prep_fn, so with your patch we map a
scsi_driver on top of scsi_disk. That is also why scsi char devices have a
struct gendisk. 

Kind of misleading code, but it got rid of the awful code that searched
all upper level drivers - in 2.4 scsi_lib.c scsi_get_request_dev - and
AFAIR also helped clean out some other crap (the 2.4 scsi code hurts my
head).

-- Patrick Mansfield
