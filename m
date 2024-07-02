Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383D148825;
	Tue,  2 Jul 2024 16:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936531; cv=none; b=BjCffcgIkrmOypaaVkvRaucpR5q0bhnA/ZvMbR+k//4JQB+FoqsD+7+JOEeN4me8p4L8iQcQfrttBJfOmf4poNT5ja6GnTOhuARJcrcALD9T42tKngBC8clAqfz/dFiYfaLMQjLG8PUjQL3cGt6TIX5aDKzToQ/KvrO+BGj/oMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936531; c=relaxed/simple;
	bh=pJFjRC4pdUovu49pfV86X1dvnSXZmQTs5FtES/N36iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoEiI7yfgX8cwgTwvIncbfBUukhSMsZF5zc8VE7gzt+u2LXDHIvdvr2OJFeoWoyBiraliogquUq+dq1+lg+YzuwOCsOw0DeOBiheHoXAoTsGHpxft88WOxkuAWTPMJfVKo2N7vIUpw+IzdpzuhTL/KTwj2ZTpG1gXLY9EW1P8M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tn3uBd58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tn3uBd58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F72C116B1;
	Tue,  2 Jul 2024 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936530;
	bh=pJFjRC4pdUovu49pfV86X1dvnSXZmQTs5FtES/N36iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tn3uBd58ADWVPqADxtNUfR1AHhqTJdLJseOdsozQxZSkg+Gow4fp2ax3QJXFfS4to
	 NXTsDKD0y0L3QFcy1xO29v7bSqbMJMvUGRwL/cvbUYOKJpED8POagKptjKK8Onxhuh
	 mI7RAHT0JFNOJriToxfKd/TSv0s2PbLXZSxf+R3Db1oJU6Ts/9IKihnF0kMQXoTtsz
	 bd8lmHsZJcj4/M55NvCN46FpSETFSQuL/cBGVVtfCrNgKtvlUH8+vTQ3Fyb7tc7Cqr
	 T2/aSV3dnMvUUotrQeVvAEv5ETsBxOSS3vhe80EZWaV2nJI/jyuvu14W7Shy+lEecT
	 SzPbjiAaplBhw==
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
Subject: [PATCH v3 4/9] ata: libata-sata: Remove superfluous assignment in ata_sas_port_alloc()
Date: Tue,  2 Jul 2024 18:08:00 +0200
Message-ID: <20240702160756.596955-15-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=822; i=cassel@kernel.org; h=from:subject; bh=pJFjRC4pdUovu49pfV86X1dvnSXZmQTs5FtES/N36iQ=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVJ9wF9luvqZuwtOyNWcui829BO7Z67Zk9PyYxTalO YXnJdfCjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAExkrTMjw5X5nJsrvUvLHU6E JUV/OONz5P25gz4f+mYdWBmrHlNnXMHwv+Cz9iZJe5VDLdPY7k4I8rpZqK7L1RLxZ1HqK4df21m /cQEA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ata_sas_port_alloc() calls ata_port_alloc() which already assigns ap->lock
so there is no need for ata_sas_port_alloc() to assign it again.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-sata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index e7991595bfe5..1a36a5d1d7bc 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1228,7 +1228,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 		return NULL;
 
 	ap->port_no = 0;
-	ap->lock = &host->lock;
 	ap->pio_mask = port_info->pio_mask;
 	ap->mwdma_mask = port_info->mwdma_mask;
 	ap->udma_mask = port_info->udma_mask;
-- 
2.45.2

