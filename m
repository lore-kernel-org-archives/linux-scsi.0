Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5CF377548
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 09:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773997813; cv=none; b=or4LKnI1KGAbuaiLBZljVdhjo3QkDgG3rZZi7T/bG54FCppf6MaQOmp8U7AQTi0h0nJ198FWPxmV9JGqanK+HxqQK5WqaRF9xeiCaHgaBS46xyf4/ILOoOQzJ0IfFhVvTHNCfNpljZCY+xcikrJ99aJ7OPA6IQCSp2I9gfHULLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773997813; c=relaxed/simple;
	bh=2s3NOW1zIX6l/HdvVLP1AO7ouShH68+sSFWA4EQE3do=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sQciroTeDckW5y6Sy+Pmo8mVZgdr/dAr/k7fGhFPJ8i3iRj4eSLdkU2Mlrlam0b65YOovbB/n1W3hTOjsVQ0PsQMsPsDB+6wOV/HYvTQn7awZsIKLMM4PVzOck1iyax0S0alTBmlzKAyQNgXO7kk7h6dooL7+odZuWeFCgMBorg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bmTonWrc; arc=none smtp.client-ip=74.125.224.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bmTonWrc"
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-64aedd812baso1943151d50.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773997809; x=1774602609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R/wxc0Gswh06ZRfuxBdasCd22zjoUhF/1JND9FuQWhk=;
        b=EdzOzfWCaapTmBM32ZqanhcX8nM5YLmuguDevvP97iQjzpQJOwiIo77sENK2976Rk4
         z9cHhD1UMaIcB9upWgtMPPv4JEVR7zF9tsLxI4FVVOCH9T3h1UYxv8QAawCrqok1AP4e
         nBgqLVf84ljz5iipsjbF6blrGOiIx//3uIMK5WC+anKcQmMBKDqVEljvcyQGd69qCKw7
         WqbcCi5RvpAAf2EN9OsdQgm6sSfJ06hnlF6cb4NQvSBSFcFLdas+e1Yv/mHFYWVZZC0w
         0drdRZCxgjMimGiZsOzjbUQDPscuPE9JMQO1dPeWCoxVQFoJZjKadINlw0A68ty+oMWp
         Bzng==
X-Gm-Message-State: AOJu0Yzd9wBbSsnCbZUh8C8uAQyNVF7RbCmxPRmIL4I/vpXQjqSXVRfm
	T1KxF2kAgbX9RffF78Dit+k0sSH5D0rM8au+f25FOyktlFx+wJa++MmF6xaDXyUCctIKroulRm5
	pfHdUtdPrpuvvnEJeX8vbxRqk0rFj4Dj4AoqGzfy64eWoFGKvmdodu7O/1azPREQ5ed8+VvpRuB
	NzL9XwiJJLp7wz/PvkFrF3vh+PGZczvJU2vve0NK1eTURI2C+IAuj/1Z0voe1k5IwjK/2sZM5fP
	4T+WpGwFIWMqkBY
X-Gm-Gg: ATEYQzyQ43cydOoqiSQOkaxbQCcpx6T8UrMdPz/cBUtzYNzfF7ExzjndWJhHNrB1Ql+
	ASWu+VJ+CRIwitXxaonKNgJfXuXB67BxLTOk9cg1feBlkoBCpahCvHv6/7Vip7hK6YlHlS/qEts
	kdPQiTebDI7EPuukGtmy78js8Wag5FcYCNwZzHEhxLzY4kcnfOoMFKG8tn7VIZ7SIcSItUbb9tn
	86Fdth2NVD/kklqaDKQ6y0urFEu0ELObuK9Cx8N1oCZ13RGBwyPTrWT1/95rerBZ2HtwMdywxcm
	MeRNwyODOehaeNlmMJtwWxX/fFe8uZR1I09VkGMNXMOqilQ1mz/h2PrOL/9scyti27qK1IcF2yn
	LQrzHZF+QovB6KgvNmxJ/njwPr2KX8VOniar7OatutiLcZzALhvyd0ozJwINawxdVhAAfWcgcQ0
	IbOIfTMc67gG6xoEkIkYnGGVkniYKkgshI7haz+0bQSWiPqFEX7jvPWTXkl3w=
X-Received: by 2002:a53:d049:0:20b0:64d:695d:6ae4 with SMTP id 956f58d0204a3-64eaa82aad0mr1944263d50.68.1773997808552;
        Fri, 20 Mar 2026 02:10:08 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-64eabbf8ba1sm170420d50.0.2026.03.20.02.10.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Mar 2026 02:10:08 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7962f1424d2so45285377b3.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1773997807; x=1774602607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R/wxc0Gswh06ZRfuxBdasCd22zjoUhF/1JND9FuQWhk=;
        b=bmTonWrcmE94JhK4Udi7RnDzB0mQ6hbFxy8g1/IW1KWh2bKGcE24MFS1WpNf2adehG
         R1ohKXdaBmb8ISqnmyqPjX9PKHyJ8T/40ppsFrgCBM8EZ0M2JYmh55WEyAedoNyLjEq9
         MJAKqiI6jbCCfd/f1Bl5SMAKw9Tt1FESax9vE=
X-Received: by 2002:a05:690c:450e:b0:79a:649e:2666 with SMTP id 00721157ae682-79a90aa032dmr22406697b3.10.1773997807556;
        Fri, 20 Mar 2026 02:10:07 -0700 (PDT)
X-Received: by 2002:a05:690c:450e:b0:79a:649e:2666 with SMTP id 00721157ae682-79a90aa032dmr22406387b3.10.1773997806975;
        Fri, 20 Mar 2026 02:10:06 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a9057b738sm11680357b3.36.2026.03.20.02.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 02:10:06 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/3] mpi3mr: Enhancements for mpi3mr
Date: Fri, 20 Mar 2026 14:33:23 +0530
Message-ID: <20260320090326.47544-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Enhancements for mpi3mr driver

Ranjan Kumar (3):
  mpi3mr: Reset controller on invalid I/O completion
  mpi3mr: Add queue-full tracking for operational request queues
  mpi3mr: Add retry mechanism for IOC shutdown with timeout reset

 drivers/scsi/mpi3mr/mpi3mr.h    | 16 ++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 55 +++++++++++++++++++++++++++++----
 drivers/scsi/mpi3mr/mpi3mr_os.c | 11 +++++--
 3 files changed, 74 insertions(+), 8 deletions(-)

-- 
2.47.3

