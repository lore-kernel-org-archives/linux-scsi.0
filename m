From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: crash in pscsi_get_device_type
Date: Fri, 27 Feb 2015 03:52:19 -0800
Message-ID: <1425037939.30824.89.camel@haakon3.risingtidesystems.com>
References: <20150226092604.GA1119@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150226092604.GA1119@aepfle.de>
Sender: target-devel-owner@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Olaf,

Thanks for your detailed bug report.  Comments below.

On Thu, 2015-02-26 at 10:26 +0100, Olaf Hering wrote:
> While attempting to understand the Xen scsi backend driver I got this
> crash using the script shown below:
> 
> ....
> [  145.495887] Rounding down aligned max_sectors from 4294967295 to 4294967288
> [  145.554864] Unable to load target_core_user
> [  145.661446] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
> [  145.661468] IP: [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
> [  145.661475] PGD 64121a067 PUD 6427e1067 PMD 0 
> [  145.661479] Oops: 0000 [#1] SMP 
> [  145.661482] Modules linked in: target_core_pscsi target_core_file target_core_iblock xen_scsiback target_core_mod bridge stp llc loop ipv6 usb_storage tpm_tis i2c_i801 joydev tpm xen_blkfront xen_netfront mptsas mptscsih mptbase scsi_transport_sas
> [  145.661503] CPU: 6 PID: 5930 Comm: cat Not tainted 3.19.0-1.olh.4-kernel-linux-3_19 #1
> [  145.661507] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
> [  145.661512] task: ffff88063b8f0760 ti: ffff88063d740000 task.ti: ffff88063d740000
> [  145.661515] RIP: e030:[<ffffffffa024f17b>]  [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
> [  145.661521] RSP: e02b:ffff88063d743e48  EFLAGS: 00010292
> [  145.661524] RAX: 0000000000000000 RBX: ffff8800080b9000 RCX: ffff88000809a5a8
> [  145.661527] RDX: ffff8800080b9000 RSI: ffff8800080b9000 RDI: ffff88000809a000
> [  145.661530] RBP: ffff88063d743e48 R08: ffffffffa01fd390 R09: 0000000000000000
> [  145.661533] R10: 0000000000000000 R11: 0000000000000100 R12: ffff880641e7b1e0
> [  145.661536] R13: ffffffffa020ed40 R14: ffffffffa020fc20 R15: ffff88000809a6f8
> [  145.661543] FS:  00007f8e447a5700(0000) GS:ffff88064b780000(0000) knlGS:0000000000000000
> [  145.661546] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  145.661549] CR2: 00000000000000a8 CR3: 000000063d753000 CR4: 0000000000002660
> [  145.661552] Stack:
> [  145.661554]  ffff88063d743e68 ffffffffa01fd3b0 ffff88063d743e68 fffffffffffffff4
> [  145.661559]  ffff88063d743e78 ffffffffa01fcd48 ffff88063d743ed8 ffffffff811a90a5
> [  145.661563]  000000002c495760 ffff88063d743f48 0000000000008000 000000000060d000
> [  145.661568] Call Trace:
> [  145.661579]  [<ffffffffa01fd3b0>] target_stat_scsi_lu_show_attr_dev_type+0x20/0x50 [target_core_mod]
> [  145.661586]  [<ffffffffa01fcd48>] target_stat_scsi_lu_attr_show+0x28/0x30 [target_core_mod]
> [  145.661593]  [<ffffffff811a90a5>] configfs_read_file+0x75/0x110
> [  145.661598]  [<ffffffff8113b3d3>] __vfs_read+0x13/0x60
> [  145.661602]  [<ffffffff8113cd4e>] vfs_read+0xae/0x120
> [  145.661606]  [<ffffffff8113cec4>] SyS_read+0x54/0xb0
> [  145.661611]  [<ffffffff81778f29>] system_call_fastpath+0x12/0x17
> [  145.661614] Code: 0f 84 22 ff ff ff 80 fa 2a 0f 1f 80 00 00 00 00 0f 85 16 ff ff ff 66 90 e9 0b ff ff ff 0f 1f 00 48 8b 87 90 0e 00 00 55 48 89 e5 <0f> be 80 a8 00 00 00 c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 
> [  145.661648] RIP  [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
> [  145.661653]  RSP <ffff88063d743e48>
> [  145.661655] CR2: 00000000000000a8
> [  145.661658] ---[ end trace 73b5dd612a58996d ]---
> ....
> 
> root@satriani:~ # : bash -xv t.sh /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0\:0
> #!/bin/bash
> # usage:
> # mkpvscsi device
> # e.g. mkpvscsi /dev/sr0
> unset LANG
> + unset LANG
> unset ${!LC_*}
> + unset LC_COLLATE
> DEV=$1
> + DEV=/dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
> 
> gen_uuid()
> {
>         cat /proc/sys/kernel/random/uuid | \
>         awk '{print "naa.6001405" substr($1,1,8) substr($1,10,1);}'
> }
> 
> 
> stat_dev()
> {
> 	local type=$1
> 	local d=$2
> 	local mm
> 	local path
> 
> 	mm=$(( `stat -L -c 0x%t "$d"` )):$(( `stat -L -c 0x%T "$d"` ))
> 	if test -z "$mm"
> 	then
> 		exit 1
> 	fi
> 	path=`set -e ; cd /sys/dev/$type/$mm/device/scsi_device ; ls -d *:*:*:*`
> 	if test -z "$path"
> 	then
> 		exit 1
> 	fi
> 	NODE=$path
> }
> 
> if test -c "$DEV"
> then
> 	stat_dev char "$DEV"
> elif test -b "$DEV"
> then
> 	stat_dev block "$DEV"
> else
> 	exit 1
> fi
> + test -c /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
> + test -b /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
> + stat_dev block /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
> + local type=block
> + local d=/dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
> + local mm
> + local path
> stat -L -c 0x%t "$d"
> ++ stat -L -c 0x%t /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
> stat -L -c 0x%T "$d"
> ++ stat -L -c 0x%T /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
> + mm=11:0
> + test -z 11:0
> set -e ; cd /sys/dev/$type/$mm/device/scsi_device ; ls -d *:*:*:*
> ++ set -e
> ++ cd /sys/dev/block/11:0/device/scsi_device
> ++ ls -d 7:0:0:0
> + path=7:0:0:0
> + test -z 7:0:0:0
> + NODE=7:0:0:0
> 
> TARG=`gen_uuid`
> gen_uuid
> ++ gen_uuid
> ++ cat /proc/sys/kernel/random/uuid
> ++ awk '{print "naa.6001405" substr($1,1,8) substr($1,10,1);}'
> + TARG=naa.600140595883158a
> INIT=`gen_uuid`
> gen_uuid
> ++ gen_uuid
> ++ cat /proc/sys/kernel/random/uuid
> ++ awk '{print "naa.6001405" substr($1,1,8) substr($1,10,1);}'
> + INIT=naa.600140555b779033
> NAME=`echo $NODE | sed 's/:/_/g'`
> echo $NODE | sed 's/:/_/g'
> ++ echo 7:0:0:0
> ++ sed s/:/_/g
> + NAME=7_0_0_0
> 
> modprobe configfs
> + modprobe configfs
> mount -t configfs configfs /sys/kernel/config
> + mount -t configfs configfs /sys/kernel/config
> modprobe xen-scsiback
> + modprobe xen-scsiback
> modprobe target_core_mod
> + modprobe target_core_mod
> cd /sys/kernel/config/target
> + cd /sys/kernel/config/target
> ls -lA
> + ls -lA
> total 0
> drwxr-xr-x 3 root root    0 Feb 26 10:17 core
> -r--r--r-- 1 root root 4096 Feb 26 10:17 version
> find -ls
> + find -ls
>  13063    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 .
>  13064    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core
>  13065    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/alua
>  13066    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/alua/lu_gps
>  13067    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp
>  13801    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp/members
>  13802    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp/lu_gp_id
>  13803    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./version
> find -type f -print0 | sort -z | xargs -0 head
> + find -type f -print0
> + sort -z
> + xargs -0 head
> ==> ./core/alua/lu_gps/default_lu_gp/lu_gp_id <==
> 0
> 
> ==> ./core/alua/lu_gps/default_lu_gp/members <==
> 
> ==> ./version <==
> Target Engine Core ConfigFS Infrastructure v4.1.0 on Linux/x86_64 on 3.19.0-1.olh.4-kernel-linux-3_19
> 
> mkdir -p core/pscsi_0/$NAME
> + mkdir -p core/pscsi_0/7_0_0_0
> echo "$DEV" >core/pscsi_0/$NAME/udev_path
> + echo /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
> mkdir -p xen-pvscsi/$TARG/tpgt_0
> + mkdir -p xen-pvscsi/naa.600140595883158a/tpgt_0
> echo "${NODE%:*}" >xen-pvscsi/$TARG/tpgt_0/param/alias
> + echo 7:0:0
> echo $INIT >xen-pvscsi/$TARG/tpgt_0/nexus
> + echo naa.600140555b779033
> mkdir xen-pvscsi/$TARG/tpgt_0/lun/lun_0
> + mkdir xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0
> ln -s ../../../../../../target/core/pscsi_0/$NAME xen-pvscsi/$TARG/tpgt_0/lun/lun_0/xen-pvscsi_port
> + ln -s ../../../../../../target/core/pscsi_0/7_0_0_0 xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/xen-pvscsi_port
> ln: failed to create symbolic link `xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/xen-pvscsi_port': No such file or directory
> find -ls
> + find -ls
>  13063    0 drwxr-xr-x   4 root     root            0 Feb 26 10:17 .
>  16178    0 drwxr-xr-x   4 root     root            0 Feb 26 10:17 ./xen-pvscsi
>  16180    0 drwxr-xr-x   4 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a
>  16182    0 drwxr-xr-x   8 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0
>  16188    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/param
>  13808    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/param/alias
>  16187    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/auth
>  16186    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/attrib
>  16185    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/acls
>  16184    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/np
>  16183    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun
>  17105    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0
>  17106    0 drwxr-xr-x   5 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics
>  17109    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport
>  13809    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport/dev_name
>  13810    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport/indx
>  13811    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport/device
>  13812    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport/inst
>  17108    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port
>  13813    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/hs_in_cmds
>  13814    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/read_mbytes
>  13815    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/write_mbytes
>  13816    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/in_cmds
>  13817    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/port_index
>  13818    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/name
>  13819    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/indx
>  13820    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/dev
>  13821    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/inst
>  17107    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port
>  13822    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/busy_count
>  13823    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/role
>  13824    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/indx
>  13825    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/dev
>  13826    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/inst
>  13827    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/alua_tg_pt_write_md
>  13828    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/alua_tg_pt_status
>  13829    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/alua_tg_pt_offline
>  13830    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/alua_tg_pt_gp
>  13831    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/nexus
>  16181    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/fabric_statistics
>  16179    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/discovery_auth
>  13832    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/version
>  13064    0 drwxr-xr-x   4 root     root            0 Feb 26 10:17 ./core
>  13070    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/pscsi_0
>  13071    0 drwxr-xr-x   7 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0
>  13077    0 drwxr-xr-x   5 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics
>  13080    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu
>  13833    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/creation_time
>  13834    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/hs_num_cmds
>  13835    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/full_stat
>  13836    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/resets
>  13837    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/write_mbytes
>  13838    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/read_mbytes
>  13839    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/num_cmds
>  13840    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/state_bit
>  13841    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/status
>  13842    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/dev_type
>  13843    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/rev
>  13844    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/prod
>  13845    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/vend
>  13846    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/lu_name
>  13847    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/lun
>  13848    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/indx
>  13849    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/dev
>  13850    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/inst
>  13079    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev
>  13851    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/resets
>  13852    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/non_access_lus
>  13853    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/status
>  13854    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/num_lus
>  13855    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/indx
>  13856    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/inst
>  13078    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev
>  13857    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/ports
>  13858    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/role
>  13859    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/indx
>  13860    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/inst
>  13075    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua
>  13076    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp
>  13861    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/members
>  13862    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/tg_pt_gp_id
>  13863    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/preferred
>  13864    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/implicit_trans_secs
>  13865    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/trans_delay_msecs
>  13866    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/nonop_delay_msecs
>  13867    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_write_metadata
>  13868    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_active_optimized
>  13869    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_active_nonoptimized
>  13870    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_standby
>  13871    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_unavailable
>  13872    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_lba_dependent
>  13873    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_offline
>  13874    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_transitioning
>  13875    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_type
>  13876    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_status
>  13877    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_state
>  13074    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn
>  13878    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_assoc_scsi_target_device
>  13879    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_assoc_target_port
>  13880    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_assoc_logical_unit
>  13881    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_protocol_identifier
>  13882    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_unit_serial
>  13073    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr
>  13883    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_aptpl_metadata
>  13884    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_aptpl_active
>  13885    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_type
>  13886    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_type
>  13887    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_registered_i_pts
>  13888    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_holder_tg_port
>  13889    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_generation
>  13890    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_all_tgt_pts
>  13891    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_holder
>  13072    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib
>  13892    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib/hw_queue_depth
>  13893    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib/hw_max_sectors
>  13894    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib/hw_block_size
>  13895    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib/hw_pi_prot_type
>  13896    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/lba_map
>  13897    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua_lu_gp
>  13898    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/enable
>  13899    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/udev_path
>  13900    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alias
>  13901    0 --w-------   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/control
>  13902    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/info
>  13903    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/hba_mode
>  13904    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/hba_info
>  13065    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/alua
>  13066    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/alua/lu_gps
>  13067    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp
>  13905    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp/members
>  13906    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp/lu_gp_id
>  13907    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./version
> find -type f -print0 | sort -z | xargs -0n1 --verbose cat
> + find -type f -print0
> + sort -z
> + xargs -0n1 --verbose cat
> cat ./core/alua/lu_gps/default_lu_gp/lu_gp_id 
> 0
> cat ./core/alua/lu_gps/default_lu_gp/members 
> cat ./core/pscsi_0/7_0_0_0/alias 
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_state 
> 0
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_status 
> None
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_type 
> Implicit and Explicit
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_active_nonoptimized 
> 1
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_active_optimized 
> 1
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_lba_dependent 
> 0
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_offline 
> 1
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_standby 
> 1
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_transitioning 
> 1
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_unavailable 
> 1
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_write_metadata 
> 0
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/implicit_trans_secs 
> 0
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/members 
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/nonop_delay_msecs 
> 100
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/preferred 
> 0
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/tg_pt_gp_id 
> 0
> cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/trans_delay_msecs 
> 0
> cat ./core/pscsi_0/7_0_0_0/alua_lu_gp 
> cat ./core/pscsi_0/7_0_0_0/attrib/hw_block_size 
> 0
> cat ./core/pscsi_0/7_0_0_0/attrib/hw_max_sectors 
> 0
> cat ./core/pscsi_0/7_0_0_0/attrib/hw_pi_prot_type 
> 0
> cat ./core/pscsi_0/7_0_0_0/attrib/hw_queue_depth 
> 0
> cat ./core/pscsi_0/7_0_0_0/control 
> cat: ./core/pscsi_0/7_0_0_0/control: Permission denied
> cat ./core/pscsi_0/7_0_0_0/enable 
> 0
> cat ./core/pscsi_0/7_0_0_0/info 
> Status: DEACTIVATED  Max Queue Depth: 0  SectorSize: 0  HwMaxSectors: 0
>         SCSI Device Bus Location: Channel ID: 0 Target ID: 0 LUN: 0 Host ID: 0
> cat ./core/pscsi_0/7_0_0_0/lba_map 
> cat ./core/pscsi_0/7_0_0_0/pr/res_aptpl_active 
> cat ./core/pscsi_0/7_0_0_0/pr/res_aptpl_metadata 
> cat ./core/pscsi_0/7_0_0_0/pr/res_holder 
> Passthrough
> cat ./core/pscsi_0/7_0_0_0/pr/res_pr_all_tgt_pts 
> No SPC-3 Reservation holder
> cat ./core/pscsi_0/7_0_0_0/pr/res_pr_generation 
> 0x00000000
> cat ./core/pscsi_0/7_0_0_0/pr/res_pr_holder_tg_port 
> No SPC-3 Reservation holder
> cat ./core/pscsi_0/7_0_0_0/pr/res_pr_registered_i_pts 
> SPC-3 PR Registrations:
> None
> cat ./core/pscsi_0/7_0_0_0/pr/res_pr_type 
> No SPC-3 Reservation holder
> cat ./core/pscsi_0/7_0_0_0/pr/res_type 
> SPC_PASSTHROUGH
> cat ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/indx 
> 0
> cat ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/inst 
> 2
> cat ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/ports 
> 0
> cat ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/role 
> Target
> cat ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/creation_time 
> 3367284360
> cat ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/dev 
> 0
> cat ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/dev_type 
> xargs: cat: terminated by signal 9

Looks like a PSCSI specific NULL pointer dereference when reading the
dev_type attribute if a backend device was not able to be successfully
configured -> enabled.

Here's a quick patch to address this case.  Please confirm on your end.

Thanks for reporting!

--nab

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 1045dcd..f6c954c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1121,7 +1121,7 @@ static u32 pscsi_get_device_type(struct se_device *dev)
        struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
        struct scsi_device *sd = pdv->pdv_sd;
 
-       return sd->type;
+       return (sd) ? sd->type : TYPE_NO_LUN;
 }
 
 static sector_t pscsi_get_blocks(struct se_device *dev)
