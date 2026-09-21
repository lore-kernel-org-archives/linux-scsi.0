Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBB24AB3A7
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005271; cv=none; b=mmoBM2/n3PtYwtlrgw1gF4jtFV0bCwSsTHaT4/K2O5jkZVV34WODuJdraUJ5mY6YADB8ZGQ7e8FmqgPON6dh32GivWpKad8zV/UsBf1/qjnSn5RZ5innylrYU0yuLLhcSepdWrMooo8pIlvDYE8M5txm1gmWjK2WvLdSlUJNogg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005271; c=relaxed/simple;
	bh=w3YmdYK5HMa/aA549ExPDdA8WIz9Z5u7w5xrnyLRXPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MseQHDzwc/0QBmDy0dS4QmdaVt23YgxlMdtVyXykMeRWdPF5wk+1mSDkNfTbfuOboUkLgYZlyF8qXqWOXDB79c41bFQy/tMg8auuKu+TBhbd2yA6ACbGJItd1LkhKRWuzOOvLp5W+SF2eBXMN+dL+TGJG/oqM9aw3e+WNgXtX1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CwABeNpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CwABeNpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D391F00893;
	Mon, 21 Sep 2026 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005270;
	bh=+2fezWUp0Amt70NpcysTUCWEHtiOgJT2Nc9/a/P8lTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwABeNpVAeAYoiACmW5PH4G5DXH+3WGbLojBVCpNnM0CC9gjXMXS4o/Wya9PBqMYM
	 i8plGPc+wupCnNazJdfhcnLiZc66Q1uWErYWUYlSbOg088fpWHesEUG+ZR1m9JdUBo
	 IDpD+kLHql42nGxvT2pN7j4CGUHK+AqjwMv3S7TP5IoQ40a7x2+ADJSyZz31MC9Np2
	 uAwQZI6rUdrMQNA3CuEY5zYzFwLM42UDtIEWK790qQB26tUAjdfoD9lZcwVAOKSbrA
	 nE3UhOA4HI1te8JkEQ0VRe449bS2uTz5yfy5au/Rd8rrzSkglncJ/muX951rNwyrs6
	 tbsEJ4fhnlBHQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v5 02/10] scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclusive
Date: Mon, 21 Sep 2026 17:40:18 +0200
Message-ID: <20260921154015.2971990-14-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154015.2971990-12-cassel@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1971; i=cassel@kernel.org; h=from:subject; bh=w3YmdYK5HMa/aA549ExPDdA8WIz9Z5u7w5xrnyLRXPo=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLI2+j9zEYuYesh/L/ekz02NqxoKXGfke4m/c9LtN34x1 3vOp7nGHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjINROG/6kPdTZHxKW2PFr8 zGD9o5Rdna5X86w2bvL7lF2T6N1o+Yrhv2Pyzz1ZM8J8w++ZBWvEKM5iu7fw6ZvHKRr9ORNP7jv nzg8A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

There are no SMR drives that support atomic writes. Emulating a device
that supports both is emulating something that a user cannot encounter,
rather than the drives that exist, and it means maintaining the zone
handling of a command that no zoned device implements.

Nothing in the standards forbids the combination. For what would be by
far the most common case, a host managed SMR drive whose logical block
size equals its physical block size, there is no problem in the two
features being combined: the drive vendor only has to give atomic
writes an alignment that makes sense with regards to ZBC, for instance
equal to the physical block size. This is therefore a choice not to
complicate scsi_debug, rather than a restriction that the standards
impose.

Refuse the combination at initialisation. If SMR drives that support
atomic writes ever become a thing, this can be changed back.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested by loading the module with each combination:

  zbc=managed atomic_wr=1    refused, -EINVAL
  zbc=aware   atomic_wr=1    refused, -EINVAL
  zbc=managed                loads
  atomic_wr=1                loads
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c664966e95cb..8e45a57ae406 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8739,6 +8739,11 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (sdeb_zbc_in_use && sdebug_atomic_wr) {
+		pr_err("atomic_wr is not supported by a zoned device\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
 		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 	if (sdebug_dev_size_mb < 1)
-- 
2.55.0

