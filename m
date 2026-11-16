Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789432;
	b=SrCoZzIR6/F+2iOscVQQPJrYKEyC24j0+BzJu05LaugZ/NxZHlN37q3edV6ohsieMIAK
	 0PVGluv8qRUoa1baGVTLz1L1QzMtumsf2nu57GuTqUPmCQXzhRQ12Zo/1NLWs5ROlCKCk
	 D4CaDk15o1+dwZU6eRV92g3CwystPBjQ1yH7Sht7mymAD+VH4ex/fEKntzmyOGbdakBJq
	 1jlwIVreLg2Ex4Muaf3IIg2hEmqGEvVNISyXcoyPmgobJeWWaqXZR5XpgVdbdYHWmBoea
	 Rax/nI6f9JjhXOBj2llPj/vj4EMzy35VCV2aetUBvs0HhYFAZ3P4gSgjE8yrKAC3OnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789432;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WzftDjFEbXzGjqMcJzOA+hPwGmCJY9a5reN+8RoKs5w=;
	b=VHM1doU6wTR7kQCoQIQLeogeAUneBK/o0vwFsMBBiybbJwQ9rO4w+PVt0Fo98XlweRJ5
	 G9pp4ijbxQDaeNkaHMWdYqyDALwo2xUTPjMGUOVTWNk62eBDJv8DkgWADf9WE18rlN/R5
	 +vo+thY/Iqr5Dv2DBCacApExgYOO0v+5qGnyHVewCkvjW2WBa8uu3tBSUbSywFcA30rnZ
	 cezfvCBl5NtDA1Xd4ptUi5UtsfiX0uT79UVCSxz+fkpt+XuQUTmnNFj22fStXsJHn5Hpd
	 JpO9ioEmwyyqtT1gf4HiN9r4NMRZ3dKuGfWmAqmLPjcD3rkzB3m+lNozepqTs6eJw8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=omwrXO8+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2825606A31F;
	Mon, 16 Nov 2026 00:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=omwrXO8+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA9D1F000C4;
	Mon, 16 Nov 2026 00:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794789431;
	bh=WzftDjFEbXzGjqMcJzOA+hPwGmCJY9a5reN+8RoKs5w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=omwrXO8+Lc8WzjU6EOgBZu0g2NckWhKssQlENBBB17uWGGqhQnRU3BZRLo4Vv+0uJ
	 dTMPsiXJ60H5/jJ2a3Mnj2pN2OFvB+4ITqdNkvOhFnKYkIH7S/2auTP82h5+TSSEs6
	 XfUY6LyIhLgwa/U7zA/VBXQLiBshtJ+aRUafO6YYUd8jEjxg2NF96ICHNjGd3y4HZ+
	 IEFmjBaQjgaJroTUAsJgiYy4w7pl49a9LPcqj6Ju4rkO0e3hqQWFBMrVYwCwvTQiOX
	 o1Dwc4T7uoRSXVtFMsBKBYNx9KUxJSJPkehA092e/e+yQi24sl5p+t1mqnzYqoE9DL
	 GeZFq/bsFlcHg==
Message-ID: <sashiko-outbox-215958@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 11/18] scsi: target: uring: Drop aborted commands
 that are still queued
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-11-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-11-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:37:11 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] scsi: target: uring: missing CMD_T_ABORTED check in
  tcmur_queue_cmd()
--

commit 84783430b27d7a40ed74a32ae69a8126b2da14ae
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: uring: Drop aborted commands that are still queued

This commit implements tmr_notify() for target_core_uring so that aborted
commands still waiting on a queue's pending list are removed and completed
immediately with SAM_STAT_TASK_ABORTED instead of waiting to time out.

> diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_c=
ore_uring.c
> index 0f83bdc55e06a..629419a4c8f46 100644
> --- a/drivers/target/target_core_uring.c
> +++ b/drivers/target/target_core_uring.c
[ ... ]
> @@ -207,6 +208,7 @@ static void tcmur_queue_cmd(struct tcmur_dev *udev, s=
truct tcmur_cmd *tcmd)
>  		io->ucmd =3D NULL;
>  		tcmur_io_start(q, io, tcmd);
>  	} else {
> +		tcmd->se_cmd->priv =3D tcmd;
>  		list_add_tail(&tcmd->node, &q->pending);
>  	}
>  	spin_unlock(&q->lock);
> @@ -255,6 +257,31 @@ static sense_reason_t tcmur_execute_rw(struct se_cmd=
 *se_cmd,
>  			    se_cmd->data_length, sgl, sgl_nents);
>  }
> =20
> +static void tcmur_tmr_notify(struct se_device *dev, enum tcm_tmreq_table=
 tmf,
> +			     struct list_head *aborted_cmds)
> +{
> +	struct tcmur_dev *udev =3D TCMUR_DEV(dev);
> +	struct tcmur_cmd *tcmd;
> +	struct tcmur_queue *q;
> +	struct se_cmd *se_cmd;
> +
> +	/* Drop the aborted commands that no server has picked up yet */
> +	list_for_each_entry(se_cmd, aborted_cmds, state_list) {
> +		q =3D tcmur_cmd_queue(udev, se_cmd);
> +
> +		spin_lock(&q->lock);
> +		tcmd =3D se_cmd->priv;
> +		if (tcmd) {
> +			se_cmd->priv =3D NULL;
> +			list_del(&tcmd->node);
> +		}
> +		spin_unlock(&q->lock);
> +
> +		if (tcmd)
> +			tcmur_cmd_end(tcmd, SAM_STAT_TASK_ABORTED);
> +	}
> +}

[Severity: High]
Can tcmur_queue_cmd() queue a command onto q->pending after
tcmur_tmr_notify() has already run for it?

transport_generic_new_cmd() places se_cmd on state_list before the command
reaches tcmur_queue_cmd():

CPU0                                    CPU1
transport_generic_new_cmd()
  target_add_to_state_list(se_cmd)
  target_execute_cmd(se_cmd)
    ...
                                        core_tmr_abort_task()
                                          __target_check_io_state()
                                            se_cmd->transport_state |=3D
                                              CMD_T_ABORTED
                                            list_move_tail(..., &aborted)
                                          tcmur_tmr_notify()
                                            spin_lock(&q->lock)
                                            tcmd =3D se_cmd->priv  <-- NULL
                                            spin_unlock(&q->lock)
      tcmur_queue_cmd()
        spin_lock(&q->lock)
        tcmd->se_cmd->priv =3D tcmd
        list_add_tail(&tcmd->node,
                      &q->pending)      <-- queued after tmr_notify()
        spin_unlock(&q->lock)
                                          target_put_cmd_and_wait()

The same ordering also happens without a narrow race when a command on
dev->delayed_cmd_list is aborted while se_cmd->priv is still NULL and is
later dispatched by target_do_delayed_work() -> __target_execute_cmd().

Once tcmd is placed on q->pending after tcmur_tmr_notify() finishes,
se_cmd is no longer on state_list, so nothing removes tcmd if no server
fetches it.  target_put_cmd_and_wait() then blocks for up to cmd_timeout
seconds, or hangs indefinitely when cmd_time_out is 0.

Should tcmur_queue_cmd() check se_cmd->transport_state & CMD_T_ABORTED
under q->lock before starting or queueing tcmd, similar to
tcmu_queue_cmd() in target_core_user.c?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D11
