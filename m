Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168542AD00
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786560017; cv=none; b=JHtemeVyZdJeMCpN8lIifrqtafnEdn33lgY0DiIEUm5K3Se4kkzjLpTLTv1EkkaEu78iOWku7cRdd1Wwg/t8XA9nXm3dvEqSLZdNpPcEos3PazFN9BXCcpyymJjarXNY+KvCoz4Z1RzmoSf0BLDUaD7HVF0xqUi76D8ixbfF4Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786560017; c=relaxed/simple;
	bh=uE9lNykVEjcoE6HtEssE4iUjajHYUcp6RQ9axUve9fo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Eh7mWG108HMBn3H9VF/3//4KiCGlqXE2M6lBEMbbgIYKjcdxhh9u8QXxCuxGlg5WmngpD76gIaRGvxkscRZ4DrBu2qWEPBuek9lw4xXxtEyRnltcs6jv02aF6EEWhF685QBOEdGKVFkNhCSazCbXPrak27eFhgmezdBH7JeJWzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/QRajaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/QRajaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A821F000E9;
	Wed, 12 Aug 2026 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786560015;
	bh=iLEpDQSX4xE50/XxbAcm0aVPT49VMLF8cIykwsAU13c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M/QRajaazst61Kw+CGtLrgPewfZLdbx3fLIdJ6+G0gOEgvm5kkGbbp96TSCT2MUwG
	 xrJklKSqqFn9z+R7OLqbSO1Lp6Zw6Epy7PPyZ25g69S9n+aEmAaGOvpQMIZ7IpD/hJ
	 3jWSb4c19Cq5wU6AeSQUv3J2oBxNJ6XHzSTyQ6tkbZKMdymscdjMIQyrOXlGh8Bk2j
	 NwYjbgWeOZ7D9UZfBlYJ8vh/Rtsx1efRbM+XG6cyfY0MGEWL9+eH8vj5nDGY+wVkpH
	 Xz5bFIR6bTh2fqOUNmQQouiPkXDsJtIM49jHB9+p8nBo430zjN+jKC9jAxZwPt4iJr
	 YKhHZhVeFpJgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] ufs: core: Simplify timeout handling for START STOP
 UNIT commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <0a0a8245594f992a2318caf14164491974e79c46.1786558726.git.bvanassche@acm.org>
References: <cover.1786558726.git.bvanassche@acm.org>
 <0a0a8245594f992a2318caf14164491974e79c46.1786558726.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:40:15 +0000
Message-Id: <20260812184015.88A821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Replacing DID_REQUEUE with DID_TIME_OUT for START STOP UNIT comman=
ds inadvertently routes them to the SCSI Error Handler, risking deadlock an=
d breaking PM recovery.
--

--- Patch [1]: [PATCH 1/3] ufs: core: Simplify timeout handling for START S=
TOP UNIT commands ---
commit 457c19a7449f41757fe8a8fc3aa57e02dd255499
Author: Bart Van Assche <bvanassche@acm.org>
   =20
ufs: core: Simplify timeout handling for START STOP UNIT commands
   =20
This commit simplifies timeout handling for START STOP UNIT commands by fai=
ling
them directly instead of requeuing them. It updates the ufshcd_eh_timed_out
handler to use DID_TIME_OUT rather than DID_REQUEUE for SCSI commands.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9572,13 +9572,9 @@ static enum scsi_timeout_action ufshcd_eh_timed_ou=
t(struct scsi_cmnd *scmd)
>  			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
>  		}
> =20
> -		if (ufshcd_is_scsi_cmd(scmd)) {
> -			set_host_byte(scmd, DID_REQUEUE);
> +		set_host_byte(scmd, DID_TIME_OUT);

[Severity: High]
Will this inadvertently route START STOP UNIT commands to the SCSI Error
Handler and risk deadlocks during PM recovery?

Looking at scsi_decide_disposition(), setting DID_TIME_OUT for commands oth=
er
than INQUIRY or TEST_UNIT_READY (such as START STOP UNIT, opcode 0x1B)
evaluates to FAILED. The SCSI core then proceeds to call scsi_eh_scmd_add(),
which flags the host for SHOST_RECOVERY and wakes the SCSI Error Handler
thread.

Waking the EH thread during PM transitions appears to break the UFS
subsystem's custom inline recovery and reintroduces the deadlocks that comm=
it
01d5e237b339 originally resolved.

If the goal is to fail the command directly without retries and without
invoking the EH, would an error status that evaluates to SUCCESS in
scsi_decide_disposition() (such as DID_BAD_TARGET) be more appropriate here?

> +		if (ufshcd_is_scsi_cmd(scmd))
>  			ufshcd_release_scsi_cmd(hba, scmd);
> -		} else {
> -			set_host_byte(scmd, DID_TIME_OUT);
> -		}
> -
>  		scsi_done(scmd);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1786558726.gi=
t.bvanassche@acm.org?part=3D1
