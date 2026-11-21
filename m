Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231509;
	b=sFsx1l0HaR17EztRLxfZrjKcaH9B6BmSfskyEczlt2uz8cS6zwjSKzbROaatjuyYA/NT
	 zUtuvowcLsT/w+xtzroXZF3VNOX273gHBDF2pxIWI6WrLN6DNz3eQdpT+BqkJsZpqcHCH
	 8pm19Sm3bA9K7CfieTqZuYwnO8KL+m41xwnaJiAxInc67lKptuQp0rlwyvQHWPi7DjY4i
	 3FwwHbmgit5myAVmyurlFW/xXsqH2FT9e+ooHOD38xS5JGQb6KbB0IgnaQRFS+8W9Mwnu
	 HE17hCBKXFEzRt3ybt6EAeeST9R7lKuTKUbwxaKddV01PpPa+D+GvZdqBTETAFfk0ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=o7jnLrErowqvXFY1EZEaU+H+eIQG65Ba2gVvEwqJzl8=;
	b=uYnoy8rFV4J1DJN3ImvkXpW+w9Yx3GkiD3pM+JciySgV1MNGzRlS09Ct/rANQk4hy6Qv
	 Rp+26GQhP4ptNA3Eio89qfjI8S4DG/Abj84Gs82NjMWBkQkMs+S//Ckzn8+8BBdZtXodB
	 MX80+FzhcZCvU6rVWvsBxSe6pb+rvZ31GlcGCU6Lo/0S+hQ2T0BUXqDxYtvNpuZttfOdH
	 3QyDKC34g6CBW8uQ2DysDupoTVNcrkx7+L7pbI1j71Br4DXyCOEYV7e09KEQHeUxZXm5T
	 uCuzTrVa+EXGKOQ01EtxMMV7hbisIos49NiZcD5g7wPWgnC055btwjEQO+gg+dhvRvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLs2+FKc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6813260A263B;
	Sat, 21 Nov 2026 03:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLs2+FKc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530771F000C6;
	Sat, 21 Nov 2026 03:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231509;
	bh=o7jnLrErowqvXFY1EZEaU+H+eIQG65Ba2gVvEwqJzl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLs2+FKcEM38QahOfau4ytU46FnTx9QElOrPxzqjhuNrASMX5XPCNo1pNmJiygI6N
	 gAAreYAVCPqf4QuQmUIP06syOJkbcjtPSmAkzBQo6cY1+9FDyW73225W33lB2tXSDn
	 1+q/rajzt2babrU4PzpHebAOfhBLyjfZ7CkoavY9NHtVkhyju8iSUUeYcDlRLiEKqr
	 RJRUru2x8L0J/qtU13dMVC7SJdEmCHpHfZED3PmMifSJlB0Z7D2OQdzadNoKYoFaoC
	 pRlaViRdGDzOwMZi8J3nH3vVD2craXCgFmTn81DrfNVHF2lm17pjqAac6c5lZXDh9X
	 67JCByJ/sBotQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	TJ Adams <tadamsjr@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: pm8001: Offset hardware queue index for MSI-X pre-vector
Date: Fri, 20 Nov 2026 22:24:54 -0500
Message-ID: <179523145628.420187.12144397144891918712.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118180344.1159617-1-tadamsjr@google.com>
References: <20261118180344.1159617-1-tadamsjr@google.com>
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

On Wed, 18 Nov 2026 10:03:44 -0800, TJ Adams wrote:

> When MSI-X interrupt vectors are configured in pm8001_setup_msix(), the
> driver requests vector affinity with .pre_vectors = 1 to reserve Vector
> 0 for non-affinitized housekeeping interrupts.
> 
> blk_mq_map_hw_queues() maps hardware queues (hwq 0 to nr_hw_queues - 1)
> with an offset of 1, mapping hwq 0 to Vector 1, hwq 1 to Vector 2, etc.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: pm8001: Offset hardware queue index for MSI-X pre-vector
      https://git.kernel.org/mkp/scsi/c/3ad578b22f7a

-- 
Martin K. Petersen
