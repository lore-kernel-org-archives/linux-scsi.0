From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: mpt3sas: driver got task abort request just after it's .shutdown()
 function is invoked
Date: Wed, 14 Jun 2017 12:20:51 +0530
Message-ID: <CAK=zhgqfFhLcpZGYrsBRjCiFRwz_8sf=hEt+Jd1aJEvMd8x61Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "jejb@kernel.org" <jejb@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi All,

I am using 4.9 kernel and I am observing NULL pointer deference type
kernel panic in the below scenario,

* Hotplug (i.e. hot add) the HBA (with a set of drives attached to it)
to the system just few seconds before issuing "poweroff" command.

* Observed that during drives discovery process; for some of the
drives "MODE SENSE" command got timed out.

* And as "poweroff" command issued, so kernel as called driver's
shutdown() callback function and driver has cleaned up all the HBA
resources (such as IRQ's, memory pools etc).

* But as the "MODE SENSE" command got timed out, so SCSI EH thread has
invoked driver's .eh_abort_handler() callback function, but by this
time driver has already cleaned up the resources and so it leads to
kernel panic when it trying to access one of these resources.

I was assuming that kernel should not call driver's shutdown()
callback function until all the outstanding IOs count reaches to zero
(i.e. kernel should call the driver's shutdown() functions only after
clearing up all the outstanding IOs). Please correct me if I am wrong,
and please suggest better way to handle these types of issues.

Thanks,
Sreekanth


Here I am copying the required driver logs,

[  429.995550] mpt3sas 0000:b6:00.0: enabling device (0100 -> 0102)
[  429.995629] mpt3sas_cm3: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED,
total mem (131164804 kB)
[  429.995636] mpt3sas_cm3: _base_get_ioc_facts
[  429.995636] mpt3sas_cm3: _base_wait_for_iocstate
[  430.109107]     offset:data
[  430.109107]     [0x00]:03110206
[  430.109108]     [0x04]:00002e00
[  430.109108]     [0x08]:00000000
[  430.109108]     [0x0c]:00000000
[  430.109109]     [0x10]:00000000
[  430.109109]     [0x14]:60010080
[  430.109110]     [0x18]:22281700
[  430.109110]     [0x1c]:0007a85c
[  430.109110]     [0x20]:0e000000
[  430.109111]     [0x24]:00100040
[  430.109111]     [0x28]:0180001b
[  430.109111]     [0x2c]:00b100b0
[  430.109112]     [0x30]:006c0003
[  430.109112]     [0x34]:0020ffe0
[  430.109112]     [0x38]:00800263
[  430.109113]     [0x3c]:00000019
[  430.109113] mpt3sas_cm3: IOC Number : 0
[  430.109114] mpt3sas_cm3: hba queue depth(5888), max chains per io(128)
[  430.109114] mpt3sas_cm3: request frame size(256), reply frame size(128)
[  430.109130] mpt3sas_cm3: msix is supported, vector_count(96)
[  430.109131] mpt3sas_cm3: MSI-X vectors supported: 96, no of cores:
16, max_msix_vectors: -1
[  430.109497] mpt3sas3-msix0: PCI-MSI-X enabled: IRQ 76
[  430.109497] mpt3sas3-msix1: PCI-MSI-X enabled: IRQ 77
[  430.109498] mpt3sas3-msix2: PCI-MSI-X enabled: IRQ 78
[  430.109498] mpt3sas3-msix3: PCI-MSI-X enabled: IRQ 79
[  430.109499] mpt3sas3-msix4: PCI-MSI-X enabled: IRQ 80
[  430.109499] mpt3sas3-msix5: PCI-MSI-X enabled: IRQ 81
[  430.109499] mpt3sas3-msix6: PCI-MSI-X enabled: IRQ 82
[  430.109500] mpt3sas3-msix7: PCI-MSI-X enabled: IRQ 83
[  430.109500] mpt3sas3-msix8: PCI-MSI-X enabled: IRQ 84
[  430.109500] mpt3sas3-msix9: PCI-MSI-X enabled: IRQ 85
[  430.109501] mpt3sas3-msix10: PCI-MSI-X enabled: IRQ 86
[  430.109501] mpt3sas3-msix11: PCI-MSI-X enabled: IRQ 87
[  430.109502] mpt3sas3-msix12: PCI-MSI-X enabled: IRQ 88
[  430.109502] mpt3sas3-msix13: PCI-MSI-X enabled: IRQ 89
[  430.109502] mpt3sas3-msix14: PCI-MSI-X enabled: IRQ 90
[  430.109503] mpt3sas3-msix15: PCI-MSI-X enabled: IRQ 91
[  430.109504] mpt3sas_cm3: iomem(0x00000000fb800000),
mapped(0xffffc9000e890000), size(65536)
[  430.109504] mpt3sas_cm3: ioport(0x000000000000c000), size(256)
[  430.109531] mpt3sas_cm3: _base_get_ioc_facts
[  430.109531] mpt3sas_cm3: _base_wait_for_iocstate
[  430.222840]     offset:data
[  430.222840]     [0x00]:03110206
[  430.222841]     [0x04]:00002e00
[  430.222841]     [0x08]:00000000
[  430.222842]     [0x0c]:00000000
[  430.222842]     [0x10]:00000000
[  430.222842]     [0x14]:60010080
[  430.222843]     [0x18]:22281700
[  430.222843]     [0x1c]:0007a85c
[  430.222844]     [0x20]:0e000000
[  430.222844]     [0x24]:00100040
[  430.222844]     [0x28]:0180001b
[  430.222845]     [0x2c]:00b100b0
[  430.222845]     [0x30]:006c0003
[  430.222846]     [0x34]:0020ffe0
[  430.222846]     [0x38]:00800263
[  430.222846]     [0x3c]:00000019
[  430.222847] mpt3sas_cm3: IOC Number : 0
[  430.222847] mpt3sas_cm3: hba queue depth(5888), max chains per io(128)
[  430.222848] mpt3sas_cm3: request frame size(256), reply frame size(128)
[  430.222848] mpt3sas_cm3: _base_make_ioc_ready
[  430.222850] mpt3sas_cm3: _base_get_port_facts
[  430.276713]     offset:data
[  430.276714]     [0x00]:05070000
[  430.276714]     [0x04]:00000000
[  430.276714]     [0x08]:00000000
[  430.276715]     [0x0c]:00000000
[  430.276715]     [0x10]:00000000
[  430.276716]     [0x14]:00003000
[  430.276716]     [0x18]:000000d8
[  430.276716] mpt3sas_cm3: _base_allocate_memory_pools
[  430.276717] mpt3sas_cm3: scatter gather: sge_in_main_msg(8),
sge_per_chain(15), sge_per_io(128), chains_per_io(9)
[  430.276718] mpt3sas_cm3: scsi host: can_queue depth (5772)
[  430.276810] mpt3sas_cm3: request pool(0xffff881fe4a00000):
depth(5996), frame_size(256), pool_size(1499 kB)
[  430.276810] mpt3sas_cm3: request pool: dma(0x1fe4a00000)
[  430.276811] mpt3sas_cm3: scsiio(0xffff881fe4a00000): depth(5775)
[  430.307213] mpt3sas_cm3: chain pool depth(51975), frame_size(256),
pool_size(12993 kB)
[  430.307214] mpt3sas_cm3: hi_priority(0xffff881fe4b69000):
depth(108), start smid(5776)
[  430.307215] mpt3sas_cm3: internal(0xffff881fe4b6fc00): depth(113),
start smid(5884)
[  430.307250] mpt3sas_cm3: sense pool(0xffff881fef100000):
depth(5775), element_size(96), pool_size(541 kB)
[  430.307250] mpt3sas_cm3: sense_dma(0x1fef100000)
[  430.307299] mpt3sas_cm3: reply pool(0xffff881fee300000):
depth(6060), frame_size(128), pool_size(757 kB)
[  430.307299] mpt3sas_cm3: reply_dma(0x1fee300000)
[  430.307302] mpt3sas_cm3: reply_free pool(0xffff881feda08000):
depth(6060), element_size(4), pool_size(23 kB)
[  430.307302] mpt3sas_cm3: reply_free_dma(0x1feda08000)
[  430.307487] mpt3sas_cm3: reply post free pool (0xffff881fe4600000):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307488] mpt3sas_cm3: reply_post_free_dma = (0x1fe4600000)
[  430.307488] mpt3sas_cm3: reply post free pool (0xffff881fe4617900):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307489] mpt3sas_cm3: reply_post_free_dma = (0x1fe4617900)
[  430.307489] mpt3sas_cm3: reply post free pool (0xffff881fe462f200):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307490] mpt3sas_cm3: reply_post_free_dma = (0x1fe462f200)
[  430.307490] mpt3sas_cm3: reply post free pool (0xffff881fe4646b00):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307491] mpt3sas_cm3: reply_post_free_dma = (0x1fe4646b00)
[  430.307491] mpt3sas_cm3: reply post free pool (0xffff881fe465e400):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307492] mpt3sas_cm3: reply_post_free_dma = (0x1fe465e400)
[  430.307492] mpt3sas_cm3: reply post free pool (0xffff881fe4675d00):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307493] mpt3sas_cm3: reply_post_free_dma = (0x1fe4675d00)
[  430.307493] mpt3sas_cm3: reply post free pool (0xffff881fe468d600):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307494] mpt3sas_cm3: reply_post_free_dma = (0x1fe468d600)
[  430.307494] mpt3sas_cm3: reply post free pool (0xffff881fe46a4f00):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307495] mpt3sas_cm3: reply_post_free_dma = (0x1fe46a4f00)
[  430.307495] mpt3sas_cm3: reply post free pool (0xffff881fe46bc800):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307496] mpt3sas_cm3: reply_post_free_dma = (0x1fe46bc800)
[  430.307496] mpt3sas_cm3: reply post free pool (0xffff881fe46d4100):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307497] mpt3sas_cm3: reply_post_free_dma = (0x1fe46d4100)
[  430.307497] mpt3sas_cm3: reply post free pool (0xffff881fe46eba00):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307498] mpt3sas_cm3: reply_post_free_dma = (0x1fe46eba00)
[  430.307498] mpt3sas_cm3: reply post free pool (0xffff881fe4703300):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307499] mpt3sas_cm3: reply_post_free_dma = (0x1fe4703300)
[  430.307499] mpt3sas_cm3: reply post free pool (0xffff881fe471ac00):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307500] mpt3sas_cm3: reply_post_free_dma = (0x1fe471ac00)
[  430.307500] mpt3sas_cm3: reply post free pool (0xffff881fe4732500):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307501] mpt3sas_cm3: reply_post_free_dma = (0x1fe4732500)
[  430.307501] mpt3sas_cm3: reply post free pool (0xffff881fe4749e00):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307501] mpt3sas_cm3: reply_post_free_dma = (0x1fe4749e00)
[  430.307502] mpt3sas_cm3: reply post free pool (0xffff881fe4761700):
depth(12064), element_size(16), pool_size(94 kB)
[  430.307502] mpt3sas_cm3: reply_post_free_dma = (0x1fe4761700)
[  430.307503] mpt3sas_cm3: config page(0xffff881feefa4000): size(512)
[  430.307504] mpt3sas_cm3: config_page_dma(0x1feefa4000)
[  430.307504] mpt3sas_cm3: Allocated physical memory: size(17324 kB)
[  430.307505] mpt3sas_cm3: Current Controller Queue Depth(5772), Max
Controller Queue Depth(5888)
[  430.307505] mpt3sas_cm3: Scatter Gather Elements per IO(128)
[  430.307507] mpt3sas_cm3: _base_make_ioc_operational
[  430.308777] mpt3sas_cm3: _base_send_ioc_init
[  430.308779]     offset:data
[  430.308780]     [0x00]:02000004
[  430.308780]     [0x04]:01000000
[  430.308781]     [0x08]:00000000
[  430.308781]     [0x0c]:2a000206
[  430.308781]     [0x10]:00000000
[  430.308782]     [0x14]:10000000
[  430.308782]     [0x18]:00400000
[  430.308783]     [0x1c]:17ac2f20
[  430.308783]     [0x20]:0000001f
[  430.308784]     [0x24]:0000001f
[  430.308784]     [0x28]:e4a00000
[  430.308785]     [0x2c]:0000001f
[  430.308785]     [0x30]:eefa5000
[  430.308786]     [0x34]:0000001f
[  430.308786]     [0x38]:eda08000
[  430.308786]     [0x3c]:0000001f
[  430.308787]     [0x40]:a1004832
[  430.308787]     [0x44]:0000015c
[  430.395435]     offset:data
[  430.395436]     [0x00]:02050004
[  430.395436]     [0x04]:01000000
[  430.395436]     [0x08]:00000000
[  430.395437]     [0x0c]:00000000
[  430.395437]     [0x10]:00000000
[  430.395461] mpt3sas_cm3: _base_event_notification
[  430.395479] mpt3sas_cm3: _base_event_notification: complete
[  430.395723] mpt3sas_cm3: LSISAS3224: FWVersion(14.00.00.00),
ChipRevision(0x01), BiosVersion(08.31.00.00)
[  430.395724] mpt3sas_cm3: Protocol=(
[  430.395724] Initiator
[  430.395725] ,Target
[  430.395725] ),
[  430.395725] Capabilities=(
[  430.395726] TLR
[  430.395726] ,EEDP
[  430.395727] ,Snapshot Buffer
[  430.395727] ,Diag Trace Buffer
[  430.395727] ,Task Set Full
[  430.395727] ,NCQ
[  430.395728] )
[  430.395787] mpt3sas_cm3: : host protection capabilities enabled
DIF1 DIF2 DIF3
[  430.395789] scsi host11: Fusion MPT SAS Host
[  430.396029] mpt3sas_cm3: sending port enable !!
[  430.433348] sd 0:0:14:0: attempting task abort! scmd(ffff881feaa0b600)
[  430.433350] sd 0:0:14:0: tag#14 CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  430.433351] scsi target0:0:14: handle(0x0027),
sas_address(0x300a0d1002395e0f), phy(15)
[  430.433352] scsi target0:0:14: enclosure logical
id(0x500a0d1002395e00), slot(14)
[  430.433353] scsi target0:0:14: enclosure level(0x0000), connector name(     )
[  430.433396] sd 0:0:14:0: task abort: SUCCESS scmd(ffff881feaa0b600)
[  430.433402] sd 0:0:15:0: attempting task abort! scmd(ffff881fed1be880)
[  430.433403] sd 0:0:15:0: tag#15 CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  430.433404] scsi target0:0:15: handle(0x0028),
sas_address(0x300a0d1002395e11), phy(17)
[  430.433405] scsi target0:0:15: enclosure logical
id(0x500a0d1002395e00), slot(17)
[  430.433406] scsi target0:0:15: enclosure level(0x0000), connector name(     )
[  430.433411] sd 0:0:15:0: task abort: SUCCESS scmd(ffff881fed1be880)
[  430.433455] sd 0:0:14:0: [sdp] Write Protect is off
[  430.433457] sd 0:0:14:0: [sdp] Mode Sense: 9b 00 10 08
[  430.433477] sd 0:0:15:0: [sdq] Write Protect is off
[  430.433479] sd 0:0:15:0: [sdq] Mode Sense: 9b 00 10 08
[  430.433850] sd 0:0:14:0: [sdp] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  430.433900] sd 0:0:14:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  430.433902] mpt3sas_cm0:     sas_address(0x300a0d1002395e0f), phy(15)
[  430.433902] mpt3sas_cm0:     enclosure logical
id(0x500a0d1002395e00), slot(14)
[  430.433903] mpt3sas_cm0:     enclosure level(0x0000), connector name(     )
[  430.433904] mpt3sas_cm0:     handle(0x0027),
ioc_status(success)(0x0000), smid(3)
[  430.433905] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[  430.433906] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  430.433906] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  430.433907] mpt3sas_cm0:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  430.433990] sd 0:0:15:0: [sdq] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  430.434039] sd 0:0:15:0: tag#1 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  430.434041] mpt3sas_cm0:     sas_address(0x300a0d1002395e11), phy(17)
[  430.434042] mpt3sas_cm0:     enclosure logical
id(0x500a0d1002395e00), slot(17)
[  430.434042] mpt3sas_cm0:     enclosure level(0x0000), connector name(     )
[  430.434043] mpt3sas_cm0:     handle(0x0028),
ioc_status(success)(0x0000), smid(1)
[  430.434044] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[  430.434045] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  430.434045] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  430.434046] mpt3sas_cm0:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  430.470673] sd 0:0:14:0: [sdp] Attached SCSI disk
[  430.471965] sd 0:0:15:0: [sdq] Attached SCSI disk
[  431.453965] sd 0:0:16:0: attempting task abort! scmd(ffff881fef308000)
[  431.453969] sd 0:0:16:0: tag#16 CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  431.453973] scsi target0:0:16: handle(0x0029),
sas_address(0x300a0d1002395e12), phy(18)
[  431.453975] scsi target0:0:16: enclosure logical
id(0x500a0d1002395e00), slot(19)
[  431.453978] scsi target0:0:16: enclosure level(0x0000), connector name(     )
[  431.453996] sd 0:0:16:0: task abort: SUCCESS scmd(ffff881fef308000)
[  431.454005] sd 0:0:17:0: attempting task abort! scmd(ffff881feb5cfa80)
[  431.454008] sd 0:0:17:0: tag#17 CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  431.454011] scsi target0:0:17: handle(0x002a),
sas_address(0x300a0d1002395e13), phy(19)
[  431.454014] scsi target0:0:17: enclosure logical
id(0x500a0d1002395e00), slot(18)
[  431.454016] scsi target0:0:17: enclosure level(0x0000), connector name(     )
[  431.454030] sd 0:0:17:0: task abort: SUCCESS scmd(ffff881feb5cfa80)
[  431.454062] sd 0:0:16:0: [sdr] Write Protect is off
[  431.454068] sd 0:0:16:0: [sdr] Mode Sense: 9b 00 10 08
[  431.454096] sd 0:0:17:0: [sds] Write Protect is off
[  431.454102] sd 0:0:17:0: [sds] Mode Sense: 9b 00 10 08
[  431.454492] sd 0:0:16:0: [sdr] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  431.454528] sd 0:0:17:0: [sds] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  431.454562] sd 0:0:16:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  431.454567] mpt3sas_cm0:     sas_address(0x300a0d1002395e12), phy(18)
[  431.454569] mpt3sas_cm0:     enclosure logical
id(0x500a0d1002395e00), slot(19)
[  431.454571] mpt3sas_cm0:     enclosure level(0x0000), connector name(     )
[  431.454573] mpt3sas_cm0:     handle(0x0029),
ioc_status(success)(0x0000), smid(1)
[  431.454575] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[  431.454578] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  431.454580] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  431.454582] mpt3sas_cm0:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  431.454596] sd 0:0:17:0: tag#1 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  431.454601] mpt3sas_cm0:     sas_address(0x300a0d1002395e13), phy(19)
[  431.454603] mpt3sas_cm0:     enclosure logical
id(0x500a0d1002395e00), slot(18)
[  431.454605] mpt3sas_cm0:     enclosure level(0x0000), connector name(     )
[  431.454607] mpt3sas_cm0:     handle(0x002a),
ioc_status(success)(0x0000), smid(3)
[  431.454610] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[  431.454612] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  431.454614] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  431.454629] mpt3sas_cm0:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  431.491773] sd 0:0:17:0: [sds] Attached SCSI disk
[  431.496134] sd 0:0:16:0: [sdr] Attached SCSI disk
[  432.164043] mpt3sas_cm3: Discovery: (start)
[  432.164045]
[  432.164056] mpt3sas_cm3: discovery event: (start)
[  432.164057]
[  432.164116] mpt3sas_cm3: SAS Enclosure Device Status Change
[  432.164124] mpt3sas_cm3: SAS Topology Change List
[  432.166523] mpt3sas_cm3: host_add: handle(0x0001),
sas_addr(0x500a0d1002390a00), phys(24)
[  432.166556] mpt3sas_cm3: enclosure status change: (enclosure add)
    handle(0x0001), enclosure logical id(0x500a0d1002390a00) number slots(0)
[  432.166556] mpt3sas_cm3: sas topology change: (responding)
[  432.166557]     handle(0x0000), enclosure_handle(0x0001)
start_phy(00), count(1)
[  432.166558]     phy(00), attached_handle(0x0019): target add: link
rate: new(0x0a), old(0x00)
[  432.166559] mpt3sas_cm3: updating handles for sas_host(0x500a0d1002390a00)
[  432.166724] mpt3sas_cm3: _scsih_sas_device_add: handle(0x0019),
sas_addr(0x300a0d1002390a00)
[  432.166725] mpt3sas_cm3: _scsih_sas_device_add: enclosure logical
id(0x500a0d1002390a00), slot( 0)
[  432.166725] mpt3sas_cm3: _scsih_sas_device_add: enclosure
level(0x0000), connector name(     )
[  432.413463] mpt3sas_cm3: Discovery: (stop)
[  432.413465]
[  432.413507] mpt3sas_cm3: Discovery: (start)
[  432.413509]
[  432.413567] mpt3sas_cm3: SAS Topology Change List
[  432.413575] mpt3sas_cm3: Discovery: (stop)
[  432.413576]
[  432.413604] mpt3sas_cm3: Discovery: (start)
[  432.413605]
[  432.413660] mpt3sas_cm3: SAS Topology Change List
[  432.413669] mpt3sas_cm3: Discovery: (stop)
[  432.413671]
[  432.413697] mpt3sas_cm3: Discovery: (start)
[  432.413698]
[  432.413752] mpt3sas_cm3: SAS Topology Change List
[  432.413762] mpt3sas_cm3: Discovery: (stop)
[  432.413763]
[  432.475571] sd 0:0:18:0: attempting task abort! scmd(ffff881fef30a400)
[  432.475576] sd 0:0:18:0: tag#18 CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  432.475580] scsi target0:0:18: handle(0x002b),
sas_address(0x300a0d1002395e15), phy(21)
[  432.475583] scsi target0:0:18: enclosure logical
id(0x500a0d1002395e00), slot(21)
[  432.475586] scsi target0:0:18: enclosure level(0x0000), connector name(     )
[  432.475628] sd 0:0:18:0: task abort: SUCCESS scmd(ffff881fef30a400)
[  432.475640] sd 0:0:19:0: attempting task abort! scmd(ffff881fe9fda580)
[  432.475643] sd 0:0:19:0: tag#19 CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  432.475647] scsi target0:0:19: handle(0x002c),
sas_address(0x300a0d1002395e16), phy(22)
[  432.475649] scsi target0:0:19: enclosure logical
id(0x500a0d1002395e00), slot(23)
[  432.475651] scsi target0:0:19: enclosure level(0x0000), connector name(     )
[  432.475666] sd 0:0:19:0: task abort: SUCCESS scmd(ffff881fe9fda580)
[  432.475696] sd 0:0:18:0: [sdt] Write Protect is off
[  432.475702] sd 0:0:18:0: [sdt] Mode Sense: 9b 00 10 08
[  432.475731] sd 0:0:19:0: [sdu] Write Protect is off
[  432.475737] sd 0:0:19:0: [sdu] Mode Sense: 9b 00 10 08
[  432.476123] sd 0:0:18:0: [sdt] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  432.476153] sd 0:0:19:0: [sdu] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  432.476186] sd 0:0:18:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  432.476190] mpt3sas_cm0:     sas_address(0x300a0d1002395e15), phy(21)
[  432.476192] mpt3sas_cm0:     enclosure logical
id(0x500a0d1002395e00), slot(21)
[  432.476194] mpt3sas_cm0:     enclosure level(0x0000), connector name(     )
[  432.476197] mpt3sas_cm0:     handle(0x002b),
ioc_status(success)(0x0000), smid(3)
[  432.476199] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[  432.476201] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  432.476204] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  432.476206] mpt3sas_cm0:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  432.476221] sd 0:0:19:0: tag#1 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  432.476225] mpt3sas_cm0:     sas_address(0x300a0d1002395e16), phy(22)
[  432.476227] mpt3sas_cm0:     enclosure logical
id(0x500a0d1002395e00), slot(23)
[  432.476229] mpt3sas_cm0:     enclosure level(0x0000), connector name(     )
[  432.476232] mpt3sas_cm0:     handle(0x002c),
ioc_status(success)(0x0000), smid(1)
[  432.476234] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[  432.476236] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  432.476238] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  432.476241] mpt3sas_cm0:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  432.513055] sd 0:0:19:0: [sdu] Attached SCSI disk
[  432.520529] sd 0:0:18:0: [sdt] Attached SCSI disk
[  432.662844] mpt3sas_cm3: Discovery: (start)
[  432.662845]
[  432.662903] mpt3sas_cm3: SAS Topology Change List
[  432.662911] mpt3sas_cm3: Discovery: (stop)
[  432.662912]
[  432.662955] mpt3sas_cm3: Discovery: (start)
[  432.662956]
[  432.663011] mpt3sas_cm3: SAS Topology Change List
[  432.663021] mpt3sas_cm3: Discovery: (stop)
[  432.663022]
[  432.663296] scsi 11:0:0:0: Direct-Access     ATA      HGST
HUH721010AL W2J2 PQ: 0 ANSI: 6
[  432.663446] mpt3sas_cm3:     ioc_status(0x0045),
loginfo(0x00000000), scsi_status(0x00), scsi_state(0x00), rc(ready)
[  432.663452] scsi 11:0:0:0: SATA: handle(0x0019),
sas_addr(0x300a0d1002390a00), phy(0), device_name(0x0000000000000000)
[  432.663456] scsi 11:0:0:0: SATA: enclosure logical
id(0x500a0d1002390a00), slot(0)
[  432.663459] scsi 11:0:0:0: SATA: enclosure level(0x0000), connector
name(     )
[  432.663514] scsi 11:0:0:0: atapi(n), ncq(y), asyn_notify(n),
smart(y), fua(y), sw_preserve(y)
[  432.663664] scsi 11:0:0:0: serial_number(7GHENS9K            )
[  432.676484] sd 11:0:0:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[  432.676486] mpt3sas_cm3:     sas_address(0x300a0d1002390a00), phy(0)
[  432.676486] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(0)
[  432.676487] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  432.676488] mpt3sas_cm3:     handle(0x0019),
ioc_status(success)(0x0000), smid(1)
[  432.676489] mpt3sas_cm3:     request_len(0), underflow(0), resid(0)
[  432.676490] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  432.676490] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  432.676491] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x06,0x29,0x00], count(18)
[  432.676504] sd 11:0:0:0: Attached scsi generic sg69 type 0
[  432.676537] mpt3sas_cm3: discovery event: (stop)
[  432.676537]
[  432.676538] mpt3sas_cm3: discovery event: (start)
[  432.676538]
[  432.676539] mpt3sas_cm3: sas topology change: (responding)
[  432.676540]     handle(0x0000), enclosure_handle(0x0001)
start_phy(01), count(1)
[  432.676541]     phy(01), attached_handle(0x001a): target add: link
rate: new(0x0a), old(0x00)
[  432.676542] mpt3sas_cm3: updating handles for sas_host(0x500a0d1002390a00)
[  432.676835] sd 11:0:0:0: [sdbr] 19532873728 512-byte logical
blocks: (10.0 TB/9.10 TiB)
[  432.676837] sd 11:0:0:0: [sdbr] 4096-byte physical blocks
[  432.677065] mpt3sas_cm3: _scsih_sas_device_add: handle(0x001a),
sas_addr(0x300a0d1002390a01)
[  432.677066] mpt3sas_cm3: _scsih_sas_device_add: enclosure logical
id(0x500a0d1002390a00), slot( 1)
[  432.677066] mpt3sas_cm3: _scsih_sas_device_add: enclosure
level(0x0000), connector name(     )
[  432.682987] sd 11:0:0:0: [sdbr] Write Protect is off
[  432.682989] sd 11:0:0:0: [sdbr] Mode Sense: 9b 00 10 08
[  432.683342] sd 11:0:0:0: [sdbr] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  432.683390] sd 11:0:0:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  432.683392] mpt3sas_cm3:     sas_address(0x300a0d1002390a00), phy(0)
[  432.683392] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(0)
[  432.683393] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  432.683393] mpt3sas_cm3:     handle(0x0019),
ioc_status(success)(0x0000), smid(1)
[  432.683394] mpt3sas_cm3:     request_len(512), underflow(0), resid(512)
[  432.683395] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  432.683395] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  432.683396] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  432.718117] sd 11:0:0:0: [sdbr] Attached SCSI disk
[  432.912251] mpt3sas_cm3: Discovery: (start)
[  432.912252]
[  432.912313] mpt3sas_cm3: SAS Topology Change List
[  432.912322] mpt3sas_cm3: Discovery: (stop)
[  432.912323]
[  432.912364] mpt3sas_cm3: Discovery: (start)
[  432.912364]
[  432.912421] mpt3sas_cm3: SAS Topology Change List
[  432.912430] mpt3sas_cm3: Discovery: (stop)
[  432.912430]
[  432.912459] mpt3sas_cm3: Discovery: (start)
[  432.912460]
[  432.912516] mpt3sas_cm3: SAS Topology Change List
[  432.912525] mpt3sas_cm3: Discovery: (stop)
[  432.912525]
[  433.161959] scsi 11:0:1:0: Direct-Access     ATA      HGST
HUH721010AL W2J2 PQ: 0 ANSI: 6
[  433.162095] mpt3sas_cm3:     ioc_status(0x0045),
loginfo(0x00000000), scsi_status(0x00), scsi_state(0x00), rc(ready)
[  433.162096] scsi 11:0:1:0: SATA: handle(0x001a),
sas_addr(0x300a0d1002390a01), phy(1), device_name(0x0000000000000000)
[  433.162097] scsi 11:0:1:0: SATA: enclosure logical
id(0x500a0d1002390a00), slot(1)
[  433.162098] scsi 11:0:1:0: SATA: enclosure level(0x0000), connector
name(     )
[  433.162138] scsi 11:0:1:0: atapi(n), ncq(y), asyn_notify(n),
smart(y), fua(y), sw_preserve(y)
[  433.162279] scsi 11:0:1:0: serial_number(7PHVZGUC            )
[  433.174130] sd 11:0:1:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[  433.174132] mpt3sas_cm3:     sas_address(0x300a0d1002390a01), phy(1)
[  433.174132] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(1)
[  433.174133] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  433.174134] mpt3sas_cm3:     handle(0x001a),
ioc_status(success)(0x0000), smid(2)
[  433.174134] mpt3sas_cm3:     request_len(0), underflow(0), resid(0)
[  433.174135] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  433.174136] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  433.174136] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x06,0x29,0x00], count(18)
[  433.174165] sd 11:0:1:0: Attached scsi generic sg70 type 0
[  433.174188] mpt3sas_cm3: discovery event: (stop)
[  433.174188]
[  433.174189] mpt3sas_cm3: discovery event: (start)
[  433.174189]
[  433.174190] mpt3sas_cm3: sas topology change: (responding)
[  433.174191]     handle(0x0000), enclosure_handle(0x0001)
start_phy(02), count(1)
[  433.174192]     phy(02), attached_handle(0x001b): target add: link
rate: new(0x0a), old(0x00)
[  433.174192] mpt3sas_cm3: updating handles for sas_host(0x500a0d1002390a00)
[  433.174464] sd 11:0:1:0: [sdbs] 19532873728 512-byte logical
blocks: (10.0 TB/9.10 TiB)
[  433.174465] sd 11:0:1:0: [sdbs] 4096-byte physical blocks
[  433.174815] mpt3sas_cm3: _scsih_sas_device_add: handle(0x001b),
sas_addr(0x300a0d1002390a02)
[  433.174816] mpt3sas_cm3: _scsih_sas_device_add: enclosure logical
id(0x500a0d1002390a00), slot( 3)
[  433.174817] mpt3sas_cm3: _scsih_sas_device_add: enclosure
level(0x0000), connector name(     )
[  433.180565] sd 11:0:1:0: [sdbs] Write Protect is off
[  433.180567] sd 11:0:1:0: [sdbs] Mode Sense: 9b 00 10 08
[  433.180910] sd 11:0:1:0: [sdbs] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  433.180957] sd 11:0:1:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  433.180957] mpt3sas_cm3:     sas_address(0x300a0d1002390a01), phy(1)
[  433.180958] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(1)
[  433.180958] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  433.180959] mpt3sas_cm3:     handle(0x001a),
ioc_status(success)(0x0000), smid(2)
[  433.180959] mpt3sas_cm3:     request_len(512), underflow(0), resid(512)
[  433.180960] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  433.180960] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  433.180961] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  433.217502] sd 11:0:1:0: [sdbs] Attached SCSI disk
[  433.497164] sd 0:0:20:0: attempting task abort! scmd(ffff881fed1bea00)
[  433.497166] sd 0:0:20:0: tag#20 CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  433.497168] scsi target0:0:20: handle(0x002d),
sas_address(0x300a0d1002395e17), phy(23)
[  433.497168] scsi target0:0:20: enclosure logical
id(0x500a0d1002395e00), slot(22)
[  433.497169] scsi target0:0:20: enclosure level(0x0000), connector name(     )
[  433.497196] sd 0:0:20:0: task abort: SUCCESS scmd(ffff881fed1bea00)
[  433.497255] sd 0:0:20:0: [sdv] Write Protect is off
[  433.497257] sd 0:0:20:0: [sdv] Mode Sense: 9b 00 10 08
[  433.497645] sd 0:0:20:0: [sdv] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  433.497711] sd 0:0:20:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  433.497715] mpt3sas_cm0:     sas_address(0x300a0d1002395e17), phy(23)
[  433.497717] mpt3sas_cm0:     enclosure logical
id(0x500a0d1002395e00), slot(22)
[  433.497719] mpt3sas_cm0:     enclosure level(0x0000), connector name(     )
[  433.497722] mpt3sas_cm0:     handle(0x002d),
ioc_status(success)(0x0000), smid(3)
[  433.497724] mpt3sas_cm0:     request_len(512), underflow(0), resid(512)
[  433.497726] mpt3sas_cm0:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  433.497729] mpt3sas_cm0:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  433.497731] mpt3sas_cm0:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  433.503606] mpt3sas_cm3: Discovery: (start)
[  433.503607]
[  433.503635] mpt3sas_cm3: SAS Topology Change List
[  433.503645] mpt3sas_cm3: Discovery: (stop)
[  433.503645]
[  433.524686] mpt3sas_cm3: Discovery: (start)
[  433.524687]
[  433.524712] mpt3sas_cm3: SAS Topology Change List
[  433.524720] mpt3sas_cm3: Discovery: (stop)
[  433.524721]
[  433.542623] sd 0:0:20:0: [sdv] Attached SCSI disk
[  433.549923] scsi 11:0:2:0: Direct-Access     ATA      HGST
HUH721010AL W2J2 PQ: 0 ANSI: 6
[  433.550072] mpt3sas_cm3:     ioc_status(0x0045),
loginfo(0x00000000), scsi_status(0x00), scsi_state(0x00), rc(ready)
[  433.550077] scsi 11:0:2:0: SATA: handle(0x001b),
sas_addr(0x300a0d1002390a02), phy(2), device_name(0x0000000000000000)
[  433.550080] scsi 11:0:2:0: SATA: enclosure logical
id(0x500a0d1002390a00), slot(3)
[  433.550084] scsi 11:0:2:0: SATA: enclosure level(0x0000), connector
name(     )
[  433.550138] scsi 11:0:2:0: atapi(n), ncq(y), asyn_notify(n),
smart(y), fua(y), sw_preserve(y)
[  433.550293] scsi 11:0:2:0: serial_number(7PHVX8RC            )
[  433.558321] sd 11:0:2:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[  433.558326] mpt3sas_cm3:     sas_address(0x300a0d1002390a02), phy(2)
[  433.558328] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(3)
[  433.558330] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  433.558332] mpt3sas_cm3:     handle(0x001b),
ioc_status(success)(0x0000), smid(1)
[  433.558334] mpt3sas_cm3:     request_len(0), underflow(0), resid(0)
[  433.558337] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  433.558339] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  433.558342] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x06,0x29,0x00], count(18)
[  433.558442] sd 11:0:2:0: Attached scsi generic sg71 type 0
[  433.558468] mpt3sas_cm3: discovery event: (stop)
[  433.558469]
[  433.558469] mpt3sas_cm3: discovery event: (start)
[  433.558470]
[  433.558471] mpt3sas_cm3: sas topology change: (responding)
[  433.558471]     handle(0x0000), enclosure_handle(0x0001)
start_phy(03), count(1)
[  433.558472]     phy(03), attached_handle(0x001c): target add: link
rate: new(0x0a), old(0x00)
[  433.558472] mpt3sas_cm3: updating handles for sas_host(0x500a0d1002390a00)
[  433.558675] sd 11:0:2:0: [sdbt] 19532873728 512-byte logical
blocks: (10.0 TB/9.10 TiB)
[  433.558676] sd 11:0:2:0: [sdbt] 4096-byte physical blocks
[  433.559123] mpt3sas_cm3: _scsih_sas_device_add: handle(0x001c),
sas_addr(0x300a0d1002390a03)
[  433.559124] mpt3sas_cm3: _scsih_sas_device_add: enclosure logical
id(0x500a0d1002390a00), slot( 2)
[  433.559124] mpt3sas_cm3: _scsih_sas_device_add: enclosure
level(0x0000), connector name(     )
[  433.564803] sd 11:0:2:0: [sdbt] Write Protect is off
[  433.564804] sd 11:0:2:0: [sdbt] Mode Sense: 9b 00 10 08
[  433.565154] sd 11:0:2:0: [sdbt] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  433.565202] sd 11:0:2:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  433.565203] mpt3sas_cm3:     sas_address(0x300a0d1002390a02), phy(2)
[  433.565203] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(3)
[  433.565204] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  433.565204] mpt3sas_cm3:     handle(0x001b),
ioc_status(success)(0x0000), smid(1)
[  433.565205] mpt3sas_cm3:     request_len(512), underflow(0), resid(512)
[  433.565205] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  433.565206] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  433.565207] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  433.597429] mpt3sas_cm3: Discovery: (start)
[  433.597429]
[  433.597456] mpt3sas_cm3: SAS Topology Change List
[  433.597465] mpt3sas_cm3: Discovery: (stop)
[  433.597465]
[  433.630608] mpt3sas_cm3: Discovery: (start)
[  433.630608]
[  433.630634] mpt3sas_cm3: SAS Topology Change List
[  433.630644] mpt3sas_cm3: Discovery: (stop)
[  433.630644]
[  433.703719] mpt3sas_cm3: Discovery: (start)
[  433.703719]
[  433.703745] mpt3sas_cm3: SAS Topology Change List
[  433.703754] mpt3sas_cm3: Discovery: (stop)
[  433.703754]
[  433.724784] mpt3sas_cm3: Discovery: (start)
[  433.724784]
[  433.724809] mpt3sas_cm3: SAS Topology Change List
[  433.724817] mpt3sas_cm3: Discovery: (stop)
[  433.724818]
[  433.809795] mpt3sas_cm3: Discovery: (start)
[  433.809796]
[  433.809820] mpt3sas_cm3: SAS Topology Change List
[  433.809829] mpt3sas_cm3: Discovery: (stop)
[  433.809829]
[  433.869461] sd 11:0:2:0: [sdbt] Attached SCSI disk
[  433.930239] scsi 11:0:3:0: Direct-Access     ATA      HGST
HUH721010AL W2J2 PQ: 0 ANSI: 6
[  433.930374] mpt3sas_cm3:     ioc_status(0x0045),
loginfo(0x00000000), scsi_status(0x00), scsi_state(0x00), rc(ready)
[  433.930376] scsi 11:0:3:0: SATA: handle(0x001c),
sas_addr(0x300a0d1002390a03), phy(3), device_name(0x0000000000000000)
[  433.930377] scsi 11:0:3:0: SATA: enclosure logical
id(0x500a0d1002390a00), slot(2)
[  433.930377] scsi 11:0:3:0: SATA: enclosure level(0x0000), connector
name(     )
[  433.930417] scsi 11:0:3:0: atapi(n), ncq(y), asyn_notify(n),
smart(y), fua(y), sw_preserve(y)
[  433.930556] scsi 11:0:3:0: serial_number(7GHT43AK            )
[  433.949247] sd 11:0:3:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[  433.949248] mpt3sas_cm3:     sas_address(0x300a0d1002390a03), phy(3)
[  433.949249] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(2)
[  433.949249] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  433.949250] mpt3sas_cm3:     handle(0x001c),
ioc_status(success)(0x0000), smid(2)
[  433.949250] mpt3sas_cm3:     request_len(0), underflow(0), resid(0)
[  433.949251] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  433.949251] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  433.949252] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x06,0x29,0x00], count(18)
[  433.949291] sd 11:0:3:0: Attached scsi generic sg72 type 0
[  433.949310] mpt3sas_cm3: discovery event: (stop)
[  433.949311]
[  433.949311] mpt3sas_cm3: discovery event: (start)
[  433.949312]
[  433.949312] mpt3sas_cm3: sas topology change: (responding)
[  433.949313]     handle(0x0000), enclosure_handle(0x0001)
start_phy(04), count(1)
[  433.949314]     phy(04), attached_handle(0x001d): target add: link
rate: new(0x0a), old(0x00)
[  433.949314] mpt3sas_cm3: updating handles for sas_host(0x500a0d1002390a00)
[  433.949581] sd 11:0:3:0: [sdbu] 19532873728 512-byte logical
blocks: (10.0 TB/9.10 TiB)
[  433.949582] sd 11:0:3:0: [sdbu] 4096-byte physical blocks
[  433.949931] mpt3sas_cm3: _scsih_sas_device_add: handle(0x001d),
sas_addr(0x300a0d1002390a04)
[  433.949932] mpt3sas_cm3: _scsih_sas_device_add: enclosure logical
id(0x500a0d1002390a00), slot( 4)
[  433.949932] mpt3sas_cm3: _scsih_sas_device_add: enclosure
level(0x0000), connector name(     )
[  433.955691] sd 11:0:3:0: [sdbu] Write Protect is off
[  433.955692] sd 11:0:3:0: [sdbu] Mode Sense: 9b 00 10 08
[  433.956039] sd 11:0:3:0: [sdbu] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  433.956087] sd 11:0:3:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  433.956088] mpt3sas_cm3:     sas_address(0x300a0d1002390a03), phy(3)
[  433.956088] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(2)
[  433.956088] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  433.956089] mpt3sas_cm3:     handle(0x001c),
ioc_status(success)(0x0000), smid(2)
[  433.956089] mpt3sas_cm3:     request_len(512), underflow(0), resid(512)
[  433.956090] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  433.956090] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  433.956091] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  434.032521] sd 11:0:3:0: [sdbu] Attached SCSI disk
[  434.162076] mpt3sas_cm3: Discovery: (start)
[  434.162076]
[  434.162137] mpt3sas_cm3: SAS Topology Change List
[  434.162146] mpt3sas_cm3: Discovery: (stop)
[  434.162146]
[  434.414118] mpt3sas_cm3: Discovery: (start)
[  434.414118]
[  434.414177] mpt3sas_cm3: SAS Topology Change List
[  434.414186] mpt3sas_cm3: Discovery: (stop)
[  434.414186]
[  434.414227] mpt3sas_cm3: Discovery: (start)
[  434.414228]
[  434.414282] mpt3sas_cm3: SAS Topology Change List
[  434.414291] mpt3sas_cm3: Discovery: (stop)
[  434.414291]
[  434.414313] mpt3sas_cm3: Discovery: (start)
[  434.414314]
[  434.414367] mpt3sas_cm3: SAS Topology Change List
[  434.414375] mpt3sas_cm3: Discovery: (stop)
[  434.414376]
[  434.414399] mpt3sas_cm3: Discovery: (start)
[  434.414399]
[  434.414452] mpt3sas_cm3: SAS Topology Change List
[  434.414461] mpt3sas_cm3: Discovery: (stop)
[  434.414461]
[  434.414484] mpt3sas_cm3: Discovery: (start)
[  434.414484]
[  434.414537] mpt3sas_cm3: SAS Topology Change List
[  434.414546] mpt3sas_cm3: Discovery: (stop)
[  434.414546]
[  434.414569] mpt3sas_cm3: Discovery: (start)
[  434.414570]
[  434.414622] mpt3sas_cm3: SAS Topology Change List
[  434.426887] scsi 11:0:4:0: Direct-Access     ATA      HGST
HUH721010AL W2J2 PQ: 0 ANSI: 6
[  434.427043] mpt3sas_cm3:     ioc_status(0x0045),
loginfo(0x00000000), scsi_status(0x00), scsi_state(0x00), rc(ready)
[  434.427045] scsi 11:0:4:0: SATA: handle(0x001d),
sas_addr(0x300a0d1002390a04), phy(4), device_name(0x0000000000000000)
[  434.427045] scsi 11:0:4:0: SATA: enclosure logical
id(0x500a0d1002390a00), slot(4)
[  434.427046] scsi 11:0:4:0: SATA: enclosure level(0x0000), connector
name(     )
[  434.427094] scsi 11:0:4:0: atapi(n), ncq(y), asyn_notify(n),
smart(y), fua(y), sw_preserve(y)
[  434.427246] scsi 11:0:4:0: serial_number(7PHVRAYC            )
[  434.459262] sd 11:0:4:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[  434.459267] mpt3sas_cm3:     sas_address(0x300a0d1002390a04), phy(4)
[  434.459269] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(4)
[  434.459271] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  434.459274] mpt3sas_cm3:     handle(0x001d),
ioc_status(success)(0x0000), smid(1)
[  434.459276] mpt3sas_cm3:     request_len(0), underflow(0), resid(0)
[  434.459278] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  434.459280] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  434.459283] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x06,0x29,0x00], count(18)
[  434.459344] sd 11:0:4:0: Attached scsi generic sg73 type 0
[  434.459402] mpt3sas_cm3: discovery event: (stop)
[  434.459403]
[  434.459405] mpt3sas_cm3: discovery event: (start)
[  434.459406]
[  434.459409] mpt3sas_cm3: sas topology change: (responding)
[  434.459411]     handle(0x0000), enclosure_handle(0x0001)
start_phy(05), count(1)
[  434.459414]     phy(05), attached_handle(0x001e): target add: link
rate: new(0x0a), old(0x00)
[  434.459415] mpt3sas_cm3: updating handles for sas_host(0x500a0d1002390a00)
[  434.459673] sd 11:0:4:0: [sdbv] 19532873728 512-byte logical
blocks: (10.0 TB/9.10 TiB)
[  434.459677] sd 11:0:4:0: [sdbv] 4096-byte physical blocks
[  434.460578] mpt3sas_cm3: _scsih_sas_device_add: handle(0x001e),
sas_addr(0x300a0d1002390a05)
[  434.460579] mpt3sas_cm3: _scsih_sas_device_add: enclosure logical
id(0x500a0d1002390a00), slot( 5)
[  434.460579] mpt3sas_cm3: _scsih_sas_device_add: enclosure
level(0x0000), connector name(     )
[  434.465912] sd 11:0:4:0: [sdbv] Write Protect is off
[  434.465913] sd 11:0:4:0: [sdbv] Mode Sense: 9b 00 10 08
[  434.466296] sd 11:0:4:0: [sdbv] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  434.466349] sd 11:0:4:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  434.466350] mpt3sas_cm3:     sas_address(0x300a0d1002390a04), phy(4)
[  434.466350] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(4)
[  434.466351] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  434.466351] mpt3sas_cm3:     handle(0x001d),
ioc_status(success)(0x0000), smid(1)
[  434.466352] mpt3sas_cm3:     request_len(512), underflow(0), resid(512)
[  434.466352] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  434.466353] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  434.466354] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  434.520996] sd 11:0:4:0: [sdbv] Attached SCSI disk
[  434.658110] mpt3sas_cm3: Discovery: (start)
[  434.658111]
[  434.658171] mpt3sas_cm3: SAS Topology Change List
[  434.658180] mpt3sas_cm3: Discovery: (stop)
[  434.658180]
[  434.658257] mpt3sas_cm3: Discovery: (start)
[  434.658257]
[  434.658312] mpt3sas_cm3: SAS Topology Change List
[  434.658321] mpt3sas_cm3: Discovery: (stop)
[  434.658321]
[  434.658349] mpt3sas_cm3: Discovery: (start)
[  434.658349]
[  434.658403] mpt3sas_cm3: SAS Topology Change List
[  434.658412] mpt3sas_cm3: Discovery: (stop)
[  434.658412]
[  434.907543] mpt3sas_cm3: Discovery: (stop)
[  434.907544]
[  434.907581] mpt3sas_cm3: Discovery: (start)
[  434.907581]
[  434.907639] mpt3sas_cm3: SAS Topology Change List
[  434.907648] mpt3sas_cm3: Discovery: (stop)
[  434.907648]
[  434.907670] mpt3sas_cm3: Discovery: (start)
[  434.907670]
[  434.907723] mpt3sas_cm3: SAS Topology Change List
[  434.907732] mpt3sas_cm3: Discovery: (stop)
[  434.907732]
[  434.907952] scsi 11:0:5:0: Direct-Access     ATA      HGST
HUH721010AL W2J2 PQ: 0 ANSI: 6
[  434.908088] mpt3sas_cm3:     ioc_status(0x0045),
loginfo(0x00000000), scsi_status(0x00), scsi_state(0x00), rc(ready)
[  434.908090] scsi 11:0:5:0: SATA: handle(0x001e),
sas_addr(0x300a0d1002390a05), phy(5), device_name(0x0000000000000000)
[  434.908091] scsi 11:0:5:0: SATA: enclosure logical
id(0x500a0d1002390a00), slot(5)
[  434.908092] scsi 11:0:5:0: SATA: enclosure level(0x0000), connector
name(     )
[  434.908132] scsi 11:0:5:0: atapi(n), ncq(y), asyn_notify(n),
smart(y), fua(y), sw_preserve(y)
[  434.908272] scsi 11:0:5:0: serial_number(7GHRZ40K            )
[  434.918977] sd 11:0:5:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[  434.918978] mpt3sas_cm3:     sas_address(0x300a0d1002390a05), phy(5)
[  434.918978] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(5)
[  434.918979] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  434.918979] mpt3sas_cm3:     handle(0x001e),
ioc_status(success)(0x0000), smid(2)
[  434.918980] mpt3sas_cm3:     request_len(0), underflow(0), resid(0)
[  434.918981] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  434.918981] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  434.918982] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x06,0x29,0x00], count(18)
[  434.919021] sd 11:0:5:0: Attached scsi generic sg74 type 0
[  434.919042] mpt3sas_cm3: discovery event: (stop)
[  434.919043]
[  434.919044] mpt3sas_cm3: discovery event: (start)
[  434.919044]
[  434.919045] mpt3sas_cm3: sas topology change: (responding)
[  434.919046]     handle(0x0000), enclosure_handle(0x0001)
start_phy(06), count(1)
[  434.919046]     phy(06), attached_handle(0x001f): target add: link
rate: new(0x0a), old(0x00)
[  434.919047] mpt3sas_cm3: updating handles for sas_host(0x500a0d1002390a00)
[  434.919304] sd 11:0:5:0: [sdbw] 19532873728 512-byte logical
blocks: (10.0 TB/9.10 TiB)
[  434.919305] sd 11:0:5:0: [sdbw] 4096-byte physical blocks
[  434.920194] mpt3sas_cm3: _scsih_sas_device_add: handle(0x001f),
sas_addr(0x300a0d1002390a06)
[  434.920195] mpt3sas_cm3: _scsih_sas_device_add: enclosure logical
id(0x500a0d1002390a00), slot( 7)
[  434.920196] mpt3sas_cm3: _scsih_sas_device_add: enclosure
level(0x0000), connector name(     )
[  434.925444] sd 11:0:5:0: [sdbw] Write Protect is off
[  434.925445] sd 11:0:5:0: [sdbw] Mode Sense: 9b 00 10 08
[  434.925794] sd 11:0:5:0: [sdbw] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  434.925841] sd 11:0:5:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  434.925842] mpt3sas_cm3:     sas_address(0x300a0d1002390a05), phy(5)
[  434.925842] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(5)
[  434.925843] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  434.925843] mpt3sas_cm3:     handle(0x001e),
ioc_status(success)(0x0000), smid(2)
[  434.925844] mpt3sas_cm3:     request_len(512), underflow(0), resid(512)
[  434.925844] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  434.925845] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  434.925845] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  434.959235] sd 11:0:5:0: [sdbw] Attached SCSI disk
[  435.156931] mpt3sas_cm3: Discovery: (start)
[  435.156932]
[  435.156990] mpt3sas_cm3: SAS Topology Change List
[  435.156997] mpt3sas_cm3: Discovery: (stop)
[  435.156999]
[  435.157040] mpt3sas_cm3: Discovery: (start)
[  435.157041]
[  435.157096] mpt3sas_cm3: SAS Topology Change List
[  435.157103] mpt3sas_cm3: Discovery: (stop)
[  435.157104]
[  435.157133] mpt3sas_cm3: Discovery: (start)
[  435.157134]
[  435.157188] mpt3sas_cm3: SAS Topology Change List
[  435.157195] mpt3sas_cm3: Discovery: (stop)
[  435.157196]
[  435.406702] scsi 11:0:6:0: Direct-Access     ATA      HGST
HUH721010AL W2J2 PQ: 0 ANSI: 6
[  435.406838] mpt3sas_cm3:     ioc_status(0x0045),
loginfo(0x00000000), scsi_status(0x00), scsi_state(0x00), rc(ready)
[  435.406840] scsi 11:0:6:0: SATA: handle(0x001f),
sas_addr(0x300a0d1002390a06), phy(6), device_name(0x0000000000000000)
[  435.406841] scsi 11:0:6:0: SATA: enclosure logical
id(0x500a0d1002390a00), slot(7)
[  435.406842] scsi 11:0:6:0: SATA: enclosure level(0x0000), connector
name(     )
[  435.406883] scsi 11:0:6:0: atapi(n), ncq(y), asyn_notify(n),
smart(y), fua(y), sw_preserve(y)
[  435.407027] scsi 11:0:6:0: serial_number(7PHVX2DC            )
[  435.422004] sd 11:0:6:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[  435.422009] mpt3sas_cm3:     sas_address(0x300a0d1002390a06), phy(6)
[  435.422012] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(7)
[  435.422014] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  435.422016] mpt3sas_cm3:     handle(0x001f),
ioc_status(success)(0x0000), smid(1)
[  435.422018] mpt3sas_cm3:     request_len(0), underflow(0), resid(0)
[  435.422021] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  435.422023] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  435.422025] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x06,0x29,0x00], count(18)
[  435.422091] sd 11:0:6:0: Attached scsi generic sg75 type 0
[  435.422153] mpt3sas_cm3: discovery event: (stop)
[  435.422155]
[  435.422157] mpt3sas_cm3: discovery event: (start)
[  435.422158]
[  435.422160] mpt3sas_cm3: sas topology change: (responding)
[  435.422162]     handle(0x0000), enclosure_handle(0x0001)
start_phy(07), count(1)
[  435.422165]     phy(07), attached_handle(0x0020): target add: link
rate: new(0x0a), old(0x00)
[  435.422167] mpt3sas_cm3: updating handles for sas_host(0x500a0d1002390a00)
[  435.422405] sd 11:0:6:0: [sdbx] 19532873728 512-byte logical
blocks: (10.0 TB/9.10 TiB)
[  435.422408] sd 11:0:6:0: [sdbx] 4096-byte physical blocks
[  435.423458] mpt3sas_cm3: _scsih_sas_device_add: handle(0x0020),
sas_addr(0x300a0d1002390a07)
[  435.423459] mpt3sas_cm3: _scsih_sas_device_add: enclosure logical
id(0x500a0d1002390a00), slot( 6)
[  435.423459] mpt3sas_cm3: _scsih_sas_device_add: enclosure
level(0x0000), connector name(     )
[  435.428534] sd 11:0:6:0: [sdbx] Write Protect is off
[  435.428535] sd 11:0:6:0: [sdbx] Mode Sense: 9b 00 10 08
[  435.428890] sd 11:0:6:0: [sdbx] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  435.428937] sd 11:0:6:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  435.428938] mpt3sas_cm3:     sas_address(0x300a0d1002390a06), phy(6)
[  435.428939] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(7)
[  435.428939] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  435.428940] mpt3sas_cm3:     handle(0x001f),
ioc_status(success)(0x0000), smid(1)
[  435.428940] mpt3sas_cm3:     request_len(512), underflow(0), resid(512)
[  435.428941] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  435.428942] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  435.428942] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  435.462992] sd 11:0:6:0: [sdbx] Attached SCSI disk
[  435.905475] scsi 11:0:7:0: Direct-Access     ATA      HGST
HUH721010AL W2J2 PQ: 0 ANSI: 6
[  435.905621] mpt3sas_cm3:     ioc_status(0x0045),
loginfo(0x00000000), scsi_status(0x00), scsi_state(0x00), rc(ready)
[  435.905626] scsi 11:0:7:0: SATA: handle(0x0020),
sas_addr(0x300a0d1002390a07), phy(7), device_name(0x0000000000000000)
[  435.905630] scsi 11:0:7:0: SATA: enclosure logical
id(0x500a0d1002390a00), slot(6)
[  435.905633] scsi 11:0:7:0: SATA: enclosure level(0x0000), connector
name(     )
[  435.905687] scsi 11:0:7:0: atapi(n), ncq(y), asyn_notify(n),
smart(y), fua(y), sw_preserve(y)
[  435.905834] scsi 11:0:7:0: serial_number(7GHTBVRK            )
[  435.916796] sd 11:0:7:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[  435.916801] mpt3sas_cm3:     sas_address(0x300a0d1002390a07), phy(7)
[  435.916803] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(6)
[  435.916805] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  435.916808] mpt3sas_cm3:     handle(0x0020),
ioc_status(success)(0x0000), smid(2)
[  435.916810] mpt3sas_cm3:     request_len(0), underflow(0), resid(0)
[  435.916812] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  435.916815] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  435.916817] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x06,0x29,0x00], count(18)
[  435.916885] sd 11:0:7:0: Attached scsi generic sg76 type 0
[  435.916945] mpt3sas_cm3: discovery event: (stop)
[  435.916946]
[  435.916948] mpt3sas_cm3: discovery event: (start)
[  435.916949]
[  435.916952] mpt3sas_cm3: sas topology change: (responding)
[  435.916954]     handle(0x0000), enclosure_handle(0x0001)
start_phy(08), count(1)
[  435.916956]     phy(08), attached_handle(0x0021): target add: link
rate: new(0x0a), old(0x00)
[  435.916958] mpt3sas_cm3: updating handles for sas_host(0x500a0d1002390a00)
[  435.917195] sd 11:0:7:0: [sdby] 19532873728 512-byte logical
blocks: (10.0 TB/9.10 TiB)
[  435.917199] sd 11:0:7:0: [sdby] 4096-byte physical blocks
[  435.918304] mpt3sas_cm3: _scsih_sas_device_add: handle(0x0021),
sas_addr(0x300a0d1002390a08)
[  435.918305] mpt3sas_cm3: _scsih_sas_device_add: enclosure logical
id(0x500a0d1002390a00), slot( 8)
[  435.918306] mpt3sas_cm3: _scsih_sas_device_add: enclosure
level(0x0000), connector name(     )
[  435.923352] sd 11:0:7:0: [sdby] Write Protect is off
[  435.923353] sd 11:0:7:0: [sdby] Mode Sense: 9b 00 10 08
[  435.923706] sd 11:0:7:0: [sdby] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  435.923754] sd 11:0:7:0: tag#0 CDB: Report supported operation
codes a3 0c 01 12 00 00 00 00 02 00 00 00
[  435.923755] mpt3sas_cm3:     sas_address(0x300a0d1002390a07), phy(7)
[  435.923755] mpt3sas_cm3:     enclosure logical
id(0x500a0d1002390a00), slot(6)
[  435.923756] mpt3sas_cm3:     enclosure level(0x0000), connector name(     )
[  435.923756] mpt3sas_cm3:     handle(0x0020),
ioc_status(success)(0x0000), smid(2)
[  435.923757] mpt3sas_cm3:     request_len(512), underflow(0), resid(512)
[  435.923757] mpt3sas_cm3:     tag(65535), transfer_count(0),
sc->result(0x00000002)
[  435.923758] mpt3sas_cm3:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  435.923758] mpt3sas_cm3:     [sense_key,asc,ascq]:
[0x05,0x20,0x00], count(18)
[  435.956651] sd 11:0:7:0: [sdby] Attached SCSI disk
[  436.051236] sd 9:0:1:0: attempting task abort! scmd(ffff881fed618c00)
[  436.051238] sd 9:0:1:0: tag#1 CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  436.051240] scsi target9:0:1: handle(0x001a),
sas_address(0x300a0d1002397201), phy(1)
[  436.051241] scsi target9:0:1: enclosure logical
id(0x500a0d1002397200), slot(1)
[  436.051242] scsi target9:0:1: enclosure level(0x0000), connector name(     )
[  436.051261] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
[  436.059744] IP: [<ffffffffa076933b>]
_scsih_scsi_lookup_find_by_scmd+0x3b/0x80 [mpt3sas]
[  436.068471] PGD 0
[  436.070312]
[  436.072438] Oops: 0000 [#1] SMP
[  436.076200] Modules linked in: mpt3sas(O) fuse xt_CHECKSUM
iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack ipt_REJECT nf_reject_ipv4 tun ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter skx_edac edac_core
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel vfat fat kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel lrw gf128mul glue_helper ablk_helper cryptd
intel_rapl_perf iTCO_wdt iTCO_vendor_support pcspkr uas usb_storage
joydev input_leds ipmi_devintf shpchp mei_me i2c_i801 sg wmi mei
lpc_ich ipmi_si ipmi_msghandler mfd_core nfit acpi_pad i2c_smbus
acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables
xfs libcrc32c sd_mod crc32c_intel ast
[  436.151629]  drm_kms_helper raid_class syscopyarea sysfillrect
scsi_transport_sas sysimgblt igb fb_sys_fops ptp ttm pps_core dca ahci
i2c_algo_bit libahci drm libata fjes dm_mirror dm_region_hash dm_log
dm_mod [last unloaded: mpt3sas]
[  436.173047] CPU: 4 PID: 5439 Comm: kworker/u112:20 Tainted: G
    O    4.9.5-1.el7.elrepo.x86_64 #1
[  436.183352] Hardware name: ZTSYSTEM     WAIPOUA17/NJ460G4, BIOS
0.53a 06/07/2017
[  436.191510] Workqueue: scsi_tmf_9 scmd_eh_abort_handler
[  436.197525] task: ffff881fcbab8000 task.stack: ffffc9000cf94000
[  436.204216] RIP: 0010:[<ffffffffa076933b>]  [<ffffffffa076933b>]
_scsih_scsi_lookup_find_by_scmd+0x3b/0x80 [mpt3sas]
[  436.215543] RSP: 0018:ffffc9000cf97d88  EFLAGS: 00010046
[  436.221658] RAX: 0000000000000286 RBX: ffff881fed618c00 RCX: 0000000000000000
[  436.229594] RDX: 0000000000000001 RSI: ffff881fed618c00 RDI: ffff881fee4fb260
[  436.237521] RBP: ffffc9000cf97da0 R08: 0000000000000000 R09: 000000000000168f
[  436.245450] R10: 0000000000000000 R11: 0000000000000006 R12: ffff881fee4fa7e0
[  436.253380] R13: ffff881fee4fb260 R14: ffff881fe9fd3d00 R15: 0000000000000e00
[  436.261318] FS:  0000000000000000(0000) GS:ffff881ffed00000(0000)
knlGS:0000000000000000
[  436.270216] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  436.276777] CR2: 0000000000000008 CR3: 0000000001c07000 CR4: 00000000007406e0
[  436.284733] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  436.292686] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  436.300631] PKRU: 55555554
[  436.304177] Stack:
[  436.307014]  ffff881fed618c00 ffff881fee4fa7e0 ffff881fe9246560
ffffc9000cf97de8
[  436.315313]  ffffffffa07766a8 ffff881ff19e1280 0000000000019480
000000006645714b
[  436.323613]  ffff881ffec59480 ffff881fed618c28 ffff881fed618c00
ffff881feaac3800
[  436.331915] Call Trace:
[  436.335198]  [<ffffffffa07766a8>] scsih_abort+0x78/0x1d0 [mpt3sas]
[  436.342239]  [<ffffffff81501f4d>] scmd_eh_abort_handler+0xbd/0x280
[  436.349252]  [<ffffffff8109c342>] process_one_work+0x152/0x400
[  436.355917]  [<ffffffff8109cc35>] worker_thread+0x125/0x4b0
[  436.362326]  [<ffffffff8109cb10>] ? rescuer_thread+0x380/0x380
[  436.368993]  [<ffffffff810a2799>] kthread+0xd9/0xf0
[  436.374698]  [<ffffffff810a26c0>] ? kthread_park+0x60/0x60
[  436.381003]  [<ffffffff81756ad5>] ret_from_fork+0x25/0x30
[  436.387209] Code: 00 00 41 54 49 89 fc 4c 89 ef 53 48 89 f3 e8 3d
d4 fe e0 45 0f b7 8c 24 54 0a 00 00 45 85 c9 74 2b 4d 8b 84 24 70 0a
00 00 31 c9 <49> 39 58 08 49 8d 50 40 75
[  436.404308] scsi 11:0:8:0: Direct-Access     ATA      HGST
HUH721010AL W2J2 PQ: 0 ANSI: 6
[  436.404441] mpt3sas_cm3:     ioc_status(0x0045),
loginfo(0x00000000), scsi_status(0x00), scsi_state(0x00), rc(ready)
[  436.404443] scsi 11:0:8:0: SATA: handle(0x0021),
sas_addr(0x300a0d1002390a08), phy(8), device_name(0x0000000000000000)
[  436.404443] scsi 11:0:8:0: SATA: enclosure logical
id(0x500a0d1002390a00), slot(8)
[  436.404444] scsi 11:0:8:0: SATA: enclosure level(0x0000), connector
name(     )
[  436.404484] scsi 11:0:8:0: atapi(n), ncq(y), asyn_notify(n),
smart(y), fua(y), sw_preserve(y)
[  436.404622] scsi 11:0:8:0: serial_number(7GHT44ZK            )
[  436.468970] 0f
[  436.470558] eb 2b 49 89 d0 48 83 c2 40 48 39
[  436.474708] RIP  [<ffffffffa076933b>]
_scsih_scsi_lookup_find_by_scmd+0x3b/0x80 [mpt3sas]
[  436.483806]  RSP <ffffc9000cf97d88>
[  436.488275] CR2: 0000000000000008
