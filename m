From: Dag Nygren <dag@newtech.fi>
Subject: Re: Bug in the sg driver
Date: Tue, 07 Oct 2003 15:03:55 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007120355.19343.qmail@dag.newtech.fi>
References: <willy@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip213-185-39-113.laajakaista.mtv3.fi ([213.185.39.113]:7051
	"HELO dag.newtech.fi") by vger.kernel.org with SMTP id S262285AbTJGMD5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 08:03:57 -0400
In-Reply-To: Message from Matthew Wilcox <willy@debian.org>
   of "Tue, 07 Oct 2003 12:56:00 BST." <20031007115600.GH24824@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Dag Nygren <dag@newtech.fi>, "Randy.Dunlap" <rddunlap@osdl.org>, linux-scsi@vger.kernel.orgdag@newtech.fi

> On Tue, Oct 07, 2003 at 08:47:00AM +0300, Dag Nygren wrote:
 
> Then you really should be taking these problems up with Red Hat,
> not with us.

So you mean that this bug is squished in 2.4.22 then? 

Anyway I got an oops-trace ran through ksymoops by the
customer and here is the result (If anyone is interested anymore....)

ksymoops 2.4.9 on i686 2.4.20-20.9.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.20-20.9/ (default)
     -m /usr/src/linux/System.map (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (expand_objects): cannot stat(/lib/ext3.o) for ext3
Error (expand_objects): cannot stat(/lib/jbd.o) for jbd
Error (expand_objects): cannot stat(/lib/aacraid.o) for aacraid
Error (expand_objects): cannot stat(/lib/aic7xxx.o) for aic7xxx
Error (expand_objects): cannot stat(/lib/sd_mod.o) for sd_mod
Error (expand_objects): cannot stat(/lib/scsi_mod.o) for scsi_mod
Error (regular_file): read_system_map stat /usr/src/linux/System.map failed
Warning (map_ksym_to_module): cannot match loaded module ext3 to a unique 
module object.  Trace may not be reliable.
Warning (map_ksym_to_module): cannot match loaded module aacraid to a unique 
module object.  Trace may not be reliable.
Oct  6 19:37:37 venus kernel: kernel BUG at panic.c:288!
Oct  6 19:37:37 venus kernel: invalid operand: 0000
Oct  6 19:37:37 venus kernel: CPU:    0
Oct  6 19:37:37 venus kernel: EIP:    0060:[<c011bec7>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
Oct  6 19:37:37 venus kernel: EFLAGS: 00010082
Oct  6 19:37:37 venus kernel: EIP is at __out_of_line_bug [kernel] 0x17 
(2.4.20-20.9)
Oct  6 19:37:37 venus kernel: eax: 00000026   ebx: 00000014   ecx: c037459c   
edx: 00000046
Oct  6 19:37:37 venus kernel: esi: f55b8000   edi: 00000011   ebp: c47a8068   
esp: f5cc3c44
Oct  6 19:37:37 venus kernel: ds: 0068   es: 0068   ss: 0068
Oct  6 19:37:37 venus kernel: Process hp_ltt (pid: 3813, stackpage=f5cc3000)
Oct  6 19:37:37 venus kernel: Stack: c0260b80 000000a2 f882ff34 000000a2 
f55b8000 00000246 c46c42b0 00000020
Oct  6 19:37:37 venus kernel:        416c4f58 c47a4080 00000001 c4659c00 
00000000 00000001 f6f2f600 f882f71d
Oct  6 19:37:37 venus kernel:        c4659c00 c4604380 00000000 00000000 
00000086 00000297 c46e32d4 f6f2f600
Oct  6 19:37:37 venus kernel: Call Trace:   [<f882ff34>] 
ahc_linux_run_device_queue [aic7xxx] 0x784 (0xf5cc3c4c))
Oct  6 19:37:37 venus kernel: [<f882f71d>] ahc_linux_queue [aic7xxx] 0x14d 
(0xf5cc3c80))
Oct  6 19:37:37 venus kernel: [<f880d6c2>] scsi_dispatch_cmd [scsi_mod] 0x112 
(0xf5cc3ca8))
Oct  6 19:37:37 venus kernel: [<f880dfc0>] scsi_done [scsi_mod] 0x0 
(0xf5cc3cb0))
Oct  6 19:37:37 venus kernel: [<f8812820>] scsi_times_out [scsi_mod] 0x0 
(0xf5cc3cb4))
Oct  6 19:37:37 venus kernel: [<f8816446>] scsi_request_fn [scsi_mod] 0x1d6 
(0xf5cc3ce0))
Oct  6 19:37:37 venus kernel: [<f8815818>] __scsi_insert_special [scsi_mod] 
0x58 (0xf5cc3d18))
Oct  6 19:37:38 venus kernel: [<f8815898>] scsi_insert_special_req [scsi_mod] 
0x28 (0xf5cc3d28))
Oct  6 19:37:38 venus kernel: [<f880daab>] scsi_do_req_R1f341175 [scsi_mod] 
0xeb (0xf5cc3d3c))
Oct  6 19:37:38 venus kernel: [<f896f320>] sg_cmd_done_bh [sg] 0x0 
(0xf5cc3d70))
Oct  6 19:37:38 venus kernel: [<f896e134>] sg_common_write [sg] 0x1f4 
(0xf5cc3d8c))
Oct  6 19:37:38 venus kernel: [<f896f320>] sg_cmd_done_bh [sg] 0x0 
(0xf5cc3da0))
Oct  6 19:37:38 venus kernel: [<f896de7b>] sg_new_write [sg] 0x1eb 
(0xf5cc3dbc))
Oct  6 19:37:38 venus kernel: [<f896ebe8>] sg_ioctl [sg] 0xa28 (0xf5cc3e00))
Oct  6 19:37:38 venus kernel: [<c0145378>] kmap_high [kernel] 0x48 
(0xf5cc3e50))
Oct  6 19:37:38 venus kernel: [<c013f01d>] __alloc_pages [kernel] 0x7d 
(0xf5cc3e70))
Oct  6 19:37:38 venus kernel: [<c012eceb>] vm_set_pte [kernel] 0x3b 
(0xf5cc3e90))
Oct  6 19:37:38 venus kernel: [<c0130227>] do_wp_page [kernel] 0x337 
(0xf5cc3eb4))
Oct  6 19:37:38 venus kernel: [<c0130ce0>] handle_mm_fault [kernel] 0x120 
(0xf5cc3ed8))
Oct  6 19:37:38 venus kernel: [<c011750c>] do_page_fault [kernel] 0x16c 
(0xf5cc3f08))
Oct  6 19:37:38 venus kernel: [<c012884b>] sys_rt_sigaction [kernel] 0x8b 
(0xf5cc3f60))
Oct  6 19:37:38 venus kernel: [<c012016e>] sys_wait4 [kernel] 0x1ce 
(0xf5cc3f74))
Oct  6 19:37:38 venus kernel: [<c0156ff9>] sys_ioctl [kernel] 0xc9 
(0xf5cc3f94))
Oct  6 19:37:38 venus kernel: [<c010953f>] system_call [kernel] 0x33 
(0xf5cc3fc0))
Oct  6 19:37:38 venus kernel: Code: 0f 0b 20 01 03 04 26 c0 90 eb fe 90 90 90 
90 90 90 90 90 90


>>EIP; c011bec7 <__out_of_line_bug+17/600>   <=====

>>ecx; c037459c <init_task_union+2459c/24a80>
>>esi; f55b8000 <___strtok+351d8e84/3842dee4>
>>ebp; c47a8068 <___strtok+43c8eec/3842dee4>
>>esp; f5cc3c44 <___strtok+358e4ac8/3842dee4>

Trace; f882ff34 <[aic7xxx]ahc_linux_run_device_queue+784/900>
Trace; f882f71d <[aic7xxx]ahc_linux_queue+14d/1e0>
Trace; f880d6c2 <[scsi_mod]scsi_dispatch_cmd+112/360>
Trace; f880dfc0 <[scsi_mod]scsi_done+0/d0>
Trace; f8812820 <[scsi_mod]scsi_times_out+0/d0>
Trace; f8816446 <[scsi_mod]scsi_request_fn+1d6/3a0>
Trace; f8815818 <[scsi_mod]__scsi_insert_special+58/80>
Trace; f8815898 <[scsi_mod]scsi_insert_special_req+28/30>
Trace; f880daab <[scsi_mod]scsi_do_req+eb/1e0>
Trace; f896f320 <[sg]sg_cmd_done_bh+0/360>
Trace; f896e134 <[sg]sg_common_write+1f4/280>
Trace; f896f320 <[sg]sg_cmd_done_bh+0/360>
Trace; f896de7b <[sg]sg_new_write+1eb/2b0>
Trace; f896ebe8 <[sg]sg_ioctl+a28/c00>
Trace; c0145378 <kmap_high+48/50>
Trace; c013f01d <__alloc_pages+7d/370>
Trace; c012eceb <cpufreq_frequency_table_setpolicy+1fb/ac0>
Trace; c0130227 <remap_page_range+587/630>
Trace; c0130ce0 <vmtruncate+a10/b00>
Trace; c011750c <__verify_write+30c/8e0>
Trace; c012884b <notify_parent+115b/1a60>
Trace; c012016e <sys_wait4+1ce/1870>
Trace; c0156ff9 <kill_fasync+269/470>
Trace; c010953f <__up_wakeup+109f/1480>

Code;  c011bec7 <__out_of_line_bug+17/600>
00000000 <_EIP>:
Code;  c011bec7 <__out_of_line_bug+17/600>   <=====
   0:   0f 0b                     ud2a      <=====
Code;  c011bec9 <__out_of_line_bug+19/600>
   2:   20 01                     and    %al,(%ecx)
Code;  c011becb <__out_of_line_bug+1b/600>
   4:   03 04 26                  add    (%esi,1),%eax
Code;  c011bece <__out_of_line_bug+1e/600>
   7:   c0 90 eb fe 90 90 90      rclb   $0x90,0x9090feeb(%eax)
Code;  c011bed5 <__out_of_line_bug+25/600>
   e:   90                        nop    
Code;  c011bed6 <__out_of_line_bug+26/600>
   f:   90                        nop    
Code;  c011bed7 <__out_of_line_bug+27/600>
  10:   90                        nop    
Code;  c011bed8 <__out_of_line_bug+28/600>
  11:   90                        nop    
Code;  c011bed9 <__out_of_line_bug+29/600>
  12:   90                        nop    
Code;  c011beda <__out_of_line_bug+2a/600>
  13:   90                        nop    


3 warnings and 7 errors issued.  Results may not be reliable.


Best for now.

-- Dag

