Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E74C479871
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785454307; cv=none; b=feUXu9OGF7EcW18ApKH5us6wrS2vE8laAT1McgVFREIqb7sKA9IG5RckR2MjRqOjFwxB4dRbR+zrB4Cy0auJK8Zc5Uwv0iIz0L3psmJwMYE8z1tHCKaXcXsPyWcv17fSnuRWD7Poant09J/2Be+TkUrklt0FsTfoPn9J7difudg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785454307; c=relaxed/simple;
	bh=viz+6lHLh/MpbhJDZBk8prOY7FAkOCKO5FAb23QGia8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fvhex9AMYBJoM+tqJlEKp5FpANTZTDGqY+Ki0EIUaFyngj/lcvb17fM/HjsNnB+MGpcfAy549bqrLoO3Ya6iR2a4BK/2gfz+64gFyVV8mMLrOQVtQjq24B4WtGwUuybYiH4H7GG8ep4g2Pkt8aF9J7Kuiz8lsJLVleJUvxDTCOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVEnJuyS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVEnJuyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24991F000E9;
	Thu, 30 Jul 2026 23:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785454303;
	bh=3IWPF7sTFIF57Vz03ZHeY8JE7zNu95z4a3CDKZB4WVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iVEnJuySCBQwGlZUR43oxBLEPOz4m0NkyfucgjtnCpCLjOI0kc8YB5ZVgO88tsxH8
	 bsXk5fR4jKdI/1OCLuYEVNd3S5rAZjfyyVl+/mtORCYKKCxMebOTRcgRU+dfjpgabp
	 8pRtQYsDEzhobdf1MieD7lAlhl5EjHoBIiX3NBHTt840rwC+KDNxepoHQR0JaBB8P/
	 kyMwfa3lhyMNJV+1vKl+Yo/FyNhsyOVTJSbcPU0HyL34YBLB16Bswc64wkFeu0rPyf
	 E4oGO85fEIF+idwEbs5JjKf3yDzfCmZNe58bXbWWqF1VJ+7VJKxGJWRFprz2UkMswK
	 EHjU3Jq0w7Skg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 44/57] scsi: pm8001: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <6371196646d5f6222a6d8e55de2a351aa9caf967.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <6371196646d5f6222a6d8e55de2a351aa9caf967.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:31:43 +0000
Message-Id: <20260730233143.B24991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Early returns in `mpi_sata_completion` for internal tasks bypass t=
he `SAS_TASK_STATE_ABORTED` check, leading to a Use-After-Free if the task =
was concurrently aborted.
--

--- Patch [44]: [PATCH v3 44/57] scsi: pm8001: Enable lock context analysis=
 ---
commit 33ee7fcaec7784e599b990132a4a4b4063d0bddb
Author: Bart Van Assche <bvanassche@acm.org>

scsi: pm8001: Enable lock context analysis

This commit enables lock context analysis for the pm8001 driver. It also
documents locking requirements with __must_hold() for mpi_sata_completion()
and process_one_iomb().

> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index 2c0fa7ab33d22..11f6fa5c9771e 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2294,6 +2294,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *p=
m8001_ha, void *piomb)
>  static void
>  mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>  		struct outbound_queue_table *circularQ, void *piomb)
> +	__must_hold(&circularQ->oq_lock)
>  {
>  	struct sas_task *t;
>  	struct pm8001_ccb_info *ccb;

[Severity: High]
This is a pre-existing issue, but does this function have a use-after-free
if an internal task is concurrently aborted?

If a SATA internal task (where !t->uldd_task) times out, the libsas EH
handler can set SAS_TASK_STATE_ABORTED under the task_state_lock, complete
the task, and free it.

If the device concurrently completes the task with an error,
mpi_sata_completion() checks !t->uldd_task and returns early after calling
pm8001_ccb_task_free_done().

This early return bypasses the task_state_lock synchronization and the check
for SAS_TASK_STATE_ABORTED at the end of the function, which blindly execut=
es
task->task_done(task) on a potentially freed task.

This issue also appears to exist in mpi_sata_completion() in
drivers/scsi/pm8001/pm8001_hwi.c.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D44
