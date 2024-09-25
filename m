Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C40B20010D;
	Wed, 25 Sep 2024 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727265925; cv=none; b=iWOV4F9ma6idd8On3oVgkhYL5s/lKvgYqTCXntDliFTYTgA/dY5ldcycTSih9QdsLE3D4/Z3f83+0c3LPet0f08UJJUzkKgEoEdKNjfKP27+zsm/hYAaFl/QuC/b0smdutmdaYEZLqfbLu5mT6w1cdu0e49cI94s0a5qC00yGAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727265925; c=relaxed/simple;
	bh=DIgccXoM7l0r0k5D5IXzP36HlpO+6jZM1+Rqh+3F1xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrnmEXgjvgMyK1yg3ORRux+E6Ulr0JZ6PwZLjJRtjAUrGbNH8fdO8/XPxZJY1JsBYARNzCYa0vmz+DKBZFOptl/m9NDVXn9p1T7ZoVyGBWGDpR8uZSEqrYJBB5XLwqH2a62bjDhn0ebEGf4teMRiT5EPWM+Ug5wEQNh9x2DIzbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/SG1Npw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/SG1Npw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A8AC4CECD;
	Wed, 25 Sep 2024 12:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727265925;
	bh=DIgccXoM7l0r0k5D5IXzP36HlpO+6jZM1+Rqh+3F1xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/SG1Npw1gR/3SpPWkFZWIxYQ6T5zDQmitR1Sj7jvhndwN7OHpI4HPqLCSEl3onzn
	 mXuf8mGBONvFrYs8TQZ/gtUZl9/QsbZPTRDGv1jBzJIWwx2JHO640sw32wr6CNDqvP
	 JyzrBEW16RQ5OvD83FGC8ZUzHvO0xySSBCBmd+UKQTaMN+pPmA3UWE6txm+RzGWCN6
	 PlDc1h8O4WvktYohNa1N2Myp8MPKw+9y0n1LK0YhRkVNVt5e+VVXjkIr6a6H4Uv0kL
	 6Rv/Pxzh4iQm+GHGTcBTGB194hEArKwjbS5oep/ONS9hRrZM2l4k0DePVum7E/1JNn
	 wBffVPrbW7P2Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: David Strahan <David.Strahan@microchip.com>,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 126/197] scsi: smartpqi: Add new controller PCI IDs
Date: Wed, 25 Sep 2024 07:52:25 -0400
Message-ID: <20240925115823.1303019-126-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925115823.1303019-1-sashal@kernel.org>
References: <20240925115823.1303019-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.11
Content-Transfer-Encoding: 8bit

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit 0e21e73384d324f75ea16f3d622cfc433fa6209b ]

All PCI ID entries in hex.

Add new inagile PCI IDs:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
            SMART-HBA 8242-24i               9005 / 028f / 1ff9 / 0045
            RAID 8236-16i                    9005 / 028f / 1ff9 / 0046
            RAID 8240-24i                    9005 / 028f / 1ff9 / 0047
            SMART-HBA 8238-16i               9005 / 028f / 1ff9 / 0048
            PM8222-SHBA                      9005 / 028f / 1ff9 / 004a
            RAID PM8204-2GB                  9005 / 028f / 1ff9 / 004b
            RAID PM8204-4GB                  9005 / 028f / 1ff9 / 004c
            PM8222-HBA                       9005 / 028f / 1ff9 / 004f
            MT0804M6R                        9005 / 028f / 1ff9 / 0051
            MT0801M6E                        9005 / 028f / 1ff9 / 0052
            MT0808M6R                        9005 / 028f / 1ff9 / 0053
            MT0800M6H                        9005 / 028f / 1ff9 / 0054
            RS0800M5H24i                     9005 / 028f / 1ff9 / 006b
            RS0800M5E8i                      9005 / 028f / 1ff9 / 006c
            RS0800M5H8i                      9005 / 028f / 1ff9 / 006d
            RS0804M5R16i                     9005 / 028f / 1ff9 / 006f
            RS0800M5E24i                     9005 / 028f / 1ff9 / 0070
            RS0800M5H16i                     9005 / 028f / 1ff9 / 0071
            RS0800M5E16i                     9005 / 028f / 1ff9 / 0072
            RT0800M7E                        9005 / 028f / 1ff9 / 0086
            RT0800M7H                        9005 / 028f / 1ff9 / 0087
            RT0804M7R                        9005 / 028f / 1ff9 / 0088
            RT0808M7R                        9005 / 028f / 1ff9 / 0089
            RT1608M6R16i                     9005 / 028f / 1ff9 / 00a1

Add new h3c pci_id:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
            UN RAID P4408-Mr-2               9005 / 028f / 193d / 1110

Add new powerleader pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
            PL SmartROC PM8204               9005 / 028f / 1f3a / 0104

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20240711194704.982400-2-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 104 ++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 24c7cb285dca0..9166dfa1fedc3 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9472,6 +9472,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x110b)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x1110)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8460)
@@ -9588,6 +9592,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x0089)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x00a1)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f3a, 0x0104)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x19e5, 0xd227)
@@ -10180,6 +10192,98 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1137, 0x02fa)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0045)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0046)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0047)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0048)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004a)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004b)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004c)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0051)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0052)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0053)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0054)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006b)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006c)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006d)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0070)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0071)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0072)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0086)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0087)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0088)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0089)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1e93, 0x1000)
-- 
2.43.0

