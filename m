From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13307] New: hotplug cascaded expander will cause unpluged
 devices not remove from os
Date: Thu, 14 May 2009 10:07:31 GMT
Message-ID: <bug-13307-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49906 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZENKHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2009 06:07:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4EA7VfN010936
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2009 10:07:31 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13307

           Summary: hotplug cascaded expander will cause unpluged devices
                    not remove from os
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.29.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: jack_wang@usish.com
                CC: linux-scsi@vger.kernel.org
        Regression: No


Hi,all
      We are developing a sas HBA driver based on libsas .when we hotplug
cascaded expander will cause unpluged devices not remove from os.We look into
the source code ,found that when BROADCAST CHANGES happend ,libsas will invoke
sas_revalidate_domain to fonud out the change phy ,and it can found the right
phy issue the BROADCAST CHANGE.But in sas_rediscover,it seems that it does
nothing with the wide port case ,only print out a message.I submit this in case
that it
is real a bug.Any comments will be apprieciated. 
 I send relevant output information of the dmesg  attached with this mail.

System:
dual xeon 2.8Ghz, Supermicro-MB x6da3-g2 with our SAS 6G controller tested with
opensuse 10.3, opensuse 11.0 and opensuse 11.1 kernels are standard kernel
opensuse 10.3/11.0/11.1 and vanilla-Kernel 2.6.27-2.6.30-rc3 from kernel.org

Topology:
The root expander connects to HBA,and another expander connect to the root
expander ,each expander has one disk.
dmesg output when unplug the expander from root expander:




[  275.592477] sas: ex 50010c600000003f phy24:D attached: 50010c600000003e
[  275.592498] kobject: 'port-6:0:8' (f4ca7e68): kobject_add_internal: parent:
'expander-6:0', set: 'devices'
[  275.592517] kobject: 'port-6:0:8' (f4ca7e68): kobject_uevent_env
[  275.592519] kobject: 'port-6:0:8' (f4ca7e68): kobject_uevent_env: filter
function caused the event to drop!
[  275.592528] kobject: 'sas_port' (f62c36c0): kobject_add_internal: parent:
'port-6:0:8', set: '<NULL>'
[  275.592536] kobject: 'port-6:0:8' (f5b4e07c): kobject_add_internal: parent:
'sas_port', set: 'devices'
[  275.592566] kobject: 'port-6:0:8' (f5b4e07c): kobject_uevent_env
[  275.592571] kobject: 'port-6:0:8' (f5b4e07c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/sas_port/port-6:0:8'
[  275.593945] kobject: 'end_device-6:0:8' (f5b4e268): kobject_add_internal:
parent: 'port-6:0:8', set: 'devices'
[  275.593965] kobject: 'end_device-6:0:8' (f5b4e268): kobject_uevent_env
[  275.593967] kobject: 'end_device-6:0:8' (f5b4e268): kobject_uevent_env:
filter function caused the event to drop!
[  275.593978] kobject: 'sas_device' (f62c3b40): kobject_add_internal: parent:
'end_device-6:0:8', set: '<NULL>'
[  275.593985] kobject: 'end_device-6:0:8' (f5b4e47c): kobject_add_internal:
parent: 'sas_device', set: 'devices'
[  275.594054] kobject: 'end_device-6:0:8' (f5b4e47c): kobject_uevent_env
[  275.594059] kobject: 'end_device-6:0:8' (f5b4e47c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/sas_device/end_device-6:0:8'
[  275.594097] kobject: 'sas_end_device' (f62c35c0): kobject_add_internal:
parent: 'end_device-6:0:8', set: '<NULL>'
[  275.594104] kobject: 'end_device-6:0:8' (f5b4e67c): kobject_add_internal:
parent: 'sas_end_device', set: 'devices'
[  275.594134] kobject: 'end_device-6:0:8' (f5b4e67c): kobject_uevent_env
[  275.594139] kobject: 'end_device-6:0:8' (f5b4e67c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/sas_end_device/end_device-6:0:8'
[  275.594206] kobject: 'bsg' (f6b1b900): kobject_add_internal: parent:
'end_device-6:0:8', set: '<NULL>'
[  275.594214] kobject: 'end_device-6:0:8' (f5b4ea68): kobject_add_internal:
parent: 'bsg', set: 'devices'
[  275.594279] kobject: 'end_device-6:0:8' (f5b4ea68): kobject_uevent_env
[  275.594284] kobject: 'end_device-6:0:8' (f5b4ea68): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/bsg/end_device-6:0:8'
[  277.595075] sas: sas_ata_phy_reset: Found ATA device.
[  280.945276] ata6.00: ATA-7: ST3160812AS, 3.AAH, max UDMA/133
[  280.945282] ata6.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 16)
[  281.003616] ata6.00: configured for UDMA/133
[  281.003827] scsi 6:0:0:0: Direct-Access     ATA      ST3160812AS      3.AA
PQ: 0 ANSI: 5
[  281.003851] kobject: 'target6:0:0' (f5b4ec7c): kobject_add_internal: parent:
'end_device-6:0:8', set: 'devices'
[  281.003916] kobject: 'target6:0:0' (f5b4ec7c): kobject_uevent_env
[  281.003927] kobject: 'target6:0:0' (f5b4ec7c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/target6:0:0'
[  281.003990] kobject: '6:0:0:0' (f6b29948): kobject_add_internal: parent:
'target6:0:0', set: 'devices'
[  281.004167] kobject: '6:0:0:0' (f6b29948): kobject_uevent_env
[  281.004177] kobject: '6:0:0:0' (f6b29948): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/target6:0:0/6:0:0:0'
[  281.004262] kobject: 'scsi_disk' (f5ce5600): kobject_add_internal: parent:
'6:0:0:0', set: '<NULL>'
[  281.004277] kobject: '6:0:0:0' (f5a9cc70): kobject_add_internal: parent:
'scsi_disk', set: 'devices'
[  281.004369] kobject: '6:0:0:0' (f5a9cc70): kobject_uevent_env
[  281.004380] kobject: '6:0:0:0' (f5a9cc70): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/target6:0:0/6:0:0:0/scsi_disk/6:0:0:0'
[  281.004565] sd 6:0:0:0: [sdc] 312581808 512-byte hardware sectors: (160
GB/149 GiB)
[  281.004654] sd 6:0:0:0: [sdc] Write Protect is off
[  281.004659] sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[  281.004821] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[  281.004842] kobject: 'block' (f5ce5f00): kobject_add_internal: parent:
'6:0:0:0', set: '<NULL>'
[  281.004857] kobject: 'sdc' (f5b7b0a0): kobject_add_internal: parent:
'block', set: 'devices'
[  281.004976] kobject: 'sdc' (f5b7b0a0): kobject_uevent_env
[  281.004981] kobject: 'sdc' (f5b7b0a0): kobject_uevent_env: filter function
caused the event to drop!
[  281.005012] kobject: 'holders' (f5ce57c0): kobject_add_internal: parent:
'sdc', set: '<NULL>'
[  281.005025] kobject: 'slaves' (f5ce5700): kobject_add_internal: parent:
'sdc', set: '<NULL>'
[  281.005241] sd 6:0:0:0: [sdc] 312581808 512-byte hardware sectors: (160
GB/149 GiB)
[  281.005332] sd 6:0:0:0: [sdc] Write Protect is off
[  281.005337] sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[  281.005501] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[  281.005511]  sdc: sdc1
[  281.076652] kobject: 'sdc' (f5b7b0a0): kobject_uevent_env
[  281.076660] kobject: 'sdc' (f5b7b0a0): kobject_uevent_env: filter function
caused the event to drop!
[  281.076680] kobject: 'sdc1' (f5b4f070): kobject_add_internal: parent: 'sdc',
set: 'devices'
[  281.076789] kobject: 'sdc1' (f5b4f070): kobject_uevent_env
[  281.076794] kobject: 'sdc1' (f5b4f070): kobject_uevent_env: filter function
caused the event to drop!
[  281.076809] kobject: 'holders' (f636aa80): kobject_add_internal: parent:
'sdc1', set: '<NULL>'
[  281.076873] kobject: 'sdc' (f5b7b0a0): kobject_uevent_env
[  281.076886] kobject: 'sdc' (f5b7b0a0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/target6:0:0/6:0:0:0/block/sdc'
[  281.076924] kobject: 'sdc1' (f5b4f070): kobject_uevent_env
[  281.076933] kobject: 'sdc1' (f5b4f070): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/target6:0:0/6:0:0:0/block/sdc/sdc1'
[  281.076965] kobject: 'queue' (f5c45d54): kobject_add_internal: parent:
'sdc', set: '<NULL>'
[  281.081785] kobject: 'queue' (f5c45d54): kobject_uevent_env
[  281.081791] kobject: 'queue' (f5c45d54): kobject_uevent_env: filter function
caused the event to drop!
[  281.081798] kobject: 'iosched' (f58b7608): kobject_add_internal: parent:
'queue', set: '<NULL>'
[  281.081857] kobject: 'iosched' (f58b7608): kobject_uevent_env
[  281.081861] kobject: 'iosched' (f58b7608): kobject_uevent_env: filter
function caused the event to drop!
[  281.081880] kobject: '8:32' (f5b4f268): kobject_add_internal: parent: 'bdi',
set: 'devices'
[  281.081955] kobject: '8:32' (f5b4f268): kobject_uevent_env
[  281.081963] kobject: '8:32' (f5b4f268): fill_kobj_path: path =
'/devices/virtual/bdi/8:32'
[  281.083180] sd 6:0:0:0: [sdc] Attached SCSI disk
[  281.083207] kobject: 'scsi_device' (f636a840): kobject_add_internal: parent:
'6:0:0:0', set: '<NULL>'
[  281.083225] kobject: '6:0:0:0' (f6b29ab4): kobject_add_internal: parent:
'scsi_device', set: 'devices'
[  281.083280] kobject: '6:0:0:0' (f6b29ab4): kobject_uevent_env
[  281.083290] kobject: '6:0:0:0' (f6b29ab4): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/target6:0:0/6:0:0:0/scsi_device/6:0:0:0'
[  281.083363] kobject: 'scsi_generic' (f636a280): kobject_add_internal:
parent: '6:0:0:0', set: '<NULL>'
[  281.083381] kobject: 'sg2' (f5b4f668): kobject_add_internal: parent:
'scsi_generic', set: 'devices'
[  281.083478] kobject: 'sg2' (f5b4f668): kobject_uevent_env
[  281.083487] kobject: 'sg2' (f5b4f668): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/target6:0:0/6:0:0:0/scsi_generic/sg2'
[  281.083538] sd 6:0:0:0: Attached scsi generic sg2 type 0
[  281.083572] kobject: 'bsg' (f636ac80): kobject_add_internal: parent:
'6:0:0:0', set: '<NULL>'
[  281.083588] kobject: '6:0:0:0' (f5b4f868): kobject_add_internal: parent:
'bsg', set: 'devices'
[  281.083663] kobject: '6:0:0:0' (f5b4f868): kobject_uevent_env
[  281.083672] kobject: '6:0:0:0' (f5b4f868): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:8/end_device-6:0:8/target6:0:0/6:0:0:0/bsg/6:0:0:0'
[  281.083966] kobject: 'port-6:0:20' (f5b4fa68): kobject_add_internal: parent:
'expander-6:0', set: 'devices'
[  281.091235] kobject: 'port-6:0:20' (f5b4fa68): kobject_uevent_env
[  281.091240] kobject: 'port-6:0:20' (f5b4fa68): kobject_uevent_env: filter
function caused the event to drop!
[  281.091261] kobject: 'sas_port' (f636a4c0): kobject_add_internal: parent:
'port-6:0:20', set: '<NULL>'
[  281.091273] kobject: 'port-6:0:20' (f5b4fc7c): kobject_add_internal: parent:
'sas_port', set: 'devices'
[  281.091323] kobject: 'port-6:0:20' (f5b4fc7c): kobject_uevent_env
[  281.091329] kobject: 'port-6:0:20' (f5b4fc7c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:20/sas_port/port-6:0:20'
[  281.091444] kobject: 'port-6:0:24' (f5b4fe68): kobject_add_internal: parent:
'expander-6:0', set: 'devices'
[  281.091465] kobject: 'port-6:0:24' (f5b4fe68): kobject_uevent_env
[  281.091467] kobject: 'port-6:0:24' (f5b4fe68): kobject_uevent_env: filter
function caused the event to drop!
[  281.091477] kobject: 'sas_port' (f636a480): kobject_add_internal: parent:
'port-6:0:24', set: '<NULL>'
[  281.091485] kobject: 'port-6:0:24' (f5b4ee7c): kobject_add_internal: parent:
'sas_port', set: 'devices'
[  281.091512] kobject: 'port-6:0:24' (f5b4ee7c): kobject_uevent_env
[  281.091517] kobject: 'port-6:0:24' (f5b4ee7c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:24/sas_port/port-6:0:24'
[  281.091686] kobject: 'end_device-6:0:24' (f4d88068): kobject_add_internal:
parent: 'port-6:0:24', set: 'devices'
[  281.091702] kobject: 'end_device-6:0:24' (f4d88068): kobject_uevent_env
[  281.091704] kobject: 'end_device-6:0:24' (f4d88068): kobject_uevent_env:
filter function caused the event to drop!
[  281.091715] kobject: 'sas_device' (f636ad00): kobject_add_internal: parent:
'end_device-6:0:24', set: '<NULL>'
[  281.091722] kobject: 'end_device-6:0:24' (f4d8827c): kobject_add_internal:
parent: 'sas_device', set: 'devices'
[  281.091751] kobject: 'end_device-6:0:24' (f4d8827c): kobject_uevent_env
[  281.091757] kobject: 'end_device-6:0:24' (f4d8827c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:24/end_device-6:0:24/sas_device/end_device-6:0:24'
[  281.091793] kobject: 'sas_end_device' (f636a980): kobject_add_internal:
parent: 'end_device-6:0:24', set: '<NULL>'
[  281.091800] kobject: 'end_device-6:0:24' (f4d8847c): kobject_add_internal:
parent: 'sas_end_device', set: 'devices'
[  281.091831] kobject: 'end_device-6:0:24' (f4d8847c): kobject_uevent_env
[  281.091836] kobject: 'end_device-6:0:24' (f4d8847c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:24/end_device-6:0:24/sas_end_device/end_device-6:0:24'
[  281.091903] kobject: 'bsg' (f58007c0): kobject_add_internal: parent:
'end_device-6:0:24', set: '<NULL>'
[  281.091911] kobject: 'end_device-6:0:24' (f4d88668): kobject_add_internal:
parent: 'bsg', set: 'devices'
[  281.091981] kobject: 'end_device-6:0:24' (f4d88668): kobject_uevent_env
[  281.091986] kobject: 'end_device-6:0:24' (f4d88668): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:24/end_device-6:0:24/bsg/end_device-6:0:24'
[  281.098642] scsi 6:0:1:0: Enclosure         USI      1202JS-P         2.1 
PQ: 0 ANSI: 5
[  281.099458] kobject: 'target6:0:1' (f4d8887c): kobject_add_internal: parent:
'end_device-6:0:24', set: 'devices'
[  281.099514] kobject: 'target6:0:1' (f4d8887c): kobject_uevent_env
[  281.099522] kobject: 'target6:0:1' (f4d8887c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:24/end_device-6:0:24/target6:0:1'
[  281.099558] kobject: '6:0:1:0' (f69be948): kobject_add_internal: parent:
'target6:0:1', set: 'devices'
[  281.099660] kobject: '6:0:1:0' (f69be948): kobject_uevent_env
[  281.099666] kobject: '6:0:1:0' (f69be948): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:24/end_device-6:0:24/target6:0:1/6:0:1:0'
[  281.099760] kobject: 'scsi_device' (f5e45300): kobject_add_internal: parent:
'6:0:1:0', set: '<NULL>'
[  281.099769] kobject: '6:0:1:0' (f69beab4): kobject_add_internal: parent:
'scsi_device', set: 'devices'
[  281.099810] kobject: '6:0:1:0' (f69beab4): kobject_uevent_env
[  281.099815] kobject: '6:0:1:0' (f69beab4): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:24/end_device-6:0:24/target6:0:1/6:0:1:0/scsi_device/6:0:1:0'
[  281.099852] kobject: 'scsi_generic' (f5e453c0): kobject_add_internal:
parent: '6:0:1:0', set: '<NULL>'
[  281.099864] kobject: 'sg3' (f5a9d868): kobject_add_internal: parent:
'scsi_generic', set: 'devices'
[  281.099961] kobject: 'sg3' (f5a9d868): kobject_uevent_env
[  281.099966] kobject: 'sg3' (f5a9d868): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:24/end_device-6:0:24/target6:0:1/6:0:1:0/scsi_generic/sg3'
[  281.099994] scsi 6:0:1:0: Attached scsi generic sg3 type 13
[  281.100014] kobject: 'bsg' (f5e45200): kobject_add_internal: parent:
'6:0:1:0', set: '<NULL>'
[  281.100030] kobject: '6:0:1:0' (f5a9de68): kobject_add_internal: parent:
'bsg', set: 'devices'
[  281.100097] kobject: '6:0:1:0' (f5a9de68): kobject_uevent_env
[  281.100102] kobject: '6:0:1:0' (f5a9de68): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:24/end_device-6:0:24/target6:0:1/6:0:1:0/bsg/6:0:1:0'
[  281.101314] sas: ex 50010c600001e73f has self-configuring routing table
[  281.101336] kobject: 'port-6:1:10' (f4d54068): kobject_add_internal: parent:
'expander-6:1', set: 'devices'
[  281.101368] kobject: 'port-6:1:10' (f4d54068): kobject_uevent_env
[  281.101370] kobject: 'port-6:1:10' (f4d54068): kobject_uevent_env: filter
function caused the event to drop!
[  281.101384] kobject: 'sas_port' (f5e45d80): kobject_add_internal: parent:
'port-6:1:10', set: '<NULL>'
[  281.101394] kobject: 'port-6:1:10' (f4d5427c): kobject_add_internal: parent:
'sas_port', set: 'devices'
[  281.101433] kobject: 'port-6:1:10' (f4d5427c): kobject_uevent_env
[  281.101439] kobject: 'port-6:1:10' (f4d5427c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/sas_port/port-6:1:10'
[  281.101532] /home/newsas/pm8001/pm8001_sas.c 606:found dev 
[  281.101664] kobject: 'end_device-6:1:10' (f4d54468): kobject_add_internal:
parent: 'port-6:1:10', set: 'devices'
[  281.101685] kobject: 'end_device-6:1:10' (f4d54468): kobject_uevent_env
[  281.101687] kobject: 'end_device-6:1:10' (f4d54468): kobject_uevent_env:
filter function caused the event to drop!
[  281.101699] kobject: 'sas_device' (f5e45640): kobject_add_internal: parent:
'end_device-6:1:10', set: '<NULL>'
[  281.101708] kobject: 'end_device-6:1:10' (f4d5467c): kobject_add_internal:
parent: 'sas_device', set: 'devices'
[  281.101754] kobject: 'end_device-6:1:10' (f4d5467c): kobject_uevent_env
[  281.101759] kobject: 'end_device-6:1:10' (f4d5467c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/sas_device/end_device-6:1:10'
[  281.101801] kobject: 'sas_end_device' (f5e45140): kobject_add_internal:
parent: 'end_device-6:1:10', set: '<NULL>'
[  281.101808] kobject: 'end_device-6:1:10' (f4d5487c): kobject_add_internal:
parent: 'sas_end_device', set: 'devices'
[  281.101838] kobject: 'end_device-6:1:10' (f4d5487c): kobject_uevent_env
[  281.101843] kobject: 'end_device-6:1:10' (f4d5487c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/sas_end_device/end_device-6:1:10'
[  281.101919] kobject: 'bsg' (f5d84dc0): kobject_add_internal: parent:
'end_device-6:1:10', set: '<NULL>'
[  281.101930] kobject: 'end_device-6:1:10' (f4d54a68): kobject_add_internal:
parent: 'bsg', set: 'devices'
[  281.101982] kobject: 'end_device-6:1:10' (f4d54a68): kobject_uevent_env
[  281.101990] kobject: 'end_device-6:1:10' (f4d54a68): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/bsg/end_device-6:1:10'
[  281.104357] scsi 6:0:2:0: Direct-Access     SEAGATE  ST3146854SS      0003
PQ: 0 ANSI: 5
[  281.104992] kobject: 'target6:0:2' (f4d54c7c): kobject_add_internal: parent:
'end_device-6:1:10', set: 'devices'
[  281.105035] kobject: 'target6:0:2' (f4d54c7c): kobject_uevent_env
[  281.105043] kobject: 'target6:0:2' (f4d54c7c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/target6:0:2'
[  281.105073] kobject: '6:0:2:0' (f5b79148): kobject_add_internal: parent:
'target6:0:2', set: 'devices'
[  281.105189] kobject: '6:0:2:0' (f5b79148): kobject_uevent_env
[  281.105195] kobject: '6:0:2:0' (f5b79148): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/target6:0:2/6:0:2:0'
[  281.105245] kobject: 'scsi_disk' (f58e60c0): kobject_add_internal: parent:
'6:0:2:0', set: '<NULL>'
[  281.105254] kobject: '6:0:2:0' (f4d54e70): kobject_add_internal: parent:
'scsi_disk', set: 'devices'
[  281.105303] kobject: '6:0:2:0' (f4d54e70): kobject_uevent_env
[  281.105309] kobject: '6:0:2:0' (f4d54e70): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/target6:0:2/6:0:2:0/scsi_disk/6:0:2:0'
[  281.105882] sd 6:0:2:0: [sdd] 286749488 512-byte hardware sectors: (146
GB/136 GiB)
[  281.106879] sd 6:0:2:0: [sdd] Write Protect is off
[  281.106883] sd 6:0:2:0: [sdd] Mode Sense: b3 00 10 08
[  281.108094] sd 6:0:2:0: [sdd] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[  281.108108] kobject: 'block' (f58e6ac0): kobject_add_internal: parent:
'6:0:2:0', set: '<NULL>'
[  281.108120] kobject: 'sdd' (f5b794a0): kobject_add_internal: parent:
'block', set: 'devices'
[  281.108206] kobject: 'sdd' (f5b794a0): kobject_uevent_env
[  281.108209] kobject: 'sdd' (f5b794a0): kobject_uevent_env: filter function
caused the event to drop!
[  281.108229] kobject: 'holders' (f58e6800): kobject_add_internal: parent:
'sdd', set: '<NULL>'
[  281.108237] kobject: 'slaves' (f58e6300): kobject_add_internal: parent:
'sdd', set: '<NULL>'
[  281.108829] sd 6:0:2:0: [sdd] 286749488 512-byte hardware sectors: (146
GB/136 GiB)
[  281.109854] sd 6:0:2:0: [sdd] Write Protect is off
[  281.109858] sd 6:0:2:0: [sdd] Mode Sense: b3 00 10 08
[  281.111081] sd 6:0:2:0: [sdd] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[  281.111087]  sdd: sdd1
[  281.119031] kobject: 'sdd' (f5b794a0): kobject_uevent_env
[  281.119035] kobject: 'sdd' (f5b794a0): kobject_uevent_env: filter function
caused the event to drop!
[  281.119049] kobject: 'sdd1' (f4d55070): kobject_add_internal: parent: 'sdd',
set: 'devices'
[  281.119153] kobject: 'sdd1' (f4d55070): kobject_uevent_env
[  281.119157] kobject: 'sdd1' (f4d55070): kobject_uevent_env: filter function
caused the event to drop!
[  281.119167] kobject: 'holders' (f58e6640): kobject_add_internal: parent:
'sdd1', set: '<NULL>'
[  281.119214] kobject: 'sdd' (f5b794a0): kobject_uevent_env
[  281.119222] kobject: 'sdd' (f5b794a0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/target6:0:2/6:0:2:0/block/sdd'
[  281.119244] kobject: 'sdd1' (f4d55070): kobject_uevent_env
[  281.119250] kobject: 'sdd1' (f4d55070): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/target6:0:2/6:0:2:0/block/sdd/sdd1'
[  281.119267] kobject: 'queue' (f6b0c354): kobject_add_internal: parent:
'sdd', set: '<NULL>'
[  281.119309] kobject: 'queue' (f6b0c354): kobject_uevent_env
[  281.119312] kobject: 'queue' (f6b0c354): kobject_uevent_env: filter function
caused the event to drop!
[  281.119316] kobject: 'iosched' (f5af53c8): kobject_add_internal: parent:
'queue', set: '<NULL>'
[  281.119350] kobject: 'iosched' (f5af53c8): kobject_uevent_env
[  281.119353] kobject: 'iosched' (f5af53c8): kobject_uevent_env: filter
function caused the event to drop!
[  281.119361] kobject: '8:48' (f4d55468): kobject_add_internal: parent: 'bdi',
set: 'devices'
[  281.119410] kobject: '8:48' (f4d55468): kobject_uevent_env
[  281.119414] kobject: '8:48' (f4d55468): fill_kobj_path: path =
'/devices/virtual/bdi/8:48'
[  281.119464] sd 6:0:2:0: [sdd] Attached SCSI disk
[  281.119483] kobject: 'scsi_device' (f58e63c0): kobject_add_internal: parent:
'6:0:2:0', set: '<NULL>'
[  281.119494] kobject: '6:0:2:0' (f5b792b4): kobject_add_internal: parent:
'scsi_device', set: 'devices'
[  281.119526] kobject: '6:0:2:0' (f5b792b4): kobject_uevent_env
[  281.119532] kobject: '6:0:2:0' (f5b792b4): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/target6:0:2/6:0:2:0/scsi_device/6:0:2:0'
[  281.119570] kobject: 'scsi_generic' (f58e6440): kobject_add_internal:
parent: '6:0:2:0', set: '<NULL>'
[  281.119578] kobject: 'sg4' (f4d55868): kobject_add_internal: parent:
'scsi_generic', set: 'devices'
[  281.119647] kobject: 'sg4' (f4d55868): kobject_uevent_env
[  281.119653] kobject: 'sg4' (f4d55868): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/target6:0:2/6:0:2:0/scsi_generic/sg4'
[  281.119678] sd 6:0:2:0: Attached scsi generic sg4 type 0
[  281.119698] kobject: 'bsg' (f58e6340): kobject_add_internal: parent:
'6:0:2:0', set: '<NULL>'
[  281.119706] kobject: '6:0:2:0' (f4d55a68): kobject_add_internal: parent:
'bsg', set: 'devices'
[  281.119751] kobject: '6:0:2:0' (f4d55a68): kobject_uevent_env
[  281.119757] kobject: '6:0:2:0' (f4d55a68): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:10/end_device-6:1:10/target6:0:2/6:0:2:0/bsg/6:0:2:0'
[  281.120102] kobject: 'port-6:1:20' (f4d55c68): kobject_add_internal: parent:
'expander-6:1', set: 'devices'
[  281.120158] kobject: 'port-6:1:20' (f4d55c68): kobject_uevent_env
[  281.120161] kobject: 'port-6:1:20' (f4d55c68): kobject_uevent_env: filter
function caused the event to drop!
[  281.120177] kobject: 'sas_port' (f58e6080): kobject_add_internal: parent:
'port-6:1:20', set: '<NULL>'
[  281.120186] kobject: 'port-6:1:20' (f4d55e7c): kobject_add_internal: parent:
'sas_port', set: 'devices'
[  281.120220] kobject: 'port-6:1:20' (f4d55e7c): kobject_uevent_env
[  281.120225] kobject: 'port-6:1:20' (f4d55e7c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:20/sas_port/port-6:1:20'
[  281.123051] sas: ex 50010c600001e73f has self-configuring routing table
[  281.123072] kobject: 'port-6:1:24' (f5a9d668): kobject_add_internal: parent:
'expander-6:1', set: 'devices'
[  281.123099] kobject: 'port-6:1:24' (f5a9d668): kobject_uevent_env
[  281.123102] kobject: 'port-6:1:24' (f5a9d668): kobject_uevent_env: filter
function caused the event to drop!
[  281.123116] kobject: 'sas_port' (f58e6700): kobject_add_internal: parent:
'port-6:1:24', set: '<NULL>'
[  281.123124] kobject: 'port-6:1:24' (f4d5607c): kobject_add_internal: parent:
'sas_port', set: 'devices'
[  281.123247] kobject: 'port-6:1:24' (f4d5607c): kobject_uevent_env
[  281.123253] kobject: 'port-6:1:24' (f4d5607c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:24/sas_port/port-6:1:24'
[  281.123313] /home/newsas/pm8001/pm8001_sas.c 606:found dev 
[  281.123438] kobject: 'end_device-6:1:24' (f4d56268): kobject_add_internal:
parent: 'port-6:1:24', set: 'devices'
[  281.123456] kobject: 'end_device-6:1:24' (f4d56268): kobject_uevent_env
[  281.123459] kobject: 'end_device-6:1:24' (f4d56268): kobject_uevent_env:
filter function caused the event to drop!
[  281.123473] kobject: 'sas_device' (f58e6400): kobject_add_internal: parent:
'end_device-6:1:24', set: '<NULL>'
[  281.123481] kobject: 'end_device-6:1:24' (f4d5647c): kobject_add_internal:
parent: 'sas_device', set: 'devices'
[  281.123513] kobject: 'end_device-6:1:24' (f4d5647c): kobject_uevent_env
[  281.123519] kobject: 'end_device-6:1:24' (f4d5647c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:24/end_device-6:1:24/sas_device/end_device-6:1:24'
[  281.123564] kobject: 'sas_end_device' (f58e6580): kobject_add_internal:
parent: 'end_device-6:1:24', set: '<NULL>'
[  281.123572] kobject: 'end_device-6:1:24' (f4d5667c): kobject_add_internal:
parent: 'sas_end_device', set: 'devices'
[  281.123605] kobject: 'end_device-6:1:24' (f4d5667c): kobject_uevent_env
[  281.123610] kobject: 'end_device-6:1:24' (f4d5667c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:24/end_device-6:1:24/sas_end_device/end_device-6:1:24'
[  281.123686] kobject: 'bsg' (f5ee3b40): kobject_add_internal: parent:
'end_device-6:1:24', set: '<NULL>'
[  281.123696] kobject: 'end_device-6:1:24' (f4d56868): kobject_add_internal:
parent: 'bsg', set: 'devices'
[  281.123756] kobject: 'end_device-6:1:24' (f4d56868): kobject_uevent_env
[  281.123764] kobject: 'end_device-6:1:24' (f4d56868): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:24/end_device-6:1:24/bsg/end_device-6:1:24'
[  281.126146] scsi 6:0:3:0: Enclosure         USI      1202JS-P         2.1 
PQ: 0 ANSI: 5
[  281.126977] kobject: 'target6:0:3' (f4d56a7c): kobject_add_internal: parent:
'end_device-6:1:24', set: 'devices'
[  281.127020] kobject: 'target6:0:3' (f4d56a7c): kobject_uevent_env
[  281.127029] kobject: 'target6:0:3' (f4d56a7c): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:24/end_device-6:1:24/target6:0:3'
[  281.127062] kobject: '6:0:3:0' (f4d9cd48): kobject_add_internal: parent:
'target6:0:3', set: 'devices'
[  281.127165] kobject: '6:0:3:0' (f4d9cd48): kobject_uevent_env
[  281.127171] kobject: '6:0:3:0' (f4d9cd48): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:24/end_device-6:1:24/target6:0:3/6:0:3:0'
[  281.127253] kobject: 'scsi_device' (f5c6f800): kobject_add_internal: parent:
'6:0:3:0', set: '<NULL>'
[  281.127262] kobject: '6:0:3:0' (f4d9ceb4): kobject_add_internal: parent:
'scsi_device', set: 'devices'
[  281.127295] kobject: '6:0:3:0' (f4d9ceb4): kobject_uevent_env
[  281.127301] kobject: '6:0:3:0' (f4d9ceb4): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:24/end_device-6:1:24/target6:0:3/6:0:3:0/scsi_device/6:0:3:0'
[  281.127338] kobject: 'scsi_generic' (f5c6f900): kobject_add_internal:
parent: '6:0:3:0', set: '<NULL>'
[  281.127347] kobject: 'sg5' (f4d56e68): kobject_add_internal: parent:
'scsi_generic', set: 'devices'
[  281.127413] kobject: 'sg5' (f4d56e68): kobject_uevent_env
[  281.127419] kobject: 'sg5' (f4d56e68): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:24/end_device-6:1:24/target6:0:3/6:0:3:0/scsi_generic/sg5'
[  281.127445] scsi 6:0:3:0: Attached scsi generic sg5 type 13
[  281.127463] kobject: 'bsg' (f5c6f8c0): kobject_add_internal: parent:
'6:0:3:0', set: '<NULL>'
[  281.127471] kobject: '6:0:3:0' (f4d57068): kobject_add_internal: parent:
'bsg', set: 'devices'
[  281.127520] kobject: '6:0:3:0' (f4d57068): kobject_uevent_env
[  281.127526] kobject: '6:0:3:0' (f4d57068): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/port-6:0/expander-6:0/port-6:0:0/expander-6:1/port-6:1:24/end_device-6:1:24/target6:0:3/6:0:3:0/bsg/6:0:3:0'
[  281.128702] sas: DONE DISCOVERY on port 0, pid:3051, result:0
[  281.128718] sas: phy1 matched wide port0
[  281.128737] sas: phy-6:1 added to port-6:0, phy_mask:0x3 (50010c600001e73f)
[  281.128750] sas: phy2 matched wide port0
[  281.128764] sas: phy-6:2 added to port-6:0, phy_mask:0x7 (50010c600001e73f)
[  281.128773] sas: phy3 matched wide port0
[  281.128787] sas: phy-6:3 added to port-6:0, phy_mask:0xf (50010c600001e73f)
[  281.128793] sas: broadcast received: 9
[  281.128801] sas: broadcast received: 9
[  281.128806] sas: broadcast received: 9
[  281.128811] sas: broadcast received: 9
[  281.128825] sas: REVALIDATING DOMAIN on port 0, pid:3051
[  281.128852] kobject: 'drivers' (f5c6ff80): kobject_add_internal: parent:
'usihba', set: '<NULL>'
[  281.128874] kobject: 'pm8001' (f5fbfb00): kobject_uevent_env
[  281.128880] kobject: 'pm8001' (f5fbfb00): fill_kobj_path: path =
'/bus/pci/drivers/pm8001'
[  281.134926] sas: ex 50010c600001e73f phy8 originated BROADCAST(CHANGE)
[  281.135454] sas: ex 50010c600001e73f phy 0x8 broadcast flutter
[  281.136038] sas: ex 50010c600001e73f phy08:T attached: 50010c600001e708
[  281.150229] sas: done REVALIDATING DOMAIN on port 0, pid:3051, res 0x0
[  299.827191] sas: broadcast received: 9
[  299.827208] sas: REVALIDATING DOMAIN on port 0, pid:3051
[  299.828364] sas: ex 50010c600001e73f phy0 originated BROADCAST(CHANGE)
[  299.828368] sas: phy0 part of wide port with phy1
[  299.828839] sas: ex 50010c600001e73f phy1 originated BROADCAST(CHANGE)
[  299.828843] sas: phy1 part of wide port with phy0
[  299.829323] sas: ex 50010c600001e73f phy2 originated BROADCAST(CHANGE)
[  299.829328] sas: phy2 part of wide port with phy0
[  299.830049] sas: ex 50010c600001e73f phy3 originated BROADCAST(CHANGE)
[  299.830053] sas: phy3 part of wide port with phy0
[  299.840097] sas: done REVALIDATING DOMAIN on port 0, pid:3051, res 0x0
[  299.840383] sas: broadcast received: 9
[  299.840397] sas: REVALIDATING DOMAIN on port 0, pid:3051
[  299.852983] sas: done REVALIDATING DOMAIN on port 0, pid:3051, res 0x0
[  299.853452] sas: broadcast received: 9
[  299.853466] sas: REVALIDATING DOMAIN on port 0, pid:3051
[  299.866417] sas: done REVALIDATING DOMAIN on port 0, pid:3051, res 0x0
[  299.866963] sas: broadcast received: 9
[  299.866984] sas: REVALIDATING DOMAIN on port 0, pid:3051
[  299.879672] sas: done REVALIDATING DOMAIN on port 0, pid:3051, res 0x0
[  314.353590] sd 6:0:2:0: [sdd] Unhandled error code
[  314.353596] sd 6:0:2:0: [sdd] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
[  314.353604] end_request: I/O error, dev sdd, sector 0
[  314.353622] Buffer I/O error on device sdd, logical block 0
[  314.353635] Buffer I/O error on device sdd, logical block 1
[  314.353643] Buffer I/O error on device sdd, logical block 2
[  314.353651] Buffer I/O error on device sdd, logical block 3
[  314.353826] sd 6:0:2:0: [sdd] Unhandled error code
[  314.353831] sd 6:0:2:0: [sdd] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
[  314.353838] end_request: I/O error, dev sdd, sector 0
[  314.353845] Buffer I/O error on device sdd, logical block 0
[  314.353969] sd 6:0:2:0: [sdd] Unhandled error code
[  314.353973] sd 6:0:2:0: [sdd] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
[  314.353980] end_request: I/O error, dev sdd, sector 286749480
[  314.353986] Buffer I/O error on device sdd, logical block 35843685
[  314.354159] sd 6:0:2:0: [sdd] Unhandled error code
[  314.354163] sd 6:0:2:0: [sdd] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
[  314.354169] end_request: I/O error, dev sdd, sector 286749480
[  314.354176] Buffer I/O error on device sdd, logical block 35843685
[  314.354466] sd 6:0:2:0: [sdd] Unhandled error code
[  314.354472] sd 6:0:2:0: [sdd] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
[  314.354481] end_request: I/O error, dev sdd, sector 0
[  314.354488] Buffer I/O error on device sdd, logical block 0
[  314.354503] Buffer I/O error on device sdd, logical block 1
[  314.354512] Buffer I/O error on device sdd, logical block 2
[  314.354609] sd 6:0:2:0: [sdd] Unhandled error code
[  314.354612] sd 6:0:2:0: [sdd] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
[  314.354618] end_request: I/O error, dev sdd, sector 0

Notes:
disk sdd is connect to the unpluged expander,when unplug the expander ,the
disk&
expander are not correctly removed .

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You are watching the assignee of the bug.
