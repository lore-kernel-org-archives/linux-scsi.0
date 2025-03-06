Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BF2146A63
	for <linux-scsi@vger.kernel.org>; Thu,  6 Mar 2025 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741273339; cv=none; b=V5E/GVceJhj9sblp1/o0fcegy0SyiClQVD6iI7/EoxfdNEFwGO9NKRJhHay25Pr1saW/1FzKkqocyF1Xy2WAbPrf3CZlb2ayYCC0wvNzozacVGs+AavaqmcHu58N7LIl41q9AwlI7bMOJ1jr3oEVR5ynoLIV7OGh8NBAZoNGpso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741273339; c=relaxed/simple;
	bh=TNHYt9OrG7z20k4JSs77FE0a0Uuxd1mThM9cNp/g3qw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lO0Dk+2xGejBLJeP4zJnzGDalmqWeUonPj8jHvUSQKIjJeSVR6glp8v/N9qIVhxDlY6Mwraxsh3Up6nrZvAts7NS7bFlNoRKHI6cZkgUmIWx3VENpPGJNwLCggYzEFf2bvLSV/WOq5sVhyEBUr87z6LxkVXor9X6tzUcLG7v8Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=axjCXDg0; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="axjCXDg0"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d3e25323cfso6307575ab.3
        for <linux-scsi@vger.kernel.org>; Thu, 06 Mar 2025 07:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741273336; x=1741878136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=85jq1Q6VP5GwImlSpp7X1r/ay/vqE02iBEhuFPnO6PI=;
        b=axjCXDg0hfRlXe9OQhPPPI6BBGSflFi9vI/4gF7FbrKEOWLGUnBs9/Q5yKsG4Lp4Of
         g5KpvfUtsCN0wu72WiIaFc6KalEqI7T9RwJbpCtCu3ivCEewAYEChUQdyrSG4ukwKFcf
         ZDxmhbqZTnAUs/f+VyKrS0zVDPv5OebVbbaIFuhZQZ2bR4pQERFCUZo1SNjAJYUlT/L0
         Ch7zv35rCo20R5rgjvk4ewapIQyGWILC89uxWEpMbsFTOmKyotoyP+tQEV1UlNJASevj
         D15q4sh4YgZfqfJLzVQueJHuoFQaLwMrHn1Dd3adkx8CWtgTgfQL2MaowirUE67c+rrj
         R5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741273336; x=1741878136;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=85jq1Q6VP5GwImlSpp7X1r/ay/vqE02iBEhuFPnO6PI=;
        b=TfzvoRFNEKENKt+o7Jh6MvknVVFZiQ+P60l/nCNfqVtYT3sxxq59yTkYv2LSjhHcTw
         s5WHUg46DgnXzK9qglXMcIb3avnm+ID7ug76lVTIl4ephTLiINL8maf+YjQYJXVQ6U+H
         ekPjXUvdi/A731rGsqNH0Vjze5saXC46u4ZEA9E7T/beOHIr7R1TVPS5kB8X34tsTQkl
         vh5aYvGn3FNQwl1n/ewsvWKg/XgFrA1hh6RTWY2s5ExOTW/DlyS2Qnh126umRAr3BGi2
         30Tu3LWEnVTUx2hMVCV2D0y58ToltM/6oo8uqxTxGAP0iUqq/hB20wST8XWYRQ9fDY86
         nSBA==
X-Forwarded-Encrypted: i=1; AJvYcCXcTM/hjrhCZBMjFaCOx3zsXxpwhmhr7f/xb4cUPApoZHcN1FP4dxd5sxn5HtgN+3KqP8MuhAJ14D8m@vger.kernel.org
X-Gm-Message-State: AOJu0YzqRWuINqGACbLD9mhG0yGBK7t/8HIqVWIyQx1UrNz0Cm/8+yGV
	UUUcVMhtE7AcL1yHdFsFoHeV9pQTeL0IEVtoWOlQmqc0KWdacYcv7UA3mzEA8JK5vXksLwELdEl
	v
X-Gm-Gg: ASbGncsc0Xlz+3sYuc0fb7DtnucneZWpa2RySZeaA3m0ndCbmvsG6NmUHqY8o+Xa3MG
	fDgUXHRNQbvc3hJVwIsc5i2+EJdwLtGohaFulMrL41jrzVzdD8y6LOGglRXcWJi+OZif9WfmjDb
	LJ3nQLkcJvYJqeAY5qwXSuBX7JI9/Pu3p9gzVKVjfrlztbsCthKoWV2AlBro0VZ/olBDtX2e+2s
	U36TrnSdQUy5NTwTVXcqHvvD75EVcH0Tsp+UPFxtgSYc4OiSPHQ+7KqP7LjNDfqp55ci8T5IAu4
	b3VixFqnTJ032yq9bepycMUOvQKGxO0fcRdJ
X-Google-Smtp-Source: AGHT+IFLAobN1y/JaLFeXk9mcMrXNaETTC2QGpW5wyvCdzhLBlyXi27OPaIuZlvogV6xlSSS4u8ADg==
X-Received: by 2002:a05:6e02:1985:b0:3cf:bb6e:3065 with SMTP id e9e14a558f8ab-3d42b75767bmr95773635ab.0.1741273335734;
        Thu, 06 Mar 2025 07:02:15 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f20a06a6a7sm375874173.134.2025.03.06.07.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 07:02:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: hch@lst.de, martin.petersen@oracle.com, 
 Anuj Gupta <anuj20.g@samsung.com>
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com, 
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
 linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
In-Reply-To: <20250305063033.1813-1-anuj20.g@samsung.com>
References: <CGME20250305063900epcas5p38bb20587ccf4310cfb0f3307180eb536@epcas5p3.samsung.com>
 <20250305063033.1813-1-anuj20.g@samsung.com>
Subject: Re: [PATCH v3 0/2] Fix integrity sysfs reporting inconsistencies
Message-Id: <174127333427.62743.13850185317855218553.b4-ty@kernel.dk>
Date: Thu, 06 Mar 2025 08:02:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 05 Mar 2025 12:00:31 +0530, Anuj Gupta wrote:
> Patch 1: Ensures DM devices correctly propagate
> device_is_integrity_capable
> Patch 2: initialize nogenerate and noverify correctly
> 
> Changes since v2:
> Ensure that integrity capability gets propogated correctly for all cases
> in DM (hch)
> 
> [...]

Applied, thanks!

[1/2] block: ensure correct integrity capability propagation in stacked devices
      commit: 677e332e4885a17def5efa4788b6e725a737b63c
[2/2] block: Correctly initialize BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY
      commit: 85f72925000e924291a0ebf63d2234994a4f22bd

Best regards,
-- 
Jens Axboe



