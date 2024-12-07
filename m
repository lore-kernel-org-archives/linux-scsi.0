Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D13E1DFE1;
	Sat,  7 Dec 2024 19:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733598088; cv=none; b=ScoyCaGhGCggkptd7JtIw/qu/GTEaJsgqllDwHXSQtayiBEWaVxQvJhmp9Rp08cj5z0K+CvzAgKt6CxePtfbsNprD5TKmLaXL+fqBCRfaQzz4xcWOW287qJagRZ3CI+zz6kf8UFJzAl1J81yxXxpstG0YozwEmoK4OkG6py6oWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733598088; c=relaxed/simple;
	bh=Ie6Q67LZpx9+4F1pVoXnIc3bQjDvP0dU8VSgEmhLSgE=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=GFGL6SxMfqhKbvwo43xXwCrsnFbjbQXa1zrDpxf7Nv7uuSVC4urXoMEp+0Fqg31L5/2GKNlx8lHYTMYOgk1wWg28IMGFHhUv/YeaKJ2avvxuhJ3UNxECff5nyI6kk1333iUBWbaiRNCxyPpF9hrr8wu/PtA5WfmACVVFG4bNp48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=u62F2LmH; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=u62F2LmH; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="u62F2LmH";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="u62F2LmH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1733598082;
	bh=Ie6Q67LZpx9+4F1pVoXnIc3bQjDvP0dU8VSgEmhLSgE=;
	h=Message-ID:Subject:From:To:Date:From;
	b=u62F2LmHFeExBof9ZOJVv3AVVZVX/z884/TjyDcUKnr7Q/D1pKRbaDpZR6g5WZvL2
	 PYliT0OvclANtAKM5b6c0EVY9Jqv2zTqX7wspZGwyJ65698WBqp5PIxqLHWY84+jja
	 kWt8iC2vQBSCInpUO3mBjy3dRPRnyCkCjxMiXZyw=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 9A25E1286D0B;
	Sat, 07 Dec 2024 14:01:22 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id rIEQNrm6Svw5; Sat,  7 Dec 2024 14:01:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1733598082;
	bh=Ie6Q67LZpx9+4F1pVoXnIc3bQjDvP0dU8VSgEmhLSgE=;
	h=Message-ID:Subject:From:To:Date:From;
	b=u62F2LmHFeExBof9ZOJVv3AVVZVX/z884/TjyDcUKnr7Q/D1pKRbaDpZR6g5WZvL2
	 PYliT0OvclANtAKM5b6c0EVY9Jqv2zTqX7wspZGwyJ65698WBqp5PIxqLHWY84+jja
	 kWt8iC2vQBSCInpUO3mBjy3dRPRnyCkCjxMiXZyw=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E961E1286CF2;
	Sat, 07 Dec 2024 14:01:21 -0500 (EST)
Message-ID: <ebffd769d3f0dfc8877592c728f158190b057c30.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.13-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 07 Dec 2024 14:01:20 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Large number of small fixes, all in drivers.  The three largest fixes
are dead code removal in bfa, qla2xxx: fix abort timeout in bsg and
mpi3mr: Fix corrupt config pages PHY state is switched in sysfs.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Anil Gurumurthy (1):
      scsi: qla2xxx: Supported speed displayed incorrectly for VPorts

Cathy Avery (1):
      scsi: storvsc: Do not flag MAINTENANCE_IN return of SRB_STATUS_DATA_OVERRUN as an error

Christophe JAILLET (2):
      scsi: target: tcmu: Constify some structures
      scsi: message: fusion: Constify struct pci_device_id

Dr. David Alan Gilbert (2):
      scsi: bfa: Remove unused parsers
      scsi: bfa: Remove unused structure builders

Gwendal Grignou (1):
      scsi: ufs: core: sysfs: Prevent div by zero

John Garry (1):
      scsi: scsi_debug: Fix hrtimer support for ndelay

Magnus Lindholm (1):
      scsi: qla1280: Fix hw revision numbering for ISP1020/1040

Manivannan Sadhasivam (5):
      scsi: ufs: pltfrm: Dellocate HBA during ufshcd_pltfrm_remove()
      scsi: ufs: pltfrm: Drop PM runtime reference count after ufshcd_remove()
      scsi: ufs: pltfrm: Disable runtime PM during removal of glue drivers
      scsi: ufs: qcom: Only free platform MSIs when ESI is enabled
      scsi: ufs: core: Cancel RTC work during ufshcd_remove()

Nilesh Javali (1):
      scsi: qla2xxx: Update version to 10.02.09.400-k

Peter Wang (1):
      scsi: ufs: core: Add missing post notify for power mode change

Quinn Tran (3):
      scsi: qla2xxx: Fix NVMe and NPIV connect issue
      scsi: qla2xxx: Fix use after free on unload
      scsi: qla2xxx: Fix abort in bsg timeout

Ranjan Kumar (7):
      scsi: mpi3mr: Update driver version to 8.12.0.3.50
      scsi: mpi3mr: Handling of fault code for insufficient power
      scsi: mpi3mr: Start controller indexing from 0
      scsi: mpi3mr: Fix corrupt config pages PHY state is switched in sysfs
      scsi: mpi3mr: Synchronize access to ioctl data buffer
      scsi: mpt3sas: Update driver version to 51.100.00.00
      scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time

Saurav Kashyap (1):
      scsi: qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt

Suraj Sonawane (1):
      scsi: sg: Fix slab-use-after-free read in sg_release()

Tomas Henzl (1):
      scsi: megaraid_sas: Fix for a potential deadlock

Uwe Kleine-König (1):
      scsi: ufs: Switch back to struct platform_driver::remove()

Ziqi Chen (1):
      scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS BSG

liujing (1):
      scsi: lpfc: Fix spelling errors 'asynchronously'

and the diffstat:

 drivers/message/fusion/mptfc.c            |   2 +-
 drivers/message/fusion/mptsas.c           |   2 +-
 drivers/message/fusion/mptspi.c           |   2 +-
 drivers/scsi/bfa/bfa_fcbuild.c            | 482 ------------------------------
 drivers/scsi/bfa/bfa_fcbuild.h            |  72 -----
 drivers/scsi/lpfc/lpfc_nvme.c             |   2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c            |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |   5 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  13 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c          |  36 ++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 121 ++++----
 drivers/scsi/mpi3mr/mpi3mr_os.c           |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c       |   7 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h       |   8 +-
 drivers/scsi/qla1280.h                    |  12 +-
 drivers/scsi/qla2xxx/qla_attr.c           |   1 +
 drivers/scsi/qla2xxx/qla_bsg.c            | 124 ++++++--
 drivers/scsi/qla2xxx/qla_mid.c            |   1 +
 drivers/scsi/qla2xxx/qla_os.c             |  15 +-
 drivers/scsi/qla2xxx/qla_version.h        |   4 +-
 drivers/scsi/scsi_debug.c                 |   2 +-
 drivers/scsi/sg.c                         |   2 +-
 drivers/scsi/storvsc_drv.c                |   7 +-
 drivers/target/target_core_user.c         |   4 +-
 drivers/ufs/core/ufs-sysfs.c              |   6 +
 drivers/ufs/core/ufs_bsg.c                |   2 +-
 drivers/ufs/core/ufshcd-priv.h            |   1 +
 drivers/ufs/core/ufshcd.c                 |  44 ++-
 drivers/ufs/host/cdns-pltfrm.c            |   6 +-
 drivers/ufs/host/tc-dwc-g210-pltfrm.c     |   7 +-
 drivers/ufs/host/ti-j721e-ufs.c           |   2 +-
 drivers/ufs/host/ufs-exynos.c             |   5 +-
 drivers/ufs/host/ufs-hisi.c               |   6 +-
 drivers/ufs/host/ufs-mediatek.c           |   7 +-
 drivers/ufs/host/ufs-qcom.c               |   9 +-
 drivers/ufs/host/ufs-renesas.c            |   6 +-
 drivers/ufs/host/ufs-sprd.c               |   7 +-
 drivers/ufs/host/ufshcd-pltfrm.c          |  16 +
 drivers/ufs/host/ufshcd-pltfrm.h          |   1 +
 include/ufs/ufshcd.h                      |  10 +-
 40 files changed, 312 insertions(+), 751 deletions(-)

With full diff below.

James

---

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 91242f26defb..ee61b70aa677 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -137,7 +137,7 @@ static const struct scsi_host_template mptfc_driver_template = {
  * Supported hardware
  */
 
-static struct pci_device_id mptfc_pci_table[] = {
+static const struct pci_device_id mptfc_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC909,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a798e26c6402..d0549a4daf76 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5377,7 +5377,7 @@ static void mptsas_remove(struct pci_dev *pdev)
 	mptscsih_remove(pdev);
 }
 
-static struct pci_device_id mptsas_pci_table[] = {
+static const struct pci_device_id mptsas_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068,
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 574b882c9a85..4184d0c70ac3 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1238,7 +1238,7 @@ static struct spi_function_template mptspi_transport_functions = {
  * Supported hardware
  */
 
-static struct pci_device_id mptspi_pci_table[] = {
+static const struct pci_device_id mptspi_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1030,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_ATTO, MPI_MANUFACTPAGE_DEVID_53C1030,
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 52303e8c716d..c44fd096ee68 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -219,44 +219,6 @@ fc_plogi_x_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 	return sizeof(struct fc_logi_s);
 }
 
-u16
-fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
-		u16 ox_id, wwn_t port_name, wwn_t node_name, u16 pdu_size,
-	       u8 set_npiv, u8 set_auth, u16 local_bb_credits)
-{
-	u32        d_id = bfa_hton3b(FC_FABRIC_PORT);
-	__be32	*vvl_info;
-
-	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
-
-	flogi->els_cmd.els_code = FC_ELS_FLOGI;
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	flogi->csp.rxsz = flogi->class3.rxsz = cpu_to_be16(pdu_size);
-	flogi->port_name = port_name;
-	flogi->node_name = node_name;
-
-	/*
-	 * Set the NPIV Capability Bit ( word 1, bit 31) of Common
-	 * Service Parameters.
-	 */
-	flogi->csp.ciro = set_npiv;
-
-	/* set AUTH capability */
-	flogi->csp.security = set_auth;
-
-	flogi->csp.bbcred = cpu_to_be16(local_bb_credits);
-
-	/* Set brcd token in VVL */
-	vvl_info = (u32 *)&flogi->vvl[0];
-
-	/* set the flag to indicate the presence of VVL */
-	flogi->csp.npiv_supp    = 1; /* @todo. field name is not correct */
-	vvl_info[0]	= cpu_to_be32(FLOGI_VVL_BRCD);
-
-	return sizeof(struct fc_logi_s);
-}
-
 u16
 fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 		   __be16 ox_id, wwn_t port_name, wwn_t node_name,
@@ -279,24 +241,6 @@ fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 	return sizeof(struct fc_logi_s);
 }
 
-u16
-fc_fdisc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
-		u16 ox_id, wwn_t port_name, wwn_t node_name, u16 pdu_size)
-{
-	u32        d_id = bfa_hton3b(FC_FABRIC_PORT);
-
-	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
-
-	flogi->els_cmd.els_code = FC_ELS_FDISC;
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	flogi->csp.rxsz = flogi->class3.rxsz = cpu_to_be16(pdu_size);
-	flogi->port_name = port_name;
-	flogi->node_name = node_name;
-
-	return sizeof(struct fc_logi_s);
-}
-
 u16
 fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 	       u16 ox_id, wwn_t port_name, wwn_t node_name,
@@ -315,40 +259,6 @@ fc_plogi_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 				node_name, pdu_size, bb_cr, FC_ELS_ACC);
 }
 
-enum fc_parse_status
-fc_plogi_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
-{
-	struct fc_els_cmd_s *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
-	struct fc_logi_s *plogi;
-	struct fc_ls_rjt_s *ls_rjt;
-
-	switch (els_cmd->els_code) {
-	case FC_ELS_LS_RJT:
-		ls_rjt = (struct fc_ls_rjt_s *) (fchs + 1);
-		if (ls_rjt->reason_code == FC_LS_RJT_RSN_LOGICAL_BUSY)
-			return FC_PARSE_BUSY;
-		else
-			return FC_PARSE_FAILURE;
-	case FC_ELS_ACC:
-		plogi = (struct fc_logi_s *) (fchs + 1);
-		if (len < sizeof(struct fc_logi_s))
-			return FC_PARSE_FAILURE;
-
-		if (!wwn_is_equal(plogi->port_name, port_name))
-			return FC_PARSE_FAILURE;
-
-		if (!plogi->class3.class_valid)
-			return FC_PARSE_FAILURE;
-
-		if (be16_to_cpu(plogi->class3.rxsz) < (FC_MIN_PDUSZ))
-			return FC_PARSE_FAILURE;
-
-		return FC_PARSE_OK;
-	default:
-		return FC_PARSE_FAILURE;
-	}
-}
-
 enum fc_parse_status
 fc_plogi_parse(struct fchs_s *fchs)
 {
@@ -421,21 +331,6 @@ fc_prli_rsp_parse(struct fc_prli_s *prli, int len)
 	return FC_PARSE_OK;
 }
 
-enum fc_parse_status
-fc_prli_parse(struct fc_prli_s *prli)
-{
-	if (prli->parampage.type != FC_TYPE_FCP)
-		return FC_PARSE_FAILURE;
-
-	if (!prli->parampage.imagepair)
-		return FC_PARSE_FAILURE;
-
-	if (!prli->parampage.servparams.initiator)
-		return FC_PARSE_FAILURE;
-
-	return FC_PARSE_OK;
-}
-
 u16
 fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id, u32 s_id,
 	      u16 ox_id, wwn_t port_name)
@@ -506,84 +401,6 @@ fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len, wwn_t port_name,
 	return FC_PARSE_OK;
 }
 
-enum fc_parse_status
-fc_adisc_parse(struct fchs_s *fchs, void *pld, u32 host_dap, wwn_t node_name,
-	       wwn_t port_name)
-{
-	struct fc_adisc_s *adisc = (struct fc_adisc_s *) pld;
-
-	if (adisc->els_cmd.els_code != FC_ELS_ACC)
-		return FC_PARSE_FAILURE;
-
-	if ((adisc->nport_id == (host_dap))
-	    && wwn_is_equal(adisc->orig_port_name, port_name)
-	    && wwn_is_equal(adisc->orig_node_name, node_name))
-		return FC_PARSE_OK;
-
-	return FC_PARSE_FAILURE;
-}
-
-enum fc_parse_status
-fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name, wwn_t port_name)
-{
-	struct fc_logi_s *pdisc = (struct fc_logi_s *) (fchs + 1);
-
-	if (pdisc->class3.class_valid != 1)
-		return FC_PARSE_FAILURE;
-
-	if ((be16_to_cpu(pdisc->class3.rxsz) <
-		(FC_MIN_PDUSZ - sizeof(struct fchs_s)))
-	    || (pdisc->class3.rxsz == 0))
-		return FC_PARSE_FAILURE;
-
-	if (!wwn_is_equal(pdisc->port_name, port_name))
-		return FC_PARSE_FAILURE;
-
-	if (!wwn_is_equal(pdisc->node_name, node_name))
-		return FC_PARSE_FAILURE;
-
-	return FC_PARSE_OK;
-}
-
-u16
-fc_abts_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
-{
-	memcpy(fchs, &fc_bls_req_tmpl, sizeof(struct fchs_s));
-	fchs->cat_info = FC_CAT_ABTS;
-	fchs->d_id = (d_id);
-	fchs->s_id = (s_id);
-	fchs->ox_id = cpu_to_be16(ox_id);
-
-	return sizeof(struct fchs_s);
-}
-
-enum fc_parse_status
-fc_abts_rsp_parse(struct fchs_s *fchs, int len)
-{
-	if ((fchs->cat_info == FC_CAT_BA_ACC)
-	    || (fchs->cat_info == FC_CAT_BA_RJT))
-		return FC_PARSE_OK;
-
-	return FC_PARSE_FAILURE;
-}
-
-u16
-fc_rrq_build(struct fchs_s *fchs, struct fc_rrq_s *rrq, u32 d_id, u32 s_id,
-	     u16 ox_id, u16 rrq_oxid)
-{
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	/*
-	 * build rrq payload
-	 */
-	memcpy(rrq, &rrq_tmpl, sizeof(struct fc_rrq_s));
-	rrq->s_id = (s_id);
-	rrq->ox_id = cpu_to_be16(rrq_oxid);
-	rrq->rx_id = FC_RXID_ANY;
-
-	return sizeof(struct fc_rrq_s);
-}
-
 u16
 fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 		  __be16 ox_id)
@@ -658,30 +475,6 @@ fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code)
 	return num_pages;
 }
 
-u16
-fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
-		u32 d_id, u32 s_id, __be16 ox_id, int num_pages)
-{
-	int             page;
-
-	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
-
-	memset(tprlo_acc, 0, (num_pages * 16) + 4);
-	tprlo_acc->command = FC_ELS_ACC;
-
-	tprlo_acc->page_len = 0x10;
-	tprlo_acc->payload_len = cpu_to_be16((num_pages * 16) + 4);
-
-	for (page = 0; page < num_pages; page++) {
-		tprlo_acc->tprlo_acc_params[page].opa_valid = 0;
-		tprlo_acc->tprlo_acc_params[page].rpa_valid = 0;
-		tprlo_acc->tprlo_acc_params[page].fc4type_csp = FC_TYPE_FCP;
-		tprlo_acc->tprlo_acc_params[page].orig_process_assc = 0;
-		tprlo_acc->tprlo_acc_params[page].resp_process_assc = 0;
-	}
-	return be16_to_cpu(tprlo_acc->payload_len);
-}
-
 u16
 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc, u32 d_id,
 		  u32 s_id, __be16 ox_id, int num_pages)
@@ -706,20 +499,6 @@ fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc, u32 d_id,
 	return be16_to_cpu(prlo_acc->payload_len);
 }
 
-u16
-fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid, u32 d_id,
-		u32 s_id, u16 ox_id, u32 data_format)
-{
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	memset(rnid, 0, sizeof(struct fc_rnid_cmd_s));
-
-	rnid->els_cmd.els_code = FC_ELS_RNID;
-	rnid->node_id_data_format = data_format;
-
-	return sizeof(struct fc_rnid_cmd_s);
-}
-
 u16
 fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc, u32 d_id,
 		  u32 s_id, __be16 ox_id, u32 data_format,
@@ -748,18 +527,6 @@ fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc, u32 d_id,
 
 }
 
-u16
-fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc, u32 d_id,
-		u32 s_id, u16 ox_id)
-{
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	memset(rpsc, 0, sizeof(struct fc_rpsc_cmd_s));
-
-	rpsc->els_cmd.els_code = FC_ELS_RPSC;
-	return sizeof(struct fc_rpsc_cmd_s);
-}
-
 u16
 fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2, u32 d_id,
 		u32 s_id, u32 *pid_list, u16 npids)
@@ -801,115 +568,6 @@ fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
 	return sizeof(struct fc_rpsc_acc_s);
 }
 
-u16
-fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
-	       wwn_t port_name, wwn_t node_name, u16 pdu_size)
-{
-	struct fc_logi_s *pdisc = (struct fc_logi_s *) (fchs + 1);
-
-	memcpy(pdisc, &plogi_tmpl, sizeof(struct fc_logi_s));
-
-	pdisc->els_cmd.els_code = FC_ELS_PDISC;
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-
-	pdisc->csp.rxsz = pdisc->class3.rxsz = cpu_to_be16(pdu_size);
-	pdisc->port_name = port_name;
-	pdisc->node_name = node_name;
-
-	return sizeof(struct fc_logi_s);
-}
-
-u16
-fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
-{
-	struct fc_logi_s *pdisc = (struct fc_logi_s *) (fchs + 1);
-
-	if (len < sizeof(struct fc_logi_s))
-		return FC_PARSE_LEN_INVAL;
-
-	if (pdisc->els_cmd.els_code != FC_ELS_ACC)
-		return FC_PARSE_ACC_INVAL;
-
-	if (!wwn_is_equal(pdisc->port_name, port_name))
-		return FC_PARSE_PWWN_NOT_EQUAL;
-
-	if (!pdisc->class3.class_valid)
-		return FC_PARSE_NWWN_NOT_EQUAL;
-
-	if (be16_to_cpu(pdisc->class3.rxsz) < (FC_MIN_PDUSZ))
-		return FC_PARSE_RXSZ_INVAL;
-
-	return FC_PARSE_OK;
-}
-
-u16
-fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
-	      int num_pages)
-{
-	struct fc_prlo_s *prlo = (struct fc_prlo_s *) (fchs + 1);
-	int             page;
-
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-	memset(prlo, 0, (num_pages * 16) + 4);
-	prlo->command = FC_ELS_PRLO;
-	prlo->page_len = 0x10;
-	prlo->payload_len = cpu_to_be16((num_pages * 16) + 4);
-
-	for (page = 0; page < num_pages; page++) {
-		prlo->prlo_params[page].type = FC_TYPE_FCP;
-		prlo->prlo_params[page].opa_valid = 0;
-		prlo->prlo_params[page].rpa_valid = 0;
-		prlo->prlo_params[page].orig_process_assc = 0;
-		prlo->prlo_params[page].resp_process_assc = 0;
-	}
-
-	return be16_to_cpu(prlo->payload_len);
-}
-
-u16
-fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
-	       int num_pages, enum fc_tprlo_type tprlo_type, u32 tpr_id)
-{
-	struct fc_tprlo_s *tprlo = (struct fc_tprlo_s *) (fchs + 1);
-	int             page;
-
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-	memset(tprlo, 0, (num_pages * 16) + 4);
-	tprlo->command = FC_ELS_TPRLO;
-	tprlo->page_len = 0x10;
-	tprlo->payload_len = cpu_to_be16((num_pages * 16) + 4);
-
-	for (page = 0; page < num_pages; page++) {
-		tprlo->tprlo_params[page].type = FC_TYPE_FCP;
-		tprlo->tprlo_params[page].opa_valid = 0;
-		tprlo->tprlo_params[page].rpa_valid = 0;
-		tprlo->tprlo_params[page].orig_process_assc = 0;
-		tprlo->tprlo_params[page].resp_process_assc = 0;
-		if (tprlo_type == FC_GLOBAL_LOGO) {
-			tprlo->tprlo_params[page].global_process_logout = 1;
-		} else if (tprlo_type == FC_TPR_LOGO) {
-			tprlo->tprlo_params[page].tpo_nport_valid = 1;
-			tprlo->tprlo_params[page].tpo_nport_id = (tpr_id);
-		}
-	}
-
-	return be16_to_cpu(tprlo->payload_len);
-}
-
-u16
-fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id, __be16 ox_id,
-		u32 reason_code, u32 reason_expl)
-{
-	struct fc_ba_rjt_s *ba_rjt = (struct fc_ba_rjt_s *) (fchs + 1);
-
-	fc_bls_rsp_build(fchs, d_id, s_id, ox_id);
-
-	fchs->cat_info = FC_CAT_BA_RJT;
-	ba_rjt->reason_code = reason_code;
-	ba_rjt->reason_expl = reason_expl;
-	return sizeof(struct fc_ba_rjt_s);
-}
-
 static void
 fc_gs_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
 {
@@ -973,35 +631,6 @@ fc_gpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	return sizeof(fcgs_gpnid_req_t) + sizeof(struct ct_hdr_s);
 }
 
-u16
-fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
-	       u32 port_id)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	fcgs_gnnid_req_t *gnnid = (fcgs_gnnid_req_t *) (cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
-	fc_gs_cthdr_build(cthdr, s_id, GS_GNN_ID);
-
-	memset(gnnid, 0, sizeof(fcgs_gnnid_req_t));
-	gnnid->dap = port_id;
-	return sizeof(fcgs_gnnid_req_t) + sizeof(struct ct_hdr_s);
-}
-
-u16
-fc_ct_rsp_parse(struct ct_hdr_s *cthdr)
-{
-	if (be16_to_cpu(cthdr->cmd_rsp_code) != CT_RSP_ACCEPT) {
-		if (cthdr->reason_code == CT_RSN_LOGICAL_BUSY)
-			return FC_PARSE_BUSY;
-		else
-			return FC_PARSE_FAILURE;
-	}
-
-	return FC_PARSE_OK;
-}
-
 u16
 fc_gs_rjt_build(struct fchs_s *fchs,  struct ct_hdr_s *cthdr,
 		u32 d_id, u32 s_id, u16 ox_id, u8 reason_code,
@@ -1034,26 +663,6 @@ fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr,
 	return sizeof(struct fc_scr_s);
 }
 
-u16
-fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn,
-		u32 s_id, u16 ox_id)
-{
-	u32        d_id = bfa_hton3b(FC_FABRIC_CONTROLLER);
-	u16        payldlen;
-
-	fc_els_req_build(fchs, d_id, s_id, ox_id);
-	rscn->command = FC_ELS_RSCN;
-	rscn->pagelen = sizeof(rscn->event[0]);
-
-	payldlen = sizeof(u32) + rscn->pagelen;
-	rscn->payldlen = cpu_to_be16(payldlen);
-
-	rscn->event[0].format = FC_RSCN_FORMAT_PORTID;
-	rscn->event[0].portid = s_id;
-
-	return struct_size(rscn, event, 1);
-}
-
 u16
 fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	       enum bfa_lport_role roles)
@@ -1078,26 +687,6 @@ fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
 }
 
-u16
-fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
-		   u8 *fc4_bitmap, u32 bitmap_size)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rftid_req_s *rftid = (struct fcgs_rftid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
-	fc_gs_cthdr_build(cthdr, s_id, GS_RFT_ID);
-
-	memset(rftid, 0, sizeof(struct fcgs_rftid_req_s));
-
-	rftid->dap = s_id;
-	memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap,
-		(bitmap_size < 32 ? bitmap_size : 32));
-
-	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
-}
-
 u16
 fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	       u8 fc4_type, u8 fc4_ftrs)
@@ -1181,24 +770,6 @@ fc_gid_ft_build(struct fchs_s *fchs, void *pyld, u32 s_id, u8 fc4_type)
 	return sizeof(struct fcgs_gidft_req_s) + sizeof(struct ct_hdr_s);
 }
 
-u16
-fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
-	       wwn_t port_name)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rpnid_req_s *rpnid = (struct fcgs_rpnid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
-	fc_gs_cthdr_build(cthdr, s_id, GS_RPN_ID);
-
-	memset(rpnid, 0, sizeof(struct fcgs_rpnid_req_s));
-	rpnid->port_id = port_id;
-	rpnid->port_name = port_name;
-
-	return sizeof(struct fcgs_rpnid_req_s) + sizeof(struct ct_hdr_s);
-}
-
 u16
 fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	       wwn_t node_name)
@@ -1217,59 +788,6 @@ fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	return sizeof(struct fcgs_rnnid_req_s) + sizeof(struct ct_hdr_s);
 }
 
-u16
-fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
-	       u32 cos)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rcsid_req_s *rcsid =
-			(struct fcgs_rcsid_req_s *) (cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
-	fc_gs_cthdr_build(cthdr, s_id, GS_RCS_ID);
-
-	memset(rcsid, 0, sizeof(struct fcgs_rcsid_req_s));
-	rcsid->port_id = port_id;
-	rcsid->cos = cos;
-
-	return sizeof(struct fcgs_rcsid_req_s) + sizeof(struct ct_hdr_s);
-}
-
-u16
-fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
-	       u8 port_type)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_rptid_req_s *rptid = (struct fcgs_rptid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
-	fc_gs_cthdr_build(cthdr, s_id, GS_RPT_ID);
-
-	memset(rptid, 0, sizeof(struct fcgs_rptid_req_s));
-	rptid->port_id = port_id;
-	rptid->port_type = port_type;
-
-	return sizeof(struct fcgs_rptid_req_s) + sizeof(struct ct_hdr_s);
-}
-
-u16
-fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id)
-{
-	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	struct fcgs_ganxt_req_s *ganxt = (struct fcgs_ganxt_req_s *)(cthdr + 1);
-	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
-
-	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
-	fc_gs_cthdr_build(cthdr, s_id, GS_GA_NXT);
-
-	memset(ganxt, 0, sizeof(struct fcgs_ganxt_req_s));
-	ganxt->port_id = port_id;
-
-	return sizeof(struct ct_hdr_s) + sizeof(struct fcgs_ganxt_req_s);
-}
-
 /*
  * Builds fc hdr and ct hdr for FDMI requests.
  */
diff --git a/drivers/scsi/bfa/bfa_fcbuild.h b/drivers/scsi/bfa/bfa_fcbuild.h
index 49e0ee4a7334..51da37b2ae6b 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.h
+++ b/drivers/scsi/bfa/bfa_fcbuild.h
@@ -127,15 +127,6 @@ struct fc_templates_s {
 
 void            fcbuild_init(void);
 
-u16        fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
-			u32 s_id, u16 ox_id, wwn_t port_name, wwn_t node_name,
-			       u16 pdu_size, u8 set_npiv, u8 set_auth,
-			       u16 local_bb_credits);
-
-u16        fc_fdisc_build(struct fchs_s *buf, struct fc_logi_s *flogi, u32 s_id,
-			       u16 ox_id, wwn_t port_name, wwn_t node_name,
-			       u16 pdu_size);
-
 u16        fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
 				   u32 s_id, __be16 ox_id,
 				   wwn_t port_name, wwn_t node_name,
@@ -148,14 +139,6 @@ u16        fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id,
 
 enum fc_parse_status fc_plogi_parse(struct fchs_s *fchs);
 
-u16        fc_abts_build(struct fchs_s *buf, u32 d_id, u32 s_id,
-			      u16 ox_id);
-
-enum fc_parse_status fc_abts_rsp_parse(struct fchs_s *buf, int len);
-
-u16        fc_rrq_build(struct fchs_s *buf, struct fc_rrq_s *rrq, u32 d_id,
-			     u32 s_id, u16 ox_id, u16 rrq_oxid);
-
 u16        fc_rspnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
 				u16 ox_id, u8 *name);
 u16	fc_rsnn_nn_build(struct fchs_s *fchs, void *pld, u32 s_id,
@@ -164,10 +147,6 @@ u16	fc_rsnn_nn_build(struct fchs_s *fchs, void *pld, u32 s_id,
 u16        fc_rftid_build(struct fchs_s *fchs, void *pld, u32 s_id,
 			       u16 ox_id, enum bfa_lport_role role);
 
-u16       fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id,
-				   u16 ox_id, u8 *fc4_bitmap,
-				   u32 bitmap_size);
-
 u16	fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 			u16 ox_id, u8 fc4_type, u8 fc4_ftrs);
 
@@ -193,9 +172,6 @@ u16        fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
 			u32 d_id, u32 s_id, __be16 ox_id, wwn_t port_name,
 			       wwn_t node_name);
 
-enum fc_parse_status fc_adisc_parse(struct fchs_s *fchs, void *pld,
-			u32 host_dap, wwn_t node_name, wwn_t port_name);
-
 enum fc_parse_status fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len,
 				 wwn_t port_name, wwn_t node_name);
 
@@ -216,10 +192,6 @@ u16        fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
 				  u32 s_id, __be16 ox_id,
 				  enum bfa_lport_role role);
 
-u16        fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid,
-			      u32 d_id, u32 s_id, u16 ox_id,
-			      u32 data_format);
-
 u16        fc_rnid_acc_build(struct fchs_s *fchs,
 			struct fc_rnid_acc_s *rnid_acc, u32 d_id, u32 s_id,
 			__be16 ox_id, u32 data_format,
@@ -228,29 +200,15 @@ u16        fc_rnid_acc_build(struct fchs_s *fchs,
 
 u16	fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rps2c,
 			u32 d_id, u32 s_id, u32 *pid_list, u16 npids);
-u16        fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc,
-			      u32 d_id, u32 s_id, u16 ox_id);
 u16        fc_rpsc_acc_build(struct fchs_s *fchs,
 			struct fc_rpsc_acc_s *rpsc_acc, u32 d_id, u32 s_id,
 			__be16 ox_id, struct fc_rpsc_speed_info_s *oper_speed);
 u16        fc_gid_ft_build(struct fchs_s *fchs, void *pld, u32 s_id,
 				u8 fc4_type);
 
-u16        fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			       u32 port_id, wwn_t port_name);
-
 u16        fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 			       u32 port_id, wwn_t node_name);
 
-u16        fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			       u32 port_id, u32 cos);
-
-u16        fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			       u32 port_id, u8 port_type);
-
-u16        fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id,
-			       u32 port_id);
-
 u16        fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id,
 			      u32 s_id, u16 ox_id, wwn_t port_name);
 
@@ -267,46 +225,16 @@ void		fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask);
 void		fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
 					 __be16 ox_id);
 
-enum fc_parse_status	fc_plogi_rsp_parse(struct fchs_s *fchs, int len,
-					wwn_t port_name);
-
-enum fc_parse_status	fc_prli_parse(struct fc_prli_s *prli);
-
-enum fc_parse_status	fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name,
-					wwn_t port_name);
-
 u16 fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
 		u32 s_id, __be16 ox_id, u16 rx_id);
 
 int fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code);
 
-u16 fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
-		u32 d_id, u32 s_id, __be16 ox_id, int num_pages);
-
 u16 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
 		u32 d_id, u32 s_id, __be16 ox_id, int num_pages);
 
-u16 fc_pdisc_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		u16 ox_id, wwn_t port_name, wwn_t node_name,
-		u16 pdu_size);
-
-u16 fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name);
-
-u16 fc_prlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		u16 ox_id, int num_pages);
-
 u16 fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
 		u16 ox_id, int num_pages, enum fc_tprlo_type tprlo_type,
 		u32 tpr_id);
 
-u16 fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		__be16 ox_id, u32 reason_code, u32 reason_expl);
-
-u16 fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
-		u32 port_id);
-
-u16 fc_ct_rsp_parse(struct ct_hdr_s *cthdr);
-
-u16 fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn, u32 s_id,
-		u16 ox_id);
 #endif
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 49dd78ed8a9a..43dc1da4a156 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -242,7 +242,7 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
  * @phba: pointer to lpfc hba data structure.
  * @axchg: pointer to exchange context for the NVME LS request
  *
- * This routine is used for processing an asychronously received NVME LS
+ * This routine is used for processing an asynchronously received NVME LS
  * request. Any remaining validation is done and the LS is then forwarded
  * to the nvme-fc transport via nvme_fc_rcv_ls_req().
  *
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index e6c9112a8862..fba2e62027b7 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2142,7 +2142,7 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  * @axchg: pointer to exchange context for the NVME LS request
  *
- * This routine is used for processing an asychronously received NVME LS
+ * This routine is used for processing an asynchronously received NVME LS
  * request. Any remaining validation is done and the LS is then forwarded
  * to the nvmet-fc transport via nvmet_fc_rcv_ls_req().
  *
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8e75e2e279a4..50f1dcb6d584 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8907,8 +8907,11 @@ megasas_aen_polling(struct work_struct *work)
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
 						   (ld_target_id % MEGASAS_MAX_DEV_PER_CHANNEL),
 						   0);
-			if (sdev1)
+			if (sdev1) {
+				mutex_unlock(&instance->reset_mutex);
 				megasas_remove_scsi_device(sdev1);
+				mutex_lock(&instance->reset_mutex);
+			}
 
 			event_type = SCAN_VD_CHANNEL;
 			break;
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 81bb408ce56d..0c3e1ac076b5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -57,8 +57,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.12.0.0.50"
-#define MPI3MR_DRIVER_RELDATE	"05-Sept-2024"
+#define MPI3MR_DRIVER_VERSION	"8.12.0.3.50"
+#define MPI3MR_DRIVER_RELDATE	"11-November-2024"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
@@ -134,8 +134,6 @@ extern atomic64_t event_counter;
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
-#define MPI3MR_DEFAULT_CFG_PAGE_SZ		1024 /* in bytes */
-
 #define MPI3MR_RESET_TOPOLOGY_SETTLE_TIME	10
 
 #define MPI3MR_SCMD_TIMEOUT    (60 * HZ)
@@ -1133,9 +1131,6 @@ struct scmd_priv {
  * @io_throttle_low: I/O size to stop throttle in 512b blocks
  * @num_io_throttle_group: Maximum number of throttle groups
  * @throttle_groups: Pointer to throttle group info structures
- * @cfg_page: Default memory for configuration pages
- * @cfg_page_dma: Configuration page DMA address
- * @cfg_page_sz: Default configuration page memory size
  * @sas_transport_enabled: SAS transport enabled or not
  * @scsi_device_channel: Channel ID for SCSI devices
  * @transport_cmds: Command tracker for SAS transport commands
@@ -1332,10 +1327,6 @@ struct mpi3mr_ioc {
 	u16 num_io_throttle_group;
 	struct mpi3mr_throttle_group_info *throttle_groups;
 
-	void *cfg_page;
-	dma_addr_t cfg_page_dma;
-	u16 cfg_page_sz;
-
 	u8 sas_transport_enabled;
 	u8 scsi_device_channel;
 	struct mpi3mr_drv_cmd transport_cmds;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 01f035f9330e..10b8e4dc64f8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2329,6 +2329,15 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	if (!mrioc)
 		return -ENODEV;
 
+	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex))
+		return -ERESTARTSYS;
+
+	if (mrioc->bsg_cmds.state & MPI3MR_CMD_PENDING) {
+		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
+		return -EAGAIN;
+	}
+
 	if (!mrioc->ioctl_sges_allocated) {
 		dprint_bsg_err(mrioc, "%s: DMA memory was not allocated\n",
 			       __func__);
@@ -2339,13 +2348,16 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		karg->timeout = MPI3MR_APP_DEFAULT_TIMEOUT;
 
 	mpi_req = kzalloc(MPI3MR_ADMIN_REQ_FRAME_SZ, GFP_KERNEL);
-	if (!mpi_req)
+	if (!mpi_req) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		return -ENOMEM;
+	}
 	mpi_header = (struct mpi3_request_header *)mpi_req;
 
 	bufcnt = karg->buf_entry_list.num_of_entries;
 	drv_bufs = kzalloc((sizeof(*drv_bufs) * bufcnt), GFP_KERNEL);
 	if (!drv_bufs) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -ENOMEM;
 		goto out;
 	}
@@ -2353,6 +2365,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	dout_buf = kzalloc(job->request_payload.payload_len,
 				      GFP_KERNEL);
 	if (!dout_buf) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -ENOMEM;
 		goto out;
 	}
@@ -2360,6 +2373,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	din_buf = kzalloc(job->reply_payload.payload_len,
 				     GFP_KERNEL);
 	if (!din_buf) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -ENOMEM;
 		goto out;
 	}
@@ -2435,6 +2449,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 					(mpi_msg_size > MPI3MR_ADMIN_REQ_FRAME_SZ)) {
 				dprint_bsg_err(mrioc, "%s: invalid MPI message size\n",
 					__func__);
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
 				rval = -EINVAL;
 				goto out;
 			}
@@ -2447,6 +2462,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		if (invalid_be) {
 			dprint_bsg_err(mrioc, "%s: invalid buffer entries passed\n",
 				__func__);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
@@ -2454,12 +2470,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)) {
 			dprint_bsg_err(mrioc, "%s: data_out buffer length mismatch\n",
 				       __func__);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
 		if (sgl_din_iter > (din_buf + job->reply_payload.payload_len)) {
 			dprint_bsg_err(mrioc, "%s: data_in buffer length mismatch\n",
 				       __func__);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
@@ -2472,6 +2490,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc, "%s:%d: invalid data transfer size passed for function 0x%x din_size = %d, dout_size = %d\n",
 			       __func__, __LINE__, mpi_header->function, din_size,
 			       dout_size);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -EINVAL;
 		goto out;
 	}
@@ -2480,6 +2499,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s:%d: invalid data transfer size passed for function 0x%x din_size=%d\n",
 		    __func__, __LINE__, mpi_header->function, din_size);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -EINVAL;
 		goto out;
 	}
@@ -2487,6 +2507,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s:%d: invalid data transfer size passed for function 0x%x dout_size = %d\n",
 		    __func__, __LINE__, mpi_header->function, dout_size);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -EINVAL;
 		goto out;
 	}
@@ -2497,6 +2518,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 			dprint_bsg_err(mrioc, "%s:%d: invalid message size passed:%d:%d:%d:%d\n",
 				       __func__, __LINE__, din_cnt, dout_cnt, din_size,
 			    dout_size);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
@@ -2544,6 +2566,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				continue;
 			if (mpi3mr_map_data_buffer_dma(mrioc, drv_buf_iter, desc_count)) {
 				rval = -ENOMEM;
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
 				dprint_bsg_err(mrioc, "%s:%d: mapping data buffers failed\n",
 					       __func__, __LINE__);
 			goto out;
@@ -2556,20 +2579,11 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		sense_buff_k = kzalloc(erbsz, GFP_KERNEL);
 		if (!sense_buff_k) {
 			rval = -ENOMEM;
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			goto out;
 		}
 	}
 
-	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex)) {
-		rval = -ERESTARTSYS;
-		goto out;
-	}
-	if (mrioc->bsg_cmds.state & MPI3MR_CMD_PENDING) {
-		rval = -EAGAIN;
-		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
-		mutex_unlock(&mrioc->bsg_cmds.mutex);
-		goto out;
-	}
 	if (mrioc->unrecoverable) {
 		dprint_bsg_err(mrioc, "%s: unrecoverable controller\n",
 		    __func__);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f1ab76351bd8..5ed31fe57474 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1035,6 +1035,36 @@ static const char *mpi3mr_reset_type_name(u16 reset_type)
 	return name;
 }
 
+/**
+ * mpi3mr_is_fault_recoverable - Read fault code and decide
+ * whether the controller can be recoverable
+ * @mrioc: Adapter instance reference
+ * Return: true if fault is recoverable, false otherwise.
+ */
+static inline bool mpi3mr_is_fault_recoverable(struct mpi3mr_ioc *mrioc)
+{
+	u32 fault;
+
+	fault = (readl(&mrioc->sysif_regs->fault) &
+		      MPI3_SYSIF_FAULT_CODE_MASK);
+
+	switch (fault) {
+	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
+	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
+		ioc_warn(mrioc,
+		    "controller requires system power cycle, marking controller as unrecoverable\n");
+		return false;
+	case MPI3_SYSIF_FAULT_CODE_INSUFFICIENT_PCI_SLOT_POWER:
+		ioc_warn(mrioc,
+		    "controller faulted due to insufficient power,\n"
+		    " try by connecting it to a different slot\n");
+		return false;
+	default:
+		break;
+	}
+	return true;
+}
+
 /**
  * mpi3mr_print_fault_info - Display fault information
  * @mrioc: Adapter instance reference
@@ -1373,6 +1403,11 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	ioc_info(mrioc, "ioc_status(0x%08x), ioc_config(0x%08x), ioc_info(0x%016llx) at the bringup\n",
 	    ioc_status, ioc_config, base_info);
 
+	if (!mpi3mr_is_fault_recoverable(mrioc)) {
+		mrioc->unrecoverable = 1;
+		goto out_device_not_present;
+	}
+
 	/*The timeout value is in 2sec unit, changing it to seconds*/
 	mrioc->ready_timeout =
 	    ((base_info & MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK) >>
@@ -2734,6 +2769,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	mpi3mr_print_fault_info(mrioc);
 	mrioc->diagsave_timeout = 0;
 
+	if (!mpi3mr_is_fault_recoverable(mrioc)) {
+		mrioc->unrecoverable = 1;
+		goto schedule_work;
+	}
+
 	switch (trigger_data.fault) {
 	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
 	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
@@ -4186,17 +4226,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	mpi3mr_read_tsu_interval(mrioc);
 	mpi3mr_print_ioc_info(mrioc);
 
-	if (!mrioc->cfg_page) {
-		dprint_init(mrioc, "allocating config page buffers\n");
-		mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
-		mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
-		    mrioc->cfg_page_sz, &mrioc->cfg_page_dma, GFP_KERNEL);
-		if (!mrioc->cfg_page) {
-			retval = -1;
-			goto out_failed_noretry;
-		}
-	}
-
 	dprint_init(mrioc, "allocating host diag buffers\n");
 	mpi3mr_alloc_diag_bufs(mrioc);
 
@@ -4768,11 +4797,7 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		    mrioc->admin_req_base, mrioc->admin_req_dma);
 		mrioc->admin_req_base = NULL;
 	}
-	if (mrioc->cfg_page) {
-		dma_free_coherent(&mrioc->pdev->dev, mrioc->cfg_page_sz,
-		    mrioc->cfg_page, mrioc->cfg_page_dma);
-		mrioc->cfg_page = NULL;
-	}
+
 	if (mrioc->pel_seqnum_virt) {
 		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
 		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
@@ -5392,55 +5417,6 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
-
-/**
- * mpi3mr_free_config_dma_memory - free memory for config page
- * @mrioc: Adapter instance reference
- * @mem_desc: memory descriptor structure
- *
- * Check whether the size of the buffer specified by the memory
- * descriptor is greater than the default page size if so then
- * free the memory pointed by the descriptor.
- *
- * Return: Nothing.
- */
-static void mpi3mr_free_config_dma_memory(struct mpi3mr_ioc *mrioc,
-	struct dma_memory_desc *mem_desc)
-{
-	if ((mem_desc->size > mrioc->cfg_page_sz) && mem_desc->addr) {
-		dma_free_coherent(&mrioc->pdev->dev, mem_desc->size,
-		    mem_desc->addr, mem_desc->dma_addr);
-		mem_desc->addr = NULL;
-	}
-}
-
-/**
- * mpi3mr_alloc_config_dma_memory - Alloc memory for config page
- * @mrioc: Adapter instance reference
- * @mem_desc: Memory descriptor to hold dma memory info
- *
- * This function allocates new dmaable memory or provides the
- * default config page dmaable memory based on the memory size
- * described by the descriptor.
- *
- * Return: 0 on success, non-zero on failure.
- */
-static int mpi3mr_alloc_config_dma_memory(struct mpi3mr_ioc *mrioc,
-	struct dma_memory_desc *mem_desc)
-{
-	if (mem_desc->size > mrioc->cfg_page_sz) {
-		mem_desc->addr = dma_alloc_coherent(&mrioc->pdev->dev,
-		    mem_desc->size, &mem_desc->dma_addr, GFP_KERNEL);
-		if (!mem_desc->addr)
-			return -ENOMEM;
-	} else {
-		mem_desc->addr = mrioc->cfg_page;
-		mem_desc->dma_addr = mrioc->cfg_page_dma;
-		memset(mem_desc->addr, 0, mrioc->cfg_page_sz);
-	}
-	return 0;
-}
-
 /**
  * mpi3mr_post_cfg_req - Issue config requests and wait
  * @mrioc: Adapter instance reference
@@ -5596,8 +5572,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
 		cfg_req->page_length = cfg_hdr->page_length;
 		cfg_req->page_version = cfg_hdr->page_version;
 	}
-	if (mpi3mr_alloc_config_dma_memory(mrioc, &mem_desc))
-		goto out;
+
+	mem_desc.addr = dma_alloc_coherent(&mrioc->pdev->dev,
+		mem_desc.size, &mem_desc.dma_addr, GFP_KERNEL);
+
+	if (!mem_desc.addr)
+		return retval;
 
 	mpi3mr_add_sg_single(&cfg_req->sgl, sgl_flags, mem_desc.size,
 	    mem_desc.dma_addr);
@@ -5626,7 +5606,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
 	}
 
 out:
-	mpi3mr_free_config_dma_memory(mrioc, &mem_desc);
+	if (mem_desc.addr) {
+		dma_free_coherent(&mrioc->pdev->dev, mem_desc.size,
+			mem_desc.addr, mem_desc.dma_addr);
+		mem_desc.addr = NULL;
+	}
+
 	return retval;
 }
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5f2f67acf8bf..1bef88130d0c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5215,7 +5215,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc = shost_priv(shost);
-	retval = ida_alloc_range(&mrioc_ida, 1, U8_MAX, GFP_KERNEL);
+	retval = ida_alloc_range(&mrioc_ida, 0, U8_MAX, GFP_KERNEL);
 	if (retval < 0)
 		goto id_alloc_failed;
 	mrioc->id = (u8)retval;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ed5046593fda..16ac2267c71e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7041,11 +7041,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	int i;
 	u8 failed;
 	__le32 *mfp;
+	int ret_val;
 
 	/* make sure doorbell is not in use */
 	if ((ioc->base_readl_ext_retry(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
 		ioc_err(ioc, "doorbell is in use (line=%d)\n", __LINE__);
-		return -EFAULT;
+		goto doorbell_diag_reset;
 	}
 
 	/* clear pending doorbell interrupts from previous state changes */
@@ -7135,6 +7136,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 			    le32_to_cpu(mfp[i]));
 	}
 	return 0;
+
+doorbell_diag_reset:
+	ret_val = _base_diag_reset(ioc);
+	return ret_val;
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index eceb5eeb4651..d8d1a64b4764 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -77,11 +77,11 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"48.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		48
+#define MPT3SAS_DRIVER_VERSION		"51.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		51
 #define MPT3SAS_MINOR_VERSION		100
-#define MPT3SAS_BUILD_VERSION		0
-#define MPT3SAS_RELEASE_VERSION	00
+#define MPT3SAS_BUILD_VERSION		00
+#define MPT3SAS_RELEASE_VERSION		00
 
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
diff --git a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
index d309e2ca14de..dea2290b37d4 100644
--- a/drivers/scsi/qla1280.h
+++ b/drivers/scsi/qla1280.h
@@ -116,12 +116,12 @@ struct device_reg {
 	uint16_t id_h;		/* ID high */
 	uint16_t cfg_0;		/* Configuration 0 */
 #define ISP_CFG0_HWMSK   0x000f	/* Hardware revision mask */
-#define ISP_CFG0_1020    BIT_0	/* ISP1020 */
-#define ISP_CFG0_1020A	 BIT_1	/* ISP1020A */
-#define ISP_CFG0_1040	 BIT_2	/* ISP1040 */
-#define ISP_CFG0_1040A	 BIT_3	/* ISP1040A */
-#define ISP_CFG0_1040B	 BIT_4	/* ISP1040B */
-#define ISP_CFG0_1040C	 BIT_5	/* ISP1040C */
+#define ISP_CFG0_1020	 1	/* ISP1020 */
+#define ISP_CFG0_1020A	 2	/* ISP1020A */
+#define ISP_CFG0_1040	 3	/* ISP1040 */
+#define ISP_CFG0_1040A	 4	/* ISP1040A */
+#define ISP_CFG0_1040B	 5	/* ISP1040B */
+#define ISP_CFG0_1040C	 6	/* ISP1040C */
 	uint16_t cfg_1;		/* Configuration 1 */
 #define ISP_CFG1_F128    BIT_6  /* 128-byte FIFO threshold */
 #define ISP_CFG1_F64     BIT_4|BIT_5 /* 128-byte FIFO threshold */
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2810608acd96..e6ece30c4348 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3304,6 +3304,7 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
+	.show_host_supported_speeds = 1,
 
 	.get_host_port_id = qla2x00_get_host_port_id,
 	.show_host_port_id = 1,
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 52dc9604f567..10431a67d202 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -24,6 +24,7 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
 {
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct completion *comp = sp->comp;
 
 	ql_dbg(ql_dbg_user, sp->vha, 0x7009,
 	    "%s: sp hdl %x, result=%x bsg ptr %p\n",
@@ -35,6 +36,9 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
 	bsg_reply->result = res;
 	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
+
+	if (comp)
+		complete(comp);
 }
 
 void qla2x00_bsg_sp_free(srb_t *sp)
@@ -490,16 +494,6 @@ qla2x00_process_ct(struct bsg_job *bsg_job)
 		goto done;
 	}
 
-	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
-	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
-		ql_log(ql_log_warn, vha, 0x7011,
-		    "request_sg_cnt: %x dma_request_sg_cnt: %x reply_sg_cnt:%x "
-		    "dma_reply_sg_cnt: %x\n", bsg_job->request_payload.sg_cnt,
-		    req_sg_cnt, bsg_job->reply_payload.sg_cnt, rsp_sg_cnt);
-		rval = -EAGAIN;
-		goto done_unmap_sg;
-	}
-
 	if (!vha->flags.online) {
 		ql_log(ql_log_warn, vha, 0x7012,
 		    "Host is not online.\n");
@@ -3061,7 +3055,7 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 
 static bool qla_bsg_found(struct qla_qpair *qpair, struct bsg_job *bsg_job)
 {
-	bool found = false;
+	bool found, do_bsg_done;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
 	struct qla_hw_data *ha = vha->hw;
@@ -3069,6 +3063,11 @@ static bool qla_bsg_found(struct qla_qpair *qpair, struct bsg_job *bsg_job)
 	int cnt;
 	unsigned long flags;
 	struct req_que *req;
+	int rval;
+	DECLARE_COMPLETION_ONSTACK(comp);
+	uint32_t ratov_j;
+
+	found = do_bsg_done = false;
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	req = qpair->req;
@@ -3080,42 +3079,104 @@ static bool qla_bsg_found(struct qla_qpair *qpair, struct bsg_job *bsg_job)
 		     sp->type == SRB_ELS_CMD_HST ||
 		     sp->type == SRB_ELS_CMD_HST_NOLOGIN) &&
 		    sp->u.bsg_job == bsg_job) {
-			req->outstanding_cmds[cnt] = NULL;
-			spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-
-			if (!ha->flags.eeh_busy && ha->isp_ops->abort_command(sp)) {
-				ql_log(ql_log_warn, vha, 0x7089,
-						"mbx abort_command failed.\n");
-				bsg_reply->result = -EIO;
-			} else {
-				ql_dbg(ql_dbg_user, vha, 0x708a,
-						"mbx abort_command success.\n");
-				bsg_reply->result = 0;
-			}
-			/* ref: INIT */
-			kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 			found = true;
-			goto done;
+			sp->comp = &comp;
+			break;
 		}
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-done:
-	return found;
+	if (!found)
+		return false;
+
+	if (ha->flags.eeh_busy) {
+		/* skip over abort.  EEH handling will return the bsg. Wait for it */
+		rval = QLA_SUCCESS;
+		ql_dbg(ql_dbg_user, vha, 0x802c,
+			"eeh encounter. bsg %p sp=%p handle=%x \n",
+			bsg_job, sp, sp->handle);
+	} else {
+		rval = ha->isp_ops->abort_command(sp);
+		ql_dbg(ql_dbg_user, vha, 0x802c,
+			"Aborting bsg %p sp=%p handle=%x rval=%x\n",
+			bsg_job, sp, sp->handle, rval);
+	}
+
+	switch (rval) {
+	case QLA_SUCCESS:
+		/* Wait for the command completion. */
+		ratov_j = ha->r_a_tov / 10 * 4 * 1000;
+		ratov_j = msecs_to_jiffies(ratov_j);
+
+		if (!wait_for_completion_timeout(&comp, ratov_j)) {
+			ql_log(ql_log_info, vha, 0x7089,
+				"bsg abort timeout.  bsg=%p sp=%p handle %#x .\n",
+				bsg_job, sp, sp->handle);
+
+			do_bsg_done = true;
+		} else {
+			/* fw had returned the bsg */
+			ql_dbg(ql_dbg_user, vha, 0x708a,
+				"bsg abort success. bsg %p sp=%p handle=%#x\n",
+				bsg_job, sp, sp->handle);
+			do_bsg_done = false;
+		}
+		break;
+	default:
+		ql_log(ql_log_info, vha, 0x704f,
+			"bsg abort fail.  bsg=%p sp=%p rval=%x.\n",
+			bsg_job, sp, rval);
+
+		do_bsg_done = true;
+		break;
+	}
+
+	if (!do_bsg_done)
+		return true;
+
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+	/*
+	 * recheck to make sure it's still the same bsg_job due to
+	 * qp_lock_ptr was released earlier.
+	 */
+	if (req->outstanding_cmds[cnt] &&
+	    req->outstanding_cmds[cnt]->u.bsg_job != bsg_job) {
+		/* fw had returned the bsg */
+		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+		return true;
+	}
+	req->outstanding_cmds[cnt] = NULL;
+	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+	/* ref: INIT */
+	sp->comp = NULL;
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	bsg_reply->result = -ENXIO;
+	bsg_reply->reply_payload_rcv_len = 0;
+
+	ql_dbg(ql_dbg_user, vha, 0x7051,
+	       "%s bsg_job_done : bsg %p result %#x sp %p.\n",
+	       __func__, bsg_job, bsg_reply->result, sp);
+
+	bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
+
+	return true;
 }
 
 int
 qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 {
-	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct fc_bsg_request *bsg_request = bsg_job->request;
 	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
 	struct qla_hw_data *ha = vha->hw;
 	int i;
 	struct qla_qpair *qpair;
 
-	ql_log(ql_log_info, vha, 0x708b, "%s CMD timeout. bsg ptr %p.\n",
-	    __func__, bsg_job);
+	ql_log(ql_log_info, vha, 0x708b,
+	       "%s CMD timeout. bsg ptr %p msgcode %x vendor cmd %x\n",
+	       __func__, bsg_job, bsg_request->msgcode,
+	       bsg_request->rqst_data.h_vendor.vendor_cmd[0]);
 
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x9007,
@@ -3136,7 +3197,6 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 	}
 
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
-	bsg_reply->result = -ENXIO;
 
 done:
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 76703f2706b8..79879c4743e6 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -506,6 +506,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 		return(NULL);
 	}
 
+	vha->irq_offset = QLA_BASE_VECTORS;
 	host = vha->host;
 	fc_vport->dd_data = vha;
 	/* New host info */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7f980e6141c2..7ab717ed7232 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6902,12 +6902,15 @@ qla2x00_do_dpc(void *data)
 	set_user_nice(current, MIN_NICE);
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
+	while (1) {
 		ql_dbg(ql_dbg_dpc, base_vha, 0x4000,
 		    "DPC handler sleeping.\n");
 
 		schedule();
 
+		if (kthread_should_stop())
+			break;
+
 		if (test_and_clear_bit(DO_EEH_RECOVERY, &base_vha->dpc_flags))
 			qla_pci_set_eeh_busy(base_vha);
 
@@ -6920,15 +6923,16 @@ qla2x00_do_dpc(void *data)
 			goto end_loop;
 		}
 
+		if (test_bit(UNLOADING, &base_vha->dpc_flags))
+			/* don't do any work. Wait to be terminated by kthread_stop */
+			goto end_loop;
+
 		ha->dpc_active = 1;
 
 		ql_dbg(ql_dbg_dpc + ql_dbg_verbose, base_vha, 0x4001,
 		    "DPC handler waking up, dpc_flags=0x%lx.\n",
 		    base_vha->dpc_flags);
 
-		if (test_bit(UNLOADING, &base_vha->dpc_flags))
-			break;
-
 		if (IS_P3P_TYPE(ha)) {
 			if (IS_QLA8044(ha)) {
 				if (test_and_clear_bit(ISP_UNRECOVERABLE,
@@ -7241,9 +7245,6 @@ qla2x00_do_dpc(void *data)
 	 */
 	ha->dpc_active = 0;
 
-	/* Cleanup any residual CTX SRBs. */
-	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
-
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index cf0f9d9db645..a491d6ee5c94 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.09.300-k"
+#define QLA2XXX_VERSION      "10.02.09.400-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	9
-#define QLA_DRIVER_BETA_VER	300
+#define QLA_DRIVER_BETA_VER	400
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b52513eeeafa..680ba180a672 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6447,7 +6447,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	}
 	sd_dp = &sqcp->sd_dp;
 
-	if (polled)
+	if (polled || (ndelay > 0 && ndelay < INCLUSIVE_TIMING_MAX_NS))
 		ns_from_boot = ktime_get_boottime_ns();
 
 	/* one of the resp_*() response functions is called here */
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 84334ab39c81..94127868bedf 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -386,7 +386,6 @@ sg_release(struct inode *inode, struct file *filp)
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp, "sg_release\n"));
 
 	mutex_lock(&sdp->open_rel_lock);
-	kref_put(&sfp->f_ref, sg_remove_sfp);
 	sdp->open_cnt--;
 
 	/* possibly many open()s waiting on exlude clearing, start many;
@@ -398,6 +397,7 @@ sg_release(struct inode *inode, struct file *filp)
 		wake_up_interruptible(&sdp->open_wait);
 	}
 	mutex_unlock(&sdp->open_rel_lock);
+	kref_put(&sfp->f_ref, sg_remove_sfp);
 	return 0;
 }
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 7ceb982040a5..d0b55c1fa908 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -149,6 +149,8 @@ struct hv_fc_wwn_packet {
 */
 static int vmstor_proto_version;
 
+static bool hv_dev_is_fc(struct hv_device *hv_dev);
+
 #define STORVSC_LOGGING_NONE	0
 #define STORVSC_LOGGING_ERROR	1
 #define STORVSC_LOGGING_WARN	2
@@ -1138,6 +1140,7 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	 * not correctly handle:
 	 * INQUIRY command with page code parameter set to 0x80
 	 * MODE_SENSE command with cmd[2] == 0x1c
+	 * MAINTENANCE_IN is not supported by HyperV FC passthrough
 	 *
 	 * Setup srb and scsi status so this won't be fatal.
 	 * We do this so we can distinguish truly fatal failues
@@ -1145,7 +1148,9 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	 */
 
 	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
-	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
+	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE) ||
+	   (stor_pkt->vm_srb.cdb[0] == MAINTENANCE_IN &&
+	   hv_dev_is_fc(device))) {
 		vstor_packet->vm_srb.scsi_status = 0;
 		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
 	}
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 717931267bda..0f5d820af119 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -361,7 +361,7 @@ static const struct genl_multicast_group tcmu_mcgrps[] = {
 	[TCMU_MCGRP_CONFIG] = { .name = "config", },
 };
 
-static struct nla_policy tcmu_attr_policy[TCMU_ATTR_MAX+1] = {
+static const struct nla_policy tcmu_attr_policy[TCMU_ATTR_MAX + 1] = {
 	[TCMU_ATTR_DEVICE]	= { .type = NLA_STRING },
 	[TCMU_ATTR_MINOR]	= { .type = NLA_U32 },
 	[TCMU_ATTR_CMD_STATUS]	= { .type = NLA_S32 },
@@ -2430,7 +2430,7 @@ enum {
 	Opt_cmd_ring_size_mb, Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_dev_config, "dev_config=%s"},
 	{Opt_dev_size, "dev_size=%s"},
 	{Opt_hw_block_size, "hw_block_size=%d"},
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 265f21133b63..796e37a1d859 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -670,6 +670,9 @@ static ssize_t read_req_latency_avg_show(struct device *dev,
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[READ])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[READ]),
 						 m->nr_req[READ]));
 }
@@ -737,6 +740,9 @@ static ssize_t write_req_latency_avg_show(struct device *dev,
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[WRITE])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[WRITE]),
 						 m->nr_req[WRITE]));
 }
diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 433d0480391e..6c09d97ae006 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -170,7 +170,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	case UPIU_TRANSACTION_UIC_CMD:
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
-		ret = ufshcd_send_uic_cmd(hba, &uc);
+		ret = ufshcd_send_bsg_uic_cmd(hba, &uc);
 		if (ret)
 			dev_err(hba->dev, "send uic cmd: error code %d\n", ret);
 
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 7aea8fbaeee8..9ffd94ddf8c7 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -84,6 +84,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
+int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     struct utp_upiu_req *req_upiu,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6a2685333076..b7ec5797d5ba 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4319,6 +4319,42 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	return ret;
 }
 
+/**
+ * ufshcd_send_bsg_uic_cmd - Send UIC commands requested via BSG layer and retrieve the result
+ * @hba: per adapter instance
+ * @uic_cmd: UIC command
+ *
+ * Return: 0 only if success.
+ */
+int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
+{
+	int ret;
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
+	ufshcd_hold(hba);
+
+	if (uic_cmd->argument1 == UIC_ARG_MIB(PA_PWRMODE) &&
+	    uic_cmd->command == UIC_CMD_DME_SET) {
+		ret = ufshcd_uic_pwr_ctrl(hba, uic_cmd);
+		goto out;
+	}
+
+	mutex_lock(&hba->uic_cmd_mutex);
+	ufshcd_add_delay_before_dme_cmd(hba);
+
+	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
+	if (!ret)
+		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
+
+	mutex_unlock(&hba->uic_cmd_mutex);
+
+out:
+	ufshcd_release(hba);
+	return ret;
+}
+
 /**
  * ufshcd_uic_change_pwr_mode - Perform the UIC power mode chage
  *				using DME_SET primitives.
@@ -4635,9 +4671,6 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 		dev_err(hba->dev,
 			"%s: power mode change failed %d\n", __func__, ret);
 	} else {
-		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
-								pwr_mode);
-
 		memcpy(&hba->pwr_info, pwr_mode,
 			sizeof(struct ufs_pa_layer_attr));
 	}
@@ -4666,6 +4699,10 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 
 	ret = ufshcd_change_power_mode(hba, &final_params);
 
+	if (!ret)
+		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
+					&final_params);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
@@ -10195,6 +10232,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufs_hwmon_remove(hba);
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
+	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index 66811d8d1929..e793e3538c48 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -307,9 +307,7 @@ static int cdns_ufs_pltfrm_probe(struct platform_device *pdev)
  */
 static void cdns_ufs_pltfrm_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
@@ -321,7 +319,7 @@ static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
 
 static struct platform_driver cdns_ufs_pltfrm_driver = {
 	.probe	= cdns_ufs_pltfrm_probe,
-	.remove_new = cdns_ufs_pltfrm_remove,
+	.remove = cdns_ufs_pltfrm_remove,
 	.driver	= {
 		.name   = "cdns-ufshcd",
 		.pm     = &cdns_ufs_dev_pm_ops,
diff --git a/drivers/ufs/host/tc-dwc-g210-pltfrm.c b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
index a3877592604d..454ac88c357d 100644
--- a/drivers/ufs/host/tc-dwc-g210-pltfrm.c
+++ b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
@@ -76,10 +76,7 @@ static int tc_dwc_g210_pltfm_probe(struct platform_device *pdev)
  */
 static void tc_dwc_g210_pltfm_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
-	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
@@ -89,7 +86,7 @@ static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
 
 static struct platform_driver tc_dwc_g210_pltfm_driver = {
 	.probe		= tc_dwc_g210_pltfm_probe,
-	.remove_new	= tc_dwc_g210_pltfm_remove,
+	.remove		= tc_dwc_g210_pltfm_remove,
 	.driver		= {
 		.name	= "tc-dwc-g210-pltfm",
 		.pm	= &tc_dwc_g210_pltfm_pm_ops,
diff --git a/drivers/ufs/host/ti-j721e-ufs.c b/drivers/ufs/host/ti-j721e-ufs.c
index 250c22df000d..21214e5d5896 100644
--- a/drivers/ufs/host/ti-j721e-ufs.c
+++ b/drivers/ufs/host/ti-j721e-ufs.c
@@ -83,7 +83,7 @@ MODULE_DEVICE_TABLE(of, ti_j721e_ufs_of_match);
 
 static struct platform_driver ti_j721e_ufs_driver = {
 	.probe	= ti_j721e_ufs_probe,
-	.remove_new = ti_j721e_ufs_remove,
+	.remove = ti_j721e_ufs_remove,
 	.driver	= {
 		.name   = "ti-j721e-ufs",
 		.of_match_table = ti_j721e_ufs_of_match,
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 6548f7a8562f..13dd5dfc03eb 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1992,8 +1992,7 @@ static void exynos_ufs_remove(struct platform_device *pdev)
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 
-	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 
 	phy_power_off(ufs->phy);
 	phy_exit(ufs->phy);
@@ -2166,7 +2165,7 @@ static const struct dev_pm_ops exynos_ufs_pm_ops = {
 
 static struct platform_driver exynos_ufs_pltform = {
 	.probe	= exynos_ufs_probe,
-	.remove_new = exynos_ufs_remove,
+	.remove = exynos_ufs_remove,
 	.driver	= {
 		.name	= "exynos-ufshc",
 		.pm	= &exynos_ufs_pm_ops,
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 5ee73ff05251..6e6569de74d8 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -576,9 +576,7 @@ static int ufs_hisi_probe(struct platform_device *pdev)
 
 static void ufs_hisi_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static const struct dev_pm_ops ufs_hisi_pm_ops = {
@@ -590,7 +588,7 @@ static const struct dev_pm_ops ufs_hisi_pm_ops = {
 
 static struct platform_driver ufs_hisi_pltform = {
 	.probe	= ufs_hisi_probe,
-	.remove_new = ufs_hisi_remove,
+	.remove = ufs_hisi_remove,
 	.driver	= {
 		.name	= "ufshcd-hisi",
 		.pm	= &ufs_hisi_pm_ops,
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 06ab1e5e8b6f..135cd78109e2 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1879,10 +1879,7 @@ static int ufs_mtk_probe(struct platform_device *pdev)
  */
 static void ufs_mtk_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
-	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1962,7 +1959,7 @@ static const struct dev_pm_ops ufs_mtk_pm_ops = {
 
 static struct platform_driver ufs_mtk_pltform = {
 	.probe      = ufs_mtk_probe,
-	.remove_new = ufs_mtk_remove,
+	.remove = ufs_mtk_remove,
 	.driver = {
 		.name   = "ufshcd-mtk",
 		.pm     = &ufs_mtk_pm_ops,
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 3b592492e152..68040b2ab5f8 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1861,10 +1861,11 @@ static int ufs_qcom_probe(struct platform_device *pdev)
 static void ufs_qcom_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
-	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
-	platform_device_msi_free_irqs_all(hba->dev);
+	ufshcd_pltfrm_remove(pdev);
+	if (host->esi_enabled)
+		platform_device_msi_free_irqs_all(hba->dev);
 }
 
 static const struct of_device_id ufs_qcom_of_match[] __maybe_unused = {
@@ -1897,7 +1898,7 @@ static const struct dev_pm_ops ufs_qcom_pm_ops = {
 
 static struct platform_driver ufs_qcom_pltform = {
 	.probe	= ufs_qcom_probe,
-	.remove_new = ufs_qcom_remove,
+	.remove = ufs_qcom_remove,
 	.driver	= {
 		.name	= "ufshcd-qcom",
 		.pm	= &ufs_qcom_pm_ops,
diff --git a/drivers/ufs/host/ufs-renesas.c b/drivers/ufs/host/ufs-renesas.c
index 3ff97112e1f6..03cd82db751b 100644
--- a/drivers/ufs/host/ufs-renesas.c
+++ b/drivers/ufs/host/ufs-renesas.c
@@ -397,14 +397,12 @@ static int ufs_renesas_probe(struct platform_device *pdev)
 
 static void ufs_renesas_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba = platform_get_drvdata(pdev);
-
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static struct platform_driver ufs_renesas_platform = {
 	.probe	= ufs_renesas_probe,
-	.remove_new = ufs_renesas_remove,
+	.remove = ufs_renesas_remove,
 	.driver	= {
 		.name	= "ufshcd-renesas",
 		.of_match_table	= of_match_ptr(ufs_renesas_of_match),
diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index d8b165908809..b1d532363f9d 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -427,10 +427,7 @@ static int ufs_sprd_probe(struct platform_device *pdev)
 
 static void ufs_sprd_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =  platform_get_drvdata(pdev);
-
-	pm_runtime_get_sync(&(pdev)->dev);
-	ufshcd_remove(hba);
+	ufshcd_pltfrm_remove(pdev);
 }
 
 static const struct dev_pm_ops ufs_sprd_pm_ops = {
@@ -442,7 +439,7 @@ static const struct dev_pm_ops ufs_sprd_pm_ops = {
 
 static struct platform_driver ufs_sprd_pltform = {
 	.probe = ufs_sprd_probe,
-	.remove_new = ufs_sprd_remove,
+	.remove = ufs_sprd_remove,
 	.driver = {
 		.name = "ufshcd-sprd",
 		.pm = &ufs_sprd_pm_ops,
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 1f4f30d6cb42..505572d4fa87 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -524,6 +524,22 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 }
 EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
 
+/**
+ * ufshcd_pltfrm_remove - Remove ufshcd platform
+ * @pdev: pointer to Platform device handle
+ */
+void ufshcd_pltfrm_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&pdev->dev);
+	ufshcd_remove(hba);
+	ufshcd_dealloc_host(hba);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+}
+EXPORT_SYMBOL_GPL(ufshcd_pltfrm_remove);
+
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
diff --git a/drivers/ufs/host/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
index df387be5216b..3017f8e8f93c 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.h
+++ b/drivers/ufs/host/ufshcd-pltfrm.h
@@ -31,6 +31,7 @@ int ufshcd_negotiate_pwr_params(const struct ufs_host_params *host_params,
 void ufshcd_init_host_params(struct ufs_host_params *host_params);
 int ufshcd_pltfrm_init(struct platform_device *pdev,
 		       const struct ufs_hba_variant_ops *vops);
+void ufshcd_pltfrm_remove(struct platform_device *pdev);
 int ufshcd_populate_vreg(struct device *dev, const char *name,
 			 struct ufs_vreg **out_vreg, bool skip_current);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d7aca9e61684..d650ae6b58d3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -310,7 +310,9 @@ struct ufs_pwr_mode_info {
  *                       to allow variant specific Uni-Pro initialization.
  * @pwr_change_notify: called before and after a power mode change
  *			is carried out to allow vendor spesific capabilities
- *			to be set.
+ *			to be set. PRE_CHANGE can modify final_params based
+ *			on desired_pwr_mode, but POST_CHANGE must not alter
+ *			the final_params parameter
  * @setup_xfer_req: called before any transfer request is issued
  *                  to set some things
  * @setup_task_mgmt: called before any task management request is issued
@@ -353,9 +355,9 @@ struct ufs_hba_variant_ops {
 	int	(*link_startup_notify)(struct ufs_hba *,
 				       enum ufs_notify_change_status);
 	int	(*pwr_change_notify)(struct ufs_hba *,
-					enum ufs_notify_change_status status,
-					struct ufs_pa_layer_attr *,
-					struct ufs_pa_layer_attr *);
+				enum ufs_notify_change_status status,
+				struct ufs_pa_layer_attr *desired_pwr_mode,
+				struct ufs_pa_layer_attr *final_params);
 	void	(*setup_xfer_req)(struct ufs_hba *hba, int tag,
 				  bool is_scsi_cmd);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);

