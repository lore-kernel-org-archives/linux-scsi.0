Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEA31A0BFF
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 20:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727719; cv=none; b=N8BID6FY+M4PzYilCmetuUdg+5l0JcszmJpovG4//rUJYbg4/eWI9yaCD+pdUsMn+w0NmaC51I50a2gbO5ctaWKrfUJnYEfqtTH9tnFNdX3Yh8Cm9vUMbA8jufj8R8jTrSZ5UXkpykQ+T4zLsyRyZf40H2/+1Ozkyg/WbcCze48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727719; c=relaxed/simple;
	bh=/FFnJ3mKcPpnbtw8VXY3zX7muzDbWQg40kOpQ6guI2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uesWNd7RT7X2748ovqjqtMKdWsD80NjeEjsbVUZZvMOck2FbxFKA8irXihpW+Y40Km4ALOQHyLTrtqZjAZ2lYEzTRfPR3BFBM/IIXPGB7N0qYL2fUr4m21QOfvryI3MZwruAC924S9x1D6jfarTE8w1G9j8O46U8JbAJDtgaYd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JQGpe5rl; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JQGpe5rl"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XHXXy5JWsz6ClY9d;
	Mon, 30 Sep 2024 20:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1727727624; x=1730319625; bh=nmfP1
	6SWx34DgqKltSkLWKJKjI3amEKmO38FirbiGQc=; b=JQGpe5rlnwgQo23CyJkIm
	kSadJj7JW1Z08dO6y1W2Iz2p5LxK463FdgCyUfLOLlY7qzMq1vLkFV/MS/sKv2EB
	cgQBraR6ZBxU6/jStWyVpvTY0Ceh7r9IUh5h6lwpZuzjtWJrRv2OhYh4JjXjUzMl
	KDrMuIJpvbpyyWbUU0rxFSxCbJFSbrPLkSp5jDiFAB/3BkyUcG1oIfOA0aRQmsCZ
	hqddKJhKLDkZ8Sf5N9FQkMW+um/QAIvahHfi3ndEmRqaLhHbBIOFKTtANinlvAOz
	FGn7Zutbc0Kx0KlV0vM8D880PbiQADKAFM0fCZ2GzsYZ4TsY3jh/XOEfrq3s+MHq
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gYvcgGZ6Mkut; Mon, 30 Sep 2024 20:20:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XHXVw5Pbsz6ClY9V;
	Mon, 30 Sep 2024 20:20:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Steffen Maier <maier@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Yihang Li <liyihang9@huawei.com>,
	Don Brace <don.brace@microchip.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Brian King <brking@us.ibm.com>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Randy Dunlap <rdunlap@infradead.org>,
	John Garry <john.g.garry@oracle.com>,
	Soumya Negi <soumya.negi97@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 1/4] scsi: Rename .slave_alloc() and .slave_destroy()
Date: Mon, 30 Sep 2024 13:18:47 -0700
Message-ID: <20240930201937.2020129-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
In-Reply-To: <20240930201937.2020129-1-bvanassche@acm.org>
References: <20240930201937.2020129-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

There is agreement that the word "slave" should not be used in Linux
kernel source code. Hence this patch that renames .slave_alloc() into
.device_alloc() and .slave_destroy() into .device_destroy() in the SCSI
core, SCSI drivers, ATA drivers and also in the SCSI documentation.
Do not modify Documentation/scsi/ChangeLog.lpfc. No functionality has
been changed.

This patch has been created as follows:
* Change the text "slave_alloc" into "device_alloc" in all source files
  except in the LPFC driver changelog.
* Change the text "slave_destroy" into "device_destroy" in all source
  files except in the LPFC driver changelog.
* Rename lpfc_no_slave() into lpfc_no_device().
* Manually adjust whitespace where necessary to restore vertical
  alignment (dc395x driver and include/linux/libata.h).

Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_mid_low_api.rst   | 50 +++++++++++------------
 drivers/ata/libata-scsi.c                 | 12 +++---
 drivers/firewire/sbp2.c                   |  4 +-
 drivers/message/fusion/mptfc.c            | 12 +++---
 drivers/message/fusion/mptsas.c           |  8 ++--
 drivers/message/fusion/mptscsih.c         |  6 +--
 drivers/message/fusion/mptscsih.h         |  2 +-
 drivers/message/fusion/mptspi.c           | 12 +++---
 drivers/net/ethernet/mellanox/mlx4/main.c | 12 +++---
 drivers/s390/scsi/zfcp_scsi.c             | 10 ++---
 drivers/s390/scsi/zfcp_sysfs.c            |  2 +-
 drivers/s390/scsi/zfcp_unit.c             |  2 +-
 drivers/scsi/53c700.c                     | 12 +++---
 drivers/scsi/aic7xxx/aic79xx_osm.c        |  4 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |  4 +-
 drivers/scsi/bfa/bfad_im.c                | 20 ++++-----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |  2 +-
 drivers/scsi/csiostor/csio_scsi.c         | 12 +++---
 drivers/scsi/dc395x.c                     | 12 +++---
 drivers/scsi/esp_scsi.c                   |  8 ++--
 drivers/scsi/fcoe/fcoe.c                  |  2 +-
 drivers/scsi/fnic/fnic_main.c             |  4 +-
 drivers/scsi/hisi_sas/hisi_sas.h          |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c     |  6 +--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  2 +-
 drivers/scsi/hpsa.c                       | 12 +++---
 drivers/scsi/ibmvscsi/ibmvfc.c            |  6 +--
 drivers/scsi/ipr.c                        | 12 +++---
 drivers/scsi/libfc/fc_fcp.c               |  6 +--
 drivers/scsi/libsas/sas_scsi_host.c       |  4 +-
 drivers/scsi/lpfc/lpfc_scsi.c             | 22 +++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c |  8 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 12 +++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 16 ++++----
 drivers/scsi/myrb.c                       | 16 ++++----
 drivers/scsi/myrs.c                       |  8 ++--
 drivers/scsi/ncr53c8xx.c                  |  4 +-
 drivers/scsi/pmcraid.c                    | 14 +++----
 drivers/scsi/qla2xxx/qla_os.c             |  8 ++--
 drivers/scsi/qla4xxx/ql4_os.c             |  6 +--
 drivers/scsi/scsi_debug.c                 | 12 +++---
 drivers/scsi/scsi_scan.c                  |  8 ++--
 drivers/scsi/scsi_sysfs.c                 |  4 +-
 drivers/scsi/smartpqi/smartpqi_init.c     |  8 ++--
 drivers/scsi/snic/snic_main.c             |  6 +--
 drivers/scsi/storvsc_drv.c                |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       | 10 ++---
 drivers/scsi/virtio_scsi.c                |  2 +-
 drivers/scsi/xen-scsifront.c              |  4 +-
 drivers/staging/rts5208/rtsx.c            |  4 +-
 drivers/ufs/core/ufshcd.c                 | 12 +++---
 drivers/usb/image/microtek.c              |  4 +-
 drivers/usb/storage/scsiglue.c            |  6 +--
 drivers/usb/storage/uas.c                 |  4 +-
 include/linux/libata.h                    |  8 ++--
 include/scsi/libfc.h                      |  2 +-
 include/scsi/libsas.h                     |  4 +-
 include/scsi/scsi_device.h                |  4 +-
 include/scsi/scsi_host.h                  | 16 ++++----
 61 files changed, 250 insertions(+), 250 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi=
/scsi_mid_low_api.rst
index 2df29b92e196..3507c10164b4 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -112,9 +112,9 @@ Those usages in group c) should be handled with care,=
 especially in a
 that are shared with the mid level and other layers.
=20
 All functions defined within an LLD and all data defined at file scope
-should be static. For example the slave_alloc() function in an LLD
+should be static. For example the device_alloc() function in an LLD
 called "xxx" could be defined as
-``static int xxx_slave_alloc(struct scsi_device * sdev) { /* code */ }``
+``static int xxx_device_alloc(struct scsi_device * sdev) { /* code */ }`=
`
=20
 .. [#] the scsi_host_alloc() function is a replacement for the rather va=
guely
        named scsi_register() function in most situations.
@@ -149,18 +149,18 @@ scsi devices of which only the first 2 respond::
     scsi_add_host()  ---->
     scsi_scan_host()  -------+
 			    |
-			slave_alloc()
+			device_alloc()
 			slave_configure() -->  scsi_change_queue_depth()
 			    |
-			slave_alloc()
+			device_alloc()
 			slave_configure()
 			    |
-			slave_alloc()   ***
-			slave_destroy() ***
+			device_alloc()   ***
+			device_destroy() ***
=20
=20
     *** For scsi devices that the mid level tries to scan but do not
-	respond, a slave_alloc(), slave_destroy() pair is called.
+	respond, a device_alloc(), device_destroy() pair is called.
=20
 If the LLD wants to adjust the default queue settings, it can invoke
 scsi_change_queue_depth() in its slave_configure() routine.
@@ -176,8 +176,8 @@ same::
     =3D=3D=3D----------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D----------=
-------=3D=3D=3D------
     scsi_remove_host() ---------+
 				|
-			slave_destroy()
-			slave_destroy()
+			device_destroy()
+			device_destroy()
     scsi_host_put()
=20
 It may be useful for a LLD to keep track of struct Scsi_Host instances
@@ -202,7 +202,7 @@ An LLD can use this sequence to make the mid level aw=
are of a SCSI device::
     =3D=3D=3D-------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D-------------=
-------=3D=3D=3D------
     scsi_add_device()  ------+
 			    |
-			slave_alloc()
+			device_alloc()
 			slave_configure()   [--> scsi_change_queue_depth()]
=20
 In a similar fashion, an LLD may become aware that a SCSI device has bee=
n
@@ -218,12 +218,12 @@ upper layers with this sequence::
     =3D=3D=3D----------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D----------=
-------=3D=3D=3D------
     scsi_remove_device() -------+
 				|
-			slave_destroy()
+			device_destroy()
=20
 It may be useful for an LLD to keep track of struct scsi_device instance=
s
-(a pointer is passed as the parameter to slave_alloc() and
+(a pointer is passed as the parameter to device_alloc() and
 slave_configure() callbacks). Such instances are "owned" by the mid-leve=
l.
-struct scsi_device instances are freed after slave_destroy().
+struct scsi_device instances are freed after device_destroy().
=20
=20
 Reference Counting
@@ -331,7 +331,7 @@ Details::
     *      bus scan when an HBA is added (i.e. scsi_scan_host()). So it
     *      should only be called if the HBA becomes aware of a new scsi
     *      device (lu) after scsi_scan_host() has completed. If successf=
ul
-    *      this call can lead to slave_alloc() and slave_configure() cal=
lbacks
+    *      this call can lead to device_alloc() and slave_configure() ca=
llbacks
     *      into the LLD.
     *
     *      Defined in: drivers/scsi/scsi_scan.c
@@ -375,7 +375,7 @@ Details::
     *
     *      Notes: Can be invoked any time on a SCSI device controlled by=
 this
     *      LLD. [Specifically during and after slave_configure() and pri=
or to
-    *      slave_destroy().] Can safely be invoked from interrupt code.
+    *      device_destroy().] Can safely be invoked from interrupt code.
     *
     *      Defined in: drivers/scsi/scsi.c [see source code for more not=
es]
     *
@@ -506,7 +506,7 @@ Details::
     *      Notes: If an LLD becomes aware that a scsi device (lu) has
     *      been removed but its host is still present then it can reques=
t
     *      the removal of that scsi device. If successful this call will
-    *      lead to the slave_destroy() callback being invoked. sdev is a=
n
+    *      lead to the device_destroy() callback being invoked. sdev is =
an
     *      invalid pointer after this call.
     *
     *      Defined in: drivers/scsi/scsi_sysfs.c .
@@ -657,9 +657,9 @@ Summary:
   - ioctl - driver can respond to ioctls
   - proc_info - supports /proc/scsi/{driver_name}/{host_no}
   - queuecommand - queue scsi command, invoke 'done' on completion
-  - slave_alloc - prior to any commands being sent to a new device
+  - device_alloc - prior to any commands being sent to a new device
   - slave_configure - driver fine tuning for given device after attach
-  - slave_destroy - given device is about to be shut down
+  - device_destroy - given device is about to be shut down
=20
=20
 Details::
@@ -960,7 +960,7 @@ Details::
=20
=20
     /**
-    *      slave_alloc -   prior to any commands being sent to a new dev=
ice
+    *      device_alloc -   prior to any commands being sent to a new de=
vice
     *                      (i.e. just prior to scan) this call is made
     *      @sdp: pointer to new device (about to be scanned)
     *
@@ -976,12 +976,12 @@ Details::
     *      exist but the mid level is just about to scan for it (i.e. se=
nd
     *      and INQUIRY command plus ...). If a device is found then
     *      slave_configure() will be called while if a device is not fou=
nd
-    *      slave_destroy() is called.
+    *      device_destroy() is called.
     *      For more details see the include/scsi/scsi_host.h file.
     *
     *      Optionally defined in: LLD
     **/
-	int slave_alloc(struct scsi_device *sdp)
+	int device_alloc(struct scsi_device *sdp)
=20
=20
     /**
@@ -992,7 +992,7 @@ Details::
     *
     *      Returns 0 if ok. Any other return is assumed to be an error a=
nd
     *      the device is taken offline. [offline devices will _not_ have
-    *      slave_destroy() called on them so clean up resources.]
+    *      device_destroy() called on them so clean up resources.]
     *
     *      Locks: none
     *
@@ -1008,7 +1008,7 @@ Details::
=20
=20
     /**
-    *      slave_destroy - given device is about to be shut down. All
+    *      device_destroy - given device is about to be shut down. All
     *                      activity has ceased on this device.
     *      @sdp: device that is about to be shut down
     *
@@ -1023,12 +1023,12 @@ Details::
     *      by this driver for given device should be freed now. No furth=
er
     *      commands will be sent for this sdp instance. [However the dev=
ice
     *      could be re-attached in the future in which case a new instan=
ce
-    *      of struct scsi_device would be supplied by future slave_alloc=
()
+    *      of struct scsi_device would be supplied by future device_allo=
c()
     *      and slave_configure() calls.]
     *
     *      Optionally defined in: LLD
     **/
-	void slave_destroy(struct scsi_device *sdp)
+	void device_destroy(struct scsi_device *sdp)
=20
=20
=20
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a4aedf7e1775..bb82b6400bfb 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1133,7 +1133,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, s=
truct queue_limits *lim,
 }
=20
 /**
- *	ata_scsi_slave_alloc - Early setup of SCSI device
+ *	ata_scsi_device_alloc - Early setup of SCSI device
  *	@sdev: SCSI device to examine
  *
  *	This is called from scsi_alloc_sdev() when the scsi device
@@ -1143,7 +1143,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, s=
truct queue_limits *lim,
  *	Defined by SCSI layer.  We don't really care.
  */
=20
-int ata_scsi_slave_alloc(struct scsi_device *sdev)
+int ata_scsi_device_alloc(struct scsi_device *sdev)
 {
 	struct ata_port *ap =3D ata_shost_to_port(sdev->host);
 	struct device_link *link;
@@ -1166,7 +1166,7 @@ int ata_scsi_slave_alloc(struct scsi_device *sdev)
=20
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ata_scsi_slave_alloc);
+EXPORT_SYMBOL_GPL(ata_scsi_device_alloc);
=20
 /**
  *	ata_scsi_device_configure - Set SCSI device attributes
@@ -1195,7 +1195,7 @@ int ata_scsi_device_configure(struct scsi_device *s=
dev,
 EXPORT_SYMBOL_GPL(ata_scsi_device_configure);
=20
 /**
- *	ata_scsi_slave_destroy - SCSI device is about to be destroyed
+ *	ata_scsi_device_destroy - SCSI device is about to be destroyed
  *	@sdev: SCSI device to be destroyed
  *
  *	@sdev is about to be destroyed for hot/warm unplugging.  If
@@ -1208,7 +1208,7 @@ EXPORT_SYMBOL_GPL(ata_scsi_device_configure);
  *	LOCKING:
  *	Defined by SCSI layer.  We don't really care.
  */
-void ata_scsi_slave_destroy(struct scsi_device *sdev)
+void ata_scsi_device_destroy(struct scsi_device *sdev)
 {
 	struct ata_port *ap =3D ata_shost_to_port(sdev->host);
 	unsigned long flags;
@@ -1228,7 +1228,7 @@ void ata_scsi_slave_destroy(struct scsi_device *sde=
v)
=20
 	kfree(sdev->dma_drain_buf);
 }
-EXPORT_SYMBOL_GPL(ata_scsi_slave_destroy);
+EXPORT_SYMBOL_GPL(ata_scsi_device_destroy);
=20
 /**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 827dee0f57dd..e88654b3a220 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1490,7 +1490,7 @@ static int sbp2_scsi_queuecommand(struct Scsi_Host =
*shost,
 	return retval;
 }
=20
-static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
+static int sbp2_scsi_device_alloc(struct scsi_device *sdev)
 {
 	struct sbp2_logical_unit *lu =3D sdev->hostdata;
=20
@@ -1590,7 +1590,7 @@ static const struct scsi_host_template scsi_driver_=
template =3D {
 	.name			=3D "SBP-2 IEEE-1394",
 	.proc_name		=3D "sbp2",
 	.queuecommand		=3D sbp2_scsi_queuecommand,
-	.slave_alloc		=3D sbp2_scsi_slave_alloc,
+	.device_alloc		=3D sbp2_scsi_device_alloc,
 	.device_configure	=3D sbp2_scsi_device_configure,
 	.eh_abort_handler	=3D sbp2_scsi_abort,
 	.this_id		=3D -1,
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptf=
c.c
index 91242f26defb..1b43fba24af1 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -96,7 +96,7 @@ static u8	mptfcTaskCtx =3D MPT_MAX_PROTOCOL_DRIVERS;
 static u8	mptfcInternalCtx =3D MPT_MAX_PROTOCOL_DRIVERS;
=20
 static int mptfc_target_alloc(struct scsi_target *starget);
-static int mptfc_slave_alloc(struct scsi_device *sdev);
+static int mptfc_device_alloc(struct scsi_device *sdev);
 static int mptfc_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt);
 static void mptfc_target_destroy(struct scsi_target *starget);
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t ti=
meout);
@@ -113,10 +113,10 @@ static const struct scsi_host_template mptfc_driver=
_template =3D {
 	.info				=3D mptscsih_info,
 	.queuecommand			=3D mptfc_qcmd,
 	.target_alloc			=3D mptfc_target_alloc,
-	.slave_alloc			=3D mptfc_slave_alloc,
+	.device_alloc			=3D mptfc_device_alloc,
 	.slave_configure		=3D mptscsih_slave_configure,
 	.target_destroy			=3D mptfc_target_destroy,
-	.slave_destroy			=3D mptscsih_slave_destroy,
+	.device_destroy			=3D mptscsih_device_destroy,
 	.change_queue_depth 		=3D mptscsih_change_queue_depth,
 	.eh_timed_out			=3D fc_eh_timed_out,
 	.eh_abort_handler		=3D mptfc_abort,
@@ -503,7 +503,7 @@ mptfc_register_dev(MPT_ADAPTER *ioc, int channel, FCD=
evicePage0_t *pg0)
 			/*
 			 * if already mapped, remap here.  If not mapped,
 			 * target_alloc will allocate vtarget and map,
-			 * slave_alloc will fill in vdevice from vtarget.
+			 * device_alloc will fill in vdevice from vtarget.
 			 */
 			if (ri->starget) {
 				vtarget =3D ri->starget->hostdata;
@@ -631,7 +631,7 @@ mptfc_dump_lun_info(MPT_ADAPTER *ioc, struct fc_rport=
 *rport, struct scsi_device
  *	Init memory once per LUN.
  */
 static int
-mptfc_slave_alloc(struct scsi_device *sdev)
+mptfc_device_alloc(struct scsi_device *sdev)
 {
 	MPT_SCSI_HOST		*hd;
 	VirtTarget		*vtarget;
@@ -651,7 +651,7 @@ mptfc_slave_alloc(struct scsi_device *sdev)
=20
 	vdevice =3D kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdevice) {
-		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
+		printk(MYIOC_s_ERR_FMT "device_alloc kmalloc(%zd) FAILED!\n",
 				ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mpt=
sas.c
index a0bcb0864ecd..848c45d141e3 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1867,7 +1867,7 @@ mptsas_target_destroy(struct scsi_target *starget)
=20
=20
 static int
-mptsas_slave_alloc(struct scsi_device *sdev)
+mptsas_device_alloc(struct scsi_device *sdev)
 {
 	struct Scsi_Host	*host =3D sdev->host;
 	MPT_SCSI_HOST		*hd =3D shost_priv(host);
@@ -1880,7 +1880,7 @@ mptsas_slave_alloc(struct scsi_device *sdev)
=20
 	vdevice =3D kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdevice) {
-		printk(MYIOC_s_ERR_FMT "slave_alloc kzalloc(%zd) FAILED!\n",
+		printk(MYIOC_s_ERR_FMT "device_alloc kzalloc(%zd) FAILED!\n",
 				ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
@@ -2005,10 +2005,10 @@ static const struct scsi_host_template mptsas_dri=
ver_template =3D {
 	.info				=3D mptscsih_info,
 	.queuecommand			=3D mptsas_qcmd,
 	.target_alloc			=3D mptsas_target_alloc,
-	.slave_alloc			=3D mptsas_slave_alloc,
+	.device_alloc			=3D mptsas_device_alloc,
 	.slave_configure		=3D mptsas_slave_configure,
 	.target_destroy			=3D mptsas_target_destroy,
-	.slave_destroy			=3D mptscsih_slave_destroy,
+	.device_destroy			=3D mptscsih_device_destroy,
 	.change_queue_depth 		=3D mptscsih_change_queue_depth,
 	.eh_timed_out			=3D mptsas_eh_timed_out,
 	.eh_abort_handler		=3D mptscsih_abort,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/m=
ptscsih.c
index 6c3f25cc33ff..18664bbe8db5 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1071,7 +1071,7 @@ EXPORT_SYMBOL(mptscsih_flush_running_cmds);
  *
  *	Returns: None.
  *
- *	Called from slave_destroy.
+ *	Called from device_destroy.
  */
 static void
 mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
@@ -2331,7 +2331,7 @@ EXPORT_SYMBOL(mptscsih_raid_id_to_num);
  *	Called if no device present or device being unloaded
  */
 void
-mptscsih_slave_destroy(struct scsi_device *sdev)
+mptscsih_device_destroy(struct scsi_device *sdev)
 {
 	struct Scsi_Host	*host =3D sdev->host;
 	MPT_SCSI_HOST		*hd =3D shost_priv(host);
@@ -3302,7 +3302,7 @@ EXPORT_SYMBOL(mptscsih_resume);
 EXPORT_SYMBOL(mptscsih_show_info);
 EXPORT_SYMBOL(mptscsih_info);
 EXPORT_SYMBOL(mptscsih_qcmd);
-EXPORT_SYMBOL(mptscsih_slave_destroy);
+EXPORT_SYMBOL(mptscsih_device_destroy);
 EXPORT_SYMBOL(mptscsih_slave_configure);
 EXPORT_SYMBOL(mptscsih_abort);
 EXPORT_SYMBOL(mptscsih_dev_reset);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/m=
ptscsih.h
index e3d92c392673..e3b7368264d7 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -116,7 +116,7 @@ extern const char * mptscsih_info(struct Scsi_Host *S=
Chost);
 extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt);
 extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel=
,
 	u8 id, u64 lun, int ctx2abort, ulong timeout);
-extern void mptscsih_slave_destroy(struct scsi_device *device);
+extern void mptscsih_device_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mpt=
spi.c
index 574b882c9a85..744487585a78 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -713,7 +713,7 @@ static void mptspi_dv_device(struct _MPT_SCSI_HOST *h=
d,
 	mptspi_read_parameters(sdev->sdev_target);
 }
=20
-static int mptspi_slave_alloc(struct scsi_device *sdev)
+static int mptspi_device_alloc(struct scsi_device *sdev)
 {
 	MPT_SCSI_HOST *hd =3D shost_priv(sdev->host);
 	VirtTarget		*vtarget;
@@ -727,7 +727,7 @@ static int mptspi_slave_alloc(struct scsi_device *sde=
v)
=20
 	vdevice =3D kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdevice) {
-		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
+		printk(MYIOC_s_ERR_FMT "device_alloc kmalloc(%zd) FAILED!\n",
 				ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
@@ -799,7 +799,7 @@ mptspi_qcmd(struct Scsi_Host *shost, struct scsi_cmnd=
 *SCpnt)
 	return mptscsih_qcmd(SCpnt);
 }
=20
-static void mptspi_slave_destroy(struct scsi_device *sdev)
+static void mptspi_device_destroy(struct scsi_device *sdev)
 {
 	struct scsi_target *starget =3D scsi_target(sdev);
 	VirtTarget *vtarget =3D starget->hostdata;
@@ -817,7 +817,7 @@ static void mptspi_slave_destroy(struct scsi_device *=
sdev)
 		mptspi_write_spi_device_pg1(starget, &pg1);
 	}
=20
-	mptscsih_slave_destroy(sdev);
+	mptscsih_device_destroy(sdev);
 }
=20
 static const struct scsi_host_template mptspi_driver_template =3D {
@@ -828,10 +828,10 @@ static const struct scsi_host_template mptspi_drive=
r_template =3D {
 	.info				=3D mptscsih_info,
 	.queuecommand			=3D mptspi_qcmd,
 	.target_alloc			=3D mptspi_target_alloc,
-	.slave_alloc			=3D mptspi_slave_alloc,
+	.device_alloc			=3D mptspi_device_alloc,
 	.slave_configure		=3D mptspi_slave_configure,
 	.target_destroy			=3D mptspi_target_destroy,
-	.slave_destroy			=3D mptspi_slave_destroy,
+	.device_destroy			=3D mptspi_device_destroy,
 	.change_queue_depth 		=3D mptscsih_change_queue_depth,
 	.eh_abort_handler		=3D mptscsih_abort,
 	.eh_device_reset_handler	=3D mptscsih_dev_reset,
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethe=
rnet/mellanox/mlx4/main.c
index febeadfdd5a5..fc909e336dc3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -851,7 +851,7 @@ static void slave_adjust_steering_mode(struct mlx4_de=
v *dev,
 		 mlx4_steering_mode_str(dev->caps.steering_mode));
 }
=20
-static void mlx4_slave_destroy_special_qp_cap(struct mlx4_dev *dev)
+static void mlx4_device_destroy_special_qp_cap(struct mlx4_dev *dev)
 {
 	kfree(dev->caps.spec_qps);
 	dev->caps.spec_qps =3D NULL;
@@ -894,7 +894,7 @@ static int mlx4_slave_special_qp_cap(struct mlx4_dev =
*dev)
=20
 err_mem:
 	if (err)
-		mlx4_slave_destroy_special_qp_cap(dev);
+		mlx4_device_destroy_special_qp_cap(dev);
 	kfree(func_cap);
 	return err;
 }
@@ -1078,7 +1078,7 @@ static int mlx4_slave_cap(struct mlx4_dev *dev)
=20
 err_mem:
 	if (err)
-		mlx4_slave_destroy_special_qp_cap(dev);
+		mlx4_device_destroy_special_qp_cap(dev);
 free_mem:
 	kfree(hca_param);
 	kfree(func_cap);
@@ -2503,7 +2503,7 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 	unmap_bf_area(dev);
=20
 	if (mlx4_is_slave(dev))
-		mlx4_slave_destroy_special_qp_cap(dev);
+		mlx4_device_destroy_special_qp_cap(dev);
=20
 err_close:
 	if (mlx4_is_slave(dev))
@@ -3749,7 +3749,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int =
pci_dev_data,
 	}
=20
 	if (mlx4_is_slave(dev))
-		mlx4_slave_destroy_special_qp_cap(dev);
+		mlx4_device_destroy_special_qp_cap(dev);
=20
 err_close:
 	mlx4_close_hca(dev);
@@ -4159,7 +4159,7 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	if (!mlx4_is_slave(dev))
 		mlx4_free_ownership(dev);
=20
-	mlx4_slave_destroy_special_qp_cap(dev);
+	mlx4_device_destroy_special_qp_cap(dev);
 	kfree(dev->dev_vfs);
=20
 	mlx4_adev_cleanup(dev);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.=
c
index b2a8cd792266..355b99fa8c0f 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -37,11 +37,11 @@ static bool allow_lun_scan =3D true;
 module_param(allow_lun_scan, bool, 0600);
 MODULE_PARM_DESC(allow_lun_scan, "For NPIV, scan and attach all storage =
LUNs");
=20
-static void zfcp_scsi_slave_destroy(struct scsi_device *sdev)
+static void zfcp_scsi_device_destroy(struct scsi_device *sdev)
 {
 	struct zfcp_scsi_dev *zfcp_sdev =3D sdev_to_zfcp(sdev);
=20
-	/* if previous slave_alloc returned early, there is nothing to do */
+	/* if previous device_alloc returned early, there is nothing to do */
 	if (!zfcp_sdev->port)
 		return;
=20
@@ -110,7 +110,7 @@ int zfcp_scsi_queuecommand(struct Scsi_Host *shost, s=
truct scsi_cmnd *scpnt)
 	return ret;
 }
=20
-static int zfcp_scsi_slave_alloc(struct scsi_device *sdev)
+static int zfcp_scsi_device_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(sdev));
 	struct zfcp_adapter *adapter =3D
@@ -427,9 +427,9 @@ static const struct scsi_host_template zfcp_scsi_host=
_template =3D {
 	.eh_device_reset_handler =3D zfcp_scsi_eh_device_reset_handler,
 	.eh_target_reset_handler =3D zfcp_scsi_eh_target_reset_handler,
 	.eh_host_reset_handler	 =3D zfcp_scsi_eh_host_reset_handler,
-	.slave_alloc		 =3D zfcp_scsi_slave_alloc,
+	.device_alloc		 =3D zfcp_scsi_device_alloc,
 	.slave_configure	 =3D zfcp_scsi_slave_configure,
-	.slave_destroy		 =3D zfcp_scsi_slave_destroy,
+	.device_destroy		 =3D zfcp_scsi_device_destroy,
 	.change_queue_depth	 =3D scsi_change_queue_depth,
 	.host_reset		 =3D zfcp_scsi_sysfs_host_reset,
 	.proc_name		 =3D "zfcp",
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysf=
s.c
index cb67fa80fb12..7a6c7fa8f844 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -284,7 +284,7 @@ static bool zfcp_sysfs_port_in_use(struct zfcp_port *=
const port)
 		goto unlock_host_lock;
 	}
=20
-	/* port is about to be removed, so no more unit_add or slave_alloc */
+	/* port is about to be removed, so no more unit_add or device_alloc */
 	zfcp_sysfs_port_set_removing(port);
 	in_use =3D false;
=20
diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.=
c
index 60f2a04f0869..a8ad08040366 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -170,7 +170,7 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun=
)
 	write_unlock_irq(&port->unit_list_lock);
 	/*
 	 * lock order: shost->scan_mutex before zfcp_sysfs_port_units_mutex
-	 * due to      zfcp_unit_scsi_scan() =3D> zfcp_scsi_slave_alloc()
+	 * due to      zfcp_unit_scsi_scan() =3D> zfcp_scsi_device_alloc()
 	 */
 	mutex_unlock(&zfcp_sysfs_port_units_mutex);
=20
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 85439e976143..5498417604fc 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -158,9 +158,9 @@ STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
-STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
+STATIC int NCR_700_device_alloc(struct scsi_device *SDpnt);
 STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
-STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
+STATIC void NCR_700_device_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int dep=
th);
=20
 STATIC const struct attribute_group *NCR_700_dev_groups[];
@@ -331,8 +331,8 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	tpnt->sg_tablesize =3D NCR_700_SG_SEGMENTS;
 	tpnt->cmd_per_lun =3D NCR_700_CMD_PER_LUN;
 	tpnt->slave_configure =3D NCR_700_slave_configure;
-	tpnt->slave_destroy =3D NCR_700_slave_destroy;
-	tpnt->slave_alloc =3D NCR_700_slave_alloc;
+	tpnt->device_destroy =3D NCR_700_device_destroy;
+	tpnt->device_alloc =3D NCR_700_device_alloc;
 	tpnt->change_queue_depth =3D NCR_700_change_queue_depth;
=20
 	if(tpnt->name =3D=3D NULL)
@@ -2017,7 +2017,7 @@ NCR_700_set_offset(struct scsi_target *STp, int off=
set)
 }
=20
 STATIC int
-NCR_700_slave_alloc(struct scsi_device *SDp)
+NCR_700_device_alloc(struct scsi_device *SDp)
 {
 	SDp->hostdata =3D kzalloc(sizeof(struct NCR_700_Device_Parameters),
 				GFP_KERNEL);
@@ -2052,7 +2052,7 @@ NCR_700_slave_configure(struct scsi_device *SDp)
 }
=20
 STATIC void
-NCR_700_slave_destroy(struct scsi_device *SDp)
+NCR_700_device_destroy(struct scsi_device *SDp)
 {
 	kfree(SDp->hostdata);
 	SDp->hostdata =3D NULL;
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/ai=
c79xx_osm.c
index 4202059815a0..1bf60a8d01cf 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -672,7 +672,7 @@ ahd_linux_target_destroy(struct scsi_target *starget)
 }
=20
 static int
-ahd_linux_slave_alloc(struct scsi_device *sdev)
+ahd_linux_device_alloc(struct scsi_device *sdev)
 {
 	struct	ahd_softc *ahd =3D
 		*((struct ahd_softc **)sdev->host->hostdata);
@@ -906,7 +906,7 @@ struct scsi_host_template aic79xx_driver_template =3D=
 {
 	.this_id		=3D -1,
 	.max_sectors		=3D 8192,
 	.cmd_per_lun		=3D 2,
-	.slave_alloc		=3D ahd_linux_slave_alloc,
+	.device_alloc		=3D ahd_linux_device_alloc,
 	.slave_configure	=3D ahd_linux_slave_configure,
 	.target_alloc		=3D ahd_linux_target_alloc,
 	.target_destroy		=3D ahd_linux_target_destroy,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/ai=
c7xxx_osm.c
index b0c4f2345321..5724e8940ea8 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -632,7 +632,7 @@ ahc_linux_target_destroy(struct scsi_target *starget)
 }
=20
 static int
-ahc_linux_slave_alloc(struct scsi_device *sdev)
+ahc_linux_device_alloc(struct scsi_device *sdev)
 {
 	struct	ahc_softc *ahc =3D
 		*((struct ahc_softc **)sdev->host->hostdata);
@@ -791,7 +791,7 @@ struct scsi_host_template aic7xxx_driver_template =3D=
 {
 	.this_id		=3D -1,
 	.max_sectors		=3D 8192,
 	.cmd_per_lun		=3D 2,
-	.slave_alloc		=3D ahc_linux_slave_alloc,
+	.device_alloc		=3D ahc_linux_device_alloc,
 	.slave_configure	=3D ahc_linux_slave_configure,
 	.target_alloc		=3D ahc_linux_target_alloc,
 	.target_destroy		=3D ahc_linux_target_destroy,
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 66fb701401de..b749715cd49c 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -25,7 +25,7 @@ struct scsi_transport_template *bfad_im_scsi_transport_=
template;
 struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 static void bfad_im_itnim_work_handler(struct work_struct *work);
 static int bfad_im_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *c=
mnd);
-static int bfad_im_slave_alloc(struct scsi_device *sdev);
+static int bfad_im_device_alloc(struct scsi_device *sdev);
 static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
 				struct bfad_itnim_s *itnim);
=20
@@ -404,10 +404,10 @@ bfad_im_reset_target_handler(struct scsi_cmnd *cmnd=
)
 }
=20
 /*
- * Scsi_Host template entry slave_destroy.
+ * Scsi_Host template entry device_destroy.
  */
 static void
-bfad_im_slave_destroy(struct scsi_device *sdev)
+bfad_im_device_destroy(struct scsi_device *sdev)
 {
 	sdev->hostdata =3D NULL;
 	return;
@@ -800,9 +800,9 @@ struct scsi_host_template bfad_im_scsi_host_template =
=3D {
 	.eh_device_reset_handler =3D bfad_im_reset_lun_handler,
 	.eh_target_reset_handler =3D bfad_im_reset_target_handler,
=20
-	.slave_alloc =3D bfad_im_slave_alloc,
+	.device_alloc =3D bfad_im_device_alloc,
 	.slave_configure =3D bfad_im_slave_configure,
-	.slave_destroy =3D bfad_im_slave_destroy,
+	.device_destroy =3D bfad_im_device_destroy,
=20
 	.this_id =3D -1,
 	.sg_tablesize =3D BFAD_IO_MAX_SGE,
@@ -823,9 +823,9 @@ struct scsi_host_template bfad_im_vport_template =3D =
{
 	.eh_device_reset_handler =3D bfad_im_reset_lun_handler,
 	.eh_target_reset_handler =3D bfad_im_reset_target_handler,
=20
-	.slave_alloc =3D bfad_im_slave_alloc,
+	.device_alloc =3D bfad_im_device_alloc,
 	.slave_configure =3D bfad_im_slave_configure,
-	.slave_destroy =3D bfad_im_slave_destroy,
+	.device_destroy =3D bfad_im_device_destroy,
=20
 	.this_id =3D -1,
 	.sg_tablesize =3D BFAD_IO_MAX_SGE,
@@ -915,7 +915,7 @@ bfad_get_itnim(struct bfad_im_port_s *im_port, int id=
)
 }
=20
 /*
- * Function is invoked from the SCSI Host Template slave_alloc() entry p=
oint.
+ * Function is invoked from the SCSI Host Template device_alloc() entry =
point.
  * Has the logic to query the LUN Mask database to check if this LUN nee=
ds to
  * be made visible to the SCSI mid-layer or not.
  *
@@ -946,10 +946,10 @@ bfad_im_check_if_make_lun_visible(struct scsi_devic=
e *sdev,
 }
=20
 /*
- * Scsi_Host template entry slave_alloc
+ * Scsi_Host template entry device_alloc
  */
 static int
-bfad_im_slave_alloc(struct scsi_device *sdev)
+bfad_im_device_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(sdev));
 	struct bfad_itnim_data_s *itnim_data;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2=
fc_fcoe.c
index f49783b89d04..b2d6947cffc4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2951,7 +2951,7 @@ static struct scsi_host_template bnx2fc_shost_templ=
ate =3D {
 	.eh_device_reset_handler =3D bnx2fc_eh_device_reset, /* lun reset */
 	.eh_target_reset_handler =3D bnx2fc_eh_target_reset, /* tgt reset */
 	.eh_host_reset_handler	=3D fc_eh_host_reset,
-	.slave_alloc		=3D fc_slave_alloc,
+	.device_alloc		=3D fc_device_alloc,
 	.change_queue_depth	=3D scsi_change_queue_depth,
 	.this_id		=3D -1,
 	.cmd_per_lun		=3D 3,
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/cs=
io_scsi.c
index 05e1a63e00c3..68c6c8651b76 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2224,7 +2224,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 }
=20
 static int
-csio_slave_alloc(struct scsi_device *sdev)
+csio_device_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(sdev));
=20
@@ -2244,7 +2244,7 @@ csio_slave_configure(struct scsi_device *sdev)
 }
=20
 static void
-csio_slave_destroy(struct scsi_device *sdev)
+csio_device_destroy(struct scsi_device *sdev)
 {
 	sdev->hostdata =3D NULL;
 }
@@ -2276,9 +2276,9 @@ struct scsi_host_template csio_fcoe_shost_template =
=3D {
 	.eh_timed_out		=3D fc_eh_timed_out,
 	.eh_abort_handler	=3D csio_eh_abort_handler,
 	.eh_device_reset_handler =3D csio_eh_lun_reset_handler,
-	.slave_alloc		=3D csio_slave_alloc,
+	.device_alloc		=3D csio_device_alloc,
 	.slave_configure	=3D csio_slave_configure,
-	.slave_destroy		=3D csio_slave_destroy,
+	.device_destroy		=3D csio_device_destroy,
 	.scan_finished		=3D csio_scan_finished,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D CSIO_SCSI_MAX_SGE,
@@ -2295,9 +2295,9 @@ struct scsi_host_template csio_fcoe_shost_vport_tem=
plate =3D {
 	.eh_timed_out		=3D fc_eh_timed_out,
 	.eh_abort_handler	=3D csio_eh_abort_handler,
 	.eh_device_reset_handler =3D csio_eh_lun_reset_handler,
-	.slave_alloc		=3D csio_slave_alloc,
+	.device_alloc		=3D csio_device_alloc,
 	.slave_configure	=3D csio_slave_configure,
-	.slave_destroy		=3D csio_slave_destroy,
+	.device_destroy		=3D csio_device_destroy,
 	.scan_finished		=3D csio_scan_finished,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D CSIO_SCSI_MAX_SGE,
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index d108a86e196e..2d0432028784 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3715,13 +3715,13 @@ static void adapter_remove_and_free_all_devices(s=
truct AdapterCtlBlk* acb)
=20
=20
 /**
- * dc395x_slave_alloc - Called by the scsi mid layer to tell us about a =
new
+ * dc395x_device_alloc - Called by the scsi mid layer to tell us about a=
 new
  * scsi device that we need to deal with. We allocate a new device and t=
hen
  * insert that device into the adapters device list.
  *
  * @scsi_device: The new scsi device that we need to handle.
  **/
-static int dc395x_slave_alloc(struct scsi_device *scsi_device)
+static int dc395x_device_alloc(struct scsi_device *scsi_device)
 {
 	struct AdapterCtlBlk *acb =3D (struct AdapterCtlBlk *)scsi_device->host=
->hostdata;
 	struct DeviceCtlBlk *dcb;
@@ -3736,12 +3736,12 @@ static int dc395x_slave_alloc(struct scsi_device =
*scsi_device)
=20
=20
 /**
- * dc395x_slave_destroy - Called by the scsi mid layer to tell us about =
a
+ * dc395x_device_destroy - Called by the scsi mid layer to tell us about=
 a
  * device that is going away.
  *
  * @scsi_device: The new scsi device that we need to handle.
  **/
-static void dc395x_slave_destroy(struct scsi_device *scsi_device)
+static void dc395x_device_destroy(struct scsi_device *scsi_device)
 {
 	struct AdapterCtlBlk *acb =3D (struct AdapterCtlBlk *)scsi_device->host=
->hostdata;
 	struct DeviceCtlBlk *dcb =3D find_dcb(acb, scsi_device->id, scsi_device=
->lun);
@@ -4547,8 +4547,8 @@ static const struct scsi_host_template dc395x_drive=
r_template =3D {
 	.show_info              =3D dc395x_show_info,
 	.name                   =3D DC395X_BANNER " " DC395X_VERSION,
 	.queuecommand           =3D dc395x_queue_command,
-	.slave_alloc            =3D dc395x_slave_alloc,
-	.slave_destroy          =3D dc395x_slave_destroy,
+	.device_alloc           =3D dc395x_device_alloc,
+	.device_destroy         =3D dc395x_device_destroy,
 	.can_queue              =3D DC395x_MAX_CAN_QUEUE,
 	.this_id                =3D 7,
 	.sg_tablesize           =3D DC395x_MAX_SG_TABLESIZE,
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 0175d2282b45..a754318eca70 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2441,7 +2441,7 @@ static void esp_target_destroy(struct scsi_target *=
starget)
 	tp->starget =3D NULL;
 }
=20
-static int esp_slave_alloc(struct scsi_device *dev)
+static int esp_device_alloc(struct scsi_device *dev)
 {
 	struct esp *esp =3D shost_priv(dev->host);
 	struct esp_target_data *tp =3D &esp->target[dev->id];
@@ -2479,7 +2479,7 @@ static int esp_slave_configure(struct scsi_device *=
dev)
 	return 0;
 }
=20
-static void esp_slave_destroy(struct scsi_device *dev)
+static void esp_device_destroy(struct scsi_device *dev)
 {
 	struct esp_lun_data *lp =3D dev->hostdata;
=20
@@ -2667,9 +2667,9 @@ const struct scsi_host_template scsi_esp_template =3D=
 {
 	.queuecommand		=3D esp_queuecommand,
 	.target_alloc		=3D esp_target_alloc,
 	.target_destroy		=3D esp_target_destroy,
-	.slave_alloc		=3D esp_slave_alloc,
+	.device_alloc		=3D esp_device_alloc,
 	.slave_configure	=3D esp_slave_configure,
-	.slave_destroy		=3D esp_slave_destroy,
+	.device_destroy		=3D esp_device_destroy,
 	.eh_abort_handler	=3D esp_eh_abort_handler,
 	.eh_bus_reset_handler	=3D esp_eh_bus_reset_handler,
 	.eh_host_reset_handler	=3D esp_eh_host_reset_handler,
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 39aec710660c..7cbd072ad582 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -269,7 +269,7 @@ static const struct scsi_host_template fcoe_shost_tem=
plate =3D {
 	.eh_abort_handler =3D fc_eh_abort,
 	.eh_device_reset_handler =3D fc_eh_device_reset,
 	.eh_host_reset_handler =3D fc_eh_host_reset,
-	.slave_alloc =3D fc_slave_alloc,
+	.device_alloc =3D fc_device_alloc,
 	.change_queue_depth =3D scsi_change_queue_depth,
 	.this_id =3D -1,
 	.cmd_per_lun =3D 3,
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.=
c
index 0044717d4486..0db2df815048 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -87,7 +87,7 @@ static struct libfc_function_template fnic_transport_te=
mplate =3D {
 	.exch_mgr_reset =3D fnic_exch_mgr_reset
 };
=20
-static int fnic_slave_alloc(struct scsi_device *sdev)
+static int fnic_device_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(sdev));
=20
@@ -106,7 +106,7 @@ static const struct scsi_host_template fnic_host_temp=
late =3D {
 	.eh_abort_handler =3D fnic_abort_cmd,
 	.eh_device_reset_handler =3D fnic_device_reset,
 	.eh_host_reset_handler =3D fnic_host_reset,
-	.slave_alloc =3D fnic_slave_alloc,
+	.device_alloc =3D fnic_device_alloc,
 	.change_queue_depth =3D scsi_change_queue_depth,
 	.this_id =3D -1,
 	.cmd_per_lun =3D 3,
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/his=
i_sas.h
index d223f482488f..378547a3884b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -645,7 +645,7 @@ extern void hisi_sas_remove(struct platform_device *p=
dev);
=20
 int hisi_sas_device_configure(struct scsi_device *sdev,
 		struct queue_limits *lim);
-extern int hisi_sas_slave_alloc(struct scsi_device *sdev);
+extern int hisi_sas_device_alloc(struct scsi_device *sdev);
 extern int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long=
 time);
 extern void hisi_sas_scan_start(struct Scsi_Host *shost);
 extern int hisi_sas_host_reset(struct Scsi_Host *shost, int reset_type);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
index 6219807ce3b9..8b03a806836a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -805,13 +805,13 @@ static int hisi_sas_init_device(struct domain_devic=
e *device)
 	return rc;
 }
=20
-int hisi_sas_slave_alloc(struct scsi_device *sdev)
+int hisi_sas_device_alloc(struct scsi_device *sdev)
 {
 	struct domain_device *ddev =3D sdev_to_domain_dev(sdev);
 	struct hisi_sas_device *sas_dev =3D ddev->lldd_dev;
 	int rc;
=20
-	rc =3D sas_slave_alloc(sdev);
+	rc =3D sas_device_alloc(sdev);
 	if (rc)
 		return rc;
=20
@@ -821,7 +821,7 @@ int hisi_sas_slave_alloc(struct scsi_device *sdev)
 	sas_dev->dev_status =3D HISI_SAS_DEV_NORMAL;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(hisi_sas_slave_alloc);
+EXPORT_SYMBOL_GPL(hisi_sas_device_alloc);
=20
 static int hisi_sas_dev_found(struct domain_device *device)
 {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v1_hw.c
index 71b5008c3552..480fc284942f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1740,7 +1740,7 @@ static const struct scsi_host_template sht_v1_hw =3D=
 {
 	.scan_finished		=3D hisi_sas_scan_finished,
 	.scan_start		=3D hisi_sas_scan_start,
 	.sg_tablesize		=3D HISI_SAS_SGE_PAGE_CNT,
-	.slave_alloc		=3D hisi_sas_slave_alloc,
+	.device_alloc		=3D hisi_sas_device_alloc,
 	.shost_groups		=3D host_v1_hw_groups,
 	.host_reset             =3D hisi_sas_host_reset,
 };
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v2_hw.c
index 342d75f12051..4651ef440a5d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3572,7 +3572,7 @@ static const struct scsi_host_template sht_v2_hw =3D=
 {
 	.scan_finished		=3D hisi_sas_scan_finished,
 	.scan_start		=3D hisi_sas_scan_start,
 	.sg_tablesize		=3D HISI_SAS_SGE_PAGE_CNT,
-	.slave_alloc		=3D hisi_sas_slave_alloc,
+	.device_alloc		=3D hisi_sas_device_alloc,
 	.shost_groups		=3D host_v2_hw_groups,
 	.sdev_groups		=3D sdev_groups_v2_hw,
 	.host_reset		=3D hisi_sas_host_reset,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v3_hw.c
index 4cd3a3eab6f1..046ff15c9202 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3336,7 +3336,7 @@ static const struct scsi_host_template sht_v3_hw =3D=
 {
 	.map_queues		=3D hisi_sas_map_queues,
 	.sg_tablesize		=3D HISI_SAS_SGE_PAGE_CNT,
 	.sg_prot_tablesize	=3D HISI_SAS_SGE_PAGE_CNT,
-	.slave_alloc		=3D hisi_sas_slave_alloc,
+	.device_alloc		=3D hisi_sas_device_alloc,
 	.shost_groups		=3D host_v3_hw_groups,
 	.sdev_groups		=3D sdev_groups_v3_hw,
 	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e044ed09d7e0..ba0a85ddb7fe 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -283,9 +283,9 @@ static int hpsa_scan_finished(struct Scsi_Host *sh,
 static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth)=
;
=20
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
-static int hpsa_slave_alloc(struct scsi_device *sdev);
+static int hpsa_device_alloc(struct scsi_device *sdev);
 static int hpsa_slave_configure(struct scsi_device *sdev);
-static void hpsa_slave_destroy(struct scsi_device *sdev);
+static void hpsa_device_destroy(struct scsi_device *sdev);
=20
 static void hpsa_update_scsi_devices(struct ctlr_info *h);
 static int check_for_unit_attention(struct ctlr_info *h,
@@ -978,9 +978,9 @@ static const struct scsi_host_template hpsa_driver_te=
mplate =3D {
 	.this_id		=3D -1,
 	.eh_device_reset_handler =3D hpsa_eh_device_reset_handler,
 	.ioctl			=3D hpsa_ioctl,
-	.slave_alloc		=3D hpsa_slave_alloc,
+	.device_alloc		=3D hpsa_device_alloc,
 	.slave_configure	=3D hpsa_slave_configure,
-	.slave_destroy		=3D hpsa_slave_destroy,
+	.device_destroy		=3D hpsa_device_destroy,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		=3D hpsa_compat_ioctl,
 #endif
@@ -2107,7 +2107,7 @@ static struct hpsa_scsi_dev_t *lookup_hpsa_scsi_dev=
(struct ctlr_info *h,
 	return NULL;
 }
=20
-static int hpsa_slave_alloc(struct scsi_device *sdev)
+static int hpsa_device_alloc(struct scsi_device *sdev)
 {
 	struct hpsa_scsi_dev_t *sd =3D NULL;
 	unsigned long flags;
@@ -2173,7 +2173,7 @@ static int hpsa_slave_configure(struct scsi_device =
*sdev)
 	return 0;
 }
=20
-static void hpsa_slave_destroy(struct scsi_device *sdev)
+static void hpsa_device_destroy(struct scsi_device *sdev)
 {
 	struct hpsa_scsi_dev_t *hdev =3D NULL;
=20
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
index e66c3ef74267..689c45e08d28 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3393,7 +3393,7 @@ static int ibmvfc_scan_finished(struct Scsi_Host *s=
host, unsigned long time)
 }
=20
 /**
- * ibmvfc_slave_alloc - Setup the device's task set value
+ * ibmvfc_device_alloc - Setup the device's task set value
  * @sdev:	struct scsi_device device to configure
  *
  * Set the device's task set value so that error handling works as
@@ -3402,7 +3402,7 @@ static int ibmvfc_scan_finished(struct Scsi_Host *s=
host, unsigned long time)
  * Returns:
  *	0 on success / -ENXIO if device does not exist
  **/
-static int ibmvfc_slave_alloc(struct scsi_device *sdev)
+static int ibmvfc_device_alloc(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost =3D sdev->host;
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(sdev));
@@ -3696,7 +3696,7 @@ static const struct scsi_host_template driver_templ=
ate =3D {
 	.eh_device_reset_handler =3D ibmvfc_eh_device_reset_handler,
 	.eh_target_reset_handler =3D ibmvfc_eh_target_reset_handler,
 	.eh_host_reset_handler =3D ibmvfc_eh_host_reset_handler,
-	.slave_alloc =3D ibmvfc_slave_alloc,
+	.device_alloc =3D ibmvfc_device_alloc,
 	.slave_configure =3D ibmvfc_slave_configure,
 	.target_alloc =3D ibmvfc_target_alloc,
 	.scan_finished =3D ibmvfc_scan_finished,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 31cf2d31cceb..30ac01f9dd72 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4745,13 +4745,13 @@ static struct ipr_resource_entry *ipr_find_sdev(s=
truct scsi_device *sdev)
 }
=20
 /**
- * ipr_slave_destroy - Unconfigure a SCSI device
+ * ipr_device_destroy - Unconfigure a SCSI device
  * @sdev:	scsi device struct
  *
  * Return value:
  * 	nothing
  **/
-static void ipr_slave_destroy(struct scsi_device *sdev)
+static void ipr_device_destroy(struct scsi_device *sdev)
 {
 	struct ipr_resource_entry *res;
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -4815,7 +4815,7 @@ static int ipr_device_configure(struct scsi_device =
*sdev,
 }
=20
 /**
- * ipr_slave_alloc - Prepare for commands to a device.
+ * ipr_device_alloc - Prepare for commands to a device.
  * @sdev:	scsi device struct
  *
  * This function saves a pointer to the resource entry
@@ -4826,7 +4826,7 @@ static int ipr_device_configure(struct scsi_device =
*sdev,
  * Return value:
  * 	0 on success / -ENXIO if device does not exist
  **/
-static int ipr_slave_alloc(struct scsi_device *sdev)
+static int ipr_device_alloc(struct scsi_device *sdev)
 {
 	struct ipr_ioa_cfg *ioa_cfg =3D (struct ipr_ioa_cfg *) sdev->host->host=
data;
 	struct ipr_resource_entry *res;
@@ -6398,9 +6398,9 @@ static const struct scsi_host_template driver_templ=
ate =3D {
 	.eh_abort_handler =3D ipr_eh_abort,
 	.eh_device_reset_handler =3D ipr_eh_dev_reset,
 	.eh_host_reset_handler =3D ipr_eh_host_reset,
-	.slave_alloc =3D ipr_slave_alloc,
+	.device_alloc =3D ipr_device_alloc,
 	.device_configure =3D ipr_device_configure,
-	.slave_destroy =3D ipr_slave_destroy,
+	.device_destroy =3D ipr_device_destroy,
 	.scan_finished =3D ipr_scan_finished,
 	.target_destroy =3D ipr_target_destroy,
 	.change_queue_depth =3D ipr_change_queue_depth,
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 80be3a936d92..b4d3ac892f44 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2222,13 +2222,13 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 EXPORT_SYMBOL(fc_eh_host_reset);
=20
 /**
- * fc_slave_alloc() - Configure the queue depth of a Scsi_Host
+ * fc_device_alloc() - Configure the queue depth of a Scsi_Host
  * @sdev: The SCSI device that identifies the SCSI host
  *
  * Configures queue depth based on host's cmd_per_len. If not set
  * then we use the libfc default.
  */
-int fc_slave_alloc(struct scsi_device *sdev)
+int fc_device_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(sdev));
=20
@@ -2238,7 +2238,7 @@ int fc_slave_alloc(struct scsi_device *sdev)
 	scsi_change_queue_depth(sdev, FC_FCP_DFLT_QUEUE_DEPTH);
 	return 0;
 }
-EXPORT_SYMBOL(fc_slave_alloc);
+EXPORT_SYMBOL(fc_device_alloc);
=20
 /**
  * fc_fcp_destroy() - Tear down the FCP layer for a given local port
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sa=
s_scsi_host.c
index da11d32840e2..83d3e42dc093 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1194,14 +1194,14 @@ void sas_task_abort(struct sas_task *task)
 }
 EXPORT_SYMBOL_GPL(sas_task_abort);
=20
-int sas_slave_alloc(struct scsi_device *sdev)
+int sas_device_alloc(struct scsi_device *sdev)
 {
 	if (dev_is_sata(sdev_to_domain_dev(sdev)) && sdev->lun)
 		return -ENXIO;
=20
 	return 0;
 }
-EXPORT_SYMBOL_GPL(sas_slave_alloc);
+EXPORT_SYMBOL_GPL(sas_device_alloc);
=20
 void sas_target_destroy(struct scsi_target *starget)
 {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.=
c
index 0eaede8275da..f0d6b6bbaae1 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6226,7 +6226,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 }
=20
 /**
- * lpfc_slave_alloc - scsi_host_template slave_alloc entry point
+ * lpfc_device_alloc - scsi_host_template device_alloc entry point
  * @sdev: Pointer to scsi_device.
  *
  * This routine populates the cmds_per_lun count + 2 scsi_bufs into  thi=
s host's
@@ -6239,7 +6239,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
  *   0 - Success
  **/
 static int
-lpfc_slave_alloc(struct scsi_device *sdev)
+lpfc_device_alloc(struct scsi_device *sdev)
 {
 	struct lpfc_vport *vport =3D (struct lpfc_vport *) sdev->host->hostdata=
;
 	struct lpfc_hba   *phba =3D vport->phba;
@@ -6371,13 +6371,13 @@ lpfc_slave_configure(struct scsi_device *sdev)
 }
=20
 /**
- * lpfc_slave_destroy - slave_destroy entry point of SHT data structure
+ * lpfc_device_destroy - device_destroy entry point of SHT data structur=
e
  * @sdev: Pointer to scsi_device.
  *
  * This routine sets @sdev hostatdata filed to null.
  **/
 static void
-lpfc_slave_destroy(struct scsi_device *sdev)
+lpfc_device_destroy(struct scsi_device *sdev)
 {
 	struct lpfc_vport *vport =3D (struct lpfc_vport *) sdev->host->hostdata=
;
 	struct lpfc_hba   *phba =3D vport->phba;
@@ -6737,7 +6737,7 @@ lpfc_no_command(struct Scsi_Host *shost, struct scs=
i_cmnd *cmnd)
 }
=20
 static int
-lpfc_no_slave(struct scsi_device *sdev)
+lpfc_no_device(struct scsi_device *sdev)
 {
 	return -ENODEV;
 }
@@ -6748,8 +6748,8 @@ struct scsi_host_template lpfc_template_nvme =3D {
 	.proc_name		=3D LPFC_DRIVER_NAME,
 	.info			=3D lpfc_info,
 	.queuecommand		=3D lpfc_no_command,
-	.slave_alloc		=3D lpfc_no_slave,
-	.slave_configure	=3D lpfc_no_slave,
+	.device_alloc		=3D lpfc_no_device,
+	.slave_configure	=3D lpfc_no_device,
 	.scan_finished		=3D lpfc_scan_finished,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D 1,
@@ -6772,9 +6772,9 @@ struct scsi_host_template lpfc_template =3D {
 	.eh_device_reset_handler =3D lpfc_device_reset_handler,
 	.eh_target_reset_handler =3D lpfc_target_reset_handler,
 	.eh_host_reset_handler  =3D lpfc_host_reset_handler,
-	.slave_alloc		=3D lpfc_slave_alloc,
+	.device_alloc		=3D lpfc_device_alloc,
 	.slave_configure	=3D lpfc_slave_configure,
-	.slave_destroy		=3D lpfc_slave_destroy,
+	.device_destroy		=3D lpfc_device_destroy,
 	.scan_finished		=3D lpfc_scan_finished,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D LPFC_DEFAULT_SG_SEG_CNT,
@@ -6799,9 +6799,9 @@ struct scsi_host_template lpfc_vport_template =3D {
 	.eh_target_reset_handler =3D lpfc_target_reset_handler,
 	.eh_bus_reset_handler	=3D NULL,
 	.eh_host_reset_handler	=3D NULL,
-	.slave_alloc		=3D lpfc_slave_alloc,
+	.device_alloc		=3D lpfc_device_alloc,
 	.slave_configure	=3D lpfc_slave_configure,
-	.slave_destroy		=3D lpfc_slave_destroy,
+	.device_destroy		=3D lpfc_device_destroy,
 	.scan_finished		=3D lpfc_scan_finished,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D LPFC_DEFAULT_SG_SEG_CNT,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
index 4ecf5284c0fc..9fba66190093 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2109,7 +2109,7 @@ static int megasas_device_configure(struct scsi_dev=
ice *sdev,
 	return 0;
 }
=20
-static int megasas_slave_alloc(struct scsi_device *sdev)
+static int megasas_device_alloc(struct scsi_device *sdev)
 {
 	u16 pd_index =3D 0, ld_tgt_id;
 	struct megasas_instance *instance ;
@@ -2154,7 +2154,7 @@ static int megasas_slave_alloc(struct scsi_device *=
sdev)
 	return 0;
 }
=20
-static void megasas_slave_destroy(struct scsi_device *sdev)
+static void megasas_device_destroy(struct scsi_device *sdev)
 {
 	u16 ld_tgt_id;
 	struct megasas_instance *instance;
@@ -3511,8 +3511,8 @@ static const struct scsi_host_template megasas_temp=
late =3D {
 	.name =3D "Avago SAS based MegaRAID driver",
 	.proc_name =3D "megaraid_sas",
 	.device_configure =3D megasas_device_configure,
-	.slave_alloc =3D megasas_slave_alloc,
-	.slave_destroy =3D megasas_slave_destroy,
+	.device_alloc =3D megasas_device_alloc,
+	.device_destroy =3D megasas_device_destroy,
 	.queuecommand =3D megasas_queue_command,
 	.eh_target_reset_handler =3D megasas_reset_target,
 	.eh_abort_handler =3D megasas_task_abort,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
index 5f2f67acf8bf..4dc9fdce42cc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4465,14 +4465,14 @@ static int mpi3mr_scan_finished(struct Scsi_Host =
*shost,
 }
=20
 /**
- * mpi3mr_slave_destroy - Slave destroy callback handler
+ * mpi3mr_device_destroy - Slave destroy callback handler
  * @sdev: SCSI device reference
  *
  * Cleanup and free per device(lun) private data.
  *
  * Return: Nothing.
  */
-static void mpi3mr_slave_destroy(struct scsi_device *sdev)
+static void mpi3mr_device_destroy(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
@@ -4599,14 +4599,14 @@ static int mpi3mr_device_configure(struct scsi_de=
vice *sdev,
 }
=20
 /**
- * mpi3mr_slave_alloc -Slave alloc callback handler
+ * mpi3mr_device_alloc -Slave alloc callback handler
  * @sdev: SCSI device reference
  *
  * Allocate per device(lun) private data and initialize it.
  *
  * Return: 0 on success -ENOMEM on memory allocation failure.
  */
-static int mpi3mr_slave_alloc(struct scsi_device *sdev)
+static int mpi3mr_device_alloc(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
@@ -5062,10 +5062,10 @@ static const struct scsi_host_template mpi3mr_dri=
ver_template =3D {
 	.proc_name			=3D MPI3MR_DRIVER_NAME,
 	.queuecommand			=3D mpi3mr_qcmd,
 	.target_alloc			=3D mpi3mr_target_alloc,
-	.slave_alloc			=3D mpi3mr_slave_alloc,
+	.device_alloc			=3D mpi3mr_device_alloc,
 	.device_configure		=3D mpi3mr_device_configure,
 	.target_destroy			=3D mpi3mr_target_destroy,
-	.slave_destroy			=3D mpi3mr_slave_destroy,
+	.device_destroy			=3D mpi3mr_device_destroy,
 	.scan_finished			=3D mpi3mr_scan_finished,
 	.scan_start			=3D mpi3mr_scan_start,
 	.change_queue_depth		=3D mpi3mr_change_queue_depth,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index 728cced42b0e..94b8acfcf933 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2026,14 +2026,14 @@ scsih_target_destroy(struct scsi_target *starget)
 }
=20
 /**
- * scsih_slave_alloc - device add routine
+ * scsih_device_alloc - device add routine
  * @sdev: scsi device struct
  *
  * Return: 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
 static int
-scsih_slave_alloc(struct scsi_device *sdev)
+scsih_device_alloc(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost;
 	struct MPT3SAS_ADAPTER *ioc;
@@ -2108,11 +2108,11 @@ scsih_slave_alloc(struct scsi_device *sdev)
 }
=20
 /**
- * scsih_slave_destroy - device destroy routine
+ * scsih_device_destroy - device destroy routine
  * @sdev: scsi device struct
  */
 static void
-scsih_slave_destroy(struct scsi_device *sdev)
+scsih_device_destroy(struct scsi_device *sdev)
 {
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct scsi_target *starget;
@@ -11905,10 +11905,10 @@ static const struct scsi_host_template mpt2sas_=
driver_template =3D {
 	.proc_name			=3D MPT2SAS_DRIVER_NAME,
 	.queuecommand			=3D scsih_qcmd,
 	.target_alloc			=3D scsih_target_alloc,
-	.slave_alloc			=3D scsih_slave_alloc,
+	.device_alloc			=3D scsih_device_alloc,
 	.device_configure		=3D scsih_device_configure,
 	.target_destroy			=3D scsih_target_destroy,
-	.slave_destroy			=3D scsih_slave_destroy,
+	.device_destroy			=3D scsih_device_destroy,
 	.scan_finished			=3D scsih_scan_finished,
 	.scan_start			=3D scsih_scan_start,
 	.change_queue_depth		=3D scsih_change_queue_depth,
@@ -11943,10 +11943,10 @@ static const struct scsi_host_template mpt3sas_=
driver_template =3D {
 	.proc_name			=3D MPT3SAS_DRIVER_NAME,
 	.queuecommand			=3D scsih_qcmd,
 	.target_alloc			=3D scsih_target_alloc,
-	.slave_alloc			=3D scsih_slave_alloc,
+	.device_alloc			=3D scsih_device_alloc,
 	.device_configure		=3D scsih_device_configure,
 	.target_destroy			=3D scsih_target_destroy,
-	.slave_destroy			=3D scsih_slave_destroy,
+	.device_destroy			=3D scsih_device_destroy,
 	.scan_finished			=3D scsih_scan_finished,
 	.scan_start			=3D scsih_scan_start,
 	.change_queue_depth		=3D scsih_change_queue_depth,
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index bfc2b835e612..fe39d95d0bdd 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1619,7 +1619,7 @@ static int myrb_queuecommand(struct Scsi_Host *shos=
t,
 	return myrb_pthru_queuecommand(shost, scmd);
 }
=20
-static int myrb_ldev_slave_alloc(struct scsi_device *sdev)
+static int myrb_ldev_device_alloc(struct scsi_device *sdev)
 {
 	struct myrb_hba *cb =3D shost_priv(sdev->host);
 	struct myrb_ldev_info *ldev_info;
@@ -1665,7 +1665,7 @@ static int myrb_ldev_slave_alloc(struct scsi_device=
 *sdev)
 	return 0;
 }
=20
-static int myrb_pdev_slave_alloc(struct scsi_device *sdev)
+static int myrb_pdev_device_alloc(struct scsi_device *sdev)
 {
 	struct myrb_hba *cb =3D shost_priv(sdev->host);
 	struct myrb_pdev_state *pdev_info;
@@ -1701,7 +1701,7 @@ static int myrb_pdev_slave_alloc(struct scsi_device=
 *sdev)
 	return 0;
 }
=20
-static int myrb_slave_alloc(struct scsi_device *sdev)
+static int myrb_device_alloc(struct scsi_device *sdev)
 {
 	if (sdev->channel > myrb_logical_channel(sdev->host))
 		return -ENXIO;
@@ -1710,9 +1710,9 @@ static int myrb_slave_alloc(struct scsi_device *sde=
v)
 		return -ENXIO;
=20
 	if (sdev->channel =3D=3D myrb_logical_channel(sdev->host))
-		return myrb_ldev_slave_alloc(sdev);
+		return myrb_ldev_device_alloc(sdev);
=20
-	return myrb_pdev_slave_alloc(sdev);
+	return myrb_pdev_device_alloc(sdev);
 }
=20
 static int myrb_slave_configure(struct scsi_device *sdev)
@@ -1741,7 +1741,7 @@ static int myrb_slave_configure(struct scsi_device =
*sdev)
 	return 0;
 }
=20
-static void myrb_slave_destroy(struct scsi_device *sdev)
+static void myrb_device_destroy(struct scsi_device *sdev)
 {
 	kfree(sdev->hostdata);
 }
@@ -2208,9 +2208,9 @@ static const struct scsi_host_template myrb_templat=
e =3D {
 	.proc_name		=3D "myrb",
 	.queuecommand		=3D myrb_queuecommand,
 	.eh_host_reset_handler	=3D myrb_host_reset,
-	.slave_alloc		=3D myrb_slave_alloc,
+	.device_alloc		=3D myrb_device_alloc,
 	.slave_configure	=3D myrb_slave_configure,
-	.slave_destroy		=3D myrb_slave_destroy,
+	.device_destroy		=3D myrb_device_destroy,
 	.bios_param		=3D myrb_biosparam,
 	.cmd_size		=3D sizeof(struct myrb_cmdblk),
 	.shost_groups		=3D myrb_shost_groups,
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 3392feb15cb4..56557addbcca 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1786,7 +1786,7 @@ static unsigned short myrs_translate_ldev(struct my=
rs_hba *cs,
 	return ldev_num;
 }
=20
-static int myrs_slave_alloc(struct scsi_device *sdev)
+static int myrs_device_alloc(struct scsi_device *sdev)
 {
 	struct myrs_hba *cs =3D shost_priv(sdev->host);
 	unsigned char status;
@@ -1910,7 +1910,7 @@ static int myrs_slave_configure(struct scsi_device =
*sdev)
 	return 0;
 }
=20
-static void myrs_slave_destroy(struct scsi_device *sdev)
+static void myrs_device_destroy(struct scsi_device *sdev)
 {
 	kfree(sdev->hostdata);
 }
@@ -1921,9 +1921,9 @@ static const struct scsi_host_template myrs_templat=
e =3D {
 	.proc_name		=3D "myrs",
 	.queuecommand		=3D myrs_queuecommand,
 	.eh_host_reset_handler	=3D myrs_host_reset,
-	.slave_alloc		=3D myrs_slave_alloc,
+	.device_alloc		=3D myrs_device_alloc,
 	.slave_configure	=3D myrs_slave_configure,
-	.slave_destroy		=3D myrs_slave_destroy,
+	.device_destroy		=3D myrs_device_destroy,
 	.cmd_size		=3D sizeof(struct myrs_cmdblk),
 	.shost_groups		=3D myrs_shost_groups,
 	.sdev_groups		=3D myrs_sdev_groups,
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 35869b4f9329..59821966d54d 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -7786,7 +7786,7 @@ static void __init ncr_getclock (struct ncb *np, in=
t mult)
=20
 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D LINUX =
ENTRY POINTS SECTION =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D*/
=20
-static int ncr53c8xx_slave_alloc(struct scsi_device *device)
+static int ncr53c8xx_device_alloc(struct scsi_device *device)
 {
 	struct Scsi_Host *host =3D device->host;
 	struct ncb *np =3D ((struct host_data *) host->hostdata)->ncb;
@@ -8094,7 +8094,7 @@ struct Scsi_Host * __init ncr_attach(struct scsi_ho=
st_template *tpnt,
=20
 	tpnt->queuecommand	=3D ncr53c8xx_queue_command;
 	tpnt->slave_configure	=3D ncr53c8xx_slave_configure;
-	tpnt->slave_alloc	=3D ncr53c8xx_slave_alloc;
+	tpnt->device_alloc	=3D ncr53c8xx_device_alloc;
 	tpnt->eh_bus_reset_handler =3D ncr53c8xx_bus_reset;
 	tpnt->can_queue		=3D SCSI_NCR_CAN_QUEUE;
 	tpnt->this_id		=3D 7;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 4c5881917d76..250a11a0716a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -125,7 +125,7 @@ MODULE_DEVICE_TABLE(pci, pmcraid_pci_table);
=20
=20
 /**
- * pmcraid_slave_alloc - Prepare for commands to a device
+ * pmcraid_device_alloc - Prepare for commands to a device
  * @scsi_dev: scsi device struct
  *
  * This function is called by mid-layer prior to sending any command to =
the new
@@ -136,7 +136,7 @@ MODULE_DEVICE_TABLE(pci, pmcraid_pci_table);
  * Return value:
  *	  0 on success / -ENXIO if device does not exist
  */
-static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
+static int pmcraid_device_alloc(struct scsi_device *scsi_dev)
 {
 	struct pmcraid_resource_entry *temp, *res =3D NULL;
 	struct pmcraid_instance *pinstance;
@@ -248,17 +248,17 @@ static int pmcraid_device_configure(struct scsi_dev=
ice *scsi_dev,
 }
=20
 /**
- * pmcraid_slave_destroy - Unconfigure a SCSI device before removing it
+ * pmcraid_device_destroy - Unconfigure a SCSI device before removing it
  *
  * @scsi_dev: scsi device struct
  *
  * This is called by mid-layer before removing a device. Pointer assignm=
ents
- * done in pmcraid_slave_alloc will be reset to NULL here.
+ * done in pmcraid_device_alloc will be reset to NULL here.
  *
  * Return value
  *   none
  */
-static void pmcraid_slave_destroy(struct scsi_device *scsi_dev)
+static void pmcraid_device_destroy(struct scsi_device *scsi_dev)
 {
 	struct pmcraid_resource_entry *res;
=20
@@ -3668,9 +3668,9 @@ static const struct scsi_host_template pmcraid_host=
_template =3D {
 	.eh_device_reset_handler =3D pmcraid_eh_device_reset_handler,
 	.eh_host_reset_handler =3D pmcraid_eh_host_reset_handler,
=20
-	.slave_alloc =3D pmcraid_slave_alloc,
+	.device_alloc =3D pmcraid_device_alloc,
 	.device_configure =3D pmcraid_device_configure,
-	.slave_destroy =3D pmcraid_slave_destroy,
+	.device_destroy =3D pmcraid_device_destroy,
 	.change_queue_depth =3D pmcraid_change_queue_depth,
 	.can_queue =3D PMCRAID_MAX_IO_CMD,
 	.this_id =3D -1,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
index 7f980e6141c2..47d7faf9b4d5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1934,7 +1934,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int re=
s)
 }
=20
 static int
-qla2xxx_slave_alloc(struct scsi_device *sdev)
+qla2xxx_device_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(sdev));
=20
@@ -1957,7 +1957,7 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 }
=20
 static void
-qla2xxx_slave_destroy(struct scsi_device *sdev)
+qla2xxx_device_destroy(struct scsi_device *sdev)
 {
 	sdev->hostdata =3D NULL;
 }
@@ -8088,8 +8088,8 @@ struct scsi_host_template qla2xxx_driver_template =3D=
 {
=20
 	.slave_configure	=3D qla2xxx_slave_configure,
=20
-	.slave_alloc		=3D qla2xxx_slave_alloc,
-	.slave_destroy		=3D qla2xxx_slave_destroy,
+	.device_alloc		=3D qla2xxx_device_alloc,
+	.device_destroy		=3D qla2xxx_device_destroy,
 	.scan_finished		=3D qla2xxx_scan_finished,
 	.scan_start		=3D qla2xxx_scan_start,
 	.change_queue_depth	=3D scsi_change_queue_depth,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
index d91f54a6e752..9cf7362ac1a9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -160,7 +160,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
-static int qla4xxx_slave_alloc(struct scsi_device *device);
+static int qla4xxx_device_alloc(struct scsi_device *device);
 static umode_t qla4_attr_is_visible(int param_type, int param);
 static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
=20
@@ -234,7 +234,7 @@ static struct scsi_host_template qla4xxx_driver_templ=
ate =3D {
 	.eh_host_reset_handler	=3D qla4xxx_eh_host_reset,
 	.eh_timed_out		=3D qla4xxx_eh_cmd_timed_out,
=20
-	.slave_alloc		=3D qla4xxx_slave_alloc,
+	.device_alloc		=3D qla4xxx_device_alloc,
 	.change_queue_depth	=3D scsi_change_queue_depth,
=20
 	.this_id		=3D -1,
@@ -9052,7 +9052,7 @@ static void qla4xxx_config_dma_addressing(struct sc=
si_qla_host *ha)
 	}
 }
=20
-static int qla4xxx_slave_alloc(struct scsi_device *sdev)
+static int qla4xxx_device_alloc(struct scsi_device *sdev)
 {
 	struct iscsi_cls_session *cls_sess;
 	struct iscsi_session *sess;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d95f417e24c0..59782c2d8053 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5881,10 +5881,10 @@ static struct sdebug_dev_info *find_build_dev_inf=
o(struct scsi_device *sdev)
 	return open_devip;
 }
=20
-static int scsi_debug_slave_alloc(struct scsi_device *sdp)
+static int scsi_debug_device_alloc(struct scsi_device *sdp)
 {
 	if (sdebug_verbose)
-		pr_info("slave_alloc <%u %u %u %llu>\n",
+		pr_info("device_alloc <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
=20
 	return 0;
@@ -5929,14 +5929,14 @@ static int scsi_debug_slave_configure(struct scsi=
_device *sdp)
 	return 0;
 }
=20
-static void scsi_debug_slave_destroy(struct scsi_device *sdp)
+static void scsi_debug_device_destroy(struct scsi_device *sdp)
 {
 	struct sdebug_dev_info *devip =3D
 		(struct sdebug_dev_info *)sdp->hostdata;
 	struct sdebug_err_inject *err;
=20
 	if (sdebug_verbose)
-		pr_info("slave_destroy <%u %u %u %llu>\n",
+		pr_info("device_destroy <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
=20
 	if (!devip)
@@ -8714,9 +8714,9 @@ static struct scsi_host_template sdebug_driver_temp=
late =3D {
 	.proc_name =3D		sdebug_proc_name,
 	.name =3D			"SCSI DEBUG",
 	.info =3D			scsi_debug_info,
-	.slave_alloc =3D		scsi_debug_slave_alloc,
+	.device_alloc =3D		scsi_debug_device_alloc,
 	.slave_configure =3D	scsi_debug_slave_configure,
-	.slave_destroy =3D	scsi_debug_slave_destroy,
+	.device_destroy =3D	scsi_debug_device_destroy,
 	.ioctl =3D		scsi_debug_ioctl,
 	.queuecommand =3D		scsi_debug_queuecommand,
 	.change_queue_depth =3D	sdebug_change_qdepth,
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c0b72199b4fa..88b8acfdacd4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -265,7 +265,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_d=
evice *sdev,
  * scsi_alloc_sdev - allocate and setup a scsi_Device
  * @starget: which target to allocate a &scsi_device for
  * @lun: which lun
- * @hostdata: usually NULL and set by ->slave_alloc instead
+ * @hostdata: usually NULL and set by ->device_alloc instead
  *
  * Description:
  *     Allocate, initialize for io, and return a pointer to a scsi_Devic=
e.
@@ -312,7 +312,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
 	sdev->sdev_gendev.parent =3D get_device(&starget->dev);
 	sdev->sdev_target =3D starget;
=20
-	/* usually NULL and set by ->slave_alloc instead */
+	/* usually NULL and set by ->device_alloc instead */
 	sdev->hostdata =3D hostdata;
=20
 	/* if the device needs this changing, it may do so in the
@@ -363,8 +363,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
=20
 	scsi_sysfs_device_initialize(sdev);
=20
-	if (shost->hostt->slave_alloc) {
-		ret =3D shost->hostt->slave_alloc(sdev);
+	if (shost->hostt->device_alloc) {
+		ret =3D shost->hostt->device_alloc(sdev);
 		if (ret) {
 			/*
 			 * if LLDD reports slave not present, don't clutter
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 32f94db6d6bf..575898ea123c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1513,8 +1513,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 	cancel_work_sync(&sdev->requeue_work);
=20
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
+	if (sdev->host->hostt->device_destroy)
+		sdev->host->hostt->device_destroy(sdev);
 	transport_destroy_device(dev);
=20
 	/*
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
index 7fd5a8c813dc..2535138544ed 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6490,7 +6490,7 @@ static int pqi_eh_abort_handler(struct scsi_cmnd *s=
cmd)
 	return SUCCESS;
 }
=20
-static int pqi_slave_alloc(struct scsi_device *sdev)
+static int pqi_device_alloc(struct scsi_device *sdev)
 {
 	struct pqi_scsi_dev *device;
 	unsigned long flags;
@@ -6574,7 +6574,7 @@ static int pqi_slave_configure(struct scsi_device *=
sdev)
 	return rc;
 }
=20
-static void pqi_slave_destroy(struct scsi_device *sdev)
+static void pqi_device_destroy(struct scsi_device *sdev)
 {
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_scsi_dev *device;
@@ -7549,9 +7549,9 @@ static const struct scsi_host_template pqi_driver_t=
emplate =3D {
 	.eh_device_reset_handler =3D pqi_eh_device_reset_handler,
 	.eh_abort_handler =3D pqi_eh_abort_handler,
 	.ioctl =3D pqi_ioctl,
-	.slave_alloc =3D pqi_slave_alloc,
+	.device_alloc =3D pqi_device_alloc,
 	.slave_configure =3D pqi_slave_configure,
-	.slave_destroy =3D pqi_slave_destroy,
+	.device_destroy =3D pqi_device_destroy,
 	.map_queues =3D pqi_map_queues,
 	.sdev_groups =3D pqi_sdev_groups,
 	.shost_groups =3D pqi_shost_groups,
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.=
c
index 9be3f0193145..a5dd3deaec26 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -42,11 +42,11 @@ module_param(snic_max_qdepth, uint, S_IRUGO | S_IWUSR=
);
 MODULE_PARM_DESC(snic_max_qdepth, "Queue depth to report for each LUN");
=20
 /*
- * snic_slave_alloc : callback function to SCSI Mid Layer, called on
+ * snic_device_alloc : callback function to SCSI Mid Layer, called on
  * scsi device initialization.
  */
 static int
-snic_slave_alloc(struct scsi_device *sdev)
+snic_device_alloc(struct scsi_device *sdev)
 {
 	struct snic_tgt *tgt =3D starget_to_tgt(scsi_target(sdev));
=20
@@ -107,7 +107,7 @@ static const struct scsi_host_template snic_host_temp=
late =3D {
 	.eh_abort_handler =3D snic_abort_cmd,
 	.eh_device_reset_handler =3D snic_device_reset,
 	.eh_host_reset_handler =3D snic_host_reset,
-	.slave_alloc =3D snic_slave_alloc,
+	.device_alloc =3D snic_device_alloc,
 	.slave_configure =3D snic_slave_configure,
 	.change_queue_depth =3D snic_change_queue_depth,
 	.this_id =3D -1,
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 7ceb982040a5..6487b029ca9f 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1875,7 +1875,7 @@ static struct scsi_host_template scsi_driver =3D {
 	.eh_host_reset_handler =3D	storvsc_host_reset_handler,
 	.proc_name =3D		"storvsc_host",
 	.eh_timed_out =3D		storvsc_eh_timed_out,
-	.slave_alloc =3D		storvsc_device_alloc,
+	.device_alloc =3D		storvsc_device_alloc,
 	.slave_configure =3D	storvsc_device_configure,
 	.cmd_per_lun =3D		2048,
 	.this_id =3D		-1,
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx=
_2/sym_glue.c
index a2560cc807d3..606196ff90f9 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -765,7 +765,7 @@ static void sym_tune_dev_queuing(struct sym_tcb *tp, =
int lun, u_short reqtags)
 	}
 }
=20
-static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
+static int sym53c8xx_device_alloc(struct scsi_device *sdev)
 {
 	struct sym_hcb *np =3D sym_get_hcb(sdev->host);
 	struct sym_tcb *tp =3D &np->target[sdev->id];
@@ -861,14 +861,14 @@ static int sym53c8xx_slave_configure(struct scsi_de=
vice *sdev)
 	return 0;
 }
=20
-static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
+static void sym53c8xx_device_destroy(struct scsi_device *sdev)
 {
 	struct sym_hcb *np =3D sym_get_hcb(sdev->host);
 	struct sym_tcb *tp =3D &np->target[sdev->id];
 	struct sym_lcb *lp =3D sym_lp(tp, sdev->lun);
 	unsigned long flags;
=20
-	/* if slave_alloc returned before allocating a sym_lcb, return */
+	/* if device_alloc returned before allocating a sym_lcb, return */
 	if (!lp)
 		return;
=20
@@ -1684,9 +1684,9 @@ static const struct scsi_host_template sym2_templat=
e =3D {
 	.info			=3D sym53c8xx_info,=20
 	.cmd_size		=3D sizeof(struct sym_ucmd),
 	.queuecommand		=3D sym53c8xx_queue_command,
-	.slave_alloc		=3D sym53c8xx_slave_alloc,
+	.device_alloc		=3D sym53c8xx_device_alloc,
 	.slave_configure	=3D sym53c8xx_slave_configure,
-	.slave_destroy		=3D sym53c8xx_slave_destroy,
+	.device_destroy		=3D sym53c8xx_device_destroy,
 	.eh_abort_handler	=3D sym53c8xx_eh_abort_handler,
 	.eh_target_reset_handler =3D sym53c8xx_eh_target_reset_handler,
 	.eh_bus_reset_handler	=3D sym53c8xx_eh_bus_reset_handler,
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 8471f38b730e..318d9e55633e 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -801,7 +801,7 @@ static const struct scsi_host_template virtscsi_host_=
template =3D {
 	.eh_abort_handler =3D virtscsi_abort,
 	.eh_device_reset_handler =3D virtscsi_device_reset,
 	.eh_timed_out =3D virtscsi_eh_timed_out,
-	.slave_alloc =3D virtscsi_device_alloc,
+	.device_alloc =3D virtscsi_device_alloc,
=20
 	.dma_boundary =3D UINT_MAX,
 	.map_queues =3D virtscsi_map_queues,
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 9ec55ddc1204..068267c16cf6 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -777,7 +777,7 @@ static const struct scsi_host_template scsifront_sht =
=3D {
 	.eh_abort_handler	=3D scsifront_eh_abort_handler,
 	.eh_device_reset_handler =3D scsifront_dev_reset_handler,
 	.slave_configure	=3D scsifront_sdev_configure,
-	.slave_destroy		=3D scsifront_sdev_destroy,
+	.device_destroy		=3D scsifront_sdev_destroy,
 	.cmd_per_lun		=3D VSCSIIF_DEFAULT_CMD_PER_LUN,
 	.can_queue		=3D VSCSIIF_MAX_REQS,
 	.this_id		=3D -1,
@@ -1075,7 +1075,7 @@ static void scsifront_do_lun_hotplug(struct vscsifr=
nt_info *info, int op)
=20
 		/*
 		 * Front device state path, used in slave_configure called
-		 * on successfull scsi_add_device, and in slave_destroy called
+		 * on successfull scsi_add_device, and in device_destroy called
 		 * on remove of a device.
 		 */
 		snprintf(info->dev_state_path, sizeof(info->dev_state_path),
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rts=
x.c
index c4f54c311d05..5b481b4d835a 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -57,7 +57,7 @@ static const char *host_info(struct Scsi_Host *host)
 	return "SCSI emulation for PCI-Express Mass Storage devices";
 }
=20
-static int slave_alloc(struct scsi_device *sdev)
+static int device_alloc(struct scsi_device *sdev)
 {
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
@@ -198,7 +198,7 @@ static const struct scsi_host_template rtsx_host_temp=
late =3D {
 	/* unknown initiator id */
 	.this_id =3D			-1,
=20
-	.slave_alloc =3D			slave_alloc,
+	.device_alloc =3D			device_alloc,
 	.slave_configure =3D		slave_configure,
=20
 	/* lots of sg segments can be handled */
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 24a32e2fd75e..35bce0d7d7a7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5182,12 +5182,12 @@ static void ufshcd_lu_init(struct ufs_hba *hba, s=
truct scsi_device *sdev)
 }
=20
 /**
- * ufshcd_slave_alloc - handle initial SCSI device configurations
+ * ufshcd_device_alloc - handle initial SCSI device configurations
  * @sdev: pointer to SCSI device
  *
  * Return: success.
  */
-static int ufshcd_slave_alloc(struct scsi_device *sdev)
+static int ufshcd_device_alloc(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba;
=20
@@ -5265,10 +5265,10 @@ static int ufshcd_device_configure(struct scsi_de=
vice *sdev,
 }
=20
 /**
- * ufshcd_slave_destroy - remove SCSI device configurations
+ * ufshcd_device_destroy - remove SCSI device configurations
  * @sdev: pointer to SCSI device
  */
-static void ufshcd_slave_destroy(struct scsi_device *sdev)
+static void ufshcd_device_destroy(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba;
 	unsigned long flags;
@@ -8973,9 +8973,9 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.map_queues		=3D ufshcd_map_queues,
 	.queuecommand		=3D ufshcd_queuecommand,
 	.mq_poll		=3D ufshcd_poll,
-	.slave_alloc		=3D ufshcd_slave_alloc,
+	.device_alloc		=3D ufshcd_device_alloc,
 	.device_configure	=3D ufshcd_device_configure,
-	.slave_destroy		=3D ufshcd_slave_destroy,
+	.device_destroy		=3D ufshcd_device_destroy,
 	.change_queue_depth	=3D ufshcd_change_queue_depth,
 	.eh_abort_handler	=3D ufshcd_abort,
 	.eh_device_reset_handler =3D ufshcd_eh_device_reset_handler,
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 9f758241d9d3..9acf80304be8 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -322,7 +322,7 @@ static inline void mts_urb_abort(struct mts_desc* des=
c) {
 	usb_kill_urb( desc->urb );
 }
=20
-static int mts_slave_alloc (struct scsi_device *s)
+static int mts_device_alloc (struct scsi_device *s)
 {
 	s->inquiry_len =3D 0x24;
 	return 0;
@@ -626,7 +626,7 @@ static const struct scsi_host_template mts_scsi_host_=
template =3D {
 	.this_id =3D		-1,
 	.emulated =3D		1,
 	.dma_alignment =3D	511,
-	.slave_alloc =3D		mts_slave_alloc,
+	.device_alloc =3D		mts_device_alloc,
 	.max_sectors=3D		256, /* 128 K */
 };
=20
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglu=
e.c
index 8c8b5e6041cc..7d5b1b7539ac 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -64,7 +64,7 @@ static const char* host_info(struct Scsi_Host *host)
 	return us->scsi_name;
 }
=20
-static int slave_alloc (struct scsi_device *sdev)
+static int device_alloc (struct scsi_device *sdev)
 {
 	struct us_data *us =3D host_to_us(sdev->host);
=20
@@ -127,7 +127,7 @@ static int device_configure(struct scsi_device *sdev,=
 struct queue_limits *lim)
 		lim->max_hw_sectors, dma_max_mapping_size(dev) >> SECTOR_SHIFT);
=20
 	/*
-	 * We can't put these settings in slave_alloc() because that gets
+	 * We can't put these settings in device_alloc() because that gets
 	 * called before the device type is known.  Consequently these
 	 * settings can't be overridden via the scsi devinfo mechanism.
 	 */
@@ -637,7 +637,7 @@ static const struct scsi_host_template usb_stor_host_=
template =3D {
 	/* unknown initiator id */
 	.this_id =3D			-1,
=20
-	.slave_alloc =3D			slave_alloc,
+	.device_alloc =3D			device_alloc,
 	.device_configure =3D		device_configure,
 	.target_alloc =3D			target_alloc,
=20
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 03043d567fa1..1192df9c4317 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -817,7 +817,7 @@ static int uas_target_alloc(struct scsi_target *starg=
et)
 	return 0;
 }
=20
-static int uas_slave_alloc(struct scsi_device *sdev)
+static int uas_device_alloc(struct scsi_device *sdev)
 {
 	struct uas_dev_info *devinfo =3D
 		(struct uas_dev_info *)sdev->host->hostdata;
@@ -905,7 +905,7 @@ static const struct scsi_host_template uas_host_templ=
ate =3D {
 	.name =3D "uas",
 	.queuecommand =3D uas_queuecommand,
 	.target_alloc =3D uas_target_alloc,
-	.slave_alloc =3D uas_slave_alloc,
+	.device_alloc =3D uas_device_alloc,
 	.device_configure =3D uas_device_configure,
 	.eh_abort_handler =3D uas_eh_abort_handler,
 	.eh_device_reset_handler =3D uas_eh_device_reset_handler,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 9b4a6ff03235..e04184b6d79b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1201,10 +1201,10 @@ extern int ata_std_bios_param(struct scsi_device =
*sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
 extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
-extern int ata_scsi_slave_alloc(struct scsi_device *sdev);
+extern int ata_scsi_device_alloc(struct scsi_device *sdev);
 int ata_scsi_device_configure(struct scsi_device *sdev,
 		struct queue_limits *lim);
-extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
+extern void ata_scsi_device_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
 extern int ata_change_queue_depth(struct ata_port *ap, struct scsi_devic=
e *sdev,
@@ -1460,8 +1460,8 @@ extern const struct attribute_group *ata_common_sde=
v_groups[];
 	.this_id		=3D ATA_SHT_THIS_ID,		\
 	.emulated		=3D ATA_SHT_EMULATED,		\
 	.proc_name		=3D drv_name,			\
-	.slave_alloc		=3D ata_scsi_slave_alloc,		\
-	.slave_destroy		=3D ata_scsi_slave_destroy,	\
+	.device_alloc		=3D ata_scsi_device_alloc,	\
+	.device_destroy		=3D ata_scsi_device_destroy,	\
 	.bios_param		=3D ata_std_bios_param,		\
 	.unlock_native_capacity	=3D ata_scsi_unlock_native_capacity,\
 	.max_sectors		=3D ATA_MAX_SECTORS_LBA48
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 4a9b4169e081..5049391c4c9a 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -963,7 +963,7 @@ int fc_queuecommand(struct Scsi_Host *, struct scsi_c=
mnd *);
 int fc_eh_abort(struct scsi_cmnd *);
 int fc_eh_device_reset(struct scsi_cmnd *);
 int fc_eh_host_reset(struct scsi_cmnd *);
-int fc_slave_alloc(struct scsi_device *);
+int fc_device_alloc(struct scsi_device *);
=20
 /*
  * ELS/CT interface
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 1324068dd950..b29eb58f4ef3 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -703,7 +703,7 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd=
);
 int sas_eh_target_reset_handler(struct scsi_cmnd *cmd);
=20
 extern void sas_target_destroy(struct scsi_target *);
-extern int sas_slave_alloc(struct scsi_device *);
+extern int sas_device_alloc(struct scsi_device *);
 extern int sas_ioctl(struct scsi_device *sdev, unsigned int cmd,
 		     void __user *arg);
 extern int sas_drain_work(struct sas_ha_struct *ha);
@@ -751,7 +751,7 @@ void sas_notify_phy_event(struct asd_sas_phy *phy, en=
um phy_event event,
=20
 #define LIBSAS_SHT_BASE			_LIBSAS_SHT_BASE		\
 	.device_configure		=3D sas_device_configure,		\
-	.slave_alloc			=3D sas_slave_alloc,		\
+	.device_alloc			=3D sas_device_alloc,		\
=20
 #define LIBSAS_SHT_BASE_NO_SLAVE_INIT	_LIBSAS_SHT_BASE
=20
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c540f5468eb..6c2e09164ad0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -155,7 +155,7 @@ struct scsi_device {
=20
 	blist_flags_t		sdev_bflags; /* black/white flags as also found in
 				 * scsi_devinfo.[hc]. For now used only to
-				 * pass settings from slave_alloc to scsi
+				 * pass settings from device_alloc to scsi
 				 * core. */
 	unsigned int eh_timeout; /* Error handling timeout */
=20
@@ -357,7 +357,7 @@ struct scsi_target {
 	atomic_t		target_blocked;
=20
 	/*
-	 * LLDs should set this in the slave_alloc host template callout.
+	 * LLDs should set this in the device_alloc host template callout.
 	 * If set to zero then there is not limit.
 	 */
 	unsigned int		can_queue;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 2b4ab0369ffb..934aae4254c3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -168,20 +168,20 @@ struct scsi_host_template {
 	 * Return values: 0 on success, non-0 on failure
 	 *
 	 * Deallocation:  If we didn't find any devices at this ID, you will
-	 * get an immediate call to slave_destroy().  If we find something
+	 * get an immediate call to device_destroy().  If we find something
 	 * here then you will get a call to slave_configure(), then the
 	 * device will be used for however long it is kept around, then when
 	 * the device is removed from the system (or * possibly at reboot
-	 * time), you will then get a call to slave_destroy().  This is
-	 * assuming you implement slave_configure and slave_destroy.
+	 * time), you will then get a call to device_destroy().  This is
+	 * assuming you implement slave_configure and device_destroy.
 	 * However, if you allocate memory and hang it off the device struct,
-	 * then you must implement the slave_destroy() routine at a minimum
+	 * then you must implement the device_destroy() routine at a minimum
 	 * in order to avoid leaking memory
 	 * each time a device is tore down.
 	 *
 	 * Status: OPTIONAL
 	 */
-	int (* slave_alloc)(struct scsi_device *);
+	int (* device_alloc)(struct scsi_device *);
=20
 	/*
 	 * Once the device has responded to an INQUIRY and we know the
@@ -206,7 +206,7 @@ struct scsi_host_template {
 	 *     specific setup basis...
 	 * 6.  Return 0 on success, non-0 on error.  The device will be marked
 	 *     as offline on error so that no access will occur.  If you return
-	 *     non-0, your slave_destroy routine will never get called for this
+	 *     non-0, your device_destroy routine will never get called for thi=
s
 	 *     device, so don't leave any loose memory hanging around, clean
 	 *     up after yourself before returning non-0
 	 *
@@ -223,11 +223,11 @@ struct scsi_host_template {
 	 * has ceased the mid layer calls this point so that the low level
 	 * driver may completely detach itself from the scsi device and vice
 	 * versa.  The low level driver is responsible for freeing any memory
-	 * it allocated in the slave_alloc or slave_configure calls.=20
+	 * it allocated in the device_alloc or slave_configure calls.=20
 	 *
 	 * Status: OPTIONAL
 	 */
-	void (* slave_destroy)(struct scsi_device *);
+	void (* device_destroy)(struct scsi_device *);
=20
 	/*
 	 * Before the mid layer attempts to scan for a new device attached
