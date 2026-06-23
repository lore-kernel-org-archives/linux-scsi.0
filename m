Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A222222A9;
	Tue, 23 Jun 2026 13:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.40.148.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782221082; cv=none; b=bRDEaGd6piuFdsYNUWIGHGMIsdqG+4SmU+hVO8bjodkVbx52YBYcDCcE4pZjnTq4dVSknXVSvext5+kQ1lfCScwUrordL+Y7zAk1k6bKOT7gkk6rUcr39cuJW5jaf34+SuEXM8mz7fW1bNY0QgcjSA22KlffA62uZELh9II4o70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782221082; c=relaxed/simple;
	bh=o/lKGMzLwL9jeD7Q81Hm5xK9t1EhI6f+gOszDs5W0FE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gCVftq9P/2dlf5T6XVaYFhOET5XztP3acT6B0WHmJ5yhIyupKndT9Ku6SWASuvbJkKi1c8KDq+gUW+ObLkqX3+vIjhWR8TCrfr0vlUEykhrDcEwUJ0k3Fo9SVAQ9ggx5SihykUJ3Wdy1dB0tpiy/NPXt0SmXrZixx5R0C00I0Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.com; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=S/pANkjw; arc=none smtp.client-ip=78.40.148.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codethink.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="S/pANkjw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=F5UG/rFsLepcEdLLTYcq/mvyh2fLWf4JoeLmE1+Ml3o=; b=S/pANkjwhIKnDs
	qznbBh3zWuP8ftASv/SbwDgWebUk99YsLfOSSNbcGNVRtASVMNzps5qxBniS7XwkYQjFFNd79+Hpb
	caKngJDQbd/Ex3aRLdiauOnMTax1dFKgumbpEgsnKRascjlEtZwFpPrBd2r7BRheolOwH0uoWM/Zc
	i8sziJUUBdRYLyVRi8ZViFWqsVuSB/eLT3mLkEnDX74UjpnFRk87hteP/RqYJkWvEgBCbRAyUSqQs
	xNo5NFUAF/5AK5B5oCyXhLHquwtU4UlDBKNRhVkCz3nA9auMZfhqPUEnniU3xnHs5nuW/Id3M+g6f
	MLVt7iRg6RBBp0dF2wUw==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wc176-007LhF-5E; Tue, 23 Jun 2026 14:24:28 +0100
Received: from ben by rainbowdash with local (Exim 4.99.4)
	(envelope-from <ben@rainbowdash>)
	id 1wc175-00000003WEr-3t0y;
	Tue, 23 Jun 2026 14:24:27 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] scsi: virtio_scsi: fixup endian conversions for warning messages
Date: Tue, 23 Jun 2026 14:24:27 +0100
Message-Id: <20260623132427.838900-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: srv_ts003@codethink.com

There are several places where printing functions are being passed parameters
that have not been through endian conversion functions. Use the virtio32_to_cpu
to fix the warnings.

Fixes the following warnings from (prototype) sparse:
drivers/scsi/virtio_scsi.c:126:9: warning: incorrect type in argument 7 (different base types)
drivers/scsi/virtio_scsi.c:126:9:    expected unsigned int
drivers/scsi/virtio_scsi.c:126:9:    got restricted __virtio32 [usertype] sense_len
drivers/scsi/virtio_scsi.c:312:17: warning: incorrect type in argument 2 (different base types)
drivers/scsi/virtio_scsi.c:312:17:    expected unsigned int
drivers/scsi/virtio_scsi.c:312:17:    got restricted __virtio32 [usertype] reason
drivers/scsi/virtio_scsi.c:412:17: warning: incorrect type in argument 2 (different base types)
drivers/scsi/virtio_scsi.c:412:17:    expected unsigned int
drivers/scsi/virtio_scsi.c:412:17:    got restricted __virtio32 [usertype] event

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/scsi/virtio_scsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 5fdaa71f0652..35731b18c519 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -122,10 +122,11 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	struct virtio_scsi_cmd *cmd = buf;
 	struct scsi_cmnd *sc = cmd->sc;
 	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
+	unsigned sense_len = virtio32_to_cpu(vscsi->vdev, resp->sense_len);
 
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p response %u status %#02x sense_len %u\n",
-		sc, resp->response, resp->status, resp->sense_len);
+		sc, resp->response, resp->status, sense_len);
 
 	sc->result = resp->status;
 	virtscsi_compute_resid(sc, virtio32_to_cpu(vscsi->vdev, resp->resid));
@@ -166,13 +167,10 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		break;
 	}
 
-	WARN_ON(virtio32_to_cpu(vscsi->vdev, resp->sense_len) >
-		VIRTIO_SCSI_SENSE_SIZE);
+	WARN_ON(sense_len > VIRTIO_SCSI_SENSE_SIZE);
 	if (resp->sense_len) {
 		memcpy(sc->sense_buffer, resp->sense,
-		       min_t(u32,
-			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
-			     VIRTIO_SCSI_SENSE_SIZE));
+		       min_t(u32, sense_len, VIRTIO_SCSI_SENSE_SIZE));
 	}
 
 	scsi_done(sc);
@@ -288,8 +286,9 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	unsigned int target = event->lun[1];
 	unsigned int lun = (event->lun[2] << 8) | event->lun[3];
+	unsigned int reason = virtio32_to_cpu(vscsi->vdev, event->reason);
 
-	switch (virtio32_to_cpu(vscsi->vdev, event->reason)) {
+	switch (reason) {
 	case VIRTIO_SCSI_EVT_RESET_RESCAN:
 		if (lun == 0) {
 			scsi_scan_target(&shost->shost_gendev, 0, target,
@@ -309,7 +308,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 		}
 		break;
 	default:
-		pr_info("Unsupported virtio scsi event reason %x\n", event->reason);
+		pr_info("Unsupported virtio scsi event reason %x\n", reason);
 	}
 }
 
@@ -409,7 +408,8 @@ static void virtscsi_handle_event(struct work_struct *work)
 		virtscsi_handle_param_change(vscsi, event);
 		break;
 	default:
-		pr_err("Unsupported virtio scsi event %x\n", event->event);
+		pr_err("Unsupported virtio scsi event %x\n",
+		       virtio32_to_cpu(vscsi->vdev, event->event));
 	}
 	virtscsi_kick_event(vscsi, event_node);
 }
-- 
2.37.2.352.g3c44437643

