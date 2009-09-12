From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx: Correct compilation issues when CONFIG_MOUDLES=n
 (was: Re: linux-next: Tree for September 7 (scsi/qla2x))
Date: Fri, 11 Sep 2009 17:07:42 -0700
Message-ID: <20090912000742.GB12098@plap4-2.local>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
 <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
 <20090908182541.GB44157@plap4-2.local>
 <20090911175341.GH710@plap4-2.local>
 <1252708951.13282.151.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39418 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZILAHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 20:07:40 -0400
Content-Disposition: inline
In-Reply-To: <1252708951.13282.151.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Fri, 11 Sep 2009, James Bottomley wrote:

> On Fri, 2009-09-11 at 10:53 -0700, Andrew Vasquez wrote:
> > Randy Dunlap noted:
> > 
> >   when CONFIG_MODULES=n:
> > 
> > 	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> > 
> >   in
> > 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> > 		KOBJ_CHANGE, envp);
> > 
> > Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > ---
> > 
> > On Tue, 08 Sep 2009, Andrew Vasquez wrote:
> > 
> > > On Mon, 07 Sep 2009, Randy Dunlap wrote:
> > > 
> > > > On Mon, 7 Sep 2009 21:02:06 +1000 Stephen Rothwell wrote:
> > > > 
> > > > > Hi all,
> > > > > 
> > > > > Changes since 20090904:
> > > > 
> > > > 
> > > > when CONFIG_MODULES=n:
> > > > 
> > > > drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> > > > 
> > > > in
> > > > 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> > > > 	    KOBJ_CHANGE, envp);
> > > 
> > > Argg...  Some history here...  During several unwelcome
> > > hardware/firmware events (ISP system error, mailbox command timeouts,
> > > etc), the qla2xxx driver can store a 'firmware-dump' (essentially a
> > > snapshot of the current state of the ISP firmware).  This snapshot is
> > > then captured via a user-space tool querying a driver sysfs-node
> > > hanging off of a scsi_host's device tree:
> > > 
> > > 	/sys/class/scsi_host/host4/device/fw_dump
> > > 
> > > The dump is then used by our firmware engineering group to help triage
> > > the issue.
> > > 
> > > This recent change:
> > > 
> > > 	commit 10a71b40153a19279428053ad9743e15ef414148
> > > 	Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > > 	Date:   Tue Aug 25 11:36:15 2009 -0700
> > > 
> > > 	    [SCSI] qla2xxx: Add firmware-dump kobject uevent notification.
> > > 
> > > 	    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > > 	    Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> > > 	    Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> > > 
> > > attempted to help 'automate' the task of retrieval by signaling udev
> > > to automatically run the 'retrieval' script anytime the driver
> > > captured the firmware-dump.  Here's a snippet of the udev rule:
> > > 
> > > 	# qla2xxx driver
> > > 	KERNEL=="qla2xxx", SUBSYSTEM=="module", ACTION=="change", RUN+="qla2xxx_udev.sh"
> > > 
> > > Any suggestions here on an alternate driver-specific kobject an LLD
> > > can/should use for something like this?  I looked previously at other
> > > callers of kobject_uevent_env(), but didn't really see a simlar
> > > usage-pattern of a driver wanting to signal events to userspace...
> > > 
> > > Thanks, AV
> > 
> > Ok, So any strong objections to just having the functionality present
> > when module support is enabled?
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> > index 29396c0..3887adb 100644
> > --- a/drivers/scsi/qla2xxx/qla_os.c
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -2671,6 +2671,7 @@ qla2x00_post_uevent_work(struct scsi_qla_host *vha, u32 code)
> >  static void
> >  qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
> >  {
> > +#ifdef CONFIG_MODULES
> >  	char event_string[40];
> >  	char *envp[] = { event_string, NULL };
> >  
> > @@ -2685,6 +2686,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
> >  	}
> >  	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> >  	    KOBJ_CHANGE, envp);
> > +#endif
> 
> Only emitting events if the thing is compiled as a module doesn't really
> look like the right solution.  The first question that springs to mind
> is why are you emitting events against the module kobject in the first
> place?  Why not emit them against the device kobject (which is always
> present)?

The struct device's kobj from pdev->dev?

My udev-foo is pathetic, so how exactly would that get multiplexed at
the udev side?

	KERNEL=="???", SUBSYSTEM=="???", ACTION=="change", RUN+="qla2xxx_udev.sh"

Thanks, AV
