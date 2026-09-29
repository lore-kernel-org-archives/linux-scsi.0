Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1CF47140A
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710119; cv=none; b=s635+Q/yhk51hp+E9oPnM6uomlYyy+m3v369/Jd1Ih1s5602IxCCJ4Y7QPt6Ktu6nfVj05mBgbdy1X4bfvsDpNPhYaMhdj6HrzwGUckP5wW7a+KkbSd5A6c26F+AzdWjMSkBv9fRw4Vll4WZb5pvDzCUB4wlDNF2jwVNaJ8kUmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710119; c=relaxed/simple;
	bh=iPmzYAF2wjtRw8FfPjwvE9Lc7Lu+hGwstgpcktW4gs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XXJ2hbUbp+H8Qll1dCHZLN4H2ihiA/TShQdVWQM4BtJjXSKYqzW2/mcu+swtOS1FecISJNIpgRr8l8CVjxEm4eHtyBVnCEjGBoWLrU8W9XDQKZKDCbK7P87vTnSuFGvY5MEt+gIKmEb8lOeqUX7e5BGctdO7mDkhQ7Z3N42A1GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eDgexTL3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eDgexTL3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790710117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XMcJ65RbTE9CDBl0rHSBHrsMoxBXQLG5vKm57180Opg=;
	b=eDgexTL39o930X8nLVgjp8vP6rzx8klbIY3ytsdVsT8q8ltHpDJ1C8dC8yF31ulSIMIFY6
	K/+FUZ8nXlhGL8ny58CM95kDqQ09MgTrWt6EZw5NJsIjwAr8uBPMOFDTO9r/i6PG+6lYkY
	GOVyAL3r7XxNegWP0gh7KpznEcWo1+c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-mIjHn1pQPseLzOQ9URMsuA-1; Tue,
 29 Sep 2026 15:28:36 -0400
X-MC-Unique: mIjHn1pQPseLzOQ9URMsuA-1
X-Mimecast-MFC-AGG-ID: mIjHn1pQPseLzOQ9URMsuA_1790710115
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B180B1977582;
	Tue, 29 Sep 2026 19:28:34 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76EBF1956047;
	Tue, 29 Sep 2026 19:28:33 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH v4 4/4] scsi: st: Relock the door after a reset
Date: Tue, 29 Sep 2026 15:28:21 -0400
Message-ID: <20260929192821.997675-5-loberman@redhat.com>
In-Reply-To: <20260929192821.997675-1-loberman@redhat.com>
References: <20260929192821.997675-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

With auto-lock enabled, st locks the door at the first read or write and
records ST_LOCKED_AUTO.  A device reset clears the drive's medium removal
prevention, but st keeps its state, so it never locks the door again and
the medium can be removed from the drive while it is in use.

Set the lock state to ST_UNLOCKED when a reset is recognized.  The door
is then locked again at the next read or write.

Suggested-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
v4: no changes.
v3: new patch (Kai Mäkisara).

 drivers/scsi/st.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f548197..e089d3a 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -368,6 +368,8 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	if (ctr != STp->por_ctr) {
 		STp->por_ctr = ctr;
 		STp->pos_unknown = 1; /* ASC => power on / reset */
+		/* The reset allowed medium removal; relock at next access */
+		STp->door_locked = ST_UNLOCKED;
 		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
 	}
 
@@ -426,6 +428,7 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	if (cmdstatp->have_sense && scode == UNIT_ATTENTION &&
 		cmdstatp->sense_hdr.asc == 0x29 && !STp->pos_unknown) {
 		STp->pos_unknown = 1; /* ASC => power on / reset */
+		STp->door_locked = ST_UNLOCKED;
 		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
 	}
 
-- 
2.43.0

