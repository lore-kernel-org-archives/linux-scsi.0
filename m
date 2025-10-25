Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3473422689C;
	Sat, 25 Oct 2025 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408612; cv=none; b=LcHgsIxii5Nw/5GQzeXLWp9vANSftnySz7Pn41Q8lH8JTD1QmOWLQGuCZnaE/TSkbsEizOVFmmIomss345jv4/2xjQ+XXNYMaUrak2FVFDM9vn0pPJDCWSfsQDIttTB+GAhgARmnskRONZGSDvRsBh2/pj0jY04bU1ziMWRT/hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408612; c=relaxed/simple;
	bh=7ZSIncxnmdvYrR3duGvUeHsmQSqHuifvezjNdE7AbGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRhW+RBXyywje7QKg1y99aIPXhfJSnNjVBqAgX4d7KZpUyaV8NQnZ59bxaMj2oZwcL0jeASlKcK9Av2kypFOgjq5fXIiXBa8DWVIfqnXOZ9QSXezWsdYaaxkrGXsM5EzUKstSezMJmmNIVGYCP256zohqne87idjAReU7pZAO2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DV9givGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DV9givGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC255C4CEF5;
	Sat, 25 Oct 2025 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408611;
	bh=7ZSIncxnmdvYrR3duGvUeHsmQSqHuifvezjNdE7AbGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DV9givGsQ8lTHlHNGvUFKnUpJ23/JvGUPwJQFSgZWMXatDHeupasy+ehPyE8WIcdo
	 MMvVK24cUJ8xi5oZsGPkMKCYykN/clnk2yzLB8RYtZ3NWVR5PCoR+Oxk3fJeJYoeoC
	 j174m8QJ1iidxGpMdizBrFeVLpUwi4iU31lggtP1O7RiYW7UJOu3Uv5uHr7EE28wK/
	 TNxpxEGMfSjKPbGeIushU4qwkmroISzkwsPus30ZX3YDT0QGTA28f+SINtzM+Pd4bN
	 YafmCqDog2CYJB+bvo9/PjTaLVAZLa6nKK5QIEVt9zoeKz1u3oYw97wE6zB0qGKmCo
	 wFLuzynOpHT2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.ely@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] scsi: lpfc: Define size of debugfs entry for xri rebalancing
Date: Sat, 25 Oct 2025 11:54:14 -0400
Message-ID: <20251025160905.3857885-23-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 5de09770b1c0e229d2cec93e7f634fcdc87c9bc8 ]

To assist in debugging lpfc_xri_rebalancing driver parameter, a debugfs
entry is used.  The debugfs file operations for xri rebalancing have
been previously implemented, but lack definition for its information
buffer size.  Similar to other pre-existing debugfs entry buffers,
define LPFC_HDWQINFO_SIZE as 8192 bytes.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-9-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this one-liner unblocks an existing debugfs feature and is safe to
carry into stable.

- `drivers/scsi/lpfc/lpfc_debugfs.c:607` and
  `drivers/scsi/lpfc/lpfc_debugfs.c:2134` consume `LPFC_HDWQINFO_SIZE`
  to cap output and size the kmalloc buffer when the optional
  `LPFC_HDWQ_LOCK_STAT` instrumentation is enabled; without a definition
  the driver fails to build as soon as that knob is turned on.
- The new define in `drivers/scsi/lpfc/lpfc_debugfs.h:47` mirrors the
  other debugfs buffer constants, restoring buildability for the
  lockstat/xri-rebalancing debugfs file that has existed since commit
  6a828b0f6192 but was unusable.
- Scope is tight (single macro), runtime behavior is unchanged, and the
  only effect is eliminating a straightforward compile-time break, so
  regression risk is effectively nil.

Suggested follow-up: rebuild the lpfc driver with
`-DLPFC_HDWQ_LOCK_STAT` (and `CONFIG_SCSI_LPFC_DEBUG_FS`) to confirm the
debugfs entry now compiles and opens as expected.

 drivers/scsi/lpfc/lpfc_debugfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index f319f3af04009..566dd84e0677a 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -44,6 +44,9 @@
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
+/* hdwqinfo output buffer size */
+#define LPFC_HDWQINFO_SIZE 8192
+
 /* nvmestat output buffer size */
 #define LPFC_NVMESTAT_SIZE 8192
 #define LPFC_IOKTIME_SIZE 8192
-- 
2.51.0

