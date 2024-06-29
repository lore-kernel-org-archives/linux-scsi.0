Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138502574B;
	Sat, 29 Jun 2024 12:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719664950; cv=none; b=ITpX5qINOFUdZ3vk29dpEPqEdOqE/Cgj7Z/1c0LUfACRzVwnT1PPc9zoEYwyEV+d2OiB6GyWGZMLmguu2vnDBBad48ET4lyehNb9ogtP71Yeb7P/7SZ6vLfAtWJ4WwiB91XeOQkmEdw4vwqxO4qn6ph8AcPEERU7zT1mrUm3i6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719664950; c=relaxed/simple;
	bh=iO7tyo6AWk5mKZyZe91ucFAmhDDPDxjeokxhfR8Lf0A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iwFcb9ROtLFJy6z3wmzfn9mRVD+NqzqFBgwIYNKOuBM+OeZzO0hqfXa9HU9g/t+yV5HA91Jm6OsRBwab+wc8mSbvuPeesFGPI+OVpKGQ76r7D6bFP5u/pRA+uxlBPGRyavtOZ+dTqr9aTT8pRJIPQNKlKraEA8o5W782SxcSKt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IwMWcRxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IwMWcRxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFF5C2BBFC;
	Sat, 29 Jun 2024 12:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719664949;
	bh=iO7tyo6AWk5mKZyZe91ucFAmhDDPDxjeokxhfR8Lf0A=;
	h=From:To:Cc:Subject:Date:From;
	b=IwMWcRxBsP3wSN2HEc43xgfpYSq5HMSf+GNCXgxoKltaYLV+9AERJdvyu6tufVLY2
	 HybIEsCGmWZi4XXlnJD3sHXBZ28br98LYp2W17T3XCwAZyCsgTU4wi2MS+O7MmWc+X
	 RgaW8YoHSxWedZ4kTtQ5OKn9SKmdIG9BRwttDVqjI7nHHzGqK5l2z2c2z28GpV9ymx
	 nkyKkgEF1WqfeT/f+1ivnZzXaWb03ePIHu/ZtfvqrKRL/pyqacSGFFavFLcKbfJXWH
	 4KlCPu1l4wLCeCzG7J3sTSn10PdJRzDOMpHFU18z6oucNY7uJWqqzQY2Jl3kb9UxZ7
	 dgiTDAE/PBzPw==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jeff Garzik <jeff@garzik.org>,
	Tejun Heo <htejun@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Colin Ian King <colin.i.king@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: linux-scsi@vger.kernel.org,
	Niklas Cassel <niklas.cassel@wdc.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH 0/4] libata/libsas cleanup fixes
Date: Sat, 29 Jun 2024 14:42:10 +0200
Message-ID: <20240629124210.181537-6-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=903; i=cassel@kernel.org; h=from:subject; bh=iO7tyo6AWk5mKZyZe91ucFAmhDDPDxjeokxhfR8Lf0A=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNIaGJXKuyu49b9LnVu2MVs9xOflpFBOifkTlmR/fm2oE JXatOpHRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACYS9ZbhD+c3iQUzWn6ZZj36 8yHisrdcpYOz/LyYH3MzdsW3zXCbEs/wVzxp41Epa+MLXz5+e7Pzf81ubpEZd6I9tfrS2VhXqfT N5QAA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Hello there,

This series takes the patches that are -stable material from this series:
https://lore.kernel.org/linux-ide/20240626180031.4050226-15-cassel@kernel.org/

Changes since series above:
-Fixed minor review comments for the four patches included in the series.
-Picked up tags.


Kind regards,
Niklas


Niklas Cassel (4):
  ata: libata-core: Fix null pointer dereference on error
  ata,scsi: libata-core: Do not leak memory for ata_port struct members
  ata: libata-core: Fix double free on error
  ata: ahci: Clean up sysfs file on error

 drivers/ata/ahci.c                 | 17 ++++++++++++-----
 drivers/ata/libata-core.c          | 29 ++++++++++++++++++-----------
 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             |  1 +
 5 files changed, 33 insertions(+), 18 deletions(-)

-- 
2.45.2

