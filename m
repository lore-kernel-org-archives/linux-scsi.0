From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [BUG] USB Storage OOPS and a D state process in 2.6.10
Date: Wed, 5 Jan 2005 00:14:20 -0800
Message-ID: <20050105001420.5f4c8623.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Looks like the scsi-vs-usb-storage bunfight isn't yet settled...


Begin forwarded message:

Date: Fri, 31 Dec 2004 14:44:44 +1100
From: Srihari Vijayaraghavan <harisri@internode.on.net>
To: linux-kernel@vger.kernel.org
Subject: [BUG] USB Storage OOPS and a D state process in 2.6.10


Can easily reproduce this by plugging and unplugging an external USB DVD-RW a 
few times on my Athlon 64 desktop:

usb-storage: device scan complete
usb 1-2: USB disconnect, address 22
Unable to handle kernel paging request at 000000000044c8c6 RIP: 
<ffffffffa0108252>{:usb_storage:bus_reset+66}
PML4 331b9067 PGD 331ba067 PMD 331bb067 PTE 0
Oops: 0000 [1] 
CPU 0 
Modules linked in: radeon ipt_conntrack ip_conntrack nfsd exportfs lockd 
autofs4 sunrpc iptable_filter ip_tables af_packet sr_mod dm_mod video button 
ohci1394 ieee1394 usb_storage uhci_hcd ehci_hcd snd_via82xx snd_ac97_codec 
snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart 
snd_rawmidi snd_seq_device snd soundcore via_rhine mii r8169 crc32 floppy 
unix ext3 mbcache jbd sata_via libata sd_mod scsi_mod
Pid: 8843, comm: scsi_eh_22 Not tainted 2.6.10
RIP: 0010:[<ffffffffa0108252>] <ffffffffa0108252>{:usb_storage:bus_reset+66}
RSP: 0018:000001002f9a7e68  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000001002f8ec200 RCX: 0000010037d6f670
RDX: 0000000000002003 RSI: 0000000000000000 RDI: 000000000044c68e
RBP: 00000000fffffff0 R08: 0000000000000000 R09: 0000000000000001
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000010037d6f670
R13: 0000010036acf400 R14: 000001002f6c4c20 R15: 0000000000000001
FS:  0000002a955792c0(0000) GS:ffffffff803c9f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000044c8c6 CR3: 0000000000101000 CR4: 00000000000006e0
Process scsi_eh_22 (pid: 8843, threadinfo 000001002f9a6000, task 
00000100369f70f0)
Stack: 0000010037d6f640 0000010037d6f640 0000010037d6f670 ffffffffa0003c31 
       0000000000000282 0000000000000000 0000010037d6f640 ffffffffa000463b 
       ff000000ff000000 ff000000ff000000 
Call Trace:<ffffffffa0003c31>{:scsi_mod:scsi_try_bus_reset+113} 
       <ffffffffa000463b>{:scsi_mod:scsi_error_handler+2251} 
       <ffffffff8010ebf3>{child_rip+8} 
<ffffffffa0003d70>{:scsi_mod:scsi_error_handler+0} 
       <ffffffff8010ebeb>{child_rip+0} 

Code: 48 8b 87 38 02 00 00 80 78 04 01 75 31 48 8b 73 20 e8 e8 c8 
RIP <ffffffffa0108252>{:usb_storage:bus_reset+66} RSP <000001002f9a7e68>
CR2: 000000000044c8c6
 <6>agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.

And a D state hald process:

Dec 31 13:52:09 desktop kernel: hald          D 00000100376c3938     0  3677      
1          4600  2304 (NOTLB)
Dec 31 13:52:09 desktop kernel: 00000100376c3898 0000000000000006 
000000732f5c80b8 000001003f7555d0 
Dec 31 13:52:09 desktop kernel:        0000000000000736 000001003fed2070 
0000010037d6f640 00000100368f8000 
Dec 31 13:52:09 desktop kernel:        000001002f5c80b8 00000100376c3938 
Dec 31 13:52:09 desktop kernel: Call 
Trace:<ffffffff802c11eb>{wait_for_completion+139} 
<ffffffff8012dc20>{default_wake_function+0} 
Dec 31 13:52:09 desktop kernel:        
<ffffffff8012dc20>{default_wake_function+0} 
<ffffffffa0004f7b>{:scsi_mod:scsi_wait_req+91} 
Dec 31 13:52:09 desktop kernel:        
<ffffffffa0000038>{:scsi_mod:scsi_allocate_request+56} 
Dec 31 13:52:09 desktop kernel:        
<ffffffffa018a33c>{:sr_mod:sr_do_ioctl+156} 
<ffffffffa018a654>{:sr_mod:sr_audio_ioctl+372} 
Dec 31 13:52:09 desktop kernel:        
<ffffffffa0004fac>{:scsi_mod:scsi_wait_req+140} 
<ffffffff8023f71e>{cdrom_count_tracks+222} 
Dec 31 13:52:09 desktop kernel:        <ffffffff8023f9a0>{cdrom_open+448} 
<ffffffffa00471f4>{:ext3:ext3_get_block_handle+228} 
Dec 31 13:52:09 desktop kernel:        <ffffffff8014ef4e>{find_get_page+14} 
<ffffffff8016ce4c>{__find_get_block_slow+220} 
Dec 31 13:52:09 desktop kernel:        
<ffffffff8016d519>{__find_get_block+377} <ffffffff8016f87f>{__getblk+31} 
Dec 31 13:52:09 desktop kernel:        <ffffffff801af4ba>{avc_has_perm+90} 
<ffffffff801af4ba>{avc_has_perm+90} 
Dec 31 13:52:09 desktop kernel:        <ffffffff801af4ba>{avc_has_perm+90} 
<ffffffff801b02b4>{task_has_capability+100} 
Dec 31 13:52:09 desktop kernel:        <ffffffff801c2992>{kobject_get+18} 
<ffffffff801c2992>{kobject_get+18} 
Dec 31 13:52:09 desktop kernel:        
<ffffffffa0189730>{:sr_mod:sr_block_open+176} <ffffffff8017286a>{do_open+170} 
Dec 31 13:52:09 desktop kernel:        <ffffffff80172c5f>{blkdev_open+47} 
<ffffffff8016aa36>{dentry_open+230} 
Dec 31 13:52:09 desktop kernel:        <ffffffff8016ab7e>{filp_open+62} 
<ffffffff8016abc7>{get_unused_fd+55} 
Dec 31 13:52:09 desktop kernel:        <ffffffff8016ad4c>{sys_open+76} 
<ffffffff8010e1da>{system_call+126} 
Dec 31 13:52:09 desktop kernel:        

Thanks
Hari.

PS: I am not subscribed to LKML, so please cc me on replies.
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


-------------------------------------------------------
The SF.Net email is sponsored by: Beat the post-holiday blues
Get a FREE limited edition SourceForge.net t-shirt from ThinkGeek.
It's fun and FREE -- well, almost....http://www.thinkgeek.com/sfshirt
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
