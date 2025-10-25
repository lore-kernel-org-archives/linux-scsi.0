Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FE930BBBA;
	Sat, 25 Oct 2025 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409657; cv=none; b=FJYsq13C+2n6wUk8s3e6cc9bAaXAqS/ww3gvavfd7TsOUPssCoG3YCGg5k6DtXCgJz5BTRSbOGPvFEDCA+TazZtIzUboajwdxf5eoCkhTDgm2zcg1sCUkW9bb8NoggG4+QJ9M2UnSCFR18kefglnctvjBb08/cjsAJmIgHZ0l44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409657; c=relaxed/simple;
	bh=LJLQvPEZCGlHBCzG61tg6UqUKm1C7OYt53EJ7qB59OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hmGT6w92Z7gxdZdfTzOeA2moyPrZ4k9KIEzORr7bc90fuyrKGUOtwC6al2/7ZNq8odE2uwhAxVaGknbV4UcgX1VLXSDDYou04xmoEtPatBdX2f+klizn650iRnxNYOIBL7rhCa2uL88f/QVVqJvqd3e42y6QvrLmd+1eAlfznJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCQTE2m1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCQTE2m1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDA6C4CEF5;
	Sat, 25 Oct 2025 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409657;
	bh=LJLQvPEZCGlHBCzG61tg6UqUKm1C7OYt53EJ7qB59OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCQTE2m1aPdXsjyUadjfr3QNvYe5QY8LvsCPFmVtHMAFOblXA9N0oUlCvpAcm68q7
	 N0UZ/QpxJRPBHiHcl1//k/rJ7rxC4Wm3BxnOsmV74p7YkVa0l4pj8FDws0XGcmvbzG
	 plWWs5QN8VT914IjHFNygjyrvnZ4C4oxekgEZo1f8hxpVhrmSbl231M7wv2wZUHrtq
	 DuDCX3u4GYmWTi/KgF5TRbSA1aySl2ueiWQSXeiB94ZQ0zij8mdwUUFUkF7QuskOKu
	 VGxeTVTRGWJIJEPenRdzWnPTTZi6QPaIGz/HX+LG0BJedEycTPvQ3tdpgTagFk9Px+
	 DjPV6ZwqpItDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] scsi: mpt3sas: Add support for 22.5 Gbps SAS link rate
Date: Sat, 25 Oct 2025 12:00:40 -0400
Message-ID: <20251025160905.3857885-409-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 4be7599d6b27bade41bfccca42901b917c01c30c ]

Add handling for MPI26_SAS_NEG_LINK_RATE_22_5 in
_transport_convert_phy_link_rate(). This maps the new 22.5 Gbps
negotiated rate to SAS_LINK_RATE_22_5_GBPS, to get correct PHY link
speeds.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Message-Id: <20250922095113.281484-4-ranjan.kumar@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Adding the `MPI26_SAS_NEG_LINK_RATE_22_5` case in
  `_transport_convert_phy_link_rate()` maps firmware’s new 22.5 Gbps
  negotiation code to the existing transport-layer enum
  (`SAS_LINK_RATE_22_5_GBPS`), ensuring the driver reports the correct
  speed instead of falling into the “unknown” default path
  (`drivers/scsi/mpt3sas/mpt3sas_transport.c:169`,
  `drivers/scsi/mpt3sas/mpt3sas_transport.c:188`).
- The converted value feeds directly into each SAS phy’s
  `negotiated_linkrate` field when links are refreshed
  (`drivers/scsi/mpt3sas/mpt3sas_transport.c:1160`), which backs sysfs
  reporting and link-management heuristics; without the mapping,
  hardware running at 22.5 Gbps is exposed as “unknown”, degrading
  diagnostics and any policy that depends on link speed.
- All constants used here have been present in stables for years (e.g.,
  `MPI26_SAS_NEG_LINK_RATE_22_5` in
  `drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h:2067`, `SAS_LINK_RATE_22_5_GBPS`
  in `include/scsi/scsi_transport_sas.h:44`), so the change is self-
  contained, matches what the newer mpi3mr driver already does for the
  same rate, and carries negligible regression risk.

 drivers/scsi/mpt3sas/mpt3sas_transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 66fd301f03b0d..f3400d01cc2ae 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -166,6 +166,9 @@ _transport_convert_phy_link_rate(u8 link_rate)
 	case MPI25_SAS_NEG_LINK_RATE_12_0:
 		rc = SAS_LINK_RATE_12_0_GBPS;
 		break;
+	case MPI26_SAS_NEG_LINK_RATE_22_5:
+		rc = SAS_LINK_RATE_22_5_GBPS;
+		break;
 	case MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED:
 		rc = SAS_PHY_DISABLED;
 		break;
-- 
2.51.0

