Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D291BD02A;
	Tue,  2 Jul 2024 16:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936539; cv=none; b=gtgBxXUGnApyieNImBJW2cFCa/Op52qwP8bl3gB0eR374cOo3zZUvjt7sm3/JDqgkAZJyjRzATXJjMF5ekPUJlNvvuX6KnifhUmLLcQw/sIfH+iVBAX+L4wVQcz0tT5Zvfspw7IuWFtT5FJAJcSi4TY/ClCv4tT8YpfgYrVdto0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936539; c=relaxed/simple;
	bh=X7mlgOE0kf+ALAuEbjybN4/crwHxq36D50SYzF6JoYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNt89GicyTxSe299gzkV3RRNk/JHc1wQiGYoNtAfZO8VTtvUvsqV/BUtD0JsBhY8W5TRH9wSm/LczwNjZFyKa8iFGthF8FJ5NHM6JIhFvIyzUjk7cXIXjkTkTYZ6FOhbeSn4pKo77VBcrh8W52aBiPoaor0zEBH/GP6w5iiRCCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDgB+vPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDgB+vPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEEDC4AF0A;
	Tue,  2 Jul 2024 16:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936539;
	bh=X7mlgOE0kf+ALAuEbjybN4/crwHxq36D50SYzF6JoYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDgB+vPrG+WMu3vGV9e9Dy2/kDdteIW/xUfcCYVAoAFKzMXbRH/pxHsT/ebrBFX0R
	 khJTfXu3Elt07k7dfrnoXnjjZcSIvhaaAN0yfcMJrlsmA977AYIa2xdOQJHY4NgKnJ
	 EdxnmJFIkAoLEHYr9erxa2JB/6/ePLfbw2Ol4XdbEtsn/T1UxQMbUq7llIlmj93U+Y
	 jsfDGSLHvq+lEWfSuqXP3o8xKnhP6+Hn3uMsFh8ECuC2WBeiRzKTepdeBdDgwHRvS0
	 GajyvdThtoZKmehoLXpx/zwyAn/jntXJClOECX9pvs73wZShABa0DkdfGvSmmpWZRs
	 UGwWlJluEtj6Q==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH v3 7/9] ata: libata-core: Reuse available ata_port print_ids
Date: Tue,  2 Jul 2024 18:08:03 +0200
Message-ID: <20240702160756.596955-18-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2031; i=cassel@kernel.org; h=from:subject; bh=X7mlgOE0kf+ALAuEbjybN4/crwHxq36D50SYzF6JoYI=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVJ/+8Jn05USTZZ7dnXfJzaHXdZ4xqpRvWStflPp0y kK7ibszO0pZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCRRhOG/y4namb+Zr5sxnxC nYdh0TmDOVNKpbZ/bV4zPSgsSu6FvhDDP/U8QQffUpW7QsYHPnzfyTL9bRJbZ4BOgOk3V4t7gg1 xzAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Currently, the ata_port print_ids are increased indefinitely, even when
there are lower ids available.

E.g. on first boot you will have ata1-ata6 assigned.
After a rmmod + modprobe, you will instead have ata7-ata12 assigned.

Move to use the ida_alloc() API, such that print_ids will get reused.
This means that even after a rmmod + modprobe, the ports will be assigned
print_ids ata1-ata6.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f02c023ba89e..5031064834be 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -86,7 +86,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
-atomic_t ata_print_id = ATOMIC_INIT(0);
+static DEFINE_IDA(ata_ida);
 
 #ifdef CONFIG_ATA_FORCE
 struct ata_force_param {
@@ -5455,6 +5455,7 @@ int sata_link_init_spd(struct ata_link *link)
 struct ata_port *ata_port_alloc(struct ata_host *host)
 {
 	struct ata_port *ap;
+	int id;
 
 	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
 	if (!ap)
@@ -5462,7 +5463,12 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
-	ap->print_id = atomic_inc_return(&ata_print_id);
+	id = ida_alloc_min(&ata_ida, 1, GFP_KERNEL);
+	if (id < 0) {
+		kfree(ap);
+		return NULL;
+	}
+	ap->print_id = id;
 	ap->host = host;
 	ap->dev = host->dev;
 
@@ -5496,6 +5502,7 @@ void ata_port_free(struct ata_port *ap)
 	kfree(ap->pmp_link);
 	kfree(ap->slave_link);
 	kfree(ap->ncq_sense_buf);
+	ida_free(&ata_ida, ap->print_id);
 	kfree(ap);
 }
 EXPORT_SYMBOL_GPL(ata_port_free);
-- 
2.45.2

