Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55D13B7B63
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350409; cv=none; b=R1txyMimkE+X9jQRGhv4LxsA4s7X6rKnEGlCLkthGjZHuWvGUuef/GcsJmWR7hVlCGf/iN8OC/sfr0F517EcUnWcW3utFfnI2aZwe08kVgK284OUhEDC2Y6Nq32BJKwKKvCwSAANpl7xrx2kL52d7USiig4qUN0gSxccChkaKbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350409; c=relaxed/simple;
	bh=mTH3GiXT+ts+eyAWPFPoQIBEVfWqLzyD3gVB/A5x4qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WAr7DwZ5943O5+5bjdeNIPE2M5c4JwwKC20z5jqtKGr0hdsk9m1lKUPrT2qKeJ8MNEmnCJkWSVwXu9xhdT3DC1HMmBvL3sdwLAl7qSLQAd/38cmH7g796cnZlG/4JFFIdK2qXUV8At+uhe6rHloWhFT/G2fwiFDZwBJJ9AOEoKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ywaM/snO; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ywaM/snO"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0rQ10Pvzlfl5V;
	Thu, 12 Mar 2026 21:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:references:in-reply-to:x-mailer:message-id:date:date:subject
	:subject:from:from:received:received; s=mr01; t=1773350333; x=
	1775942334; bh=dgbvgvFifxs+nD6sufNhW61u4sfXaUruU2n8JBIOmlo=; b=y
	waM/snO7cKIK9/FaiOVxmhO78AmThGDT3DmyWAY1uOe8aDUDZeJSVMfsvwTfDrTW
	V89N8kjidOL5y/AbAJOvClYDJ6OF/QM1/CEODl4pcl8bxtMFCQ4H/f+BZig9uKrG
	2hQmfT2c3Qtnv8sRMJ0/vbSQ5SF9Gl4prGIdVsdet10PFxJcl8gL1aHdAmJLlq1C
	nyLk2EjZ+iF9AwlY/lKt5kDPFeZlOd5+L2JMqhWBZ99hTDkW+dPKH9hlEyoouQqx
	r+a+wuLz76SsKiezAphjNTZYRQGfgcdO0UL3by4CH91OzY8sqRfz1+m91WyKcU4C
	01lx1vQaFWQ72k7ZB1JBg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rS37Ja19vCWe; Thu, 12 Mar 2026 21:18:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0pr0kw7zlfl8L;
	Thu, 12 Mar 2026 21:18:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Hannes Reinecke <hare@suse.com>,
	Russell King <linux@armlinux.org.uk>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Yihang Li <liyihang9@h-partners.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Don Brace <don.brace@microchip.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH 35/36] scsi: Enable lock context analysis
Date: Thu, 12 Mar 2026 14:15:46 -0700
Message-ID: <20260312211636.3245119-36-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Set the CONTEXT_ANALYIS variable to 1 in all Makefiles under
drivers/scsi/ and also in the UFS Makefiles.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile                | 1 +
 drivers/scsi/aacraid/Makefile        | 2 ++
 drivers/scsi/aic7xxx/Makefile        | 2 ++
 drivers/scsi/aic7xxx/aicasm/Makefile | 3 +++
 drivers/scsi/aic94xx/Makefile        | 2 ++
 drivers/scsi/arcmsr/Makefile         | 2 ++
 drivers/scsi/arm/Makefile            | 2 ++
 drivers/scsi/be2iscsi/Makefile       | 2 ++
 drivers/scsi/bfa/Makefile            | 3 +++
 drivers/scsi/bnx2fc/Makefile         | 3 +++
 drivers/scsi/bnx2i/Makefile          | 3 +++
 drivers/scsi/csiostor/Makefile       | 2 ++
 drivers/scsi/cxgbi/Makefile          | 3 +++
 drivers/scsi/device_handler/Makefile | 3 +++
 drivers/scsi/elx/Makefile            | 1 +
 drivers/scsi/esas2r/Makefile         | 3 +++
 drivers/scsi/fcoe/Makefile           | 3 +++
 drivers/scsi/fnic/Makefile           | 3 +++
 drivers/scsi/hisi_sas/Makefile       | 3 +++
 drivers/scsi/ibmvscsi/Makefile       | 3 +++
 drivers/scsi/ibmvscsi_tgt/Makefile   | 3 +++
 drivers/scsi/isci/Makefile           | 3 +++
 drivers/scsi/libfc/Makefile          | 2 ++
 drivers/scsi/libsas/Makefile         | 2 ++
 drivers/scsi/megaraid/Makefile       | 3 +++
 drivers/scsi/mpt3sas/Makefile        | 3 +++
 drivers/scsi/mvsas/Makefile          | 2 ++
 drivers/scsi/pcmcia/Makefile         | 2 ++
 drivers/scsi/pm8001/Makefile         | 1 +
 drivers/scsi/qedf/Makefile           | 3 +++
 drivers/scsi/qedi/Makefile           | 3 +++
 drivers/scsi/qla2xxx/Makefile        | 3 +++
 drivers/scsi/qla4xxx/Makefile        | 3 +++
 drivers/scsi/smartpqi/Makefile       | 3 +++
 drivers/scsi/snic/Makefile           | 3 +++
 drivers/scsi/sym53c8xx_2/Makefile    | 2 ++
 drivers/ufs/Makefile                 | 2 ++
 drivers/ufs/core/Makefile            | 2 ++
 drivers/ufs/host/Makefile            | 2 ++
 39 files changed, 96 insertions(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 16de3e41f94c..d230dd5df5c5 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -14,6 +14,7 @@
 # satisfy certain initialization assumptions in the SCSI layer.
 # *!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
=20
+CONTEXT_ANALYSIS :=3D 1
=20
 CFLAGS_aha152x.o =3D   -DAHA152X_STAT -DAUTOCONF
=20
diff --git a/drivers/scsi/aacraid/Makefile b/drivers/scsi/aacraid/Makefil=
e
index 8f0eec682bb6..e143117528f7 100644
--- a/drivers/scsi/aacraid/Makefile
+++ b/drivers/scsi/aacraid/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Adaptec aacraid
=20
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_AACRAID) :=3D aacraid.o
=20
 aacraid-objs	:=3D linit.o aachba.o commctrl.o comminit.o commsup.o \
diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefil=
e
index 853c72a81ae0..9c49ae4d7b95 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -5,6 +5,8 @@
 # $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#8 $
 #
=20
+CONTEXT_ANALYSIS :=3D 1
+
 # Let kbuild descend into aicasm when cleaning
 subdir-				+=3D aicasm
=20
diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/=
aicasm/Makefile
index a3f2357a3f08..397d3d0706d8 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D 1
+
 PROG=3D	aicasm
=20
 OUTDIR ?=3D ./
diff --git a/drivers/scsi/aic94xx/Makefile b/drivers/scsi/aic94xx/Makefil=
e
index db9fbe3a8e4c..da4633fc4b38 100644
--- a/drivers/scsi/aic94xx/Makefile
+++ b/drivers/scsi/aic94xx/Makefile
@@ -6,6 +6,8 @@
 # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 #
=20
+CONTEXT_ANALYSIS :=3D 1
+
 ccflags-$(CONFIG_AIC94XX_DEBUG) :=3D -DASD_DEBUG -DASD_ENTER_EXIT
=20
 obj-$(CONFIG_SCSI_AIC94XX) +=3D aic94xx.o
diff --git a/drivers/scsi/arcmsr/Makefile b/drivers/scsi/arcmsr/Makefile
index 9051f66cae36..7a3df01f453b 100644
--- a/drivers/scsi/arcmsr/Makefile
+++ b/drivers/scsi/arcmsr/Makefile
@@ -2,6 +2,8 @@
 # File: drivers/arcmsr/Makefile
 # Makefile for the ARECA PCI-X PCI-EXPRESS SATA RAID controllers SCSI dr=
iver.
=20
+CONTEXT_ANALYSIS :=3D 1
+
 arcmsr-objs :=3D arcmsr_attr.o arcmsr_hba.o
=20
 obj-$(CONFIG_SCSI_ARCMSR) :=3D arcmsr.o
diff --git a/drivers/scsi/arm/Makefile b/drivers/scsi/arm/Makefile
index b576d9276f71..047956b7fdb1 100644
--- a/drivers/scsi/arm/Makefile
+++ b/drivers/scsi/arm/Makefile
@@ -3,6 +3,8 @@
 # Makefile for drivers/scsi/arm
 #
=20
+CONTEXT_ANALYSIS :=3D 1
+
 acornscsi_mod-objs	:=3D acornscsi.o acornscsi-io.o
=20
 obj-$(CONFIG_SCSI_ACORNSCSI_3)	+=3D acornscsi_mod.o queue.o msgqueue.o
diff --git a/drivers/scsi/be2iscsi/Makefile b/drivers/scsi/be2iscsi/Makef=
ile
index 910885343a75..84a962332bc3 100644
--- a/drivers/scsi/be2iscsi/Makefile
+++ b/drivers/scsi/be2iscsi/Makefile
@@ -4,6 +4,8 @@
 #
 #
=20
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_BE2ISCSI) +=3D be2iscsi.o
=20
 be2iscsi-y :=3D be_iscsi.o be_main.o be_mgmt.o be_cmds.o
diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index 442fc3db8f1f..ac1145940af1 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_BFA_FC) :=3D bfa.o
=20
 bfa-y :=3D bfad.o bfad_im.o bfad_attr.o bfad_debugfs.o bfad_bsg.o
diff --git a/drivers/scsi/bnx2fc/Makefile b/drivers/scsi/bnx2fc/Makefile
index 1d72e279a97d..0ecf6bc76755 100644
--- a/drivers/scsi/bnx2fc/Makefile
+++ b/drivers/scsi/bnx2fc/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_BNX2X_FCOE) +=3D bnx2fc.o
=20
 bnx2fc-y :=3D bnx2fc_els.o bnx2fc_fcoe.o bnx2fc_hwi.o bnx2fc_io.o bnx2fc=
_tgt.o \
diff --git a/drivers/scsi/bnx2i/Makefile b/drivers/scsi/bnx2i/Makefile
index 25378671bb1e..bf1aa2225d7d 100644
--- a/drivers/scsi/bnx2i/Makefile
+++ b/drivers/scsi/bnx2i/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 bnx2i-y :=3D bnx2i_init.o bnx2i_hwi.o bnx2i_iscsi.o bnx2i_sysfs.o
=20
 obj-$(CONFIG_SCSI_BNX2_ISCSI) +=3D bnx2i.o
diff --git a/drivers/scsi/csiostor/Makefile b/drivers/scsi/csiostor/Makef=
ile
index d047e22eac0d..747a7cd92f8b 100644
--- a/drivers/scsi/csiostor/Makefile
+++ b/drivers/scsi/csiostor/Makefile
@@ -4,6 +4,8 @@
 #
 ##
=20
+CONTEXT_ANALYSIS :=3D 1
+
 ccflags-y +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
=20
 obj-$(CONFIG_SCSI_CHELSIO_FCOE) +=3D csiostor.o
diff --git a/drivers/scsi/cxgbi/Makefile b/drivers/scsi/cxgbi/Makefile
index abfd38a26fec..8f9dfa0eccbf 100644
--- a/drivers/scsi/cxgbi/Makefile
+++ b/drivers/scsi/cxgbi/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 ccflags-y +=3D -I $(srctree)/drivers/net/ethernet/chelsio/libcxgb
=20
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+=3D libcxgbi.o cxgb3i/
diff --git a/drivers/scsi/device_handler/Makefile b/drivers/scsi/device_h=
andler/Makefile
index 0a603aefd2bb..dd66cafe39f1 100644
--- a/drivers/scsi/device_handler/Makefile
+++ b/drivers/scsi/device_handler/Makefile
@@ -2,6 +2,9 @@
 #
 # SCSI Device Handler
 #
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_DH_RDAC)	+=3D scsi_dh_rdac.o
 obj-$(CONFIG_SCSI_DH_HP_SW)	+=3D scsi_dh_hp_sw.o
 obj-$(CONFIG_SCSI_DH_EMC)	+=3D scsi_dh_emc.o
diff --git a/drivers/scsi/elx/Makefile b/drivers/scsi/elx/Makefile
index a8537d7a2a6e..54812e891940 100644
--- a/drivers/scsi/elx/Makefile
+++ b/drivers/scsi/elx/Makefile
@@ -4,6 +4,7 @@
 # * =E2=80=9CBroadcom=E2=80=9D refers to Broadcom Inc. and/or its subsid=
iaries.
 # */
=20
+CONTEXT_ANALYSIS :=3D 1
=20
 obj-$(CONFIG_SCSI_EFCT) :=3D efct.o
=20
diff --git a/drivers/scsi/esas2r/Makefile b/drivers/scsi/esas2r/Makefile
index 279d9cb3ca69..7da9246cd6c0 100644
--- a/drivers/scsi/esas2r/Makefile
+++ b/drivers/scsi/esas2r/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_ESAS2R)	+=3D esas2r.o
=20
 esas2r-objs :=3D esas2r_log.o esas2r_disc.o esas2r_flash.o esas2r_init.o=
 \
diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index 1183e80a09e7..22f534710e20 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_FCOE) +=3D fcoe.o
 obj-$(CONFIG_LIBFCOE) +=3D libfcoe.o
=20
diff --git a/drivers/scsi/fnic/Makefile b/drivers/scsi/fnic/Makefile
index c025e875009e..7f34d938b534 100644
--- a/drivers/scsi/fnic/Makefile
+++ b/drivers/scsi/fnic/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_FCOE_FNIC) +=3D fnic.o
=20
 fnic-y	:=3D \
diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makef=
ile
index 742e732cd51d..aac7025f872b 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_main.o
 obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_v1_hw.o hisi_sas_v2_hw.o
 obj-$(CONFIG_SCSI_HISI_SAS_PCI)		+=3D hisi_sas_v3_hw.o
diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makef=
ile
index 5eb1cb1a0028..79d7e2b404f2 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_IBMVSCSI)	+=3D ibmvscsi.o
 obj-$(CONFIG_SCSI_IBMVFC)	+=3D ibmvfc.o
diff --git a/drivers/scsi/ibmvscsi_tgt/Makefile b/drivers/scsi/ibmvscsi_t=
gt/Makefile
index cc7a8256dcf8..e8424050c57a 100644
--- a/drivers/scsi/ibmvscsi_tgt/Makefile
+++ b/drivers/scsi/ibmvscsi_tgt/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_IBMVSCSIS)	+=3D ibmvscsis.o
=20
 ibmvscsis-y :=3D libsrp.o ibmvscsi_tgt.o
diff --git a/drivers/scsi/isci/Makefile b/drivers/scsi/isci/Makefile
index da6f04cae272..2ac4b57d0871 100644
--- a/drivers/scsi/isci/Makefile
+++ b/drivers/scsi/isci/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_ISCI) +=3D isci.o
 isci-objs :=3D init.o phy.o request.o \
 	     remote_device.o port.o \
diff --git a/drivers/scsi/libfc/Makefile b/drivers/scsi/libfc/Makefile
index 65396f86c307..bd367bcbd1ea 100644
--- a/drivers/scsi/libfc/Makefile
+++ b/drivers/scsi/libfc/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # $Id: Makefile
=20
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_LIBFC) +=3D libfc.o
=20
 libfc-objs :=3D \
diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index 9dc32736cf21..08cd8e289ddf 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -6,6 +6,8 @@
 # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 #
=20
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_SAS_LIBSAS) +=3D libsas.o
 libsas-y +=3D  sas_init.o     \
 		sas_phy.o      \
diff --git a/drivers/scsi/megaraid/Makefile b/drivers/scsi/megaraid/Makef=
ile
index 12177e4cae65..b8fe9e975d05 100644
--- a/drivers/scsi/megaraid/Makefile
+++ b/drivers/scsi/megaraid/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_MEGARAID_MM)	+=3D megaraid_mm.o
 obj-$(CONFIG_MEGARAID_MAILBOX)	+=3D megaraid_mbox.o
 obj-$(CONFIG_MEGARAID_SAS)	+=3D megaraid_sas.o
diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefil=
e
index e76d994dbed3..1516f02f6fce 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # mpt3sas makefile
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_MPT3SAS) +=3D mpt3sas.o
 mpt3sas-y +=3D  mpt3sas_base.o     \
 		mpt3sas_config.o \
diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
index 75849258e898..48b35532896d 100644
--- a/drivers/scsi/mvsas/Makefile
+++ b/drivers/scsi/mvsas/Makefile
@@ -7,6 +7,8 @@
 # Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
 #
=20
+CONTEXT_ANALYSIS :=3D 1
+
 ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) :=3D -DMV_DEBUG
=20
 obj-$(CONFIG_SCSI_MVSAS) +=3D mvsas.o
diff --git a/drivers/scsi/pcmcia/Makefile b/drivers/scsi/pcmcia/Makefile
index 02f5b44a2685..4e66e3c0be5e 100644
--- a/drivers/scsi/pcmcia/Makefile
+++ b/drivers/scsi/pcmcia/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
=20
+CONTEXT_ANALYSIS :=3D 1
+
 ccflags-y		:=3D -I $(srctree)/drivers/scsi
=20
 # 16-bit client drivers
diff --git a/drivers/scsi/pm8001/Makefile b/drivers/scsi/pm8001/Makefile
index bbb51b7312f1..f42e12b3f485 100644
--- a/drivers/scsi/pm8001/Makefile
+++ b/drivers/scsi/pm8001/Makefile
@@ -4,6 +4,7 @@
 #
 # Copyright (C) 2008-2009  USI Co., Ltd.
=20
+CONTEXT_ANALYSIS :=3D 1
=20
 obj-$(CONFIG_SCSI_PM8001) +=3D pm80xx.o
=20
diff --git a/drivers/scsi/qedf/Makefile b/drivers/scsi/qedf/Makefile
index c46287826fb8..c646d6daad2e 100644
--- a/drivers/scsi/qedf/Makefile
+++ b/drivers/scsi/qedf/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_QEDF) :=3D qedf.o
 qedf-y =3D qedf_dbg.o qedf_main.o qedf_io.o qedf_fip.o \
 	 qedf_attr.o qedf_els.o drv_scsi_fw_funcs.o drv_fcoe_fw_funcs.o
diff --git a/drivers/scsi/qedi/Makefile b/drivers/scsi/qedi/Makefile
index d84eedfd031b..cc3b0f10e11b 100644
--- a/drivers/scsi/qedi/Makefile
+++ b/drivers/scsi/qedi/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_QEDI) :=3D qedi.o
 qedi-y :=3D qedi_main.o qedi_iscsi.o qedi_fw.o qedi_sysfs.o \
 	    qedi_dbg.o qedi_fw_api.o
diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefil=
e
index cbc1303e761e..b17bcdf76a7f 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D 1
+
 qla2xxx-y :=3D qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs=
.o \
 		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o \
 		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_nvme.o \
diff --git a/drivers/scsi/qla4xxx/Makefile b/drivers/scsi/qla4xxx/Makefil=
e
index 1f8a9096c744..1627d9e4f48a 100644
--- a/drivers/scsi/qla4xxx/Makefile
+++ b/drivers/scsi/qla4xxx/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D 1
+
 qla4xxx-y :=3D ql4_os.o ql4_init.o ql4_mbx.o ql4_iocb.o ql4_isr.o \
 		ql4_nx.o ql4_nvram.o ql4_dbg.o ql4_attr.o ql4_bsg.o ql4_83xx.o
=20
diff --git a/drivers/scsi/smartpqi/Makefile b/drivers/scsi/smartpqi/Makef=
ile
index 28985e508b5c..6606634e6341 100644
--- a/drivers/scsi/smartpqi/Makefile
+++ b/drivers/scsi/smartpqi/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_SMARTPQI) +=3D smartpqi.o
 smartpqi-objs :=3D smartpqi_init.o smartpqi_sis.o smartpqi_sas_transport=
.o
diff --git a/drivers/scsi/snic/Makefile b/drivers/scsi/snic/Makefile
index 41546e3cb701..33f51226014a 100644
--- a/drivers/scsi/snic/Makefile
+++ b/drivers/scsi/snic/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_SNIC) +=3D snic.o
=20
 snic-y :=3D \
diff --git a/drivers/scsi/sym53c8xx_2/Makefile b/drivers/scsi/sym53c8xx_2=
/Makefile
index 0751e2a0cd82..ee459a60b28b 100644
--- a/drivers/scsi/sym53c8xx_2/Makefile
+++ b/drivers/scsi/sym53c8xx_2/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Makefile for the NCR/SYMBIOS/LSI 53C8XX PCI SCSI controllers driver.
=20
+CONTEXT_ANALYSIS :=3D 1
+
 sym53c8xx-objs :=3D sym_fw.o sym_glue.o sym_hipd.o sym_malloc.o sym_nvra=
m.o
 obj-$(CONFIG_SCSI_SYM53C8XX_2) :=3D sym53c8xx.o
diff --git a/drivers/ufs/Makefile b/drivers/ufs/Makefile
index 5a199ef18d4c..3523ac5b51b3 100644
--- a/drivers/ufs/Makefile
+++ b/drivers/ufs/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
=20
+CONTEXT_ANALYSIS :=3D 1
+
 # The link order is important here. ufshcd-core must initialize
 # before vendor drivers.
 obj-$(CONFIG_SCSI_UFSHCD)	+=3D core/ host/
diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
index 51e1867e524e..4dfdb87be7d2 100644
--- a/drivers/ufs/core/Makefile
+++ b/drivers/ufs/core/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
=20
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_UFSHCD)		+=3D ufshcd-core.o
 ufshcd-core-y				+=3D ufshcd.o ufs-sysfs.o ufs-mcq.o
 ufshcd-core-$(CONFIG_RPMB)		+=3D ufs-rpmb.o
diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
index 65d8bb23ab7b..67c609c17330 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
=20
+CONTEXT_ANALYSIS :=3D 1
+
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc-g210-pci.o ufshcd-dwc.o tc=
-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o ufshcd-=
dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
