From: Jarod Wilson <jwilson@redhat.com>
Subject: Re: [PATCH update 2] firewire: fix crash in automatic module unloading
Date: Sat, 1 Mar 2008 00:12:07 -0500
Message-ID: <200803010012.07663.jwilson@redhat.com>
References: <tkrat.43f73e8c841b3161@s5r6.in-berlin.de>
	<tkrat.6515bdc94ebad712@s5r6.in-berlin.de>
	<tkrat.47eb30c18d98ad28@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.47eb30c18d98ad28@s5r6.in-berlin.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 27 February 2008 04:14:27 pm Stefan Richter wrote:
> "modprobe firewire-ohci; sleep .1; modprobe -r firewire-ohci" used to
> result in crashes like this:
>
>     BUG: unable to handle kernel paging request at ffffffff8807b455
>     IP: [<ffffffff8807b455>]
>     PGD 203067 PUD 207063 PMD 7c170067 PTE 0
>     Oops: 0010 [1] PREEMPT SMP
>     CPU 0
>     Modules linked in: i915 drm cpufreq_ondemand acpi_cpufreq freq_table
> applesmc input_polldev led_class coretemp hwmon eeprom snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss button
> thermal processor sg snd_hda_intel snd_pcm snd_timer snd snd_page_alloc
> sky2 i2c_i801 rtc [last unloaded: crc_itu_t] Pid: 9, comm: events/0 Not
> tainted 2.6.25-rc2 #3
>     RIP: 0010:[<ffffffff8807b455>]  [<ffffffff8807b455>]
>     RSP: 0018:ffff81007dcdde88  EFLAGS: 00010246
>     RAX: ffff81007dc95040 RBX: ffff81007dee5390 RCX: 0000000000005e13
>     RDX: 0000000000008c8b RSI: 0000000000000001 RDI: ffff81007dee5388
>     RBP: ffff81007dc5eb40 R08: 0000000000000002 R09: ffffffff8022d05c
>     R10: ffffffff8023b34c R11: ffffffff8041a353 R12: ffff81007dee5388
>     R13: ffffffff8807b455 R14: ffffffff80593bc0 R15: 0000000000000000
>     FS:  0000000000000000(0000) GS:ffffffff8055a000(0000)
> knlGS:0000000000000000 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>     CR2: ffffffff8807b455 CR3: 0000000000201000 CR4: 00000000000006e0
>     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>     DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>     Process events/0 (pid: 9, threadinfo ffff81007dcdc000, task
> ffff81007dc95040) Stack:  ffffffff8023b396 ffffffff88082524
> 0000000000000000 ffffffff8807d9ae ffff81007dc5eb40 ffff81007dc9dce0
> ffff81007dc5eb40 ffff81007dc5eb80 ffff81007dc9dce0 ffffffffffffffff
> ffffffff8023be87 0000000000000000 Call Trace:
>     [<ffffffff8023b396>] ? run_workqueue+0xdf/0x1df
>     [<ffffffff8023be87>] ? worker_thread+0xd8/0xe3
>     [<ffffffff8023e917>] ? autoremove_wake_function+0x0/0x2e
>     [<ffffffff8023bdaf>] ? worker_thread+0x0/0xe3
>     [<ffffffff8023e813>] ? kthread+0x47/0x74
>     [<ffffffff804198e0>] ? trace_hardirqs_on_thunk+0x35/0x3a
>     [<ffffffff8020c008>] ? child_rip+0xa/0x12
>     [<ffffffff8020b6e3>] ? restore_args+0x0/0x3d
>     [<ffffffff8023e68a>] ? kthreadd+0x14c/0x171
>     [<ffffffff8023e68a>] ? kthreadd+0x14c/0x171
>     [<ffffffff8023e7cc>] ? kthread+0x0/0x74
>     [<ffffffff8020bffe>] ? child_rip+0x0/0x12
>
>
>     Code:  Bad RIP value.
>     RIP  [<ffffffff8807b455>]
>     RSP <ffff81007dcdde88>
>     CR2: ffffffff8807b455
>     ---[ end trace c7366c6657fe5bed ]---
>
> Note that this crash happened _after_ firewire-core was unloaded.  The
> shared workqueue tried to run firewire-core's device initialization jobs
> or similar jobs.
>
> The fix makes sure that firewire-ohci and hence firewire-core is not
> unloaded before all device shutdown jobs have been completed.  This is
> determined by the count of device initializations minus device releases.
>
> Also skip useless retries in the node initialization job if the node is
> to be shut down.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> Update:  Refreshed to be applicable after patch "firewire: fw-sbp2:
> better fix for NULL pointer dereference in scsi_remove_device".
>
> Update 2:  Update 1 had a use-after-free bug. #-|

This version is working quite well for me.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
