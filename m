Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239403;
	b=vtPQIL404EcjcvPOE0PGi+uZKekNdBeIyFl9kCTUhWJIb4wxQyMmqwT2POwCFDhHoovy
	 KyEqqLzz0WpqVaqEgHBFAhz7CBOgmDl4NLlabKI/1DiXopM4ImoXnT/gxFktR64tfhUJP
	 RdQiW5D9Te5x7Zoq1ykBNaw7KmEphgIAMrVukE+sgHPzS3UbOFKqbpjzRWXjR1G7QAdP/
	 kQWa15fWQFcm9E7J4rNjdJxw1ZTVdZPlPtOWzrsL5oorkU1ZGy3SWWavTe4zP8O0+xvxL
	 8vREdOFkQuagvVPTXlb99N7bLsTTH9fkFtRAZdOcRZd+q5dDJx3CW1GcdXj0mXbismg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=kkQc70oVksqdbEHEl+DL/6+OU0ag3dkv+ZKz50Q+rqg=;
	b=SrxssNL1TjrPcOij7L/kfqn83H2XrgAE8KVIfemhmPxuLguBk3LsJCm/Pr9/ZQOzCMCJ
	 K3tO0doyF3p9TsxkuQ/6M2jnhdMdHv6SnKPXHgpXm7FjwWzI+zY3FYWspoc00gMJxP8lW
	 lDY3ysjFT0/VGfRwPYxKqwpbPGVcYny5oNJas1QSSmuJUzwxZljuBRRzODDlL+8PUq9Ro
	 ZLd6kue4PUn3WA8df+rdL9gieGhmUSWWEc4lVVsjNULp4d0FksovE2OG8k9lGR2W33oEp
	 pfSHMqKiPcXrmHk7+12R0501TCnUywBLtpI/wsgZaM9KXWSlNxw3NAwTgwqN1nwnJ2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ns0rWLZK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845DB606A33D;
	Thu, 29 Oct 2026 02:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ns0rWLZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E14A1F031E7;
	Thu, 29 Oct 2026 02:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239403;
	bh=kkQc70oVksqdbEHEl+DL/6+OU0ag3dkv+ZKz50Q+rqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ns0rWLZKFVKnZHk0NTbNpOWLmS1/SVvqtPvOZX1Hf3P2PPJe89v0IRL7pRb+XT6UJ
	 16KMErrxvcx1fljQKivFb0H5216EpRW1MvTd0AQiw5cJ4r5KjXZs60rO6yEAmeCBK0
	 J1y/fZ/f5tggVo2+xxOgt5aAaxLkmIH3JWao8ciXV0T6zWMcx7fH/Af015+9qHQ599
	 xT9Q+E4zy3B3d7k00UQPMauBP/kS/owcx1pnV3PBvrJC4+vvBKPUH+y8EgjVHZ+PVp
	 f01FJUxU94UJgC9SsrcdZ69aWw2IHJzd4Jd5mxF416LeWj6cqU9Fzej0FeDH7xtiE9
	 3b/HmYPtEkd0A==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Brian Kao <powenkao@google.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] scsi: ufs: Fix UIC result byte and BSG request handling
Date: Wed, 28 Oct 2026 22:02:57 -0400
Message-ID: <179323465375.491807.14399231373519507963.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261015001855.3450573-1-stanleyjhu@google.com>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 15 Oct 2026 08:18:50 +0800, Stanley Jhu wrote:

> ufs-bsg fixes for issues found by fuzzing /dev/bsg/ufs-bsg* with
> syzkaller on QEMU's emulated UFS host controller and in review of v1,
> plus a fix for peer DME retries.
> 
> Patch 1 completes failed BSG requests via bsg_job_done() so error paths
> do not leak the job's device reference and mapped scatterlists.
> Patch 2 clears the reused reply buffer so replies do not carry bytes
> from an earlier request.
> Patch 3 rejects requests shorter than the UFS BSG request structures.
> Patch 4 rejects UIC commands with a non-zero result byte from userspace.
> Patch 5 clears the stale UIC result byte and restores argument3 before
> peer DME retries.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/5] scsi: ufs: bsg: Complete the job on error
      https://git.kernel.org/mkp/scsi/c/cc0ce3fe8fac
[2/5] scsi: ufs: bsg: Clear the reply buffer before use
      https://git.kernel.org/mkp/scsi/c/2e63ac76cc08
[3/5] scsi: ufs: bsg: Validate request_len before accessing request
      https://git.kernel.org/mkp/scsi/c/42aa44371810
[4/5] scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
      https://git.kernel.org/mkp/scsi/c/1ae42513205a
[5/5] scsi: ufs: core: Clear stale UIC result byte before peer DME retries
      https://git.kernel.org/mkp/scsi/c/e4a9b7640914

-- 
Martin K. Petersen
