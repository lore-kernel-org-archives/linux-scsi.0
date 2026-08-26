Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973F9448BA3
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 15:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757530; cv=none; b=g0/ZY6LlI8fSzfi5pXkZ+3nCyGHrlTyyttjcLJ9IZ/aIRXQ9HU/16ZTXU3iVjmhdan5fZKASrsLJN/tYMWlxr/HL/HLcRHKjUrlRFIv9eIKvqGX9PABkpLOVgQ0CZAcfPfD6I7xe4S4Ot2AXH4V+wv9vVeKjkkT1QFHHafie54c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757530; c=relaxed/simple;
	bh=mdIFFSYMTO1qBfozLcRwDaC//UZKhRjmepl0G2Vdt+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PF7aSwMayv8PCgzYS3adLpAqMbPlw74gmv2ihpmdkYGt2vMRzi7XSTAbMENN6t32YNncc0LyDfJGnYRifz5IqaS8JMfHoMI8m6W5QV0IW4TkeOboZC0w/4WFIk7wzFsj/sMZeNECfuxp2sv3Obqf5SRr77b5Dh6SbhCLvzFqJKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2A0Ml7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2A0Ml7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610F41F000E9;
	Wed, 26 Aug 2026 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757526;
	bh=VUpkhJJJ2HaINjXSqtpnCWE6w796XlD3dYGTBGVBZac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2A0Ml7Wi2AE/w3lSzVxj7Y4XejPnB/2peUFaGrK4xWGcjxZ6q97ZBGEcq3qx+Zqs
	 hYkF0gNW0r8+/+8+F7N5qRYMf7c8wEALfsiUmdks+MAWdCqRmXmxi0hG0uczSRk3BO
	 ST1oObKCeC/zeI1cSE7thuXFZkvEt+ygOIKiaD7j6nSqzoDVzmb8O1Owb9Vb2twAFu
	 V72lmy4HbrgAUqKfYKVI6Io1FI6zAxzM+g7VH9OIPHS3PGK8Sb6Z7fGhc5KdPqtm2k
	 Q9gUwhCmtR8bVGyymbpYwVC0H+k5dxj9bRXEBNR2mbph+vM0lufubFGSGdNWrJ7/Jd
	 7I1N6SuD9keWA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Enable context analysis for hosts.o
Date: Wed, 26 Aug 2026 11:18:42 -0400
Message-ID: <178775714064.3862282.13326172323276262259.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <3e1c3c0ca9307e2581cf4b96cf3fcdae35202255.1786724393.git.bvanassche@acm.org>
References: <3e1c3c0ca9307e2581cf4b96cf3fcdae35202255.1786724393.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 14 Aug 2026 16:20:08 +0000, Bart Van Assche wrote:

> Enable compiler-based context analysis for drivers/scsi/hosts.c by setting
> CONTEXT_ANALYSIS_hosts.o := y in drivers/scsi/Makefile.
> 
> The SCSI host management code in hosts.c now has the necessary lock context
> annotations (such as __must_hold(shost->host_lock) on scsi_host_set_state)
> and conforms to compile-time lock checking rules. It builds cleanly without
> triggering any context analysis warnings.
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: core: Enable context analysis for hosts.o
      https://git.kernel.org/mkp/scsi/c/d34a88f53a7a

-- 
Martin K. Petersen
