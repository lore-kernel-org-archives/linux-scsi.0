Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250082E7370;
	Mon, 31 Aug 2026 02:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788142769; cv=none; b=hrHkG7+yTKFMTgf2GvYg4dEME5qbfgJeoEujaAZzl3JabBz/5CGeOAqOaDrBg/2XmGeKwyTYlPLpcV/uy5PnFjaATyXAJ/M4TK/oJFUJl3/kmf0XnntPtc548r4pJ1t3KoBdHbTnCTc8dQD5+lTh3tQJsoaRp+jzf66V/EmMxqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788142769; c=relaxed/simple;
	bh=XIEeq8L2Hm/apkBJ070KAMvFmMaXTivjgSem6P64w5k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aDFt3KSivxdEEXWvUZ8TvLvUrrS9wSZh4R5vqsPCbPSVF5lJIqffsepE2m77hz9JnGAphZSlveOqGirLvbHhuM9dbURKEdyYwaRHnqHHPVKFeh3UhWZOHtTOjWjicDDZtifwG2cRLFfSZTqH6ocqG9NzrZ34+mZl9l6MbLVPaoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k8pgezwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k8pgezwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FD21F00A3D;
	Mon, 31 Aug 2026 02:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788142767;
	bh=aowGbJ0mpmqCuX8TIz4QjmUWk5PPd28GIX12T4vlQOI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k8pgezwT+E4yiy8pVr/CmGPuw94x9lfSpf/s/gtTeU5AklIpKvh9sCDSGF8DO5CIk
	 EFybQNg6NznzQJgsTTX7NIYcHPahPqfTxxLugZjYQ1eICt1u7JQlNK9H2PvBjpE7n7
	 D/U3zNjBKwkJlp+zfFN1VDtydmHCZ611bQqZmvMuICRDWfC3NTgVqSxy5sNuHhvqnV
	 ekSHpZO9wRzNZuRj6fIWsdfVe0e8LMFm8WhyDQexzRplLl6MRHHNK9oZG52jJrAWUV
	 sLgGwg+3IgIzD6zJcMYPFA/Pp5YDBRx4i/kgohDqmzvLKt0g6iU1gfVJSob9vyxRXg
	 f4ERWuO0koYnw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/37] scsi: st: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org
In-Reply-To: <20260831020451.585944-13-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:19:27 +0000
Message-Id: <20260831021927.90FD21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incorrectly assigning ASC value to ASCQ in SCSI tracepoint.
--

commit c1f7c0aa9501c3562bd45de8a85431d940fa338b
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: scsi: st: use 16-bits defined sense codes

This commit refactors the SCSI tape driver to use the 16-bit sense_code
field of struct scsi_sense_hdr. It replaces hard-coded additional sense
codes and qualifiers with enum values defined in include/scsi/scsi_sense.h
to improve code clarity.

While reviewing this patch series, I noticed an issue introduced in the
related change to include/trace/events/scsi.h:

> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -303,8 +303,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
>  		    scsi_command_normalize_sense(cmd, &sshdr)) {
>  			__entry->sense_key =3D sshdr.sense_key;
> -			__entry->asc =3D sshdr.asc;
> -			__entry->ascq =3D sshdr.ascq;
> +			__entry->asc =3D scsi_sense_asc(&sshdr);
> +			__entry->ascq =3D scsi_sense_asc(&sshdr);
                                        ^^^^^^^^^^^^^^

[Severity: Medium]
Is there a typo in this assignment?

In the scsi_cmd_done_timeout_template tracepoint, __entry->ascq is being
assigned scsi_sense_asc(&sshdr) instead of the ASCQ value. This appears to
log the Additional Sense Code for both the asc and ascq fields, which will
result in lost diagnostic data when userspace tools analyze SCSI errors via
tracepoints.

Should this use scsi_sense_ascq(&sshdr) for the ascq field instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D12
