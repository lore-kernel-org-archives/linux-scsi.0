From: "jidong xiao" <jidong.xiao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bugme-new] [Bug 11088] New: Warning about NULL pointer dereference when attaching usb hd
Date: Wed, 16 Jul 2008 11:19:26 +0800
Message-ID: <4104961b0807152019p6a704b9mf1d4f3bbeaee43cf@mail.gmail.com>
References: <bug-11088-10286@http.bugzilla.kernel.org/>
	 <20080715022323.4a6e470e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080715022323.4a6e470e.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Content-Disposition: inline
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hanno-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 15, 2008 at 5:23 PM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>
> On Tue, 15 Jul 2008 02:15:53 -0700 (PDT) bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org wrote:
>
>> http://bugzilla.kernel.org/show_bug.cgi?id=11088
>>
>>            Summary: Warning about NULL pointer dereference when attaching
>>                     usb hd
>>            Product: Drivers
>>            Version: 2.5
>>      KernelVersion: 2.6.26
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: USB
>>         AssignedTo: greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
>>         ReportedBy: hanno-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org
>>
>>
>> I got this when attaching an external usb hd. Kernel is 2.6.26, I'll attach
>> config.
>>
>> sd 0:0:0:0: [sda] Attached SCSI disk
>> sd 0:0:0:0: Attached scsi generic sg0 type 0
>> BUG: unable to handle kernel NULL pointer dereference at 00000004
>> IP: [<f98c067b>] :usb_storage:slave_alloc+0x2b/0x60
>> *pde = 00000000
>> Oops: 0000 [#1]
>> Modules linked in: radeon drm usb_storage pcmcia nsc_ircc irda parport_pc
>> ehci_hcd uhci_hcd parport usbcore yenta_socket rsrc_nonstatic firewire_ohci
>> pcmcia_core 8139cp firewire_core crc_itu_t ipw2200 8139too i2c_i801
>>
>> Pid: 1354, comm: usb-stor-scan Not tainted (2.6.26 #1)
>> EIP: 0060:[<f98c067b>] EFLAGS: 00010202 CPU: 0
>> EIP is at slave_alloc+0x2b/0x60 [usb_storage]
>> EAX: 00000000 EBX: f6c6070c ECX: 00000202 EDX: f6cb8c00
>> ESI: f0403400 EDI: f6c10c14 EBP: f6c60400 ESP: f6d9bddc
>>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>> Process usb-stor-scan (pid: 1354, ti=f6d9a000 task=f7c534c0 task.ti=f6d9a000)
>> Stack: f0403400 f6c10c00 c02f0c73 f60fc938 00000000 00000000 f6c60400 00000000
>>        00000000 00000000 c02f1061 c04cca30 c049cb92 f60fc938 c04bebfe f6c643c8
>>        f6c643d0 f6c643e0 00000000 00000000 c04befed f6ea0288 00000000 f6c10c00
>> Call Trace:
>>  [<c02f0c73>] scsi_alloc_sdev+0x143/0x1b0
>>  [<c02f1061>] scsi_probe_and_add_lun+0x261/0x9a0
>>  [<c02f1c03>] __scsi_scan_target+0x2e3/0x610
>>  [<c0124f40>] process_timeout+0x0/0x10
>>  [<c0424347>] wait_for_common+0x77/0x110
>>  [<c0118ab0>] default_wake_function+0x0/0x10
>>  [<c02f1f87>] scsi_scan_channel+0x57/0xa0
>>  [<c02f2077>] scsi_scan_host_selected+0xa7/0x120
>>  [<c02f215b>] do_scsi_scan_host+0x6b/0x70
>>  [<f98c2625>] usb_stor_scan_thread+0x145/0x190 [usb_storage]
>>  [<c012e6e0>] autoremove_wake_function+0x0/0x50
>>  [<f98c24e0>] usb_stor_scan_thread+0x0/0x190 [usb_storage]
>>  [<c012e2d7>] kthread+0x37/0x70
>>  [<c012e2a0>] kthread+0x0/0x70
>>  [<c0103323>] kernel_thread_helper+0x7/0x14
>>  =======================
>> Code: 83 ec 08 89 74 24 04 89 c6 89 1c 24 8b 18 c6 40 57 24 81 c3 0c 03 00 00
>> 8b 43 20 8b 53 0c c1 e8 0f 83 e0 0f 8b 84 82 8c 01 00 00 <0f> b7 50 04 8b 46 04
>> 4a e8 b8 aa 96 c6 80 7b 3c 04 75 0e 8b 46
>> EIP: [<f98c067b>] slave_alloc+0x2b/0x60 [usb_storage] SS:ESP 0068:f6d9bddc
>> ---[ end trace f3a5e784c4c8fadf ]---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi, Hanno,

1. Can this bug be reproduced?
2. Can you try it with older kernel?such as 2.6.25 or some other
versions prior to 2.6.26.

Thanks
Jason Xiao
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
