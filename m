Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA24E40D57B
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453315; cv=none; b=rw0bsWIlQcWGyt5LAPru4U4SOsp2xT4DxHcbyfaKh2vFc1MyXGzM1EJJ8B4QE6pG2XPo4rUfMu4uvMzEelM8ZGllulOWV+LalY4U8X9fmQS8iMDe6B8ytBDhewp8VT/svtaRjUjujhelqe7Y3BeTs76GwWQ7vvfBkQPX/2ntjh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453315; c=relaxed/simple;
	bh=OUz9hvkS/pM9/HHM5ICb600QoSnRjTDJigR+YWfGLig=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OJ6UQTUqo0o+aixXJ7RfQGXxqk2+CtQVemAb90r67KmS9Ifjs3n2HZMAiS25jnVPdyMjhqdLwEgVWJ/uAfMQylGCAJgMM3HHBjkWFCl4pRWkfwRIH7Zp0A94tnCxYq3QXqH+0sJDglAFXAo0EatdUSUPhG5aT0DYSGKEgl9Z+fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uboa1pfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uboa1pfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B1E1F00A3A;
	Thu, 30 Jul 2026 23:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453314;
	bh=UTh/asuXOyXVCWZeuIqUDkqU05QBPmVBAFIMG6qkeHw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uboa1pfcQIqrn++f8hqk0AuAmGm5u5BVPsJQGLOHpmtzB1PSA3sWK+1rj2wh8kUMA
	 ZMcw66RjdT5wsg1ffM8py82xNrMZWTY5cofmajLIivkA4F1m4EsYJIDvwA+3/7Dr3/
	 UacRHCSyw3wIGLooycoFj6kK1yWH0U9Q5bDLJiukL7UHNi8yomLNfQU7r5MaHXPUya
	 k7rFtGCKGdrbqUkMnA7Br98MDcW3uWt1tIXTgbY5J6ErMC929AolJPWA1oQTBiAXMU
	 vFrcVN7n9JLIISb4VPgdMfDBaOnvZNb+aVS6hG651GaQEM+18YLiYKPhkmsP1WzLmV
	 zPRtZc82MRCMQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 31/57] scsi: ipr: Prepare for enabling lock context
 analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <513b03ea01a06dc5eafdc31663497614eed3624e.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <513b03ea01a06dc5eafdc31663497614eed3624e.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:15:13 +0000
Message-Id: <20260730231514.51B1E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Command timers are cancelled asynchronously during adapter removal=
, which can lead to a use-after-free if the timer callback executes concurr=
ently while the underlying memory is freed.
--

--- Patch [31]: [PATCH v3 31/57] scsi: ipr: Prepare for enabling lock conte=
xt analysis ---
commit 2f00fc44ee9f9f3037991b9e96f4f40f0505e35f
Author: Bart Van Assche <bvanassche@acm.org>

scsi: ipr: Prepare for enabling lock context analysis

Document locking requirements with __must_hold().

> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index d207e5e81afe0..51092834876cb 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -1016,6 +1016,7 @@ static void ipr_init_ioadl(struct ipr_cmnd *ipr_cmd=
, dma_addr_t dma_addr,
>  static void ipr_send_blocking_cmd(struct ipr_cmnd *ipr_cmd,
>  				  void (*timeout_func) (struct timer_list *),
>  				  u32 timeout)
> +	__must_hold(ipr_cmd->ioa_cfg->host->host_lock)
>  {
>  	struct ipr_ioa_cfg *ioa_cfg =3D ipr_cmd->ioa_cfg;

[Severity: High]
This is a pre-existing issue, but can the asynchronous timer cancellation
during adapter removal lead to a use-after-free?

In drivers/scsi/ipr.c:ipr_fail_all_ops(), pending command timers are cancel=
led
using timer_delete():

drivers/scsi/ipr.c:ipr_fail_all_ops() {
    ...
    timer_delete(&ipr_cmd->timer);
    ...
}

Since this is non-synchronous, if a timer callback like ipr_timeout() is
already running on another CPU, it will spin waiting for the lock:

ioa_cfg->host->host_lock

Meanwhile, the removal path in __ipr_remove() initiates the bringdown and
eventually calls ipr_free_all_resources(). This frees the command blocks via
dma_pool_free() in ipr_free_cmd_blks().

When the delayed timer callback finally acquires the lock, could it
dereference the freed ipr_cmd and ioa_cfg structures?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D31
