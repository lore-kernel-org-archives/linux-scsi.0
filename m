Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991A6264612
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 03:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791343078; cv=none; b=cSaDPyOSWW4/FzfwK1R/JG9ajSkyP+Piz+gL++sETZOQKdCNaLAgZgaKRO7a5VN1adUUr1jc8gFaxsCFqrf8Csg85haRmjybH05zVjQDsmlXCtVrVYpXWnzRkQ4wu7u+DdK3F8oCFkUVfElUdisNNgz0bNulNGOZAXVf7IcdVII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791343078; c=relaxed/simple;
	bh=ds1XhdHLj5dnLNInfOd7LIrtEsMtnzYuVcsSLS+ymB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYu0W8gG0yvtiBmFKweDu55djmDkW0LbG4kcRB6+RIiod3PhzmxC2woBFci2GlrT4cOc/m2P8/Q+N6u9nF5mbEtjbMO0ESUAZL7miKoUIV7bplHeReTczKSSICpPIBLt7VN5T59djTqlhK2cGb7KsUCopMDrnnvmwUCvYNdW044=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=mQWdPPHK; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="mQWdPPHK"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a02551822eso1382015a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 20:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791343075; x=1791947875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ds1XhdHLj5dnLNInfOd7LIrtEsMtnzYuVcsSLS+ymB8=;
        b=mQWdPPHK3yuPtBL37IWIVF1Z7zMDzmWaPYFk7XMo7GYdKVQw9pxkF2opwSqc/03JzC
         tZo7kWKv1ATlsEnTXxlR523X4s9F4PRFUGnCGlWiZYszNj5Xi5y2E4d7ngF2sNMfYFt+
         zzkwCKrZE4Le9R9h2OAomG57NNZQGRlT6CnXJLLf3B1uVgOWxvpKsQUskkBesAsWtHc1
         bRzodWEUo6oEiZl5feK2NImhT3S1SclNGpV/NfRwjjB3JnT4lwhi5Pwe8WUdilAjdUjY
         0ugamQ+EwDh5ZI32OUZTDY7kpSxJ/5JbNL0uXVgCRJ3obASKxX6y1iHWcTJbZOVwCWGB
         Ll5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791343075; x=1791947875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ds1XhdHLj5dnLNInfOd7LIrtEsMtnzYuVcsSLS+ymB8=;
        b=1GqJz94lfywXJdLoxNKj2XnTkipOXOwfy/wpuOWJFTAryu7k8aSI/YjGYqlK+kvjjX
         gxEbNiH8oY0AsxQKUi+ZioisMuY8/2DImb7tnOlkSHWJQvutYKGyWEBAXJXWTISZKWBK
         NeRWWKbZ/w3BWu6M3JAMlmv3s2AjvMeac7YykdT9YpT3D/VmA8Ke7vlnHh6yk0sjvs64
         LPrBN6nq1Ji2Y4sgBGjgD6AMoO7eMcDase4iUN+jK6AOtjhTJbH/pMk5Q73pgBKSx0+B
         t8zh09e4gZidG2E3Wq03Ejf63ukBtWHKKjlQGw7E9BV5/+wcSzBaiu6uYfnlasLtcyf8
         sx+Q==
X-Gm-Message-State: AFq9FYLwdkjAJkr31avyT9ztnpPGjPff7aqpXE1faJJIxVHj52/Sq/W2
	oUyIvyf/c9z6trhBrkG2yH63E05O6slMpPYwKKoRDBlJnsEAFAOVaBRdFxVCFJ40Xw8=
X-Gm-Gg: AYBFou2LLkXax193D2yV/+CAtTXUvNcJgKd7YVc2z68xWQOev+YWGkuYQoBGIRlDyRC
	LNQyH1uDX0kmI77sqKPYMWivx3QN7dqGWE25m8VR+9rHA2AhlGGxPdVgQN+HLdGk0nZprRKQ3Ka
	Bxr/BS4ggbjV/Evw0qqokglaFY1/5OwmD/ZZrzxuKmKyiVhVDx5x2x4tTvKWvuowig6rr69UfTD
	eddEYe6cVYdQKYtQhK7DgBmS2quILdol+kam74v/j8ZuVJO4EkHsgK/muFop6DwfzumySjUBo1V
	HjHl5aiRR+6cRJvcleO0uZ3Pu6Qo+vg2tR2yxOhcYDcYGA8Fw1lrcqSSwDf85cMoxBT9aaEApQw
	Bw1a2DyTxuLeIaXQOd9lkqSc8p8tDWqpXg/jK7VUxLj3eBNvPRPK/Hy2Skbgmiy+7bVCri+HslN
	gCfxoTg4iEJtHbjvWPrAMeCNtmirXHgts7C2r6CjDfpBpvirrIwMXw7RMw3noYFeIlDOBk9VEuT
	w3sSw==
X-Received: by 2002:a17:90b:4a47:b0:3a0:c85a:ee12 with SMTP id 98e67ed59e1d1-3a8a1592234mr637442a91.41.1791343075512;
        Tue, 06 Oct 2026 20:17:55 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89b17bc5esm2363382a91.7.2026.10.06.20.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 20:17:54 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 2/3] scsi: libiscsi: validate the ITT reflected in a Reject PDU
Date: Wed,  7 Oct 2026 12:17:36 +0900
Message-ID: <20261007031737.639431-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007015842.634893-3-yhlee@isslab.korea.ac.kr>
References: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr> <20261007015842.634893-3-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for looking at this.

The reflected ITT here is resolved with iscsi_itt_to_task(), which
returns a fixed slot in the static command pool (session->cmds[i])
and is non-NULL for any in-range index. The previous check was
"if (!task)", so a valid-range ITT was never rejected: before this
change a Reject PDU could already drive any pool slot to completion,
in any state, including a fully set-up in-flight SCSI command. This
patch rejects slots that are free or carry an active SCSI command,
which strictly reduces that set rather than widening it.

The window you point at is real but predates this change: in
iscsi_alloc_task() a slot is briefly ISCSI_TASK_PENDING with task->sc
not yet assigned (freed slots are cleared to sc == NULL), and the
allocation runs under frwd_lock while this check runs under back_lock.
That window is unchanged by this patch and is independent of the NULL
task->conn dereference fixed here.

Closing it is a separate change -- e.g. assigning task->state last in
iscsi_alloc_task(), after task->sc, so a findable slot is never
PENDING with a NULL sc. Happy to send that as a follow-up.
