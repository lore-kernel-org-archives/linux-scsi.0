From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-sbp2: fix NULL pointer deref in slave_alloc
Date: Sun, 17 Feb 2008 18:44:56 +0100 (CET)
Message-ID: <tkrat.9103805c20697161@s5r6.in-berlin.de>
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 17 Feb, Stefan Richter wrote:
> Fix a kernel bug when running rescan-scsi-bus while a FireWire disk is
> connected:  http://bugzilla.kernel.org/show_bug.cgi?id=10008
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/fw-sbp2.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux/drivers/firewire/fw-sbp2.c
> ===================================================================
> --- linux.orig/drivers/firewire/fw-sbp2.c
> +++ linux/drivers/firewire/fw-sbp2.c
> @@ -1473,6 +1473,10 @@ static int sbp2_scsi_slave_alloc(struct 
>  {
>  	struct sbp2_logical_unit *lu = sdev->hostdata;
>  
> +	/* (Re-)Adding logical units via the SCSI stack is not supported. */
> +	if (!lu)
> +		return -ENOSYS;
> +
>  	sdev->allow_restart = 1;
>  
>  	/*
> 


There is unfortunately another bug.  If the user manually removes the
scsi_device by writing into its "delete" sysfs attribute, the following
will happen when the SBP-2 device is plugged out:


BUG: unable to handle kernel NULL pointer dereference at 00000000000000b8
IP: [<ffffffff804188c6>] mutex_lock_nested+0x7b/0x270
PGD 0 
Oops: 0002 [1] PREEMPT SMP 
CPU 0 
Modules linked in: firewire_sbp2 firewire_ohci firewire_core crc_itu_t i915 drm cpufreq_ondemand acpi_cpufreq freq_table applesmc input_polldev led_class coretemp hwmon eeprom snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_hda_intel snd_pcm snd_timer snd snd_page_alloc button sg thermal processor sky2 i2c_i801 rtc [last unloaded: ieee1394]
Pid: 9, comm: events/0 Not tainted 2.6.25-rc2 #3
RIP: 0010:[<ffffffff804188c6>]  [<ffffffff804188c6>] mutex_lock_nested+0x7b/0x270
RSP: 0018:ffff81007dcddca0  EFLAGS: 00010002
RAX: 0000000000000100 RBX: ffff81007cc4a800 RCX: ffff81007009b000
RDX: ffff81007dc95040 RSI: 00000000000000d1 RDI: ffffffff804d0fcd
RBP: 00000000000000b0 R08: ffffffff805b5000 R09: ffffffff805b6000
R10: 00000000000000b0 R11: 0000000000000046 R12: 0000000000000246
R13: ffff81007dc95040 R14: ffffffff8036a670 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff8055a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000b8 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/0 (pid: 9, threadinfo ffff81007dcdc000, task ffff81007dc95040)
Stack:  ffff81007009b000 ffff81007009b078 0000000000000286 ffffffff8041a305
 0000000000000000 0000000000000000 ffff81007009b000 ffff81007cc4a800
 ffff81007009b638 00000000000000b0 ffff81007009b648 ffff81007009b000
Call Trace:
 [<ffffffff8041a305>] ? _spin_unlock_irqrestore+0x49/0x68
 [<ffffffff8036a670>] ? scsi_remove_device+0x1e/0x33
 [<ffffffff880ef799>] ? :firewire_sbp2:sbp2_release_target+0x33/0xca
 [<ffffffff880ef766>] ? :firewire_sbp2:sbp2_release_target+0x0/0xca
 [<ffffffff802ec6df>] ? kref_put+0x41/0x4c
 [<ffffffff880ef117>] ? :firewire_sbp2:sbp2_remove+0x10/0x14
 [<ffffffff8034d75c>] ? __device_release_driver+0x78/0x9e
 [<ffffffff8034db94>] ? device_release_driver+0x3d/0x55
 [<ffffffff8034cfd0>] ? bus_remove_device+0x76/0x85
 [<ffffffff8034b760>] ? device_del+0x114/0x181
 [<ffffffff88079095>] ? :firewire_core:shutdown_unit+0x0/0xd
 [<ffffffff8034b7d6>] ? device_unregister+0x9/0x12
 [<ffffffff8807909e>] ? :firewire_core:shutdown_unit+0x9/0xd
 [<ffffffff8041a2f9>] ? _spin_unlock_irqrestore+0x3d/0x68
 [<ffffffff8034b361>] ? device_for_each_child+0x22/0x4d
 [<ffffffff880790fc>] ? :firewire_core:fw_device_shutdown+0x2e/0x71
 [<ffffffff880790ce>] ? :firewire_core:fw_device_shutdown+0x0/0x71
 [<ffffffff8023b396>] ? run_workqueue+0xdf/0x1df
 [<ffffffff8023be87>] ? worker_thread+0xd8/0xe3
 [<ffffffff8023e917>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8023bdaf>] ? worker_thread+0x0/0xe3
 [<ffffffff8023e813>] ? kthread+0x47/0x74
 [<ffffffff804198e0>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020c008>] ? child_rip+0xa/0x12
 [<ffffffff8020b6e3>] ? restore_args+0x0/0x3d
 [<ffffffff8023e68a>] ? kthreadd+0x14c/0x171
 [<ffffffff8023e68a>] ? kthreadd+0x14c/0x171
 [<ffffffff8023e7cc>] ? kthread+0x0/0x74
 [<ffffffff8020bffe>] ? child_rip+0x0/0x12


Code: c0 74 1a 83 3d 43 8a 55 00 00 75 11 be 86 00 00 00 48 c7 c7 cd 0f 4d 80 e8 40 3c e1 ff 9c 41 5c fa e8 f8 e9 e2 ff b8 00 01 00 00 <f0> 66 0f c1 45 08 38 e0 74 07 f3 90 8a 45 08 eb f5 48 39 6d 58 
RIP  [<ffffffff804188c6>] mutex_lock_nested+0x7b/0x270
 RSP <ffff81007dcddca0>
CR2: 00000000000000b8
---[ end trace 2a9c61e9883e29d2 ]---

-- 
Stefan Richter
-=====-==--- --=- =---=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
