Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8307147AF65
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075836; cv=none; b=HS1X0ooX3Cz6N8lIgllcxKMgXpMhuVhx9HJ7nIjUwdYcknX2hIN7r1TF8IIiTN39bwDBexxbgcU76d+zFDISYSkqyXYf5y0aE+Fr36kSGNTGwZaMoSmXHcNED3nRpwfJzPp0klvxSj1CAgg+n5jo7HTkild4R8SozYbD6S+321Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075836; c=relaxed/simple;
	bh=H4rfqbjZW3PjCg+laeg3Z7ylMiXzkUNFWZc+La6hF1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTuvKMQIFBPgtIfpwkwyaeoicgVKq2yKx4A+Q66vG9XpuNSp2S6ulWVdYVU4mc/L3eje/UG/B+S2p69LGnIvHeJBjC+z3le5LmYQn3MZww/RduPN/V129+RHSJ1aAinuUv77Q4oM1uND85pS8XeMBaqcVjkkDljya7RjH54ToWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=YCSka42T; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YCSka42T"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-381b831d535so340044a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075835; x=1787680635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KMAOfD8xNts03aElkbAlSJN0VAr63f0GAnw4kXjqhRM=;
        b=FL+h/XF4vmcEc2lvowutrAKOUa+yOeUhP7jgTXS3rSDHkZYLq5dSldzDNOCXJFndou
         Y17543eC58psOj2cZoi30p+rmafTPFRERNb1llpKKVH86Vj/7Jd9fMp6cY3PvSXBunGF
         HehRfeVNA5NHtUHGsG5628ueUAbAIZa8zt0J4Vujqc7vuE6mEMlgj9azoFo2MFBpchV4
         4wjF6V/CYnBMknRNqRemvQeK1g7ksoMfCa5mgKj+PJZO60kVr25wHv93dDctCL2otAQ3
         BQ+cCHcikBF2UKZaIWFr7cRBwtYfFelZFUsIg+3PvMfI0dva48zcZqn2Fzp7lkl6sw+7
         tCkg==
X-Gm-Message-State: AOJu0YxHahq3K0hCrmrz0hWVfxQP0yPAu9EwIeMOQ++h2W3gYlDnUuXh
	2mlY82vx/LMwa3kJ93Y5fYqjNWJ8F2GtWrMMx3qbQ67SI04CD6VYaxj4/FUthjtma4Aa4UW+GWp
	AGibyN0UBG9tgqbosAUUUbG0D2Pb/LZHMM7DYGiLflTipp4sioemq7SsO6/oJ7Qd9b4u1V/VibN
	iEUgnQsqDub7sbXgjnUYzfcl/mTgKMCAHyW9koVAhJ5T9Cri5bUEzqd5ZpASBxCme7O6KGW23Pe
	lV0WhWDRPREXO78ic4GZIrr
X-Gm-Gg: AR+sD12H61M73lSQwprMxlB6fc2XEOZSScFeHdAh5JD1UbiuZQzvXRUR8SqT5HCaD2U
	CGdje4OmbDsij5Tr7jFxLRJC/rE2yxtKDw092ZrLkUmF+wFDvqtTV4UmDlKhSoZpQrem2itaAgP
	RHWK91jJDn4v4qCfjZX70qNQDVUBrofLPfPjHatoPEyGovinKOqeUjk/K4O9SdRjOj+dAf4jg/E
	lxc1L9rxeDCzoJ0JBW0sgPMIPdyBhdf1Lw4kQApDDxbVmtgjWtAZmh2SLeXkjHaEE49GpTJh2z6
	Kn0MrxSz4geR+I5H+63tArg4yfFwoKpG09I5TvVerWut2Z7vmTP9PNB+URPwboGZ86SlSy/GoPw
	8/9BGz7RbjrqCVchI3F+0CzanC3Wna6TvlRankq5hKetTeeLkQRYO6WBjs0x1Mf+H3/QP+cquGY
	xR+2LwewHvwmnaAN5PyXiwFDWowwbOlUl8CkSwkUGrTYE=
X-Received: by 2002:a17:90b:5101:b0:36d:b424:4f17 with SMTP id 98e67ed59e1d1-3933b6d0deamr44984283a91.1.1787075834736;
        Tue, 18 Aug 2026 10:57:14 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3954d176bfesm2723597a91.0.2026.08.18.10.57.14
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:14 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38dbf293831so376323a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075833; x=1787680633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KMAOfD8xNts03aElkbAlSJN0VAr63f0GAnw4kXjqhRM=;
        b=YCSka42TmeewijJHP6cKeFAdAD/x5OGL6GLtaVUkymethACzlfsjz6dU5lWrtu9RMb
         HLlf72K/KOK1RqLrr0gl1XHndGQ/v+KBxh7J7bgSesA1EZ01AsMcqGDB23ZcmxLbL+Ie
         NpaXskApfteFP0VHGZT74qQHkD3hXb/V4NCIo=
X-Received: by 2002:a17:90b:520d:b0:38f:5801:cd76 with SMTP id 98e67ed59e1d1-3933b6d0171mr42958851a91.3.1787075833029;
        Tue, 18 Aug 2026 10:57:13 -0700 (PDT)
X-Received: by 2002:a17:90b:520d:b0:38f:5801:cd76 with SMTP id 98e67ed59e1d1-3933b6d0171mr42958713a91.3.1787075832416;
        Tue, 18 Aug 2026 10:57:12 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:11 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 05/17] mpi3mr: Fix buffer overflow when caching log data
Date: Wed, 19 Aug 2026 04:44:14 +0530
Message-ID: <20260818231426.58105-6-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Each log data slot holds a header followed by the payload, but the copy
was sized against the whole slot and so wrote one header length past
the end of it. Subtracting the header on its own is not enough either,
because the entry size is derived from the controller reply size and
can be smaller than the header.

Work out the payload room first and clamp the copy to it.

Fixes: 43ca11005098 ("scsi: mpi3mr: Add support for PEL commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 94b992acb233..cd772b2cb98a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2947,7 +2947,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
-	u32 index = mrioc->logdata_buf_idx, sz;
+	u32 index = mrioc->logdata_buf_idx;
+	size_t entry_payload_len, sz;
 	struct mpi3mr_logdata_entry *entry;
 
 	if (!(mrioc->logdata_buf))
@@ -2956,7 +2957,12 @@ void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	entry = (struct mpi3mr_logdata_entry *)
 		(mrioc->logdata_buf + (index * mrioc->logdata_entry_sz));
 	entry->valid_entry = 1;
-	sz = min(mrioc->logdata_entry_sz, event_data_size);
+	if (mrioc->logdata_entry_sz > MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ)
+		entry_payload_len = (size_t)mrioc->logdata_entry_sz -
+		    MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
+	else
+		entry_payload_len = 0;
+	sz = min_t(size_t, entry_payload_len, event_data_size);
 	memcpy(entry->data, event_data, sz);
 	mrioc->logdata_buf_idx =
 		((++index) % MPI3MR_BSG_LOGDATA_MAX_ENTRIES);
