From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Mon, 25 May 2009 11:49:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905251144470.24294-100000@netrider.rowland.org>
References: <1243252896.4853.9.camel@poy>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:42103 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752051AbZEYPti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 May 2009 11:49:38 -0400
In-Reply-To: <1243252896.4853.9.camel@poy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

Since this appears to be a bug in the SCSI layer, let's add some SCSI
people to the CC: list.

To summarize the problem: The SCSI core tries to unregister a host 
while its sysfs directory is still non-empty because the target hasn't 
been unregistered yet.

On Mon, 25 May 2009, Kay Sievers wrote:

> On Mon, 2009-05-25 at 13:45 +0200, Kay Sievers wrote:
> > On Mon, May 25, 2009 at 04:06, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > > by the way -- so it's a little difficult to trigger.
> > 
> > I can trigger it pretty reliable now on plain -rc7 , but only with
> > more hubs in-between the storage device. It usually take less than
> > 10-15 connect/disconnect cycles.
> > 
> > It looks like a serious bug though, after the bug triggered, random,
> > likely unrelated, applications crash, and I can not cleanly shot down
> > anymore.
> > 
> > > I posted a patch, but the
> > > reporter never said whether or not the patch fixed the problem.  Hence
> > > the patch hasn't been submitted.
> > >
> > > Here it is for you to try out.
> > 
> > I'll give it try now.
> 
> It still shows the same issue. Here is the trace with the target
> directory left-over, when the host directory goes away: "host5/target5:0:0",
> and the devpath with the parents lost "path = '/host5/target5:0:0'":
> 
> Thanks,
> Kay
> 
> 
> [   58.399021] kobject: 'host5' (ffff88012c52b558): kobject_uevent_env
> [   58.399041] kobject: 'host5' (ffff88012c52b558): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host5/scsi_host/host5'
> [   58.399213] kobject: 'scsi_host' (ffff88012548cdd0): kobject_cleanup
> [   58.399217] kobject: 'scsi_host' (ffff88012548cdd0): auto cleanup kobject_del
> [   58.399236] kobject: 'scsi_host' (ffff88012548cdd0): calling ktype release
> [   58.399239] kobject: (ffff88012548cdd0): dynamic_kobj_release
> [   58.399243] kobject: 'scsi_host': free name
> [   58.399247] kobject: 'host5' (ffff88012c52b558): kobject_cleanup
> [   58.399250] kobject: 'host5' (ffff88012c52b558): calling ktype release
> [   58.399255] kobject: 'host5': free name
> [   58.399315] kobject: 'host5' (ffff88012c52b388): kobject_uevent_env
> [   58.399335] kobject: 'host5' (ffff88012c52b388): fill_kobj_path: path = '/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.4/2-2.4:1.0/host5'
> [   58.399484] ------------[ cut here ]------------
> [   58.399493] WARNING: at fs/sysfs/dir.c:794 sysfs_remove_dir+0xb2/0xd0()
> [   58.399497] Hardware name: 2776LEG
> [   58.399499] XXX dir: host5/target5:0:0
> ...
> [   58.399594] Pid: 226, comm: khubd Not tainted 2.6.30-rc7-dirty #40
> [   58.399598] Call Trace:
> [   58.399605]  [<ffffffff8023c6a8>] warn_slowpath_common+0x78/0xb0
> [   58.399610]  [<ffffffff8023c73c>] warn_slowpath_fmt+0x3c/0x40
> [   58.399614]  [<ffffffff803229f6>] ? sysfs_addrm_start+0x76/0xd0
> [   58.399619]  [<ffffffff80323012>] sysfs_remove_dir+0xb2/0xd0
> [   58.399626]  [<ffffffff803e5036>] kobject_del+0x16/0x40
> [   58.399632]  [<ffffffff80477645>] device_del+0x165/0x1a0
> [   58.399638]  [<ffffffff8048256f>] scsi_remove_host+0xcf/0x120
> [   58.399652]  [<ffffffffa02fd3cb>] quiesce_and_remove_host+0x6b/0xb0 [usb_storage]
> [   58.399662]  [<ffffffffa02fd4f8>] usb_stor_disconnect+0x18/0x30 [usb_storage]
> [   58.399686]  [<ffffffffa0062fae>] usb_unbind_interface+0x6e/0x140 [usbcore]
> [   58.399694]  [<ffffffff80479e29>] __device_release_driver+0x59/0xa0
> [   58.399699]  [<ffffffff80479f68>] device_release_driver+0x28/0x40
> [   58.399704]  [<ffffffff8047927c>] bus_remove_device+0xac/0xe0
> [   58.399709]  [<ffffffff80477607>] device_del+0x127/0x1a0
> [   58.399726]  [<ffffffffa005fb77>] usb_disable_device+0xa7/0x130 [usbcore]
> [   58.399744]  [<ffffffffa005a818>] usb_disconnect+0xc8/0x140 [usbcore]
> [   58.399761]  [<ffffffffa005a804>] usb_disconnect+0xb4/0x140 [usbcore]
> [   58.399778]  [<ffffffffa005b8db>] hub_thread+0x50b/0x1230 [usbcore]
> [   58.399784]  [<ffffffff80565a56>] ? _spin_unlock_irq+0x26/0x30
> [   58.399790]  [<ffffffff80237d1e>] ? finish_task_switch+0x7e/0x140
> [   58.399795]  [<ffffffff80237cdb>] ? finish_task_switch+0x3b/0x140
> [   58.399802]  [<ffffffff802549e0>] ? autoremove_wake_function+0x0/0x40
> [   58.399818]  [<ffffffffa005b3d0>] ? hub_thread+0x0/0x1230 [usbcore]
> [   58.399823]  [<ffffffff802545b5>] kthread+0x55/0xa0
> [   58.399829]  [<ffffffff8020cf3a>] child_rip+0xa/0x20
> [   58.399833]  [<ffffffff80254560>] ? kthread+0x0/0xa0
> [   58.399838]  [<ffffffff8020cf30>] ? child_rip+0x0/0x20
> [   58.399842] ---[ end trace a5fdfdfd6227b73e ]---
> ...
> [   58.853385] kobject: 'target5:0:0' (ffff880129980480): kobject_uevent_env
> [   58.853405] kobject: 'target5:0:0' (ffff880129980480): fill_kobj_path: path = '/host5/target5:0:0'
> [   58.853643] kobject: 'target5:0:0' (ffff880129980480): kobject_cleanup
> [   58.853647] kobject: 'target5:0:0' (ffff880129980480): calling ktype release
> [   58.853653] kobject: 'host5' (ffff88012c52b388): kobject_cleanup
> [   58.853657] kobject: 'host5' (ffff88012c52b388): calling ktype release
> [   58.853701] kobject: '2-2.4:1.0' (ffff8801255319f0): kobject_cleanup
> [   58.853705] kobject: '2-2.4:1.0' (ffff8801255319f0): calling ktype release
> [   58.853721] kobject: '2-2.4:1.0': free name
> [   58.853736] kobject: 'host5': free name
> [   58.853742] kobject: 'target5:0:0': free name
> [   58.853748] kobject: '5:0:0:0': free name

Can you provide more of the context?  I'd like to see the log starting 
from when these devices were first registered.

Alan Stern

