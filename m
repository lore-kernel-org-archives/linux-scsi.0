From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: bsg_unregister_queue attempts to remove "bsg" sysfs link that
 doesn't exist
Date: Thu, 9 Feb 2012 15:24:02 -0800
Message-ID: <20120209152402.cdaf1b55.akpm@linux-foundation.org>
References: <4F32E0F8.4080203@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F32E0F8.4080203@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

(cc's added)

Kernel version appears to be 3.3-rc2.  

On Wed, 08 Feb 2012 20:54:16 +0000
Simon Arlott <simon@fire.lp0.eu> wrote:

> I unplugged two hard drives and this happened:
> [168525.975223] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL}, Code={Reset}, SubCode(0x0d00) cb_idx mptbase_reply
> [168527.976303] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL}, Code={Reset}, SubCode(0x0d00) cb_idx mptbase_reply
> [168530.879028]  end_device-8:2: mptsas: ioc0: removing sata device: fw_channel 0, fw_id 13, phy 7,sas_addr 0xde5c3f3bbc9bae8f
> [168530.879034]  phy-8:7: mptsas: ioc0: delete phy 7, phy-obj (0xffff88027582b800)
> [168530.879045]  port-8:2: mptsas: ioc0: delete port 2, sas_addr (0xde5c3f3bbc9bae8f)
> [168530.879525] sd 8:0:2:0: [sdh] Synchronizing SCSI cache
> [168530.879581] sd 8:0:2:0: [sdh]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [168530.879651] scsi target8:0:2: mptsas: ioc0: delete device: fw_channel 0, fw_id 13, phy 7, sas_addr 0xde5c3f3bbc9bae8f
> [168530.879706] ------------[ cut here ]------------
> [168530.879715] WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0x9c/0xb0()
> [168530.879717] Hardware name: empty
> [168530.879719] sysfs: can not remove 'bsg', no directory
> [168530.879721] Modules linked in: zaurus cdc_ether usbnet bnep rfcomm bridge stp fuse ext4 jbd2 nf_conntrack_ipv6 ipt_REJECT iptable_filter nf_defrag_ipv6 xt_state ip6t_REJECT iptable_mangle xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack xt_connmark nf_conntrack ip6_tables ip_tables x_tables btusb bluetooth crc16
> [168530.879757] Pid: 1578, comm: kworker/u:7 Tainted: G       A     3.3.0-rc2+ #00119-gd8e94fc-dirty
> [168530.879761] Call Trace:
> [168530.879770]  [<ffffffff8103a29a>] warn_slowpath_common+0x7a/0xb0
> [168530.879774]  [<ffffffff8103a371>] warn_slowpath_fmt+0x41/0x50
> [168530.879778]  [<ffffffff81154fbc>] sysfs_hash_and_remove+0x9c/0xb0
> [168530.879782]  [<ffffffff81157a01>] sysfs_remove_link+0x21/0x30
> [168530.879788]  [<ffffffff81274bb7>] bsg_unregister_queue+0x47/0xa0
> [168530.879795]  [<ffffffff813fdc20>] sas_rphy_free+0xa0/0xd0
> [168530.879798]  [<ffffffff813fe9e9>] sas_rphy_delete+0x19/0x20
> [168530.879801]  [<ffffffff813fea15>] sas_port_delete+0x25/0x130
> [168530.879806]  [<ffffffff814581c3>] mptsas_del_end_device+0x183/0x1c0
> [168530.879810]  [<ffffffff8145aedc>] mptsas_hotplug_work+0x1ec/0x6a0
> [168530.879816]  [<ffffffff810698e5>] ? idle_balance+0xf5/0x150
> [168530.879820]  [<ffffffff81061779>] ? finish_task_switch+0x49/0xd0
> [168530.879824]  [<ffffffff8145c183>] mptsas_firmware_event_work+0xa63/0xca0
> [168530.879829]  [<ffffffff81046cf7>] ? lock_timer_base+0x37/0x70
> [168530.879832]  [<ffffffff8145b720>] ? mptsas_send_ir2_event+0x110/0x110
> [168530.879836]  [<ffffffff8104fd67>] process_one_work+0x117/0x3c0
> [168530.879839]  [<ffffffff81050382>] worker_thread+0x172/0x3e0
> [168530.879844]  [<ffffffff8105e651>] ? __wake_up_common+0x51/0x80
> [168530.879847]  [<ffffffff81050210>] ? manage_workers+0x200/0x200
> [168530.879852]  [<ffffffff81056796>] kthread+0x96/0xa0
> [168530.879858]  [<ffffffff816d01d4>] kernel_thread_helper+0x4/0x10
> [168530.879862]  [<ffffffff81056700>] ? kthread_freezable_should_stop+0x60/0x60
> [168530.879866]  [<ffffffff816d01d0>] ? gs_change+0xb/0xb
> [168530.879869] ---[ end trace b116d5a791652b31 ]---
> [168532.879048]  end_device-8:1: mptsas: ioc0: removing sata device: fw_channel 0, fw_id 12, phy 6,sas_addr 0xde5c3f3cc395aa8e
> [168532.879054]  phy-8:6: mptsas: ioc0: delete phy 6, phy-obj (0xffff88027582b000)
> [168532.879065]  port-8:1: mptsas: ioc0: delete port 1, sas_addr (0xde5c3f3cc395aa8e)
> [168532.879580] sd 8:0:1:0: [sdg] Synchronizing SCSI cache
> [168532.879692] sd 8:0:1:0: [sdg]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [168532.879877] scsi target8:0:1: mptsas: ioc0: delete device: fw_channel 0, fw_id 12, phy 6, sas_addr 0xde5c3f3cc395aa8e
> [168532.879999] ------------[ cut here ]------------
> [168532.880033] WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0x9c/0xb0()
> [168532.880038] Hardware name: empty
> [168532.880042] sysfs: can not remove 'bsg', no directory
> [168532.880045] Modules linked in: zaurus cdc_ether usbnet bnep rfcomm bridge stp fuse ext4 jbd2 nf_conntrack_ipv6 ipt_REJECT iptable_filter nf_defrag_ipv6 xt_state ip6t_REJECT iptable_mangle xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack xt_connmark nf_conntrack ip6_tables ip_tables x_tables btusb bluetooth crc16
> [168532.880108] Pid: 1578, comm: kworker/u:7 Tainted: G       AW    3.3.0-rc2+ #00119-gd8e94fc-dirty
> [168532.880115] Call Trace:
> [168532.880128]  [<ffffffff8103a29a>] warn_slowpath_common+0x7a/0xb0
> [168532.880136]  [<ffffffff8103a371>] warn_slowpath_fmt+0x41/0x50
> [168532.880143]  [<ffffffff81154fbc>] sysfs_hash_and_remove+0x9c/0xb0
> [168532.880152]  [<ffffffff81157a01>] sysfs_remove_link+0x21/0x30
> [168532.880160]  [<ffffffff81274bb7>] bsg_unregister_queue+0x47/0xa0
> [168532.880171]  [<ffffffff813fdc20>] sas_rphy_free+0xa0/0xd0
> [168532.880177]  [<ffffffff813fe9e9>] sas_rphy_delete+0x19/0x20
> [168532.880183]  [<ffffffff813fea15>] sas_port_delete+0x25/0x130
> [168532.880192]  [<ffffffff814581c3>] mptsas_del_end_device+0x183/0x1c0
> [168532.880218]  [<ffffffff8145aedc>] mptsas_hotplug_work+0x1ec/0x6a0
> [168532.880227]  [<ffffffff810698e5>] ? idle_balance+0xf5/0x150
> [168532.880234]  [<ffffffff81061779>] ? finish_task_switch+0x49/0xd0
> [168532.880241]  [<ffffffff8145c183>] mptsas_firmware_event_work+0xa63/0xca0
> [168532.880250]  [<ffffffff81046cf7>] ? lock_timer_base+0x37/0x70
> [168532.880256]  [<ffffffff8145b720>] ? mptsas_send_ir2_event+0x110/0x110
> [168532.880264]  [<ffffffff8104fd67>] process_one_work+0x117/0x3c0
> [168532.880270]  [<ffffffff81050382>] worker_thread+0x172/0x3e0
> [168532.880279]  [<ffffffff8105e651>] ? __wake_up_common+0x51/0x80
> [168532.880285]  [<ffffffff81050210>] ? manage_workers+0x200/0x200
> [168532.880293]  [<ffffffff81056796>] kthread+0x96/0xa0
> [168532.880303]  [<ffffffff816d01d4>] kernel_thread_helper+0x4/0x10
> [168532.880316]  [<ffffffff81056700>] ? kthread_freezable_should_stop+0x60/0x60
> [168532.880329]  [<ffffffff816d01d0>] ? gs_change+0xb/0xb
> [168532.880336] ---[ end trace b116d5a791652b32 ]---
