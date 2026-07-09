Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B6B3DBD47
	for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2026 07:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783582468; cv=none; b=dyWD70qeqkD0U7x77XseKLQoKQ+WB62Qpi0BebJbdvUu9oE9EjEgoBTC/yKBbklh10e7u3XLukftStetw+Cz7Pgnq56hw7QESjU68JWg7dtd10khWzzppHoJ3M5ybd7rmo2Yp6aP7pAIKpr4GphxdqaHr5el7u5lTAskJhEMuNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783582468; c=relaxed/simple;
	bh=rwgFyLQh5+WchmsRWwXQ6aS+UN/7tpUwbS+w2PhGIwA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HmEg2h1ua2zjXjyquxFNOb1U/QJe8GbPKg8XfQD3XmQcTZC6u1W7e2I8puA11Y69bqU/D3+QsC9jUT4fanh+F08eVnn9aAG0zgKXObbbUOO1E6x+6KuSMiWAWxP3+nDZiGXyBRgUWmX1Ju5etA+7C7l2/dukirQ1oKH6kCgkH7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1RRQK1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1RRQK1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7021F000E9;
	Thu,  9 Jul 2026 07:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783582466;
	bh=v81P6njW7SZRZHup0gMswUG8C98oe4TxJbKdgVVs6mw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q1RRQK1mE6yD0cPyQZ+vTUXEofhhN8KB8ii+ghsMqgqpxw7LMaDJ8tXuIDt1ryM2q
	 QD68cdyMsfSiZI247SROaR8NzKF6H+svbuc9E/CSFNMjxhlh7vMXRtpgQxDRGmSVm/
	 +qJr0xmCRcg6rVq26lNyXr2UMwOZ4zMS+mztNDxbT/6DPHp6Amu3u/Gq17TFtE0Z4f
	 Igrl+Oh9GtbBySm8LiQpAoS/MwEtwnguRvQuwaYYGGeHBD2SLm5OELAdN/HxA8eb8I
	 6o5w+UPrvgXUa+dmsqF57rcjZ5WFWZnyG/Q/t8lBwAc4azjgEPBoeCuOIsSaqJtO4U
	 vdPUM6ezUh1RA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] target/stat: implement scsiPortBusyStatuses counter
Reply-To: sashiko-reviews@lists.linux.dev
To: kensanya@163.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260709071805.769860-1-kensanya@163.com>
References: <20260709071805.769860-1-kensanya@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 07:34:25 +0000
Message-Id: <20260709073426.5E7021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] NULL pointer dereference in `ib_srpt.c` error path when handli=
ng a malformed SRP command.
--

--- Patch [1]: [PATCH v2] target/stat: implement scsiPortBusyStatuses count=
er ---
commit 7d5200afbb36f3291f84cfd7445e77cbcd9a96de
Author: TanZheng <tanzheng@kylinos.cn>

target/stat: implement scsiPortBusyStatuses counter

Implement RFC 4455 scsiPortBusyStatuses (ConfigFS busy_count) by adding a
per-CPU busy_statuses counter to scsi_port_stats, incrementing it when
the target sends SAM_STAT_BUSY, and summing all CPUs in the show handler.

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index fad03a15c969e..bab5ee81817b5 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
[ ... ]
> @@ -829,6 +829,20 @@ void transport_copy_sense_to_cmd(struct se_cmd *cmd,=
 unsigned char *sense)
>  }
>  EXPORT_SYMBOL(transport_copy_sense_to_cmd);
> =20
> +static int target_queue_status(struct se_cmd *cmd)
> +{
> +	int ret;
> +	struct se_lun *lun =3D cmd->se_lun;
> +	u8 scsi_status =3D cmd->scsi_status;
> +	u32 flags =3D cmd->se_cmd_flags;
> +
> +	ret =3D cmd->se_tfo->queue_status(cmd);

[Severity: Critical]
This is a pre-existing issue, but does this lead to a null pointer derefere=
nce
when handling a malformed SRP command in ib_srpt.c?

If an initiator sends an SRP command with a malformed descriptor table,
srpt_get_desc_tbl() fails, causing srpt_handle_cmd() to jump to the busy
label before target_init_cmd() has initialized cmd->se_tfo:

drivers/infiniband/ulp/srpt/ib_srpt.c:srpt_handle_cmd() {
	...
	rc =3D srpt_get_desc_tbl(...);
	if (rc) {
		...
		goto busy;
	}
	...
busy:
	target_send_busy(cmd);
}

This calls target_send_busy(), which calls target_queue_status() here,
unconditionally dereferencing cmd->se_tfo->queue_status(cmd) while
cmd->se_tfo is still zero-initialized.

Could a remote initiator trigger a denial of service by sending a malicious=
ly
crafted packet?

> +	if (!ret)
> +		target_stat_count_sent_status(lun, scsi_status, flags);
> +
> +	return ret;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709071805.7698=
60-1-kensanya@163.com?part=3D1
