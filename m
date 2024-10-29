Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7796A17A58F;
	Tue, 29 Oct 2024 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730197917; cv=none; b=IcqBzYd7B+GPiQspQh830LpCx5j4arTmUkmmFxhmLEZwWpIqmFWRci3s5Ww/2FajtCXmQlEEB1xXNKNcxsvPQCNIt0rrA2So8mGBGksLyrDoJmk3W1y5hwFwwYojp6iav5f58lYC4uaATJovMUakUgcNB6MEXKdvJup9w7tglQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730197917; c=relaxed/simple;
	bh=3UjJEYi6H5qPBF8XI60QT6eZz7o/rqYEXUjuPkN9PJA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gMZts322bVBP0TAK0DYKSB8sOYne34es7nWxMgKdMG1neu5PUoD2DN5a2vEf2v1astLSdjFFmCsk0SZKZxFXly15VrycLjzY9ypD6kz2krG9aqD5xzyP9VsjULsSKTwg2PvuAnVQXX/NtwpJSxKCTJq7zOKCfGpYAy706A9B0d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=E+67RvXJ; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="E+67RvXJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730197915; x=1761733915;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3UjJEYi6H5qPBF8XI60QT6eZz7o/rqYEXUjuPkN9PJA=;
  b=E+67RvXJGzcSaAPSTDZ9cz6dxgEdT518B1PHTTam/swvR+FBCvpN79YB
   ja+uRhUldFw9h0eY3yIyTe8qOHboW3d4bxeMthX7przhTPuVvSA6eLdbN
   bi61yFGk3nXmsL+XO3IpdHdExu+biDT4RlyeLyAGjuPiLJN14aO7CuF7m
   1PpA9hODvkSS76iTn86t16TPjZKH/oMpHegXOYwRflQlZGZ7vP7QJid0E
   CWTiMrE6A/479rMqWw/3d8/qcke2m+CI86hOkHpkQN1lnxErQPhtahlQp
   EZ9r6+oxfV1CeO0p640UG7MkMj2FZeMcLfHJullLDBUhcRVKb2vBm8dNe
   w==;
X-CSE-ConnectionGUID: ML55fWCPSG2Akozq/wAg/Q==
X-CSE-MsgGUID: wh9CAcHPQkSLQvLU14LryA==
X-IronPort-AV: E=Sophos;i="6.11,241,1725292800"; 
   d="scan'208";a="31111241"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2024 18:31:48 +0800
IronPort-SDR: 6720ac67_lfILeSyPsENHf04teJUez5TmOEOvxecFty9bt5s2F8D7WZC
 oUCP36jgcPxRgbCTyV9PxlZpUSCULJ2rwj9780A==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2024 02:35:35 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Oct 2024 03:31:47 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 0/2] Untie the host lock entanglement - part 2
Date: Tue, 29 Oct 2024 12:29:36 +0200
Message-Id: <20241029102938.685835-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is the 2nd part in the sequel, watering down the scsi host lock
usage in the ufs driver. This work is motivated by a comment made by
Bart [1], of the abuse of the scsi host lock in the ufs driver.  Its
Precursor [2] removed the host lock around some of the host register
accesses.

This part replaces the scsi host lock by dedicated locks serializing
access to the clock gating and clock scaling members.

Changes compared to v1:
 - use the guard() & scoped_guard() macros (Bart)
 - re-order struct ufs_clk_scaling and struct ufs_clk_gating (Bart)

[1] https://lore.kernel.org/linux-scsi/0b031b8f-c07c-42ef-af93-7336439d3c37@acm.org/
[2] https://lore.kernel.org/linux-scsi/20241024075033.562562-1-avri.altman@wdc.com/

Avri Altman (2):
  scsi: ufs: core: Introduce a new clock_gating lock
  scsi: ufs: core: Introduce a new clock_scaling lock

 drivers/ufs/core/ufshcd.c | 223 ++++++++++++++++----------------------
 include/ufs/ufshcd.h      |  24 ++--
 2 files changed, 111 insertions(+), 136 deletions(-)

-- 
2.25.1

