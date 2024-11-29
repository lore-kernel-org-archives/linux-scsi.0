Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED97C19C566;
	Fri, 29 Nov 2024 15:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894358; cv=none; b=RFvrt8QvtJZRfs8tf2ervFKw+XeuLTxbc4gpIjE+DcPDkxBymrOF6HnC3TIAex375mbH5YQc9J6mgDGSYbaXNvzWBbsrWeMLjvi/TJ9IXoo+dWSTJrbpTPEf0tL/8iumHwQzyBZ6fFa9GxwmKcqf4bN9Sma+xzW3olbHU75gPGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894358; c=relaxed/simple;
	bh=bhtU96oxwzBb9jJ71pKc7JkNY4mbmp/siqnKgJRyfL0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RIUjJkHv+T6EK3kc6wuwJVqb0ZzHePgW8w71XJS0x3SnUru47X82uNPX1Rs1WOHG19jFsp4ZhXpdx3WvlW5pJ09Dm9QyBgGRoO4LHHBGGA5NxUn5RhslHvMTgEWJKhdXBCtuT1z13KaoOu2TUKPXQmFGAWHg3PR2YexOi/WQlmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=AGLx7Xhh; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=hzkcnPtH; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="AGLx7Xhh";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="hzkcnPtH"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 06BA5E0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894352; bh=DLjFI//x5ecdGB56aIfPz255gSyglUHASG3ntCPv2mM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=AGLx7XhhMFtOiKLef9olk2EsnP4wWaJCCEt0kBYcvwRvDudCzA6Tr15yoL64g3+1R
	 PR3Ssv62YNkGHkUh+R8DaQKpftkZ3GmpFJIQMwJi32fflw8aeLiTpGZlpphc0M2lEC
	 lO+g/k+kr4+vOIunSbtTTBqlkyQgaR8xTS0coPqXBBulCgSLy55MsSjplDLBRkIw7E
	 7lvfnwehiCgjL7CdwKPys/PPRlLfHj0/mo6DUWT0/7AIWPlyXWbdal+bchv4ngyfse
	 LE16dAZBRUsQJF0J3EwlIpze99v1JFG6TO4vJdvkTig5WjlZlYf2I46JjfyS99lPCc
	 X9uknEta1h0uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894352; bh=DLjFI//x5ecdGB56aIfPz255gSyglUHASG3ntCPv2mM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=hzkcnPtHgbr+oBCMAbXV26niHvY1FZrZx/kkp+Hk0RM9l0MqUVw+1D84hYcX8cuFt
	 eYL9Vbcz1xtpohGp2WZM0SQYrmcZLQYVbvS/0wM5vnKuU45CXKhZ0mcDGvLHR/Bdr+
	 889t5NPycXQnhnXBUe3c7yUYtlyuMH8CCRZyBNZ1kJ4HXpTHLzA7F46JrO7K0n4Rvt
	 NOAnV15PS66pz8Tg+WZUryWxlhdiMUcPVHpBA+iUnPNDeFXRcBVJEiD2Pf/q6hhGwk
	 1fLgW440Rs0CjBwaHk2gxsrqb7Unevzf/B1Mn+iSne12d4JUdDofhl8VhOd6n154cJ
	 36klx2+PBXyFg==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 10/10] target: iscsi: Improve a log message
Date: Fri, 29 Nov 2024 18:30:56 +0300
Message-ID: <20241129153056.6985-11-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20241129153056.6985-1-a.kovaleva@yadro.com>
References: <20241129153056.6985-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-06.corp.yadro.com (172.17.10.110) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Change the log message to a useful one.

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 9eae01538696..587a7a69405b 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1143,7 +1143,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 			if (iscsi_check_string_or_list_value(param, value) < 0)
 				return -1;
 		} else {
-			target_err("Huh? 0x%02x\n", param->type);
+			target_err("Unknown parameter: 0x%02x\n", param->type);
 			return -1;
 		}
 
-- 
2.40.3

