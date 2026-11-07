Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794069333;
	b=fUfb0iEzY5nwQAxGrAXPXdlhaIivFRE4C5CnEmvPxdOcBnfjkfni9bjVQZvzI18Vq8HJ
	 ilszZklHW+v8DXcYKiCT5fgxaDSaAIv7NvPs96W4JcpxHGe9YIo7fxPEV69x2peAeJCmB
	 Tzg71IkcHKsY/WAuCJZKpopKR1tasJFc0mv/+xdpFRGCkQYNb3eJm1mgwTLYcxKQiEEbm
	 l/5F3xeqGanlLsXy9eSo4CaO8pAn3kU5XUg+eQXfKMf3O0HGU4YDNL6ZIi+/TQTzQRcS7
	 kC3GeP06Ry2XFABLAzZG0Dponl6IW4uw0sr8zsm+XN+jt6qNLrIyWHoHO7yWB/WastQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069333;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=vpx8jpvZit1mrMnK53mn6lvyf/Hr8HxBYVCEMXEzzdI=;
	b=rdN35LXUn8HFdFcnjq1nzqKANzBeB90qeQhAwC6bjKH5rKgXci0Q4gpGOJ0dz+6rch2p
	 uYSGhbCOna0Vgme2kBkyMYqC8tYGJFLELQswmIHmbweBy3ejBx4HDTWaVOI4TK5gNvoED
	 aXrt0sTOsA41il6O2HIl+puRO6RCsYbxv5tHWVxyNJnz6T9zU+o3CrZcrGCBta8mBECDj
	 NMrnLL3c+rvefyshMNdXNNxXvGw+4Ig0XnEGUUuqTPQIjsElbHOJNkTxy+fSPL53tCkZI
	 9iamxWVpEmcOm+jEfgggE/Y1a3gt9o0kjcOGA7tCQKC08TRNj3V6FRAIx8sAzFwXe3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=TbrZZA1B;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B968C606A32C
	for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2026 16:35:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B968C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=TbrZZA1B
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdadf7e248aso600296a12.3
        for <linux-scsi@vger.kernel.org>; Sat, 07 Nov 2026 08:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794069332; x=1794674132; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=vpx8jpvZit1mrMnK53mn6lvyf/Hr8HxBYVCEMXEzzdI=;
        b=TbrZZA1BRm+Sy0qn7deY4UysaYGNgo1OVyYeTt9YSwGUJ/2DYx7c1Gr/1QE7k9t5Nz
         PXOuh2OiqSfIzKcXXK3vUPjfWm6tqfhuQ3TONFWqVyhrIPTGA9XeXsbi+8yGvUBOkNkP
         CquXDLXGxoUU0NvXIh3t7f9fqE10jnZCV3sWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794069332; x=1794674132;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vpx8jpvZit1mrMnK53mn6lvyf/Hr8HxBYVCEMXEzzdI=;
        b=QpnT5cMHzdD6g6ac4DmD4ztDgAixeiWQKP9CASSccZe2imeJ44jUteAxByUBrIAXgD
         6jobHPkZBRyj5SwOZ2k+EvhFNod9qTaAf3YjrYNsYOmIO4WO3He9WPKAVk7ZDOp7Yh8X
         gkE41mDEfY/VdB4EiJOck9i6GSfMVJylrr3RDqObuBXPZLA7Xc0zlAxTP6W/sW7Axsxh
         KYtZ3f3cdjWU+sT8Wq+RSLUQCmKOXybnDeeEG92w8biFWvNMG/M+0/iQ9NL3sD1iVZVf
         7g5SZE/werpX8oGLtu89LRnbsrTCN/3R8HumZrWitvSun3FYaWr0St8wGQWjfurQ1ffD
         DQJw==
X-Forwarded-Encrypted: i=1; AL+hErEMbwycgkUQYRniq5Ni4l1DkjbFQRDjjTPtjRH61ih7l2Ob9wz6Z6u6UojHJg2EFaQbJDUXXK1EcJM0@vger.kernel.org
X-Gm-Message-State: APuU4Z+5XTUuSvgU9o6f6MDXxj0dXorpVsIieFsEKZ+NulVNw5D2KOqz
	vnsBLcuazENk/VusE/FRjcmT1gWyluH4TL90FihYw9XT0DEM2qW/uaReBq2zD/+rbf8=
X-Gm-Gg: AYBFou3UswKYAIXS3UTiYwU43vXk8WRLV00DlFRvayXwWHoIDubK5UIFX5sZgrZq0aS
	sPdM/AugGgLmWqD5Qtlm/jKdmss7hICZ2eZQvVoykxf+U2z46QTsfgG2dYfe11CYkAoaFt+Fuh/
	LETdNvIOO1QWVMcyDTN16BpNAcJYzpxjjcW07ZrKSBfGql9aCe78pQr2bFVvQ9MjxWTVmMASTJZ
	byfp4xFqSunimRd1DvgrlJbdOt7Q12J5KfQiDfMzHLpO5efxi99BQIlCj4eP4SaGqO4HHQeklCG
	eLx/KYIbfo3nHUufT3PMPh7uniHv0TfUnDpZ+V8of8kkhMAXh9R6+h+AvifgXmsoRNB0/+xggZW
	R7vKMe/FK21l1Va9rWN6tXWDIetGnGms5kpsOpR0BV2+boq1CRtPHJA27TNGMpihOhco2aH+cVC
	qrS1B1BOJ+b93LDr2JChsTsFytzP5dtNk/U/6qMmFZpzyRTdZL3MRDGaq1Gux/a5zX5UyPE/uA3
	kTsbPVYV0hsyL3OHnwp3JZJbPqTNJzhJMdF+pLxY9hro2ayaMG181w3l7zTIxSsMkThW2xOFgri
	mU3qZi+A32jA+OSngA6yXiknNgESQBIXgJ1peuU1Mp+CE+J/IQ2vN7bSurpq957RwT2kdWvZa1V
	7gLhg2JQKG09E63JZx+FT3PJEs5PpEUEHin6x2ZfrDtNqwusKDN22gz4jO1+iDUhh4TTt8rMd9c
	8hvrLRfDN7CrQ77cQitOf++o24DsrP13AY+kBUxnMrcWk59m2LQUCL
X-Received: by 2002:a17:90b:4b0f:b0:39e:4c81:6c5f with SMTP id 98e67ed59e1d1-3b0db6e5c68mr6010349a91.26.1794069331989;
        Sat, 07 Nov 2026 08:35:31 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b10588225asm3741301a91.8.2026.11.07.08.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:35:30 -0800 (PST)
Date: Sat, 7 Nov 2026 08:35:29 -0800
From: Chris Down <chris@chrisdown.name>
To: "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH 2/2] scsi: sd: Fix data corruption in WRITE SAME(10) discards
Message-ID: <c58578f870580f92d1acd6cb73b59b7a7867d80b.1794069087.git.chris@chrisdown.name>
References: <cover.1794069087.git.chris@chrisdown.name>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794069087.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)

We already cap the discard length in writesame_10 and writesame_zero
mode, but we still truncate the starting LBA to 32 bits. A discard at
or above block 2^32 can corrupt live data near the start of the disk
and still report success.

Discard is advisory, so return BLK_STS_NOTSUPP if the request won't
fit in WRITE SAME(10). Discards that fit can still go through.

Fixes: c98a0eb0e90d ("[SCSI] sd: Logical Block Provisioning update")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 drivers/scsi/sd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a28d11886aca..9b8530267b4a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1131,6 +1131,9 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u32 data_len = sdp->sector_size;
 	blk_status_t ret;
 
+	if (lba > 0xffffffff || nr_blocks > 0xffff)
+		return BLK_STS_NOTSUPP;
+
 	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
 
-- 
2.54.0

