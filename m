From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [ANNOUNCE] TCM based Open-FCOE.org target fabric module
Date: Fri, 19 Mar 2010 19:41:45 -0700
Message-ID: <1269052905.23779.97.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, openfcoe-devel <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Florian Haas <florian.haas-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Greetings all,

It is my great pleasure to announce that the Open-FCoE.org based TCM fabric
module (tcm_fc) has been merged into lio-core-2.6.git/master.

As of LIO v3.4.0-rc1, 100% of logic for v3.x TCM Persistent Reservations and ALUA is
running across iSCSI, FCoE and Virtual SAS based LUNs.

This would not have been possible without the tremendous contributions by Joe Eykholt
with his work to tcm_fc and libfc.  Thank you Joe!

The initial wiki entry has been added with details and a simple howto.

http://www.linux-iscsi.org/index.php/Openfcoe

Alow included below is the entry including sg_inq -i, sg_persist -c and
sg_rtpg output from a TCM based FCoE Target LUN.

Any constructive comments or questions are welcome!

--nab

Contents
[hide]
      * 1 Description
      * 2 Control interface
      * 3 Source
      * 4 What does a running example look like..?
      * 5 Open-FCoE Initiator
[edit] Description 
The tcm_fc fabric module is based on the open-fcoe.org target code and
has been modified to run using a modified upstream Linux libfc module.

This includes a patch series to reenable Point to Point module for libfc
(which have been merged upstream), and a set of hooks into libfc to be
able to hand off incoming FLOGI requests to FC based target modules.


[edit] Control interface 
The tcm_fc fabric module is using the configfs interface
in /sys/kernel/config/target/fc. Note that there is NO strict open-fcoe
userspace code requirement in order to get up and running.


[edit] Source 
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=tree;f=drivers/target/tcm_fc;hb=HEAD


[edit] What does a running example look like..? 

 *) Configure using configfs
# Create the '20:00:' prefixed FCoE Lport from network inteface eth0
 mkdir -p /sys/kernel/config/target/fc/20:00:00:e0:81:c0:90:b3/tpgt_1/lun/lun_0
 # Chdir and create tcm_fc_port from TCM FILEIO object
 cd /sys/kernel/config/target/fc/20\:00\:00\:e0\:81\:c0\:90\:b3/tpgt_1/lun/lun_0/
 ln -s /sys/kernel/config/target/core/fileio_0/myfile/ tcm_fc_port
 # Chdir and created '20:00' prefixed Initiator WWPN from it's own network interface
 cd ../../ ; mkdir -p acl/20:00:00:e0:81:c0:90:b2/lun_0 ; cd acl/20\:00\:00\:e0\:81\:c0\:90\:b2/lun_0
 # Create explict MappedLUN=0 for NodeACl to TPG LUN 0
 ln -s /sys/kernel/config/target/fc/20\:00\:00\:e0\:81\:c0\:90\:b3/tpgt_1/lun/lun_0/ lun_0

*) Here is what a running configuration looks like from /sys/kernel/config/target/fc/

target# tree /sys/kernel/config/target/fc/
 /sys/kernel/config/target/fc/
 |-- 20:00:00:e0:81:c0:90:b3
 |   `-- tpgt_1
 |       |-- acl
 |       |   `-- 20:00:00:e0:81:c0:90:b2
 |       |       |-- auth
 |       |       |   |-- node_name
 |       |       |   `-- port_name
 |       |       `-- lun_0
 |       |           `-- lun_0 -> ../../../../../../../target/fc/20:00:00:e0:81:c0:90:b3/tpgt_1/lun/lun_0
 |       `-- lun
 |           `-- lun_0
 |               |-- alua_tg_pt_gp
 |               |-- alua_tg_pt_offline
 |               |-- alua_tg_pt_status
 |               |-- alua_tg_pt_write_md
 |               `-- tcm_fc_port -> ../../../../../../target/core/fileio_0/myfile
 `-- version
 10 directories, 7 files


*) dmesg output

 [  176.370130] <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
 [  176.371205] Initialized struct target_fabric_configfs: ffff88003787b800 for fc
 [  176.372739] <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
 [  180.529964] Target_Core_ConfigFS: REGISTER -> group: ffffffffa02b9480 name: fc
 [  180.531086] Target_Core_ConfigFS: REGISTER -> Located fabric: fc
 [  180.531803] Target_Core_ConfigFS: REGISTER -> ffffffffa0366f70
 [  180.532506] Target_Core_ConfigFS: REGISTER -> Allocated Fabric: fc
 [  180.532921] Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric for fc
 [  180.532921] TARGET_CORE[fc]: Allocated Normal se_portal_group_t for endpoint: 20:00:00:e0:81:c0:90:b3, Portal Tag: 1
 [  188.053789] fileio/fc: Adding to default ALUA Target Port Group: alua/default_tg_pt_gp
 [  188.054913] fc_TPG[1]_LUN[0] - Activated fc Logical Unit from CORE HBA: 1
 [  211.862437] fc_TPG[1] - Added ACL with TCQ Depth: 32 for fc Initiator Node: 20:00:00:e0:81:c0:90:b2
 [  219.960620] fc_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: 20:00:00:e0:81:c0:90:b2

*) Next, load the fcoe module and create an association to the matching
LPORT interface configured with tcm_fc:

modprobe fcoe ; echo eth0 > /sys/module/fcoe/parameters/create

you should see something like the following in the target side kernel
ring buffer:

 [  469.432122] device eth0 entered promiscuous mode
 [  469.433179] scsi0 : FCoE Driver
 [  469.435336] host0: libfc: Link up on port (     0)

and the target will be configured!


[edit] Open-FCoE Initiator 
Now we are ready to connect from an Open-FCOE Initiator. Remember that
in order to run the Initiator in Point to Point mode, the necessary
patches to libfc are also required. Just as on the target side, load the
fcoe module and create the association to the network interface on the
initiator capable of communication with the LPORT network interface
configured above:

modprobe fcoe ; echo eth0 > /sys/module/fcoe/parameters/create

After a few seconds, the FCoE LUNs will be detected and registered with
Linux/SCSI.. Here is what that output looks like on the Open-FCOE
initiator side:

 [  853.183484] device eth0 entered promiscuous mode
 [  853.184640] scsi0 : FCoE Driver
 [  853.186064] host0: libfc: Link up on port (     0)
 [  856.754764] host0: Assigned Port ID  10101
 [  856.758376] scsi 0:0:0:0: Direct-Access     LIO-ORG  FILEIO           3.1  PQ: 0 ANSI: 5
 [  856.818511] sd 0:0:0:0: [sda] READ CAPACITY(16) failed
 [  856.819201] sd 0:0:0:0: [sda] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
 [  856.820127] sd 0:0:0:0: [sda] Sense not available.
 [  856.820964] sd 0:0:0:0: [sda] 97656251 512-byte logical blocks: (50.0 GB/46.5 GiB)
 [  856.822580] sd 0:0:0:0: [sda] Write Protect is off
 [  856.823230] sd 0:0:0:0: [sda] Mode Sense: 2f 00 00 00
 [  856.823640] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 [  856.825018] sd 0:0:0:0: [sda] READ CAPACITY(16) failed
 [  856.825688] sd 0:0:0:0: [sda] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
 [  856.826620] sd 0:0:0:0: [sda] Sense not available.
 [  856.828304]  sda: unknown partition table
 [  856.830403] sd 0:0:0:0: [sda] READ CAPACITY(16) failed
 [  856.831109] sd 0:0:0:0: [sda] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
 [  856.832039] sd 0:0:0:0: [sda] Sense not available.
 [  856.833689] sd 0:0:0:0: [sda] Attached SCSI disk
 [  857.186393] ------------[ cut here ]------------
 [  857.187054] WARNING: at drivers/scsi/libfc/fc_lport.c:1370 fc_lport_timeout+0x49/0x87 [libfc]()
 [  857.188144] Hardware name: 
 [  857.191292] Modules linked in: sd_mod crc_t10dif fcoe libfcoe libfc scsi_transport_fc scsi_tgt ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_multipath dm_mod scsi_dh loop parport_pc serio_raw parport tpm_tis virtio_balloon psmouse tpm tpm_bios pcspkr i2c_piix4 i2c_core processor button evdev ext3 jbd mbcache ide_cd_mod   ide_gd_mod cdrom ata_piix ata_generic libata scsi_mod piix ide_pci_generic floppy e1000e virtio_pci virtio_ring virtio 8139cp 8139too ide_core mii thermal fan thermal_sys
 [  857.202922] Pid: 16, comm: events/1 Not tainted 2.6.34-rc1 #3
 [  857.203563] Call Trace:
 [  857.204064]  [<ffffffffa03594e1>] ? fc_lport_timeout+0x49/0x87 [libfc]
 [  857.204747]  [<ffffffffa03594e1>] ? fc_lport_timeout+0x49/0x87 [libfc]
 [  857.205434]  [<ffffffff8103892d>] ? warn_slowpath_common+0x77/0xa3
 [  857.206102]  [<ffffffffa03594e1>] ? fc_lport_timeout+0x49/0x87 [libfc]
 [  857.206878]  [<ffffffff8104cb06>] ? worker_thread+0x181/0x20f
 [  857.207557]  [<ffffffffa0359498>] ? fc_lport_timeout+0x0/0x87 [libfc]
 [  857.208285]  [<ffffffff81050126>] ? autoremove_wake_function+0x0/0x2e
 [  857.209009]  [<ffffffff8104c985>] ? worker_thread+0x0/0x20f
 [  857.209693]  [<ffffffff8104fcf9>] ? kthread+0x79/0x81
 [  857.210424]  [<ffffffff81003694>] ? kernel_thread_helper+0x4/0x10
 [  857.211141]  [<ffffffff8104fc80>] ? kthread+0x0/0x81
 [  857.211791]  [<ffffffff81003690>] ? kernel_thread_helper+0x0/0x10
 [  857.212497] ---[ end trace e194c9c11700625f ]---
 [  857.265004] alua: device handler registered
 [  857.290275] device-mapper: multipath round-robin: version 1.0.0 loaded
 [  857.291599] sd 0:0:0:0: alua: supports implicit and explicit TPGS
 [  857.292794] sd 0:0:0:0: alua: port group 00 rel port 02
 [  857.293645] sd 0:0:0:0: alua: port group 00 state A supports TOUSNA
 [  857.300249] sd 0:0:0:0: alua: port group 00 state A supports TOUSNA

and on the Open-FCoE TCM_FC target side you will see:

 [  491.470139] host0: Assigned Port ID  10102
 [  491.470789] host0: libfc: Port ( 10102) entered point-to-point mode
 [  491.471679] TARGET_CORE[fc]: Registered fabric_sess_ptr: ffff88007d474340

Notice that Port ID 10101 is being used for the FCoE Initiator, and Port
ID 10102 used by the FCoE Target.

      * ) lsscsi output
lenny64guest0:~# lsscsi
 [0:0:0:0]    disk    LIO-ORG  FILEIO           3.1   /dev/sda
 lenny64guest0:~# lsscsi --transport
 [0:0:0:0]    disk    fc:0x200000e081c090b3,0x010102  /dev/sda

      * ) sg_inq -i output for EVPD 0x83 Identifier
lenny64guest0:~# sg_inq -i /dev/sda
VPD INQUIRY: Device Identification page
 Designation descriptor number 1, descriptor length: 20
   designator_type: NAA,  code_set: Binary
   associated with the addressed logical unit
     NAA 6, IEEE Company_id: 0x1405
     Vendor Specific Identifier: 0xf776de20d
     Vendor Specific Identifier Extension: 0xc416d4382d8b16d0
     [0x6001405f776de20dc416d4382d8b16d0]
 Designation descriptor number 2, descriptor length: 56
   designator_type: T10 vendor identification,  code_set: ASCII
   associated with the addressed logical unit
     vendor id: LIO-ORG
     vendor specific: FILEIO:f776de20-c416-4382-8b16-0519a7dcf3ab
 Designation descriptor number 3, descriptor length: 8
   transport: Fibre Channel (FCP-2)
   designator_type: Relative target port,  code_set: Binary
   associated with the target port
     Relative target port: 0x2
 Designation descriptor number 4, descriptor length: 8
   transport: Fibre Channel (FCP-2)
   designator_type: Target port group,  code_set: Binary
   associated with the target port
     Target port group: 0x2
 Designation descriptor number 5, descriptor length: 8
   designator_type: Logical unit group,  code_set: Binary
   associated with the addressed logical unit
     Logical unit group: 0x0
 Designation descriptor number 6, descriptor length: 40
   transport: Fibre Channel (FCP-2)
   designator_type: SCSI name string,  code_set: UTF-8
   associated with the target port
     SCSI name string:
     20:00:00:e0:81:c0:90:b3,t,0x0001

      * ) sg_persist -c output of Persistent Reservations
        REPORT_CAPABILITIES
lenny64guest0:~# sg_persist -c /dev/sda
 LIO-ORG  FILEIO  3.1
 Peripheral device type: disk
Report capabilities response:
 Compatible Reservation Handling(CRH): 1
 Specify Initiator Ports Capable(SIP_C): 1
 All Target Ports Capable(ATP_C): 1
 Persist Through Power Loss Capable(PTPL_C): 1
 Type Mask Valid(TMV): 1
 Allow Commands: 1
 Persist Through Power Loss Active(PTPL_A): 0
   Support indicated in Type mask:
     Write Exclusive, all registrants: 1
     Exclusive Access, registrants only: 1
     Write Exclusive, registrants only: 1
     Exclusive Access: 1
     Write Exclusive: 1
     Exclusive Access, all registrants: 1

      * ) sg_rtpg output of ALUA REPORT_TARGET_PORT_GROUPS
lenny64guest0:~# sg_rtpg /dev/sda 
Report target port groups:
 target port group id : 0x0 , Pref=0
   target port group asymmetric access state : 0x00
   T_SUP : 1, O_SUP : 1, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
   status code : 0x00
   vendor unique status : 0x00
   target port count : 00
 target port group id : 0x1 , Pref=0
   target port group asymmetric access state : 0x00
   T_SUP : 1, O_SUP : 1, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
   status code : 0x00
   vendor unique status : 0x00
   target port count : 01
   Relative target port ids:
     0x01
 target port group id : 0x2 , Pref=0
   target port group asymmetric access state : 0x00
   T_SUP : 1, O_SUP : 1, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
   status code : 0x00
   vendor unique status : 0x00
   target port count : 01
   Relative target port ids:
     0x02
