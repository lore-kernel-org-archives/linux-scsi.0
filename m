From: Praveen Murali <pmurali@logicube.com>
Subject: RE: sysfs group not found for kobject on mvsas drive removal
Date: Thu, 7 May 2015 18:08:47 +0000
Message-ID: <16adc53b67b247f49bc46ff20a9d55d4@EX01.lg.local>
References: <c952e6a1dc4b4badb3b4a55272bfbc48@EX01.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:57439 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbbEGSJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2015 14:09:55 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James Bottomley (James.Bottomley@HansenPartnership.com)" <James.Bottomley@HansenPartnership.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hey Guys,
  Am I on the right track? Or am I missing something? 

Praveen

> -----Original Message----- > 
From: Praveen Murali
> Sent: Friday, May 01, 2015 5:46 PM
> To: James Bottomley (James.Bottomley@HansenPartnership.com);
> dan.j.williams@intel.com
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: sysfs group not found for kobject on mvsas drive removal
> 
> After some debugging this is what I have found
> 
> sas_phye_loss_of_signal gets triggered on phy_event from mvsas
> 	sas_phye_loss_of_signal calls sas_deform_port
> 		sas_deform_port posts a DISCE_DESTRUCT event
> (sas_unregister_domain_devices-> sas_unregister_dev)
> 		sas_deform_port calls sas_port_delete
> 			sas_port_delete calls sas_port_delete_link
> 				sysfs_remove_group: kobject 'port-X:Y'
> 			sas_port_delete calls device_del
> 				sysfs_remove_group: kobject 'port-X:Y'
> 
> sas_destruct_devices gets triggered for the destruct event (DISCE_DESTRUCT)
> 	sas_destruct_devices calls sas_rphy_delete
> 		sas_rphy_delete calls scsi_remove_device
> 			scsi_remove_device calls __scsi_remove_device
> 				__scsi_remove_device calls
> bsg_unregister_queue
> 					bsg_unregister_queue ->
> device_unregister -> device_del -> sysfs_remove_group: kobject 'X:0:0:0'
> 
> Since X:0:0:0 falls under port-X:Y (which got deleted during sas_port_delete),
> this call results in the warning. All the later warnings in the dmesg output I sent
> earlier are trying to delete objects under port-X:Y. Since port-X:Y got
> recursively deleted, all these calls result in warnings. Since, the PHY and DISC
> events are processed in two different work queues (and one triggers the other),
> is there any way other than checking if the object exists in sysfs (in device_del)
> before deleting?
> 
> Praveen
> 
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Praveen Murali
> > Sent: Friday, May 01, 2015 1:47 PM
> > To: James Bottomley (James.Bottomley@HansenPartnership.com);
> > dan.j.williams@intel.com
> > Cc: linux-scsi@vger.kernel.org
> > Subject: sysfs group not found for kobject on mvsas drive removal
> >
> > Hi Guys,
> >   I have a server with the Marvell SAS HBA and in the newer versions of the
> > kernel I have been seeing a whole bunch of this "sysfs group not found for
> > kobject" warnings when a drive is removed; I am specifically trying to get the
> > 3.16 kernel up and running. Looking around I found there were a few reports
> > and patches on this issue which have been included in and around 3.14. The
> last
> > one (I believe) was by Joe Lawrence (scsi_transport_sas: move bsg destructor
> > into sas_rphy_remove). I checked the sources and looks like all patches are
> > included but I still see this issue.
> >  Could this be an issue with the order in which mvsas driver does the tear
> down
> > during drive removal? Following is a snippet of the trace. I have attached the
> > full logs to the mail which contains rest of the trace with all the warnings
> > related to a drive removal. Any ideas?
> >
> > Thanks,
> > Praveen
> >
> > [ 2338.512534] ------------[ cut here ]------------
> > [ 2338.512551] WARNING: CPU: 2 PID: 6 at fs/sysfs/group.c:219
> > device_del+0x40/0x1c0()
> > [ 2338.512557] sysfs group ffffffff818b97e0 not found for kobject '2:0:4:0'
> > [ 2338.512561] Modules linked in: g_mass_storage usb_f_mass_storage
> > libcomposite firewire_sbp2 iptable_filter ip_tables x_tables joydev sg
> > hid_multitouch usbhid hid firewire_ohci firewire_core crc_itu_t uhci_hcd
> > scsi_transport_iscsi evdev via_rng rng_core kvm_intel dm_dmirror
> dm_zcache
> > dm_mod kvm padlock_aes snd_hda_codec_hdmi psmouse
> snd_hda_codec_via
> > padlock_sha pcspkr snd_hda_codec_generic serio_raw tpm_tis tpm xhci_hcd
> > ehci_pci ehci_hcd shpchp usb3380 ac udc_core snd_hda_intel
> > snd_hda_controller snd_hda_codec snd_hwdep snd_pcm video r8169 mii
> > snd_timer snd soundcore mvsas iscsi_target_mod processor
> target_core_mod
> > button configfs sswipe libsas scsi_transport_sas picdev usbcore usb_common
> > via_cputemp hwmon_vid fuse parport_pc ppdev lp parport autofs4 ext4 crc16
> > mbcache jbd2 s3g(PO) sd_mod crc_t10dif crct10dif_common ahci libahci
> libata
> > scsi_mod fan thermal_sys s3g_drm(O) drm i2c_core [last unloaded:
> > libcomposite]
> > [ 2338.512724] CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: P        W  O
> 3.16.7-
> > ckt9-logicube-ng.3 #1
> > [ 2338.512729] Hardware name: To be filled by O.E.M. To be filled by
> > O.E.M./VT6085, BIOS 4.6.5 01/23/2015
> > [ 2338.512747] Workqueue: scsi_wq_2 sas_destruct_devices [libsas]
> > [ 2338.512751]  0000000000000009 ffffffff8151cd18 ffff88011b35bcd8
> > ffffffff810687b7
> > [ 2338.512760]  ffff88011a661400 ffff88011b35bd28 ffff8800c6e5e968
> > ffff880000028810
> > [ 2338.512767]  ffff8800c89f2c00 ffffffff8106881c ffffffff81733b68
> > 0000000000000028
> > [ 2338.512775] Call Trace:
> > [ 2338.512787]  [<ffffffff8151cd18>] ? dump_stack+0x41/0x51
> > [ 2338.512796]  [<ffffffff810687b7>] ? warn_slowpath_common+0x77/0x90
> > [ 2338.512804]  [<ffffffff8106881c>] ? warn_slowpath_fmt+0x4c/0x50
> > [ 2338.512812]  [<ffffffff813ad2d0>] ? device_del+0x40/0x1c0
> > [ 2338.512819]  [<ffffffff813ad46a>] ? device_unregister+0x1a/0x70
> > [ 2338.512828]  [<ffffffff812a535e>] ? bsg_unregister_queue+0x5e/0xb0
> > [ 2338.512847]  [<ffffffffa00781a9>] ? __scsi_remove_device+0xa9/0xd0
> > [scsi_mod]
> > [ 2338.512860]  [<ffffffffa00781f1>] ? scsi_remove_device+0x21/0x30
> > [scsi_mod]
> > [ 2338.512873]  [<ffffffffa0078392>] ? scsi_remove_target+0x162/0x260
> > [scsi_mod]
> > [ 2338.512885]  [<ffffffffa03639cd>] ? sas_rphy_remove+0x5d/0x70
> > [scsi_transport_sas]
> > [ 2338.512895]  [<ffffffffa0365f2e>] ? sas_rphy_delete+0xe/0x20
> > [scsi_transport_sas]
> > [ 2338.512905]  [<ffffffffa0384865>] ? sas_destruct_devices+0x65/0x90
> [libsas]
> > [ 2338.512914]  [<ffffffff81083054>] ? process_one_work+0x174/0x460
> > [ 2338.512921]  [<ffffffff81083a5b>] ? worker_thread+0x6b/0x530
> > [ 2338.512928]  [<ffffffff810839f0>] ? rescuer_thread+0x2d0/0x2d0
> > [ 2338.512936]  [<ffffffff81089ccf>] ? kthread+0xcf/0xf0
> > [ 2338.512945]  [<ffffffff81089c00>] ? kthread_create_on_node+0x180/0x180
> > [ 2338.512953]  [<ffffffff81522b58>] ? ret_from_fork+0x58/0x90
> > [ 2338.512961]  [<ffffffff81089c00>] ? kthread_create_on_node+0x180/0x180
> > [ 2338.512966] ---[ end trace a726bd98d3e66840 ]---
> > [ 2338.513091] ------------[ cut here ]------------
> > [ 2338.513100] WARNING: CPU: 2 PID: 6 at fs/sysfs/group.c:219
> > device_del+0x40/0x1c0()
> > [ 2338.513104] sysfs group ffffffff818b97e0 not found for kobject '2:0:4:0'
> > [ 2338.513107] Modules linked in: g_mass_storage usb_f_mass_storage
> > libcomposite firewire_sbp2 iptable_filter ip_tables x_tables joydev sg
> > hid_multitouch usbhid hid firewire_ohci firewire_core crc_itu_t uhci_hcd
> > scsi_transport_iscsi evdev via_rng rng_core kvm_intel dm_dmirror
> dm_zcache
> > dm_mod kvm padlock_aes snd_hda_codec_hdmi psmouse
> snd_hda_codec_via
> > padlock_sha pcspkr snd_hda_codec_generic serio_raw tpm_tis tpm xhci_hcd
> > ehci_pci ehci_hcd shpchp usb3380 ac udc_core snd_hda_intel
> > snd_hda_controller snd_hda_codec snd_hwdep snd_pcm video r8169 mii
> > snd_timer snd soundcore mvsas iscsi_target_mod processor
> target_core_mod
> > button configfs sswipe libsas scsi_transport_sas picdev usbcore usb_common
> > via_cputemp hwmon_vid fuse parport_pc ppdev lp parport autofs4 ext4 crc16
> > mbcache jbd2 s3g(PO) sd_mod crc_t10dif crct10dif_common ahci libahci
> libata
> > scsi_mod fan thermal_sys s3g_drm(O) drm i2c_core [last unloaded:
> > libcomposite]
> > [ 2338.513243] CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: P        W  O
> 3.16.7-
> > ckt9-logicube-ng.3 #1
> > [ 2338.513247] Hardware name: To be filled by O.E.M. To be filled by
> > O.E.M./VT6085, BIOS 4.6.5 01/23/2015
> > [ 2338.513258] Workqueue: scsi_wq_2 sas_destruct_devices [libsas]
> > [ 2338.513262]  0000000000000009 ffffffff8151cd18 ffff88011b35bce8
> > ffffffff810687b7
> > [ 2338.513270]  ffff8800c6e5ec20 ffff88011b35bd38 ffff8800c6e5e968
> > ffff880000028810
> > [ 2338.513277]  ffff8800c89f2c00 ffffffff8106881c ffffffff81733b68
> > 0000000000000028
> > [ 2338.513285] Call Trace:
> > [ 2338.513293]  [<ffffffff8151cd18>] ? dump_stack+0x41/0x51
> > [ 2338.513300]  [<ffffffff810687b7>] ? warn_slowpath_common+0x77/0x90
> > [ 2338.513308]  [<ffffffff8106881c>] ? warn_slowpath_fmt+0x4c/0x50
> > [ 2338.513317]  [<ffffffff812b9f70>] ? cleanup_uevent_env+0x10/0x10
> > [ 2338.513324]  [<ffffffff813ad2d0>] ? device_del+0x40/0x1c0
> > [ 2338.513331]  [<ffffffff813ad46a>] ? device_unregister+0x1a/0x70
> > [ 2338.513345]  [<ffffffffa00781b5>] ? __scsi_remove_device+0xb5/0xd0
> > [scsi_mod]
> > [ 2338.513358]  [<ffffffffa00781f1>] ? scsi_remove_device+0x21/0x30
> > [scsi_mod]
> > [ 2338.513370]  [<ffffffffa0078392>] ? scsi_remove_target+0x162/0x260
> > [scsi_mod]
> > [ 2338.513380]  [<ffffffffa03639cd>] ? sas_rphy_remove+0x5d/0x70
> > [scsi_transport_sas]
> > [ 2338.513390]  [<ffffffffa0365f2e>] ? sas_rphy_delete+0xe/0x20
> > [scsi_transport_sas]
> > [ 2338.513400]  [<ffffffffa0384865>] ? sas_destruct_devices+0x65/0x90
> [libsas]
> > [ 2338.513408]  [<ffffffff81083054>] ? process_one_work+0x174/0x460
> > [ 2338.513415]  [<ffffffff81083a5b>] ? worker_thread+0x6b/0x530
> > [ 2338.513422]  [<ffffffff810839f0>] ? rescuer_thread+0x2d0/0x2d0
> > [ 2338.513429]  [<ffffffff81089ccf>] ? kthread+0xcf/0xf0
> > [ 2338.513437]  [<ffffffff81089c00>] ? kthread_create_on_node+0x180/0x180
> > [ 2338.513445]  [<ffffffff81522b58>] ? ret_from_fork+0x58/0x90
> > [ 2338.513453]  [<ffffffff81089c00>] ? kthread_create_on_node+0x180/0x180
> > [ 2338.513458] ---[ end trace a726bd98d3e66841 ]---
> > [ 2338.513476] ------------[ cut here ]------------
