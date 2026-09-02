Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC88243C06F
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 09:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788343082; cv=none; b=CtpKe4SWlFYkyUbinS4Petj+M60qx6Iny473/KPPhO3gBgqfM4y0tUrzjAS/c5BiefLEmbZpkn2XVe8JtOyG8dFHTzbHxTvYVqeWx4DfE9151QqhVrhsGjVDAKooFevc8TyLhd/Zle4uhPmZIqDW5PQKmhQ15brDqZbEpmcmcuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788343082; c=relaxed/simple;
	bh=ZvDxNyoC+sfsiVAKIp4EAiKAfoQss3f2LI4Lq/lRoj8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=syU9vtHC5Ww5VIc681XO8OXcKU/kpKr3xgB6umZ7ZmMegQ3eHSB1ZEAMPLxJvb+VWUcMHtqvC99eRfFQrI8m/9kXrEIwR7a/O2qTdBw2YR0v8yu1x3uVYeAg+WDdbHL7XudYdJO55d/iMLkoTnliFPHRw6qjLKFejD9Cl77Kl00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nEKkCtdt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nEKkCtdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253D21F000E9;
	Wed,  2 Sep 2026 09:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788343079;
	bh=FLOoSfQkNv9Xwaq8t6R5wl5dK0EoY06sSG6ihVbz3Io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nEKkCtdtVPF3y8OTErX9Wspj88I+JzoSUIWpw2PTgkRZ9+Klqd4sNEFclhtC35jNN
	 CKgKg8mRKpDu9vTz2udUk55iWLBdpz5B/0O7ZrkpxQag6YUAREnWfdfMAjduAdqrBF
	 zLHPA9IMCN+oDIIbypSVqPpDvDJI4ikqv1Fu+Go4DW6Es3CaaLvC4T0GPXkc+zg15S
	 V08UeyhLnrN84Z6dHw6TDQXf7NX8HIyek1dUBECw+0Cn8esLazlXt4SG3av5RVf6LU
	 zHU3FKehMPEhpcO4g0ZfIoGWPrxe/h7LOkj2U7hKuzrV5pl+U+dkJPbA5FCM8xGVcz
	 04RL9djaGtZ5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: default to a higher throughput config
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260902092844.1741533-1-john.garry@linux.dev>
References: <20260902092844.1741533-1-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 09:57:58 +0000
Message-Id: <20260902095759.253D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Stale defer_t in sdebug_scsi_cmd causes premature double scsi_=
done() leading to UAF.
--

commit 92c33bac6eb173f6156f5a3b2daf5604d8994b5b
Author: John Garry <john.garry@linux.dev>

scsi: scsi_debug: default to a higher throughput config

Currently the default config goes not give as high a throughput as some
would like. Give a higher default throughput by modifying the delay,
can_queue, and clustering defaults.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3346562275f80..f2afe757c4380 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -79,7 +79,7 @@ static const char *sdebug_version_date =3D "20210520";
>   */
>  #define DEF_ATO 1
>  #define DEF_CDB_LEN 10
> -#define DEF_JDELAY   1		/* if > 0 unit is a jiffy */
> +#define DEF_JDELAY   0		/* if > 0 unit is a jiffy */

[Severity: Critical]
This is a pre-existing issue, but changing the default delay to 0 exposes it
out-of-the-box to all users.

When delay=3D0, schedule_resp() takes the early completion path without upd=
ating
sd_dp->defer_t or sd_dp->cmpl_ts:

drivers/scsi/scsi_debug.c:schedule_resp() {
    ...
respond_in_thread:      /* call back to mid-layer using invocation thread */
        cmnd->result =3D pfp !=3D NULL ? pfp(cmnd, devip) : 0;
        cmnd->result &=3D ~SDEG_RES_IMMED_MASK;
        if (cmnd->result =3D=3D 0 && scsi_result !=3D 0)
                cmnd->result =3D scsi_result;
        scsi_done(cmnd);
        return 0;
}

Because scsi_cmd_priv(cmd) is not zeroed per-request by the SCSI midlayer,
a reused tag retains its previous defer_t value.

If the previous command on this tag was polled, defer_t is left as
SDEB_DEFER_POLL. Concurrently, if a userspace thread invokes
sdebug_blk_mq_poll_iter(), it iterates over busy tags, sees the stale
SDEB_DEFER_POLL and expired cmpl_ts, and spuriously calls scsi_done(cmd) a
second time:

drivers/scsi/scsi_debug.c:sdebug_blk_mq_poll_iter() {
    ...
        spin_lock_irqsave(&sdsc->lock, flags);
        sd_dp =3D &sdsc->sd_dp;
        if (sd_dp->defer_t !=3D SDEB_DEFER_POLL) {
                spin_unlock_irqrestore(&sdsc->lock, flags);
                return true;
        }

        if (time < sd_dp->cmpl_ts) {
                spin_unlock_irqrestore(&sdsc->lock, flags);
                return true;
        }
        spin_unlock_irqrestore(&sdsc->lock, flags);
    ...
        scsi_done(cmd); /* callback to mid level */
}

Could this lead to a double scsi_done() and a Use-After-Free in the block
layer when racing with the early completion path?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902092844.1741=
533-1-john.garry@linux.dev?part=3D1
