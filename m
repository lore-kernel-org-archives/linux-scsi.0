Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239392;
	b=aPZTRY4+g/Wv7Qd7V2V/0HD/yLlaAtaYnaOk27TQmAxTfQe/BW+iJWYZMgryut8qAHt/
	 7ejmoYukiaFQzneOYDrbf+SrqNKycWx/tqYP+RTpZqdMXun2KJmuJXsDC0quDSoMjSkpe
	 hRSOZxSa98MKETDxh+D0v2cF3lZxoQyTK1oludPIzUdfCDklB9E8TqxPvkKDhSL4lyRMH
	 bxTbHImkowjx6ep7W+xj2MGp9rGzzO+18MV+NZk60XQQ6WGbAO4/RuPRXXc3UcESCdNx9
	 3cJSKaxqjhqNp/RHEzQJ9tnAO5moeBkM6mWuVOzadH6MIg+dzyyIvm+3R510YM7+y3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=3JFRAUkzRhTG7w07ynQ3Bn9PUKRkX+0anMF1vW2pBVc=;
	b=iuJwuQ9bpu8vnw69w2HjTQibSliouX6Ys5tj3ahXDvxFsEIVLK+9GfDZptUgyVfyG79k
	 K8HPFh28PnQ4qQJiR1V5vCUK+8yKRTT77zoiBFb6dkngOkNgB5CS4/SMUtC3rhHdisvIb
	 yrGFuuBeGU4f0zW2rOiTW1z8qx5IMvbDwq83Dvf8qKPZAVy5lDQwO46Gc0a0KVz1vLS/k
	 arRcr8zVNVkowGQ60nXi249z9DpQnIh8t+JJuCfeUIT2tjJT9wx5mZamWHF1zVPb3LlHA
	 IWNXOyfwmgajEK3PDaYcjvS8iyNF8RTHqp0bnts7gzLy2BewaVpMfAkWnZSU9mfqrlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fcY6GK0H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843FF606A330;
	Thu, 29 Oct 2026 02:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fcY6GK0H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640D01F031E0;
	Thu, 29 Oct 2026 02:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239392;
	bh=3JFRAUkzRhTG7w07ynQ3Bn9PUKRkX+0anMF1vW2pBVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fcY6GK0HVBXdHkTSiSjD35v4hvrFhGt/2LzuFBDhOMPQIC2OIh7GvHSQVIKDH2Q/V
	 DmB2cWBiTay6a2JORalKm6VJYI8QxJ74Ox6RvStVxzrCEzRmRJROUGnDxKHVie15wD
	 H4YDC9znfYcsr8/QvulN7+mgKg/pzXRhaHIuRKnf31SUOZvdrwbfUg053dn19oBn+m
	 8DO86zKgjgdMrVfYKfM25AnhHarz77r99tqclLcyDB0GGNP6a3v8pPtn559JiUJiCT
	 pW0JfcB4O+BV2mBFDFJzZDgdmWnu703tcdc8H7gIxYGbI1iELWXM+icDCQaloY5zln
	 PIzux/M8Fx8RQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Lianqin Hu <hulianqin@vivo.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: Mark the disk dead if runtime resume fails in sd_remove()
Date: Wed, 28 Oct 2026 22:02:49 -0400
Message-ID: <179323465385.491807.4200261615139182816.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <2c0c76d70f0fe197932836b9bcf8496095135d1b.1792446921.git.bvanassche@acm.org>
References: <2c0c76d70f0fe197932836b9bcf8496095135d1b.1792446921.git.bvanassche@acm.org>
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

On Mon, 19 Oct 2026 14:55:32 -0700, Bart Van Assche wrote:

> If a SCSI disk is unplugged while runtime suspended, its request queue
> is still in the pm-only state when sd_remove() is called. The runtime
> resume attempted by scsi_autopm_get_device() fails because the parent
> device, e.g. a USB device in the USB_STATE_NOTATTACHED state, cannot be
> resumed. Hence, sdev_runtime_resume() is not called and the pm-only
> state is not cleared. Next, del_gendisk() calls
> blk_report_disk_dead(disk, false), which calls sync_filesystem(). Any
> bio submitted by the filesystem waits forever in __bio_queue_enter()
> because the queue will never leave the pm-only state and because
> GD_DEAD has not yet been set:
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: sd: Mark the disk dead if runtime resume fails in sd_remove()
      https://git.kernel.org/mkp/scsi/c/085bb18a0b91

-- 
Martin K. Petersen
