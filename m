From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY
 objects
Date: Wed, 18 May 2016 10:49:17 -0700
Message-ID: <20160518174917.GA1241608@devbig337.prn1.facebook.com>
References: <41278f83ecb4de381ab49aeb94e341dc533fde8f.1463170969.git.calvinowens@fb.com>
 <94D0CD8314A33A4D9D801C0FE68B40296396FB3E@G4W3202.americas.hpqcorp.net>
 <20160516202454.GA2018262@devbig337.prn1.facebook.com>
 <f6e9d525a6435464bfa53bf7884b956f@mail.gmail.com>
 <20160517031357.GA2468135@devbig337.prn1.facebook.com>
 <CAK=zhgov_-ORUsXJexWgJkPs3RMmheaxtGT66skgFBYJRnH3eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41107 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751967AbcERRth (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2016 13:49:37 -0400
Content-Disposition: inline
In-Reply-To: <CAK=zhgov_-ORUsXJexWgJkPs3RMmheaxtGT66skgFBYJRnH3eQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, calvinowens@fb.com

On Wednesday 05/18 at 18:44 +0530, Sreekanth Reddy wrote:
> On Tue, May 17, 2016 at 8:43 AM, Calvin Owens <calvinowens@fb.com> wrote:
> > On Monday 05/16 at 15:51 -0600, Sathya Prakash Veerichetty wrote:
> >> Our understanding is the relationship between the SCSI host and SAS end
> >> devices is a parent-child and before ripping of SCSI host we need to rip of
> >> all the children.
> >
> > I know at least HPSA does the opposite, Elliott observes that other
> > drivers do as well.
> >
> >> Why the enclosure ends up trying to re-parent the SCSI device from the
> >> enclosure to the SAS PHY even after we remove the SAS Phy?
> >
> > Take this path in /sys:
> >
> > /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/end_device-6:0:0/target6:0:0/6:0:0:0/scsi_device/6:0:0:0
> >
> > The problem is "port-6:0:0" in the hierarchy: since mpt3sas explicitly
> > calls sas_port_delete() before scsi_remove_host(), that node is removed
> > from the device hierarchy and seems to orphan what lies beneath it:
> >
> > [  955.119328] kobject: '6:0:0:0' (ffff88074e2e1008): kobject_uevent_env
> > [  955.133890] kobject: '6:0:0:0' (ffff88074e2e1008): fill_kobj_path: path = '/end_device-6:0:0/target6:0:0/6:0:0:0/bsg/6:0:0:0'
> > <WARN/OOPS sadness follows>
> 
> [Sreekanth] Calvin, Now with your patch we are observing same type of
> <WARN/OOPS> while unregistered the drive with scsi_transport layer
> after calling scsi_remove_host() on the same driver unload path,
> 
> kobject: 'end_device-2:0' (ffff8800dad0c010): kobject_uevent_env
> kobject: 'end_device-2:0' (ffff8800dad0c010): fill_kobj_path: path =
> '/host2/port-2:0/end_device-2:0/bsg/end_device-2:0'
> 
> As scsi_remove_host() has freed it's parent
> "/devices/pci0000:00/0000:00:07.0" we are observing these warnings.
> 
> here is it's complete path
> 
>  fill_kobj_path: path =
> '/devices/pci0000:00/0000:00:07.0/host2/port-2:0/end_device-2:0/bsg/end_device-2:0',

Could you post the stacktraces for your WARN/OOPS?

> Until on  ~3.19/4.0 kernel all the thing are working fine, we haven't
> seen these types of kernel warning. Also we haven't done any changes
> in mpt3sas driver w.r.t to this after 4.0 kernel.

I'll dig around more. In any case, my patch seems to be papering over
the problem rather than solving it, so we need a different fix.

Thanks,
Calvin

> >
> > As the above from CONFIG_DEBUG_KOBJECT suggests, "end_device-6:0:0" no longer
> > has a parent. The path to the enclosured device is:
> >
> > /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:15/end_device-6:0:15/target6:0:15/6:0:15:0/enclosure/6:0:15:0/ArrayDevice09
> >
> > Enclosure wants to re-add the device outside the enclosure:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/misc/enclosure.c#n404
> >
> > We melt when trying to re-add "ArrayDevice09" to the "6:0:15:0" directory
> > above the "enclosure" directory best I can tell. This is *incredibly*
> > confusing because kobj_add_internal() actually clobbers the parent pointer
> > if it's NULL:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/lib/kobject.c#n216
> >
> > So even though it appears that the parent was "6:0:15:0" here, it was
> > actually NULL when passed into kobj_add_internal(). Thus, we try to do
> > the add with the kset as our parent, and we get -ENOENT because that
> > node has been marked as inactive in kernfs as per here:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/kernfs/dir.c#n743
> >
> > Why is it inactive? I think, because __kernfs_remove() deleted an ancestor:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/kernfs/dir.c#n1243
> >
> > ...which brings us full circle.
> >
> >> Doesn't this need to be taken care in enclosure_removal?
> >
> > Even with enclosure compiled out, I still get a WARN like the following
> > for every block device being removed at rmmod (-dirty here is just from me
> > applying a fix to SES I sent to the list a few days ago):
> >
> > [  224.057286] ------------[ cut here ]------------
> > [  224.067696] WARNING: CPU: 1 PID: 5412 at fs/sysfs/group.c:237 sysfs_remove_group+0x10f/0x150
> > [  224.088007] sysfs group ffffffff83109ba0 not found for kobject 'sdc'
> > [  224.102283] Modules linked in: mpt3sas(-) <snip>
> > [  224.200483] CPU: 0 PID: 5412 Comm: rmmod Not tainted 4.6.0-dirty #4
> > [  224.219797] Hardware name: Wiwynn   HoneyBadger/PantherPlus, BIOS HBM6.71 02/03/2016
> > [  224.237001]  ffffffff82af6280 ffff8806e826f8b0 ffffffff81e13e54 ffff8806e826f928
> > [  224.253811]  0000000000000000 ffff8806e826f8f8 ffffffff81127822 ffffffff831a5968
> > [  224.270647]  ffff8806000000ed ffffed00dd04df21 0000000000000000 ffff880754ae3078
> > [  224.287462] Call Trace:
> > [  224.292953]  [<ffffffff81e13e54>] dump_stack+0x68/0x94
> > [  224.304433]  [<ffffffff81127822>] __warn+0x172/0x1b0
> > [  224.315514]  [<ffffffff811278f7>] warn_slowpath_fmt+0x97/0xb0
> > [  224.351845]  [<ffffffff816bbc1f>] sysfs_remove_group+0x10f/0x150
> > [  224.365252]  [<ffffffff81377814>] blk_trace_remove_sysfs+0x14/0x20
> > [  224.379021]  [<ffffffff81d966bf>] blk_unregister_queue+0xcf/0x120
> > [  224.392589]  [<ffffffff81dc8c7e>] del_gendisk+0x26e/0x600
> > [  224.432345]  [<ffffffff8215ea75>] sd_remove+0xf5/0x1b0
> > [  224.443808]  [<ffffffff820dd210>] __device_release_driver+0x160/0x3a0
> > [  224.458151]  [<ffffffff820dd475>] device_release_driver+0x25/0x40
> > [  224.471734]  [<ffffffff820dbd81>] bus_remove_device+0x2e1/0x4b0
> > [  224.484926]  [<ffffffff820d25ad>] device_del+0x37d/0x680
> > [  224.555423]  [<ffffffff82148225>] __scsi_remove_device+0x1e5/0x250
> > [  224.569196]  [<ffffffff821443bc>] scsi_forget_host+0x12c/0x1e0
> > [  224.582197]  [<ffffffff82120b6c>] scsi_remove_host+0x10c/0x300
> > [  224.595227]  [<ffffffffa0066cc9>] scsih_remove+0x339/0x670 [mpt3sas]
> > [  224.609383]  [<ffffffff81edd400>] pci_device_remove+0x70/0x110
> > [  224.622379]  [<ffffffff820dd210>] __device_release_driver+0x160/0x3a0
> > [  224.636724]  [<ffffffff820de7b3>] driver_detach+0x183/0x200
> > [  224.649166]  [<ffffffff820dc61f>] bus_remove_driver+0xdf/0x200
> > [  224.662185]  [<ffffffff820df2e7>] driver_unregister+0x67/0xa0
> > [  224.675009]  [<ffffffff81edb2ee>] pci_unregister_driver+0x1e/0xe0
> > [  224.688613]  [<ffffffffa0093a3a>] _mpt3sas_exit+0x23/0x5e9 [mpt3sas]
> > [  224.702782]  [<ffffffff812a2d1b>] SyS_delete_module+0x2eb/0x390
> > [  224.743359]  [<ffffffff829529e5>] entry_SYSCALL_64_fastpath+0x18/0xa8
> > [  224.759036] ---[ end trace 13f1919bf2ec7bb0 ]---
> >
> > My patch fixes that too :)
> >
> > The only driver besides mpt*sas that calls sas_delete_port() explicitly is
> > HPSA, and it does it in the opposite order mpt3sas does: scsi_remove_host()
> > first.
> >
> > Thanks,
> > Calvin
> >
> >> -----Original Message-----
> >> From: Calvin Owens [mailto:calvinowens@fb.com]
> >> Sent: Monday, May 16, 2016 2:25 PM
> >> To: Elliott, Robert (Persistent Memory)
> >> Cc: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; James E.J.
> >> Bottomley; Martin K. Petersen; MPT-FusionLinux.pdl@broadcom.com;
> >> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> >> kernel-team@fb.com; calvinowens@fb.com
> >> Subject: Re: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY
> >> objects
> >>
> >> On Friday 05/13 at 21:17 +0000, Elliott, Robert (Persistent Memory) wrote:
> >> >
> >> >
> >> > > -----Original Message-----
> >> > > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> >> > > owner@vger.kernel.org] On Behalf Of Calvin Owens
> >> > > Sent: Friday, May 13, 2016 3:28 PM
> >> > ...
> >> > > Subject: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS
> >> > > PHY objects
> >> > >
> >> > ...
> >> > > The issue is that enclosure_remove_device() expects to be able to
> >> > > re-add the device that was previously enclosured: so with SES
> >> > > running, the order we unwind things matters in a way it otherwise
> >> > > wouldn't.
> >> > >
> >> > > Since mpt3sas deletes the SAS objects before the SCSI hosts,
> >> > > enclosure ends up trying to re-parent the SCSI device from the
> >> > > enclosure to the SAS PHY which has already been deleted. This obviously
> >> > > ends in sadness.
> >> > >
> >> > > The fix appears to be simple: just call scsi_remove_host() before we
> >> > > call
> >> > > sas_port_delete() and/or sas_remove_host().
> >> > >
> >> > ...
> >> > > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >> > > @@ -8149,6 +8149,8 @@ void scsih_remove(struct pci_dev *pdev)
> >> > >           _scsih_raid_device_remove(ioc, raid_device);
> >> > >   }
> >> > >
> >> > > + scsi_remove_host(shost);
> >> > > +
> >> > >   /* free ports attached to the sas_host */
> >> > >   list_for_each_entry_safe(mpt3sas_port, next_port,
> >> > >      &ioc->sas_hba.sas_port_list, port_list) { @@ -8172,7 +8174,6 @@
> >> > > void scsih_remove(struct pci_dev *pdev)
> >> > >   }
> >> > >
> >> > >   sas_remove_host(shost);
> >> > > - scsi_remove_host(shost);
> >> > >   mpt3sas_base_detach(ioc);
> >> > >   spin_lock(&gioc_lock);
> >> > >   list_del(&ioc->list);
> >> >
> >> > That change matches the pattern of all other drivers calling
> >> > sas_remove_host, except for one:
> >> >     drivers/message/fusion/mptsas.c
> >> >
> >> > That consensus means this comment in drivers/scsi/scsi_transport_sas.c
> >> > is wrong:
> >> >
> >> > /**
> >> >  * sas_remove_host  -  tear down a Scsi_Host's SAS data structures
> >> >  * @shost:      Scsi Host that is torn down
> >> >  *
> >> >  * Removes all SAS PHYs and remote PHYs for a given Scsi_Host.
> >> >  * Must be called just before scsi_remove_host for SAS HBAs.
> >> >  */
> >>
> >> Yes, exactly: that comment appears to be backwards, and as you say most
> >> drivers appear to do the opposite (I looked at HPSA at least, which calls
> >> sas_port_delete() before scsi_remove_host()).
> >>
> >> I suppose I should send a patch to fix the comment as well? It'd be nice to
> >> get some testing to be certain I'm not breaking somebody else's setup by
> >> fixing mine though...
> >>
> >> Thanks,
> >> Calvin
