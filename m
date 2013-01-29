From: Olaf Hering <olaf@aepfle.de>
Subject: storvsc loops with No Sense messages
Date: Tue, 29 Jan 2013 16:28:01 +0100
Message-ID: <20130129152801.GA671@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:48378 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab3A2P2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 10:28:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org


KY,

while attempting to install the upcoming openSuSE 12.3 in a hyper-v
guest (1 vcpu, 512MB) hosted on Windows Server 2012 I see a hanging
guest after formating the root partition, when the installer starts to
write files to it.  After booting the install kernel with
'ignore_loglevel' I see a flood of the "No Sense" messages shown below.
I can reproduce it every time with 12.3.

The sglist init patch does not fix it for me.

Hannes did many storage related backports for SLES11 SP3, and sometimes
the installer hangs at similar points during a fresh SP3 install.

The same procedure works fine on Windows Server 2008.

Any ideas what 2012 does differently? It happens with a plain 3.7.n
kernel. I will try 3.8-rc now, and see if it happens as well.

Olaf

...
[    0.000000] Linux version 3.7.5-5.home_olh_12_3-vanilla (geeko@buildhost) (gcc version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #1 SMP Mon Jan 28 12:39:46 UTC 2013 (d9a9e6d)
[    0.000000] Command line: quiet panic=9 sysrq=yes start_shell splash=silent vga=0x317 video=1024x768 console=ttyS0,115200 console=tty1 ignore_loglevel initrd=sl/12.3/initrd-x86_64 BOOT_IMAGE=sl/12.3/linux-x86_64
...
[    7.938806] scsi2 : storvsc_host_t
[    7.940709] scsi 2:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
[    7.943952] sd 2:0:0:0: Attached scsi generic sg1 type 0

[    7.946440] sd 2:0:0:0: [sda] 20971520 512-byte logical blocks: (10.7 GB/10.0 GiB)
[    7.949485] sd 2:0:0:0: [sda] Write Protect is off
[    7.951231] sd 2:0:0:0: [sda] Mode Sense: 0f 00 00 00
[    7.953105] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.955269] scsi3 : storvsc_host_t
[    7.957027] scsi scan: INQUIRY result too short (5), using 36
[    7.958786] scsi scan: INQUIRY result too short (5), using 36
[    7.961292] input: Microsoft Vmbus HID-compliant Mouse as /devices/virtual/input/input3
[    7.965400] hid-generic 0006:045E:0621.0001: input: <UNKNOWN> HID v0.01 Mouse [Microsoft Vmbus HID-compliant Mouse] on
[    7.971872] hv_netvsc: hv_netvsc channel opened successfully
[    7.974574] hv_netvsc vmbus_0_11: Device MAC 00:15:5d:02:51:02 link state up
[    7.985086]  sda: sda1 sda2
[    7.986725] sd 2:0:0:0: [sda] Attached SCSI disk
...
[  156.205185] Adding 746492k swap on /dev/sda1.  Priority:-1 extents:1 across:746492k
...
[  156.478186] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[  161.459523] hv_storvsc vmbus_0_1: cmd 0x41 scsi status 0x2 srb status 0x6
[  161.462157] sd 2:0:0:0: [sda]
[  161.463135] Sense Key : No Sense [current]
[  161.464983] sd 2:0:0:0: [sda]
[  161.465899] Add. Sense: No additional sense information
[  161.468211] hv_storvsc vmbus_0_1: cmd 0x41 scsi status 0x2 srb status 0x6
[  161.475766] sd 2:0:0:0: [sda]
[  161.476728] Sense Key : No Sense [current]
[  161.478284] sd 2:0:0:0: [sda]
[  161.479441] Add. Sense: No additional sense information
[  161.481311] hv_storvsc vmbus_0_1: cmd 0x41 scsi status 0x2 srb status 0x6
[  161.484477] sd 2:0:0:0: [sda]
[  161.485422] Sense Key : No Sense [current]
[  161.486977] sd 2:0:0:0: [sda]
[  161.487920] Add. Sense: No additional sense information

... and so it goes on until the VM is powered off.

