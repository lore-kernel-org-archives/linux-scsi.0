Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFFC4B5CD0
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005273; cv=none; b=QyXSXFFgq4XMxFbdzZ7okRYKGYZvxbBh4T6W65i49nrMItKOmgi0vGqfBJSL4xalVSPRwjU6ffOb867NTMMtohoxlG05PMQvQD9Wqj7Y3Nm+6LUc2/ahg2Hy402dIB+Gx9sT6HyPiXGiSQJtsVE9q6eiS6IvwdxYQHuFD+yedqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005273; c=relaxed/simple;
	bh=p0H9nrw5Pi3MxTk7EUdzqjs7veDqSzFgesOd6/zyEC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ye9rx187i5sL+yqF3a1iHJgrLFI0sfZvnEsaJVNjy/ZWcPXWPaZ+RUIZ03eZhD/rtmFnOjAvt/cAEZffk3DfMFqKegOMsSFVGhPZx08En7UrdEd2fPcXViZQM5W5y/DpjY/dIR2Riht3Yl6QB3tEzC6ybL4DAoLFVJT1+RIK0jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKrKeI10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKrKeI10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4FE1F000FF;
	Mon, 21 Sep 2026 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005271;
	bh=duMZQf8rT9FWVm1HJTGjQd2CsToV+7HKbHhLoGWq2Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKrKeI10vVuhtpjLJ8EXyyudwuXMsrkuGBr8Odlnb0haNlrNfBJm629K4QL24uvAW
	 cNkf4JmKVT6UBx1QQOhGOI55TeHUhJI/ZFlVUvCJvBORb0vg3AkcEHPEwBXYtjutu3
	 9lfOU4d9so8Zzu3y0gOA0R/xyTLEDqYuU7OqtHj1iOxmiopba+JdJGEMDu+O7opw6y
	 vbRrwZ5bUwNIG3ZzIy6nTxrI4SzLWW4SxMGLZDi7xvtA311A96FTO8j+GQAnQy27tO
	 j+NL8Rhj6TwdojsMSbwEKC87le81h1IPz7RFYAfbfoQbMskt96mE3fYSEIviDgdUM4
	 FiGHK+l5Ifz8Q==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 03/10] scsi: scsi_debug: Take the zone metadata lock before the data lock
Date: Mon, 21 Sep 2026 17:40:19 +0200
Message-ID: <20260921154015.2971990-15-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154015.2971990-12-cassel@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2614; i=cassel@kernel.org; h=from:subject; bh=p0H9nrw5Pi3MxTk7EUdzqjs7veDqSzFgesOd6/zyEC0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLI2+j9L5k31+tt6Y4tzpeBpK+aUOp7tZ6WMP1xcvJ9/5 j6m63v3dZSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAid0IZ/tmy2Pcur9lg++zh 3Hdb3xlcKFKbXi7Os1KAVWNF83IH0WOMDBtdXa2LdbwLz93cbvt5xYVd3O6/9YrbXCSrK+vd7vD uZQEA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_comp_write() takes the data lock and then the zone metadata lock.
Every other command that takes both takes them the other way round:
resp_write_dt0(), resp_write_scat(), resp_write_same() and
resp_write_tape() take the metadata lock and then call
do_device_access(), which takes the data lock.

Two commands that take the same two locks in opposite orders can
deadlock against each other, so a COMPARE AND WRITE and any other write
to the same store can hang one another.

Take the locks in the same order as everywhere else, and release them in
the reverse of that order.

Correct the comment above map_region() while here. The provisioning map
is covered by the metadata lock rather than by the data lock, which is
why resp_unmap() takes only the metadata lock while unmap_region()
clears map bits.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 dev_size_mb=128 lbpu=1 lbpws=1

COMPARE AND WRITE completes, and a READ(16) of the block that it wrote
returns, so the reordered locks are still taken and released correctly.

The deadlock itself was not reproduced. This kernel is built without
lockdep, and the window needs a COMPARE AND WRITE and another write to
the same store to interleave between the two acquisitions. Found by
review.
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8e45a57ae406..18aefe83b7b6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5575,8 +5575,8 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
 
-	sdeb_data_write_lock(sip);
 	sdeb_meta_write_lock(sip);
+	sdeb_data_write_lock(sip);
 	if (!comp_write_worker(sip, lba, num, arr, false)) {
 		mk_sense_buffer(scp, MISCOMPARE,
 				MISCOMPARE_DURING_VERIFY_OPERATION);
@@ -5584,12 +5584,12 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		goto cleanup_unlock;
 	}
 
-	/* Cover sip->map_storep (which map_region()) sets with data lock */
+	/* Cover sip->map_storep (which map_region() sets) with the meta lock */
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
 cleanup_unlock:
-	sdeb_meta_write_unlock(sip);
 	sdeb_data_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 cleanup_free:
 	kfree(arr);
 	return retval;
-- 
2.55.0

