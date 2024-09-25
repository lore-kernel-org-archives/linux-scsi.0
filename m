Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74731BB692;
	Wed, 25 Sep 2024 11:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727264873; cv=none; b=MsTRxPSVOzoW4yRhCYqUK2RF8UQf9J6FWdGzXb168LA8Q/VtUAX6HdO9KfB1jup0qQOziiFdZ6Tx5zVTV/FHgz4wfmRuM/CjwKdAKJwKShZEfVmpY8GgVItfUn7j9eI/Bq4/9ioE8s8y5fc84pUW6R3XnSzQ0aE6tXsWgcgvwHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727264873; c=relaxed/simple;
	bh=q31IgjeZ87tKVwugrlTWy1ijWIrYF2EdrIlt5qJnx8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO2GymkI55+HJnKt4t4LUxQfXooC7FslpljKI2cHwWNqCLKlahqMgu7syN5rZzeqnU0ILE3JMaZc1BPSH/OBgZ9N002jze8Jv5JzTVxkyPDGMJfcKNZPr852siNW8sqOKa894U04nbXGnp0Nd/hKlwj0CpxNXS9Gjf3zWjnSKcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StvSIMfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StvSIMfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1952FC4CEC7;
	Wed, 25 Sep 2024 11:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727264872;
	bh=q31IgjeZ87tKVwugrlTWy1ijWIrYF2EdrIlt5qJnx8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StvSIMfVucVln9zr/2ion2xWAuFoPvXCV99Hyu7k+1fbE+x2qKXlkUf7Oy4fxjYIu
	 Pucf0AKRSkdl6Rvmpj0d4H/wEJDbBnKHlVc0R48ExjFygngDfmjdhO7Xiyde2Ai/k/
	 paG8C5vEvr9MoXcxjXIUltPpNveiWnMAK4E2pLWwegMTGiBemEbnUmoJ7lUEdg2M3Z
	 emIpRowThINyphV81Lk05kn8q9ViVJVx8jdvv9Bs6W+pJR8VQCIJHrm1N5BPSM0/Cm
	 VkaRPG4BfroAIVLSmIxEhEBE8PssqBtmmA2nFaA9/OtDnSbbDZQmzTlWe6efWPeJQM
	 scgfAehbV2lCA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: David Strahan <David.Strahan@microchip.com>,
	Scott Benesh <scott.benesh@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 167/244] scsi: smartpqi: add new controller PCI IDs
Date: Wed, 25 Sep 2024 07:26:28 -0400
Message-ID: <20240925113641.1297102-167-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925113641.1297102-1-sashal@kernel.org>
References: <20240925113641.1297102-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11
Content-Transfer-Encoding: 8bit

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit dbc39b84540f746cc814e69b21e53e6d3e12329a ]

All PCI ID entries in Hex.

Add new cisco pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
                                             9005   028f   1137   02fe
                                             9005   028f   1137   02ff
                                             9005   028f   1137   0300

Add new h3c pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
                                             9005   028f   193d   0462
                                             9005   028f   193d   8462

Add new ieit pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
                                             9005   028f   1ff9   00a3

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20240827185501.692804-5-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f18799afe9de2..5e815e979297f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9444,6 +9444,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x152d, 0x8a37)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x0462)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1104)
@@ -9484,6 +9488,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8461)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x8462)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0xc460)
@@ -10192,6 +10200,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1137, 0x02fa)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02fe)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02ff)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x0300)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1ff9, 0x0045)
@@ -10368,6 +10388,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1f51, 0x1045)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x00a3)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
-- 
2.43.0

