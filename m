From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [PATCH] SCSI: limit mode sense usage
Date: Mon, 27 Oct 2003 20:51:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067313069.1277.17.camel@ronald.kuetemeier.com>
References: <1067293080.1075.8.camel@ronald.kuetemeier.com>
	 <20031027145531.A2130@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Qp3DefEBv8gAJkBSXTsv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:7443 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S263839AbTJ1Dvh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 22:51:37 -0500
In-Reply-To: <20031027145531.A2130@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net


--=-Qp3DefEBv8gAJkBSXTsv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Patrick,
attached is a file (err_messages.txt) from an attempt to attach my Sony
camera (S70) via usb-storage to my system. 
It should include the relevant errors, if you want me to try something
else let me know. It's the only usb and scsi device on that system, so I
won't be able to kill anything else.
I have also attached a file (succ_messages.txt) after I did:
echo "Sony:Sony DSC:0x4000" > /proc/scsi/device_info
which shows a successful (yeah) attempt to connect the camera to the
system.
If you need anything else, just let me know.
Thanks for your help.
Ronald
BTW: I'm not on either list, if you (list users) have questions, need me
to try something else. Please contact me directly.
PS: Sorry for the cross posting, but maybe we can figure it out this
way. 


On Mon, 2003-10-27 at 15:55, Patrick Mansfield wrote:
> On Mon, Oct 27, 2003 at 03:18:00PM -0700, Ronald Kuetemeier wrote:
> > According to the -test9 changelog:
> > "USB mass storage and removable media (for testing mode page 3f use)
> > were not tested, if you have a USB storage device that still chokes on
> > mode sense 3f please give this a spin."
> > 
> > I did give it a spin and it didn't work. So I changed 
> > 
> > --- ./drivers/usb/storage/scsiglue.c    Sat Oct 25 12:43:38 2003
> > +++ ./drivers/usb/storage/scsiglue.c.new        Mon Oct 27 14:58:04 2003
> > @@ -322,7 +322,7 @@
> >         .emulated =                     TRUE,
> >   
> >         /* modify scsi_device bits on probe */
> > -       .flags = (BLIST_MS_SKIP_PAGE_08 | BLIST_USE_10_BYTE_MS),
> > +       .flags = ( BLIST_MS_SKIP_PAGE_3F | BLIST_MS_SKIP_PAGE_08 |
> > BLIST_USE_10_BYTE_MS),
> >   
> >         /* module management */
> >         .module =                       THIS_MODULE
> > 
> > Which works. What's the correct way to set sdkp->device->skip_ms_page_3f
> > anyway?
> > Thanks for the patch, even if my Sony S70 needs a little more help.
> > Ronald
> 
> Ronald -
> 
> Can you get logs so we can tell exactly which mode sense request is
> failing? 
> 
> Run with scsi logging and perhaps usb debug enabled. FYI for scsi logging
> - make sure you have SCSI_CONFIG_LOGGING on, and prior to using your USB
> device, run (assuming you are not running syslogd to a scsi device!):
> 	
> 	sysctl -w dev.scsi.logging_level=0xffffffff
> 
> USB people will likely want USB debug logs - I don't have details on how
> to turn those on.
> 
> sd.c asks for the information 3 different ways. If we can figure out a way
> to get your device to give us back the information we want without
> hanging, that would be best (similiar to Linus' recent change to
> sd_read_cache_type), rather than having to black list it.
> 
> If the device can't handle page 0x3f (scsi mode sense get all pages) or
> whatever hangs it in sd_read_write_protect_flag:
> 
> I don't have a good answer long term how it should be handled - whether we
> should keep updating scsi_devinfo.c or not. Short term, you can definitely
> use the scsi_dev_flags, that is why I added the BLIST_MS_SKIP_PAGE_3F.
> 
> I do not think your patch above is correct for general use, since normally
> we want to see the result of page 3f.
> 
> Anyway, scsi_dev_flags usage -
> 
> Given that BLIST_MS_SKIP_PAGE_3F is 0x4000. And fill in vendor and model
> per your device (Sony and S70?).
> 
> Via /proc before attaching your device:
> 
> 	echo "vendor:model:0x4000" > /proc/scsi/devie_info
> 
> At boot time, scsi non-module, use:
> 
> 	scsi_mod.scsi_dev_flags=vendor:model:0x4000
> 
> Or, scsi_mod load time:
> 
> 	scsi_dev_flags=vendor_model:0x4000
> 
> If the above works, post your failed log, and success case, to linux-scsi
> and usb storage lists (linux-scsi@vger.kernel.org and
> usb-storage@one-eyed-alien.net).
> 
> I might post to linux-scsi about scsi_dev_flags, and what direction should
> we take long term for the scsi_devinfo.c blacklist, since Russel King had
> a post about it.
> 
> -- Patrick Mansfield
> 

--=-Qp3DefEBv8gAJkBSXTsv
Content-Disposition: attachment; filename=err_messages.txt
Content-Type: text/plain; name=err_messages.txt; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Oct 27 20:17:23 ronald kernel: hub 1-0:1.0: new USB device on port 2, assigned address 2
Oct 27 20:17:23 ronald kernel: usb 1-2: Product: Sony DSC
Oct 27 20:17:23 ronald kernel: usb 1-2: Manufacturer: Sony
Oct 27 20:17:23 ronald kernel: Wake up parent of scsi_eh_1
Oct 27 20:17:23 ronald kernel: Error handler scsi_eh_1 sleeping
Oct 27 20:17:23 ronald kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Oct 27 20:17:23 ronald kernel: scsi_scan_host_selected: <1:4294967295:4294967295:4294967295>
Oct 27 20:17:23 ronald kernel: scsi scan: INQUIRY to host 1 channel 0 id 0 lun 0
Oct 27 20:17:23 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 6000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0b16e80, 
Oct 27 20:17:23 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command finished 1 0 0x0
Oct 27 20:17:23 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:17:23 ronald kernel: scsi scan: 1st INQUIRY successful with code 0x0
Oct 27 20:17:23 ronald kernel:   Vendor: Sony      Model: Sony DSC          Rev: 2.10
Oct 27 20:17:23 ronald kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Oct 27 20:17:23 ronald kernel: sd_attach: scsi device: <1,0,0,0>
Oct 27 20:17:23 ronald kernel: sd_revalidate_disk: disk=sda
Oct 27 20:17:23 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 0, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command finished 1 0 0x0
Oct 27 20:17:23 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:17:23 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command finished 1 0 0x0
Oct 27 20:17:23 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:17:23 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 27 20:17:23 ronald kernel: sda: assuming  read_Write 1 0 
Oct 27 20:17:23 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: <reset failed: -32
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command finished 1 0 0x70000
Oct 27 20:17:23 ronald kernel: Notifying upper driver of completion for device 0 70000
Oct 27 20:17:23 ronald kernel: sda: Write Protect is off
Oct 27 20:17:23 ronald kernel: sda: assuming drive cache: write through
Oct 27 20:17:23 ronald kernel: sd_open: disk=sda
Oct 27 20:17:23 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:17:23 ronald kernel: sd_media_changed: disk=sda
Oct 27 20:17:23 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:17:23 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:17:23 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 10000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = 00000000, 
Oct 27 20:17:23 ronald kernel: bufflen = 0, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command finished 1 0 0x2
Oct 27 20:17:23 ronald kernel: Notifying upper driver of completion for device 0 8000002
Oct 27 20:17:23 ronald kernel: SCSI device (ioctl) reports ILLEGAL REQUEST.
Oct 27 20:17:23 ronald kernel: sd_revalidate_disk: disk=sda
Oct 27 20:17:23 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 0, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command finished 1 0 0x0
Oct 27 20:17:23 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:17:23 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command finished 1 0 0x0
Oct 27 20:17:23 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:17:23 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 27 20:17:23 ronald kernel: sda: assuming  read_Write 1 0 
Oct 27 20:17:23 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:23 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:23 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:23 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:23 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:23 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:23 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:23 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:24 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:24 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x70000
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 0 70000
Oct 27 20:17:24 ronald kernel: sda: Write Protect is off
Oct 27 20:17:24 ronald kernel: sda: assuming drive cache: write through
Oct 27 20:17:24 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 10000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = 00000000, 
Oct 27 20:17:24 ronald kernel: bufflen = 0, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x2
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 0 8000002
Oct 27 20:17:24 ronald kernel: sd_revalidate_disk: disk=sda
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:24 ronald kernel: bufflen = 0, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x0
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:24 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x0
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:17:24 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 27 20:17:24 ronald kernel: sda: assuming  read_Write 1 0 
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:24 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:24 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:24 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:24 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command needs retry 1 0 0x70000
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 30000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 0, command = cf12c1f4, buffer = c0671e00, 
Oct 27 20:17:24 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x70000
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 0 70000
Oct 27 20:17:24 ronald kernel: sda: Write Protect is off
Oct 27 20:17:24 ronald kernel: sda: assuming drive cache: write through
Oct 27 20:17:24 ronald kernel:  sda:sd_init_command: disk=sda, block=0, count=8
Oct 27 20:17:24 ronald kernel: Buffer I/O error on device sda, logical block 0
Oct 27 20:17:24 ronald kernel: sd_init_command: disk=sda, block=0, count=8
Oct 27 20:17:24 ronald kernel: Buffer I/O error on device sda, logical block 0
Oct 27 20:17:24 ronald kernel:  unable to read partition table
Oct 27 20:17:24 ronald kernel:  sda:sd_init_command: disk=sda, block=0, count=8
Oct 27 20:17:24 ronald kernel: Buffer I/O error on device sda, logical block 0
Oct 27 20:17:24 ronald kernel:  unable to read partition table
Oct 27 20:17:24 ronald kernel: sd_release: disk=sda
Oct 27 20:17:24 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:17:24 ronald kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Oct 27 20:17:24 ronald kernel: sg_attach: dev=1 
Oct 27 20:17:24 ronald kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
Oct 27 20:17:24 ronald kernel: scsi scan: Sequential scan of host 1 channel 0 id 0
Oct 27 20:17:24 ronald kernel: scsi scan: INQUIRY to host 1 channel 0 id 1 lun 0
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 6000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 1, command = cf12c1f4, buffer = c0b16e80, 
Oct 27 20:17:24 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 1 40000
Oct 27 20:17:24 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:17:24 ronald kernel: scsi scan: INQUIRY to host 1 channel 0 id 2 lun 0
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 6000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 2, command = cf12c1f4, buffer = c0b16e80, 
Oct 27 20:17:24 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 2 40000
Oct 27 20:17:24 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:17:24 ronald kernel: scsi scan: INQUIRY to host 1 channel 0 id 3 lun 0
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 6000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 3, command = cf12c1f4, buffer = c0b16e80, 
Oct 27 20:17:24 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 3 40000
Oct 27 20:17:24 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:17:24 ronald kernel: scsi scan: INQUIRY to host 1 channel 0 id 4 lun 0
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 6000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 4, command = cf12c1f4, buffer = c0b16e80, 
Oct 27 20:17:24 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 4 40000
Oct 27 20:17:24 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:17:24 ronald kernel: scsi scan: INQUIRY to host 1 channel 0 id 5 lun 0
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 6000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 5, command = cf12c1f4, buffer = c0b16e80, 
Oct 27 20:17:24 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:24 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:24 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:17:24 ronald kernel: Notifying upper driver of completion for device 5 40000
Oct 27 20:17:24 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:17:24 ronald kernel: scsi scan: INQUIRY to host 1 channel 0 id 6 lun 0
Oct 27 20:17:24 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:24 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 6000, (c02afcf0)
Oct 27 20:17:24 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 6, command = cf12c1f4, buffer = c0b16e80, 
Oct 27 20:17:24 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:17:24 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:24 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:25 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:25 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:17:25 ronald kernel: Notifying upper driver of completion for device 6 40000
Oct 27 20:17:25 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:17:25 ronald kernel: scsi scan: INQUIRY to host 1 channel 0 id 7 lun 0
Oct 27 20:17:25 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:17:25 ronald kernel: scsi_add_timer: scmd: cf12c1a0, time: 6000, (c02afcf0)
Oct 27 20:17:25 ronald kernel: scsi_dispatch_cmnd (host = 1, channel = 0, target = 7, command = cf12c1f4, buffer = c0b16e80, 
Oct 27 20:17:25 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:17:25 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:17:25 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:17:25 ronald kernel: scsi_delete_timer: scmd: cf12c1a0, rtn: 1
Oct 27 20:17:25 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:17:25 ronald kernel: Notifying upper driver of completion for device 7 40000
Oct 27 20:17:25 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:17:43 ronald kernel: SCSI device (ioctl) reports ILLEGAL REQUEST.
Oct 27 20:17:43 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 27 20:17:43 ronald kernel: sda: assuming  read_Write 1 0 
Oct 27 20:17:43 ronald kernel: sda: Write Protect is off
Oct 27 20:17:43 ronald kernel: sda: assuming drive cache: write through
Oct 27 20:17:43 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 27 20:17:43 ronald kernel: sda: assuming  read_Write 1 0 
Oct 27 20:17:43 ronald kernel: sda: Write Protect is off
Oct 27 20:17:43 ronald kernel: sda: assuming drive cache: write through
Oct 27 20:17:43 ronald kernel:  sda:<3>Buffer I/O error on device sda, logical block 0
Oct 27 20:17:43 ronald kernel: Buffer I/O error on device sda, logical block 0
Oct 27 20:17:43 ronald kernel:  unable to read partition table

--=-Qp3DefEBv8gAJkBSXTsv
Content-Disposition: attachment; filename=succ_messages.txt
Content-Type: text/plain; name=succ_messages.txt; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Oct 27 20:28:35 ronald kernel: usb 1-2: USB disconnect, address 2
Oct 27 20:29:01 ronald kernel: hub 1-0:1.0: new USB device on port 2, assigned address 3
Oct 27 20:29:01 ronald kernel: usb 1-2: Product: Sony DSC
Oct 27 20:29:01 ronald kernel: usb 1-2: Manufacturer: Sony
Oct 27 20:29:01 ronald kernel: scsi2 : SCSI emulation for USB Mass Storage devices
Oct 27 20:29:01 ronald kernel:   Vendor: Sony      Model: Sony DSC          Rev: 2.10
Oct 27 20:29:01 ronald kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Oct 27 20:29:01 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 27 20:29:01 ronald kernel: sda: assuming  read_Write 0 1 
Oct 27 20:29:01 ronald kernel: sda: assuming Write Enabled
Oct 27 20:29:01 ronald kernel: sda: cache data unavailable
Oct 27 20:29:01 ronald kernel: sda: assuming drive cache: write through
Oct 27 20:29:01 ronald kernel:  sda:<7>usb-storage: queuecommand called
Oct 27 20:29:01 ronald kernel:  sda1
Oct 27 20:29:01 ronald kernel: Attached scsi removable disk sda at scsi2, channel 0, id 0, lun 0
Oct 27 20:29:01 ronald kernel: Attached scsi generic sg1 at scsi2, channel 0, id 0, lun 0,  type 0
Oct 27 20:29:23 ronald kernel: usb 1-2: USB disconnect, address 3
Oct 27 20:30:02 ronald kernel: hub 1-0:1.0: new USB device on port 2, assigned address 4
Oct 27 20:30:02 ronald kernel: usb 1-2: Product: Sony DSC
Oct 27 20:30:02 ronald kernel: usb 1-2: Manufacturer: Sony
Oct 27 20:30:02 ronald kernel: Wake up parent of scsi_eh_3
Oct 27 20:30:02 ronald kernel: Error handler scsi_eh_3 sleeping
Oct 27 20:30:02 ronald kernel: scsi3 : SCSI emulation for USB Mass Storage devices
Oct 27 20:30:02 ronald kernel: scsi_scan_host_selected: <3:4294967295:4294967295:4294967295>
Oct 27 20:30:02 ronald kernel: scsi scan: INQUIRY to host 3 channel 0 id 0 lun 0
Oct 27 20:30:02 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:02 ronald kernel: scsi_add_timer: scmd: cf12c420, time: 6000, (c02afcf0)
Oct 27 20:30:02 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 0, command = cf12c474, buffer = c0756ec0, 
Oct 27 20:30:02 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:30:02 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:02 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:02 ronald kernel: scsi_delete_timer: scmd: cf12c420, rtn: 1
Oct 27 20:30:02 ronald kernel: Command finished 1 0 0x0
Oct 27 20:30:02 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:30:02 ronald kernel: scsi scan: 1st INQUIRY successful with code 0x0
Oct 27 20:30:02 ronald kernel:   Vendor: Sony      Model: Sony DSC          Rev: 2.10
Oct 27 20:30:02 ronald kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Oct 27 20:30:02 ronald kernel: sd_attach: scsi device: <3,0,0,0>
Oct 27 20:30:02 ronald kernel: sd_revalidate_disk: disk=sdb
Oct 27 20:30:02 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:02 ronald kernel: scsi_add_timer: scmd: cf12c420, time: 30000, (c02afcf0)
Oct 27 20:30:02 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 0, command = cf12c474, buffer = c07b0e00, 
Oct 27 20:30:02 ronald kernel: bufflen = 0, done = c02b1b10)
Oct 27 20:30:02 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:02 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:02 ronald kernel: scsi_delete_timer: scmd: cf12c420, rtn: 1
Oct 27 20:30:02 ronald kernel: Command finished 1 0 0x0
Oct 27 20:30:02 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:30:02 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:02 ronald kernel: scsi_add_timer: scmd: cf12c420, time: 30000, (c02afcf0)
Oct 27 20:30:02 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 0, command = cf12c474, buffer = c07b0e00, 
Oct 27 20:30:02 ronald kernel: bufflen = 8, done = c02b1b10)
Oct 27 20:30:02 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:02 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:02 ronald kernel: scsi_delete_timer: scmd: cf12c420, rtn: 1
Oct 27 20:30:02 ronald kernel: Command finished 1 0 0x0
Oct 27 20:30:02 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:30:02 ronald kernel: SCSI device sdb: 63424 512-byte hdwr sectors (32 MB)
Oct 27 20:30:02 ronald kernel: sdb: assuming  read_Write 0 1 
Oct 27 20:30:02 ronald kernel: sdb: assuming Write Enabled
Oct 27 20:30:02 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:02 ronald kernel: scsi_add_timer: scmd: cf12c420, time: 30000, (c02afcf0)
Oct 27 20:30:02 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 0, command = cf12c474, buffer = c07b0e00, 
Oct 27 20:30:02 ronald kernel: bufflen = 4, done = c02b1b10)
Oct 27 20:30:02 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:02 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:02 ronald kernel: scsi_delete_timer: scmd: cf12c420, rtn: 1
Oct 27 20:30:02 ronald kernel: Command finished 1 0 0x2
Oct 27 20:30:02 ronald kernel: Notifying upper driver of completion for device 0 8000002
Oct 27 20:30:02 ronald kernel: sdb: cache data unavailable
Oct 27 20:30:02 ronald kernel: sdb: assuming drive cache: write through
Oct 27 20:30:02 ronald kernel: sd_open: disk=sdb
Oct 27 20:30:02 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:30:02 ronald kernel: sd_media_changed: disk=sdb
Oct 27 20:30:02 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:30:02 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:30:02 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:02 ronald kernel: scsi_add_timer: scmd: cf12c420, time: 10000, (c02afcf0)
Oct 27 20:30:02 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 0, command = cf12c474, buffer = 00000000, 
Oct 27 20:30:02 ronald kernel: bufflen = 0, done = c02b1b10)
Oct 27 20:30:02 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:02 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c420, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x0
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:30:03 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:30:03 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:03 ronald kernel: scsi_add_timer: scmd: cf12c420, time: 10000, (c02afcf0)
Oct 27 20:30:03 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 0, command = cf12c474, buffer = 00000000, 
Oct 27 20:30:03 ronald kernel: bufflen = 0, done = c02b1b10)
Oct 27 20:30:03 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:03 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c420, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x2
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 0 8000002
Oct 27 20:30:03 ronald kernel:  sdb:sd_init_command: disk=sdb, block=0, count=8
Oct 27 20:30:03 ronald kernel: sdb : block=0
Oct 27 20:30:03 ronald kernel: sdb : reading 8/8 512 byte blocks.
Oct 27 20:30:03 ronald kernel: scsi_add_timer: scmd: cf12c420, time: 30000, (c02afcf0)
Oct 27 20:30:03 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 0, command = cf12c474, buffer = cff609c0, 
Oct 27 20:30:03 ronald kernel: bufflen = 4096, done = c02b6d40)
Oct 27 20:30:03 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:03 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c420, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x0
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 0 0
Oct 27 20:30:03 ronald kernel: sd_rw_intr: sdb: res=0x0
Oct 27 20:30:03 ronald kernel: 8 sectors total, 8 sectors done.
Oct 27 20:30:03 ronald kernel: use_sg is 1
Oct 27 20:30:03 ronald kernel:  sdb1
Oct 27 20:30:03 ronald kernel: sd_release: disk=sdb
Oct 27 20:30:03 ronald kernel: scsi_block_when_processing_errors: rtn: 1
Oct 27 20:30:03 ronald kernel: Attached scsi removable disk sdb at scsi3, channel 0, id 0, lun 0
Oct 27 20:30:03 ronald kernel: sg_attach: dev=1 
Oct 27 20:30:03 ronald kernel: Attached scsi generic sg1 at scsi3, channel 0, id 0, lun 0,  type 0
Oct 27 20:30:03 ronald kernel: scsi scan: Sequential scan of host 3 channel 0 id 0
Oct 27 20:30:03 ronald kernel: scsi scan: INQUIRY to host 3 channel 0 id 1 lun 0
Oct 27 20:30:03 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:03 ronald kernel: scsi_add_timer: scmd: cf12c560, time: 6000, (c02afcf0)
Oct 27 20:30:03 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 1, command = cf12c5b4, buffer = c0756ec0, 
Oct 27 20:30:03 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:30:03 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:03 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c560, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 1 40000
Oct 27 20:30:03 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:30:03 ronald kernel: scsi scan: INQUIRY to host 3 channel 0 id 2 lun 0
Oct 27 20:30:03 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:03 ronald kernel: scsi_add_timer: scmd: cf12c560, time: 6000, (c02afcf0)
Oct 27 20:30:03 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 2, command = cf12c5b4, buffer = c0756ec0, 
Oct 27 20:30:03 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:30:03 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:03 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c560, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 2 40000
Oct 27 20:30:03 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:30:03 ronald kernel: scsi scan: INQUIRY to host 3 channel 0 id 3 lun 0
Oct 27 20:30:03 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:03 ronald kernel: scsi_add_timer: scmd: cf12c560, time: 6000, (c02afcf0)
Oct 27 20:30:03 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 3, command = cf12c5b4, buffer = c0756ec0, 
Oct 27 20:30:03 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:30:03 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:03 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c560, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 3 40000
Oct 27 20:30:03 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:30:03 ronald kernel: scsi scan: INQUIRY to host 3 channel 0 id 4 lun 0
Oct 27 20:30:03 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:03 ronald kernel: scsi_add_timer: scmd: cf12c560, time: 6000, (c02afcf0)
Oct 27 20:30:03 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 4, command = cf12c5b4, buffer = c0756ec0, 
Oct 27 20:30:03 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:30:03 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:03 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c560, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 4 40000
Oct 27 20:30:03 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:30:03 ronald kernel: scsi scan: INQUIRY to host 3 channel 0 id 5 lun 0
Oct 27 20:30:03 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:03 ronald kernel: scsi_add_timer: scmd: cf12c560, time: 6000, (c02afcf0)
Oct 27 20:30:03 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 5, command = cf12c5b4, buffer = c0756ec0, 
Oct 27 20:30:03 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:30:03 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:03 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c560, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 5 40000
Oct 27 20:30:03 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:30:03 ronald kernel: scsi scan: INQUIRY to host 3 channel 0 id 6 lun 0
Oct 27 20:30:03 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:03 ronald kernel: scsi_add_timer: scmd: cf12c560, time: 6000, (c02afcf0)
Oct 27 20:30:03 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 6, command = cf12c5b4, buffer = c0756ec0, 
Oct 27 20:30:03 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:30:03 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:03 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c560, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 6 40000
Oct 27 20:30:03 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000
Oct 27 20:30:03 ronald kernel: scsi scan: INQUIRY to host 3 channel 0 id 7 lun 0
Oct 27 20:30:03 ronald kernel: Leaving scsi_init_cmd_from_req()
Oct 27 20:30:03 ronald kernel: scsi_add_timer: scmd: cf12c560, time: 6000, (c02afcf0)
Oct 27 20:30:03 ronald kernel: scsi_dispatch_cmnd (host = 3, channel = 0, target = 7, command = cf12c5b4, buffer = c0756ec0, 
Oct 27 20:30:03 ronald kernel: bufflen = 36, done = c02b1b10)
Oct 27 20:30:03 ronald kernel: queuecommand : routine at c02d3b90
Oct 27 20:30:03 ronald kernel: leaving scsi_dispatch_cmnd()
Oct 27 20:30:03 ronald kernel: scsi_delete_timer: scmd: cf12c560, rtn: 1
Oct 27 20:30:03 ronald kernel: Command finished 1 0 0x40000
Oct 27 20:30:03 ronald kernel: Notifying upper driver of completion for device 7 40000
Oct 27 20:30:03 ronald kernel: scsi scan: 1st INQUIRY failed with code 0x40000

--=-Qp3DefEBv8gAJkBSXTsv--

