Received: from mail-oi1-f226.google.com (mail-oi1-f226.google.com [209.85.167.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0C421A453
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 08:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772008367; cv=none; b=Iy0xzdVq8Evs6iY0H+Et4pMUGdT5fme4luzzo4DyuludKQ6Q4gPZWdncZeVFrk0ZNdsxcIAaQbp5cYUEmslRT4cdJxF0IZ2KqCLTPPWgaL205YCdY06aUEhns1H4T5LpkLgx98Q/0vfpsL88Haapls3n0vYRs6L+emJ88h4SP6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772008367; c=relaxed/simple;
	bh=T3BDWhX68lSsYU9+wvCEApk2BI6omk9WZULhxMx12oM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZaO0P4AHW02++ZqwVRvkf/76UxI2N8j5sjeWO/3Ubf/lWir3Ie5G3yD8YOCaug4jYLNifhkbM5O1MeLIPw1ak7BNyHGEWmWzqAgMKvwil9+7WUr6a8syJ9GJEa+bXr8t/F6jhzfFnLU3zb5ShNWb70DEEUdE6aNBMBJu178cLKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=QQWyWdeu; arc=none smtp.client-ip=209.85.167.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QQWyWdeu"
Received: by mail-oi1-f226.google.com with SMTP id 5614622812f47-46413b2c3d8so2200610b6e.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 00:32:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772008364; x=1772613164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6r1ydyvMhAB0kpg/vJ+VWXvjahaNSh1DbXJDE94meNI=;
        b=cdHQdRhR+9hzrvEwECW3LSdQKUUp1O0C8bPEdNY9GJRGr1Yv9XxUt70fTrog+0l2dS
         Ehp2Rbr6x20bHIigT8qc0m0MtPEg5XvWOKKVko4wpJH048qMQGEn2I8M01lLhCsJ81FT
         o6mFiEdwt//+H3W40l/SW7qdoZX+nfJsSDrmr8UVQRE8oD+VScDS/5UZ6lKIoH/ey/Az
         1JNu6dMoRPyxNTzP27PqHqjBWc6YgRNYZHGptpab5jC8FEHsqMelOmpHx7hheWNSsNVv
         XbrtRV0X/h2mwMCfmurmYmRima6AAMGaqnOKzWXldTg6s313geETOmTVmLbvMEcG3dSZ
         BoZA==
X-Gm-Message-State: AOJu0YzrqSVUeXSAXiDxt227eQlHN56CYp1plOrm0TMYMOu8PyBEZwnZ
	pQWBvgwGkRqNtC1OSjH6z9tBARj5SV5YvgoHTAS5voGF8aXfU8OQKSWDvRbPGFzaaV93Wrea8pC
	mHsDcJSQdqqqr4zoTBQ9YQS0DTbgo9gF4LlPik3gTvI/N7pLzIro4lc82iWFHvd2eAL1V7uUhYX
	gIgacKKdWdalzO1NidbNFSgn6aSEptRHXvU3eM9YmcB85fQzxwU3CxpAnA9xN6W14IoEIk2jeFo
	oqZaV7Caw3oyaO/
X-Gm-Gg: ATEYQzycMvDGECoYuxXu/y9o0LUZrd/cJSWDAuHH3GQitQYa0t2XqNJQPm2jZXbVsz6
	SC79aNtTMsvSbAMCWAOnttTENwbcSqh0jNuOQSbVjTBN6clNjSBl6/M/H65LkvU9pb51NW+36uB
	mD3uW91O/knMiOBIIJ6N4wwm8Lte05OgnDr1HHFyAYGVW87YhUIDjKCNkUawZEsIBuaSlaI9RdM
	zKKDC9LVYrSD9+31UD20itVclTX3XTYUxe0M+be+NAxo6TF9Fl0KfcmYxS60Doj/7HENdkjSNZw
	HeVZt7wVMVM2zbD9anmzUOWgF5Frb1YH/2N5pbiXoWA30ldmUe7HVPqYrmqNtxsFnGGx0J4rTfg
	R4ECCNpXKHex2RNw+I1wjyf3W5rtSYviZ/XgcspMUbR6BFGwLj3gwoIQzUujQC8BkVZ1lA6eLga
	oPWnf4NtECxkaBuL35eVe9qSAmFniBFKva7csw76peBLp/jwVlYwuc1lATtVE=
X-Received: by 2002:a05:6871:7891:b0:409:66f2:c281 with SMTP id 586e51a60fabf-4157b1aaed5mr8434076fac.48.1772008364424;
        Wed, 25 Feb 2026 00:32:44 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-4157d2c8b35sm1645438fac.11.2026.02.25.00.32.44
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Feb 2026 00:32:44 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2addb9ba334so2258525ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 00:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1772008362; x=1772613162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6r1ydyvMhAB0kpg/vJ+VWXvjahaNSh1DbXJDE94meNI=;
        b=QQWyWdeuKcGJXF5oxO7YEqBk3Nr/CSp5K/r618S5XTpRwkgMnZP4rgpUbn/XhfEdKf
         6Nf32UPjTeiYrNqqBKO6oCEtXget1oxuk68lw3ZpLbuO2Na+nbjzALSIhSGplYQnHDa3
         zeBR7A0LwtPMVdHJZssR1R3lRf5OlHGXQK6Ks=
X-Received: by 2002:a17:902:ea0f:b0:2a0:c942:8adf with SMTP id d9443c01a7336-2ad74400677mr144776255ad.8.1772008362575;
        Wed, 25 Feb 2026 00:32:42 -0800 (PST)
X-Received: by 2002:a17:902:ea0f:b0:2a0:c942:8adf with SMTP id d9443c01a7336-2ad74400677mr144776035ad.8.1772008362006;
        Wed, 25 Feb 2026 00:32:42 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad750591e2sm126791905ad.91.2026.02.25.00.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 00:32:41 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1] mpi3mr: Clear reset history on ready and recheck state after timeout
Date: Wed, 25 Feb 2026 13:56:22 +0530
Message-ID: <20260225082622.82588-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The driver retains reset history even after the IOC has successfully
reached the READY state. That leaves stale reset information active
during normal operation and can mislead recovery and diagnostics.
In addition, if the IOC becomes READY just as the ready timeout
loop exits, the driver still follows the failure path and may
retry or report failure incorrectly.

Clear reset history once READY is confirmed so driver state matches
actual IOC status. After the timeout loop, recheck the IOC state and
treat READY as success instead of failing.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 04d4a2aea7d7..e418bf1b47d3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1618,6 +1618,7 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			ioc_info(mrioc,
 			    "successfully transitioned to %s state\n",
 			    mpi3mr_iocstate_name(ioc_state));
+			mpi3mr_clear_reset_history(mrioc);
 			return 0;
 		}
 		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
@@ -1637,6 +1638,15 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 		elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
 	} while (elapsed_time_sec < mrioc->ready_timeout);
 
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if (ioc_state == MRIOC_STATE_READY) {
+		ioc_info(mrioc,
+		    "successfully transitioned to %s state after %llu seconds\n",
+		    mpi3mr_iocstate_name(ioc_state), elapsed_time_sec);
+		mpi3mr_clear_reset_history(mrioc);
+		return 0;
+	}
+
 out_failed:
 	elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
 	if ((retry < 2) && (elapsed_time_sec < (mrioc->ready_timeout - 60))) {
-- 
2.47.3

