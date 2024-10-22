Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B771C9B79
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 18:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729620796; cv=none; b=Gk16FQQ3fEtrP9Y0EsN7/2Vb9RXPEk0twMoqfkohSkWBEWx+cgN/nfyMeDBhVPEtCBGLAfjCx8uMbn7a0EyXmlhYekHBKalbBROeLO/xWX700hg1Y53Ro+g9iF14sf2t0P+I6scpO4T/0YUa1VY2t5PjVJEADjeAPzzoTmwL7Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729620796; c=relaxed/simple;
	bh=t9QZyjZ7Iz9+9g5wOn619fcHce/hlUDvP0dDYklL6LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM2dhEPxN7N0MsevL407idN5iI6Pwh4oEEepC/+ND+btmGHcIYpghEqlIVGZWml/F5r3IKVtdjjiDWUhRg+8H34etcO6L8NUJZvRZzkCTbPPExa9KROHSAhGH8n/sLKtjL2zK2BU11LGjV18Mhk3g7R8JvtcVekMyFTYCBsZk+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aRRS2Txr; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aRRS2Txr"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XY0fK1NjczlgTWK;
	Tue, 22 Oct 2024 18:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729620607; x=1732212608; bh=vlwqK
	r1ExGWL8DkCAU0nXW4TTec0nizeeXkqq5PWrWA=; b=aRRS2TxrwoPGgQBovk+C9
	vxItYbk9O+SDAdHJvii2mYrney3NxRDFdG93R/aifsrnmB4cs6MKBtbU4u1Z+smR
	2k9k91VB/GvkXHy3+NZbSljj4CLAt14rkThDScFo2T+m3L8c97liWZIrgEGv6xmY
	1ggel01m9SO4O4EsTu4Q+eE8k8V2HcpWgAwIbp1OOLz4AUe7VL67DprPa/j0h1nI
	N+scFoo8qk8sKXAcAk17go5XWS0p5Kizj9u8KAyPxMFiJJX8S20FYDPyxv0I9w7C
	X5eOR+FejvTAqDm63ISH9rl/8E/F0sLVfYGeiYyPX6Ryu12m6XCXXVzBBQFBopNO
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Tu3U9rituMwV; Tue, 22 Oct 2024 18:10:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XY0ZF0tT8zlgMVW;
	Tue, 22 Oct 2024 18:09:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Geoff Levand <geoff@infradead.org>,
	Khalid Aziz <khalid@gonehiking.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Steffen Maier <maier@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Adam Radford <aradford@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Don Brace <don.brace@microchip.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	ching Huang <ching2048@areca.com.tw>,
	Bjorn Helgaas <bhelgaas@google.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 3/5] scsi: Convert SCSI drivers to .sdev_configure()
Date: Tue, 22 Oct 2024 11:07:55 -0700
Message-ID: <20241022180839.2712439-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
In-Reply-To: <20241022180839.2712439-1-bvanassche@acm.org>
References: <20241022180839.2712439-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The only difference between the .sdev_configure() and .slave_configure()
methods is that the former accepts an additional 'limits' argument.
Convert all SCSI drivers that define a .slave_configure() method to
.sdev_configure(). This patch prepares for removing the
.slave_configure() method. No functionality has been changed.

Acked-by: Geoff Levand <geoff@infradead.org> # for ps3rom
Acked-by: Khalid Aziz <khalid@gonehiking.org> # for the BusLogic driver
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c   |  5 +++--
 drivers/message/fusion/mptfc.c        |  2 +-
 drivers/message/fusion/mptsas.c       |  6 +++---
 drivers/message/fusion/mptscsih.c     |  4 ++--
 drivers/message/fusion/mptscsih.h     |  3 ++-
 drivers/message/fusion/mptspi.c       |  7 ++++---
 drivers/s390/scsi/zfcp_scsi.c         |  5 +++--
 drivers/scsi/3w-9xxx.c                |  7 ++++---
 drivers/scsi/3w-sas.c                 |  7 ++++---
 drivers/scsi/3w-xxxx.c                |  8 ++++----
 drivers/scsi/53c700.c                 |  7 ++++---
 drivers/scsi/BusLogic.c               |  7 ++++---
 drivers/scsi/BusLogic.h               |  3 ++-
 drivers/scsi/aacraid/linit.c          |  8 +++++---
 drivers/scsi/advansys.c               | 23 ++++++++++++-----------
 drivers/scsi/aic7xxx/aic79xx_osm.c    |  4 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |  4 ++--
 drivers/scsi/arcmsr/arcmsr_hba.c      |  8 +++++---
 drivers/scsi/bfa/bfad_im.c            |  6 +++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c     |  5 +++--
 drivers/scsi/csiostor/csio_scsi.c     |  6 +++---
 drivers/scsi/esp_scsi.c               |  6 +++---
 drivers/scsi/hpsa.c                   |  8 +++++---
 drivers/scsi/ibmvscsi/ibmvfc.c        |  8 +++++---
 drivers/scsi/ibmvscsi/ibmvscsi.c      |  8 +++++---
 drivers/scsi/ips.c                    |  6 +++---
 drivers/scsi/ips.h                    |  3 ++-
 drivers/scsi/lpfc/lpfc_scsi.c         | 21 ++++++++++++++-------
 drivers/scsi/mvumi.c                  |  5 +++--
 drivers/scsi/myrb.c                   |  5 +++--
 drivers/scsi/myrs.c                   |  5 +++--
 drivers/scsi/ncr53c8xx.c              |  5 +++--
 drivers/scsi/ps3rom.c                 |  5 +++--
 drivers/scsi/qedf/qedf_main.c         |  5 +++--
 drivers/scsi/qla1280.c                |  6 +++---
 drivers/scsi/qla2xxx/qla_os.c         |  4 ++--
 drivers/scsi/qlogicpti.c              |  5 +++--
 drivers/scsi/scsi_debug.c             |  9 +++++----
 drivers/scsi/scsi_scan.c              |  2 +-
 drivers/scsi/smartpqi/smartpqi_init.c |  5 +++--
 drivers/scsi/snic/snic_main.c         |  6 +++---
 drivers/scsi/stex.c                   |  4 ++--
 drivers/scsi/storvsc_drv.c            |  5 +++--
 drivers/scsi/sym53c8xx_2/sym_glue.c   |  5 +++--
 drivers/scsi/xen-scsifront.c          |  7 ++++---
 drivers/staging/rts5208/rtsx.c        |  4 ++--
 46 files changed, 164 insertions(+), 123 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp=
/srp/ib_srp.c
index 2916e77f589b..d17289803b99 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2844,7 +2844,8 @@ static int srp_target_alloc(struct scsi_target *sta=
rget)
 	return 0;
 }
=20
-static int srp_slave_configure(struct scsi_device *sdev)
+static int srp_sdev_configure(struct scsi_device *sdev,
+			      struct queue_limits *lim)
 {
 	struct Scsi_Host *shost =3D sdev->host;
 	struct srp_target_port *target =3D host_to_target(shost);
@@ -3067,7 +3068,7 @@ static const struct scsi_host_template srp_template=
 =3D {
 	.name				=3D "InfiniBand SRP initiator",
 	.proc_name			=3D DRV_NAME,
 	.target_alloc			=3D srp_target_alloc,
-	.slave_configure		=3D srp_slave_configure,
+	.sdev_configure			=3D srp_sdev_configure,
 	.info				=3D srp_target_info,
 	.init_cmd_priv			=3D srp_init_cmd_priv,
 	.exit_cmd_priv			=3D srp_exit_cmd_priv,
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptf=
c.c
index f034ebacf974..0933b5f7fd29 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -114,7 +114,7 @@ static const struct scsi_host_template mptfc_driver_t=
emplate =3D {
 	.queuecommand			=3D mptfc_qcmd,
 	.target_alloc			=3D mptfc_target_alloc,
 	.sdev_init			=3D mptfc_sdev_init,
-	.slave_configure		=3D mptscsih_slave_configure,
+	.sdev_configure			=3D mptscsih_sdev_configure,
 	.target_destroy			=3D mptfc_target_destroy,
 	.sdev_destroy			=3D mptscsih_sdev_destroy,
 	.change_queue_depth 		=3D mptscsih_change_queue_depth,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mpt=
sas.c
index ea9d0e6e7f08..9d4984adc705 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1710,7 +1710,7 @@ mptsas_firmware_event_work(struct work_struct *work=
)
=20
=20
 static int
-mptsas_slave_configure(struct scsi_device *sdev)
+mptsas_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim=
)
 {
 	struct Scsi_Host	*host =3D sdev->host;
 	MPT_SCSI_HOST	*hd =3D shost_priv(host);
@@ -1736,7 +1736,7 @@ mptsas_slave_configure(struct scsi_device *sdev)
 	mptsas_add_device_component_starget(ioc, scsi_target(sdev));
=20
  out:
-	return mptscsih_slave_configure(sdev);
+	return mptscsih_sdev_configure(sdev, lim);
 }
=20
 static int
@@ -2006,7 +2006,7 @@ static const struct scsi_host_template mptsas_drive=
r_template =3D {
 	.queuecommand			=3D mptsas_qcmd,
 	.target_alloc			=3D mptsas_target_alloc,
 	.sdev_init			=3D mptsas_sdev_init,
-	.slave_configure		=3D mptsas_slave_configure,
+	.sdev_configure			=3D mptsas_sdev_configure,
 	.target_destroy			=3D mptsas_target_destroy,
 	.sdev_destroy			=3D mptscsih_sdev_destroy,
 	.change_queue_depth 		=3D mptscsih_change_queue_depth,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/m=
ptscsih.c
index 50ea4ee65d5c..a9604ba3c805 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2399,7 +2399,7 @@ mptscsih_change_queue_depth(struct scsi_device *sde=
v, int qdepth)
  *	Return non-zero if fails.
  */
 int
-mptscsih_slave_configure(struct scsi_device *sdev)
+mptscsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *l=
im)
 {
 	struct Scsi_Host	*sh =3D sdev->host;
 	VirtTarget		*vtarget;
@@ -3303,7 +3303,7 @@ EXPORT_SYMBOL(mptscsih_show_info);
 EXPORT_SYMBOL(mptscsih_info);
 EXPORT_SYMBOL(mptscsih_qcmd);
 EXPORT_SYMBOL(mptscsih_sdev_destroy);
-EXPORT_SYMBOL(mptscsih_slave_configure);
+EXPORT_SYMBOL(mptscsih_sdev_configure);
 EXPORT_SYMBOL(mptscsih_abort);
 EXPORT_SYMBOL(mptscsih_dev_reset);
 EXPORT_SYMBOL(mptscsih_target_reset);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/m=
ptscsih.h
index 9f1cde8e76a8..ece451c575e1 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -117,7 +117,8 @@ extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt);
 extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel=
,
 	u8 id, u64 lun, int ctx2abort, ulong timeout);
 extern void mptscsih_sdev_destroy(struct scsi_device *device);
-extern int mptscsih_slave_configure(struct scsi_device *device);
+extern int mptscsih_sdev_configure(struct scsi_device *device,
+				   struct queue_limits *lim);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mpt=
spi.c
index 09828c34f8fb..6833013a6ba2 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -746,7 +746,8 @@ static int mptspi_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
=20
-static int mptspi_slave_configure(struct scsi_device *sdev)
+static int mptspi_sdev_configure(struct scsi_device *sdev,
+				 struct queue_limits *lim)
 {
 	struct _MPT_SCSI_HOST *hd =3D shost_priv(sdev->host);
 	VirtTarget *vtarget =3D scsi_target(sdev)->hostdata;
@@ -754,7 +755,7 @@ static int mptspi_slave_configure(struct scsi_device =
*sdev)
=20
 	mptspi_initTarget(hd, vtarget, sdev);
=20
-	ret =3D mptscsih_slave_configure(sdev);
+	ret =3D mptscsih_sdev_configure(sdev, lim);
=20
 	if (ret)
 		return ret;
@@ -829,7 +830,7 @@ static const struct scsi_host_template mptspi_driver_=
template =3D {
 	.queuecommand			=3D mptspi_qcmd,
 	.target_alloc			=3D mptspi_target_alloc,
 	.sdev_init			=3D mptspi_sdev_init,
-	.slave_configure		=3D mptspi_slave_configure,
+	.sdev_configure			=3D mptspi_sdev_configure,
 	.target_destroy			=3D mptspi_target_destroy,
 	.sdev_destroy			=3D mptspi_sdev_destroy,
 	.change_queue_depth 		=3D mptscsih_change_queue_depth,
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.=
c
index c9cb9db8c2ee..b31f860af47b 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -49,7 +49,8 @@ static void zfcp_scsi_sdev_destroy(struct scsi_device *=
sdev)
 	put_device(&zfcp_sdev->port->dev);
 }
=20
-static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
+static int zfcp_scsi_sdev_configure(struct scsi_device *sdp,
+				    struct queue_limits *lim)
 {
 	if (sdp->tagged_supported)
 		scsi_change_queue_depth(sdp, default_depth);
@@ -428,7 +429,7 @@ static const struct scsi_host_template zfcp_scsi_host=
_template =3D {
 	.eh_target_reset_handler =3D zfcp_scsi_eh_target_reset_handler,
 	.eh_host_reset_handler	 =3D zfcp_scsi_eh_host_reset_handler,
 	.sdev_init		 =3D zfcp_scsi_sdev_init,
-	.slave_configure	 =3D zfcp_scsi_slave_configure,
+	.sdev_configure		 =3D zfcp_scsi_sdev_configure,
 	.sdev_destroy		 =3D zfcp_scsi_sdev_destroy,
 	.change_queue_depth	 =3D scsi_change_queue_depth,
 	.host_reset		 =3D zfcp_scsi_sysfs_host_reset,
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 6fb61c88ea11..97bcdf84386d 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1968,13 +1968,14 @@ static char *twa_string_lookup(twa_message_type *=
table, unsigned int code)
 } /* End twa_string_lookup() */
=20
 /* This function gets called when a disk is coming on-line */
-static int twa_slave_configure(struct scsi_device *sdev)
+static int twa_sdev_configure(struct scsi_device *sdev,
+			      struct queue_limits *lim)
 {
 	/* Force 60 second timeout */
 	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
=20
 	return 0;
-} /* End twa_slave_configure() */
+} /* End twa_sdev_configure() */
=20
 static const struct scsi_host_template driver_template =3D {
 	.module			=3D THIS_MODULE,
@@ -1984,7 +1985,7 @@ static const struct scsi_host_template driver_templ=
ate =3D {
 	.bios_param		=3D twa_scsi_biosparam,
 	.change_queue_depth	=3D scsi_change_queue_depth,
 	.can_queue		=3D TW_Q_LENGTH-2,
-	.slave_configure	=3D twa_slave_configure,
+	.sdev_configure		=3D twa_sdev_configure,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D TW_APACHE_MAX_SGL_LENGTH,
 	.max_sectors		=3D TW_MAX_SECTORS,
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index caa6713a62a4..8ed7126d82bb 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1523,13 +1523,14 @@ static void twl_shutdown(struct pci_dev *pdev)
 } /* End twl_shutdown() */
=20
 /* This function configures unit settings when a unit is coming on-line =
*/
-static int twl_slave_configure(struct scsi_device *sdev)
+static int twl_sdev_configure(struct scsi_device *sdev,
+			      struct queue_limits *lim)
 {
 	/* Force 60 second timeout */
 	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
=20
 	return 0;
-} /* End twl_slave_configure() */
+} /* End twl_sdev_configure() */
=20
 static const struct scsi_host_template driver_template =3D {
 	.module			=3D THIS_MODULE,
@@ -1539,7 +1540,7 @@ static const struct scsi_host_template driver_templ=
ate =3D {
 	.bios_param		=3D twl_scsi_biosparam,
 	.change_queue_depth	=3D scsi_change_queue_depth,
 	.can_queue		=3D TW_Q_LENGTH-2,
-	.slave_configure	=3D twl_slave_configure,
+	.sdev_configure		=3D twl_sdev_configure,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D TW_LIBERATOR_MAX_SGL_LENGTH,
 	.max_sectors		=3D TW_MAX_SECTORS,
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 2c0fb6da0e60..82fb9dc8dac9 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -172,7 +172,7 @@
                  Initialize queues correctly when loading with no valid =
units.
    1.02.00.034 - Fix tw_decode_bits() to handle multiple errors.
                  Add support for user configurable cmd_per_lun.
-                 Add support for sht->slave_configure().
+                 Add support for sht->sdev_configure().
    1.02.00.035 - Improve tw_allocate_memory() memory allocation.
                  Fix tw_chrdev_ioctl() to sleep correctly.
    1.02.00.036 - Increase character ioctl timeout to 60 seconds.
@@ -2221,13 +2221,13 @@ static void tw_shutdown(struct pci_dev *pdev)
 } /* End tw_shutdown() */
=20
 /* This function gets called when a disk is coming online */
-static int tw_slave_configure(struct scsi_device *sdev)
+static int tw_sdev_configure(struct scsi_device *sdev, struct queue_limi=
ts *lim)
 {
 	/* Force 60 second timeout */
 	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
=20
 	return 0;
-} /* End tw_slave_configure() */
+} /* End tw_sdev_configure() */
=20
 static const struct scsi_host_template driver_template =3D {
 	.module			=3D THIS_MODULE,
@@ -2237,7 +2237,7 @@ static const struct scsi_host_template driver_templ=
ate =3D {
 	.bios_param		=3D tw_scsi_biosparam,
 	.change_queue_depth	=3D scsi_change_queue_depth,
 	.can_queue		=3D TW_Q_LENGTH-2,
-	.slave_configure	=3D tw_slave_configure,
+	.sdev_configure		=3D tw_sdev_configure,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D TW_MAX_SGL_LENGTH,
 	.max_sectors		=3D TW_MAX_SECTORS,
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 71c1d25f93b1..71b7ac027f48 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -159,7 +159,8 @@ STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpn=
t);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_sdev_init(struct scsi_device *SDpnt);
-STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
+STATIC int NCR_700_sdev_configure(struct scsi_device *SDpnt,
+				  struct queue_limits *lim);
 STATIC void NCR_700_sdev_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int dep=
th);
=20
@@ -330,7 +331,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	tpnt->can_queue =3D NCR_700_COMMAND_SLOTS_PER_HOST;
 	tpnt->sg_tablesize =3D NCR_700_SG_SEGMENTS;
 	tpnt->cmd_per_lun =3D NCR_700_CMD_PER_LUN;
-	tpnt->slave_configure =3D NCR_700_slave_configure;
+	tpnt->sdev_configure =3D NCR_700_sdev_configure;
 	tpnt->sdev_destroy =3D NCR_700_sdev_destroy;
 	tpnt->sdev_init =3D NCR_700_sdev_init;
 	tpnt->change_queue_depth =3D NCR_700_change_queue_depth;
@@ -2029,7 +2030,7 @@ NCR_700_sdev_init(struct scsi_device *SDp)
 }
=20
 STATIC int
-NCR_700_slave_configure(struct scsi_device *SDp)
+NCR_700_sdev_configure(struct scsi_device *SDp, struct queue_limits *lim=
)
 {
 	struct NCR_700_Host_Parameters *hostdata =3D=20
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 2135a2b3e2d0..d04b5feec2eb 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2153,14 +2153,15 @@ static void __init blogic_inithoststruct(struct b=
logic_adapter *adapter,
 }
=20
 /*
-  blogic_slaveconfig will actually set the queue depth on individual
+  blogic_sdev_configure will actually set the queue depth on individual
   scsi devices as they are permanently added to the device chain.  We
   shamelessly rip off the SelectQueueDepths code to make this work mostl=
y
   like it used to.  Since we don't get called once at the end of the sca=
n
   but instead get called for each device, we have to do things a bit
   differently.
 */
-static int blogic_slaveconfig(struct scsi_device *dev)
+static int blogic_sdev_configure(struct scsi_device *dev,
+				 struct queue_limits *lim)
 {
 	struct blogic_adapter *adapter =3D
 		(struct blogic_adapter *) dev->host->hostdata;
@@ -3672,7 +3673,7 @@ static const struct scsi_host_template blogic_templ=
ate =3D {
 	.name =3D "BusLogic",
 	.info =3D blogic_drvr_info,
 	.queuecommand =3D blogic_qcmd,
-	.slave_configure =3D blogic_slaveconfig,
+	.sdev_configure =3D blogic_sdev_configure,
 	.bios_param =3D blogic_diskparam,
 	.eh_host_reset_handler =3D blogic_hostreset,
 #if 0
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 7d1ec10f2430..61bf26d4fc10 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1274,7 +1274,8 @@ static inline void blogic_incszbucket(unsigned int =
*cmdsz_buckets,
 static const char *blogic_drvr_info(struct Scsi_Host *);
 static int blogic_qcmd(struct Scsi_Host *h, struct scsi_cmnd *);
 static int blogic_diskparam(struct scsi_device *, struct block_device *,=
 sector_t, int *);
-static int blogic_slaveconfig(struct scsi_device *);
+static int blogic_sdev_configure(struct scsi_device *,
+				 struct queue_limits *lim);
 static void blogic_qcompleted_ccb(struct blogic_ccb *);
 static irqreturn_t blogic_inthandler(int, void *);
 static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset)=
;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 68f4dbcfff49..91170a67cc91 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -377,15 +377,17 @@ static int aac_biosparm(struct scsi_device *sdev, s=
truct block_device *bdev,
 }
=20
 /**
- *	aac_slave_configure		-	compute queue depths
+ *	aac_sdev_configure		-	compute queue depths
  *	@sdev:	SCSI device we are considering
+ *	@lim:	Request queue limits
  *
  *	Selects queue depths for each target device based on the host adapter=
's
  *	total capacity and the queue depth supported by the target device.
  *	A queue depth of one automatically disables tagged queueing.
  */
=20
-static int aac_slave_configure(struct scsi_device *sdev)
+static int aac_sdev_configure(struct scsi_device *sdev,
+			      struct queue_limits *lim)
 {
 	struct aac_dev *aac =3D (struct aac_dev *)sdev->host->hostdata;
 	int chn, tid;
@@ -1487,7 +1489,7 @@ static const struct scsi_host_template aac_driver_t=
emplate =3D {
 	.queuecommand			=3D aac_queuecommand,
 	.bios_param			=3D aac_biosparm,
 	.shost_groups			=3D aac_host_groups,
-	.slave_configure		=3D aac_slave_configure,
+	.sdev_configure			=3D aac_sdev_configure,
 	.change_queue_depth		=3D aac_change_queue_depth,
 	.sdev_groups			=3D aac_dev_groups,
 	.eh_abort_handler		=3D aac_eh_abort,
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index fd4fcb37863d..8fededa1a751 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4496,7 +4496,7 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dv=
c)
=20
 	/*
 	 * Microcode operating variables for WDTR, SDTR, and command tag
-	 * queuing will be set in slave_configure() based on what a
+	 * queuing will be set in sdev_configure() based on what a
 	 * device reports it is capable of in Inquiry byte 7.
 	 *
 	 * If SCSI Bus Resets have been disabled, then directly set
@@ -5013,7 +5013,7 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc=
_dvc)
=20
 	/*
 	 * Microcode operating variables for WDTR, SDTR, and command tag
-	 * queuing will be set in slave_configure() based on what a
+	 * queuing will be set in sdev_configure() based on what a
 	 * device reports it is capable of in Inquiry byte 7.
 	 *
 	 * If SCSI Bus Resets have been disabled, then directly set
@@ -5508,7 +5508,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc=
_dvc)
=20
 	/*
 	 * Microcode operating variables for WDTR, SDTR, and command tag
-	 * queuing will be set in slave_configure() based on what a
+	 * queuing will be set in sdev_configure() based on what a
 	 * device reports it is capable of in Inquiry byte 7.
 	 *
 	 * If SCSI Bus Resets have been disabled, then directly set
@@ -7219,7 +7219,7 @@ static void AscAsyncFix(ASC_DVC_VAR *asc_dvc, struc=
t scsi_device *sdev)
 }
=20
 static void
-advansys_narrow_slave_configure(struct scsi_device *sdev, ASC_DVC_VAR *a=
sc_dvc)
+advansys_narrow_sdev_configure(struct scsi_device *sdev, ASC_DVC_VAR *as=
c_dvc)
 {
 	ASC_SCSI_BIT_ID_TYPE tid_bit =3D 1 << sdev->id;
 	ASC_SCSI_BIT_ID_TYPE orig_use_tagged_qng =3D asc_dvc->use_tagged_qng;
@@ -7345,7 +7345,7 @@ static void advansys_wide_enable_ppr(ADV_DVC_VAR *a=
dv_dvc,
 }
=20
 static void
-advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv=
_dvc)
+advansys_wide_sdev_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_=
dvc)
 {
 	AdvPortAddr iop_base =3D adv_dvc->iop_base;
 	unsigned short tidmask =3D 1 << sdev->id;
@@ -7391,16 +7391,17 @@ advansys_wide_slave_configure(struct scsi_device =
*sdev, ADV_DVC_VAR *adv_dvc)
  * Set the number of commands to queue per device for the
  * specified host adapter.
  */
-static int advansys_slave_configure(struct scsi_device *sdev)
+static int advansys_sdev_configure(struct scsi_device *sdev,
+				   struct queue_limits *lim)
 {
 	struct asc_board *boardp =3D shost_priv(sdev->host);
=20
 	if (ASC_NARROW_BOARD(boardp))
-		advansys_narrow_slave_configure(sdev,
-						&boardp->dvc_var.asc_dvc_var);
+		advansys_narrow_sdev_configure(sdev,
+					       &boardp->dvc_var.asc_dvc_var);
 	else
-		advansys_wide_slave_configure(sdev,
-						&boardp->dvc_var.adv_dvc_var);
+		advansys_wide_sdev_configure(sdev,
+					     &boardp->dvc_var.adv_dvc_var);
=20
 	return 0;
 }
@@ -10612,7 +10613,7 @@ static const struct scsi_host_template advansys_t=
emplate =3D {
 	.queuecommand =3D advansys_queuecommand,
 	.eh_host_reset_handler =3D advansys_reset,
 	.bios_param =3D advansys_biosparam,
-	.slave_configure =3D advansys_slave_configure,
+	.sdev_configure =3D advansys_sdev_configure,
 	.cmd_size =3D sizeof(struct advansys_cmd),
 };
=20
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/ai=
c79xx_osm.c
index 2a137629e48d..17dfc3c72110 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -701,7 +701,7 @@ ahd_linux_sdev_init(struct scsi_device *sdev)
 }
=20
 static int
-ahd_linux_slave_configure(struct scsi_device *sdev)
+ahd_linux_sdev_configure(struct scsi_device *sdev, struct queue_limits *=
lim)
 {
 	if (bootverbose)
 		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
@@ -907,7 +907,7 @@ struct scsi_host_template aic79xx_driver_template =3D=
 {
 	.max_sectors		=3D 8192,
 	.cmd_per_lun		=3D 2,
 	.sdev_init		=3D ahd_linux_sdev_init,
-	.slave_configure	=3D ahd_linux_slave_configure,
+	.sdev_configure		=3D ahd_linux_sdev_configure,
 	.target_alloc		=3D ahd_linux_target_alloc,
 	.target_destroy		=3D ahd_linux_target_destroy,
 };
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/ai=
c7xxx_osm.c
index 9066ab2ef6e3..cebf8c5d0caf 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -664,7 +664,7 @@ ahc_linux_sdev_init(struct scsi_device *sdev)
 }
=20
 static int
-ahc_linux_slave_configure(struct scsi_device *sdev)
+ahc_linux_sdev_configure(struct scsi_device *sdev, struct queue_limits *=
lim)
 {
 	if (bootverbose)
 		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
@@ -792,7 +792,7 @@ struct scsi_host_template aic7xxx_driver_template =3D=
 {
 	.max_sectors		=3D 8192,
 	.cmd_per_lun		=3D 2,
 	.sdev_init		=3D ahc_linux_sdev_init,
-	.slave_configure	=3D ahc_linux_slave_configure,
+	.sdev_configure		=3D ahc_linux_sdev_configure,
 	.target_alloc		=3D ahc_linux_target_alloc,
 	.target_destroy		=3D ahc_linux_target_destroy,
 };
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcms=
r_hba.c
index 35860c61468b..6a32e3e0d516 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -143,7 +143,8 @@ static irqreturn_t arcmsr_interrupt(struct AdapterCon=
trolBlock *acb);
 static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock=
 *);
 static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb);
 static void arcmsr_set_iop_datetime(struct timer_list *);
-static int arcmsr_slave_config(struct scsi_device *sdev);
+static int arcmsr_sdev_configure(struct scsi_device *sdev,
+				 struct queue_limits *lim);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int =
queue_depth)
 {
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
@@ -160,7 +161,7 @@ static const struct scsi_host_template arcmsr_scsi_ho=
st_template =3D {
 	.eh_abort_handler	=3D arcmsr_abort,
 	.eh_bus_reset_handler	=3D arcmsr_bus_reset,
 	.bios_param		=3D arcmsr_bios_param,
-	.slave_configure	=3D arcmsr_slave_config,
+	.sdev_configure		=3D arcmsr_sdev_configure,
 	.change_queue_depth	=3D arcmsr_adjust_disk_queue_depth,
 	.can_queue		=3D ARCMSR_DEFAULT_OUTSTANDING_CMD,
 	.this_id		=3D ARCMSR_SCSI_INITIATOR_ID,
@@ -3344,7 +3345,8 @@ static int arcmsr_queue_command_lck(struct scsi_cmn=
d *cmd)
=20
 static DEF_SCSI_QCMD(arcmsr_queue_command)
=20
-static int arcmsr_slave_config(struct scsi_device *sdev)
+static int arcmsr_sdev_configure(struct scsi_device *sdev,
+				 struct queue_limits *lim)
 {
 	unsigned int	dev_timeout;
=20
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 5729f429ed8b..a719a18f0fbc 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -783,7 +783,7 @@ bfad_thread_workq(struct bfad_s *bfad)
  * Return non-zero if fails.
  */
 static int
-bfad_im_slave_configure(struct scsi_device *sdev)
+bfad_im_sdev_configure(struct scsi_device *sdev, struct queue_limits *li=
m)
 {
 	scsi_change_queue_depth(sdev, bfa_lun_queue_depth);
 	return 0;
@@ -801,7 +801,7 @@ struct scsi_host_template bfad_im_scsi_host_template =
=3D {
 	.eh_target_reset_handler =3D bfad_im_reset_target_handler,
=20
 	.sdev_init =3D bfad_im_sdev_init,
-	.slave_configure =3D bfad_im_slave_configure,
+	.sdev_configure =3D bfad_im_sdev_configure,
 	.sdev_destroy =3D bfad_im_sdev_destroy,
=20
 	.this_id =3D -1,
@@ -824,7 +824,7 @@ struct scsi_host_template bfad_im_vport_template =3D =
{
 	.eh_target_reset_handler =3D bfad_im_reset_target_handler,
=20
 	.sdev_init =3D bfad_im_sdev_init,
-	.slave_configure =3D bfad_im_slave_configure,
+	.sdev_configure =3D bfad_im_sdev_configure,
 	.sdev_destroy =3D bfad_im_sdev_destroy,
=20
 	.this_id =3D -1,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2=
fc_fcoe.c
index 938e38a01326..d75472622337 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2652,7 +2652,8 @@ static int bnx2fc_cpu_offline(unsigned int cpu)
 	return 0;
 }
=20
-static int bnx2fc_slave_configure(struct scsi_device *sdev)
+static int bnx2fc_sdev_configure(struct scsi_device *sdev,
+				 struct queue_limits *lim)
 {
 	if (!bnx2fc_queue_depth)
 		return 0;
@@ -2959,7 +2960,7 @@ static struct scsi_host_template bnx2fc_shost_templ=
ate =3D {
 	.dma_boundary           =3D 0x7fff,
 	.max_sectors		=3D 0x3fbf,
 	.track_queue_depth	=3D 1,
-	.slave_configure	=3D bnx2fc_slave_configure,
+	.sdev_configure		=3D bnx2fc_sdev_configure,
 	.shost_groups		=3D bnx2fc_host_groups,
 	.cmd_size		=3D sizeof(struct bnx2fc_priv),
 };
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/cs=
io_scsi.c
index fb6b0c8e22e0..36d31c31c8e4 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2237,7 +2237,7 @@ csio_sdev_init(struct scsi_device *sdev)
 }
=20
 static int
-csio_slave_configure(struct scsi_device *sdev)
+csio_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 {
 	scsi_change_queue_depth(sdev, csio_lun_qdepth);
 	return 0;
@@ -2277,7 +2277,7 @@ struct scsi_host_template csio_fcoe_shost_template =
=3D {
 	.eh_abort_handler	=3D csio_eh_abort_handler,
 	.eh_device_reset_handler =3D csio_eh_lun_reset_handler,
 	.sdev_init		=3D csio_sdev_init,
-	.slave_configure	=3D csio_slave_configure,
+	.sdev_configure		=3D csio_sdev_configure,
 	.sdev_destroy		=3D csio_sdev_destroy,
 	.scan_finished		=3D csio_scan_finished,
 	.this_id		=3D -1,
@@ -2296,7 +2296,7 @@ struct scsi_host_template csio_fcoe_shost_vport_tem=
plate =3D {
 	.eh_abort_handler	=3D csio_eh_abort_handler,
 	.eh_device_reset_handler =3D csio_eh_lun_reset_handler,
 	.sdev_init		=3D csio_sdev_init,
-	.slave_configure	=3D csio_slave_configure,
+	.sdev_configure		=3D csio_sdev_configure,
 	.sdev_destroy		=3D csio_sdev_destroy,
 	.scan_finished		=3D csio_scan_finished,
 	.this_id		=3D -1,
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index d14a3383abb0..802718ffad84 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2261,7 +2261,7 @@ static void esp_init_swstate(struct esp *esp)
 	INIT_LIST_HEAD(&esp->active_cmds);
 	INIT_LIST_HEAD(&esp->esp_cmd_pool);
=20
-	/* Start with a clear state, domain validation (via ->slave_configure,
+	/* Start with a clear state, domain validation (via ->sdev_configure,
 	 * spi_dv_device()) will attempt to enable SYNC, WIDE, and tagged
 	 * commands.
 	 */
@@ -2463,7 +2463,7 @@ static int esp_sdev_init(struct scsi_device *dev)
 	return 0;
 }
=20
-static int esp_slave_configure(struct scsi_device *dev)
+static int esp_sdev_configure(struct scsi_device *dev, struct queue_limi=
ts *lim)
 {
 	struct esp *esp =3D shost_priv(dev->host);
 	struct esp_target_data *tp =3D &esp->target[dev->id];
@@ -2668,7 +2668,7 @@ const struct scsi_host_template scsi_esp_template =3D=
 {
 	.target_alloc		=3D esp_target_alloc,
 	.target_destroy		=3D esp_target_destroy,
 	.sdev_init		=3D esp_sdev_init,
-	.slave_configure	=3D esp_slave_configure,
+	.sdev_configure		=3D esp_sdev_configure,
 	.sdev_destroy		=3D esp_sdev_destroy,
 	.eh_abort_handler	=3D esp_eh_abort_handler,
 	.eh_bus_reset_handler	=3D esp_eh_bus_reset_handler,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index eccdec143ad8..56b122cda86c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -284,7 +284,8 @@ static int hpsa_change_queue_depth(struct scsi_device=
 *sdev, int qdepth);
=20
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
 static int hpsa_sdev_init(struct scsi_device *sdev);
-static int hpsa_slave_configure(struct scsi_device *sdev);
+static int hpsa_sdev_configure(struct scsi_device *sdev,
+			       struct queue_limits *lim);
 static void hpsa_sdev_destroy(struct scsi_device *sdev);
=20
 static void hpsa_update_scsi_devices(struct ctlr_info *h);
@@ -979,7 +980,7 @@ static const struct scsi_host_template hpsa_driver_te=
mplate =3D {
 	.eh_device_reset_handler =3D hpsa_eh_device_reset_handler,
 	.ioctl			=3D hpsa_ioctl,
 	.sdev_init		=3D hpsa_sdev_init,
-	.slave_configure	=3D hpsa_slave_configure,
+	.sdev_configure		=3D hpsa_sdev_configure,
 	.sdev_destroy		=3D hpsa_sdev_destroy,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		=3D hpsa_compat_ioctl,
@@ -2142,7 +2143,8 @@ static int hpsa_sdev_init(struct scsi_device *sdev)
=20
 /* configure scsi device based on internal per-device structure */
 #define CTLR_TIMEOUT (120 * HZ)
-static int hpsa_slave_configure(struct scsi_device *sdev)
+static int hpsa_sdev_configure(struct scsi_device *sdev,
+			       struct queue_limits *lim)
 {
 	struct hpsa_scsi_dev_t *sd;
 	int queue_depth;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
index 48417615bffe..ee606db81874 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3441,8 +3441,9 @@ static int ibmvfc_target_alloc(struct scsi_target *=
starget)
 }
=20
 /**
- * ibmvfc_slave_configure - Configure the device
+ * ibmvfc_sdev_configure - Configure the device
  * @sdev:	struct scsi_device device to configure
+ * @lim:	Request queue limits
  *
  * Enable allow_restart for a device if it is a disk. Adjust the
  * queue_depth here also.
@@ -3450,7 +3451,8 @@ static int ibmvfc_target_alloc(struct scsi_target *=
starget)
  * Returns:
  *	0
  **/
-static int ibmvfc_slave_configure(struct scsi_device *sdev)
+static int ibmvfc_sdev_configure(struct scsi_device *sdev,
+				 struct queue_limits *lim)
 {
 	struct Scsi_Host *shost =3D sdev->host;
 	unsigned long flags =3D 0;
@@ -3697,7 +3699,7 @@ static const struct scsi_host_template driver_templ=
ate =3D {
 	.eh_target_reset_handler =3D ibmvfc_eh_target_reset_handler,
 	.eh_host_reset_handler =3D ibmvfc_eh_host_reset_handler,
 	.sdev_init =3D ibmvfc_sdev_init,
-	.slave_configure =3D ibmvfc_slave_configure,
+	.sdev_configure =3D ibmvfc_sdev_configure,
 	.target_alloc =3D ibmvfc_target_alloc,
 	.scan_finished =3D ibmvfc_scan_finished,
 	.change_queue_depth =3D ibmvfc_change_queue_depth,
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibm=
vscsi.c
index 71f3e9563520..16a1aac11911 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1860,14 +1860,16 @@ static void ibmvscsi_handle_crq(struct viosrp_crq=
 *crq,
 }
=20
 /**
- * ibmvscsi_slave_configure: Set the "allow_restart" flag for each disk.
+ * ibmvscsi_sdev_configure: Set the "allow_restart" flag for each disk.
  * @sdev:	struct scsi_device device to configure
+ * @lim:	Request queue limits
  *
  * Enable allow_restart for a device if it is a disk.  Adjust the
  * queue_depth here also as is required by the documentation for
  * struct scsi_host_template.
  */
-static int ibmvscsi_slave_configure(struct scsi_device *sdev)
+static int ibmvscsi_sdev_configure(struct scsi_device *sdev,
+				   struct queue_limits *lim)
 {
 	struct Scsi_Host *shost =3D sdev->host;
 	unsigned long lock_flags =3D 0;
@@ -2091,7 +2093,7 @@ static struct scsi_host_template driver_template =3D=
 {
 	.eh_abort_handler =3D ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler =3D ibmvscsi_eh_device_reset_handler,
 	.eh_host_reset_handler =3D ibmvscsi_eh_host_reset_handler,
-	.slave_configure =3D ibmvscsi_slave_configure,
+	.sdev_configure =3D ibmvscsi_sdev_configure,
 	.change_queue_depth =3D ibmvscsi_change_queue_depth,
 	.host_reset =3D ibmvscsi_host_reset,
 	.cmd_per_lun =3D IBMVSCSI_CMDS_PER_LUN_DEFAULT,
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 10cf5775a939..cce6c6b409ad 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -364,7 +364,7 @@ static struct scsi_host_template ips_driver_template =
=3D {
 	.proc_name		=3D "ips",
 	.show_info		=3D ips_show_info,
 	.write_info		=3D ips_write_info,
-	.slave_configure	=3D ips_slave_configure,
+	.sdev_configure		=3D ips_sdev_configure,
 	.bios_param		=3D ips_biosparam,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D IPS_MAX_SG,
@@ -1166,7 +1166,7 @@ static int ips_biosparam(struct scsi_device *sdev, =
struct block_device *bdev,
=20
 /***********************************************************************=
*****/
 /*                                                                      =
    */
-/* Routine Name: ips_slave_configure                                    =
    */
+/* Routine Name: ips_sdev_configure                                     =
    */
 /*                                                                      =
    */
 /* Routine Description:                                                 =
    */
 /*                                                                      =
    */
@@ -1174,7 +1174,7 @@ static int ips_biosparam(struct scsi_device *sdev, =
struct block_device *bdev,
 /*                                                                      =
    */
 /***********************************************************************=
*****/
 static int
-ips_slave_configure(struct scsi_device * SDptr)
+ips_sdev_configure(struct scsi_device *SDptr, struct queue_limits *lim)
 {
 	ips_ha_t *ha;
 	int min;
diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
index 65edf000e447..8ac932ec4444 100644
--- a/drivers/scsi/ips.h
+++ b/drivers/scsi/ips.h
@@ -400,7 +400,8 @@
     */
    static int ips_biosparam(struct scsi_device *sdev, struct block_devic=
e *bdev,
 		sector_t capacity, int geom[]);
-   static int ips_slave_configure(struct scsi_device *SDptr);
+   static int ips_sdev_configure(struct scsi_device *SDptr,
+				 struct queue_limits *lim);
=20
 /*
  * Raid Command Formats
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.=
c
index 3f408a47a36c..f3a48d722e69 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6342,8 +6342,9 @@ lpfc_sdev_init(struct scsi_device *sdev)
 }
=20
 /**
- * lpfc_slave_configure - scsi_host_template slave_configure entry point
+ * lpfc_sdev_configure - scsi_host_template sdev_configure entry point
  * @sdev: Pointer to scsi_device.
+ * @lim: Request queue limits.
  *
  * This routine configures following items
  *   - Tag command queuing support for @sdev if supported.
@@ -6353,7 +6354,7 @@ lpfc_sdev_init(struct scsi_device *sdev)
  *   0 - Success
  **/
 static int
-lpfc_slave_configure(struct scsi_device *sdev)
+lpfc_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 {
 	struct lpfc_vport *vport =3D (struct lpfc_vport *) sdev->host->hostdata=
;
 	struct lpfc_hba   *phba =3D vport->phba;
@@ -6737,7 +6738,13 @@ lpfc_no_command(struct Scsi_Host *shost, struct sc=
si_cmnd *cmnd)
 }
=20
 static int
-lpfc_no_sdev(struct scsi_device *sdev)
+lpfc_init_no_sdev(struct scsi_device *sdev)
+{
+	return -ENODEV;
+}
+
+static int
+lpfc_config_no_sdev(struct scsi_device *sdev, struct queue_limits *lim)
 {
 	return -ENODEV;
 }
@@ -6748,8 +6755,8 @@ struct scsi_host_template lpfc_template_nvme =3D {
 	.proc_name		=3D LPFC_DRIVER_NAME,
 	.info			=3D lpfc_info,
 	.queuecommand		=3D lpfc_no_command,
-	.sdev_init		=3D lpfc_no_sdev,
-	.slave_configure	=3D lpfc_no_sdev,
+	.sdev_init		=3D lpfc_init_no_sdev,
+	.sdev_configure		=3D lpfc_config_no_sdev,
 	.scan_finished		=3D lpfc_scan_finished,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D 1,
@@ -6773,7 +6780,7 @@ struct scsi_host_template lpfc_template =3D {
 	.eh_target_reset_handler =3D lpfc_target_reset_handler,
 	.eh_host_reset_handler  =3D lpfc_host_reset_handler,
 	.sdev_init		=3D lpfc_sdev_init,
-	.slave_configure	=3D lpfc_slave_configure,
+	.sdev_configure		=3D lpfc_sdev_configure,
 	.sdev_destroy		=3D lpfc_sdev_destroy,
 	.scan_finished		=3D lpfc_scan_finished,
 	.this_id		=3D -1,
@@ -6800,7 +6807,7 @@ struct scsi_host_template lpfc_vport_template =3D {
 	.eh_bus_reset_handler	=3D NULL,
 	.eh_host_reset_handler	=3D NULL,
 	.sdev_init		=3D lpfc_sdev_init,
-	.slave_configure	=3D lpfc_slave_configure,
+	.sdev_configure		=3D lpfc_sdev_configure,
 	.sdev_destroy		=3D lpfc_sdev_destroy,
 	.scan_finished		=3D lpfc_scan_finished,
 	.this_id		=3D -1,
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index d9d366ec17dc..96549e7f5705 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2000,7 +2000,8 @@ static struct mvumi_instance_template mvumi_instanc=
e_9580 =3D {
 	.reset_host =3D mvumi_reset_host_9580,
 };
=20
-static int mvumi_slave_configure(struct scsi_device *sdev)
+static int mvumi_sdev_configure(struct scsi_device *sdev,
+				struct queue_limits *lim)
 {
 	struct mvumi_hba *mhba;
 	unsigned char bitcount =3D sizeof(unsigned char) * 8;
@@ -2172,7 +2173,7 @@ static const struct scsi_host_template mvumi_templa=
te =3D {
=20
 	.module =3D THIS_MODULE,
 	.name =3D "Marvell Storage Controller",
-	.slave_configure =3D mvumi_slave_configure,
+	.sdev_configure =3D mvumi_sdev_configure,
 	.queuecommand =3D mvumi_queue_command,
 	.eh_timed_out =3D mvumi_timed_out,
 	.eh_host_reset_handler =3D mvumi_host_reset,
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 3586830c392c..762b718fd82f 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1715,7 +1715,8 @@ static int myrb_sdev_init(struct scsi_device *sdev)
 	return myrb_pdev_sdev_init(sdev);
 }
=20
-static int myrb_slave_configure(struct scsi_device *sdev)
+static int myrb_sdev_configure(struct scsi_device *sdev,
+			       struct queue_limits *lim)
 {
 	struct myrb_ldev_info *ldev_info;
=20
@@ -2209,7 +2210,7 @@ static const struct scsi_host_template myrb_templat=
e =3D {
 	.queuecommand		=3D myrb_queuecommand,
 	.eh_host_reset_handler	=3D myrb_host_reset,
 	.sdev_init		=3D myrb_sdev_init,
-	.slave_configure	=3D myrb_slave_configure,
+	.sdev_configure		=3D myrb_sdev_configure,
 	.sdev_destroy		=3D myrb_sdev_destroy,
 	.bios_param		=3D myrb_biosparam,
 	.cmd_size		=3D sizeof(struct myrb_cmdblk),
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 2d276e654c27..53e54f413c5c 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1882,7 +1882,8 @@ static int myrs_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
=20
-static int myrs_slave_configure(struct scsi_device *sdev)
+static int myrs_sdev_configure(struct scsi_device *sdev,
+			       struct queue_limits *lim)
 {
 	struct myrs_hba *cs =3D shost_priv(sdev->host);
 	struct myrs_ldev_info *ldev_info;
@@ -1922,7 +1923,7 @@ static const struct scsi_host_template myrs_templat=
e =3D {
 	.queuecommand		=3D myrs_queuecommand,
 	.eh_host_reset_handler	=3D myrs_host_reset,
 	.sdev_init		=3D myrs_sdev_init,
-	.slave_configure	=3D myrs_slave_configure,
+	.sdev_configure		=3D myrs_sdev_configure,
 	.sdev_destroy		=3D myrs_sdev_destroy,
 	.cmd_size		=3D sizeof(struct myrs_cmdblk),
 	.shost_groups		=3D myrs_shost_groups,
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 526411dff48f..a06b7d7ae96b 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -7796,7 +7796,8 @@ static int ncr53c8xx_sdev_init(struct scsi_device *=
device)
 	return 0;
 }
=20
-static int ncr53c8xx_slave_configure(struct scsi_device *device)
+static int ncr53c8xx_sdev_configure(struct scsi_device *device,
+				    struct queue_limits *lim)
 {
 	struct Scsi_Host *host =3D device->host;
 	struct ncb *np =3D ((struct host_data *) host->hostdata)->ncb;
@@ -8093,7 +8094,7 @@ struct Scsi_Host * __init ncr_attach(struct scsi_ho=
st_template *tpnt,
 		tpnt->shost_groups =3D ncr53c8xx_host_groups;
=20
 	tpnt->queuecommand	=3D ncr53c8xx_queue_command;
-	tpnt->slave_configure	=3D ncr53c8xx_slave_configure;
+	tpnt->sdev_configure	=3D ncr53c8xx_sdev_configure;
 	tpnt->sdev_init	=3D ncr53c8xx_sdev_init;
 	tpnt->eh_bus_reset_handler =3D ncr53c8xx_bus_reset;
 	tpnt->can_queue		=3D SCSI_NCR_CAN_QUEUE;
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 90495a832f34..92fe5c5c5bb0 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -61,7 +61,8 @@ enum lv1_atapi_in_out {
 };
=20
=20
-static int ps3rom_slave_configure(struct scsi_device *scsi_dev)
+static int ps3rom_sdev_configure(struct scsi_device *scsi_dev,
+				 struct queue_limits *lim)
 {
 	struct ps3rom_private *priv =3D shost_priv(scsi_dev->host);
 	struct ps3_storage_device *dev =3D priv->dev;
@@ -325,7 +326,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *da=
ta)
=20
 static const struct scsi_host_template ps3rom_host_template =3D {
 	.name =3D			DEVICE_NAME,
-	.slave_configure =3D	ps3rom_slave_configure,
+	.sdev_configure =3D	ps3rom_sdev_configure,
 	.queuecommand =3D		ps3rom_queuecommand,
 	.can_queue =3D		1,
 	.this_id =3D		7,
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
index df756f3eef3e..41bce7a7d6c2 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -982,7 +982,8 @@ static int qedf_eh_host_reset(struct scsi_cmnd *sc_cm=
d)
 	return SUCCESS;
 }
=20
-static int qedf_slave_configure(struct scsi_device *sdev)
+static int qedf_sdev_configure(struct scsi_device *sdev,
+			       struct queue_limits *lim)
 {
 	if (qedf_queue_depth) {
 		scsi_change_queue_depth(sdev, qedf_queue_depth);
@@ -1003,7 +1004,7 @@ static const struct scsi_host_template qedf_host_te=
mplate =3D {
 	.eh_device_reset_handler =3D qedf_eh_device_reset, /* lun reset */
 	.eh_target_reset_handler =3D qedf_eh_target_reset, /* target reset */
 	.eh_host_reset_handler  =3D qedf_eh_host_reset,
-	.slave_configure	=3D qedf_slave_configure,
+	.sdev_configure	=3D qedf_sdev_configure,
 	.dma_boundary =3D QED_HW_DMA_BOUNDARY,
 	.sg_tablesize =3D QEDF_MAX_BDS_PER_CMD,
 	.can_queue =3D FCOE_PARAMS_NUM_TASKS,
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8958547ac111..360867838abd 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1159,7 +1159,7 @@ qla1280_set_target_parameters(struct scsi_qla_host =
*ha, int bus, int target)
=20
=20
 /***********************************************************************=
***
- *   qla1280_slave_configure
+ *   qla1280_sdev_configure
  *
  * Description:
  *   Determines the queue depth for a given device.  There are two ways
@@ -1170,7 +1170,7 @@ qla1280_set_target_parameters(struct scsi_qla_host =
*ha, int bus, int target)
  *   default queue depth (dependent on the number of hardware SCBs).
  ***********************************************************************=
***/
 static int
-qla1280_slave_configure(struct scsi_device *device)
+qla1280_sdev_configure(struct scsi_device *device, struct queue_limits *=
lim)
 {
 	struct scsi_qla_host *ha;
 	int default_depth =3D 3;
@@ -4121,7 +4121,7 @@ static const struct scsi_host_template qla1280_driv=
er_template =3D {
 	.proc_name		=3D "qla1280",
 	.name			=3D "Qlogic ISP 1280/12160",
 	.info			=3D qla1280_info,
-	.slave_configure	=3D qla1280_slave_configure,
+	.sdev_configure		=3D qla1280_sdev_configure,
 	.queuecommand		=3D qla1280_queuecommand,
 	.eh_abort_handler	=3D qla1280_eh_abort,
 	.eh_device_reset_handler=3D qla1280_eh_device_reset,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
index 686e69d3ec98..6b7388cfc55e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1947,7 +1947,7 @@ qla2xxx_sdev_init(struct scsi_device *sdev)
 }
=20
 static int
-qla2xxx_slave_configure(struct scsi_device *sdev)
+qla2xxx_sdev_configure(struct scsi_device *sdev, struct queue_limits *li=
m)
 {
 	scsi_qla_host_t *vha =3D shost_priv(sdev->host);
 	struct req_que *req =3D vha->req;
@@ -8086,7 +8086,7 @@ struct scsi_host_template qla2xxx_driver_template =3D=
 {
 	.eh_bus_reset_handler	=3D qla2xxx_eh_bus_reset,
 	.eh_host_reset_handler	=3D qla2xxx_eh_host_reset,
=20
-	.slave_configure	=3D qla2xxx_slave_configure,
+	.sdev_configure		=3D qla2xxx_sdev_configure,
=20
 	.sdev_init		=3D qla2xxx_sdev_init,
 	.sdev_destroy		=3D qla2xxx_sdev_destroy,
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 6177f4798f3a..cc632c6b603a 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -975,7 +975,8 @@ static inline void update_can_queue(struct Scsi_Host =
*host, u_int in_ptr, u_int
 	host->sg_tablesize =3D QLOGICPTI_MAX_SG(num_free);
 }
=20
-static int qlogicpti_slave_configure(struct scsi_device *sdev)
+static int qlogicpti_sdev_configure(struct scsi_device *sdev,
+				    struct queue_limits *lim)
 {
 	struct qlogicpti *qpti =3D shost_priv(sdev->host);
 	int tgt =3D sdev->id;
@@ -1292,7 +1293,7 @@ static const struct scsi_host_template qpti_templat=
e =3D {
 	.name			=3D "qlogicpti",
 	.info			=3D qlogicpti_info,
 	.queuecommand		=3D qlogicpti_queuecommand,
-	.slave_configure	=3D qlogicpti_slave_configure,
+	.sdev_configure		=3D qlogicpti_sdev_configure,
 	.eh_abort_handler	=3D qlogicpti_abort,
 	.eh_host_reset_handler	=3D qlogicpti_reset,
 	.can_queue		=3D QLOGICPTI_REQ_QUEUE_LEN,
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8a0951245a94..36f34597b5e8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5890,14 +5890,15 @@ static int scsi_debug_sdev_init(struct scsi_devic=
e *sdp)
 	return 0;
 }
=20
-static int scsi_debug_slave_configure(struct scsi_device *sdp)
+static int scsi_debug_sdev_configure(struct scsi_device *sdp,
+				     struct queue_limits *lim)
 {
 	struct sdebug_dev_info *devip =3D
 			(struct sdebug_dev_info *)sdp->hostdata;
 	struct dentry *dentry;
=20
 	if (sdebug_verbose)
-		pr_info("slave_configure <%u %u %u %llu>\n",
+		pr_info("sdev_configure <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (sdp->host->max_cmd_len !=3D SDEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len =3D SDEBUG_MAX_CMD_LEN;
@@ -8715,8 +8716,8 @@ static struct scsi_host_template sdebug_driver_temp=
late =3D {
 	.name =3D			"SCSI DEBUG",
 	.info =3D			scsi_debug_info,
 	.sdev_init =3D		scsi_debug_sdev_init,
-	.slave_configure =3D	scsi_debug_slave_configure,
-	.sdev_destroy =3D	scsi_debug_sdev_destroy,
+	.sdev_configure =3D	scsi_debug_sdev_configure,
+	.sdev_destroy =3D		scsi_debug_sdev_destroy,
 	.ioctl =3D		scsi_debug_ioctl,
 	.queuecommand =3D		scsi_debug_queuecommand,
 	.change_queue_depth =3D	sdebug_change_qdepth,
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b60c218dc0d0..abd2da3ef45f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -316,7 +316,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
 	sdev->hostdata =3D hostdata;
=20
 	/* if the device needs this changing, it may do so in the
-	 * slave_configure function */
+	 * sdev_configure function */
 	sdev->max_device_blocked =3D SCSI_DEFAULT_DEVICE_BLOCKED;
=20
 	/*
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
index c51f760306c7..f93e55f5acf3 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6558,7 +6558,8 @@ static inline bool pqi_is_tape_changer_device(struc=
t pqi_scsi_dev *device)
 	return device->devtype =3D=3D TYPE_TAPE || device->devtype =3D=3D TYPE_=
MEDIUM_CHANGER;
 }
=20
-static int pqi_slave_configure(struct scsi_device *sdev)
+static int pqi_sdev_configure(struct scsi_device *sdev,
+			      struct queue_limits *lim)
 {
 	int rc =3D 0;
 	struct pqi_scsi_dev *device;
@@ -7550,7 +7551,7 @@ static const struct scsi_host_template pqi_driver_t=
emplate =3D {
 	.eh_abort_handler =3D pqi_eh_abort_handler,
 	.ioctl =3D pqi_ioctl,
 	.sdev_init =3D pqi_sdev_init,
-	.slave_configure =3D pqi_slave_configure,
+	.sdev_configure =3D pqi_sdev_configure,
 	.sdev_destroy =3D pqi_sdev_destroy,
 	.map_queues =3D pqi_map_queues,
 	.sdev_groups =3D pqi_sdev_groups,
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.=
c
index 14830b6ab94b..d3cf50088a37 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -57,11 +57,11 @@ snic_sdev_init(struct scsi_device *sdev)
 }
=20
 /*
- * snic_slave_configure : callback function to SCSI Mid Layer, called on
+ * snic_sdev_configure : callback function to SCSI Mid Layer, called on
  * scsi device initialization.
  */
 static int
-snic_slave_configure(struct scsi_device *sdev)
+snic_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 {
 	struct snic *snic =3D shost_priv(sdev->host);
 	u32 qdepth =3D 0, max_ios =3D 0;
@@ -108,7 +108,7 @@ static const struct scsi_host_template snic_host_temp=
late =3D {
 	.eh_device_reset_handler =3D snic_device_reset,
 	.eh_host_reset_handler =3D snic_host_reset,
 	.sdev_init =3D snic_sdev_init,
-	.slave_configure =3D snic_slave_configure,
+	.sdev_configure =3D snic_sdev_configure,
 	.change_queue_depth =3D snic_change_queue_depth,
 	.this_id =3D -1,
 	.cmd_per_lun =3D SNIC_DFLT_QUEUE_DEPTH,
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 0e81125df8c7..0e5c7609dcc4 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -584,7 +584,7 @@ static void return_abnormal_state(struct st_hba *hba,=
 int status)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 static int
-stex_slave_config(struct scsi_device *sdev)
+stex_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 {
 	sdev->use_10_for_rw =3D 1;
 	sdev->use_10_for_ms =3D 1;
@@ -1481,7 +1481,7 @@ static const struct scsi_host_template driver_templ=
ate =3D {
 	.proc_name			=3D DRV_NAME,
 	.bios_param			=3D stex_biosparam,
 	.queuecommand			=3D stex_queuecommand,
-	.slave_configure		=3D stex_slave_config,
+	.sdev_configure			=3D stex_sdev_configure,
 	.eh_abort_handler		=3D stex_abort,
 	.eh_host_reset_handler		=3D stex_reset,
 	.this_id			=3D -1,
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 0f18591539e7..eab32abf1f49 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1574,7 +1574,8 @@ static int storvsc_device_alloc(struct scsi_device =
*sdevice)
 	return 0;
 }
=20
-static int storvsc_device_configure(struct scsi_device *sdevice)
+static int storvsc_sdev_configure(struct scsi_device *sdevice,
+				  struct queue_limits *lim)
 {
 	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout * HZ));
=20
@@ -1876,7 +1877,7 @@ static struct scsi_host_template scsi_driver =3D {
 	.proc_name =3D		"storvsc_host",
 	.eh_timed_out =3D		storvsc_eh_timed_out,
 	.sdev_init =3D		storvsc_device_alloc,
-	.slave_configure =3D	storvsc_device_configure,
+	.sdev_configure =3D	storvsc_sdev_configure,
 	.cmd_per_lun =3D		2048,
 	.this_id =3D		-1,
 	/* Ensure there are no gaps in presented sgls */
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx=
_2/sym_glue.c
index e7a17f87027d..9b8cb7319370 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -825,7 +825,8 @@ static int sym53c8xx_sdev_init(struct scsi_device *sd=
ev)
 /*
  * Linux entry point for device queue sizing.
  */
-static int sym53c8xx_slave_configure(struct scsi_device *sdev)
+static int sym53c8xx_sdev_configure(struct scsi_device *sdev,
+				    struct queue_limits *lim)
 {
 	struct sym_hcb *np =3D sym_get_hcb(sdev->host);
 	struct sym_tcb *tp =3D &np->target[sdev->id];
@@ -1685,7 +1686,7 @@ static const struct scsi_host_template sym2_templat=
e =3D {
 	.cmd_size		=3D sizeof(struct sym_ucmd),
 	.queuecommand		=3D sym53c8xx_queue_command,
 	.sdev_init		=3D sym53c8xx_sdev_init,
-	.slave_configure	=3D sym53c8xx_slave_configure,
+	.sdev_configure		=3D sym53c8xx_sdev_configure,
 	.sdev_destroy		=3D sym53c8xx_sdev_destroy,
 	.eh_abort_handler	=3D sym53c8xx_eh_abort_handler,
 	.eh_target_reset_handler =3D sym53c8xx_eh_target_reset_handler,
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 8ac3b284c2ef..924025305753 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -735,7 +735,8 @@ static int scsifront_dev_reset_handler(struct scsi_cm=
nd *sc)
 	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_RESET);
 }
=20
-static int scsifront_sdev_configure(struct scsi_device *sdev)
+static int scsifront_sdev_configure(struct scsi_device *sdev,
+				    struct queue_limits *lim)
 {
 	struct vscsifrnt_info *info =3D shost_priv(sdev->host);
 	int err;
@@ -776,7 +777,7 @@ static const struct scsi_host_template scsifront_sht =
=3D {
 	.queuecommand		=3D scsifront_queuecommand,
 	.eh_abort_handler	=3D scsifront_eh_abort_handler,
 	.eh_device_reset_handler =3D scsifront_dev_reset_handler,
-	.slave_configure	=3D scsifront_sdev_configure,
+	.sdev_configure		=3D scsifront_sdev_configure,
 	.sdev_destroy		=3D scsifront_sdev_destroy,
 	.cmd_per_lun		=3D VSCSIIF_DEFAULT_CMD_PER_LUN,
 	.can_queue		=3D VSCSIIF_MAX_REQS,
@@ -1074,7 +1075,7 @@ static void scsifront_do_lun_hotplug(struct vscsifr=
nt_info *info, int op)
 			continue;
=20
 		/*
-		 * Front device state path, used in slave_configure called
+		 * Front device state path, used in sdev_configure called
 		 * on successfull scsi_add_device, and in sdev_destroy called
 		 * on remove of a device.
 		 */
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rts=
x.c
index 6851a28f5ec6..2ee5d6341b53 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -68,7 +68,7 @@ static int sdev_init(struct scsi_device *sdev)
 	return 0;
 }
=20
-static int slave_configure(struct scsi_device *sdev)
+static int sdev_configure(struct scsi_device *sdev, struct queue_limits =
*lim)
 {
 	/* Set the SCSI level to at least 2.  We'll leave it at 3 if that's
 	 * what is originally reported.  We need this to avoid confusing
@@ -199,7 +199,7 @@ static const struct scsi_host_template rtsx_host_temp=
late =3D {
 	.this_id =3D			-1,
=20
 	.sdev_init =3D			sdev_init,
-	.slave_configure =3D		slave_configure,
+	.sdev_configure =3D		sdev_configure,
=20
 	/* lots of sg segments can be handled */
 	.sg_tablesize =3D			SG_ALL,
