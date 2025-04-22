Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CDC275115;
	Tue, 22 Apr 2025 02:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288339; cv=none; b=rOdMl//chy4zTRsgP3qWdJ05Wo3JTx7wnQ+9/EEc715kixx5ULioZsOvMhHiG0R7MQzl/0LdSXX3Nxeokd3xGrnUmb7mDZHwk7nHE8zTW+FDTOte/qb1ScXAnrrxfuEf39jH9ile6QphyPEQtNrFPbOwSHpgKGKvEbgJuAmY6mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288339; c=relaxed/simple;
	bh=ahtqeS/2t7eqBWl0IKJPdd7lzp15THQoq1seVWxWeFs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tAZoXPfqYm13mx2gOt84z2wkS9Dz2PH1RWQKtorqgACUocAKbv29+uvVF14mTkOYTmk2rD57kfeZpPHkngYN05KMOLDg3OBQR/+CwmZ6SeJ0rdB75dG2lh/hG49WH6mfqqQzU/v17hvCRM+Y3MybLwvImGFtHY6wZya7NVfiVVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAJpMlJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAJpMlJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E45EC4CEE4;
	Tue, 22 Apr 2025 02:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288339;
	bh=ahtqeS/2t7eqBWl0IKJPdd7lzp15THQoq1seVWxWeFs=;
	h=From:To:Cc:Subject:Date:From;
	b=TAJpMlJp815riH17NpJw5UdPhQaY/Fnou1gW8RSmVgQ8KuECYSmey5g5lgFR2idRQ
	 i8HrQrKqYjTZBWAFKxuCb4s2X/APs417W9TaQ5hO0owcTzK57kON0sVqFzea2jAi/v
	 DMFEBGnc7Da3cbAU8oh8h/QY82SRdSiqd5uu0nvB6nT7Sm/PKf19sHFMdoAU8y7z0q
	 2jk9nMH125+sS6CfAao8AVbYxqay8y7Ns3Bi/ebx4YnSWthLsdAbCogEx9QCGriG/2
	 2QqX7USgrRf8C3zqvB0CnqMNhZU4B5C92nVS60Gv3ps6Uk5On5NfCPwwr33vFM8l4R
	 soCLiPQEzl8rw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jinpu.wang@cloud.ionos.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 1/3] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Mon, 21 Apr 2025 22:18:54 -0400
Message-Id: <20250422021856.1942063-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.236
Content-Transfer-Encoding: 8bit

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit f7b705c238d1483f0a766e2b20010f176e5c0fb7 ]

When a fatal error occurs, a phy down event may not be received to set
phy->phy_attached to zero.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
Link: https://lore.kernel.org/r/20250319230305.3172920-1-salomondush@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a16ed0695f1ae..3244f30dffec2 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -892,6 +892,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.39.5

