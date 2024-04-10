Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F22A944E
	for <linux-scsi@vger.kernel.org>; Wed, 10 Apr 2024 02:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712716321; cv=none; b=kEdsl7NZanG+R+Js9o1EY2iECB86wL22dkmFYl1Z0lzwCqrm3Diwn/VRIbOtOLrh2lddBLJy7mlfSA/Vjx6Eijaj4knXe4avMqTsH1c0jYfD9uw6E8i6Ot4Rw6weVR1m0IgrUOIcbI99O2TESciOFecwSSpj5Ar/+/zAxCFDYs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712716321; c=relaxed/simple;
	bh=KszawLlCfqBX5u3rVG0NvzmvK/754HFncGX7jVg0qxY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TnqSbsn7Ib1SMRyuzTo6Nw925OGmrME6/IjxdwUZI9X5jWdBirgYbRbeuZ9Ij6bgMJbJ7TvSp+UqqaQ9/k32lBhV5XRlegk26M/ngFwdwVDS1XO5/xZJAilKFK7BylHn+L1G6VW9SfMCpmnzIcJaFfehnTtnbZ3kfUjBgkGdjHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=H7CD6fRB; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="H7CD6fRB"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e3e84a302eso23868385ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Apr 2024 19:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712716318; x=1713321118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7sJB/mea+ne4UFf8C44UTKqaf9B7A57oFQubr1xCfoI=;
        b=H7CD6fRBN5qrbJARl/fzdCmRnD3qqryKyynhwWbYSIxuVcnNMcgu2LivLl1N38rfVk
         NJ6jVxygQ8pdSmMwk71ejOKTyBbFlIodb1fPNNHLSenGTReTqGzvM1n70V8LHZu7WBJF
         W6HEEhhaFhKHNBjQZd8419vUqgIbmQC10u5Pc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712716318; x=1713321118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7sJB/mea+ne4UFf8C44UTKqaf9B7A57oFQubr1xCfoI=;
        b=VQaD1CQsHDhas6Bw5YAzzWZXJOHYmqZuJXOfvepx2w+dbqzZC2hV6b55GYd7kO2ZD4
         QdOUm182uaT5OnNOTD8iVpbRDtxpiHl0M23l2OMnJXyOkEq7LgpmkfW/JQzNk1/lLZPW
         aiTlxRhb7/+3oET1RYWmg/Lycb/PYqkx/wTCiBs1PnklV2vTx+GXgzlrNZIY9068Op2e
         gdNlzeQOf+j1rU4MV+U7WhEVzShCvK2Bjl39vm8hPowvV9o0f7CjOeEz/88DSt1rjlQf
         bg/10FrgrOm/PMI0Z4Wu4VaWdx3UV1ezlECgxq0Ys8vjr/YoLS9g/Vh/402Io/Tu+8V4
         MXXA==
X-Forwarded-Encrypted: i=1; AJvYcCUkoNzYTcPTkH3Hg/FPCniwGsna+ngpGk2hQ7aC0p1mm4LqeY5Fgcy+3O4v2X9Wk8R6zTt+TEg0IfXtnxELecQn3EyLAQSz8gUTUg==
X-Gm-Message-State: AOJu0Yyx5XndzJeLp3G5wP/F3nxVT4i1JBYf1TNXGKP6kbNamwPDYPqi
	biIAFkrb8hOeZZ4d5I+iCxRFFl02JP8uzilhj1QxqFN2DefY+C6+gmEQSZ8Wow==
X-Google-Smtp-Source: AGHT+IHClp98RNXSKgnfnzn46Mc2LDj/wf+Cyy5uZfzjLtUAplxwmqUCk9V8CgCGYNbpysszUmj2iw==
X-Received: by 2002:a17:902:7008:b0:1e4:3ad5:b6d6 with SMTP id y8-20020a170902700800b001e43ad5b6d6mr1512978plk.37.1712716318594;
        Tue, 09 Apr 2024 19:31:58 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902d50700b001e3ee552999sm6406385plg.291.2024.04.09.19.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 19:31:58 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <keescook@chromium.org>,
	Charles Bertsch <cbertsch@cox.net>,
	Justin Stitt <justinstitt@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Andy Shevchenko <andy@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 0/5] scsi: Avoid possible run-time warning with long manufacturer strings
Date: Tue,  9 Apr 2024 19:31:49 -0700
Message-Id: <20240410021833.work.750-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1911; i=keescook@chromium.org;
 h=from:subject:message-id; bh=KszawLlCfqBX5u3rVG0NvzmvK/754HFncGX7jVg0qxY=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmFfoZGm+w5zIvLCsYnaFCm1zKDHNOj0+xiwYgY
 QCyzpvIZWGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZhX6GQAKCRCJcvTf3G3A
 Jo6wD/0QQk0StqwBxMN5hxnRxuq1LlsSW6z1VwPSQbvxTQhHewhbKVcSmede+va3JiKcOFnm8db
 Z5tyz10tEr4E1gWXWMfMZvp3HtZQNej83u3OZdrdgfrHNr06E5twCcfmS/LEFwwqdsVSr1AsN6k
 8soxXZSYHKsCEyiYQGYGBIv/yTn91kepLo3oP6UE2sF0YF9th4p+yYovtTDtcVI06xFTPTimcOA
 b4yivDJtG0MuKjJPtWCEeUSHRv7I55eY7Um9YoRMh6AwkgE6Sq4FuogJQjcQ0/cADCB9UiFMUmL
 5aQR30QXfusAOfgG4b8M/PJtfFHv0zf8gd8gYYiSxiR5DQ8eNKp4h4CdLEcHDYkpMOsW4J/mygX
 7jEPX/+3EiWE72P4eYnfnzhw5Gb28anIEI4gCcVOIGQT25H2FgFN/7srJ440W9vmlGOm/alkpBP
 zMo4aorHp0hSy85xDtvmFbFM8tKG4tj5hOh5U4VPLVUlwzk8OH6sGJ0waSHdNIsQBScGBRk3kXG
 MP+jzndBxOoaWnXkHrK1b3/wIPPlcYG5BkXxqALuRo63UucckCttvJcNPF75urxyQ/1nfgGfwNU
 JJqca5Pli5JfQqGyfV+y32MEwpMfCj6JqHDwe4WUQDJfpZnS91bEvOepX7jB03lPrx+7ZrJ7Z7I
 Dp8Y9D/ WtLzpPwA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Hi,

Another code pattern using the gloriously ambiguous strncpy() function was
turning maybe not-NUL-terminated character arrays into NUL-terminated
strings. In these cases, when strncpy() is replaced with strscpy()
it creates a situation where if the non-terminated string takes up the
entire character array (i.e. it is not terminated) run-time warnings
from CONFIG_FORTIFY_SOURCE will trip, since strscpy() was expecting to
find a NUL-terminated source but checking for the NUL would walk off
the end of the source buffer.

In doing an instrumented build of the kernel to find these cases, it
seems it was almost entirely a code pattern used in the SCSI subsystem,
so the creation of the new helper, memtostr(), can land via the SCSI
tree. And, as it turns out, inappropriate conversions have been happening
for several years now, some of which even moved through strlcpy() first
(and were never noticed either).

This series fixes all 4 of the instances I could find in the SCSI
subsystem.

Thanks,

-Kees

Kees Cook (5):
  string.h: Introduce memtostr() and memtostr_pad()
  scsi: mptfusion: Avoid possible run-time warning with long
    manufacturer strings
  scsi: mpt3sas: Avoid possible run-time warning with long manufacturer
    strings
  scsi: mpi3mr: Avoid possible run-time warning with long manufacturer
    strings
  scsi: qla2xxx: Avoid possible run-time warning with long model_num

 drivers/message/fusion/mptsas.c          | 14 +++----
 drivers/scsi/mpi3mr/mpi3mr_transport.c   | 14 +++----
 drivers/scsi/mpt3sas/mpt3sas_base.c      |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 14 +++----
 drivers/scsi/qla2xxx/qla_mr.c            |  6 +--
 include/linux/string.h                   | 49 ++++++++++++++++++++++++
 lib/strscpy_kunit.c                      | 26 +++++++++++++
 7 files changed, 93 insertions(+), 32 deletions(-)

-- 
2.34.1

