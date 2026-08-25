Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689F12F5A06
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672733; cv=none; b=m0lWIrH9mGCc2fHtZB+fBUXnYmITKTfkPKoQbMh6i6MoPbP5cHm77tp04j0x9F7hAVgmPjqA9R5NmTZxueNApJEN+cIZiwaChagFwwQH6P8vw2feCnwjJxmbDyWZIyCY5cG/RRe8K5zeKcMiqoF+krJnuG4D3c40KGRLcZrfN0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672733; c=relaxed/simple;
	bh=IT47/JA4fCV8LQHDCPeZc3lhGHmL2UEJNvl9TL8X6dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOx+Oll0r03cM4I+BJRLYloHWslKBdPvipOPZeC+zZpTrV+nCPzi8cfecLTjWPLhb3UO4v2j0P2PxUhO4HKmu9vMJ2QAg3xccXvyJMjr1DLTwxKnGuc2+IiJnrHq0g8x3+1WHX4ZHF2WYKhQkgVpH/+VOQs9Fkq1LnYnecYi74Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hPaff2e/; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hPaff2e/"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3964e480f76so1263726a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672732; x=1788277532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/MN33ituDobO68T8U4zoo+FK6MwYnpBfS15rEucuKFM=;
        b=pMKVd3s6OGBSiiahey3FhKGgcD/FAyn2iwYQc8nOgvhKG6Sgy4Tr5m4dS8+E9ut+LO
         5JrYOAk/FIsqocW9dDcDx7WHjFPaF63ugI2O2v7jg/2fJtBLyTTHgVh+AxLutuOJSQeS
         omaK8hheABPBF7npMUDiwyyZderkckiAcJIgtTrIFopcM/X0DtHdR8jv6mbBWd2FhuEZ
         Xt1XU+LQ71kXVwEPYMKaVRu5CrGvURmXkEz3vE/MxTx92xS9tWGkfHEl0cO0R8IQlWbr
         DwEHCPBTSJklvcss0wP95l3PvTjMgWo/n8m9+c11+QNhpbovGQMC1dRw0zeVEenDglK4
         E1VA==
X-Gm-Message-State: AFuF++mPu/vY4hk/0BxzIIk6u9xNubsGj3OppQgpMSD3O+bFNFb/6NFC
	T5D01gBYjfxBSwzcKxX13JVLos5TOjGivMzsYgJHIiVgqK9oPPI0gEaggmxu44n8feY3DUfcxOh
	3x/OnX4FIanjnWptdEcQhLZ2VR7ugrrvd0gF6igdG5L0GX5EYe9HUEDvobrcjdeJZfdAKBxar7G
	KLzU2LHAVqzYZfVgiKixT5S2qKkWJtCdyk8OPWG+WuczJnogakCSdROh6c7YVMtU3w9l1BjLvU0
	agE2lB4aHb5tns9XY05M677
X-Gm-Gg: AR+sD10Vj8ggedgRxhiXjAmn5czFAH1zKdMFX0PoBAFOtbc/IQCQj0m5lLXvEFc9L0G
	ESksPVJv0uYUdPDPSmOCT4aWdgtbX63ruJlxElRwhoVpsv3NgBm4y5TC5Hgvb7FYnISG/JnCy9P
	KI1bxqHyM2nFpR7lrH+MNkEyUuI6Bz74DE1/kJwjB7ahqdDd+53P1t3VnpIlSVS7OQL9ngV1Qg8
	BOVevo0PocAkRQmML65s6x7YmnRyM51FzIu11k4jUfC6ejlFXdQ+j5oMzTCPF2r7FpgvUGJzlxn
	/8DTQLOpAvYC/ci1SWotD2CJK9rXsNNTzVLmXc4qVbV/DLCWkKIrK65dGu+dJwR11LookaFeoLK
	WK8DLuxvCP2KW437Kk3h7QSd62NwNLZIFl/c8IcjZwL4AGxSAWVQ8CdjsDl3u+uZ5dlFcdj6ngr
	KS5lC06tsdoLTl8GyOpaH5DPANFH5Fyrb0WfTE9OURf9c=
X-Received: by 2002:a17:90b:390e:b0:395:5eec:b932 with SMTP id 98e67ed59e1d1-3966d5f90b8mr49982a91.11.1787672731602;
        Tue, 25 Aug 2026 08:45:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39641f540e7sm498601a91.0.2026.08.25.08.45.31
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:45:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc11b5dd54dso6206611a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672729; x=1788277529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/MN33ituDobO68T8U4zoo+FK6MwYnpBfS15rEucuKFM=;
        b=hPaff2e/CntljwTcapzUbznnmfNaLiMQUIa/wTjh4YMUiToAKaz+MkjdvF8lwLfuh7
         dPVC1EAAmw09zZ5k1kTwgefPFOhyypH1Qm4LHIc8KwmkCethObYX5sshxv/87SdX60H0
         OBp42aknIuEQamPVyFhWvGOqlFErWYbC+xnxo=
X-Received: by 2002:a05:6a20:b7aa:b0:3c3:bbe6:95c7 with SMTP id adf61e73a8af0-3cd913c6c58mr17665135637.17.1787672729446;
        Tue, 25 Aug 2026 08:45:29 -0700 (PDT)
X-Received: by 2002:a05:6a20:b7aa:b0:3c3:bbe6:95c7 with SMTP id adf61e73a8af0-3cd913c6c58mr17664973637.17.1787672728813;
        Tue, 25 Aug 2026 08:45:28 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:45:27 -0700 (PDT)
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
Subject: [PATCH v2 17/17] mpi3mr: Fix NULL pointer dereference on PCI error recovery
Date: Wed, 26 Aug 2026 02:34:11 +0530
Message-ID: <20260825210411.301535-18-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On a frozen PCI channel the driver unmaps the register window and frees
the interrupts, but leaves the firmware event workqueue running. An
event handler that is already in flight can still reach the register
window after it has been unmapped.

Stop event processing and drain the queue first, and start it again
when the channel resumes.

Fixes: 30bafe1774f0 ("scsi: mpi3mr: Support PCI Error Recovery callback handlers")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - Removed stop_drv_processing and mpi3mr_cleanup_fwevt_list() calls from
   pci_channel_io_frozen to avoid workqueue cancellation deadlocks and
   preserve transparent I/O recovery (SCSI_MLQUEUE_HOST_BUSY).
 - Added pci_err_recovery check in mpi3mr_fwevt_bh() to safely skip bottom-half
   event handling during PCI error recovery.
 drivers/scsi/mpi3mr/mpi3mr_os.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e97e343b14fa..a389f7f2c741 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2130,9 +2130,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
 	mrioc->current_event = fwevt;
 
-	if (mrioc->stop_drv_processing) {
-		dprint_event_bh(mrioc, "ignoring event(0x%02x) in the bottom half handler\n"
-				"due to stop_drv_processing\n", fwevt->event_id);
+	if (mrioc->stop_drv_processing || mrioc->pci_err_recovery) {
+		dprint_event_bh(mrioc,
+				"ignoring event(0x%02x) in the bottom half handler\n"
+				"due to stop_drv_processing or pci_err_recovery\n",
+				fwevt->event_id);
 		goto out;
 	}
 
-- 
2.52.0

