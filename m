From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Suspected Spam:#] 2 QLogic 2xxx driver possible problems
Date: Thu, 17 Aug 2006 13:52:08 +0400
Message-ID: <44E43C48.4090503@vlnb.net>
References: <44E19B53.1090509@vlnb.net> <20060816175258.GQ3674@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-02.infobox.ru ([85.249.135.211]:51598 "EHLO
	out-relay-02.mailcluster.net") by vger.kernel.org with ESMTP
	id S932466AbWHQJwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 05:52:41 -0400
In-Reply-To: <20060816175258.GQ3674@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org

Andrew Vasquez wrote:
> On Tue, 15 Aug 2006, Vladislav Bolkhovitin wrote:
> 
> 
>>1. Once, when there were some problems with the target I had the 
>>following oops:
>>
>>========================================================================
>>
>> 11:0:0:0: scsi: Device offlined - not ready after error recovery
>>BUG: unable to handle kernel NULL pointer dereference at virtual address 
>>00000000
>> printing eip:
>>c0241964
>>*pde = 00000000
>>Oops: 0000 [#1]
>>PREEMPT SMP
>>Modules linked in: qla2xxx firmware_class scsi_transport_fc pcspkr 
>>w83627hf hwmon_vid eeprom adm1021 i2c_isa binfmt_misc dm_mirror dm_mod 
>>video button battery ac ehci_hcd sg uhci_hcd e1000 i2c_i801 e7xxx_edac 
>>i2c_core usbcore
>>CPU:    0
>>EIP:    0060:[<c0241964>]    Not tainted VLI
>>EFLAGS: 00010202   (2.6.17.2 #7)
>>EIP is at make_class_name+0x28/0x8d
>>eax: 00000000   ebx: ffffffff   ecx: ffffffff   edx: cc5331f0
>>esi: 0000000b   edi: 00000000   ebp: 00000000   esp: cadfce8c
>>ds: 007b   es: 007b   ss: 0068
>>Process fc_wq_11 (pid: 10579, threadinfo=cadfc000 task=f7928030)
>>Stack: cc5331f0 c03cb7c4 cc5331f0 c03cb7c4 c03cb7cc c0241b82 c03cb740 
>>00000000
>>       e6cd203c cc5331f0 cc533098 f73e3800 00000202 c0241c60 cc533000 
>>c025b994
>>       cc533000 e6cd2038 c025b9e5 cc533000 e6cd2000 c025ba79 f73e3814 
>>dd8d1044
>>Call Trace:
>> <c0241b82> class_device_del+0x93/0x169
>> <c0241c60> class_device_unregister+0x8/0x10
>> <c025b994> __scsi_remove_device+0x26/0x60
>> <c025b9e5> > scsi_remove_device+0x17/0x20
>> <c025ba79> __scsi_remove_target+0x8b/0xb7
>> <c025badc> > __remove_child+0x0/0x18
>> <c025baf0> __remove_child+0x14/0x18
>> <c023fb18> > device_for_each_child+0x23/0x41
>> <c025bad3> scsi_remove_target+0x2e/0x37
>> <f88edb5f> fc_rport_final_delete+0x32/0x6a [scsi_transport_fc]
>> <c012a4ae> run_workqueue+0x72/0xe6
>> <f88edb2d> fc_rport_final_delete+0x0/0x6a [scsi_transport_fc]
> 
> 
> This is pretty far up the call chain.  qla2xxx has already called
> fc_remote_port_delete(), TMO has expired, and the final transport
> cleanup is running...
> 
> Could you provide some details on how you produced this?

That happened some time after modprobe when the target refused all ATIO 
by CTIO with terminate exchange flag set (it's also qLogic based).

Actually, I'm not very impressed with the driver's behavior in similar 
erroneous situations. Such things as becoming completely unresponsive, 
rmmod hanging and various error messages like those two reported here 
are usual for it. Seems the corner cases were not tested too well. I 
report only those two problems, because I don't have clear descriptions 
for other ones. But they are pretty easily reproducible with "bad" 
target/link.

>>========================================================================
>>
>>2. If "rmmod" is called too soon after "modprobe" sometimes the 
>>following messages appear in the kernel log (I made them one func name 
>>per line for readability).
> 
> 
> Interesting...  How 'soon' is 'too soon'?

After modprobe returns, but before the remote devices added to the 
system. Usually this time is quite short, but my target does some 
debugging output via serial console, so it becomes noticeable. Looks 
like there is a race somewhere, since it isn't easily reproducible.

>>========================================================================
>>
>>ERROR: FC host 'qla2xxx' attempted to flush work, when no workqueue created.
>><f88edfdb> fc_remote_port_add+0x31/0x37c [scsi_transport_fc]
>><f89e2ea3> qla2x00_reg_remote_port+0x1d4/0x28a [qla2xxx]
>><f89e1ae0> qla2x00_do_dpc+0x32a/0x33f [qla2xxx]
>><f89e17b6> qla2x00_do_dpc+0x0/0x33f [qla2xxx]
>><c012d36c> kthread+0x9f/0xc4
>><c012d2cd> kthread+0x0/0xc4
>><c0100d35> kernel_thread_helper+0x5/0xb
> 
> 
> Weird, the driver only does rport registration after probe() is
> called.  The transport workqueue should have already been created
> during fc_host_setup().
> 
> 
>>ERROR: FC host 'qla2xxx' attempted to flush work, when no workqueue created.
>><f88edd22> fc_remote_port_rolechg+0x96/0xf6 [scsi_transport_fc]
>><f89e2ef5> qla2x00_reg_remote_port+0x226/0x28a [qla2xxx]
>><f89e1ae0> qla2x00_do_dpc+0x32a/0x33f [qla2xxx]
>><f89e17b6> qla2x00_do_dpc+0x0/0x33f [qla2xxx]
>><c012d36c> kthread+0x9f/0xc4
>><c012d2cd> kthread+0x0/0xc4
>><c0100d35> kernel_thread_helper+0x5/0xb
>>
>>Kernel is 2.6.17.2.
> 
> 
> there's been some reference counting fixes since 2.6.17... (though I'm
> not entirely clear if they will help here) can you try to reproduce
> with a recent kernel?

Which one do you mean? 2.6.18-rc4?

> Regards,
> Andrew Vasquez
> 

