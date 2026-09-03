Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D884B37A854;
	Thu,  3 Sep 2026 04:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408125; cv=none; b=LPMOaRnjZ39eeBDuY/r5nfShhL6nXUD0IqVd2zlCrSXLyTko0tiCa8FjeVig4fN46NufyrOKS92ZGMJWTjUePa8uZVHs08wQ4XexQpwQAG2NQ+6CTpVGgxUvuLVfGFtdimNryKVpptPTK3djArunWlkZxR+CbkFK/V+3qI0dDuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408125; c=relaxed/simple;
	bh=l7k7mWa22sp9wdz28Kf/qGvH1FY7JDymdfcpSxBTAEQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XmAhwiiZ9G0mJY4zv9E6ng3QPFmwae9XLAE3LJN+l6B2+xJzrj+obRbPDgxe9D9Vp6lqjJpXed0RTNoYtM0Dq4sWaBfVs7ag64CvMqQuLOMyh8McTimDJYwYQnn8HND0UpzM8TF/l5GH/E2DYlzebJOyfSqTxop+fg4XV6l33Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGXlZhBc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGXlZhBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A091F00A3E;
	Thu,  3 Sep 2026 04:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408123;
	bh=mJkjHm095mfSkEeTxnQ2rwxcNv1P9r/+wDg54G8ld0Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PGXlZhBcqGH7Ah1ZBJUz1n0aQEaimLrLDnEzlhso+3A6O/XoGlqIoelegX/Kej1eW
	 drb66vrqctLCXwlumW+UIKpXtgzleUal0t/ztPrAzNR+yqJf1+md3MvzscdYdHWgWY
	 yq4v5w1YyDPX3PeMPHETH5KwuASr2tWcfVTx5JkaZVF9kd29aTlPL843MKpCvgXjBm
	 oqd3KCXlHqYksQPSn1OXvBT5u2q710++I9JVU1sctln88wtok/fArXJAIJeGGKW3fa
	 +LkZlxLCEsx1VAMW4AbMvKJkgfpo6D+43iVMVno/BgF48MnDeGngsZUw/k0GeykQpC
	 PfBXn+GohsN8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 34/40] target: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260903034201.112211-35-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-35-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:02:02 +0000
Message-Id: <20260903040203.42A091F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Uninitialized stack variable read in debug log due to concurrent=
 list modification

Pre-existing issues:
- [High] Logic error causes Unit Attention Interlock to fail and incorrectl=
y return SAM_STAT_BUSY
--

commit 95a802c45c6965b17dd9cccbc6b6421dcf571862
Author: Damien Le Moal <dlemoal@kernel.org>

target: use 16-bits defined sense codes

Refactor the target core code to use the 16-bits sense codes for building
sense and replace all hard-coded additional sense codes and additional
sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_cor=
e_spc.c
> index f964a531e053a..f11766dfb5428 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -1226,9 +1226,9 @@ static sense_reason_t spc_emulate_request_sense(str=
uct se_cmd *cmd)
>  {
>  	unsigned char *cdb =3D cmd->t_task_cdb;
>  	unsigned char *rbuf;
> -	u8 ua_asc =3D 0, ua_ascq =3D 0;
>  	unsigned char buf[SE_SENSE_BUF];
>  	bool desc_format =3D target_sense_desc_format(cmd->se_dev);
> +	u16 sense_code;

[Severity: Medium]
Could this uninitialized variable cause an issue?

The previous code initialized ua_asc and ua_ascq to 0, but sense_code is
left uninitialized here.

[ ... ]

> diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core=
_ua.c
> index 4276690fb6cbd..ea97b05d47ab7 100644
> --- a/drivers/target/target_core_ua.c
> +++ b/drivers/target/target_core_ua.c
[ ... ]
> @@ -232,8 +230,7 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd =
*cmd, u8 *key, u8 *asc,
>  		 * clearing it.
>  		 */
>  		if (!dev_ua_intlck_clear) {
> -			*asc =3D ua->ua_asc;
> -			*ascq =3D ua->ua_ascq;
> +			*code =3D scsi_sense_code(ua->ua_asc, ua->ua_ascq);
>  			break;
>  		}

[Severity: High]
This is a pre-existing issue, but if dev_ua_intlck_clear is false, the loop
breaks early without updating the head variable to 0.

Since head remains 1, core_scsi3_ua_for_check_condition() later returns
head =3D=3D 0, which evaluates to false.

Does this incorrect return value mislead the target core into aborting the
sense processing in translate_sense_reason() and returning a SAM_STAT_BUSY
status instead of a CHECK CONDITION?

[ ... ]

> @@ -317,7 +310,8 @@ int core_scsi3_ua_clear_for_request_sense(
>  	pr_debug("[%s]: Released UNIT ATTENTION condition, mapped"
>  		" LUN: %llu, got REQUEST_SENSE reported ASC: 0x%02x,"
>  		" ASCQ: 0x%02x\n", nacl->se_tpg->se_tpg_tfo->fabric_name,
> -		cmd->orig_fe_lun, *asc, *ascq);
> +		cmd->orig_fe_lun, scsi_sense_code_asc(*code),
> +		scsi_sense_code_ascq(*code));
> =20
>  	return (head) ? -EPERM : 0;
>  }

[Severity: Medium]
Is it possible for this debug log to read the uninitialized stack variable
from spc_emulate_request_sense()?

If the list is cleared concurrently between the lockless list_empty_careful=
()
check and acquiring the ua_lock, the loop is skipped and *code is never
assigned.

Will this unconditionally pass uninitialized memory to pr_debug() and
potentially trigger a KMSAN warning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D34
