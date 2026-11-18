Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977418;
	b=UIwo0/Xvr2sEShSp9wh+bqbXaVWlcIIvmSOwOaa2r73wBhHqyc/PkEDhTiA17Kcd0Tof
	 yn4rGunwzdF+v8jFvoknKKJS2GySbjIvGVIkEaI/0dXzLEn/eU9J5niA+6T6R0Fs3zTNL
	 tARmeOQnqSri7hPY2t47VMlDszRsif7U3Rh/hxFRSj8dLelKEk6G5hhrrbEx7bFvG4Hub
	 rdeW23gt2uT4GZt1cyvSzUtnLgILQqMsaRBCMJ4OpYJQiubP50eaV8LsBq+88GhjKrlJZ
	 fvH4J5PP6NHRQwbHUdgkU2lzGj7zUCoMa7NkpFrwE3tY4dTht0ftXby7BER8buB/Eog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=+2jvL4JNKlSe8jf1OkMiuLniWO2CLDkzaNhl1C3qeaM=;
	b=3lQ1WoPUZwOO8yWgKzJh3dOPsz1qTSwfrF7nSgZyaaioQ/JKKfEuVhzQZdeP6bBRvKKt
	 PqxsjqBZNX2M9ROV7/w4CPqHnGvdPjBPu0pNjhUfla+PrFNYIdfrrnqq6VleemMeNVQSl
	 4axNNdqI2RvfWYV3aPyLGjpCEkFKxRpOQPi+l9AN07CEBw7c/bWLdH4h+icJQGUGX6O7s
	 tbw6h9R32RbCdFe3O4Jpot1+xU3CHUnp+3dI+lClcjPb4TZ773Csv0DtmmBcUASMvGTwc
	 8FajwIKiZKtPAHqbiiRKplnGKlCFgPSmE7n0GGbK06j86eNaKKaZe9q1rUmXnYVjCnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HA9Ei5yP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3D6606A31C;
	Wed, 18 Nov 2026 04:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HA9Ei5yP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFCD1F000C4;
	Wed, 18 Nov 2026 04:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977418;
	bh=+2jvL4JNKlSe8jf1OkMiuLniWO2CLDkzaNhl1C3qeaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HA9Ei5yP5vxe5bhMUHZf66sS8Wv1eUpl/20MYdF/zyB1Db9lg4oY3r7/DM5gUcj0B
	 HFV3XpCO8rHhn4JU0xyxEUjqAnFmG4To1H0mY9W6HAATIh23wHfJBVzxUjYvEN78Qx
	 KqXXe6UOqcOwDwz/+WK4my1BXemQ093Q0uviA8ehdgy2xjkXZVt6HbNe2vRSwCt761
	 dvwucAbOkpTQuJyJzAQ3IC8jqBdsCOxraFhZjVjVjD3BoyQQzLvpzxAcrYGzwBOs6+
	 U2iZP7oRJVVZNGconJ/sW6RVVBLdV1EpMs6x8QHJ/Ldw+woY1taBDcLYgjYfwTuhtv
	 /oWUfP45j7fnA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Brian Bunker <brian@purestorage.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] scsi: core: Restart the queue when unblocking a device set running
Date: Tue, 17 Nov 2026 23:50:09 -0500
Message-ID: <179485091819.1479907.9990858567236462228.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261030175721.24379-1-brian@purestorage.com>
References: <20261030175721.24379-1-brian@purestorage.com>
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

On Fri, 30 Oct 2026 10:57:19 -0700, Brian Bunker wrote:

> A SCSI device can be left in SDEV_RUNNING with its request queue stopped
> for good. The task that put it there hangs holding the device lock, and
> anything else that takes the lock hangs behind it.
> 
> This was seen with iSCSI when a session drops again just after
> recovering. The error handler offlines a device while its transport has
> it blocked, which leaves the queue stopped. iscsid then writes "running"
> to the device's state attribute and store_state_field() moves it to
> SDEV_RUNNING without restarting the queue. The rescan it starts sends an
> INQUIRY that can never be dispatched. When the transport later unblocks
> the device, scsi_internal_device_unblock_nowait() rejects it with
> -EINVAL because it is already running, so nothing restarts the queue.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: core: Restart the queue when unblocking a device set running
      https://git.kernel.org/mkp/scsi/c/dc7ba60d45b1

-- 
Martin K. Petersen
