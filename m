Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF887483BCD
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 12:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524135; cv=none; b=SiqFHsudzY6l49i6o2u8aAE7QnXNoHJXrBq/8ldFciF2acqAf0k45+mOCbWpLfeysLLLmEEXjWb9UNgSGf1FjA7ibj+IvYdRTa0JQEndKrnIbOK+6fLbuZrprKgHiRfo40BtGuzcJTcuMYgL6uDAvHwM9uqBg1ctbTd1NQsu0MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524135; c=relaxed/simple;
	bh=W359OjfIbskvbCG6hATMhmlTqlki5wiJ+w5q5wdWeDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soptsEyL66/QDusNiHGAstxbZzhL1r4/wo9w+Lulzq4byQ70VsC3kB+aYjd/tzoyzNelSGTzcsnBVOxHwtTtcNsmxZRr2tCcOWEushVNPpm1B7zC9v/PSIQfHil6plXV7EZ8rzqCAsPEqL5WGmCUpbGSRJW9P8NE/DfJYpV83NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bxGjmG/i; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxGjmG/i"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6b13496112cso739471eaf.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 05:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524128; x=1789128928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wLriOncN8EXIb8r8eEWe0pNNMkRUQ8tE/RWhoaiviUA=;
        b=bxGjmG/ibY7I/013J2vQYZ2PYWKoPPw1Aq0Z91XH3IWJlK6Wxw9Uv5kex0lsEC5r+0
         rHg9J7oLAfHw/FBfTW6XVbI1hpAWTkG9/WK50vonSjghBggYeegL5d8aBbwVe/Vt30Az
         dB1qByQLYDe5Ieq5gefdrrKIeFXLPCcnpuKni/AdXEhe9jq69EuWgbvfUk0Q/B15cyW7
         K/1KdSKagKUSxdIJLGUfNhZkWK3/DdiKU/FqJKHD5ZYyT1bbG7fHY/JeWo89Rp36QFxm
         dliHCJXoefaMVgpChmBdaMf5dNv/h92yCuAGi+aQwkFXcD4sMsuG4RupcetI9jR4eXUN
         E+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524128; x=1789128928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wLriOncN8EXIb8r8eEWe0pNNMkRUQ8tE/RWhoaiviUA=;
        b=jlsd0CCzdmdfB5tJqDbQPdMZacurX8Qv6QdixMaqH3tavyv722Fb13mRGyeBSrPIvF
         chK54HtgY0FUGyj4t57f/oc20yyfLOZuKvCfQ8ebnkZcUvfB5bgSSNxHGRaRKyDoJ7L1
         TtgV4tUm30mmLQ+5km/S/RaMSnFoTSUxmIpggnPG7fiB5W3iOFKJsls1e0cmwabkvZKp
         bKC4X01IJC223rS7l5RY2VJq3dYFr1Tlsh8Ak8xOxyYgyALuyZL3hwQsUEyM60xWsp96
         iPGHbjJB+7i1kbsSUDXnl/Ictq8xLXz0ahP8CSbGqZ6eJYocC9vIxbvjKK+4aWf6C+vf
         Depw==
X-Forwarded-Encrypted: i=1; AKwUvBwkUe4wWc8DLfRCRoPAZ5Ns6HpuuLhs8E97Z5ZuvY+rSNlvW6okNnvSv0rjub16KXlHppAcKmgLRzDU@vger.kernel.org
X-Gm-Message-State: AFuF++k//1FP1BMPAHqxfyasPGm0ctoPFRGxywdF4HgbD0b7LUOuzxR4
	W+Ags9LrCb7Qn7HYWyPTd21GqiU4WUYxL5pyvwyc27IVkmsEYmqK4LHm
X-Gm-Gg: AYBFou3CBdwnJ3ON9J2Y1Lfdkd90wU13sG/rp0B1G89OlO6FgdT6vCOsg7gvOSx3njN
	5rPjP9Pw7JV+Lr17evaTJEL3X5ibWgEPytiIeOLMNymOzMEnK4BohGcgDDMlN2VrI+rFMErAcrR
	XIAhBSew7u0vHreDJMmDySQWcNshLSYSSspOmZoC0X9A4ItM8xYK66Iua5w8swQkbMUYHjXsoZT
	wEmdiBPI53E2X066KhC5xN9dM7xVBBwX7qRuhqB5JZ61f5jjau6VWbn+n2nP+bSHn41nY9gH0VQ
	CMZLFIoJ4sbEHXqU9vM0wS9aQKQb0RStj00tYmR2Ncym8EJiG55VgmrYC5xJptk8bi8xcye8dld
	2wQZYIon5XMH7eID85Upo8kq6kCklNFXdPTqYiHVqRL6zU2W4LT1mLk56Vf4uaQjKeLBtpKCfUE
	CzwaSEFxh4dIuLQWUGQnkDiAu0dIAYpKVRzYbwMjjDFKs5cZ9lICKxj0hLPqxLHKZDEHcGNQVms
	2FxbIORatI+dYmRhraKTpU/yQ==
X-Received: by 2002:a05:6820:a50e:20b0:6b7:46fa:16ac with SMTP id 006d021491bc7-6b746fa1b09mr1544916eaf.65.1788524127686;
        Fri, 04 Sep 2026 05:15:27 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432424d27asm9311666c88.2.2026.09.04.05.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:15:27 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	"Juergen E. Fischer" <fischer@norbit.de>,
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
	Bradley Grove <linuxdrivers@attotech.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Don Brace <don.brace@microchip.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Michael Reed <mdr@sgi.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Doug Gilbert <dgilbert@interlog.com>,
	Narsimhulu Musini <nmusini@cisco.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	storagedev@microchip.com,
	target-devel@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com,
	open-iscsi@googlegroups.com
Subject: [PATCH 1/2] scsi: fix typos in comments
Date: Fri,  4 Sep 2026 17:44:22 +0530
Message-ID: <20260904121449.24178-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904121449.24178-1-hemanth.selam@gmail.com>
References: <20260904121449.24178-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/scsi/aacraid/aachba.c                   |  2 +-
 drivers/scsi/aacraid/aacraid.h                  |  2 +-
 drivers/scsi/aacraid/commsup.c                  |  2 +-
 drivers/scsi/aha152x.c                          |  6 +++---
 drivers/scsi/aic7xxx/aic79xx.h                  |  8 ++++----
 drivers/scsi/aic7xxx/aic79xx_core.c             |  4 ++--
 drivers/scsi/aic7xxx/aic79xx_osm.c              |  2 +-
 drivers/scsi/aic7xxx/aic7xxx.h                  |  6 +++---
 drivers/scsi/aic7xxx/aic7xxx_core.c             |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l |  2 +-
 drivers/scsi/aic7xxx/aiclib.h                   |  2 +-
 drivers/scsi/arm/fas216.c                       |  8 ++++----
 drivers/scsi/arm/fas216.h                       |  6 +++---
 drivers/scsi/atp870u.c                          |  2 +-
 drivers/scsi/be2iscsi/be_cmds.c                 |  2 +-
 drivers/scsi/be2iscsi/be_iscsi.c                |  2 +-
 drivers/scsi/be2iscsi/be_main.c                 |  4 ++--
 drivers/scsi/be2iscsi/be_main.h                 |  6 +++---
 drivers/scsi/bfa/bfa_core.c                     |  2 +-
 drivers/scsi/bfa/bfa_defs.h                     |  2 +-
 drivers/scsi/bfa/bfa_defs_fcs.h                 |  2 +-
 drivers/scsi/bfa/bfa_defs_svc.h                 |  2 +-
 drivers/scsi/bfa/bfa_fc.h                       |  6 +++---
 drivers/scsi/bfa/bfa_fcpim.c                    |  6 +++---
 drivers/scsi/bfa/bfa_fcpim.h                    |  2 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c                |  2 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                |  4 ++--
 drivers/scsi/bfa/bfa_fcs_rport.c                |  4 ++--
 drivers/scsi/bfa/bfa_ioc.c                      |  6 +++---
 drivers/scsi/bfa/bfa_ioc.h                      |  2 +-
 drivers/scsi/bfa/bfa_svc.c                      |  2 +-
 drivers/scsi/bfa/bfa_svc.h                      |  2 +-
 drivers/scsi/bfa/bfad.c                         |  4 ++--
 drivers/scsi/bfa/bfad_bsg.c                     |  2 +-
 drivers/scsi/bfa/bfi.h                          |  4 ++--
 drivers/scsi/bfa/bfi_ms.h                       |  4 ++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c               |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                |  2 +-
 drivers/scsi/bnx2i/bnx2i.h                      |  2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c                |  2 +-
 drivers/scsi/csiostor/csio_hw.c                 |  2 +-
 drivers/scsi/csiostor/csio_hw.h                 |  2 +-
 drivers/scsi/csiostor/csio_isr.c                |  2 +-
 drivers/scsi/csiostor/csio_lnode.c              |  4 ++--
 drivers/scsi/csiostor/csio_mb.c                 |  2 +-
 drivers/scsi/csiostor/csio_scsi.c               | 14 +++++++-------
 drivers/scsi/csiostor/csio_wr.c                 |  8 ++++----
 drivers/scsi/esas2r/esas2r.h                    |  2 +-
 drivers/scsi/esas2r/esas2r_init.c               |  2 +-
 drivers/scsi/fcoe/fcoe_transport.c              |  2 +-
 drivers/scsi/fnic/fnic_main.c                   |  2 +-
 drivers/scsi/fnic/fnic_trace.h                  |  2 +-
 drivers/scsi/hpsa_cmd.h                         |  2 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c        |  2 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h        |  2 +-
 drivers/scsi/imm.c                              |  4 ++--
 drivers/scsi/ipr.c                              |  2 +-
 drivers/scsi/libfc/fc_exch.c                    |  2 +-
 drivers/scsi/megaraid.c                         |  4 ++--
 drivers/scsi/megaraid/megaraid_mbox.c           |  8 ++++----
 drivers/scsi/mpt3sas/mpi/mpi2_init.h            |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c             |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h             |  4 ++--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c              |  8 ++++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            | 12 ++++++------
 drivers/scsi/mvsas/mv_sas.h                     |  2 +-
 drivers/scsi/ncr53c8xx.c                        |  4 ++--
 drivers/scsi/pcmcia/nsp_cs.c                    |  2 +-
 drivers/scsi/pcmcia/nsp_io.h                    |  2 +-
 drivers/scsi/pm8001/pm8001_sas.h                |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h                |  4 ++--
 drivers/scsi/pmcraid.c                          |  4 ++--
 drivers/scsi/pmcraid.h                          |  2 +-
 drivers/scsi/ppa.c                              |  4 ++--
 drivers/scsi/qedf/qedf_main.c                   |  4 ++--
 drivers/scsi/qla1280.c                          |  2 +-
 drivers/scsi/qla2xxx/qla_fw.h                   |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c                 |  4 ++--
 drivers/scsi/qla2xxx/qla_nx.c                   |  2 +-
 drivers/scsi/qla2xxx/qla_os.c                   |  6 +++---
 drivers/scsi/qla2xxx/qla_target.c               |  4 ++--
 drivers/scsi/qla2xxx/qla_target.h               |  4 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c              |  2 +-
 drivers/scsi/qla4xxx/ql4_fw.h                   |  2 +-
 drivers/scsi/qla4xxx/ql4_nx.c                   |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c                   |  2 +-
 drivers/scsi/qlogicfas408.c                     |  2 +-
 drivers/scsi/scsi_error.c                       |  2 +-
 drivers/scsi/scsi_transport_iscsi.c             |  2 +-
 drivers/scsi/sd_zbc.c                           |  2 +-
 drivers/scsi/sg.c                               |  2 +-
 drivers/scsi/snic/snic_fwint.h                  |  6 +++---
 drivers/scsi/snic/snic_scsi.c                   |  4 ++--
 drivers/scsi/snic/snic_stats.h                  |  4 ++--
 drivers/scsi/st.c                               |  2 +-
 drivers/scsi/sym53c8xx_2/sym53c8xx.h            |  2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c             |  8 ++++----
 drivers/scsi/wd719x.c                           |  2 +-
 drivers/scsi/wd719x.h                           |  2 +-
 drivers/ufs/core/ufshcd.c                       |  4 ++--
 include/uapi/scsi/scsi_bsg_fc.h                 |  2 +-
 include/ufs/ufs_quirks.h                        |  2 +-
 103 files changed, 172 insertions(+), 172 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index df9492247631..4fa440fb5aa8 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2485,7 +2485,7 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 	if (aac_adapter_bounds(dev,scsicmd,lba))
 		return 0;
 	/*
-	 *	Alocate and initialize a Fib
+	 *	Allocate and initialize a Fib
 	 */
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
 	aac_priv(scsicmd)->owner = AAC_OWNER_FIRMWARE;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 0a5888b53d6d..fc9d2b962907 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -701,7 +701,7 @@ struct aac_fibhdr {
 		__le32 SenderFibAddressHigh;/* upper 32bit of phys. FIB address */
 		__le32 TimeStamp;	/* otherwise timestamp for FW internal use */
 	} u;
-	__le32 Handle;		/* FIB handle used for MSGU commnunication */
+	__le32 Handle;		/* FIB handle used for MSGU communication */
 	u32 Previous;		/* FW internal use */
 	u32 Next;		/* FW internal use */
 };
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index c4485629f792..1597c88f983f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -404,7 +404,7 @@ static int aac_get_entry (struct aac_dev * dev, u32 qid, struct aac_entry **entr
  *	@fibptr: Driver fib object to go with fib
  *	@nonotify: Don't notify the adapter
  *
- *	Gets the next free QE off the requested priorty adapter command
+ *	Gets the next free QE off the requested priority adapter command
  *	queue and associates the Fib with the QE. The QE represented by
  *	index is ready to insert on the queue when this routine returns
  *	success.
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e3ccb6bb62c0..3c2eb081d1d3 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -42,7 +42,7 @@
  * - fix for data out w/o scatter gather
  *
  * Revision 2.0  1999/12/25 15:07:32  fischer
- * - interrupt routine completly reworked
+ * - interrupt routine completely reworked
  * - basic support for new eh code
  *
  * Revision 1.21  1999/11/10 23:46:36  fischer
@@ -1381,7 +1381,7 @@ static irqreturn_t intr(int irqno, void *dev_id)
 
 /*
  * busfree phase
- * - handle completition/disconnection/error of current command
+ * - handle completion/disconnection/error of current command
  * - start selection for next command (if any)
  */
 static void busfree_run(struct Scsi_Host *shpnt)
@@ -1665,7 +1665,7 @@ static void seldi_run(struct Scsi_Host *shpnt)
  *   reconnecting nexus
  * - queue command on DISCONNECTED_SC on DISCONNECT message
  * - set completed flag on COMMAND COMPLETE
- *   (other completition code moved to busfree_run)
+ *   (other completion code moved to busfree_run)
  * - handle response to SDTR
  * - clear synchronous transfer agreements on BUS RESET
  *
diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index 59e9321815c8..ea40806bc5b4 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -275,7 +275,7 @@ typedef enum {
 	 */
 	AHD_NONPACKFIFO_BUG	= 0x4000,
 	/*
-	 * Writing to a DFF SCBPTR register may fail if concurent with
+	 * Writing to a DFF SCBPTR register may fail if concurrent with
 	 * a hardware write to the other DFF SCBPTR register.  This is
 	 * not currently a concern in our sequencer since all chips with
 	 * this bug have the AHD_NONPACKFIFO_BUG and all writes of concern
@@ -465,7 +465,7 @@ struct hardware_scb {
  * each S/G element is expired, its datacnt field is checked to see
  * if the LAST_SEG flag is set.  If so, SG_LIST_NULL is set in the
  * residual sg ptr and the transfer is considered complete.  If the
- * sequencer determines that there is a residual in the tranfer, or
+ * sequencer determines that there is a residual in the transfer, or
  * there is non-zero status, it will set the SG_STATUS_VALID flag in
  * sgptr and dma the scb back into host memory.  To sumarize:
  *
@@ -837,8 +837,8 @@ struct seeprom_config {
  * BIOS Control Bits
  */
 	uint16_t bios_control;		/* word 16 */
-#define		CFSUPREM	0x0001	/* support all removeable drives */
-#define		CFSUPREMB	0x0002	/* support removeable boot drives */
+#define		CFSUPREM	0x0001	/* support all removable drives */
+#define		CFSUPREMB	0x0002	/* support removable boot drives */
 #define		CFBIOSSTATE	0x000C	/* BIOS Action State */
 #define		    CFBS_DISABLED	0x00
 #define		    CFBS_ENABLED	0x04
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 3602a1fc40e4..09fd5b1241a1 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -4235,7 +4235,7 @@ ahd_update_pending_scbs(struct ahd_softc *ahd)
 	 * has already been setup.  The negotiation changes may
 	 * effect whether we select-out with ATN.  It is only
 	 * safe to clear ENSELO when the bus is not free and no
-	 * selection is in progres or completed.
+	 * selection is in progress or completed.
 	 */
 	saved_modes = ahd_save_modes(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
@@ -7152,7 +7152,7 @@ ahd_init(struct ahd_softc *ahd)
 		goto init_done;
 	}
 
-	/* Diable current sensing. */
+	/* Disable current sensing. */
 	ahd_write_flexport(ahd, FLXADDR_ROMSTAT_CURSENSECTL, 0);
 
 #ifdef AHD_DEBUG
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index feb1707feb7e..c9470f80626b 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -173,7 +173,7 @@ static adapter_tag_info_t aic79xx_tag_info[] =
 
 /*
  * The I/O cell on the chip is very configurable in respect to its analog
- * characteristics.  Set the defaults here; they can be overriden with
+ * characteristics.  Set the defaults here; they can be overridden with
  * the proper insmod parameters.
  */
 struct ahd_linux_iocell_opts
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 20857c213c72..5e04c532944c 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -432,7 +432,7 @@ struct hardware_scb {
  * each S/G element is expired, its datacnt field is checked to see
  * if the LAST_SEG flag is set.  If so, SG_LIST_NULL is set in the
  * residual sg ptr and the transfer is considered complete.  If the
- * sequencer determines that there is a residual in the tranfer, it
+ * sequencer determines that there is a residual in the transfer, it
  * will set the SG_RESID_VALID flag in sgptr and dma the scb back into
  * host memory.  To sumarize:
  *
@@ -785,8 +785,8 @@ struct seeprom_config {
  * BIOS Control Bits
  */
 	uint16_t bios_control;		/* word 16 */
-#define		CFSUPREM	0x0001	/* support all removeable drives */
-#define		CFSUPREMB	0x0002	/* support removeable boot drives */
+#define		CFSUPREM	0x0001	/* support all removable drives */
+#define		CFSUPREMB	0x0002	/* support removable boot drives */
 #define		CFBIOSEN	0x0004	/* BIOS enabled */
 #define		CFBIOS_BUSSCAN	0x0008	/* Have the BIOS Scan the Bus */
 #define		CFSM2DRV	0x0010	/* support more than two drives */
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index b9761f9f0bbc..547a05087c50 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -104,7 +104,7 @@ static const u_int num_phases = ARRAY_SIZE(ahc_phase_table) - 1;
 
 /*
  * Valid SCSIRATE values.  (p. 3-17)
- * Provides a mapping of tranfer periods in ns to the proper value to
+ * Provides a mapping of transfer periods in ns to the proper value to
  * stick in the scsixfer reg.
  */
 static const struct ahc_syncrate ahc_syncrates[] =
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
index 98e9959c6907..52d66ea8dbb1 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
@@ -1,6 +1,6 @@
 %{
 /*
- * Sub-Lexical Analyzer for macro invokation in 
+ * Sub-Lexical Analyzer for macro invocation in 
  * the Aic7xxx SCSI Host adapter sequencer assembler.
  *
  * Copyright (c) 2001 Adaptec Inc.
diff --git a/drivers/scsi/aic7xxx/aiclib.h b/drivers/scsi/aic7xxx/aiclib.h
index ba08eb3c4e3b..f5aa44275070 100644
--- a/drivers/scsi/aic7xxx/aiclib.h
+++ b/drivers/scsi/aic7xxx/aiclib.h
@@ -154,7 +154,7 @@ scsi_4btoul(uint8_t *bytes)
 
 #define IDIROC(x)  ((x) | ~ID_ALL_IROC_MASK)
 
-/* Generate IDs for all 16 possibilites.
+/* Generate IDs for all 16 possibilities.
  * The argument has already masked out
  * the 4 least significant bits of the device id.
  * (e.g., mask: ID_9005_GENERIC_MASK).
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index fccfacaaf1d5..a4134d25ea3c 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -405,7 +405,7 @@ static void print_debug_list(void)
 static void fas216_done(FAS216_Info *info, unsigned int result);
 
 /**
- * fas216_get_last_msg - retrive last message from the list
+ * fas216_get_last_msg - retrieve last message from the list
  * @info: interface to search
  * @pos: current fifo position
  *
@@ -2470,7 +2470,7 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
 
 /**
  * fas216_eh_device_reset - Reset the device associated with this command
- * @SCpnt: command specifing device to reset
+ * @SCpnt: command specifying device to reset
  *
  * Reset the device associated with this command.
  * Returns: FAILED if unable to reset.
@@ -2552,7 +2552,7 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 
 /**
  * fas216_eh_bus_reset - Reset the bus associated with the command
- * @SCpnt: command specifing bus to reset
+ * @SCpnt: command specifying bus to reset
  *
  * Reset the bus associated with the command.
  * Returns: FAILED if unable to reset.
@@ -2652,7 +2652,7 @@ static void fas216_init_chip(FAS216_Info *info)
 
 /**
  * fas216_eh_host_reset - Reset the host associated with this command
- * @SCpnt: command specifing host to reset
+ * @SCpnt: command specifying host to reset
  *
  * Reset the host associated with this command.
  * Returns: FAILED if unable to reset.
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 29f710f9cb51..6c6d77ab12cd 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -385,21 +385,21 @@ extern int fas216_eh_abort(struct scsi_cmnd *SCpnt);
 
 /* Function: int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
  * Purpose : Reset the device associated with this command
- * Params  : SCpnt - command specifing device to reset
+ * Params  : SCpnt - command specifying device to reset
  * Returns : FAILED if unable to reset
  */
 extern int fas216_eh_device_reset(struct scsi_cmnd *SCpnt);
 
 /* Function: int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt)
  * Purpose : Reset the complete bus associated with this command
- * Params  : SCpnt - command specifing bus to reset
+ * Params  : SCpnt - command specifying bus to reset
  * Returns : FAILED if unable to reset
  */
 extern int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt);
 
 /* Function: int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
  * Purpose : Reset the host associated with this command
- * Params  : SCpnt - command specifing host to reset
+ * Params  : SCpnt - command specifying host to reset
  * Returns : FAILED if unable to reset
  */
 extern int fas216_eh_host_reset(struct scsi_cmnd *SCpnt);
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 67459d81f479..41c9ef3ec879 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1127,7 +1127,7 @@ static void tscam(struct Scsi_Host *host, bool wide_chip, u8 scam_on)
 			}
 	while (1) {
 	/*
-	 * The funny division into multiple delays is to accomodate
+	 * The funny division into multiple delays is to accommodate
 	 * arches like ARM where udelay() multiplies its argument by
 	 * a large number to initialize a loop counter.  To avoid
 	 * overflow, the maximum supported udelay is 2000 microseconds.
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 0b59b63bce79..917a3e80b6e6 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1213,7 +1213,7 @@ int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
 }
 
 /**
- * be_cmd_set_vlan()- Configure VLAN paramters on the adapter
+ * be_cmd_set_vlan()- Configure VLAN parameters on the adapter
  * @phba: device priv structure instance
  * @vlan_tag: TAG to be set
  *
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 8d374ae863ba..04ea3d62f0f3 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -304,7 +304,7 @@ void beiscsi_iface_destroy_default(struct beiscsi_hba *phba)
 /**
  * beiscsi_iface_config_vlan()- Set the VLAN TAG
  * @shost: Scsi Host for the driver instance
- * @iface_param: Interface paramters
+ * @iface_param: Interface parameters
  *
  * Set the VLAN TAG for the adapter or disable
  * the VLAN config
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fd18d4d3d219..901579d05304 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -570,7 +570,7 @@ static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)
 }
 
 /**
- * beiscsi_get_params()- Set the config paramters
+ * beiscsi_get_params()- Set the config parameters
  * @phba: ptr  device priv structure
  **/
 static void beiscsi_get_params(struct beiscsi_hba *phba)
@@ -4188,7 +4188,7 @@ static void beiscsi_cleanup_port(struct beiscsi_hba *phba)
  * @beiscsi_conn: ptr to the conn to be cleaned up
  * @task: ptr to iscsi_task resource to be freed.
  *
- * Free driver mgmt resources binded to CXN.
+ * Free driver mgmt resources bound to CXN.
  **/
 void
 beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 71c95d144560..b6f3e74955a6 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -81,7 +81,7 @@
 
 /**
  * hardware needs the async PDU buffers to be posted in multiples of 8
- * So have atleast 8 of them by default
+ * So have at least 8 of them by default
  */
 
 #define HWI_GET_ASYNC_PDU_CTX(phwi, ulp_num)	\
@@ -236,7 +236,7 @@ struct hwi_wrb_context {
 	unsigned short free_index;
 	unsigned short wrb_handles_available;
 	unsigned short cid;
-	uint8_t ulp_num;	/* ULP to which CID binded */
+	uint8_t ulp_num;	/* ULP to which CID bound */
 	uint32_t doorbell_offset;
 };
 
@@ -956,7 +956,7 @@ struct be_ring {
 	u32 cidx;		/* consumer index */
 	u32 pidx;		/* producer index -- not used by most rings */
 	u32 item_size;		/* size in bytes of one object */
-	u8 ulp_num;	/* ULP to which CID binded */
+	u8 ulp_num;	/* ULP to which CID bound */
 	u16 register_set;
 	u16 doorbell_format;
 	u32 doorbell_offset;
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 2559df8baa05..d8cb3b94df55 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -942,7 +942,7 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 		if (pss_isr) {
 			/*
 			 * ERR_PSS bit needs to be cleared as well in case
-			 * interrups are shared so driver's interrupt handler is
+			 * interrupts are shared so driver's interrupt handler is
 			 * still called even though it is already masked out.
 			 */
 			curr_value = readl(
diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index 6abd9f42a3fc..1d5f4f838e54 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -707,7 +707,7 @@ struct bfa_boot_bootlun_s {
 #pragma pack()
 
 /*
- * BOOT boot configuraton
+ * BOOT boot configuration
  */
 struct bfa_boot_cfg_s {
 	u8		version;
diff --git a/drivers/scsi/bfa/bfa_defs_fcs.h b/drivers/scsi/bfa/bfa_defs_fcs.h
index 760606062c66..aa73a43dffa7 100644
--- a/drivers/scsi/bfa/bfa_defs_fcs.h
+++ b/drivers/scsi/bfa/bfa_defs_fcs.h
@@ -72,7 +72,7 @@ struct bfa_lport_symname_s {
 * Roles of FCS port:
  *     - FCP IM and FCP TM roles cannot be enabled together for a FCS port
  *     - Create multiple ports if both IM and TM functions required.
- *     - Atleast one role must be specified.
+ *     - At least one role must be specified.
  */
 enum bfa_lport_role {
 	BFA_LPORT_ROLE_FCP_IM	= 0x01,	/*  FCP initiator role */
diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index f2c49f0e5c8b..32ee7af08bf6 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -32,7 +32,7 @@ struct bfa_iocfc_intr_attr_s {
 };
 
 /*
- * IOC firmware configuraton
+ * IOC firmware configuration
  */
 struct bfa_iocfc_fwcfg_s {
 	u16		num_fabrics;	/*  number of fabrics		*/
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 1091aa428533..0999b8af7fe1 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -218,8 +218,8 @@ enum {
 	FC_ELS_FAN = 0x60,	/* Fabric Address Notification */
 	FC_ELS_RSCN = 0x61,	/* Reg State Change Notification */
 	FC_ELS_SCR = 0x62,	/* State Change Registration. */
-	FC_ELS_RTIN = 0x77,	/* Mangement server request */
-	FC_ELS_RNID = 0x78,	/* Mangement server request */
+	FC_ELS_RTIN = 0x77,	/* Management server request */
+	FC_ELS_RNID = 0x78,	/* Management server request */
 	FC_ELS_RLIR = 0x79,	/* Registered Link Incident Record */
 
 	FC_ELS_RPSC = 0x7D,	/* Report Port Speed Capabilities */
@@ -462,7 +462,7 @@ struct fc_rsi_s {
 };
 
 /*
- * structure for PRLI paramater pages, both request & response
+ * structure for PRLI parameter pages, both request & response
  * see FC-PH-X table 113 & 115 for explanation also FCP table 8
  */
 struct fc_prli_params_s {
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 2518e36d70d3..646798c8599b 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -741,7 +741,7 @@ bfa_itnim_sm_cleanup_delete(struct bfa_itnim_s *itnim,
 }
 
 /*
- * Rport offline. Fimrware itnim is being deleted - awaiting f/w response.
+ * Rport offline. Firmware itnim is being deleted - awaiting f/w response.
  */
 static void
 bfa_itnim_sm_fwdelete(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
@@ -2884,7 +2884,7 @@ bfa_ioim_alloc(struct bfa_s *bfa, struct bfad_ioim_s *dio,
 	struct bfa_iotag_s *iotag = NULL;
 
 	/*
-	 * alocate IOIM resource
+	 * allocate IOIM resource
 	 */
 	bfa_q_deq(&fcpim->fcp->iotag_ioim_free_q, &iotag);
 	if (!iotag) {
@@ -3398,7 +3398,7 @@ bfa_tskim_qresume(void *cbarg)
 }
 
 /*
- * Cleanup IOs associated with a task mangement command on IOC failures.
+ * Cleanup IOs associated with a task management command on IOC failures.
  */
 static void
 bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index 64e4485b226e..a89b806c68d1 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -405,7 +405,7 @@ void	bfa_cb_itnim_tov(void *itnim);
 
 /*
  * BFA notification to FCS/driver for second level error recovery.
- * Atleast one I/O request has timedout and target is unresponsive to
+ * At least one I/O request has timedout and target is unresponsive to
  * repeated abort requests. Second level error recovery should be initiated
  * by starting implicit logout and recovery procedures.
  */
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index 40e65ab28504..136d74c71537 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -744,7 +744,7 @@ bfa_cb_itnim_tov(void *cb_arg)
 /*
  *		BFA notification to FCS/driver for second level error recovery.
  *
- * Atleast one I/O request has timedout and target is unresponsive to
+ * At least one I/O request has timedout and target is unresponsive to
  * repeated abort requests. Second level error recovery should be initiated
  * by starting implicit logout and recovery procedures.
  */
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 8c9d423129c0..f40de5e172d9 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1882,7 +1882,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	len += sizeof(rhba->hba_attr_blk.attr_count);
 
 	/*
-	 * fill out the invididual entries of the HBA attrib Block
+	 * fill out the individual entries of the HBA attrib Block
 	 */
 	curr_ptr = (u8 *) &rhba->hba_attr_blk.hba_attr;
 
@@ -2214,7 +2214,7 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	len = sizeof(port_attrib->attr_count);
 
 	/*
-	 * fill out the invididual entries
+	 * fill out the individual entries
 	 */
 	curr_ptr = (u8 *) &port_attrib->port_attr;
 
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index d4bde9bbe75b..0cff934e0f36 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2231,7 +2231,7 @@ bfa_fcs_rport_process_rpsc(struct bfa_fcs_rport_s *rport,
 		RPSC_SPEED_CAP_8G;
 
 	/*
-	 * get curent speed from pport attributes from BFA
+	 * get current speed from pport attributes from BFA
 	 */
 	bfa_fcport_get_attr(port->fcs->bfa, &pport_attr);
 
@@ -2847,7 +2847,7 @@ bfa_cb_rport_qos_scn_prio(void *cbarg,
 }
 
 /*
- *		Called to process any unsolicted frames from this remote port
+ *		Called to process any unsolicited frames from this remote port
  */
 void
 bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport,
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index aa68d61a2d0d..ee8379010b87 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1527,7 +1527,7 @@ bfa_ioc_fwver_md5_check(struct bfi_ioc_image_hdr_s *fwhdr_1,
 }
 
 /*
- * Returns TRUE if major minor and maintainence are same.
+ * Returns TRUE if major minor and maintenance are same.
  * If patch versions are same, check for MD5 Checksum to be same.
  */
 static bfa_boolean_t
@@ -4157,7 +4157,7 @@ bfa_sfp_speed(struct bfa_sfp_s *sfp, enum bfa_port_speed portspeed,
 /*
  * FLASH DMA buffer should be big enough to hold both MFG block and
  * asic block(64k) at the same time and also should be 2k aligned to
- * avoid write segement to cross sector boundary.
+ * avoid write segment to cross sector boundary.
  */
 #define BFA_FLASH_SEG_SZ	2048
 #define BFA_FLASH_DMA_BUF_SZ	\
@@ -6834,7 +6834,7 @@ bfa_flash_read_start(void __iomem *pci_bar, u32 offset, u32 len,
 	int status;
 
 	/*
-	 * len must be mutiple of 4 and not exceeding fifo size
+	 * len must be multiple of 4 and not exceeding fifo size
 	 */
 	if (len == 0 || len > BFA_FLASH_FIFO_SIZE || (len & 0x03) != 0)
 		return BFA_FLASH_ERR_LEN;
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index d70332e9ad6d..6a826b3513a8 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -844,7 +844,7 @@ void	bfa_dconf_modexit(struct bfa_s *bfa);
 bfa_status_t	bfa_dconf_update(struct bfa_s *bfa);
 
 /*
- *	IOC specfic macros
+ *	IOC specific macros
  */
 #define bfa_ioc_pcifn(__ioc)		((__ioc)->pcidev.pci_func)
 #define bfa_ioc_devid(__ioc)		((__ioc)->pcidev.device_id)
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index df33afaaa673..7145672192e6 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -5480,7 +5480,7 @@ bfa_uf_start(struct bfa_s *bfa)
 }
 
 /*
- * Register handler for all unsolicted receive frames.
+ * Register handler for all unsolicited receive frames.
  *
  * @param[in]	bfa		BFA instance
  * @param[in]	ufrecv	receive handler function
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index 99a960a8a2db..22fedecb83c1 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -545,7 +545,7 @@ struct bfa_fcport_s {
 	struct bfa_fcport_ln_s	ln; /*  Link Notification */
 	struct bfa_cb_qe_s	hcb_qe;	/*  BFA callback queue elem */
 	struct bfa_timer_s	timer;	/*  timer */
-	u32		msgtag;	/*  fimrware msg tag for reply */
+	u32		msgtag;	/*  firmware msg tag for reply */
 	u8			*stats_kva;
 	u64		stats_pa;
 	union bfa_fcport_stats_u *stats;
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 448f736457f0..8a6c22175c82 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -52,7 +52,7 @@ int		msix_disable_cb = 0, msix_disable_ct = 0;
 int		max_xfer_size = BFAD_MAX_SECTORS >> 1;
 static int	max_rport_logins = BFA_FCS_MAX_RPORT_LOGINS;
 
-/* Firmware releated */
+/* Firmware related */
 u32	bfi_image_cb_size, bfi_image_ct_size, bfi_image_ct2_size;
 u32	*bfi_image_cb, *bfi_image_ct, *bfi_image_ct2;
 
@@ -1019,7 +1019,7 @@ bfad_start_ops(struct bfad_s *bfad) {
 	}
 
 	/*
-	 * If bfa_linkup_delay is set to -1 default; try to retrive the
+	 * If bfa_linkup_delay is set to -1 default; try to retrieve the
 	 * value using the bfad_get_linkup_delay(); else use the
 	 * passed in module param value as the bfa_linkup_delay.
 	 */
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 292bc9aa43f1..2e045bf91ed3 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3383,7 +3383,7 @@ bfad_im_bsg_els_ct_request(struct bsg_job *job)
 	void *req_kbuf = NULL, *rsp_kbuf = NULL;
 	int rc = -EINVAL;
 
-	job->reply_len  = sizeof(uint32_t);	/* Atleast uint32_t reply_len */
+	job->reply_len  = sizeof(uint32_t);	/* At least uint32_t reply_len */
 	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* Get the payload passed in from userspace */
diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index e1e0e967bcc3..552e30255c13 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -228,8 +228,8 @@ enum bfi_asic_gen {
 };
 
 enum bfi_asic_mode {
-	BFI_ASIC_MODE_FC	= 1,	/* FC upto 8G speed		*/
-	BFI_ASIC_MODE_FC16	= 2,	/* FC upto 16G speed		*/
+	BFI_ASIC_MODE_FC	= 1,	/* FC up to 8G speed		*/
+	BFI_ASIC_MODE_FC16	= 2,	/* FC up to 16G speed		*/
 	BFI_ASIC_MODE_ETH	= 3,	/* Ethernet ports		*/
 	BFI_ASIC_MODE_COMBO	= 4,	/* FC 16G and Ethernet 10G port	*/
 };
diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
index b9dc0b9bb814..01411b608b4c 100644
--- a/drivers/scsi/bfa/bfi_ms.h
+++ b/drivers/scsi/bfa/bfi_ms.h
@@ -742,7 +742,7 @@ struct bfi_ioim_req_s {
  *					  loss and other reasons
  *					- io-tag cannot be used yet.
  *
- *	BFI_IOIM_STS_DIF_ERR	: Firwmare detected DIF error. ex: DIF
+ *	BFI_IOIM_STS_DIF_ERR	: Firmware detected DIF error. ex: DIF
  *					CRC err or Ref Tag err or App tag err.
  *					- io-tag can be reused.
  *
@@ -772,7 +772,7 @@ enum bfi_ioim_status {
 struct bfi_ioim_rsp_s {
 	struct bfi_mhdr_s	mh;	/*  common msg header		*/
 	__be16	io_tag;		/*  completed IO tag		 */
-	u16	bfa_rport_hndl;	/*  releated rport handle	 */
+	u16	bfa_rport_hndl;	/*  related rport handle	 */
 	u8	io_status;	/*  IO completion status	 */
 	u8	reuse_io_tag;	/*  IO tag can be reused	*/
 	u16	abort_tag;	/*  host abort request tag	*/
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index c95b084cad69..8eabd87544dc 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -312,7 +312,7 @@ static int bnx2fc_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	 */
 	/*
 	 * tgt_ofld_list access is synchronized using
-	 * both hba mutex and hba lock. Atleast hba mutex or
+	 * both hba mutex and hba lock. At least hba mutex or
 	 * hba lock needs to be held for read access.
 	 */
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 9c7a541a4523..4f3240a2b6e5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -89,7 +89,7 @@ static void bnx2fc_cmd_timeout(struct work_struct *work)
 				return;
 			}
 		} else {
-			/* Hanlde IO timeout */
+			/* Handle IO timeout */
 			BNX2FC_IO_DBG(io_req, "IO timed out. issue ABTS\n");
 			if (test_and_set_bit(BNX2FC_FLAG_IO_COMPL,
 					     &io_req->req_flags)) {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 77dcdfc412b1..b4b71fada591 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -619,7 +619,7 @@ static u32 bnx2fc_alloc_conn_id(struct bnx2fc_hba *hba,
 
 	/*
 	 * tgt_ofld_list access is synchronized using
-	 * both hba mutex and hba lock. Atleast hba mutex or
+	 * both hba mutex and hba lock. At least hba mutex or
 	 * hba lock needs to be held for read access.
 	 */
 
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 7030efee5c46..9779b9c3a6c8 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -573,7 +573,7 @@ struct bnx2i_5771x_dbell {
 };
 
 /**
- * struct qp_info - QP (share queue region) atrributes structure
+ * struct qp_info - QP (share queue region) attributes structure
  *
  * @ctx_base:           ioremapped pci register base to access doorbell register
  *                      pertaining to this offloaded connection
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index d6b0bbb5176b..2bbbb4ba1ec3 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -33,7 +33,7 @@ static inline struct bnx2i_hba *bnx2i_dev_to_hba(struct device *dev)
  * @attr:	device attribute (unused)
  * @buf:	buffer to return current SQ size parameter
  *
- * Returns current SQ size parameter, this paramater determines the number
+ * Returns current SQ size parameter, this parameter determines the number
  * outstanding iSCSI commands supported on a connection
  */
 static ssize_t bnx2i_show_sq_info(struct device *dev,
diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index df9f81f29950..8e82703ce724 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -480,7 +480,7 @@ csio_hw_flash_wait_op(struct csio_hw *hw, int32_t attempts, int32_t delay)
  *	Read the specified number of 32-bit words from the serial flash.
  *	If @byte_oriented is set the read data is stored as a byte array
  *	(i.e., big-endian), otherwise as 32-bit words in the platform's
- *	natural endianess.
+ *	natural endianness.
  */
 static int
 csio_hw_read_flash(struct csio_hw *hw, uint32_t addr, uint32_t nwords,
diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index e351af6e7c81..2ed482316b90 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -374,7 +374,7 @@ enum csio_hw_ev {
 struct csio_hw_stats {
 	uint32_t	n_evt_activeq;	/* Number of event in active Q */
 	uint32_t	n_evt_freeq;	/* Number of event in free Q */
-	uint32_t	n_evt_drop;	/* Number of event droped */
+	uint32_t	n_evt_drop;	/* Number of event dropped */
 	uint32_t	n_evt_unexp;	/* Number of unexpected events */
 	uint32_t	n_pcich_offline;/* Number of pci channel offline */
 	uint32_t	n_lnlkup_miss;  /* Number of lnode lookup miss */
diff --git a/drivers/scsi/csiostor/csio_isr.c b/drivers/scsi/csiostor/csio_isr.c
index b2540402fafc..15170a2de3a6 100644
--- a/drivers/scsi/csiostor/csio_isr.c
+++ b/drivers/scsi/csiostor/csio_isr.c
@@ -174,7 +174,7 @@ csio_process_scsi_cmpl(struct csio_hw *hw, void *wr, uint32_t len,
 			 * We call scsi_done for I/Os that driver thinks aborts
 			 * have timed out. If there is a race caused by FW
 			 * completing abort at the exact same time that the
-			 * driver has deteced the abort timeout, the following
+			 * driver has detected the abort timeout, the following
 			 * check prevents calling of scsi_done twice for the
 			 * same command: once from the eh_abort_handler, another
 			 * from csio_scsi_isr_handler(). This also avoids the
diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index 78d5ecd14f65..4129fe2ad46d 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -259,7 +259,7 @@ csio_append_attrib(uint8_t **ptr, uint16_t type, void *val, size_t val_len)
 }
 
 /*
- * csio_ln_fdmi_done - FDMI registeration completion
+ * csio_ln_fdmi_done - FDMI registration completion
  * @hw: HW context
  * @fdmi_req: fdmi request
  */
@@ -1796,7 +1796,7 @@ csio_ln_mgmt_submit_wr(struct csio_mgmtm *mgmtm, struct csio_ioreq *io_req,
  * @pld_len - Payload len
  *
  *
- * This API used submit managment ELS/CT request.
+ * This API used submit management ELS/CT request.
  * This called with hw lock held
  * Returns: 0 - on success
  *	    -ENOMEM	- on error.
diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index c7b4c464f6b8..c2aa5fff747c 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -334,7 +334,7 @@ csio_mb_caps_config(struct csio_hw *hw, struct csio_mb *mbp, uint32_t tmo,
  * @portid: Port ID to get/set info
  * @wr: Write/Read PORT information.
  * @fc: Flow control
- * @caps: Port capabilites to set.
+ * @caps: Port capabilities to set.
  * @cbfn: Callback, if any.
  *
  */
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index b1de615cf316..86c08f3af3ed 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -938,12 +938,12 @@ csio_scsis_aborting(struct csio_ioreq *req, enum csio_scsi_ev evt)
 		 *    out etc). FW sent back an appropriate IT nexus loss status
 		 *    for the abort.
 		 * 4. FW sent an abort, but abort timed out (remote device
-		 *    didnt respond). FW replied back with
+		 *    didn't respond). FW replied back with
 		 *    FW_SCSI_ABORT_TIMEDOUT.
 		 * 5. FW couldn't genuinely abort the request for some reason,
 		 *    and sent us an error.
 		 *
-		 * The first 3 scenarios are treated as  succesful abort
+		 * The first 3 scenarios are treated as  successful abort
 		 * operations by the host, while the last 2 are failed attempts
 		 * to abort. Manipulate the return value of the request
 		 * appropriately, so that host can convey these results
@@ -1063,7 +1063,7 @@ csio_scsis_shost_cmpl_await(struct csio_ioreq *req, enum csio_scsi_ev evt)
 		 * FW event. In this interval, if the I/O times out at the upper
 		 * layer, a close can come in. Take the same action as abort:
 		 * return success, and hope that the remote device unregister
-		 * path will cleanup this I/O. If the FW still doesnt send
+		 * path will cleanup this I/O. If the FW still doesn't send
 		 * the msg, the close times out, and the upper layer resorts
 		 * to the next level of error recovery.
 		 */
@@ -1095,7 +1095,7 @@ csio_scsis_shost_cmpl_await(struct csio_ioreq *req, enum csio_scsi_ev evt)
  * the WR, based on WR opcode. Only on a non-good status is the entire
  * WR copied into the WR cache (ioreq->fw_wr).
  * The ioreq corresponding to the WR is returned to the caller.
- * NOTE: The SCSI queue doesnt allocate a freelist today, hence
+ * NOTE: The SCSI queue doesn't allocate a freelist today, hence
  * no freelist buffer is expected.
  */
 struct csio_ioreq *
@@ -1674,7 +1674,7 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	case FW_RDEV_NOT_READY:
 		/*
 		 * In firmware, a RDEV can get into this state
-		 * temporarily, before moving into dissapeared/lost
+		 * temporarily, before moving into disappeared/lost
 		 * state. So, the driver should complete the request equivalent
 		 * to device-disappeared!
 		 */
@@ -1968,7 +1968,7 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 
 	wait_for_completion_timeout(&ioreq->cmplobj, msecs_to_jiffies(tmo));
 
-	/* FW didnt respond to abort within our timeout */
+	/* FW didn't respond to abort within our timeout */
 	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd) {
 
 		csio_err(hw, "Abort timed out -- req: %p\n", ioreq);
@@ -2010,7 +2010,7 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
  * @req: IO request.
  *
  * Cache the result in 'cmnd', since ioreq will be freed soon
- * after we return from here, and the waiting thread shouldnt trust
+ * after we return from here, and the waiting thread shouldn't trust
  * the ioreq contents.
  */
 static void
diff --git a/drivers/scsi/csiostor/csio_wr.c b/drivers/scsi/csiostor/csio_wr.c
index aa6007a21868..a45a368dbe4b 100644
--- a/drivers/scsi/csiostor/csio_wr.c
+++ b/drivers/scsi/csiostor/csio_wr.c
@@ -80,8 +80,8 @@ static inline void
 csio_wr_ring_fldb(struct csio_hw *hw, struct csio_q *flq)
 {
 	/*
-	 * Ring the doorbell only when we have atleast CSIO_QCREDIT_SZ
-	 * number of bytes in the freelist queue. This translates to atleast
+	 * Ring the doorbell only when we have at least CSIO_QCREDIT_SZ
+	 * number of bytes in the freelist queue. This translates to at least
 	 * 8 freelist buffer pointers (since each pointer is 8 bytes).
 	 */
 	if (flq->inc_idx >= 8) {
@@ -296,7 +296,7 @@ csio_wr_alloc_q(struct csio_hw *hw, uint32_t qsize, uint32_t wrsize,
 				return -1;
 
 			/*
-			 * Make sure in a FLQ, atleast 1 credit (8 FL buffers)
+			 * Make sure in a FLQ, at least 1 credit (8 FL buffers)
 			 * remains unpopulated,otherwise HW thinks
 			 * FLQ is empty.
 			 */
@@ -1235,7 +1235,7 @@ csio_wr_process_iq(struct csio_hw *hw, struct csio_q *q,
 	if (flq) {
 		uint32_t avail  = csio_wr_avail_qcredits(flq);
 		if (avail <= 16) {
-			/* Make sure in FLQ, atleast 1 credit (8 FL buffers)
+			/* Make sure in FLQ, at least 1 credit (8 FL buffers)
 			 * remains unpopulated otherwise HW thinks
 			 * FLQ is empty.
 			 */
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index a763edd05fe4..d8e9053905ff 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -88,7 +88,7 @@ extern int sg_tablesize;
 extern int interrupt_mode;
 extern int num_io_requests;
 
-/* Macro defintions */
+/* Macro definitions */
 #define ESAS2R_MAX_ID        255
 #define MAX_ADAPTERS         32
 #define ESAS2R_DRVR_NAME     "esas2r"
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 0a35f1953768..06ee2c2d024e 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -672,7 +672,7 @@ static int __maybe_unused esas2r_resume(struct device *dev)
 		goto error_exit;
 	}
 
-	/* Set up interupt mode */
+	/* Set up interrupt mode */
 	esas2r_setup_interrupts(a, a->intr_mode);
 
 	/*
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 2bbb9a38e61d..a8704ea7cae5 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -302,7 +302,7 @@ EXPORT_SYMBOL_GPL(fcoe_get_wwn);
 
 /**
  * fcoe_fc_crc() - Calculates the CRC for a given frame
- * @fp: The frame to be checksumed
+ * @fp: The frame to be checksummed
  *
  * This uses crc32() routine to calculate the CRC for a frame
  *
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 9b3025007075..83cddf799ee8 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -502,7 +502,7 @@ static int fnic_dev_wait(struct vnic_dev *vdev,
 	* Sometime schedule_timeout_uninterruptible take long time
 	* to wake up so we do not retry as we are only waiting for
 	* 2 seconds in while loop. By adding count, we make sure
-	* we try atleast three times before returning -ETIMEDOUT
+	* we try at least three times before returning -ETIMEDOUT
 	*/
 	time = jiffies + (HZ * 2);
 	do {
diff --git a/drivers/scsi/fnic/fnic_trace.h b/drivers/scsi/fnic/fnic_trace.h
index d1c301bf3fde..f160d627475a 100644
--- a/drivers/scsi/fnic/fnic_trace.h
+++ b/drivers/scsi/fnic/fnic_trace.h
@@ -100,7 +100,7 @@ void fnic_debugfs_terminate(void);
 void fnic_trace_debugfs_init(void);
 void fnic_trace_debugfs_terminate(void);
 
-/* Fnic FC CTLR Trace releated function */
+/* Fnic FC CTLR Trace related function */
 int fnic_fc_trace_init(void);
 void fnic_fc_trace_free(void);
 int fnic_fc_trace_set_data(u32 host_no, u8 frame_type,
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index ba6a3aa8d954..2ba199ad8707 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -25,7 +25,7 @@
 #include <linux/build_bug.h> /* static_assert */
 #include <linux/stddef.h> /* offsetof */
 
-/* general boundary defintions */
+/* general boundary definitions */
 #define SENSEINFOBYTES          32 /* may vary between hbas */
 #define SG_ENTRIES_IN_CMD	32 /* Max SG entries excluding chain blocks */
 #define HPSA_SG_CHAIN		0x80000000
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 61f682800765..ecef1157093f 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1198,7 +1198,7 @@ static void ibmvscsis_poll_cmd_q(struct scsi_info *vscsi)
 				rc = ibmvscsis_trans_event(vscsi, crq);
 			} else if (vscsi->flags & TRANS_EVENT) {
 				/*
-				 * if a tranport event has occurred leave
+				 * if a transport event has occurred leave
 				 * everything but transport events on the queue
 				 */
 				dev_dbg(&vscsi->dev, "poll_cmd_q, ignoring\n");
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
index 7ae074e5d7a1..48ee8f33fa8e 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
@@ -194,7 +194,7 @@ struct scsi_info {
 	struct list_head list;
 	char eye[MAX_EYE];
 
-	/* commands waiting for space on repsonse queue */
+	/* commands waiting for space on response queue */
 	struct list_head waiting_rsp;
 #define NO_QUEUE                    0x00
 #define WAIT_ENABLED                0X01
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 0535252e77e3..b0fa538a4698 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -652,7 +652,7 @@ static int imm_completion(struct scsi_cmnd *const cmd)
 		(v == READ_10) || (v == WRITE_6) || (v == WRITE_10));
 
 	/*
-	 * We only get here if the drive is ready to comunicate,
+	 * We only get here if the drive is ready to communicate,
 	 * hence no need for a full imm_wait.
 	 */
 	w_ctr(ppb, 0x0c);
@@ -714,7 +714,7 @@ static int imm_completion(struct scsi_cmnd *const cmd)
 					scsi_pointer->this_residual++;
 			}
 		}
-		/* Now check to see if the drive is ready to comunicate */
+		/* Now check to see if the drive is ready to communicate */
 		w_ctr(ppb, 0x0c);
 		r = (r_str(ppb) & 0xb8);
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d207e5e81afe..abe6cb773c6d 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8247,7 +8247,7 @@ static int ipr_reset_cancel_hcam_done(struct ipr_cmnd *ipr_cmd)
  * ipr_reset_cancel_hcam - Cancel outstanding HCAMs
  * @ipr_cmd:	ipr command struct
  *
- * Description: Cancel any oustanding HCAMs to the IOA.
+ * Description: Cancel any outstanding HCAMs to the IOA.
  *
  * Return value:
  * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 9183a0e9568a..bf993908d7c9 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -198,7 +198,7 @@ static void fc_exch_els_rrq(struct fc_frame *);
  *
  * To protect against concurrency between a worker thread code and timers,
  * sequence allocation and deallocation must be locked.
- *  - exchange refcnt can be done atomicly without locks.
+ *  - exchange refcnt can be done atomically without locks.
  *  - sequence allocation must be locked by exch lock.
  *  - If the EM pool lock and ex_lock must be taken at the same time, then the
  *    EM pool lock must be taken before the ex_lock.
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9476a0d2c72d..4833e3043e61 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1009,7 +1009,7 @@ mega_prepare_passthru(adapter_t *adapter, scb_t *scb, struct scsi_cmnd *cmd,
  * @channel: actual channel on the controller
  * @target: actual id on the controller.
  *
- * prepare a command for the scsi physical devices. This rountine prepares
+ * prepare a command for the scsi physical devices. This routine prepares
  * commands for devices which can take extended CDBs (>10 bytes)
  */
 static mega_ext_passthru *
@@ -2986,7 +2986,7 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	 * mega_m_to_n() copies the data from the user space, so we do not
 	 * have to do it here.
 	 * NOTE: We will need some user address to copyout the data, therefore
-	 * the inteface layer will also provide us with the required user
+	 * the interface layer will also provide us with the required user
 	 * addresses.
 	 */
 	memset(&uioc, 0, sizeof(nitioctl_t));
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index ce89032a5a74..2fb4c17f3974 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -401,7 +401,7 @@ megaraid_exit(void)
  * @id		: pci device id of the class of controllers
  *
  * This routine should be called whenever a new adapter is detected by the
- * PCI hotplug susbsystem.
+ * PCI hotplug subsystem.
  */
 static int
 megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -1164,7 +1164,7 @@ megaraid_mbox_setup_dma_pools(adapter_t *adapter)
 	}
 
 	/*
-	 * Allocate memory for each embedded passthru strucuture pointer
+	 * Allocate memory for each embedded passthru structure pointer
 	 * Request for a 128 bytes aligned structure for each passthru command
 	 * structure
 	 * Since passthru and extended passthru commands are exclusive, they
@@ -3299,7 +3299,7 @@ megaraid_mbox_fire_sync_cmd(adapter_t *adapter)
  * @adapter		: controller's soft state
  * @scb			: SCB to be displayed
  *
- * Diplay information about the given SCB iff the current debug level is
+ * Display information about the given SCB iff the current debug level is
  * verbose.
  */
 static void
@@ -3723,7 +3723,7 @@ megaraid_mbox_mm_done(adapter_t *adapter, scb_t *scb)
 /**
  * gather_hbainfo - HBA characteristics for the applications
  * @adapter		: HBA soft state
- * @hinfo		: pointer to the caller's host info strucuture
+ * @hinfo		: pointer to the caller's host info structure
  */
 static int
 gather_hbainfo(adapter_t *adapter, mraid_hba_info_t *hinfo)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_init.h b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
index 8f1b903fe0a9..964e1248acd7 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_init.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
@@ -27,7 +27,7 @@
  * 05-21-08  02.00.05  Fixed typo in name of Mpi2SepRequest_t.
  * 10-02-08  02.00.06  Removed Untagged and No Disconnect values from SCSI IO
  *                     Control field Task Attribute flags.
- *                     Moved LUN field defines to mpi2.h becasue they are
+ *                     Moved LUN field defines to mpi2.h because they are
  *                     common to many structures.
  * 05-06-09  02.00.07  Changed task management type of Query Unit Attention to
  *                     Query Asynchronous Event.
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index fed7aeffec58..fd6d79e3afd5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1951,7 +1951,7 @@ _base_irqpoll(struct irq_poll *irqpoll, int budget)
 }
 
 /**
- * _base_init_irqpolls - initliaze IRQ polls
+ * _base_init_irqpolls - initialize IRQ polls
  * @ioc: per adapter object
  *
  * Return: nothing
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 47255bf9cdda..458a716b7f7d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1296,14 +1296,14 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @sense_dma_pool:
  * @reply_depth: hba reply queue depth:
  * @reply_sz: per reply frame size:
- * @reply: pool of replys:
+ * @reply: pool of replies:
  * @reply_dma:
  * @reply_dma_pool:
  * @reply_free_queue_depth: reply free depth
  * @reply_free: pool for reply free queue (32 bit addr)
  * @reply_free_dma:
  * @reply_free_dma_pool:
- * @reply_free_host_index: tail index in pool to insert free replys
+ * @reply_free_host_index: tail index in pool to insert free replies
  * @reply_post_queue_depth: reply post queue depth
  * @reply_post_struct: struct for reply_post_free physical & virt address
  * @rdpq_array_capable: FW supports multiple reply queue addresses in ioc_init
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8bb947004885..5a35ef56fc72 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3324,7 +3324,7 @@ static DEVICE_ATTR_RO(board_tracer);
  * @attr: ?
  * @buf: the buffer returned
  *
- * This is for firmware implemention for deboucing device
+ * This is for firmware implementation for deboucing device
  * removal events.
  *
  * A sysfs 'read-only' shost attribute.
@@ -3346,7 +3346,7 @@ static DEVICE_ATTR_RO(io_delay);
  * @attr: ?
  * @buf: the buffer returned
  *
- * This is for firmware implemention for deboucing device
+ * This is for firmware implementation for deboucing device
  * removal events.
  *
  * A sysfs 'read-only' shost attribute.
@@ -3830,7 +3830,7 @@ host_trace_buffer_enable_store(struct device *cdev,
 }
 static DEVICE_ATTR_RW(host_trace_buffer_enable);
 
-/*********** diagnostic trigger suppport *********************************/
+/*********** diagnostic trigger support *********************************/
 
 /**
  * diag_trigger_master_show - show the diag_trigger_master attribute
@@ -4129,7 +4129,7 @@ diag_trigger_mpi_store(struct device *cdev,
 
 static DEVICE_ATTR_RW(diag_trigger_mpi);
 
-/*********** diagnostic trigger suppport *** END ****************************/
+/*********** diagnostic trigger support *** END ****************************/
 
 /*****************************************/
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0e12009a87f6..aa2667e58ca3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4380,7 +4380,7 @@ _scsih_block_io_to_pcie_children_attached_directly(struct MPT3SAS_ADAPTER *ioc,
  * using high priority request queue.  It will send a sas iounit
  * control request (MPI2_SAS_OP_REMOVE_DEVICE) from this completion.
  *
- * This is designed to send muliple task management request at the same
+ * This is designed to send multiple task management request at the same
  * time to the fifo. If the fifo is full, we will append the request,
  * and process it in a future completion.
  */
@@ -4684,7 +4684,7 @@ _scsih_sas_control_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid,
  * @handle: device handle
  * Context: interrupt time.
  *
- * This is designed to send muliple task management request at the same
+ * This is designed to send multiple task management request at the same
  * time to the fifo. If the fifo is full, we will append the request,
  * and process it in a future completion.
  */
@@ -4919,7 +4919,7 @@ mpt3sas_check_for_pending_internal_cmds(struct MPT3SAS_ADAPTER *ioc, u16 smid)
  * @smid: system request message index
  *
  * This will check delayed target reset list, and feed the
- * next reqeust.
+ * next request.
  *
  * Return: 1 meaning mf should be freed from _base_interrupt
  *         0 means the mf is freed from this function.
@@ -13028,7 +13028,7 @@ _scsih_probe_devices(struct MPT3SAS_ADAPTER *ioc)
  * @shost: SCSI host pointer
  *
  * The shost has the ability to discover targets on its own instead
- * of scanning the entire bus.  In our implemention, we will kick off
+ * of scanning the entire bus.  In our implementation, we will kick off
  * firmware discovery.
  */
 static void
@@ -13076,7 +13076,7 @@ static void _scsih_complete_devices_scanning(struct MPT3SAS_ADAPTER *ioc)
  * @time: elapsed time of the scan in jiffies
  *
  * This function will be called periodicallyn until it returns 1 with the
- * scsi_host and the elapsed time of the scan in jiffies. In our implemention,
+ * scsi_host and the elapsed time of the scan in jiffies. In our implementation,
  * we wait for firmware discovery to complete, then return 1.
  */
 static int
@@ -14039,7 +14039,7 @@ scsih_init(void)
 
 	mpt3sas_base_initialize_callback_handler();
 
-	 /* queuecommand callback hander */
+	 /* queuecommand callback handler */
 	scsi_io_cb_idx = mpt3sas_base_register_callback_handler(_scsih_io_done);
 
 	/* task management callback handler */
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 7521f969aa87..ab67511646e8 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -236,7 +236,7 @@ struct mvs_device {
 	u16 reserved;
 };
 
-/* Generate  PHY tunning parameters */
+/* Generate  PHY tuning parameters */
 struct phy_tuning {
 	/* 1 bit,  transmitter emphasis enable	*/
 	u8	trans_emp_en:1;
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 5369ca3fe4fd..cb821e0cc19f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -2220,7 +2220,7 @@ static	struct script script0 __initdata = {
 
 }/*-------------------------< NO_DATA >--------------------*/,{
 	/*
-	**	The target wants to tranfer too much data
+	**	The target wants to transfer too much data
 	**	or in the wrong direction.
 	**      Remember that in extended error.
 	*/
@@ -7055,7 +7055,7 @@ static struct ccb *ncr_get_ccb(struct ncb *np, struct scsi_cmnd *cmd)
 	}
 
 	/*
-	**	Remember all informations needed to free this CCB.
+	**	Remember all information needed to free this CCB.
 	*/
 	cp->tag	   = tag;
 	cp->target = tn;
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index ae70fda96ae9..1e64d4168cfb 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -683,7 +683,7 @@ static void nsp_reselected(struct scsi_cmnd *SCpnt)
 }
 
 /*
- * count how many data transferd
+ * count how many data transferred
  */
 static int nsp_fifo_count(struct scsi_cmnd *SCpnt)
 {
diff --git a/drivers/scsi/pcmcia/nsp_io.h b/drivers/scsi/pcmcia/nsp_io.h
index 3b8746f85b6c..f10d39fc6611 100644
--- a/drivers/scsi/pcmcia/nsp_io.h
+++ b/drivers/scsi/pcmcia/nsp_io.h
@@ -1,5 +1,5 @@
 /*
-  NinjaSCSI I/O funtions 
+  NinjaSCSI I/O functions 
       By: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
  
   This software may be used and distributed according to the terms of
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index b63b6ffcaaf5..5464e3d1e8d8 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -314,7 +314,7 @@ struct mpi_mem {
 struct mpi_mem_req {
 	/* The number of element in the  mpiMemory array */
 	u32			count;
-	/* The array of structures that define memroy regions*/
+	/* The array of structures that define memory regions*/
 	struct mpi_mem		region[USI_MAX_MEMCNT];
 };
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index d8a63b7fed6a..7aebc780972e 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -964,7 +964,7 @@ struct dek_mgmt_req {
 
 /**
  * brief the data structure for SET PHY PROFILE COMMAND
- * use to retrive phy specific information
+ * use to retrieve phy specific information
  */
 struct set_phy_profile_req {
 	__le32	tag;
@@ -974,7 +974,7 @@ struct set_phy_profile_req {
 
 /**
  * brief the data structure for GET PHY PROFILE COMMAND
- * use to retrive phy specific information
+ * use to retrieve phy specific information
  */
 struct get_phy_profile_req {
 	__le32	tag;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 942a99393204..2e28d7711d2f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -860,7 +860,7 @@ static void _pmcraid_fire_command(struct pmcraid_cmd *cmd)
 	unsigned long lock_flags;
 
 	/* Add this command block to pending cmd pool. We do this prior to
-	 * writting IOARCB to ioarrin because IOA might complete the command
+	 * writing IOARCB to ioarrin because IOA might complete the command
 	 * by the time we are about to add it to the list. Response handler
 	 * (isr/tasklet) looks for cmd block in the pending pending list.
 	 */
@@ -2453,7 +2453,7 @@ static void pmcraid_request_sense(struct pmcraid_cmd *cmd)
 
 	/* request sense might be called as part of error response processing
 	 * which runs in tasklets context. It is possible that mid-layer might
-	 * schedule queuecommand during this time, hence, writting to IOARRIN
+	 * schedule queuecommand during this time, hence, writing to IOARRIN
 	 * must be protect by host_lock
 	 */
 	pmcraid_send_cmd(cmd, pmcraid_erp_done,
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index cd059b7599b4..a74d87fea537 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -211,7 +211,7 @@ struct pmcraid_ioadl_desc {
 
 /* additional IOARCB data which can be CDB or additional request parameters
  * or list of IOADLs. Firmware supports max of 512 bytes for IOARCB, hence then
- * number of IOADLs are limted to 27. In case they are more than 27, they will
+ * number of IOADLs are limited to 27. In case they are more than 27, they will
  * be used in chained form
  */
 struct pmcraid_ioarcb_add_data {
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 8a4e910d5758..3303f9fcc673 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -556,7 +556,7 @@ static int ppa_completion(struct scsi_cmnd *const cmd)
 		(v == READ_10) || (v == WRITE_6) || (v == WRITE_10));
 
 	/*
-	 * We only get here if the drive is ready to comunicate,
+	 * We only get here if the drive is ready to communicate,
 	 * hence no need for a full ppa_wait.
 	 */
 	r = (r_str(ppb) & 0xf0);
@@ -624,7 +624,7 @@ static int ppa_completion(struct scsi_cmnd *const cmd)
 					sg_virt(scsi_pointer->buffer);
 			}
 		}
-		/* Now check to see if the drive is ready to comunicate */
+		/* Now check to see if the drive is ready to communicate */
 		r = (r_str(ppb) & 0xf0);
 		/* If not, drop back down to the scheduler and wait a timer tick */
 		if (!(r & 0x80))
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index da429b3a4283..9a05f52b62db 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -187,7 +187,7 @@ static void qedf_handle_link_update(struct work_struct *work)
 		}
 
 		/*
-		 * If we get here then we never received a repsonse to our
+		 * If we get here then we never received a response to our
 		 * fip vlan request so set the vlan_id to the default and
 		 * tell FCoE that the link is up
 		 */
@@ -838,7 +838,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	    io_req->event == QEDF_IOREQ_EV_ABORT_FAILED ||
 	    io_req->event == QEDF_IOREQ_EV_CLEANUP_SUCCESS) {
 		/*
-		 * If we get a reponse to the abort this is success from
+		 * If we get a response to the abort this is success from
 		 * the perspective that all references to the command have
 		 * been removed from the driver and firmware
 		 */
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index cdd6fe002c32..034df7060957 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4238,7 +4238,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto error_release_region;
 	}
 
-	/* load the F/W, read paramaters, and init the H/W */
+	/* load the F/W, read parameters, and init the H/W */
 	if (qla1280_initialize_adapter(ha)) {
 		printk(KERN_INFO "qla1x160: Failed to initialize adapter\n");
 		goto error_free_irq;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 98bc4a57b59b..6c2f23c80895 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1319,7 +1319,7 @@ struct device_reg_24xx {
 	__le32	unused_6[2];		/* Gap. */
 	__le32	iobase_sdata;
 };
-/* RISC-RISC semaphore register PCI offet */
+/* RISC-RISC semaphore register PCI offset */
 #define RISC_REGISTER_BASE_OFFSET	0x7010
 #define RISC_REGISTER_WINDOW_OFFSET	0x6
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 88bae1166a24..62e85531a3ce 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -4425,7 +4425,7 @@ qla25xx_build_bidir_iocb(srb_t *sp, struct scsi_qla_host *vha,
 
 		/* Allocate additional continuation packets */
 		if (avail_dsds == 0) {
-			/* Continuation type 1 IOCB can accomodate
+			/* Continuation type 1 IOCB can accommodate
 			 * 5 DSDS
 			 */
 			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
@@ -4448,7 +4448,7 @@ qla25xx_build_bidir_iocb(srb_t *sp, struct scsi_qla_host *vha,
 
 		/* Allocate additional continuation packets */
 		if (avail_dsds == 0) {
-			/* Continuation type 1 IOCB can accomodate
+			/* Continuation type 1 IOCB can accommodate
 			 * 5 DSDS
 			 */
 			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 2366cca51bce..dff03308bcc6 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3513,7 +3513,7 @@ int qla82xx_fcoe_ctx_reset(scsi_qla_host_t *vha)
  *
  * Return:
  *    Success (fcoe_ctx reset is done) : 0
- *    Failed  (fcoe_ctx reset not completed within max loop timout ) : 1
+ *    Failed  (fcoe_ctx reset not completed within max loop timeout ) : 1
  */
 int qla2x00_wait_for_fcoe_ctx_reset(scsi_qla_host_t *vha)
 {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c0efdbff5da7..9221ce104f75 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6202,7 +6202,7 @@ qla25xx_rdp_rsp_reduce_size(struct scsi_qla_host *vha, void *pkt)
 
 	vha->hw->isp_ops->fw_version_str(vha, fwstr, sizeof(fwstr));
 	fwstr[strcspn(fwstr, " ")] = 0;
-	/* if FW version allows RDP response length upto 2048 bytes: */
+	/* if FW version allows RDP response length up to 2048 bytes: */
 	if (strcmp(fwstr, "8.09.00") > 0 || strcmp(fwstr, "8.05.65") == 0)
 		return false;
 
@@ -6442,7 +6442,7 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	    vha->fabric_port_name,
 	    sizeof(rsp_payload->port_name_direct_desc.WWPN));
 
-	/* Bufer Credit Descriptor */
+	/* Buffer Credit Descriptor */
 	rsp_payload->buffer_credit_desc.desc_tag = cpu_to_be32(0x10006);
 	rsp_payload->buffer_credit_desc.desc_len =
 		cpu_to_be32(RDP_DESC_LEN(rsp_payload->buffer_credit_desc));
@@ -8494,7 +8494,7 @@ qla2x00_module_init(void)
 		goto destroy_cache;
 	} else if (ret > 0) {
 		/*
-		 * If initiator mode is explictly disabled by qlt_init(),
+		 * If initiator mode is explicitly disabled by qlt_init(),
 		 * prevent scsi_transport_fc.c:fc_scsi_scan_rport() from
 		 * performing scsi_scan_target() during LOOP UP event.
 		 */
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 53a505df8da0..1cd377191122 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1953,7 +1953,7 @@ static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
 }
 
 /* drop cmds for the given lun
- * XXX only looks for cmds on the port through which lun reset was recieved
+ * XXX only looks for cmds on the port through which lun reset was received
  * XXX does not go through the list of other port (which may have cmds
  *     for the same lun)
  */
@@ -3328,7 +3328,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			    CTIO7_FLAGS_DONT_RET_CTIO);
 
 			/* qlt_24xx_init_ctio_to_isp will correct
-			 * all neccessary fields that's part of CTIO7.
+			 * all necessary fields that's part of CTIO7.
 			 * There should be no residual of CTIO-CRC2 data.
 			 */
 			qlt_24xx_init_ctio_to_isp((struct ctio7_to_24xx *)ctio,
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 61072fb41b29..905f629159fc 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -559,7 +559,7 @@ struct ctio_crc_from_fw {
  * ISP queue - ABTS received/response entries structure definition for 24xx.
  */
 #define ABTS_RECV_24XX		0x54 /* ABTS received (for 24xx) */
-#define ABTS_RESP_24XX		0x55 /* ABTS responce (for 24xx) */
+#define ABTS_RESP_24XX		0x55 /* ABTS response (for 24xx) */
 
 /*
  * ISP queue -	ABTS received IOCB entry structure definition for 24xx.
@@ -814,7 +814,7 @@ struct qla_tgt {
 	int tgt_stop; /* the target mode driver is being stopped */
 	int tgt_stopped; /* the target mode driver has been stopped */
 
-	/* Count of sessions refering qla_tgt. Protected by hardware_lock. */
+	/* Count of sessions referring qla_tgt. Protected by hardware_lock. */
 	int sess_count;
 
 	spinlock_t sess_work_lock;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3be23ed067e6..fb26cd1b6383 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1439,7 +1439,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 		return -EINVAL;
 	}
 	/*
-	 * Format the FCP Initiator port_name into colon seperated values to
+	 * Format the FCP Initiator port_name into colon separated values to
 	 * match the format by tcm_qla2xxx explict ConfigFS NodeACLs.
 	 */
 	memset(&port_name, 0, 36);
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 860ec61b51b9..b446354fbeb4 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -260,7 +260,7 @@ union external_hw_config_reg {
 	struct {
 		/* FIXME: Do we even need this?	 All values are
 		 * referred to by 16 bit quantities.  Platform and
-		 * endianess issues. */
+		 * endianness issues. */
 		__le32 bReserved0:1;
 		__le32 bSDRAMProtectionMethod:2;
 		__le32 bSDRAMBanks:1;
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index f7340cfc990a..29a56e0dbdc7 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3954,7 +3954,7 @@ qla4_8xxx_get_flash_info(struct scsi_qla_host *ha)
  * Remarks:
  * For iSCSI, throws away all I/O and AENs into bit bucket, so they will
  * not be available after successful return.  Driver must cleanup potential
- * outstanding I/O's after calling this funcion.
+ * outstanding I/O's after calling this function.
  **/
 int
 qla4_8xxx_stop_firmware(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c9d9fc7c81fb..b20d74dcd2f7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7216,7 +7216,7 @@ static int qla4xxx_sysfs_ddb_is_non_persistent(struct device *dev,
  * @user: if set then this call is made from userland else from kernel
  *
  * Returns:
- * On sucess: QLA_SUCCESS
+ * On success: QLA_SUCCESS
  * On failure: QLA_ERROR
  *
  * This create separate sysfs entries for session and connection attributes of
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index d36293bc2717..e0a136e15322 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -94,7 +94,7 @@ static void ql_zap(struct qlogicfas408_priv *priv)
 }
 
 /*
- *	Do a pseudo-dma tranfer
+ *	Do a pseudo-dma transfer
  */
 
 static int ql_pdma(struct qlogicfas408_priv *priv, int phase, char *request,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b729407348f7..368dc68ec092 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1489,7 +1489,7 @@ static int scsi_eh_tur(struct scsi_cmnd *scmd)
  * @done_q:	queue for commands which are finished
  * @try_stu:	boolean on if a STU command should be tried in addition to TUR.
  *
- * Decription:
+ * Description:
  *    Tests if devices are in a working state.  Commands to devices now in
  *    a working state are sent to the done_q while commands to devices which
  *    are still failing to respond are returned to the work_q for more
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 8aa76f813bcd..6221a1ada76d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1838,7 +1838,7 @@ static void iscsi_scan_session(struct work_struct *work)
 }
 
 /**
- * iscsi_block_scsi_eh - block scsi eh until session state has transistioned
+ * iscsi_block_scsi_eh - block scsi eh until session state has transitioned
  * @cmd: scsi cmd passed to scsi eh handler
  *
  * If the session is down this function will wait for the recovery
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 56e455fb5add..fc50a8275b06 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -154,7 +154,7 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
  *
  * Try to allocate a reply buffer for the number of requested zones.
  * The size of the buffer allocated may be smaller than requested to
- * satify the device constraint (max_hw_sectors, max_segments, etc).
+ * satisfy the device constraint (max_hw_sectors, max_segments, etc).
  *
  * Return the address of the allocated buffer and update @buflen with
  * the size of the allocated buffer.
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..66be4f1a0316 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -964,7 +964,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 	case SG_SET_FORCE_LOW_DMA:
 		/*
 		 * N.B. This ioctl never worked properly, but failed to
-		 * return an error value. So returning '0' to keep compability
+		 * return an error value. So returning '0' to keep compatibility
 		 * with legacy applications.
 		 */
 		return 0;
diff --git a/drivers/scsi/snic/snic_fwint.h b/drivers/scsi/snic/snic_fwint.h
index 2550ba964b03..d7c9aaeca84e 100644
--- a/drivers/scsi/snic/snic_fwint.h
+++ b/drivers/scsi/snic/snic_fwint.h
@@ -95,7 +95,7 @@ struct snic_io_hdr {
 	u16	resvd;
 };
 
-/* auxillary funciton for encoding the snic_io_hdr */
+/* auxiliary function for encoding the snic_io_hdr */
 static inline void
 snic_io_hdr_enc(struct snic_io_hdr *hdr, u8 typ, u8 status, u32 id, u32 hid,
 		u16 sg_cnt, ulong ctx)
@@ -110,7 +110,7 @@ snic_io_hdr_enc(struct snic_io_hdr *hdr, u8 typ, u8 status, u32 id, u32 hid,
 	hdr->flags = 0;
 }
 
-/* auxillary funciton for decoding the snic_io_hdr */
+/* auxiliary function for decoding the snic_io_hdr */
 static inline void
 snic_io_hdr_dec(struct snic_io_hdr *hdr, u8 *typ, u8 *stat, u32 *cmnd_id,
 		u32 *hid, ulong *ctx)
@@ -473,7 +473,7 @@ struct snic_fw_req {
 }; /* end of snic_fw_req structure */
 
 /*
- * Auxillary macro to verify specific snic req/cmpl structures
+ * Auxiliary macro to verify specific snic req/cmpl structures
  * to ensure that it will be aligned to 64 bit, and not using
  * color bit field
  */
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index c6af3b8d2523..fbf2124362a0 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1508,7 +1508,7 @@ snic_send_abort_and_wait(struct snic *snic, struct scsi_cmnd *sc)
 	 * If the command is already completed by fw_cmpl code,
 	 * we just return SUCCESS from here. This means that the abort
 	 * succeeded. In the SCSI ML, since the timeout for command has
-	 * happend, the completion wont actually complete the command
+	 * happened, the completion wont actually complete the command
 	 * and it will be considered as an aborted command
 	 *
 	 * The CMD_SP will not be cleared except while holding io_lock
@@ -2066,7 +2066,7 @@ snic_send_dr_and_wait(struct snic *snic, struct scsi_cmnd *sc)
 }
 
 /*
- * auxillary funciton to check lun reset op is supported or not
+ * auxiliary function to check lun reset op is supported or not
  * Not supported if returns 0
  */
 static int
diff --git a/drivers/scsi/snic/snic_stats.h b/drivers/scsi/snic/snic_stats.h
index f0285c5a35f8..481bb21cfef7 100644
--- a/drivers/scsi/snic/snic_stats.h
+++ b/drivers/scsi/snic/snic_stats.h
@@ -88,7 +88,7 @@ struct snic_stats {
 void snic_stats_debugfs_init(struct snic *);
 void snic_stats_debugfs_remove(struct snic *);
 
-/* Auxillary function to update active IO counter */
+/* Auxiliary function to update active IO counter */
 static inline void
 snic_stats_update_active_ios(struct snic_stats *s_stats)
 {
@@ -102,7 +102,7 @@ snic_stats_update_active_ios(struct snic_stats *s_stats)
 	atomic64_inc(&io->num_ios);
 }
 
-/* Auxillary function to update IO completion counter */
+/* Auxiliary function to update IO completion counter */
 static inline void
 snic_stats_update_io_cmpl(struct snic_stats *s_stats)
 {
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..734057138f28 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -5020,7 +5020,7 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
 		goto out_unmap;
 
         for (i=0; i < nr_pages; i++) {
-                /* FIXME: flush superflous for rw==READ,
+                /* FIXME: flush superfluous for rw==READ,
                  * probably wrong function for rw==WRITE
                  */
 		flush_dcache_page(pages[i]);
diff --git a/drivers/scsi/sym53c8xx_2/sym53c8xx.h b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
index 11f5dc29aa59..8790f1315f75 100644
--- a/drivers/scsi/sym53c8xx_2/sym53c8xx.h
+++ b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
@@ -128,7 +128,7 @@ struct sym_driver_setup {
 /*
  *  Initial setup.
  *
- *  Can be overriden at startup by a command line.
+ *  Can be overridden at startup by a command line.
  */
 #define SYM_LINUX_DRIVER_SETUP	{				\
 	.max_tag	= CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS,	\
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index c554e4158094..d5ca66afab34 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -606,7 +606,7 @@ static inline void sym_init_burst(struct sym_hcb *np, u_char bc)
  *  Save initial settings of some IO registers.
  *  Assumed to have been set by BIOS.
  *  We cannot reset the chip prior to reading the 
- *  IO registers, since informations will be lost.
+ *  IO registers, since information will be lost.
  *  Since the SCRIPTS processor may be running, this 
  *  is not safe on paper, but it seems to work quite 
  *  well. :)
@@ -2178,7 +2178,7 @@ static void sym_recover_scsi_int (struct sym_hcb *np, u_char hsts)
 
 	/*
 	 *  If we haven't been interrupted inside the SCRIPTS 
-	 *  critical pathes, we can safely restart the SCRIPTS 
+	 *  critical paths, we can safely restart the SCRIPTS 
 	 *  and trust the DSA value if it matches a CCB.
 	 */
 	if ((!(dsp > SCRIPTA_BA(np, getjob_begin) &&
@@ -4516,7 +4516,7 @@ static void sym_int_sir(struct sym_hcb *np)
 		}
 		goto out;
 	/*
-	 *  The device wants us to tranfer more data than 
+	 *  The device wants us to transfer more data than 
 	 *  expected or in the wrong direction.
 	 *  The number of extra bytes is in scratcha.
 	 *  It is a data overrun condition.
@@ -4913,7 +4913,7 @@ static struct sym_ccb *sym_alloc_ccb(struct sym_hcb *np)
 	sym_insque_head(&cp->link_ccbq, &np->free_ccbq);
 
 	/*
-	 *  Chain into optionnal lists.
+	 *  Chain into optional lists.
 	 */
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	sym_insque_head(&cp->link2_ccbq, &np->dummy_ccbq);
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 830d40f57f6a..3b64114123f5 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -399,7 +399,7 @@ static int wd719x_chip_init(struct wd719x *wd)
 	/* disable interrupts during initialization of RISC */
 	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM, WD719X_DISABLE_INT);
 
-	/* issue INITIALIZE RISC comand */
+	/* issue INITIALIZE RISC command */
 	wd719x_writeb(wd, WD719X_AMR_COMMAND, WD719X_CMD_INIT_RISC);
 	/* enable advanced mode (wake up RISC) */
 	wd719x_writeb(wd, WD719X_PCI_MODE_SELECT, WD719X_ENABLE_ADVANCE_MODE);
diff --git a/drivers/scsi/wd719x.h b/drivers/scsi/wd719x.h
index 966ab0fb4621..6523bc46b4ea 100644
--- a/drivers/scsi/wd719x.h
+++ b/drivers/scsi/wd719x.h
@@ -130,7 +130,7 @@ struct wd719x {
 #define WD719X_SUE_REJECTED	0x01 /* Command Rejected (bad opcode/param) */
 #define WD719X_SUE_SCBQFULL	0x02 /* SCB queue full */
 /* 0x03 is reserved */
-#define WD719X_SUE_TERM		0x04 /* Host terminated SCB via primative cmd */
+#define WD719X_SUE_TERM		0x04 /* Host terminated SCB via primitive cmd */
 #define WD719X_SUE_CHAN1PAR	0x05 /* PCI Channel 1 parity error occurred */
 #define WD719X_SUE_CHAN1ABORT	0x06 /* PCI Channel 1 system abort occurred */
 #define WD719X_SUE_CHAN23PAR	0x07 /* PCI Channel 2/3 parity error occurred */
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..8381c99bb763 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10103,7 +10103,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	/*
 	 * Current function would be generally called from the power management
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
-	 * already suspended childs.
+	 * already suspended children.
 	 */
 	ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
 	if (ret) {
@@ -10188,7 +10188,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 
 	/*
 	 * It seems some UFS devices may keep drawing more than sleep current
-	 * (atleast for 500us) from UFS rails (especially from VCCQ rail).
+	 * (at least for 500us) from UFS rails (especially from VCCQ rail).
 	 * To avoid this situation, add 2ms delay before putting these UFS
 	 * rails in LPM mode.
 	 */
diff --git a/include/uapi/scsi/scsi_bsg_fc.h b/include/uapi/scsi/scsi_bsg_fc.h
index 5e46cf1054af..4f5f98529df1 100644
--- a/include/uapi/scsi/scsi_bsg_fc.h
+++ b/include/uapi/scsi/scsi_bsg_fc.h
@@ -293,7 +293,7 @@ struct fc_bsg_reply {
 	 */
 	__u32 result;
 
-	/* If there was reply_payload, how much was recevied ? */
+	/* If there was reply_payload, how much was received ? */
 	__u32 reply_payload_rcv_len;
 
 	union {
diff --git a/include/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
index e9c59ec1ceae..b1f339d4b076 100644
--- a/include/ufs/ufs_quirks.h
+++ b/include/ufs/ufs_quirks.h
@@ -65,7 +65,7 @@ struct ufs_dev_quirk {
 
 /*
  * It seems some UFS devices may keep drawing more than sleep current
- * (atleast for 500us) from UFS rails (especially from VCCQ rail).
+ * (at least for 500us) from UFS rails (especially from VCCQ rail).
  * To avoid this situation, add 2ms delay before putting these UFS
  * rails in LPM mode.
  */
-- 
2.48.1

