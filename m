Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC963590B3
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 18:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725631; cv=none; b=Bft8H6OQZpQbiTsWzmy7ZnmfT+dA/15i8CadgZ6LXxgNdFLakpA96iPZ1bdlBp4e3Kn4Cdz3R0nw6VeZmyTR9MNOqHLZpJpZzG7SR94HjI6ksrGzvItggTYWUi3pHFJeojtF6SNQq4KSRWQJq4idngU2FcZD54Cmqi4GGyGy58U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725631; c=relaxed/simple;
	bh=oHnTf2gbbRK0BbgSGcyeVe1HaRzrOpmyHfSVdqjz63Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t+56iDyo1Sja76dWRpEO7aAljRNdW9ylPaAvLKD2M1M70caKsfpb8AudAk4lVYFjYLSTSCr8REhXjQZ7f7xWcEvM5Hqur9lQw++wKcDmFd2iaoxz2bCYzgbw3W1mNvavwcpcRMB7rxHSO7B2BOHLXmphUSb6dlBdP4mHkd9ME9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UHYiyr/O; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UHYiyr/O"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dm0gY4G9dzm04kt;
	Tue,  6 Jan 2026 18:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1767725620; x=1770317621; bh=uduxVEnsMwSPyYgr7jdM7zCT4q21NogavP5
	G9ULP+8A=; b=UHYiyr/OF2RzzUgbOmgtGrwNmxxC681nh1afbJ1b68NVpS9/M0C
	+kPdQoAX40SiLS8tlQLOXdbq0hBc7vNWuYIuZAc8Ujhhxkd9lhHQTBR8u7bT4r45
	ve5CPrJJiVj0Ji2EBsmsPCvDbeopldS+mXXcfilbZeewkU5rNAm5eP2+xFhE2sFd
	t7uc+8YCzHn1SBsjif2opWst7vrkr6A+onbl5wJltQ+aNQ8S0/HT0R/fjNVlI75o
	a+ctZYPJZRZINGAE3V88n+R8CeurjkLiI9Cy7d7HAcKh7F6kCFRnhFJUMr8AZQJX
	n4YjU7JS7nU3fh+llmVGzdWupaaUFHVKCbg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HheMhwEWiTHS; Tue,  6 Jan 2026 18:53:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dm0g648NdzlwmHm;
	Tue,  6 Jan 2026 18:53:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Nihar Panda <niharp@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Khalid Aziz <khalid@gonehiking.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Russell King <linux@armlinux.org.uk>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Don Brace <don.brace@microchip.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Brian King <brking@us.ibm.com>,
	Hannes Reinecke <hare@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	GOTO Masanori <gotom@debian.or.jp>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oliver Neukum <oliver@neukum.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Easwar Hariharan <easwar.hariharan@linux.microsoft.com>,
	Allen Pais <apais@linux.microsoft.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH] scsi: Change the return type of the .queuecommand() callback
Date: Tue,  6 Jan 2026 11:52:47 -0700
Message-ID: <20260106185310.2524290-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let the compiler verify whether a valid value is returned by the
.queuecommand() implementations by changing their return type from 'int'
into 'enum scsi_qc_status'. No functionality has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_mid_low_api.rst   |  3 ++-
 drivers/ata/libata-scsi.c                 |  8 +++++---
 drivers/ata/libata.h                      |  3 ++-
 drivers/firewire/sbp2.c                   |  7 ++++---
 drivers/infiniband/ulp/srp/ib_srp.c       |  3 ++-
 drivers/message/fusion/mptfc.c            |  7 ++++---
 drivers/message/fusion/mptsas.c           |  4 ++--
 drivers/message/fusion/mptscsih.c         |  3 +--
 drivers/message/fusion/mptscsih.h         |  2 +-
 drivers/message/fusion/mptspi.c           |  4 ++--
 drivers/s390/scsi/zfcp_scsi.c             |  4 ++--
 drivers/scsi/53c700.c                     |  4 ++--
 drivers/scsi/BusLogic.h                   |  2 +-
 drivers/scsi/NCR5380.c                    |  4 ++--
 drivers/scsi/aacraid/linit.c              |  4 ++--
 drivers/scsi/aha1542.c                    |  3 ++-
 drivers/scsi/arcmsr/arcmsr_hba.c          |  3 ++-
 drivers/scsi/arm/fas216.h                 | 10 ++++++----
 drivers/scsi/bfa/bfad_im.c                |  3 ++-
 drivers/scsi/bnx2fc/bnx2fc.h              |  3 ++-
 drivers/scsi/bnx2fc/bnx2fc_io.c           |  4 ++--
 drivers/scsi/csiostor/csio_scsi.c         |  4 ++--
 drivers/scsi/esas2r/esas2r.h              |  3 ++-
 drivers/scsi/esas2r/esas2r_main.c         |  3 ++-
 drivers/scsi/fdomain.c                    |  3 ++-
 drivers/scsi/fnic/fnic.h                  |  2 +-
 drivers/scsi/fnic/fnic_scsi.c             |  3 ++-
 drivers/scsi/hpsa.c                       |  6 ++++--
 drivers/scsi/ibmvscsi/ibmvfc.c            |  3 ++-
 drivers/scsi/ipr.c                        |  4 ++--
 drivers/scsi/ips.c                        |  2 +-
 drivers/scsi/libfc/fc_fcp.c               |  3 ++-
 drivers/scsi/libiscsi.c                   |  3 ++-
 drivers/scsi/libsas/sas_scsi_host.c       |  3 ++-
 drivers/scsi/lpfc/lpfc_scsi.c             |  8 ++++----
 drivers/scsi/megaraid.h                   |  3 ++-
 drivers/scsi/megaraid/megaraid_mbox.c     |  3 ++-
 drivers/scsi/megaraid/megaraid_sas_base.c |  4 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  4 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  4 ++--
 drivers/scsi/mvumi.c                      |  4 ++--
 drivers/scsi/myrb.c                       | 12 ++++++------
 drivers/scsi/myrs.c                       |  4 ++--
 drivers/scsi/nsp32.c                      |  3 ++-
 drivers/scsi/pcmcia/nsp_cs.h              |  3 ++-
 drivers/scsi/qedf/qedf.h                  |  4 ++--
 drivers/scsi/qedf/qedf_io.c               |  4 ++--
 drivers/scsi/qla2xxx/qla_os.c             | 15 ++++++++-------
 drivers/scsi/qla4xxx/ql4_os.c             |  6 ++++--
 drivers/scsi/qlogicfas408.h               |  3 ++-
 drivers/scsi/scsi_debug.c                 |  9 +++++----
 drivers/scsi/smartpqi/smartpqi_init.c     |  3 ++-
 drivers/scsi/snic/snic.h                  |  2 +-
 drivers/scsi/snic/snic_scsi.c             |  4 ++--
 drivers/scsi/storvsc_drv.c                |  3 ++-
 drivers/scsi/virtio_scsi.c                |  4 ++--
 drivers/scsi/wd33c93.h                    |  3 ++-
 drivers/scsi/wd719x.c                     |  3 ++-
 drivers/scsi/xen-scsifront.c              |  4 ++--
 drivers/target/loopback/tcm_loop.c        |  3 ++-
 drivers/ufs/core/ufshcd.c                 |  7 ++++---
 drivers/usb/image/microtek.c              |  4 ++--
 include/linux/libata.h                    |  3 ++-
 include/scsi/libfc.h                      |  2 +-
 include/scsi/libiscsi.h                   |  3 ++-
 include/scsi/libsas.h                     |  3 ++-
 include/scsi/scsi_host.h                  |  9 ++++++---
 67 files changed, 163 insertions(+), 120 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi=
/scsi_mid_low_api.rst
index 634f5c28a849..ec429e58e8f0 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -903,7 +903,8 @@ Details::
     *
     *      Defined in: LLD
     **/
-	int queuecommand(struct Scsi_Host *shost, struct scsi_cmnd * scp)
+	enum scsi_qc_status queuecommand(struct Scsi_Host *shost,
+					 struct scsi_cmnd * scp)
=20
=20
     /**
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 721d3f270c8e..2967a2900317 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4309,7 +4309,8 @@ static inline ata_xlat_func_t ata_get_xlat_func(str=
uct ata_device *dev, u8 cmd)
 	return NULL;
 }
=20
-int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
+enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
+					struct ata_device *dev)
 {
 	struct ata_port *ap =3D dev->link->ap;
 	u8 scsi_op =3D scmd->cmnd[0];
@@ -4383,12 +4384,13 @@ int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, s=
truct ata_device *dev)
  *	Return value from __ata_scsi_queuecmd() if @cmd can be queued,
  *	0 otherwise.
  */
-int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
+enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *shost,
+				      struct scsi_cmnd *cmd)
 {
 	struct ata_port *ap;
 	struct ata_device *dev;
 	struct scsi_device *scsidev =3D cmd->device;
-	int rc =3D 0;
+	enum scsi_qc_status rc =3D 0;
 	unsigned long irq_flags;
=20
 	ap =3D ata_shost_to_port(shost);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 0e7ecac73680..0e48bd1c0c20 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -164,7 +164,8 @@ extern int ata_scsi_user_scan(struct Scsi_Host *shost=
, unsigned int channel,
 void ata_scsi_sdev_config(struct scsi_device *sdev);
 int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *l=
im,
 		struct ata_device *dev);
-int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev);
+enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
+					struct ata_device *dev);
=20
 /* libata-eh.c */
 extern unsigned int ata_internal_cmd_timeout(struct ata_device *dev, u8 =
cmd);
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 1a19828114cf..baf288c4a3c0 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1440,13 +1440,14 @@ static int sbp2_map_scatterlist(struct sbp2_comma=
nd_orb *orb,
=20
 /* SCSI stack integration */
=20
-static int sbp2_scsi_queuecommand(struct Scsi_Host *shost,
-				  struct scsi_cmnd *cmd)
+static enum scsi_qc_status sbp2_scsi_queuecommand(struct Scsi_Host *shos=
t,
+						  struct scsi_cmnd *cmd)
 {
 	struct sbp2_logical_unit *lu =3D cmd->device->hostdata;
 	struct fw_device *device =3D target_parent_device(lu->tgt);
 	struct sbp2_command_orb *orb;
-	int generation, retval =3D SCSI_MLQUEUE_HOST_BUSY;
+	int generation;
+	enum scsi_qc_status retval =3D SCSI_MLQUEUE_HOST_BUSY;
=20
 	orb =3D kzalloc(sizeof(*orb), GFP_ATOMIC);
 	if (orb =3D=3D NULL)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp=
/srp/ib_srp.c
index 23ed2fc688f0..c4291071deb9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2148,7 +2148,8 @@ static void srp_handle_qp_err(struct ib_cq *cq, str=
uct ib_wc *wc,
 	target->qp_in_error =3D true;
 }
=20
-static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *s=
cmnd)
+static enum scsi_qc_status srp_queuecommand(struct Scsi_Host *shost,
+					    struct scsi_cmnd *scmnd)
 {
 	struct request *rq =3D scsi_cmd_to_rq(scmnd);
 	struct srp_target_port *target =3D host_to_target(shost);
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptf=
c.c
index 8f587c0efd9d..cd52db6fe76c 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -97,7 +97,8 @@ static u8	mptfcInternalCtx =3D MPT_MAX_PROTOCOL_DRIVERS=
;
=20
 static int mptfc_target_alloc(struct scsi_target *starget);
 static int mptfc_sdev_init(struct scsi_device *sdev);
-static int mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt);
+static enum scsi_qc_status mptfc_qcmd(struct Scsi_Host *shost,
+				      struct scsi_cmnd *SCpnt);
 static void mptfc_target_destroy(struct scsi_target *starget);
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t ti=
meout);
 static void mptfc_remove(struct pci_dev *pdev);
@@ -676,8 +677,8 @@ mptfc_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
=20
-static int
-mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
+static enum scsi_qc_status mptfc_qcmd(struct Scsi_Host *shost,
+				      struct scsi_cmnd *SCpnt)
 {
 	struct mptfc_rport_info	*ri;
 	struct fc_rport	*rport =3D starget_to_rport(scsi_target(SCpnt->device))=
;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mpt=
sas.c
index 185c08eab4ca..5276bdb7acc2 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1920,8 +1920,8 @@ mptsas_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
=20
-static int
-mptsas_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
+static enum scsi_qc_status mptsas_qcmd(struct Scsi_Host *shost,
+				       struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
 	MPT_ADAPTER	*ioc;
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/m=
ptscsih.c
index 3304f8824cf7..ec6edcc4ef56 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1309,8 +1309,7 @@ int mptscsih_show_info(struct seq_file *m, struct S=
csi_Host *host)
  *
  *	Returns 0. (rtn value discarded by linux scsi mid-layer)
  */
-int
-mptscsih_qcmd(struct scsi_cmnd *SCpnt)
+enum scsi_qc_status mptscsih_qcmd(struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST		*hd;
 	MPT_FRAME_HDR		*mf;
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/m=
ptscsih.h
index f9678d48100c..ac3f56801c92 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -113,7 +113,7 @@ extern int mptscsih_resume(struct pci_dev *pdev);
 #endif
 extern int mptscsih_show_info(struct seq_file *, struct Scsi_Host *);
 extern const char * mptscsih_info(struct Scsi_Host *SChost);
-extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt);
+extern enum scsi_qc_status mptscsih_qcmd(struct scsi_cmnd *SCpnt);
 extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel=
,
 	u8 id, u64 lun, int ctx2abort, ulong timeout);
 extern void mptscsih_sdev_destroy(struct scsi_device *device);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mpt=
spi.c
index a3901fbfac4f..14707d19fbbd 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -774,8 +774,8 @@ static int mptspi_sdev_configure(struct scsi_device *=
sdev,
 	return 0;
 }
=20
-static int
-mptspi_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
+static enum scsi_qc_status mptspi_qcmd(struct Scsi_Host *shost,
+				       struct scsi_cmnd *SCpnt)
 {
 	struct _MPT_SCSI_HOST *hd =3D shost_priv(shost);
 	VirtDevice	*vdevice =3D SCpnt->device->hostdata;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.=
c
index 141476ea21bb..634bd8dceedd 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -63,8 +63,8 @@ static void zfcp_scsi_command_fail(struct scsi_cmnd *sc=
pnt, int result)
 	scsi_done(scpnt);
 }
=20
-static
-int zfcp_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc=
pnt)
+static enum scsi_qc_status zfcp_scsi_queuecommand(struct Scsi_Host *shos=
t,
+						  struct scsi_cmnd *scpnt)
 {
 	struct zfcp_scsi_dev *zfcp_sdev =3D sdev_to_zfcp(scpnt->device);
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(scpnt->device))=
;
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 71b7ac027f48..a740f87aafa8 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -152,8 +152,8 @@ MODULE_LICENSE("GPL");
 /* This is the script */
 #include "53c700_d.h"
=20
-
-STATIC int NCR_700_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *)=
;
+STATIC enum scsi_qc_status NCR_700_queuecommand(struct Scsi_Host *h,
+						struct scsi_cmnd *);
 STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 79de815e33b0..08400084b285 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1272,7 +1272,7 @@ static inline void blogic_incszbucket(unsigned int =
*cmdsz_buckets,
 */
=20
 static const char *blogic_drvr_info(struct Scsi_Host *);
-static int blogic_qcmd(struct Scsi_Host *h, struct scsi_cmnd *);
+static enum scsi_qc_status blogic_qcmd(struct Scsi_Host *h, struct scsi_=
cmnd *);
 static int blogic_diskparam(struct scsi_device *, struct gendisk *, sect=
or_t, int *);
 static int blogic_sdev_configure(struct scsi_device *,
 				 struct queue_limits *lim);
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 0e10502660de..006dcf981218 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -555,8 +555,8 @@ static void complete_cmd(struct Scsi_Host *instance,
  * main coroutine is not running, it is restarted.
  */
=20
-static int NCR5380_queue_command(struct Scsi_Host *instance,
-                                 struct scsi_cmnd *cmd)
+static enum scsi_qc_status NCR5380_queue_command(struct Scsi_Host *insta=
nce,
+						 struct scsi_cmnd *cmd)
 {
 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
 	struct NCR5380_cmd *ncmd =3D NCR5380_to_ncmd(cmd);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 82c6e7c7cdaf..ea468666159a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -237,8 +237,8 @@ static struct aac_driver_ident aac_drivers[] =3D {
  *	TODO: unify with aac_scsi_cmd().
  */
=20
-static int aac_queuecommand(struct Scsi_Host *shost,
-			    struct scsi_cmnd *cmd)
+static enum scsi_qc_status aac_queuecommand(struct Scsi_Host *shost,
+					    struct scsi_cmnd *cmd)
 {
 	aac_priv(cmd)->owner =3D AAC_OWNER_LOWLEVEL;
=20
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 371e8300f029..fd766282d4a4 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -411,7 +411,8 @@ static irqreturn_t aha1542_interrupt(int irq, void *d=
ev_id)
 	}
 }
=20
-static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *=
cmd)
+static enum scsi_qc_status aha1542_queuecommand(struct Scsi_Host *sh,
+						struct scsi_cmnd *cmd)
 {
 	struct aha1542_cmd *acmd =3D scsi_cmd_priv(cmd);
 	struct aha1542_hostdata *aha1542 =3D shost_priv(sh);
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcms=
r_hba.c
index f0c5a30ce51b..463761eb7313 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -113,7 +113,8 @@ static int arcmsr_abort(struct scsi_cmnd *);
 static int arcmsr_bus_reset(struct scsi_cmnd *);
 static int arcmsr_bios_param(struct scsi_device *sdev,
 		struct gendisk *disk, sector_t capacity, int *info);
-static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *c=
md);
+static enum scsi_qc_status arcmsr_queue_command(struct Scsi_Host *h,
+						struct scsi_cmnd *cmd);
 static int arcmsr_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
 static int __maybe_unused arcmsr_suspend(struct device *dev);
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 08113277a2a9..1e255a8bc98a 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -338,21 +338,23 @@ extern int fas216_init (struct Scsi_Host *instance)=
;
  */
 extern int fas216_add (struct Scsi_Host *instance, struct device *dev);
=20
-/* Function: int fas216_queue_command(struct Scsi_Host *h, struct scsi_c=
mnd *SCpnt)
+/* Function: enum scsi_qc_status fas216_queue_command(struct Scsi_Host *=
h, struct scsi_cmnd *SCpnt)
  * Purpose : queue a command for adapter to process.
  * Params  : h - host adapter
  *	   : SCpnt - Command to queue
  * Returns : 0 - success, else error
  */
-extern int fas216_queue_command(struct Scsi_Host *h, struct scsi_cmnd *S=
Cpnt);
+extern enum scsi_qc_status fas216_queue_command(struct Scsi_Host *h,
+						struct scsi_cmnd *SCpnt);
=20
-/* Function: int fas216_noqueue_command(struct Scsi_Host *h, struct scsi=
_cmnd *SCpnt)
+/* Function: enum scsi_qc_status fas216_noqueue_command(struct Scsi_Host=
 *h, struct scsi_cmnd *SCpnt)
  * Purpose : queue a command for adapter to process, and process it to c=
ompletion.
  * Params  : h - host adapter
  *	   : SCpnt - Command to queue
  * Returns : 0 - success, else error
  */
-extern int fas216_noqueue_command(struct Scsi_Host *, struct scsi_cmnd *=
);
+extern enum scsi_qc_status fas216_noqueue_command(struct Scsi_Host *,
+						  struct scsi_cmnd *);
=20
 /* Function: irqreturn_t fas216_intr (FAS216_Info *info)
  * Purpose : handle interrupts from the interface to progress a command
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f56e008ee52b..3e5b3c19af57 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -24,7 +24,8 @@ DEFINE_IDR(bfad_im_port_index);
 struct scsi_transport_template *bfad_im_scsi_transport_template;
 struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 static void bfad_im_itnim_work_handler(struct work_struct *work);
-static int bfad_im_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *c=
mnd);
+static enum scsi_qc_status bfad_im_queuecommand(struct Scsi_Host *h,
+						struct scsi_cmnd *cmnd);
 static int bfad_im_sdev_init(struct scsi_device *sdev);
 static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
 				struct bfad_itnim_s *itnim);
diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 6d47a4d8eed6..8c8968ec8cb4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -498,7 +498,8 @@ static inline struct bnx2fc_priv *bnx2fc_priv(struct =
scsi_cmnd *cmd)
 struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport *tgt);
 struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type=
);
 void bnx2fc_cmd_release(struct kref *ref);
-int bnx2fc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd=
);
+enum scsi_qc_status bnx2fc_queuecommand(struct Scsi_Host *host,
+					struct scsi_cmnd *sc_cmd);
 int bnx2fc_send_fw_fcoe_init_msg(struct bnx2fc_hba *hba);
 int bnx2fc_send_fw_fcoe_destroy_msg(struct bnx2fc_hba *hba);
 int bnx2fc_send_session_ofld_req(struct fcoe_port *port,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc=
_io.c
index 33057908f147..90b2b54c549a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1836,8 +1836,8 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd =
*io_req,
  *
  * This is the IO strategy routine, called by SCSI-ML
  **/
-int bnx2fc_queuecommand(struct Scsi_Host *host,
-			struct scsi_cmnd *sc_cmd)
+enum scsi_qc_status bnx2fc_queuecommand(struct Scsi_Host *host,
+					struct scsi_cmnd *sc_cmd)
 {
 	struct fc_lport *lport =3D shost_priv(host);
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(sc_cmd->device)=
);
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/cs=
io_scsi.c
index 34bde6650fae..c29bf2807e31 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1775,8 +1775,8 @@ csio_scsi_cbfn(struct csio_hw *hw, struct csio_iore=
q *req)
  *	- Kicks off the SCSI state machine for this IO.
  *	- Returns busy status on error.
  */
-static int
-csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
+static enum scsi_qc_status csio_queuecommand(struct Scsi_Host *host,
+					     struct scsi_cmnd *cmnd)
 {
 	struct csio_lnode *ln =3D shost_priv(host);
 	struct csio_hw *hw =3D csio_lnode_to_hw(ln);
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index c48275d53aef..a763edd05fe4 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -968,7 +968,8 @@ int esas2r_ioctl_handler(void *hostdata, unsigned int=
 cmd, void __user *arg);
 int esas2r_ioctl(struct scsi_device *dev, unsigned int cmd, void __user =
*arg);
 u8 handle_hba_ioctl(struct esas2r_adapter *a,
 		    struct atto_ioctl *ioctl_hba);
-int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd);
+enum scsi_qc_status esas2r_queuecommand(struct Scsi_Host *host,
+					struct scsi_cmnd *cmd);
 int esas2r_show_info(struct seq_file *m, struct Scsi_Host *sh);
 long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long =
arg);
=20
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas=
2r_main.c
index be6bf518eb7c..fdcffc871d19 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -818,7 +818,8 @@ static u32 get_physaddr_from_sgc(struct esas2r_sg_con=
text *sgc, u64 *addr)
 	return len;
 }
=20
-int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+enum scsi_qc_status esas2r_queuecommand(struct Scsi_Host *host,
+					struct scsi_cmnd *cmd)
 {
 	struct esas2r_adapter *a =3D
 		(struct esas2r_adapter *)cmd->device->host->hostdata;
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index c0b2a980db34..22fbb0222f07 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -402,7 +402,8 @@ static irqreturn_t fdomain_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
=20
-static int fdomain_queue(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
+static enum scsi_qc_status fdomain_queue(struct Scsi_Host *sh,
+					 struct scsi_cmnd *cmd)
 {
 	struct scsi_pointer *scsi_pointer =3D fdomain_scsi_pointer(cmd);
 	struct fdomain *fd =3D shost_priv(cmd->device->host);
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 1199d701c3f5..1f27ee6d456f 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -503,7 +503,7 @@ void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic=
_rq_buf *buf);
 void fnic_flush_tx(struct work_struct *work);
 void fnic_update_mac_locked(struct fnic *, u8 *new);
=20
-int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
+enum scsi_qc_status fnic_queuecommand(struct Scsi_Host *, struct scsi_cm=
nd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
 int fnic_device_reset(struct scsi_cmnd *);
 int fnic_eh_host_reset_handler(struct scsi_cmnd *sc);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.=
c
index 75b29a018d1f..29d7aca06958 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -454,7 +454,8 @@ static inline int fnic_queue_wq_copy_desc(struct fnic=
 *fnic,
 	return 0;
 }
=20
-int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+enum scsi_qc_status fnic_queuecommand(struct Scsi_Host *shost,
+				      struct scsi_cmnd *sc)
 {
 	struct request *const rq =3D scsi_cmd_to_rq(sc);
 	uint32_t mqtag =3D 0;
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3654b12c5d5a..3e235dbfb67a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -276,7 +276,8 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h);
 #define VPD_PAGE (1 << 8)
 #define HPSA_SIMPLE_ERROR_BITS 0x03
=20
-static int hpsa_scsi_queue_command(struct Scsi_Host *h, struct scsi_cmnd=
 *cmd);
+static enum scsi_qc_status hpsa_scsi_queue_command(struct Scsi_Host *h,
+						   struct scsi_cmnd *cmd);
 static void hpsa_scan_start(struct Scsi_Host *);
 static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time);
@@ -5667,7 +5668,8 @@ static void hpsa_command_resubmit_worker(struct wor=
k_struct *work)
 }
=20
 /* Running in struct Scsi_Host->host_lock less mode */
-static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmn=
d *cmd)
+static enum scsi_qc_status hpsa_scsi_queue_command(struct Scsi_Host *sh,
+						   struct scsi_cmnd *cmd)
 {
 	struct ctlr_info *h;
 	struct hpsa_scsi_dev_t *dev;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
index 228daffb286d..1c370d11b6dd 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1960,7 +1960,8 @@ static struct ibmvfc_cmd *ibmvfc_init_vfc_cmd(struc=
t ibmvfc_event *evt, struct s
  * Returns:
  *	0 on success / other on failure
  **/
-static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd=
 *cmnd)
+static enum scsi_qc_status ibmvfc_queuecommand(struct Scsi_Host *shost,
+					       struct scsi_cmnd *cmnd)
 {
 	struct ibmvfc_host *vhost =3D shost_priv(shost);
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(cmnd->device));
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index dbd58a7e7bc1..c0487ce38d8d 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6242,8 +6242,8 @@ static void ipr_scsi_done(struct ipr_cmnd *ipr_cmd)
  *	SCSI_MLQUEUE_DEVICE_BUSY if device is busy
  *	SCSI_MLQUEUE_HOST_BUSY if host is busy
  **/
-static int ipr_queuecommand(struct Scsi_Host *shost,
-			    struct scsi_cmnd *scsi_cmd)
+static enum scsi_qc_status ipr_queuecommand(struct Scsi_Host *shost,
+					    struct scsi_cmnd *scsi_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 3393a288fd23..25a344722c57 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -230,7 +230,7 @@ module_param(ips, charp, 0);
  */
 static int ips_eh_abort(struct scsi_cmnd *);
 static int ips_eh_reset(struct scsi_cmnd *);
-static int ips_queue(struct Scsi_Host *, struct scsi_cmnd *);
+static enum scsi_qc_status ips_queue(struct Scsi_Host *, struct scsi_cmn=
d *);
 static const char *ips_info(struct Scsi_Host *);
 static irqreturn_t do_ipsintr(int, void *);
 static int ips_hainit(ips_ha_t *);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 31d08c115521..2f93f6c65a86 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1854,7 +1854,8 @@ static inline int fc_fcp_lport_queue_ready(struct f=
c_lport *lport)
  *
  * This is the i/o strategy routine, called by the SCSI layer.
  */
-int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
+enum scsi_qc_status fc_queuecommand(struct Scsi_Host *shost,
+				    struct scsi_cmnd *sc_cmd)
 {
 	struct fc_lport *lport =3D shost_priv(shost);
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(sc_cmd->device)=
);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c9f410c50978..25857d6ed6e8 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1747,7 +1747,8 @@ enum {
 	FAILURE_SESSION_NOT_READY,
 };
=20
-int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
+enum scsi_qc_status iscsi_queuecommand(struct Scsi_Host *host,
+				       struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_host *ihost;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sa=
s_scsi_host.c
index ffa5b49aaf08..58ee74562332 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -157,7 +157,8 @@ static struct sas_task *sas_create_task(struct scsi_c=
mnd *cmd,
 	return task;
 }
=20
-int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+enum scsi_qc_status sas_queuecommand(struct Scsi_Host *host,
+				     struct scsi_cmnd *cmd)
 {
 	struct sas_internal *i =3D to_sas_internal(host->transportt);
 	struct domain_device *dev =3D cmd_to_domain_dev(cmd);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.=
c
index 6d9d8c196936..df64948e55ee 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5233,8 +5233,8 @@ static char *lpfc_is_command_vm_io(struct scsi_cmnd=
 *cmd)
  *   0 - Success
  *   SCSI_MLQUEUE_HOST_BUSY - Block all devices served by this host temp=
orarily.
  **/
-static int
-lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
+static enum scsi_qc_status lpfc_queuecommand(struct Scsi_Host *shost,
+					     struct scsi_cmnd *cmnd)
 {
 	struct lpfc_vport *vport =3D (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba =3D vport->phba;
@@ -6743,8 +6743,8 @@ lpfc_disable_oas_lun(struct lpfc_hba *phba, struct =
lpfc_name *vport_wwpn,
 	return false;
 }
=20
-static int
-lpfc_no_command(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
+static enum scsi_qc_status lpfc_no_command(struct Scsi_Host *shost,
+					   struct scsi_cmnd *cmnd)
 {
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index d6bfd26a8843..3a41194957d8 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -962,7 +962,8 @@ static int mega_query_adapter(adapter_t *);
 static int issue_scb(adapter_t *, scb_t *);
 static int mega_setup_mailbox(adapter_t *);
=20
-static int megaraid_queue (struct Scsi_Host *, struct scsi_cmnd *);
+static enum scsi_qc_status megaraid_queue(struct Scsi_Host *,
+					  struct scsi_cmnd *);
 static scb_t * mega_build_cmd(adapter_t *, struct scsi_cmnd *, int *);
 static void __mega_runpendq(adapter_t *);
 static int issue_scb_block(adapter_t *, u_char *);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megarai=
d/megaraid_mbox.c
index b610cad83321..0390ce7b4eee 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -109,7 +109,8 @@ static int megaraid_mbox_fire_sync_cmd(adapter_t *);
 static void megaraid_mbox_display_scb(adapter_t *, scb_t *);
 static void megaraid_mbox_setup_device_map(adapter_t *);
=20
-static int megaraid_queue_command(struct Scsi_Host *, struct scsi_cmnd *=
);
+static enum scsi_qc_status megaraid_queue_command(struct Scsi_Host *,
+						  struct scsi_cmnd *);
 static scb_t *megaraid_mbox_build_cmd(adapter_t *, struct scsi_cmnd *, i=
nt *);
 static void megaraid_mbox_runpendq(adapter_t *, scb_t *);
 static void megaraid_mbox_prepare_pthru(adapter_t *, scb_t *,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
index abbbc4b36cd1..52894e892a92 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1781,8 +1781,8 @@ megasas_build_and_issue_cmd(struct megasas_instance=
 *instance,
  * @shost:			adapter SCSI host
  * @scmd:			SCSI command to be queued
  */
-static int
-megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
+static enum scsi_qc_status megasas_queue_command(struct Scsi_Host *shost=
,
+						 struct scsi_cmnd *scmd)
 {
 	struct megasas_instance *instance;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
index d4ca878d0886..7212459d5c4a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5029,8 +5029,8 @@ inline bool mpi3mr_allow_scmd_to_fw(struct scsi_cmn=
d *scmd)
  *         SCSI_MLQUEUE_DEVICE_BUSY when the device is busy.
  *         SCSI_MLQUEUE_HOST_BUSY when the host queue is full.
  */
-static int mpi3mr_qcmd(struct Scsi_Host *shost,
-	struct scsi_cmnd *scmd)
+static enum scsi_qc_status mpi3mr_qcmd(struct Scsi_Host *shost,
+				       struct scsi_cmnd *scmd)
 {
 	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
 	struct mpi3mr_stgt_priv_data *stgt_priv_data;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index ac69a5abe2e2..26a13b622c95 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5422,8 +5422,8 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, =
u16 ioc_status)
  * SCSI_MLQUEUE_DEVICE_BUSY if the device queue is full, or
  * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
  */
-static int
-scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
+static enum scsi_qc_status scsih_qcmd(struct Scsi_Host *shost,
+				      struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc =3D shost_priv(shost);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index bdc2f2f17753..cda8bd083a38 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2077,8 +2077,8 @@ static unsigned char mvumi_build_frame(struct mvumi=
_hba *mhba,
  * @shost:			Scsi host to queue command on
  * @scmd:			SCSI command to be queued
  */
-static int mvumi_queue_command(struct Scsi_Host *shost,
-					struct scsi_cmnd *scmd)
+static enum scsi_qc_status mvumi_queue_command(struct Scsi_Host *shost,
+					       struct scsi_cmnd *scmd)
 {
 	struct mvumi_cmd *cmd;
 	struct mvumi_hba *mhba;
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index b8453c0333dc..efeacb9ffd7c 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1260,8 +1260,8 @@ static int myrb_host_reset(struct scsi_cmnd *scmd)
 	return SUCCESS;
 }
=20
-static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
-		struct scsi_cmnd *scmd)
+static enum scsi_qc_status myrb_pthru_queuecommand(struct Scsi_Host *sho=
st,
+						   struct scsi_cmnd *scmd)
 {
 	struct request *rq =3D scsi_cmd_to_rq(scmd);
 	struct myrb_hba *cb =3D shost_priv(shost);
@@ -1416,8 +1416,8 @@ static void myrb_read_capacity(struct myrb_hba *cb,=
 struct scsi_cmnd *scmd,
 	scsi_sg_copy_from_buffer(scmd, data, 8);
 }
=20
-static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
-		struct scsi_cmnd *scmd)
+static enum scsi_qc_status myrb_ldev_queuecommand(struct Scsi_Host *shos=
t,
+						  struct scsi_cmnd *scmd)
 {
 	struct myrb_hba *cb =3D shost_priv(shost);
 	struct myrb_cmdblk *cmd_blk =3D scsi_cmd_priv(scmd);
@@ -1603,8 +1603,8 @@ static int myrb_ldev_queuecommand(struct Scsi_Host =
*shost,
 	return 0;
 }
=20
-static int myrb_queuecommand(struct Scsi_Host *shost,
-		struct scsi_cmnd *scmd)
+static enum scsi_qc_status myrb_queuecommand(struct Scsi_Host *shost,
+					     struct scsi_cmnd *scmd)
 {
 	struct scsi_device *sdev =3D scmd->device;
=20
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index a58abd796603..7e8bb533c669 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1581,8 +1581,8 @@ static void myrs_mode_sense(struct myrs_hba *cs, st=
ruct scsi_cmnd *scmd,
 	scsi_sg_copy_from_buffer(scmd, modes, mode_len);
 }
=20
-static int myrs_queuecommand(struct Scsi_Host *shost,
-		struct scsi_cmnd *scmd)
+static enum scsi_qc_status myrs_queuecommand(struct Scsi_Host *shost,
+					     struct scsi_cmnd *scmd)
 {
 	struct request *rq =3D scsi_cmd_to_rq(scmd);
 	struct myrs_hba *cs =3D shost_priv(shost);
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index abc4ce9eae74..d67e3500f506 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -185,7 +185,8 @@ static void __exit exit_nsp32  (void);
 static int	   nsp32_show_info   (struct seq_file *, struct Scsi_Host *);
=20
 static int	   nsp32_detect      (struct pci_dev *pdev);
-static int	   nsp32_queuecommand(struct Scsi_Host *, struct scsi_cmnd *)=
;
+static enum scsi_qc_status nsp32_queuecommand(struct Scsi_Host *,
+					      struct scsi_cmnd *);
 static const char *nsp32_info	     (struct Scsi_Host *);
 static int	   nsp32_release     (struct Scsi_Host *);
=20
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index e1ee8ef90ad3..12e58386bb8f 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -294,7 +294,8 @@ static struct Scsi_Host *nsp_detect     (struct scsi_=
host_template *sht);
 static const  char      *nsp_info       (struct Scsi_Host *shpnt);
 static        int        nsp_show_info  (struct seq_file *m,
 	                                 struct Scsi_Host *host);
-static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt=
);
+static enum scsi_qc_status nsp_queuecommand(struct Scsi_Host *h,
+					    struct scsi_cmnd *SCpnt);
=20
 /* Error handler */
 /*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 98afdfe63600..5b330a3203e1 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -487,8 +487,8 @@ extern uint qedf_debug;
=20
 extern struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf);
 extern void qedf_cmd_mgr_free(struct qedf_cmd_mgr *cmgr);
-extern int qedf_queuecommand(struct Scsi_Host *host,
-	struct scsi_cmnd *sc_cmd);
+extern enum scsi_qc_status qedf_queuecommand(struct Scsi_Host *host,
+					     struct scsi_cmnd *sc_cmd);
 extern void qedf_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb);
 extern u8 *qedf_get_src_mac(struct fc_lport *lport);
 extern void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb);
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..d12c47be016e 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -930,8 +930,8 @@ int qedf_post_io_req(struct qedf_rport *fcport, struc=
t qedf_ioreq *io_req)
 	return false;
 }
=20
-int
-qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
+enum scsi_qc_status qedf_queuecommand(struct Scsi_Host *host,
+				      struct scsi_cmnd *sc_cmd)
 {
 	struct fc_lport *lport =3D shost_priv(host);
 	struct qedf_ctx *qedf =3D lport_priv(lport);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
index c9aff70e7357..d9335788bd15 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -402,8 +402,9 @@ static int qla2x00_mem_alloc(struct qla_hw_data *, ui=
nt16_t, uint16_t,
 	struct req_que **, struct rsp_que **);
 static void qla2x00_free_fw_dump(struct qla_hw_data *);
 static void qla2x00_mem_free(struct qla_hw_data *);
-int qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
-	struct qla_qpair *qpair);
+enum scsi_qc_status qla2xxx_mqueuecommand(struct Scsi_Host *host,
+					  struct scsi_cmnd *cmd,
+					  struct qla_qpair *qpair);
=20
 /* ---------------------------------------------------------------------=
----- */
 static void qla_init_base_qpair(struct scsi_qla_host *vha, struct req_qu=
e *req,
@@ -858,8 +859,8 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 		complete(comp);
 }
=20
-static int
-qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+static enum scsi_qc_status qla2xxx_queuecommand(struct Scsi_Host *host,
+						struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha =3D shost_priv(host);
 	fc_port_t *fcport =3D (struct fc_port *) cmd->device->hostdata;
@@ -981,9 +982,9 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct s=
csi_cmnd *cmd)
 }
=20
 /* For MQ supported I/O */
-int
-qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
-    struct qla_qpair *qpair)
+enum scsi_qc_status qla2xxx_mqueuecommand(struct Scsi_Host *host,
+					  struct scsi_cmnd *cmd,
+					  struct qla_qpair *qpair)
 {
 	scsi_qla_host_t *vha =3D shost_priv(host);
 	fc_port_t *fcport =3D (struct fc_port *) cmd->device->hostdata;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
index 97329c97332f..71bb96ca33b4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -155,7 +155,8 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *s=
host, char *buf, int len);
 /*
  * SCSI host template entry points
  */
-static int qla4xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *c=
md);
+static enum scsi_qc_status qla4xxx_queuecommand(struct Scsi_Host *h,
+						struct scsi_cmnd *cmd);
 static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
@@ -4107,7 +4108,8 @@ void qla4xxx_srb_compl(struct kref *ref)
  * completion handling). Unfortunately, it sometimes calls the scheduler
  * in interrupt context which is a big NO! NO!.
  **/
-static int qla4xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd=
 *cmd)
+static enum scsi_qc_status qla4xxx_queuecommand(struct Scsi_Host *host,
+						struct scsi_cmnd *cmd)
 {
 	struct scsi_qla_host *ha =3D to_qla_host(host);
 	struct ddb_entry *ddb_entry =3D cmd->device->hostdata;
diff --git a/drivers/scsi/qlogicfas408.h b/drivers/scsi/qlogicfas408.h
index 83ef86c71f2f..a589c7656f57 100644
--- a/drivers/scsi/qlogicfas408.h
+++ b/drivers/scsi/qlogicfas408.h
@@ -104,7 +104,8 @@ struct qlogicfas408_priv {
 #define get_priv_by_host(x) (struct qlogicfas408_priv *)&((x)->hostdata[=
0])
=20
 irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id);
-int qlogicfas408_queuecommand(struct Scsi_Host *h, struct scsi_cmnd * cm=
d);
+enum scsi_qc_status qlogicfas408_queuecommand(struct Scsi_Host *h,
+					      struct scsi_cmnd *cmd);
 int qlogicfas408_biosparam(struct scsi_device * disk,
 			   struct gendisk *unused,
 			   sector_t capacity, int ip[]);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9f17e9c49cb5..b8c1c77e9c78 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9284,8 +9284,9 @@ static void scsi_debug_abort_cmd(struct Scsi_Host *=
shost, struct scsi_cmnd *scp)
 	set_host_byte(scp, res ? DID_OK : DID_ERROR);
 }
=20
-static int scsi_debug_process_reserved_command(struct Scsi_Host *shost,
-					       struct scsi_cmnd *scp)
+static enum scsi_qc_status
+scsi_debug_process_reserved_command(struct Scsi_Host *shost,
+				    struct scsi_cmnd *scp)
 {
 	struct sdebug_internal_cmd *internal_cmd =3D scsi_cmd_priv(scp);
=20
@@ -9303,8 +9304,8 @@ static int scsi_debug_process_reserved_command(stru=
ct Scsi_Host *shost,
 	return 0;
 }
=20
-static int scsi_debug_queuecommand(struct Scsi_Host *shost,
-				   struct scsi_cmnd *scp)
+static enum scsi_qc_status scsi_debug_queuecommand(struct Scsi_Host *sho=
st,
+						   struct scsi_cmnd *scp)
 {
 	u8 sdeb_i;
 	struct scsi_device *sdp =3D scp->device;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
index fe549e2b7c94..36834768fec1 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6047,7 +6047,8 @@ static bool pqi_is_parity_write_stream(struct pqi_c=
trl_info *ctrl_info,
 	return false;
 }
=20
-static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_c=
mnd *scmd)
+static enum scsi_qc_status pqi_scsi_queue_command(struct Scsi_Host *shos=
t,
+						  struct scsi_cmnd *scmd)
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 32f5a34b6987..b5cf698e6c43 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -362,7 +362,7 @@ void snic_glob_cleanup(void);
 extern struct workqueue_struct *snic_event_queue;
 extern const struct attribute_group *snic_host_groups[];
=20
-int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
+enum scsi_qc_status snic_queuecommand(struct Scsi_Host *, struct scsi_cm=
nd *);
 int snic_abort_cmd(struct scsi_cmnd *);
 int snic_device_reset(struct scsi_cmnd *);
 int snic_host_reset(struct scsi_cmnd *);
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.=
c
index 84973f0f771e..c6af3b8d2523 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -315,8 +315,8 @@ snic_issue_scsi_req(struct snic *snic,
  * Routine to send a scsi cdb to LLD
  * Called with host_lock held and interrupts disabled
  */
-int
-snic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+enum scsi_qc_status snic_queuecommand(struct Scsi_Host *shost,
+				      struct scsi_cmnd *sc)
 {
 	struct snic_tgt *tgt =3D NULL;
 	struct snic *snic =3D shost_priv(shost);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6e4112143c76..19e18939d3a5 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1714,7 +1714,8 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *s=
cmnd)
 	return allowed;
 }
=20
-static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd=
 *scmnd)
+static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
+						struct scsi_cmnd *scmnd)
 {
 	int ret;
 	struct hv_host_device *host_dev =3D shost_priv(host);
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 96a69edddbe5..6b1d8bcd06b9 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -561,8 +561,8 @@ static struct virtio_scsi_vq *virtscsi_pick_vq_mq(str=
uct virtio_scsi *vscsi,
 	return &vscsi->req_vqs[hwq];
 }
=20
-static int virtscsi_queuecommand(struct Scsi_Host *shost,
-				 struct scsi_cmnd *sc)
+static enum scsi_qc_status virtscsi_queuecommand(struct Scsi_Host *shost=
,
+						 struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi =3D shost_priv(shost);
 	struct virtio_scsi_vq *req_vq =3D virtscsi_pick_vq_mq(vscsi, sc);
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index e5e4254b1477..e1e98280aad1 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -332,7 +332,8 @@ static inline struct scsi_pointer *WD33C93_scsi_point=
er(struct scsi_cmnd *cmd)
 void wd33c93_init (struct Scsi_Host *instance, const wd33c93_regs regs,
          dma_setup_t setup, dma_stop_t stop, int clock_freq);
 int wd33c93_abort (struct scsi_cmnd *cmd);
-int wd33c93_queuecommand (struct Scsi_Host *h, struct scsi_cmnd *cmd);
+enum scsi_qc_status wd33c93_queuecommand(struct Scsi_Host *h,
+					 struct scsi_cmnd *cmd);
 void wd33c93_intr (struct Scsi_Host *instance);
 int wd33c93_show_info(struct seq_file *, struct Scsi_Host *);
 int wd33c93_write_info(struct Scsi_Host *, char *, int);
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 0c9987828774..830d40f57f6a 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -204,7 +204,8 @@ static void wd719x_finish_cmd(struct wd719x_scb *scb,=
 int result)
 }
=20
 /* Build a SCB and send it to the card */
-static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *c=
md)
+static enum scsi_qc_status wd719x_queuecommand(struct Scsi_Host *sh,
+					       struct scsi_cmnd *cmd)
 {
 	int i, count_sg;
 	unsigned long flags;
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 924025305753..bf36c07c2b47 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -603,8 +603,8 @@ static void scsifront_return(struct vscsifrnt_info *i=
nfo)
 	wake_up(&info->wq_pause);
 }
=20
-static int scsifront_queuecommand(struct Scsi_Host *shost,
-				  struct scsi_cmnd *sc)
+static enum scsi_qc_status scsifront_queuecommand(struct Scsi_Host *shos=
t,
+						  struct scsi_cmnd *sc)
 {
 	struct vscsifrnt_info *info =3D shost_priv(shost);
 	struct vscsifrnt_shadow *shadow =3D scsi_cmd_priv(sc);
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback=
/tcm_loop.c
index 01a8e349dc4d..0821a149573e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -165,7 +165,8 @@ static void tcm_loop_target_queue_cmd(struct tcm_loop=
_cmd *tl_cmd)
  * ->queuecommand can be and usually is called from interrupt context, s=
o
  * defer the actual submission to a workqueue.
  */
-static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd =
*sc)
+static enum scsi_qc_status tcm_loop_queuecommand(struct Scsi_Host *sh,
+						 struct scsi_cmnd *sc)
 {
 	struct tcm_loop_cmd *tl_cmd =3D scsi_cmd_priv(sc);
=20
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 80c0b49f30b0..562d8cffc6f6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3031,7 +3031,8 @@ static int ufshcd_init_cmd_priv(struct Scsi_Host *h=
ost, struct scsi_cmnd *cmd)
  *
  * Return: 0 for success, non-zero in case of failure.
  */
-static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd =
*cmd)
+static enum scsi_qc_status ufshcd_queuecommand(struct Scsi_Host *host,
+					       struct scsi_cmnd *cmd)
 {
 	struct ufs_hba *hba =3D shost_priv(host);
 	int tag =3D scsi_cmd_to_rq(cmd)->tag;
@@ -3111,8 +3112,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 	return err;
 }
=20
-static int ufshcd_queue_reserved_command(struct Scsi_Host *host,
-					 struct scsi_cmnd *cmd)
+static enum scsi_qc_status ufshcd_queue_reserved_command(struct Scsi_Hos=
t *host,
+							 struct scsi_cmnd *cmd)
 {
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	struct request *rq =3D scsi_cmd_to_rq(cmd);
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 934ec5310fb9..b03cd76e4210 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -355,8 +355,8 @@ static int mts_scsi_host_reset(struct scsi_cmnd *srb)
 	return result ? FAILED : SUCCESS;
 }
=20
-static int
-mts_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *srb);
+static enum scsi_qc_status mts_scsi_queuecommand(struct Scsi_Host *shost=
,
+						 struct scsi_cmnd *srb);
=20
 static void mts_transfer_cleanup( struct urb *transfer );
 static void mts_do_sg(struct urb * transfer);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 39534fafa36a..44117814d672 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1150,7 +1150,8 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, =
unsigned int cmd,
 #else
 #define ATA_SCSI_COMPAT_IOCTL /* empty */
 #endif
-extern int ata_scsi_queuecmd(struct Scsi_Host *h, struct scsi_cmnd *cmd)=
;
+extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
+					     struct scsi_cmnd *cmd);
 #if IS_REACHABLE(CONFIG_ATA)
 bool ata_scsi_dma_need_drain(struct request *rq);
 #else
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 183d9fd50d2d..7ef761439623 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -959,7 +959,7 @@ void fc_fcp_destroy(struct fc_lport *);
 /*
  * SCSI INTERACTION LAYER
  *****************************/
-int fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
+enum scsi_qc_status fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd=
 *);
 int fc_eh_abort(struct scsi_cmnd *);
 int fc_eh_device_reset(struct scsi_cmnd *);
 int fc_eh_host_reset(struct scsi_cmnd *);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7282555adfd5..3d765c77bcd9 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -392,7 +392,8 @@ extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
 extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
-extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *=
sc);
+extern enum scsi_qc_status iscsi_queuecommand(struct Scsi_Host *host,
+					      struct scsi_cmnd *sc);
 extern enum scsi_timeout_action iscsi_eh_cmd_timed_out(struct scsi_cmnd =
*sc);
=20
 /*
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index a0635b128d7a..0c2a65d2da37 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -689,7 +689,8 @@ extern void sas_suspend_ha(struct sas_ha_struct *sas_=
ha);
=20
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
 int sas_phy_enable(struct sas_phy *phy, int enable);
-extern int sas_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
+extern enum scsi_qc_status sas_queuecommand(struct Scsi_Host *,
+					    struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
 int sas_sdev_configure(struct scsi_device *dev, struct queue_limits *lim=
);
 extern int sas_change_queue_depth(struct scsi_device *, int new_depth);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e87cf7eadd26..41ba6e7e799a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -84,13 +84,15 @@ struct scsi_host_template {
 	 *
 	 * STATUS: REQUIRED
 	 */
-	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
+	enum scsi_qc_status (* queuecommand)(struct Scsi_Host *,
+					     struct scsi_cmnd *);
=20
 	/*
 	 * Queue a reserved command (BLK_MQ_REQ_RESERVED). The .queuecommand()
 	 * documentation also applies to the .queue_reserved_command() callback=
.
 	 */
-	int (*queue_reserved_command)(struct Scsi_Host *, struct scsi_cmnd *);
+	enum scsi_qc_status (*queue_reserved_command)(struct Scsi_Host *,
+						      struct scsi_cmnd *);
=20
 	/*
 	 * The commit_rqs function is used to trigger a hardware
@@ -525,7 +527,8 @@ struct scsi_host_template {
  *
  */
 #define DEF_SCSI_QCMD(func_name) \
-	int func_name(struct Scsi_Host *shost, struct scsi_cmnd *cmd)	\
+	enum scsi_qc_status func_name(struct Scsi_Host *shost,		\
+				      struct scsi_cmnd *cmd)		\
 	{								\
 		unsigned long irq_flags;				\
 		int rc;							\
