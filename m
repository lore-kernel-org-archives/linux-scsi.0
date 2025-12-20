Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6522DC32D;
	Sat, 20 Dec 2025 03:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766201870; cv=none; b=U8F4nnAYaMRQA8uFGJMsdPlZicrbSw+B+9959CdKRIcg/18LGVuiv3onORaz9vHp6iS45uWqRecraNJDMIyInhYbP47s8Jn7OHnizOGSsJH7tr8D9NPU0IRxfFAkepXBnG4Eq/gjjl5Kh+W3XZGDrZWyyptfhAHnUbfZFVt0V10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766201870; c=relaxed/simple;
	bh=jRSMpF4eLalrhg0Di4dEPlD/g1PB2PIZ9yiXeGSUaPI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QqwenLDSnyL2mr5cpOqHcytN4rKopu9lNztNMTCNlF9Pg5ofiquDgMIQWXnK06+fYoiQKrvRsuvVxlukRGVTMWySqGWw9DmFZWtHXvIY8eYNm1R3B1CuwsXTVHfdpuH++MtJQA2I0pSIhx901GZzyC+JwmStu7wvRidzrg8a6Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iP+groqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iP+groqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89CDC116C6;
	Sat, 20 Dec 2025 03:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766201869;
	bh=jRSMpF4eLalrhg0Di4dEPlD/g1PB2PIZ9yiXeGSUaPI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iP+groqK7+T4FUSAmerbnUqWXOx6X40wr8+uDfIa6XmsMpRy92oT6OKOu/JvX2Hkq
	 BfgayXVcKpthAtQz4FzJhgh3sEpXf+Xx5Ht8ihwLrMuYb/Fn7ppQQch9jwJyhz6aGI
	 3lRAbygHG+6bgontB1diGWoJwRYOKWv0x/WSZbeDUFl9rflO/aKJqmrg/AW6DHRCSn
	 5n8jjo3EfEtaBPlbaarwhVnuXEAyegnJgb7j35QnWccqbN3jiHaDCmoGfJHrOKfDPR
	 3R4gV3vx6lHvLyahBiusV4ysw5JXsBg2EzPBSWbJrDcii5ZOWiNiysmuzkZBhuliNI
	 XxnLpk5M0eNKA==
From: Daniel Gomez <da.gomez@kernel.org>
Date: Sat, 20 Dec 2025 04:37:32 +0100
Subject: [PATCH 1/2] target: replace -EEXIST with -EBUSY
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-dev-module-init-eexists-linux-scsi-v1-1-5379db749d54@samsung.com>
References: <20251220-dev-module-init-eexists-linux-scsi-v1-0-5379db749d54@samsung.com>
In-Reply-To: <20251220-dev-module-init-eexists-linux-scsi-v1-0-5379db749d54@samsung.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Hannes Reinecke <hare@suse.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, Lucas De Marchi <demarchi@kernel.org>, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Daniel Gomez <da.gomez@samsung.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1291; i=da.gomez@samsung.com;
 h=from:subject:message-id; bh=VDJDNrBS2vwGPUPZ23vM9lngQG8JKRe7beFXxdcGdZs=;
 b=owEBbQKS/ZANAwAIAUCeo8QfGVH7AcsmYgBpRhoF4mc0A1nMVHErwBgjZFAjaP64bjrrUBFCE
 XjzRXAZNcuJAjMEAAEIAB0WIQTvdRrhHw9z4bnGPFNAnqPEHxlR+wUCaUYaBQAKCRBAnqPEHxlR
 +2ykD/9yHCvTtOaK4pXcD0bFbbJ8NDCmuZVP7ZbTGYnAvlSow/GE77EV3ivvv5e/xKDffvR//ym
 0WHih04OjmcPLE8o56TLrw2vNkGcRc/E6lY65YxKOiQX8M7+Z6Lo154FQAW8z58CzG4biEHhqae
 tw119d6g6pcHvJurj7mj1NXk0d8yXmSbhXjVjveZAbWbDtRaGe94QrOzROJq0jHtg6qZoX9gTGS
 IKGSAF5nk1Zs227/NAXLwraeDS0X0bog222QoRxxdj8OFswt+jTRpJ78qDzbMT1q7J7weWX6/Ab
 5S/4dqVmmivHmEd8lvB8uUDNTTrPi+D5a7K30GpD39MnopwpHnRFZUAIKAxr/lSVefAhMp/f03P
 jMJsE2u/283w+ymh+RpC9D1Vw5rPx0R0jW47SINkf4bJDXTZETVhsZYXVP/6Ow0p8BBXrpNQgGy
 6XYqteAT2FVQdkx9qYt7rpKLUeRDFFAy7QquJ3m5p9Y60C42Y4NnbM+2255CLnyWu0PRvc2HcDm
 xv1jP7HKVGhqyKdhQCK6BCI2qGSHothsCcU28qz0czR5y0hFcB1YV2TX7+ybEaAvgmybyOQMWGP
 kP40YEgn+0PaNEwbTpOMy0HOqDuUTm13mGTMSY/QXCVKaC+6y3jO515QZnNpmz9kPucoS8FgNdj
 zH2klMt3vwYjKEg==
X-Developer-Key: i=da.gomez@samsung.com; a=openpgp;
 fpr=B2A7A9CFDD03B540FF58B27185F56EA4E9E8138F

From: Daniel Gomez <da.gomez@samsung.com>

The -EEXIST error code is reserved by the module loading infrastructure
to indicate that a module is already loaded. When a module's init
function returns -EEXIST, userspace tools like kmod interpret this as
"module already loaded" and treat the operation as successful, returning
0 to the user even though the module initialization actually failed.

This follows the precedent set by commit 54416fd76770 ("netfilter:
conntrack: helper: Replace -EEXIST by -EBUSY") which fixed the same
issue in nf_conntrack_helper_register()

Affected modules:
  * target_core_file target_core_iblock target_core_pscsi
  * target_core_user

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 drivers/target/target_core_hba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index d508b343ba7b..dcc11671d919 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -50,7 +50,7 @@ int transport_backend_register(const struct target_backend_ops *ops)
 			pr_err("backend %s already registered.\n", ops->name);
 			mutex_unlock(&backend_mutex);
 			kfree(tb);
-			return -EEXIST;
+			return -EBUSY;
 		}
 	}
 	target_setup_backend_cits(tb);

-- 
2.52.0

