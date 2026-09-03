Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2A937F30E;
	Thu,  3 Sep 2026 04:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408076; cv=none; b=Huo5e39+Hi+yBQhJLsvfJJVdLgk6VyKZvoLHWtNZUhQLdeCZWca8yw2MBoWOgBmu5o5MsmeMvqsTT+FadvWPq1ngv2aXgzdVi0sEupouZ30IVsNNf9jq1PfDG3g7caSnB5LKfk/VhoZPw4/aRPkMVnTDK+edivOrmgjYfQyfoxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408076; c=relaxed/simple;
	bh=abzHQvkaHJ8Hw/pfyKMuT40vAsJmKj1SwOTOisaca1A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WY0iECTxrmOxgCuTg8jdkhTgxrPieQhOEK+cKx0XPCM145co8D8L/H96epNqhvcZH6BI1C77mnttBb5GdPEy4544lzhStHY3cAuN1y9Enn4dLhSIJDyPG4u6vKUUS6W9MwU8BUL7eDah+qX2HUKVj/VtKPJzbwKkqgBpJu8SwvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zs0HYS9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zs0HYS9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24C71F00A3A;
	Thu,  3 Sep 2026 04:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408075;
	bh=1koH8oSIsnR+DLM6EkiZbYJMxCnnncEpAcxKE83RLnc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zs0HYS9ASWm94uMRcb1zPdyfZgiodGWNJYFFKXkcPMlzz3quncZmzsmxaaiFyDOFX
	 zVuHLZn8nMeauS6Uea+1P1bO7BrX1th8+IXK5IBZr9NonplNxH+QAPqyeH0dNN2FWA
	 JgMRoCzByKtkn/3W/PKukd2oIAIT/E/iczJuJJDCX8KxDmnQwjKQpIfedhiA4wfjFb
	 Rq9qzlqAEzSVoa5GdP4A6AwgFfav8pFPTEbGqrbWZBKoy69a+QTq6tqdksrgZ8PO/L
	 Sh+/Ufqm3oRVgX9uIWhVUxkl3IJrnnUEwBZ+AJz6mji13K/qwC05uXO9bm2hSoY1e8
	 L2mBMzklwcCLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 38/40] s390: scsi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org
In-Reply-To: <20260903034201.112211-39-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-39-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:01:14 +0000
Message-Id: <20260903040114.F24C71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete refactoring leaves hard-coded ASCQ values in `zfcp_fs=
f.c`, contradicting the commit message.
--

commit a120aaf764276a0a8205d59d479d4eea2ff29d24
Author: Damien Le Moal <dlemoal@kernel.org>

s390: scsi: use 16-bits defined sense codes
   =20
Use the 16-bits sense codes and replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined
in include/scsi/scsi_sense.h. This helps with code clarity as the sense
codes being processed are easier to test and self-documented.

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 3590113c2b744..0994fa328a4fa 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -856,7 +856,8 @@ void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
>   */
>  void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
>  {
> -	scsi_build_sense(scmd, 1, ILLEGAL_REQUEST, 0x10, ascq);
> +	scsi_set_sense(scmd, 1, ILLEGAL_REQUEST,
> +		       scsi_sense_code(ASC_ID_CRC_OR_ECC_ERROR, ascq));

[Severity: Medium]
Does leaving the ascq parameter as an integer leave hard-coded additional
sense code qualifiers in the codebase, contradicting the commit message?

Looking at drivers/s390/scsi/zfcp_fsf.c:zfcp_fsf_fcp_cmnd_handler():

	case FSF_BLOCK_GUARD_CHECK_FAILURE:
		zfcp_scsi_dif_sense_error(scpnt, 0x1);
		goto skip_fsfstatus;
	case FSF_APP_TAG_CHECK_FAILURE:
		zfcp_scsi_dif_sense_error(scpnt, 0x2);

It appears the hard-coded literals (0x1, 0x2) are still being used here
instead of the new 16-bit enum values.

Could the function signature and callers be updated to use the full 16-bit
enums (e.g., LOGICAL_BLOCK_GUARD_CHECK_FAILED) to completely remove these
hard-coded values?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D38
