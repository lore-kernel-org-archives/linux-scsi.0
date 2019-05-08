From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.1+ merge window
Date: Tue, 07 May 2019 22:03:12 -0700
Message-ID: <1557291792.9245.31.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly update of the usual drivers: qla2xxx, qedf, smartpqi,
hpsa, lpfc, ufs, mpt3sas, ibmvfc and hisi_sas.  Plus number of minor
changes, spelling fixes and other trivia.

We've got a trivial conflict with Kees tree where two differently
authored patches try to add fall through statements in lpfc_els.c.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Ajish Koshy (1):
      scsi: smartpqi: add H3C controller IDs

Alan Adamson (1):
      scsi: target: Add device product id and revision configfs attributes

Anders Roxell (1):
      scsi: ufs-mediatek: Add missing MODULE_* information

Andrew Vasquez (3):
      scsi: qla2xxx: Further limit FLASH region write access from SysFS
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS routines
      scsi: qedf: Correct the memory barriers in qedf_ring_doorbell

Anil Gurumurthy (1):
      scsi: qla2xxx: Cleanup redundant qla2x00_abort_all_cmds during unload

Arnd Bergmann (2):
      scsi: qla4xxx: avoid freeing unallocated dma memory
      scsi: lpfc: avoid uninitialized variable warning

Bart Van Assche (81):
      scsi: qla2xxx: Avoid that lockdep complains about unsafe locking in tcm_qla2xxx_close_session()
      scsi: qla2xxx: Avoid that qlt_send_resp_ctio() corrupts memory
      scsi: qla2xxx: Fix hardirq-unsafe locking
      scsi: qla2xxx: Complain loudly about reference count underflow
      scsi: qla2xxx: Use __le64 instead of uint32_t[2] for sending DMA addresses to firmware
      scsi: qla2xxx: Introduce the dsd32 and dsd64 data structures
      scsi: qla2xxx: Check the size of firmware data structures at compile time
      scsi: qla2xxx: Pass little-endian values to the firmware
      scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands
      scsi: qla2xxx: Use an on-stack completion in qla24xx_control_vp()
      scsi: qla2xxx: Make qla24xx_async_abort_cmd() static
      scsi: qla2xxx: Remove unnecessary locking from the target code
      scsi: qla2xxx: Remove qla_tgt_cmd.released
      scsi: qla2xxx: Complain if a command is released that is owned by the firmware
      scsi: qla2xxx: target: Fix offline port handling and host reset handling
      scsi: qla2xxx: Fix abort handling in tcm_qla2xxx_write_pending()
      scsi: qla2xxx: Fix error handling in qlt_alloc_qfull_cmd()
      scsi: qla2xxx: Simplify qlt_send_term_imm_notif()
      scsi: qla2xxx: Fix use-after-free issues in qla2xxx_qpair_sp_free_dma()
      scsi: qla2xxx: Fix a qla24xx_enable_msix() error path
      scsi: qla2xxx: Avoid that qla2x00_mem_free() crashes if called twice
      scsi: qla2xxx: Make qla2x00_mem_free() easier to verify
      scsi: qla2xxx: Increase the size of the mailbox arrays from 4 to 8
      scsi: qla2xxx: Log the status code if a firmware command fails
      scsi: qla2xxx: Avoid that Coverity complains about dereferencing a NULL rport pointer
      scsi: qla2xxx: Remove the fcport test from qla_nvme_abort_work()
      scsi: qla2xxx: Uninline qla2x00_init_timer()
      scsi: qla2xxx: Move qla2x00_is_reserved_id() from qla_inline.h into qla_init.c
      scsi: qla2xxx: Move qla2x00_clear_loop_id() from qla_inline.h into qla_init.c
      scsi: qla2xxx: Remove a set-but-not-used variable
      scsi: qla2xxx: Declare qla2x00_find_new_loop_id() static
      scsi: qla2xxx: Move qla2x00_set_reserved_loop_ids() definition
      scsi: qla2xxx: Fix a format specifier
      scsi: qla2xxx: Update two source code comments
      scsi: sd: Revert "Rely on the driver core for asynchronous probing"
      scsi: sd: Revert "Inline sd_probe_part2()"
      scsi: qla2xxx: Move qla2x00_set_fcport_state() from a .h into a .c file
      scsi: qla2xxx: Remove two superfluous casts
      scsi: qla2xxx: Remove qla_tgt_cmd.data_work and qla_tgt_cmd.data_work_free
      scsi: qla2xxx: Move the <linux/io-64-nonatomic-lo-hi.h> include directive
      scsi: qla2xxx: Declare qla24xx_build_scsi_crc_2_iocbs() static
      scsi: qla2xxx: Move the port_state_str[] definition from a .h to a .c file
      scsi: qla2xxx: Insert spaces where required
      scsi: qla2xxx: Fix formatting of pointer types
      scsi: qla2xxx: Leave a blank line after declarations
      scsi: qla2xxx: Use tabs to indent code
      scsi: target/iscsi: Make sure PDU processing continues if parsing a command fails
      scsi: target/iscsi: Make iscsit_map_iovec() more robust
      scsi: target/iscsi: Handle too large immediate data buffers correctly
      scsi: target/iscsi: Only send R2T if needed
      scsi: target/iscsi: Detect conn_cmd_list corruption early
      scsi: target/core: Make the XCOPY setup code easier to read by inlining two functions
      scsi: target/core: Simplify LUN initialization in XCOPY implementation
      scsi: target/core: Remove a set-but-not-used member variable from the XCOPY implementation
      scsi: target/core: Rework the SPC-2 reservation handling code
      scsi: target/core: Fix a race condition in the LUN lookup code
      scsi: tcm_qla2xxx: Minimize #include directives
      scsi: qla2xxx: Unregister resources in the opposite order of the registration order
      scsi: qla2xxx: Unregister chrdev if module initialization fails
      scsi: qla2xxx: Use get/put_unaligned where appropriate
      scsi: qla2xxx: Make qla2x00_process_response_queue() easier to read
      scsi: qla2xxx: Reduce the number of forward declarations
      scsi: qla2xxx: Declare local symbols static
      scsi: qla2xxx: Use ARRAY_SIZE() in the definition of QLA_LAST_SPEED
      scsi: qla2xxx: Remove a comment that refers to the SCSI host lock
      scsi: qla2xxx: Change a stack variable into a static const variable
      scsi: scsi_transport_fc: Declare wwn_to_u64() argument const
      scsi: lpfc: Fix a recently introduced compiler warning
      scsi: lpfc: Change smp_processor_id() into raw_smp_processor_id()
      scsi: lpfc: Remove unused functions
      scsi: lpfc: Remove set-but-not-used variables
      scsi: lpfc: Move trunk_errmsg[] from a header file into a .c file
      scsi: lpfc: Annotate switch/case fall-through
      scsi: lpfc: Fix indentation and balance braces
      scsi: lpfc: Declare local functions static
      scsi: sd: Fix a race between closing an sd device and sd I/O
      scsi: sd: Inline sd_probe_part2()
      scsi: sd: Rely on the driver core for asynchronous probing
      scsi: core: Avoid that a kernel warning appears during system resume
      scsi: core: Also call destroy_rcu_head() for passthrough requests
      scsi: core: Remove OSD include files

Chad Dupuis (15):
      scsi: qedf: Add port_id for fcport into initiate_cleanup debug message
      scsi: qedf: Add LBA to underrun debug messages
      scsi: qedf: Print scsi_cmd backpointer in good completion path if the command is still being used
      scsi: qedf: Add driver state to 'driver_stats' debugfs node
      scsi: qedf: Change MSI-X load error message
      scsi: qedf: Check both the FCF and fabric ID before servicing clear virtual link
      scsi: qedf: Add missing return in qedf_scsi_done()
      scsi: qedf: Wait for upload and link down processing during soft ctx reset
      scsi: qedf: Add additional checks for io_req->sc_cmd validity
      scsi: qedf: Add missing fc_disc_init call after allocating lport
      scsi: qedf: Use a separate completion for cleanup commands
      scsi: qedf: Simplify s/g list mapping
      scsi: qedf: Add missing return in qedf_post_io_req() in the fcport offload check
      scsi: qedf: Correct xid range overlap between offloaded requests and libfc requests
      scsi: qedf: Do not retry ELS request if qedf_alloc_cmd fails

Christoph Hellwig (2):
      scsi: aic7xxx: improve the Kconfig entry
      scsi: core: remove the scsi_ioctl_reset export

Colin Ian King (18):
      scsi: aic7xxx: fix spelling mistake "recevied" -> "received"
      scsi: megaraid_sas: fix spelling mistake "oustanding" -> "outstanding"
      scsi: qedi: fix spelling mistake "oflload" -> "offload"
      scsi: qedf: remove memset/memcpy to nfunc and use func instead
      scsi: cxgbi: remove redundant __kfree_skb call on skb and free cst->atid
      scsi: qla2xxx: fix spelling mistake "alredy" -> "already"
      scsi: pm8001: fix spelling mistake, interupt -> interrupt
      scsi: pm8001: clean up dead code when PM8001_USE_MSIX is defined
      scsi: qedi: remove declaration of nvm_image from stack
      scsi: mpt3sas: fix indentation issue
      scsi: libcxgbi: remove uninitialized variable len
      scsi: target: fix unsigned comparision with less than zero
      scsi: mptfusion: fix indentation issues
      scsi: mvsas: clean up a few indentation issues
      scsi: qlogicfas408: clean up a couple of indentation issues
      scsi: dpt_i2o: clean up indentation issues, remove spaces
      scsi: atp870u: clean up code style and indentation issues
      scsi: pm8001: clean up various indentation issues

Dave Carroll (1):
      scsi: aacraid: Insure we don't access PCIe space during AER/EEH

Ding Xiang (1):
      scsi: bnx2fc: remove unneeded variable

Don Brace (7):
      scsi: smartpqi: bump driver version
      scsi: smartpqi: add spdx
      scsi: smartpqi: update copyright
      scsi: hpsa: bump driver version
      scsi: hpsa: remove timeout from TURs
      scsi: hpsa: correct device id issues
      scsi: hpsa: check for lv removal

Dongli Zhang (4):
      scsi: smartpqi: Use HCTX_TYPE_DEFAULT for blk_mq_tag_set->map
      scsi: qla2xxx: Use HCTX_TYPE_DEFAULT for blk_mq_tag_set->map
      scsi: virtio_scsi: Use HCTX_TYPE_DEFAULT for blk_mq_tag_set->map
      scsi: core: Use HCTX_TYPE_DEFAULT for blk_mq_tag_set->map

Finn Thain (2):
      scsi: NCR5380: Remove set but unused variable
      scsi: NCR5380: Avoid compiler warning when -Wimplicit-fallthrough is enabled

Giridhar Malavali (8):
      scsi: qla2xxx: Change abort wait_loop from msleep to wait_event_timeout
      scsi: qla2xxx: Fix driver unload when FC-NVMe LUNs are connected
      scsi: qla2xxx: Set remote port devloss timeout to 0
      scsi: qla2xxx: Disable T10-DIF feature with FC-NVMe during probe
      scsi: qla2xxx: Increase the max_sgl_segments to 1024
      scsi: qla2xxx: Reset the FCF_ASYNC_{SENT|ACTIVE} flags
      scsi: qla2xxx: Set the qpair in SRB to NULL when SRB is released
      scsi: qla2xxx: Set the SCSI command result before calling the command done

Gustavo A. R. Silva (2):
      scsi: mptscsih: Mark expected switch fall-throughs
      scsi: mptfusion: mark expected switch fall-through

Hannes Reinecke (6):
      scsi: scsi_transport_fc: nvme: display FC-NVMe port roles
      scsi: qedf: fc_rport_priv reference counting fixes
      scsi: qedf: fixup bit operations
      scsi: qedf: fixup locking in qedf_restart_rport()
      scsi: qedf: missing kref_put in qedf_xmit()
      scsi: core: reshuffle no_scsi2_lun_in_cdb for better alignment

Himanshu Madhani (5):
      scsi: qla2xxx: Silence Successful ELS IOCB message
      scsi: qla2xxx: Fix read offset in qla24xx_load_risc_flash()
      scsi: qla2xxx: Update driver version to 10.01.00.16-k
      scsi: qla2xxx: Fix NULL pointer crash due to stale CPUID
      scsi: qla2xxx: Update driver version to 10.01.00.15-k

James Bottomley (1):
      scsi: lpfc: Fix build error

James Smart (36):
      scsi: lpfc: add support for posting FC events on FPIN reception
      scsi: scsi_transport_fc: Add FPIN fc event codes
      scsi: scsi_transport_fc: refactor event posting routines
      scsi: fc: add FPIN ELS definition
      scsi: lpfc: Fix missing wakeups on abort threads
      scsi: lpfc: Fixup eq_clr_intr references
      scsi: lpfc: Update lpfc version to 12.2.0.1
      scsi: lpfc: Update Copyright in driver version
      scsi: lpfc: Enhance 6072 log string
      scsi: lpfc: Fix duplicate log message numbers
      scsi: lpfc: Specify node affinity for queue memory allocation
      scsi: lpfc: Reduce memory footprint for lpfc_queue
      scsi: lpfc: Add loopback testing to trunking mode
      scsi: lpfc: Fix link speed reporting for 4-link trunk
      scsi: lpfc: Fix handling of trunk links state reporting
      scsi: lpfc: Fix protocol support on G6 and G7 adapters
      scsi: lpfc: Correct boot bios information to FDMI registration
      scsi: lpfc: Fix HDMI2 registration string for symbolic name
      scsi: lpfc: Fix fc4type information for FDMI
      scsi: lpfc: Fix FDMI manufacturer attribute value
      scsi: lpfc: Fix io lost on host resets
      scsi: lpfc: Fix mailbox hang on adapter init
      scsi: lpfc: Fix driver crash in target reset handler
      scsi: lpfc: Correct localport timeout duration error
      scsi: lpfc: Convert bootstrap mbx polling from msleep to udelay
      scsi: lpfc: Coordinate adapter error handling with offline handling
      scsi: lpfc: Stop adapter if pci errors detected
      scsi: lpfc: Fix deadlock due to nested hbalock call
      scsi: lpfc: Fix nvmet handling of first burst cmd
      scsi: lpfc: Fix lpfc_nvmet_mrq attribute handling when 0
      scsi: lpfc: Fix nvmet async receive buffer replenishment
      scsi: lpfc: Fix location of SCSI ktime counters
      scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices
      scsi: lpfc: Fix use-after-free mailbox cmd completion
      scsi: lpfc: Resolve irq-unsafe lockdep heirarchy warning in lpfc_io_free
      scsi: lpfc: Resolve inconsistent check of hdwq in lpfc_scsi_cmd_iocb_cmpl

Jan Kotas (2):
      scsi: ufs-cdns: Add support for UFSHCI with M31 PHY
      scsi: dt-bindings: ufs-cdns: Update Cadence UFS compatibility list

Joe Carnuccio (12):
      scsi: qla2xxx: Add 28xx flash primary/secondary status/image mechanism
      scsi: qla2xxx: Simplification of register address used in qla_tmpl.c
      scsi: qla2xxx: Correction and improvement to fwdt processing
      scsi: qla2xxx: Update flash read/write routine
      scsi: qla2xxx: Add support for multiple fwdump templates/segments
      scsi: qla2xxx: Cleanups for NVRAM/Flash read/write path
      scsi: qla2xxx: Correctly report max/min supported speeds
      scsi: qla2xxx: Add Serdes support for ISP28XX
      scsi: qla2xxx: Add Device ID for ISP28XX
      scsi: qla2xxx: Fix routine qla27xx_dump_{mpi|ram}()
      scsi: qla2xxx: Remove FW default template
      scsi: qla2xxx: Add fw_attr and port_no SysFS node

John Garry (7):
      scsi: libsas: Print expander PHY indexes in decimal
      scsi: libsas: Do discovery on empty PHY to update PHY info
      scsi: libsas: Inject revalidate event for root port event
      scsi: libsas: Improve vague log in SAS rediscovery
      scsi: libsas: Try to retain programmed min linkrate for SATA min pathway unmatch fixing
      scsi: libsas: Stop hardcoding SAS address length
      scsi: hisi_sas: Fix for setting the PHY linkrate when disconnected

Kangjie Lu (2):
      scsi: qla4xxx: fix a potential NULL pointer dereference
      scsi: ufs: fix a missing check of devm_reset_control_get

Kevin Barnett (1):
      scsi: smartpqi: increase LUN reset timeout

Li Zhong (1):
      scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT

Luo Jiaxing (3):
      scsi: hisi_sas: Don't fail IT nexus reset for Open Reject timeout
      scsi: hisi_sas: Don't hard reset disk during controller reset
      scsi: hisi_sas: Add softreset in hisi_sas_I_T_nexus_reset()

Manish Rangankar (2):
      scsi: qedi: Adjust termination and offload ramrod timers
      scsi: qedi: Abort ep termination if offload not scheduled

Martin K. Petersen (1):
      scsi: sd: Quiesce warning if device does not report optimal I/O size

Matteo Croce (1):
      scsi: be2iscsi: lpfc: fix typo

Maurizio Lombardi (1):
      scsi: iscsi: flush running unbind operations when removing a session

Michael Hernandez (1):
      scsi: qla2xxx: Secure flash update support for ISP28XX

Michael Kelley (2):
      scsi: storvsc: Reduce default ring buffer size to 128 Kbytes
      scsi: storvsc: Fix calculation of sub-channel count

Milan P. Gandhi (2):
      scsi: qla2xxx: Fix a small typo in qla_bsg.c
      scsi: qla2xxx: Fix comment alignment in qla_bsg.c

Ming Lei (1):
      scsi: core: don't hold device refcount in IO path

Nathan Chancellor (3):
      scsi: qla2xxx: Simplify conditional check again
      scsi: gdth: Only call dma_free_coherent when buf is not NULL in ioc_general
      scsi: ufs-mediatek: Avoid using ret uninitialized in ufs_mtk_setup_clocks

Pedro Sousa (1):
      scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value

Quinn Tran (5):
      scsi: qla2xxx: Fix device staying in blocked state
      scsi: qla2xxx: Cleanup fcport memory to prevent leak
      scsi: qla2xxx: Use mutex protection during qla2x00_sysfs_read_fw_dump()
      scsi: qla2xxx: Fix fw dump corruption
      scsi: qla2xxx: Fix FC-AL connection target discovery

Saurav Kashyap (14):
      scsi: qedf: Update the driver version to 8.37.25.20
      scsi: qedf: Add return value to log message if scsi_add_host fails
      scsi: qedf: Print fcport information on wait for upload timeout
      scsi: qedf: Check the return value of start_xmit
      scsi: qedf: Log message if scsi_add_host fails
      scsi: qedf: Check for fcoe_libfc_config failure
      scsi: qedf: Add comment to display logging levels
      scsi: qedf: Update the driver version to 8.37.25.19
      scsi: qedf: Fix lport may be used uninitialized warning
      scsi: qedf: Correctly handle refcounting of rdata
      scsi: qedf: Check for tm_flags instead of cmd_type during cleanup
      scsi: qedf: Don't send ABTS for under run scenario
      scsi: qedf: Check for link state before processing LL2 packets and send fipvlan retries
      scsi: qedf: Modify abort and tmf handler to handle edge condition and flush

Shyam Sundar (4):
      scsi: qedf: Cleanup rrq_work after QEDF_CMD_OUTSTANDING is cleared
      scsi: qedf: Add a flag to help debugging io_req which could not be cleaned
      scsi: qedf: Don't queue anything if upload is in progress
      scsi: qedf: Modify flush routine to handle all I/Os and TMF

Silvio Cesare (1):
      scsi: lpfc: change snprintf to scnprintf for possible overflow

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic during expander reset

Stanley Chu (16):
      scsi: ufs: Print real incorrect request response code
      scsi: dt-bindings: ufs: Add VCC capability on MediaTek UFS driver
      scsi: dt-bindings: ufs: Remove custom property "<name>-fixed-regulator"
      scsi: ufs: Remove "<name>-fixed-regulator" device tree property
      scsi: ufs: Change "<name>-max-microamp" to non-mandatory property
      scsi: ufs: Fix regulator load and icc-level configuration
      scsi: ufs: Avoid configuring regulator with undefined voltage range
      scsi: ufs: Remove unused min_uA field in struct ufs_vreg
      scsi: MAINTAINERS: Add maintainer for MediaTek UFS driver
      scsi: ufs-mediatek: Add UFS support for Mediatek SoC chips
      scsi: phy: mediatek: Add UFS M-PHY driver
      scsi: dt-bindings: ufs: Add document for ufs-mediatek
      scsi: dt-bindings: phy: Add document for phy-mtk-ufs
      scsi: ufs-hisi: Re-factor ufshcd_get_pwr_dev_param
      scsi: ufs-qcom: Re-factor ufshcd_get_pwr_dev_param
      scsi: ufs: Introduce ufshcd_get_pwr_dev_param

Steffen Maier (3):
      scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RSCN
      scsi: zfcp: fix scsi_eh host reset with port_forced ERP for non-NPIV FCP devices
      scsi: zfcp: fix rport unblock if deleted SCSI devices on Scsi_Host

Suganath Prabu (6):
      scsi: mpt3sas: Update mpt3sas driver version to 28.100.00.00
      scsi: mpt3sas: Improve the threshold value and introduce module param
      scsi: mpt3sas: Load balance to improve performance and avoid soft lockups
      scsi: mpt3sas: Irq poll to avoid CPU hard lockups
      scsi: mpt3sas: simplify interrupt handler
      scsi: mpt3sas: Fix typo in request_desript_type

Tyrel Datwyler (6):
      scsi: ibmvfc: Clean up transport events
      scsi: ibmvfc: Byte swap status and error codes when logging
      scsi: ibmvfc: Add failed PRLI to cmd_status lookup array
      scsi: ibmvfc: Remove "failed" from logged errors
      scsi: ibmvscsi: Fix empty event pool access during host removal
      scsi: ibmvscsi: Protect ibmvscsi_head from concurrent modificaiton

Varun Prakash (5):
      scsi: csiostor: create per port irq affinity mask set
      scsi: cxgb4i: fix incorrect spelling "reveive" -> "receive"
      scsi: libcxgbi: update route finding logic
      scsi: libcxgbi: find cxgbi device by MAC address
      scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Xiang Chen (5):
      scsi: hisi_sas: Some misc tidy-up
      scsi: hisi_sas: allocate different SAS address for directly attached situation
      scsi: hisi_sas: Adjust the printk format of functions hisi_sas_init_device()
      scsi: hisi_sas: Remedy inconsistent PHY down state in software
      scsi: hisi_sas: add host reset interface for test

Xiaofei Tan (1):
      scsi: hisi_sas: Support all RAS events with MSI interrupts

Xose Vazquez Perez (1):
      scsi: core: add new RDAC LENOVO/DE_Series device

YueHaibing (11):
      scsi: qedf: remove set but not used variables
      scsi: lpfc: Make lpfc_sli4_oas_verify static
      scsi: megaraid_sas: Make megasas_host_device_list_query() static
      scsi: qla2xxx: Remove useless set memory to zero use memset()
      scsi: qedf: Remove set but not used variable 'fr_len'
      scsi: pm8001: remove set but not used variables 'param, sas_ha'
      scsi: ufs-mediatek: Fix platform_no_drv_owner.cocci warnings
      scsi: ufs-mediatek: Make some symbols static
      scsi: mvumi: Stop using plain integer as NULL pointer
      scsi: qedi: Remove set but not used variable 'cls_sess'
      scsi: mptfusion: remove set, but not used, variables

Zeng Guangyue (1):
      scsi: ufs: remove unnecessary pointer evaluation

tangwenji (3):
      scsi: target: alua: fix the tg_pt_gps_count
      scsi: target: iscsi: Free conn_ops when zalloc_cpumask_var failed
      scsi: target: iscsi: Fix np_ip_proto and np_sock_type in iscsit_setup_np

zhengbin (1):
      scsi: core: Run queue when state is set to running after being blocked

and the diffstat:

 .../devicetree/bindings/phy/phy-mtk-ufs.txt        |   38 +
 .../devicetree/bindings/ufs/cdns,ufshc.txt         |    5 +-
 .../devicetree/bindings/ufs/ufs-mediatek.txt       |   43 +
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |    2 -
 MAINTAINERS                                        |    7 +
 drivers/message/fusion/mptbase.c                   |    2 +-
 drivers/message/fusion/mptctl.c                    |    2 +-
 drivers/message/fusion/mptsas.c                    |   36 +-
 drivers/message/fusion/mptscsih.c                  |    4 +-
 drivers/message/fusion/mptspi.c                    |    5 -
 drivers/nvme/host/fc.c                             |    2 +-
 drivers/phy/mediatek/Kconfig                       |   10 +
 drivers/phy/mediatek/Makefile                      |    1 +
 drivers/phy/mediatek/phy-mtk-ufs.c                 |  245 ++++
 drivers/s390/scsi/zfcp_erp.c                       |   17 +
 drivers/s390/scsi/zfcp_ext.h                       |    2 +
 drivers/s390/scsi/zfcp_fc.c                        |   21 +-
 drivers/s390/scsi/zfcp_scsi.c                      |    4 +
 drivers/scsi/NCR5380.c                             |   11 +-
 drivers/scsi/aacraid/aacraid.h                     |    7 +-
 drivers/scsi/aacraid/commsup.c                     |    4 +-
 drivers/scsi/aic7xxx/Kconfig.aic7xxx               |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/atp870u.c                             |    7 +-
 drivers/scsi/be2iscsi/be_cmds.c                    |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |    3 +-
 drivers/scsi/csiostor/csio_isr.c                   |   28 +-
 drivers/scsi/csiostor/csio_scsi.c                  |    5 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |   14 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |    2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   22 +-
 drivers/scsi/dpt_i2o.c                             |   12 +-
 drivers/scsi/gdth.c                                |    5 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |    3 +
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  108 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   21 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   49 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  473 +++---
 drivers/scsi/hpsa.c                                |   27 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   39 +-
 drivers/scsi/ibmvscsi/ibmvfc.h                     |    7 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   23 +-
 drivers/scsi/libsas/sas_ata.c                      |    2 +-
 drivers/scsi/libsas/sas_expander.c                 |   83 +-
 drivers/scsi/libsas/sas_init.c                     |   42 +-
 drivers/scsi/libsas/sas_phy.c                      |    7 +-
 drivers/scsi/libsas/sas_port.c                     |   24 +-
 drivers/scsi/lpfc/lpfc.h                           |    1 +
 drivers/scsi/lpfc/lpfc_attr.c                      |  243 ++--
 drivers/scsi/lpfc/lpfc_bsg.c                       |  123 +-
 drivers/scsi/lpfc/lpfc_bsg.h                       |    4 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   43 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |  486 +++----
 drivers/scsi/lpfc/lpfc_debugfs.h                   |    8 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   34 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   40 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |    4 +
 drivers/scsi/lpfc/lpfc_hw4.h                       |   42 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  137 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |    8 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   29 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   64 +-
 drivers/scsi/lpfc/lpfc_nvmet.h                     |    3 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   30 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  350 ++---
 drivers/scsi/lpfc/lpfc_sli.h                       |   19 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   54 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |    4 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |    2 +-
 drivers/scsi/mpt3sas/Kconfig                       |    1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  184 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   22 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   12 +
 drivers/scsi/mvsas/mv_64xx.c                       |    3 +-
 drivers/scsi/mvsas/mv_94xx.c                       |    3 +-
 drivers/scsi/mvsas/mv_sas.c                        |    2 +-
 drivers/scsi/mvumi.c                               |    6 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |   37 +-
 drivers/scsi/pm8001/pm8001_init.c                  |    4 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |    4 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |    2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   55 +-
 drivers/scsi/qedf/qedf.h                           |   57 +-
 drivers/scsi/qedf/qedf_dbg.c                       |   32 +-
 drivers/scsi/qedf/qedf_debugfs.c                   |   57 +-
 drivers/scsi/qedf/qedf_els.c                       |   82 +-
 drivers/scsi/qedf/qedf_fip.c                       |   95 +-
 drivers/scsi/qedf/qedf_io.c                        |  753 +++++++---
 drivers/scsi/qedf/qedf_main.c                      |  281 +++-
 drivers/scsi/qedf/qedf_version.h                   |    6 +-
 drivers/scsi/qedi/qedi_fw.c                        |    4 -
 drivers/scsi/qedi/qedi_iscsi.c                     |   12 +-
 drivers/scsi/qedi/qedi_main.c                      |    7 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  329 +++--
 drivers/scsi/qla2xxx/qla_bsg.c                     |   84 +-
 drivers/scsi/qla2xxx/qla_bsg.h                     |   11 +
 drivers/scsi/qla2xxx/qla_dbg.c                     |  192 ++-
 drivers/scsi/qla2xxx/qla_dbg.h                     |   10 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  267 ++--
 drivers/scsi/qla2xxx/qla_dfs.c                     |    9 +-
 drivers/scsi/qla2xxx/qla_dsd.h                     |   30 +
 drivers/scsi/qla2xxx/qla_fw.h                      |   98 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |  107 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  139 +-
 drivers/scsi/qla2xxx/qla_init.c                    | 1505 ++++++++++++--------
 drivers/scsi/qla2xxx/qla_inline.h                  |   69 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |  360 ++---
 drivers/scsi/qla2xxx/qla_isr.c                     |  144 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  336 +++--
 drivers/scsi/qla2xxx/qla_mid.c                     |    9 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |  111 +-
 drivers/scsi/qla2xxx/qla_mr.h                      |   11 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  115 +-
 drivers/scsi/qla2xxx/qla_nvme.h                    |   14 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |   38 +-
 drivers/scsi/qla2xxx/qla_nx.h                      |    2 +-
 drivers/scsi/qla2xxx/qla_nx2.c                     |   13 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  609 ++++----
 drivers/scsi/qla2xxx/qla_sup.c                     |  973 +++++++++----
 drivers/scsi/qla2xxx/qla_target.c                  |  201 +--
 drivers/scsi/qla2xxx/qla_target.h                  |   33 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  447 +++---
 drivers/scsi/qla2xxx/qla_tmpl.h                    |   76 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   58 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    4 +-
 drivers/scsi/qlogicfas408.c                        |    4 +-
 drivers/scsi/scsi_devinfo.c                        |    1 +
 drivers/scsi/scsi_dh.c                             |    1 +
 drivers/scsi/scsi_error.c                          |    1 -
 drivers/scsi/scsi_lib.c                            |   45 +-
 drivers/scsi/scsi_scan.c                           |    7 +-
 drivers/scsi/scsi_sysfs.c                          |    6 +
 drivers/scsi/scsi_transport_fc.c                   |  119 +-
 drivers/scsi/scsi_transport_iscsi.c                |    2 +
 drivers/scsi/sd.c                                  |   22 +-
 drivers/scsi/smartpqi/Makefile                     |    1 +
 drivers/scsi/smartpqi/smartpqi.h                   |   15 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   51 +-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c     |   15 +-
 drivers/scsi/smartpqi/smartpqi_sis.c               |   15 +-
 drivers/scsi/smartpqi/smartpqi_sis.h               |   15 +-
 drivers/scsi/storvsc_drv.c                         |   15 +-
 drivers/scsi/ufs/Kconfig                           |   14 +
 drivers/scsi/ufs/Makefile                          |    1 +
 drivers/scsi/ufs/cdns-pltfrm.c                     |   74 +-
 drivers/scsi/ufs/ufs-hisi.c                        |  113 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |  368 +++++
 drivers/scsi/ufs/ufs-mediatek.h                    |   53 +
 drivers/scsi/ufs/ufs-qcom.c                        |  106 +-
 drivers/scsi/ufs/ufs.h                             |    1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  112 +-
 drivers/scsi/ufs/ufshcd-pltfrm.h                   |   21 +
 drivers/scsi/ufs/ufshcd.c                          |   41 +-
 drivers/scsi/ufs/unipro.h                          |    2 +-
 drivers/scsi/virtio_scsi.c                         |    2 +-
 drivers/target/iscsi/iscsi_target.c                |  118 +-
 drivers/target/iscsi/iscsi_target_login.c          |    9 +-
 drivers/target/iscsi/iscsi_target_util.c           |    5 +
 drivers/target/target_core_alua.c                  |    6 +-
 drivers/target/target_core_configfs.c              |  163 ++-
 drivers/target/target_core_device.c                |    4 +-
 drivers/target/target_core_pr.c                    |   33 +-
 drivers/target/target_core_pr.h                    |    1 +
 drivers/target/target_core_tmr.c                   |    2 +-
 drivers/target/target_core_xcopy.c                 |   92 +-
 include/linux/nvme-fc-driver.h                     |    6 -
 include/scsi/libsas.h                              |   13 +-
 include/scsi/osd_attributes.h                      |  398 ------
 include/scsi/osd_protocol.h                        |  676 ---------
 include/scsi/osd_sec.h                             |   45 -
 include/scsi/osd_sense.h                           |  263 ----
 include/scsi/osd_types.h                           |   45 -
 include/scsi/scsi_host.h                           |    6 +-
 include/scsi/scsi_transport_fc.h                   |   18 +-
 include/target/iscsi/iscsi_target_core.h           |    1 +
 include/target/target_core_base.h                  |    4 +-
 include/target/target_core_fabric.h                |    1 +
 include/uapi/scsi/fc/fc_els.h                      |   33 +
 180 files changed, 8037 insertions(+), 6489 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
 create mode 100644 drivers/phy/mediatek/phy-mtk-ufs.c
 create mode 100644 drivers/scsi/qla2xxx/qla_dsd.h
 create mode 100644 drivers/scsi/ufs/ufs-mediatek.c
 create mode 100644 drivers/scsi/ufs/ufs-mediatek.h
 delete mode 100644 include/scsi/osd_attributes.h
 delete mode 100644 include/scsi/osd_protocol.h
 delete mode 100644 include/scsi/osd_sec.h
 delete mode 100644 include/scsi/osd_sense.h
 delete mode 100644 include/scsi/osd_types.h

James
