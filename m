From: Andrew Patterson <andrew.patterson@hpe.com>
Subject: bnx2x: bnx2fc: FC-NPIV table with bad length
Date: Mon, 14 Mar 2016 20:33:17 -0600
Message-ID: <56E7746D.6030606@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:45741 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382AbcCOCdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 22:33:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ariel.elior@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


I see the following error when booting a 4.4.1 kernel from the
bnx2x/bnx2fc drivers:

bnx2x: [bnx2x_get_fc_npiv:14843(eth2)]FC-NPIV table with bad length 0x08000040

This is using a QLogic/Broadcom CNA card in FCoE mode. The relavent code
in drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c has:

	if (!tbl->fc_npiv_cfg.num_of_npiv) {
		DP(BNX2X_MSG_MCP,
		   "No FC-NPIV table [valid, simply not present]\n");
		goto out;
	} else if (tbl->fc_npiv_cfg.num_of_npiv > MAX_NUMBER_NPIV) {
		BNX2X_ERR("FC-NPIV table with bad length 0x%08x\n",
			  tbl->fc_npiv_cfg.num_of_npiv);
		goto out;
	} else {
		DP(BNX2X_MSG_MCP, "Read 0x%08x entries from NVRAM\n",
		   tbl->fc_npiv_cfg.num_of_npiv);
	}

where:

#define MAX_NUMBER_NPIV 64

It looks like some portion of fc_npiv_cfg.num_of_npiv needs to be
masked off. How much to mask requires a spec or perhaps just
max_npiv_vports? The same code is used in the 4.5 kernel.

Hardware/kernel details

$ dmesg | grep bnx2
[    1.690750] bnx2fc: QLogic FCoE Driver bnx2fc v2.9.6 (October 15, 2015)
[    1.766617] bnx2x: QLogic 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.712.30-0 (2014/02/10)
[    1.766926] bnx2x 0000:06:00.0: msix capability found
[    1.767071] bnx2x 0000:06:00.0: part number 0-0-0-0
[    1.883845] bnx2x 0000:06:00.1: msix capability found
[    1.883991] bnx2x 0000:06:00.1: part number 0-0-0-0
[    1.999892] bnx2x 0000:06:00.2: msix capability found
[    2.000040] bnx2x 0000:06:00.2: part number 0-0-0-0
[    2.115390] bnx2x 0000:06:00.2 eth2: Added CNIC device
[    2.125127] bnx2x 0000:06:00.3: msix capability found
[    2.125273] bnx2x 0000:06:00.3: part number 0-0-0-0
[    2.243359] bnx2x 0000:06:00.3 eth3: Added CNIC device
[    2.870153] bnx2x 0000:06:00.2 eth2: using MSI-X  IRQs: sp 113  fp[0] 115 ... fp[0] 115
[    2.981871] bnx2fc: [06]: FCOE_INIT passed
[    3.530078] bnx2x 0000:06:00.3 eth3: using MSI-X  IRQs: sp 116  fp[0] 118 ... fp[0] 118
[    3.665625] bnx2x 0000:06:00.2 eth2: NIC Link is Up, 8000 Mbps full duplex, Flow control: ON - receive & transmit
[    3.705728] bnx2fc: [06]: FCOE_INIT passed
[    4.129613] bnx2x 0000:06:00.3 eth3: NIC Link is Up, 8000 Mbps full duplex, Flow control: ON - receive & transmit
[    8.131448] bnx2x: [bnx2x_get_fc_npiv:14843(eth2)]FC-NPIV table with bad length 0x08000040
[   11.487340] bnx2x: [bnx2x_get_fc_npiv:14843(eth3)]FC-NPIV table with bad length 0x08000040
[   11.571466] bnx2fc: 104bf - rport not created Yet!!
[   14.889722] bnx2fc: 1053a - rport not created Yet!!
[   14.892995] bnx2fc: 1053a - rport not created Yet!!
[   28.060856] bnx2x 0000:06:00.0 eth0: using MSI-X  IRQs: sp 93  fp[0] 95 ... fp[7] 102
[   28.133198] bnx2x 0000:06:00.0 eth0: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & transmit

$ lspci -s 06:00.2 -v
06:00.2 Ethernet controller: Broadcom Corporation BCM57840 NetXtreme II 10/20-Gigabit Ethernet (rev 11)
	Subsystem: Hewlett-Packard Company Device 22fa
	Flags: bus master, fast devsel, latency 0
	Memory at 94000000 (64-bit, prefetchable) [size=8M]
	Memory at 94800000 (64-bit, prefetchable) [size=8M]
	Memory at 97010000 (64-bit, prefetchable) [size=64K]
	[virtual] Expansion ROM at 92c00000 [disabled] [size=512K]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [a0] MSI-X: Enable+ Count=32 Masked-
	Capabilities: [ac] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Device Serial Number 6c-c2-17-ff-fe-3a-50-00
	Capabilities: [150] Power Budgeting <?>
	Capabilities: [160] Virtual Channel
	Capabilities: [1b8] Alternative Routing-ID Interpretation (ARI)
	Capabilities: [220] #15
	Kernel driver in use: bnx2x

$ lspci -s 06:00.2 -n
06:00.2 0200: 14e4:16a2 (rev 11)

$ lsmod
Module                  Size  Used by
8021q                  28672  0 
garp                   16384  1 8021q
mrp                    20480  1 8021q
stp                    16384  1 garp
llc                    16384  2 stp,garp
vfat                   20480  1 
fat                    69632  1 vfat
iTCO_wdt               16384  0 
iTCO_vendor_support    16384  1 iTCO_wdt
x86_pkg_temp_thermal    16384  0 
intel_powerclamp       16384  0 
coretemp               16384  0 
kvm_intel             167936  0 
kvm                   520192  1 kvm_intel
irqbypass              16384  1 kvm
crc32_pclmul           16384  0 
hmac                   16384  1 
drbg                   24576  1 
ansi_cprng             16384  0 
aesni_intel           167936  0 
aes_x86_64             20480  1 aesni_intel
lrw                    16384  1 aesni_intel
gf128mul               16384  1 lrw
glue_helper            16384  1 aesni_intel
ablk_helper            16384  1 aesni_intel
cryptd                 20480  2 aesni_intel,ablk_helper
pcspkr                 16384  0 
evdev                  20480  1 
mgag200                49152  1 
ttm                    94208  1 mgag200
drm_kms_helper        126976  1 mgag200
drm                   344064  4 ttm,drm_kms_helper,mgag200
i2c_algo_bit           16384  1 mgag200
fb_sys_fops            16384  1 drm_kms_helper
syscopyarea            16384  1 drm_kms_helper
sysfillrect            16384  1 drm_kms_helper
lpc_ich                24576  0 
sb_edac                28672  0 
sysimgblt              16384  1 drm_kms_helper
edac_core              57344  1 sb_edac
mfd_core               16384  1 lpc_ich
i2c_core               53248  4 drm,drm_kms_helper,mgag200,i2c_algo_bit
hpilo                  20480  0 
hpwdt                  16384  0 
ioatdma                40960  0 
dca                    16384  1 ioatdma
wmi                    16384  0 
ipmi_si                57344  0 
ipmi_msghandler        49152  1 ipmi_si
pcc_cpufreq            16384  0 
acpi_cpufreq           16384  0 
processor              36864  1 acpi_cpufreq
acpi_power_meter       20480  0 
button                 16384  0 
autofs4                32768  2 
ext4                  589824  2 
crc16                  16384  1 ext4
mbcache                20480  1 ext4
jbd2                  106496  1 ext4
scsi_dh_emc            16384  0 
scsi_dh_alua           16384  24 
dm_round_robin         16384  0 
dm_service_time        16384  12 
dm_multipath           24576  14 dm_round_robin,dm_service_time
dm_mod                110592  84 dm_multipath
hid_generic            16384  0 
usbhid                 49152  0 
hid                   114688  2 hid_generic,usbhid
sd_mod                 49152  45 
sg                     36864  0 
bnx2x                 720896  0 
xhci_pci               16384  0 
uhci_hcd               32768  0 
xhci_hcd              126976  1 xhci_pci
ehci_hcd               53248  0 
mdio                   16384  1 bnx2x
usbcore               208896  5 uhci_hcd,ehci_hcd,usbhid,xhci_hcd,xhci_pci
ptp                    20480  1 bnx2x
pps_core               16384  1 ptp
hpsa                   94208  2 
crc32c_generic         16384  0 
usb_common             16384  1 usbcore
crc32c_intel           24576  1 
scsi_transport_sas     45056  1 hpsa
libcrc32c              16384  1 bnx2x
bnx2fc                 94208  90 
cnic                   69632  1 bnx2fc
uio                    20480  1 cnic
fcoe                   28672  0 
libfcoe                65536  2 fcoe,bnx2fc
libfc                 118784  3 fcoe,libfcoe,bnx2fc
scsi_transport_fc      61440  3 fcoe,libfc,bnx2fc
scsi_mod              237568  12 sg,fcoe,hpsa,scsi_dh_alua,dm_multipath,scsi_transport_fc,scsi_transport_sas,libfc,bnx2fc,scsi_dh_emc,sd_mod

The CNA is running 2.16.20 firmware and is in an HP Proliant bl460gen9 blade.

--
Andrew Patterson
Hewlett-Packard Enterprise
