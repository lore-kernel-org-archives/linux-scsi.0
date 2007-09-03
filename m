From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 8968] One broken USB storage device can
 hang the entire USB subsystem
Date: Mon, 3 Sep 2007 11:44:46 -0700
Message-ID: <20070903114446.d4f09c99.akpm@linux-foundation.org>
References: <bug-8968-27@http.bugzilla.kernel.org/>
	<20070903175526.69C3B108015@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070903175526.69C3B108015@picon.linux-foundation.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Cc: Alain Knaff <kernel@misc.lka.org.lu>, bugme-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

> On Mon,  3 Sep 2007 10:55:26 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=8968

Either a scsi bug or a usb-storage bug.  The interesting bits are below:


> [  411.364000] scsi_eh_6     D F7E21F28     0  2782      2 (L-TLB)
> [  411.364000]        f7e21f3c 00000046 00000002 f7e21f28 f7e21f24 00000000 00000082 f79ec600 
> [  411.364000]        dd5c5a00 0000000a b1510900 00000058 00000000 dd56a10c c3015b00 00000000 
> [  411.364000]        00000002 00000001 deb0e1c0 00004ec3 00000000 00000082 000000ff 00000000 
> [  411.364000] Call Trace:
> [  411.364000]  [<c02f11e4>] wait_for_completion+0x94/0xe0
> [  411.364000]  [<c0122bc0>] default_wake_function+0x0/0x10
> [  411.364000]  [<f88fe6d5>] command_abort+0x85/0xb0 [usb_storage]
> [  411.364000]  [<f8a51f89>] __scsi_try_to_abort_cmd+0x19/0x20 [scsi_mod]
> [  411.364000]  [<f8a53b86>] scsi_error_handler+0x356/0x510 [scsi_mod]
> [  411.364000]  [<c01205c0>] complete+0x40/0x60
> [  411.364000]  [<f8a53830>] scsi_error_handler+0x0/0x510 [scsi_mod]
> [  411.364000]  [<c013ba12>] kthread+0x42/0x70
> [  411.364000]  [<c013b9d0>] kthread+0x0/0x70
> [  411.364000]  [<c0105487>] kernel_thread_helper+0x7/0x10
> [  411.364000]  =======================
> [  411.364000] usb-storage   D F7E23EA0     0  2783      2 (L-TLB)
> [  411.364000]        f7e23eb4 00000046 00000000 f7e23ea0 f79ec600 de7e6a80 000031ba 00000000 
> [  411.364000]        00000a00 0000000a b56a6600 00000051 00000000 dd56a62c c3015b00 00000000 
> [  411.364000]        c02f18d8 0001b000 de7e6a80 000031ba dfb89d00 00002000 00000010 c0008380 
> [  411.364000] Call Trace:
> [  411.364000]  [<c02f18d8>] schedule_timeout+0x78/0xd0
> [  411.364000]  [<c02f11e4>] wait_for_completion+0x94/0xe0
> [  411.364000]  [<c0122bc0>] default_wake_function+0x0/0x10
> [  411.364000]  [<f8887716>] usb_sg_wait+0x126/0x170 [usbcore]
> [  411.364000]  [<f88ff2e0>] usb_stor_bulk_transfer_sg+0xb0/0x100 [usb_storage]
> [  411.364000]  [<f88ff11e>] usb_stor_bulk_transfer_buf+0x4e/0x90 [usb_storage]
> [  411.364000]  [<f88ff776>] usb_stor_Bulk_transport+0x126/0x290 [usb_storage]
> [  411.364000]  [<f89007b0>] usb_stor_control_thread+0x0/0x1d0 [usb_storage]
> [  411.364000]  [<f88ff904>] usb_stor_invoke_transport+0x24/0x2f0 [usb_storage]
> [  411.364000]  [<c012003f>] __wake_up_locked+0x1f/0x30
> [  411.364000]  [<c02f2820>] __down_interruptible+0xf0/0x120
> [  411.364000]  [<c0122bc0>] default_wake_function+0x0/0x10
> [  411.364000]  [<f89007b0>] usb_stor_control_thread+0x0/0x1d0 [usb_storage]
> [  411.364000]  [<f89007b0>] usb_stor_control_thread+0x0/0x1d0 [usb_storage]
> [  411.364000]  [<f8900918>] usb_stor_control_thread+0x168/0x1d0 [usb_storage]
> [  411.364000]  [<c01205c0>] complete+0x40/0x60
> [  411.364000]  [<f89007b0>] usb_stor_control_thread+0x0/0x1d0 [usb_storage]
> [  411.364000]  [<c013ba12>] kthread+0x42/0x70
> [  411.364000]  [<c013b9d0>] kthread+0x0/0x70
> [  411.364000]  [<c0105487>] kernel_thread_helper+0x7/0x10
> [  411.364000]  =======================
>
> ...
>
> [  411.364000] rsync         D 000031F9     0  8809   8779 (NOTLB)
> [  411.364000]        de1a9db0 00000082 00000051 000031f9 c3016a38 00000000 df93a6d0 c3010000 
> [  411.364000]        c010320a 00000009 b56a6600 00000051 00000000 df93a62c c3015b00 00000000 
> [  411.364000]        de1a9df0 00000082 de7e6a80 00000086 de1a9ea8 c012da61 c0118735 b56a6600 
> [  411.364000] Call Trace:
> [  411.364000]  [<c010320a>] __switch_to+0xaa/0x1d0
> [  411.364000]  [<c012da61>] irq_exit+0x51/0x80
> [  411.364000]  [<c0118735>] smp_apic_timer_interrupt+0x55/0x80
> [  411.364000]  [<c02f171d>] io_schedule+0x1d/0x30
> [  411.364000]  [<c015e7c9>] sync_page+0x39/0x50
> [  411.364000]  [<c02f19ad>] __wait_on_bit_lock+0x3d/0x70
> [  411.364000]  [<c015e790>] sync_page+0x0/0x50
> [  411.364000]  [<c015e773>] __lock_page+0x73/0x80
> [  411.364000]  [<c013bd20>] wake_bit_function+0x0/0x60
> [  411.364000]  [<c015f193>] do_generic_mapping_read+0x213/0x5d0
> [  411.364000]  [<c01612ec>] generic_file_aio_read+0xcc/0x1d0
> [  411.364000]  [<c015e520>] file_read_actor+0x0/0xf0
> [  411.364000]  [<c01802f5>] do_sync_read+0xd5/0x120
> [  411.364000]  [<c013bcd0>] autoremove_wake_function+0x0/0x50
> [  411.364000]  [<c0180c2c>] vfs_read+0xbc/0x160
> [  411.364000]  [<c0180220>] do_sync_read+0x0/0x120
> [  411.364000]  [<c0181161>] sys_read+0x41/0x70
> [  411.364000]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
> 
> 

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
