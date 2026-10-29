Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239390;
	b=WjYhmXdSi2Kb12vaZX13Fd3se3/X4SA+6RNt/93iOB8kDPlerbnbuOSZzCjW2W6gxnL5
	 oSdkoVUlhmGTT1iNBtreP2FhQg3Y+ZNhU/xCW+GQsMywaKoFsHbkRJS4y95kz2k82g9fI
	 XCE8fJUxp2DZeHsQn7YYvok/kJlW6q87H3Rf9tQmscXRmVUZ/ObulbYaacZziTsDdrIu+
	 revjsAg+pdHs8puntdCrLX++9gFVByWZGQvWPjtOOR9JfYaz1hFiqaZ6dvf0KjD9tPEuP
	 mgyRA/z5B8GNt+zRKCzseJhwiV282BMXmyiojdUDH1IDlf9kDexKzJb14ljXwQY0i8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=3uE7o/QimMmEZXnVOf/1pHIokpocmQaKF4aGqgQsVp4=;
	b=2Q8LanvqiEzlwNPQJOHrR9ldxRqTBNdSfdQo2xhJYvhzGBjHd9kduB++xqqR+V/2x/x/
	 SA2uWp7d0Q5BOMg/L2RHCRdsd64E2Mi87iakLEMlfIM5ujz7LbwaevlwwgqQwJOC/1TUI
	 lghn6HYr8w/Iekb/fvUtcZx6ngF7+GS8EEiSeVHODZ7RXZd4g29SF4Wb/11UeQ7gzFRaD
	 Lsb+LAbw6pvFen22ecKBCgXkw7cp3RNjmeB0BvfzySG7X/a5VBk4/UmKK0aUYjw8psRqh
	 MHmhuCpTEPAomFmSRo3uL/NdYMveKVMzAbjbH3d4yeW5nchXZhOuP24kMnbRFXOZoVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+osIaKy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63960606A32D
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 02:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+osIaKy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3FE1F031E3;
	Thu, 29 Oct 2026 02:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239390;
	bh=3uE7o/QimMmEZXnVOf/1pHIokpocmQaKF4aGqgQsVp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+osIaKyALps+Y9C8yjR/hjGIRYJqmk9pVBVvjgt8vsF8KKds4P1A2X2WLDGYlHa/
	 M5Gi/HipZPRRlfQSDy7wLjwT5aHK+T0LBX/gOs6D+jpoosCoL3mxcHcmwSDVtYYMK4
	 rvQvssJJVVkMmsrq66e/v5oIJFdBbQUjlD7+upFsLN3LhVOscPSBwkMmdx7S8FKYih
	 /isN2ByEs2oAX4ffl7+isR+wjl2HirTQmBKT5qnzVacAB6xjm5ff6eGhA7SlL57UxM
	 DBRICiUChIdPw00GoEhIpLNYEn/NDXMh6TvvjfCao7/cgNBAy/HDZ3qQvNYzDtYuwx
	 DcS8Vn9lb7fgA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: fnic: Annotate fnic_nvme functions with __must_hold()
Date: Wed, 28 Oct 2026 22:02:47 -0400
Message-ID: <179323465380.491807.15587959352768559081.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <3c41b84d7d832dd767b30bc04cf875f800ce748d.1792283587.git.bvanassche@acm.org>
References: <3c41b84d7d832dd767b30bc04cf875f800ce748d.1792283587.git.bvanassche@acm.org>
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

On Sat, 17 Oct 2026 17:40:51 -0700, Bart Van Assche wrote:

> Add __must_hold() annotations for fnic_lock to
> nvfnic_process_ls_abts_rsp(), nvfnic_ls_rsp_recv(),
> nvfnic_delete_tport(), and nvfnic_add_tport() in
> drivers/scsi/fnic/fnic_nvme.c.
> 
> Document that callers must hold fnic_lock on entry and exit because
> these functions temporarily release and reacquire fnic_lock, and
> suppress context imbalance warnings reported by lock context analysis
> and sparse.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: fnic: Annotate fnic_nvme functions with __must_hold()
      https://git.kernel.org/mkp/scsi/c/cd02f87668a8

-- 
Martin K. Petersen
