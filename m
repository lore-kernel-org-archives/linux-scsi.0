Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA46187353;
	Wed,  3 Jul 2024 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032308; cv=none; b=LLsL8thhjLu5LvaPxdj5tiGU+P4W11GuSfETD/wMlmL7bXaDbocWJJW9zMQYHVyJAc/JL+gP/vOei4v+tL0tHHSNpwKyKZbe4ywoI9+cg+tVmuuBjgcT+lvOaMc50jzuwYgzZm5v+UNjkZ4Kj9xav84Jy545Wb3NQndUGCAI3Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032308; c=relaxed/simple;
	bh=X7mlgOE0kf+ALAuEbjybN4/crwHxq36D50SYzF6JoYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+mw8ybQXcaGx0bI0O+P2GTC8s1y0G6gworubQwGBpJecPRsJYVge6i0sANJBCTMDL5YnblRYrpOZPBYd97FxkiMLv9ZGepntpo8besy+HEX7SR9yHZcnq3YF9lskudQ4Y5I5mrwQk1inM2pWAWxCwwkU9iM/wsf4eePjfbVF+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gK9C9Mys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gK9C9Mys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FED4C32781;
	Wed,  3 Jul 2024 18:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032308;
	bh=X7mlgOE0kf+ALAuEbjybN4/crwHxq36D50SYzF6JoYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK9C9MysN2jQZ+t/oTFlM7FmP69BVZe4OcYbFitVltbz1WMsITeakufLzs2UKXMz3
	 hdiD/8U3tCxPgpmXRoYx1d2GJACRXxJ5bPxamOHp3SJW6SZ0yoHdl2rpS65/hldNML
	 c2vSMSxNY9ztqrp/1xVpqqMaUzLzqC1L0vnAn8pwexf8EJSn6Q5Um5QNP0mVTNCdQp
	 ujJuGE56DJVsxWOLIHx5afW6F0DRvBHZhnpp9df2QcoG5tOdl/13HOvN8eqA9RtO3D
	 DVI4dGoLYDP6U8TjvHj+BPdISBaBaTproqDtYhMGQfvLgr5LoejN71iUeYRVYkf46Y
	 b/i3nru0RE54g==
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
Subject: [PATCH v4 7/9] ata: libata-core: Reuse available ata_port print_ids
Date: Wed,  3 Jul 2024 20:44:24 +0200
Message-ID: <20240703184418.723066-18-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2031; i=cassel@kernel.org; h=from:subject; bh=X7mlgOE0kf+ALAuEbjybN4/crwHxq36D50SYzF6JoYI=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa5/D+8Jn05USTZZ7dnXfJzaHXdZ4xqpRvWStflPp0y kK7ibszO0pZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjARxdUM/5S2L3J7nN9l+PKi k53Q9LYFXQUn+27UOH+Y6BZy7xLfRitGho6CbMvc7LVvvrLdqAgTCYw4wK2Tf9+0iD8jufx41Eo pZgA=
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

