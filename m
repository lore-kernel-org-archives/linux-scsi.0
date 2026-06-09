Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7DE1F30BB
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781005744; cv=none; b=PkulogIo+agS4dTU1hkYUtQEVMb5qaFLtGdzBRxNAEJxN5g3bnuZdZXqQkkmcIwhS8529WtAK0LYCknHn+DFdx+yjg07/wyjf+FjMgVuf2RtJLUdXvjJp4RZqQGCwWSznfOAzCmDds/k8iF3C1HteESpKuuaKTwXD+FoNYNj3wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781005744; c=relaxed/simple;
	bh=idiuQJNN0GZ7hWFIbxqI9skHLKDG4DRE2a8a21vQ7TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlvJ2mjz7fvJ1W+PGCslDshy6zojG1NIUamObnAGRsLqHTett55kZlPk0HnD72LXU36QscvWZXAnJBWgLJm4JfLCDekQhlDdITLt63P65zZ6XKCpFahhWPdo/fv9mEbwTpHj1SDZz9Ra3ze21UzHpmf1cU5aSthzfZpbjLc6W/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=e06sNo4R; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="e06sNo4R"
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-66058b880e9so5444101d50.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 04:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781005741; x=1781610541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cij0f7XK3gPTc98cKs5ll/gp5Fj5YlFQkChYuGOVaaM=;
        b=k1uus+GJvp3UfjwTpnGgjiolqi1CIMuyNR41uuYO8VApyJ3MI+vRJNM1DYKNNE/Sfi
         i/GHFI9SqYRuLkXO+8TZMf5qVPiCdBECMNYnzGRLWNAe9wwmv9GlxPLkbhiIE2RJGKDq
         s/WSkGoBcZDz4YlMRDDuN5YSUPpbf6OsoWVl3cbYMbQMNdrw/Jlh1qlgXt76ObXbniK/
         2Ca+sjxIYhcIYpmY1x5sC8uiz50gvl+WfH+BBi99meKlEIaaZ8ZSi7jrm1vLNWtW1Kkl
         Rx8MwQFT/6V0GsT8bKO55SdByC98nLhdqFKonZEgfDsgSkPA4e3mFrZQvmajlaaiOa9a
         8v4A==
X-Forwarded-Encrypted: i=1; AFNElJ/IyZr8IMpXzKVcK4SCM7Eip61QPAf2CAQuFT/IMtKaM1pFyDKHNGyWLa8Nn2Dy5F7z3VK4Dkq2gI7K@vger.kernel.org
X-Gm-Message-State: AOJu0YxaBnlIXZKHsuIivKr77RRgRCiTI/lONJFW5oyKjC/8EN+WmZ7g
	nGVEpowlVS90Y5bp7qNhOpDwhqmUphAnRfPEMqjeZuH8FmmSj7A358tO+q/IGoocxJIaPtIAx2B
	YsO58oR0xxXNg1s1yQ2Kpw8B2WmzxhI1NgZo7TohRUucURj9r84D/mECKNxfDx2NNM4ZgxIJYQ4
	glwsTUOx4ilotCzJpHUUiv728Jkvr6AJP78Gl2kTC67ldYfzl2aw3dOYt7TiZpaFL5YdBE1Ey8D
	mTCH/HdMluKaa8o
X-Gm-Gg: Acq92OGW/GXu+IfTqdLzQAIkZkv0hvQJWLDXdB+YIx0dA6Ue1eAoYhcqk4y/AvO/wEM
	aCy15p1g/GB4WTSqI/0s//NdZFh+sQPXCoosAqP+84HLctKR2g3vUc4XoCxVcvSvF6ZI0CHG9dy
	KYrEjnwVMoU+SF3KWBlAyBZVVbrKNV35VMckRU7oUBhdjcv0Row/V9E5RXVkB9jIPQ14ly8G/rk
	9qVZleOGC+X1aJmepT42ERQabGnhhNXpg5K3BF9Rw4nYzIQj6+bSMPx6KTSUvtUIPAq7TZmJuoK
	OnOCwlc//O5k/gZURnEP9aHkQyNPwgTOybj619ge4Kp3ekoFU/WuNjUNUyhOeCBUiN9Jvjc0Gjy
	VtbI0qm1AxI5xizHe4zHrYAPOjNpOQClyGnwo5o8Z0tUs4o6Icg9WZ26y8/3oDLUv9vKrx8Gs+2
	VvdX/zCLMrhXqJye/kvkQygV5KD9FGQViGelUbFludg2M2M66YF1IkCbW+w0qzsJGAudQ=
X-Received: by 2002:a53:d90c:0:b0:65e:a7cb:50a3 with SMTP id 956f58d0204a3-6610707df1fmr13616313d50.53.1781005740979;
        Tue, 09 Jun 2026 04:49:00 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-21.dlp.protect.broadcom.com. [144.49.247.21])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-660d647a6d6sm1556116d50.27.2026.06.09.04.49.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jun 2026 04:49:00 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-36bc54005a7so7346487a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 04:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781005739; x=1781610539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cij0f7XK3gPTc98cKs5ll/gp5Fj5YlFQkChYuGOVaaM=;
        b=e06sNo4RL1szcwmfAvf5K/+fgiSMK5oGTIgcSEuBFYCZBheyKe0CdkKPCY4FomdVUG
         Jd4TpOrsJ/9JXk3XmUUSEnkV8QqVrZuqYn38cuA/sOzRjdmkWkPM2RpixlMxsgIpE7xE
         YrRyRE3xPOI9wxlYhzE9VL9GwRPp6z8Nin2Tk=
X-Forwarded-Encrypted: i=1; AFNElJ+mM2OZWiYv6ayqO4SYazoDlV+3aslBY4k4YyKUReuzfEKzPImwAldODuVLpcsuQJXiJ7CBkCKnE94T@vger.kernel.org
X-Received: by 2002:a17:90b:5787:b0:36b:8824:d7cc with SMTP id 98e67ed59e1d1-370f057a115mr22377752a91.20.1781005739355;
        Tue, 09 Jun 2026 04:48:59 -0700 (PDT)
X-Received: by 2002:a17:90b:5787:b0:36b:8824:d7cc with SMTP id 98e67ed59e1d1-370f057a115mr22377714a91.20.1781005738858;
        Tue, 09 Jun 2026 04:48:58 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf903fasm18898075a91.2.2026.06.09.04.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:48:57 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	Adam Radford <aradford@gmail.com>,
	Khalid Aziz <khalid@gonehiking.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	"Juergen E . Fischer" <fischer@norbit.de>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	target-devel@vger.kernel.org,
	Bradley Grove <linuxdrivers@attotech.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Yihang Li <liyihang9@h-partners.com>,
	Don Brace <don.brace@microchip.com>,
	storagedev@microchip.com,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	open-iscsi@googlegroups.com,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	megaraidlinux.pdl@broadcom.com,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	Daniel Palmer <daniel@thingy.jp>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Geoff Levand <geoff@infradead.org>,
	Michael Reed <mdr@sgi.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Narsimhulu Musini <nmusini@cisco.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	linux-hyperv@vger.kernel.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio Perez <eperezma@redhat.com>,
	virtualization@lists.linux.dev,
	Vishal Bhakta <vishal.bhakta@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	xen-devel@lists.xenproject.org,
	James Rizzo <james.rizzo@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v3 1/4] scsi: scan: allocate sdev and starget on the NUMA node of the host adapter
Date: Tue,  9 Jun 2026 17:48:00 +0530
Message-ID: <20260609121806.2121755-2-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: James Rizzo <james.rizzo@broadcom.com>

When a host adapter is attached to a specific NUMA node, allocating
scsi_device and scsi_target via kzalloc() may place them on a remote
node.  All hot-path I/O accesses to these structures then cross the NUMA
interconnect, adding latency and consuming inter-node bandwidth.

Use kzalloc_node() with dev_to_node(shost->dma_dev) so allocations land
on the same node as the HBA, reducing cross-node traffic and improving
I/O performance on NUMA systems.

Signed-off-by: James Rizzo <james.rizzo@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/scsi_scan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e27da038603a..121a14d5fdb8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -34,6 +34,7 @@
 #include <linux/kthread.h>
 #include <linux/spinlock.h>
 #include <linux/async.h>
+#include <linux/topology.h>
 #include <linux/slab.h>
 #include <linux/unaligned.h>
 
@@ -287,8 +288,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct queue_limits lim;
 
-	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
-		       GFP_KERNEL);
+	sdev = kzalloc_node(sizeof(*sdev) + shost->transportt->device_size,
+		       GFP_KERNEL, dev_to_node(shost->dma_dev));
 	if (!sdev)
 		goto out;
 
@@ -502,7 +503,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	struct scsi_target *found_target;
 	int error, ref_got;
 
-	starget = kzalloc(size, GFP_KERNEL);
+	starget = kzalloc_node(size, GFP_KERNEL, dev_to_node(shost->dma_dev));
 	if (!starget) {
 		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return NULL;
-- 
2.43.7

