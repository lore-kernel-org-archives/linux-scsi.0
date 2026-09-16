Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D1B4457B6
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547748; cv=none; b=mRdz2015ZC7yElHMPetRx84D27MDIBSysB0CUBap1to2ZE64I0GjyWCrWkTi7eZFb8QMNWFh/eNbETs28erQd9kwJLPt2sfX9Cwnnw6LtnfTVu2zaSqoM873ELdRc0fScfMJvOyc7X36PS56gfjm0dvu5tXKt3xo+kL+k9GZuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547748; c=relaxed/simple;
	bh=YS8G7xFDIqSMALlBBgwgzLsTXiltwDXlZ/lvGyRz+Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl1nTGgZe8jBMka9qnuIvY4ShlI9TvLSnS5lisuFD1gm6Cmj3vwkQApjjknNpp2MVIDVvkcyzhwY8wwikJv6G9Cy9YvxpM3lKdNIlpVVA4NjqQH8B4VCnSbV3Pw+jB+SQoRp0ool86lg0fw4cHY9rb07tJfWuZ06iWfpzQRQh38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Dul8xHbn; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Dul8xHbn"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-382ef647e20so3649431a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547746; x=1790152546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hh20xApue4fwWsHR+zvFD8axJLUqwcBrKIhIHy4dJXs=;
        b=ZyZ2qvddv9K3yuuLoJgCmJBWyUs6dSL+4g0kUNHC2J2jGVy6oR9Bx/ld+ViA4xCVW4
         87jmi9Jr4Du7ddkh9m/DsT6hpHnUDfvrtc9utZvjmmtKj5qDYCeD/skH+e5k6Zw5eRq6
         aLnX5WtMKYWxZ8FvILClDaxYAHdffoT7CdhDGe7q2NVkbzq4PBjCUmjtfa2j3IKYyQo0
         7dgakHwGv10Tmfyu5tHx/ItTiAc1JJ/086ODORWeWeY+i0QR8FAKhrN4MFqn5MIKegTa
         hM4VSVKbTfWPUlHElMCpTI5lB4BUYDkBQFhdUNf1GwfBUsAZkjWBiOK73V3OVQTzuHvE
         T6pA==
X-Gm-Message-State: AFuF++mkFR8+xa27wra6LmoFjvS1DfkkNeE9UfqtsAdzpIKN2gg/fVO2
	nUJzU+vICXzaNE8vdHc5ep0pHnCrrimat8vy/3AF3mFJNLFPez6EpGyagXbQxeWTAaA4lyhGaAl
	/6fzjyQiLjf8hpX4eV1VI4mnQsc/pIkrNzmvqMCZ7XfEIur8/UkMF7Dl6ZZrqyBsTFGeIK0U+zZ
	NBJ+Ke/AT4HzBDMZYjmTH86kTVhFDyzrhpUYWEz3Wzc89cvgOzlHIcagwUhj6B3C9u6TYAkdGN0
	YlbWCM+Wst2iuiy
X-Gm-Gg: AYBFou2dxHwtzMpxL1gWFPVFAej99ivjXC8wfDeK642M0/6+2ry0LqvQNpbrXElEf7W
	K00m1KUbSc5k26mEYRalbQHWPc2jm+yXsGJOFfyFalyoxDzciuKFchG1GEvrpjvIkUMIsB6ttWL
	e+/r2ZAppTEtBBXvunVMfU9A6q3kvhnTAt7Ovs8f4NAD1DOq9BvpzBTrjVFG70hgfdYwk9JcmnO
	dMN1NpMcuQDcx7OdaMVVoJ9jqFEJyAqVUxdeIXW3hElyeFPtvppEC0UYOTba8IMQDABRuPz0B6d
	hCUsxC6VtEOCWncWJRMEpUwWWjBpgDPPKTMlGZsD/76mJmH50b4tkkt6ovcr+XjLZw5Qnbg1s3R
	QPnlXaBGiJi+3/spqBhk90lmJTqUPyXTifNqtzVRZjlEt6/eDBANAaYziuC6T8yRUsU8X8Gej45
	u9jBHEhJ6YaUKIoDQK8jcYTC1ezKLRiGKvWHE=
X-Received: by 2002:a17:90b:1c04:b0:39e:d2a:e25a with SMTP id 98e67ed59e1d1-39e1e45f28cmr4040493a91.13.1789547745870;
        Wed, 16 Sep 2026 01:35:45 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39e1b3eb552sm1047097a91.2.2026.09.16.01.35.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:45 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d001671a54so104838475ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547744; x=1790152544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hh20xApue4fwWsHR+zvFD8axJLUqwcBrKIhIHy4dJXs=;
        b=Dul8xHbn5/6yHkWuzSLqcxQCCu3tIE5Vjmz4UwZHKaomqpB+I8+UircTlGiFVeZsan
         CtDUe5RlV3iM4GTWxlqw+xvHSBxzOo6Eillp5VFIPFYhF71spq4t1NIo+eUAGl6x7ALA
         DMEfjSMiJMn21LOO+PkxirIuX3uLnSWvHJqEg=
X-Received: by 2002:a17:902:f68f:b0:2db:20fa:9443 with SMTP id d9443c01a7336-2dd8e5247fcmr35326275ad.13.1789547744109;
        Wed, 16 Sep 2026 01:35:44 -0700 (PDT)
X-Received: by 2002:a17:902:f68f:b0:2db:20fa:9443 with SMTP id d9443c01a7336-2dd8e5247fcmr35324895ad.13.1789547743121;
        Wed, 16 Sep 2026 01:35:43 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:42 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v5 10/10] mpi3mr: Driver version update to 8.18.0.8.50
Date: Wed, 16 Sep 2026 13:57:05 +0530
Message-ID: <20260916082705.44712-11-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
References: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Update driver version to 8.18.0.8.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 4d19a9460d38..d6e16707fd97 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.17.0.3.50"
-#define MPI3MR_DRIVER_RELDATE	"09-January-2026"
+#define MPI3MR_DRIVER_VERSION	"8.18.0.8.50"
+#define MPI3MR_DRIVER_RELDATE	"26-June-2026"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.47.3

