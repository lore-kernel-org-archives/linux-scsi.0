From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v3 5/5] Revert "scsi: ufs: disable vccq if it's not needed
 by UFS device"
Date: Tue, 5 Feb 2019 18:24:39 +0100
Message-ID: <05d2d193-4181-12ce-b4fb-4e8dec5aef27@free.fr>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr>
 <CGME20190204174549epcas4p4682667176f55101f69cc24cc455c9f3c@epcas4p4.samsung.com>
 <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
 <5f2a8378-1f22-6a52-356d-56d3b393ab1d@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5f2a8378-1f22-6a52-356d-56d3b393ab1d@samsung.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/02/2019 05:58, Alim Akhtar wrote:

> On 04/02/19 11:12 PM, Marc Gonzalez wrote:
>
>> This reverts commit 60f0187031c05e04cbadffb62f557d0ff3564490.
>>
>> Calling ufshcd_set_vccq_rail_unused hangs my system.
>> It seems vccq is not *not* needed.
> 
> AFAIK Samsung and Toshiba UFS devices does not use VCCQ (this pin is 
> either floating or connected to Ground, at least on the devices that I 
> have worked on).
> You said your system hanged, I believe you have set UFS_DEVICE_NO_VCCQ 
> quirks, in that case VCCQ regulator should having been disabled.
> So you mean your system hanged because vccq regulator got disabled?

If I keep the proposed patch, this is what I get:

ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
l9: supplied by bob
l10: supplied by bob
l13: supplied by bob
l16: supplied by bob
l18: supplied by bob
l19: supplied by bob
l21: supplied by bob
l22: supplied by bob
l23: supplied by bob
l24: supplied by bob
l25: supplied by bob
l28: [garbled]
ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[3, 3], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
scsi 0:0:0:49488: scsi_add_lun: correcting incorrect peripheral device type 0x0 for W-LUN 0x            c150hN
scsi 0:0:0:49488: Well-known LUN    SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
scsi 0:0:0:49476: scsi_add_lun: correcting incorrect peripheral device type 0x0 for W-LUN 0x            c144hN
scsi 0:0:0:49476: Well-known LUN    SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
scsi 0:0:0:49456: scsi_add_lun: correcting incorrect peripheral device type 0x0 for W-LUN 0x            c130hN
scsi 0:0:0:49456: Well-known LUN    SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
scsi 0:0:0:0: Direct-Access     SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
sd 0:0:0:0: Power-on or device reset occurred
sd 0:0:0:0: [sda] 14145536 4096-byte logical blocks: (57.9 GB/54.0 GiB)
sd 0:0:0:0: [sda] Write Protect is off
scsi 0:0:0:1: Direct-Access     SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:1: Power-on or device reset occurred
scsi 0:0:0:2: Direct-Access     SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
sd 0:0:0:1: [sdb] 1024 4096-byte logical blocks: (4.19 MB/4.00 MiB)
sd 0:0:0:1: [sdb] Write Protect is off
sd 0:0:0:2: Power-on or device reset occurred
scsi 0:0:0:3: Direct-Access     SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
sd 0:0:0:2: [sdc] 1024 4096-byte logical blocks: (4.19 MB/4.00 MiB)
sd 0:0:0:1: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:3: Power-on or device reset occurred
 sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7
sd 0:0:0:3: [sdd] 32768 4096-byte logical blocks: (134 MB/128 MiB)
sd 0:0:0:2: [sdc] Write Protect is off
scsi 0:0:0:4: Direct-Access     SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
sd 0:0:0:3: [sdd] Write Protect is off
scsi 0:0:0:5: Direct-Access     SAMSUNG  KLUCG4J1EB-B0B1  0200 PQ: 0 ANSI: 6
random: fast init done
sd 0:0:0:4: Power-on or device reset occurred
sd 0:0:0:5: Power-on or device reset occurred
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:4: [sde] 1048576 4096-byte logical blocks: (4.29 GB/4.00 GiB)
sd 0:0:0:5: [sdf] 393216 4096-byte logical blocks: (1.61 GB/1.50 GiB)
sd 0:0:0:3: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1
sd 0:0:0:4: [sde] Write Protect is off
sd 0:0:0:4: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:5: [sdf] Write Protect is off
sd 0:0:0:2: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sde: sde1 sde2 sde3 sde4 sde5 sde6 sde7 sde8 sde9 sde10 sde11 sde12 sde13 sde14 sde15 sde16 sde17 sde18 sde19 sde20 sde21 sde22 sde23 sde24 sde25 sde26 sde27 sde28 sde29 sde30 sde31 sde32 sde33 sde34 sde35 sde36 sde37 sde38
sd 0:0:0:5: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdd: sdd1 sdd2
sd 0:0:0:1: [sdb] Attached SCSI disk
 sdc: sdc1
sd 0:0:0:2: [sdc] Attached SCSI disk
sd 0:0:0:4: [sde] Attached SCSI disk
sd 0:0:0:3: [sdd] Attached SCSI disk
 sdf: sdf1 sdf2 sdf3
sd 0:0:0:5: [sdf] Attached SCSI disk



If I drop the proposed patch, this is what I get:

ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
l9: supplied by bob
l10: supplied by bob
l13: supplied by bob
l16: supplied by bob
l18: supplied by bob
l19: supplied by bob
l21: supplied by bob
l22: supplied by bob
l23: supplied by bob
l24: supplied by bob
l25: supplied by bob
l28: [garbled]
regulator_disable: ENTER vdd_l26
regulator_disable: EXIT vdd_l26
ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr_retry: query attribute, idn 13, failed with error -11 after 3 retires
ufshcd-qcom 1da4000.ufshc: ufshcd_disable_auto_bkops: failed to enable exception event -11
ufshcd-qcom 1da4000.ufshc: dme-peer-get: attr-id 0x1587 failed 3 retries
ufshcd-qcom 1da4000.ufshc: dme-peer-get: attr-id 0x1586 failed 3 retries
ufshcd-qcom 1da4000.ufshc: ufshcd_get_max_pwr_mode: invalid max pwm tx gear read = 0
ufshcd-qcom 1da4000.ufshc: ufshcd_probe_hba: Failed getting max supported power mode
ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag_retry: query attribute, opcode 5, idn 3, failed with error -11 after 3 retires
ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
ufshcd-qcom 1da4000.ufshc: ufshcd_read_desc_param: Failed reading descriptor. desc_id 8, desc_index 0, param_offset 0, ret -11
ufshcd-qcom 1da4000.ufshc: ufshcd_init_icc_levels: Failed reading power descriptor.len = 98 ret = -11
ufshcd-qcom 1da4000.ufshc: link startup failed 1
ufshcd-qcom 1da4000.ufshc: UFS Host state=0
ufshcd-qcom 1da4000.ufshc: lrb in use=0x1000000, outstanding reqs=0x1000000 tasks=0x0
ufshcd-qcom 1da4000.ufshc: saved_err=0x4, saved_uic_err=0x5
ufshcd-qcom 1da4000.ufshc: Device power mode=1, UIC link state=0
ufshcd-qcom 1da4000.ufshc: PM in progress=0, sys. suspended=0
ufshcd-qcom 1da4000.ufshc: Auto BKOPS=1, Host self-block=0
ufshcd-qcom 1da4000.ufshc: Clk gate=1
ufshcd-qcom 1da4000.ufshc: error handling flags=0x1, req. abort count=0
ufshcd-qcom 1da4000.ufshc: Host capabilities=0x1587001f, caps=0xf
ufshcd-qcom 1da4000.ufshc: quirks=0x0, dev. quirks=0xe6
ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
host_regs: 00000000: 1587001f 00000000 00000210 00000000
host_regs: 00000010: 01000000 00010217 00000000 00000000
host_regs: 00000020: 00000000 00000470 00000000 00000000
host_regs: 00000030: 00000008 00000001 00000000 00000000
host_regs: 00000040: 00000000 00000000 00000000 00000000
host_regs: 00000050: 00000000 00000000 00000000 00000000
host_regs: 00000060: 00000000 00000000 00000000 00000000
host_regs: 00000070: 00000000 00000000 00000000 00000000
host_regs: 00000080: 00000000 00000000 00000000 00000000
host_regs: 00000090: 00000001 00410000 00000000 00000001
ufshcd-qcom 1da4000.ufshc: hba->ufs_version = 0x210, hba->capabilities = 0x1587001f
ufshcd-qcom 1da4000.ufshc: hba->outstanding_reqs = 0x1000000, hba->outstanding_tasks = 0x0
ufshcd-qcom 1da4000.ufshc: last_hibern8_exit_tstamp at 0 us, hibern8_exit_cnt = 0
ufshcd-qcom 1da4000.ufshc: dl_err[0] = 0x80002000 at 1321487 us
ufshcd-qcom 1da4000.ufshc: dl_err[7] = 0x80000002 at 1187360 us
ufshcd-qcom 1da4000.ufshc: clk: core_clk, rate: 200000000
ufshcd-qcom 1da4000.ufshc: clk: core_clk_unipro, rate: 150000000
HCI Vendor Specific Registers 00000000: 000000c8 00000000 00000000 00000000
HCI Vendor Specific Registers 00000010: 00000000 00000000 00000001 5c5c052c
HCI Vendor Specific Registers 00000020: 3f0113ff 30010000 00000007 00000000
HCI Vendor Specific Registers 00000030: 00000000 00000000 02500000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000000: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000010: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000020: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000030: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000040: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000050: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000060: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000070: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000080: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 00000090: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_REG_OCSC 000000a0: 00000000 00000000 00000000 00000000
UFS_UFS_DBG_RD_EDTL_RAM 00000000: 00000000 46269aca bba683dc ae26420e
UFS_UFS_DBG_RD_EDTL_RAM 00000010: fe46b054 3c97c041 038ac9ef a263479f
UFS_UFS_DBG_RD_EDTL_RAM 00000020: 3fac4ac6 4b8f4fdf 6e561798 cac010d9
UFS_UFS_DBG_RD_EDTL_RAM 00000030: 28dbbdbc 8b912ab6 8e7eebaa defdea74
UFS_UFS_DBG_RD_EDTL_RAM 00000040: caefd827 4f68b8b7 437f8c09 e622feb7
UFS_UFS_DBG_RD_EDTL_RAM 00000050: 26521148 6e7241fd c609e7e6 3d582eaf
UFS_UFS_DBG_RD_EDTL_RAM 00000060: 00000024 aa98783f e71f3ce9 eeb2b7af
UFS_UFS_DBG_RD_EDTL_RAM 00000070: 01bed85b 6bba9c5f 79bb6c47 00000000
UFS_UFS_DBG_RD_DESC_RAM 00000000: 40000fff 000269c0 c0004fff 0002674c
UFS_UFS_DBG_RD_DESC_RAM 00000010: 47ca8e27 002ad393 c14304be 0029798f
UFS_UFS_DBG_RD_DESC_RAM 00000020: 28ffe38d 0023cc67 e5aa2e2c 001aa623
UFS_UFS_DBG_RD_DESC_RAM 00000030: 8680feea 0028a93f e6ef9ebb 001a39be
UFS_UFS_DBG_RD_DESC_RAM 00000040: 28f68ce7 000a3abd 79a0a809 000eaa08
UFS_UFS_DBG_RD_DESC_RAM 00000050: ceb38db8 000aa74a f3e9f7fb 002c2a6c
UFS_UFS_DBG_RD_DESC_RAM 00000060: 687de4d6 001a7a3a e6e89b2b 00063fac
UFS_UFS_DBG_RD_DESC_RAM 00000070: 2fb2c052 003aabea c26ee943 002b8d8d
UFS_UFS_DBG_RD_DESC_RAM 00000080: bbbad83b 002aabe5 6df4bf83 003bee50
UFS_UFS_DBG_RD_DESC_RAM 00000090: f7b08e03 0009cb86 caf5b2d0 000eee24
UFS_UFS_DBG_RD_DESC_RAM 000000a0: ad263982 001a27d4 8fa39e9e 00213a02
UFS_UFS_DBG_RD_DESC_RAM 000000b0: edc2c838 001acc7a a5e1952c 002a25b1
UFS_UFS_DBG_RD_DESC_RAM 000000c0: ee0eb208 0029f609 b18cacbb 000eb1c8
UFS_UFS_DBG_RD_DESC_RAM 000000d0: 113eeebe 001a3c94 fab74732 000abef5
UFS_UFS_DBG_RD_DESC_RAM 000000e0: 21e5e2fe 000b8b63 e4eafcfc 00348e05
UFS_UFS_DBG_RD_DESC_RAM 000000f0: 206a7c3e 002ae252 b6087166 0023e74d
UFS_UFS_DBG_RD_DESC_RAM 00000100: 092820a0 0039b70e 294903ae 0014880f
UFS_UFS_DBG_RD_DESC_RAM 00000110: a726fffa 0029233a b86ef955 0029b166
UFS_UFS_DBG_RD_DESC_RAM 00000120: 320f0ce3 000e81e4 3ad7c22a 0027bec4
UFS_UFS_DBG_RD_DESC_RAM 00000130: bb59d781 002becf1 755abb91 00293cc7
UFS_UFS_DBG_RD_DESC_RAM 00000140: a2722c99 003c9eff 13f31639 002bb4db
UFS_UFS_DBG_RD_DESC_RAM 00000150: 08ab4fda 00006b23 a2e638e6 00218abb
UFS_UFS_DBG_RD_DESC_RAM 00000160: cbaaefd5 000a9af3 f83a3754 002a902c
UFS_UFS_DBG_RD_DESC_RAM 00000170: ebf336e9 000b1ca2 0e7b19ef 001a04d3
UFS_UFS_DBG_RD_DESC_RAM 00000180: 40000023 0005e12a ead2d0f1 00283aee
UFS_UFS_DBG_RD_DESC_RAM 00000190: a8f5ae8f 001c6188 fb09ea2b 003b2f4a
UFS_UFS_DBG_RD_DESC_RAM 000001a0: e5383e2a 0033ffde 8f4f229a 000b636b
UFS_UFS_DBG_RD_DESC_RAM 000001b0: 9fdfbd3c 0013ab96 fe4e16ba 00206c8e
UFS_UFS_DBG_RD_DESC_RAM 000001c0: 4a8ec4b6 000ccfa3 f283af16 0010eb18
UFS_UFS_DBG_RD_DESC_RAM 000001d0: 62126082 00299b58 46ab47cc 002cfef1
UFS_UFS_DBG_RD_DESC_RAM 000001e0: aa527ed6 003fb422 a92b35b2 0018328f
UFS_UFS_DBG_RD_DESC_RAM 000001f0: f864fb9b 0010cdb4 ebb0b0cc 003ea82e
UFS_UFS_DBG_RD_PRDT_RAM 00000000: 01700000 00009b3f c8cee2fd 0009ea97
UFS_UFS_DBG_RD_PRDT_RAM 00000010: ea5b24f6 000b2b69 e40a919e 00036be0
UFS_UFS_DBG_RD_PRDT_RAM 00000020: af556e2f 000f323d aeff7e6a 0008edfa
UFS_UFS_DBG_RD_PRDT_RAM 00000030: 3732fc69 000da4f3 c3eb170f 000a3dd2
UFS_UFS_DBG_RD_PRDT_RAM 00000040: 633dfce6 000a899d e5057d97 000aeade
UFS_UFS_DBG_RD_PRDT_RAM 00000050: 3aa2e736 0003b7a2 3366d6c7 0002b88c
UFS_UFS_DBG_RD_PRDT_RAM 00000060: fd937dbb 00085cbb 81f13deb 0000267d
UFS_UFS_DBG_RD_PRDT_RAM 00000070: 6e2ecd02 0000c225 a30b1e7e 000520e6
UFS_UFS_DBG_RD_PRDT_RAM 00000080: eb449c67 000b2380 2da23d73 000b6b77
UFS_UFS_DBG_RD_PRDT_RAM 00000090: d4ed6ef3 000a75ab 7a6e58f3 0000e3e3
UFS_UFS_DBG_RD_PRDT_RAM 000000a0: eada9737 0004d23e 0069bed2 0007a34e
UFS_UFS_DBG_RD_PRDT_RAM 000000b0: ffad4d8a 000eb58f f72bde37 00067c73
UFS_UFS_DBG_RD_PRDT_RAM 000000c0: 24100000 00017865 d66413bf 000b7be3
UFS_UFS_DBG_RD_PRDT_RAM 000000d0: 5f0e4bd8 000ced6c 994a332e 000f6108
UFS_UFS_DBG_RD_PRDT_RAM 000000e0: c4f6bedc 000f08aa 3c8d7fba 00019a7d
UFS_UFS_DBG_RD_PRDT_RAM 000000f0: 26a77938 000efaee 78000000 00017865
UFS_DBG_RD_REG_UAWM 00000000: 00000000 0000004a 00000000 0001fec0
UFS_DBG_RD_REG_UARM 00000000: 00000000 00000001 00000011 00000001
UFS_DBG_RD_REG_TXUC 00000000: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 00000010: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 00000020: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 00000030: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 00000040: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 00000050: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 00000060: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 00000070: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 00000080: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 00000090: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 000000a0: 00000000 00000000 00000000 00000000
UFS_DBG_RD_REG_TXUC 000000b0: 00000001 00000000 00000000 00000004

/*** system hangs here for several seconds, then reboots ***/

Format: Log Type - Time(microsec) - Message - Optional Info
Log Type: B - Since Boot(Power On Reset),  D - Delta,  S - Statistic
S - QC_IMAGE_VERSION_STRING=BOOT.XF.1.2.2-00157-M8998LZB-1
S - IMAGE_VARIANT_STRING=Msm8998LA
S - OEM_IMAGE_VERSION_STRING=speedcore
S - Boot Interface: UFS
S - Secure Boot: Off
S - Boot Config @ 0x00786070 = 0x000002c1
S - JTAG ID @ 0x00786130 = 0x200620e1
S - OEM ID @ 0x00786138 = 0x00000000
S - Serial Number @ 0x00784138 = 0x13ab5626
S - OEM Config Row 0 @ 0x00784188 = 0x0000000000000000
S - OEM Config Row 1 @ 0x00784190 = 0x0000000000004000
S - Feature Config Row 0 @ 0x007841a0 = 0x0050300000000000
S - Feature Config Row 1 @ 0x007841a8 = 0x0000ffff00087fff
S - Core 0 Frequency, 1305 MHz
S - PBL Patch Ver: 1
B -         0 - PBL, Start
B -      9445 - bootable_media_detect_entry, Start
B -     55529 - bootable_media_detect_success, Start
B -     55536 - elf_loader_entry, Start
B -     56834 - auth_hash_seg_entry, Start
B -     57150 - auth_hash_seg_exit, Start
B -    107643 - elf_segs_hash_verify_entry, Start
B -    139027 - elf_segs_hash_verify_exit, Start
B -    139044 - auth_xbl_sec_hash_seg_entry, Start
B -    162946 - auth_xbl_sec_hash_seg_exit, Start
B -    162948 - xbl_sec_segs_hash_verify_entry, Start
B -    168357 - xbl_sec_segs_hash_verify_exit, Start
B -    168423 - PBL, End
B -    201818 - SBL1, Start
B -    323757 - boot_flash_init, Start
D -        30 - boot_flash_init, Delta
B -    326289 - sbl1_ddr_set_default_params, Start
D -         0 - sbl1_ddr_set_default_params, Delta
B -    334280 - boot_config_data_table_init, Start
D -    109525 - boot_config_data_table_init, Delta - (60 Bytes)
B -    448380 - CDT Version:3,Platform ID:8,Major ID:1,Minor ID:0,Subtype:1
B -    453077 - Image Load, Start
D -       579 - Auth Metadata
D -       580 - Segments hash check
D -     12322 - PMIC Image Loaded, Delta - (45640 Bytes)
B -    468724 - pm_device_init, Start
B -    476257 - PM: PON REASON: PM0=0x8000024000020001:0x0 PM1=0x8000084000080020:0x0 PM2=0x8000084000080020:0x0 
B -    535183 - PM: SET_VAL:Skip
D -     62738 - pm_device_init, Delta
B -    537105 - pm_driver_init, Start
D -      5215 - pm_driver_init, Delta
B -    545614 - pm_sbl_chg_init, Start
B -    547902 - PM: Trigger FG IMA Reset
B -    551470 - PM: Trigger FG IMA Reset.Completed
B -    556960 - PM: BOOTUP, Debug Board being used
D -     11529 - pm_sbl_chg_init, Delta
B -    563914 - vsense_init, Start
D -         0 - vsense_init, Delta
B -    621071 - Pre_DDR_clock_init, Start
D -       213 - Pre_DDR_clock_init, Delta
D -         0 - sbl1_ddr_set_params, Delta
B -    630465 - do_ddr_training, Start
D -         0 - do_ddr_training, Delta
B -    655628 - clock_init, Start
D -       335 - clock_init, Delta
B -    658556 - Image Load, Start
D -      2074 - APDP Image Loaded, Delta - (0 Bytes)
B -    868914 - usb: chgr -  SDP_CHARGER
B -    869524 - Image Load, Start
D -      6496 - Auth Metadata
D -      4270 - Segments hash check
D -     15982 - XBLRamDump Image Loaded, Delta - (314564 Bytes)
B -    976213 - MDPDetectPanel: DSC major:0 minor:0 invalid, using default

B -    977372 - DisplayDxe: Resolution 1440x2560 (1 intf)

B -  10088637 - usb: init start
B -  10089034 - usb: ss_lane_2nd
B -  10093426 - usb: VBUS High!
B -  10393912 - usb: HIGH , 0x900e
B -  10521768 - usb: HIGH , 0x900e
B -  10616867 - usb: ENUM success
