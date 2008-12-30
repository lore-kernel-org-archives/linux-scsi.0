From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] first set of SCSI updates for the 2.6.28 merge window
Date: Tue, 30 Dec 2008 13:32:34 -0600
Message-ID: <1230665554.18627.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753045AbYL3Tcy@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the first set of driver updates and infrastructure changes.  Th=
e
major new drivers are software FCoE and the chelsio iSCSI addition to
the cxgb3 net driver.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Alan Cox (1):
      Clean up my email address and use a single standard address for e=
verything

Alan Stern (1):
      simplify scsi_io_completion()

Anirban Chakraborty (6):
      qla2xxx: changes in multiq code
      qla2xxx: add support for multi-queue adapter
      qla2xxx: Code changes for vport bus reset
      qla2xxx: Fix for build warning
      qla2xxx: Code changes for qla data structure refactoring
      qla2xxx: Refactor qla data structures

Arjan van de Ven (1):
      advansys, arcmsr, ipr, nsp32, qla1280, stex: use pci_ioremap_bar(=
)

Babu Moger (1):
      scsi_dh_rdac: Add LSI vendor and product ids in rdac device list

Brian King (14):
      ibmvfc: Improve async event handling
      ibmvscsi: Don't fail EH due to insufficient resources
      ibmvfc: Fix errors due to inconsistent command data
      ibmvfc: Delay NPIV login retry and add retries
      ibmvfc: Driver version 1.0.4
      ibmvfc: Handle port login required response
      ibmvfc: Fix command timeouts due to cached CRQ access
      ibmvfc: Fix oops in interrupt handler
      ibmvfc: Driver version 1.0.3
      ibmvfc: Quiet gcc warning in ibmvfc_reset_device
      ibmvfc: Fix target initialization failure retry handling
      ibmvfc: Error handling fixes
      ibmvfc: Fix error reporting for some FC errors
      ibmvfc: Fix log level filtering

Chandra Seetharaman (2):
      scsi_dh: Retry mode select in rdac device handler
      scsi_dh: Make sure the state of a path is set properly when contr=
oller is=20

Christof Schmitt (9):
      zfcp: Remove unnecessary warning message
      zfcp: Add support for unchained FSF requests
      zfcp: Remove busid macro
      zfcp: remove DID_DID flag
      zfcp: Simplify mask lookups for incoming RSCNs
      zfcp: Remove initial device data from zfcp_data
      zfcp: Remove adapter list
      zfcp: Simplify SBAL allocation to fix sparse warnings
      zfcp: Fix message line break

=46UJITA Tomonori (17):
      eata: fix the data buffer accessors conversion regression
      scsi_transport_spi: fix the misuse of scsi_execute return value
      st: convert st_int_ioctl to use st_scsi_kern_execute
      st: convert get_location to use st_scsi_kern_execute
      st: convert write_mode_page to use st_scsi_kern_execute
      st: convert read_mode_page to use st_scsi_kern_execute
      st: convert check_tape to use st_scsi_kern_execute
      st: convert st_flush to use st_scsi_kern_execute
      st: convert cross_eof to use st_scsi_kern_execute
      st: convert do_load_unload to use st_scsi_kern_execute
      st: convert set_location to use st_scsi_kern_execute
      st: convert test_ready to use st_scsi_kern_execute
      st: add st_scsi_kern_execute helper function
      st: move st_request initialization to st_allocate_request form st=
_do_scsi
      retry with missing data for INQUIRY
      add residual argument to scsi_execute and scsi_execute_req
      aacraid: check pci_alloc_consistent errors

=46inn Thain (2):
      mac_esp: fix for quadras with two esp chips
      m68k: mac_esp asm fix

Heiko Carstens (1):
      zfcp: fix compile warning

Ilpo J=C3=A4rvinen (2):
      scsi_error: fix indentation and braces disagreement - add braces
      tmscsim: fix indentation and braces disagreement - add braces

James Bottomley (5):
      fcoe: fix configuration problems
      cxgb3i: fix select/depend problem
      fcoe: fix incorrect use of struct module
      remove timeout from struct scsi_device
      st: update to use block timeout

James Smart (16):
      lpfc : correct printk types on PPC compiles
      fc transport: pre-emptively terminate i/o upon dev_loss_tmo timeo=
ut
      lpfc 8.3.0 : Update driver version to 8.3.0
      lpfc 8.3.0 : Hook lpfc's debugfs into Kconfig
      lpfc 8.3.0 : Add BlockGuard support (T10-DIF) code
      lpfc 8.3.0 : Add BlockGuard support (T10-DIF) structs and defs
      lpfc 8.3.0 : Fix some memory handling issues
      lpfc 8.3.0 : Add active interrupt test for enabling MSI/MSI-X/INT=
x
      lpfc 8.3.0 : Fix several minor issues
      lpfc 8.3.0 : Fix issue with assumed Interrupt Enable Block suppor=
t
      lpfc 8.3.0 : Added 3 small features and improve PCI EEH support
      lpfc 8.3.0 : Fix multiple NPIV issues
      lpfc 8.3.0 : Fix system crash due to uninitialized node access
      lpfc 8.3.0 : Add kernel-doc headers to lpfc_scsi.c
      lpfc 8.3.0 : Add support for Power Management Suspend/Resume oper=
ations
      lpfc 8.3.0 : Rework RSCN netlink event to send entire RSCN payloa=
d

Julia Lawall (2):
      fusion: use ARRAY_SIZE
      esp_scsi: Use DIV_ROUND_UP

Karen Xie (2):
      cxgb3i: remove use of skb->sp
      cxgb3i: Add cxgb3i iSCSI driver.

Mark Nelson (1):
      ipr: fix lockdep warning from ipr_ioa_reset_done

Mike Christie (13):
      libiscsi_tcp: support padding offload
      libiscsi: handle init task failures.
      libiscsi: pass opcode into alloc_pdu callout
      libiscsi: allow drivers to modify the itt sent to the target
      iscsi_tcp: hook iscsi_tcp into new libiscsi_tcp module
      iscsi_tcp: split module into lib and lld
      iscsi_tcp: add iscsi_tcp prefix to iscsi_tcp functions
      libiscsi: change login data buffer allocation
      iscsi_tcp: remove unused r2t handling
      iscsi_tcp: convert to new alloc_hdr api
      iser: convert iser to new alloc_pdu api
      libiscsi: prepare libiscsi for new offload engines by modifying u=
nsol data
      iscsi_tcp: prepare helpers for LLDs that can offload some operati=
ons

Randy Dunlap (2):
      fusion: remove excess kernel-doc notation
      scsi ioctl: fix kernel-doc warning

Robert Love (3):
      fcoe: Fibre Channel over Ethernet
      libfc: A modular Fibre Channel library
      FC protocol definition header files

Swen Schillig (1):
      zfcp: register with SCSI layer on ccw registration

Vladislav Bolkhovitin (1):
      scsi_error: TASK ABORTED status handling improvement

roel kluin (1):
      u14-34f: fix scsi_dma_map failure case

and the diffstat:

 Documentation/scsi/cxgb3i.txt                |   85 +
 drivers/ata/libata-scsi.c                    |    4=20
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   48=20
 drivers/infiniband/ulp/iser/iser_initiator.c |    5=20
 drivers/message/fusion/mptbase.c             |   15=20
 drivers/net/Kconfig                          |    7=20
 drivers/s390/scsi/zfcp_aux.c                 |  110 -
 drivers/s390/scsi/zfcp_ccw.c                 |    6=20
 drivers/s390/scsi/zfcp_cfdc.c                |   17=20
 drivers/s390/scsi/zfcp_dbf.c                 |   12=20
 drivers/s390/scsi/zfcp_dbf.h                 |    1=20
 drivers/s390/scsi/zfcp_def.h                 |   32=20
 drivers/s390/scsi/zfcp_erp.c                 |   10=20
 drivers/s390/scsi/zfcp_fc.c                  |   88 -
 drivers/s390/scsi/zfcp_fsf.c                 |   77=20
 drivers/s390/scsi/zfcp_fsf.h                 |    2=20
 drivers/s390/scsi/zfcp_qdio.c                |    4=20
 drivers/scsi/Kconfig                         |   22=20
 drivers/scsi/Makefile                        |    5=20
 drivers/scsi/NCR5380.c                       |    2=20
 drivers/scsi/a100u2w.c                       |    2=20
 drivers/scsi/aacraid/aachba.c                |    2=20
 drivers/scsi/aacraid/commctrl.c              |   14=20
 drivers/scsi/aacraid/comminit.c              |    2=20
 drivers/scsi/aacraid/commsup.c               |    2=20
 drivers/scsi/aacraid/dpcsup.c                |    2=20
 drivers/scsi/aacraid/linit.c                 |    2=20
 drivers/scsi/aacraid/rkt.c                   |    2=20
 drivers/scsi/aacraid/rx.c                    |    2=20
 drivers/scsi/aacraid/sa.c                    |    2=20
 drivers/scsi/advansys.c                      |    3=20
 drivers/scsi/aha1740.c                       |    2=20
 drivers/scsi/arcmsr/arcmsr_hba.c             |    8=20
 drivers/scsi/atp870u.c                       |    4=20
 drivers/scsi/ch.c                            |    2=20
 drivers/scsi/cxgb3i/Kbuild                   |    4=20
 drivers/scsi/cxgb3i/Kconfig                  |    7=20
 drivers/scsi/cxgb3i/cxgb3i.h                 |  139 +
 drivers/scsi/cxgb3i/cxgb3i_ddp.c             |  770 +++++++++
 drivers/scsi/cxgb3i/cxgb3i_ddp.h             |  306 +++
 drivers/scsi/cxgb3i/cxgb3i_init.c            |  107 +
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c           |  951 ++++++++++++
 drivers/scsi/cxgb3i/cxgb3i_offload.c         | 1810 ++++++++++++++++++=
++++
 drivers/scsi/cxgb3i/cxgb3i_offload.h         |  231 ++
 drivers/scsi/cxgb3i/cxgb3i_pdu.c             |  402 +++++
 drivers/scsi/cxgb3i/cxgb3i_pdu.h             |   59=20
 drivers/scsi/device_handler/scsi_dh_rdac.c   |   18=20
 drivers/scsi/eata.c                          |   15=20
 drivers/scsi/eata_pio.c                      |    4=20
 drivers/scsi/esp_scsi.c                      |    6=20
 drivers/scsi/fcoe/Makefile                   |    8=20
 drivers/scsi/fcoe/fc_transport_fcoe.c        |  446 +++++
 drivers/scsi/fcoe/fcoe_sw.c                  |  494 ++++++
 drivers/scsi/fcoe/libfcoe.c                  | 1510 ++++++++++++++++++=
+
 drivers/scsi/fdomain.c                       |    2=20
 drivers/scsi/ibmmca.c                        |    2=20
 drivers/scsi/ibmvscsi/ibmvfc.c               |  293 ++-
 drivers/scsi/ibmvscsi/ibmvfc.h               |   32=20
 drivers/scsi/ibmvscsi/ibmvscsi.c             |    4=20
 drivers/scsi/in2000.c                        |    2=20
 drivers/scsi/initio.c                        |    2=20
 drivers/scsi/initio.h                        |    2=20
 drivers/scsi/ipr.c                           |    6=20
 drivers/scsi/ipr.h                           |    2=20
 drivers/scsi/iscsi_tcp.c                     | 1621 +++---------------=
--
 drivers/scsi/iscsi_tcp.h                     |   88 -
 drivers/scsi/libfc/Makefile                  |   12=20
 drivers/scsi/libfc/fc_disc.c                 |  845 ++++++++++
 drivers/scsi/libfc/fc_elsct.c                |   71=20
 drivers/scsi/libfc/fc_exch.c                 | 1970 ++++++++++++++++++=
++++++
 drivers/scsi/libfc/fc_fcp.c                  | 2131 ++++++++++++++++++=
+++++++++
 drivers/scsi/libfc/fc_frame.c                |   89 +
 drivers/scsi/libfc/fc_lport.c                | 1604 ++++++++++++++++++=
++
 drivers/scsi/libfc/fc_rport.c                | 1291 ++++++++++++++++
 drivers/scsi/libiscsi.c                      |  236 ++
 drivers/scsi/libiscsi_tcp.c                  | 1163 ++++++++++++++
 drivers/scsi/lpfc/lpfc.h                     |   22=20
 drivers/scsi/lpfc/lpfc_attr.c                |  169 ++
 drivers/scsi/lpfc/lpfc_crtn.h                |   15=20
 drivers/scsi/lpfc/lpfc_ct.c                  |   17=20
 drivers/scsi/lpfc/lpfc_debugfs.c             |  164 ++
 drivers/scsi/lpfc/lpfc_debugfs.h             |    2=20
 drivers/scsi/lpfc/lpfc_els.c                 |  160 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c             |   69=20
 drivers/scsi/lpfc/lpfc_hw.h                  |  249 +++
 drivers/scsi/lpfc/lpfc_init.c                |  685 ++++++--
 drivers/scsi/lpfc/lpfc_logmsg.h              |    1=20
 drivers/scsi/lpfc/lpfc_mbox.c                |   54=20
 drivers/scsi/lpfc/lpfc_nl.h                  |   30=20
 drivers/scsi/lpfc/lpfc_nportdisc.c           |    2=20
 drivers/scsi/lpfc/lpfc_scsi.c                | 1235 ++++++++++++++-
 drivers/scsi/lpfc/lpfc_scsi.h                |    2=20
 drivers/scsi/lpfc/lpfc_sli.c                 |  159 --
 drivers/scsi/lpfc/lpfc_version.h             |    2=20
 drivers/scsi/lpfc/lpfc_vport.c               |   28=20
 drivers/scsi/mac_esp.c                       |  100 -
 drivers/scsi/nsp32.c                         |    3=20
 drivers/scsi/qla1280.c                       |    3=20
 drivers/scsi/qla2xxx/qla_attr.c              |  328 ++--
 drivers/scsi/qla2xxx/qla_dbg.c               |   96 -
 drivers/scsi/qla2xxx/qla_dbg.h               |   15=20
 drivers/scsi/qla2xxx/qla_def.h               |  584 ++++---
 drivers/scsi/qla2xxx/qla_dfs.c               |   21=20
 drivers/scsi/qla2xxx/qla_fw.h                |   14=20
 drivers/scsi/qla2xxx/qla_gbl.h               |   56=20
 drivers/scsi/qla2xxx/qla_gs.c                |  481 +++---
 drivers/scsi/qla2xxx/qla_init.c              | 1251 ++++++++-------
 drivers/scsi/qla2xxx/qla_inline.h            |   45=20
 drivers/scsi/qla2xxx/qla_iocb.c              |  358 ++--
 drivers/scsi/qla2xxx/qla_isr.c               |  840 ++++++----
 drivers/scsi/qla2xxx/qla_mbx.c               |  886 ++++++-----
 drivers/scsi/qla2xxx/qla_mid.c               |  516 +++++-
 drivers/scsi/qla2xxx/qla_os.c                | 1471 ++++++++++--------
 drivers/scsi/qla2xxx/qla_sup.c               |  554 +++----
 drivers/scsi/qla2xxx/qla_version.h           |    4=20
 drivers/scsi/qlogicfas408.c                  |    2=20
 drivers/scsi/scsi_error.c                    |    6=20
 drivers/scsi/scsi_ioctl.c                    |    6=20
 drivers/scsi/scsi_lib.c                      |  149 +
 drivers/scsi/scsi_scan.c                     |   17=20
 drivers/scsi/scsi_transport_fc.c             |   13=20
 drivers/scsi/scsi_transport_spi.c            |    5=20
 drivers/scsi/sd.c                            |   11=20
 drivers/scsi/ses.c                           |    9=20
 drivers/scsi/sr.c                            |    4=20
 drivers/scsi/sr_ioctl.c                      |    2=20
 drivers/scsi/st.c                            |  245 ++-
 drivers/scsi/stex.c                          |    3=20
 drivers/scsi/sym53c416.c                     |    2=20
 drivers/scsi/tmscsim.c                       |    3=20
 drivers/scsi/u14-34f.c                       |    3=20
 drivers/scsi/wd7000.c                        |    4=20
 include/scsi/fc/fc_els.h                     |  816 ++++++++++
 include/scsi/fc/fc_encaps.h                  |  138 +
 include/scsi/fc/fc_fc2.h                     |  124 +
 include/scsi/fc/fc_fcoe.h                    |  114 +
 include/scsi/fc/fc_fcp.h                     |  199 ++
 include/scsi/fc/fc_fs.h                      |  340 ++++
 include/scsi/fc/fc_gs.h                      |   93 +
 include/scsi/fc/fc_ns.h                      |  159 ++
 include/scsi/fc_encode.h                     |  309 +++
 include/scsi/fc_frame.h                      |  242 +++
 include/scsi/fc_transport_fcoe.h             |   54=20
 include/scsi/iscsi_if.h                      |    7=20
 include/scsi/libfc.h                         |  938 +++++++++++
 include/scsi/libfcoe.h                       |  176 ++
 include/scsi/libiscsi.h                      |   39=20
 include/scsi/libiscsi_tcp.h                  |  132 +
 include/scsi/scsi_device.h                   |    7=20
 include/scsi/scsi_transport_iscsi.h          |   12=20
 150 files changed, 28769 insertions(+), 5663 deletions(-)

James
