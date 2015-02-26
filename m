From: Olaf Hering <olaf@aepfle.de>
Subject: crash in pscsi_get_device_type
Date: Thu, 26 Feb 2015 10:26:04 +0100
Message-ID: <20150226092604.GA1119@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


While attempting to understand the Xen scsi backend driver I got this
crash using the script shown below:

....
[  145.495887] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  145.554864] Unable to load target_core_user
[  145.661446] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
[  145.661468] IP: [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
[  145.661475] PGD 64121a067 PUD 6427e1067 PMD 0 
[  145.661479] Oops: 0000 [#1] SMP 
[  145.661482] Modules linked in: target_core_pscsi target_core_file target_core_iblock xen_scsiback target_core_mod bridge stp llc loop ipv6 usb_storage tpm_tis i2c_i801 joydev tpm xen_blkfront xen_netfront mptsas mptscsih mptbase scsi_transport_sas
[  145.661503] CPU: 6 PID: 5930 Comm: cat Not tainted 3.19.0-1.olh.4-kernel-linux-3_19 #1
[  145.661507] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
[  145.661512] task: ffff88063b8f0760 ti: ffff88063d740000 task.ti: ffff88063d740000
[  145.661515] RIP: e030:[<ffffffffa024f17b>]  [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
[  145.661521] RSP: e02b:ffff88063d743e48  EFLAGS: 00010292
[  145.661524] RAX: 0000000000000000 RBX: ffff8800080b9000 RCX: ffff88000809a5a8
[  145.661527] RDX: ffff8800080b9000 RSI: ffff8800080b9000 RDI: ffff88000809a000
[  145.661530] RBP: ffff88063d743e48 R08: ffffffffa01fd390 R09: 0000000000000000
[  145.661533] R10: 0000000000000000 R11: 0000000000000100 R12: ffff880641e7b1e0
[  145.661536] R13: ffffffffa020ed40 R14: ffffffffa020fc20 R15: ffff88000809a6f8
[  145.661543] FS:  00007f8e447a5700(0000) GS:ffff88064b780000(0000) knlGS:0000000000000000
[  145.661546] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  145.661549] CR2: 00000000000000a8 CR3: 000000063d753000 CR4: 0000000000002660
[  145.661552] Stack:
[  145.661554]  ffff88063d743e68 ffffffffa01fd3b0 ffff88063d743e68 fffffffffffffff4
[  145.661559]  ffff88063d743e78 ffffffffa01fcd48 ffff88063d743ed8 ffffffff811a90a5
[  145.661563]  000000002c495760 ffff88063d743f48 0000000000008000 000000000060d000
[  145.661568] Call Trace:
[  145.661579]  [<ffffffffa01fd3b0>] target_stat_scsi_lu_show_attr_dev_type+0x20/0x50 [target_core_mod]
[  145.661586]  [<ffffffffa01fcd48>] target_stat_scsi_lu_attr_show+0x28/0x30 [target_core_mod]
[  145.661593]  [<ffffffff811a90a5>] configfs_read_file+0x75/0x110
[  145.661598]  [<ffffffff8113b3d3>] __vfs_read+0x13/0x60
[  145.661602]  [<ffffffff8113cd4e>] vfs_read+0xae/0x120
[  145.661606]  [<ffffffff8113cec4>] SyS_read+0x54/0xb0
[  145.661611]  [<ffffffff81778f29>] system_call_fastpath+0x12/0x17
[  145.661614] Code: 0f 84 22 ff ff ff 80 fa 2a 0f 1f 80 00 00 00 00 0f 85 16 ff ff ff 66 90 e9 0b ff ff ff 0f 1f 00 48 8b 87 90 0e 00 00 55 48 89 e5 <0f> be 80 a8 00 00 00 c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 
[  145.661648] RIP  [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
[  145.661653]  RSP <ffff88063d743e48>
[  145.661655] CR2: 00000000000000a8
[  145.661658] ---[ end trace 73b5dd612a58996d ]---
....

root@satriani:~ # : bash -xv t.sh /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0\:0
#!/bin/bash
# usage:
# mkpvscsi device
# e.g. mkpvscsi /dev/sr0
unset LANG
+ unset LANG
unset ${!LC_*}
+ unset LC_COLLATE
DEV=$1
+ DEV=/dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0

gen_uuid()
{
        cat /proc/sys/kernel/random/uuid | \
        awk '{print "naa.6001405" substr($1,1,8) substr($1,10,1);}'
}


stat_dev()
{
	local type=$1
	local d=$2
	local mm
	local path

	mm=$(( `stat -L -c 0x%t "$d"` )):$(( `stat -L -c 0x%T "$d"` ))
	if test -z "$mm"
	then
		exit 1
	fi
	path=`set -e ; cd /sys/dev/$type/$mm/device/scsi_device ; ls -d *:*:*:*`
	if test -z "$path"
	then
		exit 1
	fi
	NODE=$path
}

if test -c "$DEV"
then
	stat_dev char "$DEV"
elif test -b "$DEV"
then
	stat_dev block "$DEV"
else
	exit 1
fi
+ test -c /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
+ test -b /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
+ stat_dev block /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
+ local type=block
+ local d=/dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
+ local mm
+ local path
stat -L -c 0x%t "$d"
++ stat -L -c 0x%t /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
stat -L -c 0x%T "$d"
++ stat -L -c 0x%T /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
+ mm=11:0
+ test -z 11:0
set -e ; cd /sys/dev/$type/$mm/device/scsi_device ; ls -d *:*:*:*
++ set -e
++ cd /sys/dev/block/11:0/device/scsi_device
++ ls -d 7:0:0:0
+ path=7:0:0:0
+ test -z 7:0:0:0
+ NODE=7:0:0:0

TARG=`gen_uuid`
gen_uuid
++ gen_uuid
++ cat /proc/sys/kernel/random/uuid
++ awk '{print "naa.6001405" substr($1,1,8) substr($1,10,1);}'
+ TARG=naa.600140595883158a
INIT=`gen_uuid`
gen_uuid
++ gen_uuid
++ cat /proc/sys/kernel/random/uuid
++ awk '{print "naa.6001405" substr($1,1,8) substr($1,10,1);}'
+ INIT=naa.600140555b779033
NAME=`echo $NODE | sed 's/:/_/g'`
echo $NODE | sed 's/:/_/g'
++ echo 7:0:0:0
++ sed s/:/_/g
+ NAME=7_0_0_0

modprobe configfs
+ modprobe configfs
mount -t configfs configfs /sys/kernel/config
+ mount -t configfs configfs /sys/kernel/config
modprobe xen-scsiback
+ modprobe xen-scsiback
modprobe target_core_mod
+ modprobe target_core_mod
cd /sys/kernel/config/target
+ cd /sys/kernel/config/target
ls -lA
+ ls -lA
total 0
drwxr-xr-x 3 root root    0 Feb 26 10:17 core
-r--r--r-- 1 root root 4096 Feb 26 10:17 version
find -ls
+ find -ls
 13063    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 .
 13064    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core
 13065    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/alua
 13066    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/alua/lu_gps
 13067    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp
 13801    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp/members
 13802    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp/lu_gp_id
 13803    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./version
find -type f -print0 | sort -z | xargs -0 head
+ find -type f -print0
+ sort -z
+ xargs -0 head
==> ./core/alua/lu_gps/default_lu_gp/lu_gp_id <==
0

==> ./core/alua/lu_gps/default_lu_gp/members <==

==> ./version <==
Target Engine Core ConfigFS Infrastructure v4.1.0 on Linux/x86_64 on 3.19.0-1.olh.4-kernel-linux-3_19

mkdir -p core/pscsi_0/$NAME
+ mkdir -p core/pscsi_0/7_0_0_0
echo "$DEV" >core/pscsi_0/$NAME/udev_path
+ echo /dev/disk/by-id/usb-TEAC_DV-W28S-V_000000000033-0:0
mkdir -p xen-pvscsi/$TARG/tpgt_0
+ mkdir -p xen-pvscsi/naa.600140595883158a/tpgt_0
echo "${NODE%:*}" >xen-pvscsi/$TARG/tpgt_0/param/alias
+ echo 7:0:0
echo $INIT >xen-pvscsi/$TARG/tpgt_0/nexus
+ echo naa.600140555b779033
mkdir xen-pvscsi/$TARG/tpgt_0/lun/lun_0
+ mkdir xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0
ln -s ../../../../../../target/core/pscsi_0/$NAME xen-pvscsi/$TARG/tpgt_0/lun/lun_0/xen-pvscsi_port
+ ln -s ../../../../../../target/core/pscsi_0/7_0_0_0 xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/xen-pvscsi_port
ln: failed to create symbolic link `xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/xen-pvscsi_port': No such file or directory
find -ls
+ find -ls
 13063    0 drwxr-xr-x   4 root     root            0 Feb 26 10:17 .
 16178    0 drwxr-xr-x   4 root     root            0 Feb 26 10:17 ./xen-pvscsi
 16180    0 drwxr-xr-x   4 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a
 16182    0 drwxr-xr-x   8 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0
 16188    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/param
 13808    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/param/alias
 16187    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/auth
 16186    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/attrib
 16185    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/acls
 16184    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/np
 16183    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun
 17105    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0
 17106    0 drwxr-xr-x   5 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics
 17109    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport
 13809    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport/dev_name
 13810    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport/indx
 13811    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport/device
 13812    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_transport/inst
 17108    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port
 13813    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/hs_in_cmds
 13814    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/read_mbytes
 13815    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/write_mbytes
 13816    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/in_cmds
 13817    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/port_index
 13818    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/name
 13819    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/indx
 13820    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/dev
 13821    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_tgt_port/inst
 17107    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port
 13822    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/busy_count
 13823    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/role
 13824    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/indx
 13825    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/dev
 13826    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/statistics/scsi_port/inst
 13827    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/alua_tg_pt_write_md
 13828    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/alua_tg_pt_status
 13829    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/alua_tg_pt_offline
 13830    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/lun/lun_0/alua_tg_pt_gp
 13831    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/tpgt_0/nexus
 16181    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/naa.600140595883158a/fabric_statistics
 16179    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./xen-pvscsi/discovery_auth
 13832    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./xen-pvscsi/version
 13064    0 drwxr-xr-x   4 root     root            0 Feb 26 10:17 ./core
 13070    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/pscsi_0
 13071    0 drwxr-xr-x   7 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0
 13077    0 drwxr-xr-x   5 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics
 13080    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu
 13833    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/creation_time
 13834    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/hs_num_cmds
 13835    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/full_stat
 13836    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/resets
 13837    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/write_mbytes
 13838    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/read_mbytes
 13839    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/num_cmds
 13840    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/state_bit
 13841    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/status
 13842    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/dev_type
 13843    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/rev
 13844    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/prod
 13845    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/vend
 13846    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/lu_name
 13847    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/lun
 13848    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/indx
 13849    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/dev
 13850    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/inst
 13079    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev
 13851    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/resets
 13852    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/non_access_lus
 13853    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/status
 13854    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/num_lus
 13855    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/indx
 13856    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_tgt_dev/inst
 13078    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev
 13857    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/ports
 13858    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/role
 13859    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/indx
 13860    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/inst
 13075    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua
 13076    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp
 13861    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/members
 13862    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/tg_pt_gp_id
 13863    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/preferred
 13864    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/implicit_trans_secs
 13865    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/trans_delay_msecs
 13866    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/nonop_delay_msecs
 13867    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_write_metadata
 13868    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_active_optimized
 13869    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_active_nonoptimized
 13870    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_standby
 13871    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_unavailable
 13872    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_lba_dependent
 13873    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_offline
 13874    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_transitioning
 13875    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_type
 13876    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_status
 13877    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_state
 13074    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn
 13878    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_assoc_scsi_target_device
 13879    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_assoc_target_port
 13880    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_assoc_logical_unit
 13881    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_protocol_identifier
 13882    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/wwn/vpd_unit_serial
 13073    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr
 13883    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_aptpl_metadata
 13884    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_aptpl_active
 13885    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_type
 13886    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_type
 13887    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_registered_i_pts
 13888    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_holder_tg_port
 13889    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_generation
 13890    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_pr_all_tgt_pts
 13891    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/pr/res_holder
 13072    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib
 13892    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib/hw_queue_depth
 13893    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib/hw_max_sectors
 13894    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib/hw_block_size
 13895    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/attrib/hw_pi_prot_type
 13896    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/lba_map
 13897    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alua_lu_gp
 13898    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/enable
 13899    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/udev_path
 13900    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/alias
 13901    0 --w-------   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/control
 13902    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/7_0_0_0/info
 13903    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/hba_mode
 13904    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/pscsi_0/hba_info
 13065    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/alua
 13066    0 drwxr-xr-x   3 root     root            0 Feb 26 10:17 ./core/alua/lu_gps
 13067    0 drwxr-xr-x   2 root     root            0 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp
 13905    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp/members
 13906    0 -rw-r--r--   1 root     root         4096 Feb 26 10:17 ./core/alua/lu_gps/default_lu_gp/lu_gp_id
 13907    0 -r--r--r--   1 root     root         4096 Feb 26 10:17 ./version
find -type f -print0 | sort -z | xargs -0n1 --verbose cat
+ find -type f -print0
+ sort -z
+ xargs -0n1 --verbose cat
cat ./core/alua/lu_gps/default_lu_gp/lu_gp_id 
0
cat ./core/alua/lu_gps/default_lu_gp/members 
cat ./core/pscsi_0/7_0_0_0/alias 
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_state 
0
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_status 
None
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_access_type 
Implicit and Explicit
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_active_nonoptimized 
1
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_active_optimized 
1
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_lba_dependent 
0
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_offline 
1
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_standby 
1
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_transitioning 
1
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_support_unavailable 
1
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/alua_write_metadata 
0
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/implicit_trans_secs 
0
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/members 
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/nonop_delay_msecs 
100
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/preferred 
0
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/tg_pt_gp_id 
0
cat ./core/pscsi_0/7_0_0_0/alua/default_tg_pt_gp/trans_delay_msecs 
0
cat ./core/pscsi_0/7_0_0_0/alua_lu_gp 
cat ./core/pscsi_0/7_0_0_0/attrib/hw_block_size 
0
cat ./core/pscsi_0/7_0_0_0/attrib/hw_max_sectors 
0
cat ./core/pscsi_0/7_0_0_0/attrib/hw_pi_prot_type 
0
cat ./core/pscsi_0/7_0_0_0/attrib/hw_queue_depth 
0
cat ./core/pscsi_0/7_0_0_0/control 
cat: ./core/pscsi_0/7_0_0_0/control: Permission denied
cat ./core/pscsi_0/7_0_0_0/enable 
0
cat ./core/pscsi_0/7_0_0_0/info 
Status: DEACTIVATED  Max Queue Depth: 0  SectorSize: 0  HwMaxSectors: 0
        SCSI Device Bus Location: Channel ID: 0 Target ID: 0 LUN: 0 Host ID: 0
cat ./core/pscsi_0/7_0_0_0/lba_map 
cat ./core/pscsi_0/7_0_0_0/pr/res_aptpl_active 
cat ./core/pscsi_0/7_0_0_0/pr/res_aptpl_metadata 
cat ./core/pscsi_0/7_0_0_0/pr/res_holder 
Passthrough
cat ./core/pscsi_0/7_0_0_0/pr/res_pr_all_tgt_pts 
No SPC-3 Reservation holder
cat ./core/pscsi_0/7_0_0_0/pr/res_pr_generation 
0x00000000
cat ./core/pscsi_0/7_0_0_0/pr/res_pr_holder_tg_port 
No SPC-3 Reservation holder
cat ./core/pscsi_0/7_0_0_0/pr/res_pr_registered_i_pts 
SPC-3 PR Registrations:
None
cat ./core/pscsi_0/7_0_0_0/pr/res_pr_type 
No SPC-3 Reservation holder
cat ./core/pscsi_0/7_0_0_0/pr/res_type 
SPC_PASSTHROUGH
cat ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/indx 
0
cat ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/inst 
2
cat ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/ports 
0
cat ./core/pscsi_0/7_0_0_0/statistics/scsi_dev/role 
Target
cat ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/creation_time 
3367284360
cat ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/dev 
0
cat ./core/pscsi_0/7_0_0_0/statistics/scsi_lu/dev_type 
xargs: cat: terminated by signal 9
root@satriani:~ # dmesg
[    0.000000] PAT configuration [0-7]: WB  WT  UC- UC  WC  WP  UC  UC  
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.0-1.olh.4-kernel-linux-3_19 (abuild@cloud131) (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP Wed Feb 25 23:17:17 UTC 2015
[    0.000000] Command line: debug panic=9 sysrq_always_enabled showopts log_buf_len=64M console=hvc0
[    0.000000] Released 0 page(s)
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x000000000009afff] usable
[    0.000000] Xen: [mem 0x000000000009b000-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x000000008c21afff] usable
[    0.000000] Xen: [mem 0x000000008c21b000-0x000000008c2edfff] ACPI NVS
[    0.000000] Xen: [mem 0x000000008c2ee000-0x000000008c3defff] ACPI data
[    0.000000] Xen: [mem 0x000000008c3df000-0x000000008d7defff] ACPI NVS
[    0.000000] Xen: [mem 0x000000008d7df000-0x000000008f301fff] ACPI data
[    0.000000] Xen: [mem 0x000000008f302000-0x000000008f34efff] reserved
[    0.000000] Xen: [mem 0x000000008f34f000-0x000000008f3d3fff] ACPI data
[    0.000000] Xen: [mem 0x000000008f3d4000-0x000000008f3ddfff] ACPI NVS
[    0.000000] Xen: [mem 0x000000008f3de000-0x000000008f3e1fff] ACPI data
[    0.000000] Xen: [mem 0x000000008f3e2000-0x000000008f4cefff] ACPI NVS
[    0.000000] Xen: [mem 0x000000008f4cf000-0x000000008f4fffff] ACPI data
[    0.000000] Xen: [mem 0x000000008f500000-0x000000008fffffff] reserved
[    0.000000] Xen: [mem 0x00000000a0000000-0x00000000afffffff] reserved
[    0.000000] Xen: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] Xen: [mem 0x00000000fe710000-0x00000000fe710fff] reserved
[    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] Xen: [mem 0x00000000fec90000-0x00000000fec90fff] reserved
[    0.000000] Xen: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] Xen: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] Xen: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] Xen: [mem 0x0000000100000000-0x000000066fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x670000 max_arch_pfn = 0x400000000
[    0.000000] e820: last_pfn = 0x8c21b max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 28672
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x5d7800000-0x5d79fffff]
[    0.000000]  [mem 0x5d7800000-0x5d79fffff] page 4k
[    0.000000] BRK [0x01ff7000, 0x01ff7fff] PGTABLE
[    0.000000] BRK [0x01ff8000, 0x01ff8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x5c0000000-0x5d77fffff]
[    0.000000]  [mem 0x5c0000000-0x5d77fffff] page 4k
[    0.000000] BRK [0x01ff9000, 0x01ff9fff] PGTABLE
[    0.000000] BRK [0x01ffa000, 0x01ffafff] PGTABLE
[    0.000000] BRK [0x01ffb000, 0x01ffbfff] PGTABLE
[    0.000000] BRK [0x01ffc000, 0x01ffcfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x5a0000000-0x5bfffffff]
[    0.000000]  [mem 0x5a0000000-0x5bfffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x8c21afff]
[    0.000000]  [mem 0x00100000-0x8c21afff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x59fffffff]
[    0.000000]  [mem 0x100000000-0x59fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x5d7a00000-0x66fffffff]
[    0.000000]  [mem 0x5d7a00000-0x66fffffff] page 4k
[    0.000000] log_buf_len: 67108864 bytes
[    0.000000] early log buf free: 2093080(99%)
[    0.000000] RAMDISK: [mem 0x08000000-0x08eacfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x000000008F4FD120 0000A4 (v01 INTEL  S5520UT  00000000      01000013)
[    0.000000] ACPI: FACP 0x000000008F4FB000 0000F4 (v04 INTEL  S5520UT  00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 0x000000008F4F4000 0065E9 (v02 INTEL  S5520UT  00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 0x000000008F3E2000 000040
[    0.000000] ACPI: APIC 0x000000008F4F3000 0001A8 (v02 INTEL  S5520UT  00000000 MSFT 0100000D)
[    0.000000] ACPI: MCFG 0x000000008F4F2000 00003C (v01 INTEL  S5520UT  00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 0x000000008F4F1000 000038 (v01 INTEL  S5520UT  00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 0x000000008F4F0000 000030 (v01 INTEL  S5520UT  00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 0x000000008F4EF000 000430 (v02 INTEL  S5520UT  00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 0x000000008F4EE000 000050 (v01 INTEL  S5520UT  00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 0x000000008F4ED000 000040 (v01 INTEL  S5520UT  00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 0x000000008F4D2000 01AFC4 (v02 INTEL  SSDT  PM 00004000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x000000008F4D1000 0001D8 (v02 INTEL  IPMI     00004000 INTL 20061109)
[    0.000000] ACPI: TCPA 0x000000008F4D0000 000032 (v00                 00000000      00000000)
[    0.000000] ACPI: HEST 0x000000008F4CF000 0000A8 (v01 INTEL  S5520UT  00000001 INTL 00000001)
[    0.000000] ACPI: BERT 0x000000008F3E1000 000030 (v01 INTEL  S5520UT  00000001 INTL 00000001)
[    0.000000] ACPI: ERST 0x000000008F3E0000 000230 (v01 INTEL  S5520UT  00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x000000008F3DF000 000130 (v01 INTEL  S5520UT  00000001 INTL 00000001)
[    0.000000] ACPI: XMAR 0x000000008F3DE000 0001A8 (v01 INTEL  S5520UT  00000001 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x66fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0x8c21afff]
[    0.000000]   node   0: [mem 0x100000000-0x66fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x66fffffff]
[    0.000000] On node 0 totalpages: 6275509
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8905 pages used for memmap
[    0.000000]   DMA32 zone: 569883 pages, LIFO batch:31
[    0.000000]   Normal zone: 89088 pages used for memmap
[    0.000000]   Normal zone: 5701632 pages, LIFO batch:31
[    0.000000] p2m virtual area at ffffc90000000000, size is 3400000
[    0.000000] Remapped 474698 page(s)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x12] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 8/0x12 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x32] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 9/0x32 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x14] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 10/0x14 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x34] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 11/0x34 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 12/0x1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x21] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 13/0x21 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 14/0x3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x23] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 15/0x23 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x05] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 16/0x5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x25] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 17/0x25 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x11] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 18/0x11 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x31] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 19/0x31 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x13] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 20/0x13 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x33] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 21/0x33 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x15] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 22/0x15 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x35] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 23/0x35 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec90000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec90000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
[    0.000000] smpboot: 24 Processors exceeds NR_CPUS limit of 8
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x8c21b000-0x8c2edfff]
[    0.000000] PM: Registered nosave memory: [mem 0x8c2ee000-0x8c3defff]
[    0.000000] PM: Registered nosave memory: [mem 0x8c3df000-0x8d7defff]
[    0.000000] PM: Registered nosave memory: [mem 0x8d7df000-0x8f301fff]
[    0.000000] PM: Registered nosave memory: [mem 0x8f302000-0x8f34efff]
[    0.000000] PM: Registered nosave memory: [mem 0x8f34f000-0x8f3d3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x8f3d4000-0x8f3ddfff]
[    0.000000] PM: Registered nosave memory: [mem 0x8f3de000-0x8f3e1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x8f3e2000-0x8f4cefff]
[    0.000000] PM: Registered nosave memory: [mem 0x8f4cf000-0x8f4fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x8f500000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0x9fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xa0000000-0xafffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xb0000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfd000000-0xfe70ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe710000-0xfe710fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe711000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec90000-0xfec90fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec91000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0xb0000000-0xfbffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.6-unstable (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88064b600000 s79680 r8192 d30912 u262144
[    0.000000] pcpu-alloc: s79680 r8192 d30912 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] xen: PV spinlocks enabled
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 6177430
[    0.000000] Kernel command line: debug panic=9 sysrq_always_enabled showopts log_buf_len=64M console=hvc0
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.000000] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.000000] software IO TLB [mem 0x644600000-0x648600000] (64MB) mapped at [ffff880644600000-ffff8806485fffff]
[    0.000000] Memory: 23799836K/25102036K available (7669K kernel code, 537K rwdata, 2684K rodata, 980K init, 2492K bss, 1302200K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:896 16
[    0.000000] xen:events: Using FIFO-based ABI
[    0.000000] xen: --> pirq=1 -> irq=1 (gsi=1)
[    0.000000] xen: --> pirq=2 -> irq=2 (gsi=2)
[    0.000000] xen: --> pirq=3 -> irq=3 (gsi=3)
[    0.000000] xen: --> pirq=4 -> irq=4 (gsi=4)
[    0.000000] xen: --> pirq=5 -> irq=5 (gsi=5)
[    0.000000] xen: --> pirq=6 -> irq=6 (gsi=6)
[    0.000000] xen: --> pirq=7 -> irq=7 (gsi=7)
[    0.000000] xen: --> pirq=8 -> irq=8 (gsi=8)
[    0.000000] xen: --> pirq=9 -> irq=9 (gsi=9)
[    0.000000] xen: --> pirq=10 -> irq=10 (gsi=10)
[    0.000000] xen: --> pirq=11 -> irq=11 (gsi=11)
[    0.000000] xen: --> pirq=12 -> irq=12 (gsi=12)
[    0.000000] xen: --> pirq=13 -> irq=13 (gsi=13)
[    0.000000] xen: --> pirq=14 -> irq=14 (gsi=14)
[    0.000000] xen: --> pirq=15 -> irq=15 (gsi=15)
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [hvc0] enabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] tsc: Detected 2926.416 MHz processor
[   11.949611] Calibrating delay loop (skipped), value calculated using timer frequency.. 5852.83 BogoMIPS (lpj=11705664)
[   11.949617] pid_max: default: 32768 minimum: 301
[   11.949625] ACPI: Core revision 20141107
[   11.988452] ACPI: All ACPI Tables successfully acquired
[   11.992486] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   11.992492] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   11.992893] Initializing cgroup subsys memory
[   11.992903] Initializing cgroup subsys devices
[   11.992907] Initializing cgroup subsys freezer
[   11.992911] Initializing cgroup subsys net_cls
[   11.992916] Initializing cgroup subsys blkio
[   11.992920] Initializing cgroup subsys perf_event
[   11.992976] CPU: Physical Processor ID: 0
[   11.992978] CPU: Processor Core ID: 0
[   11.992981] mce: CPU supports 2 MCE banks
[   11.992998] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[   11.992998] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[   11.993112] Freeing SMP alternatives memory: 36K (ffffffff81d7d000 - ffffffff81d86000)
[   11.994341] cpu 0 spinlock event irq 49
[   11.994385] Performance Events: unsupported p6 CPU model 44 no PMU driver, software events only.
[   11.994633] installing Xen timer for CPU 1
[   11.994645] cpu 1 spinlock event irq 56
[   11.995969] installing Xen timer for CPU 2
[   11.995980] cpu 2 spinlock event irq 63
[   11.997238] installing Xen timer for CPU 3
[   11.997248] cpu 3 spinlock event irq 70
[   11.998481] installing Xen timer for CPU 4
[   11.998491] cpu 4 spinlock event irq 77
[   11.999490] installing Xen timer for CPU 5
[   11.999499] cpu 5 spinlock event irq 84
[   12.000515] installing Xen timer for CPU 6
[   12.000525] cpu 6 spinlock event irq 91
[   12.001549] installing Xen timer for CPU 7
[   12.001559] cpu 7 spinlock event irq 98
[   12.002567] x86: Booted up 1 node, 8 CPUs
[   12.002975] devtmpfs: initialized
[   12.006708] PM: Registering ACPI NVS region [mem 0x8c21b000-0x8c2edfff] (864256 bytes)
[   12.006722] PM: Registering ACPI NVS region [mem 0x8c3df000-0x8d7defff] (20971520 bytes)
[   12.006934] PM: Registering ACPI NVS region [mem 0x8f3d4000-0x8f3ddfff] (40960 bytes)
[   12.006938] PM: Registering ACPI NVS region [mem 0x8f3e2000-0x8f4cefff] (970752 bytes)
[   12.007108] xor: measuring software checksum speed
[   12.045360]    prefetch64-sse:  7205.000 MB/sec
[   12.085384]    generic_sse:  6672.000 MB/sec
[   12.085386] xor: using function: prefetch64-sse (7205.000 MB/sec)
[   12.085480] NET: Registered protocol family 16
[   12.085496] xen:grant_table: Grant tables using version 1 layout
[   12.085506] Grant table initialized
[   12.085854] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[   12.085859] ACPI: bus type PCI registered
[   12.086131] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xa0000000-0xafffffff] (base 0xa0000000)
[   12.086136] PCI: MMCONFIG at [mem 0xa0000000-0xafffffff] reserved in E820
[   12.119991] PCI: Using configuration type 1 for base access
[   12.198162] raid6: sse2x1    6992 MB/s
[   12.266932] raid6: sse2x2    8119 MB/s
[   12.335658] raid6: sse2x4    8980 MB/s
[   12.335662] raid6: using algorithm sse2x4 (8980 MB/s)
[   12.335664] raid6: using ssse3x2 recovery algorithm
[   12.335716] ACPI: Added _OSI(Module Device)
[   12.335721] ACPI: Added _OSI(Processor Device)
[   12.335723] ACPI: Added _OSI(3.0 _SCP Extensions)
[   12.335726] ACPI: Added _OSI(Processor Aggregator Device)
[   12.336955] xen: registering gsi 9 triggering 0 polarity 0
[   12.359743] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20141107/dsopcode-236)
[   12.359752] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff8806440401b8), AE_AML_BUFFER_LIMIT (20141107/psparse-536)
[   12.361149] ACPI: Interpreter enabled
[   12.361160] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
[   12.361165] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20141107/hwxface-580)
[   12.361171] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20141107/hwxface-580)
[   12.361178] ACPI: (supports S0 S1 S5)
[   12.361181] ACPI: Using IOAPIC for interrupt routing
[   12.361203] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[   12.365633] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fd])
[   12.365642] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[   12.365814] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[   12.366268] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[   12.366297] PCI host bridge to bus 0000:00
[   12.366301] pci_bus 0000:00: root bus resource [bus 00-fd]
[   12.366304] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   12.366307] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   12.366310] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[   12.366314] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[   12.366317] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xfdffffff]
[   12.366320] pci_bus 0000:00: scanning bus
[   12.366341] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[   12.366351] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x10
[   12.366458] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[   12.366465] pci 0000:00:00.0: PME# disabled
[   12.366587] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[   12.366639] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.366717] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[   12.366723] pci 0000:00:01.0: PME# disabled
[   12.366779] pci 0000:00:01.0: System wakeup disabled by ACPI
[   12.366847] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[   12.366896] pci 0000:00:03.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.366965] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[   12.366971] pci 0000:00:03.0: PME# disabled
[   12.367025] pci 0000:00:03.0: System wakeup disabled by ACPI
[   12.367092] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[   12.367141] pci 0000:00:05.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.367208] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[   12.367214] pci 0000:00:05.0: PME# disabled
[   12.367269] pci 0000:00:05.0: System wakeup disabled by ACPI
[   12.367335] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[   12.367384] pci 0000:00:07.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.367452] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[   12.367459] pci 0000:00:07.0: PME# disabled
[   12.367513] pci 0000:00:07.0: System wakeup disabled by ACPI
[   12.367578] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[   12.367627] pci 0000:00:09.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.367694] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[   12.367700] pci 0000:00:09.0: PME# disabled
[   12.367754] pci 0000:00:09.0: System wakeup disabled by ACPI
[   12.367817] pci 0000:00:0a.0: [8086:3411] type 01 class 0x060400
[   12.367866] pci 0000:00:0a.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.367933] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[   12.367939] pci 0000:00:0a.0: PME# disabled
[   12.367993] pci 0000:00:0a.0: System wakeup disabled by ACPI
[   12.368084] pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
[   12.368248] pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
[   12.368394] pci 0000:00:11.0: [8086:3427] type 00 class 0x080000
[   12.368555] pci 0000:00:11.1: [8086:3428] type 00 class 0x080000
[   12.368705] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[   12.368727] pci 0000:00:13.0: reg 0x10: [mem 0xb1b24000-0xb1b24fff]
[   12.368821] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[   12.368827] pci 0000:00:13.0: PME# disabled
[   12.368919] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[   12.369086] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[   12.369254] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[   12.369413] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[   12.369554] pci 0000:00:15.0: [8086:342f] type 00 class 0x080020
[   12.369704] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[   12.369729] pci 0000:00:16.0: reg 0x10: [mem 0xb1b00000-0xb1b03fff 64bit]
[   12.369935] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[   12.369961] pci 0000:00:16.1: reg 0x10: [mem 0xb1b04000-0xb1b07fff 64bit]
[   12.370158] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[   12.370183] pci 0000:00:16.2: reg 0x10: [mem 0xb1b08000-0xb1b0bfff 64bit]
[   12.370374] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[   12.370398] pci 0000:00:16.3: reg 0x10: [mem 0xb1b0c000-0xb1b0ffff 64bit]
[   12.370590] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[   12.370615] pci 0000:00:16.4: reg 0x10: [mem 0xb1b10000-0xb1b13fff 64bit]
[   12.370816] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[   12.370842] pci 0000:00:16.5: reg 0x10: [mem 0xb1b14000-0xb1b17fff 64bit]
[   12.371032] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[   12.371057] pci 0000:00:16.6: reg 0x10: [mem 0xb1b18000-0xb1b1bfff 64bit]
[   12.371247] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[   12.371272] pci 0000:00:16.7: reg 0x10: [mem 0xb1b1c000-0xb1b1ffff 64bit]
[   12.371465] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[   12.371537] pci 0000:00:1a.0: reg 0x20: [io  0x30e0-0x30ff]
[   12.371660] pci 0000:00:1a.0: System wakeup disabled by ACPI
[   12.371714] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[   12.371786] pci 0000:00:1a.1: reg 0x20: [io  0x30c0-0x30df]
[   12.371908] pci 0000:00:1a.1: System wakeup disabled by ACPI
[   12.371962] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[   12.372034] pci 0000:00:1a.2: reg 0x20: [io  0x30a0-0x30bf]
[   12.372157] pci 0000:00:1a.2: System wakeup disabled by ACPI
[   12.372224] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[   12.372259] pci 0000:00:1a.7: reg 0x10: [mem 0xb1b22000-0xb1b223ff]
[   12.372406] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[   12.372413] pci 0000:00:1a.7: PME# disabled
[   12.372481] pci 0000:00:1a.7: System wakeup disabled by ACPI
[   12.372538] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[   12.372601] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.372673] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[   12.372679] pci 0000:00:1c.0: PME# disabled
[   12.372735] pci 0000:00:1c.0: System wakeup disabled by ACPI
[   12.372793] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[   12.372855] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.372927] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[   12.372933] pci 0000:00:1c.4: PME# disabled
[   12.372988] pci 0000:00:1c.4: System wakeup disabled by ACPI
[   12.373041] pci 0000:00:1c.5: [8086:3a4a] type 01 class 0x060400
[   12.373103] pci 0000:00:1c.5: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.373175] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[   12.373181] pci 0000:00:1c.5: PME# disabled
[   12.373236] pci 0000:00:1c.5: System wakeup disabled by ACPI
[   12.373292] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[   12.373364] pci 0000:00:1d.0: reg 0x20: [io  0x3080-0x309f]
[   12.373487] pci 0000:00:1d.0: System wakeup disabled by ACPI
[   12.373540] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[   12.373612] pci 0000:00:1d.1: reg 0x20: [io  0x3060-0x307f]
[   12.373733] pci 0000:00:1d.1: System wakeup disabled by ACPI
[   12.373786] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[   12.373860] pci 0000:00:1d.2: reg 0x20: [io  0x3040-0x305f]
[   12.373992] pci 0000:00:1d.2: System wakeup disabled by ACPI
[   12.374063] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[   12.374097] pci 0000:00:1d.7: reg 0x10: [mem 0xb1b21000-0xb1b213ff]
[   12.374273] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[   12.374280] pci 0000:00:1d.7: PME# disabled
[   12.374349] pci 0000:00:1d.7: System wakeup disabled by ACPI
[   12.374402] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[   12.374459] pci 0000:00:1e.0: calling quirk_use_pcie_bridge_dma_alias+0x0/0x50
[   12.374464] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   12.374540] pci 0000:00:1e.0: System wakeup disabled by ACPI
[   12.374594] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[   12.374721] pci 0000:00:1f.0: calling ich_force_enable_hpet+0x0/0x1c0
[   12.374726] pci 0000:00:1f.0: calling quirk_ich7_lpc+0x0/0x70
[   12.374736] pci 0000:00:1f.0: can't claim BAR 13 [io  0x0400-0x047f]: address conflict with ACPI CPU throttle [io  0x0410-0x0415]
[   12.374745] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[   12.374751] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[   12.374756] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[   12.374762] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0600 (mask 001f)
[   12.374907] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[   12.374941] pci 0000:00:1f.2: reg 0x10: [io  0x3108-0x310f]
[   12.374954] pci 0000:00:1f.2: reg 0x14: [io  0x3114-0x3117]
[   12.374968] pci 0000:00:1f.2: reg 0x18: [io  0x3100-0x3107]
[   12.374982] pci 0000:00:1f.2: reg 0x1c: [io  0x3110-0x3113]
[   12.374995] pci 0000:00:1f.2: reg 0x20: [io  0x3020-0x303f]
[   12.375009] pci 0000:00:1f.2: reg 0x24: [mem 0xb1b20000-0xb1b207ff]
[   12.375092] pci 0000:00:1f.2: PME# supported from D3hot
[   12.375098] pci 0000:00:1f.2: PME# disabled
[   12.375193] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[   12.375219] pci 0000:00:1f.3: reg 0x10: [mem 0xb1b23000-0xb1b230ff 64bit]
[   12.375256] pci 0000:00:1f.3: reg 0x20: [io  0x3000-0x301f]
[   12.375365] pci_bus 0000:00: fixups for bus
[   12.375371] pci 0000:00:01.0: scanning [bus 01-03] behind bridge, pass 0
[   12.375438] pci_bus 0000:01: scanning bus
[   12.375466] pci 0000:01:00.0: [8086:10c9] type 00 class 0x020000
[   12.375489] pci 0000:01:00.0: reg 0x10: [mem 0xb1a20000-0xb1a3ffff]
[   12.375517] pci 0000:01:00.0: reg 0x18: [io  0x2020-0x203f]
[   12.375532] pci 0000:01:00.0: reg 0x1c: [mem 0xb1ac4000-0xb1ac7fff]
[   12.375655] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[   12.375661] pci 0000:01:00.0: PME# disabled
[   12.375709] pci 0000:01:00.0: reg 0x184: [mem 0xb1a40000-0xb1a43fff 64bit]
[   12.375732] pci 0000:01:00.0: reg 0x190: [mem 0xb1a60000-0xb1a63fff 64bit]
[   12.375760] pci 0000:01:00.0: System wakeup disabled by ACPI
[   12.375850] pci 0000:01:00.1: [8086:10c9] type 00 class 0x020000
[   12.375873] pci 0000:01:00.1: reg 0x10: [mem 0xb1a00000-0xb1a1ffff]
[   12.375901] pci 0000:01:00.1: reg 0x18: [io  0x2000-0x201f]
[   12.375916] pci 0000:01:00.1: reg 0x1c: [mem 0xb1ac0000-0xb1ac3fff]
[   12.376038] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[   12.376045] pci 0000:01:00.1: PME# disabled
[   12.376085] pci 0000:01:00.1: reg 0x184: [mem 0xb1a80000-0xb1a83fff 64bit]
[   12.376108] pci 0000:01:00.1: reg 0x190: [mem 0xb1aa0000-0xb1aa3fff 64bit]
[   12.376132] pci 0000:01:00.1: System wakeup disabled by ACPI
[   12.377719] pci_bus 0000:01: fixups for bus
[   12.377740] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[   12.377746] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[   12.377753] pci 0000:00:01.0:   bridge window [mem 0xb1a00000-0xb1afffff]
[   12.377762] pci_bus 0000:01: bus scan returning with max=01
[   12.377768] pci 0000:00:03.0: scanning [bus 04-04] behind bridge, pass 0
[   12.377836] pci_bus 0000:04: scanning bus
[   12.377840] pci_bus 0000:04: fixups for bus
[   12.377843] pci 0000:00:03.0: PCI bridge to [bus 04]
[   12.377857] pci_bus 0000:04: bus scan returning with max=04
[   12.377863] pci 0000:00:05.0: scanning [bus 05-08] behind bridge, pass 0
[   12.377937] pci_bus 0000:05: scanning bus
[   12.377958] pci 0000:05:00.0: [111d:806a] type 01 class 0x060400
[   12.378088] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[   12.378095] pci 0000:05:00.0: PME# disabled
[   12.379557] pci_bus 0000:05: fixups for bus
[   12.379561] pci 0000:00:05.0: PCI bridge to [bus 05-08]
[   12.379577] pci 0000:05:00.0: scanning [bus 06-08] behind bridge, pass 0
[   12.379637] pci_bus 0000:06: scanning bus
[   12.379660] pci 0000:06:02.0: [111d:806a] type 01 class 0x060400
[   12.379805] pci 0000:06:02.0: PME# supported from D0 D3hot D3cold
[   12.379812] pci 0000:06:02.0: PME# disabled
[   12.379890] pci 0000:06:04.0: [111d:806a] type 01 class 0x060400
[   12.380034] pci 0000:06:04.0: PME# supported from D0 D3hot D3cold
[   12.380041] pci 0000:06:04.0: PME# disabled
[   12.380144] pci_bus 0000:06: fixups for bus
[   12.380147] pci 0000:05:00.0: PCI bridge to [bus 06-08]
[   12.380172] pci 0000:06:02.0: scanning [bus 07-07] behind bridge, pass 0
[   12.380241] pci_bus 0000:07: scanning bus
[   12.380245] pci_bus 0000:07: fixups for bus
[   12.380248] pci 0000:06:02.0: PCI bridge to [bus 07]
[   12.380270] pci_bus 0000:07: bus scan returning with max=07
[   12.380278] pci 0000:06:04.0: scanning [bus 08-08] behind bridge, pass 0
[   12.380345] pci_bus 0000:08: scanning bus
[   12.380350] pci_bus 0000:08: fixups for bus
[   12.380352] pci 0000:06:04.0: PCI bridge to [bus 08]
[   12.380374] pci_bus 0000:08: bus scan returning with max=08
[   12.380382] pci 0000:06:02.0: scanning [bus 07-07] behind bridge, pass 1
[   12.380393] pci 0000:06:04.0: scanning [bus 08-08] behind bridge, pass 1
[   12.380402] pci_bus 0000:06: bus scan returning with max=08
[   12.380409] pci 0000:05:00.0: scanning [bus 06-08] behind bridge, pass 1
[   12.380419] pci_bus 0000:05: bus scan returning with max=08
[   12.380425] pci 0000:00:07.0: scanning [bus 09-0c] behind bridge, pass 0
[   12.380491] pci_bus 0000:09: scanning bus
[   12.380511] pci 0000:09:00.0: [111d:806a] type 01 class 0x060400
[   12.380639] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[   12.380647] pci 0000:09:00.0: PME# disabled
[   12.382091] pci_bus 0000:09: fixups for bus
[   12.382116] pci 0000:00:07.0: PCI bridge to [bus 09-0c]
[   12.382133] pci 0000:09:00.0: scanning [bus 0a-0c] behind bridge, pass 0
[   12.382193] pci_bus 0000:0a: scanning bus
[   12.382216] pci 0000:0a:02.0: [111d:806a] type 01 class 0x060400
[   12.382362] pci 0000:0a:02.0: PME# supported from D0 D3hot D3cold
[   12.382370] pci 0000:0a:02.0: PME# disabled
[   12.382447] pci 0000:0a:04.0: [111d:806a] type 01 class 0x060400
[   12.382591] pci 0000:0a:04.0: PME# supported from D0 D3hot D3cold
[   12.382598] pci 0000:0a:04.0: PME# disabled
[   12.382696] pci_bus 0000:0a: fixups for bus
[   12.382699] pci 0000:09:00.0: PCI bridge to [bus 0a-0c]
[   12.382724] pci 0000:0a:02.0: scanning [bus 0b-0b] behind bridge, pass 0
[   12.382793] pci_bus 0000:0b: scanning bus
[   12.382797] pci_bus 0000:0b: fixups for bus
[   12.382800] pci 0000:0a:02.0: PCI bridge to [bus 0b]
[   12.382822] pci_bus 0000:0b: bus scan returning with max=0b
[   12.382829] pci 0000:0a:04.0: scanning [bus 0c-0c] behind bridge, pass 0
[   12.382897] pci_bus 0000:0c: scanning bus
[   12.382902] pci_bus 0000:0c: fixups for bus
[   12.382905] pci 0000:0a:04.0: PCI bridge to [bus 0c]
[   12.382927] pci_bus 0000:0c: bus scan returning with max=0c
[   12.382934] pci 0000:0a:02.0: scanning [bus 0b-0b] behind bridge, pass 1
[   12.382945] pci 0000:0a:04.0: scanning [bus 0c-0c] behind bridge, pass 1
[   12.382954] pci_bus 0000:0a: bus scan returning with max=0c
[   12.382961] pci 0000:09:00.0: scanning [bus 0a-0c] behind bridge, pass 1
[   12.382970] pci_bus 0000:09: bus scan returning with max=0c
[   12.382977] pci 0000:00:09.0: scanning [bus 0d-0d] behind bridge, pass 0
[   12.383042] pci_bus 0000:0d: scanning bus
[   12.383046] pci_bus 0000:0d: fixups for bus
[   12.383049] pci 0000:00:09.0: PCI bridge to [bus 0d]
[   12.383063] pci_bus 0000:0d: bus scan returning with max=0d
[   12.383069] pci 0000:00:0a.0: scanning [bus 0e-0e] behind bridge, pass 0
[   12.383134] pci_bus 0000:0e: scanning bus
[   12.383138] pci_bus 0000:0e: fixups for bus
[   12.383141] pci 0000:00:0a.0: PCI bridge to [bus 0e]
[   12.383155] pci_bus 0000:0e: bus scan returning with max=0e
[   12.383162] pci 0000:00:1c.0: scanning [bus 0f-0f] behind bridge, pass 0
[   12.383231] pci_bus 0000:0f: scanning bus
[   12.383252] pci 0000:0f:00.0: [1000:0062] type 00 class 0x010000
[   12.383287] pci 0000:0f:00.0: reg 0x10: [mem 0xb1940000-0xb1943fff 64bit]
[   12.383304] pci 0000:0f:00.0: reg 0x18: [io  0x1000-0x10ff]
[   12.383330] pci 0000:0f:00.0: reg 0x1c: [mem 0xb1900000-0xb193ffff 64bit]
[   12.383361] pci 0000:0f:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]
[   12.383459] pci 0000:0f:00.0: supports D1
[   12.391662] pci_bus 0000:0f: fixups for bus
[   12.391670] pci 0000:00:1c.0: PCI bridge to [bus 0f]
[   12.391681] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[   12.391692] pci 0000:00:1c.0:   bridge window [mem 0xb1900000-0xb19fffff]
[   12.391708] pci_bus 0000:0f: bus scan returning with max=0f
[   12.391720] pci 0000:00:1c.4: scanning [bus 10-10] behind bridge, pass 0
[   12.391803] pci_bus 0000:10: scanning bus
[   12.391833] pci 0000:10:00.0: [102b:0522] type 00 class 0x030000
[   12.391866] pci 0000:10:00.0: reg 0x10: [mem 0xb0000000-0xb0ffffff pref]
[   12.391887] pci 0000:10:00.0: reg 0x14: [mem 0xb1800000-0xb1803fff]
[   12.391907] pci 0000:10:00.0: reg 0x18: [mem 0xb1000000-0xb17fffff]
[   12.391981] pci 0000:10:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[   12.399762] pci_bus 0000:10: fixups for bus
[   12.399770] pci 0000:00:1c.4: PCI bridge to [bus 10]
[   12.399787] pci 0000:00:1c.4:   bridge window [mem 0xb1000000-0xb18fffff]
[   12.399804] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[   12.399811] pci_bus 0000:10: bus scan returning with max=10
[   12.399823] pci 0000:00:1c.5: scanning [bus 11-11] behind bridge, pass 0
[   12.399922] pci_bus 0000:11: scanning bus
[   12.399927] pci_bus 0000:11: fixups for bus
[   12.399930] pci 0000:00:1c.5: PCI bridge to [bus 11]
[   12.399946] pci_bus 0000:11: bus scan returning with max=11
[   12.399952] pci 0000:00:1e.0: scanning [bus 12-12] behind bridge, pass 0
[   12.399989] pci_bus 0000:12: scanning bus
[   12.400055] pci_bus 0000:12: fixups for bus
[   12.400058] pci 0000:00:1e.0: PCI bridge to [bus 12] (subtractive decode)
[   12.400074] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[   12.400079] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[   12.400083] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[   12.400086] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[   12.400090] pci 0000:00:1e.0:   bridge window [mem 0xb0000000-0xfdffffff] (subtractive decode)
[   12.400094] pci_bus 0000:12: bus scan returning with max=12
[   12.400100] pci 0000:00:01.0: scanning [bus 01-03] behind bridge, pass 1
[   12.400114] pci 0000:00:03.0: scanning [bus 04-04] behind bridge, pass 1
[   12.400127] pci 0000:00:05.0: scanning [bus 05-08] behind bridge, pass 1
[   12.400140] pci 0000:00:07.0: scanning [bus 09-0c] behind bridge, pass 1
[   12.400153] pci 0000:00:09.0: scanning [bus 0d-0d] behind bridge, pass 1
[   12.400166] pci 0000:00:0a.0: scanning [bus 0e-0e] behind bridge, pass 1
[   12.400179] pci 0000:00:1c.0: scanning [bus 0f-0f] behind bridge, pass 1
[   12.400191] pci 0000:00:1c.4: scanning [bus 10-10] behind bridge, pass 1
[   12.400202] pci 0000:00:1c.5: scanning [bus 11-11] behind bridge, pass 1
[   12.400213] pci 0000:00:1e.0: scanning [bus 12-12] behind bridge, pass 1
[   12.400221] pci_bus 0000:00: bus scan returning with max=12
[   12.400234] pci 0000:05:00.0: Max Payload Size 128, but upstream 0000:00:05.0 set to 256; if necessary, use "pci=pcie_bus_safe" and report a bug
[   12.400251] pci 0000:09:00.0: Max Payload Size 128, but upstream 0000:00:07.0 set to 256; if necessary, use "pci=pcie_bus_safe" and report a bug
[   12.400272] pci_bus 0000:00: on NUMA node 0
[   12.400274] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[   12.400395] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[   12.400465] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[   12.400532] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[   12.400599] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[   12.400666] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[   12.400746] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[   12.400831] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[   12.400899] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[   12.400942] xen: registering gsi 13 triggering 1 polarity 0
[   12.401239] ACPI: Enabled 1 GPEs in block 00 to 3F
[   12.401281] xen:balloon: Initialising balloon driver
[   12.402636] xen_balloon: Initialising balloon driver
[   12.402926] vgaarb: setting as boot device: PCI:0000:10:00.0
[   12.402935] vgaarb: device added: PCI:0000:10:00.0,decodes=io+mem,owns=io+mem,locks=none
[   12.402940] vgaarb: loaded
[   12.402944] vgaarb: bridge control possible 0000:10:00.0
[   12.403033] SCSI subsystem initialized
[   12.403099] libata version 3.00 loaded.
[   12.403117] ACPI: bus type USB registered
[   12.403148] usbcore: registered new interface driver usbfs
[   12.403160] usbcore: registered new interface driver hub
[   12.403190] usbcore: registered new device driver usb
[   12.403223] pps_core: LinuxPPS API ver. 1 registered
[   12.403226] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   12.403233] PTP clock support registered
[   12.403257] PCI: Using ACPI for IRQ routing
[   12.414607] PCI: Discovered peer bus fe
[   12.414610] PCI: root bus fe: using default resources
[   12.414613] PCI: Probing PCI hardware (bus fe)
[   12.414638] PCI host bridge to bus 0000:fe
[   12.414642] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[   12.414645] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xffffffffff]
[   12.414649] pci_bus 0000:fe: No busn resource found for root bus, will use [bus fe-ff]
[   12.414653] pci_bus 0000:fe: scanning bus
[   12.414663] pci 0000:fe:00.0: [8086:2c70] type 00 class 0x060000
[   12.414672] pci 0000:fe:00.0: calling quirk_mmio_always_on+0x0/0x10
[   12.414759] pci 0000:fe:00.1: [8086:2d81] type 00 class 0x060000
[   12.414764] pci 0000:fe:00.1: calling quirk_mmio_always_on+0x0/0x10
[   12.414847] pci 0000:fe:02.0: [8086:2d90] type 00 class 0x060000
[   12.414852] pci 0000:fe:02.0: calling quirk_mmio_always_on+0x0/0x10
[   12.414926] pci 0000:fe:02.1: [8086:2d91] type 00 class 0x060000
[   12.414931] pci 0000:fe:02.1: calling quirk_mmio_always_on+0x0/0x10
[   12.415006] pci 0000:fe:02.2: [8086:2d92] type 00 class 0x060000
[   12.415011] pci 0000:fe:02.2: calling quirk_mmio_always_on+0x0/0x10
[   12.415085] pci 0000:fe:02.3: [8086:2d93] type 00 class 0x060000
[   12.415090] pci 0000:fe:02.3: calling quirk_mmio_always_on+0x0/0x10
[   12.415164] pci 0000:fe:02.4: [8086:2d94] type 00 class 0x060000
[   12.415169] pci 0000:fe:02.4: calling quirk_mmio_always_on+0x0/0x10
[   12.415244] pci 0000:fe:02.5: [8086:2d95] type 00 class 0x060000
[   12.415249] pci 0000:fe:02.5: calling quirk_mmio_always_on+0x0/0x10
[   12.415326] pci 0000:fe:03.0: [8086:2d98] type 00 class 0x060000
[   12.415331] pci 0000:fe:03.0: calling quirk_mmio_always_on+0x0/0x10
[   12.415405] pci 0000:fe:03.1: [8086:2d99] type 00 class 0x060000
[   12.415410] pci 0000:fe:03.1: calling quirk_mmio_always_on+0x0/0x10
[   12.415484] pci 0000:fe:03.2: [8086:2d9a] type 00 class 0x060000
[   12.415489] pci 0000:fe:03.2: calling quirk_mmio_always_on+0x0/0x10
[   12.415564] pci 0000:fe:03.4: [8086:2d9c] type 00 class 0x060000
[   12.415569] pci 0000:fe:03.4: calling quirk_mmio_always_on+0x0/0x10
[   12.415646] pci 0000:fe:04.0: [8086:2da0] type 00 class 0x060000
[   12.415651] pci 0000:fe:04.0: calling quirk_mmio_always_on+0x0/0x10
[   12.415725] pci 0000:fe:04.1: [8086:2da1] type 00 class 0x060000
[   12.415730] pci 0000:fe:04.1: calling quirk_mmio_always_on+0x0/0x10
[   12.415817] pci 0000:fe:04.2: [8086:2da2] type 00 class 0x060000
[   12.415823] pci 0000:fe:04.2: calling quirk_mmio_always_on+0x0/0x10
[   12.415900] pci 0000:fe:04.3: [8086:2da3] type 00 class 0x060000
[   12.415904] pci 0000:fe:04.3: calling quirk_mmio_always_on+0x0/0x10
[   12.415983] pci 0000:fe:05.0: [8086:2da8] type 00 class 0x060000
[   12.415988] pci 0000:fe:05.0: calling quirk_mmio_always_on+0x0/0x10
[   12.416062] pci 0000:fe:05.1: [8086:2da9] type 00 class 0x060000
[   12.416067] pci 0000:fe:05.1: calling quirk_mmio_always_on+0x0/0x10
[   12.416142] pci 0000:fe:05.2: [8086:2daa] type 00 class 0x060000
[   12.416147] pci 0000:fe:05.2: calling quirk_mmio_always_on+0x0/0x10
[   12.416221] pci 0000:fe:05.3: [8086:2dab] type 00 class 0x060000
[   12.416226] pci 0000:fe:05.3: calling quirk_mmio_always_on+0x0/0x10
[   12.416335] pci 0000:fe:06.0: [8086:2db0] type 00 class 0x060000
[   12.416339] pci 0000:fe:06.0: calling quirk_mmio_always_on+0x0/0x10
[   12.416416] pci 0000:fe:06.1: [8086:2db1] type 00 class 0x060000
[   12.416421] pci 0000:fe:06.1: calling quirk_mmio_always_on+0x0/0x10
[   12.416496] pci 0000:fe:06.2: [8086:2db2] type 00 class 0x060000
[   12.416501] pci 0000:fe:06.2: calling quirk_mmio_always_on+0x0/0x10
[   12.416576] pci 0000:fe:06.3: [8086:2db3] type 00 class 0x060000
[   12.416581] pci 0000:fe:06.3: calling quirk_mmio_always_on+0x0/0x10
[   12.416686] pci_bus 0000:fe: fixups for bus
[   12.416689] pci_bus 0000:fe: bus scan returning with max=fe
[   12.416693] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to fe
[   12.416700] PCI: Discovered peer bus ff
[   12.416702] PCI: root bus ff: using default resources
[   12.416704] PCI: Probing PCI hardware (bus ff)
[   12.416725] PCI host bridge to bus 0000:ff
[   12.416728] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[   12.416731] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[   12.416734] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[   12.416738] pci_bus 0000:ff: scanning bus
[   12.416746] pci 0000:ff:00.0: [8086:2c70] type 00 class 0x060000
[   12.416751] pci 0000:ff:00.0: calling quirk_mmio_always_on+0x0/0x10
[   12.416824] pci 0000:ff:00.1: [8086:2d81] type 00 class 0x060000
[   12.416829] pci 0000:ff:00.1: calling quirk_mmio_always_on+0x0/0x10
[   12.416908] pci 0000:ff:02.0: [8086:2d90] type 00 class 0x060000
[   12.416913] pci 0000:ff:02.0: calling quirk_mmio_always_on+0x0/0x10
[   12.416983] pci 0000:ff:02.1: [8086:2d91] type 00 class 0x060000
[   12.416988] pci 0000:ff:02.1: calling quirk_mmio_always_on+0x0/0x10
[   12.417059] pci 0000:ff:02.2: [8086:2d92] type 00 class 0x060000
[   12.417064] pci 0000:ff:02.2: calling quirk_mmio_always_on+0x0/0x10
[   12.417136] pci 0000:ff:02.3: [8086:2d93] type 00 class 0x060000
[   12.417141] pci 0000:ff:02.3: calling quirk_mmio_always_on+0x0/0x10
[   12.417212] pci 0000:ff:02.4: [8086:2d94] type 00 class 0x060000
[   12.417217] pci 0000:ff:02.4: calling quirk_mmio_always_on+0x0/0x10
[   12.417290] pci 0000:ff:02.5: [8086:2d95] type 00 class 0x060000
[   12.417295] pci 0000:ff:02.5: calling quirk_mmio_always_on+0x0/0x10
[   12.417369] pci 0000:ff:03.0: [8086:2d98] type 00 class 0x060000
[   12.417374] pci 0000:ff:03.0: calling quirk_mmio_always_on+0x0/0x10
[   12.417445] pci 0000:ff:03.1: [8086:2d99] type 00 class 0x060000
[   12.417450] pci 0000:ff:03.1: calling quirk_mmio_always_on+0x0/0x10
[   12.417522] pci 0000:ff:03.2: [8086:2d9a] type 00 class 0x060000
[   12.417526] pci 0000:ff:03.2: calling quirk_mmio_always_on+0x0/0x10
[   12.417599] pci 0000:ff:03.4: [8086:2d9c] type 00 class 0x060000
[   12.417603] pci 0000:ff:03.4: calling quirk_mmio_always_on+0x0/0x10
[   12.417678] pci 0000:ff:04.0: [8086:2da0] type 00 class 0x060000
[   12.417683] pci 0000:ff:04.0: calling quirk_mmio_always_on+0x0/0x10
[   12.417754] pci 0000:ff:04.1: [8086:2da1] type 00 class 0x060000
[   12.417759] pci 0000:ff:04.1: calling quirk_mmio_always_on+0x0/0x10
[   12.417831] pci 0000:ff:04.2: [8086:2da2] type 00 class 0x060000
[   12.417835] pci 0000:ff:04.2: calling quirk_mmio_always_on+0x0/0x10
[   12.417908] pci 0000:ff:04.3: [8086:2da3] type 00 class 0x060000
[   12.417913] pci 0000:ff:04.3: calling quirk_mmio_always_on+0x0/0x10
[   12.417989] pci 0000:ff:05.0: [8086:2da8] type 00 class 0x060000
[   12.417994] pci 0000:ff:05.0: calling quirk_mmio_always_on+0x0/0x10
[   12.418064] pci 0000:ff:05.1: [8086:2da9] type 00 class 0x060000
[   12.418069] pci 0000:ff:05.1: calling quirk_mmio_always_on+0x0/0x10
[   12.418141] pci 0000:ff:05.2: [8086:2daa] type 00 class 0x060000
[   12.418145] pci 0000:ff:05.2: calling quirk_mmio_always_on+0x0/0x10
[   12.418217] pci 0000:ff:05.3: [8086:2dab] type 00 class 0x060000
[   12.418222] pci 0000:ff:05.3: calling quirk_mmio_always_on+0x0/0x10
[   12.418298] pci 0000:ff:06.0: [8086:2db0] type 00 class 0x060000
[   12.418303] pci 0000:ff:06.0: calling quirk_mmio_always_on+0x0/0x10
[   12.418385] pci 0000:ff:06.1: [8086:2db1] type 00 class 0x060000
[   12.418391] pci 0000:ff:06.1: calling quirk_mmio_always_on+0x0/0x10
[   12.418473] pci 0000:ff:06.2: [8086:2db2] type 00 class 0x060000
[   12.418479] pci 0000:ff:06.2: calling quirk_mmio_always_on+0x0/0x10
[   12.418554] pci 0000:ff:06.3: [8086:2db3] type 00 class 0x060000
[   12.418559] pci 0000:ff:06.3: calling quirk_mmio_always_on+0x0/0x10
[   12.418659] pci_bus 0000:ff: fixups for bus
[   12.418663] pci_bus 0000:ff: bus scan returning with max=ff
[   12.418666] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[   12.418673] PCI: pci_cache_line_size set to 64 bytes
[   12.418684] pci 0000:01:00.0: BAR 0: reserving [mem 0xb1a20000-0xb1a3ffff flags 0x40200] (d=0, p=0)
[   12.418689] pci 0000:01:00.0: BAR 2: reserving [io  0x2020-0x203f flags 0x40101] (d=0, p=0)
[   12.418693] pci 0000:01:00.0: BAR 3: reserving [mem 0xb1ac4000-0xb1ac7fff flags 0x40200] (d=0, p=0)
[   12.418697] pci 0000:01:00.0: BAR 7: reserving [mem 0xb1a40000-0xb1a5ffff flags 0x140204] (d=0, p=0)
[   12.418701] pci 0000:01:00.0: BAR 10: reserving [mem 0xb1a60000-0xb1a7ffff flags 0x140204] (d=0, p=0)
[   12.418708] pci 0000:01:00.1: BAR 0: reserving [mem 0xb1a00000-0xb1a1ffff flags 0x40200] (d=0, p=0)
[   12.418712] pci 0000:01:00.1: BAR 2: reserving [io  0x2000-0x201f flags 0x40101] (d=0, p=0)
[   12.418716] pci 0000:01:00.1: BAR 3: reserving [mem 0xb1ac0000-0xb1ac3fff flags 0x40200] (d=0, p=0)
[   12.418720] pci 0000:01:00.1: BAR 7: reserving [mem 0xb1a80000-0xb1a9ffff flags 0x140204] (d=0, p=0)
[   12.418724] pci 0000:01:00.1: BAR 10: reserving [mem 0xb1aa0000-0xb1abffff flags 0x140204] (d=0, p=0)
[   12.418757] pci 0000:00:13.0: BAR 0: reserving [mem 0xb1b24000-0xb1b24fff flags 0x40200] (d=0, p=0)
[   12.418771] pci 0000:00:16.0: BAR 0: reserving [mem 0xb1b00000-0xb1b03fff flags 0x140204] (d=0, p=0)
[   12.418777] pci 0000:00:16.1: BAR 0: reserving [mem 0xb1b04000-0xb1b07fff flags 0x140204] (d=0, p=0)
[   12.418783] pci 0000:00:16.2: BAR 0: reserving [mem 0xb1b08000-0xb1b0bfff flags 0x140204] (d=0, p=0)
[   12.418789] pci 0000:00:16.3: BAR 0: reserving [mem 0xb1b0c000-0xb1b0ffff flags 0x140204] (d=0, p=0)
[   12.418795] pci 0000:00:16.4: BAR 0: reserving [mem 0xb1b10000-0xb1b13fff flags 0x140204] (d=0, p=0)
[   12.418801] pci 0000:00:16.5: BAR 0: reserving [mem 0xb1b14000-0xb1b17fff flags 0x140204] (d=0, p=0)
[   12.418807] pci 0000:00:16.6: BAR 0: reserving [mem 0xb1b18000-0xb1b1bfff flags 0x140204] (d=0, p=0)
[   12.418813] pci 0000:00:16.7: BAR 0: reserving [mem 0xb1b1c000-0xb1b1ffff flags 0x140204] (d=0, p=0)
[   12.418819] pci 0000:00:1a.0: BAR 4: reserving [io  0x30e0-0x30ff flags 0x40101] (d=0, p=0)
[   12.418825] pci 0000:00:1a.1: BAR 4: reserving [io  0x30c0-0x30df flags 0x40101] (d=0, p=0)
[   12.418830] pci 0000:00:1a.2: BAR 4: reserving [io  0x30a0-0x30bf flags 0x40101] (d=0, p=0)
[   12.418836] pci 0000:00:1a.7: BAR 0: reserving [mem 0xb1b22000-0xb1b223ff flags 0x40200] (d=0, p=0)
[   12.418845] pci 0000:0f:00.0: BAR 0: reserving [mem 0xb1940000-0xb1943fff flags 0x140204] (d=0, p=0)
[   12.418849] pci 0000:0f:00.0: BAR 2: reserving [io  0x1000-0x10ff flags 0x40101] (d=0, p=0)
[   12.418853] pci 0000:0f:00.0: BAR 3: reserving [mem 0xb1900000-0xb193ffff flags 0x140204] (d=0, p=0)
[   12.418862] pci 0000:10:00.0: BAR 0: reserving [mem 0xb0000000-0xb0ffffff flags 0x42208] (d=0, p=0)
[   12.418866] pci 0000:10:00.0: BAR 1: reserving [mem 0xb1800000-0xb1803fff flags 0x40200] (d=0, p=0)
[   12.418870] pci 0000:10:00.0: BAR 2: reserving [mem 0xb1000000-0xb17fffff flags 0x40200] (d=0, p=0)
[   12.418878] pci 0000:00:1d.0: BAR 4: reserving [io  0x3080-0x309f flags 0x40101] (d=0, p=0)
[   12.418884] pci 0000:00:1d.1: BAR 4: reserving [io  0x3060-0x307f flags 0x40101] (d=0, p=0)
[   12.418889] pci 0000:00:1d.2: BAR 4: reserving [io  0x3040-0x305f flags 0x40101] (d=0, p=0)
[   12.418895] pci 0000:00:1d.7: BAR 0: reserving [mem 0xb1b21000-0xb1b213ff flags 0x40200] (d=0, p=0)
[   12.418905] pci 0000:00:1f.2: BAR 0: reserving [io  0x3108-0x310f flags 0x40101] (d=0, p=0)
[   12.418909] pci 0000:00:1f.2: BAR 1: reserving [io  0x3114-0x3117 flags 0x40101] (d=0, p=0)
[   12.418913] pci 0000:00:1f.2: BAR 2: reserving [io  0x3100-0x3107 flags 0x40101] (d=0, p=0)
[   12.418917] pci 0000:00:1f.2: BAR 3: reserving [io  0x3110-0x3113 flags 0x40101] (d=0, p=0)
[   12.418921] pci 0000:00:1f.2: BAR 4: reserving [io  0x3020-0x303f flags 0x40101] (d=0, p=0)
[   12.418925] pci 0000:00:1f.2: BAR 5: reserving [mem 0xb1b20000-0xb1b207ff flags 0x40200] (d=0, p=0)
[   12.418931] pci 0000:00:1f.3: BAR 0: reserving [mem 0xb1b23000-0xb1b230ff flags 0x140204] (d=0, p=0)
[   12.418935] pci 0000:00:1f.3: BAR 4: reserving [io  0x3000-0x301f flags 0x40101] (d=0, p=0)
[   12.419129] e820: reserve RAM buffer [mem 0x0009b000-0x0009ffff]
[   12.419133] e820: reserve RAM buffer [mem 0x8c21b000-0x8fffffff]
[   12.420089] Switched to clocksource xen
[   12.420206] pnp: PnP ACPI init
[   12.420389] xen: registering gsi 8 triggering 1 polarity 0
[   12.420435] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   12.420526] system 00:01: [io  0x0500-0x057f] could not be reserved
[   12.420530] system 00:01: [io  0x0400-0x047f] could not be reserved
[   12.420534] system 00:01: [io  0x0800-0x081f] has been reserved
[   12.420538] system 00:01: [io  0x0ca2-0x0ca3] has been reserved
[   12.420541] system 00:01: [io  0x0600-0x061f] has been reserved
[   12.420544] system 00:01: [io  0x0880-0x0883] has been reserved
[   12.420548] system 00:01: [io  0x0ca4-0x0ca5] has been reserved
[   12.420552] system 00:01: [mem 0xfed1c000-0xfed3fffe] could not be reserved
[   12.420555] system 00:01: [mem 0xff000000-0xffffffff] could not be reserved
[   12.420559] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
[   12.420562] system 00:01: [mem 0xfe900000-0xfe90001f] has been reserved
[   12.420566] system 00:01: [mem 0xfea00000-0xfea0001f] has been reserved
[   12.420569] system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
[   12.420573] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[   12.420734] xen: registering gsi 3 triggering 1 polarity 0
[   12.420808] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[   12.420846] pnp 00:03: Plug and Play ACPI device, IDs PNP0c31 (active)
[   12.420890] pnp 00:04: Plug and Play ACPI device, IDs IPI0001 (active)
[   12.420929] pnp: PnP ACPI: found 5 devices
[   12.428765] PM-Timer failed consistency check  (0xffffff) - aborting.
[   12.428774] pci 0000:0f:00.0: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
[   12.428779] pci 0000:10:00.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
[   12.428922] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 0f] add_size 200000
[   12.428936] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 10] add_size 1000
[   12.428950] pci 0000:00:1c.5: bridge window [io  0x1000-0x0fff] to [bus 11] add_size 1000
[   12.428954] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 11] add_size 200000
[   12.428959] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff] to [bus 11] add_size 200000
[   12.428989] pci 0000:00:1f.0: BAR 13: [io  0x0400-0x047f] has bogus alignment
[   12.428994] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   12.428998] pci 0000:00:1c.5: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   12.429002] pci 0000:00:1c.5: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   12.429006] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   12.429010] pci 0000:00:1c.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   12.429019] pci 0000:00:1c.0: BAR 15: assigned [mem 0xb1c00000-0xb1dfffff 64bit pref]
[   12.429023] pci 0000:00:1c.5: BAR 14: assigned [mem 0xb1e00000-0xb1ffffff]
[   12.429029] pci 0000:00:1c.5: BAR 15: assigned [mem 0xb2000000-0xb21fffff 64bit pref]
[   12.429033] pci 0000:00:1c.4: BAR 13: assigned [io  0x4000-0x4fff]
[   12.429037] pci 0000:00:1c.5: BAR 13: assigned [io  0x5000-0x5fff]
[   12.429041] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[   12.429046] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[   12.429054] pci 0000:00:01.0:   bridge window [mem 0xb1a00000-0xb1afffff]
[   12.429065] pci 0000:00:03.0: PCI bridge to [bus 04]
[   12.429081] pci 0000:06:02.0: PCI bridge to [bus 07]
[   12.429102] pci 0000:06:04.0: PCI bridge to [bus 08]
[   12.429122] pci 0000:05:00.0: PCI bridge to [bus 06-08]
[   12.429143] pci 0000:00:05.0: PCI bridge to [bus 05-08]
[   12.429159] pci 0000:0a:02.0: PCI bridge to [bus 0b]
[   12.429179] pci 0000:0a:04.0: PCI bridge to [bus 0c]
[   12.429200] pci 0000:09:00.0: PCI bridge to [bus 0a-0c]
[   12.429221] pci 0000:00:07.0: PCI bridge to [bus 09-0c]
[   12.429237] pci 0000:00:09.0: PCI bridge to [bus 0d]
[   12.429252] pci 0000:00:0a.0: PCI bridge to [bus 0e]
[   12.429268] pci 0000:0f:00.0: BAR 6: assigned [mem 0xb1980000-0xb19fffff pref]
[   12.429272] pci 0000:00:1c.0: PCI bridge to [bus 0f]
[   12.429277] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[   12.429285] pci 0000:00:1c.0:   bridge window [mem 0xb1900000-0xb19fffff]
[   12.429291] pci 0000:00:1c.0:   bridge window [mem 0xb1c00000-0xb1dfffff 64bit pref]
[   12.429301] pci 0000:10:00.0: BAR 6: assigned [mem 0xb1810000-0xb181ffff pref]
[   12.429305] pci 0000:00:1c.4: PCI bridge to [bus 10]
[   12.429309] pci 0000:00:1c.4:   bridge window [io  0x4000-0x4fff]
[   12.429317] pci 0000:00:1c.4:   bridge window [mem 0xb1000000-0xb18fffff]
[   12.429323] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[   12.429333] pci 0000:00:1c.5: PCI bridge to [bus 11]
[   12.429337] pci 0000:00:1c.5:   bridge window [io  0x5000-0x5fff]
[   12.429345] pci 0000:00:1c.5:   bridge window [mem 0xb1e00000-0xb1ffffff]
[   12.429351] pci 0000:00:1c.5:   bridge window [mem 0xb2000000-0xb21fffff 64bit pref]
[   12.429361] pci 0000:00:1e.0: PCI bridge to [bus 12]
[   12.429378] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   12.429381] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   12.429384] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   12.429387] pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfedfffff]
[   12.429390] pci_bus 0000:00: resource 8 [mem 0xb0000000-0xfdffffff]
[   12.429394] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[   12.429397] pci_bus 0000:01: resource 1 [mem 0xb1a00000-0xb1afffff]
[   12.429401] pci_bus 0000:0f: resource 0 [io  0x1000-0x1fff]
[   12.429404] pci_bus 0000:0f: resource 1 [mem 0xb1900000-0xb19fffff]
[   12.429407] pci_bus 0000:0f: resource 2 [mem 0xb1c00000-0xb1dfffff 64bit pref]
[   12.429410] pci_bus 0000:10: resource 0 [io  0x4000-0x4fff]
[   12.429413] pci_bus 0000:10: resource 1 [mem 0xb1000000-0xb18fffff]
[   12.429416] pci_bus 0000:10: resource 2 [mem 0xb0000000-0xb0ffffff 64bit pref]
[   12.429420] pci_bus 0000:11: resource 0 [io  0x5000-0x5fff]
[   12.429423] pci_bus 0000:11: resource 1 [mem 0xb1e00000-0xb1ffffff]
[   12.429426] pci_bus 0000:11: resource 2 [mem 0xb2000000-0xb21fffff 64bit pref]
[   12.429429] pci_bus 0000:12: resource 4 [io  0x0000-0x0cf7]
[   12.429432] pci_bus 0000:12: resource 5 [io  0x0d00-0xffff]
[   12.429435] pci_bus 0000:12: resource 6 [mem 0x000a0000-0x000bffff]
[   12.429439] pci_bus 0000:12: resource 7 [mem 0xfed40000-0xfedfffff]
[   12.429442] pci_bus 0000:12: resource 8 [mem 0xb0000000-0xfdffffff]
[   12.429446] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[   12.429449] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]
[   12.429453] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[   12.429456] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[   12.429484] NET: Registered protocol family 2
[   12.429647] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[   12.430009] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   12.430176] TCP: Hash tables configured (established 262144 bind 65536)
[   12.430206] TCP: reno registered
[   12.430213] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[   12.430308] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[   12.430441] NET: Registered protocol family 1
[   12.430630] RPC: Registered named UNIX socket transport module.
[   12.430634] RPC: Registered udp transport module.
[   12.430636] RPC: Registered tcp transport module.
[   12.430638] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   12.430703] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x7a0
[   12.430866] xen: registering gsi 19 triggering 0 polarity 1
[   12.430883] xen: --> pirq=19 -> irq=19 (gsi=19)
[   12.431033] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x7a0
[   12.431130] xen: registering gsi 19 triggering 0 polarity 1
[   12.431134] Already setup the GSI :19
[   12.431255] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x7a0
[   12.431351] xen: registering gsi 19 triggering 0 polarity 1
[   12.431354] Already setup the GSI :19
[   12.431474] pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x7a0
[   12.431572] xen: registering gsi 19 triggering 0 polarity 1
[   12.431576] Already setup the GSI :19
[   12.431810] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x7a0
[   12.431931] xen: registering gsi 16 triggering 0 polarity 1
[   12.431940] xen: --> pirq=16 -> irq=16 (gsi=16)
[   12.432099] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x7a0
[   12.432198] xen: registering gsi 16 triggering 0 polarity 1
[   12.432202] Already setup the GSI :16
[   12.432322] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x7a0
[   12.432418] xen: registering gsi 16 triggering 0 polarity 1
[   12.432422] Already setup the GSI :16
[   12.432542] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x7a0
[   12.432640] xen: registering gsi 16 triggering 0 polarity 1
[   12.432644] Already setup the GSI :16
[   12.432882] pci 0000:01:00.0: calling quirk_e100_interrupt+0x0/0x200
[   12.432890] pci 0000:01:00.1: calling quirk_e100_interrupt+0x0/0x200
[   12.432915] pci 0000:10:00.0: calling pci_fixup_video+0x0/0xd0
[   12.432923] pci 0000:10:00.0: Video device with shadowed ROM
[   12.433012] PCI: CLS 64 bytes, default 64
[   12.433060] Unpacking initramfs...
[   12.445631] Freeing initrd memory: 15028K (ffff880008000000 - ffff880008ead000)
[   12.446333] Scanning for low memory corruption every 60 seconds
[   12.446672] futex hash table entries: 2048 (order: 5, 131072 bytes)
[   12.448717] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   12.449070] NFS: Registering the id_resolver key type
[   12.449084] Key type id_resolver registered
[   12.449087] Key type id_legacy registered
[   12.449093] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   12.449149] ntfs: driver 2.1.31 [Flags: R/O].
[   12.449316] fuse init (API version 7.23)
[   12.449490] SGI XFS with ACLs, security attributes, realtime, no debug enabled
[   12.450185] bounce: pool size: 64 pages
[   12.450217] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[   12.450223] io scheduler noop registered
[   12.450226] io scheduler deadline registered (default)
[   12.450252] io scheduler cfq registered
[   12.450528] xen: registering gsi 28 triggering 0 polarity 1
[   12.450548] xen: --> pirq=28 -> irq=28 (gsi=28)
[   12.450817] xen: registering gsi 24 triggering 0 polarity 1
[   12.450826] xen: --> pirq=24 -> irq=24 (gsi=24)
[   12.451077] xen: registering gsi 26 triggering 0 polarity 1
[   12.451087] xen: --> pirq=26 -> irq=26 (gsi=26)
[   12.451332] xen: registering gsi 30 triggering 0 polarity 1
[   12.451341] xen: --> pirq=30 -> irq=30 (gsi=30)
[   12.451587] xen: registering gsi 32 triggering 0 polarity 1
[   12.451597] xen: --> pirq=32 -> irq=32 (gsi=32)
[   12.451842] xen: registering gsi 33 triggering 0 polarity 1
[   12.451852] xen: --> pirq=33 -> irq=33 (gsi=33)
[   12.452117] xen: registering gsi 16 triggering 0 polarity 1
[   12.452122] Already setup the GSI :16
[   12.452371] xen: registering gsi 16 triggering 0 polarity 1
[   12.452376] Already setup the GSI :16
[   12.452623] xen: registering gsi 17 triggering 0 polarity 1
[   12.452633] xen: --> pirq=17 -> irq=17 (gsi=17)
[   12.453680] aer 0000:00:01.0:pcie02: service driver aer loaded
[   12.453720] aer 0000:00:03.0:pcie02: service driver aer loaded
[   12.453771] aer 0000:00:05.0:pcie02: service driver aer loaded
[   12.453822] aer 0000:00:07.0:pcie02: service driver aer loaded
[   12.453859] aer 0000:00:09.0:pcie02: service driver aer loaded
[   12.453894] aer 0000:00:0a.0:pcie02: service driver aer loaded
[   12.453916] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[   12.453920] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[   12.453923] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[   12.453929] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[   12.453941] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[   12.453947] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[   12.453959] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[   12.453962] pcieport 0000:05:00.0: Signaling PME through PCIe PME interrupt
[   12.453965] pcieport 0000:06:02.0: Signaling PME through PCIe PME interrupt
[   12.453968] pcieport 0000:06:04.0: Signaling PME through PCIe PME interrupt
[   12.453975] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[   12.453986] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[   12.453989] pcieport 0000:09:00.0: Signaling PME through PCIe PME interrupt
[   12.453992] pcieport 0000:0a:02.0: Signaling PME through PCIe PME interrupt
[   12.453995] pcieport 0000:0a:04.0: Signaling PME through PCIe PME interrupt
[   12.454002] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[   12.454013] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[   12.454020] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[   12.454031] pcieport 0000:00:0a.0: Signaling PME through PCIe PME interrupt
[   12.454037] pcie_pme 0000:00:0a.0:pcie01: service driver pcie_pme loaded
[   12.454067] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[   12.454071] pci 0000:0f:00.0: Signaling PME through PCIe PME interrupt
[   12.454078] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[   12.454107] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[   12.454111] pci 0000:10:00.0: Signaling PME through PCIe PME interrupt
[   12.454118] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[   12.454145] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[   12.454153] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[   12.454258] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[   12.454265] ACPI: Sleep Button [SLPB]
[   12.454298] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   12.454302] ACPI: Power Button [PWRF]
[   12.454552] Monitor-Mwait will be used to enter C-1 state
[   12.454585] Monitor-Mwait will be used to enter C-3 state
[   12.457815] Warning: Processor Platform Limit not supported.
[   12.459017] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   12.479621] 00:02: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   12.480205] hpet_acpi_add: no address or irqs in _CRS
[   12.480288] Non-volatile memory driver v1.3
[   12.480293] Linux agpgart interface v0.103
[   12.480467] ahci 0000:00:1f.2: version 3.0
[   12.480577] xen: registering gsi 18 triggering 0 polarity 1
[   12.480588] xen: --> pirq=18 -> irq=18 (gsi=18)
[   12.480634] ahci 0000:00:1f.2: forcing PORTS_IMPL to 0x3f
[   12.480866] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   12.480872] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[   12.482851] scsi host0: ahci
[   12.483112] scsi host1: ahci
[   12.483290] scsi host2: ahci
[   12.483391] scsi host3: ahci
[   12.483491] scsi host4: ahci
[   12.483589] scsi host5: ahci
[   12.483626] ata1: SATA max UDMA/133 abar m2048@0xb1b20000 port 0xb1b20100 irq 121
[   12.483631] ata2: SATA max UDMA/133 abar m2048@0xb1b20000 port 0xb1b20180 irq 122
[   12.483635] ata3: SATA max UDMA/133 abar m2048@0xb1b20000 port 0xb1b20200 irq 123
[   12.483638] ata4: SATA max UDMA/133 abar m2048@0xb1b20000 port 0xb1b20280 irq 124
[   12.483642] ata5: SATA max UDMA/133 abar m2048@0xb1b20000 port 0xb1b20300 irq 125
[   12.483646] ata6: SATA max UDMA/133 abar m2048@0xb1b20000 port 0xb1b20380 irq 126
[   12.483727] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   12.483730] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[   12.483763] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
[   12.483766] igb: Copyright (c) 2007-2014 Intel Corporation.
[   12.483817] xen: registering gsi 40 triggering 0 polarity 1
[   12.483828] xen: --> pirq=40 -> irq=40 (gsi=40)
[   12.508671] igb 0000:01:00.0: PHY reset is blocked due to SOL/IDER session.
[   12.556882] igb 0000:01:00.0: added PHC on eth0
[   12.556891] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[   12.556899] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:15:17:da:f9:e4
[   12.556906] igb 0000:01:00.0: eth0: PBA No: Unknown
[   12.556912] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   12.556977] xen: registering gsi 28 triggering 0 polarity 1
[   12.556982] Already setup the GSI :28
[   12.904977] igb 0000:01:00.1: added PHC on eth1
[   12.904986] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[   12.904994] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:15:17:da:f9:e5
[   12.905001] igb 0000:01:00.1: eth1: PBA No: Unknown
[   12.905007] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   12.905049] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.2-k
[   12.905055] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[   12.905081] sky2: driver version 1.30
[   12.905707] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   12.905718] ehci-pci: EHCI PCI platform driver
[   12.905848] xen: registering gsi 19 triggering 0 polarity 1
[   12.905853] Already setup the GSI :19
[   12.905882] ehci-pci 0000:00:1a.7: enabling bus mastering
[   12.905904] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   12.905913] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   12.905933] ehci-pci 0000:00:1a.7: debug port 1
[   12.910105] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[   12.910155] ehci-pci 0000:00:1a.7: irq 19, io mem 0xb1b22000
[   12.920161] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   12.920801] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   12.920810] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.920818] usb usb1: Product: EHCI Host Controller
[   12.920824] usb usb1: Manufacturer: Linux 3.19.0-1.olh.4-kernel-linux-3_19 ehci_hcd
[   12.920830] usb usb1: SerialNumber: 0000:00:1a.7
[   12.921222] hub 1-0:1.0: USB hub found
[   12.921323] hub 1-0:1.0: 6 ports detected
[   12.922365] xen: registering gsi 16 triggering 0 polarity 1
[   12.922370] Already setup the GSI :16
[   12.922390] ehci-pci 0000:00:1d.7: enabling bus mastering
[   12.922412] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   12.922419] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   12.922437] ehci-pci 0000:00:1d.7: debug port 1
[   12.926493] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[   12.926543] ehci-pci 0000:00:1d.7: irq 16, io mem 0xb1b21000
[   12.936161] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   12.936778] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   12.936788] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.936796] usb usb2: Product: EHCI Host Controller
[   12.936801] usb usb2: Manufacturer: Linux 3.19.0-1.olh.4-kernel-linux-3_19 ehci_hcd
[   12.936808] usb usb2: SerialNumber: 0000:00:1d.7
[   12.937290] hub 2-0:1.0: USB hub found
[   12.937383] hub 2-0:1.0: 6 ports detected
[   12.938197] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   12.938219] ohci-pci: OHCI PCI platform driver
[   12.938238] uhci_hcd: USB Universal Host Controller Interface driver
[   12.938356] xen: registering gsi 19 triggering 0 polarity 1
[   12.938361] Already setup the GSI :19
[   12.938371] uhci_hcd 0000:00:1a.0: enabling bus mastering
[   12.938380] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   12.938387] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   12.938418] uhci_hcd 0000:00:1a.0: irq 19, io base 0x000030e0
[   12.939007] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   12.939017] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.939025] usb usb3: Product: UHCI Host Controller
[   12.939031] usb usb3: Manufacturer: Linux 3.19.0-1.olh.4-kernel-linux-3_19 uhci_hcd
[   12.939037] usb usb3: SerialNumber: 0000:00:1a.0
[   12.939371] hub 3-0:1.0: USB hub found
[   12.939467] hub 3-0:1.0: 2 ports detected
[   12.939926] xen: registering gsi 19 triggering 0 polarity 1
[   12.939931] Already setup the GSI :19
[   12.939942] uhci_hcd 0000:00:1a.1: enabling bus mastering
[   12.939950] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   12.939957] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   12.939988] uhci_hcd 0000:00:1a.1: irq 19, io base 0x000030c0
[   12.940623] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   12.940632] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.940639] usb usb4: Product: UHCI Host Controller
[   12.940645] usb usb4: Manufacturer: Linux 3.19.0-1.olh.4-kernel-linux-3_19 uhci_hcd
[   12.940651] usb usb4: SerialNumber: 0000:00:1a.1
[   12.940975] hub 4-0:1.0: USB hub found
[   12.941067] hub 4-0:1.0: 2 ports detected
[   12.941600] xen: registering gsi 19 triggering 0 polarity 1
[   12.941606] Already setup the GSI :19
[   12.941616] uhci_hcd 0000:00:1a.2: enabling bus mastering
[   12.941625] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   12.941631] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   12.941662] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000030a0
[   12.942240] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   12.942249] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.942256] usb usb5: Product: UHCI Host Controller
[   12.942262] usb usb5: Manufacturer: Linux 3.19.0-1.olh.4-kernel-linux-3_19 uhci_hcd
[   12.942269] usb usb5: SerialNumber: 0000:00:1a.2
[   12.942596] hub 5-0:1.0: USB hub found
[   12.942698] hub 5-0:1.0: 2 ports detected
[   12.943210] xen: registering gsi 16 triggering 0 polarity 1
[   12.943215] Already setup the GSI :16
[   12.943226] uhci_hcd 0000:00:1d.0: enabling bus mastering
[   12.943234] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   12.943241] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   12.943272] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00003080
[   12.943785] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   12.943794] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.943801] usb usb6: Product: UHCI Host Controller
[   12.943807] usb usb6: Manufacturer: Linux 3.19.0-1.olh.4-kernel-linux-3_19 uhci_hcd
[   12.943813] usb usb6: SerialNumber: 0000:00:1d.0
[   12.944055] hub 6-0:1.0: USB hub found
[   12.944120] hub 6-0:1.0: 2 ports detected
[   12.944418] xen: registering gsi 16 triggering 0 polarity 1
[   12.944423] Already setup the GSI :16
[   12.944433] uhci_hcd 0000:00:1d.1: enabling bus mastering
[   12.944442] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   12.944448] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   12.944479] uhci_hcd 0000:00:1d.1: irq 16, io base 0x00003060
[   12.944725] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   12.944730] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.944734] usb usb7: Product: UHCI Host Controller
[   12.944737] usb usb7: Manufacturer: Linux 3.19.0-1.olh.4-kernel-linux-3_19 uhci_hcd
[   12.944740] usb usb7: SerialNumber: 0000:00:1d.1
[   12.944879] hub 7-0:1.0: USB hub found
[   12.944897] hub 7-0:1.0: 2 ports detected
[   12.945119] xen: registering gsi 16 triggering 0 polarity 1
[   12.945124] Already setup the GSI :16
[   12.945134] uhci_hcd 0000:00:1d.2: enabling bus mastering
[   12.945143] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   12.945149] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   12.945180] uhci_hcd 0000:00:1d.2: irq 16, io base 0x00003040
[   12.945303] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   12.945307] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.945311] usb usb8: Product: UHCI Host Controller
[   12.945314] usb usb8: Manufacturer: Linux 3.19.0-1.olh.4-kernel-linux-3_19 uhci_hcd
[   12.945317] usb usb8: SerialNumber: 0000:00:1d.2
[   12.945422] hub 8-0:1.0: USB hub found
[   12.945438] hub 8-0:1.0: 2 ports detected
[   12.945585] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   13.508160] ata6: failed to resume link (SControl 0)
[   13.508174] ata6: SATA link down (SStatus 0 SControl 0)
[   13.508185] ata5: failed to resume link (SControl 0)
[   13.508200] ata5: SATA link down (SStatus 0 SControl 0)
[   13.508210] ata2: failed to resume link (SControl 0)
[   13.508224] ata2: SATA link down (SStatus 0 SControl 0)
[   13.508235] ata1: failed to resume link (SControl 0)
[   13.508248] ata1: SATA link down (SStatus 0 SControl 0)
[   13.512137] ata3: failed to resume link (SControl 0)
[   13.512150] ata3: SATA link down (SStatus 0 SControl 0)
[   13.983000] i8042: No controller found
[   13.983128] mousedev: PS/2 mouse device common for all mice
[   13.983440] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   13.983548] rtc_cmos 00:00: RTC can wake from S4
[   13.983730] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   13.983795] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram
[   13.983851] device-mapper: uevent: version 1.0.3
[   13.983964] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised: dm-devel@redhat.com
[   13.984132] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   13.984441] hidraw: raw HID events driver (C) Jiri Kosina
[   13.984535] usbcore: registered new interface driver usbhid
[   13.984538] usbhid: USB HID core driver
[   13.984606] TCP: cubic registered
[   13.984611] NET: Registered protocol family 17
[   13.984636] Key type dns_resolver registered
[   13.984816] mce: Unable to init device /dev/mcelog (rc: -16)
[   13.985127] registered taskstats version 1
[   13.985526] Btrfs loaded
[   13.986726] rtc_cmos 00:00: setting system clock to 2015-02-26 09:15:25 UTC (1424942125)
[   13.987066] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[   14.096150] usb 5-1: new full-speed USB device number 2 using uhci_hcd
[   14.118667] usb 2-1: New USB device found, idVendor=05e3, idProduct=0719
[   14.118677] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[   14.118685] usb 2-1: Product: USB Storage
[   14.118691] usb 2-1: SerialNumber: 000000000033
[   14.188128] ata4: failed to resume link (SControl 0)
[   14.188144] ata4: SATA link down (SStatus 0 SControl 0)
[   14.188949] Freeing unused kernel memory: 980K (ffffffff81c88000 - ffffffff81d7d000)
[   14.188954] Write protecting the kernel read-only data: 12288k
[   14.192630] Freeing unused kernel memory: 512K (ffff880001780000 - ffff880001800000)
[   14.193371] Freeing unused kernel memory: 1412K (ffff880001a9f000 - ffff880001c00000)
[   14.259173] usb 5-1: New USB device found, idVendor=046b, idProduct=ff10
[   14.259179] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.259220] usb 5-1: Product: Virtual Keyboard and Mouse
[   14.259224] usb 5-1: Manufacturer: American Megatrends Inc.
[   14.259227] usb 5-1: SerialNumber: serial
[   14.268512] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.0/0003:046B:FF10.0001/input/input3
[   14.274557] Fusion MPT base driver 3.04.20
[   14.274561] Copyright (c) 1999-2008 LSI Corporation
[   14.275086] Fusion MPT SAS Host driver 3.04.20
[   14.275171] xen: registering gsi 16 triggering 0 polarity 1
[   14.275179] Already setup the GSI :16
[   14.275572] mptbase: ioc0: Initiating bringup
[   14.324618] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-1/input0
[   14.331418] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.1/0003:046B:FF10.0002/input/input4
[   14.331999] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-1/input1
[   14.840156] ioc0: LSISAS1078 C2: Capabilities={Initiator}
[   27.642157] scsi host6: ioc0: LSISAS1078 C2, FwRev=011b0000h, Ports=1, MaxQ=276, IRQ=16
[   27.646025] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x1221000000000000
[   27.649048] scsi 6:0:0:0: Direct-Access     ATA      ST9500530NS      SN04 PQ: 0 ANSI: 5
[   27.653154] sd 6:0:0:0: Attached scsi generic sg0 type 0
[   27.653658] sd 6:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   27.696853] sd 6:0:0:0: [sda] Write Protect is off
[   27.696863] sd 6:0:0:0: [sda] Mode Sense: 73 00 00 08
[   27.699093] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.640171] mptbase: ioc0: WARNING - IOC is in FAULT state (2650h)!!!
[   28.640192] mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
[   28.640200] mptbase: ioc0: Initiating recovery
[   28.640205] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[   28.640210] mptbase: ioc0: WARNING -            FAULT code = 2650h
[   29.652187] random: nonblocking pool is initialized
[   29.652228] mptbase: ioc0: Recovered from IOC FAULT
[   42.812187] mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
[   43.812208] mptbase: ioc0: WARNING - IOC is in FAULT state (2650h)!!!
[   43.812230] mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
[   43.812237] mptbase: ioc0: Initiating recovery
[   43.812243] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[   43.812248] mptbase: ioc0: WARNING -            FAULT code = 2650h
[   44.824221] mptbase: ioc0: Recovered from IOC FAULT
[   57.984184] mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
[   58.071817]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
[   58.984213] mptbase: ioc0: WARNING - IOC is in FAULT state (2650h)!!!
[   58.984235] mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
[   58.984242] mptbase: ioc0: Initiating recovery
[   58.984248] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[   58.984253] mptbase: ioc0: WARNING -            FAULT code = 2650h
[   58.992314] sd 6:0:0:0: [sda] Attached SCSI disk
[   59.014792] xen_netfront: Initialising Xen virtual ethernet driver
[   59.031055] udev: starting version 147
[   59.996173] mptbase: ioc0: Recovered from IOC FAULT
[   73.156175] mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
[   74.527625] kjournald starting.  Commit interval 5 seconds
[   74.528407] EXT3-fs (sda6): using internal journal
[   74.528415] EXT3-fs (sda6): mounted filesystem with ordered data mode
[   76.439768] udev: starting version 147
[   76.846334] i7core_edac: Unknown symbol edac_mc_del_mc (err 0)
[   76.846363] i7core_edac: Unknown symbol edac_mc_add_mc (err 0)
[   76.846370] i7core_edac: Unknown symbol edac_pci_create_generic_ctl (err 0)
[   76.846374] i7core_edac: Unknown symbol edac_mc_alloc (err 0)
[   76.846379] i7core_edac: Unknown symbol edac_mc_free (err 0)
[   76.846385] i7core_edac: Unknown symbol edac_mc_handle_error (err 0)
[   76.846400] i7core_edac: Unknown symbol edac_pci_release_generic_ctl (err 0)
[   76.872878] xen: registering gsi 18 triggering 0 polarity 1
[   76.872892] Already setup the GSI :18
[   76.872979] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   76.874324] tpm_tis 00:03: 1.2 TPM (device-id 0x0, rev-id 78)
[   76.927458] usb-storage 2-1:1.0: USB Mass Storage device detected
[   76.932177] tpm_tis 00:03: TPM is disabled/deactivated (0x6)
[   76.939629] scsi host7: usb-storage 2-1:1.0
[   76.939726] usbcore: registered new interface driver usb-storage
[   77.245197] NET: Registered protocol family 10
[   77.942398] scsi 7:0:0:0: CD-ROM            TEAC     DV-W28S-V        1.0A PQ: 0 ANSI: 0
[   77.948083] sr 7:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   77.948089] cdrom: Uniform CD-ROM driver Revision: 3.20
[   77.948209] sr 7:0:0:0: Attached scsi CD-ROM sr0
[   77.948335] sr 7:0:0:0: Attached scsi generic sg1 type 5
[   78.406855] Adding 2096476k swap on /dev/sda2.  Priority:-1 extents:1 across:2096476k 
[   81.419237] loop: module loaded
[   82.206637] kjournald starting.  Commit interval 5 seconds
[   82.207201] EXT3-fs (sda5): mounted filesystem with ordered data mode
[   82.242551] kjournald starting.  Commit interval 5 seconds
[   82.243046] EXT3-fs (sda7): using internal journal
[   82.243055] EXT3-fs (sda7): mounted filesystem with ordered data mode
[   91.412400] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   91.412673] igb 0000:01:00.0 eth0: igb: eth0 NIC Link is Up 10 Mbps Full Duplex, Flow Control: None
[   91.412911] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   93.832257] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   93.845779] device eth0 entered promiscuous mode
[   93.852705] br0: port 1(eth0) entered forwarding state
[   93.852710] br0: port 1(eth0) entered forwarding state
[  145.495887] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  145.554864] Unable to load target_core_user
[  145.661446] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
[  145.661468] IP: [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
[  145.661475] PGD 64121a067 PUD 6427e1067 PMD 0 
[  145.661479] Oops: 0000 [#1] SMP 
[  145.661482] Modules linked in: target_core_pscsi target_core_file target_core_iblock xen_scsiback target_core_mod bridge stp llc loop ipv6 usb_storage tpm_tis i2c_i801 joydev tpm xen_blkfront xen_netfront mptsas mptscsih mptbase scsi_transport_sas
[  145.661503] CPU: 6 PID: 5930 Comm: cat Not tainted 3.19.0-1.olh.4-kernel-linux-3_19 #1
[  145.661507] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
[  145.661512] task: ffff88063b8f0760 ti: ffff88063d740000 task.ti: ffff88063d740000
[  145.661515] RIP: e030:[<ffffffffa024f17b>]  [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
[  145.661521] RSP: e02b:ffff88063d743e48  EFLAGS: 00010292
[  145.661524] RAX: 0000000000000000 RBX: ffff8800080b9000 RCX: ffff88000809a5a8
[  145.661527] RDX: ffff8800080b9000 RSI: ffff8800080b9000 RDI: ffff88000809a000
[  145.661530] RBP: ffff88063d743e48 R08: ffffffffa01fd390 R09: 0000000000000000
[  145.661533] R10: 0000000000000000 R11: 0000000000000100 R12: ffff880641e7b1e0
[  145.661536] R13: ffffffffa020ed40 R14: ffffffffa020fc20 R15: ffff88000809a6f8
[  145.661543] FS:  00007f8e447a5700(0000) GS:ffff88064b780000(0000) knlGS:0000000000000000
[  145.661546] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  145.661549] CR2: 00000000000000a8 CR3: 000000063d753000 CR4: 0000000000002660
[  145.661552] Stack:
[  145.661554]  ffff88063d743e68 ffffffffa01fd3b0 ffff88063d743e68 fffffffffffffff4
[  145.661559]  ffff88063d743e78 ffffffffa01fcd48 ffff88063d743ed8 ffffffff811a90a5
[  145.661563]  000000002c495760 ffff88063d743f48 0000000000008000 000000000060d000
[  145.661568] Call Trace:
[  145.661579]  [<ffffffffa01fd3b0>] target_stat_scsi_lu_show_attr_dev_type+0x20/0x50 [target_core_mod]
[  145.661586]  [<ffffffffa01fcd48>] target_stat_scsi_lu_attr_show+0x28/0x30 [target_core_mod]
[  145.661593]  [<ffffffff811a90a5>] configfs_read_file+0x75/0x110
[  145.661598]  [<ffffffff8113b3d3>] __vfs_read+0x13/0x60
[  145.661602]  [<ffffffff8113cd4e>] vfs_read+0xae/0x120
[  145.661606]  [<ffffffff8113cec4>] SyS_read+0x54/0xb0
[  145.661611]  [<ffffffff81778f29>] system_call_fastpath+0x12/0x17
[  145.661614] Code: 0f 84 22 ff ff ff 80 fa 2a 0f 1f 80 00 00 00 00 0f 85 16 ff ff ff 66 90 e9 0b ff ff ff 0f 1f 00 48 8b 87 90 0e 00 00 55 48 89 e5 <0f> be 80 a8 00 00 00 c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 
[  145.661648] RIP  [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
[  145.661653]  RSP <ffff88063d743e48>
[  145.661655] CR2: 00000000000000a8
[  145.661658] ---[ end trace 73b5dd612a58996d ]---
root@satriani:~ #


Olaf
