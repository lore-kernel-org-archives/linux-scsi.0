Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1ED31354F
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776875447; cv=none; b=nUNRVXZi3vIkIVx2E2rJbNG+wBZFrLA/ytOm703apuU2sZEBWhDQQmatNxH+orkOvZMDjtlHyFgsUDKwNNPxj85QktTRf4qv6ueAU6/9m7d27QO1lrBlRJ8KeVU9XRkWDuLVpDxL1wdA8C0BYNJXUnmh0bLN+Jr//ixW2zXFRbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776875447; c=relaxed/simple;
	bh=2S6weVRM6g7QDG2lSOSJh5tFwxoOcENmaY3w4BvAd+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BK5xnCPSHE/Ar2HOKvRzrBoqcj6KChbRqpk5PDDcNHmLdoKXcNPhf+nRmXF3nnc8GybVvo8ZamCJuqIwPRRygMKAECTRCp4sRGjLLcQoEsj/d/tcAt+1gbqJPLq++9ouDp5rm0K6ynytIYs0P4UNB/yFoo8rPiZGwUy5WqEhDs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1MhCK8JT; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1MhCK8JT"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g14TX16JJz1XM5kD;
	Wed, 22 Apr 2026 16:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776875433; x=1779467434; bh=xnZFQaOC5x50o8SQV+kIx1zl
	P6fnlKPIBkPBefK0PAM=; b=1MhCK8JTeaEq0QbkJzE8aBoF+/xfFTeo4R1fxdup
	1+uCfU1w5Caz56JJLS7WgQX+Sit43viTsU6Vy0agBCQZdhqOY84zmWJ7JYRrY5ih
	0Y1Z/sjUyUNqQh+Tvg+4wFn3SUav/xWG70lEsGKDwVI6HgtC1usxpgEcVQBRcXCC
	RgBtdnC/l92fYOVq+ED0Q0t/ipGkF791iU8tM4581bSuIMobqE4uDXDu2mlj3Jmd
	weEgPXnxnei3uY8rlLPPYW/bll+bL0xeQXRgu6aZH6VgZWVuCgoNkdh/bFrSQ0m8
	oq3YRcfvHIa9mVvNhRSQF72VUdeSeXP8o9LrejcmQ9dS/w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6uZNGMRQW2s8; Wed, 22 Apr 2026 16:30:33 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g14TM3ghJz1XM6Jn;
	Wed, 22 Apr 2026 16:30:31 +0000 (UTC)
Message-ID: <3c5f2db7-9190-4aa3-b69b-c9dca8a2998f@acm.org>
Date: Wed, 22 Apr 2026 09:30:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ufs: core: Optimize ufshcd_add_uic_command_trace()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>
References: <20260417213027.3506742-1-bvanassche@acm.org>
 <20260417213027.3506742-4-bvanassche@acm.org>
 <a186b02b00694be3e89cd49d477c050df4bb1cf5.camel@mediatek.com>
 <31c4e534-80e1-455d-8057-8b71a7616de5@acm.org>
 <24b3f4f1e6d723c6d0aa5a559fcb142b32e0c9be.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <24b3f4f1e6d723c6d0aa5a559fcb142b32e0c9be.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/22/26 12:52 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Yes, you are right! In general cases, this is true.
> But for some error cases, we need this trace debug log to check
> if the hardware is working as the software expects.
> Maybe the hardware is stuck or something like that.
> Therefore, we still need to read the register values from
> the hardware.

Hi Peter,

I have started testing the patch below. This patch is intended as a
replacement for patch 3/3 in this series:

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a44ef7e97125..76416ee88b25 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -460,20 +460,19 @@ static void ufshcd_add_uic_command_trace(struct=20
ufs_hba *hba,
  					 const struct uic_command *ucmd,
  					 enum ufs_trace_str_t str_t)
  {
-	u32 cmd;
-
  	if (!trace_ufshcd_uic_command_enabled())
  		return;

  	if (str_t =3D=3D UFS_CMD_SEND)
-		cmd =3D ucmd->command;
+		trace_ufshcd_uic_command(hba, str_t, ucmd->command,
+					 ucmd->argument1, ucmd->argument2,
+					 ucmd->argument3);
  	else
-		cmd =3D ufshcd_readl(hba, REG_UIC_COMMAND);
-
-	trace_ufshcd_uic_command(hba, str_t, cmd,
-				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_1),
-				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2),
-				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3));
+		trace_ufshcd_uic_command(
+			hba, str_t, ufshcd_readl(hba, REG_UIC_COMMAND),
+			ufshcd_readl(hba, REG_UIC_COMMAND_ARG_1),
+			ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2),
+			ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3));
  }

  static void ufshcd_add_command_trace(struct ufs_hba *hba, struct=20
scsi_cmnd *cmd,

