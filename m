Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE591A6803;
	Wed, 14 Oct 2026 01:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791941397; cv=none; b=EODV98N+zM0+sbB0cHoEvRrO+ScQeg2djVbrK8Dh0UNsSWP9O0SxqGItQDxyoH7iVn5ZHqR0w5WfgLAXNTeW53ih1eXzaC3OvdMlVkdGWYbECrlvf4bED5gJsts9QZ9g2prS3lKtoQL1meJSR7dJEsiVJGPPfKd0jwpzRKLYWkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791941397; c=relaxed/simple;
	bh=nKDZsb00T41vrnQ37xMpkz5/L/ymrBu5eYRZo7y5Ywk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=auB6593LVFNErhnQq0m6NcZKXsUCPEV76iZr6/OLaXrfbOl8VyX8n1HVg3PVyIjh/eW4m9IF+MkLY01C/3toFjV6yC2I/nlSPxpZwV/nxkHBoC1G6kcLSMxCR1iQerngnR0mZsh6yWJOmH43oM8JBvjw1pWP60Bl24K72xze+8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLfWfnYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLfWfnYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC791F000FF;
	Wed, 14 Oct 2026 01:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791941396;
	bh=XsY/df09aXuJLfefS4cQxqKKGejVpAcH+IpJKKYcJXA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JLfWfnYahJy4o7xf/DNdcytHHABB703zuw9/rTAEqI0nyFYuysLlkrHx51z2rFbZd
	 f0h+OJ8OOK9VsOXqF0V7mdqbLHT9ONRAXBjXW46vBfJypwbeZAjA+XxWSEpilLAeLI
	 7a17p4L0m1KLefxKEZU3KQVYyPlZyTuGkYrxC6IUxvhTr+qH2+wRXjluzsT1EGlvNn
	 2RLUE2oktgZiF9BTgsh4LdZihGvtZRNe3qLpQ9H+eQnanZs83X18BeuEao41qtZkBL
	 Kd8jjIMvsdpfU78HNfQxshzTK5JCXILXfMDMTgPeVUhvZfmR6NdDXQY6VfgGjQi2qb
	 RqN2fUmptTU+A==
Message-ID: <sashiko-outbox-170672@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: tcm_loop: fix tl_nexus use-after-free on
 concurrent nexus drop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Zhang" <yuz08559@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261014011739.45941-1-yuz08559@gmail.com>
References: <20261014011739.45941-1-yuz08559@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 01:29:55 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] tcm_loop: UAF in I/O path due to port link and nexus drop TOCTOU r=
ace
--

commit f5acf49b795a91429ba7f28b4f3ce2e9fca1884a
Author: Yu Zhang <yuz08559@gmail.com>

    scsi: target: tcm_loop: fix tl_nexus use-after-free on concurrent nexus=
 drop
   =20
    tcm_loop keeps the per-TPG I_T nexus in tl_tpg->tl_nexus with no lock,
    refcount or RCU protection.  The configfs control path that creates and
    destroys it is not serialized: configfs runs concurrent ->store() calls
    in parallel (configfs_write_iter() only holds a per-open-file
    buffer->mutex, and flush_write_buffer() takes frag_sem for read), so two
    writers to the nexus attribute, or a writer racing the transport_status
    or nexus show attribute, all touch tl_nexus concurrently.

[ ... ]

    The I/O submission path (tcm_loop_target_queue_cmd(), tcm_loop_issue_tm=
r())
    reads tl_nexus without the mutex and is left unchanged: it can run in
    atomic context, and it is already serialized against drop by
    tl_tpg_port_count plus SCSI-midlayer draining (a live scsi_device keeps
    tl_tpg_port_count > 0, which makes tcm_loop_drop_nexus() return -EPERM).
   =20
    Cc: stable@vger.kernel.org
    Signed-off-by: Yu Zhang <yuz08559@gmail.com>
    Tested-by: Yu Zhang <yuz08559@gmail.com>

> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback=
/tcm_loop.c
> index d29830b951f75..980e9e65b788c 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c

[ ... ]

> @@ -701,17 +708,23 @@ static int tcm_loop_drop_nexus(
>  	struct se_session *se_sess;
>  	struct tcm_loop_nexus *tl_nexus;
> =20
> +	mutex_lock(&tpg->tl_nexus_mutex);
>  	tl_nexus =3D tpg->tl_nexus;
> -	if (!tl_nexus)
> +	if (!tl_nexus) {
> +		mutex_unlock(&tpg->tl_nexus_mutex);
>  		return -ENODEV;
> +	}
> =20
>  	se_sess =3D tl_nexus->se_sess;
> -	if (!se_sess)
> +	if (!se_sess) {
> +		mutex_unlock(&tpg->tl_nexus_mutex);
>  		return -ENODEV;
> +	}
> =20
>  	if (atomic_read(&tpg->tl_tpg_port_count)) {
>  		pr_err("Unable to remove TCM_Loop I_T Nexus with active TPG port count=
: %d\n",
>  		       atomic_read(&tpg->tl_tpg_port_count));
> +		mutex_unlock(&tpg->tl_nexus_mutex);
>  		return -EPERM;
>  	}
> =20

[Severity: High]
Does this port count check prevent a concurrent port link from immediately
incrementing the count and issuing I/O before the nexus is freed?

While this check is under tl_nexus_mutex, tcm_loop_port_link() increments
the port count and calls scsi_add_device() without holding tl_nexus_mutex:

drivers/target/loopback/tcm_loop.c:tcm_loop_port_link() {
    ...
    atomic_inc_mb(&tl_tpg->tl_tpg_port_count);
    /*
     * Add Linux/SCSI struct scsi_device by HCTL
     */
    scsi_add_device(tl_hba->sh, 0, tl_tpg->tl_tpgt, lun->unpacked_lun);
    ...
}

If tcm_loop_drop_nexus() sees a count of 0 and proceeds to clear and free
tl_nexus, could a concurrent configfs symlink creation (tcm_loop_port_link)
transition the count to 1 and queue INQUIRY commands via scsi_add_device()?

Since scsi_add_device() synchronously queues commands via
tcm_loop_target_queue_cmd(), which locklessly reads tl_tpg->tl_nexus, could
the I/O path dereference the newly freed tl_nexus->se_sess if it races with
tcm_loop_drop_nexus() clearing and freeing it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014011739.4594=
1-1-yuz08559@gmail.com?part=3D1
