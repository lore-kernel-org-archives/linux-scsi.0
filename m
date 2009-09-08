From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: linux-next: Tree for September 7 (scsi/qla2x)
Date: Tue, 8 Sep 2009 11:25:41 -0700
Message-ID: <20090908182541.GB44157@plap4-2.local>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
 <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:36921 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbZIHSZk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2009 14:25:40 -0400
Content-Disposition: inline
In-Reply-To: <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Mon, 07 Sep 2009, Randy Dunlap wrote:

> On Mon, 7 Sep 2009 21:02:06 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20090904:
> 
> 
> when CONFIG_MODULES=n:
> 
> drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> 
> in
> 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> 	    KOBJ_CHANGE, envp);

Argg...  Some history here...  During several unwelcome
hardware/firmware events (ISP system error, mailbox command timeouts,
etc), the qla2xxx driver can store a 'firmware-dump' (essentially a
snapshot of the current state of the ISP firmware).  This snapshot is
then captured via a user-space tool querying a driver sysfs-node
hanging off of a scsi_host's device tree:

	/sys/class/scsi_host/host4/device/fw_dump

The dump is then used by our firmware engineering group to help triage
the issue.

This recent change:

	commit 10a71b40153a19279428053ad9743e15ef414148
	Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
	Date:   Tue Aug 25 11:36:15 2009 -0700

	    [SCSI] qla2xxx: Add firmware-dump kobject uevent notification.

	    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
	    Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
	    Signed-off-by: James Bottomley <James.Bottomley@suse.de>

attempted to help 'automate' the task of retrieval by signaling udev
to automatically run the 'retrieval' script anytime the driver
captured the firmware-dump.  Here's a snippet of the udev rule:

	# qla2xxx driver
	KERNEL=="qla2xxx", SUBSYSTEM=="module", ACTION=="change", RUN+="qla2xxx_udev.sh"

Any suggestions here on an alternate driver-specific kobject an LLD
can/should use for something like this?  I looked previously at other
callers of kobject_uevent_env(), but didn't really see a simlar
usage-pattern of a driver wanting to signal events to userspace...

Thanks, AV
