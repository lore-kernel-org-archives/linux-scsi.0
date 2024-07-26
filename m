Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408BF1F951
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 09:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721984790; cv=none; b=uh9RD/EgHgiMejEQm1HVgG2wmk2TqMyrI2H6mJo1R95kmidPJ0PNLCUsIkt/aJigMeo22q7SONiGDdvE6Q4XF/+cE8vJpMlGRRJmb3LP9NDVFQPmNKyjitZI2XDPL8Bd6CQWi9F14+BGS3RveW1YwPxnaL3AfSdq1pc7KjkIuLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721984790; c=relaxed/simple;
	bh=r9hh7rmI4+UZprApW09TjVP0MvilLIDvOb79QseABRc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=nQeL3FDmb8iuHO+YVXHyqaa1cfb5IroyTffmVYi6+SE3sagza8agAYUcBRAUc9f0N/N07GBMiKBKHozmaS7bulaW4mIhRFKuZ+Ig+6jIf1Akn0Pa/koxT9RiuUc8l5tdN4vs1RC1JU4Yty/gmW7XsI85hdCsLwq3QVe3kgHuzZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=pbAq72pM; arc=none smtp.client-ip=43.163.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="pbAq72pM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1721984482;
	bh=xKvXUZ7qgXg6VeUnLivu+XAlcj69Ig4Kk627jbXh+xo=;
	h=From:To:Cc:Subject:Date;
	b=pbAq72pMpEu1qwEyHbBNdo2vJST23IJWPaGmWGUEl6xbG6p3LHUODSZgKk5KhJW5v
	 4EG0K2ISLlfDjZYnS/WRIjZfbGDIF5sK5JPvBNjbl1EwLaP4kz4MjcWuLhhGdRMau+
	 ByLrKXNqgSROuDtkI1diIg8QnlVfJc6KSm9CHt14=
Received: from xp-virtual-machine.. ([111.48.58.13])
	by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
	id DCB82843; Fri, 26 Jul 2024 16:55:11 +0800
X-QQ-mid: xmsmtpt1721984111tewseevie
Message-ID: <tencent_E821B8DA466472675139402A7A799C7CCC0A@qq.com>
X-QQ-XMAILINFO: NC/J3CrDtaBbLRE3EsErpwOk1dy/P0cufsue9EzaL1tprbd4x9vSlzSnR3s0a0
	 DUA+j6zFgaaXBZi+ytQ23y7vQgKkMe68dDsiymEfC3+nYcLzcm74G+oBOUBkBD4fi5lA5YPvko25
	 PYsr9W4lAK3MFjQpwKt7TCcDu3DCMjd5dSu11jaKh1x+PZBhaJqt19zBvhppUSDTlR15gJPNHcqN
	 rjz1CqRGybl6cPJ+m92BN0a8HGJGqK5h3VE49h42qENiUDRbI+AoQ0EczMA7e9eQHb/dcqwxbLIA
	 hX0w69moHnLSu4P8D18EtK6Ka+xmZMC18FWGmfSQrx05/T0+g445FnVlKGCI4iSBeuwnxw1pp1iu
	 YKvhTmy4Pl0/3/5+g1/Q//Rp9RuQUzYoGJkBqxEsBgaZRxQ5ZuqYSf5JSqZW7XgfIhB6FkzD6D9A
	 HjWiK+w91vZ3DJKRoN/WwUErg61+tVij/6Lm2F39WY0m0/XuGKwtrSr8N6r8BIhdfb3WFlzzBbHl
	 FfJvi9iczh8HUWseQGBL7DGaCRHaUbE5Ai/ovT20SEa1bpXtW7MbcFpJztBeYCZanPNuLlmangzR
	 zJ9qw/LODucou5LzsZ/Ur2ZVeIOEnlE3SmyLj32KoH3hd9ZKP4cBar2pTH8aXrjmp9225w7LYees
	 d5kMJxLHuK24blg3CzLLGcW5UOaoP/z7JO+xDu3p3VeOtWMp+FaYa0gUYlTef1h27XVYAXczadEV
	 tXYwsMsrJrKvx4btyuWw9JrfGYkpDZXres/B6R7OpExo1PREeWn1PCrY1pATwS3UP0+un/SD3U/v
	 WGyTHBmYk/ZIyNUQBVqvW/EDfyiMB8Ea2WQQ0zCyGT1a6ikoB2Qyqn3SQAOaFkyQ1/oMDITYwX5s
	 4XANvSNfmxH+Xq5N27RRSBZ0H1RrSu3PAorUeeFnWa0E8DGPpxZDAzjLStVmFHXINNrQwho/U7lO
	 17a5sf5XnVT3KtTmElhPfVQZffqFxvNLAf7Yo1Iz0=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: xiaopeitux@foxmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org,
	xiaopei01@kylinos.cn
Subject: [PATCH] scsi: scsi_debug:Use min_t to replace min
Date: Fri, 26 Jul 2024 16:55:09 +0800
X-OQ-MSGID: <6fcf18735ccb6415fa8a5fab4286970a3ec941ce.1721983721.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pei Xiao <xiaopei01@kylinos.cn>

Use min_t to replace min, min_t is a bit fast because min use
twice typeof.
And using min_t is cleaner here since the min/max macros
do a typecheck while min_t()/max_t() to an explicit type cast.

Fixes the below checkpatch warning:
WARNING: min() should probably be min_t()

Fixes: ad620becda43 ("scsi: scsi_debug: Implement GET STREAM STATUS")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a9d8a9c62663..bd24ffa68e85 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4886,7 +4886,7 @@ static int resp_get_stream_status(struct scsi_cmnd *scp,
 	}
 	put_unaligned_be32(offset - 8, &h->len); /* PARAMETER DATA LENGTH */
 
-	return fill_from_dev_buffer(scp, arr, min(offset, alloc_len));
+	return fill_from_dev_buffer(scp, arr, min_t(u32, offset, alloc_len));
 }
 
 static int resp_sync_cache(struct scsi_cmnd *scp,
-- 
2.34.1


No virus found
		Checked by Hillstone Network AntiVirus

