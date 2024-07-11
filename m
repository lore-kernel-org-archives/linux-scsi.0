Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060C816CD1A;
	Thu, 11 Jul 2024 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713507; cv=none; b=fhVNQ/s+P1Vz7BqytmZ8QjxvQKb0D2lMQ+e2VcEJXlY39RKgh9dy4dIBMf7L9xCHkN+KiK9DSL7tg3WFz7ZLoOUk7EzUxyMJ3qSFXPABprSmd/Frw3dFbXOs29FiPrv1Oteb9OvGRHRB7cWKjhwcl5Z1TAULNG1a3t41DZO2RIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713507; c=relaxed/simple;
	bh=/kb7Zqr8CizmlxOqhpma6Z+jQqLlPdWjb8V4xQKTfD4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GbHVK3cffCt37bOWkDW8PCubD3ne4wF2fxNGLZH6K3FFiMd2Udkj6eQUNnnKVQ2SG6LvHGOY/yGEfQ5zfQyF13/tlNXMkO3tN54D4GZCja42g8DudJkF5Jkwew6cZOdd+1IG7RmfsYunylPxe9m80fYAhmmDHElXgE17xbD1lVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4v3JfNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4v3JfNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92914C116B1;
	Thu, 11 Jul 2024 15:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720713506;
	bh=/kb7Zqr8CizmlxOqhpma6Z+jQqLlPdWjb8V4xQKTfD4=;
	h=From:To:Cc:Subject:Date:From;
	b=q4v3JfNuMwYrhjXPVE9IaJv/sh3LuYuCUF7nZKiP0PLhPw01UztfSDgixd6Zzo8z1
	 r/iL6IKk2ETqTe8fuwLlayCLJnoxwrXMom15WZcPUjlp+zGpeTNAFCk5uHgTd/fs4P
	 3T1t+9Kp1PvXLJ63uhygT5JQNqhgQxm86PdiWkIUIVBu0eBwKx6Qca07WcnVGx3+0g
	 znnu+x6lL1fsUWacMQChGGxWls9GHeLOLQ9IGX8fSzZ0x0c9+X+GJLhJYGSCRnxWxR
	 azoyKsUpDvZhkJf/uF7sxSX+8qyo8YJKseuJGo/avBrJE5Mj5LujrDOMoMjpHfLFZD
	 ZX6edUmxmsMhg==
From: Kees Cook <kees@kernel.org>
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Kees Cook <kees@kernel.org>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: struct MR_LD_VF_MAP: Replace 1-element arrays with flexible arrays
Date: Thu, 11 Jul 2024 08:58:23 -0700
Message-Id: <20240711155823.work.778-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1183; i=kees@kernel.org; h=from:subject:message-id; bh=/kb7Zqr8CizmlxOqhpma6Z+jQqLlPdWjb8V4xQKTfD4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkAEfa7KwhRVpfAoIhUA1enNGEKSXbZVAnPWPY hBZ9DcxlxuJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpABHwAKCRCJcvTf3G3A JoZfEACosPugyKJoe5or8jFLjhMs+u0AdJEEgExD9cySuhAWKko7ncWLkfZAQeSbpEjI1BCmJTb FHkmwTY9BP0W9EzNZnUgNiJlPJtEENShiwyQ7vMcFfgCVif53HQ1yugLtMEIdPX3yzI6fm++G1S c4IPV1uTRcTo5qhawyiI7hB2GphYL0L6hb+5TWpSpldFKDBVxjAcoVld0dU6C+zlk6YBjFjEW0b eYLuixNSV+QXBbCowbqLLVmhaA2owZvKGWeSFVrNCETFLX5U5B6HqShhBFublELsX/Hg3lF4gnW tnIT1P3VS6qnt+4Q8ku5uu/8gJrFrg7LZ43gVAF7DDp+gGMqItLwkhg+LDO7X4jeHarReInUCfm 8hN8IClFlbCRxCFebNeU84kIWKJpsPjgIx1x44V0Rw/+nsyjZoWjILHmxmdoGOYkfdTD5jkAfuS 3w/ouBxTlZqRXfF+BthI5WDLLCa3RXq1bv16N1YtlvAbp3FFQhA0BGtQT2sa0yGL215YZr6bV5Y a7nzeA8JBL05cFtn+9q7jNPd7KYDf40tG1pHP5LWCVQ46YODXzpau1k2vEQ5B4yalp4LZDsv+Zk zik91/P7BHmGBRuPQ1wxAACYGkJeuLickRxv+trBegqXN+aO9X/bbjOwRM6MU7P6LHz7FR704VK /UZ7fopjNnSEH
 Kw==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct MR_LD_VF_MAP with a modern flexible array.

No binary differences are present after this conversion.

Link: https://github.com/KSPP/linux/issues/79 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 5680c6cdb221..84cf77c48c0d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2473,7 +2473,7 @@ struct MR_LD_VF_MAP {
 	union MR_LD_REF ref;
 	u8 ldVfCount;
 	u8 reserved[6];
-	u8 policy[1];
+	u8 policy[];
 };
 
 struct MR_LD_VF_AFFILIATION {
-- 
2.34.1

