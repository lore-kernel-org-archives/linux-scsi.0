Received: from mail-vk1-f225.google.com (mail-vk1-f225.google.com [209.85.221.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A964846F495
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672601; cv=none; b=n8+edOW79TVA2CDNJGMe87oNumnVKZSmo1r9WOFkmnQeUXxpAfOlKqo8bHk3KoGtDCpVfuc7oOb+4aAFBAfy5POXMKf4PPsybcthGTRI7HO8X3bCVE7t7JwDwXiECIqJ3e/lHXU2mWfDjO7vizWEayBr1PwspkGj7wUc4jXEEO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672601; c=relaxed/simple;
	bh=Ex2HHFx2dg/EP7S7uke5WCvzATR3ZZm+DYkBBbrq+NE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Noy4CV3+wAjk7/tpVroDczA3AiSooN5PVZcCS3SNVibhv4xdhsR5XA0/S4BwmfYPhNuQ8CA5VyBvHUSnFYntrBUoZu0M7O8vVaE0ykdGu5LOIYdN9anCxKxwjqw+0vGcq7ERLgXDzaZ+TG4B6vWkK5j9wvK8lLZ9pNWmvlWiyjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Gr9ASxqO; arc=none smtp.client-ip=209.85.221.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Gr9ASxqO"
Received: by mail-vk1-f225.google.com with SMTP id 71dfb90a1353d-5c56dbc3a51so1568922e0c.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672598; x=1788277398;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5wGVmnSgRMM4+oZz8GuN8y52+VM0YonCZQic+TFjgxw=;
        b=qlLdiPdnNQd52cL4A6X5vxF/mzjTjcyB/XonVIK7e7aoJSBCSQgSOO/uLPK+cak7Lj
         hLEb4RPTlhsMprRtiPyRecVuNWSVc3hVTrrsOH5tsaed4OJhEXr9eke/2r9EbeKD9ssB
         GQL78P4cx3WdpmuKaOsCd+vXNRTmvoOGuUyRorwhoooqxl6Yy9wzFUnek8eLbDqSPk4E
         YJ0nUOrInS3cI8oaS2IMrO749LaaWqHdK9yFsqBvnsa5raYDbDtshxQdIUTmedY6UzIP
         dHppwjrdvDY5L+iMiPiZ4GrBc/yGVa8Dq2LJaHB7S5Sc0hWRJuzzxAVuvUPIhLbAC+NS
         PAew==
X-Gm-Message-State: AFuF++kinFMpC9QS1vLn6PMfoklMWhX0hbO3XQVXlHbgA7mSbhE+o8LZ
	kJOFhj16b5cONadIRBh3/9gTLU4ZRAXneDOtKS4EARaqckiV+3IwFUFQALaxmnovTqAs07M9IGC
	w3osj3F0BKD/Eu0KvfGR5yOzrA6LzCxmKI+AbcH9DV1drUjlEX3sYzULXq7gNllg+BxsDHZ6ewa
	mcCN7w1eeeZ94tEYYzi9HcZTMZhOB6dZi5mgCLpJdJU7hNweEOaBfCDiBr5dOQyZzVcNGa/u5NS
	NLsZDf/5hi0im2ofyCwb+dA
X-Gm-Gg: AR+sD10kHVcMmZFp4KLrXGf9CrqEuFJsTbv0UOGWSAdSnjptE4JCdVAqBul5V76GJYy
	48RP2yH7ufkfN0Z97N2zxo6zGtCGrfYIC2GRUz+gIiuFEqghAbGUWlm9tLH3Jo3BcV/460FEIlU
	7b9nMN8apMuWi8rVjh4be1TMshbuKZYJGfqBHpCscBCZYKIabVUKrbzkNxT+t9Rcxl1EZbmSofK
	qa2XPYrQHhpxmPlgeKH/fr2rVWvFKJKDL9yJ1YaS9TuS9hODDOGfM/8bgEYIo9My4BnbEN2gzS9
	m7XF5jR0l+pwZ3cJq+3Leu5bcH8aAQgtpkV5Ar3UN9AeJShYVE4+HEhxaJr833fZE+bEnY+955A
	pFXXnRkJ9JARi2n/8WzYOVs37qkxiPF41oOus/Tb0eXDO6Jt4yuF4/YKFF6wQs37c20WvOGMgbl
	q25Wsqorg3QUPcSRot+q9M/cVt7lbF94UU3soF8YU3pCI=
X-Received: by 2002:a05:6122:d27:b0:5a1:fbbd:6bd0 with SMTP id 71dfb90a1353d-5c642dd5964mr3105708e0c.5.1787672598088;
        Tue, 25 Aug 2026 08:43:18 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c623dedb48sm2313790e0c.6.2026.08.25.08.43.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:43:18 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39512608fb1so11971394a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672597; x=1788277397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5wGVmnSgRMM4+oZz8GuN8y52+VM0YonCZQic+TFjgxw=;
        b=Gr9ASxqOIiXhmXU6+JRaq/bjwZCgGz0WfkSrcvKVvY3ONpXfzUbLj7J7v8kdYNY28k
         80oGIxXw8SFhvH898n4VWOW7u0+ypPCDHtkSzlbTwkvU5h5rc0uICrLMUw1eCpr2yVZC
         3+8U3lxMAgWfaFdtzz60AzOma+58JqWI3sDyE=
X-Received: by 2002:a17:90b:48c9:b0:36d:b424:4f17 with SMTP id 98e67ed59e1d1-3966d3690e2mr151616a91.1.1787672596884;
        Tue, 25 Aug 2026 08:43:16 -0700 (PDT)
X-Received: by 2002:a17:90b:48c9:b0:36d:b424:4f17 with SMTP id 98e67ed59e1d1-3966d3690e2mr151515a91.1.1787672596242;
        Tue, 25 Aug 2026 08:43:16 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:43:15 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 00/17] scsi: mpi3mr: Fix out-of-bounds accesses and reference leaks
Date: Wed, 26 Aug 2026 02:33:54 +0530
Message-ID: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series contains a set of fixes for the mpi3mr driver:

 - out-of-bounds accesses where values reported by the controller
   (device handles, phy numbers, topology event entry counts, reply and
   sense buffer addresses, event data lengths) are used to index arrays,
   derive pointers or size copies without being checked first

 - out-of-bounds accesses in the BSG passthrough paths, from a request
   size held in too narrow a variable and from a copy made without
   checking the payload holds that much data

 - target device reference leaks and an I/O block counter leak on error
   and teardown paths, the latter leaving a device blocked for I/O

 - a response buffer copied back to user space without being zeroed
   first, so its unwritten fields carry whatever the allocation held

 - a use-after-free and a NULL dereference around the firmware event
   workqueue during driver removal and PCI error recovery

Changes in v2:
 - Patch 6: Switched to do_div() for alignment check to fix 32-bit
   build issue.
 - Patch 7: Switched to do_div() for alignment check to fix 32-bit
   build issue.
 - Patch 8: Relocated handle bounds check to the entry of
   mpi3mr_dev_rmhs_send_tm() so out-of-bounds handles are rejected
   immediately without polluting delayed_rmhs_list.
 - Patch 10: Cached num_entries in a local variable before bounds
   checking to eliminate the TOCTOU re-fetch race from DMA memory.
 - Patch 14: Cached num_entries in a local variable before bounds
   checking to eliminate the TOCTOU re-fetch race from DMA memory.
 - Patch 17: Removed stop_drv_processing and workqueue cleanup from
   pci_channel_io_frozen to prevent I/O breakage (DID_NO_CONNECT) and
   workqueue deadlocks. Added pci_err_recovery check in
   mpi3mr_fwevt_bh() to safely skip event processing.
 - Patches 1-5, 9, 11-13, 15-16: Unchanged from v1.

Chandrakanth Patil (17):
  mpi3mr: Fix buffer overflow in BSG passthrough request copy
  mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
  mpi3mr: Fix I/O block counter leak on admin request post failure
  mpi3mr: Fix target device reference leak in BSG task management
  mpi3mr: Fix buffer overflow when caching log data
  mpi3mr: Fix out-of-bounds reply frame access
  mpi3mr: Fix out-of-bounds sense buffer access
  mpi3mr: Fix out-of-bounds bitmap access during device removal
  mpi3mr: Fix target device reference leak in device removal handshake
  mpi3mr: Fix out-of-bounds read in SAS topology change events
  mpi3mr: Fix out-of-bounds read of event data
  mpi3mr: Fix out-of-bounds phy array access on link change
  mpi3mr: Fix buffer overflow in the BSG target device map
  mpi3mr: Fix out-of-bounds read in PCIe topology change events
  mpi3mr: zero out diagnostic buffer status memory
  mpi3mr: Fix use-after-free of the firmware event workqueue
  mpi3mr: Fix NULL pointer dereference on PCI error recovery

 drivers/scsi/mpi3mr/mpi3mr_app.c       | 43 ++++++++----
 drivers/scsi/mpi3mr/mpi3mr_fw.c        | 17 ++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 95 +++++++++++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_transport.c |  7 ++
 4 files changed, 133 insertions(+), 29 deletions(-)

-- 
2.52.0

