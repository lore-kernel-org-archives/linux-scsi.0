Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2245A274B4B;
	Tue,  5 Aug 2025 13:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399449; cv=none; b=q7glrEnYstYOxMtuLJOFfXWxnKrmT8wkSaY60Jd6ML2UO+ChSbIGhTd/IsoYf1tdpfdpKzcgPEX3zz+i9hnnsoBw03u9bNPYUHCB0Gly9cTWQ1f0Gv3rWvIJlzYg+i/mua/1JAn/qCDiVc3MZXRe4JwtgwkuMorh/65nKX9t2lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399449; c=relaxed/simple;
	bh=LZGLItp07dcwe7VHSIu5FA/hpY/wckqr1tY+RSkuAUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U7WZhmLBitXPfZ56/Wz/eJ2E+R7Wpp/rPts/DvsjnSSVOd8SUYA10//BitYD4Cjumfr813Ls9CLdSFEFH41op079kHDj4ae59MsJXq0JV/N/OzyC29P7SX1ZUF7C8ab9NcjM0NGddHbB7xDclEHWJS7nuQ5b/kJ5vjE7kDfINkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZkycmS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZkycmS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3764C4CEF0;
	Tue,  5 Aug 2025 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399449;
	bh=LZGLItp07dcwe7VHSIu5FA/hpY/wckqr1tY+RSkuAUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZkycmS91Sz+b6SgUJArkZ00NGHuAJvKsl4L9+szmyl7IKj9AWYjgMON0IszoyQsw
	 VwJXS8+hGGBlA3jqL+jjrAPWBHFiBZ4kBMC6h/vaPrpluy9hRQxXjWs8a715zQSgY1
	 6MoidscbtpFpzeMQv/aN+u6h/OhJRdtVfyp0Wv0XKGBTvWX3DA3mQFVdgoH+cCEDPB
	 8j3F+K9C+FrhEFI6f+kbEruQw3aRGK0LG2cHIqJnNzfNQyAn9+IjKxiGJqAkilqib4
	 nAuUFmOHSvoI3ByiTLp7GtMADVvKkWjGObATB7LFq98vNVJBuI5wcEv/9C0LEif4ex
	 cG+eVXWIGNhsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Francisco Gutierrez <frankramirez@google.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jinpu.wang@cloud.ionos.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.15] scsi: pm80xx: Free allocated tags after failure
Date: Tue,  5 Aug 2025 09:09:03 -0400
Message-Id: <20250805130945.471732-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Francisco Gutierrez <frankramirez@google.com>

[ Upstream commit 258a0a19621793b811356fc9d1849f950629d669 ]

This change frees resources after an error is detected.

Signed-off-by: Francisco Gutierrez <frankramirez@google.com>
Link: https://lore.kernel.org/r/20250617210443.989058-1-frankramirez@google.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Analysis

1. **Clear Resource Leak Bug**: The commit fixes a resource leak where
   tags allocated via `pm8001_tag_alloc()` are not freed when
   `pm8001_mpi_build_cmd()` fails. Looking at the code:
   - In `pm80xx_chip_phy_start_req()` at line 4652-4656, a tag is
     allocated
   - If `pm8001_mpi_build_cmd()` fails (returns error), the function
     returns directly without freeing the allocated tag
   - The same pattern exists in `pm80xx_chip_phy_stop_req()`

2. **Actual Runtime Impact**: The `pm8001_mpi_build_cmd()` function can
   fail with `-ENOMEM` when no free MPI buffers are available (as shown
   in the function implementation). This is a realistic failure scenario
   under memory pressure or high I/O load, making this a real-world bug.

3. **Resource Exhaustion Risk**: The driver uses a limited tag pool
   (PM8001_RESERVE_SLOT tags). Each leaked tag reduces the available
   pool, potentially leading to:
   - Tag exhaustion over time
   - Inability to issue new PHY start/stop commands
   - Degraded SCSI controller functionality

4. **Consistent Pattern Fix**: The codebase already has established
   patterns for properly freeing tags on error paths, as evidenced by:
   - Multiple existing instances where `pm8001_tag_free()` is called
     after `pm8001_mpi_build_cmd()` failures
   - Previous similar fix in commit c13e73317458 for tag leaks in
     `OPC_INB_SET_CONTROLLER_CONFIG` command

5. **Small and Contained Fix**: The changes are minimal (4 lines added
   in total), localized to two functions, and follow existing error
   handling patterns in the driver. This minimizes regression risk.

6. **No New Features or Architecture Changes**: The commit purely fixes
   a resource leak without introducing new functionality or changing
   driver behavior.

7. **Maintainer Acknowledgment**: The fix is acknowledged by the
   subsystem maintainer (Jack Wang), indicating it's a legitimate issue
   that needed addressing.

The fix aligns perfectly with stable kernel criteria - it's a clear bug
fix for a resource leak that can impact system stability over time, with
minimal code changes and low regression risk.

 drivers/scsi/pm8001/pm80xx_hwi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 5b373c53c036..c4074f062d93 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4677,8 +4677,12 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 		&pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id = phy_id;
 
-	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+	ret = pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
 				    sizeof(payload), 0);
+	if (ret < 0)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return ret;
 }
 
 /**
@@ -4704,8 +4708,12 @@ static int pm80xx_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.phy_id = cpu_to_le32(phy_id);
 
-	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+	ret = pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
 				    sizeof(payload), 0);
+	if (ret < 0)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return ret;
 }
 
 /*
-- 
2.39.5

