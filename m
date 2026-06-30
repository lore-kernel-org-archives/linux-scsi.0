Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BF723EAA4
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 01:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782784011; cv=none; b=tu6M1B4QdhpwGvlbdn5KGjrGBTdOTmEzGdliJUWjp9YlCl9pU+yj/jmrqIWJPqJEcJGyyA8BXs7HNWapGuzR+OSXBK40I+WkUhHhdCQnNeFzap3mxHmQP6kaIY/VMT4Zm1TkcdbVrF/8FFjnJ9VqpbxqaM4Hi88td4Z4T39kUV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782784011; c=relaxed/simple;
	bh=XS7i39L+hJ3KCEGCAaemw4jzonJsUp3jy/RvCKJ+hZM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hSPQCyvR7jVvrEEBdEFVONMQrDO40+MSw4+AibHyFtM/hHpNgQaJ1BPl7F7W/EjwqzQZMpxX3mxLKp+EmEOSO9kzE2dbStKYIMROdjLUcWQVQv8HpxB1DeF5v2Seh1ueF/27na9nkzMcNUCgJNpV86d3Y9wp8kNAKI4E6MAHFks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZdojyJr2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdojyJr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBFD1F000E9;
	Tue, 30 Jun 2026 01:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782784009;
	bh=pWgppGSksOk1PBizOLzFnhEg7mx7nS15JA3PEZIFIOo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZdojyJr2+jdRpL+lHhaHZT6pqmoQH4eR0f65Ze35rQ+BqVHpfe2AJHWhkoNreP7kA
	 CONdZVlmJyulEinvTkPhnZGXXuhYTslf2sgE1YvWpnkE1uyLAO0NMOIOFGoYEcaUG+
	 4+hNhqXWb+bH6UEvs9E042L720SWpcsH16SYo4jutHVkR7a6QSeznuV5J3Xm9Rt8Po
	 W6e0usxTgwJXfP0bh6HIb9sSRhgVnswg+TqvwbqEeDdVXLSApswzEhLhX08U8MxXLs
	 yvfInv+7wduKraRpfTEvzEJcf3utC6ptDZ3/WC3ZAE5bCjf4E4bJqhpy3gbmXNeZiR
	 Xv/VSMSfrQ1fQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] message: fusion: remove unused variable 'timeleft' in
 mptsas_issue_tm()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rosen Penev" <rosenp@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260630013433.1518025-1-rosenp@gmail.com>
References: <20260630013433.1518025-1-rosenp@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 01:46:48 +0000
Message-Id: <20260630014649.2DBFD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing Completion Reinitialization
- [High] DMA Use-After-Free / Hardware Race on Timeout
- [High] Data Race / IRQ Synchronization due to ignored timeout return
--

commit 923c21ded0be34230873d9e6304fc7cf76180fab
Author: Rosen Penev <rosenp@gmail.com>

message: fusion: remove unused variable 'timeleft' in mptsas_issue_tm()

This patch removes the timeleft variable from mptsas_issue_tm(), which was
assigned the result of wait_for_completion_timeout() but never read. The=20
function instead relies on ioc->taskmgmt_cmds.status flags to determine if
the command completed successfully.

> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mpt=
sas.c
> index c362f09a8c555..82ac24bf780fc 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
[ ... ]
> @@ -4823,7 +4822,7 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 chann=
el, u8 id, u64 lun,
>  	mpt_put_msg_frame_hi_pri(mptsasDeviceResetCtx, ioc, mf);
> =20
>  	/* Now wait for the command to complete */
> -	timeleft =3D wait_for_completion_timeout(&ioc->taskmgmt_cmds.done,
> +	wait_for_completion_timeout(&ioc->taskmgmt_cmds.done,
>  	    timeout*HZ);

[Severity: High]
This isn't a bug introduced by this patch, but ioc->taskmgmt_cmds.done
doesn't appear to be reinitialized via reinit_completion() before waiting.

If a previous command timed out and is later completed by a delayed
interrupt or a host reset, the completion object's internal counter would
increment. Does this cause the next call to wait_for_completion_timeout()
to return instantly by consuming the stale event, before the new command
completes?

[Severity: High]
This is a pre-existing issue, but removing the timeleft variable entrenches
a potential data race by continuing to ignore the timeout return value.

If wait_for_completion_timeout() times out, could the waking thread bypass
the complete() synchronization barrier? If mptsas_taskmgmt_complete() sets
MPT_MGMT_STATUS_COMMAND_GOOD concurrently before memcpy() finishes copying
to the reply buffer, checking the status directly without verifying the
timeout return value might cause the code to read the reply buffer while
memcpy() is actively mutating it.

>  	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
>  		retval =3D -1; /* return failure */
>  		dtmprintk(ioc, printk(MYIOC_s_ERR_FMT
>  		    "TaskMgmt request: TIMED OUT!(mr=3D%p)\n", ioc->name, mf));
>  		mpt_free_msg_frame(ioc, mf);

[Severity: High]
This isn't a bug introduced by this patch, but on a timeout, the message
frame is returned to the free pool via mpt_free_msg_frame() before the
hardware is halted.

Could another thread allocate the same message frame for a new command
while the un-reset hardware still performs delayed DMA reads or writes on
it, leading to memory corruption or firmware crosstalk?

>  		if (ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET)
>  			goto out;
>  		*issue_reset =3D 1;
>  		goto out;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630013433.1518=
025-1-rosenp@gmail.com?part=3D1
