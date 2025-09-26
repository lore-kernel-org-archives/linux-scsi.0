Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239332AD35
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758907968; cv=none; b=FDcQG/16GBRjmgMccI4/Ql16Vh957onDB3FkIHClK2IggP3oxn/Bm7bm3ry9HwNjigP681OCiONNL9SCB/vhnQPC+nttpba88uTB2Ogs5Fbfq7WOlYmd0hzwC+56sIGm/dGQLuM5jqW/f4j5789rAzHUeBRGjoKYOqtwQea5k0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758907968; c=relaxed/simple;
	bh=ddat+5U38gJK9Wm+9TXNXRUTeqeTBtOjBt2FgZpLg88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Aw/M7YNR762F1auCL7j/H/JV1b5X3iWBrxAJDFqg4rj40pCK4sjT1zwz8chcFbayB034g4zVfRm0RK7OxzQPO9xtaou9w45EjmBLUYup0/XBqBiv3f0OzLzPJkdQxAGMSxD11nzCbEb2I4qmDxyywgUYbsM3Gh0b1fYYqtEq22k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xeqlMKrZ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xeqlMKrZ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cYHjB1LDQzlgqVf;
	Fri, 26 Sep 2025 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758907965; x=1761499966; bh=r7z4HRWbqcX+fwNisNwMFnrw
	stsMUj8SjpJJyDl36Io=; b=xeqlMKrZmB8/XpRaXVYYiMg8NMhR2HBEzJ0zgg9t
	zitLpGpg1sqCszTKKxTMOX2Ne/kjDw/AK63GRRJPwjFQGhmy3ETlHhLKgLR75wM0
	z1ar6jXEXyoJFtFQ6b/4q2auwFWEYPequbu85lQL0hU5izT+mdZbrGGPRn3IBzaA
	nvkfxC5mo/p3TOidzGyy93EWyjcnY2XL8/Sa2/UmLgJQ8uuE36zQjM17YGEn5o3g
	bX5wd0Xkc8e2V2ElXAuBvIupD848dKvoF1jvr9brGqDmT4a/pjRPsSjGWvCLCGkm
	BQuXUfkHK+EmajAcJXtwfl/YsZQoPWLJ3XautLbNA9VCmA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0sXw2wR5UzDb; Fri, 26 Sep 2025 17:32:45 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cYHj755XVzlgqVh;
	Fri, 26 Sep 2025 17:32:42 +0000 (UTC)
Message-ID: <27e9c889-ac42-44b7-b2e8-aa456aa335d4@acm.org>
Date: Fri, 26 Sep 2025 10:32:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/28] Optimize the hot path in the UFS driver
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <dab3464e-7f60-4843-aede-6c81a348da8a@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <dab3464e-7f60-4843-aede-6c81a348da8a@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/26/25 3:08 AM, John Garry wrote:
> Did you notice this when you tested?
Yes, but I only noticed this a few minutes after I posted this patch
series. I queued up the two changes below for when I repost this patch
series. The first change suppresses the kernel warning from your email.
The second change ensures that ufshcd_get_hba_mac() only prints an error
message if it returns a negative value.

Thanks,

Bart.

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 511cf84c2f89..5e7ef4655348 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -225,9 +225,6 @@ static int scsi_realloc_sdev_budget_map(struct 
scsi_device *sdev,
  	int ret;
  	struct sbitmap sb_backup;

-	if (WARN_ON_ONCE(!sdev->budget_map.map))
-		return -EINVAL;
-
  	depth = min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev));

  	/*
diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 9303687e38a8..1fa0f14dd291 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -156,10 +160,7 @@ int ufshcd_get_hba_mac(struct ufs_hba *hba)
  		mac = hba->vops->get_hba_mac(hba);
  	}
  	if (mac < 0)
-		goto err;
-
-err:
-	dev_err(hba->dev, "Failed to get mac, err=%d\n", mac);
+		dev_err(hba->dev, "Failed to get mac, err=%d\n", mac);
  	return mac;
  }
