From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v3 5/5] Revert
 "scsi: ufs: disable vccq if it's not needed by UFS device"
Date: Wed, 6 Feb 2019 20:57:40 +0530
Message-ID: <740e6332-b54f-ab62-915a-0aec6be450d3@samsung.com>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr>
        <CGME20190204174549epcas4p4682667176f55101f69cc24cc455c9f3c@epcas4p4.samsung.com>
        <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
        <5f2a8378-1f22-6a52-356d-56d3b393ab1d@samsung.com>
        <05d2d193-4181-12ce-b4fb-4e8dec5aef27@free.fr>
        <7610c262-1451-9bb2-48a6-4daf6f534f6c@free.fr>
        <42c86292-22e9-4c5e-d64d-bc6107af45bf@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <42c86292-22e9-4c5e-d64d-bc6107af45bf@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Marc,

On 06/02/19 8:29 PM, Marc Gonzalez wrote:
> [ Google, stop making email so hard. No, this is not spam, you twat of a Bayesian filter ]
> 
> On 05/02/2019 18:51, Marc Gonzalez wrote:
> 
>> On 05/02/2019 18:24, Marc Gonzalez wrote:
>>
>> Silly me. The system crashes in ufshcd_dump_regs() which is a bug
>> I fixed myself. Once I cherry-pick the appropriate fix, the board
>> no longer reboots, but UFS init does fail.
>>
>> Full boot log here:
>> https://pastebin.ubuntu.com/p/KwpRnWMFw5/
> 
> Here's a better failure log, with timestamps:
> 
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x51af8014]
> [    0.000000] Linux version 5.0.0-rc5-next-20190206 (mgonzalez@venus) (gcc version 7.3.1 20180425 [linaro-7.3-2018.05 revision d29120a424ecfbc167ef90065c0eeb7f91977701] (Linaro GCC 7.3-2018.05)) #19 SMP PREEMPT Wed Feb 6 15:42:45 CET 2019
> [    0.000000] Machine model: Qualcomm Technologies, Inc. MSM8998 v1 MTP
> [    0.000000] printk: debug: ignoring loglevel setting.
> [    0.000000] On node 0 totalpages: 1028544
> [    0.000000]   DMA32 zone: 8192 pages used for memmap
> [    0.000000]   DMA32 zone: 0 pages reserved
> [    0.000000]   DMA32 zone: 511488 pages, LIFO batch:63
> [    0.000000]   Normal zone: 8079 pages used for memmap
> [    0.000000]   Normal zone: 517056 pages, LIFO batch:63
> [    0.000000] psci: probing for conduit method from DT.
> [    0.000000] psci: PSCIv1.0 detected in firmware.
> [    0.000000] psci: Using standard PSCI v0.2 function IDs
> [    0.000000] psci: MIGRATE_INFO_TYPE not supported.
> [    0.000000] psci: SMC Calling Convention v1.0
> [    0.000000] random: get_random_bytes called from start_kernel+0xa8/0x470 with crng_init=0
> [    0.000000] percpu: Embedded 22 pages/cpu @(____ptrval____) s50184 r8192 d31736 u90112
> [    0.000000] pcpu-alloc: s50184 r8192 d31736 u90112 alloc=22*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7
> [    0.000000] Detected VIPT I-cache on CPU0
> [    0.000000] CPU features: detected: Kernel page table isolation (KPTI)
> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 1012273
> [    0.000000] Kernel command line: ignore_loglevel androidboot.bootdevice=1da4000.ufshc androidboot.serialno=53733c35 androidboot.baseband=apq mdss_mdp.panel=1:hdmi:16
> [    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.000000] software IO TLB: mapped [mem 0xfbfff000-0xfffff000] (64MB)
> [    0.000000] Memory: 3955464K/4114176K available (3262K kernel code, 410K rwdata, 944K rodata, 6016K init, 1161K bss, 158712K reserved, 0K cma-reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] ftrace: allocating 12605 entries in 50 pages
> [    0.000000] rcu: Preemptible hierarchical RCU implementation.
> [    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
> [    0.000000]  Tasks RCU enabled.
> [    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
> [    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
> [    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
> [    0.000000] REMAP: PA=17a00000 VA=ffffff8010040000 SIZE=10000
> [    0.000000] REMAP: PA=17b00000 VA=ffffff8010d00000 SIZE=100000
> [    0.000000] GICv3: Distributor has no Range Selector support
> [    0.000000] GICv3: no VLPI support, no direct LPI support
> [    0.000000] GICv3: CPU0: found redistributor 0 region 0:0x0000000017b00000
> [    0.000000] ITS: No ITS available, not enabling LPIs
> [    0.000000] REMAP: PA=17920000 VA=ffffff8010005000 SIZE=1000
> [    0.000000] REMAP: PA=17921000 VA=ffffff801000d000 SIZE=1000
> [    0.000000] REMAP: PA=17921000 VA=ffffff8010015000 SIZE=1000
> [    0.000000] arch_timer: cp15 and mmio timer(s) running at 19.20MHz (virt/virt).
> [    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x46d987e47, max_idle_ns: 440795202767 ns
> [    0.000003] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps every 4398046511078ns
> [    0.000061] Console: colour dummy device 80x25
> [    0.000405] printk: console [tty0] enabled
> [    0.000428] Calibrating delay loop (skipped), value calculated using timer frequency.. 38.40 BogoMIPS (lpj=76800)
> [    0.000444] pid_max: default: 32768 minimum: 301
> [    0.000542] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.000563] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.000864] *** VALIDATE proc ***
> [    0.023878] ASID allocator initialised with 32768 entries
> [    0.031878] rcu: Hierarchical SRCU implementation.
> [    0.051914] smp: Bringing up secondary CPUs ...
> [    0.086062] Detected VIPT I-cache on CPU1
> [    0.086092] GICv3: CPU1: found redistributor 1 region 0:0x0000000017b20000
> [    0.086135] CPU1: Booted secondary processor 0x0000000001 [0x51af8014]
> [    0.118156] Detected VIPT I-cache on CPU2
> [    0.118178] GICv3: CPU2: found redistributor 2 region 0:0x0000000017b40000
> [    0.118218] CPU2: Booted secondary processor 0x0000000002 [0x51af8014]
> [    0.150457] Detected VIPT I-cache on CPU3
> [    0.150481] GICv3: CPU3: found redistributor 3 region 0:0x0000000017b60000
> [    0.150521] CPU3: Booted secondary processor 0x0000000003 [0x51af8014]
> [    0.183055] Detected VIPT I-cache on CPU4
> [    0.183082] CPU features: SANITY CHECK: Unexpected variation in SYS_ID_AA64MMFR0_EL1. Boot CPU: 0x00000000001122, CPU4: 0x00000000101122
> [    0.183108] CPU features: Unsupported CPU feature variation detected.
> [    0.183141] GICv3: CPU4: found redistributor 100 region 0:0x0000000017b80000
> [    0.183217] CPU4: Booted secondary processor 0x0000000100 [0x51af8001]
> [    0.215157] Detected VIPT I-cache on CPU5
> [    0.215182] CPU features: SANITY CHECK: Unexpected variation in SYS_ID_AA64MMFR0_EL1. Boot CPU: 0x00000000001122, CPU5: 0x00000000101122
> [    0.215236] GICv3: CPU5: found redistributor 101 region 0:0x0000000017ba0000
> [    0.215308] CPU5: Booted secondary processor 0x0000000101 [0x51af8001]
> [    0.247502] Detected VIPT I-cache on CPU6
> [    0.247528] CPU features: SANITY CHECK: Unexpected variation in SYS_ID_AA64MMFR0_EL1. Boot CPU: 0x00000000001122, CPU6: 0x00000000101122
> [    0.247583] GICv3: CPU6: found redistributor 102 region 0:0x0000000017bc0000
> [    0.247656] CPU6: Booted secondary processor 0x0000000102 [0x51af8001]
> [    0.279824] Detected VIPT I-cache on CPU7
> [    0.279850] CPU features: SANITY CHECK: Unexpected variation in SYS_ID_AA64MMFR0_EL1. Boot CPU: 0x00000000001122, CPU7: 0x00000000101122
> [    0.279908] GICv3: CPU7: found redistributor 103 region 0:0x0000000017be0000
> [    0.279981] CPU7: Booted secondary processor 0x0000000103 [0x51af8001]
> [    0.280178] smp: Brought up 1 node, 8 CPUs
> [    0.280396] SMP: Total of 8 processors activated.
> [    0.280406] CPU features: detected: GIC system register CPU interface
> [    0.280418] CPU features: detected: 32-bit EL0 Support
> [    0.280429] CPU features: detected: CRC32 instructions
> [    0.823309] CPU: All CPU(s) started at EL1
> [    0.823361] alternatives: patching kernel code
> [    0.824150] devtmpfs: initialized
> [    0.827562] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    0.827585] futex hash table entries: 2048 (order: 5, 131072 bytes)
> [    0.827708] pinctrl core: initialized pinctrl subsystem
> [    0.829449] vdso: 2 pages (1 code @ (____ptrval____), 1 data @ (____ptrval____))
> [    0.829523] DMA: preallocated 256 KiB pool for atomic allocations
> [    0.830318] REMAP: PA=01f40000 VA=ffffff8011000000 SIZE=20000
> [    0.830863] REMAP: PA=86000000 VA=ffffff8011200000 SIZE=200000
> [    0.832055] REMAP: PA=00100000 VA=ffffff8011100000 SIZE=b0000
> [    0.839431] REMAP: PA=03400000 VA=ffffff8012000000 SIZE=c00000
> [    0.840662] REMAP: PA=17911000 VA=ffffff8010025000 SIZE=1000
> [    0.848961] SCSI subsystem initialized
> [    0.849218] REMAP: PA=00778000 VA=ffffff80116f8000 SIZE=7000
> [    0.850312] clocksource: Switched to clocksource arch_sys_counter
> [    0.859512] s1: supplied by vph_pwr
> [    0.860008] s2: supplied by vph_pwr
> [    0.860291] s3: supplied by vph_pwr
> [    0.860348] s3: Bringing 0uV into 1352000-1352000uV
> [    0.860566] s4: supplied by vph_pwr
> [    0.860699] s4: Bringing 0uV into 1800000-1800000uV
> [    0.860885] s5: supplied by vph_pwr
> [    0.860933] s5: Bringing 0uV into 1904000-1904000uV
> [    0.861115] s6: supplied by vph_pwr
> [    0.861337] s7: supplied by vph_pwr
> [    0.861394] s7: Bringing 0uV into 900000-900000uV
> [    0.861639] s8: supplied by vph_pwr
> [    0.861848] s9: supplied by vph_pwr
> [    0.862055] s10: supplied by vph_pwr
> [    0.862436] s11: supplied by vph_pwr
> [    0.862651] s12: supplied by vph_pwr
> [    0.862903] s13: supplied by vph_pwr
> [    0.863154] l1: supplied by s7
> [    0.863304] l1: Bringing 0uV into 880000-880000uV
> [    0.863518] l2: supplied by s3
> [    0.863573] l2: Bringing 0uV into 1200000-1200000uV
> [    0.863763] l3: supplied by s7
> [    0.863820] l3: Bringing 0uV into 1000000-1000000uV
> [    0.864049] l4: supplied by s7
> [    0.864370] l5: supplied by s7
> [    0.864421] l5: Bringing 0uV into 800000-800000uV
> [    0.864654] l6: supplied by s5
> [    0.864707] l6: Bringing 0uV into 1808000-1808000uV
> [    0.864933] l7: supplied by s5
> [    0.864994] l7: Bringing 0uV into 1800000-1800000uV
> [    0.865269] l8: supplied by s3
> [    0.865329] l8: Bringing 0uV into 1200000-1200000uV
> [    0.865560] l9: Bringing 0uV into 1808000-1808000uV
> [    0.865805] l10: Bringing 0uV into 1808000-1808000uV
> [    0.866041] l11: supplied by s7
> [    0.866098] l11: Bringing 0uV into 1000000-1000000uV
> [    0.866455] l12: supplied by s5
> [    0.866590] l12: Bringing 0uV into 1800000-1800000uV
> [    0.866845] l13: Bringing 0uV into 1808000-1808000uV
> [    0.867109] l14: supplied by s5
> [    0.867178] l14: Bringing 0uV into 1880000-1880000uV
> [    0.867438] l15: supplied by s5
> [    0.867489] l15: Bringing 0uV into 1800000-1800000uV
> [    0.867756] l16: Bringing 0uV into 2704000-2704000uV
> [    0.868118] l17: supplied by s3
> [    0.868200] l17: Bringing 0uV into 1304000-1304000uV
> [    0.868505] l18: Bringing 0uV into 2704000-2704000uV
> [    0.868821] l19: Bringing 0uV into 3008000-3008000uV
> [    0.869127] l20: Bringing 0uV into 2960000-2960000uV
> [    0.869486] l21: Bringing 0uV into 2960000-2960000uV
> [    0.869867] l22: Bringing 0uV into 2864000-2864000uV
> [    0.870433] l23: Bringing 0uV into 3312000-3312000uV
> [    0.870860] l24: Bringing 0uV into 3088000-3088000uV
> [    0.871290] l25: Bringing 0uV into 3104000-3104000uV
> [    0.871742] l26: supplied by s3
> [    0.871793] l26: Bringing 0uV into 1200000-1200000uV
> [    0.872233] l27: supplied by s7
> [    0.872808] l28: Bringing 0uV into 3008000-3008000uV
> [    0.873285] lvs1: supplied by s4
> [    0.873825] lvs2: supplied by s4
> [    0.875080] bob: supplied by vph_pwr
> [    0.875151] bob: Bringing 0uV into 3312000-3312000uV
> [    1.183716] workingset: timestamp_bits=62 max_order=20 bucket_order=0
> [    1.192148] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    1.193995] REMAP: PA=0c010000 VA=ffffff801002d000 SIZE=18c
> [    1.195073] REMAP: PA=0c010200 VA=ffffff8010035200 SIZE=128
> [    1.195106] REMAP: PA=0c010400 VA=ffffff801003d400 SIZE=200
> [    1.195129] REMAP: PA=0c010c00 VA=ffffff8010051c00 SIZE=20c
> [    1.195152] REMAP: PA=0c010600 VA=ffffff8010053600 SIZE=128
> [    1.195179] REMAP: PA=0c010800 VA=ffffff8010055800 SIZE=200
> [    1.196797] qcom-qmp-phy c010000.phy: Registered Qcom-QMP phy
> [    1.197092] REMAP: PA=01da7000 VA=ffffff801005d000 SIZE=18c
> [    1.197411] REMAP: PA=01da7400 VA=ffffff8010065400 SIZE=128
> [    1.197440] REMAP: PA=01da7600 VA=ffffff801006d600 SIZE=1fc
> [    1.197467] REMAP: PA=01da7c00 VA=ffffff8010075c00 SIZE=1dc
> [    1.197492] REMAP: PA=01da7800 VA=ffffff801007d800 SIZE=128
> [    1.197525] REMAP: PA=01da7a00 VA=ffffff8010c1ca00 SIZE=1fc
> [    1.197846] qcom-qmp-phy 1da7000.phy: Registered Qcom-QMP phy
> [    1.202503] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    1.204233] msm_serial c1b0000.serial: msm_serial: detected port #0
> [    1.204305] msm_serial c1b0000.serial: uartclk = 1843200
> [    1.204485] REMAP: PA=0c1b0000 VA=ffffff8010c1e000 SIZE=1000
> [    1.204510] c1b0000.serial: ttyMSM0 at MMIO 0xc1b0000 (irq = 17, base_baud = 115200) is a MSM
> [    1.204674] msm_serial: console setup on port #0
> [    2.240898] printk: console [ttyMSM0] enabled
> [    2.245990] msm_serial: driver initialized
> [    2.253655] REMAP: PA=01da4000 VA=ffffff8010e04000 SIZE=2500
> [    2.254403] ufshcd-qcom 1da4000.ufshc: ufshcd_populate_vreg: Unable to find vdd-hba-supply regulator, assuming enabled
> [    2.260500] l20: supplied by bob
> [    2.270704]   regulator_set_load: vdd_l20_l24 = 750000 uA
> [    2.271116]   regulator_set_load: vdd_l26 = 560000 uA
> [    2.273731]   regulator_set_load: vdd_s4 = 750000 uA
> [    2.280015] scsi host0: ufshcd
> [    2.319444] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_async_scan | async_run_entry_fn | process_one_work | worker_thread | kthread | ret_from_fork |
> [    2.319830] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [    2.332368] l9: supplied by bob
> [    2.345241] l10: supplied by bob
> [    2.348308] l13: supplied by bob
> [    2.351688] l16: supplied by bob
> [    2.354913] l18: supplied by bob
> [    2.358104] l19: supplied by bob
> [    2.361331] l21: supplied by bob
> [    2.364541] l22: supplied by bob
> [    2.367826] l23: supplied by bob
> [    2.370962] l24: supplied by bob
> [    2.374154] l25: supplied by bob
> [    2.377395] l28: supplied by bob
> [    2.405734] regulator_disable: ENTER vdd_l26
> [    2.405958] regulator_disable: EXIT vdd_l26
> [    2.406032]   regulator_set_load: vdd_l26 = 0 uA
> [    3.930447] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
> [    5.434358] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
> [    6.938318] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
> [    6.938414] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr_retry: query attribute, idn 13, failed with error -11 after 3 retires
> [    6.946959] ufshcd-qcom 1da4000.ufshc: ufshcd_disable_auto_bkops: failed to enable exception event -11
> [    6.958523] ufshcd-qcom 1da4000.ufshc: dme-peer-get: attr-id 0x1587 failed 3 retries
> [    6.967730] ufshcd-qcom 1da4000.ufshc: dme-peer-get: attr-id 0x1586 failed 3 retries
> [    6.975576] ufshcd-qcom 1da4000.ufshc: ufshcd_get_max_pwr_mode: invalid max pwm tx gear read = 0
> [    6.983306] ufshcd-qcom 1da4000.ufshc: ufshcd_probe_hba: Failed getting max supported power mode
> [    8.506314] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
> [   10.010352] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
> [   11.514313] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
> [   11.514412] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag_retry: query attribute, opcode 5, idn 3, failed with error -11 after 3 retires
> [   13.050354] ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
> [   14.554313] ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
> [   16.058313] ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
> [   16.058421] ufshcd-qcom 1da4000.ufshc: ufshcd_read_desc_param: Failed reading descriptor. desc_id 8, desc_index 0, param_offset 0, ret -11
> [   16.067654] ufshcd-qcom 1da4000.ufshc: ufshcd_init_icc_levels: Failed reading power descriptor.len = 98 ret = -11
> [   37.074334] ufshcd-qcom 1da4000.ufshc: link startup failed 1
Here the UFS link startup has failed, so no point looking below logs.
Can you check if your UFS device RESET_N is asserted correctly. It might 
be connected to some regulator and may be you can try keeping that 
regulator as "regulator-always-on" from your DT node.
> [   37.074399] IGNORE ufshcd_print_host_state
> [   37.079128] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   37.083144] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   37.104851] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   37.117239] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   37.598330] ufshcd-qcom 1da4000.ufshc: link startup failed 1
> [   37.598390] IGNORE ufshcd_print_host_state
> [   37.603088] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   37.607135] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   37.628846] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   37.641231] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   38.122332] ufshcd-qcom 1da4000.ufshc: link startup failed 1
> [   38.122392] IGNORE ufshcd_print_host_state
> [   38.127084] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   38.131135] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   38.152846] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   38.165228] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   38.646331] ufshcd-qcom 1da4000.ufshc: link startup failed 1
> [   38.646390] IGNORE ufshcd_print_host_state
> [   38.651083] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   38.655135] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   38.676845] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   38.689230] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   39.170331] ufshcd-qcom 1da4000.ufshc: link startup failed 1
> [   39.170391] IGNORE ufshcd_print_host_state
> [   39.175085] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   39.179135] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TrX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   39.200847] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   39.213232] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   39.232940] ufshcd_print_trs | __ufshcd_transfer_req_compl | ufshcd_transfer_req_compl | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | ufshcd_abort | scmd_eh_abort_handler | process_one_work | worker_thread | kthread | ret_from_fork |
> [   39.241197] ufshcd-qcom 1da4000.ufshc: UPIU[24] - issue time 15538577 us
> [   39.262687] ufshcd-qcom 1da4000.ufshc: UPIU[24] - complete time 0 us
> [   39.269630] ufshcd-qcom 1da4000.ufshc: UPIU[24] - Transfer Request Descriptor phys@0x1774ba300
> [   39.276009] UPIU TRD: 00000000: 15000000 00000000 0000000f 00000000
> [   39.284387] UPIU TRD: 00000010: 77612000 00000001 00800080 01000001
> [   39.290545] ufshcd-qcom 1da4000.ufshc: UPIU[24] - Request UPIU phys@0x177612000
> [   39.296810] UPIU REQ: 00000000: 18d04001 00000000 00000000 24000000
> [   39.304090] UPIU REQ: 00000010: 00000012 00000024 00000000 00000000
> [   39.310338] ufshcd-qcom 1da4000.ufshc: UPIU[24] - Response UPIU phys@0x177612200
> [   39.316603] UPIU RSP: 00000000: 00000000 00000000 00000000 00000000
> [   39.324233] UPIU RSP: 00000010: 00000000 00000000 00000000 00000000
> [   39.330220] UPIU RSP: 00000020: 00000000 00000000 00000000 00000000
> [   39.336463] UPIU RSP: 00000030: 00000000
> [   39.342703] ufshcd-qcom 1da4000.ufshc: UPIU[24] - PRDT - 1 entries  phys@0x177612400
> [   39.346903] UPIU PRDT: 00000000: 77625000 00000001 00000000 00000023
> [   39.474380] ufshcd-qcom 1da4000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x08 timed-out
> [   39.474482] ufshcd-qcom 1da4000.ufshc: ufshcd_eh_device_reset_handler: failed with err -110
> [   39.942333] ufshcd-qcom 1da4000.ufshc: link startup failed 1
> [   39.942391] IGNORE ufshcd_print_host_state
> [   39.947085] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   39.951126] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   39.971806] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   39.984356] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   40.014355] random: fast init done
> [   40.462330] ufshcd-qcom 1da4000.ufshc: link startup failed 1
> [   40.462392] IGNORE ufshcd_print_host_state
> [   40.467084] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   40.471125] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   40.491805] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   40.504355] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   40.982332] ufshcd-qcom 1da4000.ufshc: link startup failed 1
> [   40.982391] IGNORE ufshcd_print_host_state
> [   40.987084] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   40.991125] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   41.011807] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   41.024355] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   41.502331] ufshcd-qcom 1da4000.ufshc: link startup failed 1
> [   41.502390] IGNORE ufshcd_print_host_state
> [   41.507083] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   41.511124] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   41.531804] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   41.544355] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   42.022330] ufshcd-qcom 1da4000.ufshc: link startup failed 1
> [   42.022391] IGNORE ufshcd_print_host_state
> [   42.027084] ufshcd_print_pwr_info | ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   42.031125] ufshcd-qcom 1da4000.ufshc: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
> [   42.051801] ufshcd_probe_hba | ufshcd_host_reset_and_restore | ufshcd_reset_and_restore | ufshcd_eh_host_reset_handler | scsi_try_host_reset | scsi_eh_ready_devs | scsi_error_handler | kthread | ret_from_fork |
> [   42.064356] ufshcd-qcom 1da4000.ufshc: ufshcd_host_reset_and_restore: Host init failed 1
> [   42.083047] scsi 0:0:0:49488: Device offlined - not ready after error recovery
> [   42.101655] Freeing unused kernel memory: 6016K
> 
> 
