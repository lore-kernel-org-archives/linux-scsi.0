Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EEC19EED3
	for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2026 01:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787362907; cv=none; b=HIJbuDNzlFNKG/ChhM+fSkQLKeo0SLjhiEuPFWf55NFLbyNhnHyac0S6zVZkfizHY+TxVoBS7Tg/6NtueNmUWF0zLC5bBf6wCxkCiWIFpH/0IJXEc3ngOR0uJ6FptXMnHxm4hsHk//XpeV61Rlb4uCzMcph3+NMRLcTXCqbbrVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787362907; c=relaxed/simple;
	bh=jwBb2U5ce/QG3MQlKM1E97ImoHcSecrc/PvKpJmQQeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqoT/mVhd+4jlaB0RaB/nrs0iW5l4N77gnn8PkMdqbcR5yA4z9ErCrxz9nWkNUZCQA+QO4Y39KTXDJllVIgbh2zbOLHPaDqfYhqJ/4IIo7Bg1HFD/kKI03XEJWy7whRyPh73yHkugn/lHMY9R1ulNiFtqPuNuyQEW3ri5IGi3NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=r0s1o1mo; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="r0s1o1mo"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d032846c95so19775595ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 18:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787362905; x=1787967705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yIluKsZBjZcY13lASdrl14w+d+PVhJcBD6mA5v3rGwo=;
        b=r0s1o1moQq1M2eqasA4TzNmoDws7yoaGn+KizX003gdwRe03NfdB9fkTu5oy53ySD4
         1e78aq7jjNgMUio7VABnB7AZ8AQLK0J+3aB/vVGha59roXAXJ+eXhe83lQekrqjXoSQJ
         QWo4DUUUTXET7bdDW0FNtpyu/O+pdif+YXEO0A+qjJPyrwGMLpvfDgJk23bBjalHEFYB
         /R54fD08KYuv+O9y4mCGQz5BsbEI6WJxRRfELM/UrWbgDFXeKQK8bKA2Z6k2zOmxvrr0
         N+AeEz5CX4kJgypYLiwt4lX5FVfUmI0br9CrlzVqn9YB8KzyTbfXTjzrgoeTEVz1uV3m
         GAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787362905; x=1787967705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yIluKsZBjZcY13lASdrl14w+d+PVhJcBD6mA5v3rGwo=;
        b=Of4zlgkVc0p8qw2ckMLY19ZCnLXjWftaI1ZOlhyFitJw0B1ObDLTdEH8nSGws1Vp8k
         B/cX3gFD3uhB3z75Ue0V1psL7+OGYvtdYwrHoXB0mfLboY1em2VND4MEXkq+fHWOU8gN
         /XJYvR2orOlZKbIKZw7UsWjIaq5nNEaPXFug1dICP9GkaRcMV9U7Bxvxl33CesocY5YE
         bb2J8p9SsRKhqZE/aG83ImSn2Q7rXhbxCNAzFXuZ7zMGysPRU5M/3KYHFuhkHy9RD0O9
         KCEQo+W7mBwabBjh3//TGzBm5GnYYYqsEmSilRU7Uwq7aiEDQmysMMVRA86njRlWCdWV
         KwMA==
X-Forwarded-Encrypted: i=1; AHgh+RoQrNIWR7WQ3IyETtjRMWCFXLfsKvAon+9hNOb/da9ElWunagT7Kg+OGpqVhMYdiYt7sx8/Yd7rPj4C@vger.kernel.org
X-Gm-Message-State: AFuF++n2cRyS3fhzsLf2FakkPp4X2VdzGpMAz+vh0BwrEsDuIms8pdY+
	lFK9bzU3KX2DPHW0gdxu3he+ZPPRYMgNsNZ/eF9XjSNvnX+aqbhKLs+DQTRQg/kBCeE=
X-Gm-Gg: AR+sD13diMRqGXOB88uBN1OGit9KSvqFeqiYt8IZFrrSC14Ll4SyzUGtKgQpOwXdaOP
	+fO+OD7LZrJH1M3BZiUd57P7Slgdb5zXk4MWfS6QmdKPvBdBOii/eb9WmXpqqOI5OZ6KIC/iih7
	OIVDHDurqUcJoDcq0rU0T3l+i9sh+2QqGTJ6OxbeA5SuijToxefor01h6Ggd8MRjQ1FtJ3Jqj9S
	bPQ2OZ92mdG00qPUvt3l4jukzDgJVTdI8v61Iz7zzn/4Cu5ztLLizvV4EKHh/LOhcm+uwqr5CWG
	6m09aY6OoN+f+Y6xw4q/svXjAZX64SsqTa20hX8cfe6eNSWTP2xWP4qfmjP2tO9zy8DvH8ci2tc
	yqNQC5JuVsRNApyvM4H4+lwsW+FhJVk8Rw01lvuI632v1tfVtBLmLVRu89WlZpKuufZqKPuRx0m
	w+qocXC961Eq5wrxdfnWjjINFgV0+b0TW3JFnOdfD1In5vWuCMdh4POL1sacXXyXe/v2i881XMD
	c1biOn9ELcGp9HFAmzaeUU=
X-Received: by 2002:a17:90b:4a81:b0:381:a766:efcb with SMTP id 98e67ed59e1d1-395c34fed98mr16958781a91.4.1787362905049;
        Fri, 21 Aug 2026 18:41:45 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:a627:8da3:af81:18cc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4b2b97fsm913919a91.16.2026.08.21.18.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 18:41:44 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: lduncan@suse.com,
	cleech@redhat.com,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] scsi: libiscsi: validate task lookups driven by target-supplied ITTs
Date: Sat, 22 Aug 2026 10:41:33 +0900
Message-ID: <20260822014133.1978961-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mike, same request for this series - no comments in eighteen days, and
the only replies were from the review bot, which I answered in this
thread.  After the merge window is fine.

All three are measured against a proxy that injects one PDU.  1/3 is
argued from source only, as I have no be2iscsi hardware.

Best regards,

Yehyeong Lee
