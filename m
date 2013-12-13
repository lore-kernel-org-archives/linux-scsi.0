From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 13:13:40 -0800
Message-ID: <20131213211340.GA2975@xanatos>
References: <20131213180907.GB10727@xanatos>
 <Pine.LNX.4.44L0.1312131316470.1185-100000@iolanthe.rowland.org>
 <20131213183343.GC27070@htj.dyndns.org>
 <1386962327.2055.54.camel@dabdike.int.hansenpartnership.com>
 <1386964999.2055.59.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab3LMVNm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 16:13:42 -0500
Content-Disposition: inline
In-Reply-To: <1386964999.2055.59.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 13, 2013 at 12:03:19PM -0800, James Bottomley wrote:
> Actually, I think I have this figured out.  There's a thinko in one of
> the scsi_target_reap() cases.  The original (and still existing) problem
> with targets is that nothing creates them and nothing destroys them, so,
> while we could rely on the refcounting of the device model to preserve
> the actual target object, we had no idea when to remove it from
> visibility.  That was the job of the reap reference, to track
> visibility.  It looks like the reap on device last put is occurring too
> late.  I think we should reap immediately after doing the sdev
> device_del, so does this fix the warn on? (I'm not sure because no-one
> has actually posted a backtrace, but it sounds like this is the
> problem).

I can confirm that this patch fixes both the sysfs warning, and the
issue with USB storage disconnect during video playback.  I did trigger
a new (possibly unrelated?) mutex deadlock warning.  dmesg is attached.

Sarah Sharp

> ---
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 8ff62c2..98d4eb3 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -399,8 +399,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	/* NULL queue means the device can't be used */
>  	sdev->request_queue = NULL;
>  
> -	scsi_target_reap(scsi_target(sdev));
> -
>  	kfree(sdev->inquiry);
>  	kfree(sdev);
>  
> @@ -1044,6 +1042,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	} else
>  		put_device(&sdev->sdev_dev);
>  
> +	scsi_target_reap(scsi_target(sdev));
> +
>  	/*
>  	 * Stop accepting new requests and wait until all queuecommand() and
>  	 * scsi_run_queue() invocations have finished before tearing down the
> 
> 

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="uas-james-fix-2013-12-13-13-02.txt"

Dec 13 13:02:02 xanatos kernel: [    7.029300] usb usb4: bus auto-suspend, wakeup 1
Dec 13 13:02:02 xanatos kernel: [    7.040327] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input11
Dec 13 13:02:02 xanatos kernel: [    7.112065] btusb 3-1.4:1.0: usb_probe_interface
Dec 13 13:02:02 xanatos kernel: [    7.112070] btusb 3-1.4:1.0: usb_probe_interface - got id
Dec 13 13:02:02 xanatos kernel: [    7.122731] usbcore: registered new interface driver btusb
Dec 13 13:02:02 xanatos kernel: [    7.167710] Linux video capture interface: v2.00
Dec 13 13:02:02 xanatos kernel: [    7.235181] uvcvideo 3-1.6:1.0: usb_probe_interface
Dec 13 13:02:02 xanatos kernel: [    7.235187] uvcvideo 3-1.6:1.0: usb_probe_interface - got id
Dec 13 13:02:02 xanatos kernel: [    7.235293] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b2ea)
Dec 13 13:02:02 xanatos kernel: [    7.242661] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.6/3-1.6:1.0/input/input20
Dec 13 13:02:02 xanatos kernel: [    7.244470] usbcore: registered new interface driver uvcvideo
Dec 13 13:02:02 xanatos kernel: [    7.244473] USB Video Class driver (1.1.1)
Dec 13 13:02:03 xanatos kernel: [    8.044806] bio: create slab <bio-2> at 2
Dec 13 13:02:03 xanatos kernel: [    8.261355] Adding 4085756k swap on /dev/mapper/cryptswap1.  Priority:-1 extents:1 across:4085756k SSFS
Dec 13 13:02:03 xanatos kernel: [    8.407323] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
Dec 13 13:02:03 xanatos kernel: [    8.510442] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
Dec 13 13:02:03 xanatos kernel: [    8.510945] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
Dec 13 13:02:03 xanatos kernel: [    8.516037] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
Dec 13 13:02:03 xanatos kernel: [    8.517364] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
Dec 13 13:02:03 xanatos kernel: [    8.785685] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
Dec 13 13:02:03 xanatos kernel: [    8.792724] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
Dec 13 13:02:04 xanatos kernel: [    8.876409] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
Dec 13 13:02:04 xanatos kernel: [    9.787586] usb 3-1.6: usb auto-suspend, wakeup 0
Dec 13 13:02:05 xanatos kernel: [    9.910341] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
Dec 13 13:02:06 xanatos kernel: [   11.169530] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
Dec 13 13:02:06 xanatos kernel: [   11.375342] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input19
Dec 13 13:02:07 xanatos kernel: [   11.917809] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
Dec 13 13:02:07 xanatos kernel: [   11.917863] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
Dec 13 13:02:12 xanatos kernel: [   17.125215] 
Dec 13 13:02:12 xanatos kernel: [   17.125218] ======================================================
Dec 13 13:02:12 xanatos kernel: [   17.125219] [ INFO: possible circular locking dependency detected ]
Dec 13 13:02:12 xanatos kernel: [   17.125221] 3.13.0-rc1+ #140 Not tainted
Dec 13 13:02:12 xanatos kernel: [   17.125221] -------------------------------------------------------
Dec 13 13:02:12 xanatos kernel: [   17.125222] lightdm/1764 is trying to acquire lock:
Dec 13 13:02:12 xanatos kernel: [   17.125223]  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff812b5c53>] ecryptfs_getxattr_lower+0x43/0x80
Dec 13 13:02:12 xanatos kernel: [   17.125230] 
Dec 13 13:02:12 xanatos kernel: [   17.125230] but task is already holding lock:
Dec 13 13:02:12 xanatos kernel: [   17.125231]  (&isp->smk_lock){+.+.+.}, at: [<ffffffff812eda3e>] smack_d_instantiate+0x5e/0x2e0
Dec 13 13:02:12 xanatos kernel: [   17.125236] 
Dec 13 13:02:12 xanatos kernel: [   17.125236] which lock already depends on the new lock.
Dec 13 13:02:12 xanatos kernel: [   17.125236] 
Dec 13 13:02:12 xanatos kernel: [   17.125237] 
Dec 13 13:02:12 xanatos kernel: [   17.125237] the existing dependency chain (in reverse order) is:
Dec 13 13:02:12 xanatos kernel: [   17.125238] 
Dec 13 13:02:12 xanatos kernel: [   17.125238] -> #2 (&isp->smk_lock){+.+.+.}:
Dec 13 13:02:12 xanatos kernel: [   17.125240]        [<ffffffff8109a683>] lock_acquire+0x93/0x120
Dec 13 13:02:12 xanatos kernel: [   17.125242]        [<ffffffff8165d70a>] mutex_lock_nested+0x6a/0x390
Dec 13 13:02:12 xanatos kernel: [   17.125245]        [<ffffffff812eda3e>] smack_d_instantiate+0x5e/0x2e0
Dec 13 13:02:12 xanatos kernel: [   17.125247]        [<ffffffff812e91fb>] security_d_instantiate+0x1b/0x30
Dec 13 13:02:12 xanatos kernel: [   17.125249]        [<ffffffff811bddc0>] d_instantiate+0x50/0x70
Dec 13 13:02:12 xanatos kernel: [   17.125251]        [<ffffffff81257a7e>] ext4_add_nondir+0x6e/0x80
Dec 13 13:02:12 xanatos kernel: [   17.125254]        [<ffffffff81257d04>] ext4_create+0x104/0x170
Dec 13 13:02:12 xanatos kernel: [   17.125256]        [<ffffffff811b53ed>] vfs_create+0xcd/0x130
Dec 13 13:02:12 xanatos kernel: [   17.125257]        [<ffffffff811b65f6>] do_last+0x11a6/0x13d0
Dec 13 13:02:12 xanatos kernel: [   17.125259]        [<ffffffff811b68db>] path_openat+0xbb/0x680
Dec 13 13:02:12 xanatos kernel: [   17.125260]        [<ffffffff811b76ba>] do_filp_open+0x3a/0x90
Dec 13 13:02:12 xanatos kernel: [   17.125262]        [<ffffffff811a524e>] do_sys_open+0x12e/0x210
Dec 13 13:02:12 xanatos kernel: [   17.125264]        [<ffffffff811a534e>] SyS_open+0x1e/0x20
Dec 13 13:02:12 xanatos kernel: [   17.125266]        [<ffffffff81669d96>] system_call_fastpath+0x1a/0x1f
Dec 13 13:02:12 xanatos kernel: [   17.125268] 
Dec 13 13:02:12 xanatos kernel: [   17.125268] -> #1 (jbd2_handle){+.+.+.}:
Dec 13 13:02:12 xanatos kernel: [   17.125270]        [<ffffffff8109a683>] lock_acquire+0x93/0x120
Dec 13 13:02:12 xanatos kernel: [   17.125272]        [<ffffffff8129a4ce>] start_this_handle+0x21e/0x5f0
Dec 13 13:02:12 xanatos kernel: [   17.125274]        [<ffffffff8129aa7b>] jbd2__journal_start+0xcb/0x1b0
Dec 13 13:02:12 xanatos kernel: [   17.125276]        [<ffffffff812788cd>] __ext4_journal_start_sb+0x6d/0x130
Dec 13 13:02:12 xanatos kernel: [   17.125278]        [<ffffffff81251a6b>] ext4_setattr+0x3bb/0x6f0
Dec 13 13:02:12 xanatos kernel: [   17.125279]        [<ffffffff811c3fe9>] notify_change+0x279/0x3d0
Dec 13 13:02:12 xanatos kernel: [   17.125281]        [<ffffffff811a3d3f>] do_truncate+0x6f/0xa0
Dec 13 13:02:12 xanatos kernel: [   17.125283]        [<ffffffff811b5f02>] do_last+0xab2/0x13d0
Dec 13 13:02:12 xanatos kernel: [   17.125284]        [<ffffffff811b68db>] path_openat+0xbb/0x680
Dec 13 13:02:12 xanatos kernel: [   17.125285]        [<ffffffff811b76ba>] do_filp_open+0x3a/0x90
Dec 13 13:02:12 xanatos kernel: [   17.125287]        [<ffffffff811a524e>] do_sys_open+0x12e/0x210
Dec 13 13:02:12 xanatos kernel: [   17.125288]        [<ffffffff811a534e>] SyS_open+0x1e/0x20
Dec 13 13:02:12 xanatos kernel: [   17.125290]        [<ffffffff81669d96>] system_call_fastpath+0x1a/0x1f
Dec 13 13:02:12 xanatos kernel: [   17.125292] 
Dec 13 13:02:12 xanatos kernel: [   17.125292] -> #0 (&sb->s_type->i_mutex_key#12){+.+.+.}:
Dec 13 13:02:12 xanatos kernel: [   17.125294]        [<ffffffff8109995e>] __lock_acquire+0x148e/0x1a10
Dec 13 13:02:12 xanatos kernel: [   17.125295]        [<ffffffff8109a683>] lock_acquire+0x93/0x120
Dec 13 13:02:12 xanatos kernel: [   17.125297]        [<ffffffff8165d70a>] mutex_lock_nested+0x6a/0x390
Dec 13 13:02:12 xanatos kernel: [   17.125298]        [<ffffffff812b5c53>] ecryptfs_getxattr_lower+0x43/0x80
Dec 13 13:02:12 xanatos kernel: [   17.125300]        [<ffffffff812b5ca9>] ecryptfs_getxattr+0x19/0x20
Dec 13 13:02:12 xanatos kernel: [   17.125302]        [<ffffffff812ed9af>] smk_fetch.isra.22+0x5f/0x90
Dec 13 13:02:12 xanatos kernel: [   17.125304]        [<ffffffff812edb1f>] smack_d_instantiate+0x13f/0x2e0
Dec 13 13:02:12 xanatos kernel: [   17.125305]        [<ffffffff812e91fb>] security_d_instantiate+0x1b/0x30
Dec 13 13:02:12 xanatos kernel: [   17.125307]        [<ffffffff811bddc0>] d_instantiate+0x50/0x70
Dec 13 13:02:12 xanatos kernel: [   17.125309]        [<ffffffff812b4b7d>] ecryptfs_lookup+0x13d/0x350
Dec 13 13:02:12 xanatos kernel: [   17.125311]        [<ffffffff811afded>] lookup_real+0x1d/0x50
Dec 13 13:02:12 xanatos kernel: [   17.125313]        [<ffffffff811b5f73>] do_last+0xb23/0x13d0
Dec 13 13:02:12 xanatos kernel: [   17.125315]        [<ffffffff811b68db>] path_openat+0xbb/0x680
Dec 13 13:02:12 xanatos kernel: [   17.125316]        [<ffffffff811b76ba>] do_filp_open+0x3a/0x90
Dec 13 13:02:12 xanatos kernel: [   17.125317]        [<ffffffff811a524e>] do_sys_open+0x12e/0x210
Dec 13 13:02:12 xanatos kernel: [   17.125319]        [<ffffffff811a534e>] SyS_open+0x1e/0x20
Dec 13 13:02:12 xanatos kernel: [   17.125321]        [<ffffffff81669d96>] system_call_fastpath+0x1a/0x1f
Dec 13 13:02:12 xanatos kernel: [   17.125322] 
Dec 13 13:02:12 xanatos kernel: [   17.125322] other info that might help us debug this:
Dec 13 13:02:12 xanatos kernel: [   17.125322] 
Dec 13 13:02:12 xanatos kernel: [   17.125324] Chain exists of:
Dec 13 13:02:12 xanatos kernel: [   17.125324]   &sb->s_type->i_mutex_key#12 --> jbd2_handle --> &isp->smk_lock
Dec 13 13:02:12 xanatos kernel: [   17.125324] 
Dec 13 13:02:12 xanatos kernel: [   17.125326]  Possible unsafe locking scenario:
Dec 13 13:02:12 xanatos kernel: [   17.125326] 
Dec 13 13:02:12 xanatos kernel: [   17.125327]        CPU0                    CPU1
Dec 13 13:02:12 xanatos kernel: [   17.125328]        ----                    ----
Dec 13 13:02:12 xanatos kernel: [   17.125329]   lock(&isp->smk_lock);
Dec 13 13:02:12 xanatos kernel: [   17.125330]                                lock(jbd2_handle);
Dec 13 13:02:12 xanatos kernel: [   17.125331]                                lock(&isp->smk_lock);
Dec 13 13:02:12 xanatos kernel: [   17.125332]   lock(&sb->s_type->i_mutex_key#12);
Dec 13 13:02:12 xanatos kernel: [   17.125334] 
Dec 13 13:02:12 xanatos kernel: [   17.125334]  *** DEADLOCK ***
Dec 13 13:02:12 xanatos kernel: [   17.125334] 
Dec 13 13:02:12 xanatos kernel: [   17.125335] 2 locks held by lightdm/1764:
Dec 13 13:02:12 xanatos kernel: [   17.125336]  #0:  (&type->i_mutex_dir_key#3){+.+.+.}, at: [<ffffffff811b57d0>] do_last+0x380/0x13d0
Dec 13 13:02:12 xanatos kernel: [   17.125339]  #1:  (&isp->smk_lock){+.+.+.}, at: [<ffffffff812eda3e>] smack_d_instantiate+0x5e/0x2e0
Dec 13 13:02:12 xanatos kernel: [   17.125342] 
Dec 13 13:02:12 xanatos kernel: [   17.125342] stack backtrace:
Dec 13 13:02:12 xanatos kernel: [   17.125344] CPU: 2 PID: 1764 Comm: lightdm Not tainted 3.13.0-rc1+ #140
Dec 13 13:02:12 xanatos kernel: [   17.125345] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Dec 13 13:02:12 xanatos kernel: [   17.125346]  ffffffff82275c10 ffff8800b3e07988 ffffffff81658ace ffffffff82275f70
Dec 13 13:02:12 xanatos kernel: [   17.125349]  ffff8800b3e079c8 ffffffff81654f8d ffff8800b3e07a20 ffff8800b9a327e0
Dec 13 13:02:12 xanatos kernel: [   17.125351]  0000000000000001 0000000000000002 ffff8800b9a32090 ffff8800b9a327e0
Dec 13 13:02:12 xanatos kernel: [   17.125353] Call Trace:
Dec 13 13:02:12 xanatos kernel: [   17.125356]  [<ffffffff81658ace>] dump_stack+0x4d/0x66
Dec 13 13:02:12 xanatos kernel: [   17.125358]  [<ffffffff81654f8d>] print_circular_bug+0x200/0x20f
Dec 13 13:02:12 xanatos kernel: [   17.125360]  [<ffffffff8109995e>] __lock_acquire+0x148e/0x1a10
Dec 13 13:02:12 xanatos kernel: [   17.125363]  [<ffffffff8106a958>] ? __kernel_text_address+0x58/0x80
Dec 13 13:02:12 xanatos kernel: [   17.125364]  [<ffffffff8109a683>] lock_acquire+0x93/0x120
Dec 13 13:02:12 xanatos kernel: [   17.125366]  [<ffffffff812b5c53>] ? ecryptfs_getxattr_lower+0x43/0x80
Dec 13 13:02:12 xanatos kernel: [   17.125368]  [<ffffffff8165d70a>] mutex_lock_nested+0x6a/0x390
Dec 13 13:02:12 xanatos kernel: [   17.125370]  [<ffffffff812b5c53>] ? ecryptfs_getxattr_lower+0x43/0x80
Dec 13 13:02:12 xanatos kernel: [   17.125372]  [<ffffffff812b5c53>] ecryptfs_getxattr_lower+0x43/0x80
Dec 13 13:02:12 xanatos kernel: [   17.125374]  [<ffffffff812b5ca9>] ecryptfs_getxattr+0x19/0x20
Dec 13 13:02:12 xanatos kernel: [   17.125376]  [<ffffffff812ed9af>] smk_fetch.isra.22+0x5f/0x90
Dec 13 13:02:12 xanatos kernel: [   17.125378]  [<ffffffff812edb1f>] smack_d_instantiate+0x13f/0x2e0
Dec 13 13:02:12 xanatos kernel: [   17.125380]  [<ffffffff812e91fb>] security_d_instantiate+0x1b/0x30
Dec 13 13:02:12 xanatos kernel: [   17.125382]  [<ffffffff811bddc0>] d_instantiate+0x50/0x70
Dec 13 13:02:12 xanatos kernel: [   17.125384]  [<ffffffff812b4b7d>] ecryptfs_lookup+0x13d/0x350
Dec 13 13:02:12 xanatos kernel: [   17.125386]  [<ffffffff811afded>] lookup_real+0x1d/0x50
Dec 13 13:02:12 xanatos kernel: [   17.125388]  [<ffffffff811b5f73>] do_last+0xb23/0x13d0
Dec 13 13:02:12 xanatos kernel: [   17.125389]  [<ffffffff811b1d78>] ? inode_permission+0x18/0x50
Dec 13 13:02:12 xanatos kernel: [   17.125391]  [<ffffffff811b2656>] ? link_path_walk+0x246/0x860
Dec 13 13:02:12 xanatos kernel: [   17.125392]  [<ffffffff81098100>] ? trace_hardirqs_on_caller+0xd0/0x1c0
Dec 13 13:02:12 xanatos kernel: [   17.125394]  [<ffffffff811b68db>] path_openat+0xbb/0x680
Dec 13 13:02:12 xanatos kernel: [   17.125396]  [<ffffffff8109812d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Dec 13 13:02:12 xanatos kernel: [   17.125397]  [<ffffffff810981fd>] ? trace_hardirqs_on+0xd/0x10
Dec 13 13:02:12 xanatos kernel: [   17.125399]  [<ffffffff811b76ba>] do_filp_open+0x3a/0x90
Dec 13 13:02:12 xanatos kernel: [   17.125401]  [<ffffffff81660f77>] ? _raw_spin_unlock+0x27/0x40
Dec 13 13:02:12 xanatos kernel: [   17.125403]  [<ffffffff811c5527>] ? __alloc_fd+0xa7/0x130
Dec 13 13:02:12 xanatos kernel: [   17.125405]  [<ffffffff811a524e>] do_sys_open+0x12e/0x210
Dec 13 13:02:12 xanatos kernel: [   17.125407]  [<ffffffff811a534e>] SyS_open+0x1e/0x20
Dec 13 13:02:12 xanatos kernel: [   17.125409]  [<ffffffff81669d96>] system_call_fastpath+0x1a/0x1f
Dec 13 13:03:40 xanatos kernel: [  105.233448] usb usb2: usb wakeup-resume
Dec 13 13:03:40 xanatos kernel: [  105.233460] usb usb2: usb auto-resume
Dec 13 13:03:40 xanatos kernel: [  105.233482] hub 2-0:1.0: hub_resume
Dec 13 13:03:40 xanatos kernel: [  105.233873] hub 2-0:1.0: port 2: status 0203 change 0001
Dec 13 13:03:40 xanatos kernel: [  105.337785] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
Dec 13 13:03:40 xanatos kernel: [  105.337930] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
Dec 13 13:03:40 xanatos kernel: [  105.450162] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
Dec 13 13:03:40 xanatos kernel: [  105.466512] usb 2-2: skipped 1 descriptor after endpoint
Dec 13 13:03:40 xanatos kernel: [  105.466519] usb 2-2: skipped 1 descriptor after endpoint
Dec 13 13:03:40 xanatos kernel: [  105.466530] usb 2-2: skipped 2 descriptors after endpoint
Dec 13 13:03:40 xanatos kernel: [  105.466534] usb 2-2: skipped 2 descriptors after endpoint
Dec 13 13:03:40 xanatos kernel: [  105.466537] usb 2-2: skipped 2 descriptors after endpoint
Dec 13 13:03:40 xanatos kernel: [  105.466540] usb 2-2: skipped 2 descriptors after endpoint
Dec 13 13:03:40 xanatos kernel: [  105.466686] usb 2-2: default language 0x0409
Dec 13 13:03:40 xanatos kernel: [  105.467139] usb 2-2: udev 2, busnum 2, minor = 129
Dec 13 13:03:40 xanatos kernel: [  105.467143] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
Dec 13 13:03:40 xanatos kernel: [  105.467145] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
Dec 13 13:03:40 xanatos kernel: [  105.467148] usb 2-2: Product: Plugable USB3-SATA-UASP1
Dec 13 13:03:40 xanatos kernel: [  105.467150] usb 2-2: Manufacturer: ASM1053E
Dec 13 13:03:40 xanatos kernel: [  105.467151] usb 2-2: SerialNumber: 123456789045
Dec 13 13:03:40 xanatos kernel: [  105.467641] usb 2-2: usb_probe_device
Dec 13 13:03:40 xanatos kernel: [  105.467646] usb 2-2: configuration #1 chosen from 1 choice
Dec 13 13:03:40 xanatos kernel: [  105.468564] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
Dec 13 13:03:40 xanatos kernel: [  105.469546] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
Dec 13 13:03:40 xanatos kernel: [  105.499291] usb-storage 2-2:1.0: usb_probe_interface
Dec 13 13:03:40 xanatos kernel: [  105.499299] usb-storage 2-2:1.0: usb_probe_interface - got id
Dec 13 13:03:40 xanatos kernel: [  105.500040] usbcore: registered new interface driver usb-storage
Dec 13 13:03:40 xanatos kernel: [  105.503635] uas 2-2:1.0: usb_probe_interface
Dec 13 13:03:40 xanatos kernel: [  105.503640] uas 2-2:1.0: usb_probe_interface - got id
Dec 13 13:03:40 xanatos kernel: [  105.507154] scsi6 : uas
Dec 13 13:03:40 xanatos kernel: [  105.508103] usbcore: registered new interface driver uas
Dec 13 13:03:40 xanatos kernel: [  105.508567] scsi 6:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
Dec 13 13:03:40 xanatos kernel: [  105.509797] sd 6:0:0:0: Attached scsi generic sg1 type 0
Dec 13 13:03:40 xanatos kernel: [  105.510582] sd 6:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
Dec 13 13:03:40 xanatos kernel: [  105.511360] sd 6:0:0:0: [sdb] Write Protect is off
Dec 13 13:03:40 xanatos kernel: [  105.511363] sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
Dec 13 13:03:40 xanatos kernel: [  105.511724] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 13 13:03:40 xanatos kernel: [  105.515268]  sdb: sdb1 sdb2 sdb4
Dec 13 13:03:40 xanatos kernel: [  105.518270] sd 6:0:0:0: [sdb] Attached SCSI disk
Dec 13 13:03:41 xanatos kernel: [  106.194085] FAT-fs (sdb4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
Dec 13 13:03:41 xanatos kernel: [  106.197181] kjournald starting.  Commit interval 5 seconds
Dec 13 13:03:41 xanatos kernel: [  106.198121] EXT3-fs (sdb1): using internal journal
Dec 13 13:03:41 xanatos kernel: [  106.198128] EXT3-fs (sdb1): recovery complete
Dec 13 13:03:41 xanatos kernel: [  106.198130] EXT3-fs (sdb1): mounted filesystem with ordered data mode
Dec 13 13:03:41 xanatos kernel: [  106.200429] EXT4-fs (sdb2): recovery complete
Dec 13 13:03:41 xanatos kernel: [  106.203643] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
Dec 13 13:03:46 xanatos kernel: [  110.914386] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
Dec 13 13:03:46 xanatos kernel: [  110.914591] hub 2-0:1.0: warm reset port 2
Dec 13 13:03:46 xanatos kernel: [  110.969514] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
Dec 13 13:03:46 xanatos kernel: [  111.025947] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
Dec 13 13:03:46 xanatos kernel: [  111.025964] usb 2-2: USB disconnect, device number 2
Dec 13 13:03:46 xanatos kernel: [  111.025967] usb 2-2: unregistering device
Dec 13 13:03:46 xanatos kernel: [  111.025971] usb 2-2: unregistering interface 2-2:1.0
Dec 13 13:03:46 xanatos kernel: [  111.026263] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
Dec 13 13:03:46 xanatos kernel: [  111.026305] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
Dec 13 13:03:46 xanatos kernel: [  111.040389] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
Dec 13 13:03:46 xanatos kernel: [  111.040440] Aborting journal on device sdb2-8.
Dec 13 13:03:46 xanatos kernel: [  111.040458] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
Dec 13 13:03:46 xanatos kernel: [  111.040468] journal commit I/O error
Dec 13 13:03:46 xanatos kernel: [  111.043848] sd 6:0:0:0: [sdb] Synchronizing SCSI cache
Dec 13 13:03:46 xanatos kernel: [  111.093454] EXT3-fs (sdb1): I/O error while writing superblock
Dec 13 13:03:46 xanatos kernel: [  111.157506] sd 6:0:0:0: [sdb]  
Dec 13 13:03:46 xanatos kernel: [  111.157513] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
Dec 13 13:03:46 xanatos kernel: [  111.158093] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
Dec 13 13:03:46 xanatos kernel: [  111.158143] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
Dec 13 13:03:46 xanatos kernel: [  111.158238] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
Dec 13 13:03:46 xanatos kernel: [  111.158267] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
Dec 13 13:03:46 xanatos kernel: [  111.158289] usb 2-2: usb_disable_device nuking all URBs
Dec 13 13:03:46 xanatos kernel: [  111.285629] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
Dec 13 13:03:46 xanatos kernel: [  111.285636] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
Dec 13 13:03:46 xanatos kernel: [  111.285780] hub 2-0:1.0: hub_suspend
Dec 13 13:03:46 xanatos kernel: [  111.285792] usb usb2: bus auto-suspend, wakeup 1
Dec 13 13:03:46 xanatos kernel: [  111.750203] EXT4-fs error (device sdb2): ext4_put_super:791: Couldn't clean up the journal
Dec 13 13:03:46 xanatos kernel: [  111.750209] EXT4-fs (sdb2): Remounting filesystem read-only
Dec 13 13:04:04 xanatos kernel: [  129.385279] usb usb2: usb wakeup-resume
Dec 13 13:04:04 xanatos kernel: [  129.385292] usb usb2: usb auto-resume
Dec 13 13:04:04 xanatos kernel: [  129.385313] hub 2-0:1.0: hub_resume
Dec 13 13:04:04 xanatos kernel: [  129.385538] hub 2-0:1.0: port 2: status 0203 change 0001
Dec 13 13:04:04 xanatos kernel: [  129.489626] hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0000
Dec 13 13:04:04 xanatos kernel: [  129.489770] hub 2-0:1.0: port 2, status 0203, change 0000, 5.0 Gb/s
Dec 13 13:04:04 xanatos kernel: [  129.601984] usb 2-2: new SuperSpeed USB device number 3 using xhci_hcd
Dec 13 13:04:04 xanatos kernel: [  129.618343] usb 2-2: skipped 1 descriptor after endpoint
Dec 13 13:04:04 xanatos kernel: [  129.618350] usb 2-2: skipped 1 descriptor after endpoint
Dec 13 13:04:04 xanatos kernel: [  129.618359] usb 2-2: skipped 2 descriptors after endpoint
Dec 13 13:04:04 xanatos kernel: [  129.618362] usb 2-2: skipped 2 descriptors after endpoint
Dec 13 13:04:04 xanatos kernel: [  129.618365] usb 2-2: skipped 2 descriptors after endpoint
Dec 13 13:04:04 xanatos kernel: [  129.618368] usb 2-2: skipped 2 descriptors after endpoint
Dec 13 13:04:04 xanatos kernel: [  129.618497] usb 2-2: default language 0x0409
Dec 13 13:04:04 xanatos kernel: [  129.618944] usb 2-2: udev 3, busnum 2, minor = 130
Dec 13 13:04:04 xanatos kernel: [  129.618949] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
Dec 13 13:04:04 xanatos kernel: [  129.618952] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
Dec 13 13:04:04 xanatos kernel: [  129.618955] usb 2-2: Product: Plugable USB3-SATA-UASP1
Dec 13 13:04:04 xanatos kernel: [  129.618957] usb 2-2: Manufacturer: ASM1053E
Dec 13 13:04:04 xanatos kernel: [  129.618960] usb 2-2: SerialNumber: 123456789045
Dec 13 13:04:04 xanatos kernel: [  129.619422] usb 2-2: usb_probe_device
Dec 13 13:04:04 xanatos kernel: [  129.619428] usb 2-2: configuration #1 chosen from 1 choice
Dec 13 13:04:04 xanatos kernel: [  129.620213] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
Dec 13 13:04:04 xanatos kernel: [  129.620489] usb-storage 2-2:1.0: usb_probe_interface
Dec 13 13:04:04 xanatos kernel: [  129.620495] usb-storage 2-2:1.0: usb_probe_interface - got id
Dec 13 13:04:04 xanatos kernel: [  129.621367] uas 2-2:1.0: usb_probe_interface
Dec 13 13:04:04 xanatos kernel: [  129.621374] uas 2-2:1.0: usb_probe_interface - got id
Dec 13 13:04:04 xanatos kernel: [  129.626512] scsi7 : uas
Dec 13 13:04:04 xanatos kernel: [  129.628228] scsi 7:0:0:0: Direct-Access     ASM1053E Plugable USB3-SA 0    PQ: 0 ANSI: 6
Dec 13 13:04:04 xanatos kernel: [  129.630030] sd 7:0:0:0: Attached scsi generic sg1 type 0
Dec 13 13:04:04 xanatos kernel: [  129.640361] sd 7:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
Dec 13 13:04:04 xanatos kernel: [  129.641198] sd 7:0:0:0: [sdb] Write Protect is off
Dec 13 13:04:04 xanatos kernel: [  129.641201] sd 7:0:0:0: [sdb] Mode Sense: 43 00 00 00
Dec 13 13:04:04 xanatos kernel: [  129.641608] sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 13 13:04:04 xanatos kernel: [  129.645650]  sdb: sdb1 sdb2 sdb4
Dec 13 13:04:04 xanatos kernel: [  129.650160] sd 7:0:0:0: [sdb] Attached SCSI disk
Dec 13 13:04:05 xanatos kernel: [  130.205047] kjournald starting.  Commit interval 5 seconds
Dec 13 13:04:05 xanatos kernel: [  130.205381] EXT3-fs (sdb1): using internal journal
Dec 13 13:04:05 xanatos kernel: [  130.205387] EXT3-fs (sdb1): recovery complete
Dec 13 13:04:05 xanatos kernel: [  130.205389] EXT3-fs (sdb1): mounted filesystem with ordered data mode
Dec 13 13:04:05 xanatos kernel: [  130.228222] FAT-fs (sdb4): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
Dec 13 13:04:05 xanatos kernel: [  130.239468] EXT4-fs (sdb2): recovery complete
Dec 13 13:04:05 xanatos kernel: [  130.239478] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
Dec 13 13:04:17 xanatos kernel: [  142.112588] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
Dec 13 13:04:17 xanatos kernel: [  142.112682] hub 2-0:1.0: warm reset port 2
Dec 13 13:04:17 xanatos kernel: [  142.136957] sd 7:0:0:0: [sdb] uas_cmd_cmplt ffff88008bc1a100 tag 0, inflight: CMD IN
Dec 13 13:04:17 xanatos kernel: [  142.136963] sd 7:0:0:0: [sdb] cmd cmplt err -71
Dec 13 13:04:17 xanatos kernel: [  142.147967] sd 7:0:0:0: [sdb] uas_cmd_cmplt ffff88008bc1a400 tag 1, inflight: CMD IN
Dec 13 13:04:17 xanatos kernel: [  142.147974] sd 7:0:0:0: [sdb] cmd cmplt err -71
Dec 13 13:04:17 xanatos kernel: [  142.165840] hub 2-0:1.0: port 2 not warm reset yet, waiting 50ms
Dec 13 13:04:17 xanatos kernel: [  142.222174] hub 2-0:1.0: port 2, status 02c0, change 0041, 5.0 Gb/s
Dec 13 13:04:17 xanatos kernel: [  142.222183] usb 2-2: USB disconnect, device number 3
Dec 13 13:04:17 xanatos kernel: [  142.222185] usb 2-2: unregistering device
Dec 13 13:04:17 xanatos kernel: [  142.222187] usb 2-2: unregistering interface 2-2:1.0
Dec 13 13:04:17 xanatos kernel: [  142.222386] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
Dec 13 13:04:17 xanatos kernel: [  142.222416] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
Dec 13 13:04:17 xanatos kernel: [  142.222463] xhci_hcd 0000:00:14.0: shutdown urb ffff88010be0fb40 ep1in-bulk
Dec 13 13:04:17 xanatos kernel: [  142.222466] xhci_hcd 0000:00:14.0: shutdown urb ffff88010be0ff00 ep1in-bulk
Dec 13 13:04:17 xanatos kernel: [  142.222515] sd 7:0:0:0: [sdb] uas_data_cmplt ffff88008bc1a100 tag 0, inflight: CMD
Dec 13 13:04:17 xanatos kernel: [  142.222520] sd 7:0:0:0: [sdb] data cmplt err -108 stream 2
Dec 13 13:04:17 xanatos kernel: [  142.222535] sd 7:0:0:0: [sdb] uas_data_cmplt ffff88008bc1a400 tag 1, inflight: CMD
Dec 13 13:04:17 xanatos kernel: [  142.222537] sd 7:0:0:0: [sdb] data cmplt err -108 stream 3
Dec 13 13:04:17 xanatos kernel: [  142.222550] xhci_hcd 0000:00:14.0: shutdown urb ffff88010be0f300 ep3in-bulk
Dec 13 13:04:17 xanatos kernel: [  142.222555] xhci_hcd 0000:00:14.0: shutdown urb ffff88010be0f540 ep3in-bulk
Dec 13 13:04:17 xanatos kernel: [  142.222564] usb 2-2: stat urb: status -108
Dec 13 13:04:17 xanatos kernel: [  142.222575] usb 2-2: stat urb: status -108
Dec 13 13:04:17 xanatos kernel: [  142.222588] sd 7:0:0:0: [sdb] uas_disconnect ffff88008bc1a100 tag 0, inflight: CMD
Dec 13 13:04:17 xanatos kernel: [  142.222590] sd 7:0:0:0: [sdb] uas_disconnect ffff88008bc1a400 tag 1, inflight: CMD
Dec 13 13:04:17 xanatos kernel: [  142.222592] sd 7:0:0:0: [sdb] uas_zap_dead ffff88008bc1a100 tag 0, inflight: CMD abort
Dec 13 13:04:17 xanatos kernel: [  142.222594] sd 7:0:0:0: [sdb] abort completed
Dec 13 13:04:17 xanatos kernel: [  142.222597] sd 7:0:0:0: [sdb] uas_zap_dead ffff88008bc1a400 tag 1, inflight: CMD abort
Dec 13 13:04:17 xanatos kernel: [  142.222599] sd 7:0:0:0: [sdb] abort completed
Dec 13 13:04:17 xanatos kernel: [  142.222633] sd 7:0:0:0: [sdb] Unhandled error code
Dec 13 13:04:17 xanatos kernel: [  142.222635] sd 7:0:0:0: [sdb]  
Dec 13 13:04:17 xanatos kernel: [  142.222637] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Dec 13 13:04:17 xanatos kernel: [  142.222641] sd 7:0:0:0: [sdb] CDB: 
Dec 13 13:04:17 xanatos kernel: [  142.222646] Read(10): 28 00 01 49 c9 90 00 01 00 00
Dec 13 13:04:17 xanatos kernel: [  142.222659] end_request: I/O error, dev sdb, sector 21612944
Dec 13 13:04:17 xanatos kernel: [  142.222686] sd 7:0:0:0: [sdb] Unhandled error code
Dec 13 13:04:17 xanatos kernel: [  142.222689] sd 7:0:0:0: [sdb]  
Dec 13 13:04:17 xanatos kernel: [  142.222690] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Dec 13 13:04:17 xanatos kernel: [  142.222692] sd 7:0:0:0: [sdb] CDB: 
Dec 13 13:04:17 xanatos kernel: [  142.222693] Read(10): 28 00 01 49 ca 90 00 01 00 00
Dec 13 13:04:17 xanatos kernel: [  142.222702] end_request: I/O error, dev sdb, sector 21613200
Dec 13 13:04:17 xanatos kernel: [  142.239231] end_request: I/O error, dev sdb, sector 0
Dec 13 13:04:17 xanatos kernel: [  142.245075] sd 7:0:0:0: [sdb] Synchronizing SCSI cache
Dec 13 13:04:17 xanatos kernel: [  142.301917] end_request: I/O error, dev sdb, sector 0
Dec 13 13:04:17 xanatos kernel: [  142.307596] JBD2: Error -5 detected when updating journal superblock for sdb2-8.
Dec 13 13:04:17 xanatos kernel: [  142.338630] EXT3-fs (sdb1): I/O error while writing superblock
Dec 13 13:04:17 xanatos kernel: [  142.354202] sd 7:0:0:0: [sdb]  
Dec 13 13:04:17 xanatos kernel: [  142.354224] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
Dec 13 13:04:17 xanatos kernel: [  142.356394] usb 2-2: usb_set_device_initiated_lpm: Can't enable U1 state for unconfigured device.
Dec 13 13:04:17 xanatos kernel: [  142.356448] usb 2-2: usb_set_device_initiated_lpm: Can't enable U2 state for unconfigured device.
Dec 13 13:04:17 xanatos kernel: [  142.356534] usb 2-2: usb_set_device_initiated_lpm: Can't disable U1 state for unconfigured device.
Dec 13 13:04:17 xanatos kernel: [  142.356566] usb 2-2: usb_set_device_initiated_lpm: Can't disable U2 state for unconfigured device.
Dec 13 13:04:17 xanatos kernel: [  142.356587] usb 2-2: usb_disable_device nuking all URBs
Dec 13 13:04:17 xanatos kernel: [  142.482058] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x2a0
Dec 13 13:04:17 xanatos kernel: [  142.482064] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
Dec 13 13:04:17 xanatos kernel: [  142.482188] hub 2-0:1.0: hub_suspend
Dec 13 13:04:17 xanatos kernel: [  142.482196] usb usb2: bus auto-suspend, wakeup 1

--BXVAT5kNtrzKuDFl--
