From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: 2.6.9-rc4mm1:badness in drivers/scsi/scsi_lib.c
Date: Tue, 26 Oct 2004 11:08:43 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <417E92AB.5020406@us.ibm.com>
References: <Pine.LNX.4.44L0.0410211039420.2736-100000@ida.rowland.org> <Pine.GSO.4.58.0410260947280.22299@boromir> <417E9163.8010904@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <417E9163.8010904@us.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Mateusz.Blaszczyk@nask.pl
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:

> Mateusz.Blaszczyk@nask.pl wrote:
> 
>> On Thu, 21 Oct 2004, Alan Stern wrote:
>>
>>
>>> On Thu, 21 Oct 2004 Mateusz.Blaszczyk@nask.pl wrote:
>>>
>>>
>>>>>> After successful write on USB DVD-R writer (HP-200j), system 
>>>>>> oops's when unpluging USB device.
>>>>>> Same thing with 2.6.9-rc2mm1.
>>>>>
>>>>>
>>>>> Try applying this patch:
>>>>>
>>>>> http://marc.theaimsgroup.com/?l=linux-usb-devel&m=109744234829347&q=raw 
>>>>>
>>>>
>>>>
>>>> Patch applied.
>>>> I have done the tests at still no good.
>>>> I connected and disconnected the writer a couple of times. WHen I 
>>>> didn't
>>>> read/write on the CD there is no OOPS when disconnecting. But after 
>>>> reading CD
>>>> there was OOPS when disconnecting. See below. Decoded OOPS - see 
>>>> more below.
>>>
>>>
>>> Can you turn on the usb-storage verbose debugging option in the kernel
>>> configuration and then try running your test over again?  Be sure 
>>> also to
>>> set up /etc/syslog.conf to capture debug-level kernel messages.
>>
>>
>>
>>
>> Well, I think I must admit I was wrong.
>>
>> I have done some tests and there was no ooops after succesful writing 
>> or after
>> unmounting device. The oops is when I unplug USB-DVD-Recorder when 
>> there is
>> already mounted device on it.
>>
>> Then there is state transition from NULL->cancel and kernel oops!
>> See oops and decoded oops below:
>>
> 
> The null state and and oops are becuase of this
> http://marc.theaimsgroup.com/?l=linux-scsi&m=109733573729283&w=2

Oh yeah. that patch is not correct, but if you correctly modify it to
use device_for_each_child per Christoph's suggestion, I seem to be
getting some refcounting errors. For some reason the sdev will be
released, but the sd.c still thinks it is there.

>> Oct 26 09:10:03 localhost kernel: usb 1-1: unregistering interface 
>> 1-1:2.0
>> Oct 26 09:10:03 localhost kernel: usb-storage: storage_disconnect() 
>> called
>> Oct 26 09:10:03 localhost kernel: usb-storage: usb_stor_stop_transport 
>> called
>> Oct 26 09:10:03 localhost kernel:  target0:0:0: Illegal state 
>> transition <NULL>->cancel
>> Oct 26 09:10:03 localhost kernel: Badness in scsi_device_set_state at 
>> drivers/scsi/scsi_lib.c:1713
>> Oct 26 09:10:03 localhost kernel:  [scsi_device_set_state+199/210] 
>> scsi_device_set_state+0xc7/0xd2
>> Oct 26 09:10:03 localhost kernel:  [scsi_device_cancel+38/257] 
>> scsi_device_cancel+0x26/0x101
>> Oct 26 09:10:03 localhost kernel:  [scsi_device_cancel_cb+0/12] 
>> scsi_device_cancel_cb+0x0/0xc
>> Oct 26 09:10:03 localhost kernel:  [device_for_each_child+52/91] 
>> device_for_each_child+0x34/0x5b
>> Oct 26 09:10:03 localhost kernel:  [scsi_host_cancel+37/176] 
>> scsi_host_cancel+0x25/0xb0
>> Oct 26 09:10:03 localhost kernel:  [dput+27/569] dput+0x1b/0x239
>> Oct 26 09:10:03 localhost kernel:  [device_del+101/117] 
>> device_del+0x65/0x75
>> Oct 26 09:10:03 localhost kernel:  [scsi_remove_device+112/128] 
>> scsi_remove_device+0x70/0x80
>> Oct 26 09:10:03 localhost kernel:  [scsi_forget_host+112/140] 
>> scsi_forget_host+0x70/0x8c
>> Oct 26 09:10:03 localhost kernel:  [scsi_remove_host+17/75] 
>> scsi_remove_host+0x11/0x4b
>> Oct 26 09:10:03 localhost kernel:  [pg0+268324036/1068930048] 
>> storage_disconnect+0x7a/0x89 [usb_storage]
>> Oct 26 09:10:03 localhost kernel:  [usb_unbind_interface+51/94] 
>> usb_unbind_interface+0x33/0x5e
>> Oct 26 09:10:03 localhost kernel:  [device_release_driver+60/70] 
>> device_release_driver+0x3c/0x46
>> Oct 26 09:10:03 localhost kernel:  [bus_remove_device+63/118] 
>> bus_remove_device+0x3f/0x76
>> Oct 26 09:10:03 localhost kernel:  [device_del+86/117] 
>> device_del+0x56/0x75
>> Oct 26 09:10:03 localhost kernel:  [usb_disable_device+194/301] 
>> usb_disable_device+0xc2/0x12d
>> Oct 26 09:10:03 localhost kernel:  [usb_disconnect+173/342] 
>> usb_disconnect+0xad/0x156
>> Oct 26 09:10:03 localhost kernel:  [hub_port_connect_change+179/971] 
>> hub_port_connect_change+0xb3/0x3cb
>> Oct 26 09:10:03 localhost kernel:  [hub_events+824/1057] 
>> hub_events+0x338/0x421
>> Oct 26 09:10:03 localhost kernel:  [prepare_to_wait+76/104] 
>> prepare_to_wait+0x4c/0x68
>> Oct 26 09:10:03 localhost kernel:  [hub_thread+0/258] 
>> hub_thread+0x0/0x102
>> Oct 26 09:10:03 localhost kernel:  [hub_thread+30/258] 
>> hub_thread+0x1e/0x102
>> Oct 26 09:10:03 localhost kernel:  [autoremove_wake_function+0/45] 
>> autoremove_wake_function+0x0/0x2d
>> Oct 26 09:10:03 localhost kernel:  [hub_thread+0/258] 
>> hub_thread+0x0/0x102
>> Oct 26 09:10:03 localhost kernel:  [autoremove_wake_function+0/45] 
>> autoremove_wake_function+0x0/0x2d
>> Oct 26 09:10:03 localhost kernel:  [kernel_thread_helper+5/11] 
>> kernel_thread_helper+0x5/0xb
>> Oct 26 09:10:03 localhost kernel: Unable to handle kernel NULL pointer 
>> dereference at virtual address 00000000
>> Oct 26 09:10:03 localhost kernel:  printing eip:
>> Oct 26 09:10:03 localhost kernel: c025287b
>> Oct 26 09:10:03 localhost kernel: *pde = 00000000
>> Oct 26 09:10:03 localhost kernel: Oops: 0000 [#1]
>> Oct 26 09:10:03 localhost kernel: PREEMPT
>> Oct 26 09:10:03 localhost kernel: Modules linked in: nls_iso8859_2 
>> isofs nls_base zlib_inflate sr_mod usb_storage pktcdvd lp button 
>> processor ac battery ipt_REJECT ipt_pkttype ipt_LOG ipt_state 
>> ipt_multiport ipt_conntrack iptable_mangle ip_nat_irc ip_nat_tftp 
>> ip_nat_ftp iptable_nat ip_conntrack_irc ip_conntrack_tftp 
>> ip_conntrack_ftp ip_conntrack iptable_filter ip_tables usbhid ipw2100 
>> ieee80211 ieee80211_crypt 8139too mii crc32 hw_random intel_agp 
>> agpgart parport_pc parport irtty_sir sir_dev pcspkr
>> Oct 26 09:10:03 localhost kernel: CPU:    0
>> Oct 26 09:10:03 localhost kernel: EIP:    
>> 0060:[scsi_device_cancel+57/257]    Not tainted VLI
>> Oct 26 09:10:03 localhost kernel: EFLAGS: 00010013   (2.6.9-rc4mm1)
>> Oct 26 09:10:03 localhost kernel: EIP is at scsi_device_cancel+0x39/0x101
>> Oct 26 09:10:03 localhost kernel: eax: 00000001   ebx: fffffff0   ecx: 
>> 00000001   edx: 00000000
>> Oct 26 09:10:03 localhost kernel: esi: cb794a80   edi: c13d1e5c   ebp: 
>> 00000282   esp: c13d1e58
>> Oct 26 09:10:03 localhost kernel: ds: 007b   es: 007b   ss: 0068
>> Oct 26 09:10:03 localhost kernel: Process khubd (pid: 145, 
>> threadinfo=c13d0000 task=c12655a0)
>> Oct 26 09:10:03 localhost kernel: Stack: 00000000 c13d1e5c c13d1e5c 
>> cb794c04 cdcb78b4 c03ed008 c0252982 c023414f
>> Oct 26 09:10:03 localhost kernel:        c13d1e90 cdcb7800 d048cea0 
>> cbae60c0 cf4641c0 c02529b3 00000000 cb0f8054
>> Oct 26 09:10:03 localhost kernel:        c0159d5c cdd45da8 cb794c04 
>> cdd45d84 cdd45d84 cb794c04 c02340fb cdd45c00
>> Oct 26 09:10:03 localhost kernel: Call Trace:
>> Oct 26 09:10:03 localhost kernel:  [scsi_device_cancel_cb+0/12] 
>> scsi_device_cancel_cb+0x0/0xc
>> Oct 26 09:10:03 localhost kernel:  [device_for_each_child+52/91] 
>> device_for_each_child+0x34/0x5b
>> Oct 26 09:10:03 localhost kernel:  [scsi_host_cancel+37/176] 
>> scsi_host_cancel+0x25/0xb0
>> Oct 26 09:10:03 localhost kernel:  [dput+27/569] dput+0x1b/0x239
>> Oct 26 09:10:03 localhost kernel:  [device_del+101/117] 
>> device_del+0x65/0x75
>> Oct 26 09:10:03 localhost kernel:  [scsi_remove_device+112/128] 
>> scsi_remove_device+0x70/0x80
>> Oct 26 09:10:03 localhost kernel:  [scsi_forget_host+112/140] 
>> scsi_forget_host+0x70/0x8c
>> Oct 26 09:10:03 localhost kernel:  [scsi_remove_host+17/75] 
>> scsi_remove_host+0x11/0x4b
>> Oct 26 09:10:03 localhost kernel:  [pg0+268324036/1068930048] 
>> storage_disconnect+0x7a/0x89 [usb_storage]
>> Oct 26 09:10:03 localhost kernel:  [usb_unbind_interface+51/94] 
>> usb_unbind_interface+0x33/0x5e
>> Oct 26 09:10:03 localhost kernel:  [device_release_driver+60/70] 
>> device_release_driver+0x3c/0x46
>> Oct 26 09:10:03 localhost kernel:  [bus_remove_device+63/118] 
>> bus_remove_device+0x3f/0x76
>> Oct 26 09:10:03 localhost kernel:  [device_del+86/117] 
>> device_del+0x56/0x75
>> Oct 26 09:10:03 localhost kernel:  [usb_disable_device+194/301] 
>> usb_disable_device+0xc2/0x12d
>> Oct 26 09:10:03 localhost kernel:  [usb_disconnect+173/342] 
>> usb_disconnect+0xad/0x156
>> Oct 26 09:10:03 localhost kernel:  [hub_port_connect_change+179/971] 
>> hub_port_connect_change+0xb3/0x3cb
>> Oct 26 09:10:03 localhost kernel:  [hub_events+824/1057] 
>> hub_events+0x338/0x421
>> Oct 26 09:10:03 localhost kernel:  [prepare_to_wait+76/104] 
>> prepare_to_wait+0x4c/0x68
>> Oct 26 09:10:03 localhost kernel:  [hub_thread+0/258] 
>> hub_thread+0x0/0x102
>> Oct 26 09:10:03 localhost kernel:  [hub_thread+30/258] 
>> hub_thread+0x1e/0x102
>> Oct 26 09:10:03 localhost kernel:  [autoremove_wake_function+0/45] 
>> autoremove_wake_function+0x0/0x2d
>> Oct 26 09:10:03 localhost kernel:  [hub_thread+0/258] 
>> hub_thread+0x0/0x102
>> Oct 26 09:10:03 localhost kernel:  [autoremove_wake_function+0/45] 
>> autoremove_wake_function+0x0/0x2d
>> Oct 26 09:10:03 localhost kernel:  [kernel_thread_helper+5/11] 
>> kernel_thread_helper+0x5/0xb
>> Oct 26 09:10:03 localhost kernel: Code: 14 24 89 c7 ba 03 00 00 00 89 
>> 44 24 04 89 44 24 08 89 f0 e8 b2 41 00 00 9c 5d fa b8 01 00 00 00 e8 
>> b6 1c ec ff 8b 56 1c 8d 5a f0 <8b> 43 10 0f 18 00 90 8d 46 1c 39 c2 74 
>> 40 8b 83 b8 00 00 00 85
>> Oct 26 09:10:03 localhost kernel:  <6>note: khubd[145] exited with 
>> preempt_count 1
>> Oct 26 09:10:22 localhost kernel: scsi0 (0:0): rejecting I/O to dead 
>> device
>> Oct 26 09:10:22 localhost kernel: SCSI error: host 0 id 0 lun 0 return 
>> code = 4000000
>> Oct 26 09:10:22 localhost kernel: ^ISense class 0, sense error 0, 
>> extended sense 0
>> ------------------------------------ END OF OOPS 
>> ------------------------------------
>> ----------------------------------- DECODED OOPS 
>> ------------------------------------
>> ksymoops 2.4.9 on i686 2.6.9-rc4mm1.  Options used
>>      -V (default)
>>      -k /proc/ksyms (default)
>>      -l /proc/modules (default)
>>      -o /lib/modules/2.6.9-rc4mm1/ (default)
>>      -m /boot/System.map-2.6.9-rc4mm1 (default)
>>
>> Warning: You did not tell me where to find symbol information.  I will
>> assume that the log matches the kernel and modules that are running
>> right now and I'll use the default options above for symbol resolution.
>> If the current kernel and/or modules do not match the log, you can get
>> more accurate output by telling me the kernel version and where to find
>> map, modules, ksyms etc.  ksymoops -h explains the options.
>>
>> Error (regular_file): read_ksyms stat /proc/ksyms failed
>> No modules in ksyms, skipping objects
>> No ksyms, skipping lsmod
>> Oct 26 09:08:36 localhost kernel: Machine check exception polling 
>> timer started.
>> Oct 26 09:08:36 localhost kernel: 8139too Fast Ethernet driver 0.9.27
>> Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0100-0x04ff: 
>> excluding 0x400-0x407 0x4d0-0x4d7
>> Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0800-0x08ff: clean.
>> Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0c00-0x0cff: clean.
>> Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0a00-0x0aff: clean.
>> Oct 26 09:10:03 localhost kernel: Unable to handle kernel NULL pointer 
>> dereference at virtual address 00000000
>> Oct 26 09:10:03 localhost kernel: c025287b
>> Oct 26 09:10:03 localhost kernel: *pde = 00000000
>> Oct 26 09:10:03 localhost kernel: Oops: 0000 [#1]
>> Oct 26 09:10:03 localhost kernel: CPU:    0
>> Oct 26 09:10:03 localhost kernel: EIP:    
>> 0060:[scsi_device_cancel+57/257]    Not tainted VLI
>> Oct 26 09:10:03 localhost kernel: EFLAGS: 00010013   (2.6.9-rc4mm1)
>> Oct 26 09:10:03 localhost kernel: eax: 00000001   ebx: fffffff0   ecx: 
>> 00000001   edx: 00000000
>> Oct 26 09:10:03 localhost kernel: esi: cb794a80   edi: c13d1e5c   ebp: 
>> 00000282   esp: c13d1e58
>> Oct 26 09:10:03 localhost kernel: ds: 007b   es: 007b   ss: 0068
>> Oct 26 09:10:03 localhost kernel: Stack: 00000000 c13d1e5c c13d1e5c 
>> cb794c04 cdcb78b4 c03ed008 c0252982 c023414f
>> Oct 26 09:10:03 localhost kernel:        c13d1e90 cdcb7800 d048cea0 
>> cbae60c0 cf4641c0 c02529b3 00000000 cb0f8054
>> Oct 26 09:10:03 localhost kernel:        c0159d5c cdd45da8 cb794c04 
>> cdd45d84 cdd45d84 cb794c04 c02340fb cdd45c00
>> Oct 26 09:10:03 localhost kernel: Call Trace:
>> Warning (Oops_read): Code line not seen, dumping what data is available
>>
>>
>>
>>>> ebx; fffffff0 <__kernel_rt_sigreturn+1bb0/????>
>>>> esi; cb794a80 <pg0+b2ffa80/3fb69400>
>>>> edi; c13d1e5c <pg0+f3ce5c/3fb69400>
>>>> esp; c13d1e58 <pg0+f3ce58/3fb69400>
>>
>>
>>
>> Oct 26 09:10:03 localhost kernel: Code: 14 24 89 c7 ba 03 00 00 00 89 
>> 44 24 04 89 44 24 08 89 f0 e8 b2 41 00 00 9c 5d fa b8 01 00 00 00 e8 
>> b6 1c ec ff 8b 56 1c 8d 5a f0 <8b> 43 10 0f 18 00 90 8d 46 1c 39 c2 74 
>> 40 8b 83 b8 00 00 00 85
>> Using defaults from ksymoops -t elf32-i386 -a i386
>>
>>
>> Code;  ffffffd5 <__kernel_rt_sigreturn+1b95/????>
>> 00000000 <_EIP>:
>> Code;  ffffffd5 <__kernel_rt_sigreturn+1b95/????>
>>    0:   14 24                     adc    $0x24,%al
>> Code;  ffffffd7 <__kernel_rt_sigreturn+1b97/????>
>>    2:   89 c7                     mov    %eax,%edi
>> Code;  ffffffd9 <__kernel_rt_sigreturn+1b99/????>
>>    4:   ba 03 00 00 00            mov    $0x3,%edx
>> Code;  ffffffde <__kernel_rt_sigreturn+1b9e/????>
>>    9:   89 44 24 04               mov    %eax,0x4(%esp)
>> Code;  ffffffe2 <__kernel_rt_sigreturn+1ba2/????>
>>    d:   89 44 24 08               mov    %eax,0x8(%esp)
>> Code;  ffffffe6 <__kernel_rt_sigreturn+1ba6/????>
>>   11:   89 f0                     mov    %esi,%eax
>> Code;  ffffffe8 <__kernel_rt_sigreturn+1ba8/????>
>>   13:   e8 b2 41 00 00            call   41ca <_EIP+0x41ca>
>> Code;  ffffffed <__kernel_rt_sigreturn+1bad/????>
>>   18:   9c                        pushf
>> Code;  ffffffee <__kernel_rt_sigreturn+1bae/????>
>>   19:   5d                        pop    %ebp
>> Code;  ffffffef <__kernel_rt_sigreturn+1baf/????>
>>   1a:   fa                        cli
>> Code;  fffffff0 <__kernel_rt_sigreturn+1bb0/????>
>>   1b:   b8 01 00 00 00            mov    $0x1,%eax
>> Code;  fffffff5 <__kernel_rt_sigreturn+1bb5/????>
>>   20:   e8 b6 1c ec ff            call   ffec1cdb <_EIP+0xffec1cdb>
>> Code;  fffffffa <__kernel_rt_sigreturn+1bba/????>
>>   25:   8b 56 1c                  mov    0x1c(%esi),%edx
>> Code;  fffffffd <__kernel_rt_sigreturn+1bbd/????>
>>   28:   8d 5a f0                  lea    0xfffffff0(%edx),%ebx
>> Code;  00000000 Before first symbol
>>   2b:   8b 43 10                  mov    0x10(%ebx),%eax
>> Code;  00000003 Before first symbol
>>   2e:   0f 18 00                  prefetchnta (%eax)
>> Code;  00000006 Before first symbol
>>   31:   90                        nop
>> Code;  00000007 Before first symbol
>>   32:   8d 46 1c                  lea    0x1c(%esi),%eax
>> Code;  0000000a Before first symbol
>>   35:   39 c2                     cmp    %eax,%edx
>> Code;  0000000c Before first symbol
>>   37:   74 40                     je     79 <_EIP+0x79>
>> Code;  0000000e Before first symbol
>>   39:   8b 83 b8 00 00 00         mov    0xb8(%ebx),%eax
>> Code;  00000014 Before first symbol
>>   3f:   85                        .byte 0x85
>>
>>
>> 2 warnings and 1 error issued.  Results may not be reliable.
>> ---------------------------- END OF DECODED OOPS 
>> ------------------------------------
>>
>>
>>> Alan Stern
>>>
>>
>>
>> -mat
>>
> 
> 



-------------------------------------------------------
This SF.Net email is sponsored by:
Sybase ASE Linux Express Edition - download now for FREE
LinuxWorld Reader's Choice Award Winner for best database on Linux.
http://ads.osdn.com/?ad_id=5588&alloc_id=12065&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
