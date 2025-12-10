Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DFB226CF1;
	Wed, 10 Dec 2025 03:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338572; cv=none; b=Sk0mP1ezl8CNfu7jbsRWCmuW0eSTYrGUOVeayVd8zDhdep4NLX4ANYSbjbL56CrAXqrLK3BTS64ZYJK1EcShC0CSNnZmPABZyFgDFk2BRGpJzdDGqsf2Zsh18gLkaQQZZpefVhmnHXycq2vG5ZO/Z9NKEfVmQRT13vJbSe78cBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338572; c=relaxed/simple;
	bh=XXWah4cqIHWXwZzbYVWhOp9mQE67r5WmT6rMumBmu+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A60OAlap/Tw4PVy664bs2hviH5YfSFUEIet57ug0tT8BVYlBvkNUQI9XWvUNHDBU4N5RJEBd+o6Dzl495IZ+LwrNA8uDgNbuoEGu9Ts++ZJoaKofzudRPCUFjO3cuQzPWPKC3PJkTKBrAjlZFQEkfaUQvJ+DqWVhb3FvzIpcz6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDsyEDm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDsyEDm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6709C19422;
	Wed, 10 Dec 2025 03:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338571;
	bh=XXWah4cqIHWXwZzbYVWhOp9mQE67r5WmT6rMumBmu+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDsyEDm3WFv88RdL+94cPGcxi+fPZI4iBA/+26LN5lLP0ZyWyo31KWXHxh6sQ2nqQ
	 yop3z7I++r/maDtKH9Zhcf4QQcj7g9FB8SegeUxEn7xBlClMqL+VS/ds+z/B7dve4/
	 6jBzEF3D2kX7FUXMCJuqEEhIFJ/xV65ZxRSrcX+HBbyTrxTaN4RO6W9FP46GO6ZtPW
	 ii1Gc6iTO4qDMQjTiqii4qc2meictZQZ6lqIN0uejPHq7oQRxgeM35ip8sNAOqpuOE
	 aYhZwxFGEVtwHvERw80R0XPN7T38H6oPiM/du8skmLVHjenXutPZb6d9aynehX1qTA
	 zWCDjAazrgeOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Strahan <David.Strahan@microchip.com>,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] scsi: smartpqi: Add support for Hurray Data new controller PCI device
Date: Tue,  9 Dec 2025 22:48:48 -0500
Message-ID: <20251210034915.2268617-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210034915.2268617-1-sashal@kernel.org>
References: <20251210034915.2268617-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit 48e6b7e708029cea451e53a8c16fc8c16039ecdc ]

Add support for new Hurray Data controller.

All entries are in HEX.

Add PCI IDs for Hurray Data controllers:
                                         VID  / DID  / SVID / SDID
                                         ----   ----   ----   ----
                                         9005   028f   207d   4840

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://patch.msgid.link/20251106163823.786828-4-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: smartpqi: Add support for Hurray Data new
controller PCI device

### 1. COMMIT MESSAGE ANALYSIS

**Subject/Body:** The commit adds support for a new Hurray Data storage
controller by adding its PCI device ID to the smartpqi driver's device
table.

**Tags present:**
- Multiple `Reviewed-by:` tags from Microchip engineers
- `Signed-off-by:` from driver maintainers
- **No `Fixes:` tag** - not fixing a bug
- **No `Cc: stable@vger.kernel.org`** - maintainer didn't explicitly
  request backport

### 2. CODE CHANGE ANALYSIS

The diff shows an extremely minimal change:
- **File modified:** `drivers/scsi/smartpqi/smartpqi_init.c`
- **Lines added:** 4 lines (one PCI device ID entry)
- **Change type:** Static array addition to `pqi_pci_id_table[]`

```c
{
    PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
                   0x207d, 0x4840)
},
```

The new entry uses the same vendor ID (0x207d - Hurray Data) already
present in the table with different subsystem device IDs (0x4054,
0x4084, 0x4094, 0x4140, 0x4240). This is simply adding another variant.

### 3. CLASSIFICATION

This falls under the **NEW DEVICE IDs exception** - one of the
explicitly allowed categories for stable trees:
- Adding a PCI subsystem ID to an existing, mature driver
- The smartpqi driver already supports Hurray Data controllers
- Only the specific hardware variant (SDID 0x4840) is new
- No new driver code, no feature additions - purely declarative data

### 4. SCOPE AND RISK ASSESSMENT

| Factor | Assessment |
|--------|------------|
| Lines changed | +4 (trivial) |
| Files touched | 1 file |
| Complexity | None - static data only |
| Subsystem maturity | High - smartpqi is a well-tested SCSI driver |
| Risk of regression | **Essentially zero** |

This is purely declarative - adding an entry to a static array. It
cannot introduce logic bugs, race conditions, or regressions. If the
hardware doesn't exist on a system, the entry has no effect whatsoever.

### 5. USER IMPACT

- **Affected users:** Anyone with a Hurray Data controller using
  subsystem device ID 0x4840
- **Without patch:** Storage controller won't be recognized; system
  likely unusable
- **With patch:** Hardware works normally
- **Impact severity:** Critical for affected users (storage controller =
  essential hardware)

### 6. STABILITY INDICATORS

- **Multiple reviews** from driver maintainers (Scott Benesh, Scott
  Teel, Mike McGowen)
- **Established pattern** - follows exactly the same format as dozens of
  other entries
- **Mature driver** - smartpqi has been stable for years

### 7. DEPENDENCY CHECK

- **No dependencies** - completely standalone change
- **Code exists in stable trees** - smartpqi driver and its PCI ID table
  are present in all active stable branches

### DECISION ANALYSIS

**For backporting:**
1. ✅ Falls squarely into the "device ID" exception category
2. ✅ Zero risk of regression - purely data addition
3. ✅ Enables critical hardware (storage controller) for affected users
4. ✅ Trivial, well-reviewed change
5. ✅ Pattern already established with many similar entries
6. ✅ Self-contained with no dependencies

**Against backporting:**
1. ⚠️ No explicit `Cc: stable` tag
2. ⚠️ Technically "new hardware support" not a bug fix

### CONCLUSION

This is a textbook example of a device ID addition suitable for stable
backporting. The stable kernel rules explicitly allow new PCI/USB device
IDs because:
- They are trivially small and well-understood
- They have near-zero risk of regression
- They enable real hardware that users have purchased

The lack of an explicit stable tag is not disqualifying for device ID
additions - these are routinely accepted into stable trees. For a
storage controller, this is particularly important as users with this
hardware variant would have non-functional systems without the ID being
recognized.

The change is obviously correct, has been reviewed by multiple
maintainers, follows an established pattern, and provides clear value to
affected users with no risk to anyone else.

**YES**

 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 03c97e60d36f6..91b01e2e01f01 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10108,6 +10108,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4240)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4840)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
-- 
2.51.0

