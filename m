Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B72140DB35
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 03:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950234; cv=none; b=jgEe6AdFjp1q42hwytVW3kTgSagU0NwJGmx0YLX6U760n/Ma2h8qlN+wUNaJv5mRW9vDelr1cGk5VrQjusHoZf/oOeR45Vt2ZVCNOJpNatZAT2oNg/RVSNIfgkRlEwE3veNBRZBzn17ZK0Jq3BzkRPpa465ZKQRrIMvbHOZAbXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950234; c=relaxed/simple;
	bh=lHLzhSXb85GtAb2TnnEv+xrjg23b71tQveTjvt1kX/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UNEObDm14MOc5k3BxAY+nIWpJ+n6GTppCH14avcmPS4QN1uhL2xcIcZNaqaJ7HBiqnTbSw+okQ1c/pw44mqjE4pGYMp09sTF/6Vs5rvcXjfoQliqzInBDzQ4B3rnWujgFCzwKdGG5AFBH5db2ZqWJpz5tt1z6XiccGsReRi7TSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B3lQ3iOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3lQ3iOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6333E1F00893;
	Wed, 14 Oct 2026 03:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950233;
	bh=8Dn/RxQpAzuYSt8c7KWjwdUCav0jCwssVD9n4i30ZDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3lQ3iOhaJMqcqDUDN5iPfDqewwCXyWX2EU/XFgCP3R+vpWCaddT1qDe+IlJtlGrQ
	 48tyGWKfWfSDmApjvN6TJgZ29EAk2gEJXyW8AkBpTZlSMKXXG6ppN1IFP7igUNKr1A
	 C13wFwjJgV99kh5vZ/kULYO89wV0CuRWVOfc+HcVPp9FL3jZbIv/CVsVYZAsChrEv4
	 bU/nUy+EvDS3JKDXeS5vRrMIkneKi8HT7jOBm/wcXfPYBAqx08zjmsUACHct1E5nks
	 p3L8B+cJSiVT4O9MpGyZHEh7KsVNxlrmwMU+mKT2B06hhu8AJ6fM7tvCSKZe+dWu/c
	 SGxkqjDcTz78g==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	Laurence Oberman <loberman@redhat.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: Re: [PATCH v4 0/4] scsi: st: Restore drive settings and state after reset and MTLOAD
Date: Tue, 13 Oct 2026 23:56:48 -0400
Message-ID: <179159633703.2229379.6717658716010294178.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929192821.997675-1-loberman@redhat.com>
References: <20260929192821.997675-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 29 Sep 2026 15:28:17 -0400, Laurence Oberman wrote:

> After a device reset st blocks tape access until one of MTREW, MTOFFL,
> MTLOAD, MTRETEN, MTERASE, MTSEEK or MTEOM clears the reset condition.
> Testing the reset handling on scsi_debug and on IBM LTO drives found that
> several settings and parts of the driver state do not survive the reset
> or an MTLOAD.
> 
> 1. Changed block size and density are lost after MTLOAD or MTRETEN
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/4] scsi: st: Restore changed drive settings after reset also for MTLOAD and MTRETEN
      https://git.kernel.org/mkp/scsi/c/8d1cc285194d
[2/4] scsi: st: Record the tape position after a successful MTLOAD
      https://git.kernel.org/mkp/scsi/c/54ee0ee9bdeb
[3/4] scsi: st: Restore the drive buffering mode after reset
      https://git.kernel.org/mkp/scsi/c/614f37447212
[4/4] scsi: st: Relock the door after a reset
      https://git.kernel.org/mkp/scsi/c/5ba8c6e5ae65

-- 
Martin K. Petersen
