Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3F13E5ECE
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 12:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776170484; cv=none; b=NUQ0YM1aH4gwB30SY0YWFuHGsMA7qIF3x8caOmWLg2nD3vIwOpN4VWutpsXYldah8IwIb3x7AWpia1+hs57JQKamMI3koCHRk/XlArJekX0uCViEtMqSlqvJLzt3m1MMT9xobF/HxcNqq4k5R++ShkxUfhe/yF0+SEcQvM0+2jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776170484; c=relaxed/simple;
	bh=CHNuLZhhG1HQ3bSL731Wflt+jlh1HGLvr6pf0eZX0fA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NaT22b8HMZdA7RCrSZ3NkiUGU/dfif9VhosKDVqTdzoT6EZ9M292w+Q8PlybjtT/U6Tp31zb8Wp7syml7UpbY1AKDU+XjZMPVTbL26ekqVVNsl28g+NgLEFUkTQkyLWnKueUHdesheGaVfAjYBBYhmnropMDdhl2bjM4VeTgAcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZuppoDfu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZuppoDfu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776170482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IPAeBhGhGxR6oZrFAZL30MNll0N7+ItSi43kDk//iXI=;
	b=ZuppoDfuvNupfMZS+etMCXeJP5iXRGv84dBMomxiUURzTBCzkiW2HvuvShfrLfJGhTKXqy
	KzqNnD2gTNeFC5lltPyzUjyzrtarTquukelUjX2dfoXMZ3K6Ss6c5wCqGAIcXjFgyM4GYd
	3JxZ92rQgd8lyB50rgZaeCB2iEKvtwQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-sRmm2sYlMjqZfHcfgGSuMg-1; Tue,
 14 Apr 2026 08:41:21 -0400
X-MC-Unique: sRmm2sYlMjqZfHcfgGSuMg-1
X-Mimecast-MFC-AGG-ID: sRmm2sYlMjqZfHcfgGSuMg_1776170480
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 972F6180123C;
	Tue, 14 Apr 2026 12:41:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.43.3.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BCEC9180049F;
	Tue, 14 Apr 2026 12:41:19 +0000 (UTC)
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Don.Brace@microchip.com
Subject: [PATCH] scsi: smartpqi silence a recursive lock warning
Date: Tue, 14 Apr 2026 14:41:18 +0200
Message-ID: <20260414124118.23661-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On systems with multiple controllers debug kernel shows 
WARNING: possible recursive locking detected 
during shutdown.
Each controller does have its own ctrl_info (and mutex)
and that isn't correctly recognized by debug kernel.
Supress the warning by releasing the mutex at the end of pqi_shutdown.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b4ed991976d0..2026ac645d6a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9427,6 +9427,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 
 	pqi_crash_if_pending_command(ctrl_info);
 	pqi_reset(ctrl_info);
+	pqi_ctrl_unblock_device_reset(ctrl_info);
 }
 
 static void pqi_process_lockup_action_param(void)
-- 
2.53.0

