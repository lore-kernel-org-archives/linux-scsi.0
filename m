From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: xfs rm performance
Date: Mon, 02 Aug 2010 23:03:00 +0400
Message-ID: <4C571664.7030107@vlnb.net>
References: <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org> <4C52CBFF.6090406@vlnb.net> <20100730130957.GA26894@lst.de> <4C52D2E0.5000609@vlnb.net> <20100730133410.GA27996@lst.de> <4C52D728.6070008@vlnb.net> <20100730142025.GA29341@lst.de> <20100731004756.GC3273@quack.suse.cz> <4C56A01A.1050107@vlnb.net> <20100802124830.GB22345@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100802124830.GB22345@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

This is somehow related to the discussion, so I think it would be relevant if I send here some my observations.

One of the tests I use to verify performance of SCST is io_trash utility. This utility emulates DB-like access. For more details see http://lkml.org/lkml/2008/11/17/444.

Particularly, I'm running io_trash with the following parameters: "2 2 ./ 500000000 50000000 10  4096 4096 300000 10 90 0 10" over a 5GB XFS iSCSI drive. Backend for this drive is a 5GB file on a 15RPM Wide SCSI HDD. Initiator has 256MB of memory, the target - 2GB. Kernel on the initiator - Ubuntu 2.6.32-22-386.

In this mode io_trash creates sparse files and fill them in a transactional DB-like manner. After it finished it leaves 4 files:

# ls -l
total 1448548
-rw-r--r-- 1 root root 2048000000000 2010-08-03 01:13 _0.db
-rw-r--r-- 1 root root     124596224 2010-08-03 01:13 _0.jnl
-rw-r--r-- 1 root root 2048000000000 2010-08-03 01:13 _1.db
-rw-r--r-- 1 root root     124592128 2010-08-03 01:13 _1.jnl
-rwxr-xr-x 1 root root         24141 2008-11-19 19:29 io_thrash

The problem is:

# time rm _*

real	4m3.769s
user	0m0.000s
sys	0m25.594s

4(!) minutes to delete 4 files! For comparison, ext4 does it in few seconds.

I traced what XFS is doing that time. The initiator is sending by a _single command at time_ the following pattern:

kernel: [12703.146464] [4021]: scst_cmd_init_done:286:Receiving CDB:
kernel: [12703.146477]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
kernel: [12703.146490]    0: 2a 00 00 09 cc ee 00 00 08 00 00 00 00 00 00 00   *...............
kernel: [12703.146513] [4021]: scst: scst_parse_cmd:601:op_name <WRITE(10)> (cmd d6b4a000), direction=1 (expected 1, set yes), bufflen=32768, out_bufflen=0, (expected len 32768, out expected len 0), flags=111
kernel: [12703.148201] [4112]: scst: scst_cmd_done_local:1598:cmd d6b4a000, status 0, msg_status 0, host_status 0, driver_status 0, resp_data_len 0
kernel: [12703.149195] [4021]: scst: scst_cmd_init_done:284:tag=112, lun=0, CDB len=16, queue_type=1 (cmd d6b4a000)
kernel: [12703.149216] [4021]: scst_cmd_init_done:286:Receiving CDB:
kernel: [12703.149228]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
kernel: [12703.149242]    0: 2a 00 00 09 cc f6 00 00 08 00 00 00 00 00 00 00   *...............
kernel: [12703.149266] [4021]: scst: scst_parse_cmd:601:op_name <WRITE(10)> (cmd d6b4a000), direction=1 (expected 1, set yes), bufflen=32768, out_bufflen=0, (expected len 32768, out expected len 0), flags=111
kernel: [12703.150852] [4112]: scst: scst_cmd_done_local:1598:cmd d6b4a000, status 0, msg_status 0, host_status 0, driver_status 0, resp_data_len 0
kernel: [12703.151887] [4021]: scst: scst_cmd_init_done:284:tag=12, lun=0, CDB len=16, queue_type=1 (cmd d6b4a000)
kernel: [12703.151908] [4021]: scst_cmd_init_done:286:Receiving CDB:
kernel: [12703.151920]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
kernel: [12703.151934]    0: 2a 00 00 09 cc fe 00 00 08 00 00 00 00 00 00 00   *...............
kernel: [12703.151955] [4021]: scst: scst_parse_cmd:601:op_name <WRITE(10)> (cmd d6b4a000), direction=1 (expected 1, set yes), bufflen=32768, out_bufflen=0, (expected len 32768, out expected len 0), flags=111
kernel: [12703.153622] [4112]: scst: scst_cmd_done_local:1598:cmd d6b4a000, status 0, msg_status 0, host_status 0, driver_status 0, resp_data_len 0
kernel: [12703.154655] [4021]: scst: scst_cmd_init_done:284:tag=15, lun=0, CDB len=16, queue_type=1 (cmd d6b4a000)

"Scst_cmd_init_done" means new coming command, "scst_cmd_done_local" means it's finished. See the 1ms gap between previous command finished and new came. You can see that if XFS was sending many commands at time, it would finish the job several (5-10) times faster.

Is it possible to improve that and make XFS fully fill the device's queue during rm'ing?

Thanks,
Vlad
