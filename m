Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4A4396597;
	Thu, 17 Sep 2026 02:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612168; cv=none; b=GqfPm0aLg07PhSWq741tt9GeDW2obRK1TKzy8+ruKmlHIQ1bgTUswgqvPA1SyY+gx0HYcSnxhwOnmFDNiNkqCPhLyEZBH4HzM0e3pwWn8KgJ4dnbetkOHUJ6qXl6+dO4POVQWzNN34FKNuJLokb4lbsqO5tk7QXVuzu3tFC1WqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612168; c=relaxed/simple;
	bh=zCCSDFdxIkS8jUqQjqSXmUJwCDuyybfRQjS5rhUEYhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UM+gMRkVABkXhZSAFQpBIxb/p/oIOaiJlag5GR59kgNKa0dRqhicOVHUDJxgM1T1O48Pdf/eLIT5i2xMpTCGiKsjqDQMWB8/sIbZxkVtj5C1v+x/PGQhRpu7tEKbyw571mVSSGGjPyVRnejKJtz5Uubeis2ntC/klhiyhr66Y/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmwQ/tGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmwQ/tGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854E91F00893;
	Thu, 17 Sep 2026 02:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612150;
	bh=wIowrTJuyUZu4vbbX2f81j3pK9bUGyXEG71ByxGSxZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmwQ/tGMAX6EtcqCNRUZAtSsSxWIznwkpEeRF6bgheg8RWFMb4L6Jcg1f0F1P1uML
	 d1yf+fFqUMWUoN701cU/ERTp2sKOlp9pJZMXtdnGoYT89tqDVs8ENFIFcNW3UDtQHo
	 KpiEAI34FyIg6J2d8VNj3bliVzKVWJXH5M/NFfLrQlmcwjrqahtSTA2uLgJSxU2/Xw
	 5k3IEUYTPGDLX1IJjQBuZgylqWrDBQ+myzHXtn9fcIsBqsiusjUcYLHnpP/A+LgJZe
	 cxN1jwLqjgasROxGb3eY3N4QGfrrld63CYsU/U0IVBQLMhUXgi8oZ2ffs17Kq495c/
	 3/nhEoR+Mq2Dg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: zorro7xx: Use individual zorro_driver_data structures
Date: Wed, 16 Sep 2026 22:28:59 -0400
Message-ID: <178952247929.2757716.97989868687826712.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <7deafe83754415c5beb280f3c1808e153029e890.1788169600.git.geert@linux-m68k.org>
References: <7deafe83754415c5beb280f3c1808e153029e890.1788169600.git.geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 11:49:20 +0200, Geert Uytterhoeven wrote:

> Using an array of zorro_driver_data objects and referring to its
> elements by index obfuscates the code and is error-prone.
> 
> Improve readability and reduce code size by replacing the array (which
> includes an unneeded sentinel) by individual zorro_driver_data objects.
> 
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: zorro7xx: Use individual zorro_driver_data structures
      https://git.kernel.org/mkp/scsi/c/6b0f8a689ef3

-- 
Martin K. Petersen
