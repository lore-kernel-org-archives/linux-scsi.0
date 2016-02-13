From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Fri, 12 Feb 2016 23:03:04 -0800
Message-ID: <1455346984.9013.74.camel@haakon3.risingtidesystems.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
	 <D2DE6219.D6C44%himanshu.madhani@qlogic.com>
	 <1454995505.10001.153.camel@haakon3.risingtidesystems.com>
	 <D2DF69D8.D6DC5%himanshu.madhani@qlogic.com>
	 <1455173594.27060.49.camel@haakon3.risingtidesystems.com>
	 <1455234468.30845.8.camel@haakon3.risingtidesystems.com>
	 <D2E2AA30.D71E4%himanshu.madhani@qlogic.com>
	 <1455266895.10977.15.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xj4rrDgftrobsiQFQTef"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1455266895.10977.15.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org


--=-xj4rrDgftrobsiQFQTef
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hi Himanshu & Co,

On Fri, 2016-02-12 at 00:48 -0800, Nicholas A. Bellinger wrote:
> On Fri, 2016-02-12 at 05:30 +0000, Himanshu Madhani wrote:

<SNIP>

> Thanks for the crash dump output.
> 
> So it's a t_state = TRANSPORT_WRITE_PENDING descriptor with
> SAM_STAT_CHECK_CONDITION + cmd_kref.refcount = 0:
> 
> struct qla_tgt_cmd {
>   se_cmd = {
>     scsi_status = 0x2
>     se_cmd_flags = 0x80090d,
> 
>     <SNIP>
> 
>     cmd_kref = {
>       refcount = {
>         counter = 0x0
>       }
>     }, 
> }
> 
> The se_cmd_flags=0x80090d translation to enum se_cmd_flags_table:
> 
> - SCF_TRANSPORT_TASK_SENSE
> - SCF_EMULATED_TASK_SENSE
> - SCF_SCSI_DATA_CDB
> - SCF_SE_LUN_CMD
> - SCF_SENT_CHECK_CONDITION
> - SCF_USE_CPUID
> 

After groking your dump some more:

For SAM_STAT_CHECK_CONDITION with t_state = TRANSPORT_WRITE_PENDING plus
se_cmd->transport_state = 0x880 bits set, is:

- CMD_T_DEV_ACTIVE
- CMD_T_FABRIC_STOP

and sense buffer = 0x70 00 0b 00 00 00 00 0a 00 00 00 00 29 03 00,
which is the following from sense_info_table[]:

      [TCM_CHECK_CONDITION_ABORT_CMD] = {
                .key = ABORTED_COMMAND,
                .asc = 0x29, /* BUS DEVICE RESET FUNCTION OCCURRED */
                .ascq = 0x03,
        },

The descriptor looks like it did make it to tcm_qla2xxx_complete_free()
-> transport_generic_free_cmd() with both qla_tgt_cmd->cmd_sent_to_fw=0,
and qla_tgt_cmd->write_data_transferred=0 set.

The best I can tell, it looks like tcm_qla2xxx_handle_data_work() ->
transport_generic_request_failure() w/ TCM_CHECK_CONDITION_ABORT_CMD is
occurring..

So to confirm, this specific bug was not a result of active I/O
LUN_RESET w/ CMD_T_ABORTED during session disconnect, or otherwise.

> 
> > I can recreate this issue at will within 5 minute of triggering sg_reset
> > with following steps
> > 
> > 1. Export 4 RAM disk LUNs on each of 2 port adapter. Initiator will see 8
> > RAM disk targets
> > 2. Start IO with 4K block size and 8 threads with 80% write 20% read and
> > 100% dandom. 
> > (I am using vdbench for generating IO. I can provide setup/config script
> > if needed)
> > 3. Start sg_reset for each LUNs with first device, bus and host with 120s
> > delay. (I¹ve attached
> > My script that I am using for triggering sg_reset)
> > 
> 
> Thanks, will keep looking and try to reproduce with your script.

So here's my test setup with 3x Intel P3600 NVMe/IBLOCK backends, across
dual ISP2532 ports:

o- / ......................................................................................... [...]
  o- backstores .............................................................................. [...]
  | o- fileio ................................................................... [0 Storage Object]
  | o- iblock .................................................................. [3 Storage Objects]
  | | o- nvme0n1 ............................................................ [/dev/nvme0n1, in use]
  | | o- nvme1n1 ............................................................ [/dev/nvme1n1, in use]
  | | o- nvme2n1 ............................................................ [/dev/nvme2n1, in use]
  | o- pscsi .................................................................... [0 Storage Object]
  | o- rd_mcp ................................................................... [1 Storage Object]
  |   o- ramdisk ...................................................... [16.0G, ramdisk, not in use]
  o- qla2xxx ........................................................................... [2 Targets]
  | o- 21:00:00:24:ff:48:97:7e ........................................................... [enabled]
  | | o- acls .............................................................................. [1 ACL]
  | | | o- 21:00:00:24:ff:48:97:7c ................................................. [3 Mapped LUNs]
  | | |   o- mapped_lun0 ............................................................... [lun0 (rw)]
  | | |   o- mapped_lun1 ............................................................... [lun1 (rw)]
  | | |   o- mapped_lun2 ............................................................... [lun2 (rw)]
  | | o- luns ............................................................................. [3 LUNs]
  | |   o- lun0 .................................................... [iblock/nvme0n1 (/dev/nvme0n1)]
  | |   o- lun1 .................................................... [iblock/nvme1n1 (/dev/nvme1n1)]
  | |   o- lun2 .................................................... [iblock/nvme2n1 (/dev/nvme2n1)]
  | o- 21:00:00:24:ff:48:97:7f ........................................................... [enabled]
  |   o- acls .............................................................................. [1 ACL]
  |   | o- 21:00:00:24:ff:48:97:7d ................................................. [3 Mapped LUNs]
  |   |   o- mapped_lun0 ............................................................... [lun0 (rw)]
  |   |   o- mapped_lun1 ............................................................... [lun1 (rw)]
  |   |   o- mapped_lun2 ............................................................... [lun2 (rw)]
  |   o- luns ............................................................................. [3 LUNs]
  |     o- lun0 .................................................... [iblock/nvme0n1 (/dev/nvme0n1)]
  |     o- lun1 .................................................... [iblock/nvme1n1 (/dev/nvme1n1)]
  |     o- lun2 .................................................... [iblock/nvme2n1 (/dev/nvme2n1)]

Attached is the fio write-verify workload for reference.

Also, a few changes made to your test script:
 
- Use sg_reset -H (-h is help :) for host reset op
- Wait sleep 10 between calls instead of 2 mins
- Limit sg_reset SCSI device list to 3x remote-ports

The last one is to verify with various sg_reset ops across remote-ports
only, separate from any existing active I/O session disconnect bugs that
may exist beyond this specific PATCH-v4 series.

To that end, after verifying tonight with 100x iterations of your script
with the above changes, fio write-verify is still functioning as
expected with remote-port only sg_reset ops using NVMe/IBLOCK backends.

So that said, I'll be pushing what's in target-pending/master as -rc4
code, and continue to debug the hung task as a separate active I/O
shutdown related issue.

Thanks again for your help,

--nab

--=-xj4rrDgftrobsiQFQTef
Content-Disposition: attachment; filename="fio-nvme.txt"
Content-Type: text/plain; name="fio-nvme.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[global]
thread=1
blocksize_range=4k-256k
direct=1
ioengine=libaio
verify=crc32c-intel
verify_interval=512
iodepth=32
size=1000G
loops=100
numjobs=1
invalidate=0
filename=/dev/sdb
filename=/dev/sdc
filename=/dev/sdd

[verify]
rw=randrw
do_verify=1

--=-xj4rrDgftrobsiQFQTef--
