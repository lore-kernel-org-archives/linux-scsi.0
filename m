Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B932A3812F4;
	Mon, 31 Aug 2026 02:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143485; cv=none; b=hwBlal69VVxoduSMwEwdTlabi7t1zAvBL6Y68+xX1ABVlFGMDOEcHmr3G834l7NNZx3lkZ5Nwu2sOb5OJorRfyPw3ud5S279OFnpig3BvaJIoEprTVXJipYThzNLgQhaOIdoGGdo129Ran+LAgyDpn7OrE46YBtHgvzkLn+tEwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143485; c=relaxed/simple;
	bh=wAUkoZtJRPrbiRjWEIiwIaF5ru6nhdq0f2gDihOdfQo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p243Ql1SjYgaDK0LXtIEoVf8yL4UEtG0YHmw/WCLzFy9GexSvPbgeby6MJkS3RRZPwQMC3TFMRJo7SEKL86+okB8De2yEzw1uOuLZb3jSOhw1o4feYiBu6UYhZD/1nj7HhHTM8hVhYjiCuYWrZ3JQy0vQnAKjXKCdQ+YteDIGAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=al89+Iv8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="al89+Iv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC631F000E9;
	Mon, 31 Aug 2026 02:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788143463;
	bh=5Z8NMKFtUCgKaqrrgcGRoSw49I11LljhEQAgxss8qv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=al89+Iv8v/v2PnFPt7N/uH9ALCFdimNN78pbhpN2yRAJ63Br83ZTNjJr5fbTLJCvR
	 YC0/suLh8qe6c9MZUn+ICrYxwmMOph9I/V/oW1aFj/Z/srU5+aH0QxfPFwRPlPj18Y
	 NcLXXVXHPRgJaotqWjudlma3r9uJoszpfSa9HBcDlhSndbizHP230oHC2coLsndN2o
	 CRXPM/BasrBDoBttPJq5eYutpY7q2zlRRgb/0YEhkwYJ0MGee8z5k3CZU11L/fYw2e
	 +J4P592iIvvWvfRxSkycDL+g7eTTo5dCIKEdiY8zFHoquqpmi2E0NOAG5o0DW+lF/l
	 awqhaeaIzBVwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 37/37] scsi: cleanup scsi_proto.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260831020451.585944-38-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-38-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:31:03 +0000
Message-Id: <20260831023103.8EC631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Trace event records incorrect ASCQ value due to a copy-paste err=
or.
--

commit 18b8d3cbe68a6be05817a223fa4182ba612faa08
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: core: use 16-bits defined sense codes

This commit refactors the SCSI core code to use the 16-bit sense_code field
instead of separate 8-bit ASC and ASCQ fields. It updates various structure
fields and sense code logic to utilize macro definitions from
include/scsi/scsi_sense.h to improve code clarity and testing.

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

[Severity: Medium]
Is there a copy-paste error here where the trace event records an incorrect
ASCQ value?

Assigning scsi_sense_asc(&sshdr) to __entry->ascq instead of
scsi_sense_ascq(&sshdr) will duplicate the ASC value, losing the actual
Additional Sense Code Qualifier in the trace output.

>  		} else {
>  			__entry->sense_key =3D 0;
>  			__entry->asc =3D 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D37
