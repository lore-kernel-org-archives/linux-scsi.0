Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741E01A00C1;
	Thu, 11 Jul 2024 21:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720735060; cv=none; b=iYnXfjv4/VgqOT5AjG5TkmxBKE6f88rP/S24UWfQNwqvAWHYWrRzl/V+Jms+bNR5fjXUuJGvqpMOdbszEXw+cEAcE6nwkKWcOAyDsgo6P9FFB1o2q0cK4ZeGIEW3UvGr0mXHZOXmbwpLAv+FCSZk5Xvql7/d3/e4cZopcKuAmYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720735060; c=relaxed/simple;
	bh=bxqKXS/+WdNeKOW5XPcC4Vf7oGDiAIOeJBFndmcpWeA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BrmY5N/AoqcSfG/FwU7/8XBt85hsQ/LcFM89l03A7aYNsPta/qJKQyK6Tdb0b7o0pDDyjXlaJ7ldYXDTncGLjiYNNO0txVREEPoY+4DkWT60gAaHMFYsh+thVHCInyO1YQ2gbtiUB1s2EXbZnJIHSvPVzABAv6edekZLCwm22tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJzp17FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJzp17FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1883EC32782;
	Thu, 11 Jul 2024 21:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720735060;
	bh=bxqKXS/+WdNeKOW5XPcC4Vf7oGDiAIOeJBFndmcpWeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJzp17FUsq0aKzsHFwV3LcOPdIdCUmybA77vg5ppgkIVs49c38wHiHcj/jfib803O
	 qMhWblIAUoFc+bL6enXdu2ivyFs+0RRh3AbuOYlrXXwqIsNAcseMqBfGFPH30ByIB5
	 ojJbrFDQCjmVyvcFupqUfMicjNVxQXtuRaLxmn0OfB2SsmCRWpK9dpyQqYMnKQdTDM
	 bgUUwY2VDjF/4p4BStmy2ynLtGWcZC2sOLnc6dwVk/AYrOp9OBZ1f+K7FKkMx2rJps
	 QyqZ7sVjlK7BEqQbdcJnn9hRRJi+0FmBYFt5QaJGNBP6QluFpL5dqaxyJ8gMA7uYDk
	 DGRaAcKbPjdNg==
From: Kees Cook <kees@kernel.org>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Kees Cook <kees@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 1/2] scsi: aacraid: Rearrange order of struct aac_srb_unit
Date: Thu, 11 Jul 2024 14:57:37 -0700
Message-Id: <20240711215739.208776-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711212732.work.162-kees@kernel.org>
References: <20240711212732.work.162-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4081; i=kees@kernel.org; h=from:subject; bh=bxqKXS/+WdNeKOW5XPcC4Vf7oGDiAIOeJBFndmcpWeA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkFVSW+Z67AEQ8of5jNDviU3+qKVbvueEgaCbS t79iH7rK+yJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpBVUgAKCRCJcvTf3G3A Jit9D/9SRai4TSd5rJdLmnPGhKmDNSwEVheYARY+Irlm0CMaQyESh+qy0Fpxd8cb1bYe76Izq0A hFZE/KG1uqx5wveOfzmrSzYFScPld6ALDj7LD7qJ63q/T+pisodJoVVxzOQh3URoJ1hCmFANbdF HfuYKWb/roTAco42WChvh5OkQARdMlNagjgrZPvapZeT60wnptH3OqnWYIqiMZ2/9g9NvfibTYi TlrkeaO9MiKjnPnRzY/sPHtrHjbGxFKJIsCEf7NL2KEwWUjGv/+Ag2GFLwX/2fz3J+YjdJcqBeQ 2XvcPHBwjqNBhEq3EBh8PaH8Zg7ozTKLer2ErdLuGpizZN/MSwDbGJkFz1tk88I/mBZHGH632we 4DHLZCo/zAcjMTUlEHlnJvjjMuWUHFKu65qHXDC8QuVttLkKcqm0NN6KtKasWQv5bZf2gYfgnie wXEsSKEu/N4ukyIo1Jj+tzlYdnOLSbdWV2/G4mIbvlR8eOPMtsuoN7Ec2h90zGjqPC+8hYDKOD8 WRG1CNEHiUGw6+L6Zdj54wPIIopb4emEk8tYrFtVbW7E5F130JfDjQ30YKr0/vRQSSlJz8FRp4G 5sHwYRYbG3qTvSdo3bGvv8+BD42PleIjiJUgCXBoijeupZt2jz98inkD4kVHXndCaNxgEJRMzD5 U5r54mwP2Qi+0Pw==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

struct aac_srb_unit contains struct aac_srb, which contains struct
sgmap, which ends in a (currently) "fake" (1-element) flexible array.
Converting this to a flexible array is needed so that runtime bounds
checking won't think the array is fixed size (i.e. under
CONFIG_FORTIFY_SOURCE=y and/or CONFIG_UBSAN_BOUNDS=y), as other parts of
aacraid use struct sgmap as a flexible array.

It is not legal to have a flexible array in the middle of a structure,
so it either needs to be split up or rearranged so that it is at the
end of the structure. Luckily, struct aac_srb_unit, which is exclusively
consumed/updated by aac_send_safw_bmic_cmd(), does not depend on member
ordering.

The values set in the on-stack struct aac_srb_unit instance
"srbu" by the only two callers, aac_issue_safw_bmic_identify() and
aac_get_safw_ciss_luns(), do not contain anything in srbu.srb.sgmap.sg,
and they both implicitly initialize srbu.srb.sgmap.count to 0 during
memset(). For example:

        memset(&srbu, 0, sizeof(struct aac_srb_unit));

        srbcmd = &srbu.srb;
        srbcmd->flags   = cpu_to_le32(SRB_DataIn);
        srbcmd->cdb[0]  = CISS_REPORT_PHYSICAL_LUNS;
        srbcmd->cdb[1]  = 2; /* extended reporting */
        srbcmd->cdb[8]  = (u8)(datasize >> 8);
        srbcmd->cdb[9]  = (u8)(datasize);

        rcode = aac_send_safw_bmic_cmd(dev, &srbu, phys_luns, datasize);

During aac_send_safw_bmic_cmd(), a separate srb is mapped into DMA, and
has srbu.srb copied into it:

        srb = fib_data(fibptr);
        memcpy(srb, &srbu->srb, sizeof(struct aac_srb));

Only then is srb.sgmap.count written and srb->sg populated:

        srb->count              = cpu_to_le32(xfer_len);

        sg64 = (struct sgmap64 *)&srb->sg;
        sg64->count             = cpu_to_le32(1);
        sg64->sg[0].addr[1]     = cpu_to_le32(upper_32_bits(addr));
        sg64->sg[0].addr[0]     = cpu_to_le32(lower_32_bits(addr));
        sg64->sg[0].count       = cpu_to_le32(xfer_len);

But this is happening in the DMA memory, not in srbu.srb. An attempt to
copy the changes back to srbu does happen:

        /*
         * Copy the updated data for other dumping or other usage if
         * needed
         */
        memcpy(&srbu->srb, srb, sizeof(struct aac_srb));

But this was never correct: the sg64 (3 u32s) overlap of srb.sg (2 u32s)
always meant that srbu.srb would have held truncated information and any
attempt to walk srbu.srb.sg.sg based on the value of srbu.srb.sg.count
would result in attempting to parse past the end of srbu.srb.sg.sg[0]
into srbu.srb_reply.

After getting a reply from hardware, the reply is copied into
srbu.srb_reply:

        srb_reply = (struct aac_srb_reply *)fib_data(fibptr);
        memcpy(&srbu->srb_reply, srb_reply, sizeof(struct aac_srb_reply));

This has always been fixed-size, so there's no issue here. It is worth
noting that the two callers _never check_ srbu contents -- neither
srbu.srb nor srbu.srb_reply is examined. (They depend on the mapped
xfer_buf instead.)

Therefore, the ordering of members in struct aac_srb_unit does not matter,
and the flexible array member can moved to the end.

(Additionally, the two memcpy()s that update srbu could be entirely
removed as they are never consumed, but I left that as-is.)

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 6f0417f6f8a1..8e7a0a5cb7aa 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2029,8 +2029,8 @@ struct aac_srb_reply
 };
 
 struct aac_srb_unit {
-	struct aac_srb		srb;
 	struct aac_srb_reply	srb_reply;
+	struct aac_srb		srb;
 };
 
 /*
-- 
2.34.1

