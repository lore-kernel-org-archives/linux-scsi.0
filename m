Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748822AD02;
	Tue,  3 Jun 2025 10:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945163; cv=none; b=hpqgdAZUFYyDHO3M5clooNh9g/06SpsiionvtM2g0qKDmdXZmwY6C/Qvrv7H3NptzQEyXD7x/CrKECJPO4UtF45MJQAKzy17ixzica5Xh66jW98JBKt1F/1JbUvVR4b6NDodbGe/Cm/jEG7bmcQOptvOLpqU4vCIzqxc9+5PnwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945163; c=relaxed/simple;
	bh=K4c/Jse1dnKPuiHqwn+6LHglGjSgOxGtbw6DqHs8P5A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J/5J0tAA9VE5G+ad7dUo8XkG3bFXq+68Uz+OAM0BfL7hFhNC5ZUrF3wuqbHP3KP+6qHo/S3Bxps+d39AOYwlfxB+lHLNBoyEBxxDrqqQu9SnNgt6gI0X0yP0EKqYaRKwJpsJy3CB0CIVtKr8Tj1844OH00/aMVlLsDOGwqqCews=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/uGym2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/uGym2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4250EC4CEED;
	Tue,  3 Jun 2025 10:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748945162;
	bh=K4c/Jse1dnKPuiHqwn+6LHglGjSgOxGtbw6DqHs8P5A=;
	h=From:To:Cc:Subject:Date:From;
	b=I/uGym2vDpP7y32MqMzBW/PcY5hhJd8hfmfAlAEUQvEFJ/gOLtDTt6tYTYnfQ1e8P
	 g2VXrnIxNzrgIlSP3M3XZsO2DvxvY72qNa87gJCsb0UxlU1Q/H7or6tmxTvM2Ev38k
	 qpsinkqJOZXOwPHDf/+SMVQl5Xu1Y7WpARZWkwfK58Cq0e7KvLUqjifv1CEoZADQKY
	 kVQY/1FUo57FcQr/fX6CJCu3Tbk14z/VQIX/9XjeV5Ahcw52r4zNc6Kyw3jsHX8yUU
	 h6QOyrTjGUOX46fwV3j7anvTJK17MCtYCMetDwXOeZ28rb2MV2JmBP5G+W3gGxEERp
	 WXGIgq45ueYvg==
From: Hannes Reinecke <hare@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 0/3] block: expose 'read_keys' and 'read_reservation' PR callbacks
Date: Tue,  3 Jun 2025 12:04:13 +0200
Message-Id: <20250603100416.131490-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

the generic persistent reservation framework already has callbacks for 'read_keys'
and 'read_reservation', but these callbacks are not exposed via ioctls (unlike
the other callbacks). As we need this information if we want to work with persistent
reservations reliably add two new persistent reservation ioctls 'IOC_PR_READ_KEYS'
and 'IOC_PR_READ_RESV' to expose this information to userspace.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  block: add 'read_keys' persistent reservation ioctl
  block: add 'read_reservation' persistent reservation ioctl
  scsi: return PR generation if no reservation is held

 block/ioctl.c           | 61 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c       | 10 +++++--
 include/linux/pr.h      | 12 --------
 include/uapi/linux/pr.h | 14 ++++++++++
 4 files changed, 82 insertions(+), 15 deletions(-)

-- 
2.35.3

