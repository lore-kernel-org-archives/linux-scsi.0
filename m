Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8BA345EA2;
	Mon, 31 Aug 2026 02:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788142697; cv=none; b=tPC/q1MyQT1yIFp4vFZVRnkjCd0aAuKtPqeMe21wSDDGoTPhneQTVYSXPcZv+Jt7dhrf/auXS725UReZxaEOagryQOdwxm8TYjrztH/5kOVx/+krTY+KrnPBDHjvt6J87n5o+wHKfyBxG61ws6pQazYk4yqhPfouhPlkB0TqcGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788142697; c=relaxed/simple;
	bh=5ENS61U06y+kxk/QWBcmnAgMgID5LNfA5f2jRauAtbY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QqH1QHxdEKsDQgrZlRSXbBdM5a5N5YnjbGaqEh//yVilvaLXa74cfj8GQSgqugcNRqzF9LJzqv2IzUDwraHbOel1RnbY+LiFT5/kTocOtVacvHx9/uQ95CEWIeIriPhnLYkgr8RIcbFdWCDgJS9RCxE6jEAwnINheXUCBlyarL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQn32CvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQn32CvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44641F000E9;
	Mon, 31 Aug 2026 02:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788142696;
	bh=LhLn1o0Hov98mH/gskNcXEwblfoWr3KYOQ1oSakU0io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cQn32CvBMb9MrljHJYRk2ua75fKOYculnw4+ESYG5skqjpUq0FtMytl4uSuBBhEaU
	 j1NYd2FlAIXmteiE8Oj0s5QM1XZwGdqiB20HHzgcmgncEjameHJPM15CAyHKptjSXt
	 LuhyddRYXA0vQD62mQNuaeL+j61atlgkCjInpi3scKX8PutYJdj71cIJlCwlOPxooD
	 EJaDjN8LkMLjIKeWyUrRMzVHVZtXzACE1boqojWpn+3tE9pqYER62M74oMJZMhMVLd
	 BlDJ0Tm3sCrLqrTxNZ7hqPpLXI50O+UFBRUQGxCDuKW9NFk6q+5xHP/jBL5OSXRjt8
	 FW/fS5pUHNmtQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/37] scsi: core: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260831020451.585944-8-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:18:15 +0000
Message-Id: <20260831021815.E44641F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `scsi_cmd_done_timeout_template` trace event incorrectly ass=
igns the ASC value to the ASCQ field, causing a loss of ASCQ trace data.
--

commit 18b8d3cbe68a6be05817a223fa4182ba612faa08
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: scsi: core: use 16-bits defined sense codes

This commit refactors the SCSI core code to use the 16-bit sense_code field
of struct scsi_sense_hdr and struct scsi_failure. Hard-coded additional sen=
se
codes and qualifiers are replaced with enum values from scsi_sense.h to
improve clarity.

> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index c36c72ab7f2bf..4d17c9b61e44a 100644
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
Does this code assign the wrong value to the ascq field?=20

It looks like scsi_sense_asc() is called instead of scsi_sense_ascq(),
which would cause the trace event to duplicate the asc byte and lose
the actual ascq trace data when a SCSI command completes or times out
with valid sense data.

>  		} else {
>  			__entry->sense_key =3D 0;
>  			__entry->asc =3D 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D7
