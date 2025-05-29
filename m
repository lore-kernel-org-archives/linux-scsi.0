Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F241F19A;
	Thu, 29 May 2025 17:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748541046; cv=none; b=Ix7izTlUlx9ANYm+VY12PFQ3XUKHGojThgTMS6yiIBT/wmFZ27wGR3uyFA3ktGi2/fC1ptXGubtAgKaJKfLUCEsI2tPj9jP3+GctvN19LmgMcpee4TvcL6tWfF5v89VNI54h4C7giC8T2lnVBFl8dpJrRJ1NtO9YSbdcLBS01DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748541046; c=relaxed/simple;
	bh=+s2Cur19DP9hB0WYfCgKF5nOFgrmQPEhk9aC8V7MzFk=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=gJkz4z6d+yV3AEoc5AXxh5fVnDkYyJvQaeGN9122+0k0LWUsC+8temKYvpAMXFxVm2KZUG01aEBjLl6Oc5I/XZ6lVcRgpiP+2olSSqzMFTFA6JH/RKmFIYkFAzm0ppQIrkTwzZKx6C2EsNoCmJEiPPQNDOFnkr7qce03I/pgwm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=dBx3c09U; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="dBx3c09U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1748541040;
	bh=+s2Cur19DP9hB0WYfCgKF5nOFgrmQPEhk9aC8V7MzFk=;
	h=Message-ID:Subject:From:To:Date:From;
	b=dBx3c09UXp2LyfnEPP6+00AhTMrROQG5Br1oDmpWhQCqbQsD1qudg0k0ZQp07tbre
	 qA+hm9Pzeq7IAnmCqkyJtJ4mi4dPraX2J/87yodH+UKMLTrNZnmsPrm7EJBrlMATTX
	 ASnFbRSS3XgxrkcGGFIdpZ6fTzf8wQZEHgjUYXHI=
Received: from [IPv6:2601:5c4:4302:c21::a774] (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id C4C751C0103;
	Thu, 29 May 2025 13:50:40 -0400 (EDT)
Message-ID: <a68bfa4b6e75c8bfa2cb847d0b4867f44f9b8109.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 6.14+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Thu, 29 May 2025 13:50:39 -0400
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Updates to the usual drivers (smartpqi, ufs, lpfc, scsi_debug, target,
hisi_sas) with the only substantive core change being the removal of
the stream_status member from the scsi_stream_status_header (to get rid
of flex array members).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alok Tiwari (1):
      scsi: mvsas: Fix typos in SAS/SATA VSP register comments

Bart Van Assche (1):
      scsi: ufs: core: Increase the UIC command timeout further

Benjamin Block (1):
      scsi: zfcp: Simplify workqueue allocation

Chelsy Ratnawat (1):
      scsi: mpi3mr: Fix typo and grammar

Chen Ni (2):
      scsi: sg: Remove unnecessary NULL check before unregister_sysctl_tabl=
e()
      scsi: fnic: Replace memset() with eth_zero_addr()

Christoph Hellwig (1):
      scsi: sd: Remove the stream_status member from scsi_stream_status_hea=
der

Christophe JAILLET (2):
      scsi: target: core: Constify struct target_opcode_descriptor
      scsi: target: core: Constify enabled() in struct target_opcode_descri=
ptor

Dan Carpenter (1):
      scsi: smartpqi: Delete a stray tab in pqi_is_parity_write_stream()

Daniel Wagner (1):
      scsi: lpfc: Use memcpy() for BIOS version

David Strahan (2):
      scsi: smartpqi: Add new PCI IDs
      scsi: smartpqi: Take drives offline when controller is offline

Don Brace (1):
      scsi: smartpqi: Update driver version to 2.1.34-035

Dr. David Alan Gilbert (12):
      scsi: core: Remove unused scsi_dev_info_list_del_keyed()
      scsi: isci: Remove unused sci_remote_device_reset()
      scsi: qedi: Remove unused qedi_get_proto_itt()
      scsi: qedi: Remove unused sysfs functions
      scsi: qla2xxx: Remove unused module parameters
      scsi: qla2xxx: Remove unused qla2x00_gpsc()
      scsi: qla2xxx: Remove unused ql_log_qp
      scsi: qla2xxx: Remove unused qla82xx_wait_for_state_change()
      scsi: qla2xxx: Remove unused qla82xx_pci_region_offset()
      scsi: qla2xxx: Remove unused qlt_83xx_iospace_config()
      scsi: qla2xxx: Remove unused qlt_fc_port_deleted()
      scsi: qla2xxx: Remove unused qlt_free_qfull_cmds()

Eric Biggers (2):
      scsi: ufs: qcom: Add support for wrapped keys
      scsi: soc: qcom: ice: Make qcom_ice_program_key() take struct blk_cry=
pto_key

Gaurav Kashyap (1):
      scsi: soc: qcom: ice: Add HWKM support to the ICE driver

Huan Tang (2):
      scsi: ufs: core: Fix WB resize using wrong offset
      scsi: ufs: core: Add WB buffer resize support

John Garry (1):
      scsi: scsi_debug: Reduce DEF_ATOMIC_WR_MAX_LENGTH

Justin Tee (8):
      scsi: lpfc: Copyright updates for 14.4.0.9 patches
      scsi: lpfc: Update lpfc version to 14.4.0.9
      scsi: lpfc: Create lpfc_vmid_info sysfs entry
      scsi: lpfc: Avoid potential ndlp use-after-free in dev_loss_tmo_callb=
k
      scsi: lpfc: Prevent failure to reregister with NVMe transport after P=
RLI retry
      scsi: lpfc: Restart eratt_poll timer if HBA_SETUP flag still unset
      scsi: lpfc: Notify FC transport of rport disappearance during PCI fcn=
 reset
      scsi: lpfc: Fix lpfc_check_sli_ndlp() handling for GEN_REQUEST64 comm=
ands

Kai M=C3=A4kisara (5):
      scsi: scsi_debug: Add ERASE for tapes
      scsi: scsi_debug: Use scsi_device->type instead os sdebug_ptype where=
 possible
      scsi: scsi_debug: Move some tape-specific commands to separate defini=
tions
      scsi: scsi_debug: Enable different command definitions for different =
device types
      scsi: scsi_debug: Fix two typos in command definitions

Kees Cook (3):
      scsi: qla4xxx: Remove duplicate struct crb_addr_pair
      scsi: qla2xxx: Remove duplicate struct crb_addr_pair
      scsi: pm80xx: Add __nonstring annotations for unterminated strings

Manish Pandey (3):
      scsi: ufs: ufs-qcom: Add support to dump testbus registers
      scsi: ufs: ufs-qcom: Add support to dump MCQ registers
      scsi: ufs: ufs-qcom: Add support to dump HW and SW hibern8 count

Mike Christie (2):
      scsi: target: Move delayed/ordered tracking to per CPU
      scsi: target: Move I/O path stats to per CPU

Nathan Chancellor (1):
      scsi: dc395x: Remove leftover if statement in reselect()

Neil Armstrong (3):
      scsi: ufs: core: Delegate the interrupt service routine to a threaded=
 IRQ handler
      scsi: ufs: core: Track when MCQ ESI is enabled
      scsi: ufs: core: Drop last_intr_status/ts stats

Nitin Rawat (1):
      scsi: ufs: qcom: dt-bindings: Document the SM8750 UFS Controller

Oliver Neukum (1):
      scsi: dc395x: Remove DEBUG conditional compilation

Peter Wang (2):
      scsi: ufs: core: Support updating device command timeout
      scsi: ufs: core: Change hwq_id type and value

Randy Dunlap (1):
      scsi: docs: Clean up some style in scsi_mid_low_api

Ranjan Kumar (1):
      scsi: mpi3mr: Event processing debug improvement

Shivasharan S (1):
      scsi: mpt3sas: Fix _ctl_get_mpt_mctp_passthru_adapter() to return IOC=
 pointer

Thorsten Blum (3):
      scsi: lpfc: Use secs_to_jiffies() instead of msecs_to_jiffies()
      scsi: target: Remove size arguments when calling strscpy()
      scsi: elx: sli4: Replace deprecated strncpy() with strscpy()

Venkatesh Emparala (1):
      scsi: smartpqi: Enhance WWID logging logic

WangYuli (1):
      scsi: scsi_transport_fc: Rename del_timer() in comment

Wonkon Kim (1):
      scsi: ufs: core: Print error value as hex format in ufshcd_err_handle=
r()

Yi Zhang (1):
      scsi: smartpqi: Fix smp_processor_id() call trace for preemptible ker=
nels

Yihang Li (5):
      scsi: hisi_sas: Fix warning detected by sparse
      scsi: hisi_sas: Wait until error handling is complete
      scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk
      scsi: hisi_sas: Coding style cleanup
      scsi: hisi_sas: Use macro instead of magic number

ping.gao (1):
      scsi: ufs: mcq: Delete ufshcd_release_scsi_cmd() in ufshcd_mcq_abort(=
)

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs         |  49 ++
 .../devicetree/bindings/ufs/qcom,ufs.yaml          |   2 +
 Documentation/scsi/scsi_mid_low_api.rst            |  18 +-
 drivers/mmc/host/sdhci-msm.c                       |  16 +-
 drivers/s390/scsi/zfcp_aux.c                       |  14 +-
 drivers/scsi/dc395x.c                              | 697 +----------------=
----
 drivers/scsi/elx/libefc_sli/sli4.c                 |   6 +-
 drivers/scsi/fnic/fip.c                            |   8 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |  51 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  81 ++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 259 +++++---
 drivers/scsi/isci/remote_device.c                  |  30 -
 drivers/scsi/isci/remote_device.h                  |  15 -
 drivers/scsi/lpfc/lpfc_attr.c                      | 136 +++-
 drivers/scsi/lpfc/lpfc_bsg.c                       |   6 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  38 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   3 +
 drivers/scsi/lpfc/lpfc_nvme.c                      |  10 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  30 +-
 drivers/scsi/lpfc/lpfc_version.h                   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   4 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  73 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   3 +-
 drivers/scsi/mvsas/mv_64xx.h                       |   4 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |   2 +-
 drivers/scsi/qedi/qedi_dbg.c                       |  22 -
 drivers/scsi/qedi/qedi_dbg.h                       |  12 -
 drivers/scsi/qedi/qedi_gbl.h                       |   1 -
 drivers/scsi/qedi/qedi_main.c                      |   8 -
 drivers/scsi/qla2xxx/qla_dbg.c                     |  53 --
 drivers/scsi/qla2xxx/qla_dbg.h                     |   3 -
 drivers/scsi/qla2xxx/qla_gbl.h                     |   5 -
 drivers/scsi/qla2xxx/qla_gs.c                      |  90 ---
 drivers/scsi/qla2xxx/qla_nx.c                      |  50 --
 drivers/scsi/qla2xxx/qla_os.c                      |  12 -
 drivers/scsi/qla2xxx/qla_target.c                  | 129 ----
 drivers/scsi/qla2xxx/qla_target.h                  |   3 -
 drivers/scsi/qla4xxx/ql4_nx.c                      |   5 -
 drivers/scsi/scsi_debug.c                          | 361 ++++++-----
 drivers/scsi/scsi_devinfo.c                        |  27 -
 drivers/scsi/scsi_priv.h                           |   2 -
 drivers/scsi/scsi_transport_fc.c                   |   2 +-
 drivers/scsi/sd.c                                  |   2 +-
 drivers/scsi/sg.c                                  |   3 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 140 ++++-
 drivers/soc/qcom/ice.c                             | 350 ++++++++++-
 drivers/target/target_core_configfs.c              |  20 +-
 drivers/target/target_core_device.c                |  89 ++-
 drivers/target/target_core_spc.c                   | 134 ++--
 drivers/target/target_core_stat.c                  |  69 +-
 drivers/target/target_core_transport.c             | 119 ++--
 drivers/ufs/core/ufs-mcq.c                         |   6 -
 drivers/ufs/core/ufs-sysfs.c                       | 133 ++++
 drivers/ufs/core/ufshcd.c                          | 103 ++-
 drivers/ufs/host/ufs-qcom.c                        | 181 +++++-
 drivers/ufs/host/ufs-qcom.h                        |  11 +
 include/scsi/scsi_proto.h                          |   3 +-
 include/soc/qcom/ice.h                             |  34 +-
 include/target/target_core_base.h                  |  26 +-
 include/ufs/ufs.h                                  |  32 +
 include/ufs/ufshcd.h                               |   8 +-
 63 files changed, 1990 insertions(+), 1823 deletions(-)

Regards,

James

