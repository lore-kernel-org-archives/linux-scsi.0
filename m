From: Srihari Vijayaraghavan <harisri@internode.on.net>
Subject: Re: [linux-usb-devel] Fw: [BUG] USB Storage OOPS and a D state process in 2.6.10
Date: Sat, 8 Jan 2005 11:43:12 +1100
Message-ID: <200501081143.12636.harisri@internode.on.net>
References: <Pine.LNX.4.44L0.0501051039250.635-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.adl2.internode.on.net ([203.16.214.203]:33801 "EHLO
	smtp3.adl2.internode.on.net") by vger.kernel.org with ESMTP
	id S261674AbVAHAhU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 19:37:20 -0500
In-Reply-To: <Pine.LNX.4.44L0.0501051039250.635-100000@ida.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thursday 06 January 2005 02:50, Alan Stern wrote:
> ...
> Srihari, can you try reproducing this after rebuilding the usb-storage
> driver with CONFIG_USB_STORAGE_DEBUG=y?

Alan,

I have made a couple of observations:
1. While it is still easy to trigger this bug without USB Storage Debug Option 
in vanilla 2.6.10, I cannot reproduce the bug with debug option. Perhaps it 
changes some timings.
(Without debug option, within a dozen plug/unplug events I can reliably 
trigger the bug, but OTOH with debug options I cannot even after 50 events. 
Maybe I should run my desktop with debug option for better stability. :-))

2. When running without debug option, the D state "hald" process appears 
first, and upon unplugging the drive an OOPS appears on the very next 
plugging of the drive.

Here is the new OOPS:

usb-storage: device found at 7
usb-storage: waiting for device to settle before scanning
Unable to handle kernel paging request at 0000001600000019 RIP:
<ffffffffa0108259>{:usb_storage:bus_reset+73}
PML4 32fca067 PGD 0
Oops: 0000 [1]
CPU 0
Modules linked in: radeon ipt_conntrack ip_conntrack nfsd exportfs lockd 
autofs4 sunrpc iptable_filter ip_tables af_packet sr_mod dm_mod video button 
ohci1394 ieee1394 usb_storage uhci_hcd ehci_hcd snd_via82xx snd_ac97_codec 
snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart 
snd_rawmidi snd_seq_device snd soundcore via_rhine mii r8169 crc32 floppy 
unix ext3 mbcache jbd sata_via libata sd_mod scsi_mod
Pid: 5435, comm: scsi_eh_6 Not tainted 2.6.10
RIP: 0010:[<ffffffffa0108259>] <ffffffffa0108259>{:usb_storage:bus_reset+73}
RSP: 0018:000001002fedde68  EFLAGS: 00010246
RAX: 0000001600000015 RBX: 0000010034fb7c00 RCX: 0000010037d73270
RDX: 0000000000002003 RSI: 0000000000000000 RDI: 0000003796e00000
RBP: 00000000fffffff0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000010037d73270
R13: 000001003e4cc800 R14: 000001003572ac20 R15: 0000000000000001
FS:  0000002a955792c0(0000) GS:ffffffff803c9f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000001600000019 CR3: 0000000000101000 CR4: 00000000000006e0
Process scsi_eh_6 (pid: 5435, threadinfo 000001002fedc000, task 
0000010036f1d650)
Stack: 0000010037d73240 0000010037d73240 0000010037d73270 ffffffffa0003c31
       0000000000000282 0000000000000000 0000010037d73240 ffffffffa000463b
       ff000000ff000000 ff000000ff000000
Call Trace:<ffffffffa0003c31>{:scsi_mod:scsi_try_bus_reset+113}
       <ffffffffa000463b>{:scsi_mod:scsi_error_handler+2251}
       <ffffffff8010ebf3>{child_rip+8} 
<ffffffffa0003d70>{:scsi_mod:scsi_error_handler+0}
       <ffffffff8010ebeb>{child_rip+0}

Code: 80 78 04 01 75 31 48 8b 73 20 e8 e8 c8 13 e0 85 c0 41 89 c4
RIP <ffffffffa0108259>{:usb_storage:bus_reset+73} RSP <000001002fedde68>
CR2: 0000001600000019
 <6>usb 1-5: USB disconnect, address 7


And the D state "hald" process:

Jan  8 11:29:24 desktop kernel: hald          D 0000010037507938     0  3539      
1          4354  3176 (NOTLB)
Jan  8 11:29:24 desktop kernel: 0000010037507898 0000000000000006 
000000732f812078 000001003811c0b0
Jan  8 11:29:24 desktop kernel:        0000000000003d15 000001003fd73490 
0000010037d73240 000001003eb86000
Jan  8 11:29:24 desktop kernel:        000001002f812078 0000010037507938
Jan  8 11:29:24 desktop kernel: Call 
Trace:<ffffffff802c11eb>{wait_for_completion+139} 
<ffffffff8012dc20>{default_wake_function+0}
Jan  8 11:29:24 desktop kernel:        
<ffffffff8012dc20>{default_wake_function+0} 
<ffffffffa0004f7b>{:scsi_mod:scsi_wait_req+91}
Jan  8 11:29:24 desktop kernel:        
<ffffffffa0000038>{:scsi_mod:scsi_allocate_request+56}
Jan  8 11:29:24 desktop kernel:        
<ffffffffa018a33c>{:sr_mod:sr_do_ioctl+156} 
<ffffffffa018a654>{:sr_mod:sr_audio_ioctl+372}
Jan  8 11:29:24 desktop kernel:        
<ffffffffa0004fac>{:scsi_mod:scsi_wait_req+140} 
<ffffffff8023f71e>{cdrom_count_tracks+222}
Jan  8 11:29:24 desktop kernel:        <ffffffff8023f9a0>{cdrom_open+448} 
<ffffffffa00471f4>{:ext3:ext3_get_block_handle+228}
Jan  8 11:29:24 desktop kernel:        <ffffffff8014ef4e>{find_get_page+14} 
<ffffffff8016ce4c>{__find_get_block_slow+220}
Jan  8 11:29:24 desktop kernel:        
<ffffffff8016d519>{__find_get_block+377} <ffffffff8016f87f>{__getblk+31}
Jan  8 11:29:24 desktop kernel:        <ffffffff801af4ba>{avc_has_perm+90} 
<ffffffff801af4ba>{avc_has_perm+90}
Jan  8 11:29:24 desktop kernel:        <ffffffff801af4ba>{avc_has_perm+90} 
<ffffffff801b02b4>{task_has_capability+100}
Jan  8 11:29:24 desktop kernel:        <ffffffff801c2992>{kobject_get+18} 
<ffffffff801c2992>{kobject_get+18}
Jan  8 11:29:24 desktop kernel:        
<ffffffffa0189730>{:sr_mod:sr_block_open+176} <ffffffff8017286a>{do_open+170}
Jan  8 11:29:24 desktop kernel:        <ffffffff80172c5f>{blkdev_open+47} 
<ffffffff8016aa36>{dentry_open+230}
Jan  8 11:29:24 desktop kernel:        <ffffffff8016ab7e>{filp_open+62} 
<ffffffff8016abc7>{get_unused_fd+55}
Jan  8 11:29:24 desktop kernel:        <ffffffff8016ad4c>{sys_open+76} 
<ffffffff8010e1da>{system_call+126}
Jan  8 11:29:24 desktop kernel:

Thank you.
Hari
