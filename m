Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BE343B6C1
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249539; cv=none; b=XYqR5pA4mOK+mPZO1AYo+0B1oVANdQpgB06CLxWBOK2Me5YWRL/kg1oRFXYmaHi3VmooKb9VOVaWCeB5MZhCZQXJccozan+vQnEFMNUO02Uw/Wk4uvq+TBpolKnW7kTv/xdl/Fdm2OASDKR/EM3FpoyfGh4Y7Rww5g+c6L83s4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249539; c=relaxed/simple;
	bh=zAVWkIvYVu53PG6ZgpbDQl9fEMuegy42aSuoKiYFe8Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qf3/LT0lTuyx2T/MA9UCVVVVsMo/EcMJN0bv5CZRNbsspIa0AlbmuKTOOc6Gb0b6ILrfyJJLnyJqf8PBTPJARnv7ZagGrjqWxDefHHHq1S0pt3PaIEhxeC8dU1vRBsYVijzL2P4uk69FXANQ702bazUSWbuotUwRxFzP+W5QHwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyvZ2Arx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyvZ2Arx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E36B1F000FF;
	Thu, 24 Sep 2026 11:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790249533;
	bh=FG3iTx//d6Z+08y1Ofi17MOLX4V1FexwlR4bVj+Gc/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nyvZ2ArxCgRNhsVR+/6s/6s17rD2QKD6A5VRUpIgwRlk4qIF3K505Gxt1W/R+GvMp
	 nT16mgT8Zb2U6SF34EqIr9LoJwLOy1SikHcyby6jqfrIpCfjHMQ/sxxcOx5ux8pTws
	 uwVC2paTji86vHuPJMkohqhZEo0Ai5GVGWAZaKAnvwDMfPDHyHEOu7X1hCuWLag6+5
	 bbRH92FoLhRNEsdzLtw4s6ol7Y/F/zdiJ/8XY225xDO6ewy/0xngs/GgzoG4JhiR9r
	 EpMRMopb4RhTnUeVgTrhBwxBImDDN0PdL8yGnPjb6LR+tfXZPQtw1XmoOQs9VJ6uJt
	 Q92Dm3ClCl0OA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/11] scsi: scsi_debug: Report the residual of a
 write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260924112127.3815255-18-cassel@kernel.org>
References: <20260924112127.3815255-13-cassel@kernel.org>
 <20260924112127.3815255-18-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 11:32:12 +0000
Message-Id: <20260924113213.5E36B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi_debug: residual reporting bypassed in resp_write_scat() edg=
e cases
--

commit 2c4fb6bce2173fbd341e31abb8babf6bd210996d
Author: Niklas Cassel <cassel@kernel.org>

scsi: scsi_debug: Report the residual of a write

A write whose data buffer is larger than its transfer length leaves a
residual that the initiator is entitled to be told about. resp_read_dt0()
and resp_write_tape() report it, but the write paths for a disk do not,
so such a write completes with GOOD status and a residual of zero while
a READ of the same length into the same buffer reports it correctly.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b64ae3ad300d8..fd80f66a86ac9 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
[ ... ]
> @@ -5350,6 +5352,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  		sg_off +=3D num_by;
>  		cum_lb +=3D num;
>  	}
> +	/*
> +	 * sg_off counts what the command asked for, which can exceed the
> +	 * buffer: lbdof is not validated against it, and a range is counted
> +	 * in full even if do_device_access() copied less.
> +	 */
> +	if (scsi_bufflen(scp) > sg_off)
> +		scsi_set_resid(scp, scsi_bufflen(scp) - sg_off);
>  	ret =3D 0;
>  err_out_unlock:
>  	sdeb_meta_write_unlock(sip);

[Severity: Medium]
Will this miss reporting residuals when resp_write_scat() returns early or
takes an error path?

For instance, if the initiator provides a data-out buffer but the command
has 0-length requests, the early return path in resp_write_scat() bypasses
the new residual reporting logic entirely:

	if ((num_lrd =3D=3D 0) || (bt_len =3D=3D 0))
		return 0;       /* T10 says these do-nothings are not errors */

Similarly, if error injection for recovered errors triggers during the
descriptor processing loop, the code jumps directly to err_out_unlock,
which bypasses the new residual calculation (unlike resp_write_dt0() where
the residual is set before the error injection block):

			if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
				mk_sense_buffer(scp, RECOVERED_ERROR,
					FAILURE_PREDICTION_THRESHOLD_EXCEEDED);
				atomic_set(&sdeb_inject_pending, 0);
				ret =3D check_condition_result;
				goto err_out_unlock;

Could this cause an incorrect residual of 0 to be reported in these edge
cases, indicating to the initiator that the entire data-out buffer was
consumed when it was not?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924112127.3815=
255-13-cassel@kernel.org?part=3D5
