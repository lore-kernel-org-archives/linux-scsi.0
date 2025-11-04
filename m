Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787C127E04C
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 10:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250671; cv=none; b=MpaAtnx4z1Xkz+ljHyRzRD/E14czPMrFIl0H0CX2Dvp41ruSS8pPy4wO0P+KFiN5HkfUd3WZBJR6cFdEKxpHRFupwc5dU9jTOIwjd/XICSvYeszEnBnX3iEAq5wRUAV2M96lElCwCiI3Vfo2wez8iQNeOd+TacZrRwLWbknVDiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250671; c=relaxed/simple;
	bh=8Y/7N33UNSC5IJiLF9cQAB9cc9V7xwtmT9J0GSknaEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jg0SW9fFOtamZJspBmvJ8gBxNWkGqQitj6+xXfpslk290bPM/rwtWnysxDRP0+jNhbFbYXF6PiKk2Z7xlQ4+fvZ8XGpUADUp3vExa4XFCIuTbrpfnYBXza9x4/EtNY1Ij4cuLQm+kpjCBX4sODKMJ6A5wWpo4R65Yxr/Qq90gXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7dUpwnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7dUpwnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50254C4CEF7;
	Tue,  4 Nov 2025 10:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762250671;
	bh=8Y/7N33UNSC5IJiLF9cQAB9cc9V7xwtmT9J0GSknaEQ=;
	h=From:To:Cc:Subject:Date:From;
	b=G7dUpwnHaOdLKNOlq9JOs+ZpcNJ3XKMznKikC7lPiiUL/iN9WSP8hj1sZpKWcGdF0
	 Dns9s4QA9N9DOwnTjTBZ3B0rAUlxWWWlEj3SzvF9AVpRnJR2IopAm0wams95Z4AJyZ
	 lB1Krb5J+GAAYk5gxBAZCLqRDVQBtmxebYglddZMrIiS1OWOTyncb69d02uW6y4PAo
	 CsRDVcI5gVKFlU7CVbTUEJh7lAoiKMfmEOP/50M+vpBdZPaIp9YKynvN9Iww8URyny
	 Fvb6ddevXk1GhWop5KgvRS5pFsnejvdYOjrM084uhxvnLUCUG/lDVLW6egeidjNSH+
	 m3u0JVqxCxKHQ==
From: Hannes Reinecke <hare@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 0/4] fnic: fixup INTx and MSI interrupt modes
Date: Tue,  4 Nov 2025 11:04:20 +0100
Message-ID: <20251104100424.8215-1-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

with the rework to enable multiqueue the non-multiqueue interrupt modes
(ie MSI and INTx) got broken and resulted in a non-functional drivers.
This patchset fixes up the driver to work in all interrupt modes and
adds a new module parameter 'fnic_intr_mode' to switch between them.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  fnic: use resulting interrupt mode during configuration
  fnic: correctly initialize 'fnic->name'
  fnic: missing initialisation for wq_copy_base
  fnic: make interrupt mode configurable

 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_isr.c  | 15 +++++++++++----
 drivers/scsi/fnic/fnic_main.c | 17 ++++++++++++-----
 3 files changed, 24 insertions(+), 10 deletions(-)

-- 
2.43.0

