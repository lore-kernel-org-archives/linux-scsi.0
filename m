From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCHv3 0/9] New EH command timeout handler
Date: Fri, 12 Jul 2013 12:14:49 +0800
Message-ID: <51DF82B9.8030406@cn.fujitsu.com>
References: <1372688671-85639-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17071 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab3GLELE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 00:11:04 -0400
In-Reply-To: <1372688671-85639-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>

Hi, Hannes:

On 07/01/2013 10:24 PM, Hannes Reinecke wrote:
> With the original SCSI EH I got:
> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
> 4096+0 records in
> 4096+0 records out
> 16777216 bytes (17 MB) copied, 142.652 s, 118 kB/s
>
> real	2m22.657s
> user	0m0.013s
> sys	0m0.145s
>
> With this patchset I got:
> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
> 4096+0 records in
> 4096+0 records out
> 16777216 bytes (17 MB) copied, 52.1579 s, 322 kB/s
>
> real	0m52.163s
> user	0m0.012s
> sys	0m0.145s
>
> Test was to disable RSCN on the target port, disable the
> target port, and then start the 'dd' command as indicated.

Do you mean disabling RSCN/port is enough? I'm afraid I couldn't
reproduce the problem by your steps. Both with and without your
patchset are the same 'dd' result: 27s. Please let me know where I
neglected or mistook:

1) I made a dm-multipath target 'dm-0' whose grouping policy was
    failover;
2) Disable RSCN/port via brocade fc switch:
    SW300:root> portcfg rscnsupr 15 --enable; portDisable 15
3) Start the 'dd' command:
    # time dd if=/dev/zero of=/dev/dm-0 bs=4k count=4k oflag=direct
    dd: writing `/dev/sde': Input/output error
    1+0 records in
    0+0 records out
    0 bytes (0 B) copied, 27.8588 s, 0.0 kB/s

    real    0m27.860s
    user    0m0.001s
    sys     0m0.000s
#) Corresponding logs in /var/log/messages
Jul  9 14:56:06 build kernel: lpfc 0000:0d:00.1: 1:1305 Link Down Event 
x4 received Data: x4 x20 x110 x0 x0
Jul  9 14:56:36 build kernel: rport-3:0-2: blocked FC remote port time 
out: removing target and saving binding
Jul  9 14:56:36 build kernel: sd 3:0:0:0: rejecting I/O to offline device
Jul  9 14:56:36 build kernel: lpfc 0000:0d:00.1: 1:(0):0203 Devloss 
timeout on WWPN 20:41:00:0b:5d:6a:14:e7 NPort x620700 Data: x0 x8 x0
Jul  9 14:56:36 build kernel: sd 3:0:0:0: [sde] Synchronizing SCSI cache
Jul  9 14:56:36 build kernel: sd 3:0:0:0: [sde]
Jul  9 14:56:36 build kernel: Result: hostbyte=DID_NO_CONNECT 
driverbyte=DRIVER_OK
Jul  9 14:56:36 build kernel: sd 3:0:0:1: [sdf] Synchronizing SCSI cache
Jul  9 14:56:36 build kernel: sd 3:0:0:1: [sdf]
Jul  9 14:56:36 build kernel: Result: hostbyte=DID_NO_CONNECT 
driverbyte=DRIVER_OK
Jul  9 14:56:36 build multipathd: sdf: remove path (uevent)
Jul  9 14:56:36 build multipathd: mpatha: load table [0 104857600 
multipath 1 queue_if_no_path 0 1 1 round-robin 0 1 1 8:112 1]
Jul  9 14:56:36 build multipathd: sdf: path removed from map mpatha
Jul  9 14:56:36 build udevd-work[8420]: error opening 
ATTR{/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/0000:02:01.0/0000:0a:00.0/0000:0b:01.0/0000:0d:00.1/host3/rport-3:0-2/target3:0:0/3:0:0:0/block/sde/queue/iosched/slice_idle} 
for writing: No such file or directory
Jul  9 14:56:36 build udevd-work[8420]: error opening 
ATTR{/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/0000:02:01.0/0000:0a:00.0/0000:0b:01.0/0000:0d:00.1/host3/rport-3:0-2/target3:0:0/3:0:0:0/block/sde/queue/iosched/quantum} 
for writing: No such file or directory
Jul  9 14:56:36 build multipathd: sde: remove path (uevent)
Jul  9 14:56:36 build multipathd: mpathb: load table [0 104857600 
multipath 1 queue_if_no_path 0 1 1 round-robin 0 1 1 8:96 1]
Jul  9 14:56:36 build multipathd: sde: path removed from map mpathb
* there are two disks sde and sdf connected via port 15

Another question:

I also tried to produce timeouts by modifying Yasui's module(please
see APPENDIX A):
http://www.spinics.net/lists/linux-scsi/msg35091.html

But I got a bug with your this patchset by follwing steps(there was
not such bug without your patchset):

# grep lpfc_template /proc/kallsyms
ffffffffa00f9240 d lpfc_template    [lpfc]
# multipath -ll
...
mpathb (36000b5d0006a0000006a14e7000c0000) dm-1 FUJITSU,ETERNUS_DX400
size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=130 status=active
| `- 2:0:0:1 sdf 8:80  active ready running
`-+- policy='round-robin 0' prio=130 status=enabled
   `- 3:0:0:1 sdh 8:112 active ready running
# insmod scsi_tmo_mod.ko param=0xffffffffa00f9240,2:0:0:1; time dd 
if=/dev/zero of=/dev/dm-1 bs=4k count=4k oflag=direct
4096+0 records in
4096+0 records out
16777216 bytes (17 MB) copied, 151.194 s, 111 kB/s

real    2m31.195s
user    0m0.004s
sys    0m0.111s

Please see logs in APPENDIX B. Do you think this bug is irrelevant to
your patchset?

Thanks,
Ren

APPENDIX A:

/*
  * scsi timeout injection module
  */
#include <linux/module.h>
#include <scsi/scsi_cmnd.h>
#include <scsi/scsi_host.h>
#include <scsi/scsi_device.h>

static struct scsi_host_template *sht;
static char config[32];

static struct target {
         short host;
         uint channel;
         uint id;
         uint lun;
} st;

static int (*org_qc)(struct Scsi_Host *, struct scsi_cmnd *);


static inline int check_dev(struct target *st, struct scsi_cmnd *cmd)
{
         return (st->host == cmd->device->host->host_no &&
                 st->channel == cmd->device->channel &&
                 st->id == cmd->device->id &&
                 st->lun == cmd->device->lun);
}

static int dbg_qc(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
{
         int ret = 0;

         preempt_disable();
         if (check_dev(&st, cmd))
                 goto done;
         ret = org_qc(shost, cmd);
done:
         preempt_enable();
         return ret;
}

static int __init scsi_timeout_module_init(void)
{
         int ret;

         ret = sscanf(config, "%lx,%hd:%d:%d:%d",
                      (ulong *)&sht,
&st.host, &st.channel, &st.id, &st.lun);
         if (ret != 5) {
                 printk(KERN_INFO "scsi_timeout_module: invalid options\n");
                 return -1;
         }

         org_qc = sht->queuecommand;
         sht->queuecommand = dbg_qc;

         printk(KERN_INFO
                "scsi timeout injection: %hd:%d:%d:%d\n",
                st.host, st.channel, st.id, st.lun);

         return 0;
}

static void __exit scsi_timeout_module_exit(void)
{
         sht->queuecommand = org_qc;
         synchronize_sched();
}

module_init(scsi_timeout_module_init);
module_exit(scsi_timeout_module_exit);
module_param_string(param, config, 32, 0);

MODULE_AUTHOR("Takahiro Yasui <tyasui@xxxxxxxxxx>");
MODULE_LICENSE("GPL");

APPENDIX B:

Jul 11 11:51:06 build kernel: scsi timeout injection: 2:0:0:1
Jul 11 11:51:37 build kernel: sd 2:0:0:1: [sdf] scmd ffff88046a8af200 
abort scheduled
Jul 11 11:51:37 build kernel: sd 2:0:0:1: [sdf] aborting command 
ffff88046a8af200
Jul 11 11:51:37 build kernel: sd 2:0:0:1: [sdf] retry aborted command
Jul 11 11:51:45 build kernel: sd 2:0:0:1: [sdf] scmd ffff88046a8181c0 
abort scheduled
Jul 11 11:51:45 build kernel: sd 2:0:0:1: [sdf] aborting command 
ffff88046a8181c0
Jul 11 11:51:45 build kernel: sd 2:0:0:1: [sdf] finish aborted command
Jul 11 11:52:16 build kernel: sd 2:0:0:1: [sdf] scmd ffff88046a8af200 
abort timeout
Jul 11 11:52:16 build kernel: BUG: scheduling while atomic: 
swapper/2/0/0x10000100
Jul 11 11:52:16 build kernel: Modules linked in: scsi_tmo_mod(OF) 
ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM 
iptable_mangle iptable_filter ip_tables bridge autofs4 sunrpc 8021q garp 
stp llc ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_round_robin 
dm_multipath vhost_net macvtap macvlan tun uinput raid1 iTCO_wdt 
iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode pcspkr 
i2c_i801 lpc_ich mfd_core ioatdma i7core_edac edac_core sg e1000e dm_mod 
igb dca i2c_algo_bit i2c_core ptp pps_core ext4(F) jbd2(F) mbcache(F) 
sd_mod(F) lpfc(F) scsi_transport_fc(F) scsi_tgt(F) crc_t10dif(F) 
mptsas(F) mptscsih(F) mptbase(F) scsi_transport_sas(F) [last unloaded: 
speedstep_lib]
Jul 11 11:52:16 build kernel: CPU: 2 PID: 0 Comm: swapper/2 Tainted: 
GF          O 3.10.0hannes+ #9
Jul 11 11:52:16 build kernel: Hardware name: ...
Jul 11 11:52:16 build kernel: 0000000000000002 ffff88047ee43b88 
ffffffff8153aac4 ffff88047ee43b98
Jul 11 11:52:16 build kernel: ffffffff8107389d ffff88047ee43c28 
ffffffff8153c746 ffff88046ee0bfd8
Jul 11 11:52:16 build kernel: 0000000000012d00 ffff88046ee0a010 
0000000000012d00 0000000000012d00
Jul 11 11:52:16 build kernel: Call Trace:
Jul 11 11:52:16 build kernel: <IRQ>  [<ffffffff8153aac4>] 
dump_stack+0x19/0x1d
Jul 11 11:52:16 build kernel: [<ffffffff8107389d>] __schedule_bug+0x4d/0x60
Jul 11 11:52:16 build kernel: [<ffffffff8153c746>] __schedule+0x646/0x6f0
Jul 11 11:52:16 build kernel: [<ffffffff81081daa>] ? 
enqueue_entity+0x22a/0x920
Jul 11 11:52:16 build kernel: [<ffffffff8107749a>] __cond_resched+0x2a/0x40
Jul 11 11:52:16 build kernel: [<ffffffff8153c880>] _cond_resched+0x30/0x40
Jul 11 11:52:16 build kernel: [<ffffffff8105fecc>] 
start_flush_work+0x2c/0x140
Jul 11 11:52:16 build kernel: [<ffffffff8105fffa>] flush_work+0x1a/0x40
Jul 11 11:52:16 build kernel: [<ffffffff8106027e>] 
__cancel_work_timer+0x7e/0x110
Jul 11 11:52:16 build kernel: [<ffffffff81060340>] 
cancel_work_sync+0x10/0x20
Jul 11 11:52:16 build kernel: [<ffffffff813799f6>] 
scsi_abort_command+0x36/0x220
Jul 11 11:52:16 build kernel: [<ffffffffa005f9eb>] 
fc_timed_out+0x3b/0x40 [scsi_transport_fc]
Jul 11 11:52:16 build kernel: [<ffffffff8137a257>] scsi_times_out+0x67/0x120
Jul 11 11:52:16 build kernel: [<ffffffff8123980b>] 
blk_rq_timed_out+0x1b/0x70
Jul 11 11:52:16 build kernel: [<ffffffff812399f0>] 
blk_rq_timed_out_timer+0x100/0x150
Jul 11 11:52:16 build kernel: [<ffffffff8105f610>] ? 
__queue_work+0x360/0x360
Jul 11 11:52:16 build kernel: [<ffffffff812398f0>] ? 
blk_abort_request+0x40/0x40
Jul 11 11:52:16 build kernel: [<ffffffff810511f9>] call_timer_fn+0x49/0x120
Jul 11 11:52:16 build kernel: [<ffffffff810517f5>] 
run_timer_softirq+0x225/0x290
Jul 11 11:52:16 build kernel: [<ffffffff812398f0>] ? 
blk_abort_request+0x40/0x40
Jul 11 11:52:16 build kernel: [<ffffffff81049a4f>] __do_softirq+0xef/0x260
Jul 11 11:52:16 build kernel: [<ffffffff81049cb5>] irq_exit+0xb5/0xc0
Jul 11 11:52:16 build kernel: [<ffffffff8154822e>] 
smp_apic_timer_interrupt+0x6e/0x99
Jul 11 11:52:16 build kernel: [<ffffffff8154744a>] 
apic_timer_interrupt+0x6a/0x70
Jul 11 11:52:16 build kernel: <EOI>  [<ffffffff8109b5f2>] ? 
clockevents_notify+0x52/0x150
Jul 11 11:52:16 build kernel: [<ffffffff8142da03>] ? 
cpuidle_enter_state+0x53/0xd0
Jul 11 11:52:16 build kernel: [<ffffffff8142d9ff>] ? 
cpuidle_enter_state+0x4f/0xd0
Jul 11 11:52:16 build kernel: [<ffffffff8142de2f>] 
cpuidle_idle_call+0xcf/0x160
Jul 11 11:52:16 build kernel: [<ffffffff8100ab1e>] arch_cpu_idle+0xe/0x30
Jul 11 11:52:16 build kernel: [<ffffffff81093275>] cpu_idle_loop+0x65/0x1f0
Jul 11 11:52:16 build kernel: [<ffffffff81093470>] 
cpu_startup_entry+0x70/0x80
Jul 11 11:52:16 build kernel: [<ffffffff81532cf7>] start_secondary+0xc7/0xc9
Jul 11 11:52:16 build kernel: sd 2:0:0:1: [sdf] host in recovery, not 
aborting
Jul 11 11:52:16 build kernel: scsi_eh_2: waking up 0/2/2
Jul 11 11:52:16 build kernel: sd 2:0:0:1: scsi_eh_prt_fail_stats: cmds 
failed: 1, cancel: 1
Jul 11 11:52:16 build kernel: Total of 2 commands on 1 devices require 
eh work
Jul 11 11:52:16 build kernel: sd 2:0:0:1: [sdf] scsi_eh_2: requesting sense
Jul 11 11:52:26 build kernel: scsi_send_eh_cmnd: scmd: ffff88046a8af200, 
timeleft: 0
Jul 11 11:52:26 build kernel: scsi_eh_2: aborting cmd:0xffff88046ce48980
Jul 11 11:52:36 build kernel: scsi_send_eh_cmnd: scmd: ffff88046ce48980, 
timeleft: 0
Jul 11 11:52:36 build kernel: scsi_eh_tur: scmd ffff88046ce48980 rtn 2003
Jul 11 11:52:36 build kernel: scsi_eh_2: Sending BDR sdev: 
0xffff88046a84b000
Jul 11 11:52:36 build kernel: lpfc 0000:0d:00.0: 0:(0):0713 SCSI layer 
issued Device Reset (0, 1) return x2002
Jul 11 11:52:46 build kernel: scsi_send_eh_cmnd: scmd: ffff88046a8af200, 
timeleft: 0
Jul 11 11:52:46 build kernel: scsi_eh_tur: scmd ffff88046a8af200 rtn 2003
Jul 11 11:52:46 build kernel: scsi_eh_2: Sending target reset to target 0
Jul 11 11:52:46 build kernel: lpfc 0000:0d:00.0: 0:(0):0723 SCSI layer 
issued Target Reset (0, 1) return x2002
Jul 11 11:52:56 build kernel: scsi_send_eh_cmnd: scmd: ffff88046a8af200, 
timeleft: 0
Jul 11 11:52:56 build kernel: scsi_eh_tur: scmd ffff88046a8af200 rtn 2003
Jul 11 11:52:56 build kernel: scsi_eh_2: Sending BRST chan: 0
Jul 11 11:52:56 build kernel: scsi_try_bus_reset: Snd Bus RST
Jul 11 11:52:56 build kernel: lpfc 0000:0d:00.0: 0:(0):0714 SCSI layer 
issued Bus Reset Data: x2002
Jul 11 11:53:16 build kernel: scsi_send_eh_cmnd: scmd: ffff88046a8af200, 
timeleft: 0
Jul 11 11:53:16 build kernel: scsi_eh_tur: scmd ffff88046a8af200 rtn 2003
Jul 11 11:53:16 build kernel: scsi_eh_2: Sending HRST
Jul 11 11:53:16 build kernel: scsi_try_host_reset: Snd Host RST
Jul 11 11:53:16 build kernel: lpfc 0000:0d:00.0: 0:(0):3172 SCSI layer 
issued Host Reset Data:
Jul 11 11:53:17 build kernel: lpfc 0000:0d:00.0: 0:1303 Link Up Event x1 
received Data: x1 xf7 x20 x0 x0 x0 0
Jul 11 11:53:37 build kernel: scsi_send_eh_cmnd: scmd: ffff88046a8af200, 
timeleft: 0
Jul 11 11:53:37 build kernel: scsi_eh_tur: scmd ffff88046a8af200 rtn 2003
Jul 11 11:53:37 build kernel: sd 2:0:0:1: Device offlined - not ready 
after error recovery
Jul 11 11:53:37 build kernel: sd 2:0:0:1: Device offlined - not ready 
after error recovery
Jul 11 11:53:37 build kernel: scsi_eh_2: flush finish cmd: ffff88046a8af200
Jul 11 11:53:37 build kernel: sd 2:0:0:1: [sdf] Unhandled error code
Jul 11 11:53:37 build kernel: sd 2:0:0:1: [sdf]
Jul 11 11:53:37 build kernel: Result: hostbyte=DID_TIME_OUT 
driverbyte=DRIVER_OK
Jul 11 11:53:37 build kernel: sd 2:0:0:1: [sdf] CDB:
Jul 11 11:53:37 build kernel: Write(10): 2a 00 00 00 00 00 00 00 08 00
Jul 11 11:53:37 build kernel: end_request: I/O error, dev sdf, sector 0
Jul 11 11:53:37 build kernel: scsi_eh_2: flush finish cmd: ffff88046ce48980
Jul 11 11:53:37 build kernel: device-mapper: multipath: Failing path 8:80.
Jul 11 11:53:37 build kernel: scsi_eh_2 waking up host to restart
Jul 11 11:53:37 build kernel: scsi_eh_2: sleeping
Jul 11 11:53:37 build multipathd: 8:80: mark as failed
Jul 11 11:53:37 build multipathd: mpathb: remaining active paths: 1
Jul 11 11:53:37 build multipathd: mpathb: switch to path group #2
Jul 11 11:53:48 build kernel: rport-2:0-4: blocked FC remote port time 
out: removing rport

