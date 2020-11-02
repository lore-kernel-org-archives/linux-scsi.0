Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B67C55179
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3400220679
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D4vnjtJ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgKBORx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:17:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbgKBORm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:17:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604326658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jx+sI7GW4YW20O0Ob76M9AQV9pTBp+LZQfBSqtsCw00=;
        b=D4vnjtJ7g3Je5jOB+GLSpDNWoT2ieEQ7hZ6Hc7l5L5joC7/u93htpg9ylSyAgvnJz37iqC
        5g5oA0SYs3o7tpaFvcRGjOrr6GJ5foSooNeMTXxLGnbUeV5lGvcr6Jx5uKfRfffaBWODYt
        lbnzon2VVk6iw0aWfDJt9DiDhLzFq2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-Ez-OuzC_Pvyao9Z422pBZQ-1; Mon, 02 Nov 2020 09:17:34 -0500
X-MC-Unique: Ez-OuzC_Pvyao9Z422pBZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A2AC186841D;
        Mon,  2 Nov 2020 14:17:31 +0000 (UTC)
Received: from ovpn-112-12.rdu2.redhat.com (ovpn-112-12.rdu2.redhat.com [10.10.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EE181002C1F;
        Mon,  2 Nov 2020 14:17:23 +0000 (UTC)
Message-ID: <fe3dff7dae4494e5a88caffbb4d877bbf472dceb.camel@redhat.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
From:   Qian Cai <cai@redhat.com>
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        ming.lei@redhat.com, bvanassche@acm.org, dgilbert@interlog.com,
        paolo.valente@linaro.org, hare@suse.de, hch@lst.de
Cc:     sumit.saxena@broadcom.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, megaraidlinux.pdl@broadcom.com,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Date:   Mon, 02 Nov 2020 09:17:23 -0500
In-Reply-To: <1597850436-116171-18-git-send-email-john.garry@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
         <1597850436-116171-18-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-08-19 at 23:20 +0800, John Garry wrote:
> From: Kashyap Desai <kashyap.desai@broadcom.com>
> 
> Fusion adapters can steer completions to individual queues, and
> we now have support for shared host-wide tags.
> So we can enable multiqueue support for fusion adapters.
> 
> Once driver enable shared host-wide tags, cpu hotplug feature is also
> supported as it was enabled using below patchsets -
> commit bf0beec0607d ("blk-mq: drain I/O when all CPUs in a hctx are
> offline")
> 
> Currently driver has provision to disable host-wide tags using
> "host_tagset_enable" module parameter.
> 
> Once we do not have any major performance regression using host-wide
> tags, we will drop the hand-crafted interrupt affinity settings.
> 
> Performance is also meeting the expecatation - (used both none and
> mq-deadline scheduler)
> 24 Drive SSD on Aero with/without this patch can get 3.1M IOPs
> 3 VDs consist of 8 SAS SSD on Aero with/without this patch can get 3.1M
> IOPs.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Signed-off-by: John Garry <john.garry@huawei.com>

Reverting this commit fixed an issue that Dell Power Edge R6415 server with
megaraid_sas is unable to boot.

c1:00.0 RAID bus controller: Broadcom / LSI MegaRAID SAS-3 3108 [Invader] (rev 02)
	DeviceName: Integrated RAID
	Subsystem: Dell PERC H730P Mini
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 48
	NUMA node: 3
	Region 0: I/O ports at c000 [size=256]
	Region 1: Memory at a5500000 (64-bit, non-prefetchable) [size=64K]
	Region 3: Memory at a5400000 (64-bit, non-prefetchable) [size=1M]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 0.000W
		DevCtl:	CorrErr- NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 512 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 8GT/s, Width x8, ASPM L0s, Exit Latency L0s <2us
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (ok), Width x8 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+, NROPrPrP-, LTR-
			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt-, EETLPPrefix-
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS-, TPHComp-, ExtTPHComp-
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF Disabled
			 AtomicOpsCtl: ReqEn-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [a8] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [c0] MSI-X: Enable+ Count=97 Masked-
		Vector table: BAR=1 offset=0000e000
		PBA: BAR=1 offset=0000f000
	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt+ UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		CEMsk:	RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 04000001 c000000f c1080000 4ba9007a
	Capabilities: [1e0 v1] Secondary PCI Express
		LnkCtl3: LnkEquIntrruptEn-, PerformEqu-
		LaneErrStat: 0
	Capabilities: [1c0 v1] Power Budgeting <?>
	Capabilities: [148 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Kernel driver in use: megaraid_sas
	Kernel modules: megaraid_sas

[   26.330282][  T567] megasas: 07.714.04.00-rc1
[   26.355663][  T611] ahci 0000:87:00.2: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
[   26.364585][  T611] ahci 0000:87:00.2: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part 
[   26.376125][  T289] megaraid_sas 0000:c1:00.0: FW now in Ready state
[   26.382534][  T289] megaraid_sas 0000:c1:00.0: 63 bit DMA mask and 32 bit consistent mask
[   26.391537][  T289] megaraid_sas 0000:c1:00.0: firmware supports msix	: (96)
[   26.431767][  T611] scsi host1: ahci
[   26.492580][  T611] ata1: SATA max UDMA/133 abar m4096@0xc0a02000 port 0xc0a02100 irq 60
[   26.701197][  T283] bnxt_en 0000:84:00.0 eth0: Broadcom BCM57416 NetXtreme-E 10GBase-T Ethernet found at mem ad210000, node addr 4c:d9:8f:4a:20:e6
[   26.714352][  T283] bnxt_en 0000:84:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
[   26.743738][   T24] tg3 0000:81:00.0 eth1: Tigon3 [partno(BCM95720) rev 5720000] (PCI Express) MAC address 4c:d9:8f:65:3f:32
[   26.754974][   T24] tg3 0000:81:00.0 eth1: attached PHY is 5720C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[   26.765523][   T24] tg3 0000:81:00.0 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
[   26.774074][   T24] tg3 0000:81:00.0 eth1: dma_rwctrl[00000001] dma_mask[64-bit]
[   26.842518][  T620] ata1: SATA link down (SStatus 0 SControl 300)
[   26.945741][  T289] megaraid_sas 0000:c1:00.0: requested/available msix 49/49
[   26.952912][  T289] megaraid_sas 0000:c1:00.0: current msix/online cpus	: (49/48)
[   26.960401][  T289] megaraid_sas 0000:c1:00.0: RDPQ mode	: (disabled)
[   26.966876][  T289] megaraid_sas 0000:c1:00.0: Current firmware supports maximum commands: 928	 LDIO threshold: 0
[   27.079361][  T289] megaraid_sas 0000:c1:00.0: Performance mode :Latency (latency index = 1)
[   27.085381][  T283] bnxt_en 0000:84:00.1 eth2: Broadcom BCM57416 NetXtreme-E 10GBase-T Ethernet found at mem ad200000, node addr 4c:d9:8f:4a:20:e7
[   27.087824][  T289] megaraid_sas 0000:c1:00.0: FW supports sync cache	: No
[   27.100959][  T283] bnxt_en 0000:84:00.1: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
[   27.107835][  T289] megaraid_sas 0000:c1:00.0: megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
[   27.130978][   T24] tg3 0000:81:00.1 eth3: Tigon3 [partno(BCM95720) rev 5720000] (PCI Express) MAC address 4c:d9:8f:65:3f:33
[   27.142919][   T24] tg3 0000:81:00.1 eth3: attached PHY is 5720C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[   27.146042][  T571] bnxt_en 0000:84:00.1 enp132s0f1np1: renamed from eth2
[   27.153456][   T24] tg3 0000:81:00.1 eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
[   27.153467][   T24] tg3 0000:81:00.1 eth3: dma_rwctrl[00000001] dma_mask[64-bit]
[   27.200900][  T289] megaraid_sas 0000:c1:00.0: FW provided supportMaxExtLDs: 1	max_lds: 64
[   27.209174][  T289] megaraid_sas 0000:c1:00.0: controller type	: MR(2048MB)
[   27.216260][  T289] megaraid_sas 0000:c1:00.0: Online Controller Reset(OCR)	: Enabled
[   27.224105][  T289] megaraid_sas 0000:c1:00.0: Secure JBOD support	: No
[   27.230720][  T289] megaraid_sas 0000:c1:00.0: NVMe passthru support	: No
[   27.237527][  T289] megaraid_sas 0000:c1:00.0: FW provided TM TaskAbort/Reset timeout	: 0 secs/0 secs
[   27.246754][  T289] megaraid_sas 0000:c1:00.0: JBOD sequence map support	: No
[   27.253906][  T289] megaraid_sas 0000:c1:00.0: PCI Lane Margining support	: No
[   27.341447][  T289] megaraid_sas 0000:c1:00.0: megasas_enable_intr_fusion is called outbound_intr_mask:0x40000000
[   27.351729][  T289] megaraid_sas 0000:c1:00.0: INIT adapter done
[   27.357742][  T289] megaraid_sas 0000:c1:00.0: JBOD sequence map is disabled megasas_setup_jbod_map 5709
[   27.367832][  T289] megaraid_sas 0000:c1:00.0: pci id		: (0x1000)/(0x005d)/(0x1028)/(0x1f47)
[   27.376287][  T289] megaraid_sas 0000:c1:00.0: unevenspan support	: yes
[   27.382925][  T289] megaraid_sas 0000:c1:00.0: firmware crash dump	: no
[   27.389547][  T289] megaraid_sas 0000:c1:00.0: JBOD sequence map	: disabled
[   27.397816][  T289] megaraid_sas 0000:c1:00.0: Max firmware commands: 927 shared with nr_hw_queues = 48
[   27.407232][  T289] scsi host0: Avago SAS based MegaRAID driver
[   27.430212][  T586] bnxt_en 0000:84:00.0 enp132s0f0np0: renamed from eth0
[   27.781038][  T603] tg3 0000:81:00.0 eno1: renamed from eth1
[   28.194046][  T552] tg3 0000:81:00.1 eno2: renamed from eth3

[  251.961152][  T330] INFO: task systemd-udevd:567 blocked for more than 122 seconds.
[  251.968876][  T330]       Not tainted 5.10.0-rc1-next-20201102 #1
[  251.975003][  T330] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  251.983546][  T330] task:systemd-udevd   state:D stack:27224 pid:  567 ppid:   506 flags:0x00004324
[  251.992620][  T330] Call Trace:
[  251.995784][  T330]  __schedule+0x71d/0x1b60
[  252.000067][  T330]  ? __sched_text_start+0x8/0x8
[  252.004798][  T330]  schedule+0xbf/0x270
[  252.008735][  T330]  schedule_timeout+0x3fc/0x590
[  252.013464][  T330]  ? usleep_range+0x120/0x120
[  252.018008][  T330]  ? wait_for_completion+0x156/0x250
[  252.023176][  T330]  ? lock_downgrade+0x700/0x700
[  252.027886][  T330]  ? rcu_read_unlock+0x40/0x40
[  252.032530][  T330]  ? do_raw_spin_lock+0x121/0x290
[  252.037412][  T330]  ? lockdep_hardirqs_on_prepare+0x27c/0x3d0
[  252.043268][  T330]  ? _raw_spin_unlock_irq+0x1f/0x30
[  252.048331][  T330]  wait_for_completion+0x15e/0x250
[  252.053323][  T330]  ? wait_for_completion_interruptible+0x320/0x320
[  252.059687][  T330]  ? lockdep_hardirqs_on_prepare+0x27c/0x3d0
[  252.065543][  T330]  ? _raw_spin_unlock_irq+0x1f/0x30
[  252.070606][  T330]  __flush_work+0x42a/0x900
[  252.074989][  T330]  ? queue_delayed_work_on+0x90/0x90
[  252.080139][  T330]  ? __queue_work+0x463/0xf40
[  252.084700][  T330]  ? init_pwq+0x320/0x320
[  252.088891][  T330]  ? queue_work_on+0x5e/0x80
[  252.093364][  T330]  ? trace_hardirqs_on+0x1c/0x150
[  252.098255][  T330]  work_on_cpu+0xe7/0x130
[  252.102461][  T330]  ? flush_delayed_work+0xc0/0xc0
[  252.107342][  T330]  ? __mutex_unlock_slowpath+0xd4/0x670
[  252.112764][  T330]  ? work_debug_hint+0x30/0x30
[  252.117391][  T330]  ? pci_device_shutdown+0x80/0x80
[  252.122378][  T330]  ? cpumask_next_and+0x57/0x80
[  252.127094][  T330]  pci_device_probe+0x500/0x5c0
[  252.131824][  T330]  ? pci_device_remove+0x1f0/0x1f0
[  252.136805][  T330]  really_probe+0x207/0xad0
[  252.141191][  T330]  ? device_driver_attach+0x120/0x120
[  252.146428][  T330]  driver_probe_device+0x1f1/0x370
[  252.151424][  T330]  device_driver_attach+0xe5/0x120
[  252.156399][  T330]  __driver_attach+0xf0/0x260
[  252.160953][  T330]  bus_for_each_dev+0x117/0x1a0
[  252.165669][  T330]  ? subsys_dev_iter_exit+0x10/0x10
[  252.170731][  T330]  bus_add_driver+0x399/0x560
[  252.175289][  T330]  driver_register+0x189/0x310
[  252.179919][  T330]  ? 0xffffffffc05c1000
[  252.183960][  T330]  megasas_init+0x117/0x1000 [megaraid_sas]
[  252.189713][  T330]  do_one_initcall+0xf6/0x510
[  252.194267][  T330]  ? perf_trace_initcall_level+0x490/0x490
[  252.199940][  T330]  ? kasan_unpoison_shadow+0x30/0x40
[  252.205104][  T330]  ? __kasan_kmalloc.constprop.11+0xc1/0xd0
[  252.210859][  T330]  ? do_init_module+0x49/0x6c0
[  252.215500][  T330]  ? kmem_cache_alloc_trace+0x11f/0x1e0
[  252.220925][  T330]  ? kasan_unpoison_shadow+0x30/0x40
[  252.226068][  T330]  do_init_module+0x1ed/0x6c0
[  252.230608][  T330]  load_module+0x4a59/0x5d20
[  252.235081][  T330]  ? layout_and_allocate+0x2770/0x2770
[  252.240404][  T330]  ? __vmalloc_node+0x8d/0x100
[  252.245046][  T330]  ? kernel_read_file+0x485/0x5a0
[  252.249934][  T330]  ? kernel_read_file+0x305/0x5a0
[  252.254839][  T330]  ? __x64_sys_fsconfig+0x970/0x970
[  252.259903][  T330]  ? __do_sys_finit_module+0xff/0x180
[  252.265153][  T330]  __do_sys_finit_module+0xff/0x180
[  252.270216][  T330]  ? __do_sys_init_module+0x1d0/0x1d0
[  252.275465][  T330]  ? __fget_files+0x1c3/0x2e0
[  252.280010][  T330]  do_syscall_64+0x33/0x40
[  252.284304][  T330]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  252.290054][  T330] RIP: 0033:0x7fbb3e2fa78d
[  252.294348][  T330] Code: Unable to access opcode bytes at RIP 0x7fbb3e2fa763.
[  252.301584][  T330] RSP: 002b:00007ffe572e8d18 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  252.309855][  T330] RAX: ffffffffffffffda RBX: 000055c7795d90f0 RCX: 00007fbb3e2fa78d
[  252.317703][  T330] RDX: 0000000000000000 RSI: 00007fbb3ee6c82d RDI: 0000000000000006
[  252.325553][  T330] RBP: 00007fbb3ee6c82d R08: 0000000000000000 R09: 00007ffe572e8e40
[  252.333402][  T330] R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000000
[  252.341257][  T330] R13: 000055c7795930e0 R14: 0000000000020000 R15: 0000000000000000
[  252.349117][  T330] 
[  252.349117][  T330] Showing all locks held in the system:
[  252.356770][  T330] 3 locks held by kworker/3:1/289:
[  252.361759][  T330]  #0: ffff8881001eb938 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x7ec/0x1610
[  252.371976][  T330]  #1: ffffc90004ee7e00 ((work_completion)(&wfc.work)){+.+.}-{0:0}, at: process_one_work+0x820/0x1610
[  252.382803][  T330]  #2: ffff8881430380e0 (&shost->scan_mutex){+.+.}-{3:3}, at: scsi_scan_host_selected+0xde/0x260
[  252.393199][  T330] 1 lock held by khungtaskd/330:
[  252.397993][  T330]  #0: ffffffff9d4d3760 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire.constprop.52+0x0/0x30
[  252.408296][  T330] 1 lock held by systemd-journal/420:
[  252.413562][  T330] 1 lock held by systemd-udevd/567:
[  252.418619][  T330]  #0: ffff8881207ac218 (&dev->mutex){....}-{3:3}, at: device_driver_attach+0x37/0x120
[  252.428159][  T330] 
[  252.430355][  T330] =============================================
[  252.430355][  T330] 

> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 39 +++++++++++++++++++++
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 29 ++++++++-------
>  2 files changed, 55 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 861f7140f52e..6960922d0d7f 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -37,6 +37,7 @@
>  #include <linux/poll.h>
>  #include <linux/vmalloc.h>
>  #include <linux/irq_poll.h>
> +#include <linux/blk-mq-pci.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -113,6 +114,10 @@ unsigned int enable_sdev_max_qd;
>  module_param(enable_sdev_max_qd, int, 0444);
>  MODULE_PARM_DESC(enable_sdev_max_qd, "Enable sdev max qd as can_queue.
> Default: 0");
>  
> +int host_tagset_enable = 1;
> +module_param(host_tagset_enable, int, 0444);
> +MODULE_PARM_DESC(host_tagset_enable, "Shared host tagset enable/disable
> Default: enable(1)");
> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux.pdl@broadcom.com");
> @@ -3119,6 +3124,19 @@ megasas_bios_param(struct scsi_device *sdev, struct
> block_device *bdev,
>  	return 0;
>  }
>  
> +static int megasas_map_queues(struct Scsi_Host *shost)
> +{
> +	struct megasas_instance *instance;
> +
> +	instance = (struct megasas_instance *)shost->hostdata;
> +
> +	if (shost->nr_hw_queues == 1)
> +		return 0;
> +
> +	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> +			instance->pdev, instance->low_latency_index_start);
> +}
> +
>  static void megasas_aen_polling(struct work_struct *work);
>  
>  /**
> @@ -3427,6 +3445,7 @@ static struct scsi_host_template megasas_template = {
>  	.eh_timed_out = megasas_reset_timer,
>  	.shost_attrs = megaraid_host_attrs,
>  	.bios_param = megasas_bios_param,
> +	.map_queues = megasas_map_queues,
>  	.change_queue_depth = scsi_change_queue_depth,
>  	.max_segment_size = 0xffffffff,
>  };
> @@ -6808,6 +6827,26 @@ static int megasas_io_attach(struct megasas_instance
> *instance)
>  	host->max_lun = MEGASAS_MAX_LUN;
>  	host->max_cmd_len = 16;
>  
> +	/* Use shared host tagset only for fusion adaptors
> +	 * if there are managed interrupts (smp affinity enabled case).
> +	 * Single msix_vectors in kdump, so shared host tag is also disabled.
> +	 */
> +
> +	host->host_tagset = 0;
> +	host->nr_hw_queues = 1;
> +
> +	if ((instance->adapter_type != MFI_SERIES) &&
> +		(instance->msix_vectors > instance->low_latency_index_start) &&
> +		host_tagset_enable &&
> +		instance->smp_affinity_enable) {
> +		host->host_tagset = 1;
> +		host->nr_hw_queues = instance->msix_vectors -
> +			instance->low_latency_index_start;
> +	}
> +
> +	dev_info(&instance->pdev->dev,
> +		"Max firmware commands: %d shared with nr_hw_queues = %d\n",
> +		instance->max_fw_cmds, host->nr_hw_queues);
>  	/*
>  	 * Notify the mid-layer about the new controller
>  	 */
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 0824410f78f8..a4251121f173 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -359,24 +359,29 @@ megasas_get_msix_index(struct megasas_instance
> *instance,
>  {
>  	int sdev_busy;
>  
> -	/* nr_hw_queue = 1 for MegaRAID */
> -	struct blk_mq_hw_ctx *hctx =
> -		scmd->device->request_queue->queue_hw_ctx[0];
> -
> -	sdev_busy = atomic_read(&hctx->nr_active);
> +	/* TBD - if sml remove device_busy in future, driver
> +	 * should track counter in internal structure.
> +	 */
> +	sdev_busy = atomic_read(&scmd->device->device_busy);
>  
>  	if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
> -	    sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
> +	    sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH)) {
>  		cmd->request_desc->SCSIIO.MSIxIndex =
>  			mega_mod64((atomic64_add_return(1, &instance-
> >high_iops_outstanding) /
>  					MR_HIGH_IOPS_BATCH_COUNT), instance-
> >low_latency_index_start);
> -	else if (instance->msix_load_balance)
> +	} else if (instance->msix_load_balance) {
>  		cmd->request_desc->SCSIIO.MSIxIndex =
>  			(mega_mod64(atomic64_add_return(1, &instance-
> >total_io_count),
>  				instance->msix_vectors));
> -	else
> +	} else if (instance->host->nr_hw_queues > 1) {
> +		u32 tag = blk_mq_unique_tag(scmd->request);
> +
> +		cmd->request_desc->SCSIIO.MSIxIndex =
> blk_mq_unique_tag_to_hwq(tag) +
> +			instance->low_latency_index_start;
> +	} else {
>  		cmd->request_desc->SCSIIO.MSIxIndex =
>  			instance->reply_map[raw_smp_processor_id()];
> +	}
>  }
>  
>  /**
> @@ -956,9 +961,6 @@ megasas_alloc_cmds_fusion(struct megasas_instance
> *instance)
>  	if (megasas_alloc_cmdlist_fusion(instance))
>  		goto fail_exit;
>  
> -	dev_info(&instance->pdev->dev, "Configured max firmware commands: %d\n",
> -		 instance->max_fw_cmds);
> -
>  	/* The first 256 bytes (SMID 0) is not used. Don't add to the cmd list
> */
>  	io_req_base = fusion->io_request_frames +
> MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
>  	io_req_base_phys = fusion->io_request_frames_phys +
> MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
> @@ -1102,8 +1104,9 @@ megasas_ioc_init_fusion(struct megasas_instance
> *instance)
>  		MR_HIGH_IOPS_QUEUE_COUNT) && cur_intr_coalescing)
>  		instance->perf_mode = MR_BALANCED_PERF_MODE;
>  
> -	dev_info(&instance->pdev->dev, "Performance mode :%s\n",
> -		MEGASAS_PERF_MODE_2STR(instance->perf_mode));
> +	dev_info(&instance->pdev->dev, "Performance mode :%s (latency index =
> %d)\n",
> +		MEGASAS_PERF_MODE_2STR(instance->perf_mode),
> +		instance->low_latency_index_start);
>  
>  	instance->fw_sync_cache_support = (scratch_pad_1 &
>  		MR_CAN_HANDLE_SYNC_CACHE_OFFSET) ? 1 : 0;

