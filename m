Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5114A341AC7
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 09:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783504644; cv=none; b=CuaH0Tr4gFfm1awL4nKXO1T1vjQ/JTc3+n5yGVUoECFIvDG33mfYnwLPKCboVXabdh66kTBCc53CU/uSTkOU0Tk5HHqDV0/N8nnHX40MSZrDUnQbiV6wU0V9t+Uc/3OtwTSpr73yb2C9Nnn004PL7hphO3KJfB2FLgN6NrQ35WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783504644; c=relaxed/simple;
	bh=Acd4egOzlfOfvjjM2Rz5G0rH2QJ7IdZtU5SzY9v49fM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lBATXL/5vJh1j7zF8Hk6ospco+mNZKoLf7/rOZ3wQlXeq1WE2CJmVHvUnTQOosClc7+WreTv1GCpbmSNxKSHJE2rXI9FOfNM0CyYv6oGd/OcxLyYLp+YzuI4lUBR/2FqSW7nq2bUKmt96BmuOm0FAWh/gMQy5yhZlc76maN/UtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fkLvvy/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fkLvvy/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E8C1F000E9;
	Wed,  8 Jul 2026 09:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783504642;
	bh=PJ5Drnuy/eGOFlefUtZZvv8us45DA7PipiTiiqk8QRw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fkLvvy/ZJTMtQQB0qmeg4HvUsKiz4CtrDrUrt4uCd73+tTja7YCZ7nVqJu5kt3UnA
	 3bnbDUKwA+y8iiLTAiG3zs7KJ4M9//jhoPN8PMm6URLsg07wLTzKxWjzs4RLnRdbou
	 gYDHwzJeKHficlLXRBMH33jw0R3btGBZzEKcVwXDIE0EDEWq9akSDDL280IX3dhg2v
	 0XLFofQQFMqJIQhlIpJaXuNIegVWJqvR3Sx/kq0Hf0ZyIKEkh4f3b34AjlTkRg7kIj
	 BX0JcdTF4AUV56irQ6ij+eJ1bcDgT9sORGKTUi4mQ2br8VdaOPPzGOmHrSUAMXlhDW
	 4yFvVzLDZqgaA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] target/stat: implement scsiPortBusyStatuses counter
Reply-To: sashiko-reviews@lists.linux.dev
To: kensanya@163.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260708093433.838647-1-kensanya@163.com>
References: <20260708093433.838647-1-kensanya@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 09:57:22 +0000
Message-Id: <20260708095722.A8E8C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Accessing `cmd` after calling `queue_status()` can cause a Use-Aft=
er-Free, as the command may be completed and freed asynchronously by the fa=
bric driver.
- [Medium] The `scsiPortBusyStatuses` implementation only tracks `SAM_STAT_=
BUSY`, violating RFC 4455.
--

--- Patch [1]: [PATCH] target/stat: implement scsiPortBusyStatuses counter =
---
commit 0e48192c7d342b22881ecb0dee446ae287e24607
Author: TanZheng <tanzheng@kylinos.cn>

target/stat: implement scsiPortBusyStatuses counter
   =20
Implement RFC 4455 scsiPortBusyStatuses (ConfigFS busy_count) by adding a
per-CPU busy_statuses counter to scsi_port_stats, incrementing it when
the target sends SAM_STAT_BUSY, and summing all CPUs in the show handler.

> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_co=
re_stat.c
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
[ ... ]
> +void target_stat_count_busy_status(struct se_cmd *cmd)
> +{
> +	struct se_lun *lun =3D cmd->se_lun;
> +
> +	if (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
> +		return;
> +
> +	if (cmd->scsi_status =3D=3D SAM_STAT_BUSY && lun && lun->lun_stats)
> +		this_cpu_inc(lun->lun_stats->busy_statuses);

[Severity: Medium]
Does this code fully implement the RFC 4455 scsiPortBusyStatuses counter?

RFC 4455 states that scsiPortBusyStatuses must increment for BUSY, TASK SET
FULL, and ACA ACTIVE statuses. By checking only for SAM_STAT_BUSY, does this
undercount port busy statuses during queue full events (like
SAM_STAT_TASK_SET_FULL)?

> +}
[ ... ]
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
[ ... ]
> +static int target_queue_status(struct se_cmd *cmd)
> +{
> +	int ret;
> +
> +	ret =3D cmd->se_tfo->queue_status(cmd);
> +	if (!ret)
> +		target_stat_count_busy_status(cmd);

[Severity: High]
Can this result in a use-after-free on the cmd pointer?

If a fabric driver (such as ib_srpt) calls target_send_busy(cmd) during a
failure path, target_queue_status() will invoke the fabric driver's
queue_status() callback. The fabric driver might transmit the response and =
its
asynchronous completion handler could drop the final reference to the comma=
nd,
freeing its memory.

When queue_status() returns, target_queue_status() calls
target_stat_count_busy_status(cmd) which accesses cmd->se_lun and
cmd->scsi_status. Is it safe to dereference cmd here after relinquishing
ownership to queue_status()?

> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708093433.8386=
47-1-kensanya@163.com?part=3D1
