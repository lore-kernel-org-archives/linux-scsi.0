Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC145299931
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788261934; cv=none; b=IDrH3mY1jLVTj2NkUHFxzXgy5smWFdkB0g5p6nl1Aeq8Hpwcgry9u/itlDR4iKPeG63AQGQc9AcmAkw03dOgSODOytrRxnTnpWIQOaFy/dD6vz+BgxR5Xkly3l6dd1IIrc0ICZF3kwMtcu4roHYjNHjukw3al+LFIR0v/csABO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788261934; c=relaxed/simple;
	bh=AO2+FGYassbPwqjb/zi73ax86Z9slStrOOjuwbQnJ5U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HQfaBAGZv+9+uYCvVdqWtXytWwMjK5OxsRS35a/OOm5RYc8W8sPr2luo+le70SAj8GRfZggIC2iYCwrml7qqrJn9Xqavw1pFurO1jkEK4tcaOFo9CySPfYM7I1hE1efB6l2DLUhBIzBd9GEmXBbmhRv3wBHIYCh0C4rwgkZTl4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l30+ZrCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l30+ZrCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC161F000E9;
	Tue,  1 Sep 2026 11:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788261933;
	bh=1FhUFxNyMP6SATAmEHttdHB0MbfD15brfR8CCj/1SBE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l30+ZrCP7PPanouFvr3dGeGi1Tp59ke6VeCFYAQZsyyY+E3KgbyiNXJ4mbzu+u3Ke
	 i/x4IMBwkTM0xgDn5atqJsc3ltztps6MBVb7T2BvRja4K/EQUN0fYC0iNDJ2LEG3hr
	 UqPusJf66gGX1OSn+HSLNVJ4kMIOSd5W3Kw1Q30Ym9NOsT4SaIqsWbL4JoWUhqLHGP
	 uECBbAzn1JVzthvaDSBZSqrOKmNFbCLbJYvnipSrZ7L7NdE7SKbzAqnLi0LbCYM2rD
	 BPgX3WxpjCyjQBsoNa+cJhg/9XaOZJuoS5t/V3sG/IZOMJZaszy5KNR+wZFw2PJHym
	 hJsFkHFjUZWsA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 20/27] scsi-multipath: add
 scsi_mpath_{start,end}_request()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-21-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-21-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:25:32 +0000
Message-Id: <20260901112533.2BC161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Bypassing `scsi_end_request()` on hard errors in `scsi_queue_rq()`=
 permanently leaks multipath active counters and corrupts state for recycle=
d blk-mq tags.
--

commit d6985f792a0819a7b56a04e827a71ff5a8dd2172
Author: John Garry <john.garry@linux.dev>

scsi-multipath: add scsi_mpath_{start,end}_request()

This commit adds scsi_mpath_start_request() and scsi_mpath_end_request() to
handle private multipath request data. It also introduces mpath_nr_active
per SCSI host to track active requests for queue depth io-policies.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 189263ce56624..5916dead5422e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -1918,6 +1921,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_=
ctx *hctx,
>  	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>  	cmd->submitter =3D SUBMITTED_BY_BLOCK_LAYER;
> =20
> +	if (sdev->scsi_mpath_dev && is_mpath_request(req))
> +		scsi_mpath_start_request(req);
> +
>  	blk_mq_start_request(req);
>  	if (blk_mq_is_reserved_rq(req)) {
>  		reason =3D shost->hostt->queue_reserved_command(shost, cmd);

[ ... ]

> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 8ecfb94049db5..52227e2cd9749 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
[ ... ]
> @@ -58,8 +58,11 @@ struct scsi_pointer {
>   */
>  #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
>  #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
> +#define SCMD_MPATH_IO_STATS	(1 << 5)
> +#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
>  /* flags preserved across unprep / reprep */
> -#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
> +#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING=
 | \
> +				SCMD_MPATH_IO_STATS | SCMD_MPATH_CNT_ACTIVE)

[Severity: High]
Does preserving these multipath flags across requeue operations cause a lea=
k=20
of the mpath_nr_active counter and stale state for recycled tags?

If a multipath request is dispatched, it calls scsi_mpath_start_request()=20
which increments the host's mpath_nr_active counter and sets these flags.=20

If this request is requeued (for example, if the host is busy) and then=20
re-dispatched while the device is offline or entering recovery,=20
scsi_device_state_check() in scsi_queue_rq() will fail early. This causes=20
scsi_queue_rq() to return a hard error directly to the block layer.

Because the block layer completes the request natively on hard dispatch=20
errors, it bypasses scsi_end_request(), leaving scsi_mpath_end_request()=20
uncalled. The mpath_nr_active counter is leaked.=20

Furthermore, since SCMD_MPATH_IO_STATS and SCMD_MPATH_CNT_ACTIVE are=20
preserved in SCMD_PRESERVED_FLAGS, any new request reusing this tag might=20
inherit the stale flags, bypassing initialization in=20
scsi_mpath_start_request().

Could there be a mechanism to clear these flags and decrement the counter=20
when a requeued request encounters a hard failure during re-dispatch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D20
