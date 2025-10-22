Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E982A78F5D;
	Wed, 22 Oct 2025 21:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761167461; cv=none; b=cVqz2P57v5ZUTRKfogsP4VoXAhollojkg+wAODxrbuuWZNa0eef3WxXHfax+y2DOueDCXwvlW+A+fw/yi+2/7Rs3eOhRh6/rvr8y+vzGDC05GId6PEkk2frM3472EdUhG9954zwbso8+Y0yQ6wfJfONuxL67zTr49dC1uvior2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761167461; c=relaxed/simple;
	bh=KEyUOlL20abWRf2udp5m8M/CH1is7QXPWwLwZiwxJMk=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=BOlh2IHW9GN272md07Lxc9FDEhBt0nuqj5Zriei+0RTmt/In2IeEIibrx7pY01oQjRiJexpDlspmjS6qd93cofJfQGcrFoTcj99EZS5QCyz0GULHq7eMglYF+/d8bnKP3MZbKulVEH4IH37akxdiahCE+VPGIqNEI81o1UPma60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=FHN9unG+; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="FHN9unG+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1761167458;
	bh=KEyUOlL20abWRf2udp5m8M/CH1is7QXPWwLwZiwxJMk=;
	h=Message-ID:Subject:From:To:Date:From;
	b=FHN9unG+YPP31/zChXFguH0uUhjGK6y7MIUCZkPvNAZSxtfX7ZcXO/UjkDMaPvUhW
	 F/ccxJIzkNZBWOZUsR4vecARF4hoCH8YcEaPhTdDo3A+RMtusN2dM5wfdZHjEV63+e
	 4jFKy1pFv4Upw5ZeopZdpLz0eSJ/37KXf6zGaQCU=
Received: from [IPv6:2001:4898:d8:34:ab55:e469:cd28:a34c] (unknown [IPv6:2001:4898:80e8:a:2b6f:e469:cd28:a34c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 915941C001D;
	Wed, 22 Oct 2025 17:10:58 -0400 (EDT)
Message-ID: <892e8ced0cd493594ff29206d75977aeb20b875b.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.18-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Wed, 22 Oct 2025 14:10:57 -0700
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

All driver fixes.  The big change is the storvsc one to rejig the
hyper-v channel handling to be more efficient for SMP virtual machines.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alok Tiwari (1):
      scsi: qla4xxx: Fix typos in comments

Dan Carpenter (1):
      scsi: libfc: Prevent integer overflow in fc_fcp_recv_data()

Jingyi Wang (1):
      scsi: ufs: phy: dt-bindings: Add QMP UFS PHY compatible for Kaanapali

Long Li (1):
      scsi: storvsc: Prefer returning channel with the same CPU as on the I=
/O issuing CPU

Nitin Rawat (1):
      scsi: ufs: qcom: dt-bindings: Document the Kaanapali UFS controller

And the diffstat:

 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |  4 +
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml |  2 +
 drivers/scsi/libfc/fc_fcp.c                        |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |  8 +-
 drivers/scsi/storvsc_drv.c                         | 96 ++++++++++--------=
----
 5 files changed, 56 insertions(+), 56 deletions(-)

With full diff below.

Regards,

James

---
diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-ph=
y.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.ya=
ml
index a58370a6a5d3..fba7b2549dde 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -24,6 +24,10 @@ properties:
           - enum:
               - qcom,qcs8300-qmp-ufs-phy
           - const: qcom,sa8775p-qmp-ufs-phy
+      - items:
+          - enum:
+              - qcom,kaanapali-qmp-ufs-phy
+          - const: qcom,sm8750-qmp-ufs-phy
       - enum:
           - qcom,msm8996-qmp-ufs-phy
           - qcom,msm8998-qmp-ufs-phy
diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b=
/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index aaa0bbb5bfe1..cea84ab2204f 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -15,6 +15,7 @@ select:
     compatible:
       contains:
         enum:
+          - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
   required:
@@ -24,6 +25,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
       - const: qcom,ufshc
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 16d0f02af1e4..31d08c115521 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -503,7 +503,7 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, st=
ruct fc_frame *fp)
 		host_bcode =3D FC_ERROR;
 		goto err;
 	}
-	if (offset + len > fsp->data_len) {
+	if (size_add(offset, len) > fsp->data_len) {
 		/* this should never happen */
 		if ((fr_flags(fp) & FCPHF_CRC_UNCHECKED) &&
 		    fc_frame_crc_check(fp))
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a761c0aa5127..83ff66f954e6 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4104,7 +4104,7 @@ void qla4xxx_srb_compl(struct kref *ref)
  * The mid-level driver tries to ensure that queuecommand never gets
  * invoked concurrently with itself or the interrupt handler (although
  * the interrupt handler may call this routine as part of request-
- * completion handling).   Unfortunely, it sometimes calls the scheduler
+ * completion handling). Unfortunately, it sometimes calls the scheduler
  * in interrupt context which is a big NO! NO!.
  **/
 static int qla4xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *=
cmd)
@@ -4647,7 +4647,7 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
 			cmd =3D scsi_host_find_tag(ha->host, index);
 			/*
 			 * We cannot just check if the index is valid,
-			 * becase if we are run from the scsi eh, then
+			 * because if we are run from the scsi eh, then
 			 * the scsi/block layer is going to prevent
 			 * the tag from being released.
 			 */
@@ -4952,7 +4952,7 @@ static int qla4xxx_recover_adapter(struct scsi_qla_ho=
st *ha)
 	/* Upon successful firmware/chip reset, re-initialize the adapter */
 	if (status =3D=3D QLA_SUCCESS) {
 		/* For ISP-4xxx, force function 1 to always initialize
-		 * before function 3 to prevent both funcions from
+		 * before function 3 to prevent both functions from
 		 * stepping on top of the other */
 		if (is_qla40XX(ha) && (ha->mac_index =3D=3D 3))
 			ssleep(6);
@@ -6914,7 +6914,7 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_ho=
st *ha,
 	struct ddb_entry *ddb_entry =3D NULL;
=20
 	/* Create session object, with INVALID_ENTRY,
-	 * the targer_id would get set when we issue the login
+	 * the target_id would get set when we issue the login
 	 */
 	cls_sess =3D iscsi_session_setup(&qla4xxx_iscsi_transport, ha->host,
 				       cmds_max, sizeof(struct ddb_entry),
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 567f9cd29102..6e4112143c76 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1406,14 +1406,19 @@ static struct vmbus_channel *get_og_chn(struct stor=
vsc_device *stor_device,
 	}
=20
 	/*
-	 * Our channel array is sparsley populated and we
+	 * Our channel array could be sparsley populated and we
 	 * initiated I/O on a processor/hw-q that does not
 	 * currently have a designated channel. Fix this.
 	 * The strategy is simple:
-	 * I. Ensure NUMA locality
-	 * II. Distribute evenly (best effort)
+	 * I. Prefer the channel associated with the current CPU
+	 * II. Ensure NUMA locality
+	 * III. Distribute evenly (best effort)
 	 */
=20
+	/* Prefer the channel on the I/O issuing processor/hw-q */
+	if (cpumask_test_cpu(q_num, &stor_device->alloced_cpus))
+		return stor_device->stor_chns[q_num];
+
 	node_mask =3D cpumask_of_node(cpu_to_node(q_num));
=20
 	num_channels =3D 0;
@@ -1469,59 +1474,48 @@ static int storvsc_do_io(struct hv_device *device,
 	/* See storvsc_change_target_cpu(). */
 	outgoing_channel =3D READ_ONCE(stor_device->stor_chns[q_num]);
 	if (outgoing_channel !=3D NULL) {
-		if (outgoing_channel->target_cpu =3D=3D q_num) {
-			/*
-			 * Ideally, we want to pick a different channel if
-			 * available on the same NUMA node.
-			 */
-			node_mask =3D cpumask_of_node(cpu_to_node(q_num));
-			for_each_cpu_wrap(tgt_cpu,
-				 &stor_device->alloced_cpus, q_num + 1) {
-				if (!cpumask_test_cpu(tgt_cpu, node_mask))
-					continue;
-				if (tgt_cpu =3D=3D q_num)
-					continue;
-				channel =3D READ_ONCE(
-					stor_device->stor_chns[tgt_cpu]);
-				if (channel =3D=3D NULL)
-					continue;
-				if (hv_get_avail_to_write_percent(
-							&channel->outbound)
-						> ring_avail_percent_lowater) {
-					outgoing_channel =3D channel;
-					goto found_channel;
-				}
-			}
+		if (hv_get_avail_to_write_percent(&outgoing_channel->outbound)
+				> ring_avail_percent_lowater)
+			goto found_channel;
=20
-			/*
-			 * All the other channels on the same NUMA node are
-			 * busy. Try to use the channel on the current CPU
-			 */
-			if (hv_get_avail_to_write_percent(
-						&outgoing_channel->outbound)
-					> ring_avail_percent_lowater)
+		/*
+		 * Channel is busy, try to find a channel on the same NUMA node
+		 */
+		node_mask =3D cpumask_of_node(cpu_to_node(q_num));
+		for_each_cpu_wrap(tgt_cpu, &stor_device->alloced_cpus,
+				  q_num + 1) {
+			if (!cpumask_test_cpu(tgt_cpu, node_mask))
+				continue;
+			channel =3D READ_ONCE(stor_device->stor_chns[tgt_cpu]);
+			if (!channel)
+				continue;
+			if (hv_get_avail_to_write_percent(&channel->outbound)
+					> ring_avail_percent_lowater) {
+				outgoing_channel =3D channel;
 				goto found_channel;
+			}
+		}
=20
-			/*
-			 * If we reach here, all the channels on the current
-			 * NUMA node are busy. Try to find a channel in
-			 * other NUMA nodes
-			 */
-			for_each_cpu(tgt_cpu, &stor_device->alloced_cpus) {
-				if (cpumask_test_cpu(tgt_cpu, node_mask))
-					continue;
-				channel =3D READ_ONCE(
-					stor_device->stor_chns[tgt_cpu]);
-				if (channel =3D=3D NULL)
-					continue;
-				if (hv_get_avail_to_write_percent(
-							&channel->outbound)
-						> ring_avail_percent_lowater) {
-					outgoing_channel =3D channel;
-					goto found_channel;
-				}
+		/*
+		 * If we reach here, all the channels on the current
+		 * NUMA node are busy. Try to find a channel in
+		 * all NUMA nodes
+		 */
+		for_each_cpu_wrap(tgt_cpu, &stor_device->alloced_cpus,
+				  q_num + 1) {
+			channel =3D READ_ONCE(stor_device->stor_chns[tgt_cpu]);
+			if (!channel)
+				continue;
+			if (hv_get_avail_to_write_percent(&channel->outbound)
+					> ring_avail_percent_lowater) {
+				outgoing_channel =3D channel;
+				goto found_channel;
 			}
 		}
+		/*
+		 * If we reach here, all the channels are busy. Use the
+		 * original channel found.
+		 */
 	} else {
 		spin_lock_irqsave(&stor_device->lock, flags);
 		outgoing_channel =3D stor_device->stor_chns[q_num];

