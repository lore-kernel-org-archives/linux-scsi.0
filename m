From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] first SCSI merge for 2.6.22
Date: Sun, 15 Jul 2007 10:24:17 -0500
Message-ID: <1184513059.3400.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52326 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758345AbXGOPYY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Jul 2007 11:24:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This represents the accumulated SCSI patches for the 2.6.22 merge windo=
w
(2.5MB of them, I'm afraid).  The major infrastructure change is
switching over to data buffer accessors in preparation for merging Jens
bsg tree and adding bidirectional command support.  Depending how the
other merges go, we may or may not get all of the bidirectional and SAS
command tap stuff in before the merge window closes.  Apart from this,
there are the usual assorted driver updates and bug fixes.

The patch is available from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (4):
      remove the dead CYBERSTORMIII_SCSI option
      advansys: cleanups
      ips: remove kernel 2.4 code
      nsp32: remove kernel 2.4 code

Akinobu Mita (1):
      sr: fix error handling in module_init

Alan Cox (3):
      ppa: coding police and printk levels
      a100u2w: Convert into Linux style
      initio: Convert into a real Linux driver and update to modern sty=
le

Amol Lad (1):
      NCR5380: Replace yield() with a better alternative

Andrew Morton (1):
      ncr5380 warning fixes

Bernhard Walle (1):
      sd: remove __GFP_DMA

Boaz Harrosh (3):
      scsi.c: convert to use the data buffer accessors
      tmscsim: Further clean-up of the driver
      lpfc: add missed data buffer accessor

Brian King (6):
      ibmvscsi: Abort path fix
      ibmvscsi: Misc. locking fixes
      ibmvscsi: Add eh_host_reset_handler
      ibmvscsi: Enhanced error logging
      ibmvscsi: Remove unnecessary map_sg check
      ibmvscsi: Changeable queue depth

Christof Schmitt (1):
      zfcp: Report FCP LUN to SCSI midlayer

Christoph Hellwig (4):
      esp: use shost_priv
      introduce shost_priv helper
      53c7xx: kill driver
      aha152x: use wait_for_completion_timeout

Cornelia Huck (1):
      don't build scsi_dma_{map,unmap} for !HAS_DMA

David C Somayajulu (10):
      qla4xxx: Fix underrun/overrun conditions
      qla4xxx: allow hba to be online when initiator ip address is unin=
itialized
      qla4xxx: ql4_os.c bugfixes
      qla4xxx: ql4_mbx.c remove dead code bugfixes
      qla4xxx: ql4_isr.c support for new mbx cmds
      qla4xxx: update rev num and misc cleanup
      qla4xxx: ql4_init.c bugfixes
      qla4xxx: ql4_fw.h add support for qla4032
      qla4xxx: ql4_def.h log all AENs and cleanup
      qla4xxx: ql4_dbg.c remove dead code

David Rientjes (1):
      gdth: fix ambiguous gdthtable definition

Ed Lin (1):
      stex: use resid for xfer len information

Eric Moore (8):
      mpt fusion: fix for mounted raid volume filesytem that goes read-=
only
      mpt fusion: cleanup eh handlers
      mpt fusion: bump version
      mpt fusion: fc loginfo using defines from the header
      mpt fusion: remove unused header - linux_compat.h
      mpt fusion: remove unused header - mpi_inb.h
      mpt fusion: new mpi headers version 1.5.16
      mpt fusion: update MAINTAINERS (fusion part)

Eric Sesterhenn (1):
      sg: remove unnecessary check

=46UJITA Tomonori (54):
      ibmvscsi: convert to use the data buffer accessors
      dc395x: convert to use the data buffer accessors
      ncr53c8xx: convert to use the data buffer accessors
      sym53c8xx: convert to use the data buffer accessors
      lpfc: fix NPIV mapping problems
      ibmvscsi: fix timeout bugs
      iscsi_iser: convert to use the data buffer accessors
      lpfc: convert to use the data buffer accessors
      esp_scsi: convert to use the data buffer accessors
      hptiop: convert to use the data buffer accessors
      iscsi_tcp: convert to use the data buffer accessors
      i2o: convert to use the data buffer accessors
      aacraid: convert to use the data buffer accessors
      ips: convert to use the data buffer accessors
      ib_srp: convert to use the data buffer accessors
      mesh: convert to use the data buffer accessors
      megaraid: convert to use the data buffer accessors
      megaraid_sas: convert to use the data buffer accessors
      megaraid_old: convert to use the data buffer accessors
      dpt_i2o: convert to use the data buffer accessors
      qla2xxx: convert to use the data buffer accessors
      3w-9xxx: eliminate missed map_single path
      3w-xxxx: convert to use the data buffer accessors
      3w-9xxx: convert to use the data buffer accessors
      nsp32: convert to use the data buffer accessors
      stex: convert to use the data buffer accessors
      qla4xxx: convert to use the data buffer accessors
      fusion: convert to use the data buffer accessors
      ipr: convert to use the data buffer accessors
      libsas: convert to use the data buffer accessors
      cciss: convert to use the data buffer accessors
      arcmsr: convert to use the data buffer accessors
      aic7xxx_old: convert to use the data buffer accessors
      tmscsim: convert to use the data buffer accessors
      sbp2: convert to use the data buffer accessors
      BusLogic: convert to use the data buffer accessors
      qlogicfas408: convert to use the data buffer accessors
      u14-34f: convert to use the data buffer accessors
      ultrastor: convert to use the data buffer accessors
      wd7000: convert to use the data buffer accessors
      eata: convert to use the data buffer accessors
      initio: convert to use the data buffer accessors
      aha1740: convert to use the data buffer accessors
      a100u2w: convert to use the data buffer accessors
      fdomain: convert to use the data buffer accessors
      sym53c500_cs: convert to use the data buffer accessors
      sym53c416: convert to use the data buffer accessors
      NCR53c406a: convert to use the data buffer accessors
      mac53c94: convert to use the data buffer accessors
      ibmmca: convert to use the data buffer accessors
      aic79xx: convert to use the data buffer accessors
      aic7xxx: convert to use the data buffer accessors
      53c700: convert to use the data buffer accessors
      scsi_lib: add scatter/gather data buffer accessors

Geert Uytterhoeven (2):
      CONFIG_SCSI_FD_8xx no longer exists
      53c700: Fixup m68k drivers:

Guennadi Liakhovetski (1):
      tmscsim: clean-up status codes

Hannes Reinecke (1):
      fc_transport: Check portstates before invoking target scan

James Bottomley (3):
      lpfc: Fix NPIV compile problem
      scsi_error: send the sense buffer down without copying
      ibmmca: convert to new probing API and fix oopses

James Smart (7):
      lpfc: update to version 8.2.1
      lpfc: bug fixes
      lpfc: NPIV: add NPIV support on top of SLI-3
      lpfc: NPIV: add SLI-3 interface
      lpfc: NPIV: split ports
      fc_transport: fix sysfs deadlock on vport delete
      FC Transport support for vports based on NPIV

Jeff Garzik (2):
      fdomain: fix PCMCIA-related warnings
      aacraid,qla2xxx: use irq_handler_t where appropriate

Kars de Jong (5):
      53c700: Amiga Zorro NCR53c710 SCSI
      53c700: Amiga 4000T NCR53c710 SCSI
      53c700: m68k MVME16x NCR53C710 SCSI
      53c700: m68k BVME6000 NCR53C710 SCSI
      53c700: m68k support for the 53c700 SCSI core

Martin Bligh (1):
      megaraid: fix compiler warnings

Matthew Wilcox (2):
      Clean up scsi_add_lun a bit
      Add Brownie 1200U3P to blacklist

Matthias Kaehlcke (1):
      megaraid_mbox: use mutex instead of semaphore

Mike Christie (19):
      iscsi class, iscsi_tcp, iser, qla4xxx: add netdevname sysfs attr
      iscsi class, qla4xxx, iscsi_tcp: export local address
      iscsi_tcp: fix fd leak
      qla4xxx: add iscsi_transport capps for fw capacilities
      iscsi_tcp: remove DMA alignment restriction
      iscsi_tcp: fix handling of data buffer padding
      libiscsi: make can_queue configurable
      libiscsi: fix iscsi cmdsn allocation
      iscsi tcp: fix iscsi xmit state machine
      iscsi class, iscsi_tcp, ib_iser: add sysfs chap file
      iscsi: Some fixes in preparation for bidirectional support - tota=
l_length
      iscsi: Some fixes in preparation for bidirectional support - exp_=
datasn
      iscsi class, qla4xxx, iscsi_tcp, ib_iser: export/set initiator na=
me
      libiscsi, iscsi_tcp, ib_iser : add sw iscsi host get/set params h=
elpers
      iscsi class: add iscsi host set param event
      iscsi_transport, qla4xxx: have class lookup host for drivers
      qla4xxx: export mac as hw address
      iscsi_transport: export hw address
      iscsi_transport: Check iscsi interface skb allocation return valu=
e

Priyanka Gupta (1):
      Remove unused method scsi_device_cancel

Randy Dunlap (1):
      scsi_debug: correct parameter default text

Robert P. J. Day (1):
      gdth: Fix obvious typo "spin_lock_irqrestore()"

Salyzyn, Mark (8):
      aacraid: add 51245, 51645 and 52245 adapters to documentation.
      aacraid: add support for long serial number information
      aacraid: correct PERC2/QC and family match quirk list
      aacraid: change srb status busy return
      aacraid: add user initiated reset
      aacraid: probe related code cleanup
      aacraid: Changeable queue depth
      aacraid: add support for FUA

Satyam Sharma (2):
      aic7xxx_old: remove redundant GFP_ATOMIC from kmalloc
      i2o: remove redundant GFP_ATOMIC from kmalloc from device.c

Seokmann Ju (2):
      qla2xxx: update version to 8.02.00-k1.
      qla2xxx: add support for NPIV

Tejun Heo (1):
      kill scsi host template suspend/resume

Thomas Bogendoerfer (3):
      53c700: Remove printk, which triggers because of low scsi clock o=
n SNI RMs
      sni_53c710: Cleanup
      jazz_esp: converted to use esp_core

Volker Sameske (1):
      zfcp: clear adapter status flags during adapter shutdown

nickcheng(=E9=84=AD=E5=AE=88=E8=AC=99 (1):
      areca: improve driver stability and compatibility


and the diffstat

 b/Documentation/scsi/aacraid.txt               |    3=20
 b/Documentation/scsi/scsi_fc_transport.txt     |  450 +
 b/drivers/block/cciss_scsi.c                   |   75=20
 b/drivers/ieee1394/sbp2.c                      |   75=20
 b/drivers/infiniband/ulp/iser/iscsi_iser.c     |   40=20
 b/drivers/infiniband/ulp/iser/iscsi_iser.h     |    4=20
 b/drivers/infiniband/ulp/iser/iser_initiator.c |   14=20
 b/drivers/infiniband/ulp/iser/iser_verbs.c     |    4=20
 b/drivers/infiniband/ulp/srp/ib_srp.c          |   63=20
 b/drivers/infiniband/ulp/srp/ib_srp.h          |    5=20
 b/drivers/message/fusion/lsi/mpi.h             |    7=20
 b/drivers/message/fusion/lsi/mpi_cnfg.h        |   61=20
 b/drivers/message/fusion/lsi/mpi_history.txt   |   66=20
 b/drivers/message/fusion/lsi/mpi_init.h        |   10=20
 b/drivers/message/fusion/lsi/mpi_ioc.h         |   40=20
 b/drivers/message/fusion/lsi/mpi_raid.h        |   11=20
 b/drivers/message/fusion/mptbase.c             |   40=20
 b/drivers/message/fusion/mptbase.h             |    6=20
 b/drivers/message/fusion/mptctl.c              |    2=20
 b/drivers/message/fusion/mptctl.h              |    2=20
 b/drivers/message/fusion/mptfc.c               |    3=20
 b/drivers/message/fusion/mptlan.c              |    2=20
 b/drivers/message/fusion/mptlan.h              |    2=20
 b/drivers/message/fusion/mptsas.c              |    2=20
 b/drivers/message/fusion/mptscsih.c            |  264 -
 b/drivers/message/fusion/mptscsih.h            |    2=20
 b/drivers/message/fusion/mptspi.c              |    3=20
 b/drivers/message/i2o/device.c                 |    2=20
 b/drivers/message/i2o/i2o_scsi.c               |   24=20
 b/drivers/s390/scsi/zfcp_aux.c                 |   20=20
 b/drivers/s390/scsi/zfcp_erp.c                 |    7=20
 b/drivers/scsi/3w-9xxx.c                       |  135=20
 b/drivers/scsi/3w-xxxx.c                       |  104=20
 b/drivers/scsi/53c700.c                        |   77=20
 b/drivers/scsi/53c700.h                        |    5=20
 b/drivers/scsi/BusLogic.c                      |   51=20
 b/drivers/scsi/Kconfig                         |   56=20
 b/drivers/scsi/Makefile                        |   23=20
 b/drivers/scsi/NCR5380.c                       |   14=20
 b/drivers/scsi/NCR5380.h                       |    6=20
 b/drivers/scsi/NCR53c406a.c                    |   45=20
 b/drivers/scsi/a100u2w.c                       | 1239 ++---
 b/drivers/scsi/a100u2w.h                       |  297 -
 b/drivers/scsi/a4000t.c                        |  143=20
 b/drivers/scsi/aacraid/aachba.c                |  322 -
 b/drivers/scsi/aacraid/aacraid.h               |   40=20
 b/drivers/scsi/aacraid/commsup.c               |  210=20
 b/drivers/scsi/aacraid/linit.c                 |  104=20
 b/drivers/scsi/aacraid/rx.c                    |   33=20
 b/drivers/scsi/advansys.c                      |  101=20
 b/drivers/scsi/aha152x.c                       |   50=20
 b/drivers/scsi/aha1740.c                       |   48=20
 b/drivers/scsi/aic7xxx/aic79xx_osm.c           |   51=20
 b/drivers/scsi/aic7xxx/aic79xx_osm.h           |    4=20
 b/drivers/scsi/aic7xxx/aic7xxx_osm.c           |   59=20
 b/drivers/scsi/aic7xxx/aic7xxx_osm.h           |    4=20
 b/drivers/scsi/aic7xxx_old.c                   |   57=20
 b/drivers/scsi/arcmsr/arcmsr.h                 |    4=20
 b/drivers/scsi/arcmsr/arcmsr_hba.c             |  559 +-
 b/drivers/scsi/bvme6000_scsi.c                 |  135=20
 b/drivers/scsi/dc395x.c                        |  163=20
 b/drivers/scsi/dpt_i2o.c                       |   33=20
 b/drivers/scsi/eata.c                          |   48=20
 b/drivers/scsi/esp_scsi.c                      |   30=20
 b/drivers/scsi/esp_scsi.h                      |    2=20
 b/drivers/scsi/fdomain.c                       |   70=20
 b/drivers/scsi/gdth.c                          |    4=20
 b/drivers/scsi/hptiop.c                        |   76=20
 b/drivers/scsi/ibmmca.c                        | 1267 ++---
 b/drivers/scsi/ibmvscsi/ibmvscsi.c             |  463 +
 b/drivers/scsi/ibmvscsi/ibmvscsi.h             |    2=20
 b/drivers/scsi/ibmvscsi/rpa_vscsi.c            |   20=20
 b/drivers/scsi/initio.c                        | 3819 +++++++--------
 b/drivers/scsi/initio.h                        |  313 -
 b/drivers/scsi/ipr.c                           |  144=20
 b/drivers/scsi/ips.c                           |  401 -
 b/drivers/scsi/ips.h                           |   44=20
 b/drivers/scsi/iscsi_tcp.c                     |  606 +-
 b/drivers/scsi/iscsi_tcp.h                     |    9=20
 b/drivers/scsi/jazz_esp.c                      |    4=20
 b/drivers/scsi/libiscsi.c                      |  650 +-
 b/drivers/scsi/libsas/sas_scsi_host.c          |   10=20
 b/drivers/scsi/lpfc/Makefile                   |    5=20
 b/drivers/scsi/lpfc/lpfc.h                     |  358 +
 b/drivers/scsi/lpfc/lpfc_attr.c                |  760 ++-
 b/drivers/scsi/lpfc/lpfc_crtn.h                |  182=20
 b/drivers/scsi/lpfc/lpfc_ct.c                  |  971 ++-
 b/drivers/scsi/lpfc/lpfc_debugfs.c             |  508 ++
 b/drivers/scsi/lpfc/lpfc_debugfs.h             |   50=20
 b/drivers/scsi/lpfc/lpfc_disc.h                |   15=20
 b/drivers/scsi/lpfc/lpfc_els.c                 | 3377 +++++++++----
 b/drivers/scsi/lpfc/lpfc_hbadisc.c             | 2262 +++++----
 b/drivers/scsi/lpfc/lpfc_hw.h                  |  558 ++
 b/drivers/scsi/lpfc/lpfc_init.c                |  948 ++-
 b/drivers/scsi/lpfc/lpfc_logmsg.h              |    1=20
 b/drivers/scsi/lpfc/lpfc_mbox.c                |  306 +
 b/drivers/scsi/lpfc/lpfc_mem.c                 |  101=20
 b/drivers/scsi/lpfc/lpfc_nportdisc.c           | 1325 ++---
 b/drivers/scsi/lpfc/lpfc_scsi.c                |  557 +-
 b/drivers/scsi/lpfc/lpfc_scsi.h                |    3=20
 b/drivers/scsi/lpfc/lpfc_sli.c                 | 2047 +++++---
 b/drivers/scsi/lpfc/lpfc_sli.h                 |   47=20
 b/drivers/scsi/lpfc/lpfc_version.h             |    2=20
 b/drivers/scsi/lpfc/lpfc_vport.c               |  523 ++
 b/drivers/scsi/lpfc/lpfc_vport.h               |  113=20
 b/drivers/scsi/mac53c94.c                      |   62=20
 b/drivers/scsi/megaraid.c                      |  141=20
 b/drivers/scsi/megaraid/mega_common.h          |    1=20
 b/drivers/scsi/megaraid/megaraid_mbox.c        |  171=20
 b/drivers/scsi/megaraid/megaraid_mbox.h        |    4=20
 b/drivers/scsi/megaraid/megaraid_sas.c         |  112=20
 b/drivers/scsi/mesh.c                          |   46=20
 b/drivers/scsi/mvme16x_scsi.c                  |  158=20
 b/drivers/scsi/ncr53c8xx.c                     |   70=20
 b/drivers/scsi/nsp32.c                         |  194=20
 b/drivers/scsi/pcmcia/sym53c500_cs.c           |   42=20
 b/drivers/scsi/ppa.c                           |   57=20
 b/drivers/scsi/qla2xxx/Makefile                |    2=20
 b/drivers/scsi/qla2xxx/qla_attr.c              |  164=20
 b/drivers/scsi/qla2xxx/qla_dbg.c               |    4=20
 b/drivers/scsi/qla2xxx/qla_dbg.h               |   10=20
 b/drivers/scsi/qla2xxx/qla_def.h               |   83=20
 b/drivers/scsi/qla2xxx/qla_fw.h                |   91=20
 b/drivers/scsi/qla2xxx/qla_gbl.h               |   39=20
 b/drivers/scsi/qla2xxx/qla_gs.c                |    3=20
 b/drivers/scsi/qla2xxx/qla_init.c              |  166=20
 b/drivers/scsi/qla2xxx/qla_iocb.c              |  242=20
 b/drivers/scsi/qla2xxx/qla_isr.c               |   85=20
 b/drivers/scsi/qla2xxx/qla_mbx.c               |  396 +
 b/drivers/scsi/qla2xxx/qla_mid.c               |  497 ++
 b/drivers/scsi/qla2xxx/qla_os.c                |  237=20
 b/drivers/scsi/qla2xxx/qla_version.h           |    6=20
 b/drivers/scsi/qla4xxx/ql4_dbg.c               |  174=20
 b/drivers/scsi/qla4xxx/ql4_def.h               |   78=20
 b/drivers/scsi/qla4xxx/ql4_fw.h                |  426 -
 b/drivers/scsi/qla4xxx/ql4_glbl.h              |    7=20
 b/drivers/scsi/qla4xxx/ql4_init.c              |  105=20
 b/drivers/scsi/qla4xxx/ql4_iocb.c              |  101=20
 b/drivers/scsi/qla4xxx/ql4_isr.c               |  114=20
 b/drivers/scsi/qla4xxx/ql4_mbx.c               |  274 -
 b/drivers/scsi/qla4xxx/ql4_nvram.c             |    3=20
 b/drivers/scsi/qla4xxx/ql4_os.c                |   96=20
 b/drivers/scsi/qla4xxx/ql4_version.h           |    3=20
 b/drivers/scsi/qlogicfas408.c                  |   30=20
 b/drivers/scsi/scsi.c                          |   48=20
 b/drivers/scsi/scsi_debug.c                    |    2=20
 b/drivers/scsi/scsi_devinfo.c                  |    1=20
 b/drivers/scsi/scsi_error.c                    |   26=20
 b/drivers/scsi/scsi_lib_dma.c                  |   50=20
 b/drivers/scsi/scsi_scan.c                     |   67=20
 b/drivers/scsi/scsi_sysfs.c                    |   25=20
 b/drivers/scsi/scsi_transport_fc.c             |  831 +++
 b/drivers/scsi/scsi_transport_iscsi.c          |  138=20
 b/drivers/scsi/sd.c                            |    2=20
 b/drivers/scsi/sg.c                            |    2=20
 b/drivers/scsi/sni_53c710.c                    |   10=20
 b/drivers/scsi/sr.c                            |    6=20
 b/drivers/scsi/stex.c                          |  111=20
 b/drivers/scsi/sun_esp.c                       |    2=20
 b/drivers/scsi/sym53c416.c                     |   44=20
 b/drivers/scsi/sym53c8xx_2/sym_glue.c          |   83=20
 b/drivers/scsi/sym53c8xx_2/sym_glue.h          |    2=20
 b/drivers/scsi/tmscsim.c                       |   85=20
 b/drivers/scsi/tmscsim.h                       |   10=20
 b/drivers/scsi/u14-34f.c                       |   60=20
 b/drivers/scsi/ultrastor.c                     |   19=20
 b/drivers/scsi/wd7000.c                        |   20=20
 b/drivers/scsi/zorro7xx.c                      |  180=20
 b/include/scsi/iscsi_if.h                      |   34=20
 b/include/scsi/libiscsi.h                      |   67=20
 b/include/scsi/scsi_cmnd.h                     |   20=20
 b/include/scsi/scsi_device.h                   |    2=20
 b/include/scsi/scsi_host.h                     |   10=20
 b/include/scsi/scsi_transport_fc.h             |  186=20
 b/include/scsi/scsi_transport_iscsi.h          |   16=20
 drivers/message/fusion/linux_compat.h          |    9=20
 drivers/message/fusion/lsi/mpi_inb.h           |  221=20
 drivers/scsi/53c7xx.c                          | 6102 ----------------=
---------
 drivers/scsi/53c7xx.h                          | 1608 ------
 drivers/scsi/53c7xx.scr                        | 1591 ------
 drivers/scsi/53c7xx_d.h_shipped                | 2874 -----------
 drivers/scsi/53c7xx_u.h_shipped                |  102=20
 drivers/scsi/advansys.h                        |   36=20
 drivers/scsi/amiga7xx.c                        |  138=20
 drivers/scsi/amiga7xx.h                        |   23=20
 drivers/scsi/bvme6000.c                        |   76=20
 drivers/scsi/bvme6000.h                        |   24=20
 drivers/scsi/ibmmca.h                          |   21=20
 drivers/scsi/mvme16x.c                         |   78=20
 drivers/scsi/mvme16x.h                         |   24=20
 190 files changed, 21725 insertions(+), 26337 deletions(-)

James



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
