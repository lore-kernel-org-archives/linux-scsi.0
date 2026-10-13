Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B555437C1
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 20:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791923171; cv=none; b=J6Fpmmq5LYaOjM1rhwEtSF3qxcdHf3FKMUYolCPMmvexC37Y4jlK5ZRhlDGMHgPA4fXPxzXg6JLKCHv0LXI0fHPJXX8C4lz5ZOdssqkt6ZQYZI8Vt6waptVYGzCtd1PCnHCZ/3JwL0k6J3tttVObhJi/byfSdx422UEH+dkTp4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791923171; c=relaxed/simple;
	bh=lhGsaBvRq0uX0dt1fMGP04Ng0z24qw3si/oEBKwkbjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+1uQH4i24SJb0EhAVxe6dAHKIA1vA9wNIlYJXWgx0sQ6pp8AdgTcAxsLM54NmDowxg+PHSYtn6fMBBrxa8xCX+PO0fNY1KxjI1W8hX2ErdxPjQBUF8vafwmDeikIq6BEFHpbAhjxEUJTXpC1wfNyK43V4EK2C9PxrKTwt49xxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jD2Wri3f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jD2Wri3f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791923168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4w56Ex/koEEl4gzBJ57SY8fAkvghhpTRhqIuK0vZtOY=;
	b=jD2Wri3f3gleKrHlLt3usEvaw69C1uuMeadyPOpo2HuF9Xwkm7EKmNzG2683v7prY+h0SK
	zB2Ok9D0phMJ9kXoR0OVlKjYYgm1Rx69L1ZgtHcJA/HRKnbJiEfHdhOohd8dCNEYsSF2BA
	gfNcgV3JWpRfJa/+U4MZAOxDNC/yA48=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-cZll0NVNO5C4g6DEPAt-Ww-1; Tue,
 13 Oct 2026 20:26:05 +0000
X-MC-Unique: cZll0NVNO5C4g6DEPAt-Ww-1
X-Mimecast-MFC-AGG-ID: cZll0NVNO5C4g6DEPAt-Ww_1791923163
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A28C180A96F;
	Tue, 13 Oct 2026 20:26:03 +0000 (UTC)
Received: from loberman-thinkpadp1gen5.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C23DF769;
	Tue, 13 Oct 2026 20:26:01 +0000 (UTC)
From: loberman@redhat.com
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	Kai.Makisara@kolumbus.fi,
	jmeneghi@redhat.com,
	dingiso.kernel@gmail.com,
	Laurence Oberman <loberman@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: st: Fix use-after-free race between st_remove() and st_open()
Date: Tue, 13 Oct 2026 16:25:48 -0400
Message-ID: <20261013202548.249628-1-loberman@redhat.com>
In-Reply-To: <20261013200148.1942808-1-dingiso.kernel@gmail.com>
References: <20261013200148.1942808-1-dingiso.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

From: Laurence Oberman <loberman@redhat.com>

st_remove() drops the probe reference on the scsi_tape with kref_put()
and only afterwards removes its index from st_index_idr. If that was the
last reference, scsi_tape_release() frees the structure while it is
still published in the idr.

scsi_tape_get(), called from st_open(), looks up the tape in
st_index_idr and takes a reference under st_ref_mutex and
st_index_lock. remove_cdevs() does not wait for opens that are already
past chrdev_open(), so an open that is blocked on st_ref_mutex while
st_remove() holds it can take the mutex as soon as st_remove() drops
it, find the freed tpnt in the idr and call kref_get() on it:

  BUG: KASAN: slab-use-after-free in st_open
  Write of size 4 ...
   st_open (drivers/scsi/st.c:254 drivers/scsi/st.c:1291)
   chrdev_open
  ...
  Freed by task ...:
   kfree
   st_remove (drivers/scsi/st.c:4512)

Remove the index from the idr before dropping the reference, all under
st_ref_mutex. A concurrent scsi_tape_get() now either runs first and
holds a valid reference that keeps the tape alive, or runs afterwards
and finds nothing, so st_open() fails with -ENXIO.

This restores the ordering st_remove() had before the conversion to
st_index_idr, where the tape was unpublished from scsi_tapes[] before
the final kref_put().

Fixes: 6c648d95a6af ("[SCSI] st: get rid of scsi_tapes array")
Cc: stable@vger.kernel.org
Reported-by: Dingisoul <dingiso.kernel@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/20261007211520.1428497-1-dingiso.kernel@gmail.com/
Tested-by: Dingisoul <dingiso.kernel@gmail.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..d5b90bd1c6dc 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4509,11 +4509,11 @@ static void st_remove(struct scsi_device *SDp)
 	remove_cdevs(tpnt);
 
 	mutex_lock(&st_ref_mutex);
-	kref_put(&tpnt->kref, scsi_tape_release);
-	mutex_unlock(&st_ref_mutex);
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, index);
 	spin_unlock(&st_index_lock);
+	kref_put(&tpnt->kref, scsi_tape_release);
+	mutex_unlock(&st_ref_mutex);
 }
 
 /**
-- 
2.56.0

