Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11242BF012;
	Tue, 17 Jun 2025 10:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750154615; cv=none; b=C8wI12fLRHS5fLbD9MH6v+p8Vt/orAG177D+JAy0wyMXWk1uyoLOOl674GMMlGILVfHcn4Z6PDM1mGT6twz/U5GgsNq6CZoKvF1I0iZpCjeq1FcvOqrIFcRKiZ2cRA2T0CVt2D8WLSFp8B59Q6oOqdrslnSvjfhXSq1pbHPv4sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750154615; c=relaxed/simple;
	bh=cFoADo5KXDbu1ZQfJKN6Wx/j94gaUO2wt2/bEBYS5+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FLXb53yJhb84tkgB6J5talCCSJ6sb8X0Nmv/q7+g1WiIMg7euB1qwRrrg00q/4oFFcTVJxiG3yeWIMJrfSRFlf1siuqsDJ7gXsX5DEP2QKar57xbpO+m74Lk1ltlKZdDFXitw9/y6Qz1HVCN+uwrHH59Lewzn860KSC3DOWm+9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=PkuEvpre; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="PkuEvpre"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1750154612; x=1781690612;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cFoADo5KXDbu1ZQfJKN6Wx/j94gaUO2wt2/bEBYS5+s=;
  b=PkuEvpreft6qbj34oxBQF75T0/EmA8oiNPMLyMNIsUskRP4AguP6431/
   m8PTI9jECPgWdaSYMadX0uz1uoJ7Ym9iYj77ddsk+jwklPb8uRsY68dm+
   6elmMrPYN/O1Pp06WyaATasct7qxoP+jCwDmo5nzISMGKAv5U3T53V2xt
   CWp0QKEKYDmh+pKkUfgE9Aivqd8Qv4ZaBAk33ciZiZC6alkbuusmFFnGY
   MjEYEaFhOTfb2Hjpe91HSwVx1bAzbnCFY6b0RIGVUbWRhYiYbWfysQn5S
   jY6baaHO7KJTfhS8rGTADcuevxjNm1M9WOtbO/OWIvR/9zZ0NY0biCh7u
   Q==;
X-CSE-ConnectionGUID: JAk0DghUQ/iHsdweLFq26g==
X-CSE-MsgGUID: qq4GhS86Qh+C2HJOITPY8A==
X-IronPort-AV: E=Sophos;i="6.16,242,1744041600"; 
   d="scan'208";a="84719372"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2025 18:03:26 +0800
IronPort-SDR: 68512efb_3QhD5g10rhUPqIlVIyoeaYeUwoueT8jo3IaN7E42aU1TcaG
 d4MI6yz7w09nNjEdTB0xpd/CCPHviIUInWWOxfA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jun 2025 02:01:47 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jun 2025 03:03:25 -0700
From: Avri Altman <avri.altman@sandisk.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>
Subject: [PATCH 1/2] scsi: ufs: Clear ucd_rsp_ptr for UPIU requests once
Date: Tue, 17 Jun 2025 12:56:10 +0300
Message-Id: <20250617095611.89229-2-avri.altman@sandisk.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250617095611.89229-1-avri.altman@sandisk.com>
References: <20250617095611.89229-1-avri.altman@sandisk.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, the response buffer (ucd_rsp_ptr) was cleared in multiple
UPIU preparation functions. Do it once.

Signed-off-by: Avri Altman <avri.altman@sandisk.com>
---
 drivers/ufs/core/ufshcd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0a702356a715..c2048aca09fc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2826,8 +2826,6 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 	/* Copy the Descriptor */
 	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
 		memcpy(ucd_req_ptr + 1, query->descriptor, len);
-
-	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 }
 
 static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
@@ -2840,8 +2838,6 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 		.transaction_code = UPIU_TRANSACTION_NOP_OUT,
 		.task_tag = lrbp->task_tag,
 	};
-
-	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 }
 
 /**
@@ -2867,6 +2863,8 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
 	else
 		ret = -EINVAL;
 
+	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
+
 	return ret;
 }
 
-- 
2.25.1

