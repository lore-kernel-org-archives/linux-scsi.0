Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBF616C859;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713398; cv=none; b=mthxvsEPEw2mQ2mk/Sfgg0FtQa0G4T3GEvFYl2s06LM9ky5pYtgKGzaQayyzBXFjEF3hBZlBiBz30jPWcNxERrXq7GtXDWsIK8e3sSkNARMFm8O8/AomJ6CCgYkAFLL6sVeQFncEhlGGCBQcofRYjbw/lwEYgPBzwfvLn97SvvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713398; c=relaxed/simple;
	bh=BSy2PXieeJ0tiyHG9sTrbXuGOJPeWBrgI6LboG1OoB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bQZ+yN3OU4hO86XGvoeFWGDmV5Z8blU9/wEQY1IdkszfrGShP5dzBImXDmZydTiXqLwV5sQzsALboiMC53t7gqu4+k+7jbqtJtxAHjNoVgMfP/Tv9wV1jAaYOqLn9IhhwlBUwSoqoveZOPbMbMB8DLm165HPmSXKCMCf73QcXX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6H0th5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6H0th5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD45C4AF0D;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720713398;
	bh=BSy2PXieeJ0tiyHG9sTrbXuGOJPeWBrgI6LboG1OoB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6H0th5znsNM3eiDoibOlRzFf7i4jZa5LOaTXFDRrhKzaf3UV7Qg2n8BSzr290YZF
	 xRUAHl2ZBK3azd9rKnq8TLXUgXUQ6WjaICnmBiOwngAublcFyUM835FRFIhufrvaJW
	 V4972q/3jQMmpeUlzhb+J1rGXzyNoSXM36XImczgISeeeSSEDL8tYzZxcapv1Baya9
	 rCHSdHEIFTkWBTPMGoqy6/zcI5GVJfVWKjt/DF8/xhMAFpc9kD1A9ab96L950EE9a3
	 fOLiqZV1/Nc7X5Sx50gkCvj9vHct3lxnfdBJ/ceMIrdtcu8BT+Q8MkUhKFPj6aOH4S
	 bhikoNiixqrZg==
From: Kees Cook <kees@kernel.org>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kees Cook <kees@kernel.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 3/4] scsi: mpi3mr: struct mpi3_sas_io_unit_page0: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 08:56:35 -0700
Message-Id: <20240711155637.3757036-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711155446.work.681-kees@kernel.org>
References: <20240711155446.work.681-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1754; i=kees@kernel.org; h=from:subject; bh=BSy2PXieeJ0tiyHG9sTrbXuGOJPeWBrgI6LboG1OoB8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkAC07GEwubBo8oE0yJaReSG0O8rOPQdifeArV 7lVfBpgjN+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAAtAAKCRCJcvTf3G3A JphuD/9v7SZ0Slp6GzVBDdOZASNWVWTd69JQ/QjuFGcTXJYkVqyw7EQ1LKvYFv2VNkIJ2du1e12 KiyqhDdbPsPJODnbMct4C0w3E44fCiN2P6RzRZ8HemEtW+K0HQ2R3HdxxeDOZvrCMm4om81sz0e LLmPoZVSIvij9R7xmFBx4H70pi0DLPp/YdPnxQe4V6c0R9V/HAv0VnbxDLDPd7/rzWqUJmU/Hie ojFkFDRjIEyt1l8AZ1jfFBJtl/B9eey9kOD63I9boObOzf11LJtv8v91K1MyPD5IL+eyTuLPSGN xt148FIO655ILhnBT9J0F/mtg3fyNeyLZpwKod9aCAapAO0lGNtIQm0qZLKrIbMdq2z1bv2X3TV i9yRdV9Umlqb7B3OFywPjdC75b63T63Ut4GAH4tirMfk13/nlmFW7h3vU1Rjbz5YAxvOQiQDW/v pRNK4otW/t0l1vW5JhMVl8NP8RzoG65gbuaeauP2OpfOYeIz7KoRt0H/fPUJ6ncqDWHvcav6rM8 1MRWwF/EQlo1H/CjbJ6YaH/lHI6Zogv1XdWAHUksYmm370X88QTXKOs6l1u1mLwcOebxywtrl+h ULfT+Tafp2E+OGBFLkvUOIgVmzvbWbptoCdRrKpxyJcO45W5jJWCyn9ex8nvn2n7CdNnFKHBhZM 7B1pExXM+IMCOLQ==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct mpi3_sas_io_unit_page0 with a modern flexible array.

No binary differences are present after this conversion.

Link: https://github.com/KSPP/linux/issues/79 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 6a19e17eb1a7..66cca35d8e52 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -1565,16 +1565,13 @@ struct mpi3_sas_io_unit0_phy_data {
 	__le32             reserved10;
 };
 
-#ifndef MPI3_SAS_IO_UNIT0_PHY_MAX
-#define MPI3_SAS_IO_UNIT0_PHY_MAX           (1)
-#endif
 struct mpi3_sas_io_unit_page0 {
 	struct mpi3_config_page_header         header;
 	__le32                             reserved08;
 	u8                                 num_phys;
 	u8                                 init_status;
 	__le16                             reserved0e;
-	struct mpi3_sas_io_unit0_phy_data      phy_data[MPI3_SAS_IO_UNIT0_PHY_MAX];
+	struct mpi3_sas_io_unit0_phy_data      phy_data[];
 };
 
 #define MPI3_SASIOUNIT0_PAGEVERSION                          (0x00)
-- 
2.34.1

