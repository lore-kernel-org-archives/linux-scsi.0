Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C5D149C7B;
	Sat, 27 Dec 2025 03:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766806906; cv=none; b=bCoEwIiOxw22WN5zyIvvzcAgCbwOyuBTYe49fKY0RfY0CVuBXlLuNm5GFEr1W8jGginFl3PEGmwsEXtwyJIC70juyW26vCgW6zwWApEyh7RYJFMxCiLU95AF3S3/UTOiMlMT+FcIsNkx/PPYbtkbUqSS4ZZz2q/TTULxckLyg3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766806906; c=relaxed/simple;
	bh=ssR0LmaKFbVUNovsvho9ygeTJkPCzbvdVWNRS6jWrGs=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=bMGmfPbPMOHYK55EHc4P+mFpNBuCGUZtIQZMhnPFCF2SMKhg2cyY4VZzrurx1714Y5E3xbHwVDJUisspNIgfa8heF5C6xxkU75pjy/WfArf9bRodiIupCvJQ/Q/9uOjmG1e/ZLNdvHI13N/3VOzrxgIlnAug4hVIYNW6XV2rbio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=qd78WO4g; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="qd78WO4g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1766806901;
	bh=ssR0LmaKFbVUNovsvho9ygeTJkPCzbvdVWNRS6jWrGs=;
	h=Message-ID:Subject:From:To:Date:From;
	b=qd78WO4ggZFzC05rCtJsZ1jaRDjNinVAjuvwg1c+BtvfS3s23YDTDmJEbiyZ7RAFG
	 ai4SHMSmXVt0+OzjPjBYKVMZZKoCSUdzWjAsP8t84ePs2BpgS22JQfTEIzlf9fGoLp
	 6aqulNh7vBUyCfosU1BpTWl22XJlm9wmvT2XPJBA=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 794EA1C003A;
	Fri, 26 Dec 2025 22:41:41 -0500 (EST)
Message-ID: <858baf4dce984fc3ff5c20fb8f8c276957fd44d2.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.19-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 26 Dec 2025 22:41:40 -0500
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

Three HBA driver and one upper level driver (sg) fix.  The sg change is
the largest, but that results mostly from moving code to avoid the
described race condition.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Chandrakanth Patil (1):
      scsi: mpi3mr: Read missing IOCFacts flag for reply queue full overflo=
w

John Garry (1):
      scsi: scsi_debug: Fix atomic write enable module param description

Michal R=C3=A1bek (1):
      scsi: sg: Fix occasional bogus elapsed time that exceeds timeout

Seunghwan Baek (1):
      scsi: ufs: core: Add ufshcd_update_evt_hist() for UFS suspend error

And the diffstat:

 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c     |  2 ++
 drivers/scsi/scsi_debug.c           |  2 +-
 drivers/scsi/sg.c                   | 20 +++++++++++++-------
 drivers/ufs/core/ufshcd.c           |  5 ++++-
 5 files changed, 21 insertions(+), 9 deletions(-)

With full diff below.

Reegards,

James

---

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/=
mpi30_ioc.h
index b42933fcd423..6561f98c3cb2 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -166,6 +166,7 @@ struct mpi3_ioc_facts_data {
 #define MPI3_IOCFACTS_FLAGS_SIGNED_NVDATA_REQUIRED            (0x00010000)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK            (0x0000ff00)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT           (8)
+#define MPI3_IOCFACTS_FLAGS_MAX_REQ_PER_REPLY_QUEUE_LIMIT     (0x00000040)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK          (0x00000030)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_SHIFT		(4)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_NOT_STARTED   (0x00000000)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_f=
w.c
index 8fe6e0bf342e..8c4bb7169a87 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3158,6 +3158,8 @@ static void mpi3mr_process_factsdata(struct mpi3mr_io=
c *mrioc,
 	mrioc->facts.dma_mask =3D (facts_flags &
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK) >>
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT;
+	mrioc->facts.max_req_limit =3D (facts_flags &
+			MPI3_IOCFACTS_FLAGS_MAX_REQ_PER_REPLY_QUEUE_LIMIT);
 	mrioc->facts.protocol_flags =3D facts_data->protocol_flags;
 	mrioc->facts.mpi_version =3D le32_to_cpu(facts_data->mpi_version.word);
 	mrioc->facts.max_reqs =3D le16_to_cpu(facts_data->max_outstanding_request=
s);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1f2a53ba5dd9..c5085e6d2e75 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7459,7 +7459,7 @@ MODULE_PARM_DESC(lbprz,
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=3D0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit=
 (def=3D0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP b=
it (def=3D0)");
-MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE=
 ATOMIC(16) (def=3D0)");
+MODULE_PARM_DESC(atomic_wr, "enable ATOMIC WRITE support, support WRITE AT=
OMIC(16) (def=3D0)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=3D0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat =
address method");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=3D1)=
");
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b3af9b78fa12..57fba34832ad 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -731,6 +731,8 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char =
__user *buf,
 		sg_remove_request(sfp, srp);
 		return -EFAULT;
 	}
+	hp->duration =3D jiffies_to_msecs(jiffies);
+
 	if (hp->interface_id !=3D 'S') {
 		sg_remove_request(sfp, srp);
 		return -ENOSYS;
@@ -815,7 +817,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		return -ENODEV;
 	}
=20
-	hp->duration =3D jiffies_to_msecs(jiffies);
 	if (hp->interface_id !=3D '\0' &&	/* v3 (or later) interface */
 	    (SG_FLAG_Q_AT_TAIL & hp->flags))
 		at_head =3D 0;
@@ -1338,9 +1339,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 				      "sg_cmd_done: pack_id=3D%d, res=3D0x%x\n",
 				      srp->header.pack_id, result));
 	srp->header.resid =3D resid;
-	ms =3D jiffies_to_msecs(jiffies);
-	srp->header.duration =3D (ms > srp->header.duration) ?
-				(ms - srp->header.duration) : 0;
 	if (0 !=3D result) {
 		struct scsi_sense_hdr sshdr;
=20
@@ -1389,6 +1387,9 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			done =3D 0;
 	}
 	srp->done =3D done;
+	ms =3D jiffies_to_msecs(jiffies);
+	srp->header.duration =3D (ms > srp->header.duration) ?
+				(ms - srp->header.duration) : 0;
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
=20
 	if (likely(done)) {
@@ -2533,6 +2534,7 @@ static void sg_proc_debug_helper(struct seq_file *s, =
Sg_device * sdp)
 	const sg_io_hdr_t *hp;
 	const char * cp;
 	unsigned int ms;
+	unsigned int duration;
=20
 	k =3D 0;
 	list_for_each_entry(fp, &sdp->sfds, sfd_siblings) {
@@ -2570,13 +2572,17 @@ static void sg_proc_debug_helper(struct seq_file *s=
, Sg_device * sdp)
 			seq_printf(s, " id=3D%d blen=3D%d",
 				   srp->header.pack_id, blen);
 			if (srp->done)
-				seq_printf(s, " dur=3D%d", hp->duration);
+				seq_printf(s, " dur=3D%u", hp->duration);
 			else {
 				ms =3D jiffies_to_msecs(jiffies);
-				seq_printf(s, " t_o/elap=3D%d/%d",
+				duration =3D READ_ONCE(hp->duration);
+				if (duration)
+					duration =3D (ms > duration ?
+						    ms - duration : 0);
+				seq_printf(s, " t_o/elap=3D%u/%u",
 					(new_interface ? hp->timeout :
 						  jiffies_to_msecs(fp->timeout)),
-					(ms > hp->duration ? ms - hp->duration : 0));
+					duration);
 			}
 			seq_printf(s, "ms sgat=3D%d op=3D0x%02x\n", usg,
 				   (int) srp->data.cmd_opcode);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 80c0b49f30b0..0babb7035200 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10359,7 +10359,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 	ret =3D ufshcd_setup_clocks(hba, false);
 	if (ret) {
 		ufshcd_enable_irq(hba);
-		return ret;
+		goto out;
 	}
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		hba->clk_gating.state =3D CLKS_OFF;
@@ -10371,6 +10371,9 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 	/* Put the host controller in low power mode if possible */
 	ufshcd_hba_vreg_set_lpm(hba);
 	ufshcd_pm_qos_update(hba, false);
+out:
+	if (ret)
+		ufshcd_update_evt_hist(hba, UFS_EVT_SUSPEND_ERR, (u32)ret);
 	return ret;
 }
=20

